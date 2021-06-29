unit FormDifferent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,GraphBuf;

type
  TForm_Different = class(TForm)
    ComboBoxSou: TComboBox;
    Label1: TLabel;
    ButtonBuild: TButton;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    Label3: TLabel;
    EditREQ: TEdit;
    Label2: TLabel;
    EditColor: TEdit;
    Label4: TLabel;
    ComboBoxMode: TComboBox;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ButtonBuildClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Build;
    procedure Different(des,sou1,sou2:TGraphBuf; colorfill:DWORD; req:single);
  end;

var
  Form_Different: TForm_Different;

implementation

uses EC_Mem,EC_Str,FormMain,GraphBufList;

{$R *.DFM}

procedure TForm_Different.ButtonCancelClick(Sender: TObject);
begin
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    GBufList.CurHist.DelBuf(GBufList.CurHist.FCur);
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
    ModalResult := mrCancel;
end;

procedure TForm_Different.ButtonOkClick(Sender: TObject);
begin
    ModalResult := mrOk;
end;

procedure TForm_Different.FormActivate(Sender: TObject);
var
    i:integer;
begin
    ComboBoxSou.Items.Clear;
    for i:=0 to GBufList.Count-1 do begin
        ComboBoxSou.Items.Add(GBufList.Hist[i].FName);
    end;
    ComboBoxSou.ItemIndex:=GBufList.FCur;

    ComboBoxMode.ItemIndex:=0;
end;

procedure TForm_Different.ButtonBuildClick(Sender: TObject);
begin
    Build;
    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;
end;

procedure TForm_Different.Build;
var
    sou1,sou2,des,t_des,t_sou1,t_sou2:TGraphBuf;
//    t_temp:TGraphBuf;
//    tr:TRect;
    cr1,cg1,cb1,ca1:single;
    colorfill:DWORD;
    i:integer;
    req:single;
begin
    if GetCountParEC(EditColor.Text,',')<4 then Exit;
    cr1:=StrToIntEC(GetStrParEC(EditColor.Text,0,','))/255; if cr1>1.0 then cr1:=1.0 else if cr1<0.0 then cr1:=0;
    cg1:=StrToIntEC(GetStrParEC(EditColor.Text,1,','))/255; if cg1>1.0 then cg1:=1.0 else if cg1<0.0 then cg1:=0;
    cb1:=StrToIntEC(GetStrParEC(EditColor.Text,2,','))/255; if cb1>1.0 then cb1:=1.0 else if cb1<0.0 then cb1:=0;
    ca1:=StrToIntEC(GetStrParEC(EditColor.Text,2,','))/255; if ca1>1.0 then ca1:=1.0 else if ca1<0.0 then ca1:=0;

    colorfill:=(DWORD(Round(cr1*255))) or (DWORD(Round(cg1*255)) shl 8) or (DWORD(Round(cb1*255)) shl 16) or (DWORD(Round(ca1*255)) shl 24);

    req:=sqr(StrToIntEC(EditREQ.Text)/256);

    sou1:=GBufList.Hist[ComboBoxSou.ItemIndex].CurBuf;
    sou2:=GBufList.CurHist.Buf[GBufList.CurHist.FCur-1];
    des:=GBufList.CurHist.CurBuf;

    Screen.Cursor:=crHourglass;

    if ComboBoxMode.ItemIndex=0 then begin
        Different(des,sou1,sou2,colorfill,req);
    end else if ComboBoxMode.ItemIndex=1 then begin
        for i:=0 to GBufList.Count-1 do begin
            if GBufList.Hist[i].CurBuf=sou1 then continue;
            if GBufList.Hist[i].CurBuf=des then begin
                t_des:=des;
                t_sou1:=sou1;
                t_sou2:=sou2;
            end else begin
                GBufList.Hist[i].NewModify;
                t_des:=GBufList.Hist[i].CurBuf;
                t_sou1:=sou1;
                t_sou2:=GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1];
            end;
            Different(t_des,t_sou1,t_sou2,colorfill,req);
        end;

        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        ModalResult:=mrOk;
    end else if ComboBoxMode.ItemIndex=2 then begin
{        tr:=GBufList.Hist[0].CurBuf.GetRect;
        for i:=1 to GBufList.Count-1 do begin
            UnionRect(tr,tr,GBufList.Hist[i].CurBuf.GetRect);
        end;

        t_sou1:=GBufList.Hist[0].CurBuf;
        if t_sou1=des then begin
            t_sou1:=sou2;
        end;

        t_temp:=TGraphBuf.Create;
        t_temp.ImageCreate(tr.Right-tr.Left,tr.Bottom-tr.Top,4);
        t_temp.FPos:=tr.TopLeft;
        t_temp.FillRect(Rect(0,0,t_temp.FLenX,t_temp.FLenY),colorfill);
        t_temp.Copy(t_temp.PosWorldToBuf(t_sou1.FPos),t_sou1,Rect(0,0,t_sou1.FLenX,t_sou1.FLenY));

        for i:=1 to GBufList.Count-1 do begin
            if GBufList.Hist[i].CurBuf=des then begin
                t_des:=des;
                t_sou2:=sou2;
            end else begin
                GBufList.Hist[i].NewModify;
                t_des:=GBufList.Hist[i].CurBuf;
                t_sou2:=GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1];
            end;
            Different(t_des,t_temp,t_sou2,colorfill,req);
        end;

        t_temp.Free;}

        t_sou1:=GBufList.Hist[0].CurBuf;
        if t_sou1=des then begin
            t_sou1:=sou2;
        end;
        for i:=1 to GBufList.Count-1 do begin
            if GBufList.Hist[i].CurBuf=des then begin
                t_des:=des;
                t_sou2:=sou2;
            end else begin
                GBufList.Hist[i].NewModify;
                t_des:=GBufList.Hist[i].CurBuf;
                t_sou2:=GBufList.Hist[i].Buf[GBufList.Hist[i].FCur-1];
            end;
            Different(t_des,t_sou1,t_sou2,colorfill,req);
            t_sou1:=t_sou2;
        end;

        Form_Main.RenderImage(true);
        Form_Main.UpdateImage;
        ModalResult:=mrOk;
    end;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Different.Different(des,sou1,sou2:TGraphBuf; colorfill:DWORD; req:single);
var
    tr:TRect;
    sousmex,sousmey,dessmex,dessmey,lenx,leny:integer;
    x,y:integer;
    col:DWORD;
    cr1,cg1,cb1,ca1:single;
    cr2,cg2,cb2,ca2:single;
begin
    tr:=sou1.GetRectIntersect(sou2);

    sousmex:=tr.Left-sou1.FPos.x;
    sousmey:=tr.Top-sou1.FPos.y;
    dessmex:=tr.Left-des.FPos.x;
    dessmey:=tr.Top-des.FPos.y;
    lenx:=tr.Right-tr.Left;
    leny:=tr.Bottom-tr.Top;

    des.FillRect(Rect(0,0,des.FLenX,des.FLenY),colorfill);

    for y:=0 to leny-1 do begin
        for x:=0 to lenx-1 do begin
            col:=PGetDWORD(sou1.PixelBuf(sousmex+x,sousmey+y));
            cr1:=((col) and $ff)/255;
            cg1:=((col shr 8) and $ff)/255;
            cb1:=((col shr 16) and $ff)/255;
            ca1:=((col shr 24) and $ff)/255;

            cr1:=cr1*ca1;
            cg1:=cg1*ca1;
            cb1:=cb1*ca1;

            col:=PGetDWORD(sou2.PixelBuf(dessmex+x,dessmey+y));
            cr2:=((col) and $ff)/255;
            cg2:=((col shr 8) and $ff)/255;
            cb2:=((col shr 16) and $ff)/255;
            ca2:=((col shr 24) and $ff)/255;

            cr2:=cr2*ca2;
            cg2:=cg2*ca2;
            cb2:=cb2*ca2;

            if ((cr1-cr2)*(cr1-cr2)+(cg1-cg2)*(cg1-cg2)+(cb1-cb2)*(cb1-cb2){+(ca1-ca2)*(ca1-ca2)})>req then begin
//                col:=(DWORD(Round(cr2*255))) or (DWORD(Round(cg2*255)) shl 8) or (DWORD(Round(cb2*255)) shl 16) or (DWORD(Round(ca2*255)) shl 24);
                PSet(des.PixelBuf(dessmex+x,dessmey+y),DWORD(col));
            end;
        end;
    end;
end;

end.
