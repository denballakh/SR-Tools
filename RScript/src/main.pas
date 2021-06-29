unit main;

interface

uses Windows,GraphUnit,SysUtils,Graphics,Menus,Classes,ActiveX,
     EC_Str,EC_Buf,EC_BlockPar,forms,
     Form_Star,Form_StarLink,Form_StarShip,Form_Planet,Form_Group,Form_GroupLink,
     Form_State,Form_StateLink,Form_Place,Form_Item,Form_If,Form_Op,Form_Ether,Form_Var,
     Form_Dialog,Form_DialogMsg,Form_DialogAnswer,Form_Build;

procedure MainInit;
procedure MainSave(bd:TBufEC);
procedure MainLoad(bd:TBufEC);
procedure MainNew;
function CreateByName(tstr:WideString):TObject;
function MainCreateLink(pbegin:TGraphPoint; pend:TGraphPoint):TGraphLink;

//function GCA(a:DWORD; i:integer):boolean;
function CA(a:DWORD; i:integer):boolean; overload;
function CA(a:DWORD; i:integer; zn:boolean):DWORD; overload;
procedure SCA(var a:DWORD; i:integer; zn:boolean);
function CA1(a:DWORD; i:integer):DWORD;

function BuildRazd(tstr:WideString):WideString;
function MenuBuild(form:TForm; tstr:WideString; pum:TPopupMenu; selfun:TNotifyEvent):boolean;

procedure ReplaceColor(bm:TBitmap; oldcolor:TColor; newcolor:TColor);

function NewGUID:TGUID;
function GUIDToStr(zn:TGUID):WideString;

type
TFun=record
    FType:integer;
    FName:WideString;
    FResult:WideString;
    FArg:WideString;
    FDesc:WideString;
end;

var
{GFun:array[0..18] of TFun =( (FType:1;  FName:'EndState';         FResult:'boolean';      FArg:'';                            FDesc:'' ),
                             (FType:1;  FName:'GroupIn';          FResult:'boolean';      FArg:'<Group>,<Star,Planet,Place>'; FDesc:'' ),
                             (FType:1;  FName:'CountIn';          FResult:'int';          FArg:'<Group>,<Star,Planet,Place>'; FDesc:'' ),
                             (FType:1;  FName:'CountIn';          FResult:'int';          FArg:'<Group>';                     FDesc:'' ),
                             (FType:2;  FName:'ShipOut';          FResult:'';             FArg:'';                            FDesc:'' ),
                             (FType:3;  FName:'CurTurn';          FResult:'int';          FArg:'';                            FDesc:'' ),
                             (FType:2;  FName:'SetData';          FResult:'';             FArg:'dword';                       FDesc:'' ),
                             (FType:2;  FName:'SetData';          FResult:'';             FArg:'dword,int';                   FDesc:'' ),
                             (FType:3;  FName:'GetData';          FResult:'dword';        FArg:'';                            FDesc:'' ),
                             (FType:3;  FName:'GetData';          FResult:'dword';        FArg:'int';                         FDesc:'' ),
                             (FType:2;  FName:'EndDialog';        FResult:'';             FArg:'';                            FDesc:'' ),
                             (FType:2;  FName:'ShipJoin';         FResult:'';             FArg:'<Group>,Player()';            FDesc:'' ),
                             (FType:1;  FName:'ShipInScript';     FResult:'boolean';      FArg:'Player()';                    FDesc:'' ),
                             (FType:1;  FName:'ShipCntWeapon';    FResult:'int';          FArg:'Player()';                    FDesc:'' ),
                             (FType:1;  FName:'ShipCanJump';      FResult:'boolean';      FArg:'Player(),<Star>,<Star>';      FDesc:'' ),
                             (FType:1;  FName:'ShipInStar';       FResult:'boolean';      FArg:'Player(),<Star>';             FDesc:'' ),
                             (FType:1;  FName:'ShipInNormalSpace'; FResult:'boolean';     FArg:'Player()';                    FDesc:'' ),
                             (FType:2;  FName:'Dialog';           FResult:'';             FArg:'<Dialog>,<Planet>';           FDesc:'<Dialog>,[[<Group>],...[<Planet> or <Group>]]' ),
                             (FType:1;  FName:'Name';             FResult:'str';          FArg:'<Star,Planet>';               FDesc:'' )
                            );}
GFun:array of TFun;

GScriptName:WideString;
GScriptFileOut:WideString;
GScriptFileTextOut:TBlockParEC;
GScriptTranslate:TBlockParEC;
GScriptTranslateId:TBlockParEC;

implementation

uses Form_Main;

procedure MainInit;
var
    bm:TBitmap;
    bp:TBlockParEC;
    i,cnt:integer;
    tstr:WideString;
begin
    if GScriptTranslate<>nil then begin GScriptTranslate.Free; GScriptTranslate:=nil; end;
    GScriptTranslate:=TBlockParEC.Create;

    if GScriptTranslateId<>nil then begin GScriptTranslateId.Free; GScriptTranslateId:=nil; end;
    GScriptTranslateId:=TBlockParEC.Create;

    if GScriptFileTextOut<>nil then begin GScriptFileTextOut.Free; GScriptFileTextOut:=nil; end;
    GScriptFileTextOut:=TBlockParEC.Create(false);
    GScriptFileTextOut.Par_Add('rus','');

    bp:=FCfg.Block['Function'];
    cnt:=bp.Par_Count();
    SetLength(GFun,cnt);
    for i:=0 to cnt-1 do begin
        GFun[i].FType:=StrToIntEC(bp.Par_GetName(i));
        tstr:=bp.Par_Get(i);
        if GetCountParEC(tstr,'~')<>4 then raise Exception.Create('Load function error. Nom='+IntToStr(i));
        GFun[i].FResult:=TrimEx(GetStrParEC(tstr,0,'~'));
        GFun[i].FName:=TrimEx(GetStrParEC(tstr,1,'~'));
        GFun[i].FArg:=TrimEx(GetStrParEC(tstr,2,'~'));
        GFun[i].FDesc:=TrimEx(GetStrParEC(tstr,3,'~'));
    end;

    AddActionMenu('Build',BuildRun);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Star.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Star',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Planet.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Planet',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Ruins.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Ruins',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Place.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Place',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Group.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Group',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Ship.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Ship',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Player.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Player',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Item.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Item',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\State.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('State',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\if.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('if',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\op.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('op',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\ether.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Ether',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\var.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Var',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\Dialog.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('Dialog',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\DialogMsg.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('DialogMsg',bm);

    bm:=TBitmap.Create;
    bm.LoadFromFile(GSysWorkDir+'\Image\DialogAnswer.bmp');
    ReplaceColor(bm,bm.Canvas.Pixels[0,0],ColorBG);
    bm.Transparent:=true;
    ImageAdd('DialogAnswer',bm);

    GGraphPointInterface.Add(TStarInterface.Create);
    GGraphPointInterface.Add(TPlanetInterface.Create);
    GGraphPointInterface.Add(TStarShipInterface.Create);
    GGraphPointInterface.Add(TItemInterface.Create);
    GGraphPointInterface.Add(TPlaceInterface.Create);
    GGraphPointInterface.Add(TGroupInterface.Create);
    GGraphPointInterface.Add(TStateInterface.Create);
    GGraphPointInterface.Add(TifInterface.Create);
    GGraphPointInterface.Add(TopInterface.Create);
    GGraphPointInterface.Add(TEtherInterface.Create);
    GGraphPointInterface.Add(TvarInterface.Create);
    GGraphPointInterface.Add(TDialogInterface.Create);
    GGraphPointInterface.Add(TDialogMsgInterface.Create);
    GGraphPointInterface.Add(TDialogAnswerInterface.Create);
end;

function CreateByName(tstr:WideString):TObject;
begin
    tstr:=LowerCase(tstr);
    if tstr='tgraphpoint' then Result:=TGraphPoint.Create
    else if tstr='tgraphlink' then Result:=TGraphLink.Create
    else if tstr='tgraphrecttext' then Result:=TGraphRectText.Create
    else if tstr='tstar' then Result:=TStar.Create
    else if tstr='tstarlink' then Result:=TStarLink.Create
    else if tstr='tstarship' then Result:=TStarShip.Create
    else if tstr='tplanet' then Result:=TPlanet.Create
    else if tstr='tgroup' then Result:=TGroup.Create
    else if tstr='tgrouplink' then Result:=TGroupLink.Create
    else if tstr='tstate' then Result:=TState.Create
    else if tstr='tstatelink' then Result:=TStateLink.Create
    else if tstr='tplace' then Result:=TPlace.Create
    else if tstr='titem' then Result:=TItem.Create
    else if tstr='tif' then Result:=Tif.Create
    else if tstr='top' then Result:=Top.Create
    else if tstr='tether' then Result:=TEther.Create
    else if tstr='tvar' then Result:=Tvar.Create
    else if tstr='tdialog' then Result:=TDialog.Create
    else if tstr='tdialogmsg' then Result:=TDialogMsg.Create
    else if tstr='tdialoganswer' then Result:=TDialogAnswer.Create
    else raise Exception.Create('Unknown type : '+tstr);
end;

procedure MainSave(bd:TBufEC);
begin
    bd.Add(GScriptName);
    bd.Add(GScriptFileOut);
//    bd.Add(GScriptFileTextOut);
    GScriptFileTextOut.Save(bd);
    GScriptTranslate.Save(bd);
    GScriptTranslateId.Save(bd);
end;

procedure MainLoad(bd:TBufEC);
begin
    GScriptFileTextOut.Clear;
    GScriptTranslate.Clear;
    GScriptTranslateId.Clear;

    GScriptName:=bd.GetWideStr;
    GScriptFileOut:=bd.GetWideStr;
    if GFileVersion<$05 then begin
        GScriptFileTextOut.Par_Add('rus',bd.GetWideStr);
    end else begin
        GScriptFileTextOut.Load(bd);
    end;
    if GFileVersion>=$05 then begin
        GScriptTranslate.Load(bd);
        GScriptTranslateId.Load(bd);
    end;
end;

procedure MainNew;
begin
    GScriptName:='';
    GScriptFileOut:='';

    if GScriptFileTextOut<>nil then begin GScriptFileTextOut.Free; GScriptFileTextOut:=nil; end;
    GScriptFileTextOut:=TBlockParEC.Create(false);
    GScriptFileTextOut.Par_Add('rus','');

    if GScriptTranslate<>nil then begin GScriptTranslate.Free; GScriptTranslate:=nil; end;
    GScriptTranslate:=TBlockParEC.Create;

    if GScriptTranslateId<>nil then begin GScriptTranslateId.Free; GScriptTranslateId:=nil; end;
    GScriptTranslateId:=TBlockParEC.Create;
end;

function ifFindLoop(pfrom:TGraphPoint; pto:TGraphPoint):boolean;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=pfrom) and (gl.FEnd is Tif) then begin
            if gl.FEnd=pto then begin Result:=true; Exit; end;
            Result:=ifFindLoop(gl.FEnd,pto);
            if Result then Exit;
        end;
    end;
    Result:=false;
end;

function opFindLoop(pfrom:TGraphPoint; pto:TGraphPoint):boolean;
var
    i:integer;
    gl:TGraphLink;
begin
    for i:=0 to GGraphLink.Count-1 do begin
        gl:=GGraphLink.Items[i];
        if (gl.FBegin=pfrom) and (gl.FEnd is Top) then begin
            if gl.FEnd=pto then begin Result:=true; Exit; end;
            Result:=opFindLoop(gl.FEnd,pto);
            if Result then Exit;
        end;
    end;
    Result:=false;
end;

function MainCreateLink(pbegin:TGraphPoint; pend:TGraphPoint):TGraphLink;
begin
    Result:=nil;
    if (pbegin is TStar) and (pend is TStar) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            Result:=TStarLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Exit;
        end;
    end else if ((pbegin is TStar) and (pend is TStarShip)) or ((pbegin is TStarShip) and (pend is TStar)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            if pbegin is TStarShip then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TStar) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TStar)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TPlanet then Result:=FindLinkFull(pbegin,'TStar')
            else Result:=FindLinkFull(pend,'TStar');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TPlanet then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
{    end else if ((pbegin is TStar) and (pend is TRuins)) or ((pbegin is TRuins) and (pend is TStar)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TRuins then Result:=FindLinkFull(pbegin,'TStar')
            else Result:=FindLinkFull(pend,'TStar');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TRuins then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;}
    end else if ((pbegin is TGroup) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TGroup)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TGroup then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TGroup then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TGroup) and (pend is TGroup) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGroupLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TGroup) and (pend is TState)) or ((pbegin is TState) and (pend is TGroup)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TGroup then Result:=FindLinkFull(pbegin,'TState')
            else Result:=FindLinkFull(pend,'TState');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TGroup then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TItem) and (pend is TPlace)) or ((pbegin is TPlace) and (pend is TItem)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TItem) and (pend is TGroup)) or ((pbegin is TGroup) and (pend is TItem)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TItem) and (pend is TPlanet)) or ((pbegin is TPlanet) and (pend is TItem)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlanet')
            else Result:=FindLinkFull(pend,'TPlanet');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TGroup')
            else Result:=FindLinkFull(pend,'TGroup');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            if pbegin is TItem then Result:=FindLinkFull(pbegin,'TPlace')
            else Result:=FindLinkFull(pend,'TPlace');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TItem then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if ((pbegin is TPlace) and (pend is TStar)) or ((pbegin is TStar) and (pend is TPlace)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
            if pbegin is TPlace then Result:=FindLinkFull(pbegin,'TStar')
            else Result:=FindLinkFull(pend,'TStar');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            if pbegin is TPlace then begin
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
            end else begin
                Result.FBegin:=pend;
                Result.FEnd:=pbegin;
            end;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tif) and (pend is Tif) then begin
        if FindLink(pbegin,pend)=nil then begin
            if not ifFindLoop(pend,pbegin) then begin
                Result:=TGraphLink.Create;
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
                Result.FArrow:=true;
                Exit;
            end;
        end;
    end else if (pbegin is TState) and (pend is Tif) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tif) and (pend is TState) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=FindLinkBegin(pbegin,'TState');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Top) and (pend is Top) then begin
        if FindLink(pbegin,pend)=nil then begin
            if not opFindLoop(pend,pbegin) then begin
                Result:=TGraphLink.Create;
                Result.FBegin:=pbegin;
                Result.FEnd:=pend;
                Result.FArrow:=true;
                Exit;
            end;
        end;
    end else if (pbegin is Tif) and (pend is Top) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tif) and (pend is TEther) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogMsg) and (pend is TDialogAnswer) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogAnswer) and (pend is TDialogMsg) then begin
{        while true do begin
            Result:=FindLinkBegin(pbegin,'Tif');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end else Break;
        end;}
        if FindLink(pbegin,pend)=nil then begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogAnswer) and (pend is Tif) then begin
        if FindLink(pbegin,pend)=nil then begin
{            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;}
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogAnswer) and (pend is Top) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tif) and (pend is TDialogAnswer) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialogMsg) and (pend is Tif) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=FindLinkFull(pbegin,pend);
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialog) and ((pend is TDialogMsg)) then begin
{        while true do begin
            Result:=FindLinkBegin(pbegin,'Tif');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end else Break;
        end;}
        if FindLink(pbegin,pend)=nil then begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is TDialog) and ((pend is Tif)) then begin
        if FindLinkFull(pbegin,pend)=nil then begin
{            Result:=FindLink(pend,pbegin);
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;}
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
    end else if (pbegin is Tif) and (pend is TDialogMsg) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=FindLinkBegin(pbegin,'TDialogMsg');
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=FindLink(pend,pbegin);
            if Result<>nil then begin
                GGraphLink.Delete(GGraphLink.IndexOf(Result));
                Result.Free;
            end;
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;
{    end else if (pbegin is TDialog) and (pend is Top) then begin
        if FindLink(pbegin,pend)=nil then begin
            Result:=TGraphLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
        end;}
    end else if (pbegin is TState) and (pend is TState) then begin
//        if FindLink(pbegin,pend)=nil then begin
            Result:=TStateLink.Create;
            Result.FBegin:=pbegin;
            Result.FEnd:=pend;
            Result.FArrow:=true;
            Exit;
//        end;
    end;
end;

{function GCA(a:DWORD; i:integer):boolean;
begin
    Result:=Boolean((a shr i) and 1);
end;}

function CA(a:DWORD; i:integer):boolean;
begin
    Result:=Boolean((a shr i) and 1);
end;

function CA(a:DWORD; i:integer; zn:boolean):DWORD;
begin
    if zn then Result:=a or (1 shl i)
    else Result:=a and (not (1 shl i));
end;

procedure SCA(var a:DWORD; i:integer; zn:boolean);
begin
    if zn then a:=a or (1 shl i)
    else a:=a and (not (1 shl i));
end;

function CA1(a:DWORD; i:integer):DWORD;
begin
    Result:=a or (1 shl i);
end;

function BuildRazd(tstr:WideString):WideString;
var
    i,tstrlen,len,maxlen:integer;
begin
    tstrlen:=Length(tstr);
    i:=0;
    len:=0;
    maxlen:=0;
    while i<tstrlen do begin
        if (i<(tstrlen-1)) and (tstr[i+1]=#13) and (tstr[i+2]=#10) then begin
            if len>maxlen then maxlen:=len; 
            len:=0;
            inc(i);
        end else if tstr[i+1]='~' then begin
        end else begin
            len:=len+1;
        end;
        inc(i);
    end;
    if len>maxlen then maxlen:=len;

    Result:='';
    for i:=0 to maxlen-1 do Result:=Result+'-';

    Result:=StringReplaceEC(tstr,'~',Result+#13#10);
end;

function MenuBuild(form:TForm; tstr:WideString; pum:TPopupMenu; selfun:TNotifyEvent):boolean;
var
    i,u,cntu:integer;
    tis:WideString;
    gp:TGraphPoint;
    gpi:TGraphPointInterface;
    mi:TMenuItem;
begin
    if GetCountParEC(tstr,'<>')<>3 then begin Result:=false; Exit; end;
    tstr:=GetStrParEC(tstr,1,'<>');
    cntu:=GetCountParEC(tstr,',');
    if cntu<1 then begin Result:=false; Exit; end;

    pum.Items.Clear;
    for u:=0 to cntu-1 do begin
        tis:=TrimEx(GetStrParEC(tstr,u,','));

        if tis='Ship' then begin
            mi:=TMenuItem.Create(form);
            mi.AutoHotkeys:=maManual;
            mi.Caption:='CurShip';
            mi.OnClick:=selfun;
            pum.Items.Add(mi);

            mi:=TMenuItem.Create(form);
            mi.AutoHotkeys:=maManual;
            mi.Caption:='Player()';
            mi.OnClick:=selfun;
            pum.Items.Add(mi);
        end else begin
            i:=0;
            while i<GGraphPointInterface.Count do begin
                gpi:=GGraphPointInterface.Items[i];
                if gpi.FName=tis then begin
                    gp:=gpi.NewPoint(Point(0,0));
                    tis:=gp.ClassName;
                    gp.Free;
                break;
                end;
                inc(i);
            end;
            if i>=GGraphPointInterface.Count then continue;

            for i:=0 to GGraphPoint.Count-1 do begin
                gp:=GGraphPoint.Items[i];

                if gp.ClassName=tis then begin
                    mi:=TMenuItem.Create(form);
                    mi.AutoHotkeys:=maManual;
                    mi.Caption:=gp.FText;
                    mi.OnClick:=selfun;
                    pum.Items.Add(mi);
                end;
            end;
        end;
    end;

    Result:=pum.Items.Count<>0;
end;

procedure ReplaceColor(bm:TBitmap; oldcolor:TColor; newcolor:TColor);
var
    x,y:integer;
begin
    for y:=0 to bm.Height-1 do begin
        for x:=0 to bm.Width-1 do begin
            if bm.Canvas.Pixels[x,y]=oldcolor then bm.Canvas.Pixels[x,y]:=newcolor;
        end;
    end;
end;

function NewGUID:TGUID;
begin
    if CoCreateGuid(Result)<>S_OK then raise Exception.Create('NewGUID');
end;

function GUIDToStr(zn:TGUID):WideString;
var
    tstr:WideString;
begin
    SetLength(tstr,40);
    if StringFromGUID2(zn,PWideChar(tstr),40)=0 then raise Exception.Create('GUIDToStr');
    Result:=UpperCase(Copy(tstr,2,36));
end;

end.
