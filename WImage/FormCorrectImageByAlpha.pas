unit FormCorrectImageByAlpha;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, GraphBuf;

type
  TForm_CorrectImageByAlpha = class(TForm)
    ColorDialog1: TColorDialog;
    Label1: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    ButtonBuild: TButton;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    CheckBoxAll: TCheckBox;
    procedure SpeedButton1Click(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Build(sou,des:TGraphBuf; formula:integer; bgcolor,errorcolor:WideString);
  end;

var
  Form_CorrectImageByAlpha: TForm_CorrectImageByAlpha;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList;

{$R *.DFM}

procedure TForm_CorrectImageByAlpha.FormCreate(Sender: TObject);
begin
    ComboBox1.ItemIndex:=0;
end;

procedure TForm_CorrectImageByAlpha.SpeedButton1Click(Sender: TObject);
var
    bcr,bcg,bcb:DWORD;
begin
    if not ColorDialog1.Execute then Exit;
    bcr:=ColorDialog1.Color and $ff;
    bcg:=(ColorDialog1.Color shr 8) and $ff;
    bcb:=(ColorDialog1.Color shr 16) and $ff;
    Edit1.Text:=IntToStr(bcr)+','+IntToStr(bcg)+','+IntToStr(bcb);
end;

procedure TForm_CorrectImageByAlpha.SpeedButton2Click(Sender: TObject);
var
    bcr,bcg,bcb:DWORD;
begin
    if not ColorDialog1.Execute then Exit;
    bcr:=ColorDialog1.Color and $ff;
    bcg:=(ColorDialog1.Color shr 8) and $ff;
    bcb:=(ColorDialog1.Color shr 16) and $ff;
    Edit2.Text:=IntToStr(bcr)+','+IntToStr(bcg)+','+IntToStr(bcb);
end;

procedure TForm_CorrectImageByAlpha.ButtonCancelClick(Sender: TObject);
begin
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    GBufList.CurHist.DelBuf(GBufList.CurHist.FCur);
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
    ModalResult := mrCancel;
end;

procedure TForm_CorrectImageByAlpha.ButtonOkClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TForm_CorrectImageByAlpha.ButtonBuildClick(Sender: TObject);
var
    sou,des:TGraphBuf;
    i:integer;
begin
    sou:=GBufList.CurHist.Buf[GBufList.CurHist.FCur-1];
    des:=GBufList.CurHist.CurBuf;

    if not CheckBoxAll.Checked then begin
        Build(sou,des,ComboBox1.ItemIndex,Edit1.Text,Edit2.Text);
        Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        Form_Main.RenderImage;
        Form_Main.UpdateImage;
    end else begin
        for i:=0 to GBufList.Count-1 do begin
            if des=GBufList.Hist[i].CurBuf then begin
                Build(sou,des,ComboBox1.ItemIndex,Edit1.Text,Edit2.Text);
            end else begin
                GBufList.Hist[i].NewModify;
                Build(GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1],GBufList.Hist[i].CurBuf,ComboBox1.ItemIndex,Edit1.Text,Edit2.Text);
            end;
        end;
        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        ModalResult:=mrOk;
    end;
end;

procedure TForm_CorrectImageByAlpha.Build(sou,des:TGraphBuf; formula:integer; bgcolor,errorcolor:WideString);
var
    x,y:integer;
//    sou,des:TGraphBuf;
    bcr,bcg,bcb:single;
    ecr,ecg,ecb:single;
    cr,cg,cb,alpha:single;
    col:DWORD;
begin
//    sou:=GBufList.CurHist.Buf[GBufList.CurHist.FCur-1];
//    des:=GBufList.CurHist.CurBuf;
    if (sou.FChannels<4) or (des.FChannels<4) then Exit;

    if GetCountParEC(Edit1.Text,',')<3 then Exit;
    bcr:=StrToIntEC(GetStrParEC(bgcolor,0,','))/255; if bcr>1.0 then bcr:=1.0 else if bcr<0.0 then bcr:=0;
    bcg:=StrToIntEC(GetStrParEC(bgcolor,1,','))/255; if bcg>1.0 then bcg:=1.0 else if bcg<0.0 then bcg:=0;
    bcb:=StrToIntEC(GetStrParEC(bgcolor,2,','))/255; if bcb>1.0 then bcb:=1.0 else if bcb<0.0 then bcb:=0;

    if GetCountParEC(Edit2.Text,',')<3 then Exit;
    ecr:=StrToIntEC(GetStrParEC(errorcolor,0,','))/255; if ecr>1.0 then ecr:=1.0 else if ecr<0.0 then ecr:=0;
    ecg:=StrToIntEC(GetStrParEC(errorcolor,1,','))/255; if ecg>1.0 then ecg:=1.0 else if ecg<0.0 then ecg:=0;
    ecb:=StrToIntEC(GetStrParEC(errorcolor,2,','))/255; if ecb>1.0 then ecb:=1.0 else if ecb<0.0 then ecb:=0;

    for y:=0 to sou.FLenY-1 do begin
        for x:=0 to sou.FLenX-1 do begin
            col:=PGetDWORD(sou.PixelBuf(x,y));
            cr:=((col) and $ff)/255;
            cg:=((col shr 8) and $ff)/255;
            cb:=((col shr 16) and $ff)/255;
            alpha:=((col shr 24) and $ff)/255;

{            if (x=322) and (y=209) then begin
                if (x=y) then begin end;
            end;}

            if formula=0 then begin
                cr:=alpha*cr+(1-alpha)*bcr;
                cg:=alpha*cg+(1-alpha)*bcg;
                cb:=alpha*cb+(1-alpha)*bcb;
            end else if formula=1 then begin
                if alpha>0 then begin
                    cr:=(cr-(1.0-alpha)*bcr)/alpha; if cr<0 then cr:=0 else if cr>1.0 then cr:=1.0;
                    cg:=(cg-(1.0-alpha)*bcg)/alpha; if cg<0 then cg:=0 else if cg>1.0 then cg:=1.0;
                    cb:=(cb-(1.0-alpha)*bcb)/alpha; if cb<0 then cb:=0 else if cb>1.0 then cb:=1.0;
                end else begin
                    cr:=ecr;
                    cg:=ecg;
                    cb:=ecb;
                end;
            end;

            PSet(des.PixelBuf(x,y),(DWORD(Round(cr*255))) or (DWORD(Round(cg*255)) shl 8) or (DWORD(Round(cb*255)) shl 16) or (DWORD(Round(alpha*255)) shl 24));
        end;
    end;

//    alpha*color+(1-alpha)*bg_color:
//    sou_color:=(end_color-(1-alpha)*bg_color)/alpha;
end;

end.
