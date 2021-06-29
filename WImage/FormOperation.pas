unit FormOperation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, GraphBuf, Buttons;

type
  TForm_Operation = class(TForm)
    Label1: TLabel;
    ComboBoxSou: TComboBox;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    EditColor: TEdit;
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Label4: TLabel;
    EditColorBG: TEdit;
    CheckBox1: TCheckBox;
    CheckBoxColInv: TCheckBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
//        FSou1,FSou2,FDes:TGraphBuf;
//        FSou2Index:integer;

        FSou2Hist:integer;
        FSou2Buf:integer;
        FDesHist:integer;
        FDesBuf:integer;
  end;

var
  Form_Operation: TForm_Operation;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList,Globals;

{$R *.DFM}

procedure TForm_Operation.FormCreate(Sender: TObject);
begin
    ComboBox1.ItemIndex:=0;
end;

procedure TForm_Operation.FormShow(Sender: TObject);
var
    i:integer;
begin
    ComboBoxSou.Items.Clear;
    for i:=0 to GBufList.Count-1 do begin
        ComboBoxSou.Items.Add(GBufList.Hist[i].FName);
    end;
    ComboBoxSou.ItemIndex:=GBufList.FCur;

    FSou2Hist:=GBufList.FCur;
    FSou2Buf:=GBufList.Hist[FSou2Hist].FCur-1;

    FDesHist:=GBufList.FCur;
    FDesBuf:=GBufList.Hist[FDesHist].FCur;
end;

procedure TForm_Operation.ButtonCancelClick(Sender: TObject);
begin
    GBufList.Hist[FDesHist].DelBuf(FDesBuf);
    Form_Main.RenderImage(true);
    Form_Main.UpdateImage;
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_Operation.ButtonOkClick(Sender: TObject);
begin
    Form_Main.FFormModify:=false;
    Hide;
end;

procedure TForm_Operation.ButtonBuildClick(Sender: TObject);
var
    tr:TRect;
    sousmex,sousmey,dessmex,dessmey,lenx,leny:integer;
    ecr,ecg,ecb,eca:single;
    cr1,cg1,cb1,ca1:single;
    cr2,cg2,cb2,ca2:single;
    col:DWORD;
    x,y,tsx,tsy:integer;
    formula:integer;
    sou1,sou2,des:TGraphBuf;
    colinv:boolean;
begin
    sou1:=GBufList.Hist[ComboBoxSou.ItemIndex].CurBuf;
    sou2:=GBufList.Hist[FSou2Hist].Buf[FSou2Buf];
    des:=GBufList.Hist[FDesHist].Buf[FDesBuf];

    tr:=GBufList.RectIntersectImage(ComboBoxSou.ItemIndex,GBufList.Hist[ComboBoxSou.ItemIndex].FCur,FSou2Hist,FSou2Buf);
    sousmex:=tr.Left-sou1.FPos.x;
    sousmey:=tr.Top-sou1.FPos.y;
    dessmex:=tr.Left-des.FPos.x;
    dessmey:=tr.Top-des.FPos.y;
    lenx:=tr.Right-tr.Left;
    leny:=tr.Bottom-tr.Top;

    tsx:=tr.Left;
    tsy:=tr.Top;

    if CheckBox1.Checked then begin
        if GetCountParEC(EditColor.Text,',')<4 then Exit;
        cr1:=StrToIntEC(GetStrParEC(EditColor.Text,0,','))/255; if cr1>1.0 then cr1:=1.0 else if cr1<0.0 then cr1:=0;
        cg1:=StrToIntEC(GetStrParEC(EditColor.Text,1,','))/255; if cg1>1.0 then cg1:=1.0 else if cg1<0.0 then cg1:=0;
        cb1:=StrToIntEC(GetStrParEC(EditColor.Text,2,','))/255; if cb1>1.0 then cb1:=1.0 else if cb1<0.0 then cb1:=0;
        ca1:=StrToIntEC(GetStrParEC(EditColor.Text,2,','))/255; if ca1>1.0 then ca1:=1.0 else if ca1<0.0 then ca1:=0;

        col:=(DWORD(Round(cr1*255))) or (DWORD(Round(cg1*255)) shl 8) or (DWORD(Round(cb1*255)) shl 16) or (DWORD(Round(ca1*255)) shl 24);
        des.FillRect(Rect(0,0,des.FLenX,des.FLenY),col);
    end else begin
        des.Load(sou2);
    end;

    if GetCountParEC(EditColor.Text,',')<4 then Exit;
    ecr:=StrToIntEC(GetStrParEC(EditColor.Text,0,','))/255; if ecr>1.0 then ecr:=1.0 else if ecr<0.0 then ecr:=0;
    ecg:=StrToIntEC(GetStrParEC(EditColor.Text,1,','))/255; if ecg>1.0 then ecg:=1.0 else if ecg<0.0 then ecg:=0;
    ecb:=StrToIntEC(GetStrParEC(EditColor.Text,2,','))/255; if ecb>1.0 then ecb:=1.0 else if ecb<0.0 then ecb:=0;
    eca:=StrToIntEC(GetStrParEC(EditColor.Text,3,','))/255; if eca>1.0 then eca:=1.0 else if eca<0.0 then eca:=0;

    formula:=ComboBox1.ItemIndex;
    colinv:=CheckBoxColInv.Checked;

    for y:=0 to leny-1 do begin
        for x:=0 to lenx-1 do begin
            if IsSelected(x+tsx,y+tsy) then begin
                if colinv then col:=PGetDWORD(sou2.PixelBuf(dessmex+x,dessmey+y))
                else col:=PGetDWORD(sou1.PixelBuf(sousmex+x,sousmey+y));
                cr1:=((col) and $ff)/255;
                cg1:=((col shr 8) and $ff)/255;
                cb1:=((col shr 16) and $ff)/255;
                ca1:=((col shr 24) and $ff)/255;

                if colinv then col:=PGetDWORD(sou1.PixelBuf(sousmex+x,sousmey+y))
                else col:=PGetDWORD(sou2.PixelBuf(dessmex+x,dessmey+y));
                cr2:=((col) and $ff)/255;
                cg2:=((col shr 8) and $ff)/255;
                cb2:=((col shr 16) and $ff)/255;
                ca2:=((col shr 24) and $ff)/255;

                if formula=0 then begin
                    cr1:=ca1*cr1+(1-ca1)*cr2;
                    cg1:=ca1*cg1+(1-ca1)*cg2;
                    cb1:=ca1*cb1+(1-ca1)*cb2;
                    ca1:=ca1+ca2; if ca1>1.0 then ca1:=1.0;
                end else if formula=1 then begin
                    if ca1>0 then begin
                        cr1:=(cr2-(1.0-ca1)*cr1)/ca1; if cr1<0 then cr1:=0 else if cr1>1.0 then cr1:=1.0;
                        cg1:=(cg2-(1.0-ca1)*cg1)/ca1; if cg1<0 then cg1:=0 else if cg1>1.0 then cg1:=1.0;
                        cb1:=(cb2-(1.0-ca1)*cb1)/ca1; if cb1<0 then cb1:=0 else if cb1>1.0 then cb1:=1.0;
                        ca1:=ca1-ca2; if ca1<0 then ca1:=0;
                    end else begin
                        cr1:=ecr;
                        cg1:=ecg;
                        cb1:=ecb;
                        ca1:=eca;
                    end;
                end else if formula=2 then begin
                    cr1:=cr2+cr1; if cr1>1.0 then cr1:=1.0;
                    cg1:=cg2+cg1; if cg1>1.0 then cg1:=1.0;
                    cb1:=cb2+cb1; if cb1>1.0 then cb1:=1.0;
                    ca1:=ca2+ca1; if ca1>1.0 then ca1:=1.0;
                end else if formula=3 then begin
                    cr1:=cr2-cr1; if cr1<0 then cr1:=0;
                    cg1:=cg2-cg1; if cg1<0 then cg1:=0;
                    cb1:=cb2-cb1; if cb1<0 then cb1:=0;
                    ca1:=ca2-ca1; if ca1<0 then ca1:=0;
                end else if formula=4 then begin
                end;

                PSet(des.PixelBuf(dessmex+x,dessmey+y),(DWORD(Round(cr1*255))) or (DWORD(Round(cg1*255)) shl 8) or (DWORD(Round(cb1*255)) shl 16) or (DWORD(Round(ca1*255)) shl 24));
            end;
        end;
    end;

    Form_Main.RenderImage(true);
    Form_Main.UpdateImage;
end;

end.
