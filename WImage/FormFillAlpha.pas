unit FormFillAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,GraphBuf;

type
  TForm_FillAlpha = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Label2: TLabel;
    EditColor: TEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBoxRed: TCheckBox;
    CheckBoxGreen: TCheckBox;
    CheckBoxBlue: TCheckBox;
    CheckBoxAlpha: TCheckBox;
    CheckBoxAll: TCheckBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    FSouHist:integer;
    FSouBuf:integer;
    FDesHist:integer;
    FDesBuf:integer;
    { Public declarations }
    procedure Build(sou,des:TGraphBuf);
  end;

var
  Form_FillAlpha: TForm_FillAlpha;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_FillAlpha.FormShow(Sender: TObject);
begin
    FSouHist:=GBufList.FCur;
    FSouBuf:=GBufList.Hist[FSouHist].FCur-1;

    FDesHist:=GBufList.FCur;
    FDesBuf:=GBufList.Hist[FDesHist].FCur;
end;

procedure TForm_FillAlpha.ButtonCancelClick(Sender: TObject);
begin
    Form_Main.FRectUpdate.TestAdd(GBufList.Hist[FDesHist].Buf[FDesBuf].GetRect);
    GBufList.Hist[FDesHist].DelBuf(FDesBuf);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_FillAlpha.ButtonOkClick(Sender: TObject);
begin
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_FillAlpha.ButtonBuildClick(Sender: TObject);
var
    sou,des:TGraphBuf;
    i:integer;
begin
    Screen.Cursor:=crHourglass;

    sou:=GBufList.Hist[FSouHist].Buf[FSouBuf];
    des:=GBufList.Hist[FDesHist].Buf[FDesBuf];

    if not CheckBoxAll.Checked then begin
        Build(sou,des);
    end else begin
        for i:=0 to GBufList.Count-1 do begin
            if des=GBufList.Hist[i].CurBuf then begin
                Build(sou,des);
            end else begin
                GBufList.Hist[i].NewModify;
                Build(GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1],GBufList.Hist[i].CurBuf);
            end;
        end;
        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        Form_Main.FFormModify:=false;
        Hide;
    end;

    Form_Main.FRectUpdate.TestAdd(GBufList.Hist[FDesHist].Buf[FDesBuf].GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;

    Screen.Cursor:=crDefault;
end;

procedure TForm_FillAlpha.Build(sou,des:TGraphBuf);
var
    x,y:integer;
    col,colfill,abound:DWORD;
    cr,cg,cb,ca:integer;
    fdown:boolean;
    fillred,fillgreen,fillblue,fillalpha:boolean;
begin
    if (sou.FChannels<4) or (des.FChannels<4) then Exit;

    if GetCountParEC(EditColor.Text,',')<3 then Exit;
    cr:=StrToIntEC(GetStrParEC(EditColor.Text,0,',')); if cr>255 then cr:=255 else if cr<0 then cr:=0;
    cg:=StrToIntEC(GetStrParEC(EditColor.Text,1,',')); if cg>255 then cg:=255 else if cg<0 then cg:=0;
    cb:=StrToIntEC(GetStrParEC(EditColor.Text,2,',')); if cb>255 then cb:=255 else if cb<0 then cb:=0;
    ca:=StrToIntEC(GetStrParEC(EditColor.Text,3,',')); if ca>255 then ca:=255 else if ca<0 then ca:=0;

    colfill:=DWORD(cr) or (DWORD(cg) shl 8) or (DWORD(cb) shl 16) or (DWORD(ca) shl 24);

    abound:=StrToIntEC(Edit1.Text);

    fdown:=RadioButton1.Checked;

    fillred:=CheckBoxRed.Checked;
    fillgreen:=CheckBoxGreen.Checked;
    fillblue:=CheckBoxBlue.Checked;
    fillalpha:=CheckBoxAlpha.Checked;

    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            col:=PGetDWORD(sou.PixelBuf(x,y));

            if IsSelected(x+sou.FPos.x,y+sou.FPos.y) then begin
                if fdown then begin
                    if ((col shr 24) and $ff)<=abound then begin
//                        col:=colfill;
                        if fillred then col:=(col and not $ff) or (colfill and $ff);
                        if fillgreen then col:=(col and not $ff00) or (colfill and $ff00);
                        if fillblue then col:=(col and not $ff0000) or (colfill and $ff0000);
                        if fillalpha then col:=(col and not $ff000000) or (colfill and $ff000000);
                    end;
                end else begin
                    if ((col shr 24) and $ff)>abound then begin
//                        col:=colfill;
                        if fillred then col:=(col and not $ff) or (colfill and $ff);
                        if fillgreen then col:=(col and not $ff00) or (colfill and $ff00);
                        if fillblue then col:=(col and not $ff0000) or (colfill and $ff0000);
                        if fillalpha then col:=(col and not $ff000000) or (colfill and $ff000000);
                    end;
                end;
            end;

            PSet(des.PixelBuf(x,y),col);
        end;
    end;
end;

end.
