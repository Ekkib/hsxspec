{"mbs":{"ccuobj_0":{"mbs_id":"ccuobj_0","type":"ccuobj","hmid":100000,"name":"Wanfo1","top":684,"left":1512,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"counter":0,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_0"},"codebox_2":{"mbs_id":"codebox_2","type":"codebox","hmid":[],"name":["Rechtsklick"],"top":863,"left":1831,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"width":442,"height":104,"counter":2,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_2"},"codebox_3":{"mbs_id":"codebox_3","type":"codebox","hmid":[],"name":["Rechtsklick"],"top":1004,"left":1830,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"width":448,"height":114,"counter":3,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_3"},"codebox_5":{"mbs_id":"codebox_5","type":"codebox","hmid":[],"name":["Rechtsklick"],"top":716,"left":1839,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"width":431,"height":100,"counter":5,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_5"},"trigger_NE_6":{"mbs_id":"trigger_NE_6","type":"trigger_NE","hmid":["100000"],"name":[["Wanfo1"]],"top":747,"left":1512,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"counter":6,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_6"},"brake_7":{"mbs_id":"brake_7","type":"brake","hmid":[],"name":["Rechtsklick"],"top":855,"left":1719,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":"1800","wert":true,"counter":7,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_7"},"trigger_time_9":{"mbs_id":"trigger_time_9","type":"trigger_time","hmid":[],"name":["Rechtsklick"],"top":1035,"left":1512,"time":["05:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":[],"wert":[],"counter":9,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_9"},"trigger_val_10":{"mbs_id":"trigger_val_10","type":"trigger_val","hmid":["100000"],"name":[["Wanfo1"]],"top":864,"left":1503,"time":["00:00"],"minuten":[0],"astro":["sunrise"],"day":["88"],"val":["val"],"wert":["1"],"counter":10,"kommentar":"Comment","backcolor":"yellow","fontcolor":"black","titel":"Program_10"}},"fbs":{"output_1":{"parent":"prg_codebox_2","fbs_id":"output_1","type":"output","hmid":"72545","name":["Rasp1.PIFACEOUT > OUT0"],"value":0,"input_n":2,"counter":1,"top":18,"left":207,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{"in":"false_11_out"},"output":{}},"input_9":{"parent":"prg_codebox_5","fbs_id":"input_9","type":"input","hmid":"100000","name":["Wanfo1"],"value":0,"input_n":2,"counter":9,"top":27,"left":27,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{},"output":{"out":"output_10_in"}},"output_10":{"parent":"prg_codebox_5","fbs_id":"output_10","type":"output","hmid":"72545","name":["Rasp1.PIFACEOUT > OUT0"],"value":0,"input_n":2,"counter":10,"top":27,"left":198,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{"in":"input_9_out"},"output":{}},"false_11":{"parent":"prg_codebox_2","fbs_id":"false_11","type":"false","hmid":[],"name":"UNGÜLTIGE ID !!!","value":0,"input_n":2,"counter":11,"top":18,"left":18,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{},"output":{"out":"output_1_in"}},"output_12":{"parent":"prg_codebox_2","fbs_id":"output_12","type":"output","hmid":"100000","name":["Wanfo1"],"value":0,"input_n":2,"counter":12,"top":63,"left":207,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{"in":"false_15_out"},"output":{}},"true_13":{"parent":"prg_codebox_3","fbs_id":"true_13","type":"true","hmid":[],"name":"UNGÜLTIGE ID !!!","value":0,"input_n":2,"counter":13,"top":36,"left":36,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{},"output":{"out":"output_14_in"}},"output_14":{"parent":"prg_codebox_3","fbs_id":"output_14","type":"output","hmid":"100000","name":["Wanfo1"],"value":0,"input_n":2,"counter":14,"top":36,"left":216,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{"in":"true_13_out"},"output":{}},"false_15":{"parent":"prg_codebox_2","fbs_id":"false_15","type":"false","hmid":[],"name":"UNGÜLTIGE ID !!!","value":0,"input_n":2,"counter":15,"top":63,"left":18,"delay":0,"scope":"singel","opt":"","opt2":"","opt3":"","exp_in":1,"exp_out":1,"input":{},"output":{"out":"output_12_in"}}},"connections":{"mbs":[{"connectionId":"con_30","pageSourceId":"trigger_NE_6","pageTargetId":"codebox_5","delay":0},{"connectionId":"con_33","pageSourceId":"brake_7_out","pageTargetId":"codebox_2","delay":0},{"connectionId":"con_36","pageSourceId":"trigger_time_9","pageTargetId":"codebox_3","delay":0},{"connectionId":"con_37","pageSourceId":"trigger_val_10","pageTargetId":"brake_7_in1","delay":0}],"fbs":{"codebox_2":{"0":{"connectionId":"con_9","pageSourceId":"false_11_out","pageTargetId":"output_1_in"},"1":{"connectionId":"con_10","pageSourceId":"false_15_out","pageTargetId":"output_12_in"}},"codebox_3":{"0":{"connectionId":"con_5","pageSourceId":"true_13_out","pageTargetId":"output_14_in"}},"codebox_5":{"0":{"connectionId":"con_5","pageSourceId":"input_9_out","pageTargetId":"output_10_in"}}}},"struck":{"trigger":[{"mbs_id":"ccuobj_0","target":[]},{"mbs_id":"trigger_NE_6","target":["codebox_5"]},{"mbs_id":"trigger_time_9","target":["codebox_3"]},{"mbs_id":"trigger_val_10","target":["brake_7_in1"]}],"codebox":{"codebox_2":[[{"ebene":1,"fbs_id":"false_11","type":"false","hmid":[],"positionX":18,"positionY":18,"in":{},"out":{"out":"output_1_in"},"target":[],"input":[],"output":[{"ausgang":"false_11_out"}]},{"ebene":1,"fbs_id":"false_15","type":"false","hmid":[],"positionX":18,"positionY":63,"in":{},"out":{"out":"output_12_in"},"target":[],"input":[],"output":[{"ausgang":"false_15_out"}]},{"ebene":99999,"fbs_id":"output_1","type":"output","hmid":"72545","positionX":207,"positionY":18,"in":{"in":"false_11_out"},"out":{},"target":[],"input":[{"eingang":"in","herkunft":"false_11_out"}],"output":[]},{"ebene":99999,"fbs_id":"output_12","type":"output","hmid":"100000","positionX":207,"positionY":63,"in":{"in":"false_15_out"},"out":{},"target":[],"input":[{"eingang":"in","herkunft":"false_15_out"}],"output":[]}]],"codebox_3":[[{"ebene":1,"fbs_id":"true_13","type":"true","hmid":[],"positionX":36,"positionY":36,"in":{},"out":{"out":"output_14_in"},"target":[],"input":[],"output":[{"ausgang":"true_13_out"}]},{"ebene":99999,"fbs_id":"output_14","type":"output","hmid":"100000","positionX":216,"positionY":36,"in":{"in":"true_13_out"},"out":{},"target":[],"input":[{"eingang":"in","herkunft":"true_13_out"}],"output":[]}]],"codebox_5":[[{"ebene":1,"fbs_id":"input_9","type":"input","hmid":"100000","positionX":27,"positionY":27,"in":{},"out":{"out":"output_10_in"},"target":[],"input":[],"output":[{"ausgang":"input_9_out"}]},{"ebene":99999,"fbs_id":"output_10","type":"output","hmid":"72545","positionX":198,"positionY":27,"in":{"in":"input_9_out"},"out":{},"target":[],"input":[{"eingang":"in","herkunft":"input_9_out"}],"output":[]}]]},"control":[{"mbs_id":"brake_7","target":["codebox_2"]}]}}