/**
 *   CCU.IO OWFS Adapter - owfs.js
 *
 *   Initial Version : 05. Mar 2014
 *   Current Version : 0.3.5 [06.01.2016]
 *   
 *   Change Notes:
 *   - Initial Version 0.2.1 
 *   - Version 0.3.0 (Bluefox) Support of multiple IPs and up to 50 sensors per server
 *   - Version 0.3.1 (Bluefox) Possible write and use new adapter module
 *   - Version 0.3.2 (Giermann) Shorter channel name and identify/skip read errors
 *   - Version 0.3.3 (Giermann) Fix write support, avoid write after each read
 *   - Version 0.3.4 (Giermann) Continuous reading (interval<0) and new configs: unit, dir [r|w|rw] (direction: read/write only)
 *   - Version 0.3.5 (Giermann) Simultaneous reading for temperature
 *
 *   Authors: 
 *   Ralf Muenk [muenk@getcom.de]
 *   (c) getcom IT Services
 *   Eisbaeeer  [Eisbaeeer@gmail.com]
 *   Bluefox (dogafox@gmail.com)
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

function writeWire(ipID, wireID, value) {
    if (adapter.settings && adapter.settings.IPs["_" + ipID].wire["_" + ipID] && adapter.settings.IPs["_" + ipID].con) {
        var path = "/" + adapter.settings.IPs["_" + ipID].wire["_" + wireID].id + "/" + (adapter.settings.IPs["_" + ipID].wire["_" + wireID].property || "temperature");
        if (adapter.settings.IPs["_" + ipID].wire["_" + wireID].dir != "r") adapter.settings.IPs["_" + ipID].con.write(
            path,
            value,
            function(err,result) {
                if (err) {
                    adapter.log("debug", "error writing '" + this.p + "': " + err.msg);
                }
            }.bind( {p: path} )
        );
    }
}

function readWire(ipID, wireID, loop) {
    if (adapter.settings && adapter.settings.IPs["_" + ipID].wire["_" + ipID] && adapter.settings.IPs["_" + ipID].con) {
        var path = "/" + adapter.settings.IPs["_" + ipID].wire["_" + wireID].id + "/" + (adapter.settings.IPs["_" + ipID].wire["_" + wireID].property || "temperature");
        if (adapter.settings.IPs["_" + ipID].wire["_" + wireID].dir != "w") adapter.settings.IPs["_" + ipID].con.read(path,
            function(err,result) {
                if (err) {
                    adapter.log("debug", "error reading '" + this.p + "': " + err.msg);
                } else if (result) {
                    if (parseFloat(result) == 85) {
                        // TODO: do we have to check if number values are expected?
                        // async check for possible error and return without setting DP
                        adapter.getState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, function (id, val) {
                            if (!val || (Math.abs(val - parseFloat(this.newVal)) < 3)) {
                                if (val != this.newVal) adapter.setState(id, this.newVal, true);
                            } else {
                                adapter.log("debug", "skip invalid value for id " + id + ": " + this.newVal);
                            }
                        }.bind( {newVal: result} ));
                    } else if (!isNaN(parseFloat(result))) {
                        if (this.doLoop) {
                            // only set changes in loop mode
                            adapter.getState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, function (id, val) {
                                if (val != this.newVal) adapter.setState(id, this.newVal, true);
                            }.bind( {newVal: result} ));
                        } else {
                            // set ack=true to avoid writing the same value back again
                            adapter.setState(adapter.settings.IPs["_" + this.ip].channelId + this.wire, result, true);
                        }
                    }
                }
                // prefer setTimeout for next read (wait 10s in case of error)
                if (this.doLoop) setTimeout(readWire, (err ? 10000 : 0), this.ip, this.wire, true);
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
                    adapter.log("debug", "error requesting simultaneous reading: " + err.msg);
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

    if (adapter.settings.IPs["_" + ipID].interval < 0) {
    	// conituous polling
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
