unit EC_Str;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils;

function GetCountParEC(str:WideString; raz:WideString):integer;
function GetSmeParEC(str:WideString; np:integer; raz:WideString):integer;
function GetLenParEC(str:WideString; smepar:integer; raz:WideString):integer;
function GetStrParEC(str:WideString; np:integer; raz:WideString):WideString; overload;
function GetStrParEC(str:WideString; nps,npe:integer; raz:WideString):WideString; overload;

function GetComEC(s:WideString):WideString;
function GetStrNoComEC(s:WideString):WideString;

function IsIntEC(str:WideString):boolean;
function StrToIntEC(str:WideString):integer;
function StrToFloatEC(str:WideString):single;
function FloatToStrEC(zn:double):WideString;
function StringReplaceEC(str:WideString; sold:WideString; snew:WideString):WideString;

function AddStrPar(str,par:WideString):WideString;

function BooleanToStr(zn:boolean):WideString;

function BuildStr(tstr:string; maxlen:integer):string;
function CharToOemEx(tstr:string):string;

function TrimEx(tstr:WideString):WideString;

function TagSkipEC(tstr:PWideChar; tstrlen:integer):integer;

function File_Name(path:WideString):WideString;
function File_Ext(path:WideString):WideString;
function File_Path(path:WideString):WideString;

type
TStringsElEC = class(TObject)
    FPrev:TStringsElEC;
    FNext:TStringsElEC;

    FStr:WideString;
end;

TStringsEC = class(TObject)
    protected
        FFirst:TStringsElEC;
        FLast:TStringsElEC;

        FPointer:TStringsElEC;
    public
        constructor Create;
        destructor Destroy; override;

        procedure CopyData(des:TStringsEC);

        procedure Clear;

    protected
        function El_Add: TStringsElEC; overload;
        procedure El_Add(el:TStringsElEC); overload;
        function El_Insert(perel:TStringsElEC): TStringsElEC; overload;
        procedure El_Insert(perel,el:TStringsElEC); overload;
        procedure El_Del(el:TStringsElEC);
        function El_Get(i:integer): TStringsElEC;
        function El_GetEx(i:integer): TStringsElEC;
    public
        function GetCount:integer;
        procedure SetCount(c:integer);
        property Count:integer read GetCount write SetCount;

        function GetItem(i:integer): WideString;
        procedure SetItem(i:integer; zn:WideString);
        property Item[zn:integer]:WideString read GetItem write SetItem;
        property Strings[zn:integer]:WideString read GetItem write SetItem;

        function Find(str:WideString):integer;

        procedure Add(zn:WideString); overload;
        procedure Add(zn:PWideChar; len:integer); overload;
        procedure Insert(i:integer; zn:WideString);
        procedure Delete(i:integer);

        function Get: WideString;
        function GetInc: WideString;
        function GetDec: WideString;
        function TestEnd: boolean;
        function TestFirst: boolean;
        function TestLast: boolean;
        procedure PointerFirst;
        procedure PointerLast;
        procedure PointerNext;
        procedure PointerPrev;
        function PointerGet:integer;
        procedure PointerSet(i:integer);
        property Pointer:integer read PointerGet write PointerSet;

        procedure SetTextStr(str:WideString);
        function GetTextStr:WideString;
        property Text:WideString read GetTextStr write SetTextStr;
end;

implementation

uses EC_Mem;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TStringsEC.Create;
begin
    inherited Create;
end;

destructor TStringsEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TStringsEC.CopyData(des:TStringsEC);
var
    el:TStringsElEC;
begin
    des.Clear;
    el:=FFirst;
    while el<>nil do begin
        des.Add(el.FStr);
        el:=el.FNext;
    end;
end;

procedure TStringsEC.Clear;
begin
    while FFirst<>nil do El_Del(FLast);
    FPointer:=nil;
end;

function TStringsEC.El_Add: TStringsElEC;
var
    el:TStringsElEC;
begin
    el:=TStringsElEC.Create;
    El_Add(el);
    Result:=el;
end;

procedure TStringsEC.El_Add(el:TStringsElEC);
begin
    if FLast<>nil then FLast.FNext:=el;
	el.FPrev:=FLast;
	el.FNext:=nil;
	FLast:=el;
	if FFirst=nil then FFirst:=el;
end;

function TStringsEC.El_Insert(perel:TStringsElEC): TStringsElEC;
var
    el:TStringsElEC;
begin
    el:=TStringsElEC.Create;

    El_Insert(el);

    Result:=el;
end;

procedure TStringsEC.El_Insert(perel,el:TStringsElEC);
begin
    if perel=nil then begin
        El_Add(el);
    end else begin
		el.FPrev:=perel.FPrev;
		el.FNext:=perel;
		if perel.FPrev<>nil then perel.FPrev.FNext:=el;
		perel.FPrev:=el;
		if perel=FFirst then FFirst:=el;
    end;
end;

procedure TStringsEC.El_Del(el:TStringsElEC);
begin
	if el.FPrev<>nil then el.FPrev.FNext:=el.FNext;
	if el.FNext<>nil then el.FNext.FPrev:=el.FPrev;
	if FLast=el then FLast:=el.FPrev;
	if FFirst=el then FFirst:=el.FNext;

    el.Free;
end;

function TStringsEC.El_Get(i:integer): TStringsElEC;
var
    el:TStringsElEC;
begin
    el:=FFirst;
    while el<>nil do begin
        if i=0 then begin
            Result:=el;
            Exit;
        end;
        Dec(i);
        el:=el.FNext;
    end;
    raise Exception.Create('TStringsEC.El_Get. i=' + IntToStr(i));
end;


function TStringsEC.El_GetEx(i:integer): TStringsElEC;
var
    el:TStringsElEC;
begin
    if i<0 then raise Exception.Create('TStringsEC.El_GetEx. i=' + IntToStr(i));
    el:=FFirst;
    while el<>nil do begin
        if i=0 then begin
            Result:=el;
            Exit;
        end;
        Dec(i);
        el:=el.FNext;
    end;
    while i>=0 do begin
        El_Add;
        Dec(i);
    end;
    Result:=FLast;
end;

function TStringsEC.GetCount:integer;
var
    el:TStringsElEC;
begin
    el:=FFirst;
    Result:=0;
    while el<>nil do begin
        Inc(Result);
        el:=el.FNext;
    end;
end;

procedure TStringsEC.SetCount(c:integer);
var
    cc,i:integer;
begin
    if c<=0 then begin
        Clear;
        Exit;
    end;
    cc:=c-Count;
    if cc>0 then begin
        for i:=0 to cc-1 do El_Add;
    end else begin
        for i:=0 to cc-1 do begin
            if FLast=FPointer then FPointer:=FPointer.FPrev;
            El_Del(FLast);
        end;
    end;
end;

function TStringsEC.GetItem(i:integer): WideString;
begin
    Result:=El_GetEx(i).FStr;
end;

procedure TStringsEC.SetItem(i:integer; zn:WideString);
begin
    El_GetEx(i).FStr:=zn;
end;

function TStringsEC.Find(str:WideString):integer;
var
    el:TStringsElEC;
    i:integer;
begin
    el:=FFirst;
    i:=0;
    while el<>nil do begin
        if el.FStr=str then begin Result:=i; Exit; end;
        inc(i);
        el:=el.FNext;
    end;
    Result:=-1;
end;

procedure TStringsEC.Add(zn:WideString);
begin
    El_Add.FStr:=zn;
end;

procedure TStringsEC.Add(zn:PWideChar; len:integer);
var
    el:TStringsElEC;
begin
    el:=El_Add;
    if len>0 then begin
        SetLength(el.FStr,len+1);
        CopyMemory(PWideChar(el.FStr),zn,len*2);
        el.FStr[len+1]:=#0;
    end;
end;

procedure TStringsEC.Insert(i:integer; zn:WideString);
begin
    if (i<0) or (i>=Count) then begin
        Add(zn);
    end else begin
        El_Insert(El_Get(i)).FStr:=zn;
    end;
end;

procedure TStringsEC.Delete(i:integer);
var
    el:TStringsElEC;
begin
    el:=El_Get(i);
    if el=FPointer then begin
        FPointer:=el.FNext;
        if FPointer=nil then FPointer:=el.FPrev;
    end;
    El_Del(el);
end;

function TStringsEC.Get: WideString;
begin
    if FPointer=nil then raise Exception.Create('TStringsEC.Get.');

    Result:=FPointer.FStr;
end;

function TStringsEC.GetInc: WideString;
begin
    if FPointer=nil then raise Exception.Create('TStringsEC.Get.');

    Result:=FPointer.FStr;

    FPointer:=FPointer.FNext;
end;

function TStringsEC.GetDec: WideString;
begin
    if FPointer=nil then raise Exception.Create('TStringsEC.Get.');

    Result:=FPointer.FStr;

    FPointer:=FPointer.FPrev;
end;

function TStringsEC.TestEnd: boolean;
begin
    if FPointer<>nil then Result:=false else Result:=true;
end;

function TStringsEC.TestFirst: boolean;
begin
    if FPointer.FPrev<>nil then Result:=false else Result:=true;
end;

function TStringsEC.TestLast: boolean;
begin
    if FPointer.FNext<>nil then Result:=false else Result:=true;
end;

procedure TStringsEC.PointerFirst;
begin
    FPointer:=FFirst;
end;

procedure TStringsEC.PointerLast;
begin
    FPointer:=FLast;
end;

procedure TStringsEC.PointerNext;
begin
    FPointer:=FPointer.FNext;
end;

procedure TStringsEC.PointerPrev;
begin
    FPointer:=FPointer.FPrev;
end;

function TStringsEC.PointerGet:integer;
var
    el:TStringsElEC;
begin
    el:=FPointer;
    Result:=-1;
    while el<>nil do begin
        Inc(Result);
        FPointer:=el.FPrev;
    end;
end;

procedure TStringsEC.PointerSet(i:integer);
begin
    if i<0 then FPointer:=nil else FPointer:=El_Get(i);
end;

procedure TStringsEC.SetTextStr(str:WideString);
var
    P,Start:PWideChar;
begin
    Clear;
    P := PWideChar(str);
    if P <> nil then
      while P^ <> #0 do
      begin
        Start := P;
        while not ((P^=#0) or (P^=#10) or (P^=#13)) do Inc(P);
        Add(Start,P-Start);
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
end;

function TStringsEC.GetTextStr:WideString;
var
    el:TStringsElEC;
begin
    el:=FFirst;
    Result:='';
    while el<>nil do begin
        Result:=Result+el.FStr+#13+#10;
        el:=el.FNext;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function GetCountParEC(str:WideString; raz:WideString):integer;
var
    len,lenraz:DWORD;
    i,u,count:integer;
begin
    count:=1;
    len:=Length(str);
    lenraz:=Length(raz);
    if len<1 then begin
        Result:=0;
        Exit;
    end;
    for i:=1 to len do begin
        for u:=1 to lenraz do begin
           if str[i]=raz[u] then begin
               Inc(count);
               break;
           end;
        end;
    end;
    Result:=count;
end;

function GetSmeParEC(str:WideString; np:integer; raz:WideString):integer;
var
    len,lenraz:DWORD;
    i,u:integer;
begin
    if np>0 then begin
        len:=Length(str);
        lenraz:=Length(raz);
        for i:=1 to len do begin
            for u:=1 to lenraz do begin
               if str[i]=raz[u] then begin
                   Dec(np);
                   if np=0 then begin
                       Result:=i+1;
                       Exit;
                   end;
                   break;
               end;
            end;
        end;
        raise Exception.Create('GetSmeParEC. Str=' + str + ' np=' + IntToStr(np) + ' raz=' + raz);
    end;
    Result:=1;
end;

function GetLenParEC(str:WideString; smepar:integer; raz:WideString):integer;
var
    len,lenraz:DWORD;
    i,u:integer;
begin
    len:=Length(str);
    lenraz:=Length(raz);
    for i:=smepar to len do begin
        for u:=1 to lenraz do begin
            if str[i]=raz[u] then begin
                Result:=i-smepar;
                Exit;
            end;
        end;
    end;
    Result:=integer(len)-smepar+1;
end;

function GetStrParEC(str:WideString; np:integer; raz:WideString):WideString;
var
    sme:integer;
begin
    sme:=GetSmeParEC(str,np,raz);
    Result:=Copy(str,sme,GetLenParEC(str,sme,raz));
end;

function GetStrParEC(str:WideString; nps,npe:integer; raz:WideString):WideString;
var
    sme1,sme2:integer;
begin
	sme1:=GetSmeParEC(str,nps,raz);
	sme2:=GetSmeParEC(str,npe,raz);
	sme2:=sme2+GetLenParEC(str,sme2,raz);
    Result:=Copy(str,sme1,sme2-sme1);
end;

function GetComEC(s:WideString):WideString;
var
    compos,i:integer;
begin
    compos:=Pos('//',s);
    if compos<1 then begin
        Result:='';
        Exit;
    end;
    i:=compos-1;
    while i>=1 do begin
        if (s[i]<>WideChar(32)) and (s[i]<>WideChar(9)) and (s[i]<>WideChar($0d)) and (s[i]<>WideChar($0a)) then break;
        Dec(i);
    end;
    Result:=Copy(s,i,Length(s)-(i));
end;

function GetStrNoComEC(s:WideString):WideString;
var
    compos:integer;
begin
    compos:=Pos('//',s);
    if compos<1 then begin
        Result:=s;
        Exit;
    end else if compos=1 then begin
        Result:='';
        Exit;
    end;
    Result:=TrimRight(Copy(s,1,compos-1));
end;

function IsIntEC(str:WideString):boolean;
var
    len,i:integer;
begin
    len:=Length(str);
    if len<1 then begin
        Result:=false;
        Exit;
    end;
    for i:=1 to len do begin
        if ((str[i]<'0') or (str[i]>'9')) and (str[i]<>'-') then begin
            Result:=false;
            Exit;
        end;
    end;
    Result:=true;
end;

function StrToIntEC(str:WideString):integer;
var
    len,i:integer;
begin
    Result:=0;
    len:=Length(str);
    for i:=1 to len do begin
        if (integer(str[i])>=integer('0')) and (integer(str[i])<=integer('9')) then begin
            Result:=Result*10+StrToInt(str[i]);
        end;
    end;
end;

function StrToFloatEC(str:WideString):single;
var
    i,len:integer;
    zn,tra:single;
    ch:integer;
begin
	len:=Length(str);
	if(len<1) then begin Result:=0; Exit; End;

	zn:=0.0;

    for i:=0 to len-1 do begin
		ch:=integer(str[i+1]);
		if (ch>=integer('0')) and (ch<=integer('9')) then zn:=zn*10.0+(ch-integer('0'))
		else if (ch=integer('.')) then break;
	end;
	inc(i);
	tra:=10.0;
    while i<len do begin
		ch:=integer(str[i+1]);
		if (ch>=integer('0')) and (ch<=integer('9')) then begin
			zn:=zn+((ch-integer('0')))/tra;
			tra:=tra*10.0;
		end;
        inc(i);
	end;
    for i:=0 to len-1 do if integer(str[i+1])=integer('-') then begin zn:=-zn; break; end;

    Result:=zn;
end;

function FloatToStrEC(zn:double):WideString;
var
    oldch:char;
begin
    oldch:=DecimalSeparator;
    DecimalSeparator:='.';
    Result:=FloatToStr(zn);
    DecimalSeparator:=oldch;
end;

function StringReplaceEC(str:WideString; sold:WideString; snew:WideString):WideString;
var
    strlen,soldlen,i,u:integer;
begin
    Result:='';
    strlen:=Length(str);
    soldlen:=Length(sold);
    if (strlen<soldlen) or (strlen<1) or (soldlen<1) then begin Result:=str; Exit; end;

    i:=0;
    while i<=strlen-soldlen do begin
        u:=0;
        while u<soldlen do begin
            if str[i+u+1]<>sold[u+1] then break;
            inc(u);
        end;

        if u>=soldlen then begin
            Result:=Result+snew;
            i:=i+soldlen;
        end else begin
            Result:=Result+str[i+1];
            inc(i);
        end;
    end;

    if i<strlen then begin
        Result:=Result+Copy(str,i+1,strlen-i);
    end;
end;

function AddStrPar(str,par:WideString):WideString;
begin
    if GetCountParEC(str,'?')<2 then begin
        Result:=str + '?' + par;
    end else begin
        Result:=str + '&' + par;
    end;
end;

function BooleanToStr(zn:boolean):WideString;
begin
    if zn=false then Result:='False' else Result:='True';
end;

function BuildStr(tstr:string; maxlen:integer):string;
const
    addstr='                                                                                                                                                                                                                                                               ';
var
    tlen:integer;
begin
    tlen:=Length(tstr);
    if tlen>maxlen then begin
        Result:=Copy(tstr,1,maxlen);
    end else if tlen=maxlen then begin
        Result:=tstr;
    end else begin
        Result:=tstr+Copy(addstr,1,maxlen-tlen);
    end;
end;

function CharToOemEx(tstr:string):string;
begin
    CharToOemBuff(PChar(tstr),PChar(tstr),Length(tstr));
    Result:=tstr;
end;

function TrimEx(tstr:WideString):WideString;
var
    zn,lensou,tstart,tend:integer;
begin
    lensou:=Length(tstr);

    tstart:=0;
    while tstart<lensou do begin
        zn:=Ord(tstr[tstart+1]);
        if (zn<>$20) and (zn<>$09) and (zn<>$0d) and (zn<>$0a) and (zn<>$0) then break;
        inc(tstart);
    end;
    if tstart>=lensou then Result:='';

    tend:=lensou-1;
    while tend>=0 do begin
        zn:=Ord(tstr[tend+1]);
        if (zn<>$20) and (zn<>$09) and (zn<>$0d) and (zn<>$0a) and (zn<>$0) then break;
        dec(tend);
    end;
    if tend<tstart then Result:='';

    SetLength(Result,tend-tstart+1);
    CopyMemory(PWideChar(Result),PAdd(PWideChar(tstr),tstart*2),(tend-tstart+1)*2);
end;

function TagSkipEC(tstr:PWideChar; tstrlen:integer):integer;
var
    i:integer;
begin
    Result:=0;
    if (tstrlen<2) or (tstr[0]<>'<') then Exit;
    if tstr[1]='<' then begin Result:=1; Exit; end;
    i:=1;
    while i<tstrlen do if tstr[i]='>' then break else inc(i);
    if i>=tstrlen then Exit;
    Result:=i+1;
end;

function File_Name(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    Result:=GetStrParEC(path,cnt-1,'\/');
    cnt:=GetCountParEC(Result,'.');
    if cnt>1 then begin
        Result:=GetStrParEC(Result,0,cnt-2,'.');
    end;
end;

function File_Ext(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    Result:=GetStrParEC(path,cnt-1,'\/');
    cnt:=GetCountParEC(Result,'.');
    if cnt>1 then begin
        Result:=GetStrParEC(Result,cnt-1,'.');
    end else Result:='';
end;

function File_Path(path:WideString):WideString;
var
    cnt:integer;
begin
    cnt:=GetCountParEC(path,'\/');
    if cnt<1 then begin Result:=''; Exit; End;
    Result:=GetStrParEC(path,0,cnt-2,'\/');
end;

end.
