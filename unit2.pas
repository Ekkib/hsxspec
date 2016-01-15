unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls ;

type

  { TForm4 }

  TForm4 = class(TForm)
    Aenderungen_uebernehmen: TButton;
    Dummylines1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Dummylines: TMemo;
    Namen_Regler: TMemo;
    Namen_Programm: TMemo;
    procedure Aenderungen_uebernehmenClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.lfm}

{ TForm4 }

uses unit1 ;

var li : Integer ;

procedure TForm4.FormActivate(Sender: TObject);
var xlines : TStrings ;

begin
      xlines := Dummylines.Lines ; // Initialisieren
      unit1.form1.inifile.ReadSection('Name_Regler' , xlines );
      Dummylines.Lines := xlines ;
      Namen_Regler.Lines.Clear;

      for li := 1 to xlines.Count do
      Namen_Regler.Lines.AddText (unit1.form1.inifile.ReadString
           ('Name_Regler', xlines.Strings[li-1], 'xx'));

      //

      Namen_Programm.Lines.Clear ;
      unit1.form1.inifile.ReadSection('Name_Programm' , Dummylines1.Lines );
      for li := 1 to Dummylines1.Lines.Count do
      Namen_Programm.Lines.AddText (unit1.form1.inifile.ReadString
           ('Name_Programm', Dummylines1.Lines.Strings[li-1], 'xx'));




end;

procedure TForm4.Aenderungen_uebernehmenClick(Sender: TObject);

begin
     for li := 1 to Dummylines.Lines.Count do
     unit1.Form1.inifile.writestring
      ('Name_Regler', Dummylines.Lines[li-1], Namen_Regler.Lines.Strings[li-1]);

     for li := 1 to Dummylines1.Lines.Count do
     unit1.Form1.inifile.writestring
      ('Name_Programm', Dummylines1.Lines[li-1], Namen_Programm.Lines.Strings[li-1]);

     showmessage ('Bitte neu starten !') ;
     close ;
end;

end.

