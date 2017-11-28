/**
 *   CCU.IO OWFS Adapter :  /opt/ccu.io/adapter/owfs/owfs.js
 *
 *   Version Change Notes:
 *   - 0.4.1 2017-08-17 (Giermann) skipping all temperature readings of exactly 85
 *   - 0.4.0 2017-08-16 (Ekkehard) Kommentare bereinigt
 *   - 0.3.6    (Giermann) added log level config and number types
 *   - 0.3.5    (Giermann) Simultaneous reading for temperature
 *   - 0.3.4    (Giermann) Continuous reading (interval<0) and new configs: unit, dir [r|w|rw] (direction: read/write only)
 *   - 0.3.3    (Giermann) Fix write support, avoid write after each read
 *   - 0.3.2    (Giermann) Shorter channel name and identify/skip read errors
 *   - 0.3.1    (Bluefox) Possible write and use new adapter module
 *   - 0.3.0    (Bluefox) Support of multiple IPs and up to 50 sensors per server
 *   - 0.2.1 2014-03-05 (Muenk) Initial
 *
 *   Authors: 
 *   Ralf Muenk      - muenk@getcom.de , (c) getcom IT Services : Initial 
 *   Eisbaeeer       - Eisbaeeer@gmail.com]
 *   Bluefox         - dogafox@gmail.com
 *   Sven Giermann   - sven.giermann@gmail.com
 *   Ekkehard Pofahl - ekkehard@pofahl.de
 *     
 *
 *   This is a part of the iXmaster project started in 2014.
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.*   Licence: GNU General Public License.
 *   For more information visit http://www.gnu.org.
 *
**/
var adapter    = require(__dirname + '/../../utils/adapter-init.js').Adapter("owfs");
var owfsClient = require('owfs').Client;

// Fix old settings
if (adapter.settings.wire && adapter.settings.IPs._1) {
    adapter.settings.IPs._1.wire = adapter.settings.wire;
}

adapter.onEvent = function (id, val, ts, ack){
    if (ack)
        return;

    // process event here
    if (id >= adapter.firstId && id <= adapter.firstId + 1000) {
        // First find which IP
        var ipID   = Math.floor((id - adapter.firstId - 1) / 50) + 1;
        var wireID = id - ((ipID - 1) * 50 + adapter.firstId + 1);

        if (adapter.settings.IPs["_" + ipID] && adapter.settings.IPs["_" + ipID].wire["_" + wireID]){
            // Control some wire
            writeWire(ipID, wireID, val);
        }
    }
}

var id          = 1;
var rootId      = adapter.firstId;
var channelsIDs = [];

function writeWire(ipID, wireID, value, retries) {
    if (adapter.settings && adapter.settings.IPs["_" + ipID].wire["_" + wireID] && adapter.settings.IPs["_" + ipID].con) {
        var path = "/" + adapter.settings.IPs["_" + ipID].wire["_" + wireID].id + "/" + (adapter.settings.IPs["_" + ipID].wire["_" + wireID].property || "temperature");
        if (adapter.settings.IPs["_" + ipID].wire["_" + wireID].dir != "r") adapter.settings.IPs["_" + ipID].con.write(
            path,
            value,
            function(err,result) {
                if (err) {
                    if (this.retr < 5) {
                        setTimeout(writeWire, (adapter.settings.owserverTimeout || 3000), this.ip, this.wire, this.val, this.retr);
                    } else {
                        adapter.log(adapter.settings.IPs["_" + this.ip].errorLevelWrite || adapter.settings.errorLevelWrite,
                            "error writing '" + this.p + "': " + err.msg);
                    }
                }
            }.bind( {p: path, ip: ipID, wire: wireID, val: value, retr: ((retries || 0) + 1)} )
        );
    }
}

function readWire(ipID, wireID, loop) {
    if (adapter.settings && adapter.settings.IPs["_" + ipID].wire["_" + wireID] && adapter.settings.IPs["_" + ipID].con) {
        var path = "/" + adapter.settings.IPs["_" + ipID].wire["_" + wireID].id + "/" + (adapter.settings.IPs["_" + ipID].wire["_" + wireID].property || "temperature");
        if (adapter.settings.IPs["_" + ipID].wire["_" + wireID].dir != "w") adapter.settings.IPs["_" + ipID].con.read(path,
            function(err,result) {
                if (err) {
                    adapter.log(adapter.settings.IPs["_" + this.ip].errorLevelRead || adapter.settings.errorLevelRead,
                        "error reading '" + this.p + "': " + err.msg);
                } else if (result) {
                    if (adapter.settings.IPs["_" + this.ip].wire["_" + this.wire].number || adapter.settings.IPs["_" + this.ip].wire["_" + this.wire].maxChange) {
                        if (isNaN(parseFloat(result))) {
                            adapter.log(adapter.settings.IPs["_" + this.ip].errorLevelNumber || adapter.settings.errorLevelNumber,
                                "skip invalid value for id " + id + ": " + result);
                        } else if ((parseFloat(result) == 85) && ((adapter.settings.IPs["_" + ipID].wire["_" + wireID].property || "temperature") == "temperature")) {
                            adapter.log(adapter.settings.IPs["_" + this.ip].errorLevelNumber || adapter.settings.errorLevelNumber,
                                "skip 85 degree for id " + id + ": " + result);
                        } else if (adapter.settings.IPs["_" + this.ip].wire["_" + this.wire].maxChange) {
                            // async check for delta and return without setting DP
                            adapter.getState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, function (id, val) {
                                if (val < (this.newVal - this.maxChange)) {
                                    adapter.log(this.logLevel, "trimmed value for id " + id + ": " + this.newVal + " to maxChange");
                                    adapter.setState(id, val + this.maxChange, true);
                                } else if (val > (this.newVal + this.maxChange)) {
                                    adapter.log(this.logLevel, "trimmed value for id " + id + ": " + this.newVal + " to maxChange");
                                    adapter.setState(id, val - this.maxChange, true);
                                } else if (val != this.newVal) {
                                    adapter.setState(id, this.newVal, true);
                                }
                            }.bind( {
                                newVal: parseFloat(result),
                                maxChange: parseFloat(adapter.settings.IPs["_" + this.ip].wire["_" + this.wire].maxChange),
                                logLevel: (adapter.settings.IPs["_" + this.ip].errorLevelNumber || adapter.settings.errorLevelNumber)
                            } ));
                        } else {
                            adapter.setState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, parseFloat(result), true);
                        }
                    } else {
                        if (this.doLoop) {
                            // loop mode: do not call setState on unchanged values
                            adapter.getState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, function (id, val) {
                                if (val != this.newVal) adapter.setState(id, this.newVal, true);
                            }.bind( {newVal: result} ));
                        } else {
                            // set ack=true to avoid writing the same value back again
                            adapter.setState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, result, true);
                        }
                    }
                }
                // prefer setTimeout for next read (wait in case of error)
                if (this.doLoop) setTimeout(readWire, (err ? (adapter.settings.owserverTimeout || 3000) : 100), this.ip, this.wire, true);
            }.bind( {p: path, ip: ipID, wire: wireID, doLoop: loop } )
        );
    }
}

function owfsServerGetValues(ipID, loop) {
    if (adapter.settings.IPs["_" + ipID]) {
        // request simultaneous temperature reading for faster results
        adapter.settings.IPs["_" + ipID].con.write(
            "/simultaneous/temperature",
            1,
            function(err,result) {
                if (err) {
                    adapter.log(adapter.settings.IPs["_" + ipID].errorLevelRead || adapter.settings.errorLevelRead,
                        "error requesting simultaneous reading: " + err.msg);
                }
            }
        );
        var id = 1;
        while (adapter.settings.IPs["_" + ipID].wire["_" + id]) {
            readWire(ipID, id, loop);
            id++;
        }
    }
}

function createPointsForServer(ipID) {
    // Create Datapoints in CCU.IO
    var id = 1;
    var channelId = rootId + (ipID - 1) * 50 + 1;
    adapter.settings.IPs["_" + ipID].channelId = channelId;
    adapter.settings.IPs["_" + ipID].sensorDPs = {};
    if (typeof owfsClient != "undefined") {
        adapter.settings.IPs["_" + ipID].con   = new owfsClient(adapter.settings.IPs["_" + ipID].ip, adapter.settings.IPs["_" + ipID].port);
    }

    while (adapter.settings.IPs["_" + ipID].wire && adapter.settings.IPs["_" + ipID].wire.hasOwnProperty("_" + id)) {
        adapter.settings.IPs["_" + ipID].sensorDPs["Sensor" + id] = channelId + id;

        adapter.createDP(
            channelId + id,
            channelId,
            "OWFS." + adapter.settings.IPs["_" + ipID].alias + "." + adapter.settings.IPs["_" + ipID].wire["_" + id].alias,
            true,
            {
                "Operations": (adapter.settings.IPs["_" + ipID].wire["_" + id].dir == "r" ? 5 :
                              (adapter.settings.IPs["_" + ipID].wire["_" + id].dir == "w" ? 6 : 7)),
                "ValueType":  4,
                "ValueUnit":  adapter.settings.IPs["_" + ipID].wire["_" + id].unit ||
                              ((adapter.settings.IPs["_" + ipID].wire["_" + id].property || "temperature") == "temperature" ? "°C" : "")
            }
        );
        id++;
    };

    adapter.createChannel(
        channelId,
        rootId,
        "OWFS." + adapter.settings.IPs["_" + ipID].alias,
        adapter.settings.IPs["_" + ipID].sensorDPs,
        {HssType:     "1WIRE-SENSORS"}
    );

    if ((adapter.settings.IPs["_" + ipID].interval || adapter.settings.owserverInterval) < 0) {
    	// continuous polling
    	owfsServerGetValues(ipID, true);
    } else {
        // Request first time
        owfsServerGetValues(ipID);

    	// Interval to read values from owfs-server
        setInterval(owfsServerGetValues, adapter.settings.IPs["_" + ipID].interval || adapter.settings.owserverInterval || 30000, ipID);
    }
    channelsIDs.push(channelId);
}

function initOWFS (){
    var id = 1;
    while (adapter.settings.IPs["_" + id]) {
        createPointsForServer(id);
        id++;
    }
    adapter.createDevice(rootId, "OWFS", channelsIDs, {HssType: "1WIRE"});
    adapter.log("info", "created datapoints. Starting at: " + rootId);
}

initOWFS();