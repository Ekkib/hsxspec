.LOG


#      HSX Programme installieren   
### zuletzt geaendert : Datum am Dateiende
<<<<<<< HEAD

=======
	
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb
In diesem Verzeichnis befinden sich die folgenden Dateien  :

1. readme.md - diese Datei  
1. adapter-owfs.json        - owfs Adaptereinstellungen, incl. 1-Wire Adressen  
1. adapter-owfs_pretty.json - lesbarer JSON
<<<<<<< HEAD
1. dashui-views.json        - e1 Gluehbirnen-Maske (Warmwasser)
=======
1. dashui-views.json        - e1 Gluehbirnen-Maske (Warmwasser) 
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb
1. dashui-views_pretty.json - lesbarer JSON
1. owfs.js                  - aktueller .js owfs Adapter Treiber
1. *.prg                    - Steuerungsprogramme  
1. e*.htm                   - Steuerungs - Masken
1. Konfig.txt               - Info Datei

**Beschreibung :**  
<<<<<<< HEAD

  https://sites.google.com/site/raspihs1/hsx-interna/hsx_software/hsx-sg-0-4

Sehr hilfreich bei den Kopier-Operationen zum Raspi ist **WinSCP**.
=======
  
  https://sites.google.com/site/raspihs1/hsx-interna/hsx_software/hsx-sg-0-4
   
Sehr hilfreich bei den Kopier-Operationen zum Raspi ist **WinSCP**. 
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb
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
<<<<<<< HEAD

=======
	
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb

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

<<<<<<< HEAD
Die Adapter Einstellung muss gemaess "Konfig.txt" angepasst werden !


Aktueller owfs Adaptertreiber
-----------------------------

Bei einer CCU.IO Version 1.0.52 oder aelter sollte man den owfs Adaptertreiber austauschen.
=======
Die Adapter Einstellung muss gemaess "Konfig.txt" angepasst werden ! 
   
   
Aktueller owfs Adaptertreiber
-----------------------------

Bei einer CCU.IO Version 1.0.52 oder aelter sollte man den owfs Adaptertreiber austauschen. 
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb
Dazu die Datei

       owfs.js

in das Verzeichnis

      /opt/ccu.io/adapter/owfs/

kopieren und damit die dort vorhandene Datei ueberschreiben.

**Viel Glueck !**

<<<<<<< HEAD
mailto:Ekkehard@Pofahl.de
=======
mailto:Ekkehard@Pofahl.de 
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb

**Rueckmeldungen und Korrekturen sehr willkommen !**

Infos zu Markdown : https://de.wikipedia.org/wiki/Markdown

Editiert am :

22:36 12.05.2016

15:21 16.12.2016

16:36 15.08.2017
<<<<<<< HEAD

20:55 01.12.2018
=======
>>>>>>> 962a6980e3c86731fceb9acff7ca81f459719cfb
