unit GR_Rect;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Classes;

type
TRectGR = class(TObject)
    public
        m_Prev,m_Next: TRectGR;
        m_R: TRect;

    public
        constructor Create;
        destructor Destroy; override;

end;

TArrayRectGR = class(TObject)
    public
        m_First:TRectGR;
        m_Last:TRectGR;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;
        function Add: TRectGR;
        procedure Del(ur:TRectGR);

        procedure TestAddOld(addr:TRect); overload;
        procedure TestAdd(addp:TPoint); overload;

        procedure TestAdd(addr:TRect); overload;
        procedure TestAdd_r(aleft,atop,aright,abottom:integer);
end;

implementation

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TRectGR.Create;
begin
    inherited Create;
end;

destructor TRectGR.Destroy;
begin
    inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TArrayRectGR.Create;
begin
    inherited Create;
end;

destructor TArrayRectGR.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TArrayRectGR.Clear;
var
    t,tt:TRectGR;
begin
    t:=m_First;
    while t<>nil do begin
        tt:=t;
        t:=t.m_Next;
        tt.Free;
    end;
    m_First:=nil;
    m_Last:=nil;
end;

function TArrayRectGR.Add: TRectGR;
var
    t:TRectGR;
begin
    t:=TRectGR.Create;

    if m_Last<>nil then m_Last.m_Next:=t;
	t.m_Prev:=m_Last;
	t.m_Next:=nil;
	m_Last:=t;
	if m_First=nil then m_First:=t;

    Result:=t;
end;

procedure TArrayRectGR.Del(ur:TRectGR);
begin
	if ur.m_Prev<>nil then ur.m_Prev.m_Next:=ur.m_Next;
	if ur.m_Next<>nil then ur.m_Next.m_Prev:=ur.m_Prev;
	if m_Last=ur then m_Last:=ur.m_Prev;
	if m_First=ur then m_First:=ur.m_Next;

    ur.Free;
end;

procedure TArrayRectGR.TestAddOld(addr:TRect);
var
    t,tt: TRectGR;
    tr: TRect;
    ts1,ts2,ts3:double;
begin
    t:=m_Last;
    while t<>nil do begin
        with t.m_R do begin
            if (addr.Left>=Left) and (addr.Right<=Right) and (addr.Top>=Top) and (addr.Bottom<=Bottom) then Exit;
        end;
        t:=t.m_Prev;
    end;

    t:=m_Last;
    while t<>nil do begin
        with t.m_R do begin
            if (Left>=addr.Left) and (Right<=addr.Right) and (Top>=addr.Top) and (Bottom<=addr.Bottom) then begin
                tt:=t;
                t:=t.m_Prev;
                Del(tt);
            end else begin
                t:=t.m_Prev;
            end;
        end;
    end;

    ts1:=(addr.Right-addr.Left)*(addr.Bottom-addr.Top);
    t:=m_Last;
    while t<>nil do begin
        if IntersectRect(tr,addr,t.m_R) then begin
            ts2:=(t.m_R.Right-t.m_R.Left)*(t.m_R.Bottom-t.m_R.Top);
            ts3:=(tr.Right-tr.Left)*(tr.Bottom-tr.Top);
            if ((ts3*100.0)/ts1>80.0) or ((ts3*100.0)/ts2>80.0) then begin
                if addr.Left<t.m_R.Left then t.m_R.Left:=addr.Left;
                if addr.Top<t.m_R.Top then t.m_R.Top:=addr.Top;
                if addr.Right>t.m_R.Right then t.m_R.Right:=addr.Right;
                if addr.Bottom>t.m_R.Bottom then t.m_R.Bottom:=addr.Bottom;
                Exit;
            end;
        end;
        t:=t.m_Prev;
    end;

    t:=Add;
    t.m_R:=addr;
end;

procedure TArrayRectGR.TestAdd(addp:TPoint);
var
    t: TRectGR;
    x,y:integer;
begin
    x:=addp.x;
    y:=addp.y;

    t:=m_Last;
    while t<>nil do begin
        with t.m_R do begin
            if (x>=Left) and (x<Right) and (y>=Top) and (y<Bottom) then Exit;
        end;
        t:=t.m_Prev;
    end;

    t:=Add;
    t.m_R:=Rect(x,y,x+1,y+1);
end;

procedure TArrayRectGR.TestAdd(addr:TRect);
var
    t,tt: TRectGR;
begin
    t:=m_Last;
    while t<>nil do begin
        with t.m_R do begin
            if (addr.Left>=Left) and (addr.Right<=Right) and (addr.Top>=Top) and (addr.Bottom<=Bottom) then Exit;
        end;
        t:=t.m_Prev;
    end;

    t:=m_Last;
    while t<>nil do begin
        with t.m_R do begin
            if (Left>=addr.Left) and (Right<=addr.Right) and (Top>=addr.Top) and (Bottom<=addr.Bottom) then begin
                tt:=t;
                t:=t.m_Prev;
                Del(tt);
            end else begin
                t:=t.m_Prev;
            end;
        end;
    end;

    TestAdd_r(addr.Left,addr.Top,addr.Right,addr.Bottom);
end;

(*$WARNINGS OFF*)
procedure TArrayRectGR.TestAdd_r(aLeft,aTop,aRight,aBottom:integer);
var
    t: TRectGR;
    code:DWORD;
    bLeft,bTop,bRight,bBottom:integer;
begin
    t:=m_Last;
    while t<>nil do begin
        bLeft:=t.m_R.Left;
        bRight:=t.m_R.Right;
        bTop:=t.m_R.Top;
        bBottom:=t.m_R.Bottom;
        if (aLeft>=bLeft) and (aRight<=bRight) and (aTop>=bTop) and (aBottom<=bBottom) then Exit;
        if not ((aleft>=bRight) or (aright<=bLeft) or (atop>=bBottom) or (abottom<=bTop)) then break;
        t:=t.m_Prev;
    end;
    if t=nil then begin
        t:=Add;
        t.m_R.Left:=aLeft;
        t.m_R.Top:=aTop;
        t.m_R.Right:=aRight;
        t.m_R.Bottom:=aBottom;
        Exit;
    end;

    code:=0;
    if aLeft<bLeft then code:=code or 1;
//    if aLeft>=bRight then code:=code or 2;

//    if aRight<=bLeft then code:=code or 4;
    if aRight>bRight then code:=code or 8;

    if aTop<bTop then code:=code or 16;
//    if aTop>=bBottom then code:=code or 32;

//    if aBottom<=bTop then code:=code or 64;
    if aBottom>bBottom then code:=code or 128;

    if code=(1) then begin
        TestAdd_r(aLeft,aTop,bLeft,aBottom);
    end else if code=(8) then begin
        TestAdd_r(bRight,aTop,aRight,aBottom);
    end else if code=(16) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
    end else if code=(128) then begin
        TestAdd_r(aLeft,bBottom,aRight,aBottom);


    end else if code=(1 or 8) then begin
        TestAdd_r(aLeft,aTop,bLeft,aBottom);
        TestAdd_r(bRight,aTop,aRight,aBottom);
    end else if code=(16 or 128) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(aLeft,bBottom,aRight,aBottom);


    end else if code=(1 or 16) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(aLeft,bTop,bLeft,aBottom);
    end else if code=(8 or 16) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(bRight,bTop,aRight,aBottom);
    end else if code=(1 or 128) then begin
        TestAdd_r(aLeft,bBottom,aRight,aBottom);
        TestAdd_r(aLeft,aTop,bLeft,bBottom);
    end else if code=(8 or 128) then begin
        TestAdd_r(aLeft,bBottom,aRight,aBottom);
        TestAdd_r(bRight,aTop,aRight,bBottom);


    end else if code=(1 or 16 or 128) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(aLeft,bTop,bLeft,bBottom);
        TestAdd_r(aLeft,bBottom,aRight,aBottom);
    end else if code=(8 or 16 or 128) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(bRight,bTop,aRight,bBottom);
        TestAdd_r(aLeft,bBottom,aRight,aBottom);
    end else if code=(1 or 8 or 16) then begin
        TestAdd_r(aLeft,aTop,aRight,bTop);
        TestAdd_r(aLeft,bTop,bLeft,aBottom);
        TestAdd_r(bRight,bTop,aRight,aBottom);
    end else if code=(1 or 8 or 128) then begin
        TestAdd_r(aLeft,bBottom,aRight,aBottom);
        TestAdd_r(aLeft,aTop,bLeft,bBottom);
        TestAdd_r(bRight,aTop,aRight,bBottom);


    end;
end;
(*$WARNINGS ON*)

end.

