unit FormMain;

interface

uses
  Math,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,MMSystem,
  Menus, StdCtrls, ExtCtrls, Buttons, Grids,
  GraphBuf,EC_Mem,EC_Str,EC_File,EC_Buf,GR_Rect,GraphBufHist,GraphBufList, SelectLine,
  RXSpin, RXSplit;

const
    crSelectRectNormal=5;
    crSelectRectAdd=6;
    crSelectRectSub=7;

type
  TForm_Main = class(TForm)
    MainMenu1: TMainMenu;
    Open1: TMenuItem;
    MMFile_AddImage: TMenuItem;
    Panel1: TPanel;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    Panel2: TPanel;
    ImageR: TImage;
    SpeedButton1: TSpeedButton;
    Panel3: TPanel;
    SGListHist: TStringGrid;
    OpenDialogFile: TOpenDialog;
    RxSpinEditScale: TRxSpinEdit;
    CBAction: TComboBox;
    Panel4: TPanel;
    Label1: TLabel;
    EditRGBA: TEdit;
    CBTypeShow: TComboBox;
    X: TLabel;
    EditX: TEdit;
    Label2: TLabel;
    EditY: TEdit;
    Label3: TLabel;
    EditSize: TEdit;
    Utilite1: TMenuItem;
    MMFilter_CutOffAlpha: TMenuItem;
    SBBufLeft: TSpeedButton;
    SBBufRight: TSpeedButton;
    LBuf: TLabel;
    PopupMenuBuf: TPopupMenu;
    PopupMenuBufDelCur: TMenuItem;
    PopupMenuBufDelAll: TMenuItem;
    PopupMenuBufClear: TMenuItem;
    Filter1: TMenuItem;
    MMFilter_CorrectImageByAlpha: TMenuItem;
    Label4: TLabel;
    EditPosMouse: TEdit;
    MMFilter_Dithering16bit: TMenuItem;
    N1: TMenuItem;
    MMFile_LoadProject: TMenuItem;
    MMFile_SaveProject: TMenuItem;
    MMFilter_Different: TMenuItem;
    MMFilter_FillAlpha: TMenuItem;
    MMFilter_Operation: TMenuItem;
    Select1: TMenuItem;
    MMSelect_SelectByAlpha: TMenuItem;
    MMSelect_SelectInverse: TMenuItem;
    MMFile_SaveImage: TMenuItem;
    SaveDialogFile: TSaveDialog;
    MMFile_SaveImageWAlpha: TMenuItem;
    Utilite2: TMenuItem;
    MMTools_InfoProject: TMenuItem;
    MMFilter_Indexed8: TMenuItem;
    MMFile_SaveGAI: TMenuItem;
    N2: TMenuItem;
    PopupMenuBufAllImageClear: TMenuItem;
    MMFile_SaveGI: TMenuItem;
    MMFilter_AlphaIndexed8: TMenuItem;
    BuildGAIanim: TMenuItem;
    Splitline1: TMenuItem;
    MMSL_DivX: TMenuItem;
    MMSL_DivY: TMenuItem;
    N3: TMenuItem;
    MMSL_Delete: TMenuItem;
    MMSL_Clear: TMenuItem;
    MMSL_SplitImage: TMenuItem;
    N4: TMenuItem;
    MMSL_UnionLeft: TMenuItem;
    MMSL_UnionRight: TMenuItem;
    MMSL_UnionTop: TMenuItem;
    MMSL_UnionBottom: TMenuItem;
    MMSL_DivForm: TMenuItem;
    MMFile_LoadGAI: TMenuItem;
    OpenDialogGAI: TOpenDialog;
    BuildGAIgroup: TMenuItem;
    MMFilter_Rescale: TMenuItem;
    MMTools_Script: TMenuItem;
    MMFilter_CorrectAlpha: TMenuItem;
    Panel5: TPanel;
    ButtonHistUp: TSpeedButton;
    ButtonHistDown: TSpeedButton;
    ButtonHistCopy: TSpeedButton;
    ButtonHistDel: TSpeedButton;
    ButtonHistDelAll: TSpeedButton;
    CBRenderCur: TCheckBox;
    RxSplitter1: TRxSplitter;
    RxSplitter2: TRxSplitter;
    BuildGAIExanim: TMenuItem;
    CheckBoxPlay: TCheckBox;
    TimerPlay: TTimer;
    EditPlayInterval: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MMFile_AddImageClick(Sender: TObject);
    procedure RxSpinEditScaleChange(Sender: TObject);
    procedure SGListHistSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ImageRMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageRMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageRMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SGListHistMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure CBTypeShowChange(Sender: TObject);
    procedure ButtonHistDelClick(Sender: TObject);
    procedure ButtonHistUpClick(Sender: TObject);
    procedure ButtonHistDownClick(Sender: TObject);
    procedure EditXKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MMFilter_CutOffAlphaClick(Sender: TObject);
    procedure SBBufLeftClick(Sender: TObject);
    procedure SBBufRightClick(Sender: TObject);
    procedure PopupMenuBufDelCurClick(Sender: TObject);
    procedure PopupMenuBufDelAllClick(Sender: TObject);
    procedure PopupMenuBufClearClick(Sender: TObject);
    procedure MMFilter_CorrectImageByAlphaClick(Sender: TObject);
    procedure MMFilter_Dithering16bitClick(Sender: TObject);
    procedure MMFile_SaveProjectClick(Sender: TObject);
    procedure MMFile_LoadProjectClick(Sender: TObject);
    procedure SGListHistSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure CBRenderCurClick(Sender: TObject);
    procedure MMFilter_DifferentClick(Sender: TObject);
    procedure MMFilter_FillAlphaClick(Sender: TObject);
    procedure MMFilter_OperationClick(Sender: TObject);
    procedure ButtonHistCopyClick(Sender: TObject);
    procedure MMSelect_SelectByAlphaClick(Sender: TObject);
    procedure MMSelect_SelectInverseClick(Sender: TObject);
    procedure MMFile_SaveImageClick(Sender: TObject);
    procedure MMFile_SaveImageWAlphaClick(Sender: TObject);
    procedure MMTools_InfoProjectClick(Sender: TObject);
    procedure MMFilter_Indexed8Click(Sender: TObject);
    procedure MMFile_SaveGAIClick(Sender: TObject);
    procedure PopupMenuBufAllImageClearClick(Sender: TObject);
    procedure MMFile_SaveGIClick(Sender: TObject);
    procedure MMFilter_AlphaIndexed8Click(Sender: TObject);
    procedure BuildGAIanimClick(Sender: TObject);
    procedure MMSL_DivXClick(Sender: TObject);
    procedure MMSL_DivYClick(Sender: TObject);
    procedure MMSL_DeleteClick(Sender: TObject);
    procedure MMSL_ClearClick(Sender: TObject);
    procedure MMSL_SplitImageClick(Sender: TObject);
    procedure MMSL_UnionLeftClick(Sender: TObject);
    procedure MMSL_DivFormClick(Sender: TObject);
    procedure MMFile_LoadGAIClick(Sender: TObject);
    procedure ButtonHistDelAllClick(Sender: TObject);
    procedure BuildGAIgroupClick(Sender: TObject);
    procedure MMFilter_RescaleClick(Sender: TObject);
    procedure MMTools_ScriptClick(Sender: TObject);
    procedure MMFilter_CorrectAlphaClick(Sender: TObject);
    procedure BuildGAIExanimClick(Sender: TObject);
    procedure Panel5Resize(Sender: TObject);
    procedure TimerPlayTimer(Sender: TObject);
    procedure EditPlayIntervalChange(Sender: TObject);
  private
    { Private declarations }
  public
    FImagePos:TPoint;
    FImage:TGraphBuf;
    FRectUpdate:TArrayRectGR;
    FScale:integer;

    FSme:TPoint;
    FMouseMove:boolean;
    FMousePos:TPoint;
    FFormModify:boolean;

    FSelectLine:TSelectLine;
    FSelect:boolean;
    FSelectMode:integer; // 0-select 1-select add  2-select sub
    FSelectStart:boolean;
    FSelectRect:TRect;

    FSize:boolean;
    FSizeMode:DWORD; // 1-left 2-top 4-right 8-bottom
    FSizeRect:TRect;

    FSplitLineXCount:integer;
    FSplitLineYCount:integer;
    FSplitLineX:Pointer;
    FSplitLineY:Pointer;
    FSplitLineXCur:integer;
    FSplitLineYCur:integer;
    FSplitLineMove:boolean;
    FSplitLineMode:integer; // 0-none 1-x 2-y

    { Public declarations }
    function PosScreenToWorld(tpos:TPoint):TPoint;
    function PosWorldToScreen(tpos:TPoint):TPoint;
    function PosScreenToImage(tpos:TPoint):TPoint;
    procedure NewScale(tp:TPoint; newsc:integer);
    procedure RenderImage(fall:boolean=false);
    procedure UpdateImage;
    procedure UpdateListHist;
    procedure SGListHistAction(acol,arow:integer; lbutton,rbutton,ctrl:boolean);
    function SelectRectScreen:TRect;
    procedure SelectLineShow;
    procedure SelectLineHide;
    procedure SizeRectShow;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
end;

var
  Form_Main: TForm_Main;

implementation

uses Globals,OImage, FormCorrectImageByAlpha, FormDifferent,
  FormCutOffAlpha, FormFillAlpha, FormOperation, FormSelectAlpha,
  FormInfoProject, FormSaveGAI, FormSaveGI, FormBuildGAIAnim,
  FormSplitLineDiv, FromBuildGAIGroup, FormRescale, FormScript,
  FormCorrectAlpha, FormBuildGAIExAnim;

{$R *.DFM}

procedure TForm_Main.FormCreate(Sender: TObject);
begin
    GlobalsInit;
    GBufList:=TGraphBufList.Create;
    timeBeginPeriod(1);

    FSplitLineXCount:=0;
    FSplitLineYCount:=0;
    FSplitLineXCur:=-1;
    FSplitLineYCur:=-1;

    FScale:=1;
    CBAction.ItemIndex:=0;
    CBTypeShow.ItemIndex:=0;

    FImage:=TGraphBuf.Create;
    GImageSelect:=TGraphBuf.Create;
    FImagePos:=Point(0,0);
    FRectUpdate:=TArrayRectGR.Create;

    FSelectLine:=TSelectLine.Create;

    Application.OnMessage := AppMessage;

    LBuf.Caption:='';

    Screen.Cursors[crSelectRectNormal] := LoadCursor(HInstance, 'CURSORSELECTRECTNORMAL');
    Screen.Cursors[crSelectRectAdd] := LoadCursor(HInstance, 'CURSORSELECTRECTADD');
    Screen.Cursors[crSelectRectSub] := LoadCursor(HInstance, 'CURSORSELECTRECTSUB');

//    ImageR.Canvas.Brush.Color:=clBlack;
//    ImageR.Canvas.FillRect(Rect(0,0,ImageR.Width,ImageR.Height));
{    RenderImage(true);
    UpdateImage;}
end;

procedure TForm_Main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    timeEndPeriod(1);
    GBufList.Free;
    if FSelectLine<>nil then begin FSelectLine.Free; FSelectLine:=nil; end;
    if FImage<>nil then begin FImage.Free; FImage:=nil; end;
    if GImageSelect<>nil then begin GImageSelect.Free; GImageSelect:=nil; end;
    if FRectUpdate<>nil then begin FRectUpdate.Free; FRectUpdate:=nil; end;
end;

procedure TForm_Main.MMFile_AddImageClick(Sender: TObject);
var
    filename:string;
    i,u:integer;
    fi:TFileEC;
    zaggi:SGIZag;
    fgi:boolean;
    bd:TBufEC;
begin
    if FFormModify then Exit;
    OpenDialogFile.DefaultExt:='';
    OpenDialogFile.Filter:='*.png;*.jpg;*.psd;*.bmp;*.gi|*.png;*.jpg;*.psd;*.bmp;*.gi';
    OpenDialogFile.Title:='Add image';

    OpenDialogFile.InitialDir:=RegUser_GetString('','AddImagePath',GetCurrentDir);
    if not OpenDialogFile.Execute then Exit;
    RegUser_SetString('','AddImagePath',File_Path(OpenDialogFile.FileName));

    Screen.Cursor:=crHourglass;

    for i:=0 to OpenDialogFile.Files.Count-1 do begin
        for u:=0 to i do begin
            if CompareStr(OpenDialogFile.Files.Strings[i],OpenDialogFile.Files.Strings[u])<0 then begin
                OpenDialogFile.Files.Exchange(i,u);
            end;
        end;
    end;

    try
        for i:=0 to OpenDialogFile.Files.Count-1 do begin
            filename:=OpenDialogFile.Files.Strings[i];

            fgi:=false;
            fi:=TFileEC.Create;
            fi.Init(filename);
            fi.OpenRead;
            if fi.GetSize>=sizeof(SGIZag) then begin
                fi.Read(@zaggi,sizeof(SGIZag));
                fgi:=(zaggi.id0=Ord('g')) and (zaggi.id1=Ord('i')) and (zaggi.id2=0) and (zaggi.id3=0);
            end;
            fi.Free;

            if fgi then begin
                bd:=TBufEC.Create;
                bd.LoadFromFile(PChar(filename));
                bd.Pointer:=0;
                if zaggi.format=0 then begin
                    GBufList.AddHist.AddBuf.LoadGI_Bitmap(bd);
                    GBufList.CurHist.FSaveFormat:=0;
                end else if zaggi.format=1 then begin
                    GBufList.AddHist.AddBuf.LoadGI_Trans(bd);
                    GBufList.CurHist.FSaveFormat:=1;
                end else if zaggi.format=2 then begin
                    GBufList.AddHist.AddBuf.LoadGI_Alpha(bd);
                    GBufList.CurHist.FSaveFormat:=2;
                end else if zaggi.format=3 then begin
                    GBufList.AddHist.AddBuf.LoadGI_AlphaIndexed8(bd);
                    GBufList.CurHist.FSaveFormat:=3;
                end else if zaggi.format=4 then begin
                    GBufList.AddHist.AddBuf.LoadGI_BitmapPal(bd);
                    GBufList.CurHist.FSaveFormat:=4;
                end else raise Exception.Create('Unknown format.');
                bd.Free;
            end else begin
                GBufList.AddHist.AddBuf.LoadRGBA(filename);
            end;
            GBufList.CurHist.FName:=File_Name(filename);
        end;
    except
        on ex:Exception do ShowMessage(ex.message);
    end;
    RenderImage(true);
    UpdateImage;
    UpdateListHist;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMFile_SaveImageClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    SaveDialogFile.FileName:=GBufList.CurHist.FName;
    SaveDialogFile.DefaultExt:='*.gi';
    SaveDialogFile.Filter:='*.png|*.png|*.gi|*.gi';
    SaveDialogFile.Title:='Save image';

    SaveDialogFile.InitialDir:=RegUser_GetString('','SaveImagePath',GetCurrentDir);
    if not SaveDialogFile.Execute then Exit;
    RegUser_SetString('','SaveImagePath',File_Path(SaveDialogFile.FileName));

    if LowerCase(File_Ext(SaveDialogFile.FileName))='png' then begin
        GBufList.CurHist.CurBuf.WritePNG(SaveDialogFile.FileName);
    end else if LowerCase(File_Ext(SaveDialogFile.FileName))='gi' then begin
        GBufList.CurHist.CurBuf.WriteGI_Alpha(SaveDialogFile.FileName);
    end;
end;

procedure TForm_Main.MMFile_SaveImageWAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    SaveDialogFile.FileName:=GBufList.CurHist.FName;
    SaveDialogFile.DefaultExt:='*.gi';
    SaveDialogFile.Filter:='*.gi|*.gi';
    SaveDialogFile.Title:='Save image';

    SaveDialogFile.InitialDir:=RegUser_GetString('','SaveImagePath',GetCurrentDir);
    if not SaveDialogFile.Execute then Exit;
    RegUser_SetString('','SaveImagePath',File_Path(SaveDialogFile.FileName));

    if LowerCase(File_Ext(SaveDialogFile.FileName))='gi' then begin
        GBufList.CurHist.CurBuf.WriteGI_Trans(SaveDialogFile.FileName);
    end;
end;

procedure TForm_Main.MMFile_SaveGIClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    Form_SaveGI.ShowModal;
end;

procedure TForm_Main.MMFile_SaveGAIClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    Form_SaveGAI.ShowModal;
end;

procedure TForm_Main.MMFile_LoadGAIClick(Sender: TObject);
var
    fi:TFileEC;
    zag:SGAIZag;
    i:integer;
    tsme,tsize:DWORD;
    bdlink:Pointer;
    bd:TBufEC;
    zaggi:PGIZag;
begin
    if FFormModify then Exit;
    
    OpenDialogGAI.InitialDir:=RegUser_GetString('','LoadGAIPath',GetCurrentDir);
    if not OpenDialogGAI.Execute then Exit;
    RegUser_SetString('','LoadGAIPath',File_Path(OpenDialogGAI.FileName));

    Screen.Cursor:=crHourglass;

    GBufList.Clear;

    bd:=TBufEC.Create;

    fi:=TFileEC.Create;
    fi.Init(OpenDialogGAI.FileName);
    fi.OpenRead;

    fi.Read(@zag,sizeof(SGAIZag));

    bdlink:=AllocEC(zag.count*8);
    fi.Read(bdlink,zag.count*8);

    for i:=0 to zag.count-1 do begin
        tsme:=PGetDWORD(PAdd(bdlink,i*8+0));
        tsize:=PGetDWORD(PAdd(bdlink,i*8+4));

        fi.SetPointer(tsme);
        bd.Len:=tsize;
        fi.Read(bd.Buf,tsize);
        bd.UnCompress;
        bd.Pointer:=0;

        zaggi:=bd.Buf;

        if zaggi.format=0 then begin
            GBufList.AddHist.AddBuf.LoadGI_Bitmap(bd);
            GBufList.CurHist.FSaveFormat:=0;
        end else if zaggi.format=1 then begin
            GBufList.AddHist.AddBuf.LoadGI_Trans(bd);
            GBufList.CurHist.FSaveFormat:=1;
        end else if zaggi.format=2 then begin
            GBufList.AddHist.AddBuf.LoadGI_Alpha(bd);
            GBufList.CurHist.FSaveFormat:=2;
        end else if zaggi.format=3 then begin
            GBufList.AddHist.AddBuf.LoadGI_AlphaIndexed8(bd);
            GBufList.CurHist.FSaveFormat:=3;
        end else if zaggi.format=4 then begin
            GBufList.AddHist.AddBuf.LoadGI_BitmapPal(bd);
            GBufList.CurHist.FSaveFormat:=4;
        end else raise Exception.Create('Unknown format.');
        GBufList.CurHist.FName:='img_'+IntToStr(i);
    end;

    Form_SaveGAI.ComboBoxFormat.ItemIndex:=5;
    for i:=0 to Form_SaveGAI.StringGridAnim.RowCount-1 do begin
        Form_SaveGAI.StringGridAnim.Cells[0,i]:='';
        Form_SaveGAI.StringGridAnim.Cells[1,i]:='';
    end;
    if zag.smeAnim>0 then begin
        fi.SetPointer(zag.smeAnim);
        bd.Len:=zag.sizeAnim;
        fi.Read(bd.Buf,zag.sizeAnim);
        bd.Pointer:=0;
        Form_SaveGAI.LoadAnim(Form_SaveGAI.StringGridAnim,bd);
    end;

    FreeEC(bdlink);
    fi.Free;
    bd.Free;

    RenderImage(true);
    UpdateImage;
    UpdateListHist;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMFile_LoadProjectClick(Sender: TObject);
var
    tb:TBufEC;
    i,cnti,u,cntu:integer;
    th:TGraphBufHist;
    gb:TGraphBuf;
    i_channels,i_lenx,i_leny,i_lenline:integer;
begin
    if FFormModify then Exit;
    OpenDialogFile.DefaultExt:='*.pwi';
    OpenDialogFile.Filter:='*.pwi|*.pwi';
    OpenDialogFile.Title:='Load project';

    OpenDialogFile.InitialDir:=RegUser_GetString('','LoadProjectPath',GetCurrentDir);
    if not OpenDialogFile.Execute then Exit;
    RegUser_SetString('','LoadProjectPath',File_Path(OpenDialogFile.FileName));

    Screen.Cursor:=crHourglass;

    GBufList.Clear;

    tb:=TBufEC.Create;
    tb.LoadFromFile(PChar(OpenDialogFile.FileName));
    tb.UnCompress;

    cnti:=tb.GetInteger;
    for i:=0 to cnti-1 do begin
        th:=GBufList.AddHist;
        th.FMR:=tb.GetDWORD;
        th.FMG:=tb.GetDWORD;
        th.FMB:=tb.GetDWORD;
        th.FMA:=tb.GetDWORD;
        th.FName:=tb.GetWideStr;
        cntu:=tb.GetInteger;
        for u:=0 to cntu-1 do begin
            i_channels:=tb.GetInteger;
            i_lenx:=tb.GetInteger;
            i_leny:=tb.GetInteger;
            i_lenline:=tb.GetInteger;
            gb:=th.AddBuf;
            gb.ImageCreate(i_lenx,i_leny,i_channels,i_lenline);
            gb.FPos.x:=tb.GetInteger;
            gb.FPos.y:=tb.GetInteger;
            tb.Get(gb.FBuf,gb.FLenLine*gb.FLenY);
        end;
        th.FCur:=tb.GetInteger;
    end;
    GBufList.FCur:=tb.GetInteger;

    tb.Free;

    RenderImage(true);
    UpdateImage;
    UpdateListHist;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMFile_SaveProjectClick(Sender: TObject);
var
    tb:TBufEC;
    i,u:integer;
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    SaveDialogFile.DefaultExt:='*.pwi';
    SaveDialogFile.Filter:='*.pwi|*.pwi';
    SaveDialogFile.Title:='Save project';

    SaveDialogFile.InitialDir:=RegUser_GetString('','SaveProjectPath',GetCurrentDir);
    if not SaveDialogFile.Execute then Exit;
    RegUser_SetString('','SaveProjectPath',File_Path(SaveDialogFile.FileName));

    Screen.Cursor:=crHourglass;

    tb:=TBufEC.Create;

    tb.AddInteger(GBufList.Count);
    for i:=0 to GBufList.Count-1 do begin
        tb.AddDWORD(GBufList.Hist[i].FMR);
        tb.AddDWORD(GBufList.Hist[i].FMG);
        tb.AddDWORD(GBufList.Hist[i].FMB);
        tb.AddDWORD(GBufList.Hist[i].FMA);
        tb.Add(GBufList.Hist[i].FName);
        tb.AddInteger(GBufList.Hist[i].Count);
        for u:=0 to GBufList.Hist[i].Count-1 do begin
            tb.AddInteger(GBufList.Hist[i].Buf[u].FChannels);
            tb.AddInteger(GBufList.Hist[i].Buf[u].FLenX);
            tb.AddInteger(GBufList.Hist[i].Buf[u].FLenY);
            tb.AddInteger(GBufList.Hist[i].Buf[u].FLenLine);
            tb.AddInteger(GBufList.Hist[i].Buf[u].FPos.x);
            tb.AddInteger(GBufList.Hist[i].Buf[u].FPos.y);
            tb.Add(GBufList.Hist[i].Buf[u].FBuf,GBufList.Hist[i].Buf[u].FLenY*GBufList.Hist[i].Buf[u].FLenLine);
        end;
        tb.AddInteger(GBufList.Hist[i].FCur);
    end;
    tb.AddInteger(GBufList.FCur);

    tb.Compress(true);
    tb.SaveInFile(PChar(SaveDialogFile.FileName));

    Screen.Cursor:=crDefault;
end;

function TForm_Main.PosScreenToWorld(tpos:TPoint):TPoint;
begin
    Result.x:=Floor(tpos.x/FScale-FSme.x);
    Result.y:=Floor(tpos.y/FScale-FSme.y);
end;

function TForm_Main.PosWorldToScreen(tpos:TPoint):TPoint;
begin
    Result.x:=(tpos.x+FSme.x)*FScale;
    Result.y:=(tpos.y+FSme.y)*FScale;
end;

function TForm_Main.PosScreenToImage(tpos:TPoint):TPoint;
begin
    tpos:=PosScreenToWorld(tpos);
    Result.x:=tpos.x-FImagePos.x;
    Result.y:=tpos.y-FImagePos.y;
end;

procedure TForm_Main.NewScale(tp:TPoint; newsc:integer);
var
    tp2:TPoint;
begin
    tp2:=PosScreenToWorld(tp);
    FScale:=newsc;

    FSme.x:=Floor(tp.x/FScale)-tp2.x;
    FSme.y:=Floor(tp.y/FScale)-tp2.y;
end;

procedure TForm_Main.RenderImage(fall:boolean=false);
var
    rc,rc1,rc2:TRect;
    ff:boolean;
    i:integer;
//    tp:TPoint;
    rgr:TRectGR;
begin
    ff:=true;
    for i:=0 to GBufList.Count-1 do begin
        rc2.Left:=GBufList.Hist[i].CurBuf.FPos.x;
        rc2.Top:=GBufList.Hist[i].CurBuf.FPos.y;
        rc2.Right:=rc2.Left+GBufList.Hist[i].CurBuf.FLenX;
        rc2.Bottom:=rc2.Top+GBufList.Hist[i].CurBuf.FLenY;
        if ff then begin
            ff:=false;
            rc:=rc2;
        end else begin
            UnionRect(rc1,rc,rc2);
            rc:=rc1;
        end;
    end;
    if ff then begin
        rc.Left:=0;
        rc.Top:=0;
        rc.Right:=0;
        rc.Bottom:=0;
    end;

    FImagePos.x:=rc.Left;
    FImagePos.y:=rc.Top;

    if ((rc.Right-rc.Left)<=0) or ((rc.Bottom-rc.Top)<=0) then begin
        FImage.Clear;
        Exit;
    end;
    if (FImage.FLenX<>(rc.Right-rc.Left)) or (FImage.FLenY<>(rc.Bottom-rc.Top)) then begin
        FImage.ImageCreate(rc.Right-rc.Left,rc.Bottom-rc.Top,4);
        fall:=true;
    end;
{    if (FImageSelect.FLenX=0) or (FImageSelect.FLenY=0) then begin
        FImageSelect.ImageCreate(rc.Right-rc.Left,rc.Bottom-rc.Top,1);
        FImageSelect.FillZero;
    end else if (FImageSelect.FLenX<>(rc.Right-rc.Left)) or (FImageSelect.FLenY<>(rc.Bottom-rc.Top)) then begin
    end;}

{    tp.x:=-FImagePos.x;
    tp.y:=-FImagePos.y;
    rc.Left:=0;
    rc.Top:=0;
    rc.Right:=FImage.FLenX;
    rc.Bottom:=FImage.FLenY;

    if fall then begin
        FImage.FillZero;
        if CBRenderCur.Checked then begin
            GBufList.CurHist.CurBuf.Draw(FImage,tp,rc,GBufList.CurHist.FMR,GBufList.CurHist.FMG,GBufList.CurHist.FMB,GBufList.CurHist.FMA);
        end else begin
            for i:=0 to GBufList.Count-1 do begin
                GBufList.Hist[i].CurBuf.Draw(FImage,tp,rc,GBufList.Hist[i].FMR,GBufList.Hist[i].FMG,GBufList.Hist[i].FMB,GBufList.Hist[i].FMA);
            end;
        end;
    end else begin
        rgr:=FRectUpdate.m_First;
        while rgr<>nil do begin
            if IntersectRect(rc1,rc,rgr.m_R) then begin
                FImage.FillZeroRect(rc1);
                if CBRenderCur.Checked then begin
                    GBufList.CurHist.CurBuf.Draw(FImage,tp,rc1,GBufList.CurHist.FMR,GBufList.CurHist.FMG,GBufList.CurHist.FMB,GBufList.CurHist.FMA);
                end else begin
                    for i:=0 to GBufList.Count-1 do begin
                        GBufList.Hist[i].CurBuf.Draw(FImage,tp,rc1,GBufList.Hist[i].FMR,GBufList.Hist[i].FMG,GBufList.Hist[i].FMB,GBufList.Hist[i].FMA);
                    end;
                end;
            end;
            rgr:=rgr.m_Next;
        end;
    end;}

    FImage.FPos:=FImagePos;

    if fall then begin
        FImage.FillZero;
        if CBRenderCur.Checked then begin
            if IntersectRect(rc1,FImage.GetRect,GBufList.CurHist.CurBuf.GetRect) then begin
                GBufList.CurHist.CurBuf.Draw(FImage,FImage.PosWorldToBuf(rc1.TopLeft),GBufList.CurHist.CurBuf.RectWorldToBuf(rc1),GBufList.CurHist.FMR,GBufList.CurHist.FMG,GBufList.CurHist.FMB,GBufList.CurHist.FMA);
            end;
        end else begin
            for i:=0 to GBufList.Count-1 do begin
                if IntersectRect(rc1,FImage.GetRect,GBufList.Hist[i].CurBuf.GetRect) then begin
                    GBufList.Hist[i].CurBuf.Draw(FImage,FImage.PosWorldToBuf(rc1.TopLeft),GBufList.Hist[i].CurBuf.RectWorldToBuf(rc1),GBufList.Hist[i].FMR,GBufList.Hist[i].FMG,GBufList.Hist[i].FMB,GBufList.Hist[i].FMA);
                end;
            end;
        end;
    end else begin
        rgr:=FRectUpdate.m_First;
        while rgr<>nil do begin
            if IntersectRect(rc,FImage.GetRect,rgr.m_R) then begin
                FImage.FillZeroRect(FImage.RectWorldToBuf(rc));
                if CBRenderCur.Checked then begin
                    if IntersectRect(rc1,rc,GBufList.CurHist.CurBuf.GetRect) then begin
                        GBufList.CurHist.CurBuf.Draw(FImage,FImage.PosWorldToBuf(rc1.TopLeft),GBufList.CurHist.CurBuf.RectWorldToBuf(rc1),GBufList.CurHist.FMR,GBufList.CurHist.FMG,GBufList.CurHist.FMB,GBufList.CurHist.FMA);
                    end;
                end else begin
                    for i:=0 to GBufList.Count-1 do begin
                        if IntersectRect(rc1,rc,GBufList.Hist[i].CurBuf.GetRect) then begin
                            GBufList.Hist[i].CurBuf.Draw(FImage,FImage.PosWorldToBuf(rc1.TopLeft),GBufList.Hist[i].CurBuf.RectWorldToBuf(rc1),GBufList.Hist[i].FMR,GBufList.Hist[i].FMG,GBufList.Hist[i].FMB,GBufList.Hist[i].FMA);
                        end;
                    end;
                end;
            end;
            rgr:=rgr.m_Next;
        end;
    end;

    FRectUpdate.Clear;
end;

procedure TForm_Main.UpdateImage;
var
    gb:TGraphBuf;
    i:integer;
    rc,rc1,rc2:TRect;
    bm:TBitmap;
    x,y,lx,ly:integer;
//    time1:int64;
begin
//    time1:=HTimer;

    gb:=TGraphBuf.Create;
    gb.ImageCreate(ceil(ImageR.Width/FScale)*FScale,ceil(ImageR.Height/FScale)*FScale,2);
    gb.FillZero;

    rc1.Left:=Floor((-FSme.x-FImagePos.x){/scale});
    rc1.Top:=Floor((-FSme.y-FImagePos.y){/scale});
    rc1.Right:=rc1.Left+Floor(gb.FLenX/FScale);
    rc1.Bottom:=rc1.Top+Floor(gb.FLenY/FScale);

    rc2.Left:=0;
    rc2.Top:=0;
    rc2.Right:=rc2.Left+FImage.FLenX;
    rc2.Bottom:=rc2.Top+FImage.FLenY;

    if IntersectRect(rc,rc1,rc2) then begin
        rc1.Left:=max(0,(FSme.x+FImagePos.x)*FScale);
        rc1.Top:=max(0,(FSme.y+FImagePos.y)*FScale);
        rc1.Right:=rc1.Left+(rc.Right-rc.Left)*FScale;
        rc1.Bottom:=rc1.Top+(rc.Bottom-rc.Top)*FScale;
        FImage.EndScale(rc,rc1,gb,CBTypeShow.ItemIndex);
    end;

    bm:=TBitmap.Create;
    bm.HandleType:=bmDDB;
    bm.PixelFormat:=pf16bit;
    bm.Width:=gb.FLenX;
    bm.Height:=gb.FLenY;
    bm.Transparent:=false;
    bm.IgnorePalette:=true;

    for i:=0 to gb.FLenY-1 do begin
        CopyMemory(bm.ScanLine[i],PAdd(gb.FBuf,i*gb.FLenLine),gb.FLenLine);
    end;

    ImageR.Canvas.CopyMode:=cmSrcCopy;
    ImageR.Canvas.Draw(0,0,bm);

    if GBufList.Count>0 then begin
        x:=(GBufList.CurHist.CurBuf.FPos.x+FSme.x)*FScale;
        y:=(GBufList.CurHist.CurBuf.FPos.y+FSme.y)*FScale;
        lx:=GBufList.CurHist.CurBuf.FLenX*FScale;
        ly:=GBufList.CurHist.CurBuf.FLenY*FScale;
        ImageR.Canvas.Pen.Mode:=pmCopy;
        ImageR.Canvas.Pen.Style:=psSolid;
        ImageR.Canvas.Pen.Color:=clRed;
        ImageR.Canvas.MoveTo(x-1,y-1);
        ImageR.Canvas.LineTo(x+lx,y-1);
        ImageR.Canvas.LineTo(x+lx,y+ly);
        ImageR.Canvas.LineTo(x-1,y+ly);
        ImageR.Canvas.LineTo(x-1,y-1);

        EditX.Text:=IntToStr(GBufList.CurHist.CurBuf.FPos.x);
        EditY.Text:=IntToStr(GBufList.CurHist.CurBuf.FPos.y);
        EditSize.Text:=IntToStr(GBufList.CurHist.CurBuf.FLenX)+','+IntToStr(GBufList.CurHist.CurBuf.FLenY);

        LBuf.Caption:=IntToStr(GBufList.CurHist.FCur+1)+'/'+IntToStr(GBufList.CurHist.Count);
    end else begin
        LBuf.Caption:='0/0';
    end;
    SelectLineShow;

    ImageR.Canvas.Pen.Mode:=pmCopy;
    ImageR.Canvas.Pen.Style:=psSolid;
    ImageR.Canvas.Pen.Color:=clBlue;
    for i:=0 to FSplitLineXCount-1 do begin
        x:=(PGetInteger(PAdd(FSplitLineX,i*4))+FSme.x)*FScale;
        if i<>FSplitLineXCur then ImageR.Canvas.Pen.Color:=clBlue
        else ImageR.Canvas.Pen.Color:=RGB(170,170,255);
        ImageR.Canvas.MoveTo(x,0);
        ImageR.Canvas.LineTo(x,ImageR.Height);
    end;
    for i:=0 to FSplitLineYCount-1 do begin
        y:=(PGetInteger(PAdd(FSplitLineY,i*4))+FSme.y)*FScale;
        if i<>FSplitLineYCur then ImageR.Canvas.Pen.Color:=clBlue
        else ImageR.Canvas.Pen.Color:=RGB(170,170,255);
        ImageR.Canvas.MoveTo(0,y);
        ImageR.Canvas.LineTo(ImageR.Width,y);
    end;

    ImageR.Update;

    bm.Free;
    gb.Free;

//    Edit1.Text:=FloatToStr((HTimer-time1)/GHTimerFreq);
end;

procedure TForm_Main.UpdateListHist;
var
    i:integer;
    s:string;
begin
    if (SGListHist.ColCount<6) or (SGListHist.RowCount<1) then begin
        SGListHist.ColCount:=6;
        SGListHist.RowCount:=GBufList.Count;

        Panel5Resize(nil);
    end;

    SGListHist.ColCount:=6;
    SGListHist.RowCount:=GBufList.Count;

    for i:=0 to GBufList.Count-1 do begin
        SGListHist.RowHeights[i]:=18;

        SGListHist.Cells[0,i]:=GBufList.Hist[i].FName;

        if (GBufList.Hist[i].FMR and 1)=1 then s:='r' else s:='-';
        if (GBufList.Hist[i].FMR and 2)=2 then s:=s+'a' else s:=s+'-';
        SGListHist.Cells[1,i]:=s;

        if (GBufList.Hist[i].FMG and 1)=1 then s:='g' else s:='-';
        if (GBufList.Hist[i].FMG and 2)=2 then s:=s+'a' else s:=s+'-';
        SGListHist.Cells[2,i]:=s;

        if (GBufList.Hist[i].FMB and 1)=1 then s:='b' else s:='-';
        if (GBufList.Hist[i].FMB and 2)=2 then s:=s+'a' else s:=s+'-';
        SGListHist.Cells[3,i]:=s;

        if (GBufList.Hist[i].FMA and 1)=1 then s:='a' else s:='-';
        if (GBufList.Hist[i].FMA and 2)=2 then s:=s+'a' else s:=s+'-';
        SGListHist.Cells[4,i]:=s;


        if GBufList.Hist[i].FSaveFormat=0 then s:='   bm'
        else if GBufList.Hist[i].FSaveFormat=1 then s:='   tr'
        else if GBufList.Hist[i].FSaveFormat=2 then s:='   al'
        else if GBufList.Hist[i].FSaveFormat=3 then s:='   ia'
        else if GBufList.Hist[i].FSaveFormat=4 then s:='   ib'
        else s:='';
        SGListHist.Cells[5,i]:=s;
    end;

    if GBufList.Count>0 then begin
        SGListHist.Row:=GBufList.FCur;
    end else begin
        SGListHist.RowCount:=1;
        SGListHist.RowHeights[0]:=0;
    end;
end;

procedure TForm_Main.RxSpinEditScaleChange(Sender: TObject);
begin
    if Round(RxSpinEditScale.Value)<>FScale then begin
        NewScale(Point(ImageR.Width div 2,ImageR.Height div 2),Round(RxSpinEditScale.Value));
        UpdateImage;
    end;
end;

procedure TForm_Main.SGListHistAction(acol,arow:integer; lbutton,rbutton,ctrl:boolean);
var
    fu,fr:boolean;
    tmask:DWORD;
begin
    fu:=false;
    fr:=false;
    if GBufList.FCur<>ARow then begin
        GBufList.FCur:=ARow;
        fu:=true
    end;

    tmask:=3;
    if ACol=1 then begin tmask:=GBufList.Hist[ARow].FMR; fr:=true; end
    else if ACol=2 then begin tmask:=GBufList.Hist[ARow].FMG; fr:=true; end
    else if ACol=3 then begin tmask:=GBufList.Hist[ARow].FMB; fr:=true; end
    else if ACol=4 then begin tmask:=GBufList.Hist[ARow].FMA; fr:=true; end;

    if lbutton then begin
        tmask:=tmask xor 1;
    end;
    if rbutton then begin
        tmask:=tmask xor 2;
    end;

    if (ACol>=1) and (ACol<=3) then begin
        if not ctrl then begin
            if ACol=1 then GBufList.Hist[ARow].FMR:=tmask
            else if ACol=2 then GBufList.Hist[ARow].FMG:=tmask
            else if ACol=3 then GBufList.Hist[ARow].FMB:=tmask;
        end else begin
            GBufList.Hist[ARow].FMR:=tmask;
            GBufList.Hist[ARow].FMG:=tmask;
            GBufList.Hist[ARow].FMB:=tmask;
        end;
    end else if ACol=4 then begin
        if not ctrl then begin
            GBufList.Hist[ARow].FMA:=tmask;
        end else begin
            GBufList.Hist[ARow].FMR:=tmask;
            GBufList.Hist[ARow].FMG:=tmask;
            GBufList.Hist[ARow].FMB:=tmask;
            GBufList.Hist[ARow].FMA:=tmask;
        end;
    end else if ACol=5 then begin
        inc(GBufList.Hist[ARow].FSaveFormat);
        if GBufList.Hist[ARow].FSaveFormat>4 then GBufList.Hist[ARow].FSaveFormat:=0;
        UpdateListHist;
        Exit;
    end;

    if fr then begin
        FRectUpdate.TestAdd(GBufList.Hist[arow].CurBuf.GetRect);
        RenderImage;
    end;
    if fr or fu then begin
        UpdateImage;
        UpdateListHist;
    end;
end;

procedure TForm_Main.SGListHistSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    CanSelect:=false;
    if GBufList.Count<1 then Exit;
    if ACol=0 then CanSelect:=true;
//    SGListHistAction(ACol,ARow,(GetAsyncKeyState(VK_LBUTTON) and $8000)=$8000,(GetAsyncKeyState(VK_RBUTTON) and $8000)=$8000,(GetAsyncKeyState(VK_CONTROL) and $8000)=$8000);
end;

procedure TForm_Main.SGListHistMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    acol,arow:integer;
begin
    SGListHist.MouseToCell(x,y,acol,arow);

    if (acol>=0) and (arow>=0) then begin
        SGListHistAction(acol,arow,ssLeft in Shift,ssRight in Shift,(GetAsyncKeyState(VK_CONTROL) and $8000)=$8000);
        if CBRenderCur.Checked then begin
            RenderImage(true);
            UpdateImage;
        end;
    end;
end;

procedure TForm_Main.ImageRMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    tp:TPoint;
    i,tx,ty:integer;
begin
    if (FSelect=true) or (FSize=true) then Exit;

    FMouseMove:=true;
    FMousePos:=Point(x,y);

//    ImageR.MouseCapture:=true;

    if (not FFormModify) and (FSplitLineMode<>0) and (not (ssRight in Shift)) then begin
        tp:=PosScreenToWorld(Point(x,y));
        FSplitLineXCur:=-1;
        FSplitLineYCur:=-1;
        if FSplitLineMode=1 then begin
            for i:=0 to FSplitLineXCount-1 do begin
                tx:=PGetInteger(PAdd(FSplitLineX,i*4));
                if tp.x=tx then begin
                    FSplitLineXCur:=i;
                    break;
                end;
            end;
        end else if FSplitLineMode=2 then begin
            for i:=0 to FSplitLineYCount-1 do begin
                ty:=PGetInteger(PAdd(FSplitLineY,i*4));
                if tp.y=ty then begin
                    FSplitLineYCur:=i;
                    break;
                end;
            end;
        end;
        if (FSplitLineXCur<0) and (FSplitLineYCur<0) then begin
            FSplitLineMode:=0;
            FSplitLineMove:=false;
        end else begin
            FSplitLineMove:=true;
        end;
        UpdateImage;
    end else if (ssLeft in Shift) and (FSizeMode<>0) and (not FFormModify) then begin
        FSize:=true;
        FSizeRect.TopLeft:=GBufList.CurHist.CurBuf.FPos;
        FSizeRect.Right:=FSizeRect.Left+GBufList.CurHist.CurBuf.FLenX;
        FSizeRect.Bottom:=FSizeRect.Top+GBufList.CurHist.CurBuf.FLenY;

        SizeRectShow;
    end else if (ssLeft in Shift) and (not ((ssShift in Shift) and (ssCtrl in Shift))) and (not FFormModify) then begin
        if ssShift in Shift then FSelectMode:=1
        else if ssCtrl in Shift then FSelectMode:=2
        else FSelectMode:=0;
        if FSelectMode=0 then Screen.Cursor:=crSelectRectNormal
        else if FSelectMode=1 then Screen.Cursor:=crSelectRectAdd
        else if FSelectMode=2 then Screen.Cursor:=crSelectRectSub;
        FSelect:=true;
        FSelectStart:=false;

        FSelectRect.Left:=PosScreenToWorld(FMousePos).x;
        FSelectRect.Top:=PosScreenToWorld(FMousePos).y;
        FSelectRect.Right:=FSelectRect.Left;
        FSelectRect.Bottom:=FSelectRect.Top;
    end else begin
        Screen.Cursor:=crSizeAll;
    end;
end;

procedure TForm_Main.ImageRMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    tp:TPoint;
    tr,tr2:TRect;
    gb:TGraphBuf;
    gbrect:TRect;
begin
    FMouseMove:=false;
    Screen.Cursor:=crDefault;

    FSplitLineMove:=false;

    if FSize then begin
        SizeRectShow;

        if (FSizeRect.Left<>GBufList.CurHist.CurBuf.FPos.x) or
           (FSizeRect.Top<>GBufList.CurHist.CurBuf.FPos.y) or
           ((FSizeRect.Right-FSizeRect.Left)<>GBufList.CurHist.CurBuf.FLenX) or
           ((FSizeRect.Bottom-FSizeRect.Top)<>GBufList.CurHist.CurBuf.FLenY) then begin

            GBufList.CurHist.NewModify;
            GBufList.CurHist.CurBuf.FPos:=FSizeRect.TopLeft;
            GBufList.CurHist.CurBuf.ImageCreate(FSizeRect.Right-FSizeRect.Left,FSizeRect.Bottom-FSizeRect.Top,GBufList.CurHist.CurBuf.FChannels);
            GBufList.CurHist.CurBuf.FillZero;
            if IntersectRect(tr,GBufList.CurHist.CurBuf.GetRect,GBufList.CurHist.Buf[GBufList.CurHist.FCur-1].GetRect) then begin
                tp.x:=tr.Left-GBufList.CurHist.CurBuf.FPos.x;
                tp.y:=tr.Top-GBufList.CurHist.CurBuf.FPos.y;
                tr.Left:=tr.Left-GBufList.CurHist.Buf[GBufList.CurHist.FCur-1].FPos.x;
                tr.Top:=tr.Top-GBufList.CurHist.Buf[GBufList.CurHist.FCur-1].FPos.y;
                tr.Right:=tr.Right-GBufList.CurHist.Buf[GBufList.CurHist.FCur-1].FPos.x;
                tr.Bottom:=tr.Bottom-GBufList.CurHist.Buf[GBufList.CurHist.FCur-1].FPos.y;

                GBufList.CurHist.CurBuf.Copy(tp,GBufList.CurHist.Buf[GBufList.CurHist.FCur-1],tr);

                RenderImage(True);
                UpdateImage;
            end;
        end;

        FSize:=false;
    end else if FSelect then begin
        SelectLineHide;

        tr.Left:=min(FSelectRect.Left,FSelectRect.Right);
        tr.Right:=max(FSelectRect.Left,FSelectRect.Right)+1;
        tr.Top:=min(FSelectRect.Top,FSelectRect.Bottom);
        tr.Bottom:=max(FSelectRect.Top,FSelectRect.Bottom)+1;

        if FSelectStart then begin
            ImageR.Canvas.Brush.Style:=bsClear;
            ImageR.Canvas.Pen.Color:=clWhite;//clRed;
            ImageR.Canvas.Pen.Mode:=pmXor;
            ImageR.Canvas.Pen.Style:=psDot;
            ImageR.Canvas.Rectangle(SelectRectScreen);
        end;
        if (not FSelectStart) or ((FSelectMode=2) and GImageSelectAll) then begin
            GImageSelect.Clear;
            GImageSelectAll:=true;

            FSelectLine.Build(GImageSelect);
        end else if (FSelectMode=0) or ((FSelectMode=1) and GImageSelectAll) then begin
            GImageSelectPos:=tr.TopLeft;
            tr.Right:=tr.Right-tr.Left;
            tr.Bottom:=tr.Bottom-tr.Top;
            tr.Left:=0;
            tr.Top:=0;
            GImageSelect.ImageCreate(tr.Right-tr.Left,tr.Bottom-tr.Top,1);
            GImageSelect.FillRect(tr,1);
            GImageSelectAll:=false;

            FSelectLine.Build(GImageSelect);
        end else if FSelectMode=1 then begin
            tr2.Left:=GImageSelectPos.x;
            tr2.Top:=GImageSelectPos.y;
            tr2.Right:=tr2.Left+GImageSelect.FLenX;
            tr2.Bottom:=tr2.Top+GImageSelect.FLenY;

            UnionRect(gbrect,tr,tr2);

            gb:=TGraphBuf.Create;
            gb.ImageCreate(gbrect.Right-gbrect.Left,gbrect.Bottom-gbrect.Top,1);
            gb.FillZero;
            gb.Copy(Point(GImageSelectPos.x-gbrect.Left,GImageSelectPos.y-gbrect.Top),GImageSelect,Rect(0,0,GImageSelect.FLenX,GImageSelect.FLenY));

            GImageSelectPos:=gbrect.TopLeft;
            GImageSelect.Free;
            GImageSelect:=gb;

            tr2.Left:=tr.Left-GImageSelectPos.x;
            tr2.Top:=tr.Top-GImageSelectPos.y;
            tr2.Right:=tr2.Left+(tr.Right-tr.Left);
            tr2.Bottom:=tr2.Top+(tr.Bottom-tr.Top);

            GImageSelect.FillRect(tr2,1);
            GImageSelectAll:=false;

            FSelectLine.Build(GImageSelect);
        end else if FSelectMode=2 then begin
            tr2.Left:=GImageSelectPos.x;
            tr2.Top:=GImageSelectPos.y;
            tr2.Right:=tr2.Left+GImageSelect.FLenX;
            tr2.Bottom:=tr2.Top+GImageSelect.FLenY;

            if IntersectRect(gbrect,tr,tr2) then begin
                tr2.Left:=gbrect.Left-GImageSelectPos.x;
                tr2.Top:=gbrect.Top-GImageSelectPos.y;
                tr2.Right:=tr2.Left+(gbrect.Right-gbrect.Left);
                tr2.Bottom:=tr2.Top+(gbrect.Bottom-gbrect.Top);

                GImageSelect.FillRect(tr2,0);

                FSelectLine.Build(GImageSelect);
                if FSelectLine.FCount<1 then begin
                    GImageSelect.Clear;
                    GImageSelectAll:=true;
                end else GImageSelectAll:=false;
            end;
        end;
        FSelect:=false;
        FSelectStart:=false;

        SelectLineShow;
    end;
end;

procedure TForm_Main.ImageRMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
    tp:TPoint;
    tr:TRect;
    tbuf:Pointer;
    i,tx,ty:integer;
begin
    if FMouseMove then begin
        if FSplitLineMove then begin
            tp:=PosScreenToWorld(Point(x,y));
            if FSplitLineXCur>=0 then begin
                PSet(PAdd(FSplitLineX,FSplitLineXCur*4),integer(tp.x));
            end else if FSplitLineYCur>=0 then begin
                PSet(PAdd(FSplitLineY,FSplitLineYCur*4),integer(tp.y));
            end;
            UpdateImage;
        end else if FSize then begin
            SizeRectShow;
            tp:=PosScreenToWorld(Point(x,y));
            if (FSizeMode and 1)=1 then begin
                FSizeRect.Left:=tp.x;
                if FSizeRect.Left>=FSizeRect.Right then FSizeRect.Left:=FSizeRect.Right-1;
            end;
            if (FSizeMode and 2)=2 then begin
                FSizeRect.Top:=tp.y;
                if FSizeRect.Top>=FSizeRect.Bottom then FSizeRect.Top:=FSizeRect.Bottom-1;
            end;
            if (FSizeMode and 4)=4 then begin
                FSizeRect.Right:=tp.x;
                if FSizeRect.Right<=FSizeRect.Left then FSizeRect.Right:=FSizeRect.Left+1;
            end;
            if (FSizeMode and 8)=8 then begin
                FSizeRect.Bottom:=tp.y;
                if FSizeRect.Bottom<=FSizeRect.Top then FSizeRect.Bottom:=FSizeRect.Top+1;
            end;
            SizeRectShow;
        end else if FSelect then begin
            if not FSelectStart then begin
                if (sqr(FMousePos.x-x)+sqr(FMousePos.y-y))>sqr(2) then FSelectStart:=true;
            end else begin
                ImageR.Canvas.Brush.Style:=bsClear;
                ImageR.Canvas.Pen.Color:=clWhite;//clRed;
                ImageR.Canvas.Pen.Mode:=pmXor;
                ImageR.Canvas.Pen.Style:=psDot;
                ImageR.Canvas.Rectangle(SelectRectScreen);
            end;

            if FSelectStart then begin
                FSelectRect.BottomRight:=PosScreenToWorld(Point(x,y));

                ImageR.Canvas.Brush.Style:=bsClear;
                ImageR.Canvas.Pen.Color:=clWhite;//clRed;
                ImageR.Canvas.Pen.Mode:=pmXor;
                ImageR.Canvas.Pen.Style:=psDot;
                ImageR.Canvas.Rectangle(SelectRectScreen);
            end;
        end else if (ssRight in Shift){ or (CBAction.Text='World')} then begin
            FSme.x:=FSme.x+Round((x-FMousePos.x)/FScale);
            FSme.y:=FSme.y+Round((y-FMousePos.y)/FScale);
            FMousePos:=Point(x,y);
            UpdateImage;
            Exit;
        end else if ((ssShift in Shift) and (ssCtrl in Shift)){ or (CBAction.Text='Move')} then begin
            if FFormModify then Exit;
            FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
            GBufList.CurHist.CurBuf.FPos.x:=GBufList.CurHist.CurBuf.FPos.x+Round((x-FMousePos.x)/FScale);
            GBufList.CurHist.CurBuf.FPos.y:=GBufList.CurHist.CurBuf.FPos.y+Round((y-FMousePos.y)/FScale);
            FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
            FMousePos:=Point(x,y);
            RenderImage;
            UpdateImage;
            Exit;
        end;
    end else begin
        if not FFormModify then begin
            tp:=PosScreenToWorld(Point(x,y));
            Screen.Cursor:=crDefault;
            FSplitLineMode:=0;
            for i:=0 to FSplitLineXCount-1 do begin
                tx:=PGetInteger(PAdd(FSplitLineX,i*4));

                if (tx>=(tp.x)) and (tx<=(tp.x)) then begin
                    Screen.Cursor:=crSizeWE;
                    FSplitLineMode:=1;
                end;
            end;

            if FSplitLineMode=0 then begin
                for i:=0 to FSplitLineYCount-1 do begin
                    ty:=PGetInteger(PAdd(FSplitLineY,i*4));

                    if (ty>=(tp.y)) and (ty<=(tp.y)) then begin
                        Screen.Cursor:=crSizeNS;
                        FSplitLineMode:=2;
                    end;
                end;
            end;
        end;
        if (GBufList.Count>0) and (not FFormModify) and (FSplitLineMode=0) then begin
            tp:=PosScreenToWorld(Point(x,y));
            tr.TopLeft:=GBufList.CurHist.CurBuf.FPos;
            tr.Right:=tr.Left+GBufList.CurHist.CurBuf.FLenX;
            tr.Bottom:=tr.Top+GBufList.CurHist.CurBuf.FLenY;

            if (tp.x>=(tr.Left-2)) and (tp.x<=(tr.Left-1)) and (tp.y>=(tr.Top-2)) and (tp.y<=(tr.Bottom+1)) then FSizeMode:=FSizeMode or 1
            else FSizeMode:=FSizeMode and (not 1);

            if (tp.x>=(tr.Left-2)) and (tp.x<=(tr.Right+1)) and (tp.y>=(tr.Top-2)) and (tp.y<=(tr.Top-1)) then FSizeMode:=FSizeMode or 2
            else FSizeMode:=FSizeMode and (not 2);

            if (tp.x>=(tr.Right)) and (tp.x<=(tr.Right+1)) and (tp.y>=(tr.Top-2)) and (tp.y<=(tr.Bottom+1)) then FSizeMode:=FSizeMode or 4
            else FSizeMode:=FSizeMode and (not 4);

            if (tp.x>=(tr.Left-2)) and (tp.x<=(tr.Right+1)) and (tp.y>=(tr.Bottom)) and (tp.y<=(tr.Bottom+1)) then FSizeMode:=FSizeMode or 8
            else FSizeMode:=FSizeMode and (not 8);

            if ((FSizeMode and 1)=1) and ((FSizeMode and 2)=2) then Screen.Cursor:=crSizeNWSE
            else if ((FSizeMode and 2)=2) and ((FSizeMode and 4)=4) then Screen.Cursor:=crSizeNESW
            else if ((FSizeMode and 4)=4) and ((FSizeMode and 8)=8) then Screen.Cursor:=crSizeNWSE
            else if ((FSizeMode and 8)=8) and ((FSizeMode and 1)=1) then Screen.Cursor:=crSizeNESW
            else if (FSizeMode and 1)=1 then Screen.Cursor:=crSizeWE
            else if (FSizeMode and 2)=2 then Screen.Cursor:=crSizeNS
            else if (FSizeMode and 4)=4 then Screen.Cursor:=crSizeWE
            else if (FSizeMode and 8)=8 then Screen.Cursor:=crSizeNS
            else Screen.Cursor:=crDefault;
        end;
    end;

    if ssShift in Shift then begin
        tp:=PosScreenToImage(Point(x,y));
        if (tp.x>=0) and (tp.x<FImage.FlenX) and (tp.y>=0) and (tp.y<FImage.FlenY) then begin
            tbuf:=FImage.PixelBuf(tp.x,tp.y);
            EditRGBA.Text:=IntToStr(DWORD(PGetBYTE(tbuf)))+','+IntToStr(DWORD(PGetBYTE(PAdd(tbuf,1))))+','+IntToStr(DWORD(PGetBYTE(PAdd(tbuf,2))))+','+IntToStr(DWORD(PGetBYTE(PAdd(tbuf,3))));
        end else begin
            EditRGBA.Text:='';
        end;
    end;

    tp:=PosScreenToWorld(Point(x,y));
    EditPosMouse.Text:=IntToStr(tp.x)+','+IntToStr(tp.y);
end;

function TForm_Main.SelectRectScreen:TRect;
var
    tr:TRect;
begin
    tr.Left:=min(FSelectRect.Left,FSelectRect.Right);
    tr.Right:=max(FSelectRect.Left,FSelectRect.Right);
    tr.Top:=min(FSelectRect.Top,FSelectRect.Bottom);
    tr.Bottom:=max(FSelectRect.Top,FSelectRect.Bottom);

    tr.TopLeft:=PosWorldToScreen(tr.TopLeft);
    tr.BottomRight:=PosWorldToScreen(tr.BottomRight);

    tr.Right:=tr.Right+FScale;
    tr.Bottom:=tr.Bottom+FScale;

    Result:=tr;
end;

procedure TForm_Main.SelectLineShow;
var
    slu:PSelectLineUnit;
    i:integer;
    tp1,tp2:TPoint;
begin
    if FSelectLine.FCount<1 then Exit;

    ImageR.Canvas.Brush.Style:=bsClear;
    ImageR.Canvas.Pen.Color:=clWhite;//clRed;
    ImageR.Canvas.Pen.Mode:=pmXor;
    ImageR.Canvas.Pen.Style:=psDot;

    slu:=FSelectLine.FBuf;
    for i:=0 to FSelectLine.FCount-1 do begin
        tp1.x:=slu.FStart.x+GImageSelectPos.x;
        tp1.y:=slu.FStart.y+GImageSelectPos.y;

        tp2.x:=slu.FEnd.x+GImageSelectPos.x;
        tp2.y:=slu.FEnd.y+GImageSelectPos.y;

        tp1:=PosWorldToScreen(tp1);
        tp2:=PosWorldToScreen(tp2);

        ImageR.Canvas.MoveTo(tp1.x,tp1.y);
        ImageR.Canvas.LineTo(tp2.x,tp2.y);

        slu:=PAdd(slu,sizeof(TSelectLineUnit));
    end;
    ImageR.Update;
end;

procedure TForm_Main.SelectLineHide;
begin
    SelectLineShow;
end;

procedure TForm_Main.SizeRectShow;
var
    tr:TRect;
begin
    tr.TopLeft:=PosWorldToScreen(FSizeRect.TopLeft);
    tr.BottomRight:=PosWorldToScreen(FSizeRect.BottomRight);

    tr.Left:=tr.Left-1; tr.Top:=tr.Top-1;
    tr.Right:=tr.Right+1; tr.Bottom:=tr.Bottom+1;

    ImageR.Canvas.Pen.Color:=clWhite;//clRed;
    ImageR.Canvas.Pen.Mode:=pmXor;
    ImageR.Canvas.Pen.Style:=psDashDot;
    ImageR.Canvas.Brush.Style:=bsClear;

    ImageR.Canvas.Rectangle(tr);
end;

procedure TForm_Main.SpeedButton1Click(Sender: TObject);
begin
    RenderImage(true);
    UpdateImage;
end;

procedure TForm_Main.AppMessage(var Msg: TMsg; var Handled: Boolean);
var
    tp:TPoint;
begin
    if Msg.message=WM_MOUSEWHEEL then begin
        if (not FSelect) and (not FSize) then begin
            if short(HIWORD(Msg.wParam))=-120 then begin
                GetCursorPos(tp);
                NewScale(ImageR.ScreenToClient(tp),max(1,FScale-1));
                RxSpinEditScale.Value:=FScale;
                UpdateImage;
            end else if short(HIWORD(Msg.wParam))=120 then begin
                GetCursorPos(tp);
                NewScale(ImageR.ScreenToClient(tp),min(32,FScale+1));
                RxSpinEditScale.Value:=FScale;
                UpdateImage;
            end;
        end;

        Handled:=true;
    end else if Msg.message=WM_KEYDOWN then begin
        if Msg.wParam=VK_SHIFT then begin
            if FSelect then begin
                FSelectMode:=1;
                Screen.Cursor:=crSelectRectAdd;
                Handled:=true;
            end;
        end else if Msg.wParam=VK_CONTROL then begin
            if FSelect then begin
                FSelectMode:=2;
                Screen.Cursor:=crSelectRectSub;
                Handled:=true;
            end;
        end else if Msg.wParam=VK_NEXT then begin
            if (not FSelect) and (not FSize) then begin
                GetCursorPos(tp);
                NewScale(ImageR.ScreenToClient(tp),max(1,FScale-1));
                RxSpinEditScale.Value:=FScale;
                UpdateImage;
                Handled:=true;
            end;
        end else if Msg.wParam=VK_PRIOR then begin
            if (not FSelect) and (not FSize) then begin
                GetCursorPos(tp);
                NewScale(ImageR.ScreenToClient(tp),min(32,FScale+1));
                RxSpinEditScale.Value:=FScale;
                UpdateImage;
                Handled:=true;
            end;
        end;
    end else if Msg.message=WM_KEYUP then begin
        if Msg.wParam=VK_SHIFT then begin
            if FSelect then begin
                FSelectMode:=0;
                Screen.Cursor:=crSelectRectNormal;
                Handled:=true;
            end;
        end else if Msg.wParam=VK_CONTROL then begin
            if FSelect then begin
                FSelectMode:=0;
                Screen.Cursor:=crSelectRectNormal;
                Handled:=true;
            end;
        end;
    end;
end;

procedure TForm_Main.FormResize(Sender: TObject);
begin
//    ImageR.Canvas.Brush.Color:=clBlack;
//    ImageR.Canvas.FillRect(Rect(0,0,ImageR.Width,ImageR.Height));

end;

procedure TForm_Main.Panel1Resize(Sender: TObject);
begin
    ImageR.Picture.Bitmap.Width:=ImageR.Width;
    ImageR.Picture.Bitmap.Height:=ImageR.Height;
    UpdateImage;
end;

procedure TForm_Main.CBTypeShowChange(Sender: TObject);
begin
    UpdateImage;
end;

procedure TForm_Main.ButtonHistDelClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    if not CBRenderCur.Checked then FRectUpdate.TestAdd(GBufList.Hist[GBufList.FCur].CurBuf.GetRect);
    GBufList.DelHist(GBufList.FCur);
    RenderImage(CBRenderCur.Checked);
    UpdateImage;
    UpdateListHist;
end;

procedure TForm_Main.ButtonHistDelAllClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    GBufList.Clear;
    RenderImage(True);
    UpdateImage;
    UpdateListHist;
end;

procedure TForm_Main.ButtonHistUpClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<2 then Exit;
    FRectUpdate.TestAdd(GBufList.Hist[GBufList.FCur].CurBuf.GetRect);
    GBufList.CurHistUp;
    RenderImage;
    UpdateImage;
    UpdateListHist;
end;

procedure TForm_Main.ButtonHistDownClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<2 then Exit;
    FRectUpdate.TestAdd(GBufList.Hist[GBufList.FCur].CurBuf.GetRect);
    GBufList.CurHistDown;
    RenderImage;
    UpdateImage;
    UpdateListHist;
end;

procedure TForm_Main.ButtonHistCopyClick(Sender: TObject);
var
    hu:TGraphBufHist;
    i,histcopy:integer;
    gb:TGraphBuf;
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;

    histcopy:=GBufList.FCur;

    hu:=GBufList.InsertHist(histcopy+1);
    for i:=0 to GBufList.Hist[histcopy].Count-1 do begin
        gb:=hu.AddBuf;
        gb.Load(GBufList.Hist[histcopy].Buf[i]);
        gb.FPos:=GBufList.Hist[histcopy].Buf[i].FPos;
    end;
    hu.FCur:=GBufList.Hist[histcopy].FCur;
    hu.FName:=GBufList.Hist[histcopy].FName+' copy';
    RenderImage(true);
    UpdateImage;
    UpdateListHist;
end;

procedure TForm_Main.EditXKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    if key=VK_RETURN then begin
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        GBufList.CurHist.CurBuf.FPos.x:=StrToIntEC(EditX.Text);
        GBufList.CurHist.CurBuf.FPos.y:=StrToIntEC(EditY.Text);
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        RenderImage;
        UpdateImage;
    end;
end;

procedure TForm_Main.SBBufLeftClick(Sender: TObject);
begin
    if GBufList.Count<1 then Exit;
    if GBufList.CurHist.FCur<1 then Exit;
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    dec(GBufList.CurHist.FCur);
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    RenderImage;
    UpdateImage;
end;

procedure TForm_Main.SBBufRightClick(Sender: TObject);
begin
    if GBufList.Count<1 then Exit;
    if GBufList.CurHist.FCur=GBufList.CurHist.Count-1 then begin
        if FFormModify then Exit;
        GBufList.CurHist.NewModify;
    end else begin
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        inc(GBufList.CurHist.FCur);
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    end;
    RenderImage;
    UpdateImage;
end;

procedure TForm_Main.MMFilter_CutOffAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    Form_CutOffAlpha.ShowModal;
{    GBufList.CurHist.NewModify;
    try
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        OCutOffAlpha(GBufList.CurHist.Buf[GBufList.CurHist.Count-2],GBufList.CurHist.Buf[GBufList.CurHist.Count-1]);
    except
        on ex:Exception do begin
            GBufList.CurHist.DelBuf(GBufList.CurHist.Count-1);
            ShowMessage(ex.message);
        end;
    end;
    RenderImage;
    UpdateImage;}
end;

procedure TForm_Main.MMFilter_FillAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    FFormModify:=true;
    Form_FillAlpha.Show;
end;

procedure TForm_Main.PopupMenuBufClearClick(Sender: TObject);
begin
    if (GBufList.Count<1) or (GBufList.CurHist.Count<2) then Exit;
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    GBufList.CurHist.DelBuf(0,GBufList.CurHist.Count-2);
    GBufList.CurHist.FCur:=0;
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    RenderImage;
    UpdateImage;
end;

procedure TForm_Main.PopupMenuBufDelCurClick(Sender: TObject);
begin
    if (GBufList.Count<1) or (GBufList.CurHist.Count<2) then Exit;
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    GBufList.CurHist.DelBuf(GBufList.CurHist.FCur);
    FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    RenderImage;
    UpdateImage;
end;

procedure TForm_Main.PopupMenuBufDelAllClick(Sender: TObject);
begin
    if (GBufList.Count<1) or (GBufList.CurHist.Count<2) then Exit;
    if GBufList.CurHist.FCur>0 then begin
        GBufList.CurHist.DelBuf(0,GBufList.CurHist.FCur-1);
        GBufList.CurHist.FCur:=0;
    end;
    if GBufList.CurHist.FCur<(GBufList.CurHist.Count-1) then begin
        GBufList.CurHist.DelBuf(GBufList.CurHist.FCur+1,GBufList.CurHist.Count-1);
    end;
    UpdateImage;
end;

procedure TForm_Main.PopupMenuBufAllImageClearClick(Sender: TObject);
var
    i:integer;
begin
    if (GBufList.Count<1) or (GBufList.CurHist.Count<2) then Exit;

    for i:=0 to GBufList.Count-1 do begin
        if GBufList.Hist[i].Count>=2 then begin
            GBufList.Hist[i].DelBuf(0,GBufList.Hist[i].Count-2);
            GBufList.Hist[i].FCur:=0;
        end;
    end;

    RenderImage(true);
    UpdateImage;
end;


procedure TForm_Main.MMFilter_CorrectImageByAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if (GBufList.Count<1) then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    Form_CorrectImageByAlpha.ShowModal;
end;

procedure TForm_Main.MMFilter_CorrectAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    FFormModify:=true;
    Form_CorrectAlpha.Show;
end;

procedure TForm_Main.MMFilter_Indexed8Click(Sender: TObject);
var
    im:TGraphBuf;
    sou:TGraphBuf;
begin
    if FFormModify then Exit;
    if (GBufList.Count<1) then Exit;

    Screen.Cursor:=crHourglass;

    sou:=GBufList.CurHist.CurBuf;
    if sou.FChannels<>4 then Exit;

    im:=TGraphBuf.Create;
    im.ImageCreate(sou.FLenX,sou.FLenY,1);
    im.PalCreate(256);
    if OKGF_RGBAtoIndexed8(sou.FBuf,sou.FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,sou.FLenX,sou.FLenY)>0 then begin
//    if IC_RGBAtoIndexed8(sou.FBuf,sou.FLenLine,32,$ff0000,$ff00,$ff,$ff000000,im.FBuf,im.FLenLine,im.FPal,sou.FLenX,sou.FLenY)>0 then begin
        GBufList.CurHist.NewModify;

        GBufList.CurHist.CurBuf.Copy(Point(0,0),im,Rect(0,0,im.FLenX,im.FLenY));

        Form_Main.FRectUpdate.TestAdd(sou.GetRect);
        Form_Main.RenderImage;
        Form_Main.UpdateImage;
    end;
    im.Free;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMFilter_AlphaIndexed8Click(Sender: TObject);
var
    im,imCopy,imAlpha,gbdes:TGraphBuf;
    color:DWORD;
    x,y:integer;
begin
    if FFormModify then Exit;
    if (GBufList.Count<1) then Exit;

    Screen.Cursor:=crHourglass;

    im:=TGraphBuf.Create;
    imCopy:=TGraphBuf.Create;
    imAlpha:=TGraphBuf.Create;

    OSplit_ForAlphaIndexed(GBufList.CurHist.CurBuf,imCopy,imAlpha);

    im.ImageCreate(GBufList.CurHist.CurBuf.FLenX,GBufList.CurHist.CurBuf.FLenY,1);
    im.PalCreate(256);

    GBufList.CurHist.NewModify;
    gbdes:=GBufList.CurHist.CurBuf;

    if OKGF_RGBAtoIndexed8(imCopy.FBuf,imCopy.FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,im.FLenX,im.FLenY)>0 then begin
        GBufList.CurHist.CurBuf.Copy(Point(0,0),im,Rect(0,0,im.FLenX,im.FLenY));
    end;

    if OKGF_RGBAtoIndexed8(imAlpha.FBuf,imAlpha.FLenLine,32,$ff,$ff00,$ff0000,$ff000000,im.FBuf,im.FLenLine,im.FPal,im.FLenX,im.FLenY)>0 then begin
        for y:=0 to im.FLenY-1 do begin
            for x:=0 to im.FLenX-1 do begin
                color:=PGetDWORD(PAdd(im.FPal,im.PixelChannel(x,y,0)*4));
                if color>0 then begin
                    PSet(gbdes.PixelBuf(x,y),color);
                end;
            end;
        end;
    end;

    im.Free;

    Form_Main.FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
    Form_Main.RenderImage;
    Form_Main.UpdateImage;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMFilter_DifferentClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<2 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    Form_Different.ShowModal;
end;

procedure TForm_Main.MMFilter_OperationClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<2 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    FFormModify:=true;
    Form_Operation.Show;
end;

procedure TForm_Main.MMFilter_RescaleClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    GBufList.CurHist.NewModify;
    UpdateImage;
    FFormModify:=true;
    Form_Rescale.Show;
end;

procedure TForm_Main.MMSelect_SelectByAlphaClick(Sender: TObject);
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    FFormModify:=true;
    Form_SelectAlpha.Show;
end;

procedure TForm_Main.MMSelect_SelectInverseClick(Sender: TObject);
var
    gb:TGraphBuf;
    tr,tr2:TRect;
    x,y:integer;
begin
    if FFormModify then Exit;
    if GBufList.Count<1 then Exit;
    if GImageSelectAll then Exit;

    SelectLineHide;

    gb:=TGraphBuf.Create;
    gb.ImageCreate(FImage.FLenX,FImage.FLenY,1);
    gb.FPos:=FImagePos;
    gb.FillZero;

    tr2.Left:=GImageSelectPos.x;
    tr2.Top:=GImageSelectPos.y;
    tr2.Right:=tr2.Left+GImageSelect.FLenX;
    tr2.Bottom:=tr2.Top+GImageSelect.FLenY;

    if IntersectRect(tr,tr2,gb.GetRect) then begin
        tr2.Left:=tr.Left-GImageSelectPos.x;
        tr2.Top:=tr.Top-GImageSelectPos.y;
        tr2.Right:=tr.Right-GImageSelectPos.x;
        tr2.Bottom:=tr.Bottom-GImageSelectPos.y;
        gb.Copy(Point(tr.Left-gb.FPos.x,tr.Top-gb.FPos.y),GImageSelect,tr2);
    end;

    for y:=0 to gb.FLenY-1 do begin
        for x:=0 to gb.FLenX-1 do begin
            PSet(gb.PixelBuf(x,y),BYTE(gb.PixelChannel(x,y,0) xor 1));
        end;
    end;
    GImageSelect.Free;
    GImageSelect:=gb;
    GImageSelectPos:=gb.FPos;

    FSelectLine.Build(GImageSelect);
    SelectLineShow;
end;

procedure TForm_Main.MMFilter_Dithering16bitClick(Sender: TObject);
begin
    if GBufList.Count<1 then Exit;
    Screen.Cursor:=crHourglass;
    GBufList.CurHist.NewModify;
    try
        FRectUpdate.TestAdd(GBufList.CurHist.CurBuf.GetRect);
        ODithering16bit(GBufList.CurHist.Buf[GBufList.CurHist.Count-2],GBufList.CurHist.Buf[GBufList.CurHist.Count-1]);
    except
        on ex:Exception do begin
            GBufList.CurHist.DelBuf(GBufList.CurHist.Count-1);
            ShowMessage(ex.message);
        end;
    end;
    Screen.Cursor:=crDefault;
    RenderImage;
    UpdateImage;
end;

procedure TForm_Main.SGListHistSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
    if GBufList.Count<1 then Exit;
    GBufList.CurHist.FName:=Value;
end;

procedure TForm_Main.CBRenderCurClick(Sender: TObject);
begin
    RenderImage(true);
    UpdateImage;
end;

procedure TForm_Main.MMTools_InfoProjectClick(Sender: TObject);
begin
    if GBufList.Count<1 then Exit;

    Form_InfoProject.ShowModal;
end;

procedure TForm_Main.BuildGAIanimClick(Sender: TObject);
begin
    Form_BuildGAIAnim.ShowModal;
end;

procedure TForm_Main.BuildGAIExanimClick(Sender: TObject);
begin
    Form_BuildGAIExAnim.ShowModal;
end;

procedure TForm_Main.BuildGAIgroupClick(Sender: TObject);
begin
    Form_BuildGAIGroup.ShowModal;
end;

procedure TForm_Main.MMSL_DivXClick(Sender: TObject);
begin
    inc(FSplitLineXCount);
    FSplitLineX:=ReAllocREC(FSplitLineX,FSplitLineXCount*4);

    PSet(PAdd(FSplitLineX,(FSplitLineXCount-1)*4),integer(PosScreenToWorld(Point(ImageR.Width div 2,0)).x));

    FSplitLineXCur:=FSplitLineXCount-1;
    FSplitLineYCur:=-1;

    UpdateImage;
end;

procedure TForm_Main.MMSL_DivYClick(Sender: TObject);
begin
    inc(FSplitLineYCount);
    FSplitLineY:=ReAllocREC(FSplitLineY,FSplitLineYCount*4);

    PSet(PAdd(FSplitLineY,(FSplitLineYCount-1)*4),integer(PosScreenToWorld(Point(0,ImageR.Height div 2)).y));

    FSplitLineXCur:=-1;
    FSplitLineYCur:=FSplitLineYCount-1;

    UpdateImage;
end;

procedure TForm_Main.MMSL_DivFormClick(Sender: TObject);
var
    i,cntx,cnty,smex,smey,cur:integer;
    tr:TRect;
begin
    if GBufList.Count<1 then Exit;

    if FormSplitLineDivForm.ShowModal<>mrOk then Exit;

    cntx:=StrToIntEC(FormSplitLineDivForm.EditSX.Text);
    cnty:=StrToIntEC(FormSplitLineDivForm.EditSY.Text);
    if (cntx<1) or (cnty<1) then Exit;

    tr:=GBufList.CurHist.CurBuf.GetRect;

    smex:=(tr.Right-tr.Left) div cntx;
    smey:=(tr.Right-tr.Left) div cnty;

    cur:=tr.Left;
    for i:=0 to cntx-2 do begin
        cur:=cur+smex;

        inc(FSplitLineXCount);
        FSplitLineX:=ReAllocREC(FSplitLineX,FSplitLineXCount*4);

        PSet(PAdd(FSplitLineX,(FSplitLineXCount-1)*4),cur);
    end;

    cur:=tr.Top;
    for i:=0 to cnty-2 do begin
        cur:=cur+smey;

        inc(FSplitLineYCount);
        FSplitLineY:=ReAllocREC(FSplitLineY,FSplitLineYCount*4);

        PSet(PAdd(FSplitLineY,(FSplitLineYCount-1)*4),cur);
    end;

    UpdateImage;
end;

procedure TForm_Main.MMSL_DeleteClick(Sender: TObject);
var
    i:integer;
begin
    if FSplitLineXCur>=0 then begin
        for i:=FSplitLineXCur+1 to FSplitLineXCount-1 do begin
            PSet(PAdd(FSplitLineX,(i-1)*4),PGetInteger(PAdd(FSplitLineX,i*4)));
        end;
        dec(FSplitLineXCount);
        FSplitLineX:=ReAllocREC(FSplitLineX,FSplitLineXCount*4);

        if FSplitLineXCur>=FSplitLineXCount then FSplitLineXCur:=FSplitLineXCount-1;
    end else if FSplitLineYCur>=0 then begin
        for i:=FSplitLineYCur+1 to FSplitLineYCount-1 do begin
            PSet(PAdd(FSplitLineY,(i-1)*4),PGetInteger(PAdd(FSplitLineY,i*4)));
        end;
        dec(FSplitLineYCount);
        FSplitLineY:=ReAllocREC(FSplitLineY,FSplitLineYCount*4);

        if FSplitLineYCur>=FSplitLineYCount then FSplitLineYCur:=FSplitLineYCount-1;
    end;

    UpdateImage;
end;

procedure TForm_Main.MMSL_ClearClick(Sender: TObject);
begin
    if FSplitLineX<>nil then begin
        FreeEC(FSplitLineX); FSplitLineX:=nil;
    end;
    if FSplitLineY<>nil then begin
        FreeEC(FSplitLineY); FSplitLineY:=nil;
    end;

    FSplitLineXCount:=0;
    FSplitLineYCount:=0;
    FSplitLineXCur:=-1;
    FSplitLineYCur:=-1;

    UpdateImage;
end;

procedure TForm_Main.MMSL_SplitImageClick(Sender: TObject);
var
    slX:array of integer;
    slY:array of integer;
    slXCnt:integer;
    slYCnt:integer;
    sb:TGraphBuf;
    newb:TGraphBuf;
    i,u,t,tx,ty:integer;
    souname:WideString;
    tr:TRect;
    tMR,tMG,tMB,tMA:DWORD;
begin
    if GBufList.Count<1 then Exit;

    Screen.Cursor:=crHourglass;

    sb:=GBufList.CurHist.CurBuf;
    souname:=GBufList.CurHist.FName;
    tMR:=GBufList.CurHist.FMR;
    tMG:=GBufList.CurHist.FMG;
    tMB:=GBufList.CurHist.FMB;
    tMA:=GBufList.CurHist.FMA;

    SetLength(slX,FSplitLineXCount+2);
    SetLength(slY,FSplitLineYCount+2);

    slX[0]:=sb.FPos.x;
    slXCnt:=1;

    slY[0]:=sb.FPos.y;
    slYCnt:=1;

    for i:=0 to FSplitLineXCount-1 do begin
        tx:=PGetInteger(PAdd(FSplitLineX,i*4));
        if (tx>sb.FPos.x) and (tx<(sb.FPos.x+sb.FLenX)) then begin
            u:=0;
            while u<slXCnt do begin
                if tx<=slX[u] then break;
                inc(u);
            end;
            if u>=slXCnt then begin
                slX[slXCnt]:=tx;
                inc(slXCnt);
            end else if tx=slX[u] then begin
            end else begin
                for t:=slXCnt downto u+1 do slX[t]:=slX[t-1];
                slX[u]:=tx;
                inc(slXCnt);
            end;
        end;
    end;

    for i:=0 to FSplitLineYCount-1 do begin
        ty:=PGetInteger(PAdd(FSplitLineY,i*4));
        if (ty>sb.FPos.y) and (ty<(sb.FPos.y+sb.FLenY)) then begin
            u:=0;
            while u<slYCnt do begin
                if ty<=slY[u] then break;
                inc(u);
            end;
            if u>=slYCnt then begin
                slY[slYCnt]:=ty;
                inc(slYCnt);
            end else if ty=slY[u] then begin
            end else begin
                for t:=slYCnt downto u+1 do slY[t]:=slY[t-1];
                slY[u]:=ty;
                inc(slYCnt);
            end;
        end;
    end;

    slX[slXCnt]:=sb.FPos.x+sb.FLenX;
    inc(slXCnt);

    slY[slYCnt]:=sb.FPos.y+sb.FLenY;
    inc(slYCnt);

    for ty:=0 to slYCnt-2 do begin
        for tx:=0 to slXCnt-2 do begin
            tr.Left:=slX[tx];
            tr.Top:=slY[ty];
            tr.Right:=slX[tx+1];
            tr.Bottom:=slY[ty+1];

            newb:=GBufList.AddHist.AddBuf;
            newb.FPos:=tr.TopLeft;
            GBufList.CurHist.FName:=souname+'_'+IntToStr(tx)+'_'+IntToStr(ty);
            GBufList.CurHist.FMR:=tMR;
            GBufList.CurHist.FMG:=tMG;
            GBufList.CurHist.FMB:=tMB;
            GBufList.CurHist.FMA:=tMA;

            newb.ImageCreate(tr.Right-tr.Left,tr.Bottom-tr.Top,sb.FChannels);

            tr.Left:=tr.Left-sb.FPos.x;
            tr.Top:=tr.Top-sb.FPos.y;
            tr.Right:=tr.Right-sb.FPos.x;
            tr.Bottom:=tr.Bottom-sb.FPos.y;

            newb.Copy(Point(0,0),sb,tr);
        end;
    end;

    slX:=nil;
    slY:=nil;

    RenderImage(true);
    UpdateImage;
    UpdateListHist;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMSL_UnionLeftClick(Sender: TObject);
var
    db:TGraphBuf;
    ub:TGraphBuf;
    sb:TGraphBuf;
    i:integer;
    tr:TRect;
begin
    if GBufList.Count<2 then Exit;

    ub:=GBufList.CurHist.CurBuf;
    sb:=nil;

        i:=0;
        while i<GBufList.Count do begin
            sb:=GBufList.Hist[i].CurBuf;
            if sb=ub then begin inc(i); continue; end;
            if Sender=MMSL_UnionLeft then begin
                if (ub.FPos.y=sb.FPos.y) and (ub.FLenY=sb.FLenY) and (ub.FPos.x=(sb.FPos.x+sb.FLenX)) then break;
            end else if Sender=MMSL_UnionRight then begin
                if (ub.FPos.y=sb.FPos.y) and (ub.FLenY=sb.FLenY) and ((ub.FPos.x+ub.FLenX)=sb.FPos.x) then break;
            end else if Sender=MMSL_UnionTop then begin
                if (ub.FPos.x=sb.FPos.x) and (ub.FLenX=sb.FLenX) and (ub.FPos.y=(sb.FPos.y+sb.FLenY)) then break;
            end else if Sender=MMSL_UnionBottom then begin
                if (ub.FPos.x=sb.FPos.x) and (ub.FLenX=sb.FLenX) and ((ub.FPos.y+ub.FLeny)=sb.FPos.y) then break;
            end;
            inc(i);
        end;
    if i>=GBufList.Count then Exit;

    UnionRect(tr,ub.GetRect,sb.GetRect);

    Screen.Cursor:=crHourglass;
    GBufList.CurHist.NewModify;
    db:=GBufList.CurHist.CurBuf;
    db.ImageCreate(tr.Right-tr.Left,tr.Bottom-tr.Top,ub.FChannels);
    db.FPos:=tr.TopLeft;

    db.Copy(db.PosWorldToBuf(ub.FPos),ub,Rect(0,0,ub.FLenX,ub.FLenY));
    db.Copy(db.PosWorldToBuf(sb.FPos),sb,Rect(0,0,sb.FLenX,sb.FLenY));

    GBufList.DelHist(i);

    RenderImage(true);
    UpdateImage;
    UpdateListHist;

    Screen.Cursor:=crDefault;
end;

procedure TForm_Main.MMTools_ScriptClick(Sender: TObject);
begin
    Form_Script.ShowModal;
end;

procedure TForm_Main.Panel5Resize(Sender: TObject);
begin
    if (SGListHist.ColCount=6) and (SGListHist.ColCount>0) then begin
        SGListHist.ColWidths[0]:=70;
        SGListHist.ColWidths[1]:=20;
        SGListHist.ColWidths[2]:=20;
        SGListHist.ColWidths[3]:=20;
        SGListHist.ColWidths[4]:=20;
        SGListHist.ColWidths[5]:=30;

        SGListHist.ColWidths[0]:=Panel5.Width-SGListHist.ColWidths[1]-SGListHist.ColWidths[2]-SGListHist.ColWidths[3]-SGListHist.ColWidths[4]-SGListHist.ColWidths[5]-30;
    end;
end;

procedure TForm_Main.TimerPlayTimer(Sender: TObject);
begin
    if GBufList.Count<2 then Exit;
    if not CheckBoxPlay.Checked then Exit;

    if SGListHist.Row=SGListHist.RowCount-1 then begin
        SGListHist.Row:=0;
    end else begin
        SGListHist.Row:=SGListHist.Row+1;
    end;

    SGListHistAction(0,SGListHist.Row,false,false,false);
    if CBRenderCur.Checked then begin
        RenderImage(true);
        UpdateImage;
    end;
end;

procedure TForm_Main.EditPlayIntervalChange(Sender: TObject);
begin
    TimerPlay.Interval:=StrToIntEC(EditPlayInterval.Text);
end;

end.

