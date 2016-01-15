unit cal_wahl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    wahl_ok: TButton;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure wahl_okClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

uses unit1 ;

procedure TForm3.wahl_okClick(Sender: TObject);
begin
  close ;
end;

function Dindex : String ;
begin
     Dindex := FormatDateTime('yyyymmdd', unit1.Form1.Calendar1.DateTime) ;
end ;

procedure TForm3.FormShow(Sender: TObject);
var pi : Integer ;
begin
     radiogroup1.Items := unit1.form1.Heizprogramme.items ;

     edit1.Text:= DateToStr (unit1.Form1.Calendar1.DateTime) ;

     edit2.Text := Dindex ;

   //  pi := form1.cre_Ini_Int ( 'TProgramme', Dindex,
   //                     form1.DayToPrg (
   //                     form1.Pindex ( unit1.Form1.Calendar1.DateTime ) ) );

     pi := form1.IniFile.ReadInteger ( 'TProgramme',
                        Dindex ,
                        form1.DayToPrg (
                        form1.Pindex ( unit1.Form1.Calendar1.DateTime ) ) );

     radiogroup1.ItemIndex := pi ;

     Edit3.Text:= IntToStr (form1.Pindex ( unit1.Form1.Calendar1.DateTime ) ) ;

end;

procedure TForm3.RadioGroup1Click(Sender: TObject);
begin
     if radiogroup1.ItemIndex <>
           form1.IniFile.ReadInteger ( 'TProgramme', Dindex,
                     form1.DayToPrg (
                     form1.Pindex ( unit1.Form1.Calendar1.DateTime ) ) )
     then
      form1.IniFile.WriteInteger ('TProgramme', Dindex,
                                   radiogroup1.ItemIndex );
end;

end.

