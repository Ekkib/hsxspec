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
    ZusZeit: TLabel;
    ZusAggregat: TLabel;
    ZusBedingung: TLabel;
    XProgramm: TLabel;
    scharf3: TCheckBox;
    q2: TCheckBox;
    q1: TCheckBox;
    q3: TCheckBox;
    scharf1: TCheckBox;
    scharf2: TCheckBox;
    Peilwert: TEdit;
    Bedingung1: TComboBox;
    Aggregat1: TComboBox;
    Aggregat2: TComboBox;
    Bedingung2: TComboBox;
    Bedingung3: TComboBox;
    DispT: TLabel;
    Xquer: TEdit;
    Yquer: TEdit;
    Trig_volume: TEdit;
    Trig_time: TEdit;
    Trig_temp: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    M10: TButton;
    XqBis: TMaskEdit;
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
    slot1: TCheckBox;
    slot2: TCheckBox;
    slot3: TCheckBox;
    Von1: TMaskEdit;
    Von2: TMaskEdit;
    Von3: TMaskEdit;
    Bis1: TMaskEdit;
    Bis2: TMaskEdit;
    Bis3: TMaskEdit;
    procedure aktivChange(Sender: TObject);
    procedure scharf1Change(Sender: TObject);
    procedure scharf2Change(Sender: TObject);
    procedure PeilwertChange(Sender: TObject);
    procedure scharf3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LadenClick(Sender: TObject);
    procedure M10Click(Sender: TObject);
    procedure P10Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure Panel9Click(Sender: TObject);
    procedure SichernClick(Sender: TObject);
    procedure Von1Change(Sender: TObject);
    procedure dec_tfi ;
    procedure berechne_gueltig ;
    procedure ZusAggregatClick(Sender: TObject);
    procedure ZusBedingungClick(Sender: TObject);
    procedure ZusZeitClick(Sender: TObject);
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
var hz_t : string ;
begin

    if nDispT > 0 then dec (nDispT) ;
    if nDispT < 0 then      nDispT := 0  ;
    DispT.Caption := unit1.form1.IntToHMS (nDispT) ;
    if nDispT > 0 then Panel2.Color:= clLime
                  else Panel2.Color:= clRed   ;

    if nDispT = 0 then  // schau nach, ob geladen werden muß
    begin
       with unit1.form1 do begin
       if (HMSToInt (TimeToStr (now)) >  HMSToInt (Von1.Text + ':00')) and
          (HMSToInt (TimeToStr (now)) <  HMSToInt (Bis1.Text + ':00'))
              and slot1.checked then
          begin
           hz_t   := IntToHMS ( HMSToInt (Bis1.Text + ':00') -
                                HMSToInt (TimeToStr (now) )      );
           nDispT := HMSToInt (hz_t) ;
          end;
       end;

       with unit1.form1 do begin
       if (HMSToInt (TimeToStr (now)) >  HMSToInt (Von2.Text + ':00')) and
          (HMSToInt (TimeToStr (now)) <  HMSToInt (Bis2.Text + ':00'))
              and slot2.checked then
          begin
           hz_t   := IntToHMS ( HMSToInt (Bis2.Text + ':00') -
                                HMSToInt (TimeToStr (now) )       );
           nDispT := HMSToInt (hz_t) ;
          end;
       end;

       with unit1.form1 do begin
       if (HMSToInt (TimeToStr (now)) >  HMSToInt (Von3.Text + ':00')) and
          (HMSToInt (TimeToStr (now)) <  HMSToInt (Bis3.Text + ':00'))
              and slot3.checked then
          begin
           hz_t := IntToHMS ( HMSToInt (Bis3.Text + ':00') -
                              HMSToInt (TimeToStr (now) )        );
           nDispT := HMSToInt (hz_t) ;
          end;
       end;


    end;

    if scharf3.Checked then with unit1.form1 do begin
           Yquer.Text := IntToHMS ( Hz_Tab_Wert (Xquer.Text) ) ;
           Peilwert.Text :=  IntToHMS (  HMSToInt ( Yquer.Text) +
                                         HMSToInt ( TimeToStr (now)  ) ) ;
           if ( HMSToInt (Peilwert.Text) > HMSToInt ( XqBis.Text + ':00') )
              and (nDispT = 0)
              and (HMSToInt (TimeToStr (now)) < HMSToInt (XqBis.Text+ ':00'))
              then
              begin
                    Trig_time.Text   := DateTimeToStr (now) ;
                    Trig_temp.Text   := Xquer.Text ;
                    Trig_volume.Text := Yquer.Text ;
                    nDispT := HMSToInt (Trig_volume.Text) ;
                    panel9.color := clLime ;
              end;
     end;
end;

procedure TForm2.SichernClick(Sender: TObject);
var psec : string ;
begin with unit1.Form1 do begin
  psec := Heizprogramme.Items [Heizprogramme.ItemIndex]
                                                  + '_' + TForm (self).Caption;

  IniFile.WriteInteger( psec, 'top',   TForm (self).top   ) ;
  IniFile.WriteInteger( psec, 'left',  TForm (self).left  ) ;
  IniFile.WriteInteger( psec, 'width', TForm (self).width ) ;
  IniFile.WriteInteger( psec, 'height',TForm (self).height) ;

  with Aggregat1  do IniFile.WriteInteger( psec, name, ItemIndex ) ;
  with Aggregat2  do IniFile.WriteInteger( psec, name, ItemIndex ) ;
  with Bedingung1 do IniFile.WriteInteger( psec, name, ItemIndex ) ;
  with Bedingung2 do IniFile.WriteInteger( psec, name, ItemIndex ) ;
  with Bedingung3 do IniFile.WriteInteger( psec, name, ItemIndex ) ;

  with aktiv do IniFile.WriteBool (psec, name, checked );
  with slot1 do IniFile.WriteBool (psec, name, checked );
  with slot2 do IniFile.WriteBool (psec, name, checked );
  with slot3 do IniFile.WriteBool (psec, name, checked );
  with q1    do IniFile.WriteBool (psec, name, checked );
  with q2    do IniFile.WriteBool (psec, name, checked );
  with q3    do IniFile.WriteBool (psec, name, checked );

  IniFile.WriteString (psec, 'Von1', Von1.text ) ;
  IniFile.WriteString (psec, 'Bis1', Bis1.text ) ;
  IniFile.WriteString (psec, 'Von2', Von2.text ) ;
  IniFile.WriteString (psec, 'Bis2', Bis2.text ) ;
  IniFile.WriteString (psec, 'Von3', Von3.text ) ;
  IniFile.WriteString (psec, 'Bis3', Bis3.text ) ;

  IniFile.WriteString (psec, 'XqBis', XqBis.text ) ;


end; end ;

procedure TForm2.aktivChange(Sender: TObject);
begin
  if aktiv.Checked then Panel1.Color:= clLime
                   else Panel1.Color:= clRed ;

end;

procedure TForm2.scharf1Change(Sender: TObject);
begin

  if scharf1.Checked then panel3.Color := panel4.Color
                       else panel3.Color:= clYellow ;
end;

procedure TForm2.scharf2Change(Sender: TObject);
begin
  if scharf2.Checked then panel6.Color := panel7.Color
                       else panel6.Color:= clYellow ;
end;

procedure TForm2.PeilwertChange(Sender: TObject);
begin

end;

procedure TForm2.scharf3Change(Sender: TObject);
begin
     if scharf3.checked then panel8.Color:= clLime
                          else panel8.Color:= clYellow ;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin

end;

procedure TForm2.LadenClick(Sender: TObject);
  var psec : string ;
begin  with unit1.Form1 do begin
  psec := Heizprogramme.Items [Heizprogramme.ItemIndex]
                                               + '_' + TForm (self).Caption ;
  XProgramm.Caption := Heizprogramme.Items [Heizprogramme.ItemIndex] ;

  TForm (self).top   := IniFile.ReadInteger(psec, 'top',   TForm (self).top   );
  TForm (self).left  := IniFile.ReadInteger(psec, 'left',  TForm (self).left  );
  TForm (self).width := IniFile.ReadInteger(psec, 'width', TForm (self).width );
  TForm (self).height:= IniFile.ReadInteger(psec, 'height',TForm (self).height);

  with Bedingung1 do ItemIndex := IniFile.ReadInteger (psec,name,ItemIndex);
  with Bedingung2 do ItemIndex := IniFile.ReadInteger (psec,name,ItemIndex);
  with Bedingung3 do ItemIndex := IniFile.ReadInteger (psec,name,ItemIndex);
  with Aggregat1  do ItemIndex := IniFile.ReadInteger (psec,name,ItemIndex);
  with Aggregat2  do ItemIndex := IniFile.ReadInteger (psec,name,ItemIndex);

  with aktiv do checked := IniFile.ReadBool (psec, name, checked );
  with slot1 do checked := IniFile.ReadBool (psec, name, checked );
  with slot2 do checked := IniFile.ReadBool (psec, name, checked );
  with slot3 do checked := IniFile.ReadBool (psec, name, checked );
  with q1    do checked := IniFile.ReadBool (psec, name, checked );
  with q2    do checked := IniFile.ReadBool (psec, name, checked );
  with q3    do checked := IniFile.ReadBool (psec, name, checked );

  Von1.Text:= IniFile.ReadString(psec,'Von1','07:00' );
  Bis1.Text:= IniFile.ReadString(psec,'Bis1','08:00' );
  Von2.Text:= IniFile.ReadString(psec,'Von2','09:00' );
  Bis2.Text:= IniFile.ReadString(psec,'Bis2','10:00' );
  Von3.Text:= IniFile.ReadString(psec,'Von3','11:00' );
  Bis3.Text:= IniFile.ReadString(psec,'Bis3','12:00' );

  XqBis.Text:= IniFile.ReadString(psec,'XqBis','15:00' );

end; end ;

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

procedure TForm2.Panel2Click(Sender: TObject);
begin
      nDispT := 0 ;
end;

procedure TForm2.Panel4Click(Sender: TObject);
begin
        if panel4.Color <> clLime then panel4.Color := clLime
                                  else panel4.Color := clRed ;
end;


procedure TForm2.Panel7Click(Sender: TObject);
begin
      if panel7.Color <> clLime then panel7.Color := clLime
                                else panel7.Color := clRed ;
end;

procedure TForm2.Panel9Click(Sender: TObject);
begin
      if panel9.Color <> clYellow then panel9.Color := clYellow
                                  else panel9.Color := clLime ;
end;

procedure TForm2.Von1Change(Sender: TObject);
var strm1 : string ;
begin

    strm1 := TMaskEdit (Sender).Caption ;
    if not ( strm1 [1] in ['0' .. '2']) then strm1 [1] := '2' ;
    if not ( strm1 [2] in ['0' .. '9']) then strm1 [2] := '0' ;

    if ( strm1 [1] = '2' ) then // and ( not ( strm1 [2] = '_' ) ) then
    if StrToInt (copy (strm1, 1, 2) ) > 23 then begin
                          strm1 [1] := '2' ;
                          strm1 [2] := '3' ;
                        end;

    if not ( strm1 [4] in ['0' .. '5']) then strm1 [4] := '0' ;
    if not ( strm1 [5] in ['0' .. '9']) then strm1 [5] := '0' ;

    TMaskEdit (Sender).Caption := strm1 ;
end;

procedure TForm2.berechne_gueltig ;
begin

    if scharf1.Checked then panel3.Color := panel4.Color;
    if scharf2.Checked then panel6.Color := panel7.Color;

    if       (panel1.Color =  clLime)
        and  (panel2.Color =  clLime)
        and  (panel3.Color <> clRed )
        and  (panel6.Color <> clRed )
    then panel5.Color:= clLime else panel5.Color:= clRed;

end;

procedure TForm2.ZusAggregatClick(Sender: TObject);
begin
  showmessage ('Im Endausbau wird durch diesen Klick' + #13 +
               'ein weiteres Aggregat angelegt (...)' + #13 +
               'oder die davorliegende Zeile gelöscht ( X )' + #13 + #13 +
               '           Daumen drücken ! ') ;
end;

procedure TForm2.ZusBedingungClick(Sender: TObject);
begin
   showmessage ('Im Endausbau wird durch diesen Klick' + #13 +
               'eine weitere Bedingung angelegt (...)' + #13 +
               'oder die davorliegende Zeile gelöscht ( X )' + #13 + #13 +
               '           Daumen drücken ! ') ;
end;

procedure TForm2.ZusZeitClick(Sender: TObject);
begin
    showmessage ('Im Endausbau wird durch diesen Klick'    + #13 +
                 'eine weitere Zeiteingabe angelegt (...)' + #13 +
                 'oder die davorliegende Zeile gelöscht ( X )' + #13 + #13 +
                 '           Daumen drücken ! ') ;
end;

end.

