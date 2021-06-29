unit GraphUnit;

interface

uses Windows,Classes,Graphics,Math,Stdctrls,SysUtils,EC_Buf;

type
TGraphPoint = class(TObject)
    public
        FPos:TPoint;
        FText:WideString;

        FParent:TGraphPoint;

        FImage:WideString;

        FTextRect:TRect;
    public
        constructor Create;
        destructor Destroy; override;

        function WorldPos:TPoint; overload;
        function WorldPos(tsme:TPoint):TPoint; overload;
        function GetRectImage(tsme:TPoint):TRect;
        function GetUpdateRect(tsme:TPoint):TRect;
        procedure MoveInvalidRect(wn:HWND; tsme:TPoint);

        function DblClick:boolean; virtual;

        procedure Save(bd:TBufEC); virtual;
        procedure Load(bd:TBufEC); virtual;
        procedure LoadLink; virtual;

        procedure MsgDeletePoint(p:TGraphPoint); virtual;

        function Info:WideString; virtual;
end;

TGraphLink = class(TObject)
    public
        FBegin:TGraphPoint;
        FEnd:TGraphPoint;

        FNom:integer;
        FArrow:boolean;

        FPoint:array of TPoint;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Calc(tsme:TPoint);
        procedure DrawLine(ca:TCanvas);
        procedure DrawArrow(ca:TCanvas);

        function TestHit(pos:TPoint):boolean;

        function GetUpdateRect(tsme:TPoint):TRect;

        function DblClick:boolean; virtual;

        procedure Save(bd:TBufEC); virtual;
        procedure Load(bd:TBufEC); virtual;
        procedure LoadLink; virtual;

        function Info:WideString; virtual;
end;

TGraphRectText = class(TObject)
    public
        FRect:TRect;
        FFStyle:TBrushStyle;
        FFColor:TColor;
        FBStyle:TPenStyle;
        FBColor:TColor;
        FBSize:integer;
        FBCoef:single;
        FTAlignX:integer;
        FTAlignY:integer;
        FTAlignRect:boolean;
        FTText:WideString;
        FTColor:TColor;
        FTFont:WideString;
        FTFontSize:integer;
        FTFontStyle:TFontStyles;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Draw(ca:TCanvas; tsme:TPoint);

        procedure Save(bd:TBufEC); virtual;
        procedure Load(bd:TBufEC); virtual;
        procedure LoadLink; virtual;
end;

TGraphPointInterface=class(TObject)
    public
        FName:WideString;
        FGroup:integer;
    public
        function NewPoint(tpos:TPoint):TGraphPoint; virtual; abstract;
end;

procedure AllClear;
procedure Save(bd:TBufEC);
procedure Load(bd:TBufEC);
procedure LoadLink;
function FindLinkBeginOrEnd(p:TGraphPoint; sme:integer=0):TGraphLink;
function FindLink(p1,p2:TGraphPoint; sme:integer=0):TGraphLink;
function FindLinkFull(p1,p2:TGraphPoint; sme:integer=0):TGraphLink; overload;
function FindLinkFull(p:TGraphPoint; classname:AnsiString; sme:integer=0):TGraphLink; overload;
function FindLinkBegin(p:TGraphPoint; classname:AnsiString; sme:integer=0):TGraphLink; overload;
procedure ReNomLink(p1,p2:TGraphPoint);
procedure MsgDeletePoint(p:TGraphPoint);
procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor; bsize:integer; bcoef:single; tax:integer; tay:integer; tar:boolean; text:WideString);
procedure SaveCanvasPar(ca:TCanvas);
procedure LoadCanvasPar(ca:TCanvas);

function CT(path:WideString):WideString;

procedure FindAllPoint(className:AnsiString; li:TList);
procedure FindAllPointLinkFull(className:AnsiString; classNameLink:AnsiString; li:TList);
procedure FindAllLinkPointFull(p:TGraphPoint; className:AnsiString; li:TList);
procedure FindAllLinkPoint(p:TGraphPoint; className:AnsiString; li:TList; zadd:boolean=false);
function IsPointConnectPointFull(p:TGraphPoint; className:AnsiString):boolean;
procedure FindAllLinkFull(className1:AnsiString; className2:AnsiString; li:TList);

var
    GSysWorkDir: WideString;

    GGraphPoint:TList;
    GGraphLink:TList;
    GGraphRectText:TList;

    GGraphPointInterface:TList;

    GFileVersion:integer;

implementation

uses Form_Main,EC_Str,Main;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGraphPoint.Create;
begin
    inherited Create;
end;

destructor TGraphPoint.Destroy;
begin
    inherited Destroy;
end;

function TGraphPoint.WorldPos:TPoint;
begin
    if FParent=nil then begin
        Result:=FPos;
    end else begin
        Result:=FParent.WorldPos;
        Result.x:=FParent.WorldPos.x+FPos.x;
        Result.y:=FParent.WorldPos.y+FPos.y;
    end;
end;

function TGraphPoint.WorldPos(tsme:TPoint):TPoint;
begin
    Result:=WorldPos;
    Result.x:=Result.x-tsme.x;
    Result.y:=Result.y-tsme.y;
end;

function TGraphPoint.GetRectImage(tsme:TPoint):TRect;
var
    tp,tp2:TPoint;
begin
    tp:=WorldPos;
    tp2:=ImageSize(FImage);
    Result.Left:=tp.x-tp2.x div 2-tsme.x;
    Result.Top:=tp.y-tp2.y div 2-tsme.y;
    Result.Right:=Result.Left+tp2.x;
    Result.Bottom:=Result.Top+tp2.y;
end;

function TGraphPoint.GetUpdateRect(tsme:TPoint):TRect;
var
    tr:TRect;
begin
    Result:=GetRectImage(tsme);
    Result.Left:=Result.Left-5;
    Result.Top:=Result.Top-5;
    Result.Right:=Result.Right+5;
    Result.Bottom:=Result.Bottom+5;

    tr.Left:=WorldPos(tsme).x+FTextRect.Left;
    tr.Top:=WorldPos(tsme).y+FTextRect.Top;
    tr.Right:=WorldPos(tsme).x+FTextRect.Right;
    tr.Bottom:=WorldPos(tsme).y+FTextRect.Bottom;

    UnionRect(Result,Result,tr);
end;

procedure TGraphPoint.MoveInvalidRect(wn:HWND; tsme:TPoint);
var
    tr:TRect;
    gl:TGraphLink;
    gp:TGraphPoint;
    i:integer;
begin
    tr:=GetUpdateRect(tsme);
    InvalidateRect(wn,@tr,false);

    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=self) or (gl.FEnd=self) then begin
            tr:=gl.GetUpdateRect(tsme);
            InvalidateRect(wn,@tr,false);
        end;
    end;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp.FParent=self then begin
            gp.MoveInvalidRect(wn,tsme);
        end;
    end;
end;

function TGraphPoint.DblClick:boolean;
begin
    Result:=false;
end;

procedure TGraphPoint.Save(bd:TBufEC);
begin
    bd.AddInteger(FPos.x);
    bd.AddInteger(FPos.y);
    bd.Add(FText);
    bd.AddDWORD(GGraphPoint.IndexOf(FParent));
end;

procedure TGraphPoint.Load(bd:TBufEC);
begin
    FPos.x:=bd.GetInteger;
    FPos.y:=bd.GetInteger;
    FText:=bd.GetWideStr;
    FParent:=TGraphPoint(bd.GetDWORD);
end;

procedure TGraphPoint.LoadLink;
begin
    if integer(DWORD(FParent))=-1 then FParent:=nil
    else FParent:=GGraphPoint.Items[DWORD(FParent)];
end;

procedure TGraphPoint.MsgDeletePoint(p:TGraphPoint);
begin
end;

function TGraphPoint.Info:WideString;
begin
    Result:='';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGraphLink.Create;
begin
    inherited Create;
end;

destructor TGraphLink.Destroy;
begin
    FPoint:=nil;
    inherited Destroy;
end;

procedure TGraphLink.Calc(tsme:TPoint);
var
    x1,y1,x2,y2,xp,yp,xt,yt:single;
    i,cnt:integer;
    t,t1,tstep:single;
begin
    x1:=FBegin.WorldPos(tsme).x;
    y1:=FBegin.WorldPos(tsme).y;
    x2:=FEnd.WorldPos(tsme).x;
    y2:=FEnd.WorldPos(tsme).y;

    if FNom=0 then begin
        SetLength(FPoint,2);
        FPoint[0]:=Point(Round(x1),Round(y1));
        FPoint[1]:=Point(Round(x2),Round(y2));
    end else begin
        cnt:=max(5,Round(sqrt(sqr(x1-x2)+sqr(y1-y2)) / 20))*(FNom)+2;

        SetLength(FPoint,cnt);
        FPoint[0]:=Point(Round(x1),Round(y1));

        xt:=(x1+x2)/2;
        yt:=(y1+y2)/2;

        xp:=(xt-(y2-yt))-xt;
        yp:=(yt+(x2-xt))-yt;
        t:=1/sqrt(xp*xp+yp*yp);
        xp:=xp*t;
        yp:=yp*t;

        xp:=xt+xp*CoefLink*FNom;
        yp:=yt+yp*CoefLink*FNom;

        tstep:=1.0/(cnt-1);
        t:=tstep;
        for i:=1 to cnt-1 do begin
            t1:=1.0-t;
            xt:=t1*t1*x1+2*t*t1*xp+t*t*x2;
            yt:=t1*t1*y1+2*t*t1*yp+t*t*y2;
            FPoint[i]:=Point(Round(xt),Round(yt));
            t:=t+tstep;
        end;
    end;
end;

procedure TGraphLink.DrawLine(ca:TCanvas);
begin
    ca.Polyline(FPoint);
end;

procedure TGraphLink.DrawArrow(ca:TCanvas);
var
    x1,y1,x2,y2,xp,yp,xt,yt:single;
    t:single;
    pol:array[0..2] of TPoint;
begin
    if not FArrow then Exit;

    x1:=FPoint[High(FPoint)-1].x;
    y1:=FPoint[High(FPoint)-1].y;
    x2:=FPoint[High(FPoint)].x;
    y2:=FPoint[High(FPoint)].y;

    x1:=x1-x2;
    y1:=y1-y2;
    if (x1=0) and (y1=0) then Exit;
    t:=1.0/sqrt(x1*x1+y1*y1);
    x1:=x1*t;
    y1:=y1*t;

    t:=25*3.1415926/180.0;
    xp:=x1*cos(t)-y1*sin(t);
    yp:=x1*sin(t)+y1*cos(t);

    xt:=x2+xp*10;
    yt:=y2+yp*10;

    pol[0].x:=Round(x2); pol[0].y:=Round(y2);
    pol[1].x:=Round(xt); pol[1].y:=Round(yt);

    xp:=x1*cos(-t)-y1*sin(-t);
    yp:=x1*sin(-t)+y1*cos(-t);

    xt:=x2+xp*10;
    yt:=y2+yp*10;

    pol[2].x:=Round(xt); pol[2].y:=Round(yt);

    ca.Polygon(pol);
end;

// Return: 1-LEFT 2-RIGHT 3-BEHIND 4-BEYOND 5-BETWEEN 6-ORGIN 7-DESTINATION
function TestClassify(p:TPoint; q:TPoint; this:TPoint):integer;
var
    a,b:TPoint;
    s:integer;
begin
    a:=Point(q.x-p.x,q.y-p.y);
    b:=Point(this.x-p.x,this.y-p.y);
    s:=a.x*b.y-a.y*b.x;

    if s>0 then begin Result:=1; Exit; end;
    if s<0 then begin Result:=2; Exit; end;
    
    if ((a.x*b.x)<0) or ((a.y*b.y)<0) then begin Result:=3; Exit; end;
    if sqrt(a.x*a.x+a.y*a.y)<sqrt(b.x*b.x+b.y*b.y) then begin Result:=4; Exit; end;

    if (p.x=this.x) and (p.y=this.y) then begin Result:=6; Exit; end;
    if (q.x=this.x) and (q.y=this.y) then begin Result:=7; Exit; end;

    Result:=5;
end;

function PointBetweenLine(a:TPoint; b:TPoint; c:TPoint):boolean;
var
    l,r:single;
    px,py:single;
begin
    l:=sqrt(sqr(a.x-b.x)+sqr(a.y-b.y));
    if l=0 then begin Result:=false; Exit; end;
    r:=((a.y-c.y)*(a.y-b.y)-(a.x-c.x)*(b.x-a.x))/(l*l);

    px:=a.x+r*(b.x-a.x);
    py:=a.y+r*(b.y-a.y);

    Result:=(px>=min(a.x,b.x)) and (px<=max(a.x,b.x)) and (py>=min(a.y,b.y)) and (py<=max(a.y,b.y));
end;

function DistLinePoint(a:TPoint; b:TPoint; c:TPoint):single;
var
    l,s:single;
begin
    l:=sqrt(sqr(a.x-b.x)+sqr(a.y-b.y));
    if l=0 then begin Result:=1e30; Exit; end;
    s:=(a.y-c.y)*(b.x-a.x)-(a.x-c.x)*(b.y-a.y);
    Result:=((s)/(l*l))*l;
end;

function TGraphLink.TestHit(pos:TPoint):boolean;
var
    i:integer;
begin
    Result:=false;
    for i:=0 to High(FPoint)-1 do begin
        if not PointBetweenLine(FPoint[i],FPoint[i+1],pos) then continue;

        if abs(DistLinePoint(FPoint[i],FPoint[i+1],pos))<4 then begin
            Result:=true;
            Exit;
        end;
    end;
end;

function TGraphLink.GetUpdateRect(tsme:TPoint):TRect;
var
    tr:TRect;
    i:integer;
begin
    if (FPoint=nil) then Exit;
    tr.TopLeft:=FPoint[0];
    tr.BottomRight:=FPoint[0];
    for i:=1 to High(FPoint) do begin
        tr.Left:=min(tr.Left,FPoint[i].x);
        tr.Top:=min(tr.Top,FPoint[i].y);
        tr.Right:=max(tr.Right,FPoint[i].x);
        tr.Bottom:=max(tr.Bottom,FPoint[i].y);
    end;

    Result.Left:=tr.Left-5;
    Result.Top:=tr.Top-5;
    Result.Right:=tr.Right+5;
    Result.Bottom:=tr.Bottom+5;
end;

function TGraphLink.DblClick:boolean;
begin
    Result:=false;
end;

procedure TGraphLink.Save(bd:TBufEC);
begin
    bd.AddInteger(GGraphPoint.IndexOf(FBegin));
    bd.AddInteger(GGraphPoint.IndexOf(FEnd));

    bd.AddInteger(FNom);
    bd.AddBoolean(FArrow);
end;

procedure TGraphLink.Load(bd:TBufEC);
begin
    FBegin:=GGraphPoint.Items[bd.GetInteger];
    FEnd:=GGraphPoint.Items[bd.GetInteger];

    FNom:=bd.GetInteger;
    FArrow:=bd.GetBoolean;
end;

procedure TGraphLink.LoadLink;
begin
end;

function TGraphLink.Info:WideString;
begin
    Result:='';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TGraphRectText.Create;
begin
    inherited Create;

    FFStyle:=bsSolid;
    FFColor:=RGB(34,111,163);
    FBStyle:=psSolid;
    FBColor:=RGB(220,220,220);
    FBSize:=1;
    FBCoef:=0.3;
    FTAlignX:=0;
    FTAlignY:=0;
    FTAlignRect:=false;
    FTText:='';
    FTColor:=RGB(255,255,255);
    FTFont:='Arial';
    FTFontSize:=10;
    FTFontStyle:=[];
end;

destructor TGraphRectText.Destroy;
begin
    inherited Destroy;
end;

procedure TGraphRectText.Draw(ca:TCanvas; tsme:TPoint);
begin
    ca.Font.Color:=FTColor;
    ca.Font.Name:=FTFont;
    ca.Font.Size:=FTFontSize;
    ca.Font.Style:=FTFontStyle;

    DrawRectText(ca,
                 Rect(FRect.Left-tsme.x,FRect.Top-tsme.y,FRect.Right-tsme.x,FRect.Bottom-tsme.y),
                 FFStyle,
                 FFColor,
                 FBStyle,
                 FBColor,
                 FBSize,
                 FBCoef,
                 FTAlignX,
                 FTAlignY,
                 FTAlignRect,
                 FTText);
end;

procedure TGraphRectText.Save(bd:TBufEC);
begin
    bd.AddInteger(FRect.Left);
    bd.AddInteger(FRect.Top);
    bd.AddInteger(FRect.Right);
    bd.AddInteger(FRect.Bottom);
    bd.AddBYTE(BYTE(FFStyle));
    bd.AddDWORD(FFColor);
    bd.AddBYTE(BYTE(FBStyle));
    bd.AddDWORD(FBColor);
    bd.AddInteger(FBSize);
    bd.AddSingle(FBCoef);
    bd.AddInteger(FTAlignX);
    bd.AddInteger(FTAlignY);
    bd.AddBoolean(FTAlignRect);
    bd.Add(FTText);
    bd.AddDWORD(FTColor);
    bd.Add(FTFont);
    bd.AddInteger(FTFontSize);
    bd.AddBoolean(fsBold in FTFontStyle);
    bd.AddBoolean(fsItalic in FTFontStyle);
    bd.AddBoolean(fsUnderline in FTFontStyle);
end;

procedure TGraphRectText.Load(bd:TBufEC);
begin
    FRect.Left:=bd.GetInteger;
    FRect.Top:=bd.GetInteger;
    FRect.Right:=bd.GetInteger;
    FRect.Bottom:=bd.GetInteger;
    FFStyle:=TBrushStyle(bd.GetBYTE);
    FFColor:=bd.GetDWORD;
    FBStyle:=TPenStyle(bd.GetBYTE);
    FBColor:=bd.GetDWORD;
    FBSize:=bd.GetInteger;
    FBCoef:=bd.GetSingle;
    FTAlignX:=bd.GetInteger;
    FTAlignY:=bd.GetInteger;
    FTAlignRect:=bd.GetBoolean;
    FTText:=bd.GetWideStr;
    FTColor:=bd.GetDWORD;
    FTFont:=bd.GetWideStr;
    FTFontSize:=bd.GetInteger;

    FTFontStyle:=[];
    if bd.GetBoolean then FTFontStyle:=FTFontStyle+[fsBold];
    if bd.GetBoolean then FTFontStyle:=FTFontStyle+[fsItalic];
    if bd.GetBoolean then FTFontStyle:=FTFontStyle+[fsUnderline];
end;

procedure TGraphRectText.LoadLink;
begin
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure AllClear;
var
    i:integer;
    gp:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
begin
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        gp.Free;
    end;
    GGraphPoint.Clear;

    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        gl.Free;
    end;
    GGraphLink.Clear;

    for i:=0 to GGraphRectText.Count-1 do begin
        grt:=GGraphRectText.Items[i];
        grt.Free;
    end;
    GGraphRectText.Clear;
end;

procedure Save(bd:TBufEC);
var
    i:integer;
    gp:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
begin
    bd.AddInteger(GGraphPoint.Count);
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        bd.Add(WideString(gp.ClassName));
        gp.Save(bd);
    end;

    bd.AddInteger(GGraphLink.Count);
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        bd.Add(WideString(gl.ClassName));
        gl.Save(bd);
    end;

    bd.AddInteger(GGraphRectText.Count);
    for i:=0 to GGraphRectText.Count-1 do begin
        grt:=GGraphRectText.Items[i];
        bd.Add(WideString(grt.ClassName));
        grt.Save(bd);
    end;
end;

procedure Load(bd:TBufEC);
var
    i,cnt:integer;
    gp:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
begin
//    bd.BPointer:=$1fb5;
    
    cnt:=bd.GetInteger();
    for i:=0 to cnt-1 do begin
        gp:=CreateByName(bd.GetWideStr) as TGraphPoint;
        GGraphPoint.Add(gp);
        gp.Load(bd);
    end;

    cnt:=bd.GetInteger();
    for i:=0 to cnt-1 do begin
        gl:=CreateByName(bd.GetWideStr) as TGraphLink;
        GGraphLink.Add(gl);
        gl.Load(bd);
    end;

    cnt:=bd.GetInteger();
    for i:=0 to cnt-1 do begin
        grt:=CreateByName(bd.GetWideStr) as TGraphRectText;
        GGraphRectText.Add(grt);
        grt.Load(bd);
    end;
end;

procedure LoadLink;
var
    i:integer;
    gp:TGraphPoint;
    gl:TGraphLink;
    grt:TGraphRectText;
begin
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        gp.LoadLink;
    end;

    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        gl.LoadLink;
    end;

    for i:=0 to GGraphRectText.Count-1 do begin
        grt:=GGraphRectText.Items[i];
        grt.LoadLink;
    end;
end;

function FindLinkBeginOrEnd(p:TGraphPoint; sme:integer=0):TGraphLink;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=sme to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=p) or (gl.FEnd=p) then begin
            Result:=gl;
            Exit;
        end;
    end;
    Result:=nil;
end;

function FindLink(p1,p2:TGraphPoint; sme:integer):TGraphLink;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=sme to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=p1) and (gl.FEnd=p2) then begin
            Result:=gl;
            Exit;
        end;
    end;
    Result:=nil;
end;

function FindLinkFull(p1,p2:TGraphPoint; sme:integer):TGraphLink;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=sme to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if ((gl.FBegin=p1) and (gl.FEnd=p2)) or ((gl.FBegin=p2) and (gl.FEnd=p1)) then begin
            Result:=gl;
            Exit;
        end;
    end;
    Result:=nil;
end;

function FindLinkFull(p:TGraphPoint; classname:AnsiString; sme:integer=0):TGraphLink;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=sme to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if ((gl.FBegin=p) and (gl.FEnd.ClassName=classname)) or ((gl.FBegin.ClassName=classname) and (gl.FEnd=p)) then begin
            Result:=gl;
            Exit;
        end;
    end;
    Result:=nil;
end;

function FindLinkBegin(p:TGraphPoint; classname:AnsiString; sme:integer=0):TGraphLink;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=sme to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if ((gl.FBegin=p) and (gl.FEnd.ClassName=classname)) then begin
            Result:=gl;
            Exit;
        end;
    end;
    Result:=nil;
end;

procedure ReNomLink(p1,p2:TGraphPoint);
var
    i,no1,no2:integer;
    gl:TGraphLink;
begin
    no1:=0;
    no2:=0;
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=p1) and (gl.FEnd=p2) then begin
            gl.FNom:=no1;
            if no1=0 then no2:=1;
            inc(no1);
        end else if (gl.FBegin=p2) and (gl.FEnd=p1) then begin
            gl.FNom:=no2;
            if no2=0 then no1:=1;
            inc(no2);
        end;
    end;
end;

procedure MsgDeletePoint(p:TGraphPoint);
var
    i:integer;
    gp:TGraphPoint;
begin
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        gp.MsgDeletePoint(p);
    end;
end;

procedure DrawRectText(ca:TCanvas; rc:TRect; fs:TBrushStyle; fcolor:TColor; bstyle:TPenStyle; bcolor:TColor; bsize:integer; bcoef:single; tax:integer; tay:integer; tar:boolean; text:WideString);
var
    x,y,i:integer;
    crc:TRect;
    hr:HRGN;
    hrok:integer;
    fl:DWORD;
begin
    ca.Brush.Color:=fcolor;
    ca.Brush.Style:=fs;
    ca.Pen.Style:=psClear;
    ca.Rectangle(rc.left{+bsize},rc.top{+bsize},rc.Right{+1-bsize},rc.Bottom{+1-bsize});

    ca.Pen.Color:=bcolor;
    ca.Pen.Style:=bstyle;
    ca.Pen.Width:=1;
    for i:=0 to bsize-1 do begin
        ca.MoveTo(rc.Right-2-i,rc.Top+i);
        ca.LineTo(rc.Left+i,rc.Top+i);
        ca.LineTo(rc.Left+i,rc.Bottom-2-i);
    end;

    ca.Pen.Color:=RGB(min(255,max(0,Round(GetRValue(bcolor)*bcoef))),min(255,max(0,Round(GetGValue(bcolor)*bcoef))),min(255,max(0,Round(GetBValue(bcolor)*bcoef))));
    for i:=0 to bsize-1 do begin
        ca.MoveTo(rc.Left+i,rc.Bottom-2-i);
        ca.LineTo(rc.Right-2-i,rc.Bottom-2-i);
        ca.LineTo(rc.Right-2-i,rc.Top+i);
    end;

    if Length(TrimEx(text))<1 then Exit;

    rc.Left:=rc.Left+bsize+1;
    rc.Top:=rc.Top+bsize+1;
    rc.Right:=rc.Right-bsize-1;
    rc.Bottom:=rc.Bottom-bsize-1;

    crc:=Rect(0,0,1000000,1000000);
    DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,DT_TOP or DT_LEFT or DT_NOCLIP or DT_CALCRECT);

    if tax<0 then begin x:=rc.Left; fl:=DT_LEFT; end
    else if tax=0 then begin x:=(rc.Left+rc.Right) div 2-(crc.Right-crc.Left) div 2; fl:=DT_CENTER; end
    else begin x:=rc.Right-(crc.Right-crc.Left); fl:=DT_RIGHT; end;

    if tay<0 then y:=rc.Top
    else if tay=0 then y:=(rc.Top+rc.Bottom) div 2-(crc.Bottom-crc.Top) div 2
    else y:=rc.Bottom-(crc.Bottom-crc.Top);

    hr:=CreateRectRgn(0,0,1,1);
    hrok:=GetClipRgn(ca.Handle,hr);

//    BeginPath(ca.Handle);
//    SelectClipPath(ca.Handle,RGN_OR);
    IntersectClipRect(ca.Handle,rc.Left,rc.Top,rc.Right,rc.Bottom);

    if tar then begin
        crc:=Rect(x,y,1000000,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,DT_LEFT or DT_TOP or DT_NOCLIP);
    end else begin
        crc:=Rect(rc.Left,y,rc.Right,1000000);
        DrawText(ca.Handle,PChar(AnsiString(text)),-1,crc,fl or DT_TOP or DT_NOCLIP);
    end;

//    EndPath(ca.Handle);

    SelectClipRgn(ca.Handle,0);
    if hrok=1 then SelectClipRgn(ca.Handle,hr);
    DeleteObject(hr);
end;

var
    old_Brush_Color:TColor;
    old_Brush_Style:TBrushStyle;
    old_Pen_Color:TColor;
    old_Pen_Style:TPenStyle;
    old_Pen_Width:integer;
    old_Font_Color:TColor;
    old_Font_Size:integer;
    old_Font_Name:AnsiString;

procedure SaveCanvasPar(ca:TCanvas);
begin
    old_Brush_Color:=ca.Brush.Color;
    old_Brush_Style:=ca.Brush.Style;
    old_Pen_Color:=ca.Pen.Color;
    old_Pen_Style:=ca.Pen.Style;
    old_Pen_Width:=ca.Pen.Width;
    old_Font_Color:=ca.Font.Color;
    old_Font_Size:=ca.Font.Size;
    old_Font_Name:=ca.Font.Name;
end;

procedure LoadCanvasPar(ca:TCanvas);
begin
    ca.Brush.Color:=old_Brush_Color;
    ca.Brush.Style:=old_Brush_Style;
    ca.Pen.Color:=old_Pen_Color;
    ca.Pen.Style:=old_Pen_Style;
    ca.Pen.Width:=old_Pen_Width;
    ca.Font.Color:=old_Font_Color;
    ca.Font.Size:=old_Font_Size;
    ca.Font.Name:=old_Font_Name;
end;

function CT(path:WideString):WideString;
var
	i,count:integer;
begin
    path:='Text.'+path;
	Result:='';
    count:=FCfg.ParPath_Count(path);
    for i:=0 to count-1 do begin
    	if Result<>'' then Result:=Result+#13#10;
	    Result:=Result+FCfg.ParPath_Get(path + ':' + IntToStr(i));
    end;
end;

procedure FindAllPoint(className:AnsiString; li:TList);
var
    i:integer;
    gp:TGraphPoint;
begin
    li.Clear;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp.ClassName=className then li.Add(gp);
    end;
end;

procedure FindAllPointLinkFull(className:AnsiString; classNameLink:AnsiString; li:TList);
var
    i,u:integer;
    gp,gp2:TGraphPoint;
begin
    li.Clear;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp.ClassName=className then begin
            for u:=0 to GGraphPoint.Count-1 do begin
                gp2:=GGraphPoint.Items[u];
                if gp2.ClassName=classNameLink then begin
                    if FindLinkFull(gp,gp2)<>nil then begin
                        li.Add(gp);
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

procedure FindAllLinkPointFull(p:TGraphPoint; className:AnsiString; li:TList);
var
    i:integer;
    gp:TGraphPoint;
begin
    li.Clear;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp.ClassName=className then begin
            if FindLinkFull(p,gp)<>nil then begin
                li.Add(gp);
            end;
        end;
    end;

end;

procedure FindAllLinkPoint(p:TGraphPoint; className:AnsiString; li:TList; zadd:boolean);
var
    i:integer;
    gp:TGraphPoint;
begin
    if not zadd then li.Clear;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp.ClassName=className then begin
            if FindLink(p,gp)<>nil then begin
                li.Add(gp);
            end;
        end;
    end;

end;

function IsPointConnectPointFull_r(p:TGraphPoint; className:AnsiString; li:TList):boolean;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=p) and (gl.FEnd.ClassName=className) then begin
            Result:=True;
            Exit;
        end;
    end;
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=p) and (gl.FEnd.ClassName=className) and (li.IndexOf(gl.FEnd)<0) then begin
            li.Add(gl.FEnd);
            Result:=IsPointConnectPointFull(gl.FEnd,className);
            if Result then Exit;
        end;
    end;
    Result:=false;
    Exit;
end;

function IsPointConnectPointFull(p:TGraphPoint; className:AnsiString):boolean;
var
    li:TList;
begin
    li:=TList.Create;
    li.Add(p);
    Result:=IsPointConnectPointFull_r(p,className,li);
    li.Free;
end;

procedure FindAllLinkFull(className1:AnsiString; className2:AnsiString; li:TList);
var
    i:integer;
    link:TGraphLink;
begin
    li.Clear;
    for i:=0 to GGraphLink.Count-1 do begin
        link:=GGraphLink.Items[i];
        if ((link.FBegin.ClassName=className1) and (link.FEnd.ClassName=className2)) or
           ((link.FBegin.ClassName=className2) and (link.FEnd.ClassName=className1))
        then begin
            li.Add(link);
        end;
    end;
end;

end.

