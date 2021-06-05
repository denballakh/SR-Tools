unit Global;

interface

uses Windows, ActiveX, SysUtils, Classes, Math, Graphics, GR_DirectX3D8, aMyFunction;

type
  xyzV = single;
  TDxy = TPos;
  TDxyz = D3DVECTOR;
  TMatrix4 = D3DMATRIX;

  PabPos = ^TabPos;

  TabPos = record
    FOrbit: single;
    FOrbitAngle: single;
    FAngle: single;
  end;

  PabToPos = ^TabToPos;

  TabToPos = record
    FAngle: single;
    FDist: single;
  end;

var
  ab_WorldRadius: single = 1000;

  ab_Camera_Pos: TabPos;
  ab_Camera_Radius: single = 2300;//1800;
  ab_Camera_RadiusDefaultFW: single = 1300;//1800;
  ab_Camera_RadiusMaxFW: single = 20000;
  ab_Camera_Fov: single = 88;

  ab_Camera_MatView: D3DMATRIX;
  ab_Camera_MatProj: D3DMATRIX;
  ab_Camera_MatEnd: D3DMATRIX;

  ab_Z_TopBefore: single = -1;
  ab_Z_Top: single = 0;
  ab_Z_TopAfter: single = 1;

  GSmeX: integer = 0;
  GSmeY: integer = 0;

function Dxy(x, y: single): TDxy;
function Dxyz(x, y, z: xyzV): TDxyz;

function abPos(zorbit, zorbitangle, zangle: xyzV): TabPos;
function abToPos(zangle, zdist: xyzV): TabToPos;

function ab_CalcPos(orb, orban, radius: xyzV): TDxyz;
procedure ab_CalcAngle(pos: TDxyz; var orb: xyzV; var orban: xyzV);

procedure ab_CalcNewPos(var orb: xyzV; var orban: xyzV; var angle: xyzV; radius: xyzV; speed: xyzV); overload;
function ab_CalcNewPos(pos: TabPos; speed: xyzV): TabPos; overload;
function ab_CalcNewPos(pos: TabPos; angle: xyzV; speed: xyzV): TabPos; overload;
function ab_CalcNewPosEx(pos: TabPos; var angle: xyzV; speed: xyzV): TabPos; overload;

procedure ab_CalcAngleAndDist(sou_orb, sou_orban, sou_angle, des_orb, des_orban, radius: xyzV;
  var r_ang: xyzV; var r_dist: xyzV); overload;
function ab_CalcToPos(sou, des: TabPos): TabToPos; overload;

function ab_InTop(z: xyzV): boolean;
procedure ab_CalcZPos;

function IntersectionSphereEx(ts1, ts2: TDxyz; sc: TDxyz; radius: xyzV; var pppos: TDxyz): boolean;

procedure GlobalsInit;
function HTimer: int64;

procedure DrawRectText(ca: TCanvas; rc: TRect; fs: TBrushStyle; fcolor: TColor; bstyle: TPenStyle;
  bcolor: TColor; bsize: integer; bcoef: single; tax: integer; tay: integer; tar: boolean; Text: WideString);
procedure SaveCanvasPar(ca: TCanvas);
procedure LoadCanvasPar(ca: TCanvas);

function NewGUID: TGUID;
function GUIDToStr(zn: TGUID): WideString;
function StrToGUID(zn: WideString): TGUID;
function CmpGUID(g1, g2: TGUID): boolean;

function RegUser_GetDWORD(path: WideString; Name: WideString; bydef: DWORD): DWORD;
procedure RegUser_SetDWORD(path: WideString; Name: WideString; zn: DWORD);

function RegUser_GetString(path: WideString; Name: WideString; bydef: WideString): WideString;
procedure RegUser_SetString(path: WideString; Name: WideString; zn: WideString);

procedure SFT(tstr: ansistring);
procedure SFTne(tstr: ansistring);

var
  RegUserPath: WideString = 'Software\dab\RangersABWorld';

  GHTimerFreq: int64;

implementation

uses VOper, Form_Main, EC_Mem, EC_Buf, EC_Str;

var
  GR_FL: TextFile;

function Dxy(x, y: single): TDxy;
begin
  result.x := x;
  result.y := y;
end;

function Dxyz(x, y, z: xyzV): TDxyz;
begin
  result.x := x;
  result.y := y;
  result.z := z;
end;

function abPos(zorbit, zorbitangle, zangle: xyzV): TabPos;
begin
  result.FOrbit := zorbit;
  result.FOrbitAngle := zorbitangle;
  result.FAngle := zangle;
end;

function abToPos(zangle, zdist: xyzV): TabToPos;
begin
  result.FAngle := zangle;
  result.FDist := zdist;
end;

function ab_CalcPos(orb, orban, radius: xyzV): TDxyz;
var
  tv: TDxyz;
begin
  tv.x := sin(orban) * radius;
  tv.y := -cos(orban) * radius;
  tv.z := 0;

  result.x := sin(orb) * tv.x;
  result.y := tv.y;
  result.z := -cos(orb) * tv.x;
end;

procedure ab_CalcAngle(pos: TDxyz; var orb: xyzV; var orban: xyzV);
var
  d: xyzV;
begin
  d := sqrt(sqr(pos.x) + sqr(pos.y) + sqr(pos.z));
  orban := AngleRadTo360(arccos(-pos.y / d));
  orb := AngleRadTo360(pi - ArcTan2(pos.x, pos.z));
end;

{   A:=arcsin((sin(a_)*sin(B))/sin(b_));
    C:=arccos(-cos(A)*cos(B)+sin(A)*sin(B)*cos(c_));

    A:=arccos((sin(c_)*cos(a_)-cos(c_)*sin(a_)*cos(B))/sin(b_));
    C:=arccos(-cos(A)*cos(B)+sin(A)*sin(B)*cos(c_));

    A:=arccos(min(1.0,(sin(c_)*cos(a_)-cos(c_)*sin(a_)*cos(B))*t));
    C:=arccos(min(1.0,(sin(a_)*cos(c_)-cos(a_)*sin(c_)*cos(B))*t));

    A:=arccos((sin(c_)*cos(a_)-cos(c_)*sin(a_)*cos(B))/sin(b_));
    C:=arccos((sin(a_)*cos(c_)-cos(a_)*sin(c_)*cos(B))/sin(b_));
    A:=arccos(-cos(B)*cos(C)+sin(B)*sin(C)*cos(a_));
}
procedure ab_CalcNewPos(var orb: xyzV; var orban: xyzV; var angle: xyzV; radius: xyzV; speed: xyzV);
var
  a_, b_, c_: xyzV;

  A, B, C, t, t2: xyzV;
  fo: boolean;
begin
  if speed < 0 then
  begin
    fo := true;
    speed := -speed;
    angle := AngleCorrect360(angle + 180);
  end
  else
    fo := false;

  B := Angle360ToRad(angle);

  a_ := (speed / (2 * pi * radius)) * pi * 2;
  c_ := Angle360ToRad(orban);

  b_ := arccos(cos(c_) * cos(a_) + sin(c_) * sin(a_) * cos(B));

  if b_ < 0.00001 then
    t := 99999999
  else
    t := 1 / sin(b_);

  t2 := (sin(c_) * cos(a_) - cos(c_) * sin(a_) * cos(B)) * t;
  if t2 < -1.0 then
    t2 := -1.0
  else if t2 > 1.0 then
    t2 := 1.0;
  A := arccos(t2);

  t2 := (sin(a_) * cos(c_) - cos(a_) * sin(c_) * cos(B)) * t;
  if t2 < -1.0 then
    t2 := -1.0
  else if t2 > 1.0 then
    t2 := 1.0;
  C := arccos(t2);

{ab_Temp1:=AngleRadTo360(A);
ab_Temp2:=AngleRadTo360(B);
ab_Temp3:=AngleRadTo360(C);
ab_Temp4:=AngleRadTo360(a_);
ab_Temp5:=AngleRadTo360(b_);
ab_Temp6:=AngleRadTo360(c_);}

  if angle > 180 then
  begin
    angle := AngleCorrect360(AngleRadTo360(pi + C));
    orb := AngleCorrect360(orb - AngleRadTo360(A));
  end
  else
  begin
    angle := AngleCorrect360(AngleRadTo360(pi - C));
    orb := AngleCorrect360(orb + AngleRadTo360(A));
  end;

  orban := AngleRadTo360(b_);

  if fo then
    angle := AngleCorrect360(angle + 180);
end;

function ab_CalcNewPos(pos: TabPos; speed: xyzV): TabPos;
begin
  result := pos;
  ab_CalcNewPos(result.FOrbit, result.FOrbitAngle, result.FAngle, ab_WorldRadius, speed);
end;

function ab_CalcNewPos(pos: TabPos; angle: xyzV; speed: xyzV): TabPos;
var
  ta: xyzV;
begin
  result := pos;
  ta := AngleDist(angle, result.FAngle);
  ab_CalcNewPos(result.FOrbit, result.FOrbitAngle, angle, ab_WorldRadius, speed);
  result.FAngle := AngleCorrect360(angle + ta);
end;

function ab_CalcNewPosEx(pos: TabPos; var angle: xyzV; speed: xyzV): TabPos;
var
  ta: xyzV;
begin
  result := pos;
  ta := AngleDist(angle, result.FAngle);
  ab_CalcNewPos(result.FOrbit, result.FOrbitAngle, angle, ab_WorldRadius, speed);
  result.FAngle := AngleCorrect360(angle + ta);
end;

procedure ab_CalcAngleAndDist(sou_orb, sou_orban, sou_angle, des_orb, des_orban, radius: xyzV;
  var r_ang: xyzV; var r_dist: xyzV);
var
  a_, b_, c_, A, B, t: xyzV;
begin
  b_ := Angle360ToRad(des_orban);
  c_ := Angle360ToRad(sou_orban);
  A := Angle360ToRad(AngleCorrect360(des_orb - sou_orb));

  t := cos(b_) * cos(c_) + sin(b_) * sin(c_) * cos(A);
  if t < -1.0 then
    t := -1.0
  else if t > 1.0 then
    t := 1.0;
  a_ := arccos(t);
  r_dist := (a_ / (2 * pi)) * 2 * pi * radius;

  if a_ = 0 then
  begin
    r_ang := 0;
    exit;
  end;
  t := (sin(c_) * cos(b_) - cos(c_) * sin(b_) * cos(A)) / sin(a_);
  if t < -1.0 then
    t := -1.0
  else if t > 1.0 then
    t := 1.0;
  B := arccos(t);

  if AngleDist(sou_orb, des_orb) < 0 then
    B := -B;

  r_ang := AngleDist(sou_angle, AngleRadTo360(B));
end;

function ab_CalcToPos(sou, des: TabPos): TabToPos;
begin
  ab_CalcAngleAndDist(sou.FOrbit, sou.FOrbitAngle, sou.FAngle, des.FOrbit, des.FOrbitAngle,
    ab_WorldRadius, result.FAngle, result.FDist);
end;

procedure ab_CalcZPos;
var
  v1, v2, v3: TDxyz;
  m1, m2, m3: TMatrix4;
  zangle: xyzV;
begin
  v1 := Dxyz(0, 0, ab_Camera_Radius);
  v2 := Dxyz(0, 0, 0);
  v3 := Dxyz(0, 1, 0);

  m1 := D3D_ViewMatrix(v1, v2, v3);
  //    m2:=D3D_ProjectionMatrix(1,ab_WorldRadius*2.1,Angle360ToRad(ab_Camera_Fov),FormMain.Panel3D.Width);
  m2 := D3D_ProjectionMatrix(ab_Camera_Radius - ab_WorldRadius - 100, ab_Camera_Radius + ab_WorldRadius +
    100, Angle360ToRad(ab_Camera_Fov), FormMain.Panel3D.Width);
  m3 := D3D_MatrixMult(m2, m1);

  zangle := 90 - (180 - 90 - AngleRadTo360(arcsin(ab_WorldRadius / ab_Camera_Radius)));

  v1 := Dxyz(0, 0, sin(Angle360ToRad(zangle)) * ab_WorldRadius);
  v1 := D3D_TransformVector(m3, v1);
  ab_Z_Top := v1.z;

  v1 := Dxyz(0, 0, sin(Angle360ToRad(zangle - 15)) * ab_WorldRadius);
  v1 := D3D_TransformVector(m3, v1);
  ab_Z_TopBefore := v1.z;

  v1 := Dxyz(0, 0, sin(Angle360ToRad(zangle + 15)) * ab_WorldRadius);
  v1 := D3D_TransformVector(m3, v1);
  ab_Z_TopAfter := v1.z;
end;

function ab_InTop(z: xyzV): boolean;
begin
  result := z < ab_Z_Top;
end;

function IntersectionSphereEx(ts1, ts2: TDxyz; sc: TDxyz; radius: xyzV; var pppos: TDxyz): boolean;
var
  t, t2, tca, t2hc, l2oc: xyzV;
  dir, l: TDxyz;
begin
  dir.x := ts2.x - ts1.x;
  dir.y := ts2.y - ts1.y;
  dir.z := ts2.z - ts1.z;
  t := 1 / sqrt(dir.x * dir.x + dir.y * dir.y + dir.z * dir.z);
  dir.x := dir.x * t;
  dir.y := dir.y * t;
  dir.z := dir.z * t;

  l.x := sc.x - ts1.x;
  l.y := sc.y - ts1.y;
  l.z := sc.z - ts1.z;

  l2oc := l.x * l.x + l.y * l.y + l.z * l.z;
  tca := l.x * dir.x + l.y * dir.y + l.z * dir.z;
  t2hc := sqr(radius) - l2oc + tca * tca;

  if t2hc <= 0.0 then
  begin
    result := false;
    exit;
  end;
  t2hc := sqrt(t2hc);
  if tca < t2hc then
  begin
    t := tca + t2hc;
    t2 := tca - t2hc;
  end
  else
  begin
    t := tca - t2hc;
    t2 := tca + t2hc;
  end;

  if abs(t) < 0.001 then
    t := t2;

  pppos.x := ts1.x + dir.x * t;
  pppos.y := ts1.y + dir.y * t;
  pppos.z := ts1.z + dir.z * t;

  result := t > 0.001;
end;

procedure GlobalsInit;
begin
  GHTimerFreq := 0;
  QueryPerformanceFrequency(GHTimerFreq);

  AssignFile(GR_FL, '########.log');
  Rewrite(GR_FL);
  writeln(GR_FL, 'Start');
  CloseFile(GR_FL);
end;

function HTimer: int64;
begin
  QueryPerformanceCounter(result);
end;

function NewGUID: TGUID;
begin
  if CoCreateGuid(result) <> S_OK then
    raise Exception.Create('NewGUID');
end;

function GUIDToStr(zn: TGUID): WideString;
var
  tstr: WideString;
begin
{    SetLength(Result,38);
    if StringFromGUID2(zn,PWideChar(Result),38)<>NOERROR then raise Exception.Create('GUIDToStr');
    Result:=Copy(Result,2,36);}

  SetLength(tstr, 40);
  if StringFromGUID2(zn, PWideChar(tstr), 40) = 0 then
    raise Exception.Create('GUIDToStr');
  result := UpperCase(Copy(tstr, 2, 36));
end;

function StrToGUID(zn: WideString): TGUID;
begin
  if CLSIDFromString(PWideChar('{' + TrimEx(zn) + '}'), result) <> NOERROR then
    raise Exception.Create('StrToGUID(' + zn + ')');
end;

function CmpGUID(g1, g2: TGUID): boolean;
begin
  result := CompareMem(@g1, @g2, sizeof(TGUID));
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure DrawRectText(ca: TCanvas; rc: TRect; fs: TBrushStyle; fcolor: TColor; bstyle: TPenStyle;
  bcolor: TColor; bsize: integer; bcoef: single; tax: integer; tay: integer; tar: boolean; Text: WideString);
var
  x, y, i: integer;
  crc: TRect;
  hr: HRGN;
  hrok: integer;
  fl: DWORD;
begin
  ca.Brush.Color := fcolor;
  ca.Brush.Style := fs;
  ca.Pen.Style := psClear;
  ca.Rectangle(rc.left{+bsize}, rc.top{+bsize}, rc.Right{+1-bsize}, rc.Bottom{+1-bsize});

  ca.Pen.Color := bcolor;
  ca.Pen.Style := bstyle;
  ca.Pen.Width := 1;
  for i := 0 to bsize - 1 do
  begin
    ca.MoveTo(rc.Right - 2 - i, rc.Top + i);
    ca.LineTo(rc.Left + i, rc.Top + i);
    ca.LineTo(rc.Left + i, rc.Bottom - 2 - i);
  end;

  ca.Pen.Color := RGB(min(255, max(0, Round(GetRValue(bcolor) * bcoef))), min(255, max(0, Round(GetGValue(bcolor) * bcoef))),
    min(255, max(0, Round(GetBValue(bcolor) * bcoef))));
  for i := 0 to bsize - 1 do
  begin
    ca.MoveTo(rc.Left + i, rc.Bottom - 2 - i);
    ca.LineTo(rc.Right - 2 - i, rc.Bottom - 2 - i);
    ca.LineTo(rc.Right - 2 - i, rc.Top + i);
  end;

  if Length(TrimEx(Text)) < 1 then
    exit;

  rc.Left := rc.Left + bsize + 1;
  rc.Top := rc.Top + bsize + 1;
  rc.Right := rc.Right - bsize - 1;
  rc.Bottom := rc.Bottom - bsize - 1;

  crc := Rect(0, 0, 1000000, 1000000);
  DrawText(ca.Handle, PChar(ansistring(Text)), -1, crc, DT_TOP or DT_LEFT or DT_NOCLIP or DT_CALCRECT);

  if tax < 0 then
  begin
    x := rc.Left;
    fl := DT_LEFT;
  end
  else if tax = 0 then
  begin
    x := (rc.Left + rc.Right) div 2 - (crc.Right - crc.Left) div 2;
    fl := DT_CENTER;
  end
  else
  begin
    x := rc.Right - (crc.Right - crc.Left);
    fl := DT_RIGHT;
  end;

  if tay < 0 then
    y := rc.Top
  else if tay = 0 then
    y := (rc.Top + rc.Bottom) div 2 - (crc.Bottom - crc.Top) div 2
  else
    y := rc.Bottom - (crc.Bottom - crc.Top);

  hr := CreateRectRgn(0, 0, 1, 1);
  hrok := GetClipRgn(ca.Handle, hr);

  //    BeginPath(ca.Handle);
  //    SelectClipPath(ca.Handle,RGN_OR);
  IntersectClipRect(ca.Handle, rc.Left, rc.Top, rc.Right, rc.Bottom);

  if tar then
  begin
    crc := Rect(x, y, 1000000, 1000000);
    DrawText(ca.Handle, PChar(ansistring(Text)), -1, crc, DT_LEFT or DT_TOP or DT_NOCLIP);
  end
  else
  begin
    crc := Rect(rc.Left, y, rc.Right, 1000000);
    DrawText(ca.Handle, PChar(ansistring(Text)), -1, crc, fl or DT_TOP or DT_NOCLIP);
  end;

  //    EndPath(ca.Handle);

  SelectClipRgn(ca.Handle, 0);
  if hrok = 1 then
    SelectClipRgn(ca.Handle, hr);
  DeleteObject(hr);
end;

var
  old_Brush_Color: TColor;
  old_Brush_Style: TBrushStyle;
  old_Pen_Color: TColor;
  old_Pen_Style: TPenStyle;
  old_Pen_Width: integer;

procedure SaveCanvasPar(ca: TCanvas);
begin
  old_Brush_Color := ca.Brush.Color;
  old_Brush_Style := ca.Brush.Style;
  old_Pen_Color := ca.Pen.Color;
  old_Pen_Style := ca.Pen.Style;
  old_Pen_Width := ca.Pen.Width;
end;

procedure LoadCanvasPar(ca: TCanvas);
begin
  ca.Brush.Color := old_Brush_Color;
  ca.Brush.Style := old_Brush_Style;
  ca.Pen.Color := old_Pen_Color;
  ca.Pen.Style := old_Pen_Style;
  ca.Pen.Width := old_Pen_Width;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function RegUser_GetDWORD(path: WideString; Name: WideString; bydef: DWORD): DWORD;
var
  kkey: HKEY;
  tip: DWORD;
  zn: DWORD;
  tsize: DWORD;
begin
{    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=4;
    if RegQueryValueExW(kkey,PWChar(name),nil,@tip,PByte(@zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        Exit;
    end;}
  if RegOpenKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, KEY_READ, kkey) <> ERROR_SUCCESS then
  begin
    result := bydef;
    exit;
  end;
  tsize := 4;
  if RegQueryValueExA(kkey, PChar(ansistring(Name)), nil, @tip, Windows.PByte(@zn), @tsize) <> ERROR_SUCCESS then
  begin
    result := bydef;
    RegCloseKey(kkey);
    exit;
  end;
  if tip <> REG_DWORD then
    result := bydef
  else
    result := zn;
  RegCloseKey(kkey);
end;

procedure RegUser_SetDWORD(path: WideString; Name: WideString; zn: DWORD);
var
  kkey: HKEY;
  dv: DWORD;
begin
{    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_DWORD,@zn,4)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;}
  if RegCreateKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, nil, 0, KEY_WRITE, nil, kkey, @dv) <>
    ERROR_SUCCESS then
    exit;
  if RegSetValueExA(kkey, PChar(ansistring(Name)), 0, REG_DWORD, @zn, 4) <> ERROR_SUCCESS then
  begin
    RegCloseKey(kkey);
    exit;
  end;
  RegCloseKey(kkey);
end;

function RegUser_GetString(path: WideString; Name: WideString; bydef: WideString): WideString;
var
  kkey: HKEY;
  tip: DWORD;
  zn: Pointer;
  tsize: DWORD;
begin
{    if RegOpenKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,KEY_READ,kkey)<>ERROR_SUCCESS then begin
        Result:=bydef;
        Exit;
    end;
    tsize:=2048;
    zn:=AllocEC(tsize);
    if RegQueryValueExW(kkey,PWChar(name),nil,@tip,PByte(zn),@tsize)<>ERROR_SUCCESS then begin
        Result:=bydef;
        RegCloseKey(kkey);
        FreeEC(zn);
        Exit;
    end;
    if tip<>REG_SZ then Result:=bydef
    else Result:=PWChar(zn);
    FreeEC(zn);
    RegCloseKey(kkey);}
  if RegOpenKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, KEY_READ, kkey) <> ERROR_SUCCESS then
  begin
    result := bydef;
    exit;
  end;
  tsize := 2048;
  zn := AllocEC(tsize);
  if RegQueryValueExA(kkey, PChar(ansistring(Name)), nil, @tip, Windows.PByte(zn), @tsize) <> ERROR_SUCCESS then
  begin
    result := bydef;
    RegCloseKey(kkey);
    FreeEC(zn);
    exit;
  end;
  if tip <> REG_SZ then
    result := bydef
  else
    result := PChar(zn);
  FreeEC(zn);
  RegCloseKey(kkey);
end;

procedure RegUser_SetString(path: WideString; Name: WideString; zn: WideString);
var
  kkey: HKEY;
  dv: DWORD;
  tstr: ansistring;
begin
{    if RegCreateKeyExW(HKEY_CURRENT_USER,PWChar(RegUserPath+path),0,nil,0,KEY_WRITE,nil,kkey,@dv)<>ERROR_SUCCESS then begin
        Exit;
    end;
    if RegSetValueExW(kkey,PWChar(name),0,REG_SZ,PWChar(zn),Length(zn)*2+2)<>ERROR_SUCCESS then begin
        RegCloseKey(kkey);
        Exit;
    end;
    RegCloseKey(kkey);}
  if RegCreateKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, nil, 0, KEY_WRITE, nil, kkey, @dv) <>
    ERROR_SUCCESS then
    exit;
  tstr := zn;
  if RegSetValueExA(kkey, PChar(ansistring(Name)), 0, REG_SZ, PChar(tstr), Length(tstr) + 1) <> ERROR_SUCCESS then
  begin
    RegCloseKey(kkey);
    exit;
  end;
  RegCloseKey(kkey);
end;

procedure RegUser_GetBuf(path: WideString; Name: WideString; tbuf: TBufEC);
var
  kkey: HKEY;
  tip: DWORD;
  tsize: DWORD;
begin
  tbuf.Clear;
  if RegOpenKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, KEY_READ, kkey) <> ERROR_SUCCESS then
    exit;

  tsize := 0;
  if RegQueryValueExA(kkey, PChar(ansistring(Name)), nil, @tip, nil, @tsize) <> ERROR_SUCCESS then
  begin
    RegCloseKey(kkey);
    exit;
  end;

  if tsize <= 0 then
  begin
    RegCloseKey(kkey);
    exit;
  end;

  tbuf.Len := tsize;
  if RegQueryValueExA(kkey, PChar(ansistring(Name)), nil, @tip, tbuf.Buf, @tsize) <> ERROR_SUCCESS then
  begin
    RegCloseKey(kkey);
    tbuf.Clear;
    exit;
  end;

  RegCloseKey(kkey);
end;

procedure RegUser_SetBuf(path: WideString; Name: WideString; tbuf: TBufEC);
var
  kkey: HKEY;
  dv: DWORD;
begin
  if RegCreateKeyExA(HKEY_CURRENT_USER, PChar(ansistring(RegUserPath + path)), 0, nil, 0, KEY_WRITE, nil, kkey, @dv) <>
    ERROR_SUCCESS then
    exit;
  if RegSetValueExA(kkey, PChar(ansistring(Name)), 0, REG_BINARY, tbuf.Buf, tbuf.Len) <> ERROR_SUCCESS then
  begin
    RegCloseKey(kkey);
    exit;
  end;
  RegCloseKey(kkey);
end;

procedure SFT(tstr: ansistring);
begin
  //    if SFTCS=nil then SFTCS:=TCriticalSection.Create;
  //    SFTCS.Enter;

  Append(GR_FL);
  writeln(GR_FL, tstr);
  CloseFile(GR_FL);

  //    SFTCS.Leave;
end;

procedure SFTne(tstr: ansistring);
begin
  //    if SFTCS=nil then SFTCS:=TCriticalSection.Create;
  //    SFTCS.Enter;

  Append(GR_FL);
  write(GR_FL, tstr);
  CloseFile(GR_FL);

  //    SFTCS.Leave;
end;

end.