unit Form_Build;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,Math,
  GraphUnit, StdCtrls, Buttons, Mask, ToolEdit, Grids{, Mask, ToolEdit};

type
TFormBuild = class(TForm)
    BitBtn1: TBitBtn;
    FilenameEditScript: TFilenameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditTextSName: TEdit;
    BitBtnBuild: TBitBtn;
    Co: TMemo;
    DGOutText: TDrawGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnBuildClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DGOutTextDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DGOutTextGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure DGOutTextSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
private
    { Private declarations }
public
    { Public declarations }
    GNewNomTrasText:integer;

    procedure UpdateGOT;
end;

procedure BuildRun;

var
  FormBuild: TFormBuild;

implementation

{$R *.DFM}

uses Global,EC_Expression,EC_BlockPar,Main,EC_Str,EC_Buf,Form_Main,Form_Star,Form_StarShip,Form_StarLink,
     Form_Planet,Form_Place,Form_Item,Form_Group,Form_GroupLink,
     Form_State,Form_StateLink,Form_If,Form_Var,Form_Op,Form_Ether,
     Form_Dialog,Form_DialogMsg,Form_DialogAnswer;

function ToCodeText(tstr:WideString):WideString;
begin
//    Result:=StringReplaceEC(tstr,#13#10,' ');//'<br>');
    Result:=StringReplaceEC(tstr,#13#10,'<br>');
    Result:=StringReplaceEC(Result,'"','~quot~');
    Result:=StringReplaceEC(Result,'''','~apostrophe~');
end;

procedure BuildRun;
begin
    FormBuild.ShowModal;
end;

procedure TFormBuild.FormShow(Sender: TObject);
begin
    EditTextSName.Text:=GScriptName;
    FilenameEditScript.Text:=GScriptFileOut;
//    FilenameEditText.Text:=GScriptFileTextOut.Par['rus'];

    UpdateGOT;
end;

procedure TFormBuild.BitBtn1Click(Sender: TObject);
begin
    GScriptName:=TrimEx(EditTextSName.Text);
    GScriptFileOut:=TrimEx(FilenameEditScript.Text);
//    GScriptFileTextOut.Par['rus']:=TrimEx(FilenameEditText.Text);
end;

procedure TFormBuild.UpdateGOT;
begin
    DGOutText.RowCount:=GScriptFileTextOut.Par_Count;
    DGOutText.Invalidate;
end;

procedure TFormBuild.DGOutTextDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
    tstr:WideString;
begin
    tstr:='';
    if (ARow>=0) and (ARow<GScriptFileTextOut.Par_Count) then begin
        if ACol=0 then tstr:=GScriptFileTextOut.Par_GetName(ARow)
        else if ACol=1 then tstr:=GScriptFileTextOut.Par_Get(ARow);
    end;
    SaveCanvasPar(DGOutText.Canvas);
    DrawRectText(DGOutText.Canvas,
                 Rect,
                 bsClear,0,
                 psClear,0,0,1,
                 -1,0,false,
                 tstr);
    LoadCanvasPar(DGOutText.Canvas);
end;

procedure TFormBuild.DGOutTextGetEditText(Sender: TObject; ACol,
  ARow: Integer; var Value: String);
begin
    if (ARow>=0) and (ARow<GScriptFileTextOut.Par_Count) then begin
        if ACol=0 then Value:=GScriptFileTextOut.Par_GetName(ARow)
        else if ACol=1 then Value:=GScriptFileTextOut.Par_Get(ARow);
    end;
end;

procedure TFormBuild.DGOutTextSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
    if (ARow>=0) and (ARow<GScriptFileTextOut.Par_Count) then begin
        if ACol=0 then begin
            if ARow<>0 then GScriptFileTextOut.Par_SetName(ARow,Value);
        end else if ACol=1 then GScriptFileTextOut.Par_Set(ARow,Value);
    end;
end;

procedure TFormBuild.Button1Click(Sender: TObject);
begin
    GScriptFileTextOut.Par_Add('new','');
    UpdateGOT;
end;

procedure TFormBuild.Button2Click(Sender: TObject);
var
    no:integer;
begin
    no:=DGOutText.Row;
    if (no>=1) and (no<GScriptFileTextOut.Par_Count) then begin
        if MessageBox(Handle,'Delete ?','Query',MB_OKCANCEL or MB_ICONQUESTION)<>IDOK then Exit;
        GScriptFileTextOut.Par_Delete(no);
        UpdateGOT;
    end;
end;

procedure TFormBuild.Button3Click(Sender: TObject);
var
    bp,bp2:TBlockParEC;
    i,no:integer;
	sdir:AnsiString;
begin
    no:=DGOutText.Row;
    if (no>=0) and (no<GScriptFileTextOut.Par_Count) then begin

	    sdir:=GetCurrentDir;
        OpenDialog1.InitialDir:=RegUser_GetString('','LastTranslatePath','');
        if not OpenDialog1.Execute then Exit;
    	SetCurrentDir(sdir);
        RegUser_SetString('','LastTranslatePath',File_Path(OpenDialog1.FileName));

        bp:=TBlockParEC.Create;
        bp.LoadFromFile(PChar(OpenDialog1.FileName));
        bp2:=GScriptTranslate.Block_GetNE(GScriptFileTextOut.Par_GetName(no));
        if bp2=nil then bp2:=GScriptTranslate.Block_Add(GScriptFileTextOut.Par_GetName(no));

        for i:=bp.Par_Count()-1 downto 0 do begin
            if StrToIntEC(bp.Par_GetName(i))<0 then bp.Par_Delete(i);
        end;

        bp2.Clear;
        bp2.CopyFrom(bp);
        bp.Free;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure Error(tstr:WideString);
begin
    raise EAbort.Create(tstr);
end;

procedure SortPointByPos(li:TList);
var
    i,u:integer;
    p1,p2:TGraphPoint;
begin
    for i:=0 to li.Count-2 do begin
        for u:=i+1 to li.Count-1 do begin
            p1:=li.Items[i];
            p2:=li.Items[u];
            if (p1.FPos.y>p2.FPos.y) or ((p1.FPos.y=p2.FPos.y) and (p1.FPos.x>p2.FPos.x)) then begin
                li.Items[i]:=p2;
                li.Items[u]:=p1;
            end;
        end;
    end;
end;

procedure SortPointByLink(ps:TGraphPoint; li:TList);
var
    i,u:integer;
    p1,p2:TGraphPoint;
    l1,l2:TStateLink;
begin
    for i:=0 to li.Count-2 do begin
        for u:=i+1 to li.Count-1 do begin
            p1:=li.Items[i];
            p2:=li.Items[u];
            l1:=FindLink(ps,p1) as TStateLink;
            l2:=FindLink(ps,p2) as TStateLink;
            if l1.FPriority>l2.FPriority then begin
                li.Items[i]:=p2;
                li.Items[u]:=p1;
            end;
        end;
    end;
end;

procedure BuildCode_r(gp:TGraphPoint; var sc:WideString; var insertto:integer; liststate:TList; listdialogmsg:TList; listdialoganswer:TList; level:WideString);
var
    i:integer;
    li:TList;
    gpt:TGraphPoint;
    pop:Top;
    pif:Tif;
    pether:TEther;
    tstr:WideString;
//    fco:boolean;
begin
//    fco:=false;

    li:=TList.Create;

    FindAllLinkPoint(gp,'Top',li);
    FindAllLinkPoint(gp,'TEther',li,true);
    SortPointByPos(li);
    for i:=0 to li.Count-1 do begin
//        fco:=true;
        gpt:=li.Items[i];

        if gpt is Top then begin
            pop:=gpt as TOp;

            tstr:=level+pop.FExpr+';'+#13#10;
            StringInsertEC{ta}(sc,insertto,tstr); insertto:=insertto+Length(tstr);
        end else begin
            pether:=gpt as TEther;

            tstr:=level+'Ether('+IntToStr(pether.FType)+','''+pether.FUnique+''',"'+ToCodeText(pether.FMsg)+'"';
            if TrimEx(pether.FShip1)<>'' then tstr:=tstr+','+pether.FShip1;
            if TrimEx(pether.FShip2)<>'' then tstr:=tstr+','+pether.FShip2;
            if TrimEx(pether.FShip3)<>'' then tstr:=tstr+','+pether.FShip3;
            tstr:=tstr+');'+#13#10;
            StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
        end;

        BuildCode_r(gpt,sc,insertto,liststate,listdialogmsg,listdialoganswer,level+'    ');
    end;

    FindAllLinkPoint(gp,'Tif',li);
    SortPointByPos(li);
    for i:=0 to li.Count-1 do begin
//        fco:=true;

        pif:=li.Items[i];

        tstr:=level+'if('+pif.FExpr+') {'+#13#10;
        StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);

        BuildCode_r(pif,sc,insertto,liststate,listdialogmsg,listdialoganswer,level+'    ');

        tstr:=level+'}'+#13#10;
        StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;

    FindAllLinkPoint(gp,'TState',li);
    if gp is TState then begin
        SortPointByLink(gp,li);
        for i:=0 to li.Count-1 do begin
            if liststate=nil then Error('Code to state');
            tstr:=level+'if('+TStateLink(FindLink(gp,li.Items[i])).FExpr+') {'+#13#10;
            tstr:=tstr+level+'    '+'ChangeState('+IntToStr(liststate.IndexOf(li.Items[i]))+');'+#13#10;
            tstr:=tstr+level+'    '+'exit;'+#13#10;
            tstr:=tstr+level+'}'+#13#10;
            StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
        end;
    end else begin
        SortPointByPos(li);
        if li.Count>0 then begin
            if liststate=nil then Error('Code to state');
            tstr:=level+'ChangeState('+IntToStr(liststate.IndexOf(li.Items[0]))+');'+#13#10;
            tstr:=tstr+level+'exit;'+#13#10;
            StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
        end;
    end;

    FindAllLinkPoint(gp,'TDialogMsg',li);
    if li.Count>0 then begin
        if listdialogmsg=nil then Error('Code to DialogMsg');
        tstr:=level+'DChange('+IntToStr(listdialogmsg.IndexOf(li.Items[0]))+');'+#13#10;
        tstr:=tstr+level+'exit;'+#13#10;
        StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;

    FindAllLinkPoint(gp,'TDialogAnswer',li);
    for i:=0 to li.Count-1 do begin
        if listdialoganswer=nil then Error('Code to DialogAnswer');
        tstr:=level+'DAdd('+IntToStr(listdialoganswer.IndexOf(li.Items[i]))+');'+#13#10;
        StringInsertEC(sc,insertto,tstr); insertto:=insertto+Length(tstr);
    end;

    li.Free;
end;

{function BuildCode(pstart:TGraphPoint; liststate:TList; level:WideString=''):WideString;
var
    insertto:integer;
begin
    insertto:=0;
    Result:='';
    BuildCode_r(pstart,Result,insertto,liststate,level);
end;}

function BuildCode(gp:TGraphPoint; liststate:TList; listdialogmsg:TList; listdialoganswer:TList; level:WideString=''):WideString;
var
    insertto:integer;
    tstr:WideString;
begin
    insertto:=0;
    Result:='';

    if gp is Top then begin
        tstr:=level+Top(gp).FExpr+';'+#13#10;
        StringInsertEC(Result,insertto,tstr); insertto:=insertto+Length(tstr);
    end else if gp is Tif then begin
        tstr:=level+'if('+Tif(gp).FExpr+') {'+#13#10;
        StringInsertEC(Result,insertto,tstr); insertto:=insertto+Length(tstr);

//        BuildCode_r(pif,sc,insertto,liststate,level+'    ');

        tstr:=level+'}'+#13#10;
        StringInsertEC(Result,insertto,tstr);
    end;

    BuildCode_r(gp,Result,insertto,liststate,listdialogmsg,listdialoganswer,level+'    ');
end;

function BuildCodeText_d(tstr:WideString; bt:TBlockParEC; textpath:WideString{; pws:PWideString; wishno:integer}):WideString;
var
    tstrlen,startt,endt,cnt:integer;
    ts,ts2:WideString;
    sl:TStringList;
    i:integer;
begin
    sl:=TStringList.Create;

    cnt:=0;
    startt:=0;
    while True do begin
        tstrlen:=Length(tstr);
        while startt<tstrlen do begin
            if tstr[startt+1]='<' then break;
            inc(startt);
        end;
        if startt>=tstrlen then break;

        endt:=FindEndTagEC(tstr,startt);
        if endt<0 then break;

        ts:=Copy(tstr,startt+1,endt-startt+1);
        if (Length(ts)<3) or
           (LowerCase(ts)='<br>') or
           (LowerCase(ts)='<player>') or
           (LowerCase(ts)='<playerfull>') or
           (LowerCase(ts)='<clr>') or
           (LowerCase(ts)='<clrend>') or
           (FindSubstringEC(LowerCase(ts),'<color')>=0) or
           (FindSubstringEC(LowerCase(ts),'</color')>=0) then
        begin
            startt:=endt+1; continue;
        end;

        if (LowerCase(ts)='<name(player())>') then begin
            ts2:='<PlayerFull>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end else if (LowerCase(ts)='<shortname(player())>') then begin
            ts2:='<Player>';
            StringDeleteEC(tstr,startt,endt-startt+1);
            StringInsertEC(tstr,startt,ts2);
            startt:=startt+Length(ts2);
            continue;
        end;

        ts2:='<'+IntToStr(cnt)+'>';

        StringDeleteEC(tstr,startt,endt-startt+1);
        StringInsertEC(tstr,startt,ts2);
        startt:=startt+Length(ts2);

        sl.Add('"'+ts2+'"');
        sl.Add(Copy(ts,2,Length(ts)-2));

        inc(cnt);
    end;

    if tstr[1]='"' then begin
        ts:=Copy(tstr,2,Length(tstr)-2);
ts:=StringReplaceEC(ts,'~quot~','"');
ts:=StringReplaceEC(ts,'~apostrophe~','''');

        cnt:=GScriptTranslateId.Par_Count;
        i:=0;
        while i<cnt do begin
            if GScriptTranslateId.Par_Get(i)=ts then break;
            inc(i);
        end;
        if i<cnt then begin
            i:=StrToIntEC(GScriptTranslateId.Par_GetName(i));
            bt.ParNE[IntToStr(i)]:=ts;
        end else begin
            cnt:=bt.Par_Count;
            i:=0;
            while i<cnt do begin
                if bt.Par_Get(i)=ts then break;
                inc(i);
            end;
            if i>=cnt then begin
                i:=FormBuild.GNewNomTrasText;
                inc(FormBuild.GNewNomTrasText);
                bt.ParNE[IntToStr(i)]:=ts;
{                bt.Par_Add(IntToStr(bt.Par_Count),ts);
                i:=bt.Par_Count-1;}
            end else i:=StrToIntEC(bt.Par_GetName(i));
        end;
        tstr:='CT("'+textpath+IntToStr(i)+'")';
    end;

    if sl.Count>0 then begin
        Result:='Format('+tstr;
        for i:=0 to sl.Count-1 do Result:=Result+','+sl.Strings[i];
        Result:=Result+')';
    end else begin
        Result:=tstr;
    end;

    sl.Free;
end;

procedure BuildCodeText(var tstr:WideString; bt:TBlockParEC; textpath:WideString);
var
    ca:TCodeAnalyzerEC;
    cau:TCodeAnalyzerUnitEC;
    tstr2:WideString;
{   ts:WideString;
    i,sme,wishno:integer;
    dw:DWORD;
    ch:WideChar;
    pws:PWideString;}
begin
    ca:=TCodeAnalyzerEC.Create;
    ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;

    cau:=ca.FLast;
    while cau<>nil do begin
        while cau<>nil do begin
            if cau.FType=caeStr then break;
            cau:=cau.FPrev;
        end;
        if cau=nil then break;

{        pws:=nil;
        wishno:=-1;

        ts:=cau.FStr;
        if Length(ts)>=3 then begin
            if ts[0+1]='h' then begin
                sme:=FindSubstring(ts,'~',1);
                if sme>0 then begin
                    i:=1;
                    dw:=0;
                    while i<sme do begin
                        ch:=ts[i+1];
                        if (ch>='0') and (ch<='9') then dw:=dw*10+DWORD(ch)-DWORD('0')
                        else break;
                        inc(i);
                    end;
                    if i>=sme then begin
                        pws:=PWideString(dw);
                        ts:=Copy(ts,sme+1+1,Length(ts)-(sme+1));
                    end;
                end;
            end;
        end;
        if Length(ts)>=2 then begin
            sme:=FindSubstring(ts,'~',1);
            if sme>0 then begin
                i:=0;
                dw:=0;
                while i<sme do begin
                    ch:=ts[i+1];
                    if (ch>='0') and (ch<='9') then dw:=dw*10+DWORD(ch)-DWORD('0')
                    else break;
                    inc(i);
                end;
                if i>=sme then begin
                    wishno:=dw;
                    ts:=Copy(ts,sme+1+1,Length(ts)-(sme+1));
                end;
            end;
        end;}

        if tstr[cau.FSme+1]='"' then tstr2:=BuildCodeText_d('"'+{ts}cau.FStr+'"',bt,textpath{,pws,wishno})
        else tstr2:=BuildCodeText_d(''''+{ts}cau.FStr+'''',bt,textpath{,pws,wishno});
        if tstr2<>cau.FStr then begin
            StringDeleteEC(tstr,cau.FSme,cau.FLen);
            StringInsertEC(tstr,cau.FSme,tstr2);
        end;

        cau:=cau.FPrev;
    end;

    ca.Free;
end;

procedure TFormBuild.BitBtnBuildClick(Sender: TObject);
var
    bs,bsz:TBufEC;
    bt,bt2,bt3:TBlockParEC;
    i,u,zn,zn2,cnt,cntu:integer;
    li,li2,listar,ligroup,listate,lidialogmsg,lidialoganswer:TList;
    pg:TGraphPoint;
    ps,ps2:TStar;
    psl:TStarLink;
    pss:TStarShip;
    pp:TPlanet;
//    pr:TRuins;
    pplace:TPlace;
    pitem:TItem;
    pgroup:TGroup;
    pgl:TGroupLink;
    pstate:TState;
    pv:TVar;
    pop:Form_OP.Top;
    pdmsg:TDialogMsg;
    pdanswer:TDialogAnswer;
    svar:TVarArrayEC;
    svar_g:TVarArrayEC;
    tstr,tstr2:WideString;
    ca:TCodeAnalyzerEC;
    code:TCodeEC;
    arconst:array of integer;
begin
    GScriptName:=TrimEx(EditTextSName.Text);
    GScriptFileOut:=TrimEx(FilenameEditScript.Text);
//    GScriptFileTextOut.Par['rus']:=TrimEx(FilenameEditText.Text);

    Co.Lines.Clear;

    li:=TList.Create;
    li2:=TList.Create;
    listar:=TList.Create;
    ligroup:=TList.Create;
    listate:=TList.Create;
    lidialogmsg:=TList.Create;
    lidialoganswer:=TList.Create;
    bs:=TBufEC.Create;
    bsz:=TBufEC.Create;
    bt:=TBlockParEC.Create;
    bt2:=TBlockParEC.Create;
    svar:=TVarArrayEC.Create;
    svar_g:=TVarArrayEC.Create;
    ca:=TCodeAnalyzerEC.Create;
    code:=TCodeEC.Create;

    try
        GNewNomTrasText:=-1;
        for i:=0 to GScriptTranslateId.Par_Count-1 do begin
            GNewNomTrasText:=max(GNewNomTrasText,StrToIntEC(GScriptTranslateId.Par_GetName(i)));
        end;
        inc(GNewNomTrasText);

        if Length(GScriptName)<1 then Error('Script name error');
        if Length(GScriptFileOut)<1 then Error('Script filename error');
        if Length(GScriptFileTextOut.Par['rus'])<1 then Error('Text filename error');

        bsz.AddDWORD(PVersion);
        bsz.AddDWORD(0);

        // Variable global
        FindAllPoint('TVar',li);
        for i:=0 to li.Count-1 do begin
            pv:=li.Items[i];

            if not pv.FGlobal then continue;

            tstr:=pv.FText;
            if tstr<>TrimEx(tstr) then Error('Variable name : '+tstr);
            if Length(tstr)<1 then Error('Variable name');
            if svar_g.GetVarNE(tstr)<>nil then Error('Variable name not unique');

            if pv.FType=0 then svar_g.Add(tstr,vtUnknown)
            else if pv.FType=1 then svar_g.Add(tstr,vtInt).VInt:=StrToIntEC(pv.FInit)
            else if pv.FType=2 then svar_g.Add(tstr,vtDW).VDW:=StrToIntEC(pv.FInit)
            else if pv.FType=3 then svar_g.Add(tstr,vtStr).VStr:=pv.FInit;
        end;
        svar_g.Save(bsz);

        // Top,Tif no link
        FindAllPoint('Top',li);
        FindAllPoint('Tif',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        i:=0;
        while i<li.Count do begin
            pg:=li.Items[i];
            u:=0;
            while u<GGraphLink.Count do begin
                if TGraphLink(GGraphLink.Items[u]).FEnd=pg then break;
                inc(u);
            end;
            if u<GGraphLink.Count then begin
                li.Delete(i);
            end else inc(i);
        end;
        SortPointByPos(li);

        // Global run
        Co.Lines.Add('Global code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=2)) then
            begin
                tstr:=tstr+BuildCode(pg,nil,nil,nil,'    ');
            end;
        end;
        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        Co.Lines.Add(tstr);
        Co.Lines.Add('}');

        ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
        code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);
//        svar_g.Add(tstr);
        bsz.Add(tstr);

        bsz.S(4,DWORD(bsz.BPointer));

        // Variable local
        FindAllPoint('TVar',li);
        for i:=0 to li.Count-1 do begin
            pv:=li.Items[i];

            if pv.FGlobal then continue;

            tstr:=pv.FText;
            if tstr<>TrimEx(tstr) then Error('Variable name : '+tstr);
            if Length(tstr)<1 then Error('Variable name');
            if (svar.GetVarNE(tstr)<>nil) or (svar_g.GetVarNE(tstr)<>nil) then Error('Variable name not unique');

            if pv.FType=0 then svar.Add(tstr,vtUnknown)
            else if pv.FType=1 then svar.Add(tstr,vtInt).VInt:=StrToIntEC(pv.FInit)
            else if pv.FType=2 then svar.Add(tstr,vtDW).VDW:=StrToIntEC(pv.FInit)
            else if pv.FType=3 then svar.Add(tstr,vtStr).VStr:=pv.FInit;
        end;

        // Find DialogMsg
        FindAllPoint('TDialogMsg',lidialogmsg);

        // Find DialogAnswer
        FindAllPoint('TDialogAnswer',lidialoganswer);

        // Find state
        FindAllPoint('TState',listate); if listate.Count<1 then Error('State not found');

        // Find star
        FindAllPoint('TStar',listar); if listar.Count<1 then Error('Star not found');

        FindAllPointLinkFull('TStarShip','TStar',li2);
        if li2.Count<1 then Error('Player''s start not found');
        u:=0;
        for i:=0 to li2.Count-1 do begin
            pss:=li2.Items[i];
            if pss.FPlayer then inc(u);
        end;
        if u<>1 then Error('Player''s start');
        for i:=0 to li2.Count-1 do begin
            pss:=li2.Items[i];
            if pss.FPlayer then begin
                FindAllLinkPointFull(pss,'TStar',li2);
                if li2.Count<>1 then Error('Player''s start');

{                u:=listar.IndexOf(li2.Items[0]);
                if u>0 then begin
                    ps:=listar.Items[0];
                    listar.Items[0]:=listar.Items[u];
                    listar.Items[u]:=ps;
                end;}

                break;
            end;
        end;

        // Star sort
        for i:=0 to listar.Count-2 do begin
            for u:=i+1 to listar.Count-1 do begin
                if TStar(listar[i]).FPriority>TStar(listar[u]).FPriority then begin
                    ps:=listar.Items[i];
                    listar.Items[i]:=listar.Items[u];
                    listar.Items[u]:=ps;
                end;
            end;
        end;
        if listar.Count>=2 then begin
            if TStar(listar.Items[0]).FPriority=TStar(listar.Items[1]).FPriority then begin
                Error('Star priority. First unique');
            end;
        end;

        // Constellation
        SetLength(arconst,listar.Count);
        zn:=0;
        for i:=0 to listar.Count-1 do begin
            if (TStar(listar[i]).FConstellation-1)>=0 then begin
                u:=0;
                while u<zn do begin
                    if arconst[u]=(TStar(listar[i]).FConstellation-1) then break;
                    inc(u);
                end;
                if u>=zn then begin
                    arconst[zn]:=TStar(listar[i]).FConstellation-1;
                    inc(zn);
                end;
            end;
        end;
        for i:=0 to zn-2 do begin
            for u:=i+1 to zn-1 do begin
                if arconst[i]>arconst[u] then begin
                    zn2:=arconst[i];
                    arconst[i]:=arconst[u];
                    arconst[u]:=zn2;
                end;
            end;
        end;
        if zn>0 then begin
            if arconst[zn-1]<>(zn-1) then Error('Constellation');
        end;
        bs.AddInteger(zn);

        // Star and if
        bs.AddInteger(listar.Count);
        for i:=0 to listar.Count-1 do begin
            ps:=listar.Items[i];
            tstr:=ps.FText;
            if tstr<>TrimEx(tstr) then Error('Star name : '+tstr);
            if Length(tstr)<1 then Error('Star name');
            if svar.GetVarNE(tstr)<>nil then Error('Star name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            if not ps.FSubspace then begin
                Co.Lines.Add('Star : '+tstr);
            end else begin
                Co.Lines.Add('Subspace : '+tstr);
            end;

            bs.AddInteger(ps.FConstellation-1);
            bs.AddBoolean(ps.FSubspace);
            bs.AddBoolean(ps.FNoKling);
            bs.AddBoolean(ps.FNoComeKling);

            FindAllLinkPointFull(ps,'TStar',li);
            u:=0;
            while u<li.Count do begin
                ps2:=li.Items[u];
                psl:=FindLinkFull(ps,ps2) as TStarLink;
                if ps.FSubspace and (not psl.FHole) then Error('Subspace and not hole. Subspace name : '+ps.FText);
                if listar.IndexOf(ps2)>=i then begin
                    li.Delete(u);
                end else if ((psl.FDistMin<=0) and (psl.FDistMax>=150)) and ((psl.FRelMin<=0) and (psl.FRelMax>=100)) and ((psl.FAngleRange>=100)) and (not psl.FHole) then begin
                    li.Delete(u);
                end else inc(u);
            end;

            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                ps2:=li.Items[u];
                bs.AddDWORD(listar.IndexOf(ps2));
                psl:=FindLinkFull(ps,ps2) as TStarLink;
                zn:=Round(ArcTan2(ps.FPos.x-ps2.FPos.x,-(ps.FPos.y-ps2.FPos.y))*(180.0/3.1415926));
                if zn<0 then zn:=360+zn;
                bs.AddInteger(zn);
                bs.AddInteger(psl.FDistMin);
                bs.AddInteger(psl.FDistMax);
                bs.AddInteger(psl.FRelMin);
                bs.AddInteger(psl.FRelMax);
                bs.AddInteger(psl.FAngleRange);
                bs.AddBoolean(psl.FHole);
            end;

            // Planet
            FindAllLinkPointFull(ps,'TPlanet',li);
            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                pp:=li.Items[u];
                tstr:=pp.FText;
                if tstr<>TrimEx(tstr) then Error('Planet name : '+tstr);
                if Length(tstr)<1 then Error('Planet name');
                if svar.GetVarNE(tstr)<>nil then Error('Planet name not unique');
                bs.Add(tstr);
                svar.Add(tstr,vtDW).VDW:=0;

                Co.Lines.Add('    Planet : '+tstr);

                bs.AddDWORD(pp.FRace);
                bs.AddDWORD(pp.FOwner);
                bs.AddDWORD(pp.FEconomy);
                bs.AddDWORD(pp.FGoverment);
                bs.AddInteger(pp.FRangeMin);
                bs.AddInteger(pp.FRangeMax);
                if pp.FDialog=nil then bs.Add(WideString(''))
                else bs.Add(pp.FDialog.FText);
            end;

            // Ship
            FindAllLinkPointFull(ps,'TStarShip',li);
            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                pss:=li.Items[u];

                bs.AddInteger(pss.FCount);
                bs.AddDWORD(pss.FOwner);
                bs.AddDWORD(pss.FType);
                bs.AddBoolean(pss.FPlayer);
                bs.AddInteger(pss.FSpeedMin);
                bs.AddInteger(pss.FSpeedMax);
                bs.AddInteger(pss.FWeapon);
                bs.AddInteger(pss.FCargoHook);
                bs.AddInteger(pss.FEmptySpace);
                bs.AddInteger(pss.FRatingMin);
                bs.AddInteger(pss.FRatingMax);
                bs.AddInteger(pss.FStatusTraderMin);
                bs.AddInteger(pss.FStatusTraderMax);
                bs.AddInteger(pss.FStatusWarriorMin);
                bs.AddInteger(pss.FStatusWarriorMax);
                bs.AddInteger(pss.FStatusPirateMin);
                bs.AddInteger(pss.FStatusPirateMax);
                bs.AddInteger(pss.FScoreMin);
                bs.AddInteger(pss.FScoreMax);
                bs.AddSingle(pss.FStrengthMin);
                bs.AddSingle(pss.FStrengthMax);
                bs.Add(pss.FRuins);
            end;

{            // Ruins
            FindAllLinkPointFull(ps,'TRuins',li);
            bs.AddInteger(li.Count);
            for u:=0 to li.Count-1 do begin
                pr:=li.Items[u];

                tstr:=pr.FText;
                if tstr<>TrimEx(tstr) then Error('Ruins name : '+tstr);
                if Length(tstr)<1 then Error('Ruins name');
                if svar.GetVarNE(tstr)<>nil then Error('Ruins name not unique');
                bs.Add(tstr);
                svar.Add(tstr,vtDW).VDW:=0;

                Co.Lines.Add('    Ruins : '+tstr);

                if pr.FDialog=nil then bs.Add(WideString(''))
                else bs.Add(pr.FDialog.FText);
            end;}
        end;

        // Place
        FindAllPoint('TPlace',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pplace:=li.Items[i];

            tstr:=pplace.FText;
            if tstr<>TrimEx(tstr) then Error('Place name : '+tstr);
            if Length(tstr)<1 then Error('Place name');
            if svar.GetVarNE(tstr)<>nil then Error('Place name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=0;

            Co.Lines.Add('Place : '+tstr);

            FindAllLinkPointFull(pplace,'TStar',li2);
            if li2.Count>1 then Error('Place')
            else if li2.Count<1 then bs.Add(WideString(''))
            else bs.Add(TStar(listar[listar.IndexOf(li2.Items[0])]).FText);

            bs.AddInteger(pplace.FType);

            if pplace.FType=0 then begin // Free
                bs.AddSingle(pplace.FAngle);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
            end else if pplace.FType=1 then begin // Near planet
                if pplace.FObj=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj.FText);
                bs.Add(pplace.FRadius);
            end else if pplace.FType=2 then begin // In Planet
                if pplace.FObj=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj.FText);
            end else if pplace.FType=3 then begin // To star
                if pplace.FObj=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj.FText);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
                bs.AddSingle(pplace.FAngle);
            end else if pplace.FType=4 then begin // Near item
                if pplace.FObj=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj.FText);
                bs.Add(pplace.FRadius);
            end else if pplace.FType=5 then begin // From ship
                if pplace.FObj=nil then Error('Place : '+pplace.FText);
                bs.Add(pplace.FObj.FText);
                bs.AddSingle(pplace.FDist);
                bs.AddInteger(pplace.FRadius);
                bs.AddSingle(pplace.FAngle);
            end;
        end;

        // Items
        FindAllPoint('TItem',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pitem:=li.Items[i];

            tstr:=pitem.FText;
            if tstr<>TrimEx(tstr) then Error('Items name : '+tstr);
            if Length(tstr)<1 then Error('Items name');
            if svar.GetVarNE(tstr)<>nil then Error('Item name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=0;

            Co.Lines.Add('Item : '+tstr);

            FindAllLinkPointFull(pitem,'TPlace',li2);
            if li2.Count<1 then begin
                FindAllLinkPointFull(pitem,'TGroup',li2);
                if li2.Count<1 then begin
                    FindAllLinkPointFull(pitem,'TPlanet',li2);
                    if li2.Count<>1 then begin
                        if pitem.FMainType<>5 then Error('Place')
                    end;
                end else if li2.Count<>1 then begin
                    if pitem.FMainType<>5 then Error('Place')
                end;
            end else begin
                pplace:=li2.Items[0];
                if (pplace.FType=2) or (pplace.FType=4) then Error('Place : '+pplace.FText+' Item : '+pitem.FText);
            end;

            if li2.Count>0 then bs.Add(TGraphPoint(li2.Items[0]).FText)
            else bs.Add(WideString(''));

            bs.AddInteger(pitem.FMainType);
            bs.AddInteger(pitem.FType);
            bs.AddInteger(pitem.FSize);
            bs.AddInteger(pitem.FLavel);
            bs.AddInteger(pitem.FRadius);
            bs.AddInteger(pitem.FOwner);
            bs.Add(pitem.FUseless);
        end;

        // Group
        FindAllPoint('TGroup',ligroup);
        bs.AddInteger(ligroup.Count);
        if ligroup.Count<1 then Error('Group not found');
        for i:=0 to ligroup.Count-1 do begin
            pgroup:=ligroup.Items[i];

            tstr:=pgroup.FText;
            if tstr<>TrimEx(tstr) then Error('Group name : '+tstr);
            if Length(tstr)<1 then Error('Group name');
            if svar.GetVarNE(tstr)<>nil then Error('Group name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            Co.Lines.Add('Group : '+tstr);

            FindAllLinkPointFull(pgroup,'TPlanet',li);
            if li.Count<>1 then Error('Group-Planet');
            bs.Add(TGraphPoint(li.Items[0]).FText);

            FindAllLinkPointFull(pgroup,'TState',li);
            if li.Count<>1 then Error('Group-State');
            bs.AddInteger(listate.IndexOf(li.Items[0]));

            bs.AddDWORD(pgroup.FOwner);
            bs.AddDWORD(pgroup.FType);
            bs.AddInteger(pgroup.FCntShipMin);
            bs.AddInteger(pgroup.FCntShipMax);
            bs.AddInteger(pgroup.FSpeedMin);
            bs.AddInteger(pgroup.FSpeedMax);
            bs.AddInteger(pgroup.FWeapon);
            bs.AddInteger(pgroup.FCargoHook);
            bs.AddInteger(pgroup.FEmptySpace);
            bs.AddInteger(pgroup.FFriend);
            bs.AddBoolean(pgroup.FAddPlayer);

            bs.AddInteger(pgroup.FRatingMin);
            bs.AddInteger(pgroup.FRatingMax);

            bs.AddInteger(pgroup.FScoreMin);
            bs.AddInteger(pgroup.FScoreMax);

            bs.AddInteger(pgroup.FStatusTraderMin);
            bs.AddInteger(pgroup.FStatusTraderMax);

            bs.AddInteger(pgroup.FStatusWarriorMin);
            bs.AddInteger(pgroup.FStatusWarriorMax);

            bs.AddInteger(pgroup.FStatusPirateMin);
            bs.AddInteger(pgroup.FStatusPirateMax);

            bs.AddInteger(pgroup.FDistSearch);

            if pgroup.FDialog=nil then bs.Add(WideString(''))
            else bs.Add(pgroup.FDialog.FText);

            bs.AddSingle(pgroup.FStrengthMin);
            bs.AddSingle(pgroup.FStrengthMax);
            bs.Add(pgroup.FRuins);
        end;

        // Group link
        FindAllLinkFull('TGroup','TGroup',li);
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            pgl:=li.Items[i];
            bs.AddInteger(ligroup.IndexOf(pgl.FBegin));
            bs.AddInteger(ligroup.IndexOf(pgl.FEnd));
            bs.AddInteger(pgl.FRel1);
            bs.AddInteger(pgl.FRel2);
            bs.AddSingle(pgl.FWarWeightMin);
            bs.AddSingle(pgl.FWarWeightMax);
        end;

        // Top,Tif no link
        FindAllPoint('Top',li);
        FindAllPoint('Tif',li2);
        for i:=0 to li2.Count-1 do li.Add(li2.Items[i]);
        i:=0;
        while i<li.Count do begin
            pg:=li.Items[i];
            u:=0;
            while u<GGraphLink.Count do begin
                if TGraphLink(GGraphLink.Items[u]).FEnd=pg then break;
                inc(u);
            end;
            if u<GGraphLink.Count then begin
                li.Delete(i);
            end else inc(i);
        end;
        SortPointByPos(li);
        // Code init
        Co.Lines.Add('Init code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=1)) or
               ((pg is Form_Op.Top) and ((pg as Form_Op.Top).FInitScript)) then
            begin
                tstr:=tstr+BuildCode(pg,nil,nil,nil,'    ');
            end;
        end;
        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        Co.Lines.Add(tstr);
        Co.Lines.Add('}');

        ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
        code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);
        bs.Add(tstr);

        // Code turn
        Co.Lines.Add('Turn code {');
        tstr:='';
        for i:=0 to li.Count-1 do begin
            pg:=li.Items[i];
            if ((pg is Tif) and ((pg as Tif).FType=0)) or
               ((pg is Form_Op.Top) and (not (pg as Form_Op.Top).FInitScript)) then
            begin
                tstr:=tstr+BuildCode(pg,nil,nil,nil,'    ');
            end;
        end;
        BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
        Co.Lines.Add(tstr);
        Co.Lines.Add('}');

        ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
        code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);
        bs.Add(tstr);

        // Find dialog
        FindAllPoint('TDialog',li);

        // State
        bs.AddInteger(listate.Count);
        for i:=0 to listate.Count-1 do begin
            pstate:=listate.Items[i];

            Co.Lines.Add('State '+IntToStr(i)+' : '+pstate.FText);

            bs.Add(pstate.FText);

            bs.AddInteger(pstate.FMove);
            if pstate.FMove=0 then begin
            end else {if pstate.FMove=1 then} begin
                if pstate.FMoveObj=nil then Error('State : '+pstate.FText);
                bs.Add(pstate.FMoveObj.FText);
            end;

            bs.AddInteger(pstate.FAttack.Count);
            for u:=0 to pstate.FAttack.Count-1 do begin
                bs.Add(TGraphPoint(pstate.FAttack.Items[u]).FText);
            end;

            if pstate.FTakeItem=nil then bs.Add(WideString(''))
            else bs.Add(pstate.FTakeItem.FText);

            bs.AddBoolean(pstate.FTakeAllItem);

            if TrimEx(pstate.FMsgOut)='' then begin
                bs.Add(WideString(''));
            end else begin
                u:=0;
                while u<li.Count do begin
                    if pstate.FMsgOut=TDialog(li.Items[u]).FText then break;
                    inc(u);
                end;
                if u<li.Count then begin
                    bs.Add(TrimEx(pstate.FMsgOut));
                end else begin
                    tstr:='            '+'DText("'+ToCodeText(pstate.FMsgOut)+'");'+#13#10;
                    BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
                    Co.Lines.Add('    CodeTextOut { ');
                    Co.Lines.Add(tstr);
                    Co.Lines.Add('    }');

                    ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
                    code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

                    bs.Add(tstr);
                end;
            end;

            if TrimEx(pstate.FMsgIn)='' then begin
                bs.Add(WideString(''));
            end else begin
                u:=0;
                while u<li.Count do begin
                    if pstate.FMsgIn=TDialog(li.Items[u]).FText then break;
                    inc(u);
                end;
                if u<li.Count then begin
                    bs.Add(TrimEx(pstate.FMsgIn));
                end else begin
                    tstr:='            '+'DText("'+ToCodeText(pstate.FMsgIn)+'");'+#13#10;
                    BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
                    Co.Lines.Add('    CodeTextIn { ');
                    Co.Lines.Add(tstr);
                    Co.Lines.Add('    }');

                    ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
                    code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

                    bs.Add(tstr);
                end;
            end;

            if TrimEx(pstate.FEMsg)='' then begin
                bs.Add(WideString(''));
            end else begin
                tstr:='            '+'Ether('+IntToStr(pstate.FEType)+','''+pstate.FEUnique+''',"'+ToCodeText(pstate.FEMsg)+'",CurShip);'+#13#10;
                BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
                Co.Lines.Add('    CodeEther { ');
                Co.Lines.Add(tstr);
                Co.Lines.Add('    }');

                ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
                code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

                bs.Add(tstr);
            end;

            tstr:=(BuildCode(pstate,listate,nil,nil,'        '));
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            Co.Lines.Add('    Code { ');
            Co.Lines.Add(tstr);
            Co.Lines.Add('    }');

            ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
            code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

            bs.Add(tstr);

        end;

        // Dialog
        bs.AddInteger(li.Count);
        for i:=0 to li.Count-1 do begin
            tstr:=TDialog(li.Items[i]).FText;
            if tstr<>TrimEx(tstr) then Error('Dialog name : '+tstr);
            if Length(tstr)<1 then Error('Dialog name');
            if svar.GetVarNE(tstr)<>nil then Error('Dialog name not unique');
            bs.Add(tstr);
            svar.Add(tstr,vtDW).VDW:=i;

            Co.Lines.Add('Dialog : '+tstr);

            tstr:=BuildCode(li.Items[i],nil,lidialogmsg,nil,'        ');
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            Co.Lines.Add('    Start code { ');
            Co.Lines.Add(tstr);
            Co.Lines.Add('    }');

            ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
            code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

            bs.Add(tstr);
        end;

        // DialogMsg
        bs.AddInteger(lidialogmsg.Count);
        for i:=0 to lidialogmsg.Count-1 do begin
            pdmsg:=lidialogmsg.Items[i];
            bs.Add(pdmsg.FText);

            Co.Lines.Add('DialogMsg '+IntToStr(i)+' : '+pdmsg.FText);

            tstr:='            '+'DText("'+ToCodeText(pdmsg.FMsg)+'");'+#13#10;
            tstr:=tstr+BuildCode(pdmsg,nil,nil,lidialoganswer,'        ');
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            Co.Lines.Add('    Code { ');
            Co.Lines.Add(tstr);
            Co.Lines.Add('    }');

            ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
            code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

            bs.Add(tstr);
        end;

        // DialogAnswer
        bs.AddInteger(lidialoganswer.Count);
        for i:=0 to lidialoganswer.Count-1 do begin
            pdanswer:=lidialoganswer.Items[i];
            bs.Add(pdanswer.FText);

            Co.Lines.Add('DialogAnswer '+IntToStr(i)+' : '+pdanswer.FText);

            if LowerCase(pdanswer.FText)='exit' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''exit'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''exit~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='takeoff' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''takeoff'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''takeoff~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='planet' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''planet'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''planet~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='goods' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''goods'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''goods~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='shop' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''shop'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''shop~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='hangar' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''hangar'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''hangar~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='main' then begin
                tstr:='            '+'DAnswer(''main'');'+#13#10;
            end else if LowerCase(pdanswer.FText)='exit_news' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''exit_news'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''exit_news~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else if LowerCase(pdanswer.FText)='exit_end' then begin
                if TrimEX(pdanswer.FMsg)='' then begin
                    tstr:='            '+'DAnswer(''exit_end'');'+#13#10;
                end else begin
                    tstr:='            '+'DAnswer(''exit_end~''+"'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
                end;
            end else begin
                tstr:='            '+'DAnswer("'+ToCodeText(pdanswer.FMsg)+'");'+#13#10;
            end;
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            Co.Lines.Add('    Answer { ');
            Co.Lines.Add(tstr);
            Co.Lines.Add('    }');

            ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
            code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

            bs.Add(tstr);

            tstr:=BuildCode(pdanswer,nil,lidialogmsg,nil,'        ');
            BuildCodeText(tstr,bt,'Script.'+GScriptName+'.');
            Co.Lines.Add('    Code { ');
            Co.Lines.Add(tstr);
            Co.Lines.Add('    }');

            ca.Clear; ca.Build(tstr); ca.DelCom; ca.DelSpace; ca.DelEnter;
            code.Clear; tstr2:=code.Compiler(ca,0); if tstr2<>'' then Error(tstr2);

            bs.Add(tstr);
        end;

        svar.Save(bsz);
        bsz.Add(bs.Buf,bs.Len);

        bsz.SaveInFile(PChar(AnsiString(GScriptFileOut)));

        cnt:=GScriptFileTextOut.Par_Count();
        cntu:=bt.Par_Count();
        for i:=0 to cnt-1 do begin
            bt2.Clear;
            bt3:=GScriptTranslate.Block_GetNE(GScriptFileTextOut.Par_GetName(i));
            for u:=0 to cntu-1 do begin
                tstr:=bt.Par_GetName(u);
                if (bt3<>nil) and (bt3.Par_Count(tstr)>0) then begin
                    bt2.Par_Add(tstr,bt3.Par_Get(tstr));
                end else begin
                    bt2.Par_Add('-'+tstr,bt.Par_Get(u));
                end;
            end;
            bt2.SaveInFile(PChar(AnsiString(GScriptFileTextOut.Par_Get(i))));
        end;
        GScriptTranslateId.CopyFrom(bt);

//        bt.SaveInFile(PChar(AnsiString(GScriptFileTextOut.Par['rus'])));

        Co.Lines.Add('OK');
    except
        on ex:EAbort do begin
            Co.Lines.Add('Error : '+ex.Message);
        end;
        on ex:Exception do begin
            Co.Lines.Add('Error : '+ex.Message);
        end;
    end;

    arconst:=nil;
    code.Free;
    ca.Free;
    svar.Free;
    svar_g.Free;
    bt.Free;
    bt2.Free;
    bsz.Free;
    bs.Free;
    lidialoganswer.Free;
    lidialogmsg.Free;
    listate.Free;
    ligroup.Free;
    listar.Free;
    li2.Free;
    li.Free;
end;

end.
