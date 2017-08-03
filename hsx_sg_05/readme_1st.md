.LOG


#      HSX Programme installieren   
### erstellt : 2016-05-12, zuletzt geaendert : Datum am Dateiende
	
In diesem Verzeichnis sollten sich die folgenden Dateien befinden :

1. readme_1st.md - diese Datei  
1. adapter-owfs.json - owfs Einstellungen, incl. 1 Wire Adressen  
1. adapter-owfs_pretty.json  
1. dashui-views.json         - e1 Gluehbirnen-Maske  
1. dashui-views_pretty.json  
1. owfs.js - korrigierter .js owfs Treiber  (Version : 0.3.6 [07.06.2016])
1. xx.prg                     - Steuerungsprogramme  
1. e_nn.htm                    - Steuerungs - Masken
1. Konfig.txt

Die .json Dateien mit "pretty" im Namen enthalten den gleichen Inhalt wie die 
Dateien ohne "pretty". Sie sind halt nur lesbar formatiert. 
Der Versuch, ob CCU.IO auch nett formatierte Dateien schluckt, steht aus.

*Beschreibung :*  
   https://sites.google.com/site/raspihs1/hsx-interna/hsx_software/hsx_sg_0_5

Sehr hilfreich bei den Kopier-Operationen zum Raspi ist WinSCP. 
Siehe dazu die Bemerkungen unter :

   https://sites.google.com/site/raspihs1/home/raspi-aufsetzen

	  
ScriptGUI Programme
-------------------
Die Programme 

       taster.prg  
       zaehler.prg  
	   heizen.prg  
	   regeln.prg  
	   mittel.prg  
       
in den Ordner /opt/ccu.io/www/ScriptGUI/prg_Store kopieren 
und dann mit ScriptGUI in obiger Reihenfolge compilieren.


DashUI Masken
-------------

Die Datei /opt/ccu.io/datastore/dashui-views.json ersetzen. Da sind 
neben der Demo zwei Webseiten enthalten, e1 und e2.

Aufruf mit :

    http://hsx01:8080/dashui/#e1
    http://hsx01:8080/dashui/#e2

Die Gluehbirne von e1 muss mit WWAnfo verbunden sein. 
Bitte kontrollieren und bei Bedarf korrigieren.
 
	
SlimUI Maske
------------
Die Masken e*.htm in das Verzeichnis /opt/ccu.io/www/slimui kopieren.

Aufruf mit : http://hsx01:8080/slimui/e2.htm

SlimUI Masken sind sehr schlank. Der Aufruf klappt mobil auch mit der 
Verbindung "E" (Weniger als "3G") ohne Probleme.
Spielmaterial : ex.htm	.
	

Aktuelle owfs Adapter Einstellungen
-----------------------------------

Den Adapter-Setup "adapter-owfs.json" in das Verzeichnis 

   /opt/ccu.io/datastore/ 

kopieren und dann mit CCU.IO unter dem Tab "Adapter" editieren (oder 
mit einem JSON Editor, z.B. die Chrome Erweiterung JSON). Die Adressen
der 1-Wire Adapter muessen dort eingetragen werden. Man erhaelt die
Adressen z.B. durch einen Aufruf :

   http://hsx01:2121 

Achtung : Der .json Editor in CCU.IO ist strikt und mag keine zusaetzlichen 
Leerzeichen und so etwas.

Die Adapter Einstellung muss gemaess "Konfig.txt" angepasst werden ! 
   
   
Aktueller owfs Adapter
----------------------

Bei einer CCU.IO Version 1.0.52 oder aelter sollte man den owfs Adapter austauschen. 
Dazu die Datei

       owfs.js
	   
in das Verzeichnis

      /opt/ccu.io/adapter/owfs/

kopieren und damit die dort vorhandene Datei ueberschreiben.


Viel Glueck !

mailto:Ekkehard@Pofahl.de 

**Rueckmeldungen und Korrekturen sehr willkommen !**

Infos zu Markdown : https://de.wikipedia.org/wiki/Markdown

Editiert am :

22:36 12.05.2016

15:21 16.12.2016

16:36 02.08.2017
