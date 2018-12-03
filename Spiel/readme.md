.LOG
<Ctrl-Shift m>

Lokale Aenderung

#      Dateien zum Spielen   
### zuletzt geaendert : Datum am Dateiende

It's very  easy to make some words **bold** and other words *italic* with Markdown. You can even [link to Google!](http://google.com)

"fritzbox dvbc freischalten"

# This is an h1 tag
## This is an h2 tag
###### This is an h6 tag

*This text will be italic*
_This will also be italic_

**This text will be bold**
__This will also be bold__

_You **can** combine them_

In diesem Verzeichnis befinden sich die folgenden Dateien  :

1. readme.md - diese Datei  
1. adapter-owfs.json        - owfs Adaptereinstellungen, incl. 1-Wire Adressen  
1. adapter-owfs_pretty.json - lesbarer JSON
1. dashui-views.json        - e1 Gluehbirnen-Maske (Warmwasser)
1. dashui-views_pretty.json - lesbarer JSON
1. owfs.js                  - aktueller .js owfs Adapter Treiber
1. *.prg                    - Steuerungsprogramme  
1. e*.htm                   - Steuerungs - Masken
1. Konfig.txt               - Info Datei

**Beschreibung :**  

  https://sites.google.com/site/raspihs1/hsx-interna/hsx_software/hsx-sg-0-4

Sehr hilfreich bei den Kopier-Operationen zum Raspi ist **WinSCP**.
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


Aktueller owfs Adaptertreiber
-----------------------------

Bei einer CCU.IO Version 1.0.52 oder aelter sollte man den owfs Adaptertreiber austauschen.
Dazu die Datei

       owfs.js

in das Verzeichnis

      /opt/ccu.io/adapter/owfs/

kopieren und damit die dort vorhandene Datei ueberschreiben.

**Viel Glueck !**

mailto:Ekkehard@Pofahl.de

**Rueckmeldungen und Korrekturen sehr willkommen !**

Infos zu Markdown : https://de.wikipedia.org/wiki/Markdown

Editiert am :

13:55 03.12.2018
