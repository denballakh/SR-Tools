unit WorldLine;

interface

uses Windows,Global,ab_Obj3D;

type
TabWorldLine = class(TObject)
	public
	    FPrev:TabWorldLine;
    	FNext:TabWorldLine;

	    FStart:TDxyz;
    	FEnd:TDxyz;

        FFrontColor:DWORD;
        FBackColor:DWORD;

//        FGraph:TabObj3D;

        FPointStart:integer;
        FPointEnd:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure UpdateGraph;
end;

procedure WorldLine_Clear;
function WorldLine_Add:TabWorldLine;
procedure WorldLine_Delete(el:TabWorldLine);
procedure WorldLine_UpdateGraph;

var
	WorldLine_First:TabWorldLine=nil;
	WorldLine_Last:TabWorldLine=nil;
    WorldLine_Grap:TabObj3D=nil;
    WorldLine_Rebuild:boolean=true;

implementation

uses VOper,Form_Main,GR_DirectX3D8;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TabWorldLine.Create;
begin
	inherited Create;

    FFrontColor:=$ffffffff;
	FBackColor:=$80ffffff;

	FPointStart:=-1;
    FPointEnd:=-1;

    WorldLine_Rebuild:=true;
end;

destructor TabWorldLine.Destroy;
begin
	Clear;
	inherited Destroy;
end;

procedure TabWorldLine.Clear;
begin
//	if FGraph<>nil then begin ab_Obj3D_Delete(FGraph); FGraph:=nil; end;
end;

procedure TabWorldLine.UpdateGraph;
var
    v1,v2:TDxyz;
//    lb:boolean;
begin
{	if FGraph=nil then begin
	    FGraph:=ab_Obj3D_Add;
    	FGraph.VerCount:=2;
	    FGraph.UnitAddLine(0,1);
    end else begin
    end;}
    if (FPointStart<0) or (FPointEnd<0) then Exit;

	v1:=D3D_TransformVector(ab_Camera_MatEnd,FStart);
    v2:=D3D_TransformVector(ab_Camera_MatEnd,FEnd);

//	lb:=(not ab_InTop(v1.z)) or (not ab_InTop(v2.z));

    WorldLine_Grap.VerOpen;
    if ab_InTop(v1.z) then begin
	    WorldLine_Grap.Ver(FPointStart)^:=abVer3D(v1.x+GSmeX,v1.y+GSmeY,v1.z,0,0,FFrontColor);
    end else begin
	    WorldLine_Grap.Ver(FPointStart)^:=abVer3D(v1.x+GSmeX,v1.y+GSmeY,v1.z,0,0,FBackColor);
    end;
    if ab_InTop(v2.z) then begin
    	WorldLine_Grap.Ver(FPointEnd)^:=abVer3D(v2.x+GSmeX,v2.y+GSmeY,v2.z,1,1,FFrontColor);
    end else begin
    	WorldLine_Grap.Ver(FPointEnd)^:=abVer3D(v2.x+GSmeX,v2.y+GSmeY,v2.z,1,1,FBackColor);
    end;
    WorldLine_Grap.VerClose;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure WorldLine_Clear;
begin
	while WorldLine_First<>nil do WorldLine_Delete(WorldLine_Last);

	if WorldLine_Grap<>nil then begin ab_Obj3D_Delete(WorldLine_Grap); WorldLine_Grap:=nil; end;
end;

function WorldLine_Add:TabWorldLine;
var
    el:TabWorldLine;
begin
    el:=TabWorldLine.Create;

    if WorldLine_Last<>nil then WorldLine_Last.FNext:=el;
	el.FPrev:=WorldLine_Last;
	el.FNext:=nil;
	WorldLine_Last:=el;
	if WorldLine_First=nil then WorldLine_First:=el;

    Result:=el;
end;

procedure WorldLine_Delete(el:TabWorldLine);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if WorldLine_Last=el then WorldLine_Last:=el.FPrev;
	if WorldLine_First=el then WorldLine_First:=el.FNext;

    el.Free;
end;

procedure WorldLine_UpdateGraph;
var
    el:TabWorldLine;
    cnt:integer;
    ul:PabObj3Dunit;
begin
	if WorldLine_First=nil then begin
    	if WorldLine_Grap<>nil then begin ab_Obj3D_Delete(WorldLine_Grap); WorldLine_Grap:=nil; end;
    	Exit;
    end;

	if WorldLine_Grap=nil then begin
	    WorldLine_Grap:=ab_Obj3D_Add;
        WorldLine_Rebuild:=true;
    end;

    if WorldLine_Rebuild then begin
    	WorldLine_Grap.UnitClear;
        WorldLine_Grap.VerClear;
//	Result:=UnitAdd;

        cnt:=0;
		el:=WorldLine_First;
    	while el<>nil do begin
        	el.FPointStart:=cnt*2;
        	el.FPointEnd:=cnt*2+1;
//            WorldLine_Grap.UnitAddLine(el.FPointStart,el.FPointEnd);
        	inc(cnt);
        	el:=el.FNext;
        end;

        ul:=WorldLine_Grap.UnitAdd;
        SetLength(ul.FVer,cnt*2);
    	ul.FType:=D3DPT_LINELIST;
	    ul.FVerCnt:=cnt*2;
    	ul.FCnt:=cnt;
	    WorldLine_Grap.FIndexRebuild:=true;

		el:=WorldLine_First;
    	while el<>nil do begin
	        ul.FVer[el.FPointStart]:=el.FPointStart;
		    ul.FVer[el.FPointEnd]:=el.FPointEnd;

        	el:=el.FNext;
        end;

        WorldLine_Grap.VerCount:=cnt*2;

    	WorldLine_Rebuild:=false;
    end;

    WorldLine_Grap.VerOpen;
	el:=WorldLine_First;
    while el<>nil do begin
    	el.UpdateGraph;
    	el:=el.FNext;
    end;
    WorldLine_Grap.VerClose;
end;

end.
