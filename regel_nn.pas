unit regel_nn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  maskedit, ExtCtrls;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    aktiv: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    DispT: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    M10: TButton;
    P10: TButton;
    Laden: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
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
    procedure CheckBox6Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure M10Click(Sender: TObject);
    procedure P10Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Panel6Click(Sender: TObject);
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
    dec (tfi) ;
    edit2.Text:= IntToStr (tfi) ;
    dec (tfj) ;
    edit3.Text:= IntToStr (tfj) ;
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


  // close ;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  tfi := tfi + 30 ;
end;

procedure TForm2.aktivChange(Sender: TObject);
begin
  if aktiv.Checked then Panel1.Color:= clLime
                   else Panel1.Color:= clRed ;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  tfj := tfj + 30 ;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  tfi := tfi - 30 ;
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  tfj := tfj - 30 ;
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

procedure TForm2.CheckBox6Change(Sender: TObject);
begin

end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin

end;

procedure TForm2.M10Click(Sender: TObject);
begin
  nDispT := nDispT - 10 ;
end;

procedure TForm2.P10Click(Sender: TObject);
begin
  nDispT := nDispT + 10 ;
end;

procedure TForm2.Panel3Click(Sender: TObject);
begin

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

procedure TForm2.Panel6Click(Sender: TObject);
begin

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

