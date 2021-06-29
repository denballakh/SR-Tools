unit FormSelectAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm_SelectAlpha = class(TForm)
    ButtonBuild: TButton;
    ButtonOk: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBoxRed: TCheckBox;
    CheckBoxGreen: TCheckBox;
    CheckBoxBlue: TCheckBox;
    CheckBoxAlpha: TCheckBox;
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_SelectAlpha: TForm_SelectAlpha;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBuf,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_SelectAlpha.ButtonOkClick(Sender: TObject);
begin
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_SelectAlpha.ButtonBuildClick(Sender: TObject);
var
    tbound:integer;
    gb:TGraphBuf;
    x,y:integer;
    fup:boolean;
    cr,cg,cb,ca:BYTE;
    selected:boolean;
begin
    gb:=GBufList.CurHist.CurBuf;
    if gb.FChannels<4 then Exit;

    Form_Main.SelectLineHide;
    tbound:=StrToIntEC(Edit1.Text);
    fup:=RadioButton2.Checked;

    GImageSelectAll:=false;
    GImageSelectPos:=gb.FPos;
    GImageSelect.ImageCreate(gb.FLenX,gb.FLenY,1);

    for y:=0 to gb.FLenY-1 do begin
        for x:=0 to gb.FLenX-1 do begin
            cr:=gb.PixelChannel(x,y,0);
            cg:=gb.PixelChannel(x,y,1);
            cb:=gb.PixelChannel(x,y,2);
            ca:=gb.PixelChannel(x,y,3);
            selected:=true;
            if (CheckBoxRed.Checked) and ( ((fup) and (cr<=tbound)) or
                                           ((not fup) and (cr>tbound))) then selected:=false;
            if (CheckBoxGreen.Checked) and ( ((fup) and (cg<=tbound)) or
                                           ((not fup) and (cg>tbound))) then selected:=false;
            if (CheckBoxBlue.Checked) and ( ((fup) and (cb<=tbound)) or
                                           ((not fup) and (cb>tbound))) then selected:=false;
            if (CheckBoxAlpha.Checked) and ( ((fup) and (ca<=tbound)) or
                                           ((not fup) and (ca>tbound))) then selected:=false;

            if selected then begin
                PSet(GImageSelect.PixelBuf(x,y),BYTE(1));
            end else begin
                PSet(GImageSelect.PixelBuf(x,y),BYTE(0));
            end;
{            if CheckBoxAlpha.Checked then begin
                if ((fup) and (gb.PixelChannel(x,y,3)>tbound)) or ((not fup) and (gb.PixelChannel(x,y,3)<=tbound)) then begin
                    PSet(GImageSelect.PixelBuf(x,y),BYTE(1));
                end else begin
                    PSet(GImageSelect.PixelBuf(x,y),BYTE(0));
                end;
            end;}
        end;
    end;
    Form_Main.FSelectLine.Build(GImageSelect);
    Form_Main.SelectLineShow;
end;

end.
