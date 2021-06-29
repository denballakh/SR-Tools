unit FormCorrectAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GraphBuf, Buttons,Math;

type
  TForm_CorrectAlpha = class(TForm)
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    EditA: TEdit;
    CheckBoxAll: TCheckBox;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

        FSouHist:integer;
        FSouBuf:integer;
        FDesHist:integer;
        FDesBuf:integer;

        procedure Build(sou,des:TGraphBuf; formula:integer; a:single; alnmc:boolean);
  end;

var
  Form_CorrectAlpha: TForm_CorrectAlpha;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_CorrectAlpha.FormCreate(Sender: TObject);
begin
    ComboBox1.ItemIndex:=0;
end;

procedure TForm_CorrectAlpha.FormShow(Sender: TObject);
begin
    FSouHist:=GBufList.FCur;
    FSouBuf:=GBufList.Hist[FSouHist].FCur-1;

    FDesHist:=GBufList.FCur;
    FDesBuf:=GBufList.Hist[FDesHist].FCur;
end;

procedure TForm_CorrectAlpha.ButtonCancelClick(Sender: TObject);
begin
    GBufList.Hist[FDesHist].DelBuf(FDesBuf);
    Form_Main.RenderImage(true);
    Form_Main.UpdateImage;
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_CorrectAlpha.ButtonOkClick(Sender: TObject);
begin
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_CorrectAlpha.ButtonBuildClick(Sender: TObject);
var
    i:integer;
    sou,des:TGraphBuf;
begin
    sou:=GBufList.Hist[FSouHist].Buf[FSouBuf];
    des:=GBufList.Hist[FDesHist].Buf[FDesBuf];

    if not CheckBoxAll.Checked then begin
        Build(sou,des,ComboBox1.ItemIndex,StrToFloatEC(EditA.Text),CheckBox1.Checked);
        Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        Form_Main.RenderImage;
        Form_Main.UpdateImage;
    end else begin
        for i:=0 to GBufList.Count-1 do begin
            if des=GBufList.Hist[i].CurBuf then begin
                Build(sou,des,ComboBox1.ItemIndex,StrToFloatEC(EditA.Text),CheckBox1.Checked);
            end else begin
                GBufList.Hist[i].NewModify;
                Build(GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1],GBufList.Hist[i].CurBuf,ComboBox1.ItemIndex,StrToFloatEC(EditA.Text),CheckBox1.Checked);
            end;
        end;
        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        Form_Main.FFormModify:=false;
        Hide;
    end;

end;

procedure TForm_CorrectAlpha.Build(sou,des:TGraphBuf; formula:integer; a:single; alnmc:boolean);
var
    x,y:integer;
    cr,cg,cb,alpha:single;
    col:DWORD;
begin
    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            col:=PGetDWORD(sou.PixelBuf(x,y));
            cr:=((col) and $ff)/255;
            cg:=((col shr 8) and $ff)/255;
            cb:=((col shr 16) and $ff)/255;
            alpha:=((col shr 24) and $ff)/255;

            if formula=0 then begin
                alpha:=alpha*a;
            end else if formula=1 then begin
                alpha:=Power(alpha,a);
            end;

            if alnmc then begin
                if alpha>max(max(cr,cg),cb) then alpha:=max(max(cr,cg),cb);
            end;

            PSet(des.PixelBuf(x,y),(DWORD(Round(cr*255))) or (DWORD(Round(cg*255)) shl 8) or (DWORD(Round(cb*255)) shl 16) or (DWORD(Round(alpha*255)) shl 24));
        end;
    end;
end;

end.
