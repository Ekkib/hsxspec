.LOG

2016-05-12, HSX Programme installieren

In diesem Verzeichnis sollten sich die folgenden Dateien befinden :

12.05.2016  22:36             2.235 readme_1st.txt
11.05.2016  21:08               676 adapter-owfs.json
12.05.2016  22:29             1.121 adapter-owfs_pretty.json
11.05.2016  20:56             8.705 dashui-views.json
12.05.2016  22:16            15.583 dashui-views_pretty.json
10.05.2016  22:16             8.242 owfs.js
07.05.2016  16:44             7.216 Taster.prg
10.05.2016  18:23             7.445 Wanfo.prg
09.05.2016  22:52            11.515 heizen.prg

Die .json Dateien mit "pretty" im Namen enthalten den gleichen Inhalt wie die Dateien ohne "pretty". Sie sind halt nur lesbar formatiert. Der Versuch, ob CCU.IO auch nett formatierte Dateien schluckt, steht aus.

Dies sind alle Dateien, die man braucht, um HSX SG 0.2 ans Laufen zu bekommen.

      https://sites.google.com/site/raspihs1/hsx-interna/hsx_software/hsx_sg_0_2

Sehr hilfreich bei den Kopier-Operationen zum Raspi ist WinSCP. Siehe dazu die Bemerkungen unter :

      https://sites.google.com/site/raspihs1/home/raspi-aufsetzen

	  
ScriptGUI Programme
-------------------
Die drei Programme 

     heizen.prg 
     Taster.prg 
     Wanfo.prg 
  
in den Ordner /opt/ccu.io/www/ScriptGUI/prg_Store kopieren und dann mit ScriptGUI compilieren.


DashUI Masken
-------------

Die Datei /opt/ccu.io/datastore/dashui-views.json ersetzen. Da sind neben der Demo zwei Webseiten enthalten, e1 und e2.

Aufruf mit :

    http://hsx01:8080/dashui/#e1
    http://hsx01:8080/dashui/#e2


Aktuelle owfs Adapter Einstellungen
-----------------------------------

Den Adapter-Setup "adapter-owfs.json" in das Verzeichnis /opt/ccu.io/datastore/ kopieren und dann mit einem JSON Editor (z.B. die Chrome Erweiterung JSON) oder unter CCU.IO unter dem Tab "Adapter" editieren. Die Adressen der 1-Wire Adapter müssen dort eingetragen werden. Man erhält die Adressen z.B. durch einen Aufruf :

   http://hsx01:2121 

Achtung : Der .json Editor in CCU.IO ist strikt und mag keine zusätzlichen Leerzeichen und so etwas.
   
   
Aktueller owfs Adapter
----------------------

Bei einer CCU.IO Version 1.0.52 oder älter sollte man den owfs Adapter austauschen. Dazu die Datei

owfs.js 

in das Verzeichnis

/opt/ccu.io/adapter/owfs/

kopieren und damit die dort vorhandene Datei überschreiben.


Viel Glück !

mailto:Ekkehard@Pofahl.de 

(Rückmeldungen und Korrekturen sehr willkommen !)


Editiert am :



22:36 12.05.2016
