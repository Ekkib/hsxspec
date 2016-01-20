unit Unit1;       // quick & dirty. Schön kommt irgendwann später, :-)

{ to do, 20160120  22:40 h:
- Initialisierungen aufräumen !
- Debug Flag
- Debug Minuten, Sekunden
- Dropdown Listen in den Regeln mit aktuellen Werten füttern
- Schleife in Alles_SpeichernClick
- Regel : Zeitanzeige in Std Min Sec
- Mittelwertkiste nach Regel xx,  Tempmittelwert in Maske
}

// geplante Erweiterungen und bekannte Bugs in getrennter Datei

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Calendar, regel_nn, cal_wahl, INIFiles, Unit2;

const Version    = 'HSX_spec 20160120' ;  lizenz_text =

 'Heizungssteuerung HSX mit 1-Wire Temperatur-Sensoren'          + #13 + #13 +
 'Version : ' + version                                          + #13 + #13 +
 'Copyright (c) 2006-2016 : Ekkehard Pofahl, ekkehard@pofahl.de' + #13 + #13 +

'Lizenz: CC BY-NC 3.0             Web Adresse der Lizenz :'        +#13+
' '                                                                +#13+
'    https://creativecommons.org/licenses/by-nc/3.0/de/'           +#13+
' '                                                                       +#13+
'Sie duerfen das Werk bzw. den Inhalt vervielfältigen, verbreiten und'    +#13+
'oeffentlich zugaenglich machen, Abwandlungen und Bearbeitungen des'      +#13+
'Werkes bzw. Inhaltes anfertigen zu den folgenden Bedingungen:'           +#13+
' '                                                                       +#13+
'Namensnennung - Sie muessen den Namen des Autors/Rechteinhabers in der'  +#13+
'von ihm festgelegten Weise nennen.'                                      +#13+
'Keine kommerzielle Nutzung - Dieses Werk bzw. dieser Inhalt darf'        +#13+
'nicht fuer kommerzielle Zwecke verwendet werden.'                        +#13+
'Wobei gilt: Verzichtserklaerung - Jede der vorgenannten Bedingungen kann'+#13+
'aufgehoben werden, sofern Sie die ausdrueckliche Einwilligung des'       +#13+
'Rechteinhabers dazu erhalten.'                                           +#13+
' '                                                                       +#13+
'Die Veröffentlichung dieser Software erfolgt in der Hoffnung, dass sie'   +#13+
'Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die'+#13+
'implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FUER EINEN'     +#13+
'BESTIMMTEN ZWECK. Die Nutzung dieser Software erfolgt auf eigenes Risiko!' ;


 { MIT
 Copyright (c) <year> <copyright holders>
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation files
 (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify, merge,
 publish, distribute, sublicense, and/or sell copies of the Software,
 and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
 OR OTHER DEALINGS IN THE SOFTWARE.
  }

 {

 'This program is free software: you can redistribute it and/or modify' + #13 +
 'it under the terms of the GNU General Public License as published by' + #13 +
 'the Free Software Foundation, either version 3 of the License, or'    + #13 +
 '(at your option) any later version. '                                 + #13 +

 'This program is distributed in the hope that it will be useful,'      + #13 +
 'but WITHOUT ANY WARRANTY; without even the implied warranty of '      + #13 +
 'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the '       + #13 +
 'GNU General Public License for more details. '                        + #13 +

 'You should have received a copy of the GNU General Public License '   + #13 +
 'along with this program.  If not, see <http://www.gnu.org/licenses/>' + #13 ;
}

const
      CmaxRegler = 12 ;  // etwas unelegant, aber einfach

type

  { TForm1 }

  TForm1 = class(TForm)
    Alles_Speichern: TButton;
    Debug_Flag: TCheckBox;
    DatumZeit: TEdit;
    Info_ueber_Aggregate: TLabel;
    Tagesregel: TButton;
    Erstelle_Regeln: TButton;
    Einstellungen: TButton;
    Ende: TButton;
    Hello_World: TButton;
    P_Laden: TButton;
    Calendar1: TCalendar;
    HzMontag: TComboBox;
    HzDienstag: TComboBox;
    HzMittwoch: TComboBox;
    HzDonnerstag: TComboBox;
    HzFreitag: TComboBox;
    HzSamstag: TComboBox;
    HzSonntag: TComboBox;
    Edit1: TEdit;
    Montag: TLabel;
    Dienstag: TLabel;
    Mittwoch: TLabel;
    Donnerstag: TLabel;
    Freitag: TLabel;
    Heizprogramme: TRadioGroup;
    Samstag: TLabel;
    Sonntag: TLabel;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Alles_SpeichernClick(Sender: TObject);
    procedure HzMontagChange(Sender: TObject);
    procedure Debug_FlagChange(Sender: TObject);
    procedure Erstelle_RegelnClick(Sender: TObject);
    procedure Calendar1DblClick(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Hello_WorldClick(Sender: TObject);
    procedure P_LadenClick(Sender: TObject);
    procedure TagesregelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function cre_Ini_String ( xsection, xname, xvalue : string) : string   ;
    function create_Ini_Bool (xsection, xname : string; bvalue : boolean) : boolean ;
    function cre_Ini_Int (xsection, xname : string; ivalue : Integer) : Integer ;
    function cre_Ini_Time (xsection, xname : string; xtime : TTime) : TTime ;
    function Pindex (pdate : TDateTime) : Integer  ;
    function DayToPrg (WTag : Integer) : Integer ;

  private
    { private declarations }
  public
    { public declarations }
    IniFile : TIniFile ;
    rkx, N_Regler, N_Programm  : array [1 .. CmaxRegler] of string ;
    ini_indices  : TStrings ;
    Regeln_erstellt : Boolean ;
  end;

var
  Form1: TForm1;

implementation

// uses regel_nn ;

{$R *.lfm}

{ TForm1 }

var  regel_i : array [1 .. CmaxRegler ] of TForm2 ;
  li : Integer ;
  i1 : integer ;


  function TForm1.cre_Ini_String ( xsection, xname, xvalue : string) : string   ;
  var    cis : string ;
  begin  cis := IniFile.ReadString  (xsection, xname, xvalue ) ;
                IniFile.WriteString (xsection, xname, cis    ) ;
         result := cis ;
  end;

  function TForm1.create_Ini_Bool (xsection, xname : string; bvalue : boolean) : boolean ;
  var    cb : boolean ;
  begin  cb := IniFile.ReadBool  (xsection, xname, bvalue ) ;
               IniFile.WriteBool (xsection, xname, cb     ) ;
         result := cb ;
  end;

  function TForm1.cre_Ini_Int (xsection, xname : string; ivalue : Integer) : Integer ;
  var    cint : Integer ;
  begin  cint := IniFile.ReadInteger   (xsection, xname, ivalue ) ;
                 IniFile.WriteInteger  (xsection, xname, cint   ) ;
         result := cint ;
  end;

  function TForm1.cre_Ini_Time (xsection, xname : string; xtime : TTime): TTime;
  var    ctime : TTime ;
  begin  ctime := IniFile.ReadTime   (xsection, xname, xtime ) ;
                  IniFile.WriteTime  (xsection, xname, ctime ) ;
         result := ctime ;
  end;

function TForm1.DayToPrg (WTag : Integer) : Integer ;
begin
       DayToPrg := 0 ; // Default
       case WTag of
       1 : DayToPrg := HzMontag.ItemIndex ;
       2 : DayToPrg := HzDienstag.ItemIndex ;
       3 : DayToPrg := HzMittwoch.ItemIndex ;
       4 : DayToPrg := HzDonnerstag.ItemIndex ;
       5 : DayToPrg := HzFreitag.ItemIndex ;
       6 : DayToPrg := HzSamstag.ItemIndex ;
       7 : DayToPrg := HzSonntag.ItemIndex ;
       end ;
end;

procedure TForm1.EndeClick(Sender: TObject);
begin
      close ;
end;

function ExtractFileName_ohneExtension (voller_Name : string) : string;
var fn : string ;
begin
      fn := ExtractFileName  (voller_Name) ;
      if pos ('.', fn ) = 0
         then ExtractFileName_ohneExtension := fn
         else ExtractFileName_ohneExtension := copy(fn, 1, pos ('.', fn ) -1);
end ;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.Caption:= Version + '  *' + DateTimeToStr (now) ;

  IniFile := TIniFile.create (  ExtractFilePath (ParamStr (0)) +
                  ExtractFileName_ohneExtension (ParamStr (0)) + '.ini' ) ;

  iniFile.WriteString ('Allgemeine_Infos', 'Programmversion', Version ) ;

  debug_flag.Checked := create_Ini_Bool ('Einstellungen', 'debug', false) ;

  // Demnächst auch variabel ! :-)
  // Name_Regler

  N_Regler [1] := cre_ini_string ('Name_Regler', 'nr_1', 'RWohnzimmer');
  N_Regler [2] := cre_ini_string ('Name_Regler', 'nr_2', 'RRadiatoren');
  N_Regler [3] := cre_ini_string ('Name_Regler', 'nr_3', 'RWarmwasser');
  N_Regler [4] := cre_ini_string ('Name_Regler', 'nr_4', 'RWintergarten');
  N_Regler [5] := cre_ini_string ('Name_Regler', 'nr_5', 'R*->Wohnen');
  N_Regler [6] := cre_ini_string ('Name_Regler', 'nr_6', 'R*->Radiatoren');
  N_Regler [7] := cre_ini_string ('Name_Regler', 'nr_7', 'R*->Wintergarten');
  N_Regler [8] := cre_ini_string ('Name_Regler', 'nr_8', 'RSauna');

  // Name_Heizprogramme

  N_Programm [1] := cre_ini_string ('Name_Programm', 'np_1', 'PStandard');
  N_Programm [2] := cre_ini_string ('Name_Programm', 'np_2', 'PFrei');
  N_Programm [3] := cre_ini_string ('Name_Programm', 'np_3', 'PUrlaub');
  N_Programm [4] := cre_ini_string ('Name_Programm', 'np_4', 'PSauna');
  N_Programm [5] := cre_ini_string ('Name_Programm', 'np_5', 'PFrostschutz');
  N_Programm [6] := cre_ini_string ('Name_Programm', 'np_6', 'Programm_1');
  N_Programm [7] := cre_ini_string ('Name_Programm', 'np_7', 'Programm_2');

  // Readsection

end;

procedure TForm1.FormShow(Sender: TObject);
begin
       P_Laden.Click;
       Erstelle_Regeln.Click;
       Tagesregel.Click;
       P_Laden.Click; // Kein Doppelmoppel : Regeln müssen erst erstellt werden
end;



procedure TForm1.Erstelle_RegelnClick(Sender: TObject);
var fc_i : Integer ;
begin

  // Formulare für Regelkreise erstellen

  for fc_i := 1 to 4 do
   begin
       ini_indices := memo1.Lines ;
       inifile.ReadSection ('Name_Regler', ini_indices );

       if not Regeln_erstellt then
                               Application.CreateForm(TForm2, regel_i [fc_i]);

       regel_i[fc_i].Name    := 'Regel' + IntToStr (fc_i) ;
       regel_i[fc_i].caption := inifile.ReadString
           ('Name_Regler', ini_indices.strings [fc_i - 1], 'xx');

           // Heizprogramme.Items.Strings[fc_i - 1] ;
       regel_i[fc_i].Tag     := fc_i ;
       regel_i[fc_i].visible := true ;

       // regel_i[fc_i].xshow   := true ;
    {
       regel_i[fc_i].Aggregat1.Items := relais_items.Items ;
       regel_i[fc_i].Aggregat2.Items := relais_items.Items ;
       regel_i[fc_i].Temp1.Items := tempnamenliste.Items ;
       regel_i[fc_i].Temp2.Items := tempnamenliste.Items ;

       regel_i[fc_i].Top  := cre_Ini_Int('RG_'+ IntToStr(fc_i), 'Top', form1.Top + 25 * fc_i);
       regel_i[fc_i].Left := cre_Ini_Int('RG_'+ IntToStr(fc_i), 'Left',form1.Left+ 10 * fc_i);

       with regel_i[fc_i] do case fc_i of
       1: caption := cre_ini_string ('Regelkreise', 'rk_1', 'Wohnzimmer');
       2: caption := cre_ini_string ('Regelkreise', 'rk_2', 'Radiatoren');
       3: caption := cre_ini_string ('Regelkreise', 'rk_3', 'Warmwasser');
       4: caption := cre_ini_string ('Regelkreise', 'rk_4', 'Wintergarten');
       5: caption := cre_ini_string ('Regelkreise', 'rk_5', '*-> Wohnen');
       6: caption := cre_ini_string ('Regelkreise', 'rk_6', '*-> Radiatoren');
       7: caption := cre_ini_string ('Regelkreise', 'rk_7', '*-> Wintergarten');
       8: caption := cre_ini_string ('Regelkreise', 'rk_8', 'Regel 8');
       end ;

       RPanel := TPanel.create (form1) ;
       RPanel.Parent  := form1 ;
       RPanel.Name    := 'RPanel' + IntToStr (fc_i) ;
       RPanel.Top     := fc_i * 45 - 38 ;
       RPanel.Left    := 360 ;
       RPanel.Width   := 150 ;
       RPanel.Height  := 42 ;

       RButton := TButton.create (form1) ;
       RButton.Parent  := form1 ;
       RButton.Name    := 'RButton' + IntToStr (fc_i) ;
       RButton.Caption := inifile.ReadString ('Regelkreise', 'rk_'
                                             + IntToStr (fc_i), RButton.Name);
       RButton.Top     := fc_i * 45 - 30 ;
       RButton.Left    := 370 ;
       RButton.Width   := 130 ;
       RButton.Tag     := fc_i ;
       RButton.OnClick := form1.RButtonAClick ;
      }
   end ;

   if not Regeln_erstellt then Regeln_erstellt := true  ;


end;

procedure TForm1.Alles_SpeichernClick(Sender: TObject);
begin
      // :-)
      regel_i [1] . Sichern.click ;
      regel_i [2] . Sichern.click  ;
      regel_i [3] . Sichern.click  ;
      regel_i [4] . Sichern.click  ;

end;

procedure TForm1.HzMontagChange(Sender: TObject);
begin
  iniFile.WriteInteger ('Tagesvorwahl', TComboBox(Sender).Name ,
                                        TComboBox(Sender).ItemIndex ) ;

end;

procedure TForm1.Debug_FlagChange(Sender: TObject);
begin
      iniFile.WriteBool ('Einstellungen', 'debug', debug_flag.Checked) ;
end;

procedure TForm1.Calendar1DblClick(Sender: TObject);
begin
      Form3.showmodal ;
end;

procedure TForm1.EinstellungenClick(Sender: TObject);
begin
      Form4.ShowModal;
end;


procedure TForm1.Hello_WorldClick(Sender: TObject);
begin
        showmessage ('hello world') ;
        showmessage (lizenz_text)   ;
end;

procedure TForm1.P_LadenClick(Sender: TObject);
var Old_index : Integer ;
begin

  unit1.form1.inifile.ReadSection('Name_Programm' , Memo1.Lines );
  Old_index := Heizprogramme.ItemIndex ;
  Heizprogramme.Items.Clear;
  for li := 1 to Memo1.Lines.Count do
      Heizprogramme.Items.AddText (unit1.form1.inifile.ReadString
         ('Name_Programm', Memo1.Lines.Strings[li-1], 'xx'));

  // Namen_Programm.Lines.AddText (unit1.form1.inifile.ReadString
  //     ('Name_Programm', Dummylines1.Lines.Strings[li-1], 'xx'));

  // Heizprogramme.Items := memo1.Lines  ;

  HzMontag.Items     := Heizprogramme.Items ;
  HzDienstag.Items   := Heizprogramme.Items ;
  HzMittwoch.Items   := Heizprogramme.Items ;
  HzDonnerstag.Items := Heizprogramme.Items ;
  HzFreitag.Items    := Heizprogramme.Items ;
  HzSamstag.Items    := Heizprogramme.Items ;
  HzSonntag.Items    := Heizprogramme.Items ;
  with HzMontag     do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 0 );
  with HzDienstag   do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 0 );
  with HzMittwoch   do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 0 );
  with HzDonnerstag do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 0 );
  with HzFreitag    do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 0 );
  with HzSamstag    do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 1 );
  with HzSonntag    do ItemIndex  := cre_ini_int ( 'Tagesvorwahl', name, 1 );

  if Old_index > Heizprogramme.Items.Count then Old_index := 0 ;

  Heizprogramme.ItemIndex := Old_index;

   if Regeln_erstellt then begin
      if heizprogramme.itemindex < 0 then heizprogramme.itemindex := 0 ;  // ?
      regel_i [1] . Laden.click ;
      regel_i [2] . Laden.click  ;
      regel_i [3] . Laden.click  ;
      regel_i [4] . Laden.click  ;
  end ;


end;


Function TForm1.Pindex (pdate : TDateTime) : Integer  ;
var iday : Integer ;
begin
   // DayOfWeek startet bei So = 1, wir bei Mo = 1
   iday :=  (( DayOfWeek (pdate) + 5 ) mod 7 ) + 1 ;
   Pindex := Inifile.ReadInteger
                    ('TProgramme', FormatDateTime('yyyymmdd', pdate), iday );
end ;

procedure TForm1.TagesregelClick(Sender: TObject);
begin
      Heizprogramme.ItemIndex := DayToPrg ( Pindex ( now ) ) ;
end;


var Altes_Programm : Integer ;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  inc (i1) ;
  edit1.text := IntToStr (i1) ;
  DatumZeit.Text := DateTimeToStr (now)  ;

  if i1 > 3 then begin   // nach 3 Sekunden sollte alles eingeschwungen sein
    regel_i [1] . dec_tfi ;
    regel_i [2] . dec_tfi ;
    regel_i [3] . dec_tfi ;
    regel_i [4] . dec_tfi ;

    regel_i [1] . berechne_gueltig ;
    regel_i [2] . berechne_gueltig ;
    regel_i [3] . berechne_gueltig ;
    regel_i [4] . berechne_gueltig ;

    if Altes_Programm <> Heizprogramme.ItemIndex then P_Laden.Click ;

  end;

  Altes_Programm := Heizprogramme.ItemIndex ;

end;

end.

