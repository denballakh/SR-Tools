unit ABOpt;

interface

uses Windows,SysUtils,Classes,ABPoint,ABTriangle,WorldUnit,DebugMsg,EC_Buf,GR_DirectX3D8;

type
PabOptGroup = ^TabOptGroup;
TabOptGroup = record
    FPoint:array of TPointAB;
    FPolygon:array of TTriangleAB;
    FBB0:D3DVECTOR;
    FBB1:D3DVECTOR;
    FBB2:D3DVECTOR;
    FBB3:D3DVECTOR;
    FOwner:TabWorldUnit;
end;

PabOptUnit = ^TabOptUnit;
TabOptUnit = record
	FPoint:array of TPointAB;
    FGroup:array of integer;
//    FPolygon:array of TTriangleAB;
//    FUpdateRect:array of TPointAB;
end;

var
ab_OptGroup:array of TabOptGroup;
ab_Opt:array of TabOptUnit;
ab_Opt_OrbCnt:integer;
ab_Opt_OrbAngleCnt:integer;
ab_Opt_Cur:PabOptUnit;

procedure ab_OptClear;
function ab_OptBuild:integer;
procedure ab_OptSaveEnd(bd:TBufEC);
procedure ab_OptCur;

implementation

uses Global,Form_Main,WorldZone,VOper;

procedure ab_OptClear;
var
	i:integer;
begin
	for i:=0 to High(ab_Opt) do begin
    	ab_Opt[i].FPoint:=nil;
    	ab_Opt[i].FGroup:=nil;
//    	ab_Opt[i].FPolygon:=nil;
//    	ab_Opt[i].FUpdateRect:=nil;
    end;
    for i:=0 to High(ab_OptGroup) do begin
	    ab_OptGroup[i].FPoint:=nil;
    	ab_OptGroup[i].FPolygon:=nil;
    end;
    ab_Opt:=nil;
    ab_OptGroup:=nil;
    ab_Opt_Cur:=nil;
end;

function ab_OptBuild:integer;
var
	step,cnt,cntp,i,u,t,k,maxcntpoint,maxcntpolygon,cntgroup:integer;
    orb,orbangle:integer;
	sp,sp2:TPointAB;
    pol:TTriangleAB;
    optsize:integer;
    wu:TabWorldUnit;
    cg:PabOptGroup;

	function Zone_Exclude(orb,orbangle:single):boolean;
    var
    	zone:TabZone;
        r_ang,r_dist:single;
    begin
    	zone:=Zone_First;
        while zone<>nil do begin
			if (zone.FType=10) then begin
            	ab_CalcAngleAndDist(zone.FOrb,zone.FOrbAngle,0,orb,orbangle,ab_WorldRadius,r_ang,r_dist);
            	if r_dist<zone.FRadius then begin Result:=true; Exit; end;
            end;

        	zone:=zone.FNext;
        end;
        Result:=false;
    end;
begin
	step:=5;

    cntgroup:=0;
    wu:=WorldUnit_First;
    while wu<>nil do begin
	    wu.BBBuild;
        if wu.FBBState=1 then begin
	        inc(cntgroup);
        end;
		wu:=wu.FNext;
    end;

	ab_Camera_Radius:=ab_WorldRadius+ab_Camera_RadiusDefaultFW;

    maxcntpoint:=Point_CntUnion;
    maxcntpolygon:=Triangle_Count;

	ab_Opt_OrbCnt:=(360 div step);
	ab_Opt_OrbAngleCnt:=(180 div step)+1;

    optsize:=0;

    ab_OptClear;
    SetLength(ab_Opt,ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt);

    optsize:=optsize+ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt*sizeof(TabOptUnit);

    ab_CalcZPos;

    sp:=Point_First;
    while sp<>nil do begin
    	sp.FTemp:=0;
    	sp:=sp.FNext;
    end;

    SetLength(ab_OptGroup,cntgroup);
    i:=0;
    wu:=WorldUnit_First;
    while wu<>nil do begin
        if wu.FBBState=1 then begin
	        ab_OptGroup[i].FOwner:=wu;

        	SetLength(ab_OptGroup[i].FPolygon,maxcntpolygon);

            u:=0;
            pol:=Triangle_First;
            while pol<>nil do begin
            	if pol.FOwner=wu then begin
					ab_OptGroup[i].FPolygon[u]:=pol;
                	inc(u);
                end;
            	pol:=pol.FNext;
            end;

            SetLength(ab_OptGroup[i].FPolygon,u);

			ab_OptGroup[i].FBB0:=wu.FBB[0].FPos;
			ab_OptGroup[i].FBB1:=wu.FBB[1].FPos;
			ab_OptGroup[i].FBB2:=wu.FBB[2].FPos;
			ab_OptGroup[i].FBB3:=wu.FBB[3].FPos;

		    optsize:=optsize+u*4+4*3*4;

            SetLength(ab_OptGroup[i].FPoint,maxcntpoint);
            u:=0;
			sp:=Point_First;
            while sp<>nil do begin
            	if sp.FOwner.IndexOf(wu)>=0 then begin
					sp2:=sp; if sp2.FParent<>nil then sp2:=sp2.FParent;
                    ab_OptGroup[i].FPoint[u]:=sp2;
                    sp2.FTemp:=1;
                	inc(u);
                end;
                sp:=sp.FNext;
            end;
            SetLength(ab_OptGroup[i].FPoint,u);

            inc(i);
        end;
		wu:=wu.FNext;
    end;

    i:=0;
    orb:=0;
    while orb<360 do begin
    	orbangle:=0;
        while orbangle<=(180+0.001) do begin
        	ab_Opt_Cur:=@(ab_Opt[i]);

	        if Zone_Exclude(orb,orbangle) then begin
        	    ab_Opt_Cur.FPoint:=nil;
//    	        ab_Opt_Cur.FPolygon:=nil;
//	            ab_Opt_Cur.FUpdateRect:=nil;

            end else begin

				ab_Camera_Pos.FOrbit:=orb;
    	        ab_Camera_Pos.FOrbitAngle:=orbangle;
        	    ab_Camera_Pos.FAngle:=0;
            	FormMain.UpdateMatrix;

	            SetLength(ab_Opt_Cur.FPoint,maxcntpoint);
    	        SetLength(ab_Opt_Cur.FGroup,cntgroup);

				cnt:=0;
                cntp:=0;
				for u:=0 to cntgroup-1 do begin
	                cg:=@(ab_OptGroup[u]);

					if ab_InTop(D3D_TransformVector(ab_Camera_MatEnd,cg.FBB0).z) and
	                   ab_InTop(D3D_TransformVector(ab_Camera_MatEnd,cg.FBB1).z) and
	                   ab_InTop(D3D_TransformVector(ab_Camera_MatEnd,cg.FBB2).z) and
	                   ab_InTop(D3D_TransformVector(ab_Camera_MatEnd,cg.FBB3).z) then
                    begin
	                    ab_Opt_Cur.FGroup[cnt]:=u;

//			       	    sp:=Point_First;
//            			while sp<>nil do begin
//                        	if sp.FOwner.IndexOf(cg.FOwner)>=0 then begin
						for k:=0 to High(cg.FPoint) do begin
                        	sp:=cg.FPoint[k];
                            	sp2:=sp; if sp2.FParent<>nil then sp2:=sp2.FParent;
                            	t:=0;
                            	while t<u do begin
                                	if ab_Opt_Cur.FPoint[t]=sp2 then break;
                                	inc(t);
                                end;
                                if t>=u then begin
	                                ab_Opt_Cur.FPoint[cntp]:=sp2;
                                	inc(cntp);
                                end;
                        end;
//                            end;
//                        	sp:=sp.FNext;
//                        end;

                    	inc(cnt);
                    end;

                end;
	            SetLength(ab_Opt_Cur.FPoint,cntp);
    	        SetLength(ab_Opt_Cur.FGroup,cnt);
    	        optsize:=optsize+cnt*4+cntp*4;
			end;

			inc(i);
	        orbangle:=orbangle+step;
        end;
    	orb:=orb+step;
    end;

    ab_Opt_Cur:=nil;

    Result:=optsize;
end;

(*function ab_OptBuild:integer;
var
	step,cnt,i,maxcntpoint,maxcntpolygon,maxcntupdate:integer;
    orb,orbangle:integer;
	sp:TPointAB;
    pol:TTriangleAB;
    optsize:integer;
    wu:TabWorldUnit;

    u_l,u_r,u_u,u_d:TPointAB;

    function FindPointUpdate(own:TabWorldUnit):boolean;
    var
    	i,u,cntu:integer;
	begin
	    u_l:=nil; u_r:=nil; u_u:=nil; u_d:=nil;

//    	pol:=ab_Polygon_First;
//        while pol<>nil do begin
//        	if (pol.FOwner=noo) and (pol.FPoint[0].FPoint.FScreenInTop) and (pol.FPoint[1].FPoint.FScreenInTop) and (pol.FPoint[2].FPoint.FScreenInTop) then begin
		cntu:=High(ab_Opt_Cur.FPolygon)+1;
		for u:=0 to cntu-1 do begin
        	pol:=ab_Opt_Cur.FPolygon[u];
            if pol.FOwner=own then begin
            	if u_l=nil then begin
				    u_l:=pol.FV[0].FVer.BP; u_r:=u_l; u_u:=u_l; u_d:=u_l;
                end else begin
	            	for i:=0 to 2 do begin
    	            	sp:=pol.FV[i].FVer.BP;

                        if sp.FPosShow.x<u_l.FPosShow.x then u_l:=sp
                        else if sp.FPosShow.x>u_r.FPosShow.x then u_r:=sp;

                        if sp.FPosShow.y<u_u.FPosShow.y then u_u:=sp
                        else if sp.FPosShow.y>u_d.FPosShow.y then u_d:=sp;
                    end;
                end;
            end;
        end;
//        	pol:=pol.FNext;
  //      end;
        Result:=(u_l<>u_r) and (u_u<>u_d);
    end;
	function Zone_Exclude(orb,orbangle:single):boolean;
    var
    	zone:TabZone;
        r_ang,r_dist:single;
    begin
    	zone:=Zone_First;
        while zone<>nil do begin
			if (zone.FType=10) then begin
            	ab_CalcAngleAndDist(zone.FOrb,zone.FOrbAngle,0,orb,orbangle,ab_WorldRadius,r_ang,r_dist);
            	if r_dist<zone.FRadius then begin Result:=true; Exit; end;
            end;

        	zone:=zone.FNext;
        end;
        Result:=false;
    end;
begin
	step:=5;

	ab_Camera_Radius:=ab_WorldRadius+ab_Camera_RadiusDefaultFW;

    maxcntpoint:=Point_CntUnion;
    maxcntpolygon:=Triangle_Count;
    maxcntupdate:=WorldUnit_Cnt;

	ab_Opt_OrbCnt:=(360 div step);
	ab_Opt_OrbAngleCnt:=(180 div step)+1;

    optsize:=0;

    ab_OptClear;
    SetLength(ab_Opt,ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt);

    optsize:=optsize+ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt*sizeof(TabOptUnit);

    ab_CalcZPos;

    i:=0;
    orb:=0;
    while orb<360 do begin
    	orbangle:=0;
        while orbangle<=(180+0.001) do begin
        	ab_Opt_Cur:=@(ab_Opt[i]);

	        if Zone_Exclude(orb,orbangle) then begin
        	    ab_Opt_Cur.FPoint:=nil;
    	        ab_Opt_Cur.FPolygon:=nil;
	            ab_Opt_Cur.FUpdateRect:=nil;

            end else begin

				ab_Camera_Pos.FOrbit:=orb;
    	        ab_Camera_Pos.FOrbitAngle:=orbangle;
        	    ab_Camera_Pos.FAngle:=0;
            	FormMain.UpdateMatrix;

	            SetLength(ab_Opt_Cur.FPoint,maxcntpoint);
    	        SetLength(ab_Opt_Cur.FPolygon,maxcntpolygon);
        	    SetLength(ab_Opt_Cur.FUpdateRect,maxcntupdate*4);

//	            ab_StopPoint_CalcScreen;
				cnt:=0;
        	    sp:=Point_First;
            	while sp<>nil do begin
            		if sp.FParent=nil then begin
	    	        	sp.CalcPosShow;
		   	            sp.FPosShowInTop:=ab_InTop(sp.FPosShow.z);
        		        if sp.FPosShowInTop then begin
	        	   	        ab_Opt_Cur.FPoint[cnt]:=sp;
                			inc(cnt);
		                end;
    	            end;
        	    	sp:=sp.FNext;
            	end;
//DM('ABWorld',Format('Point cnt=%d',[cnt]));
	            SetLength(ab_Opt_Cur.FPoint,cnt);
    	        optsize:=optsize+cnt*4;

	            cnt:=0;
    	        pol:=Triangle_First;
        	    while pol<>nil do begin
            		if (pol.FV[0].FVer.BP.FPosShowInTop) and (pol.FV[1].FVer.BP.FPosShowInTop) and (pol.FV[2].FVer.BP.FPosShowInTop) then begin
	            	    ab_Opt_Cur.FPolygon[cnt]:=pol;
                		inc(cnt);
	                end;
    	        	pol:=pol.FNext;
        	    end;
//DM('ABWorld',Format('Triangle cnt=%d',[cnt]));
	            SetLength(ab_Opt_Cur.FPolygon,cnt);
    	        optsize:=optsize+cnt*4;

	            cnt:=0;
    	        wu:=WorldUnit_First;
        	    while wu<>nil do begin
	        	    if FindPointUpdate(wu) then begin
	            	    ab_Opt_Cur.FUpdateRect[cnt*4+0]:=u_l;
		                ab_Opt_Cur.FUpdateRect[cnt*4+1]:=u_u;
		                ab_Opt_Cur.FUpdateRect[cnt*4+2]:=u_r;
	    	            ab_Opt_Cur.FUpdateRect[cnt*4+3]:=u_d;
            	    	inc(cnt);
	                end;
    	            wu:=wu.FNext;
        	    end;
//DM('AB',Format('UpdateRect cnt=%d',[cnt]));
//DM('ABWorld',Format('Update cnt=%d',[cnt]));
	            SetLength(ab_Opt_Cur.FUpdateRect,cnt*4);
    	        optsize:=optsize+cnt*4*4;
			end;

			inc(i);
	        orbangle:=orbangle+step;
        end;
    	orb:=orb+step;
    end;

    ab_Opt_Cur:=nil;

    Result:=optsize;
end;*)

procedure ab_OptSaveEnd(bd:TBufEC);
var
	i,u,cnt:integer;
    buf:Pointer;
    cg:PabOptGroup;
begin
	bd.m_Add:=512*1024;
	bd.AddInteger(ab_Opt_OrbCnt);
	bd.AddInteger(ab_Opt_OrbAngleCnt);
    bd.AddInteger(High(ab_OptGroup)+1);

    for i:=0 to High(ab_OptGroup) do begin
    	cg:=@(ab_OptGroup[i]);

        bd.AddWORD(High(cg.FPolygon)+1);
        for u:=0 to High(cg.FPolygon) do begin
        	bd.AddWORD(cg.FPolygon[u].FNo);
        end;

    	bd.AddSingle(cg.FBB0.x); bd.AddSingle(cg.FBB0.y); bd.AddSingle(cg.FBB0.z);
    	bd.AddSingle(cg.FBB1.x); bd.AddSingle(cg.FBB1.y); bd.AddSingle(cg.FBB1.z);
    	bd.AddSingle(cg.FBB2.x); bd.AddSingle(cg.FBB2.y); bd.AddSingle(cg.FBB2.z);
    	bd.AddSingle(cg.FBB3.x); bd.AddSingle(cg.FBB3.y); bd.AddSingle(cg.FBB3.z);
    end;

    for i:=0 to ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt-1 do begin
		ab_Opt_Cur:=@(ab_Opt[i]);

        cnt:=High(ab_Opt_Cur.FPoint)+1;
        bd.AddWORD(cnt);
        bd.Len:=bd.Len+cnt*2;
        buf:=Ptr(DWORD(bd.Buf)+DWORD(bd.BPointer));
        bd.BPointer:=bd.Len;
        for u:=0 to cnt-1 do begin
//        	bd.AddWORD(ab_Opt_Cur.FPoint[u].FNo);
			PWORD(buf)^:=ab_Opt_Cur.FPoint[u].FNo;
			buf:=Ptr(DWORD(buf)+2);
        end;

        cnt:=High(ab_Opt_Cur.FGroup)+1;
        bd.AddWORD(cnt);
        bd.Len:=bd.Len+cnt*2;
        buf:=Ptr(DWORD(bd.Buf)+DWORD(bd.BPointer));
        bd.BPointer:=bd.Len;
        for u:=0 to cnt-1 do begin
//        	bd.AddWORD(ab_Opt_Cur.FPoint[u].FNo);
			PWORD(buf)^:=ab_Opt_Cur.FGroup[u];
			buf:=Ptr(DWORD(buf)+2);
        end;

    end;
end;

{procedure ab_OptSaveEnd(bd:TBufEC);
var
	i,u,cnt:integer;
    buf:Pointer;
begin
	bd.m_Add:=512*1024;
	bd.AddInteger(ab_Opt_OrbCnt);
	bd.AddInteger(ab_Opt_OrbAngleCnt);

    for i:=0 to ab_Opt_OrbCnt*ab_Opt_OrbAngleCnt-1 do begin
		ab_Opt_Cur:=@(ab_Opt[i]);

        cnt:=High(ab_Opt_Cur.FPoint)+1;
        bd.AddWORD(cnt);
        bd.Len:=bd.Len+cnt*2;
        buf:=Ptr(DWORD(bd.Buf)+DWORD(bd.BPointer));
        bd.BPointer:=bd.Len;
        for u:=0 to cnt-1 do begin
//        	bd.AddWORD(ab_Opt_Cur.FPoint[u].FNo);
			PWORD(buf)^:=ab_Opt_Cur.FPoint[u].FNo;
			buf:=Ptr(DWORD(buf)+2);
        end;

        cnt:=High(ab_Opt_Cur.FPolygon)+1;
        bd.AddWORD(cnt);
        bd.Len:=bd.Len+cnt*2;
        buf:=Ptr(DWORD(bd.Buf)+DWORD(bd.BPointer));
        bd.BPointer:=bd.Len;
        for u:=0 to cnt-1 do begin
//        	bd.AddWORD(ab_Opt_Cur.FPolygon[u].FNo);
			PWORD(buf)^:=ab_Opt_Cur.FPolygon[u].FNo;
			buf:=Ptr(DWORD(buf)+2);
        end;

        cnt:=(High(ab_Opt_Cur.FUpdateRect)+1) div 4;
        bd.AddWORD(cnt);
        bd.Len:=bd.Len+cnt*4*2;
        buf:=Ptr(DWORD(bd.Buf)+DWORD(bd.BPointer));
        bd.BPointer:=bd.Len;
        for u:=0 to cnt-1 do begin
//        	bd.AddWORD(ab_Opt_Cur.FUpdateRect[u*4+0].FNo);
//        	bd.AddWORD(ab_Opt_Cur.FUpdateRect[u*4+1].FNo);
//        	bd.AddWORD(ab_Opt_Cur.FUpdateRect[u*4+2].FNo);
//        	bd.AddWORD(ab_Opt_Cur.FUpdateRect[u*4+3].FNo);
			PWORD(buf)^:=ab_Opt_Cur.FUpdateRect[(u shl 2)+0].FNo; buf:=Ptr(DWORD(buf)+2);
			PWORD(buf)^:=ab_Opt_Cur.FUpdateRect[(u shl 2)+1].FNo; buf:=Ptr(DWORD(buf)+2);
			PWORD(buf)^:=ab_Opt_Cur.FUpdateRect[(u shl 2)+2].FNo; buf:=Ptr(DWORD(buf)+2);
			PWORD(buf)^:=ab_Opt_Cur.FUpdateRect[(u shl 2)+3].FNo; buf:=Ptr(DWORD(buf)+2);
        end;
    end;
end;}

procedure ab_OptCur;
var
	no,noa:integer;
begin
	no:=Round((ab_Camera_Pos.FOrbit/360)*ab_Opt_OrbCnt);
    if no>=ab_Opt_OrbCnt then no:=0;

	noa:=Round((ab_Camera_Pos.FOrbitAngle/180)*(ab_Opt_OrbAngleCnt-1));
    if noa>=ab_Opt_OrbAngleCnt then EError('ab_OptCur');// noa:=0;

    ab_Opt_Cur:=@(ab_Opt[no*ab_Opt_OrbAngleCnt+noa]);
end;

end.
