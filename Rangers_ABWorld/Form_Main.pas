unit Form_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Math, MMSystem,
  Dialogs, ExtCtrls, Menus, GR_DirectX3D8, VOper, GLobal, ab_Obj3D, WorldLine,
  StdCtrls, WorldUnit, ABPoint, ABTriangle, ABLine, EC_Buf, EC_Str, EC_File, ABKey, WorldZone,
  aMyFunction, aPathBuild, DebugMsg;

type
  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3D: TPanel;
    Timer1: TTimer;
    Label1: TLabel;
    LabelFPS: TLabel;
    Label2: TLabel;
    LabelCoord: TLabel;
    Unit1: TMenuItem;
    MM_Unit_Load: TMenuItem;
    N2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialogUnit: TOpenDialog;
    Panel3: TPanel;
    View1: TMenuItem;
    MM_View_WorldLine: TMenuItem;
    MM_View_Point: TMenuItem;
    N3: TMenuItem;
    Saveend1: TMenuItem;
    SaveDialog2: TSaveDialog;
    N4: TMenuItem;
    MM_View_SLDefault: TMenuItem;
    MM_View_SLShow: TMenuItem;
    MM_View_SLHide: TMenuItem;
    N5: TMenuItem;
    MM_File_Clear: TMenuItem;
    NotebookAction: TNotebook;
    Label3: TLabel;
    EditUnitTimeOffset: TEdit;
    Label4: TLabel;
    ComboBoxUnitKeyGroup: TComboBox;
    Label5: TLabel;
    ComboBoxUnitType: TComboBox;
    Label6: TLabel;
    ComboBoxZoneType: TComboBox;
    MM_View_Zone: TMenuItem;
    MM_Unit_ReloadCurType: TMenuItem;
    MM_Unit_ReloadAll: TMenuItem;
    MM_Unit_ReloadCur: TMenuItem;
    Options1: TMenuItem;
    MM_Options_Options: TMenuItem;
    Label7: TLabel;
    EditMainWorldRadius: TEdit;
    MM_File_SaveEnd: TMenuItem;
    EditZoneRadius: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    ComboBoxZoneGraph: TComboBox;
    Label10: TLabel;
    ComboBoxZoneLinkType: TComboBox;
    Label11: TLabel;
    EditZoneHitpoints: TEdit;
    Label12: TLabel;
    EditZoneMass: TEdit;
    Label13: TLabel;
    EditZoneDamage: TEdit;
    GroupBox1: TGroupBox;
    CheckBoxZoneI0: TCheckBox;
    CheckBoxZoneI1: TCheckBox;
    CheckBoxZoneI2: TCheckBox;
    CheckBoxZoneI3: TCheckBox;
    CheckBoxZoneI4: TCheckBox;
    CheckBoxZoneI5: TCheckBox;
    CheckBoxZoneI6: TCheckBox;
    CheckBoxZoneI7: TCheckBox;
    ComboBoxZoneIFreq: TComboBox;
    CheckBoxZoneI31: TCheckBox;
    Label14: TLabel;
    EditUnitTimeLength: TEdit;
    MM_View_Background: TMenuItem;
    N6: TMenuItem;
    MM_Unit_Path: TMenuItem;
    N7: TMenuItem;
    MM_Unit_BBCalcCurrent: TMenuItem;
    MM_Unit_BBCalcAll: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Panel3DMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure MM_Unit_LoadClick(Sender: TObject);
    procedure Panel3DMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure Panel3DMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
    procedure MM_View_PointClick(Sender: TObject);
    procedure MM_View_WorldLineClick(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Saveend1Click(Sender: TObject);
    procedure MM_View_SLDefaultClick(Sender: TObject);
    procedure MM_File_ClearClick(Sender: TObject);
    procedure ComboBoxUnitTypeChange(Sender: TObject);
    procedure EditUnitTimeOffsetChange(Sender: TObject);
    procedure ComboBoxUnitKeyGroupChange(Sender: TObject);
    procedure ComboBoxZoneTypeChange(Sender: TObject);
    procedure MM_View_ZoneClick(Sender: TObject);
    procedure MM_Unit_ReloadCurClick(Sender: TObject);
    procedure MM_Unit_ReloadCurTypeClick(Sender: TObject);
    procedure MM_Unit_ReloadAllClick(Sender: TObject);
    procedure MM_Options_OptionsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditMainWorldRadiusKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure MM_File_SaveEndClick(Sender: TObject);
    procedure ComboBoxZoneGraphChange(Sender: TObject);
    procedure ComboBoxZoneLinkTypeChange(Sender: TObject);
    procedure EditZoneHitpointsChange(Sender: TObject);
    procedure EditZoneMassChange(Sender: TObject);
    procedure EditZoneDamageChange(Sender: TObject);
    procedure CheckBoxZoneI0Click(Sender: TObject);
    procedure ComboBoxZoneIFreqChange(Sender: TObject);
    procedure EditUnitTimeLengthChange(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure MM_View_BackgroundClick(Sender: TObject);
    procedure MM_Unit_PathClick(Sender: TObject);
    procedure EditZoneRadiusChange(Sender: TObject);
    procedure MM_Unit_BBCalcCurrentClick(Sender: TObject);
    procedure MM_Unit_BBCalcAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    FSWL: TList;

    FFPSLast: DWORD;
    FFPSCnt: integer;

    FMove: boolean;
    FMoveWorld: boolean;
    FMoveLP: TPoint;
    FMoveOrbit, FMoveOrbitAngle: single;
    FRotate: boolean;

    FActionType: integer; // 0-not 1-Zone move 2-Zone radius

    FSel: boolean;
    FSelRect: TRect;
    FSelGraph: TabObj3D;

    FBGGraph: TabObj3D;

    FStopDraw: boolean;

    FTimeLastSet: DWORD;

    procedure AppMessage(var Msg: TMsg; var Handled: boolean);
    procedure ApplicationDeactivate(Sender: TObject);

    procedure SWLClear;
    procedure SWLBuild;

    procedure Draw3D;
    procedure UpdateMatrix;
    procedure UpdateCaption;
    procedure UpdateInfo;

    procedure SelGraphDelete;
    procedure SelGraphUpdate;

    procedure BuildBG;

    procedure ClearAll;

    function MouseToAngle(mp: TPoint; var orbit: xyzV; var orbitangle: xyzV): boolean;

    function AddUnit(filename: WideString; orbit, orbitangle: single): TabWorldUnit;
    function ReloadUnit(sou: TabWorldUnit): boolean;

    procedure CalcPick(mp: TPoint; var vpos: D3DVECTOR; var vdir: D3DVECTOR);
    function PickTriangle(mp: TPoint): TTriangleAB;
    function PickLine(mp: TPoint): TLineAB;
    function PickUnit(mp: TPoint): TabWorldUnit;
    function PickPoint(mp: TPoint): TPointAB;
    function PickZone(mp: TPoint): TabZone;
    function PickZoneLink(mp: TPoint): TabZoneLink;
    function Pick(mp: TPoint): TList;

    procedure SetTime(t: integer);
  end;

  PSE_PointUnit = ^TSE_PointUnit;

  TSE_PointUnit = packed record
    FOrbit: single;
    FOrbitAngle: single;
    FRadius: single;
    FU: single;
    FV: single;
    FColor: DWORD;
    r1, r2: DWORD;
  end;

var
  FormMain: TFormMain;

  GR_LibD3D8: DWORD = 0;
  GR_lpD3D: IDirect3D8 = nil;
  GR_DMode: D3DDISPLAYMODE;
  GR_lpDev: IDirect3DDevice8 = nil;

  GFileName: WideString;
  GVersion: integer = 3;
  GLoadVersion: integer;

  SE_PointCnt: integer;
  SE_PointBuf: TBufEC;

  SE_ColorKeyBuf: TBufEC;

  GUnitPath: WideString;
  GRangersPath: WideString;

  GWLCount: integer = 32;
  GWLFront: DWORD = $c0ffffff;
  GWLBack: DWORD = $00ffffff;

  GProgrammDir: WideString;

procedure EError(str: string);
function SE_PointGetOrAdd(orbit, orbitangle, radius: single; tu, tv: single; color: DWORD): integer;
procedure SE_ColorKeyBuild(key: TKeyAB; des: TBufEC);
function SE_ColorKeyGetOrAdd(key: TKeyAB; tempbuf: TBufEC): integer;

implementation

uses Form_Options, EC_BlockPar, Form_SaveEnd, Form_About, Form_UnitPath;

{$R *.dfm}

procedure EError(str: string);
begin
  raise Exception.Create(str);
end;

function SE_PointGetOrAdd(orbit, orbitangle, radius: single; tu, tv: single; color: DWORD): integer;
var
  i: integer;
  el: PSE_PointUnit;
begin
  el := SE_PointBuf.Buf;
  for i := 0 to SE_PointCnt - 1 do
  begin
    if (el.FOrbit = orbit) and (el.FOrbitAngle = orbitangle) and (el.FRadius = radius) and
      (el.FU = tu) and (el.FV = tv) and (el.FColor = color) then
    begin
      result := i;
      exit;
    end;
    el := PSE_PointUnit(DWORD(el) + sizeof(TSE_PointUnit));
  end;

  SE_PointBuf.Len := SE_PointBuf.Len + sizeof(TSE_PointUnit);
  el := PSE_PointUnit(DWORD(SE_PointBuf.Buf) + DWORD(SE_PointCnt * sizeof(TSE_PointUnit)));
  el.FOrbit := orbit;
  el.FOrbitAngle := orbitangle;
  el.FRadius := radius;
  el.FU := tu;
  el.FV := tv;
  el.FColor := color;
  el.r1 := 0;
  el.r2 := 0;

  result := SE_PointCnt;
  Inc(SE_PointCnt);
end;

procedure SE_ColorKeyBuild(key: TKeyAB; des: TBufEC);
var
  i, cnt, i1, i2: integer;
  keytimelength: integer;
  t: single;
  //    buf:Pointer;
  wu: TabWorldUnit;
begin
  wu := TabWorldUnit(key.FGroupList.FOwner);
  keytimelength := key.FTimeFull;//CalcTime(key.FCount);
  if keytimelength <= wu.FTimeLength then
    keytimelength := wu.FTimeLength;

  cnt := max(1, keytimelength{key.CalcTime(key.FCount)} div 20);

  //    des.Len:=(cnt+1)*4;
  //    buf:=des.Buf;

  //    PDWORD(buf)^:=cnt; buf:=Ptr(DWORD(buf)+4);
  des.AddInteger(0);
  des.AddInteger(cnt);

  for i := 0 to cnt - 1 do
  begin
    key.CalcInterpolate{Simple}(i * 20, i1, i2, t);
    key.FFunInterpolate(key, i1, i2, t);

    des.AddDWORD(key.IpDWORD);
    //        PDWORD(buf)^:=key.IpDWORD; buf:=Ptr(DWORD(buf)+4);
  end;
end;

procedure SE_ColorGroupKeyBuild(key: TKeyAB; des: TBufEC);
var
  oldcur, i: integer;
  stype: WideString;
  ztype: integer;
begin
  if TabWorldUnit(key.FGroupList.FOwner).FType = 0 then
  begin
    des.Len := 16 + 1 * 8;
    des.S(0, integer(0));
    des.S(4, integer(key.FGroupList.FList.Count));
    des.S(8, integer(0));
    des.S(12, integer(0));
    des.BPointer := des.Len;

    des.S(16 + 0 * 8, integer(des.BPointer));
    des.S(16 + 0 * 8 + 4, integer(0));
    SE_ColorKeyBuild(key, des);

  end
  else
  begin
    des.Len := 16 + key.FGroupList.FList.Count * 8;
    des.S(0, integer(0));
    des.S(4, integer(key.FGroupList.FList.Count));
    des.S(8, integer(TabWorldUnit(key.FGroupList.FOwner).FType));
    des.S(12, integer(0));
    des.BPointer := des.Len;

    oldcur := key.FGroupList.FCur;
    for i := 0 to key.FGroupList.FList.Count - 1 do
    begin
      key.FGroupList.FCur := i;

      ztype := 0;
      stype := TrimEx(TKeyGroup(key.FGroupList.FList.Items[i]).FName);
      if IsIntEC(stype) then
        ztype := StrToIntEC(stype);

      des.S(16 + i * 8, integer(des.BPointer));
      des.S(16 + i * 8 + 4, integer(ztype));
      SE_ColorKeyBuild(key, des);
    end;
    key.FGroupList.FCur := oldcur;
  end;
  des.S(12, des.m_Len);
end;

function SE_ColorKeyGetOrAdd(key: TKeyAB; tempbuf: TBufEC): integer;
var
  sme, len, lent: integer;
begin
  SE_ColorGroupKeyBuild(key, tempbuf);
  lent := tempbuf.Len;

  sme := 0;
  while sme < SE_ColorKeyBuf.Len do
  begin
    len := SE_ColorKeyBuf.GetDWORD(sme + 12);
    if len = lent then
      if CompareMem(Ptr(DWORD(SE_ColorKeyBuf.Buf) + DWORD(sme)), tempbuf.Buf, len) then
      begin
        result := sme;
        exit;
      end;
    sme := sme + len;
  end;

  result := DWORD(SE_ColorKeyBuf.Len);
  SE_ColorKeyBuf.Len := SE_ColorKeyBuf.Len + tempbuf.Len;
  CopyMemory(Ptr(DWORD(SE_ColorKeyBuf.Buf) + DWORD(result)), tempbuf.Buf, tempbuf.Len);
end;

procedure TFormMain.FormCreate(Sender: TObject);
type
  DefDirect3DCreate8 = function(ver: integer): IDirect3D8; stdcall;
var
  Direct3DCreate8: DefDirect3DCreate8;
  d8dpp: D3DPRESENT_PARAMETERS;
  hr: DWORD;
  bp, bp2: TBlockParEC;
  i, cnt: integer;
begin
  //  timeBeginPeriod(1);

  GProgrammDir := GetCurrentDir;

  DecimalSeparator := '.';

  GUnitPath := RegUser_GetString('', 'UnitPath', 'c:');
  GRangersPath := RegUser_GetString('', 'RangersPath', 'c:\Rangers');
  GWLCount := RegUser_GetDWORD('', 'WLCount', GWLCount);
  GWLFront := RegUser_GetDWORD('', 'WLFront', GWLFront);
  GWLBack := RegUser_GetDWORD('', 'WLBack', GWLBack);

  KeyGroupList_List := TList.Create;

  ComboBoxZoneGraph.Items.Clear;
  if FileExists(GRangersPath + '\CFG\CD\ABWall.txt') then
  begin
    bp := TBlockParEC.Create;
    bp.LoadFromFile(PChar(ansistring(GRangersPath + '\CFG\CD\ABWall.txt')));
    bp2 := bp.Block['2'];
    cnt := bp2.Par_Count;
    for i := 0 to cnt - 1 do
      ComboBoxZoneGraph.Items.Add(bp2.Par_GetName(i));
    bp.Free;
  end;

  FFPSLast := 0;
  FFPSCnt := 0;

  Panel3D.Width := 800;
  Panel3D.Height := 600;
  Panel3D.Constraints.MinWidth := Panel3D.Width;
  Panel3D.Constraints.MaxWidth := Panel3D.Width;
  Panel3D.Constraints.MinHeight := Panel3D.Height;
  Panel3D.Constraints.MaxHeight := Panel3D.Height;

  Application.OnMessage := AppMessage;
  Application.OnDeactivate := ApplicationDeactivate;

  ab_Camera_Pos := abPos(45, 45, 0);
  UpdateMatrix;

  GR_LibD3D8 := LoadLibrary('d3d8.dll');
  if GR_LibD3D8 = 0 then
    raise Exception.Create('LoadLibrary');
  Direct3DCreate8 := GetProcAddress(GR_LibD3D8, 'Direct3DCreate8');
  if not Assigned(Direct3DCreate8) then
    raise Exception.Create('GetProcAddress');

  //    GR_lpD3D:=Direct3DCreate8(120);
  asm
           MOV     EAX,120
           push  EAX
           MOV     EAX,Direct3DCreate8
           CALL    EAX
           MOV     GR_lpD3D,EAX
  end;
  if GR_lpD3D = nil then
    raise Exception.Create('Direct3DCreate8');

  hr := GR_lpD3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT, @GR_DMode);
  if hr <> D3D_OK then
    raise Exception.Create('GetAdapterDisplayMode');

  ZeroMemory(@d8dpp, sizeof(D3DPRESENT_PARAMETERS));
  d8dpp.Windowed := true;
  d8dpp.SwapEffect := D3DSWAPEFFECT_DISCARD;
  d8dpp.BackBufferFormat := GR_DMode.Format;
  d8dpp.EnableAutoDepthStencil := true;
  d8dpp.AutoDepthStencilFormat := D3DFMT_D16;
  hr := GR_lpD3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, Panel3D.Handle,
    D3DCREATE_SOFTWARE_VERTEXPROCESSING, @d8dpp, GR_lpDev);
  if hr <> D3D_OK then
    raise Exception.Create('CreateDevice');

  GSmeX := Panel3D.Width div 2;
  GSmeY := Panel3D.Height div 2;

  SWLBuild;
{    with ab_Obj3D_Add do begin
      CreateSphere(ab_WorldRadius/3,12,$ffffffff);
        SetPos(Dxyz(GSmeX,GSmeY,0));
        FUnitFirst.FType:=D3DPT_LINESTRIP;
        FUnitFirst.FCnt:=FUnitFirst.FCnt*3;
    end;}

  BuildBG;

  UpdateInfo();
  UpdateCaption();
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if FBGGraph <> nil then
  begin
    ab_Obj3D_Delete(FBGGraph);
    FBGGraph := nil;
  end;

  GR_lpDev := nil;
  GR_lpD3D := nil;
  if GR_LibD3D8 <> 0 then
  begin
    FreeLibrary(GR_LibD3D8);
    GR_LibD3D8 := 0;
  end;

  KeyGroupList_List.Free;
  KeyGroupList_List := nil;

  //  timeEndPeriod(1);
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  ActiveControl := nil;
end;

procedure TFormMain.AppMessage(var Msg: TMsg; var Handled: boolean);
var
  _ctrl, _shift: boolean;
  ed: boolean;
  zn: single;
  zni, zni2: DWORD;
  //    wu:TabWorldUnit;
  orbit, orbitangle, orbit2, orbitangle2, zangle, zangle2, zdist, zangle3, zdist3: single;
  mp: TPoint;
  zone: TabZone;
  wunit, wunit2: TabWorldUnit;
  apo: TPointAB;
  v, v2: TDxyz;
  m: D3DMATRIX;
begin
  _ctrl := (GetAsyncKeyState(VK_CONTROL) and $8000) = $8000;
  _shift := (GetAsyncKeyState(VK_SHIFT) and $8000) = $8000;

  ed := (ActiveControl <> nil) and ((ActiveControl.ClassName = 'TEdit') or (ActiveControl.ClassName = 'TComboBox')) or
    (not Active);

  Handled := false;
  if (Msg.message = ($400 + 123)) and (not FStopDraw) then
  begin
    if Application.Active then
    begin
      FStopDraw := true;
      Application.ProcessMessages;
      FStopDraw := false;

      //      if not PeekMessage(zmsg,Application.Handle,0,0,PM_NOREMOVE) then begin
      //      if GetQueueStatus(QS_ALLEVENTS or QS_ALLINPUT or QS_ALLPOSTMESSAGE)=0 then begin

      zni2 := timeGetTime;
      zni := zni2 - FTimeLastSet;
      //DM('ABW',IntToStr(zni));
      SetTime(Key_Time + integer(zni));
      FTimeLastSet := zni2;
      //            end;
    end;

    Handled := true;
  end
  else if (Msg.message = WM_PAINT) and (Msg.hwnd = Panel3D.Handle) then //        Draw3D;
    //        Handled:=true;
  else if (Msg.message = WM_KEYDOWN) and (not ed) then
  begin

    if (Msg.wParam = VK_DELETE) and (WorldUnit_Sel <> nil) then
      WorldUnit_Delete(WorldUnit_Sel)
    else if (Msg.wParam = VK_DELETE) and (Zone_Sel <> nil) then
      Zone_Delete(Zone_Sel)
    else if (Msg.wParam = VK_DELETE) and (ZoneLink_Sel <> nil) then
      ZoneLink_Delete(ZoneLink_Sel)
    else if (Msg.wParam = VK_SPACE) and (WorldUnit_Sel <> nil) then
      WorldPort2_Connect(WorldUnit_Sel)
    else if (_ctrl) and (Msg.wParam = integer('P')) then
      MM_View_PointClick(MM_View_Point)
    else if (_ctrl) and (Msg.wParam = integer('W')) then
      MM_View_WorldLineClick(MM_View_WorldLine)
    else if (_ctrl) and (Msg.wParam = integer('B')) then
      MM_View_BackgroundClick(MM_View_Background)
    else if (_ctrl) and (Msg.wParam = integer('Z')) then
      MM_View_ZoneClick(MM_View_Zone)
    else if (Msg.wParam = integer('C')) and (WorldUnit_Sel <> nil) then
    begin
      wunit := WorldUnit_Sel;
      GetCursorPos(mp);
      if MouseToAngle(Panel3D.ScreenToClient(mp), orbit, orbitangle) then
      begin
        wunit2 := AddUnit(WorldUnit_Sel.FFileName, orbit, orbitangle);
        if wunit2 <> nil then
        begin
          wunit2.FType := wunit.FType;
          wunit2.FTimeOffset := wunit.FTimeOffset;
          wunit2.FTimeLength := wunit.FTimeLength;
          wunit2.KeyGroup := wunit.FKeyGroup;

          v := wunit.CalcCenter;
          ab_CalcAngle(v, orbit, orbitangle);
          apo := wunit.GetMaxPointFrom(v);
          ab_CalcAngleAndDist(orbit, orbitangle, 0, apo.FOrbit, apo.FOrbitAngle, ab_WorldRadius, zangle, zdist);
          if zangle < 0 then
            zangle := 360 + zangle;

          v2 := wunit2.CalcCenter;
          ab_CalcAngle(v2, orbit2, orbitangle2);
          apo := wunit2.GetPoint(apo.FId);
          if apo <> nil then
          begin

            ab_CalcAngleAndDist(orbit, orbitangle, 0, orbit2, orbitangle2, ab_WorldRadius, zangle3, zdist3);
            if zangle3 < 0 then
              zangle3 := 360 + zangle3;
            zangle := ab_CalcNewPos(abPos(orbit, orbitangle, zangle), zangle3, zdist3).FAngle;

            ab_CalcAngleAndDist(orbit2, orbitangle2, 0, apo.FOrbit, apo.FOrbitAngle, ab_WorldRadius, zangle2, zdist);
            if zangle2 < 0 then
              zangle2 := 360 + zangle2;
            zangle := AngleDist(zangle, zangle2);

            v2 := D3D_Normalize(v2);
            m := D3D_RotateMatrix(v2, zangle * ToRad);

            apo := Point_First;
            while apo <> nil do
            begin
              if apo.FOwner.IndexOf(wunit2) >= 0 then
              begin
                apo.FPos := D3D_TransformVector(m, apo.FPos);
                ab_CalcAngle(apo.FPos, apo.FOrbit, apo.FOrbitAngle);
                apo.SetOrbit(apo.FOrbit, apo.FOrbitAngle);
              end;
              apo := apo.FNext;
            end;

          end;
        end;
        Key_TimeMax := max(0, Key_CalcFullTime() - 1);
      end;

    end
    else if (Msg.wParam in [VK_UP, VK_DOWN, VK_LEFT, VK_RIGHT]) then
    begin
      zn := 1;
      if _shift or _ctrl then
        zn := zn * 5;

      if Msg.wParam = VK_UP then
        ab_Camera_Pos.FOrbitAngle := max(0, ab_Camera_Pos.FOrbitAngle - zn)
      else if Msg.wParam = VK_DOWN then
        ab_Camera_Pos.FOrbitAngle := min(180, ab_Camera_Pos.FOrbitAngle + zn)
      else if Msg.wParam = VK_LEFT then
        ab_Camera_Pos.FOrbit := AngleCorrect360(ab_Camera_Pos.FOrbit - zn)
      else if Msg.wParam = VK_RIGHT then
        ab_Camera_Pos.FOrbit := AngleCorrect360(ab_Camera_Pos.FOrbit + zn);
      //      Draw3D;

    end
    else if (Msg.wParam in [VK_PRIOR, VK_NEXT]) then
    begin
      if Msg.wParam = VK_PRIOR then
        zn := -100
      else
        zn := 100;
      ab_Camera_Radius := ab_Camera_Radius + zn;

    end
    else if (Msg.wParam in [VK_PRIOR, VK_HOME]) then
      ab_Camera_Radius := ab_WorldRadius + ab_Camera_RadiusDefaultFW
    else if (Msg.wParam = integer('Z')) then
    begin
      FormMain.MM_View_Zone.Checked := true;

      GetCursorPos(mp);
      if MouseToAngle(Panel3D.ScreenToClient(mp), orbit, orbitangle) then
      begin
        if ZoneLink_Sel <> nil then
          ZoneLink_Sel.FSel := false;
        if Zone_Sel <> nil then
          Zone_Sel.FSel := false;

        apo := Point_First;
        while apo <> nil do
        begin
          if apo.FSel then
            apo.Sel := false;
          apo := apo.FNext;
        end;

        wunit := WorldUnit_Sel;
        if wunit <> nil then
        begin
          wunit.FSel := false;
          wunit.UpdateGraph;
        end;

        zone := Zone_Add;
        zone.FOrb := orbit;
        zone.FOrbAngle := orbitangle;
        zone.FRadiusAngle := (50 * 180) / (pi * ab_WorldRadius);
        zone.FSel := true;
        zone.CalcPos;
      end;

    end;

    UpdateInfo;
  end;
end;

procedure TFormMain.ApplicationDeactivate(Sender: TObject);
begin
  if (FMove) or (FMoveWorld) or (FActionType > 0) then
  begin
    FMove := false;
    FMoveWorld := false;
    FActionType := 0;

    Screen.Cursor := crDefault;
    Mouse.Capture := 0;
  end;
end;

procedure TFormMain.Panel3DMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
//var
//    _ctrl,_shift:boolean;
begin
  //    _ctrl:=(GetAsyncKeyState(VK_CONTROL) and $8000)=$8000;
  //    _shift:=(GetAsyncKeyState(VK_SHIFT) and $8000)=$8000;
  ActiveControl := nil;

  if (ssRight in Shift) then
    if (WorldUnit_Sel <> nil) and (PickUnit(Point(x, y)) = WorldUnit_Sel) then
    begin
      if MouseToAngle(Point(x, y), FMoveOrbit, FMoveOrbitAngle) then
      begin
        FMove := true;
        FMoveLP := Point(x, y);
        FRotate := false;

        Screen.Cursor := crSizeAll;
        Mouse.Capture := Panel3D.Handle;
      end;
    end
    else if (Point_Sel <> nil) and (PickPoint(Point(x, y)) <> nil) and (ab_InTop(PickPoint(Point(x, y)).FPosShow.z)) then
    begin
      if MouseToAngle(Point(x, y), FMoveOrbit, FMoveOrbitAngle) then
      begin
        FMove := true;
        FMoveLP := Point(x, y);

        Screen.Cursor := crSizeAll;
        Mouse.Capture := Panel3D.Handle;
      end;

    end
    else if (Zone_Sel <> nil) and (PickZone(Point(x, y)) <> nil) then
    begin
      if MouseToAngle(Point(x, y), FMoveOrbit, FMoveOrbitAngle) then
      begin
        if ssCtrl in Shift then
          FActionType := 2
        else
          FActionType := 1;
        FMoveLP := Point(x, y);

        Screen.Cursor := crSizeAll;
        Mouse.Capture := Panel3D.Handle;
      end;

    end
    else
    begin
      FMoveWorld := true;
      FMoveLP := Point(x, y);

      Screen.Cursor := crSizeAll;
      Mouse.Capture := Panel3D.Handle;
    end(*    end else if (ssLeft in Shift) and (not FMove) then begin
    wunitSel:=WorldUnit_Sel;
      wunit:=PickUnit(Point(x,y));

        apo:=PickPoint(Point(x,y));
        if _ctrl or _shift or (apo<>nil) then begin
          wunit:=nil;

            if (not (_ctrl or _shift)) or (apo=nil) then begin
              apo2:=Point_First;
                while apo2<>nil do begin
                  if apo2.FSel then apo2.Sel:=false;
                  apo2:=apo2.FNext;
                end;
            end;

            if (apo<>nil) and (not (_ctrl or _shift)) then begin
              apo.Sel:=true;
            end else if apo<>nil then begin
              apo.Sel:=not apo.Sel;
            end;
        end else begin
            apo2:=Point_First;
          while apo2<>nil do begin
                if apo2.FSel then apo2.Sel:=false;
              apo2:=apo2.FNext;
          end;
        end;

      if (wunit<>nil) and (wunit<>wunitSel) then begin
        if wunitSel<>nil then begin
          wunitSel.FSel:=false;
        wunitSel.UpdateGraph;
          end;

          wunit.FSel:=true;
      end else if (wunit=nil) and (wunitSel<>nil) then begin
        if wunitSel<>nil then begin
          wunitSel.FSel:=false;
        wunitSel.UpdateGraph;
          end;
        end;*);

  if (not (FMove or FMoveWorld)) and (FActionType = 0) and ((ssLeft in Shift)) and (not (ssRight in Shift)) then
  begin
    FSel := true;
    FSelRect := Rect(x, y, x, y);
    //        FSelGraph:TabObj3D;

  end;
end;

procedure TFormMain.Panel3DMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  zn: integer;
  wunit, wunitSel: TabWorldUnit;
  apo, apo2: TPointAB;
  _ctrl, _shift: boolean;
  selcancel: boolean;
  zone, zoneSel: TabZone;
  zl, zlSel: TabZoneLink;
  obj: TObject;
  li: TList;
begin
  _ctrl := (GetAsyncKeyState(VK_CONTROL) and $8000) = $8000;
  _shift := (GetAsyncKeyState(VK_SHIFT) and $8000) = $8000;

  selcancel := false;

  if ((FMove) or (FMoveWorld) or (FActionType > 0)) and (Button = mbRight) then
  begin
    FMove := false;
    FMoveWorld := false;
    FActionType := 0;

    Screen.Cursor := crDefault;
    Mouse.Capture := 0;
  end
  else if FSel and (Button = mbLeft) then
  begin
    if FSelGraph <> nil then
    begin
      if FSelRect.Left > FSelRect.Right then
      begin
        zn := FSelRect.Left;
        FSelRect.Left := FSelRect.Right;
        FSelRect.Right := zn;
      end;
      if FSelRect.Top > FSelRect.Bottom then
      begin
        zn := FSelRect.Top;
        FSelRect.Top := FSelRect.Bottom;
        FSelRect.Bottom := zn;
      end;
      FSelRect.Left := FSelRect.Left - GSmeX;
      FSelRect.Top := FSelRect.Top - GSmeY;
      FSelRect.Right := FSelRect.Right - GSmeX;
      FSelRect.Bottom := FSelRect.Bottom - GSmeY;

      if not (ssCtrl in Shift) then
      begin
        apo := Point_First;
        while apo <> nil do
        begin
          if apo.FSel then
            apo.Sel := false;
          apo := apo.FNext;
        end;
      end;

      wunit := WorldUnit_Sel;
      if wunit <> nil then
      begin
        wunit.FSel := false;
        wunit.UpdateGraph;
      end;

      apo := Point_First;
      while apo <> nil do
      begin
        if (apo.FPosShow.x >= FSelRect.Left) and (apo.FPosShow.x <= FSelRect.Right) and
          (apo.FPosShow.y >= FSelRect.Top) and (apo.FPosShow.y <= FSelRect.Bottom) and
          ab_InTop(apo.FPosShow.z) then
          if not (ssCtrl in Shift) then
            apo.Sel := true
          else
            apo.Sel := not apo.Sel;
        apo := apo.FNext;
      end;

      selcancel := true;
    end;

    FSel := false;
    SelGraphUpdate;
  end;

  if (Button = mbLeft) and (not FMove) and (not selcancel) then
  begin
    zoneSel := Zone_Sel;
    zlSel := ZoneLink_Sel;
    wunitSel := WorldUnit_Sel;

    if zoneSel <> nil then
    begin
      zoneSel.FSel := false;
      zoneSel.UpdateGraph;
    end;
    if zlSel <> nil then
      zlSel.FSel := false//      zlSel.UpdateGraph;
    ;
    if wunitSel <> nil then
    begin
      wunitSel.FSel := false;
      wunitSel.UpdateGraph;
    end;

    if _ctrl or _shift then
    begin
      zone := PickZone(Point(x, y));

      if (zoneSel <> nil) and (zone <> nil) and (zoneSel <> zone) and (ZoneLink_Find(zoneSel, zone) = nil) and
        (ZoneLink_Find(zone, zoneSel) = nil) then
      begin
        zl := ZoneLink_Add;
        zl.FStart := zoneSel;
        zl.FEnd := zone;

        zone.FSel := true;
        zone.UpdateGraph;
      end
      else
      begin
        apo := PickPoint(Point(x, y));

        if apo <> nil then
          apo.Sel := not apo.Sel;
      end;
    end
    else
    begin
      apo2 := Point_First;
      while apo2 <> nil do
      begin
        if apo2.FSel then
          apo2.Sel := false;
        apo2 := apo2.FNext;
      end;

      obj := zoneSel;
      if obj = nil then
        obj := zlSel;
      if obj = nil then
        obj := wunitSel;

      li := Pick(Point(x, y));
      if li <> nil then
      begin
        zn := li.IndexOf(obj);
        if zn >= 0 then
        begin
          Inc(zn);
          if zn >= li.Count then
            zn := 0;
          obj := li.Items[zn];
        end
        else
          obj := li.Items[0];
        li.Free;

        if obj is TabZone then
        begin
          zone := obj as TabZone;
          zone.FSel := true;
          zone.UpdateGraph;
        end
        else if obj is TabZoneLink then
        begin
          zl := obj as TabZoneLink;
          zl.FSel := true;
          //                    zl.UpdateGraph;
        end
        else if obj is TabWorldUnit then
        begin
          wunit := obj as TabWorldUnit;
          wunit.FSel := true;
          wunit.UpdateGraph;
        end
        else if obj is TPointAB then
        begin
          apo := obj as TPointAB;
          apo.Sel := true;
        end;
      end;
    end;
{
    wunitSel:=WorldUnit_Sel;
      wunit:=PickUnit(Point(x,y));

        zoneSel:=Zone_Sel;
        zone:=PickZone(Point(x,y));

        apo:=PickPoint(Point(x,y));
        if (apo<>nil) and (apo.FSel) and (wunit<>nil) and (not wunit.FSel) then apo:=nil;
        if _ctrl or _shift or (apo<>nil) then begin
          wunit:=nil;

            if (not (_ctrl or _shift)) or (apo=nil) then begin
              apo2:=Point_First;
                while apo2<>nil do begin
                  if apo2.FSel then apo2.Sel:=false;
                  apo2:=apo2.FNext;
                end;
            end;

            if (apo<>nil) and (not (_ctrl or _shift)) then begin
              apo.Sel:=true;
            end else if apo<>nil then begin
              apo.Sel:=not apo.Sel;
            end;
        end else begin
            apo2:=Point_First;
          while apo2<>nil do begin
                if apo2.FSel then apo2.Sel:=false;
              apo2:=apo2.FNext;
          end;
        end;

      if (wunit<>nil) and (wunit<>wunitSel) then begin
        if wunitSel<>nil then begin
          wunitSel.FSel:=false;
        wunitSel.UpdateGraph;
          end;

          wunit.FSel:=true;
      end else if (wunit=nil) and (wunitSel<>nil) then begin
        if wunitSel<>nil then begin
          wunitSel.FSel:=false;
        wunitSel.UpdateGraph;
          end;
        end;

        if (zone<>nil) and (wunit=nil) and (apo=nil) then begin
          if _ctrl and (zoneSel<>nil) and (zone<>zoneSel) then begin
              if (ZoneLink_Find(zoneSel,zone)=nil) and (ZoneLink_Find(zone,zoneSel)=nil) then begin
                zl:=ZoneLink_Add;
                  zl.FStart:=zoneSel;
                  zl.FEnd:=zone;
                end;
            end else begin
          if zoneSel<>nil then begin
            zoneSel.FSel:=false;
          zoneSel.UpdateGraph;
            end;

              zone.FSel:=true;
            end;
        end else begin
        if zoneSel<>nil then begin
          zoneSel.FSel:=false;
        zoneSel.UpdateGraph;
          end;
        end;

        zl:=PickZoneLink(Point(x,y));
        if (zl<>nil) and (wunit=nil) and (apo=nil) and (zone=nil) then begin
          if ZoneLink_Sel<>nil then ZoneLink_Sel.FSel:=false;
            zl.FSel:=true;
        end else begin
          if ZoneLink_Sel<>nil then ZoneLink_Sel.FSel:=false;
        end;}

    UpdateInfo();
  end;
end;

procedure TFormMain.Panel3DMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
var
  hitok: boolean;
  orbit, orbitangle: single;
  wunit: TabWorldUnit;
  apo: TPointAB;
  li: TList;
  zang, zdist: xyzV;
  zang2, zdist2: xyzV;
  ap: TabPos;
  center: TDxyz;
  i: integer;
  m: D3DMATRIX;
  zone: TabZone;
begin
  hitok := MouseToAngle(Point(x, y), orbit, orbitangle);
  if hitok then
    LabelCoord.Caption := Format('%.2f,%.2f', [orbit, orbitangle])
  else
    LabelCoord.Caption := '';

  if FMove and (hitok) and (WorldUnit_Sel <> nil) and (not (ssLeft in Shift)) and (not FRotate) then
  begin
    wunit := WorldUnit_Sel;
    li := Point_Find(wunit);

    ab_CalcAngleAndDist(FMoveOrbit, FMoveOrbitAngle, 0, orbit, orbitangle, ab_WorldRadius, zang, zdist);
    if zang < 0 then
      zang := 360 + zang;
    for i := 0 to li.Count - 1 do
    begin
      apo := li.Items[i];
      //            if apo.FParent=nil then begin
      ab_CalcAngleAndDist(FMoveOrbit, FMoveOrbitAngle, 0, apo.FOrbit, apo.FOrbitAngle, ab_WorldRadius, zang2, zdist2);
      if zang2 < 0 then
        zang2 := 360 + zang2;
      ap := ab_CalcNewPos(abPos(FMoveOrbit, FMoveOrbitAngle, zang), zang2, zdist2);
      with ab_CalcNewPos(ap, zdist) do
      begin
        apo.SetOrbit(FOrbit, FOrbitAngle);
        apo.CalcCenterOwner;
      end;
      //            end;
    end;

    FMoveOrbit := orbit;
    FMoveOrbitAngle := orbitangle;

    li.Free;

    //        WorldUnit_CalcCenter;

  end
  else if FMove and (WorldUnit_Sel <> nil) and (ssLeft in Shift) then
  begin
    FRotate := true;

    wunit := WorldUnit_Sel;
    li := Point_Find(wunit);

    center := Dxyz(0, 0, 0);
    for i := 0 to li.Count - 1 do
    begin
      apo := li.Items[i];
      center.x := center.x + apo.FPos.x;
      center.y := center.y + apo.FPos.y;
      center.z := center.z + apo.FPos.z;
    end;
    center.x := center.x / li.Count;
    center.y := center.y / li.Count;
    center.z := center.z / li.Count;
    center := D3D_Normalize(center);
    m := D3D_RotateMatrix(center, (FMoveLP.x - x) * 0.5 * ToRad);

    for i := 0 to li.Count - 1 do
    begin
      apo := li.Items[i];
      if apo.FOwner.Count <= 1 then
      begin
        apo.FPos := D3D_TransformVector(m, apo.FPos);
        ab_CalcAngle(apo.FPos, apo.FOrbit, apo.FOrbitAngle);
        apo.SetOrbit(apo.FOrbit, apo.FOrbitAngle);
        //              apo.CalcPos;
        apo.CalcCenterOwner;
      end;
    end;

    li.Free;

    //        wunit.BBBuild;

    //        WorldUnit_CalcCenter;

  end
  else if FMove and hitok then
  begin
    ab_CalcAngleAndDist(FMoveOrbit, FMoveOrbitAngle, 0, orbit, orbitangle, ab_WorldRadius, zang, zdist);
    if zang < 0 then
      zang := 360 + zang;

    apo := Point_First;
    while apo <> nil do
    begin
      if not apo.FSel then
      begin
        apo := apo.FNext;
        continue;
      end;
      if apo.FParent <> nil then
      begin
        apo := apo.FNext;
        continue;
      end;

      ab_CalcAngleAndDist(FMoveOrbit, FMoveOrbitAngle, 0, apo.FOrbit, apo.FOrbitAngle, ab_WorldRadius, zang2, zdist2);
      if zang2 < 0 then
        zang2 := 360 + zang2;
      ap := ab_CalcNewPos(abPos(FMoveOrbit, FMoveOrbitAngle, zang), zang2, zdist2);
      with ab_CalcNewPos(ap, zdist) do
      begin
        apo.SetOrbit(FOrbit, FOrbitAngle);
        apo.CalcCenterOwner;
      end;

      apo := apo.FNext;
    end;

    FMoveOrbit := orbit;
    FMoveOrbitAngle := orbitangle;

    //        WorldUnit_CalcCenter;

  end
  else if FMoveWorld then
  begin
    ab_Camera_Pos.FOrbitAngle := ab_Camera_Pos.FOrbitAngle + (FMoveLP.y - y) * 0.2;
    if ab_Camera_Pos.FOrbitAngle < 0 then
      ab_Camera_Pos.FOrbitAngle := 0
    else if ab_Camera_Pos.FOrbitAngle > 180 then
      ab_Camera_Pos.FOrbitAngle := 180;

    ab_Camera_Pos.FOrbit := AngleCorrect360(ab_Camera_Pos.FOrbit + (FMoveLP.x - x) * 0.2);

  end
  else if FSel then
  begin
    FSelRect.BottomRight := Point(x, y);
    if (FSelGraph <> nil) or ((sqr(FSelRect.Left - FSelRect.Right) + sqr(FSelRect.Top - FSelRect.Bottom)) > sqr(2)) then
      SelGraphUpdate;

  end
  else if FActionType = 1 then
  begin
    zone := Zone_Sel;
    if hitok then
    begin
      zone.FOrb := orbit;
      zone.FOrbAngle := orbitangle;
      zone.CalcPos;
    end;

  end
  else if FActionType = 2 then
  begin
    zone := Zone_Sel;
    if hitok then
    begin
      ab_CalcAngleAndDist(zone.FOrb, zone.FOrbAngle, 0, orbit, orbitangle, ab_WorldRadius, zang, zdist);
      zone.FRadiusAngle := (zdist * 180) / (pi * ab_WorldRadius);
      zone.CalcPos;
    end;

  end;

  FMoveLP := Point(x, y);
end;

procedure TFormMain.SWLClear;
var
  i: integer;
begin
  if FSWL = nil then
    exit;
  for i := 0 to FSWL.Count - 1 do
    WorldLine_Delete(TabWorldLine(FSWL.Items[i]));
  FSWL.Free;
  FSWL := nil;
end;

procedure TFormMain.SWLBuild;
var
  v1, v2{,v3}: TDxyz;
  di, dt, dtstep, distep: xyzV;
  wl: TabWorldLine;
begin
  SWLClear;

  FSWL := TList.Create;

  dtstep := (pi * 2) / GWLCount;
  distep := pi / GWLCount;

  //    v3:=ab_CalcPos(0,0,0);
  //    v3:=ab_TransformVector(ab_Camera_MatEnd,v3);

  dt := 0;
  while dt < (pi * 2 - 0.001) do
  begin
    di := distep * 2;
    while di < (pi - distep * 2 - 0.001) do
    begin
      v1 := ab_CalcPos(dt, di, ab_WorldRadius);
      v2 := ab_CalcPos(dt, di + distep, ab_WorldRadius);

      wl := WorldLine_Add;
      wl.FStart := v1;
      wl.FEnd := v2;
      wl.FFrontColor := GWLFront;
      wl.FBackColor := GWLBack;
      FSWL.Add(wl);

      di := di + distep;
    end;
    dt := dt + dtstep;
  end;

  distep := distep * 2;

  di := distep;//*2;
  while di < (pi - distep{*2} + 0.001) do
  begin
    dt := 0;
    while dt < (2 * pi - 0.001) do
    begin
      v1 := ab_CalcPos(dt, di, ab_WorldRadius);
      v2 := ab_CalcPos(dt + dtstep, di, ab_WorldRadius);

      wl := WorldLine_Add;
      wl.FStart := v1;
      wl.FEnd := v2;
      wl.FFrontColor := GWLFront;
      wl.FBackColor := GWLBack;
      FSWL.Add(wl);

      dt := dt + dtstep;
    end;
    di := di + distep;
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  //  Draw3D;
end;

procedure TFormMain.Draw3D;
var
  //  i:integer;
  dwzn: DWORD;
begin
  if not Application.Active then
    exit;
  //  Edit1.Text:=IntToStr(integer(Application.Active));

  dwzn := timeGetTime;
  if (dwzn - FFPSLast) > 1000 then
  begin
    LabelFPS.Caption := IntToStr(FFPSCnt);
    FFPSLast := dwzn;
    FFPSCnt := 0;
  end
  else
    Inc(FFPSCnt);

  UpdateMatrix;
  ab_CalcZPos;

  WorldUnit_CalcDraw;

  Zone_UpdateGraph;
  ZoneLink_UpdateGraph;
  Point_Update;
  Triangle_UpdateGraph;
  Line_UpdateGraph;
  WorldLine_UpdateGraph;
  WorldUnit_SelUpdateGraph;

  if GR_lpDev.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0, 0, 0), 1.0, 0) <> D3D_OK then
    EError('TabObj3D Dev.Clear');
  if GR_lpDev.BeginScene <> D3D_OK then
    EError('TabObj3D BeginScene');

  GR_lpDev.SetRenderState(D3DRS_COLORVERTEX, DWORD(true));
  GR_lpDev.SetRenderState(D3DRS_ALPHABLENDENABLE, DWORD(true));
  GR_lpDev.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
  GR_lpDev.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

  GR_lpDev.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW {D3DCULL_NONE});

  GR_lpDev.SetRenderState(D3DRS_CLIPPING, DWORD(false));

  //    GR_lpDev.SetRenderState(D3DRS_FILLMODE,DWORD(D3DFILL_WIREFRAME));

  GR_lpDev.SetRenderState(D3DRS_DITHERENABLE, DWORD(true));

  GR_lpDev.SetRenderState(D3DRS_ZENABLE, DWORD(true));
  GR_lpDev.SetRenderState(D3DRS_ZWRITEENABLE, DWORD(true));
  GR_lpDev.SetRenderState(D3DRS_ZFUNC, DWORD({D3DCMP_GREATEREQUAL}  D3DCMP_LESSEQUAL));

  GR_lpDev.SetTextureStageState(0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR);
  GR_lpDev.SetTextureStageState(0, D3DTSS_MINFILTER, D3DTEXF_LINEAR);
  GR_lpDev.SetTextureStageState(0, D3DTSS_MIPFILTER, D3DTEXF_LINEAR);

  //    GR_lpDev.SetRenderState(D3DRS_EDGEANTIALIAS,DWORD(true));

  ab_Obj3D_Draw(0);
  ab_Obj3D_Draw(1);

  if GR_lpDev.EndScene <> D3D_OK then
    EError('TabObj3D EndScene');
  if GR_lpDev.Present(nil, nil, 0, nil) <> D3D_OK then
    EError('TabObj3D Present');
end;

procedure TFormMain.UpdateMatrix;
var
  v1, v2, v3: TDxyz;
  tm1, tm2: D3DMATRIX;
begin
{    Camera_MatView:=D3D_ViewMatrix(Camera_Pos,Camera_Des,Camera_Up);
  Camera_MatProj:=D3D_ProjectionMatrix(1,1000,Camera_Fov*ToRad,Panel3D.Width);
    Camera_MatEnd:=D3D_MatrixMult(Camera_MatProj,Camera_MatView);}

  v1 := ab_CalcPos(Angle360ToRad(ab_Camera_Pos.FOrbit), Angle360ToRad(ab_Camera_Pos.FOrbitAngle), ab_Camera_Radius);
  v2 := Dxyz(0, 0, 0);
  v3 := ab_CalcPos(Angle360ToRad(ab_Camera_Pos.FOrbit), Angle360ToRad(ab_Camera_Pos.FOrbitAngle + 90), ab_Camera_Radius);

  tm1 := D3D_ViewMatrix(v1, v2, v3);
  tm2 := D3D_RotateZMatrix(Angle360ToRad(ab_Camera_Pos.FAngle));
  ab_Camera_MatView := D3D_MatrixMult(tm2, tm1);
  //    ab_Camera_MatProj:=D3D_ProjectionMatrix(1,ab_WorldRadius*2.1,Angle360ToRad(ab_Camera_Fov),Panel3D.Width);
  ab_Camera_MatProj := D3D_ProjectionMatrix(ab_Camera_Radius - ab_WorldRadius - 100, ab_Camera_Radius +
    ab_WorldRadius + 100, Angle360ToRad(ab_Camera_Fov), Panel3D.Width);
  ab_Camera_MatEnd := D3D_MatrixMult(ab_Camera_MatProj, ab_Camera_MatView);
end;

procedure TFormMain.UpdateCaption;
var
  tstr: WideString;
begin
  tstr := 'Rangers ABWorld v0.' + IntToStr(GVersion);
  if GFileName <> '' then
    tstr := tstr + ' [' + File_Name(GFileName) + ']';

  Caption := tstr;
end;

procedure TFormMain.UpdateInfo;
var
  wu: TabWorldUnit;
  kgl: TKeyGroupList;
  i: integer;
  zone: TabZone;
  zl: TabZoneLink;
begin
  wu := WorldUnit_Sel;
  zone := Zone_Sel;
  zl := ZoneLink_Sel;

  if wu <> nil then
  begin
    NotebookAction.ActivePage := 'Unit';

    ComboBoxUnitType.ItemIndex := wu.FType;
    EditUnitTimeOffset.Text := IntToStr(wu.FTimeOffset);
    EditUnitTimeLength.Text := IntToStr(wu.FTimeLength);

    ComboBoxUnitKeyGroup.Items.Clear;
    kgl := KeyGroupList_Get(wu);
    for i := 0 to kgl.FList.Count - 1 do
      ComboBoxUnitKeyGroup.Items.Add(TKeyGroup(kgl.FList.Items[i]).FName);
    ComboBoxUnitKeyGroup.ItemIndex := wu.FKeyGroup;

  end
  else if zone <> nil then
  begin
    NotebookAction.ActivePage := 'Zone';

    ComboBoxZoneType.ItemIndex := zone.FType;
    EditZoneRadius.Text := IntToStr(Round(zone.FRadius));
    ComboBoxZoneGraph.Text := zone.FGraph;
    EditZoneHitpoints.Text := IntToStr(zone.FHitpoints);
    EditZoneMass.Text := IntToStr(zone.FMass);
    EditZoneDamage.Text := IntToStr(zone.FDamage);

    CheckBoxZoneI0.Checked := boolean((zone.FItem shr 0) and 1);
    CheckBoxZoneI1.Checked := boolean((zone.FItem shr 1) and 1);
    CheckBoxZoneI2.Checked := boolean((zone.FItem shr 2) and 1);
    CheckBoxZoneI3.Checked := boolean((zone.FItem shr 3) and 1);
    CheckBoxZoneI4.Checked := boolean((zone.FItem shr 4) and 1);
    CheckBoxZoneI5.Checked := boolean((zone.FItem shr 5) and 1);
    CheckBoxZoneI6.Checked := boolean((zone.FItem shr 6) and 1);
    CheckBoxZoneI7.Checked := boolean((zone.FItem shr 7) and 1);
    CheckBoxZoneI31.Checked := boolean((zone.FItem shr 31) and 1);
    ComboBoxZoneIFreq.ItemIndex := zone.FItemFreq;

  end
  else if zl <> nil then
  begin
    NotebookAction.ActivePage := 'ZoneLink';

    ComboBoxZoneLinkType.ItemIndex := zl.FType;

  end
  else
  begin
    NotebookAction.ActivePage := 'Main';

    EditMainWorldRadius.Text := IntToStr(Round(ab_WorldRadius));
  end;
end;

procedure TFormMain.SelGraphDelete;
begin
  if FSelGraph <> nil then
  begin
    ab_Obj3D_Delete(FSelGraph);
    FSelGraph := nil;
  end;
end;

procedure TFormMain.SelGraphUpdate;
begin
  if not FSel then
  begin
    SelGraphDelete;
    exit;
  end;
  if FSelGraph = nil then
  begin
    FSelGraph := ab_Obj3D_Add;
    FSelGraph.VerCount := 4;
    FSelGraph.UnitAddTriangle(0, 1, 3, '');
    FSelGraph.UnitAddTriangle(1, 2, 3, '');

    FSelGraph.UnitAddTriangle(1, 0, 3, '');
    FSelGraph.UnitAddTriangle(2, 1, 3, '');
  end;

  FSelGraph.VerOpen;
  FSelGraph.Ver(0)^ := abVer3D(FSelRect.Left, FSelRect.Top, 0, 0, 0, $80ff0000);
  FSelGraph.Ver(1)^ := abVer3D(FSelRect.Right, FSelRect.Top, 0, 0, 0, $80ff0000);
  FSelGraph.Ver(2)^ := abVer3D(FSelRect.Right, FSelRect.Bottom, 0, 0, 0, $80ff0000);
  FSelGraph.Ver(3)^ := abVer3D(FSelRect.Left, FSelRect.Bottom, 0, 0, 0, $80ff0000);
  FSelGraph.VerClose;
end;

procedure TFormMain.BuildBG;
begin
  FBGGraph := ab_Obj3D_Add.Create;
  FBGGraph.FDrawFromObjLoop := MM_View_Background.Checked;
  FBGGraph.VerCount := 4;
  FBGGraph.VerOpen;
  FBGGraph.Ver(0)^ := abVer3D(0, 0, 1, 0, 0, $ffffffff);
  FBGGraph.Ver(1)^ := abVer3D(800, 0, 1, 1, 0, $ffffffff);
  FBGGraph.Ver(2)^ := abVer3D(800, 600, 1, 1, 1, $ffffffff);
  FBGGraph.Ver(3)^ := abVer3D(0, 600, 1, 0, 1, $ffffffff);
  FBGGraph.VerClose;
  FBGGraph.UnitAddTriangle(0, 1, 2, GProgrammDir + '\bg.jpg');
  FBGGraph.UnitAddTriangle(2, 3, 0, GProgrammDir + '\bg.jpg');
end;

procedure TFormMain.ClearAll;
begin
  ZoneLink_Clear;
  Zone_Clear;
  Line_Clear;
  Triangle_Clear;
  Point_Clear;
  WorldUnit_Clear;
  SWLClear;
  WorldLine_Clear;
  FBGGraph := nil;
  ab_Obj3D_Clear;
  BuildBG;
end;

function TFormMain.MouseToAngle(mp: TPoint; var orbit: xyzV; var orbitangle: xyzV): boolean;
var
  v, v1, v2: Tdxyz;
  m: TMatrix4;
begin
  //  mp:=FPanelSE.ScreenToWorld(mp);
  mp.x := mp.x - GSmeX;
  mp.y := mp.y - GSmeY;

  D3D_InverseMatrix(ab_Camera_MatProj, m);
  v := Dxyz(mp.x, mp.y, 1);
  v := D3D_TransformVector(m, v);

  D3D_InverseMatrix(ab_Camera_MatView, m);

  v2.x := v.x * m.m[0, 0] + v.y * m.m[1, 0] + v.z * m.m[2, 0];
  v2.y := v.x * m.m[0, 1] + v.y * m.m[1, 1] + v.z * m.m[2, 1];
  v2.z := v.x * m.m[0, 2] + v.y * m.m[1, 2] + v.z * m.m[2, 2];

  v1.x := m.m[3, 0];
  v1.y := m.m[3, 1];
  v1.z := m.m[3, 2];

  result := IntersectionSphereEx(v1, Dxyz(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z), Dxyz(0, 0, 0), ab_WorldRadius, v1);
  if not result then
    exit;

  ab_CalcAngle(v1, orbit, orbitangle);
end;

procedure TFormMain.MM_Unit_LoadClick(Sender: TObject);
var
  orbit, orbitangle: single;
begin
  if not OpenDialogUnit.Execute then
    exit;

  if MouseToAngle(Point(GSmeX, GSmeY), orbit, orbitangle) then
  begin
    AddUnit(BuildPathRel(LowerCaseEx(BuildPathTrim(OpenDialogUnit.FileName)), GUnitPath), orbit, orbitangle);
    Key_TimeMax := max(0, Key_CalcFullTime() - 1);
  end;
end;

function TFormMain.AddUnit(filename: WideString; orbit, orbitangle: single): TabWorldUnit;
var
  un: TabWorldUnit;
  wun2: TabWorldUnit;
begin
  result := nil;

  un := WorldUnit_Add;
  try
    un.Load(filename, orbit, orbitangle);

    wun2 := WorldUnit_Sel;
    if wun2 <> nil then
    begin
      wun2.FSel := false;
      wun2.UpdateGraph;
    end;

    un.FSel := true;
    un.CalcCenter;
    result := un;
  except
    WorldUnit_Delete(un);
  end;
end;

function TFormMain.ReloadUnit(sou: TabWorldUnit): boolean;
var
  des: TabWorldUnit;
  sou_list: array of TPointAB;
  des_list: array of TPointAB;
  des_orb: array of xyzV;
  des_orbAngle: array of xyzV;
  sou_apo, des_apo: TPointAB;
  _rel: integer;
  sou_center, des_center: TDxyz;
  i, u, cnt, sou_cnt, des_cnt: integer;
  d, mind: single;
  sou_orb_center, sou_orbangle_center: xyzV;
  des_orb_center, des_orbangle_center: xyzV;
  sou_angle_rel, sou_r_rel: xyzV;
  sou_angle_p, sou_r_p: xyzV;
  des_angle_rel, des_r_rel: xyzV;
  des_angle_p, des_r_p, angle_p: xyzV;
begin
  sou_center := sou.CalcCenter;
  ab_CalcAngle(sou_center, sou_orb_center, sou_orbangle_center);

  result := false;
  des := AddUnit(sou.FFileName, sou_orb_center, sou_orbangle_center);
  if des = nil then
    exit;

  sou_cnt := sou.PointCnt();
  des_cnt := des.PointCnt();
  if (sou_cnt < 1) or (des_cnt < 1) then
  begin
    WorldUnit_Delete(des);
    exit;
  end;

  //    if (sou.PointCnt()>des.PointCnt()) then begin WorldUnit_Delete(des); Exit; end;

  cnt := Max(sou_cnt, des_cnt);
  SetLength(sou_list, cnt);
  for i := 0 to cnt - 1 do
    sou_list[i] := nil;
  SetLength(des_list, cnt);
  for i := 0 to cnt - 1 do
    des_list[i] := nil;
  SetLength(des_orb, cnt);
  SetLength(des_orbAngle, cnt);

  des_center := des.CalcCenter;

  _rel := 0;
  mind := 1e20;
  i := 0;
  sou_apo := Point_First;
  while sou_apo <> nil do
  begin
    if sou_apo.FOwner.IndexOf(sou) >= 0 then
    begin
      sou_list[i] := sou_apo;
      des_apo := des.GetPoint(sou_apo.FId);
      if des_apo <> nil then
      begin
        des_list[i] := des_apo;

        d := sqr(sou_center.x - sou_apo.FPos.x) + sqr(sou_center.y - sou_apo.FPos.y) + sqr(sou_center.z - sou_apo.FPos.z);
        if d < mind then
        begin
          mind := d;
          _rel := i;
        end;
      end;
      Inc(i);
    end;
    sou_apo := sou_apo.FNext;
  end;

  des_apo := Point_First;
  while des_apo <> nil do
  begin
    if des_apo.FOwner.IndexOf(des) >= 0 then
    begin
      u := 0;
      while u < i do
      begin
        if des_list[u] = des_apo then
          break;
        Inc(u);
      end;
      if u >= i then
      begin
        des_list[i] := des_apo;
        Inc(i);
      end;
    end;
    des_apo := des_apo.FNext;
  end;

  for i := 0 to cnt - 1 do
  begin
    if des_list[i] <> nil then
    begin
      des_orb[i] := des_list[i].FOrbit;
      des_orbAngle[i] := des_list[i].FOrbitAngle;
    end;
    if (sou_list[i] <> nil) and (des_list[i] <> nil) then
    begin
      des_list[i].FOrbit := sou_list[i].FOrbit;
      des_list[i].FOrbitAngle := sou_list[i].FOrbitAngle;
      //          des_list[i].FRadius:=sou_list[i].FRadius;
      des_list[i].CalcPos;
      Point_Connect(sou_list[i], des_list[i]);
    end;
  end;

  if sou_cnt < des_cnt then
  begin

    ab_CalcAngle(des_center, des_orb_center, des_orbangle_center);

    ab_CalcAngleAndDist(sou_orb_center, sou_orbangle_center, 0,
      sou_list[_rel].FOrbit, sou_list[_rel].FOrbitAngle, ab_WorldRadius,
      sou_angle_rel, sou_r_rel);
    if sou_angle_rel < 0 then
      sou_angle_rel := 360 + sou_angle_rel;

    ab_CalcAngleAndDist(des_orb_center, des_orbangle_center, 0,
      des_orb[_rel], des_orbAngle[_rel], ab_WorldRadius,
      des_angle_rel, des_r_rel);
    if des_angle_rel < 0 then
      des_angle_rel := 360 + des_angle_rel;

    for i := 0 to cnt - 1 do
      if (sou_list[i] = nil) and (des_list[i] <> nil) then
      begin
        ab_CalcAngleAndDist(des_orb_center, des_orbangle_center, 0,
          des_orb[i], des_orbAngle[i], ab_WorldRadius,
          des_angle_p, des_r_p);
        if des_angle_p < 0 then
          des_angle_p := 360 + des_angle_p;
        angle_p := AngleDist(des_angle_rel, des_angle_p);

        sou_angle_p := AngleCorrect360(sou_angle_rel + angle_p);
        sou_r_p := des_r_p;//*(sou_r_rel/des_r_rel);

        des_apo := des_list[i];
        des_apo.FOrbit := sou_orb_center;
        des_apo.FOrbitAngle := sou_orbangle_center;
        ab_CalcNewPos(des_apo.FOrbit, des_apo.FOrbitAngle, sou_angle_p, ab_WorldRadius, sou_r_p);
        des_apo.CalcPos;
      end;
  end;

  sou_list := nil;
  des_list := nil;
  des_orb := nil;
  des_orbAngle := nil;

  des.FType := sou.FType;
  des.FTimeOffset := sou.FTimeOffset;
  des.KeyGroup := sou.KeyGroup;
  des.FSel := false;

  des.CalcCenter;

  WorldUnit_Delete(sou);
  result := true;
end;

(*function TFormMain.ReloadUnit(un:TabWorldUnit):boolean;
var
  un2:TabWorldUnit;
    apo,apo2:TPointAB;
//  un_apo,un2_apo:TPointAB;
//    mind,d:single;
begin
  Result:=false;
    un2:=AddUnit(un.FFileName,0,0);
    if un2=nil then Exit;

    if un.PointCnt()>un2.PointCnt() then begin WorldUnit_Delete(un2); Exit; end;

//  cc:=un.CalcCenter;

//    mind:=1e30;
  apo:=Point_First;
    while apo<>nil do begin
      if apo.FOwner.IndexOf(un)>=0 then begin
          apo2:=un2.GetPoint(apo.FId);
            if apo2=nil then begin //WorldUnit_Delete(un2); Exit; end;
            end else begin
              apo2.FOrbit:=apo.FOrbit;
              apo2.FOrbitAngle:=apo.FOrbitAngle;
              apo2.FRadius:=apo.FRadius;
              apo2.CalcPos;

{              d:=sqr(cc.x-apo.x)+sqr(cc.y-apo.y)+sqr(cc.z-apo.z);
              if d<mind then begin
                mind:=d;
                  un_apo:=apo;
                  un2_apo:=apo2;
              end;}
            end;

            Point_Connect(apo,apo2);
        end;
        apo:=apo.FNext;
    end;

    un2.FType:=un.FType;
    un2.FTimeOffset:=un.FTimeOffset;
    un2.KeyGroup:=un.KeyGroup;

    un2.CalcCenter;

    un2.FSel:=false;
    WorldUnit_Delete(un);
    Result:=true;
end;*)

procedure TFormMain.CalcPick(mp: TPoint; var vpos: D3DVECTOR; var vdir: D3DVECTOR);
var
  v: D3DVECTOR;
  m: D3DMATRIX;
begin
  D3D_InverseMatrix(ab_Camera_MatProj, m);
  v := D3DV(mp.x - GSmeX, mp.y - GSmeY, 1);
  v := D3D_TransformVector(m, v);

  D3D_InverseMatrix(ab_Camera_MatView, m);

  vdir.x := v.x * m.m[0, 0] + v.y * m.m[1, 0] + v.z * m.m[2, 0];
  vdir.y := v.x * m.m[0, 1] + v.y * m.m[1, 1] + v.z * m.m[2, 1];
  vdir.z := v.x * m.m[0, 2] + v.y * m.m[1, 2] + v.z * m.m[2, 2];

  vdir := D3D_Normalize(vdir);

  vpos.x := m.m[3, 0];
  vpos.y := m.m[3, 1];
  vpos.z := m.m[3, 2];
end;

function TFormMain.PickTriangle(mp: TPoint): TTriangleAB;
var
  atr: TTriangleAB;
  vpos, vdir: D3DVECTOR;
  t, u, v: single;
begin
  CalcPick(mp, vpos, vdir);

  atr := Triangle_First;
  while atr <> nil do
  begin
    if D3D_IntersectTriangle(vpos, vdir, atr.FV[1].FVer.FPos, atr.FV[0].FVer.FPos, atr.FV[2].FVer.FPos, t, u, v) or
      D3D_IntersectTriangle(vpos, vdir, atr.FV[0].FVer.FPos, atr.FV[1].FVer.FPos, atr.FV[2].FVer.FPos, t, u, v) then
      if t > 0 then
        if ab_InTop(atr.FV[0].FVer.FPosShow.z) and ab_InTop(atr.FV[1].FVer.FPosShow.z) and
          ab_InTop(atr.FV[2].FVer.FPosShow.z) then
        begin
          result := atr;
          exit;
        end;

    atr := atr.FNext;
  end;
  result := nil;
end;

function TFormMain.PickLine(mp: TPoint): TLineAB;
var
  ali: TLineAB;
begin
  ali := Line_First;
  while ali <> nil do
  begin
    if ali.Hit(mp) then
      if ab_InTop(ali.FVerStart.FPosShow.z) and ab_InTop(ali.FVerEnd.FPosShow.z) then
      begin
        result := ali;
        exit;
      end;
    ali := ali.FNext;
  end;
  result := nil;
end;

function TFormMain.PickUnit(mp: TPoint): TabWorldUnit;
var
  atr: TTriangleAB;
  ali: TLineAB;
begin
  atr := PickTriangle(mp);
  if (atr = nil) or (atr.FOwner = nil) or (not (atr.FOwner is TabWorldUnit)) then
  begin
    ali := PickLine(mp);
    if (ali <> nil) and (ali.FOwner <> nil) and (ali.FOwner is TabWorldUnit) then
    begin
      result := ali.FOwner as TabWorldUnit;
      exit;
    end;

    result := nil;
    exit;
  end;
  result := atr.FOwner as TabWorldUnit;
end;

function TFormMain.PickPoint(mp: TPoint): TPointAB;
var
  apo: TPointAB;
  md, td: single;
begin
  mp.x := mp.x - GSmeX;
  mp.y := mp.y - GSmeY;

  md := 1e20;

  result := nil;

  apo := Point_First;
  while apo <> nil do
  begin
    if ab_InTop(apo.FPosShow.z) then
      if apo.FParent = nil then
      begin
        td := sqr(apo.FPosShow.x - mp.x) + sqr(apo.FPosShow.y - mp.y);

        if (td < sqr(5)) and (td < md) then
        begin
          md := td;
          result := apo;
        end;
      end;

    apo := apo.FNext;
  end;
end;

function TFormMain.PickZone(mp: TPoint): TabZone;
var
  zone: TabZone;
  md, td: single;
begin
  if not FormMain.MM_View_Zone.Checked then
  begin
    result := nil;
    exit;
  end;

  mp.x := mp.x - GSmeX;
  mp.y := mp.y - GSmeY;

  md := 1e20;

  result := nil;

  zone := Zone_First;
  while zone <> nil do
  begin
    if ab_InTop(zone.FPosShow.z) then
    begin
      td := sqr(zone.FPosShow.x - mp.x) + sqr(zone.FPosShow.y - mp.y);

      if (td < sqr(5)) and (td < md) then
      begin
        md := td;
        result := zone;
      end;
    end;

    zone := zone.FNext;
  end;
end;

function TFormMain.PickZoneLink(mp: TPoint): TabZoneLink;
var
  l1, l2: D3DVECTOR;
  t, l, r: single;
  zl: TabZoneLink;
begin
  if not FormMain.MM_View_Zone.Checked then
  begin
    result := nil;
    exit;
  end;

  result := nil;

  zl := ZoneLink_First;
  while zl <> nil do
  begin

    if (not ab_InTop(zl.FStart.FPosShow.z)) or (not ab_InTop(zl.FEnd.FPosShow.z)) then
    begin
      zl := zl.FNext;
      continue;
    end;

    l1.x := zl.FEnd.FPosShow.x - zl.FStart.FPosShow.x;
    l1.y := zl.FEnd.FPosShow.y - zl.FStart.FPosShow.y;
    l1.z := 0;

    l2.x := (mp.x - GSmeX) - zl.FStart.FPosShow.x;
    l2.y := (mp.y - GSmeY) - zl.FStart.FPosShow.y;
    l2.z := 0;

    l := sqr(l1.x) + sqr(l1.y) + sqr(l1.z);
    t := D3D_DotProduct(l1, l2) / l;
    if (t < 0) or (t > 1.0) then
    begin
      zl := zl.FNext;
      continue;
    end;

    r := (-l2.y) * (l1.x) - (-l2.x) * (l1.y);
    r := (r / l) * sqrt(l);

    if abs(r) > 3 then
    begin
      zl := zl.FNext;
      continue;
    end;

    result := zl;
    exit;
  end;
end;

function TFormMain.Pick(mp: TPoint): TList;
var
  zone: TabZone;
  zl: TabZoneLink;
  wunit: TabWorldUnit;
  apo: TPointAB;
  li: TList;
begin
  li := TList.Create;

  zone := PickZone(mp);
  if zone <> nil then
    li.Add(zone);

  zl := PickZoneLink(mp);
  if zl <> nil then
    li.Add(zl);

  wunit := PickUnit(mp);
  if wunit <> nil then
    li.Add(wunit);

  apo := PickPoint(mp);
  if apo <> nil then
    li.Add(apo);

  if li.Count < 1 then
  begin
    li.Free;
    li := nil;
  end;
  result := li;
end;

procedure TFormMain.MM_View_WorldLineClick(Sender: TObject);
begin
  MM_View_WorldLine.Checked := not MM_View_WorldLine.Checked;

  if MM_View_WorldLine.Checked then
    SWLBuild
  else
    SWLClear;
end;

procedure TFormMain.MM_View_PointClick(Sender: TObject);
begin
  MM_View_Point.Checked := not MM_View_Point.Checked;
end;

procedure TFormMain.Save1Click(Sender: TObject);
begin
  SaveAs1Click(nil);
end;

procedure TFormMain.SaveAs1Click(Sender: TObject);
var
  bd: TBufEC;
begin
  if (GFileName = '') or (Sender <> nil) then
  begin
    if not SaveDialog1.Execute then
      exit;
    GFileName := SaveDialog1.FileName;
  end;

  bd := TBufEC.Create;

  bd.AddDWORD($57424152);
  bd.AddInteger(GVersion);

  bd.AddSingle(ab_WorldRadius);

  WorldUnit_SaveWorld(bd);
  KeyGroupList_SaveWorld(bd);
  Point_SaveWorld(bd);
  Triangle_SaveWorld(bd);
  Line_SaveWorld(bd);
  Zone_SaveWorld(bd);

  bd.SaveInFile(PChar(ansistring(GFileName)));

  bd.Free;

  UpdateCaption;
end;

procedure TFormMain.Open1Click(Sender: TObject);
var
  bd: TBufEC;
begin
  if not OpenDialog1.Execute then
    exit;

  ClearAll;
  GFileName := OpenDialog1.FileName;
  bd := TBufEC.Create;

  try
    bd.LoadFromFile(PChar(ansistring(GFileName)));

    if bd.GetDWORD() <> $57424152 then
      EError('Incorrect format');
    GLoadVersion := bd.GetInteger;
    if GLoadVersion > GVersion then
      EError('Incorrect version');

    ab_WorldRadius := bd.GetSingle;
    ab_Camera_Radius := ab_WorldRadius + ab_Camera_RadiusDefaultFW;

    WorldUnit_LoadWorld(bd);
    KeyGroupList_LoadWorld(bd);
    Point_LoadWorld(bd);
    Triangle_LoadWorld(bd);
    Line_LoadWorld(bd);
    Zone_LoadWorld(bd);

    Point_ClearNo;
    Point_ListClear;

    WorldUnit_CalcCenter;

  except
    on e: Exception do
    begin
      ShowMessage('Error : ' + e.Message);
      GFileName := '';
      ClearAll;
    end;
  end;

  bd.Free;

  if MM_View_WorldLine.Checked then
    SWLBuild;
  UpdateCaption;
  UpdateInfo;

  Key_TimeMax := max(0, Key_CalcFullTime() - 1);
end;

procedure TFormMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormMain.Saveend1Click(Sender: TObject);
var
  buf: TBufEC;
  fi: TFileEC;
begin
  if Triangle_Count < 1 then
    exit;
  if not SaveDialog2.Execute then
    exit;

  SE_PointCnt := 0;
  SE_PointBuf := TBufEC.Create;
  buf := TBufEC.Create;

  fi := TFileEC.Create;
  fi.Init(PChar(SaveDialog2.FileName));
  fi.CreateNew;

  Triangle_SaveEnd(buf, nil);

  fi.write(@SE_PointCnt, 4);
  fi.write(SE_PointBuf.Buf, SE_PointBuf.Len);
  fi.write(buf.Buf, buf.Len);

  fi.Free;
  buf.Free;
  SE_PointBuf.Free;
  SE_PointBuf := nil;
end;

procedure TFormMain.MM_File_SaveEndClick(Sender: TObject);
begin
  if (not FileExists(GRangersPath + '\CFG\CD\ABMap.txt')) or (not FileExists(GRangersPath + '\CFG\ABMap.txt')) then
  begin
    ShowMessage('Rangers not found');
    exit;
  end;
  FormSaveEnd.ShowModal;
  exit;

  if not SaveDialog2.Execute then
    exit;
end;

procedure TFormMain.SetTime(t: integer);
begin
  //  Key_TimeMax:=max(0,Key_CalcFullTime()-1);
  //  if t<0 then t:=0
  //    else if t>Key_TimeMax then t:=0;//TBTime.Max;

  Key_Time := t;
  Key_Interpolate;
  Triangle_UpdateGraph;
  Draw3D;
end;

procedure TFormMain.MM_View_SLDefaultClick(Sender: TObject);
begin
  MM_View_SLDefault.Checked := MM_View_SLDefault = Sender;
  MM_View_SLShow.Checked := MM_View_SLShow = Sender;
  MM_View_SLHide.Checked := MM_View_SLHide = Sender;
  Line_UpdateGraph;
end;

procedure TFormMain.MM_File_ClearClick(Sender: TObject);
begin
  GFileName := '';
  ClearAll;
  if MM_View_WorldLine.Checked then
    SWLBuild;
  UpdateCaption;
end;

procedure TFormMain.ComboBoxUnitTypeChange(Sender: TObject);
var
  wu: TabWorldUnit;
begin
  wu := WorldUnit_Sel;

  wu.FType := ComboBoxUnitType.ItemIndex;
end;

procedure TFormMain.EditUnitTimeOffsetChange(Sender: TObject);
var
  wu: TabWorldUnit;
begin
  wu := WorldUnit_Sel;

  wu.FTimeOffset := StrToIntFullEC(EditUnitTimeOffset.Text);
end;

procedure TFormMain.EditUnitTimeLengthChange(Sender: TObject);
var
  wu: TabWorldUnit;
begin
  wu := WorldUnit_Sel;

  wu.FTimeLength := StrToIntEC(EditUnitTimeLength.Text);
end;

procedure TFormMain.ComboBoxUnitKeyGroupChange(Sender: TObject);
var
  wu: TabWorldUnit;
begin
  wu := WorldUnit_Sel;

  wu.KeyGroup := ComboBoxUnitKeyGroup.ItemIndex;
end;

procedure TFormMain.ComboBoxZoneTypeChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FType := ComboBoxZoneType.ItemIndex;
end;

procedure TFormMain.EditZoneRadiusChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FRadiusAngle := (StrToIntEC(EditZoneRadius.Text) * 180) / (pi * ab_WorldRadius);
  zone.CalcPos;
  Draw3D;
end;

procedure TFormMain.ComboBoxZoneGraphChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FGraph := TrimEx(ComboBoxZoneGraph.Text);
end;

procedure TFormMain.EditZoneHitpointsChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FHitpoints := StrToIntEC(EditZoneHitpoints.Text);
end;

procedure TFormMain.EditZoneMassChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FMass := StrToIntFullEC(EditZoneMass.Text);
end;

procedure TFormMain.EditZoneDamageChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FDamage := StrToIntFullEC(EditZoneDamage.Text);
end;

procedure TFormMain.MM_View_ZoneClick(Sender: TObject);
begin
  MM_View_Zone.Checked := not MM_View_Zone.Checked;
end;

procedure TFormMain.MM_Unit_ReloadCurClick(Sender: TObject);
var
  wunit: TabWorldUnit;
begin
  wunit := WorldUnit_Sel;
  if wunit = nil then
    exit;
  ReloadUnit(wunit);

  UpdateInfo;
  Key_TimeMax := max(0, Key_CalcFullTime() - 1);
end;

procedure TFormMain.MM_Unit_ReloadCurTypeClick(Sender: TObject);
var
  li: TList;
  wunit: TabWorldUnit;
  tstr: WideString;
  i: integer;
begin
  wunit := WorldUnit_Sel;
  if wunit = nil then
    exit;
  tstr := wunit.FFileName;

  li := TList.Create;
  wunit := WorldUnit_First;
  while wunit <> nil do
  begin
    if wunit.FFileName = tstr then
      li.Add(wunit);
    wunit := wunit.FNext;
  end;

  for i := 0 to li.Count - 1 do
    ReloadUnit(li.Items[i]);

  li.Free;

  UpdateInfo;
  Key_TimeMax := max(0, Key_CalcFullTime() - 1);
end;

procedure TFormMain.MM_Unit_ReloadAllClick(Sender: TObject);
var
  li: TList;
  wunit: TabWorldUnit;
  i: integer;
begin
  li := TList.Create;
  wunit := WorldUnit_First;
  while wunit <> nil do
  begin
    li.Add(wunit);
    wunit := wunit.FNext;
  end;

  for i := 0 to li.Count - 1 do
    ReloadUnit(li.Items[i]);

  li.Free;

  UpdateInfo;
  Key_TimeMax := max(0, Key_CalcFullTime() - 1);
end;

procedure TFormMain.MM_Options_OptionsClick(Sender: TObject);
begin
  FormOptions.ShowModal;

  SWLClear;
  if MM_View_WorldLine.Checked then
    SWLBuild;
end;

procedure TFormMain.EditMainWorldRadiusKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  oldradius, newradius: single;
  apo: TPointAB;
  zone: TabZone;
begin
  if Key = VK_RETURN then
  begin
    newradius := max(500, StrToIntEc(EditMainWorldRadius.Text));

    oldradius := ab_WorldRadius;
    ab_Camera_Radius := newradius + (ab_Camera_Radius - ab_WorldRadius);
    ab_WorldRadius := newradius;

    apo := Point_First;
    while apo <> nil do
    begin
      apo.FRadius := (apo.FRadius - oldradius) + newradius;
      apo.CalcPos;
      apo := apo.FNext;
    end;

    zone := Zone_First;
    while zone <> nil do
    begin
      zone.CalcPos;
      zone := zone.FNext;
    end;

    SWLClear;
    if MM_View_WorldLine.Checked then
      SWLBuild;

    WorldUnit_CalcCenter;

    UpdateInfo;
  end;
end;

procedure TFormMain.ComboBoxZoneLinkTypeChange(Sender: TObject);
var
  zl: TabZoneLink;
begin
  zl := ZoneLink_Sel;
  zl.FType := ComboBoxZoneLinkType.ItemIndex;
end;

procedure TFormMain.CheckBoxZoneI0Click(Sender: TObject);
var
  zone: TabZone;
  sme: integer;
begin
  zone := Zone_Sel;

  sme := StrToIntEc(TCheckBox(Sender).Name);

  if TCheckBox(Sender).Checked then
    zone.FItem := (zone.FItem or (1 shl sme))
  else
    zone.FItem := (zone.FItem and (not (1 shl sme)));
end;

procedure TFormMain.ComboBoxZoneIFreqChange(Sender: TObject);
var
  zone: TabZone;
begin
  zone := Zone_Sel;

  zone.FItemFreq := ComboBoxZoneIFreq.ItemIndex;
end;

procedure TFormMain.About1Click(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.MM_View_BackgroundClick(Sender: TObject);
begin
  MM_View_Background.Checked := not MM_View_Background.Checked;
  FBGGraph.FDrawFromObjLoop := MM_View_Background.Checked;
end;

procedure TFormMain.MM_Unit_PathClick(Sender: TObject);
begin
  FormUnitPath.ShowModal;
end;

procedure TFormMain.MM_Unit_BBCalcCurrentClick(Sender: TObject);
var
  wunit: TabWorldUnit;
begin
  wunit := WorldUnit_Sel;
  if wunit = nil then
    exit;

  wunit.BBBuild;
  wunit.UpdateGraph;
end;

procedure TFormMain.MM_Unit_BBCalcAllClick(Sender: TObject);
var
  wunit: TabWorldUnit;
begin
  wunit := WorldUnit_First;
  while wunit <> nil do
  begin
    wunit.BBBuild;
    wunit := wunit.FNext;
  end;

  wunit := WorldUnit_Sel;
  if wunit = nil then
    exit;
  wunit.UpdateGraph;
end;

end.