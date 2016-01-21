unit regel_nn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  maskedit, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    aktiv: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    DispT: TLabel;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    M10: TButton;
    MaskEdit7: TMaskEdit;
    P10: TButton;
    Laden: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    Sichern: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    mask1: TLabel;
    MaskEdit1: TMaskEdit;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    MaskEdit4: TMaskEdit;
    MaskEdit5: TMaskEdit;
    MaskEdit6: TMaskEdit;
    sMinute: TLabel;
    sStunde: TLabel;
    procedure aktivChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure CheckBox5Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LadenClick(Sender: TObject);
    procedure M10Click(Sender: TObject);
    procedure P10Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure SichernClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure MaskEdit1Change(Sender: TObject);
    procedure dec_tfi ;
    procedure berechne_gueltig ;
  private
    { private declarations }
  public
    { public declarations }
    tfi , tfj, nDispT : Integer ;
  end;

var
  Form2 : TForm2;

implementation

{$R *.lfm}

{ TForm2 }

uses unit1 ;

procedure TForm2.dec_tfi ;
begin

    if nDispT > 0 then dec (nDispT) ;
    DispT.Caption := IntToStr (nDispT) ;
    if nDispT > 0 then Panel2.Color:= clLime
                  else Panel2.Color:= clRed   ;
end;

procedure TForm2.SichernClick(Sender: TObject);
var psec : string ;
begin
  psec := unit1.Form1.Heizprogramme.Items
                             [unit1.Form1.Heizprogramme.ItemIndex]
                              + '_' + TForm (self).Caption   ;

  unit1.form1.IniFile.WriteInteger( psec, 'top',   TForm (self).top   ) ;
  unit1.form1.IniFile.WriteInteger( psec, 'left',  TForm (self).left  ) ;
  unit1.form1.IniFile.WriteInteger( psec, 'width', TForm (self).width ) ;
  unit1.form1.IniFile.WriteInteger( psec, 'height',TForm (self).height ) ;

  unit1.form1.IniFile.WriteBool (psec, 'aktiv', aktiv.checked );
  // close ;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin

end;

procedure TForm2.aktivChange(Sender: TObject);
begin
  if aktiv.Checked then Panel1.Color:= clLime
                   else Panel1.Color:= clRed ;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin

end;

procedure TForm2.Button3Click(Sender: TObject);
begin

end;

procedure TForm2.Button4Click(Sender: TObject);
begin

end;

procedure TForm2.CheckBox4Change(Sender: TObject);
begin

  if CheckBox4.Checked then panel3.Color := panel4.Color
                       else panel3.Color:= clYellow ;

end;

procedure TForm2.CheckBox5Change(Sender: TObject);
begin
  if CheckBox5.Checked then panel6.Color := panel7.Color
                       else panel6.Color:= clYellow ;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;


procedure TForm2.LadenClick(Sender: TObject);
  var psec : string ;
begin
  psec := unit1.Form1.Heizprogramme.Items
                             [unit1.Form1.Heizprogramme.ItemIndex]
                              + '_' + TForm (self).Caption   ;

  TForm (self).top    := unit1.form1.IniFile.ReadInteger( psec, 'top',   TForm (self).top   ) ;
  TForm (self).left   := unit1.form1.IniFile.ReadInteger( psec, 'left',  TForm (self).left  ) ;
  TForm (self).width  := unit1.form1.IniFile.ReadInteger( psec, 'width', TForm (self).width ) ;
  TForm (self).height := unit1.form1.IniFile.ReadInteger( psec, 'height',TForm (self).height ) ;
  aktiv.checked       := unit1.form1.IniFile.ReadBool (psec, 'aktiv', false );

end;

procedure TForm2.M10Click(Sender: TObject);
begin
    if unit1.form1.Debug_Flag.Checked then nDispT := nDispT - 10
                                      else nDispT := nDispT - 600 ;
    if nDispT < 0 then nDispT := 0 ;
end;

procedure TForm2.P10Click(Sender: TObject);
begin
    if unit1.form1.Debug_Flag.Checked then nDispT := nDispT + 10
                                      else nDispT := nDispT + 600 ;
end;

procedure TForm2.Panel4Click(Sender: TObject);
begin
        if panel4.Color <> clLime then panel4.Color := clLime
                       else panel4.Color := clRed ;
end;

procedure TForm2.Panel5Click(Sender: TObject);
begin
  if panel5.Color <> clLime then panel5.Color := clLime
                          else panel5.Color := clRed ;
end;

procedure TForm2.Panel7Click(Sender: TObject);
begin
      if panel7.Color <> clLime then panel7.Color := clLime
                                else panel7.Color := clRed ;
end;

procedure TForm2.RadioGroup1Click(Sender: TObject);
begin

end;

procedure TForm2.RadioGroup2Click(Sender: TObject);
begin

end;

procedure TForm2.Edit1Change(Sender: TObject);
var strx, stry : string ;
    si : Integer ;
    no_doppel : Boolean ;
begin
    strx:= edit1.Text ;
    stry := '' ;
    no_doppel := true ;
    sStunde.Caption := '' ;
    sMinute.Caption := '' ;
    for si := 1 to length (strx) do
    begin
      if (strx [si] = ':') and no_doppel and (si <= 3) then
      begin
        no_doppel := false ;
        stry := stry + strx [si] ;
      end;
      if strx [si] in ['0' .. '9'] then stry := stry + strx [si] ;
    end;

    if length (stry) > 5 then stry := copy (stry , 1, 5) ;
    sStunde.Caption := copy (stry, 1, pos (':', stry ) - 1 ) ;
    if pos (':', stry ) <> 0 then sMinute.Caption := copy (stry, pos (':', stry )+ 1, 10 ) ;
    Label1.Caption:= stry ;
    edit1.Text:= stry ;
end;

procedure TForm2.MaskEdit1Change(Sender: TObject);
var strm1 : string ;
begin

    strm1 := TMaskEdit (Sender).Caption ;
    if not ( strm1 [1] in ['0' .. '2']) then strm1 [1] := '2' ;

    if ( strm1 [1] = '2' ) and ( not ( strm1 [2] = '_' ) ) then
    if StrToInt (copy (strm1, 1, 2) ) > 23 then begin
                          strm1 [1] := '2' ;
                          strm1 [2] := '3' ;
                        end;

    if not ( strm1 [4] in ['0' .. '5']) then strm1 [4] := '0' ;

    mask1.Caption  := strm1 ;
    TMaskEdit (Sender).Caption := strm1 ;
end;

procedure TForm2.berechne_gueltig ;
begin

    if checkbox4.Checked then panel3.Color := panel4.Color;
    if checkbox5.Checked then panel6.Color := panel7.Color;

    if       (panel1.Color =  clLime)
        and  (panel2.Color =  clLime)
        and  (panel3.Color <> clRed )
        and  (panel6.Color <> clRed )
    then panel5.Color:= clLime else panel5.Color:= clRed;



end;

end.

