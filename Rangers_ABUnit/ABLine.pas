unit ABLine;

interface

uses Types,SysUtils,Classes,ab_Obj3D,GR_DirectX3D8,ABKey,ABPoint,EC_BlockPar;

type
TLineAB = class(TObject)
	public
	    FPrev:TLineAB;
        FNext:TLineAB;

        FType:WideString;

		FVerStart:TPointAB;
        FVerEnd:TPointAB;

        FColorStart:TKeyAB;
        FColorEnd:TKeyAB;

        FGraph:TabObj3D;

        FSel:boolean;
        FSelPoint:integer; // -1 - no sellect

    	FGraphSel:TabObj3D;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;

        function Hit(tp:TPoint):boolean;

        procedure Save(bp:TBlockParEC);
        procedure Load(bp:TBlockParEC);
end;

procedure Line_Clear;
function Line_Add:TLineAB;
procedure Line_Delete(el:TLineAB);
function Line_Count:integer;
procedure Line_UpdateGraph;
function Line_Find(p1,p2:TPointAB):TLineAB; overload;
function Line_Find(p1:TPointAB):TList; overload;
function Line_Sel:TLineAB;
procedure Line_Save(bp:TBlockParEC);
procedure Line_Load(bp:TBlockParEC);

var
	Line_First:TLineAB=nil;
	Line_Last:TLineAB=nil;

implementation

uses Form_Main,EC_Str,VOper;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TLineAB.Create;
begin
	inherited Create;
	FColorStart:=TKeyAB.Create(sizeof(D3DCOLOR),@Key_FunInterpolateColor);
	FColorEnd:=TKeyAB.Create(sizeof(D3DCOLOR),@Key_FunInterpolateColor);
end;

destructor TLineAB.Destroy;
begin
	Clear;
    FColorStart.Free; FColorStart:=nil;
    FColorEnd.Free; FColorEnd:=nil;
	inherited Destroy;
end;

procedure TLineAB.Clear;
begin
	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;
	if FGraphSel<>nil then begin ab_Obj3D_Delete(FGraphSel); FGraphSel:=nil; end;
end;

procedure TLineAB.UpdateGraph;
var
	p1,p2,v:D3DVECTOR;
    c1,c2:D3DCOLOR;
    r1,r2:single;
begin
	if (FVerStart=nil) or (FVerEnd=nil) then Exit;

	if FGraph=nil then begin
	    FGraph:=ab_Obj3D_Add;
    	FGraph.VerCount:=2;
	    FGraph.UnitAddLine(0,1);
    end else begin
    end;

    FGraph.VerOpen;
    FGraph.Ver(0)^:=abVer3D(FVerStart.FPosShow.x+GSmeX,FVerStart.FPosShow.y+GSmeY,FVerStart.FPosShow.z,0,0,FColorStart.IpDWORD);
    FGraph.Ver(1)^:=abVer3D(FVerEnd.FPosShow.x+GSmeX,FVerEnd.FPosShow.y+GSmeY,FVerEnd.FPosShow.z,1,1,FColorEnd.IpDWORD);
    FGraph.VerClose;

	if not FSel then begin
		if FGraphSel<>nil then begin ab_Obj3D_Delete(FGraphSel); FGraphSel:=nil; end;
    end else begin
        p1:=FVerStart.FPosShow;
		p2:=FVerEnd.FPosShow;

        v.x:=p2.x-p1.x;
        v.y:=p2.y-p1.y;
        r1:=1/sqrt(sqr(v.x)+sqr(v.y));
        v.x:=v.x*r1;
        v.y:=v.y*r1;

        p1.x:=p1.x-v.y*5;
        p1.y:=p1.y+v.x*5;
        p2.x:=p2.x-v.y*5;
        p2.y:=p2.y+v.x*5;

    	c1:=$ffff0000;
        c2:=$ffff0000;
        r1:=1;
        r2:=1;
        if FSelPoint=0 then begin c1:=$ffffff00; r1:=2; end;
        if FSelPoint=1 then begin c2:=$ffffff00; r2:=2; end;

		if FGraphSel=nil then begin
        	FGraphSel:=ab_Obj3D_AddFirst;
		    FGraphSel.FZTest:=false;
            FGraphSel.CreateCone(D3DV(p1.x+GSmeX,p1.y+GSmeY,p1.z),
            					 D3DV(p2.x+GSmeX,p2.y+GSmeY,p2.z),
                                 r1,r2,c1,c2,
                                 5);
		end else begin
        	FGraphSel.UpdateCone(D3DV(p1.x+GSmeX,p1.y+GSmeY,p1.z),
            					 D3DV(p2.x+GSmeX,p2.y+GSmeY,p2.z),
                                 r1,r2,c1,c2);
		end;
    end;
end;

function TLineAB.Hit(tp:TPoint):boolean;
var
	l1,l2:D3DVECTOR;
    t,l,r:single;
begin
	Result:=false;

	l1.x:=FVerEnd.FPosShow.x-FVerStart.FPosShow.x;
	l1.y:=FVerEnd.FPosShow.y-FVerStart.FPosShow.y;
    l1.z:=0;

	l2.x:=(tp.x-GSmeX)-FVerStart.FPosShow.x;
	l2.y:=(tp.y-GSmeY)-FVerStart.FPosShow.y;
    l2.z:=0;

    l:=sqr(l1.x)+sqr(l1.y)+sqr(l1.z);
    t:=D3D_DotProduct(l1,l2)/l;
    if (t<0) or (t>1.0) then Exit;

	r:=(-l2.y)*(l1.x)-(-l2.x)*(l1.y);
    r:=(r/l)*sqrt(l);
    Result:=abs(r)<3;
end;

procedure TLineAB.Save(bp:TBlockParEC);
begin
	if FType<>'' then bp.Par_Add('Type',FType);

	bp.Par_Add('PointStart',IntToStr(FVerStart.FNo));
	bp.Par_Add('PointEnd',IntToStr(FVerEnd.FNo));

	bp.Par_Add('DiffuseStart',FColorStart.Save);
	bp.Par_Add('DiffuseEnd',FColorEnd.Save);
end;

procedure TLineAB.Load(bp:TBlockParEC);
begin
	if bp.Par_Count('Type')>0 then FType:=bp.Par['Type'];

	FVerStart:=Point_ByNo(StrToIntEC(bp.Par['PointStart']));
	FVerEnd:=Point_ByNo(StrToIntEC(bp.Par['PointEnd']));

    FColorStart.Load(bp.Par['DiffuseStart']);
    FColorEnd.Load(bp.Par['DiffuseEnd']);
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Line_Clear;
begin
	while Line_First<>nil do Line_Delete(Line_Last);
end;

function Line_Add:TLineAB;
var
    el:TLineAB;
begin
    el:=TLineAB.Create;

    if Line_Last<>nil then Line_Last.FNext:=el;
	el.FPrev:=Line_Last;
	el.FNext:=nil;
	Line_Last:=el;
	if Line_First=nil then Line_First:=el;

    Result:=el;
end;

procedure Line_Delete(el:TLineAB);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if Line_Last=el then Line_Last:=el.FPrev;
	if Line_First=el then Line_First:=el.FNext;

    el.Free;
end;

function Line_Count:integer;
var
    el:TLineAB;
begin
	Result:=0;
	el:=Line_First;
    while el<>nil do begin
    	inc(Result);
    	el:=el.FNext;
    end;
end;

procedure Line_UpdateGraph;
var
    el:TLineAB;
begin
	el:=Line_First;
    while el<>nil do begin
    	el.UpdateGraph;
    	el:=el.FNext;
    end;
end;

function Line_Find(p1,p2:TPointAB):TLineAB;
var
    el:TLineAB;
begin
	el:=Line_First;
    while el<>nil do begin
        if ((el.FVerStart=p1) and (el.FVerEnd=p2)) or
           ((el.FVerStart=p2) and (el.FVerEnd=p1)) then
        begin Result:=el; Exit; end;

    	el:=el.FNext;
    end;
    Result:=nil;
end;

function Line_Find(p1:TPointAB):TList; overload;
var
    el:TLineAB;
    li:TList;
begin
	li:=TList.Create;

	el:=Line_First;
    while el<>nil do begin
        if (el.FVerStart=p1) or (el.FVerEnd=p1) then li.Add(el);

    	el:=el.FNext;
    end;

    if li.Count<1 then begin li.Free; li:=nil; end;
    Result:=li;
end;

function Line_Sel:TLineAB;
var
    el:TLineAB;
begin
	el:=Line_First;
    while el<>nil do begin
    	if el.FSel then begin Result:=el; Exit; end;
    	el:=el.FNext;
    end;
    Result:=nil;
end;

procedure Line_Save(bp:TBlockParEC);
var
	el:TLineAB;
    tbp,tbp2:TBlockParEC;
    i:integer;
begin
	tbp:=bp.Block_Add('Line');

    i:=0;
	el:=Line_First;
    while el<>nil do begin
	    tbp2:=tbp.Block_Add(IntToStr(i));
    	el.Save(tbp2);
        inc(i);
    	el:=el.FNext;
    end;
end;

procedure Line_Load(bp:TBlockParEC);
var
	el:TLineAB;
    tbp:TBlockParEC;
    i,cnt:integer;
    tstr:WideString;
begin
	if bp.Block_Count('Line')<1 then Exit; 
	tbp:=bp.Block_Get('Line');

    cnt:=tbp.Block_Count;
    for i:=0 to cnt-1 do begin
    	tstr:=tbp.Block_GetName(i);
        if (tstr='') or (not IsIntEC(tstr)) then continue;

        el:=Line_Add;
        el.Load(tbp.Block_Get(i));
    end;
end;

end.
