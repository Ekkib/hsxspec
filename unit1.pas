unit Unit1;       // quick & dirty. Schön kommt irgendwann später, :-)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Calendar, regel_nn, cal_wahl, INIFiles, Unit2;

const Version    = 'HSX 20160228' ;

const ToDo    =
'                 To Do ' + #13 +  #13 +
'- Zahlen in Schleifen gegen Variable/Konstante tauschen  ' + #13 +
'- ... in den Regeln auskodieren                           ' + #13 +
'- Programmierung der .ini Datei durchbürsten ' + #13 +
'- zentraler Kesselschutz (Überhitzungsschutz)' + #13 +
'  (kann jetzt - bei Bedarf - in jedem Regelbaustein implementiert werden)' + #13 +
'- Brauchwasser Konzept (Warmwasser Vorrangschaltung und so)' + #13 +
'- Loggen implementieren und LogLevel definieren'  + #13 +
'- Debug-Screen aus HS1 rüberziehen'  + #13 +
'- Plausibilität und (Relais-)Flatter Schutz'  + #13 +
'- Heizprogramm editieren verbessern (intern, oder extra Programm) '  + #13 +
'  (Editieren kann ja auch per Text-Edit der .ini Datei passieren) '  + #13 +
'- Kalenderbaustein aufhübschen             '  + #13 +
'- restliche Regel-Variablen sichern/laden   '  + #13 +
'- Interface zu OWFS '  + #13 +
'- Ausgaben an die reale Welt (Relais) '  + #13 +
'- optional 24 Stunden Mittelwerte neben Rohwerte listen '  + #13 +
'- (Sobald es Mitarbeiter gibt, diese Liste zur github >issues< Liste migrieren)'+ #13 +
'-              '  + #13 +
'-              '  + #13 +

#13 +#13 +#13 +#13 + '                             ~ finis ~'    ;


 const lizenz_text =

 'Heizungssteuerung HSX mit 1-Wire Temperatur-Sensoren'          + #13 + #13 +
 'Version : ' + version                                          + #13 + #13 +
 'Copyright (c) 2006-2016 : Ekkehard Pofahl, ekkehard@pofahl.de' + #13 + #13 +

 '        https://sites.google.com/site/raspihs1/'   + #13 + #13 +

'Lizenz: CC BY-NC 3.0             Web Adresse der Lizenz :'        +#13+
' '                                                                +#13+
'    https://creativecommons.org/licenses/by-nc/3.0/de/'           +#13+
' '                                                                       +#13+
'Sie duerfen das Werk bzw. den Inhalt vervielfaeltigen, verbreiten und'    +#13+
'oeffentlich zugaenglich machen, Abwandlungen und Bearbeitungen des'      +#13+
'Werkes bzw. Inhaltes anfertigen zu den folgenden Bedingungen:'           +#13+
' '                                                                       +#13+
'Namensnennung - Sie muessen den Namen des Autors/Rechteinhabers'         +#13+
'                in der von ihm festgelegten Weise nennen.'               +#13+
'Keine kommerzielle Nutzung - Dieses Werk bzw. dieser Inhalt darf'        +#13+
'                nicht fuer kommerzielle Zwecke verwendet werden.'        +#13+
'Wobei gilt: Verzichtserklaerung - Jede der vorgenannten Bedingungen'     +#13+
'              kann aufgehoben werden, sofern Sie die ausdrueckliche'     +#13+
'              Einwilligung des Rechteinhabers dazu erhalten.'            +#13+
' '                                                                       +#13+
'Die Veroeffentlichung dieser Software erfolgt in der Hoffnung, dass sie'   +#13+
'Ihnen von Nutzen sein wird, aber OHNE IRGENDEINE GARANTIE, sogar ohne die'+#13+
'implizite Garantie der MARKTREIFE oder der VERWENDBARKEIT FUER EINEN'     +#13+
'BESTIMMTEN ZWECK. Die Nutzung dieser Software erfolgt auf eigenes Risiko!' ;



const                                           //etwas unelegant, aber einfach
    CmaxRegler = 8 ;  maxT = 12 ; MaxAktor = 8 ; maxStuetz = 10 ;

type

  { TForm1 }

  TForm1 = class(TForm)
    Alles_Speichern: TButton;
    DeAktiv: TButton;
    cre_Tempboxes: TButton;
    Debug_Flag: TCheckBox;
    DatumZeit: TEdit;
    ListBox1: TListBox;
    Memo1: TMemo;
    Tagesregel: TButton;
    Erstelle_Regeln: TButton;
    Einstellungen: TButton;
    Ende: TButton;
    Info: TButton;
    P_Laden: TButton;
    Calendar1: TCalendar;
    HzMontag: TComboBox;
    HzDienstag: TComboBox;
    HzMittwoch: TComboBox;
    HzDonnerstag: TComboBox;
    HzFreitag: TComboBox;
    HzSamstag: TComboBox;
    HzSonntag: TComboBox;
    Montag: TLabel;
    Dienstag: TLabel;
    Mittwoch: TLabel;
    Donnerstag: TLabel;
    Freitag: TLabel;
    Heizprogramme: TRadioGroup;
    Samstag: TLabel;
    Sonntag: TLabel;
    Timer1: TTimer;
    procedure Alles_SpeichernClick(Sender: TObject);
    procedure cre_TempboxesClick(Sender: TObject);
    procedure DeAktivClick(Sender: TObject);
    procedure HzMontagChange(Sender: TObject);
    procedure Debug_FlagChange(Sender: TObject);
    procedure Erstelle_RegelnClick(Sender: TObject);
    procedure Calendar1DblClick(Sender: TObject);
    procedure EinstellungenClick(Sender: TObject);
    procedure EndeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InfoClick(Sender: TObject);
    procedure P_LadenClick(Sender: TObject);
    procedure TagesregelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    function cre_Ini_String ( xsection, xname, xvalue : string) : string   ;
    function create_Ini_Bool (xsection, xname : string; bvalue : boolean) : boolean ;
    function cre_Ini_Int (xsection, xname : string; ivalue : Integer) : Integer ;
    function cre_Ini_Time (xsection, xname : string; xtime : TTime) : TTime ;
    function Pindex (pdate : TDateTime) : Integer  ;
    function DayToPrg (WTag : Integer) : Integer ;
    function IntToHMS (isecs : Integer)  : string ;
    function HMSToInt (hmsstr : string)  :  Integer ;
    function Hz_Tab_Wert (lookup : string) : Integer ;

  private
    { private declarations }
  public
    { public declarations }
    IniFile : TIniFile ;
    rkx, N_Regler, N_Programm  : array [1 .. CmaxRegler] of string ;
    N_TMessstelle : array [1 .. MaxT] of string ;
    N_Aktoren   : array [1 .. MaxAktor] of string ;
    Hz_Stuetz   : array [1 .. maxStuetz] of string ;
    Hz_Stuetz_Tt : array [1 .. maxStuetz, 1 .. 2] of integer ;
    X_T : array [1 .. MaxT] of real ;
       // 24 Werte für gleitenden Durchschnitt pro Messwert. Kann optimiert
       // werden, sollte der Speicher eng werden :
    X_T_quer : array [1 .. MaxT, 0 .. 23 ] of real ;
    ini_indices  : TStrings ;
    Regeln_erstellt : Boolean ;
    xLabeledEdit : TLabeledEdit ;
    xLabel : TLabel ;
    old_secs : Integer ;
  end;

var
  Form1: TForm1;

implementation

// uses regel_nn ;

// uses LCLStrConsts,  LCLType ;

{$R *.lfm}

{ TForm1 }

var  regel_i : array [1 .. CmaxRegler ] of TForm2 ;
  li : Integer ;
  i1 : integer ;
  Altes_Programm : Integer ;

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
  iniFile.WriteString ('Allgemeine_Infos', 'zuletzt_aufgerufen', Form1.Caption);

  debug_flag.Checked := create_Ini_Bool ('Einstellungen', 'debug', false) ;

  iniFile.WriteString('Mehr_Info','Sektion_info', 'bislang keine Read_section');

  // Formulargrenzen
  top    := Cre_Ini_Int ('Zentrale', 'top',    top    ) ;
  left   := Cre_Ini_Int ('Zentrale', 'left',   left   ) ;
  width  := Cre_Ini_Int ('Zentrale', 'width',  width  ) ;
  height := Cre_Ini_Int ('Zentrale', 'height', height ) ;

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

  Heizprogramme.Items.Clear;
  for li := 1 to 7 do if N_Programm [li] <> '' then
                                   Heizprogramme.Items.Append(N_Programm [li]);
        // AddText (unit1.form1.inifile.ReadString
        //  ('Name_Programm', Memo1.Lines.Strings[li-1], 'xx'));

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

  // Name_TMessstelle

  N_TMessstelle [1] := cre_ini_string ('Name_TMessstelle', 'nt_1', 'TWarmwasser');
  N_TMessstelle [2] := cre_ini_string ('Name_TMessstelle', 'nt_2', 'TKessel');
  N_TMessstelle [3] := cre_ini_string ('Name_TMessstelle', 'nt_3', 'TWohnzimmer');
  N_TMessstelle [4] := cre_ini_string ('Name_TMessstelle', 'nt_4', 'TWintergarten');
  N_TMessstelle [5] := cre_ini_string ('Name_TMessstelle', 'nt_5', 'TAussen_Nord');
  N_TMessstelle [6] := cre_ini_string ('Name_TMessstelle', 'nt_6', 'TAussen_Sued');
  N_TMessstelle [7] := cre_ini_string ('Name_TMessstelle', 'nt_7', 'TWohnz_Vor');
  N_TMessstelle [8] := cre_ini_string ('Name_TMessstelle', 'nt_8', 'TWohnz_Rueck');
  N_TMessstelle [9] := cre_ini_string ('Name_TMessstelle', 'nt_9', 'TRadiat_Vor');
  N_TMessstelle [10]:= cre_ini_string ('Name_TMessstelle','nt_10', 'TRadiat_Rueck');
  N_TMessstelle [11]:= cre_ini_string ('Name_TMessstelle','nt_11', 'TWGart_Vor');
  N_TMessstelle [12]:= cre_ini_string ('Name_TMessstelle','nt_12', 'TWGart_Rueck');

  // Name_Aktoren

  N_Programm [1] := cre_ini_string ('Name_Aktoren', 'na_1', 'Brenner');
  N_Programm [2] := cre_ini_string ('Name_Aktoren', 'na_2', 'PWohnzimmer');
  N_Programm [3] := cre_ini_string ('Name_Aktoren', 'na_3', 'PWintergarten');
  N_Programm [4] := cre_ini_string ('Name_Aktoren', 'na_4', 'PHeizkoerper');
  N_Programm [5] := cre_ini_string ('Name_Aktoren', 'na_5', 'Pumpe5');
  N_Programm [6] := cre_ini_string ('Name_Aktoren', 'na_6', 'Pumpe6');
  N_Programm [7] := cre_ini_string ('Name_Aktoren', 'na_7', 'Pumpe7');
  N_Programm [8] := cre_ini_string ('Name_Aktoren', 'na_8', 'Pumpe8');

  // Stuetzwerte für Heiztabelle
  // Help=Stuetzstellen fuer Brennerlaufzeiten abhaegig von der Temperatur
  Hz_Stuetz [1] := cre_ini_string ('Heiztabelle', 'STm30', '12:00:00');
  Hz_Stuetz [2] := cre_ini_string ('Heiztabelle', 'STm10', '06:00:00');
  Hz_Stuetz [3] := cre_ini_string ('Heiztabelle', 'STp00', '04:00:00');
  Hz_Stuetz [4] := cre_ini_string ('Heiztabelle', 'STp10', '02:00:00');
  Hz_Stuetz [5] := cre_ini_string ('Heiztabelle', 'STp15', '00:00:00');
  Hz_Stuetz [6] := cre_ini_string ('Heiztabelle', 'STp60', '00:00:00');

  // Temoperaturen in Zehntelgrad : -300 = -30 Grad, etc.
  Hz_Stuetz_Tt [1,1] := -300; Hz_Stuetz_Tt [1,2] := HMSToInt ( Hz_Stuetz [1] ) ;
  Hz_Stuetz_Tt [2,1] := -100; Hz_Stuetz_Tt [2,2] := HMSToInt ( Hz_Stuetz [2] ) ;
  Hz_Stuetz_Tt [3,1] :=    0; Hz_Stuetz_Tt [3,2] := HMSToInt ( Hz_Stuetz [3] ) ;
  Hz_Stuetz_Tt [4,1] :=  100; Hz_Stuetz_Tt [4,2] := HMSToInt ( Hz_Stuetz [4] ) ;
  Hz_Stuetz_Tt [5,1] :=  150; Hz_Stuetz_Tt [5,2] := HMSToInt ( Hz_Stuetz [5] ) ;
  Hz_Stuetz_Tt [6,1] :=  500; Hz_Stuetz_Tt [6,2] := HMSToInt ( Hz_Stuetz [6] ) ;

  // Readsection

end;

procedure TForm1.FormShow(Sender: TObject);
begin
       Erstelle_Regeln.Click;
       Tagesregel.Click;
       cre_Tempboxes.Click;
       P_Laden.Click;
end;

procedure TForm1.Erstelle_RegelnClick(Sender: TObject);
var fc_i, fc_j : Integer ;
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

           // Drop-Down Menues füllen

       ListBox1.Items.Clear ;
       ListBox1.Items.Append(' ');

       for fc_j := 1 to maxAktor do ListBox1.Items.Append( N_Programm [fc_j] );

       regel_i[fc_i].Aggregat1.Items := ListBox1.Items ;
       regel_i[fc_i].Aggregat1.ItemIndex:= 0 ;
       regel_i[fc_i].Aggregat2.Items := ListBox1.Items ;
       regel_i[fc_i].Aggregat2.ItemIndex:= 0 ;

       regel_i[fc_i].bedingung1.Items.Clear ;
       for fc_j := 1 to maxT do
                   regel_i[fc_i].bedingung1.Items.Append(N_TMessstelle [fc_j]);
       regel_i[fc_i].bedingung1.ItemIndex:= 0 ;

       regel_i[fc_i].bedingung2.Items := regel_i[fc_i].bedingung1.Items ;
       regel_i[fc_i].bedingung2.ItemIndex:= 0 ;

       regel_i[fc_i].bedingung3.Items := regel_i[fc_i].bedingung1.Items ;
       regel_i[fc_i].bedingung3.ItemIndex:= 0 ;

       // Die Anfangsansichten justieren :

       regel_i[fc_i].Top     := (fc_i * 45 )- 38 ;
       regel_i[fc_i].Left    := (fc_i * 45 ) ;
       regel_i[fc_i].Width   := 616 ;
       regel_i[fc_i].Height  := 585 ;


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
      regel_i [1] . Sichern.click  ;
      regel_i [2] . Sichern.click  ;
      regel_i [3] . Sichern.click  ;
      regel_i [4] . Sichern.click  ;

      with form1.IniFile do begin
         WriteInteger ('Zentrale', 'top',    top    ) ;
         WriteInteger ('Zentrale', 'left',   left   ) ;
         WriteInteger ('Zentrale', 'width',  width  ) ;
         WriteInteger ('Zentrale', 'height', height ) ;
      end;
end;

procedure TForm1.cre_TempboxesClick(Sender: TObject);
var
    yi  : integer ;
begin
          // Temperaturfelder :
    for yi := 1 to maxT do begin
       xLabeledEdit         := TLabeledEdit.Create (form1) ;
       xLabeledEdit.Parent  := form1 ;
       xLabeledEdit.Name    := 'T' + IntToStr (yi) ;
       xLabeledEdit.EditLabel.Caption :=  N_TMessstelle [yi] ;
       //'Temp_' + IntToStr (yi) ;//TxName[yi];
       xLabeledEdit.LabelPosition     := lpLeft ;
       xLabeledEdit.Top     := 20 + (yi - 1) * 24 ;
       xLabeledEdit.Left    := 80  ;
       xLabeledEdit.Width   := 42 ;
       xLabeledEdit.Visible := true ;
       // Defaulttemperaturen :
       //Txdef [yi]:=

       // cre_ini_int ('TDefault', 'TDef'+IntToStr (yi), 200 + yi) ; // /10;

    end ;

    // Aktorenfelder :
  for yi := 1 to MaxAktor do begin
    xLabeledEdit         := TLabeledEdit.Create (form1) ;
    xLabeledEdit.Parent  := form1 ;
    xLabeledEdit.Name    := 'A' + IntToStr (yi) ;
    xLabeledEdit.Text :=  N_Programm [yi] ;
    xLabeledEdit.EditLabel.Caption :=  '00:00:00' ;
    xLabeledEdit.LabelPosition     := lpLeft ;
    xLabeledEdit.Top     := 20 + (yi - 1) * 24 ;
    xLabeledEdit.Left    := 550  ;
    xLabeledEdit.Width   := 100 ;
    xLabeledEdit.Visible := true ;

    xLabel := Tlabel.Create(form1);
    xLabel.Parent  := form1 ;
    xLabel.Name    := 'ATLR' + IntToStr (yi) ;
    xLabel.Caption :=  '(00:0' + IntToStr (yi) + ':00)' ;
    xLabel.Top     := 22 + (yi - 1) * 24 ;
    xLabel.Left    := 655  ;
    xLabel.Visible := true ;

  end ;
end;

procedure TForm1.DeAktivClick(Sender: TObject);
begin        // hier muß natürlich noch die Schleife hin !
    regel_i [1] .aktiv.Checked:= false ;
    regel_i [2] .aktiv.Checked:= false ;
    regel_i [3] .aktiv.Checked:= false ;
    regel_i [4] .aktiv.Checked:= false ;
end;

Function TForm1.Hz_Tab_Wert (lookup : string) : Integer ;
var nakt, ii, hzindex : Integer ;
    x1, x2, y1, y2, z : Real ;
    Tstr, Tstr2 : string ; h_neg : Boolean ;
begin
   if length (lookup) < 3 then result := 1 else
      begin

      Tstr  := lookup ;
      Tstr2 := '' ;
      h_neg := false ;
      hzindex := 1 ;
      if Tstr [1] = '-' then h_neg := true ;
      if (length (Tstr) > 1) and (length (Tstr) < 6) then
         begin
            for ii := 1 to length (Tstr) do begin
               if Tstr [ii] in ['0' .. '9'] then Tstr2 := Tstr2 + TStr [ii] ;
            end;
            if length (Tstr2) > 0 then nakt := StrToInt (Tstr2) else nakt := 0;
            if h_neg then nakt := - nakt;
         end
      else  nakt := 7 ;

      for ii := 1 to 5 do
        begin
         if  (Hz_Stuetz_Tt [ii,1] <= nakt) and (Hz_Stuetz_Tt [ii+1,1] >= nakt)
                                                        then hzindex := ii ;

        end;

      x1 := StrToFloat ( IntToStr (Hz_Stuetz_Tt [hzindex   ,1] ) );
      x2 := StrToFloat ( IntToStr (Hz_Stuetz_Tt [hzindex+1 ,1] ) );

      y1 := StrToFloat ( IntToStr (Hz_Stuetz_Tt [hzindex   ,2] ) );
      y2 := StrToFloat ( IntToStr (Hz_Stuetz_Tt [hzindex+1 ,2] ) );

      z :=    y1 + ( (y2 - y1 ) * (  (nakt - x1) /  (x2-x1) ) ) ;

      result :=  round (z ) ;

      end;
end;

function twodig (indig : string) : string ;
begin
     if length (indig) = 1 then result := '0' + indig
                           else result := indig ;
end;

function TForm1.IntToHMS (isecs : Integer)  : string ;
var ihr, imn, isc : Integer ;
begin
    ihr :=  isecs div (60*60) ;
    imn := (isecs div 60 ) mod 60  ;
    isc :=  isecs - ( (isecs div 60 ) * 60 ) ;
    result := twodig (IntToStr (ihr)) + ':' +
              twodig (IntToStr (imn)) + ':' +
              twodig (IntToStr (isc)) ;
end ;

function TForm1.HMSToInt (hmsstr : string)  :  Integer ;
var hmsstrl : string ;
begin
     if length (hmsstr) = 8 then begin
     hmsstrl := hmsstr ;
     if not ( hmsstrl [1] in ['0' .. '9'] ) then hmsstrl [1] := '0' ;
     if not ( hmsstrl [2] in ['0' .. '9'] ) then hmsstrl [2] := '0' ;
     if not ( hmsstrl [4] in ['0' .. '9'] ) then hmsstrl [4] := '0' ;
     if not ( hmsstrl [5] in ['0' .. '9'] ) then hmsstrl [5] := '0' ;
     if not ( hmsstrl [7] in ['0' .. '9'] ) then hmsstrl [7] := '0' ;
     if not ( hmsstrl [8] in ['0' .. '9'] ) then hmsstrl [8] := '0' ;

     result :=  StrToInt (copy (hmsstrl,1,2  ) ) * 3600 +
                StrToInt (copy (hmsstrl,4,2  ) ) * 60   +
                StrToInt (copy (hmsstrl,7,2  ) )  ;
     end else result := 0 ;
end ;

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

procedure TForm1.InfoClick(Sender: TObject);
begin
        showmessage ('hello world' + #13 + #13 + '~ HSX Prototyp ~'
        + #13 + #13 + 'auf vier Regelbausteine eingeschränkt') ;
        showmessage (ToDo)   ;
        showmessage (lizenz_text)   ;
end;

procedure TForm1.P_LadenClick(Sender: TObject);
begin
   if Regeln_erstellt then begin
      regel_i [1] . Laden.click ;
      regel_i [2] . Laden.click  ;
      regel_i [3] . Laden.click  ;
      regel_i [4] . Laden.click  ;
   end ;
end;

Function TForm1.Pindex (pdate : TDateTime) : Integer ;   //
var iday : Integer ;
begin
   // DayOfWeek startet bei So = 1, wir bei Mo = 1
   iday :=  (( DayOfWeek (pdate) + 5 ) mod 7 ) + 1 ;
   Pindex := Inifile.ReadInteger
                       ('TProgramme', FormatDateTime('yyyymmdd', pdate),
                       DayToPrg (iday) );
end ;

procedure TForm1.TagesregelClick(Sender: TObject);
begin
      Heizprogramme.ItemIndex := Pindex ( now ) ;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var lmax, tt_i, tt_j : integer ;
begin
  inc (i1) ; // edit1.text := IntToStr (i1) ;
  DatumZeit.Text := DateTimeToStr (now)  ;

  if HMSToInt ( TimeToStr (now) ) < old_secs then  // Neuer Tag !
     begin
       Tagesregel.Click;
       // Reset akkumulierte Zeit für Aktorentimer :
       for tt_j := 1 to MaxAktor do
         TLabeledEdit(FindComponent('A'+IntToStr(tt_j))).EditLabel.Caption :=
                                                      IntToHMS (0) ;
     end;
  old_secs :=  HMSToInt ( TimeToStr (now) ) ;

  if i1 > 3 then begin   // nach 3 Sekunden sollte alles eingeschwungen sein

  for tt_j := 1 to 4 do // Achtung !!!
    begin
       regel_i [tt_j] . Peilwert.Visible:= debug_flag.Checked ;
       regel_i [tt_j] . dec_tfi ;
       regel_i [tt_j] . berechne_gueltig ;
    end ;

    if Altes_Programm <> Heizprogramme.ItemIndex then P_Laden.Click ;

    for tt_j := 1 to MaxAktor do
      begin

       lmax := 0 ;

       for tt_i := 1 to 4 do     // Achtung ! Grenze nicht 4 !
                             if regel_i[tt_i].Panel5.Color = clLime then
       begin
         if (regel_i[tt_i].Aggregat1.items[regel_i[tt_i].Aggregat1.itemindex]
               = N_Programm [tt_j])
         and (regel_i[tt_i].nDispT > lmax ) then lmax := regel_i[tt_i].nDispT ;

         if (regel_i[tt_i].Aggregat2.items[regel_i[tt_i].Aggregat2.itemindex]
               = N_Programm [tt_j])
         and (regel_i[tt_i].nDispT > lmax ) then lmax := regel_i[tt_i].nDispT ;

       end;

    TLabel(FindComponent('ATLR'+IntToStr(tt_j))).caption :=
                                                     '('+ IntToHMS (lmax)+ ')';

    if lmax > 0 then begin with TLabeledEdit(FindComponent('A'+IntToStr(tt_j))) do
        begin
          color := clLime ;
          EditLabel.Caption := IntToHMS (HMSToInt (EditLabel.Caption) +1 ) ;
        end
       end
     else TLabeledEdit (FindComponent('A'+IntToStr(tt_j))).color := clRed ;
    end ;
  end;

  Altes_Programm := Heizprogramme.ItemIndex ;


end;

end.


