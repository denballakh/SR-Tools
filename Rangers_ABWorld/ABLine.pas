unit ABLine;

interface

uses Types,SysUtils,Classes,ab_Obj3D,GR_DirectX3D8,ABPoint,EC_BlockPar,EC_Buf,ABKey;

type
TLineAB = class(TObject)
	public
	    FPrev:TLineAB;
        FNext:TLineAB;

        FShow:boolean;
        FStopLine:boolean;

		FVerStart:TPointAB;
        FVerEnd:TPointAB;

        FColorStart:TKeyAB;
        FColorEnd:TKeyAB;

        FGraph:TabObj3D;

        FSel:boolean;

        FOwner:TObject;
    public
        constructor Create(gl:TKeyGroupList);
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;

        function Hit(tp:TPoint):boolean;

        procedure Save(bp:TBlockParEC);
        procedure Load(bp:TBlockParEC);
        procedure SaveWorld(bd:TBufEC);
        procedure LoadWorld(bd:TBufEC);

        procedure SaveEnd(bd,tempbuf:TBufEC);
end;

procedure Line_Clear;
function Line_Add(gl:TKeyGroupList):TLineAB;
procedure Line_Delete(el:TLineAB);
function Line_Count:integer;
procedure Line_UpdateGraph;
function Line_Find(p1,p2:TPointAB):TLineAB; overload;
function Line_Find(p1:TPointAB):TList; overload;
function Line_Sel:TLineAB;
procedure Line_Save(bp:TBlockParEC);
procedure Line_Load(bp:TBlockParEC; owner:TObject; gl:TKeyGroupList);
procedure Line_SaveWorld(bd:TBufEC);
procedure Line_LoadWorld(bd:TBufEC);
procedure Line_SaveEnd(bd,tempbuf:TBufEC);

var
	Line_First:TLineAB=nil;
	Line_Last:TLineAB=nil;

implementation

uses Form_Main,EC_Str,VOper,Global,WorldUnit;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TLineAB.Create(gl:TKeyGroupList);
begin
	inherited Create;
	FColorStart:=TKeyAB.Create(gl,sizeof(D3DCOLOR),@Key_FunInterpolateColor);
	FColorEnd:=TKeyAB.Create(gl,sizeof(D3DCOLOR),@Key_FunInterpolateColor);

    FShow:=true;
	FStopLine:=false;
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
end;

procedure TLineAB.UpdateGraph;
begin
	if not TabWorldUnit(FOwner).FDraw then begin
    	if FGraph<>nil then FGraph.FDrawFromObjLoop:=false;
    	Exit;
    end;

	if (FVerStart=nil) or (FVerEnd=nil) then Exit;

	if FGraph=nil then begin
	    FGraph:=ab_Obj3D_Add;
    	FGraph.VerCount:=2;
	    FGraph.UnitAddLine(0,1);
    end else begin
    end;

    if FStopLine then begin
		FGraph.FDrawFromObjLoop:=FormMain.MM_View_SLShow.Checked or (FormMain.MM_View_SLDefault.Checked and FShow);
    end else begin
		FGraph.FDrawFromObjLoop:=FShow and ab_InTop(FVerStart.FPosShow.z) and ab_InTop(FVerEnd.FPosShow.z);
    end;
//	FGraph.FDrawFromObjLoop:=false;
//    FGraph.FDrawFromObjLoop:=ab_InTop(FVerStart.FPosShow.z) and ab_InTop(FVerStart.FPosShow.z);
//	FGraph.FDrawFromObjLoop:=FormMain.MM_View_SLShow.Checked or (FormMain.MM_View_SLDefault.Checked and FShow);

    FGraph.VerOpen;
    FGraph.Ver(0)^:=abVer3D(FVerStart.FPosShow.x+GSmeX,FVerStart.FPosShow.y+GSmeY,FVerStart.FPosShow.z,0,0,FColorStart.IpDWORD);
    FGraph.Ver(1)^:=abVer3D(FVerEnd.FPosShow.x+GSmeX,FVerEnd.FPosShow.y+GSmeY,FVerEnd.FPosShow.z,1,1,FColorEnd.IpDWORD);
    FGraph.VerClose;
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
	bp.Par_Add('PointStart',IntToStr(FVerStart.FNo));
	bp.Par_Add('PointEnd',IntToStr(FVerEnd.FNo));
end;

procedure TLineAB.Load(bp:TBlockParEC);
var
	tstr,tstr2:WideString;
    i,cnt:integer;
begin
	FVerStart:=Point_ByNo(StrToIntEC(bp.Par['PointStart']));
	FVerEnd:=Point_ByNo(StrToIntEC(bp.Par['PointEnd']));

    FColorStart.Load(bp.Par['DiffuseStart']);
    FColorEnd.Load(bp.Par['DiffuseEnd']);

	if bp.Par_Count('Type')>=1 then begin
		tstr:=bp.Par['Type'];
    	cnt:=GetCountParEC(tstr,',');
        for i:=0 to cnt-1 do begin
			tstr2:=LowerCaseEx(TrimEx(GetStrParEC(tstr,i,',')));
            if tstr2='hide' then begin
				FShow:=false;
            end else if tstr2='stop' then begin
				FStopLine:=true;
            end;
        end;
    end;
end;

procedure TLineAB.SaveWorld(bd:TBufEC);
begin
	bd.AddInteger(FVerStart.FNo);
	bd.AddInteger(FVerEnd.FNo);

    bd.Add(FColorStart.Save);
    bd.Add(FColorEnd.Save);

    bd.AddBoolean(FShow);
    bd.AddBoolean(FStopLine);

	bd.AddInteger(TabWorldUnit(FOwner).FNo);
end;

procedure TLineAB.LoadWorld(bd:TBufEC);
begin
	FVerStart:=Point_List[bd.GetInteger];//Point_ByNo(bd.GetInteger);
	FVerEnd:=Point_List[bd.GetInteger];//Point_ByNo(bd.GetInteger);

    FColorStart.Load(bd.GetWideStr);
    FColorEnd.Load(bd.GetWideStr);

    FShow:=bd.GetBoolean;
    FStopLine:=bd.GetBoolean;

    FOwner:=WorldUnit_ByNo(bd.GetInteger);
end;

procedure TLineAB.SaveEnd(bd,tempbuf:TBufEC);
begin
{	if FVerStart.FNo<0 then bd.AddInteger(FVerStart.FParent.FNo)
	else }bd.AddInteger(FVerStart.FNo);

{	if FVerEnd.FNo<0 then bd.AddInteger(FVerEnd.FParent.FNo)
    else }bd.AddInteger(FVerEnd.FNo);

    bd.AddBoolean(FShow);
    bd.AddBoolean(FStopLine);

    if FShow then begin
		bd.AddInteger(SE_ColorKeyGetOrAdd(FColorStart,tempbuf));
		bd.AddInteger(SE_ColorKeyGetOrAdd(FColorEnd,tempbuf));
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Line_Clear;
begin
	while Line_First<>nil do Line_Delete(Line_Last);
end;

function Line_Add(gl:TKeyGroupList):TLineAB;
var
    el:TLineAB;
begin
    el:=TLineAB.Create(gl);

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

procedure Line_Load(bp:TBlockParEC; owner:TObject; gl:TKeyGroupList);
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

        el:=Line_Add(gl);
        el.FOwner:=owner;
        el.Load(tbp.Block_Get(i));
    end;
end;

procedure Line_SaveWorld(bd:TBufEC);
var
	el:TLineAB;
begin
	bd.AddInteger(Line_Count);

    el:=Line_First;
    while el<>nil do begin
    	bd.AddInteger(el.FColorStart.FGroupList.FNo);
    	el.SaveWorld(bd);
    	el:=el.FNext;
    end;
end;

procedure Line_LoadWorld(bd:TBufEC);
var
	el:TLineAB;
    i,cnt:integer;
begin
	Line_Clear;

	cnt:=bd.GetInteger;

    for i:=0 to cnt-1 do begin
    	el:=Line_Add(KeyGroupList_ByNom(bd.GetInteger));
        el.LoadWorld(bd);
    end;
end;

procedure Line_SaveEnd(bd,tempbuf:TBufEC);
var
	el:TLineAB;
begin
	bd.AddInteger(Line_Count);

    el:=Line_First;
    while el<>nil do begin
    	el.SaveEnd(bd,tempbuf);
    	el:=el.FNext;
    end;
end;

end.
