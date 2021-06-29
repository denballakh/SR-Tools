unit Form_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons,GraphUnit, ImgList,Math,Main, Menus,EC_Buf,EC_Str,
  RXCtrls,RxRichEd,EC_BlockPar,comctrls;

var
    ColorParent:DWORD=$0000FF;
    ColorActive:DWORD=$9090FF;
    ColorLinkDefault:DWORD=$00FFFF;
    ColorLinkDefaultArrow:DWORD=0;
    ColorLinkActive:DWORD=$9090FF;
    ColorLinkActiveArrow:DWORD=$9090FF;
    ColorBG:DWORD=0;
    ColorInfo:DWORD=0;
    ColorInfoText:DWORD=$FFFFFF;
    ColorName:DWORD=$FFFFFF;

    CoefLink:integer=15;
const
    MeshSize=10;

    FileID=$22334455;
    PVersion=$00000005;

type
TMode = (mNormal,mRectText,mNewPoint);

type TActionFun = procedure;
// type temp = TSpeedButton;
    
TImageUnit = class(TObject)
    FName:WideString;
    FBitmap:TBitmap;
    Fbh:THandle;
end;

TFormMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PanelDI: TPanel;
    Label1: TLabel;
    LabelPosCursor: TLabel;
    SpeedButtonRectText: TSpeedButton;
    SpeedButtonArrow: TSpeedButton;
    PopupMenuPoint: TPopupMenu;
    SpeedButtonCreatePoint: TSpeedButton;
    SpeedButtonNew: TSpeedButton;
    SpeedButtonLoad: TSpeedButton;
    SpeedButtonSave: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    DI: TPaintBox;
    PanelInfo: TPanel;
    LabelInfo: TLabel;
    RxSpeedButton1: TRxSpeedButton;
    PopupMenuAction: TPopupMenu;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DIMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure DIMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DIMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure SpeedButtonRectTextClick(Sender: TObject);
    procedure SpeedButtonArrowClick(Sender: TObject);
    procedure DIDblClick(Sender: TObject);
    procedure SpeedButtonCreatePointClick(Sender: TObject);
    procedure SpeedButtonNewClick(Sender: TObject);
    procedure SpeedButtonLoadClick(Sender: TObject);
    procedure SpeedButtonSaveClick(Sender: TObject);
    procedure DIPaint(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    FMoveWorld:boolean;
    FMoveWorldLP:TPoint;
    FMove:boolean;
    FMode:TMode;
    FBeginAction:boolean;
    FRectAction:TRect;
    FDblClick:boolean;
    FNewLink:boolean;
    FNewLinkPos:TPoint;
    FNewLinkPoint:TGraphPoint;
    FNewParent:boolean;

    FSize:boolean;
    FSizeMode:DWORD; // 1-left 2-top 4-right 8-bottom

    FProgZag:WideString;
    FCurFileName:WideString;

    procedure DIDraw(cv:TCanvas=nil);

    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure ApplicationDeactivate(Sender: TObject);

    procedure PointCreate(Sender: TObject);

    procedure RunAction(Sender: TObject);

    procedure BuildCaption;
end;

procedure ImageAdd(name:WideString; bm:TBitmap);
procedure ImageClear;
function ImageFind(name:WideString):TImageUnit;
function ImageSize(name:WideString):TPoint;
function GetLinkColor(name1,name2:WideString):TColor;
procedure AddActionMenu(name:WideString; selfun:TActionFun);

procedure RichEditRStyle(obj:TRichEdit; tform:TForm);

var
  FormMain: TFormMain;

  FCfg:TBlockParEC;

  GViewPos: TPoint;
  GCurGraphUnit: TObject;

  GImageList: TList;

implementation

uses Form_RectText,Global;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure ImageAdd(name:WideString; bm:TBitmap);
var
    iu:TImageUnit;
begin
    iu:=TImageUnit.Create;
    iu.FName:=name;
    iu.FBitmap:=bm;
    GImageList.Add(iu);
end;

procedure ImageClear;
var
    iu:TImageUnit;
    i:integer;
begin
    for i:=0 to GImageList.Count-1 do begin
        iu:=GImageList.Items[i];
        iu.FBitmap.Free;
        iu.Free;
    end;
    GImageList.Clear;
end;

function ImageFind(name:WideString):TImageUnit;
var
    iu:TImageUnit;
    i:integer;
begin
    for i:=0 to GImageList.Count-1 do begin
        iu:=GImageList.Items[i];
        if iu.FName=name then begin Result:=iu; Exit; End;
    end;
    raise Exception.Create('ImageFind('+name+')');
end;

function ImageSize(name:WideString):TPoint;
begin
    with ImageFind(name) do begin
        Result.x:=FBitmap.Width;
        Result.y:=FBitmap.Height;
    end;
end;

function GetLinkColor(name1,name2:WideString):TColor;
var
    bp:TBlockParEC;
begin
    name1:=name1+','+name2;
    bp:=FCfg.Block['LinkColor'];

    if bp.Par_Count(name1)<1 then begin Result:=ColorLinkDefault; Exit; end;

    Result:=GetColorEC(bp.Par[name1]);
end;

procedure AddActionMenu(name:WideString; selfun:TActionFun);
var
    mi:TMenuItem;
begin
    mi:=TMenuItem.Create(FormMain);
    mi.AutoHotkeys:=maManual;
    mi.Caption:=name;
    mi.OnClick:=FormMain.RunAction;
    mi.Tag:=DWORD(@selfun);
    FormMain.PopupMenuAction.Items.Add(mi);
end;

procedure TFormMain.RunAction(Sender: TObject);
begin
    TActionFun((Sender as TMenuItem).Tag);
end;

procedure RichEditRStyle(obj:TRichEdit; tform:TForm);
var
    t_SelStart:integer;
    t_SelLength:integer;
    t_Obj:TWinControl;
    t_ReadOnly:boolean;
begin
    t_SelStart:=obj.SelStart;
    t_SelLength:=obj.SelLength;
    t_Obj:=tform.ActiveControl;
    t_ReadOnly:=obj.ReadOnly;

    tform.ActiveControl:=nil;
    obj.ReadOnly:=false;

    obj.SelectAll;
    obj.DefAttributes.Assign(obj.Font);
    obj.SelAttributes.Assign(obj.Font);

    obj.SelStart:=t_SelStart;
    obj.SelLength:=t_SelLength;
    obj.ReadOnly:=t_ReadOnly;
    tform.ActiveControl:=t_Obj;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure TFormMain.FormCreate(Sender: TObject);
var
    tstr:AnsiString;
//    gp:TGraphPoint;
//    gl:TGraphLink;
begin
    FProgZag:=FormMain.Caption;

    BuildCaption;

    Application.OnMessage := AppMessage;
    Application.OnDeactivate:=ApplicationDeactivate;

    FCfg:=TBlockParEC.Create;
    FCfg.LoadFromFile('cfg.txt');

    CoefLink:=StrToIntEC(FCfg.ParPath['CoefLink']);

    ColorBG:=GetColorEC(FCfg.ParPath['ColorBG']);
    ColorParent:=GetColorEC(FCfg.ParPath['ColorParent']);
    ColorActive:=GetColorEC(FCfg.ParPath['ColorActive']);
    ColorInfo:=GetColorEC(FCfg.ParPath['ColorInfo']);
    ColorInfoText:=GetColorEC(FCfg.ParPath['ColorInfoText']);
    ColorName:=GetColorEC(FCfg.ParPath['ColorName']);

    ColorLinkDefault:=GetColorEC(FCfg.ParPath['LinkColor.Default']);
    ColorLinkDefaultArrow:=GetColorEC(FCfg.ParPath['LinkColor.DefaultArrow']);
    ColorLinkActive:=GetColorEC(FCfg.ParPath['LinkColor.Active']);
    ColorLinkActiveArrow:=GetColorEC(FCfg.ParPath['LinkColor.ActiveArrow']);

    PanelDI.Color:=ColorBG;
    PanelInfo.Color:=ColorInfo;
    LabelInfo.Font.Color:=ColorInfoText;

    GImageList:=TList.Create;

    SetLength(tstr,1024);
    ZeroMemory(PChar(tstr),1024);
    if GetModuleFileNameA(0,PChar(tstr),1024)=0 then raise Exception.Create('GetModuleFileNameW');
    GSysWorkDir:=File_Path(Trim(tstr));

    FMode:=mNormal;

    GGraphPoint:=TList.Create;
    GGraphLink:=TList.Create;
    GGraphRectText:=TList.Create;

    GGraphPointInterface:=TList.Create;

    MainInit;

{    gp:=TGraphPoint.Create;
    gp.FPos:=Point(10,10);
    gp.FImageIndex:=0;
    gp.FText:='Star1';
    GGraphPoint.Add(gp);

    gp:=TGraphPoint.Create;
    gp.FPos:=Point(100,50);
    gp.FImageIndex:=0;
    gp.FParent:=GGraphPoint.Items[0];
    gp.FText:='Star2';
    GGraphPoint.Add(gp);

    gp:=TGraphPoint.Create;
    gp.FPos:=Point(-10,20);
    gp.FImageIndex:=1;
    gp.FParent:=GGraphPoint.Items[1];
    gp.FText:='Planet1';
    GGraphPoint.Add(gp);

    gp:=TGraphPoint.Create;
    gp.FPos:=Point(-10,40);
    gp.FImageIndex:=1;
    gp.FParent:=GGraphPoint.Items[1];
    gp.FText:='Planet2';
    GGraphPoint.Add(gp);

    gl:=TGraphLink.Create;
    gl.FBegin:=GGraphPoint.Items[0];
    gl.FEnd:=GGraphPoint.Items[1];
    gl.FNom:=0;
    gl.FArrow:=true;
    GGraphLink.Add(gl);

    gl:=TGraphLink.Create;
    gl.FBegin:=GGraphPoint.Items[1];
    gl.FEnd:=GGraphPoint.Items[0];
    gl.FNom:=1;
    gl.FArrow:=true;
    GGraphLink.Add(gl);}
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
    GGraphPoint.Free; GGraphPoint:=nil;
    GGraphLink.Free; GGraphLink:=nil;
    GGraphRectText.Free; GGraphRectText:=nil;

    GGraphPointInterface.Free; GGraphPointInterface:=nil;

    ImageClear;
    GImageList.Free; GImageList:=nil;

    FCfg.Free; FCfg:=nil;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
//    SetClassLong(PanelDI.Handle,GCL_HBRBACKGROUND,0);
//    SetClassLong(FormMain.Handle,GCL_HBRBACKGROUND,0);

//    PanelDI.ControlStyle := PanelDI.ControlStyle + [ csOpaque ] ;
//    FormMain.ControlStyle := FormMain.ControlStyle + [ csOpaque ] ;
    DI.ControlStyle := DI.ControlStyle + [ csOpaque ] ;

    MainNew;

    DIDraw;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
    DIDraw;
end;

procedure TFormMain.DIDraw(cv:TCanvas);
var
    tp:TPoint;
    gp:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
    i:integer;
    tr:TRect;
    iu:TImageUnit;
//  MaskDC: HDC;
//  Save: THandle;
    ts:TSize;
begin
    if cv=nil then cv:=DI.Canvas;
    cv.Pen.Style:=psSolid;
    cv.Pen.Color:=ColorBG;//RGB(0,0,0);
    cv.Brush.Color:=ColorBG;//RGB(0,0,0);
    cv.Brush.Style:=bsSolid;
    cv.Rectangle(0,0,DI.Width,DI.Height);

    for i:=0 to GGraphRectText.Count-1 do begin
        grt:=GGraphRectText.Items[i];

        grt.Draw(cv,GViewPos);

        if GCurGraphUnit=grt then begin
            cv.Pen.Color:=ColorActive;//RGB(100,50,60);
            cv.Pen.Style:=psSolid;
            tr:=grt.FRect; OffsetRect(tr,-GViewPos.x,-GViewPos.y);

            cv.MoveTo(tr.Left-5,tr.Top+5);
            cv.LineTo(tr.Left-5,tr.Top-5);
            cv.LineTo(tr.Left+5,tr.Top-5);

            cv.MoveTo(tr.Right+5,tr.Bottom-5);
            cv.LineTo(tr.Right+5,tr.Bottom+5);
            cv.LineTo(tr.Right-5,tr.Bottom+5);

            cv.MoveTo(tr.Left-5,tr.Bottom-5);
            cv.LineTo(tr.Left-5,tr.Bottom+5);
            cv.LineTo(tr.Left+5,tr.Bottom+5);

            cv.MoveTo(tr.Right+5,tr.Top+5);
            cv.LineTo(tr.Right+5,tr.Top-5);
            cv.LineTo(tr.Right-5,tr.Top-5);
        end;
    end;

    cv.Font.Assign(PanelDI.Font);

//    DI.Canvas.Pen.Color:=RGB(100,50,60);
{    cv.Pen.Color:=ColorParent;
    cv.Pen.Style:=psSolid;
    if (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) and ((GCurGraphUnit as TGraphPoint).FParent<>nil) then begin
        gp:=GCurGraphUnit as TGraphPoint;
        while gp.FParent<>nil do begin
            tr:=gp.GetRectImage(GViewPos); cv.MoveTo((tr.Left+tr.Right) div 2,(tr.Top+tr.Bottom) div 2);
            tr:=gp.FParent.GetRectImage(GViewPos); cv.LineTo((tr.Left+tr.Right) div 2,(tr.Top+tr.Bottom) div 2);
            gp:=gp.FParent;
        end;
    end;}

//    cv.Pen.Color:=RGB(100,50,60);
    cv.Pen.Color:=ColorActive;
    cv.Font.Color:=clWhite;
    cv.Brush.Style:=bsClear;
    SetBkMode(cv.Handle,TRANSPARENT);

//        Fbh:THandle;
    for i:=0 to GImageList.Count-1 do begin
        iu:=GImageList.Items[i];
        iu.Fbh:=iu.FBitmap.Canvas.Handle;
//        iu.Fbh2:=iu.FBitmap.MaskHandle;
    end;

    cv.Font.Color:=ColorName;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];

        tr:=gp.GetRectImage(GViewPos);

        if GCurGraphUnit=gp then begin
            cv.Rectangle(tr.Left-1,tr.Top-1,tr.Right+1,tr.Bottom+1);
        end;

        iu:=ImageFind(gp.FImage);

//        cv.Draw(tr.Left,tr.Top,iu.FBitmap);
//cv.Handle;
//gp.FImage.Canvas.Handle;

{        StretchBlt(cv.Handle, tr.Left, tr.Top, tr.Right-tr.Left, tr.Bottom-tr.Top,
                   iu.Fbh, 0, 0, tr.Right-tr.Left, tr.Bottom-tr.Top,
                   SRCCOPY);}

        BitBlt(cv.Handle, tr.Left, tr.Top, tr.Right-tr.Left, tr.Bottom-tr.Top,
                   iu.Fbh, 0, 0, SRCCOPY);

{        Save := 0;
        MaskDC := 0;
        try
            MaskDC := CreateCompatibleDC(0);
            Save := SelectObject(MaskDC, iu.Fbh2);
            TransparentStretchBlt(cv.Handle, tr.Left, tr.Top, tr.Right-tr.Left, tr.Bottom-tr.Top,
                   iu.Fbh, 0, 0,tr.Right-tr.Left, tr.Bottom-tr.Top,
                   MaskDC, 0, 0);
        finally
            if Save <> 0 then SelectObject(MaskDC, Save);
            if MaskDC <> 0 then DeleteDC(MaskDC);
        end;}

        if gp.FText<>'' then begin
            ts:=cv.TextExtent(gp.FText);
//            ts.cx:=200; ts.cy:=40;
            gp.FTextRect.Left:=(tr.Right-tr.Left) div 2;
            gp.FTextRect.Right:=gp.FTextRect.Left+ts.cx+10;
            gp.FTextRect.Top:=-ts.cy div 2;
            gp.FTextRect.Bottom:=gp.FTextRect.Top+ts.cy;
        end else begin
            gp.FTextRect:=Rect(0,0,0,0);
        end;

        cv.TextOut(tr.Right+5,(tr.Top+tr.Bottom) div 2-cv.TextHeight(gp.FText) div 2,gp.FText);
    end;

    cv.Brush.Color:=ColorLinkDefaultArrow;//RGB(0,0,0);
    cv.Brush.Style:=bsSolid;
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        cv.Pen.Color:=GetLinkColor(gl.FBegin.ClassName,gl.FEnd.ClassName);
        gl.Calc(GViewPos);
        if GCurGraphUnit<>gl then gl.DrawLine(cv);
    end;
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        cv.Pen.Color:=GetLinkColor(gl.FBegin.ClassName,gl.FEnd.ClassName);
        if GCurGraphUnit<>gl then gl.DrawArrow(cv);
    end;

    if GCurGraphUnit is TGraphLink then begin
        cv.Pen.Color:=ColorLinkActive;//RGB(0,0,255);
        cv.Brush.Color:=ColorLinkActiveArrow;//ColorActiveArrow;//RGB(255,0,0);
        cv.Brush.Style:=bsSolid;

        gl:=GCurGraphUnit as TGraphLink;
        gl.DrawLine(cv);
        gl.DrawArrow(cv);
    end;

    if (FMode=mRectText) and (FBeginAction) and (not FSize) then begin
        cv.Pen.Color:=RGB(255,255,255);
        cv.Brush.Color:=RGB(255,255,255);
        cv.Brush.Style:=bsBDiagonal;

        cv.Rectangle(FRectAction.Left-GViewPos.x,FRectAction.Top-GViewPos.y,FRectAction.Right-GViewPos.x,FRectAction.Bottom-GViewPos.y);
    end;

    if FNewLink then begin
//        cv.Pen.Width:=2;
        cv.Brush.Style:=bsClear;
        cv.Pen.Mode:=pmXor;
        if FNewParent then cv.Pen.Color:=ColorParent
        else cv.Pen.Color:=ColorLinkDefault;
        cv.Pen.Style:=psDot;
        tp:=FNewLinkPoint.WorldPos(GViewPos);
        cv.MoveTo(tp.x,tp.y);
        cv.LineTo(FNewLinkPos.x-GViewPos.x,FNewLinkPos.y-GViewPos.y);
        cv.Pen.Mode:=pmCopy;
//        cv.Pen.Width:=1;
    end;
end;

procedure TFormMain.DIPaint(Sender: TObject);
begin
    DIDraw;
end;

procedure TFormMain.DIMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    gl:TGraphLink;
    gp,gp2:TGraphPoint;
    i,no:integer;
    mi:TMenuItem;
    tp:TPoint;
begin
    PanelInfo.Visible:=false;
    
    if FDblClick then begin
        FDblClick:=false;
        Exit;
    end;
    if (Button=mbRight) and (ssCtrl	in Shift) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphRectText) and (FMode=mRectText) and (not FBeginAction) and (not FSize) and (not FMove) then begin
        FMove:=true;
        FMoveWorldLP:=Point(x,y);

        Screen.Cursor:=crSizeAll;

        PanelDI.OnMouseMove:=DIMouseMove;
        PanelDI.OnMouseUp:=DIMouseUp;

        Mouse.Capture:=PanelDI.Handle;
    end else if (Button=mbRight) {and (not FNewLink)} then begin
        if (GCurGraphUnit=nil) or (GCurGraphUnit is TGraphRectText) or ((GCurGraphUnit is TGraphPoint) and FNewLink) then begin
            FMoveWorld:=true;
            FMoveWorldLP:=Point(x,y);
            Screen.Cursor:=crSizeAll;

            PanelDI.OnMouseMove:=DIMouseMove;
            PanelDI.OnMouseUp:=DIMouseUp;

//            DI.MouseCapture:=true;
            Mouse.Capture:=PanelDI.Handle;
        end else if (GCurGraphUnit is TGraphPoint) and (FMode=mNormal) then begin
            FMove:=true;

            Screen.Cursor:=crSizeAll;

            PanelDI.OnMouseMove:=DIMouseMove;
            PanelDI.OnMouseUp:=DIMouseUp;

            Mouse.Capture:=PanelDI.Handle;
        end;
    end else if (Button=mbLeft) and (FMode=mRectText) and (not FBeginAction) and (not FSize) and (not FMove) then begin
        FRectAction.Left:=GViewPos.x+x;
        FRectAction.Top:=GViewPos.y+y;
        FRectAction.Right:=FRectAction.Left+0;
        FRectAction.Bottom:=FRectAction.Top+0;

        PanelDI.OnMouseMove:=DIMouseMove;
        PanelDI.OnMouseUp:=DIMouseUp;

        Mouse.Capture:=PanelDI.Handle;

        FBeginAction:=true;
        DIDraw;
    end else if (Button=mbLeft) and (FMode=mRectText) and (not FBeginAction) and (FSize) and (not FMove) then begin
        PanelDI.OnMouseMove:=DIMouseMove;
        PanelDI.OnMouseUp:=DIMouseUp;

        Mouse.Capture:=PanelDI.Handle;

        FBeginAction:=true;
        DIDraw;
    end else if (Button=mbLeft) and (FMode=mNormal) and (not FMove) and (not FMoveWorld) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) then begin
        FNewLinkPos:=Point(x+GViewPos.x,y+GViewPos.y);
        FNewLink:=true;
        FNewParent:=ssCtrl in Shift;
        FNewLinkPoint:=GCurGraphUnit as TGraphPoint;

        PanelDI.OnMouseMove:=DIMouseMove;
        PanelDI.OnMouseUp:=DIMouseUp;

        Mouse.Capture:=PanelDI.Handle;

        Screen.Cursor:=crCross;

//        DIDraw;
    end else if (FMode=mNewPoint) and (not FMoveWorld) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphLink) then begin
        if Application.MessageBox('Delete ?','Message',MB_YESNO or MB_ICONQUESTION)=ID_YES then begin
            with GCurGraphUnit as TGraphLink do begin
                gp:=FBegin;
                gp2:=FEnd;
            end;

            GGraphLink.Delete(GGraphLink.IndexOf(GCurGraphUnit));
            GCurGraphUnit.Free;
            GCurGraphUnit:=nil;

            ReNomLink(gp,gp2);

            DIDraw;
        end;
    end else if (FMode=mNewPoint) and (not FMoveWorld) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) then begin
        if Application.MessageBox('Delete ?','Message',MB_YESNO or MB_ICONQUESTION)=ID_YES then begin
            i:=0;
            while i<GGraphLink.Count do begin
                gl:=GGraphLink.Items[i];
                if (gl.FBegin=GCurGraphUnit) or (gl.FEnd=GCurGraphUnit) then begin
                    gl.Free;
                    GGraphLink.Delete(i);
                end else inc(i);
            end;
            for i:=0 to GGraphPoint.Count-1 do begin
                gp:=GGraphPoint.Items[i];
                if gp.FParent=GCurGraphUnit then begin
                    gp.FPos:=gp.WorldPos;
                    gp.FParent:=nil;
                end;
            end;
            MsgDeletePoint(GCurGraphUnit as TGraphPoint);
            GGraphPoint.Delete(GGraphPoint.IndexOf(GCurGraphUnit));
            GCurGraphUnit.Free;
            GCurGraphUnit:=nil;
            DIDraw;
        end;
    end else if (FMode=mNewPoint) and (not FMoveWorld) and (not ((GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint))) then begin
        FMoveWorldLP.x:=Round((x+GViewPos.x)/MeshSize)*MeshSize;
        FMoveWorldLP.y:=Round((y+GViewPos.y)/MeshSize)*MeshSize;

        PopupMenuPoint.Items.Clear;
        no:=TGraphPointInterface(GGraphPointInterface.Items[0]).FGroup;
        for i:=0 to GGraphPointInterface.Count-1 do begin
            if no<>TGraphPointInterface(GGraphPointInterface.Items[i]).FGroup then begin
                mi:=TMenuItem.Create(Self);
                mi.Caption:='-';
                PopupMenuPoint.Items.Add(mi);

                no:=TGraphPointInterface(GGraphPointInterface.Items[i]).FGroup;
            end;
            mi:=TMenuItem.Create(Self);
            mi.Caption:=TGraphPointInterface(GGraphPointInterface.Items[i]).FName;
            mi.Tag:=i;
            mi.OnClick:=PointCreate;
            PopupMenuPoint.Items.Add(mi);
        end;
        tp:=PanelDI.ClientToScreen(Point(x,y));
        PopupMenuPoint.Popup(tp.x,tp.y);
    end;
end;

procedure TFormMain.DIMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    fd:boolean;
    tr:TRect;
    tp:TPoint;
    gp:TGraphPoint;
    gl:TGraphLink;
begin
    PanelInfo.Visible:=false;

    fd:=false;
    if FDblClick then begin
        Exit;
    end;

    if (FMoveWorld or FMove) and (Button=mbRight) then begin
        FMove:=false;
        FMoveWorld:=false;
        if (FMode=mRectText) and FBeginAction and (FSize) then begin
            if ((FSizeMode and 1)=1) and ((FSizeMode and 2)=2) then Screen.Cursor:=crSizeNWSE
            else if ((FSizeMode and 2)=2) and ((FSizeMode and 4)=4) then Screen.Cursor:=crSizeNESW
            else if ((FSizeMode and 4)=4) and ((FSizeMode and 8)=8) then Screen.Cursor:=crSizeNWSE
            else if ((FSizeMode and 8)=8) and ((FSizeMode and 1)=1) then Screen.Cursor:=crSizeNESW
            else if (FSizeMode and 1)=1 then Screen.Cursor:=crSizeWE
            else if (FSizeMode and 2)=2 then Screen.Cursor:=crSizeNS
            else if (FSizeMode and 4)=4 then Screen.Cursor:=crSizeWE
            else if (FSizeMode and 8)=8 then Screen.Cursor:=crSizeNS
            else Screen.Cursor:=crDefault;
        end else if FNewLink then begin
            Screen.Cursor:=crCross;
        end else begin
            Screen.Cursor:=crDefault;
            Mouse.Capture:=0;
            PanelDI.OnMouseMove:=nil;
            PanelDI.OnMouseUp:=nil;
        end;
    end else if (Button=mbLeft) and (FMode=mRectText) and FBeginAction and (not FSize) and (not FMove) then begin
        FBeginAction:=false;
        Mouse.Capture:=0;
        PanelDI.OnMouseMove:=nil;
        PanelDI.OnMouseUp:=nil;
        DIDraw;

        if (abs(FRectAction.Left-FRectAction.Right)>2) and ((abs(FRectAction.Top-FRectAction.Bottom)>2)) then begin

            GCurGraphUnit:=TGraphRectText.Create;
            with GCurGraphUnit as TGraphRectText do begin
                FRect.Left:=min(FRectAction.Left,FRectAction.Right);
                FRect.Top:=min(FRectAction.Top,FRectAction.Bottom);
                FRect.Right:=max(FRectAction.Left,FRectAction.Right);
                FRect.Bottom:=max(FRectAction.Top,FRectAction.Bottom);
            end;
            GGraphRectText.Add(GCurGraphUnit);
            if FormRectText.ShowModal<>mrOk then begin
                GCurGraphUnit.Free;
                GGraphRectText.Delete(GGraphRectText.Count-1);
            end;
            GCurGraphUnit:=nil;

            DIDraw;
        end;
    end else if (Button=mbLeft) and (FMode=mRectText) and FBeginAction and (FSize) and (not FMove) then begin
        FBeginAction:=false;
        Mouse.Capture:=0;
        PanelDI.OnMouseMove:=nil;
        PanelDI.OnMouseUp:=nil;
        DIDraw;
    end else if (Button=mbLeft) and (FMode=mNormal) and FNewLink then begin
        tr.Left:=min(FNewLinkPos.x-GViewPos.x,FNewLinkPoint.WorldPos(GViewPos).x);
        tr.Top:=min(FNewLinkPos.y-GViewPos.y,FNewLinkPoint.WorldPos(GViewPos).y);
        tr.Right:=max(FNewLinkPos.x-GViewPos.x,FNewLinkPoint.WorldPos(GViewPos).x)+1;
        tr.Bottom:=max(FNewLinkPos.y-GViewPos.y,FNewLinkPoint.WorldPos(GViewPos).y)+1;
        InvalidateRect(PanelDI.Handle,@tr,false);

        if (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) and (GCurGraphUnit<>FNewLinkPoint) then begin
            if FNewParent then begin
                tp:=FNewLinkPoint.WorldPos;

                gp:=GCurGraphUnit as TGraphPoint;
                while gp<>nil do begin
                    tp.x:=tp.x-gp.FPos.x;
                    tp.y:=tp.y-gp.FPos.y;
                    gp:=gp.FParent;
                    if gp=FNewLinkPoint then break;
                end;

                if gp=nil then begin
                    FNewLinkPoint.FPos:=tp;
                    FNewLinkPoint.FParent:=GCurGraphUnit as TGraphPoint;
                end;
            end else begin
                gl:=MainCreateLink(FNewLinkPoint,GCurGraphUnit as TGraphPoint);
                if gl<>nil then begin
                    GGraphLink.Add(gl);
                    ReNomLink(FNewLinkPoint,GCurGraphUnit as TGraphPoint);
                end;
            end;
            fd:=true;
        end else if (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) and (GCurGraphUnit=FNewLinkPoint) and FNewParent then begin
            FNewLinkPoint.FPos:=FNewLinkPoint.WorldPos;
            FNewLinkPoint.FParent:=nil;
            fd:=true;
        end;
        FNewParent:=false;
        FNewLink:=false;
        Mouse.Capture:=0;
        PanelDI.OnMouseMove:=nil;
        PanelDI.OnMouseUp:=nil;
        Screen.Cursor:=crDefault;
        if fd then DIDraw;
    end;
end;

procedure TFormMain.DIMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var
    fd:boolean;
    cur,old:TObject;
    gp,gp2:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
    i:integer;
    tr:TRect;
    tp:TPoint;
begin
    fd:=false;

    if FMoveWorld then begin
        if (x<>FMoveWorldLP.x) or (y<>FMoveWorldLP.y) then begin
            ScrollWindowEx(PanelDI.Handle,x-FMoveWorldLP.x, y-FMoveWorldLP.y,nil,nil,0,nil,SW_INVALIDATE);

            GViewPos.x:=GViewPos.x-(x-FMoveWorldLP.x);
            GViewPos.y:=GViewPos.y-(y-FMoveWorldLP.y);
            FMoveWorldLP:=Point(x,y);
//            fd:=true;
        end;
    end else if (FMode=mNormal) and FMove then begin
        tp.x:=Round((x+GViewPos.x)/MeshSize)*MeshSize;
        tp.y:=Round((y+GViewPos.y)/MeshSize)*MeshSize;

        gp:=GCurGraphUnit as TGraphPoint;

        i:=0;
        while i<GGraphPoint.Count do begin
            gp2:=GGraphPoint.Items[i];
            if (gp2.WorldPos.x=tp.x) and (gp2.WorldPos.y=tp.y) then break;
            inc(i);
        end;

        if i>=GGraphPoint.Count then begin
            gp.MoveInvalidRect(PanelDI.Handle,GViewPos);

            gp2:=gp.FParent;
            while gp2<>nil do begin
                tp.x:=tp.x-gp2.FPos.x;
                tp.y:=tp.y-gp2.FPos.y;
                gp2:=gp2.FParent;
            end;

            gp.FPos:=tp;

            gp.MoveInvalidRect(PanelDI.Handle,GViewPos);
//            fd:=true;
        end;
    end else if (FMode=mRectText) and (FBeginAction) and (not FSize) and (not FMove) then begin
        FRectAction.Right:=GViewPos.x+x;
        FRectAction.Bottom:=GViewPos.y+y;
        fd:=true;
    end else if (FMode=mRectText) and (FBeginAction) and (FSize) and (not FMove) then begin
        grt:=GCurGraphUnit as TGraphRectText;
        if (FSizeMode and 1)=1 then begin
            if (GViewPos.x+x)<(grt.FRect.Right-2) then grt.FRect.Left:=GViewPos.x+x;
        end;
        if (FSizeMode and 2)=2 then begin
            if (GViewPos.y+y)<(grt.FRect.Bottom-2) then grt.FRect.Top:=GViewPos.y+y;
        end;
        if (FSizeMode and 4)=4 then begin
            if (GViewPos.x+x)>(grt.FRect.Left+2) then grt.FRect.Right:=GViewPos.x+x;
        end;
        if (FSizeMode and 8)=8 then begin
            if (GViewPos.y+y)>(grt.FRect.Top+2) then grt.FRect.Bottom:=GViewPos.y+y;
        end;
        fd:=true;
    end else if (FMode=mRectText) and FMove then begin
        grt:=GCurGraphUnit as TGraphRectText;
        OffsetRect(grt.FRect,x-FMoveWorldLP.x,y-FMoveWorldLP.y);
        FMoveWorldLP:=Point(x,y);
        fd:=true;
    end else if (FMode=mNormal) and FNewLink then begin
        tr.Left:=min(FNewLinkPos.x-GViewPos.x,FNewLinkPoint.WorldPos(GViewPos).x);
        tr.Top:=min(FNewLinkPos.y-GViewPos.y,FNewLinkPoint.WorldPos(GViewPos).y);
        tr.Right:=max(FNewLinkPos.x-GViewPos.x,FNewLinkPoint.WorldPos(GViewPos).x)+1;
        tr.Bottom:=max(FNewLinkPos.y-GViewPos.y,FNewLinkPoint.WorldPos(GViewPos).y)+1;
        InvalidateRect(PanelDI.Handle,@tr,false);

        FNewLinkPos:=Point(x+GViewPos.x,y+GViewPos.y);

        tr.Left:=min(x,FNewLinkPoint.WorldPos(GViewPos).x);
        tr.Top:=min(y,FNewLinkPoint.WorldPos(GViewPos).y);
        tr.Right:=max(x,FNewLinkPoint.WorldPos(GViewPos).x)+1;
        tr.Bottom:=max(y,FNewLinkPoint.WorldPos(GViewPos).y)+1;
        InvalidateRect(PanelDI.Handle,@tr,false);
//        fd:=true;
    end;

    if (not FMoveWorld) and (not FMove) and (FMode=mRectText) and (not FBeginAction) {and (not FSize)} then begin
        cur:=nil;

        for i:=GGraphRectText.Count-1 downto 0 do begin
            grt:=GGraphRectText.Items[i];
            tr:=grt.FRect;
            OffsetRect(tr,-GViewPos.x,-GViewPos.y);
            if (x>=(tr.Left-2)) and (x<(tr.Left+2)) and (y>=(tr.Top-2)) and (y<(tr.Bottom+2)) then FSizeMode:=FSizeMode or 1
            else FSizeMode:=FSizeMode and (not 1);
            if (x>=(tr.Left-2)) and (x<(tr.Right+2)) and (y>=(tr.Top-2)) and (y<(tr.Top+2)) then FSizeMode:=FSizeMode or 2
            else FSizeMode:=FSizeMode and (not 2);
            if (x>=(tr.Right-2)) and (x<(tr.Right+2)) and (y>=(tr.Top-2)) and (y<(tr.Bottom+2)) then FSizeMode:=FSizeMode or 4
            else FSizeMode:=FSizeMode and (not 4);
            if (x>=(tr.Left-2)) and (x<(tr.Right+2)) and (y>=(tr.Bottom-2)) and (y<(tr.Bottom+2)) then FSizeMode:=FSizeMode or 8
            else FSizeMode:=FSizeMode and (not 8);

            FSize:=FSizeMode<>0;

            if FSize then begin
                cur:=grt;
                break;
            end;
        end;

        if ((FSizeMode and 1)=1) and ((FSizeMode and 2)=2) then Screen.Cursor:=crSizeNWSE
        else if ((FSizeMode and 2)=2) and ((FSizeMode and 4)=4) then Screen.Cursor:=crSizeNESW
        else if ((FSizeMode and 4)=4) and ((FSizeMode and 8)=8) then Screen.Cursor:=crSizeNWSE
        else if ((FSizeMode and 8)=8) and ((FSizeMode and 1)=1) then Screen.Cursor:=crSizeNESW
        else if (FSizeMode and 1)=1 then Screen.Cursor:=crSizeWE
        else if (FSizeMode and 2)=2 then Screen.Cursor:=crSizeNS
        else if (FSizeMode and 4)=4 then Screen.Cursor:=crSizeWE
        else if (FSizeMode and 8)=8 then Screen.Cursor:=crSizeNS
        else Screen.Cursor:=crDefault;

        if (not FSize) then begin
            for i:=GGraphRectText.Count-1 downto 0 do begin
                grt:=GGraphRectText.Items[i];
                if ((x+GViewPos.x)>=grt.FRect.Left) and ((x+GViewPos.x)<grt.FRect.Right) and ((y+GViewPos.y)>=grt.FRect.Top) and ((y+GViewPos.y)<grt.FRect.Bottom) then begin
                    cur:=grt;
                    break;
                end;
            end;
        end;

        if cur<>GCurGraphUnit then begin GCurGraphUnit:=cur; fd:=true; end;
    end else if (not FMove) and (not FMoveWorld) and ((FMode=mNormal) or (FMode=mNewPoint)) then begin
        cur:=nil;

        for i:=0 to GGraphPoint.Count-1 do begin
            gp:=GGraphPoint.Items[i];
            tr:=gp.GetRectImage(GViewPos);
            if (x>=tr.Left) and (x<tr.Right) and (y>=tr.Top) and (y<tr.Bottom) then begin
                cur:=gp;
                break;
            end;
        end;

        if (not FNewLink) and (cur=nil) then begin
            for i:=0 to GGraphLink.Count-1 do begin
                gl:=GGraphLink.Items[i];
                if gl.TestHit(Point(x,y)) then begin
                    cur:=gl;
                    break;
                end;
            end;
        end;

        if cur<>GCurGraphUnit then begin
{            if GCurGraphUnit<>nil then begin
                if GCurGraphUnit is TGraphPoint then begin
                    tr:=(GCurGraphUnit as TGraphPoint).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end else if GCurGraphUnit is TGraphLink then begin
                    tr:=(GCurGraphUnit as TGraphLink).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end;
            end;}

            old:=GCurGraphUnit;
            GCurGraphUnit:=cur;

            if GCurGraphUnit=nil then begin
                PanelInfo.Visible:=false;
            end else if GCurGraphUnit is TGraphPoint then begin
                gp:=(GCurGraphUnit as TGraphPoint);
                LabelInfo.Caption:=gp.Info;
                PanelInfo.AutoSize:=false;
                PanelInfo.Width:=LabelInfo.Width+20;
                PanelInfo.Height:=LabelInfo.Height+20;
                LabelInfo.Left:=10;
                LabelInfo.Top:=10;
                PanelInfo.Visible:=LabelInfo.Caption<>'';

                tp:=gp.WorldPos(GViewPos);
                PanelInfo.Left:=tp.x-PanelInfo.Width div 2;
                PanelInfo.Top:=tp.y+ImageSize(gp.FImage).y;

                if PanelInfo.Left<0 then begin
                    PanelInfo.Left:=0;
                end else if (PanelInfo.Left+PanelInfo.Width)>PanelDI.Width then begin
                    PanelInfo.Left:=PanelDI.Width-PanelInfo.Width;
                end;
                if (PanelInfo.Top+PanelInfo.Height)>PanelDI.Height then begin
                    PanelInfo.Top:=tp.y-ImageSize(gp.FImage).y-PanelInfo.Height;
                end;

            end else if GCurGraphUnit is TGraphLink then begin
                gl:=(GCurGraphUnit as TGraphLink);
                LabelInfo.Caption:=gl.Info;
                PanelInfo.AutoSize:=false;
                PanelInfo.Width:=LabelInfo.Width+20;
                PanelInfo.Height:=LabelInfo.Height+20;
                LabelInfo.Left:=10;
                LabelInfo.Top:=10;
                PanelInfo.Visible:=LabelInfo.Caption<>'';

                tp:=Point(x,y);
                PanelInfo.Left:=tp.x-PanelInfo.Width div 2;
                PanelInfo.Top:=tp.y+20;

                if PanelInfo.Left<0 then begin
                    PanelInfo.Left:=0;
                end else if (PanelInfo.Left+PanelInfo.Width)>PanelDI.Width then begin
                    PanelInfo.Left:=PanelDI.Width-PanelInfo.Width;
                end;
                if (PanelInfo.Top+PanelInfo.Height)>PanelDI.Height then begin
                    PanelInfo.Top:=tp.y-20-PanelInfo.Height;
                end;
            end;

            if old<>nil then begin
                if old is TGraphPoint then begin
                    tr:=(old as TGraphPoint).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end else if old is TGraphLink then begin
                    tr:=(old as TGraphLink).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end;
            end;

            if GCurGraphUnit<>nil then begin
                if GCurGraphUnit is TGraphPoint then begin
                    tr:=(GCurGraphUnit as TGraphPoint).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end else if GCurGraphUnit is TGraphLink then begin
                    tr:=(GCurGraphUnit as TGraphLink).GetUpdateRect(GViewPos);
                    InvalidateRect(PanelDI.Handle,@tr,false);
                end;
            end;

            //fd:=true;
        end;
    end;

    LabelPosCursor.Caption:=IntToStr(x+GViewPos.x)+','+IntToStr(y+GViewPos.y);

    if fd then DIDraw;
end;

procedure TFormMain.DIDblClick(Sender: TObject);
begin
    FDblClick:=true;

    if (FMode=mRectText) and (not FMoveWorld) and (not FMove) and (not FBeginAction) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphRectText) then begin
        FBeginAction:=false;
        if FormRectText.ShowModal=mrAbort then begin
            GGraphRectText.Delete(GGraphRectText.IndexOf(GCurGraphUnit));
            GCurGraphUnit.Free;
            GCurGraphUnit:=nil;
        end;
        DIDraw;
    end else if (FMode=mNormal) and (not FMoveWorld) and (not FMove) and (not FBeginAction) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) then begin
        if (GCurGraphUnit as TGraphPoint).DblClick then begin
            DIDraw;
        end;
    end else if (FMode=mNormal) and (not FMoveWorld) and (not FMove) and (not FBeginAction) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphLink) then begin
        if (GCurGraphUnit as TGraphLink).DblClick then begin
            DIDraw;
        end;
    end;
end;

procedure TFormMain.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
    no,i:integer;
    tp:TPoint;
    mi:TMenuItem;
    gp,gp2:TGraphPoint;
    gl:TGraphLink;
begin
    Handled:=false;

    if Msg.hwnd<>FormMain.Handle then Exit;
    if Msg.message=WM_KEYDOWN then begin
        PanelInfo.Visible:=false;
        if Msg.wParam=VK_PRIOR then begin
            if (FMode=mRectText) and (not FBeginAction) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphRectText) then begin
                no:=GGraphRectText.IndexOf(GCurGraphUnit);
                if no>0 then begin
                    GGraphRectText.Items[no]:=GGraphRectText.Items[no-1];
                    GGraphRectText.Items[no-1]:=GCurGraphUnit;
                    DIDraw;
                end;
            end;
        end else if Msg.wParam=VK_NEXT then begin
            if (FMode=mRectText) and (not FBeginAction) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphRectText) then begin
                no:=GGraphRectText.IndexOf(GCurGraphUnit);
                if no<(GGraphRectText.Count-1) then begin
                    GGraphRectText.Items[no]:=GGraphRectText.Items[no+1];
                    GGraphRectText.Items[no+1]:=GCurGraphUnit;
                    DIDraw;
                end;
            end;
        end else if ((Msg.wParam=VK_INSERT) or (Msg.wParam=VK_SPACE)) and (FMode=mNormal) and (not FMove) and (not FMoveWorld) and (not FNewLink) and (not ((GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint))) then begin
            GetCursorPos(tp);
            tp:=PanelDI.ScreenToClient(tp);
            FMoveWorldLP.x:=Round((tp.x+GViewPos.x)/MeshSize)*MeshSize;
            FMoveWorldLP.y:=Round((tp.y+GViewPos.y)/MeshSize)*MeshSize;

            PopupMenuPoint.Items.Clear;
            no:=TGraphPointInterface(GGraphPointInterface.Items[0]).FGroup;
            for i:=0 to GGraphPointInterface.Count-1 do begin
                if no<>TGraphPointInterface(GGraphPointInterface.Items[i]).FGroup then begin
                    mi:=TMenuItem.Create(Self);
                    mi.Caption:='-';
                    PopupMenuPoint.Items.Add(mi);

                    no:=TGraphPointInterface(GGraphPointInterface.Items[i]).FGroup;
                end;
                mi:=TMenuItem.Create(Self);
                mi.Caption:=TGraphPointInterface(GGraphPointInterface.Items[i]).FName;
                mi.Tag:=i;
                mi.OnClick:=PointCreate;
                PopupMenuPoint.Items.Add(mi);
            end;
            GetCursorPos(tp);
            PopupMenuPoint.Popup(tp.x,tp.y);

        end else if (Msg.wParam=VK_DELETE) and ((FMode=mNormal) or (FMode=mNewPoint)) and (not FMove) and (not FMoveWorld) and (not FNewLink) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphLink) then begin
            if Application.MessageBox('Delete ?','Message',MB_YESNO or MB_ICONQUESTION)=ID_YES then begin
                with GCurGraphUnit as TGraphLink do begin
                    gp:=FBegin;
                    gp2:=FEnd;
                end;

                GGraphLink.Delete(GGraphLink.IndexOf(GCurGraphUnit));
                GCurGraphUnit.Free;
                GCurGraphUnit:=nil;

                ReNomLink(gp,gp2);

                DIDraw;
            end;
        end else if (Msg.wParam=VK_DELETE) and ((FMode=mNormal) or (FMode=mNewPoint)) and (not FMove) and (not FMoveWorld) and (not FNewLink) and (GCurGraphUnit<>nil) and (GCurGraphUnit is TGraphPoint) then begin
            if Application.MessageBox('Delete ?','Message',MB_YESNO or MB_ICONQUESTION)=ID_YES then begin
                i:=0;
                while i<GGraphLink.Count do begin
                    gl:=GGraphLink.Items[i];
                    if (gl.FBegin=GCurGraphUnit) or (gl.FEnd=GCurGraphUnit) then begin
                        gl.Free;
                        GGraphLink.Delete(i);
                    end else inc(i);
                end;
                for i:=0 to GGraphPoint.Count-1 do begin
                    gp:=GGraphPoint.Items[i];
                    if gp.FParent=GCurGraphUnit then begin
                        gp.FPos:=gp.WorldPos;
                        gp.FParent:=nil;
                    end;
                end;
                MsgDeletePoint(GCurGraphUnit as TGraphPoint);
                GGraphPoint.Delete(GGraphPoint.IndexOf(GCurGraphUnit));
                GCurGraphUnit.Free;
                GCurGraphUnit:=nil;
                DIDraw;
            end;
        end else if (Msg.wParam=VK_CONTROL) and (FNewLink) and (not FNewParent) then begin
            FNewParent:=True;
            DIDraw;
        end;
    end else if Msg.message=WM_KEYUP then begin
        if (Msg.wParam=VK_CONTROL) and (FNewLink) and (FNewParent) then begin
            FNewParent:=false;
            DIDraw;
        end;
    end;
end;

procedure TFormMain.PointCreate(Sender: TObject);
var
    no:integer;
    gp:TGraphPoint;
begin
    no:=(Sender as TComponent).Tag;
    gp:=TGraphPointInterface(GGraphPointInterface.Items[no]).NewPoint(FMoveWorldLP);
    GGraphPoint.Add(gp);

    DIDraw;
end;

procedure TFormMain.ApplicationDeactivate(Sender: TObject);
begin
    PanelInfo.Visible:=false;
    if FMoveWorld or FMove or FNewLink then begin
        FNewLink:=false;
        FMove:=false;
        FMoveWorld:=false;
        Screen.Cursor:=crDefault;
        Mouse.Capture:=0;
        PanelDI.OnMouseMove:=nil;
        PanelDI.OnMouseUp:=nil;
        DIDraw;
    end else if (FMode=mRectText) and (FBeginAction or FMove) then begin
        FMove:=false;
        FBeginAction:=false;
        Screen.Cursor:=crDefault;
        Mouse.Capture:=0;
        PanelDI.OnMouseMove:=nil;
        PanelDI.OnMouseUp:=nil;
        DIDraw;
    end;
end;

procedure TFormMain.SpeedButtonArrowClick(Sender: TObject);
begin
    FMode:=mNormal;
    DI.Cursor:=crDefault;
end;

procedure TFormMain.SpeedButtonRectTextClick(Sender: TObject);
begin
    FMode:=mRectText;
    DI.Cursor:=crCross;
end;

procedure TFormMain.SpeedButtonCreatePointClick(Sender: TObject);
begin
    FMode:=mNewPoint;
    DI.Cursor:=crCross;
end;

procedure TFormMain.SpeedButtonNewClick(Sender: TObject);
begin
    if Application.MessageBox('New ?','Message',MB_YESNO or MB_ICONQUESTION)=ID_YES then begin
        AllClear;
        GViewPos:=Point(0,0);
        MainNew;
        DIDraw;

        FCurFileName:='';
        BuildCaption;
    end;
end;

procedure TFormMain.SpeedButtonSaveClick(Sender: TObject);
var
    b:TBufEC;
	sdir:AnsiString;
begin
	sdir:=GetCurrentDir;
    SaveDialog1.InitialDir:=RegUser_GetString('','LastScriptDir','');
    if (FCurFileName='') or ((GetAsyncKeyState(VK_CONTROL) and $8000)=$8000) then begin
        if not SaveDialog1.Execute then Exit;
        FCurFileName:=SaveDialog1.FileName;
    end;
	SetCurrentDir(sdir);
    RegUser_SetString('','LastScriptDir',File_Path(SaveDialog1.FileName));

    GFileVersion:=PVersion;

    b:=TBufEC.Create;
    b.AddDWORD(FileID);
    b.AddDWORD(GFileVersion);
    b.AddInteger(GViewPos.x);
    b.AddInteger(GViewPos.y);

    MainSave(b);

    Save(b);

    b.SaveInFile(PChar(AnsiString(FCurFileName)));
    b.Free;

    BuildCaption;
end;

procedure TFormMain.SpeedButtonLoadClick(Sender: TObject);
var
    b:TBufEC;
	sdir:AnsiString;
begin
	sdir:=GetCurrentDir;
    OpenDialog1.InitialDir:=RegUser_GetString('','LastScriptDir','');
    if not OpenDialog1.Execute then Exit;
	SetCurrentDir(sdir);
    RegUser_SetString('','LastScriptDir',File_Path(OpenDialog1.FileName));

    FCurFileName:=OpenDialog1.FileName;

    AllClear;

    b:=TBufEC.Create;
    b.LoadFromFile(PChar(AnsiString(FCurFileName)));
    b.BPointer:=0;

    if b.GetDWORD<>FileID then raise Exception.Create('Unknown format file');
    GFileVersion:=b.GetDWORD;
    GViewPos.x:=b.GetInteger;
    GViewPos.y:=b.GetInteger;

    MainLoad(b);

    Load(b);
    LoadLink;

    b.Free;

    BuildCaption;

    DIDraw;
end;

procedure TFormMain.BuildCaption;
begin
    if FCurFileName='' then begin
        FormMain.Caption:=FProgZag+' v1.'+IntToStr(PVersion)+'.a';
    end else begin
        FormMain.Caption:=FProgZag+' v1.'+IntToStr(PVersion)+'.a ['+{File_Name(}FCurFileName{)}+']';
    end;
end;

end.

