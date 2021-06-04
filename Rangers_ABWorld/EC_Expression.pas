// Надо сделать :
// - внешние переменные одинаковый индекс
// - в функции переменное число аргументов
// - el.FNext=nil избавиться
// - отмена изменений
// - правильная вставка из клипборда
// - оптемезировать не выполняемое
// - оптимезация прыжка на пустую инструкцию
// - // в дебуг режиме правильно убирать брэк поинты

unit EC_Expression;

interface

uses Windows,SysUtils,Classes,EC_Buf;

// 1001 - catch or finally in try

function HexToStrEXP(zn:DWORD):WideString;
function BinToStrEXP(zn:DWORD):WideString;
function SmeToLineAndChar(tstr:WideString; tsme:integer; enteradd:integer; var tline:integer; var tchar:integer):boolean;

type
TVarEC=class;
TVarArrayEC=class;
TCodeProcessEC=class;
TCodeAnalyzerEC=class;
TCodeDebugEC=class;
TCodeEC=class;

// return   = 0 - ok
//          = 1 - repeat
//          = 2 - file not found
//          = 3 - error
FunctionIncludeUnitEC = function(in_unit:integer; in_unitname:WideString; in_canrepeat:boolean; var out_unit:integer; out_ca:TCodeAnalyzerEC):integer;

FunctionExpressionEC = procedure(av:array of TVarEC; code:TCodeEC);
ExceptionExpressionEC = class(Exception);

VariableTypeEC=(vtUnknown,vtInt,vtDW,vtFloat,vtStr,vtExternFun,vtLibraryFun,vtFun,vtClass,vtArray,vtRef);
TVarEC=class(TObject)
    protected
        FName:WideString;
        FVType:VariableTypeEC;
        FVInt:integer;
        FVDW:DWORD;
        FVFloat:double;
        FVStr:WideString;
        FVExternFun:FunctionExpressionEC;
        FVLibraryFun:array of DWORD;
        FVFun:TCodeEC;
        FVClass:TCodeEC;
        FVArray:TVarArrayEC;
        FVRef:TVarEC;
    public
        constructor Create(zn:VariableTypeEC=vtUnknown);
        destructor Destroy; override;

        property Name:WideString read FName write FName;

        procedure ChangeVType(zn:VariableTypeEC);
        procedure SetVType(zn:VariableTypeEC);
        function GetVType:VariableTypeEC;
        procedure CopyFrom(sou:TVarEC);
        property VType:VariableTypeEC read GetVType write SetVType;
        property RealVType:VariableTypeEC read FVType;

        function GetUnknown:boolean;
        function GetInt:integer;
        function GetDW:DWORD;
        function GetFloat:double;
        function GetStr:WideString;
        function GetExternFun:FunctionExpressionEC;
        function GetFun:TCodeEC;
        function GetClass:TCodeEC;
        function GetArray:TVarArrayEC;
        function GetRef:TVarEC;

        procedure SetInt(zn:integer);
        procedure SetDW(zn:DWORD);
        procedure SetFloat(zn:double);
        procedure SetStr(zn:WideString);
        procedure SetExternFun(tfun:FunctionExpressionEC);
        procedure SetFun(zn:TCodeEC);
        procedure SetClass(zn:TCodeEC);
        procedure SetArray(zn:TVarArrayEC);
        procedure SetRef(zn:TVarEC);

        property VUnknown:boolean read GetUnknown;
        property VInt:integer read GetInt write SetInt;
        property VDW:DWORD read GetDW write SetDW;
        property VFloat:double read GetFloat write SetFloat;
        property VStr:WideString read GetStr write SetStr;
        property VExternFun:FunctionExpressionEC read GetExternFun write SetExternFun;
        property VFun:TCodeEC read GetFun write SetFun;
        property VClass:TCodeEC read GetClass write SetClass;
        property VArray:TVarArrayEC read GetArray write SetArray;
        property VRef:TVarEC read GetRef write SetRef;

        function GetByRef:TVarEC;

        procedure ArrayInit(ar:array of integer);
        procedure ArrayClear;

        procedure OAdd(s1,s2:TVarEC);
        procedure OSub(s1,s2:TVarEC);
        procedure OMul(s1,s2:TVarEC);
        procedure ODiv(s1,s2:TVarEC);
        procedure OMod(s1,s2:TVarEC);
        procedure OBitAnd(s1,s2:TVarEC);
        procedure OBitOr(s1,s2:TVarEC);
        procedure OBitXor(s1,s2:TVarEC);
        procedure OAnd(s1,s2:TVarEC);
        procedure OOr(s1,s2:TVarEC);
        procedure OShl(s1,s2:TVarEC);
        procedure OShr(s1,s2:TVarEC);
        procedure OEqual(s1,s2:TVarEC);
        procedure ONotEqual(s1,s2:TVarEC);
        procedure OLess(s1,s2:TVarEC);
        procedure OMore(s1,s2:TVarEC);
        procedure OLessEqual(s1,s2:TVarEC);
        procedure OMoreEqual(s1,s2:TVarEC);

        procedure OMinus(sou:TVarEC);
        procedure OBitNot(sou:TVarEC);
        procedure ONot(sou:TVarEC);

        procedure Assume(sou:TVarEC);
        function Equal(sou:TVarEC):boolean;
        function NotEqual(sou:TVarEC):boolean;
        function Less(sou:TVarEC):boolean;
        function More(sou:TVarEC):boolean;
        function LessEqual(sou:TVarEC):boolean;
        function MoreEqual(sou:TVarEC):boolean;

        function IsTrue:boolean;

        procedure Save(bd:TBufEC);
        procedure Load(bd:TBufEC);
end;

TVarArrayEC=class(TObject)
    protected
        FCount:integer;
        FItem:Pointer;
        FIndex:Pointer; // sort by name
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;
        procedure ClearNoFree;

        procedure CopyFrom(sou:TVarArrayEC);

        property Count:integer read FCount;

    protected
        function FindIndex(tname:WideString):integer;
        function FindInsertIndex(tname:WideString):integer;

        procedure SetIndex(no:integer; el:integer);
        function GetIndex(no:integer):integer;
        property Indexs[no:integer]:integer read GetIndex write SetIndex;
        function IndexToVar(no:integer):TVarEC;
        function VarToIndex(el:TVarEC):integer; cdecl;

        function ItemToIndex(no:integer):integer;
    public

        function GetItem(no:integer):TVarEC;
        procedure SetItem(no:integer; el:TVarEC);
        property Items[no:integer]:TVarEC read GetItem write SetItem;

        function GetItemTB(no:integer):TVarEC;
        procedure SetItemTB(no:integer; el:TVarEC);
        property ItemsTB[no:integer]:TVarEC read GetItemTB write SetItemTB;

        function IndexOf(el:TVarEC):integer;

        function GetVar(tname:WideString):TVarEC;
        function GetVarNE(tname:WideString):TVarEC;

        procedure ChangeName(no:integer);

        procedure Del(no:integer); overload;
        procedure Del(el:TVarEC); overload;
        procedure Del(tname:WideString); overload;

        procedure Add(el:TVarEC); overload;
        procedure Insert(tono:integer; el:TVarEC); overload;

        function Add(tname:WideString; vtype:VariableTypeEC=vtUnknown):TVarEC; overload;
        function Insert(tono:integer; tname:WideString; vtype:VariableTypeEC=vtUnknown):TVarEC; overload;

        procedure AddStdFunction;

        procedure Save(bd:TBufEC);
        procedure Load(bd:TBufEC);
        procedure LoadAdd(bd:TBufEC);
end;

caeTypeEC =(caeEnter,
            caeOpen1,  		// =	(
            caeClose1,		// =	)
            caeOpen2,		// =	{
            caeClose2,		// =	}
            caeOpen3,		// =	[
            caeClose3,		// =	]
            caeOpen4,		// =	/*
            caeClose4,		// =	*/
            caeCom,         // =    //
            caePoint,		// =	.
            caePointer,		// =	->
            caeAdd,	    	// =	+
            caeSub,		    // =	-
            caeMul,		    // =	*
            caeDiv,		    // =	/
            caeMod,         // =    %
            caeBitAnd,      // =    &
            caeBitOr,       // =    |
            caeBitXor,      // =    ^
            caeBitNot,      // =    ~
            caeAnd,         // =    &&
            caeOr,          // =    ||
            caeNot,         // =    !
            caeShl,         // =    <<
            caeShr,         // =    >>
            caeAssume,		// =	=
            caeEqual,       // =    ==
            caeNotEqual,    // =    !=
            caeLess,        // =    <
            caeMore,        // =    >
            caeLessEqual,   // =    <=
            caeMoreEqual,   // =    >=
            caeSemicolon,	// =	;
            caeColon,		// =	:
            caeComma,		// =	,
            caeSpace,       // =    space,tab
            caeStr, 		//		FStr
            caeName,  		//		FStr
            caeConvertCom   //
            );

TCodeAnalyzerUnitEC = class(TObject)
    public
        FPrev:TCodeAnalyzerUnitEC;
        FNext:TCodeAnalyzerUnitEC;

        FType:caeTypeEC;
        FSme,FLen:integer;
        FStr:WideString;
end;

TCodeAnalyzerEC = class(TObject)
    public
        FFirstFree:TCodeAnalyzerUnitEC;
        FLastFree:TCodeAnalyzerUnitEC;

        FFirst:TCodeAnalyzerUnitEC;
        FLast:TCodeAnalyzerUnitEC;
    public
        constructor Create;
        destructor Destroy; override;

        procedure FreeClear;
        procedure FreeAddGroup(cnt:integer);
        function  FreeAlloc:TCodeAnalyzerUnitEC;
        procedure FreeFree(el:TCodeAnalyzerUnitEC);

        procedure Clear;
        function UnitAdd:TCodeAnalyzerUnitEC;
        procedure UnitDel(el:TCodeAnalyzerUnitEC);

        procedure BuildAdd(wstr:WideString; startstr:integer; enteradd:integer=0);
        procedure Build(wstr:WideString; enteradd:integer=0);

		function BuildStr(strshowquate:boolean=false; ustart:TCodeAnalyzerUnitEC=nil; uend:TCodeAnalyzerUnitEC=nil):WideString;

		function TestOpenClose:WideString;

        procedure DelSpace;
        procedure DelEnter;
        procedure DelCom;
        procedure ConvertCom;
end;

eieTypeEC=(eieMinus,eieAdd,eieSub,eieMul,eieDiv,eieMod,eieBitAnd,eieBitOr,eieBitXor,eieBitNot,eieAnd,eieOr,eieNot,eieShl,eieShr,eieLess,eieMore,eieEqual,eieNotEqual,eieLessEqual,eieMoreEqual,eieAssume,eieFun,eieArray);

TExpressionInstrEC=class(TObject)
    public
        FType:eieTypeEC;
                    // eieMinus     - o0=-o1
                    // eieBitNot    - o0=~o1
                    // eieNot       - o0=!o1
					// eieAdd       - o0=o1+o2
					// eieSub       - o0=o1-o2
					// eieMul       - o0=o1*o2
					// eieDiv       - o0=o1/o2
					// ....
					// eieFun - o0=o1(o2,o3,o4...)
                    // eieArray - o0=o1[o2,o3...]
        FCount:integer;
        FIndex:array of integer;
    public
        destructor Destroy; override;

        procedure InitInstr(zn:caeTypeEC);

        procedure CopyFrom(sou:TExpressionInstrEC);
end;

ExpressionVarTypeEC=(evteExtern,evteTemp,evteArrayResult);

TExpressionVarEC=class(TObject)
    public
        FType:ExpressionVarTypeEC;
        FName:WideString;
        FPath:array of WideString;
        FVar:TVarEC;
    public
        destructor Destroy; override;

        procedure CopyFrom(sou:TExpressionVarEC);

        function BuildPath:boolean;

        function Name:WideString;

        function GetVar(newtype:VariableTypeEC=vtUnknown):TVarEC;
end;

TExpressionEC=class(TObject)
    private
        FVarCount:integer;
        FVar:Pointer;

        FInstrCount:integer;
        FInstr:Pointer;
        FInstrExtern:boolean;

        FRet:integer;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure CopyFrom(sou:TExpressionEC);
        procedure CopyFromFast(sou:TExpressionEC);

        function VarAdd:integer;
        procedure VarDel(no:integer);
        function EVarGet(no:integer):TExpressionVarEC; cdecl;
        procedure EVarSet(no:integer; zn:TExpressionVarEC); cdecl;
        property EVar[no:integer]:TExpressionVarEC read EVarGet write EVarSet;

        function InstrAdd:integer;
        procedure InstrDel(no:integer);
        function EInstrGet(no:integer):TExpressionInstrEC; cdecl;
        procedure EInstrSet(no:integer; zn:TExpressionInstrEC); cdecl;
        property Instr[no:integer]:TExpressionInstrEC read EInstrGet write EInstrSet;

        function Compiler(ca:TCodeAnalyzerEC; curclass:TCodeEC=nil; castart:TCodeAnalyzerUnitEC=nil; caend:TCodeAnalyzerUnitEC=nil; endcompl:PDWORD=nil):WideString;
        procedure Link(va:TVarArrayEC);
        procedure LinkAll(va:TVarArrayEC);
        procedure UnLink(va:TVarArrayEC);
        procedure Run(cpr:TCodeProcessEC=nil; code:TCodeEC=nil; cd:TCodeDebugEC=nil);
        function Return:TVarEC;

        function EndCode(level:WideString=''):WideString;
end;

CodeUnitTypeEC=(cuteEmpty,cuteExpression,cuteIf,cuteJump,cuteExit,cuteTry,cuteTryEnd,cuteThrow{,cuteThrowEnd});

TCodeUnitEC=class(TObject)
    public
        FPrev:TCodeUnitEC;
        FNext:TCodeUnitEC;

        FType:CodeUnitTypeEC;
        FExperssion:TExpressionEC;
        FJump:TCodeUnitEC;
        FVar:TVarEC;
        FSme,FLen,FUnit:integer;

        FBP:boolean;
    public
        destructor Destroy; override;
end;

TCodeDebugST = (cdst_BP,cdst_StepIn,cdst_StepNext,cdst_StepOut);

PCodeProcessTryEC=^TCodeProcessTryEC;
TCodeProcessTryEC=record
    FCode:TCodeEC;
    FUnit:TCodeUnitEC;
end;

PCodeProcessThrowEC=^TCodeProcessThrowEC;
TCodeProcessThrowEC=record
    FVar:TVarEC;
end;

TCodeProcessEC=class(TObject)
    private
        FTry:TList;
        FThrow:TList;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure TryAdd(code:TCodeEC; cu:TCodeUnitEC);
        procedure TryDelLast;
        function TryGetLast:PCodeProcessTryEC;

        procedure ThrowAdd(tv:TVarEC);
        procedure ThrowAddNotCreate(tv:TVarEC);
        procedure ThrowDelLast;
        function ThrowGetLast:PCodeProcessThrowEC;

        procedure TestError;
end;

TCodeDebugEC=class(TObject)
    private
        FStop:boolean;
        FEventBreak:THandle;
        FEventBPEnd:THandle;
        FStopType:TCodeDebugST;
        FStopUnit:TCodeUnitEC;
        FStopLastCode:TCodeEC;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Break;
        function IsStop:boolean;
        procedure Run(typestop:TCodeDebugST);
        procedure RunStart(typestop:TCodeDebugST);
        procedure Stop;

        property StopUnit:TCodeUnitEC read FStopUnit;
end;

TCodeEC=class(TObject)
    private
        FParent:TCodeEC;
        FIsClass:boolean;
        FClassName:WideString;

        FFirst:TCodeUnitEC;
        FLast:TCodeUnitEC;

        FLocalVar:TVarArrayEC;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;

        procedure CopyFrom(sou:TCodeEC);
        procedure CopyFromFast(sou:TCodeEC);

        property LocalVar:TVarArrayEC read FLocalVar;

        function FindClassMember(name:WideString):TVarEC;

        function UnitAdd:TCodeUnitEC;
        function UnitInsert(perel:TCodeUnitEC):TCodeUnitEC;
        procedure UnitDel(el:TCodeUnitEC);

        function UnitToNum(el:TCodeUnitEC):integer;

        function Compiler(ca:TCodeAnalyzerEC; codeunit:integer; funinclude:FunctionIncludeUnitEC=nil; el:TCodeAnalyzerUnitEC=nil; elendcomp:PDWORD=nil; curclass:TCodeEC=nil):WideString;
        function CompilerR(ca:TCodeAnalyzerEC; codeunit:integer; funinclude:FunctionIncludeUnitEC; el:TCodeAnalyzerUnitEC; insertto:TCodeUnitEC; elendcomp:PDWORD; elcontinue:PDWORD; opBreak:TCodeUnitEC; opContinue:TCodeUnitEC; curclass:TCodeEC):WideString;
        procedure Link(va:TVarArrayEC);
        procedure LinkAll(va:TVarArrayEC);
        procedure LinkClass;
        procedure UnLink(va:TVarArrayEC);
        procedure Run(cpr:TCodeProcessEC);
        procedure RunDebug(cpr:TCodeProcessEC; cd:TCodeDebugEC);
        function EndCode(level:WideString=''):WideString;

        function BPNearest(codeunit:integer; tsme:integer; tsmemin:integer; tsmemax:integer):TCodeUnitEC; overload;
        function BPNearestFun(codeunit:integer; tsme:integer; tsmemin:integer; tsmemax:integer):TCodeUnitEC; overload;
        procedure BPAllEqual(el:TCodeUnitEC; li:TList);
        procedure BPDeleteAll;
        procedure BPFindAll(list:TList);
end;

implementation

uses Math;

type
cutTypeEC=(cutConstInt,cutConstDW,cutConstFloat,cutConstStr,cutOperator,cutOperatorUnary,cutOpen,cutClose,cutOpenArray,cutCloseArray,cutName,cutFun,cutArray,cutVar,cutComma,cutAssume);

TCompilerUnitEC=class(TObject)
    public
        FPrev:TCompilerUnitEC;
        FNext:TCompilerUnitEC;

        FType:cutTypeEC;
        FOper:caeTypeEC;
        FStr:WideString;
        FVar:integer;

        FVInt:integer;
        FVDW:DWORD;
        FVFloat:double;

        FSme,FLen:integer;
end;

TCompilerEC=class(TObject)
    public
        FFirst:TCompilerUnitEC;
        FLast:TCompilerUnitEC;
    public
        constructor Create;
        destructor Destroy; override;

        procedure Clear;
        function UnitAdd:TCompilerUnitEC;
        procedure UnitDel(el:TCompilerUnitEC);

        function GetOper:TCompilerUnitEC;
        function GetArray:TCompilerUnitEC;
        function GetFun:TCompilerUnitEC;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
function TrimEXP(tstr:WideString):WideString;
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
//    CopyMemory(PWideChar(Result),PAdd(PWideChar(tstr),tstart*2),(tend-tstart+1)*2);
    Result:=Copy(tstr,tstart+1,tend-tstart+1);
end;

function StrToIntEXP(str:WideString):integer;
var
    len,i,minus:integer;
begin
    Result:=0;
    len:=Length(str);
    minus:=1;
    for i:=1 to len do begin
        if (integer(str[i])>=integer('0')) and (integer(str[i])<=integer('9')) then begin
            Result:=Result*10+StrToInt(str[i]);
        end else if (str[i]='-') and (i=1) then begin
            minus:=minus*-1;
        end;
    end;
    Result:=minus*Result;
end;

function FloatToStrEXP(zn:double):WideString;
var
    oldch:char;
begin
    oldch:=DecimalSeparator;
    DecimalSeparator:='.';
    Result:=FloatToStr(zn);
    DecimalSeparator:=oldch;
end;

function HexToStrEXP(zn:DWORD):WideString;
const
    ar:array [0..15] of WideChar=('0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f');
begin
    Result:='';
    while(zn<>0) do begin
        Result:=ar[zn-(zn div 16)*16]+Result;
        zn:=zn div 16;
    end;
    if Result='' then Result:='0';
end;

function BinToStrEXP(zn:DWORD):WideString;
begin
    Result:='';
    while(zn<>0) do begin
        Result:=Chr((zn-(zn div 2)*2)+DWORD('0'))+Result;
        zn:=zn div 2;
    end;
    if Result='' then Result:='0';
end;

function SmeToLineAndChar(tstr:WideString; tsme:integer; enteradd:integer; var tline:integer; var tchar:integer):boolean;
var
    i,tlen,no:integer;
begin
    tline:=0;
    tchar:=0;
    tlen:=Length(tstr);
    if (tsme<0) or (tsme>tlen) then begin Result:=False; Exit; end;
    Result:=true;
    i:=0;
    no:=0;
    while i<tlen do begin
        if no=tsme then Exit;
        if (tstr[i+1]=#13) or (tstr[i+1]=#10) then begin
            inc(tline);
            tchar:=0;
            no:=no+enteradd;
            if (tstr[i+1+1]=#13) or (tstr[i+1+1]=#10) then begin inc(i); inc(no); end;
        end else inc(tchar);
        inc(i);
        inc(no);
    end;
end;

function StrToFloatEXP(str:WideString):double;
var
    i,len:integer;
    zn,tra:double;
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

function OnlyIntEXP(tstr:WideString):boolean;
var
    i,len:integer;
begin
    len:=Length(tstr);
    for i:=0 to len-1 do begin
        if ((tstr[i+1]<'0') or (tstr[i+1]>'9')) and ((tstr[i+1]<>'-') or (i>0)) then begin Result:=false; Exit; End;
    end;
    Result:=true;
end;

function IsVarEXP(tstr:WideString):boolean; overload;
begin
    Result:=not OnlyIntEXP(tstr);
end;

function CErrorEXP(tcode,tsme:integer):WideString;
begin
    Result:=IntToStr(tcode)+','+IntToStr(tsme);
end;

function DecodeFloatEXP(var elt:TCodeAnalyzerUnitEC; var zn:double):boolean;
var
    minus:double;
    tzn,expzn:double;
    el:TCodeAnalyzerUnitEC;
    ch:WideChar;
    i,len:integer;
    wstr:WideString;
begin
    el:=elt;
    Result:=false;
    minus:=1;
    if el=nil then Exit;
    if el.FType=caeSub then begin
        minus:=-1;
        el:=el.FNext;
        if el=nil then Exit;
    end;

    if (el.FType<>caeName) or (not OnlyIntEXP(el.FStr)) then Exit;
    zn:=StrToIntEXP(el.FStr);
    el:=el.FNext; if el=nil then Exit;
    if el.FType<>caePoint then Exit;
    el:=el.FNext; if el=nil then Exit;
    if (el.FType<>caeName) then Exit;

    len:=Length(el.FStr);
    tzn:=0;
    i:=0;
    while i<len do begin
        ch:=el.FStr[i+1];
        if (ch>='0') and (ch<='9') then tzn:=tzn*10+(integer(ch)-integer('0'))
        else if (ch='e') or (ch='E') then break
        else Exit;
        inc(i);
    end;
    if (i<1) then Exit;
    zn:=zn+tzn/Power(10,i);

    expzn:=0;
    if i<(len-1) then begin
        wstr:=Copy(el.FStr,i+2,len-i-1);
        if not OnlyIntEXP(wstr) then Exit;
        expzn:=StrToIntEXP(wstr);
        el:=el.FNext;
    end else if i=(len-1) then begin
        el:=el.FNext;
        if (el=nil) or (el.FNext=nil) or (el.FNext.FType<>caeName) or (not OnlyIntEXP(el.FNext.FStr)) then Exit;
        if (el.FType=caeSub) then expzn:=-StrToIntEXP(el.FNext.FStr)
        else if (el.FType=caeAdd) then expzn:=StrToIntEXP(el.FNext.FStr)
        else Exit;
        el:=el.FNext.FNext;
    end else el:=el.FNext;

    if expzn>0 then zn:=zn*power(10,expzn)
    else if expzn<0 then zn:=zn/power(10,-expzn);

    zn:=zn*minus;
    elt:=el;
    Result:=true;
end;

function DecodeIntEXP(var elt:TCodeAnalyzerUnitEC; var zn:integer):boolean;
var
    minus:integer;
    el:TCodeAnalyzerUnitEC;
begin
    el:=elt;
    Result:=false;
    minus:=1;
    if el=nil then Exit;
    if el.FType=caeSub then begin
        minus:=-1;
        el:=el.FNext;
        if el=nil then Exit;
    end;
    if (el.FType<>caeName) or (not OnlyIntEXP(el.FStr)) then Exit;
    zn:=StrToIntEXP(el.FStr);
    el:=el.FNext;

    zn:=zn*minus;
    elt:=el;
    Result:=true;
end;

function DecodeStrEXP(var elt:TCodeAnalyzerUnitEC; var zn:WideString):boolean;
var
    el:TCodeAnalyzerUnitEC;
begin
    el:=elt;
    Result:=false;
    if el=nil then Exit;
    if el.FType<>caeStr then Exit;
    zn:=el.FStr;
    el:=el.FNext;

    elt:=el;
    Result:=true;
end;

function DecodeDWEXP(var elt:TCodeAnalyzerUnitEC; var zn:DWORD):boolean;
var
    el:TCodeAnalyzerUnitEC;
    ch:WideChar;
    len,i:integer;
begin
    zn:=0;
    el:=elt;
    Result:=false;
    if el=nil then Exit;
    if (el.FType<>caeName) then Exit;
    len:=Length(el.FStr);
    if len<2 then Exit;
    ch:=el.FStr[len];
    if (ch='h') or (ch='H') then begin
        for i:=0 to len-2 do begin
            ch:=el.FStr[i+1];
            if (ch>='0') and (ch<='9') then zn:=zn*16+(DWORD(ch)-DWORD('0'))
            else if (ch>='a') and (ch<='f') then zn:=zn*16+(10+DWORD(ch)-DWORD('a'))
            else if (ch>='A') and (ch<='F') then zn:=zn*16+(10+DWORD(ch)-DWORD('A'))
            else Exit;
        end;
    end else if (ch='b') or (ch='B') then begin
        for i:=0 to len-2 do begin
            ch:=el.FStr[i+1];
            if (ch>='0') and (ch<='1') then zn:=zn*2+(DWORD(ch)-DWORD('0'))
            else Exit;
        end;
    end else Exit;
    el:=el.FNext;

    elt:=el;
    Result:=true;
end;

function DecodeVarEXP(var elt:TCodeAnalyzerUnitEC; var zn:WideString):boolean;
begin
    zn:='';
    while (elt.FType=caeName) and IsVarEXP(elt.FStr) do begin
        zn:=zn+elt.FStr;
        elt:=elt.FNext;
        if (elt=nil) or (elt.FType<>caePoint) then break;
        zn:=zn+'.';
        elt:=elt.FNext;
        if (elt=nil) or (not ((elt.FType=caeName) and IsVarEXP(elt.FStr))) then begin zn:=''; break; end;
    end;
    Result:=zn<>'';
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TVarEC.Create(zn:VariableTypeEC);
begin
    inherited Create;
    FVType:=zn;
    if zn=vtFun then FVFun:=TCodeEC.Create;
end;

destructor TVarEC.Destroy;
begin
    if FVFun<>nil then begin FVFun.Free; FVFun:=nil end;
    FVLibraryFun:=nil;
    inherited Destroy;
end;

procedure TVarEC.ChangeVType(zn:VariableTypeEC);
begin
    if FVFun<>nil then begin FVFun.Free; FVFun:=nil end;
    if zn=vtInt then begin
        if FVType=vtUnknown then FVInt:=0
        else if FVType=vtInt then
        else if FVType=vtDW then FVInt:=FVDW
        else if FVType=vtFloat then FVInt:=Trunc(FVFloat)
        else if FVType=vtStr then FVInt:=StrToIntEXP(FVStr)
        else if FVType=vtExternFun then FVInt:=0
        else if FVType=vtLibraryFun then FVInt:=0
        else if FVType=vtClass then FVInt:=0
        else if FVType=vtArray then FVInt:=0
        else if FVType=vtRef then FVInt:=0
        else raise ExceptionExpressionEC.Create('Type error');
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtDW then begin
        if FVType=vtUnknown then FVDW:=0
        else if FVType=vtInt then FVDW:=FVInt
        else if FVType=vtDW then
        else if FVType=vtFloat then FVDW:=Trunc(FVFloat)
        else if FVType=vtStr then FVDW:=StrToIntEXP(FVStr)
        else if FVType=vtExternFun then FVDW:=0
        else if FVType=vtLibraryFun then FVDW:=0
        else if FVType=vtClass then FVDW:=0
        else if FVType=vtArray then FVDW:=0
        else if FVType=vtRef then FVDW:=0
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtFloat then begin
        if FVType=vtUnknown then FVFloat:=0
        else if FVType=vtInt then FVFloat:=FVInt
        else if FVType=vtFloat then
        else if FVType=vtStr then FVFloat:=StrToFloatEXP(FVStr)
        else if FVType=vtExternFun then FVFloat:=0
        else if FVType=vtLibraryFun then FVFloat:=0
        else if FVType=vtClass then FVFloat:=0
        else if FVType=vtArray then FVFloat:=0
        else if FVType=vtRef then FVFloat:=0
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtStr then begin
        if FVType=vtUnknown then FVStr:=''
        else if FVType=vtInt then FVStr:=IntToStr(FVInt)
        else if FVType=vtDW then FVStr:=IntToStr(FVDW)
        else if FVType=vtFloat then FVStr:=FloatToStrEXP(FVFloat)
        else if FVType=vtStr then
        else if FVType=vtExternFun then FVStr:=''
        else if FVType=vtLibraryFun then FVStr:=''
        else if FVType=vtClass then FVStr:=''
        else if FVType=vtArray then FVStr:=''
        else if FVType=vtRef then FVStr:=''
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtExternFun then begin
        if FVType=vtUnknown then FVExternFun:=nil
        else if FVType=vtInt then FVExternFun:=nil
        else if FVType=vtDW then FVExternFun:=nil
        else if FVType=vtFloat then FVExternFun:=nil
        else if FVType=vtStr then FVExternFun:=nil
        else if FVType=vtExternFun then
        else if FVType=vtLibraryFun then FVExternFun:=nil
        else if FVType=vtClass then FVExternFun:=nil
        else if FVType=vtArray then FVExternFun:=nil
        else if FVType=vtRef then FVExternFun:=nil
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtLibraryFun then begin
        if FVType=vtUnknown then FVLibraryFun:=nil
        else if FVType=vtInt then FVLibraryFun:=nil
        else if FVType=vtDW then FVLibraryFun:=nil
        else if FVType=vtFloat then FVLibraryFun:=nil
        else if FVType=vtStr then FVLibraryFun:=nil
        else if FVType=vtExternFun then FVLibraryFun:=nil
        else if FVType=vtLibraryFun then
        else if FVType=vtClass then FVLibraryFun:=nil
        else if FVType=vtArray then FVLibraryFun:=nil
        else if FVType=vtRef then FVLibraryFun:=nil
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtFun then begin
        if FVType=vtUnknown then FVFun:=nil
        else if FVType=vtInt then FVFun:=nil
        else if FVType=vtDW then FVFun:=nil
        else if FVType=vtFloat then FVFun:=nil
        else if FVType=vtStr then FVFun:=nil
        else if FVType=vtExternFun then FVFun:=nil
        else if FVType=vtLibraryFun then FVFun:=nil
        else if FVType=vtFun then FVFun:=nil
        else if FVType=vtClass then FVFun:=nil
        else if FVType=vtArray then FVFun:=nil
        else if FVType=vtRef then FVFun:=nil
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=TCodeEC.Create;
        FVClass:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtClass then begin
        if FVType=vtUnknown then FVClass:=nil
        else if FVType=vtInt then FVClass:=nil
        else if FVType=vtDW then FVClass:=nil
        else if FVType=vtFloat then FVClass:=nil
        else if FVType=vtStr then FVClass:=nil
        else if FVType=vtExternFun then FVClass:=nil
        else if FVType=vtLibraryFun then FVClass:=nil
        else if FVType=vtFun then FVClass:=nil
        else if FVType=vtClass then
        else if FVType=vtArray then FVClass:=nil
        else if FVType=vtRef then FVClass:=nil
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVArray:=nil;
        FVRef:=nil;
    end else if zn=vtArray then begin
        if FVType=vtUnknown then FVArray:=nil
        else if FVType=vtInt then FVArray:=nil
        else if FVType=vtDW then FVExternFun:=nil
        else if FVType=vtFloat then FVArray:=nil
        else if FVType=vtStr then FVArray:=nil
        else if FVType=vtExternFun then FVArray:=nil
        else if FVType=vtLibraryFun then FVArray:=nil
        else if FVType=vtClass then FVArray:=nil
        else if FVType=vtArray then
        else if FVType=vtRef then FVArray:=nil
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVRef:=nil;
    end else if zn=vtRef then begin
        if FVType=vtUnknown then FVRef:=nil
        else if FVType=vtInt then FVRef:=nil
        else if FVType=vtDW then FVExternFun:=nil
        else if FVType=vtFloat then FVRef:=nil
        else if FVType=vtStr then FVRef:=nil
        else if FVType=vtExternFun then FVRef:=nil
        else if FVType=vtLibraryFun then FVRef:=nil
        else if FVType=vtClass then FVRef:=nil
        else if FVType=vtArray then FVRef:=nil
        else if FVType=vtRef then
        else raise ExceptionExpressionEC.Create('Type error');
        FVInt:=0;
        FVDW:=0;
        FVFloat:=0;
        FVStr:='';
        FVExternFun:=nil;
        FVLibraryFun:=nil;
        FVFun:=nil;
        FVClass:=nil;
        FVArray:=nil;
    end;
    FVType:=zn;
end;

procedure TVarEC.SetVType(zn:VariableTypeEC);
begin
    if FVFun<>nil then begin FVFun.Free; FVFun:=nil end;
{    if VType=vtRef then begin // error ???
        if FVRef<>nil then SetVType(zn);
        Exit;
    end;}
    if FVType=vtRef then begin // naverno nado tak
        if FVRef<>nil then FVRef.SetVType(zn);
        Exit;
    end;

    FVType:=zn;
    FVInt:=0;
    FVDW:=0;
    FVFloat:=0;
    FVStr:='';
    FVExternFun:=nil;
    FVLibraryFun:=nil;
    FVFun:=nil;
    FVClass:=nil;
    FVArray:=nil;
    FVRef:=nil;

    if zn=vtFun then FVFun:=TCodeEC.Create;
end;

function TVarEC.GetVType:VariableTypeEC;
var
    tv:TVarEC;
begin
    tv:=GetByRef;
    if tv=nil then raise ExceptionExpressionEC.Create('Undefined ref. Name='+FName);
    Result:=tv.FVType;
end;

procedure TVarEC.CopyFrom(sou:TVarEC);
var
    i:integer;
begin
    if FVFun<>nil then begin FVFun.Free; FVFun:=nil; end;

    FName:=sou.FName;
    FVType:=sou.FVType;
    FVInt:=sou.FVInt;
    FVDW:=sou.FVDW;
    FVFloat:=sou.FVFloat;
    FVStr:=sou.FVStr;
    FVExternFun:=sou.FVExternFun;
    FVClass:=sou.FVClass;
    FVArray:=sou.FVArray;
    FVRef:=sou.FVRef;

    FVLibraryFun:=nil;
    if sou.FVLibraryFun<>nil then begin
        SetLength(FVLibraryFun,High(sou.FVLibraryFun)+1);
        for i:=0 to High(FVLibraryFun) do FVLibraryFun[i]:=sou.FVLibraryFun[i];
    end;
    FVFun:=nil;
    if sou.FVFun<>nil then begin
        FVFun:=TCodeEC.Create;
        FVFun.CopyFrom(sou.FVFun);
    end;
end;

function TVarEC.GetUnknown:boolean;
begin
    Result:=FVType=vtUnknown;
end;

function TVarEC.GetInt:integer;
begin
    if FVType=vtUnknown then Result:=0
    else if FVType=vtInt then Result:=FVInt
    else if FVType=vtDW then Result:=FVDW
    else if FVType=vtFloat then Result:=Trunc(FVFloat)
    else if FVType=vtStr then Result:=StrToIntEXP(FVStr)
    else if FVType=vtExternFun then Result:=0
    else if FVType=vtLibraryFun then Result:=0
    else if FVType=vtFun then Result:=0
    else if FVType=vtClass then Result:=0
    else if FVType=vtArray then Result:=0
    else if FVType=vtRef then if FVRef=nil then Result:=0 else Result:=FVRef.GetInt
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetDW:DWORD;
begin
    if FVType=vtUnknown then Result:=0
    else if FVType=vtInt then Result:=FVInt
    else if FVType=vtDW then Result:=FVDW
    else if FVType=vtFloat then Result:=Trunc(FVFloat)
    else if FVType=vtStr then Result:=StrToIntEXP(FVStr)
    else if FVType=vtExternFun then Result:=0
    else if FVType=vtLibraryFun then Result:=0
    else if FVType=vtFun then Result:=0
    else if FVType=vtClass then Result:=0
    else if FVType=vtArray then Result:=0
    else if FVType=vtRef then if FVRef=nil then Result:=0 else Result:=FVRef.GetInt
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetFloat:double;
begin
    if FVType=vtUnknown then Result:=0
    else if FVType=vtInt then Result:=FVInt
    else if FVType=vtDW then Result:=FVDW
    else if FVType=vtFloat then Result:=FVFloat
    else if FVType=vtStr then Result:=StrToFloatEXP(FVStr)
    else if FVType=vtExternFun then Result:=0
    else if FVType=vtLibraryFun then Result:=0
    else if FVType=vtFun then Result:=0
    else if FVType=vtClass then Result:=0
    else if FVType=vtArray then Result:=0
    else if FVType=vtRef then if FVRef=nil then Result:=0 else Result:=FVRef.GetFloat
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetStr:WideString;
begin
    if FVType=vtUnknown then Result:=''
    else if FVType=vtInt then Result:=IntToStr(FVInt)
    else if FVType=vtDW then Result:=IntToStr(FVDW)
    else if FVType=vtFloat then Result:=FloatToStrEXP(FVFloat)
    else if FVType=vtStr then Result:=FVStr
    else if FVType=vtExternFun then Result:=''
    else if FVType=vtLibraryFun then Result:=''
    else if FVType=vtFun then Result:=''
    else if FVType=vtClass then Result:=''
    else if FVType=vtArray then Result:=''
    else if FVType=vtRef then if FVRef=nil then Result:='' else Result:=FVRef.GetStr
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetExternFun:FunctionExpressionEC;
begin
    if FVType=vtUnknown then Result:=nil
    else if FVType=vtInt then Result:=nil
    else if FVType=vtDW then Result:=nil
    else if FVType=vtFloat then Result:=nil
    else if FVType=vtStr then Result:=nil
    else if FVType=vtExternFun then Result:=FVExternFun
    else if FVType=vtLibraryFun then Result:=nil
    else if FVType=vtFun then Result:=nil
    else if FVType=vtClass then Result:=nil
    else if FVType=vtArray then Result:=nil
    else if FVType=vtRef then begin if FVRef=nil then Result:=nil else Result:=FVRef.VExternFun; end
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetFun:TCodeEC;
begin
    if FVType=vtUnknown then Result:=nil
    else if FVType=vtInt then Result:=nil
    else if FVType=vtDW then Result:=nil
    else if FVType=vtFloat then Result:=nil
    else if FVType=vtStr then Result:=nil
    else if FVType=vtExternFun then Result:=nil
    else if FVType=vtLibraryFun then Result:=nil
    else if FVType=vtFun then Result:=FVFun
    else if FVType=vtClass then Result:=nil
    else if FVType=vtArray then Result:=nil
    else if FVType=vtRef then begin if FVRef=nil then Result:=nil else Result:=FVRef.VFun; end
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetClass:TCodeEC;
begin
    if FVType=vtUnknown then Result:=nil
    else if FVType=vtInt then Result:=nil
    else if FVType=vtDW then Result:=nil
    else if FVType=vtFloat then Result:=nil
    else if FVType=vtStr then Result:=nil
    else if FVType=vtExternFun then Result:=nil
    else if FVType=vtLibraryFun then Result:=nil
    else if FVType=vtFun then Result:=nil
    else if FVType=vtClass then Result:=FVClass
    else if FVType=vtArray then Result:=nil
    else if FVType=vtRef then begin if FVRef=nil then Result:=nil else Result:=FVRef.VFun; end
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetArray:TVarArrayEC;
begin
    if FVType=vtUnknown then Result:=nil
    else if FVType=vtInt then Result:=nil
    else if FVType=vtDW then Result:=nil
    else if FVType=vtFloat then Result:=nil
    else if FVType=vtStr then Result:=nil
    else if FVType=vtExternFun then Result:=nil
    else if FVType=vtLibraryFun then Result:=nil
    else if FVType=vtFun then Result:=nil
    else if FVType=vtClass then Result:=nil
    else if FVType=vtArray then Result:=FVArray
    else if FVType=vtRef then if FVRef=nil then Result:=nil else Result:=FVRef.GetArray
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetRef:TVarEC;
begin
    if FVType=vtUnknown then Result:=nil
    else if FVType=vtInt then Result:=nil
    else if FVType=vtDW then Result:=nil
    else if FVType=vtFloat then Result:=nil
    else if FVType=vtStr then Result:=nil
    else if FVType=vtExternFun then Result:=nil
    else if FVType=vtLibraryFun then Result:=nil
    else if FVType=vtFun then Result:=nil
    else if FVType=vtClass then Result:=nil
    else if FVType=vtArray then Result:=nil
    else if FVType=vtRef then Result:=FVRef
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetInt(zn:integer);
begin
    if FVType=vtUnknown then begin VType:=vtInt; FVInt:=zn; end
    else if FVType=vtInt then FVInt:=zn
    else if FVType=vtDW then FVDW:=zn
    else if FVType=vtFloat then FVFloat:=zn
    else if FVType=vtStr then FVStr:=IntToStr(zn)
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetInt(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetDW(zn:DWORD);
begin
    if FVType=vtUnknown then begin VType:=vtInt; FVInt:=zn; end
    else if FVType=vtInt then FVInt:=zn
    else if FVType=vtDW then FVDW:=zn
    else if FVType=vtFloat then FVFloat:=zn
    else if FVType=vtStr then FVStr:=IntToStr(zn)
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetInt(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetFloat(zn:double);
begin
    if FVType=vtUnknown then begin VType:=vtFloat; FVFloat:=zn; end
    else if FVType=vtInt then FVInt:=Trunc(zn)
    else if FVType=vtDW then FVDW:=Trunc(zn)
    else if FVType=vtFloat then FVFloat:=zn
    else if FVType=vtStr then FVStr:=FloatToStrEXP(zn)
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetFloat(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetStr(zn:WideString);
begin
    if FVType=vtUnknown then begin VType:=vtStr; FVStr:=zn; end
    else if FVType=vtInt then FVInt:=StrToIntEXP(zn)
    else if FVType=vtDW then FVDW:=StrToIntEXP(zn)
    else if FVType=vtFloat then FVFloat:=StrToFloatEXP(zn)
    else if FVType=vtStr then FVStr:=zn
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetStr(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetExternFun(tfun:FunctionExpressionEC);
begin
    if FVType=vtUnknown then begin VType:=vtExternFun; FVExternFun:=tfun; end
    else if FVType=vtInt then FVInt:=0
    else if FVType=vtDW then FVDW:=0
    else if FVType=vtFloat then FVFloat:=0
    else if FVType=vtStr then FVStr:=''
    else if FVType=vtExternFun then FVExternFun:=tfun
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetExternFun(tfun)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetFun(zn:TCodeEC);
begin
    if FVType=vtUnknown then //begin VType:=vtFun; FVFun:=zn; end
    else if FVType=vtInt then FVInt:=0
    else if FVType=vtDW then FVDW:=0
    else if FVType=vtFloat then FVFloat:=0
    else if FVType=vtStr then FVStr:=''
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=zn
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetFun(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetClass(zn:TCodeEC);
begin
    if FVType=vtUnknown then begin VType:=vtClass; FVClass:=zn; end
    else if FVType=vtInt then FVInt:=0
    else if FVType=vtDW then FVDW:=0
    else if FVType=vtFloat then FVFloat:=0
    else if FVType=vtStr then FVStr:=''
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=zn
    else if FVType=vtClass then FVClass:=zn
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetFun(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetArray(zn:TVarArrayEC);
begin
    if FVType=vtUnknown then begin VType:=vtArray; FVArray:=zn; end
    else if FVType=vtInt then FVInt:=0
    else if FVType=vtDW then FVDW:=0
    else if FVType=vtFloat then FVFloat:=0
    else if FVType=vtStr then FVStr:=''
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=zn
    else if FVType=vtRef then if FVRef<>nil then FVRef.SetArray(zn)
    else raise ExceptionExpressionEC.Create('Type error');
end;

procedure TVarEC.SetRef(zn:TVarEC);
begin
    if FVType=vtUnknown then begin VType:=vtRef; FVRef:=zn; end
    else if FVType=vtInt then FVInt:=0
    else if FVType=vtDW then FVDW:=0
    else if FVType=vtFloat then FVFloat:=0
    else if FVType=vtStr then FVStr:=''
    else if FVType=vtExternFun then FVExternFun:=nil
    else if FVType=vtLibraryFun then FVLibraryFun:=nil
    else if FVType=vtFun then //FVFun:=nil
    else if FVType=vtClass then FVClass:=nil
    else if FVType=vtArray then FVArray:=nil
    else if FVType=vtRef then FVRef:=zn
    else raise ExceptionExpressionEC.Create('Type error');
end;

function TVarEC.GetByRef:TVarEC;
begin
    Result:=self;
    while (Result<>nil) and (Result.FVType=vtRef) do Result:=Result.FVRef;
end;

procedure ArrayInitREC(va:TVarArrayEC; ar:array of integer; level:integer);
var
    i,cnt:integer;
    tvar:TVarEC;
begin
    cnt:=ar[level];
    if High(ar)=level then begin
        for i:=0 to cnt-1 do begin
            va.Add('',vtUnknown);
        end;
    end else begin
        for i:=0 to cnt-1 do begin
            tvar:=va.Add('',vtArray);
            tvar.VArray:=TVarArrayEC.Create;
            ArrayInitREC(tvar.VArray,ar,level+1);
        end;
    end;
end;

procedure TVarEC.ArrayInit(ar:array of integer);
begin
    VType:=vtArray;

    FVArray:=TVarArrayEC.Create;

    ArrayInitREC(FVArray,ar,0);
end;

procedure ArrayClearREC(va:TVarArrayEC);
var
    i,cnt:integer;
    tvar:TVarEC;
begin
    cnt:=va.Count;
    for i:=0 to cnt-1 do begin
        tvar:=va.Items[i];
        if (tvar.FVType=vtArray) and (tvar.VArray<>nil) then ArrayClearREC(tvar.VArray);
    end;
    va.Free;
end;

procedure TVarEC.ArrayClear;
begin
    if (VType<>vtArray) or (VArray=nil) then Exit;
    ArrayClearREC(VArray);
    VArray:=nil;
end;

procedure TVarEC.OAdd(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt+s2.VInt;
        vtDW:VDW:=s1.VDW+s2.VDW;
        vtFloat:VFloat:=s1.VFloat+s2.VFloat;
        vtStr:VStr:=s1.VStr+s2.VStr;
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OAdd'); end;
end;

procedure TVarEC.OSub(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt-s2.VInt;
        vtDW:VDW:=s1.VDW-s2.VDW;
        vtFloat:VFloat:=s1.VFloat-s2.VFloat;
        vtStr:VStr:=s1.VStr+s2.VStr;
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OSub'); end;
end;

procedure TVarEC.OMul(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt*s2.VInt;
        vtDW:VDW:=s1.VDW*s2.VDW;
        vtFloat:VFloat:=s1.VFloat*s2.VFloat;
        vtStr:VStr:=s1.VStr+s2.VStr;
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OMul'); end;
end;

procedure TVarEC.ODiv(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt div s2.VInt;
        vtDW:VDW:=s1.VDW div s2.VDW;
        vtFloat:VFloat:=s1.VFloat / s2.VFloat;
        vtStr:VStr:=s1.VStr+s2.VStr;
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('ODiv'); end;
end;

procedure TVarEC.OMod(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt mod s2.VInt;
        vtDW:VDW:=s1.VDW mod s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) mod Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OMod'); end;
end;

procedure TVarEC.OBitAnd(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt and s2.VInt;
        vtDW:VDW:=s1.VDW and s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) and Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OBitAnd'); end;
end;

procedure TVarEC.OBitOr(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt or s2.VInt;
        vtDW:VDW:=s1.VDW or s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) or Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OBitAnd'); end;
end;

procedure TVarEC.OBitXor(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt xor s2.VInt;
        vtDW:VDW:=s1.VDW xor s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) xor Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OBitXor'); end;
end;

procedure TVarEC.OAnd(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer((s1.VInt<>0) and (s2.VInt<>0));
        vtDW:VDW:=DWORD((s1.VDW<>0) and (s2.VDW<>0));
        vtFloat:VFloat:=integer((s1.VFloat<>0) and (s2.VFloat<>0));
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OAnd'); end;
end;

procedure TVarEC.OOr(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer((s1.VInt<>0) or (s2.VInt<>0));
        vtDW:VDW:=DWORD((s1.VDW<>0) or (s2.VDW<>0));
        vtFloat:VFloat:=integer((s1.VFloat<>0) or (s2.VFloat<>0));
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OAnd'); end;
end;

procedure TVarEC.OShl(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt shl s2.VInt;
        vtDW:VDW:=s1.VDW shl s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) shl Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OXor'); end;
end;

procedure TVarEC.OShr(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=s1.VInt shr s2.VInt;
        vtDW:VDW:=s1.VDW shr s2.VDW;
        vtFloat:VFloat:=Trunc(s1.VFloat) shr Trunc(s2.VFloat);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OXor'); end;
end;

procedure TVarEC.OEqual(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt=s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW=s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat=s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr=s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OEqual'); end;
end;

procedure TVarEC.ONotEqual(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt<>s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW<>s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat<>s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr<>s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('ONotEqual'); end;
end;

procedure TVarEC.OLess(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt<s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW<s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat<s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr<s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OLess'); end;
end;

procedure TVarEC.OMore(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt>s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW>s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat>s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr>s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OMore'); end;
end;

procedure TVarEC.OLessEqual(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt<=s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW<=s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat<=s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr<=s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OLessEqual'); end;
end;

procedure TVarEC.OMoreEqual(s1,s2:TVarEC);
begin
    if VType=vtUnknown then VType:=s1.VType;
    if VType=vtUnknown then exit;

    case s1.VType of
        vtInt:VInt:=integer(s1.VInt>=s2.VInt);
        vtDW:VDW:=DWORD(s1.VDW>=s2.VDW);
        vtFloat:VFloat:=integer(s1.VFloat>=s2.VFloat);
        vtStr:VStr:=IntToStr(integer(s1.VStr>=s2.VStr));
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OMoreEqual'); end;
end;

procedure TVarEC.OMinus(sou:TVarEC);
begin
    if VType=vtUnknown then VType:=sou.VType;
    if VType=vtUnknown then exit;

    case sou.VType of
        vtInt:VInt:=-sou.VInt;
        vtDW:VDW:=DWORD(-sou.VDW);
        vtFloat:VFloat:=-sou.VFloat;
        vtStr:VStr:=sou.VStr;
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OMinus'); end;
end;

procedure TVarEC.OBitNot(sou:TVarEC);
begin
    if VType=vtUnknown then VType:=sou.VType;
    if VType=vtUnknown then exit;

    case sou.VType of
        vtInt:VInt:=not sou.VInt;
        vtDW:VDW:=not sou.VDW;
        vtFloat:VFloat:=0;
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('OBitNot'); end;
end;

procedure TVarEC.ONot(sou:TVarEC);
begin
    if VType=vtUnknown then VType:=sou.VType;
    if VType=vtUnknown then exit;

    case sou.VType of
        vtInt:VInt:=integer(sou.VInt=0);
        vtDW:VDW:=DWORD(sou.VInt=0);
        vtFloat:VFloat:=integer(sou.VFloat=0);
        vtStr:VStr:='';
        vtExternFun:VExternFun:=nil;
        vtFun:VFun:=nil;
        vtClass:VClass:=nil;
        vtArray:VArray:=nil;
    else raise ExceptionExpressionEC.Create('ONot'); end;
end;

procedure TVarEC.Assume(sou:TVarEC);
var
    des:TVarEC;
    i:integer;
begin
    des:=self; if FVType=vtRef then begin des:=GetByRef; if des=nil then Exit; end;

    if des.FVType=vtUnknown then des.VType:=sou.VType;

    if des.FVType=vtUnknown then
    else if des.FVType=vtInt then des.VInt:=sou.VInt
    else if des.FVType=vtDW then des.VDW:=sou.VDW
    else if des.FVType=vtFloat then des.VFloat:=sou.VFloat
    else if des.FVType=vtStr then des.VStr:=sou.VStr
    else if des.FVType=vtExternFun then des.VExternFun:=sou.VExternFun
    else if des.FVType=vtLibraryFun then begin
        des.FVLibraryFun:=nil;
        if sou.FVLibraryFun<>nil then begin
            SetLength(des.FVLibraryFun,High(sou.FVLibraryFun)+1);
            for i:=0 to High(des.FVLibraryFun) do des.FVLibraryFun[i]:=sou.FVLibraryFun[i];
        end;
    end
    else if des.FVType=vtFun then des.VFun:=sou.VFun
    else if des.FVType=vtClass then des.VClass:=sou.VClass
    else if des.FVType=vtArray then des.VArray:=sou.VArray
    else raise ExceptionExpressionEC.Create('OAssume');
end;

function TVarEC.Equal(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown=sou.VUnknown;
        vtInt:Result:=VInt=sou.VInt;
        vtDW:Result:=VDW=sou.VDW;
        vtFloat:Result:=VFloat=sou.VFloat;
        vtStr:Result:=VStr=sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=VClass=sou.VClass;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('Equal'); end;
end;

function TVarEC.NotEqual(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown<>sou.VUnknown;
        vtInt:Result:=VInt<>sou.VInt;
        vtDW:Result:=VDW<>sou.VDW;
        vtFloat:Result:=VFloat<>sou.VFloat;
        vtStr:Result:=VStr<>sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=VClass<>sou.VClass;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('NotEqual'); end;
end;

function TVarEC.Less(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown<sou.VUnknown;
        vtInt:Result:=VInt<sou.VInt;
        vtDW:Result:=VDW<sou.VDW;
        vtFloat:Result:=VFloat<sou.VFloat;
        vtStr:Result:=VStr<sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=false;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('Less'); end;
end;

function TVarEC.More(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown>sou.VUnknown;
        vtInt:Result:=VInt>sou.VInt;
        vtDW:Result:=VDW>sou.VDW;
        vtFloat:Result:=VFloat>sou.VFloat;
        vtStr:Result:=VStr>sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=false;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('More'); end;
end;

function TVarEC.LessEqual(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown<=sou.VUnknown;
        vtInt:Result:=VInt<=sou.VInt;
        vtDW:Result:=VDW<=sou.VDW;
        vtFloat:Result:=VFloat<=sou.VFloat;
        vtStr:Result:=VStr<=sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=false;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('LessEqual'); end;
end;

function TVarEC.MoreEqual(sou:TVarEC):boolean;
begin
    case VType of
        vtUnknown:Result:=VUnknown>=sou.VUnknown;
        vtInt:Result:=VInt>=sou.VInt;
        vtDW:Result:=VDW>=sou.VDW;
        vtFloat:Result:=VFloat>=sou.VFloat;
        vtStr:Result:=VStr>=sou.VStr;
        vtExternFun:Result:=false;
        vtFun:Result:=false;
        vtClass:Result:=false;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('MoreEqual'); end;
end;

function TVarEC.IsTrue:boolean;
begin
    case VType of
        vtUnknown:Result:=false;
        vtInt:Result:=VInt<>0;
        vtDW:Result:=VDW<>0;
        vtFloat:Result:=VFloat<>0;
        vtStr:Result:=VStr<>'';
        vtExternFun:Result:=false;
        vtLibraryFun:Result:=GetByRef.FVLibraryFun<>nil;
        vtFun:Result:=false;
        vtClass:Result:=VClass<>nil;
        vtArray:Result:=false;
    else raise ExceptionExpressionEC.Create('IsTrue'); end;
end;

procedure TVarEC.Save(bd:TBufEC);
begin
    bd.Add(FName);
    bd.AddBYTE(BYTE(FVType));
    if FVType=vtUnknown then begin
    end else if FVType=vtInt then begin
        bd.AddInteger(FVInt);
    end else if FVType=vtDW then begin
        bd.AddDWORD(FVDW);
    end else if FVType=vtFloat then begin
        bd.AddDouble(FVFloat);
    end else if FVType=vtStr then begin
        bd.Add(FVStr);
    end else if FVType=vtExternFun then begin
    end else if FVType=vtLibraryFun then begin
    end else if FVType=vtFun then begin
    end else if FVType=vtClass then begin
    end else if FVType=vtArray then begin
    end else if FVType=vtRef then begin
    end;
end;

procedure TVarEC.Load(bd:TBufEC);
begin
    FName:=bd.GetWideStr();
    SetVType(VariableTypeEC(bd.GetBYTE));
    if FVType=vtUnknown then begin
    end else if FVType=vtInt then begin
        FVInt:=bd.GetInteger;
    end else if FVType=vtDW then begin
        FVDW:=bd.GetDWORD;
    end else if FVType=vtFloat then begin
        FVFloat:=bd.GetDouble;
    end else if FVType=vtStr then begin
        FVStr:=bd.GetWideStr;
    end else if FVType=vtExternFun then begin
    end else if FVType=vtLibraryFun then begin
    end else if FVType=vtFun then begin
    end else if FVType=vtClass then begin
    end else if FVType=vtArray then begin
    end else if FVType=vtRef then begin
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TVarArrayEC.Create;
begin
    inherited Create;
end;

destructor TVarArrayEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TVarArrayEC.ClearNoFree;
begin
    if FItem<>nil then begin
        HeapFree(GetProcessHeap(),0,FItem);
        FItem:=nil;
    end;
    if FIndex<>nil then begin
        HeapFree(GetProcessHeap(),0,FIndex);
        FIndex:=nil;
    end;
    FCount:=0;
end;

procedure TVarArrayEC.Clear;
var
    i:integer;
begin
    for i:=0 to FCount-1 do begin
        Items[i].Free;
    end;
    ClearNoFree;
end;

procedure TVarArrayEC.CopyFrom(sou:TVarArrayEC);
var
    tv,tvsou:TVarEC;
    i:integer;
begin
    Clear;

    FCount:=sou.FCount;
    if FCount<1 then Exit;
    FItem:=HeapAlloc(GetProcessHeap(),0,FCount*4);
    FIndex:=HeapAlloc(GetProcessHeap(),0,FCount*4);
    CopyMemory(FIndex,sou.FIndex,FCount*4);

    for i:=0 to FCount-1 do begin
        tvsou:=sou.Items[i];
        tv:=TVarEC.Create;
        Items[i]:=tv;
        tv.Name:=tvsou.FName;
        tv.CopyFrom(tvsou);
    end;
end;

function TVarArrayEC.FindIndex(tname:WideString):integer;
var
    istart,iend,icur,cz:integer;
    el:TVarEC;
begin
    if FCount<1 then begin Result:=-1; Exit; End;
    istart:=0;
    iend:=FCount-1;
    while true do begin
        icur:=istart+((iend-istart) div 2);
        el:=IndexToVar(icur);
        cz:=CompareStr(tname,el.Name);
        if cz=0 then begin Result:=icur; Exit; End
        else if cz<0 then begin
            iend:=icur-1;
        end else begin
            istart:=icur+1;
        end;
        if iend<istart then begin
            Result:=-1;
            Exit;
        end;
    end;
end;

function TVarArrayEC.FindInsertIndex(tname:WideString):integer;
var
    istart,iend,icur,cz:integer;
    el:TVarEC;
begin
    if FCount<=0 then begin Result:=0; Exit; End;
    istart:=0;
    iend:=FCount-1;
    while true do begin
        icur:=istart+((iend-istart) div 2);
        el:=IndexToVar(icur);
        cz:=CompareStr(tname,el.Name);
        if cz=0 then begin Result:=icur; Exit; End
        else if cz<0 then begin
            iend:=icur-1;
        end else begin
            istart:=icur+1;
        end;
        if iend<istart then begin
            if cz<0 then Result:=icur
            else Result:=icur+1;
            Exit;
        end;
    end;
end;

procedure TVarArrayEC.SetIndex(no:integer; el:integer);
asm
        push    eax
        push    ebx
        mov     ebx,self
        mov     eax,no
        shl     eax,2
        add     eax,TVarArrayEC(ebx).FIndex
        mov     ebx,el
        mov     [eax],ebx
        pop     ebx
        pop     eax
end;

function TVarArrayEC.GetIndex(no:integer):integer;
asm
        push    eax
        push    ebx
        mov     ebx,self
        mov     eax,no
        shl     eax,2
        add     eax,TVarArrayEC(ebx).FIndex
        mov     eax,[eax]
        mov     Result,eax
        pop     ebx
        pop     eax
end;

function TVarArrayEC.IndexToVar(no:integer):TVarEC;
asm
        push    eax
        push    ebx
        mov     ebx,self
        mov     eax,no
        shl     eax,2
        add     eax,TVarArrayEC(ebx).FIndex
        mov     eax,[eax]
        mov     ebx,TVarArrayEC(ebx).FItem;
        mov     eax,[ebx+eax*4]
        mov     Result,eax
        pop     ebx
        pop     eax
end;

function TVarArrayEC.VarToIndex(el:TVarEC):integer;
label l3,l1,l2;
asm
    pushad

    mov     ebx,self
    mov     ecx,TVarArrayEC(ebx).FCount
    xor     edx,edx
    mov     esi,TVarArrayEC(ebx).FIndex
    mov     edi,TVarArrayEC(ebx).FItem
    mov     ebx,el
    mov     eax,-1
    mov     Result,eax
    test    ecx,ecx
    jz      l3

l1: mov     eax,[esi]
    mov     eax,[edi+eax*4]
    cmp     eax,ebx
    jz      l2
    add     esi,4
    inc     edi
    dec     ecx
    jnz     l1
    jmp     l3

l2: mov     Result,edx
l3: popad
end;

function TVarArrayEC.ItemToIndex(no:integer):integer;
label l3,l1,l2;
asm
    pushad

    mov     ebx,self
    mov     ecx,TVarArrayEC(ebx).FCount
    xor     edx,edx
    mov     esi,TVarArrayEC(ebx).FIndex
    mov     ebx,no
    mov     eax,-1
    mov     Result,eax
    test    ecx,ecx
    jz      l3

l1: mov     eax,[esi]
    cmp     eax,ebx
    jz      l2
    add     esi,4
    inc     edi
    dec     ecx
    jnz     l1
    jmp     l3

l2: mov     Result,edx
l3: popad
end;

function TVarArrayEC.GetItem(no:integer):TVarEC;
asm
        push    eax
        push    ebx
        mov     ebx,self
        mov     eax,no
        shl     eax,2
        add     eax,TVarArrayEC(ebx).FItem
        mov     eax,[eax]
        mov     Result,eax
        pop     ebx
        pop     eax
end;

procedure TVarArrayEC.SetItem(no:integer; el:TVarEC);
asm
        push    eax
        push    ebx
        mov     ebx,self
        mov     eax,no
        shl     eax,2
        add     eax,TVarArrayEC(ebx).FItem
        mov     ebx,el
        mov     [eax],ebx
        pop     ebx
        pop     eax
end;

function TVarArrayEC.GetItemTB(no:integer):TVarEC;
begin
    if (no<0) or (no>=FCount) then begin Result:=nil; Exit; End;
    Result:=GetItem(no);
end;

procedure TVarArrayEC.SetItemTB(no:integer; el:TVarEC);
begin
    if (no<0) or (no>=FCount) then Exit;
    SetItem(no,el);
end;

function TVarArrayEC.IndexOf(el:TVarEC):integer;
label l3,l1,l2;
asm
    pushad

    mov     ebx,self
    mov     ecx,TVarArrayEC(ebx).FCount
    xor     edx,edx
    mov     esi,TVarArrayEC(ebx).FItem
    mov     ebx,el
    mov     eax,-1
    mov     Result,eax
    test    ecx,ecx
    jz      l3

l1: mov     eax,[esi]
    cmp     eax,ebx
    jz      l2
    add     esi,4
    inc     edi
    dec     ecx
    jnz     l1
    jmp     l3

l2: mov     Result,edx
l3: popad
end;

function TVarArrayEC.GetVar(tname:WideString):TVarEC;
begin
    Result:=GetVarNE(tname);
    if Result=nil then raise ExceptionExpressionEC.Create('Var not found:'+tname);
end;

function TVarArrayEC.GetVarNE(tname:WideString):TVarEC;
var
    istart,iend,icur,cz:integer;
    el:TVarEC;
begin
    if FCount<1 then begin Result:=nil; Exit; End;
    istart:=0;
    iend:=FCount-1;
    while true do begin
        icur:=istart+((iend-istart) div 2);
        el:=IndexToVar(icur);
        cz:=CompareStr(tname,el.Name);
        if cz=0 then begin Result:=Items[Indexs[icur]]; Exit; end
        else if cz<0 then begin
            iend:=icur-1;
        end else begin
            istart:=icur+1;
        end;
        if iend<istart then begin
            Result:=nil;
            Exit;
        end;
    end;
end;

procedure TVarArrayEC.ChangeName(no:integer);
var
    tvar:TVarEC;
begin
    if (no<0) or (no>=FCount) or (FCount<1) then Exit;
    tvar:=Items[no];
    Items[no]:=nil;
    Del(no);
    Insert(no,tvar);
end;

procedure TVarArrayEC.Del(no:integer);
var
    i,ind:integer;
    tvar:TVarEC;
begin
    if (no<0) or (no>=FCount) or (FCount<1) then Exit;
    tvar:=Items[no];
    if tvar<>nil then tvar.Free;
    ind:=ItemToIndex(no);
    for i:=ind to FCount-2 do Indexs[i]:=Indexs[i+1];
    for i:=no to FCount-2 do Items[i]:=Items[i+1];
    dec(FCount);
    if FCount<1 then Clear;
end;

procedure TVarArrayEC.Del(el:TVarEC);
begin
    Del(IndexOf(el));
end;

procedure TVarArrayEC.Del(tname:WideString);
begin
    Del(FindIndex(tname));
end;

procedure TVarArrayEC.Add(el:TVarEC);
var
    i,no:integer;
//    tel:TVarEC;
begin
    if FItem=nil then FItem:=HeapAlloc(GetProcessHeap(),0,(FCount+1)*4)
    else FItem:=HeapRealloc(GetProcessHeap(),0,FItem,(FCount+1)*4);
    Items[FCount]:=el;

    no:=FindInsertIndex(el.Name);

    if (no>=FCount) then begin
        inc(FCount);
        if FIndex=nil then FIndex:=HeapAlloc(GetProcessHeap(),0,FCount*4)
        else FIndex:=HeapRealloc(GetProcessHeap(),0,FIndex,FCount*4);
        Indexs[FCount-1]:=FCount-1;
        Exit;
    end;
//    tel:=IndexToVar(no);
    inc(FCount);
    FIndex:=HeapRealloc(GetProcessHeap(),0,FIndex,FCount*4);
    for i:=FCount-1 downto no+1 do begin
        Indexs[i]:=Indexs[i-1];
    end;
    Indexs[no]:=FCount-1;
end;

procedure TVarArrayEC.Insert(tono:integer; el:TVarEC);
var
    i,no:integer;
begin
    if tono>=FCount then begin Add(el); Exit; end;

    inc(FCount);

    if FItem=nil then FItem:=HeapAlloc(GetProcessHeap(),0,FCount*4)
    else FItem:=HeapRealloc(GetProcessHeap(),0,FItem,FCount*4);
    for i:=FCount-1 to tono+1 do Items[i]:=Items[i-1];
    Items[tono]:=el;

    no:=FindInsertIndex(el.Name);

    if (no>=FCount) then begin
        if FIndex=nil then FIndex:=HeapAlloc(GetProcessHeap(),0,FCount*4)
        else FIndex:=HeapRealloc(GetProcessHeap(),0,FIndex,FCount*4);
        Indexs[FCount-1]:=tono;
        Exit;
    end;
    inc(FCount);
    FIndex:=HeapRealloc(GetProcessHeap(),0,FIndex,FCount*4);
    for i:=FCount-1 downto no+1 do begin
        Indexs[i]:=Indexs[i-1];
    end;
    Indexs[no]:=tono;
end;

function TVarArrayEC.Add(tname:WideString; vtype:VariableTypeEC):TVarEC;
var
    el:TVarEC;
begin
    el:=TVarEC.Create(vtype);
    el.Name:=tname;

    try
        Add(el);
    except
        el.Free;
        raise;
    end;

    Result:=el;
end;

function TVarArrayEC.Insert(tono:integer; tname:WideString; vtype:VariableTypeEC):TVarEC;
var
    el:TVarEC;
begin
    el:=TVarEC.Create(vtype);
    el.Name:=tname;

    try
        Insert(tono,el);
    except
        el.Free;
        raise;
    end;

    Result:=el;
end;

procedure TVarArrayEC.Save(bd:TBufEC);
var
    i:integer;
begin
    bd.AddInteger(FCount);
    for i:=0 to FCount-1 do begin
        Items[i].Save(bd);
    end;
end;

procedure TVarArrayEC.Load(bd:TBufEC);
var
    cnt:integer;
    i:integer;
    tv:TVarEC;
begin
    Clear;

    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
        tv:=TVarEC.Create;
        tv.Load(bd);
        Add(tv);
    end;
end;

procedure TVarArrayEC.LoadAdd(bd:TBufEC);
var
    cnt:integer;
    i:integer;
    tv:TVarEC;
begin
    cnt:=bd.GetInteger;
    for i:=0 to cnt-1 do begin
        tv:=TVarEC.Create;
        tv.Load(bd);
        Add(tv);
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TCodeAnalyzerEC.Create;
begin
    inherited Create;
end;

destructor TCodeAnalyzerEC.Destroy;
begin
    FreeClear;
    inherited Destroy;
end;

procedure TCodeAnalyzerEC.FreeClear;
var
    el,el2:TCodeAnalyzerUnitEC;
begin
    el:=FFirst;
    while el<>nil do begin
        el2:=el;
        el:=el.FNext;
        el2.Free;
    end;
    FFirst:=nil;
    FLast:=nil;

    el:=FFirstFree;
    while el<>nil do begin
        el2:=el;
        el:=el.FNext;
        el2.Free;
    end;
    FFirstFree:=nil;
    FLastFree:=nil;
end;

procedure TCodeAnalyzerEC.FreeAddGroup(cnt:integer);
var
    el:TCodeAnalyzerUnitEC;
    i:integer;
begin
    for i:=0 to cnt-1 do begin
        el:=TCodeAnalyzerUnitEC.Create;

    	if FLastFree<>nil then FLastFree.FNext:=el;
	    el.FPrev:=FLastFree;
    	el.FNext:=nil;
	    FLastFree:=el;
    	if FFirstFree=nil then FFirstFree:=el;
    end;
end;

function  TCodeAnalyzerEC.FreeAlloc:TCodeAnalyzerUnitEC;
var
    el:TCodeAnalyzerUnitEC;
begin
    if FFirstFree=nil then FreeAddGroup(64);
    el:=FLastFree;

	if (el.FPrev<>nil) then el.FPrev.FNext:=el.FNext;
	if (el.FNext<>nil) then el.FNext.FPrev:=el.FPrev;
	if (FLastFree=el) then FLastFree:=el.FPrev;
	if (FFirstFree=el) then FFirstFree:=el.FNext;

    Result:=el;
end;

procedure TCodeAnalyzerEC.FreeFree(el:TCodeAnalyzerUnitEC);
begin
    if FLastFree<>nil then FLastFree.FNext:=el;
	el.FPrev:=FLastFree;
    el.FNext:=nil;
	FLastFree:=el;
    if FFirstFree=nil then FFirstFree:=el;
end;

procedure TCodeAnalyzerEC.Clear;
begin
	while FFirst<>nil do UnitDel(FLast);
end;

function TCodeAnalyzerEC.UnitAdd:TCodeAnalyzerUnitEC;
var
    el:TCodeAnalyzerUnitEC;
begin
    el:=FreeAlloc;

	if FLast<>nil then FLast.FNext:=el;
	el.FPrev:=FLast;
	el.FNext:=nil;
	FLast:=el;
	if FFirst=nil then FFirst:=el;

	Result:=el;
end;

procedure TCodeAnalyzerEC.UnitDel(el:TCodeAnalyzerUnitEC);
begin
	if (el.FPrev<>nil) then el.FPrev.FNext:=el.FNext;
	if (el.FNext<>nil) then el.FNext.FPrev:=el.FPrev;
	if (FLast=el) then FLast:=el.FPrev;
	if (FFirst=el) then FFirst:=el.FNext;

    FreeFree(el);
end;

procedure TCodeAnalyzerEC.BuildAdd(wstr:WideString; startstr:integer; enteradd:integer);
var
    sim:WideChar;
    i:integer;
    tu:TCodeAnalyzerUnitEC;
    count:integer;
    start:integer;
    zsme,zlen:integer;
//    numchar:integer;
begin
	count:=Length(wstr);
	start:=-1;
    zsme:=-1;
    zlen:=0;
//	numchar:=-1;
    i:=0;

    while i<count do begin
		sim:=wstr[i+1];
//		inc(numchar);
		if start=-1 then begin
			if sim='(' then begin // (
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeOpen1; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim=')' then begin // )
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeClose1; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='{' then begin // {
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeOpen2; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='}' then begin // }
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeClose2; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='[' then begin // [
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeOpen3; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim=']' then begin // ]
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeClose3; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if (sim='/') and ((i+1)<count) and (wstr[i+1+1]='*') then begin // /*
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeOpen4; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='*') and ((i+1)<count) and (wstr[i+1+1]='/') then begin// */
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeClose4; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='/') and ((i+1)<count) and (wstr[i+1+1]='/') then begin// //
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeCom; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if sim='.' then begin // .
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caePoint; tu.FSme:=i+startstr; tu.FLen:=2;
			end else if (sim='-') and ((i+1)<count) and (wstr[i+1+1]='>') then begin // ->
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caePointer; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='&') and ((i+1)<count) and (wstr[i+1+1]='&') then begin // &&
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeAnd; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='|') and ((i+1)<count) and (wstr[i+1+1]='|') then begin // ||
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeOr; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if sim='+' then begin // +
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeAdd; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='-' then begin // -
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeSub; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='*' then begin // *
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeMul; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='/' then begin // /
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeDiv; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='%' then begin // %
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeMod; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='&' then begin // &
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeBitAnd; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='|' then begin // |
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeBitOr; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='^' then begin // ^
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeBitXor; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='~' then begin // ~
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeBitNot; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if (sim='!') and ((i+1)<count) and (wstr[i+1+1]='=') then begin // !=
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeNotEqual; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if sim='!' then begin // !
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeNot; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if (sim='<') and ((i+1)<count) and (wstr[i+1+1]='<') then begin // <<
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeShl; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='>') and ((i+1)<count) and (wstr[i+1+1]='>') then begin // >>
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeShr; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='=') and ((i+1)<count) and (wstr[i+1+1]='=') then begin // ==
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeEqual; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if sim='=' then begin // =
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeAssume; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if (sim='<') and ((i+1)<count) and (wstr[i+1+1]='=') then begin // <=
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeLessEqual; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if (sim='>') and ((i+1)<count) and (wstr[i+1+1]='=') then begin // >=
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeMoreEqual; tu.FSme:=i+startstr; tu.FLen:=2;
//				inc(numchar);
				inc(i);
			end else if sim='<' then begin // <
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeLess; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim='>' then begin // >
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeMore; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim=';' then begin // ;
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeSemicolon; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim=':' then begin // :
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeColon; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if sim=',' then begin // ,
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeComma; tu.FSme:=i+startstr; tu.FLen:=1;
			end else if (sim=' ') or (sim=#9) then begin // space
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
                if (FLast=nil) or ((FLast<>nil) and (FLast.FType<>caeSpace)) then begin
    				tu:=UnitAdd();
	    			tu.FType:=caeSpace; tu.FSme:=i+startstr; tu.FLen:=1;
                end else inc(FLast.FLen);
			end else if (sim=#13) or (sim=#10) then begin // Enter
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeEnter; tu.FSme:=i+startstr; tu.FLen:=1;
                startstr:=startstr+enteradd;
//				numchar:=-1;
//				inc(startstr);
				if ((i+1)<count) and ((wstr[i+1+1]=#13) or (wstr[i+1+1]=#10)) then begin inc(i); inc(tu.FLen); end;
			end else if (sim='"') or (sim='''') then begin	// String
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); inc(FLast.FLen,zlen); end; //zsme:=-1;
				tu:=UnitAdd();
				tu.FType:=caeStr; //tu.FSme:=i+startstr; tu.FLen:=1;
				start:=i;
                FLast.FSme:=i+startstr;
                FLast.FLen:=2;
                FLast.FStr:='';
                zsme:=i+1; zlen:=0;
			end else if sim>' ' then begin // Name
				if (FLast=nil) or (FLast.FType<>caeName) then begin
					tu:=UnitAdd();
    				tu.FType:=caeName; //tu.FSme:=i+startstr; tu.FLen:=1;
//                    FLast.FStr:=sim;
                    FLast.FSme:=i+startstr;
                    FLast.FLen:=0;
                    FLast.FStr:='';
                    zsme:=i; zlen:=1;
				end else begin
                    inc(zlen);
//                    FLast.FStr:=FLast.FStr+sim; inc(FLast.FLen);
                end;
            end;
        end else begin
			if FLast.FType=caeStr then begin
//                inc(FLast.FLen);
                inc(zlen);
				if sim='\' then begin
					if ((i+1)<count) and (wstr[i+1+1]='\') then begin
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen-1); inc(FLast.FLen,zlen-1); end;
						FLast.FStr:=FLast.FStr+sim;
                        FLast.FLen:=FLast.FLen+2;
//                        inc(FLast.FLen);
						inc(i);
zsme:=i+1; zlen:=0;
					end else if ((i+1)<count) and (wstr[i+1+1]='"') then begin
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen-1); inc(FLast.FLen,zlen-1); end;
						FLast.FStr:=FLast.FStr+'"';
                        FLast.FLen:=FLast.FLen+2;
//                        inc(FLast.FLen);
						inc(i);
zsme:=i+1; zlen:=0;
					end else if ((i+1)<count) and (wstr[i+1+1]='''') then begin
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen-1); inc(FLast.FLen,zlen-1); end;
						FLast.FStr:=FLast.FStr+'''';
                        FLast.FLen:=FLast.FLen+2;
//                        inc(FLast.FLen);
						inc(i);
zsme:=i+1; zlen:=0;
					end else if ((i+1)<count) and (wstr[i+1+1]='n') then begin
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen-1); inc(FLast.FLen,zlen-1); end;
						FLast.FStr:=FLast.FStr+#13#10;
                        FLast.FLen:=FLast.FLen+2;
//                        inc(FLast.FLen);
						inc(i);
zsme:=i+1; zlen:=0;
					end;
                end else if (sim='"') or (sim='''') then begin
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen-1); inc(FLast.FLen,zlen-1); end; zsme:=-1;
                    start:=-1;
				end else begin
//                    FLast.FStr:=FLast.FStr+sim;
//                    inc(zlen);
				end;
			end;
        end;
        inc(i);
    end;
if (zsme>=0) and (zlen>0) then begin FLast.FStr:=FLast.FStr+Copy(wstr,zsme+1,zlen); end;
end;

procedure TCodeAnalyzerEC.Build(wstr:WideString; enteradd:integer);
begin
    Clear();
    BuildAdd(wstr,0,enteradd);
end;

function TCodeAnalyzerEC.BuildStr(strshowquate:boolean; ustart,uend:TCodeAnalyzerUnitEC):WideString;
var
    tu:TCodeAnalyzerUnitEC;
    tstr:WideString;
begin
    if ustart=nil then ustart:=FFirst;

    tstr:='';
	tu:=ustart;
	while (tu<>nil) and (tu<>uend) do begin

//tstr:=tstr+'~';

		if tu.FType=caeEnter then tstr:=tstr+#13#10
		else if (tu.FType=caeSpace) then tstr:=tstr+' '
		else if (tu.FType=caeOpen1) then tstr:=tstr+'('
		else if (tu.FType=caeClose1) then tstr:=tstr+')'
		else if (tu.FType=caeOpen2) then tstr:=tstr+'{'
		else if (tu.FType=caeClose2) then tstr:=tstr+'}'
		else if (tu.FType=caeOpen3) then tstr:=tstr+'['
		else if (tu.FType=caeClose3) then tstr:=tstr+']'
		else if (tu.FType=caeOpen4) then tstr:=tstr+'/*'
		else if (tu.FType=caeClose4) then tstr:=tstr+'*/'
		else if (tu.FType=caeCom) then tstr:=tstr+'//'
		else if (tu.FType=caePoint) then tstr:=tstr+'.'
		else if (tu.FType=caePointer) then tstr:=tstr+'->'
		else if (tu.FType=caeAdd) then tstr:=tstr+'+'
		else if (tu.FType=caeSub) then tstr:=tstr+'-'
		else if (tu.FType=caeMul) then tstr:=tstr+'*'
		else if (tu.FType=caeDiv) then tstr:=tstr+'/'
		else if (tu.FType=caeMod) then tstr:=tstr+'%'
		else if (tu.FType=caeBitAnd) then tstr:=tstr+'&'
		else if (tu.FType=caeBitOr) then tstr:=tstr+'|'
		else if (tu.FType=caeBitXor) then tstr:=tstr+'^'
		else if (tu.FType=caeBitNot) then tstr:=tstr+'~'
		else if (tu.FType=caeAnd) then tstr:=tstr+'&&'
		else if (tu.FType=caeOr) then tstr:=tstr+'||'
		else if (tu.FType=caeNot) then tstr:=tstr+'!'
		else if (tu.FType=caeShl) then tstr:=tstr+'<<'
		else if (tu.FType=caeShr) then tstr:=tstr+'>>'
		else if (tu.FType=caeAssume) then tstr:=tstr+'='
		else if (tu.FType=caeEqual) then tstr:=tstr+'=='
		else if (tu.FType=caeNotEqual) then tstr:=tstr+'!='
		else if (tu.FType=caeLess) then tstr:=tstr+'<'
		else if (tu.FType=caeMore) then tstr:=tstr+'>'
		else if (tu.FType=caeLessEqual) then tstr:=tstr+'<='
		else if (tu.FType=caeMoreEqual) then tstr:=tstr+'>='
		else if (tu.FType=caeSemicolon) then tstr:=tstr+';'
		else if (tu.FType=caeColon) then tstr:=tstr+':'
		else if (tu.FType=caeComma) then tstr:=tstr+','
		else if (tu.FType=caeStr) and strshowquate then tstr:=tstr+'"'+tu.FStr+'"'
        else if (tu.FType=caeStr) then tstr:=tstr+tu.FStr
		else if (tu.FType=caeName) then tstr:=tstr+tu.FStr;

//tstr:=tstr+'~';

		tu:=tu.FNext;
	end;

    Result:=tstr;
end;

function TCodeAnalyzerEC.TestOpenClose:WideString;
var
    i,count,count2:integer;
    tu:TCodeAnalyzerUnitEC;
    av:array of BYTE;
begin
    Result:='';
	count:=0;
    count2:=0;

	tu:=FFirst;
	while tu<>nil do begin
		if (tu.FType=caeOpen1) or (tu.FType=caeOpen2) or (tu.FType=caeOpen3) or (tu.FType=caeOpen4) then inc(count);
		if (tu.FType=caeClose1) or (tu.FType=caeClose2) or (tu.FType=caeClose3) or (tu.FType=caeClose4) then inc(count2);
		tu:=tu.FNext;
	end;
    if count<>count2 then begin
        Result:=CErrorEXP(0,FLast.FSme+FLast.FLen); Exit;
        Exit;
    end;
	if count<1 then Exit;

    SetLength(av,count);
    try
		i:=0;
		tu:=FFirst;
		while tu<>nil do begin
			if tu.FType=caeOpen1 then begin av[i]:=1; inc(i); end
			else if(tu.FType=caeOpen2) then begin av[i]:=2; inc(i); end
			else if(tu.FType=caeOpen3) then begin av[i]:=3; inc(i); end
			else if(tu.FType=caeOpen4) then begin av[i]:=4; inc(i); end
			else if(tu.FType=caeClose1) then begin
				if (count<1) or (av[i-1]<>1) then begin
                    Result:=CErrorEXP(0,tu.FSme);
                    av:=nil;
                    Exit;
                end;
				dec(i);
			end else if(tu.FType=caeClose2) then begin
				if (count<1) or (av[i-1]<>2) then begin
                    Result:=CErrorEXP(0,tu.FSme);
                    av:=nil;
                    Exit;
                end;
				dec(i);
			end else if(tu.FType=caeClose3) then begin
				if (count<1) or (av[i-1]<>3) then begin
                    Result:=CErrorEXP(0,tu.FSme);
                    av:=nil;
                    Exit;
                end;
				dec(i);
			end else if(tu.FType=caeClose4) then begin
				if (count<1) or (av[i-1]<>4) then begin
                    Result:=CErrorEXP(0,tu.FSme);
                    av:=nil;
                    Exit;
                end;
				dec(i);
			end;
			tu:=tu.FNext;
		end;
		if i>0 then begin
            Result:=CErrorEXP(0,FLast.FSme+FLast.FLen);
            av:=nil;
            Exit;
        end;
    except
        av:=nil;
        raise;
    end;
    av:=nil;
end;

procedure TCodeAnalyzerEC.DelSpace;
var
    tu,tu2:TCodeAnalyzerUnitEC;
begin
    tu:=FFirst;
    while tu<>nil do begin
        tu2:=tu;
        tu:=tu.FNext;
        if tu2.FType=caeSpace then begin
            UnitDel(tu2);
        end;
    end;
end;

procedure TCodeAnalyzerEC.DelEnter;
var
    tu,tu2:TCodeAnalyzerUnitEC;
begin
    tu:=FFirst;
    while tu<>nil do begin
        tu2:=tu;
        tu:=tu.FNext;
        if tu2.FType=caeEnter then begin
            UnitDel(tu2);
        end;
    end;
end;

procedure TCodeAnalyzerEC.DelCom;
var
    tu,tu2:TCodeAnalyzerUnitEC;
    fcomLine:boolean;
    fcomBlock:integer;
begin
    fcomLine:=false; fcomBlock:=0;
    tu:=FFirst;
    while tu<>nil do begin
        tu2:=tu;
        tu:=tu.FNext;

        if (fcomLine=false) and (fcomBlock=0) then begin
            if tu2.FType=caeOpen4 then begin
                fcomBlock:=1;
                UnitDel(tu2);
            end else if tu2.FType=caeCom then begin
                fcomLine:=true;
                UnitDel(tu2);
            end;
        end else begin
            if (fcomBlock<>0) and (tu2.FType=caeOpen4) then begin
                inc(fcomBlock);
            end else if fcomLine and (tu2.FType=caeEnter) then begin
                fcomLine:=false;
            end else if (fcomBlock<>0) and (tu2.FType=caeClose4) then begin
                dec(fcomBlock);
            end;
            UnitDel(tu2);
        end;
    end;
end;

procedure TCodeAnalyzerEC.ConvertCom;
var
    tu,tu2,tucom:TCodeAnalyzerUnitEC;
    fcomLine:boolean;
    fcomBlock:integer;
begin
    tucom:=nil;
    fcomLine:=false; fcomBlock:=0;
    tu:=FFirst;
    while tu<>nil do begin
        tu2:=tu;
        tu:=tu.FNext;

        if (fcomLine=false) and (fcomBlock=0) then begin
            if tu2.FType=caeOpen4 then begin
                fcomBlock:=1;
//                UnitDel(tu2);
                tucom:=tu2;
                tucom.FType:=caeConvertCom;
                tucom.FStr:='';
            end else if tu2.FType=caeCom then begin
                fcomLine:=true;
//                UnitDel(tu2);
                tucom:=tu2;
                tucom.FType:=caeConvertCom;
                tucom.FStr:='';
            end;
        end else begin
            if (fcomBlock<>0) and (tu2.FType=caeOpen4) then begin
                inc(fcomBlock);
                tucom.FLen:=tu2.FSme-tucom.FSme;
            end else if fcomLine and (tu2.FType=caeEnter) then begin
                fcomLine:=false;
                tucom.FLen:=tu2.FSme-tucom.FSme;
            end else if (fcomBlock<>0) and (tu2.FType=caeClose4) then begin
                dec(fcomBlock);
                tucom.FLen:=tu2.FSme-tucom.FSme+tu2.FLen;
            end;
            UnitDel(tu2);
        end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
destructor TExpressionInstrEC.Destroy;
begin
    FIndex:=nil;
    inherited Destroy;
end;

procedure TExpressionInstrEC.InitInstr(zn:caeTypeEC);
begin
    if zn=caeAdd then FType:=eieAdd
    else if zn=caeSub then FType:=eieSub
    else if zn=caeMul then FType:=eieMul
    else if zn=caeDiv then FType:=eieDiv
    else if zn=caeMod then FType:=eieMod
    else if zn=caeBitAnd then FType:=eieBitAnd
    else if zn=caeBitOr then FType:=eieBitOr
    else if zn=caeBitXor then FType:=eieBitXor
    else if zn=caeBitNot then FType:=eieBitNot
    else if zn=caeAnd then FType:=eieAnd
    else if zn=caeOr then FType:=eieOr
    else if zn=caeNot then FType:=eieNot
    else if zn=caeShl then FType:=eieShl
    else if zn=caeShr then FType:=eieShr
    else if zn=caeEqual then FType:=eieEqual
    else if zn=caeNotEqual then FType:=eieNotEqual
    else if zn=caeLess then FType:=eieLess
    else if zn=caeMore then FType:=eieMore
    else if zn=caeLessEqual then FType:=eieLessEqual
    else if zn=caeMoreEqual then FType:=eieMoreEqual
    else raise ExceptionExpressionEC.Create('InitInstr');
end;

procedure TExpressionInstrEC.CopyFrom(sou:TExpressionInstrEC);
var
    i:integer;
begin
    FType:=sou.FType;
    FCount:=sou.FCount;
    FIndex:=nil;
    if sou.FIndex<>nil then begin
        SetLength(FIndex,FCount);
        for i:=0 to FCount-1 do FIndex[i]:=sou.FIndex[i];
    end;
end;

destructor TExpressionVarEC.Destroy;
begin
    if FType=evteTemp then FVar.Free;
    FVar:=nil;
    FPath:=nil;
    inherited Destroy;
end;

procedure TExpressionVarEC.CopyFrom(sou:TExpressionVarEC);
var
    i,cnt:integer;
begin
    FName:=sou.FName;
    FType:=sou.FType;
    FVar:=nil;
    if (FType=evteExtern) then FVar:=sou.FVar
    else if (FType=evteTemp) and (sou.FVar<>nil) then begin
        FVar:=TVarEC.Create;
        FVar.CopyFrom(sou.FVar);
    end;
    if sou.FPath<>nil then begin
        cnt:=High(sou.FPath)+1;
        SetLength(FPath,cnt);
        for i:=0 to cnt-1 do FPath[i]:=sou.FPath[i];
    end;
end;

function TExpressionVarEC.BuildPath:boolean;
var
    istart,iend,lenstr,i,cnt:integer;
    str:WideString;
begin
    Result:=true;
    str:=FName;
    lenstr:=Length(str);

    istart:=0;
    iend:=istart;
    while iend<lenstr do begin if str[iend+1]='.' then break; inc(iend); end;
    if iend>=lenstr then begin Exit; end;

    FName:=Copy(str,istart+1,iend-istart);

    cnt:=1;
    for i:=(iend+1) to lenstr-1 do if str[i+1]='.' then inc(cnt);
    SetLength(FPath,cnt);

    i:=0;
    while (iend+1)<lenstr do begin
        istart:=iend+1;
        iend:=istart;
        while iend<lenstr do begin if str[iend+1]='.' then break; inc(iend); end;

        FPath[i]:=Copy(str,istart+1,iend-istart);
        inc(i);
    end;

    Result:=true;
end;

function TExpressionVarEC.Name:WideString;
var
    i:integer;
begin
    Result:=FName;
    if FPath<>nil then begin
        for i:=0 to High(FPath) do begin
            Result:=Result+'.'+FPath[i];
        end;
    end;
end;

function TExpressionVarEC.GetVar(newtype:VariableTypeEC):TVarEC;
var
    i:integer;
begin
    if FVar<>nil then begin
        if FPath=nil then Result:=FVar
        else begin
//            raise ExceptionExpressionEC.Create('Not link var :'+Name);
//            Result:=nil;

//FindClassMember

            Result:=FVar;
            i:=0;
            while i<=High(FPath) do begin
//                if Result.VType<>vtClass then raise ExceptionExpressionEC.Create('Not link var :'+Name);
//                Result:=Result.VClass.FindClassMember(FPath[i]);
                if Result.VType=vtClass then begin
                    Result:=Result.VClass.FindClassMember(FPath[i]);
                end else if Result.VType=vtFun then begin
                    Result:=Result.VFun.FindClassMember(FPath[i]);
                end else raise ExceptionExpressionEC.Create('Not link var :'+Name);
                if Result=nil then raise ExceptionExpressionEC.Create('Not link var :'+Name);

                inc(i);
            end;

{            Result:=FVar;
            i:=0;
            while i<=High(FPath) do begin
                if Result.VType<>vtFun then raise ExceptionExpressionEC.Create('Not link var :'+Name);
                Result:=Result.VFun.FLocalVar.GetVarNE(FPath[i]);
                if Result=nil then raise ExceptionExpressionEC.Create('Not link var :'+Name);
                inc(i);
            end;}
        end;
    end else begin
        if (FType=evteTemp) then begin
            FVar:=TVarEC.Create(newtype);
        end else raise ExceptionExpressionEC.Create('Not link var :'+Name);
        Result:=FVar;
    end;
end;

constructor TExpressionEC.Create;
begin
    inherited Create;
end;

destructor TExpressionEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TExpressionEC.Clear;
begin
    while FVarCount>0 do VarDel(FVarCount-1);
    if not FInstrExtern then while FInstrCount>0 do InstrDel(FInstrCount-1);
    FRet:=-1;
    FInstrExtern:=false;
end;

procedure TExpressionEC.CopyFrom(sou:TExpressionEC);
var
    i:integer;
//    souevar,desevar:TExpressionVarEC;
begin
    Clear;

    for i:=0 to sou.FVarCount-1 do begin
        EVar[VarAdd()].CopyFrom(sou.EVar[i]);
    end;

    for i:=0 to sou.FInstrCount-1 do begin
        Instr[InstrAdd()].CopyFrom(sou.Instr[i]);
    end;

    FRet:=sou.FRet;
end;

procedure TExpressionEC.CopyFromFast(sou:TExpressionEC);
var
    i:integer;
begin
    Clear;

    for i:=0 to sou.FVarCount-1 do begin
        EVar[VarAdd()].CopyFrom(sou.EVar[i]);
    end;

    FInstrCount:=sou.FInstrCount;
    FInstr:=sou.FInstr;
    FInstrExtern:=true;

    FRet:=sou.FRet;
end;

function TExpressionEC.VarAdd:integer;
begin
    inc(FVarCount);
    if FVar=nil then FVar:=HeapAlloc(GetProcessHeap(),0,FVarCount*4)
    else FVar:=HeapRealloc(GetProcessHeap(),0,FVar,FVarCount*4);
    EVar[FVarCount-1]:=TExpressionVarEC.Create;
    Result:=FVarCount-1;
end;

procedure TExpressionEC.VarDel(no:integer);
var
    i:integer;
begin
    if (no<0) or (no>=FVarCount) then Exit;
    EVar[no].Free;
    for i:=no to FVarCount-2 do EVar[i]:=EVar[i+1];
    dec(FVarCount);
    if FVarCount<=0 then begin
        HeapFree(GetProcessHeap(),0,FVar);
        FVar:=nil;
    end;
end;

function TExpressionEC.EVarGet(no:integer):TExpressionVarEC;
asm
    push    eax
    push    ebx
    mov     ebx,self
    mov     eax,no
    shl     eax,2
    add     eax,TExpressionEC(ebx).FVar
    mov     eax,[eax]
    mov     Result,eax
    pop     ebx
    pop     eax
end;

procedure TExpressionEC.EVarSet(no:integer; zn:TExpressionVarEC);
asm
    push    eax
    push    ebx
    mov     ebx,self
    mov     eax,no
    shl     eax,2
    add     eax,TExpressionEC(ebx).FVar
    mov     ebx,zn
    mov     [eax],ebx
    pop     ebx
    pop     eax
end;

function TExpressionEC.InstrAdd:integer;
begin
    inc(FInstrCount);
    if FInstr=nil then FInstr:=HeapAlloc(GetProcessHeap(),0,FInstrCount*4)
    else FInstr:=HeapRealloc(GetProcessHeap(),0,FInstr,FInstrCount*4);
    Instr[FInstrCount-1]:=TExpressionInstrEC.Create;
    Result:=FInstrCount-1;
end;

procedure TExpressionEC.InstrDel(no:integer);
var
    i:integer;
begin
    if (no<0) or (no>=FInstrCount) then Exit;
    Instr[no].Free;
    for i:=no to FInstrCount-2 do Instr[i]:=Instr[i+1];
    dec(FInstrCount);
    if FInstrCount<=0 then begin
        HeapFree(GetProcessHeap(),0,FInstr);
        FInstr:=nil;
    end;
end;

function TExpressionEC.EInstrGet(no:integer):TExpressionInstrEC; cdecl;
asm
    push    eax
    push    ebx
    mov     ebx,self
    mov     eax,no
    shl     eax,2
    add     eax,TExpressionEC(ebx).FInstr
    mov     eax,[eax]
    mov     Result,eax
    pop     ebx
    pop     eax
end;

procedure TExpressionEC.EInstrSet(no:integer; zn:TExpressionInstrEC); cdecl;
asm
    push    eax
    push    ebx
    mov     ebx,self
    mov     eax,no
    shl     eax,2
    add     eax,TExpressionEC(ebx).FInstr
    mov     ebx,zn
    mov     [eax],ebx
    pop     ebx
    pop     eax
end;

{$WARNINGS OFF}
function TExpressionEC.Compiler(ca:TCodeAnalyzerEC; curclass:TCodeEC; castart:TCodeAnalyzerUnitEC; caend:TCodeAnalyzerUnitEC; endcompl:PDWORD):WideString;
var
    el,el2:TCodeAnalyzerUnitEC;
//    fcomLine,fcomBlock:boolean;
    cp:TCompilerEC;
    cpu,cpu2,cpu3:TCompilerUnitEC;
    no,fopen,cnt,i:integer;
    exvar:TExpressionVarEC;
    elinstr:TExpressionInstrEC;

    zint:integer;
    zdw:DWORD;
    zfloat:double;
    zstr:WideString;
begin
    Clear;

    Result:='';

    if castart=nil then castart:=ca.FFirst;

    if castart=nil then begin
        Result:=CErrorEXP(0,0);
        Exit;
    end;

//    fcomLine:=false;
//    fcomBlock:=false;

    cp:=TCompilerEC.Create;

    fopen:=0;

    el:=castart;
    while el<>caend do begin
//        if (fcomLine=false) and (fcomBlock=false) then begin
            if el.FType=caeOpen4 then begin
//                fcomBlock:=true;
            end else if el.FType=caeCom then begin
//                fcomLine:=true;
            end else if el.FType=caeStr then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutConstStr;
                cpu.FStr:=el.FStr;
            end else if el.FType=caeComma then begin
                if fopen<=0 then break;
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutComma;
            end else if el.FType=caeAssume then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutAssume;
            end else if el.FType=caeOpen1 then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutOpen;
                inc(fopen);
            end else if el.FType=caeClose1 then begin
                dec(fopen); if fopen<0 then break;
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutClose;
            end else if el.FType=caeOpen3 then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutOpenArray;
                inc(fopen);
            end else if el.FType=caeClose3 then begin
                dec(fopen); if fopen<0 then break;
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutCloseArray;
            end else if el.FType=caeAssume then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutAssume;
            end else if (el.FType=caeBitNot) or (el.FType=caeNot) then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutOperatorUnary;
                cpu.FOper:=el.FType;
            end else if (el.FType=caeAdd) or
                        (el.FType=caeSub) or
                        (el.FType=caeMul) or
                        (el.FType=caeDiv) or
                        (el.FType=caeMod) or
                        (el.FType=caeSub) or
                        (el.FType=caeBitAnd) or
                        (el.FType=caeBitOr) or
                        (el.FType=caeBitXor) or
                        (el.FType=caeAnd) or
                        (el.FType=caeOr) or
                        (el.FType=caeShl) or
                        (el.FType=caeShr) or
                        (el.FType=caeEqual) or (el.FType=caeNotEqual) or (el.FType=caeLess) or (el.FType=caeMore) or (el.FType=caeLessEqual) or (el.FType=caeMoreEqual) then begin
                cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                cpu.FType:=cutOperator;
                cpu.FOper:=el.FType;
            end else if el.FType=caeName then begin
                el2:=el;
                if DecodeFloatEXP(el2,zfloat) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; if el2=nil then cpu.FLen:=ca.FLast.FSme+ca.FLast.FLen-el.FSme else cpu.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-el.FSme;
                    cpu.FType:=cutConstFloat;
                    cpu.FVFloat:=zfloat;
                    el:=el2;
                    continue;
                end else if DecodeDWEXP(el2,zdw) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; if el2=nil then cpu.FLen:=ca.FLast.FSme+ca.FLast.FLen-el.FSme else cpu.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-el.FSme;
                    cpu.FType:=cutConstDW;
                    cpu.FVDW:=zdw;
                    el:=el2;
                    continue;
                end else if DecodeIntEXP(el2,zint) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; if el2=nil then cpu.FLen:=ca.FLast.FSme+ca.FLast.FLen-el.FSme else cpu.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-el.FSme;
                    cpu.FType:=cutConstInt;
                    cpu.FVInt:=zint;
                    el:=el2;
                    continue;
                end else if DecodeStrEXP(el2,zstr) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; if el2=nil then cpu.FLen:=ca.FLast.FSme+ca.FLast.FLen-el.FSme else cpu.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-el.FSme;
                    cpu.FType:=cutConstStr;
                    cpu.FStr:=zstr;
                    el:=el2;
                    continue;
                end else if DecodeVarEXP(el2,zstr) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; if el2=nil then cpu.FLen:=ca.FLast.FSme+ca.FLast.FLen-el.FSme else cpu.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-el.FSme;
                    cpu.FType:=cutName;
                    cpu.FStr:=zstr;
                    el:=el2;
                    continue;
{                end else if IsVarEXP(el.FStr) then begin
                    cpu:=cp.UnitAdd; cpu.FSme:=el.FSme; cpu.FLen:=el.FLen;
                    cpu.FType:=cutName;
                    cpu.FStr:=el.FStr;}
                end else begin
                    Result:=CErrorEXP(0,el.FSme);
                    cp.Free;
                    Exit;
                end;
            end else if (el.FType=caeSemicolon) then begin
                break;
            end else if (el.FType=caeEnter) or (el.FType=caeSpace) then begin
            end else begin
                Result:=CErrorEXP(0,el.FSme);
                cp.Free;
                Exit;
            end;
//        end else begin
//            if fcomLine and (el.FType=caeEnter) then begin
//                fcomLine:=false;
//            end else if fcomBlock and (el.FType=caeClose4) then begin
//                fcomBlock:=false;
//            end;
//        end;
        el:=el.FNext;
    end;
    if endcompl<>nil then endcompl^:=DWORD(el);

    // Find function,array and test OpenClose
    fopen:=0;
    cpu:=cp.FFirst;
    while cpu<>nil do begin
        if (cpu.FType=cutOpen) and (cpu.FPrev<>nil) and (cpu.FPrev.FType=cutName) then begin
            cpu.FType:=cutFun;
            cpu.FStr:=cpu.FPrev.FStr;
            cp.UnitDel(cpu.FPrev);
            inc(fopen);
        end else if (cpu.FType=cutOpenArray) then begin
            if (cpu.FPrev<>nil) and (cpu.FPrev.FType=cutName) then begin
                cpu.FType:=cutArray;
                cpu.FStr:=cpu.FPrev.FStr;
                cp.UnitDel(cpu.FPrev);
                inc(fopen);
            end else begin
                Result:=CErrorEXP(0,cpu.FSme);
                cp.Free;
                Exit;
            end;
        end else if cpu.FType=cutOpen then begin
            inc(fopen);
        end else if cpu.FType=cutClose then begin
            dec(fopen);
        end else if cpu.FType=cutCloseArray then begin
            dec(fopen);
        end;
        cpu:=cpu.FNext;
    end;

    if fopen<>0 then begin
        if el=nil then el:=ca.FLast;
        Result:=CErrorEXP(0,el.FSme+el.FLen);
        cp.Free;
        Exit;
    end;

    // Find minus and unary minus
    cpu:=cp.FFirst;
    while cpu<>nil do begin
        if (cpu.FType=cutOperator) and (cpu.FOper=caeSub) and (cpu.FNext<>nil) and ((cpu.FNext.FType=cutConstInt) or (cpu.FNext.FType=cutConstFloat)) then begin
            if (cpu.FPrev=nil) or ((cpu.FPrev.FType<>cutConstInt) and (cpu.FPrev.FType<>cutConstDW) and (cpu.FPrev.FType<>cutConstFloat) and (cpu.FPrev.FType<>cutClose) and (cpu.FPrev.FType<>cutCloseArray) and (cpu.FPrev.FType<>cutName)) then begin
                cpu:=cpu.FNext;

                cp.UnitDel(cpu.FPrev);
                cpu.FVInt:=-cpu.FVInt;
                cpu.FVFloat:=-cpu.FVFloat;
            end;
        end else if (cpu.FType=cutOperator) and (cpu.FOper=caeSub) and (cpu.FNext<>nil) and ((cpu.FNext.FType=cutConstInt) or (cpu.FNext.FType=cutConstDW) or (cpu.FNext.FType=cutConstFloat) or (cpu.FNext.FType=cutOpen) or (cpu.FNext.FType=cutFun) or (cpu.FNext.FType=cutArray) or (cpu.FNext.FType=cutName)) then begin
            if (cpu.FPrev=nil) or ((cpu.FPrev.FType<>cutConstInt) and (cpu.FPrev.FType<>cutConstDW) and (cpu.FPrev.FType<>cutConstFloat) and (cpu.FPrev.FType<>cutClose) and (cpu.FPrev.FType<>cutCloseArray) and (cpu.FPrev.FType<>cutName)) then begin
                cpu.FType:=cutOperatorUnary;
            end;
        end;
        cpu:=cpu.FNext;
    end;

    // Test operation
    cpu:=cp.FFirst;
    while cpu<>nil do begin
        if cpu.FType=cutOperator then begin
            if (cpu.FPrev=nil) or
               (cpu.FNext=nil) or
               ((cpu.FPrev.FType<>cutName) and (cpu.FPrev.FType<>cutConstInt) and (cpu.FPrev.FType<>cutConstDW) and (cpu.FPrev.FType<>cutConstFloat) and (cpu.FPrev.FType<>cutConstStr) and (cpu.FPrev.FType<>cutClose) and (cpu.FPrev.FType<>cutCloseArray)) or
               ((cpu.FNext.FType<>cutName) and (cpu.FNext.FType<>cutConstInt) and (cpu.FNext.FType<>cutConstDW) and (cpu.FNext.FType<>cutConstFloat) and (cpu.FNext.FType<>cutConstStr) and (cpu.FNext.FType<>cutOpen) and (cpu.FNext.FType<>cutFun) and (cpu.FNext.FType<>cutArray) and (cpu.FNext.FType<>cutOperatorUnary))
            then begin
                Result:=CErrorEXP(0,cpu.FSme);
                cp.Free;
                Exit;
            end;
        end else if cpu.FType=cutAssume then begin
            if (cpu.FPrev=nil) or
               (cpu.FNext=nil) or
               ((cpu.FPrev.FType<>cutName) and (cpu.FPrev.FType<>cutCloseArray)) or
               ((cpu.FNext.FType<>cutName) and (cpu.FNext.FType<>cutConstInt) and (cpu.FNext.FType<>cutConstDW) and (cpu.FNext.FType<>cutConstFloat) and (cpu.FNext.FType<>cutConstStr) and (cpu.FNext.FType<>cutOpen) and (cpu.FNext.FType<>cutFun) and (cpu.FNext.FType<>cutArray) and (cpu.FNext.FType<>cutOperatorUnary))
            then begin
                Result:=CErrorEXP(0,cpu.FSme);
                cp.Free;
                Exit;
            end;
        end else if cpu.FType=cutOperatorUnary then begin
            if (cpu.FNext=nil) or
               ((cpu.FNext.FType<>cutName) and (cpu.FNext.FType<>cutConstInt) and (cpu.FNext.FType<>cutConstDW) and (cpu.FNext.FType<>cutConstFloat) and (cpu.FNext.FType<>cutConstStr) and (cpu.FNext.FType<>cutOpen) and (cpu.FNext.FType<>cutFun) and (cpu.FNext.FType<>cutArray) and (cpu.FNext.FType<>cutOperatorUnary))
            then begin
                Result:=CErrorEXP(0,cpu.FSme);
                cp.Free;
                Exit;
            end;
        end;

        cpu:=cpu.FNext;
    end;

    // Создаем переменные
    cpu:=cp.FFirst;
    while cpu<>nil do begin
        if cpu.FType=cutConstInt then begin
            cpu.FType:=cutVar;
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteTemp;
            exvar.FVar:=TVarEC.Create(vtInt);
            exvar.FVar.VInt:=cpu.FVInt;
        end else if cpu.FType=cutConstDW then begin
            cpu.FType:=cutVar;
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteTemp;
            exvar.FVar:=TVarEC.Create(vtDW);
            exvar.FVar.VDW:=cpu.FVDW;
        end else if cpu.FType=cutConstFloat then begin
            cpu.FType:=cutVar;
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteTemp;
            exvar.FVar:=TVarEC.Create(vtFloat);
            exvar.FVar.VFloat:=cpu.FVFloat;
        end else if cpu.FType=cutConstStr then begin
            cpu.FType:=cutVar;
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteTemp;
            exvar.FVar:=TVarEC.Create(vtStr);
            exvar.FVar.VStr:=cpu.FStr;
        end else if cpu.FType=cutName then begin
            cpu.FType:=cutVar;
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteExtern;
            exvar.FName:=cpu.FStr;
            if not exvar.BuildPath then begin Result:=CErrorEXP(0,cpu.FSme); cp.Free; Exit; end;
        end else if cpu.FType=cutFun then begin
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteExtern;
            exvar.FName:=cpu.FStr;
            if not exvar.BuildPath then begin Result:=CErrorEXP(0,cpu.FSme); cp.Free; Exit; end;
        end else if cpu.FType=cutArray then begin
            cpu.FVar:=VarAdd;
            exvar:=EVar[cpu.FVar];
            exvar.FType:=evteExtern;
            exvar.FName:=cpu.FStr;
            if not exvar.BuildPath then begin Result:=CErrorEXP(0,cpu.FSme); cp.Free; Exit; end;
        end;

        cpu:=cpu.FNext;
    end;

    if cp.FFirst=nil then begin
        Result:=CErrorEXP(0,0);
        cp.Free;
        Exit;
    end;

    // Создание инструкций
    while cp.FFirst.FNext<>nil do begin
        cpu:=cp.GetArray;
        if cpu=nil then cpu:=cp.GetFun;
        if cpu=nil then cpu:=cp.GetOper;
//        cpu2:=cpu;
        if cpu=nil then begin
            Clear;
            if cp.FFirst=nil then begin
                Result:='Unknown error';
            end else begin
                Result:=CErrorEXP(0,cp.FFirst.FSme);
            end;
            cp.Free;
            Exit;
            raise ExceptionExpressionEC.Create('Unknown error');
        end else if (cpu.FType=cutFun) or (cpu.FType=cutArray) then begin
            cnt:=0;
            cpu3:=cpu.FNext;
            while cpu3<>nil do begin
                if cpu3.FType=cutVar then inc(cnt)
                else if (cpu3.FType=cutClose) or (cpu3.FType=cutCloseArray) then break;
                cpu3:=cpu3.FNext;
            end;
            if (cpu.FType=cutArray) and (cnt<1) then begin
                Clear;
                Result:=CErrorEXP(0,cpu.FSme);
                cp.Free;
                Exit;
                raise ExceptionExpressionEC.Create('Unknown error');
            end;
            no:=VarAdd;
            if cpu.FType=cutFun then EVar[no].FType:=evteTemp
            else EVar[no].FType:=evteArrayResult;
            elinstr:=Instr[InstrAdd()];
            if cpu.FType=cutFun then elinstr.FType:=eieFun else elinstr.FType:=eieArray;
            elinstr.FCount:=cnt+2;
            SetLength(elinstr.FIndex,cnt+2);
            elinstr.FIndex[0]:=no;
            elinstr.FIndex[1]:=cpu.FVar;
            i:=2;
            cpu2:=cpu.FNext;
            while cpu2<>nil do begin
                if cpu2.FType=cutVar then begin elinstr.FIndex[i]:=cpu2.FVar; inc(i); end
                else if (cpu2.FType=cutClose) or (cpu2.FType=cutCloseArray) then break;
                cpu2:=cpu2.FNext;
            end;
            cpu.FType:=cutVar;
            cpu.FStr:='';
            cpu.FVar:=no;
            cpu2:=cpu;
            while cpu3<>cpu2 do begin
                cpu:=cpu3;
                cpu3:=cpu3.FPrev;
                cp.UnitDel(cpu);
            end;
        end else if cpu.FType=cutOperatorUnary then begin
            no:=VarAdd; EVar[no].FType:=evteTemp;
            elinstr:=Instr[InstrAdd()];
            if cpu.FOper=caeSub then elinstr.FType:=eieMinus
            else elinstr.InitInstr(cpu.FOper);
            elinstr.FCount:=2;
            SetLength(elinstr.FIndex,2);
            elinstr.FIndex[0]:=no;
            elinstr.FIndex[1]:=cpu.FNext.FVar;
            cpu.FNext.FVar:=no;
            cpu2:=cpu.FNext;
            cp.UnitDel(cpu);
        end else if cpu.FType=cutAssume then begin
            elinstr:=Instr[InstrAdd()];
            elinstr.FType:=eieAssume;
            elinstr.FCount:=2;
            SetLength(elinstr.FIndex,2);
            elinstr.FIndex[0]:=cpu.FPrev.FVar;
            elinstr.FIndex[1]:=cpu.FNext.FVar;
            cpu2:=cpu.FPrev;
            cp.UnitDel(cpu.FNext);
            cp.UnitDel(cpu);
        end else begin
            no:=VarAdd; EVar[no].FType:=evteTemp;
            elinstr:=Instr[InstrAdd()];
            elinstr.InitInstr(cpu.FOper);
            elinstr.FCount:=3;
            SetLength(elinstr.FIndex,3);
            elinstr.FIndex[0]:=no;
            elinstr.FIndex[1]:=cpu.FPrev.FVar;
            elinstr.FIndex[2]:=cpu.FNext.FVar;
            cpu.FPrev.FVar:=no;
            cpu2:=cpu.FPrev;
            cp.UnitDel(cpu.FNext);
            cp.UnitDel(cpu);
        end;
{        cpu:=cp.GetOper;
//        cpu2:=cpu;
        if cpu<>nil then begin
            if cpu.FType=cutOperatorUnary then begin
                no:=VarAdd; EVar[no].FType:=evteTemp;
                elinstr:=Instr[InstrAdd()];
                if cpu.FOper=caeSub then elinstr.FType:=eieMinus
                else elinstr.InitInstr(cpu.FOper);
                elinstr.FCount:=2;
                SetLength(elinstr.FIndex,2);
                elinstr.FIndex[0]:=no;
                elinstr.FIndex[1]:=cpu.FNext.FVar;
                cpu.FNext.FVar:=no;
                cpu2:=cpu.FNext;
                cp.UnitDel(cpu);
            end else if cpu.FType=cutAssume then begin
                elinstr:=Instr[InstrAdd()];
                elinstr.FType:=eieAssume;
                elinstr.FCount:=2;
                SetLength(elinstr.FIndex,2);
                elinstr.FIndex[0]:=cpu.FPrev.FVar;
                elinstr.FIndex[1]:=cpu.FNext.FVar;
                cpu2:=cpu.FPrev;
                cp.UnitDel(cpu.FNext);
                cp.UnitDel(cpu);
            end else begin
                no:=VarAdd; EVar[no].FType:=evteTemp;
                elinstr:=Instr[InstrAdd()];
                elinstr.InitInstr(cpu.FOper);
                elinstr.FCount:=3;
                SetLength(elinstr.FIndex,3);
                elinstr.FIndex[0]:=no;
                elinstr.FIndex[1]:=cpu.FPrev.FVar;
                elinstr.FIndex[2]:=cpu.FNext.FVar;
                cpu.FPrev.FVar:=no;
                cpu2:=cpu.FPrev;
                cp.UnitDel(cpu.FNext);
                cp.UnitDel(cpu);
            end;
        end else begin
            cpu:=cp.GetArray;
            if cpu=nil then cpu:=cp.GetFun;
            if cpu<>nil then begin
                cnt:=0;
                cpu3:=cpu.FNext;
                while cpu3<>nil do begin
                    if cpu3.FType=cutVar then inc(cnt)
                    else if (cpu3.FType=cutClose) or (cpu3.FType=cutCloseArray) then break;
                    cpu3:=cpu3.FNext;
                end;
                if (cpu.FType=cutArray) and (cnt<1) then begin
                    Clear;
                    Result:='Line='+IntToStr(cpu.FNumLine)+' Char='+IntToStr(cpu.FNumChar);
                    cp.Free;
                    Exit;
//                    raise ExceptionExpressionEC.Create('Unknown error');
                end;
                no:=VarAdd;
                if cpu.FType=cutFun then EVar[no].FType:=evteTemp
                else EVar[no].FType:=evteArrayResult;
                elinstr:=Instr[InstrAdd()];
                if cpu.FType=cutFun then elinstr.FType:=eieFun else elinstr.FType:=eieArray;
                elinstr.FCount:=cnt+2;
                SetLength(elinstr.FIndex,cnt+2);
                elinstr.FIndex[0]:=no;
                elinstr.FIndex[1]:=cpu.FVar;
                i:=2;
                cpu2:=cpu.FNext;
                while cpu2<>nil do begin
                    if cpu2.FType=cutVar then begin elinstr.FIndex[i]:=cpu2.FVar; inc(i); end
                    else if (cpu2.FType=cutClose) or (cpu2.FType=cutCloseArray) then break;
                    cpu2:=cpu2.FNext;
                end;
                cpu.FType:=cutVar;
                cpu.FStr:='';
                cpu.FVar:=no;
                cpu2:=cpu;
                while cpu3<>cpu2 do begin
                    cpu:=cpu3;
                    cpu3:=cpu3.FPrev;
                    cp.UnitDel(cpu);
                end;
            end else begin
                Clear;
                if cp.FFirst=nil then begin
                    Result:='Unknown error';
                end else begin
                    Result:=CErrorEC(0,cp.FFirst.FNumLine,cp.FFirst.FNumChar);
                end;
                cp.Free;
                Exit;
                raise ExceptionExpressionEC.Create('Unknown error');
            end;
        end;}

        while (cpu2<>nil) and (cpu2.FPrev<>nil) and (cpu2.FPrev.FType=cutOpen) and (cpu2.FNext<>nil) and (cpu2.FNext.FType=cutClose) do begin
            cp.UnitDel(cpu2.FPrev);
            cp.UnitDel(cpu2.FNext);
        end;
    end;
    FRet:=cp.FFirst.FVar;

    cp.Free;
end;
{$WARNINGS ON}

procedure TExpressionEC.Link(va:TVarArrayEC);
var
    i:integer;
    exvar:TExpressionVarEC;
begin
    for i:=0 to FVarCount-1 do begin
        exvar:=EVar[i];
        if (exvar.FVar=nil) and (exvar.FType=evteExtern) then begin
            exvar.FVar:=va.GetVarNE(exvar.FName);
        end;
    end;
end;

procedure TExpressionEC.LinkAll(va:TVarArrayEC);
var
    i:integer;
    exvar:TExpressionVarEC;
    tvar:TVarEC;
begin
    for i:=0 to FVarCount-1 do begin
        exvar:=EVar[i];
        if (exvar.FType=evteExtern) then begin
            tvar:=va.GetVarNE(exvar.FName);
            if tvar<>nil then exvar.FVar:=tvar;
        end;
    end;
end;

procedure TExpressionEC.UnLink(va:TVarArrayEC);
var
    i,u,cnt:integer;
    uva:TVarEC;
    exvar:TExpressionVarEC;
begin
    cnt:=va.Count;
    for i:=0 to cnt-1 do begin
        uva:=va.Items[i];
        for u:=0 to FVarCount-1 do begin
            exvar:=EVar[u];
            if (exvar.FType=evteExtern) and (exvar.FName=uva.FName) then exvar.FVar:=nil;
        end;
    end;
end;

procedure TExpressionEC.Run(cpr:TCodeProcessEC; code:TCodeEC; cd:TCodeDebugEC);
var
    i,u:integer;
    eli:TExpressionInstrEC;
    exvar0,exvar1,exvar2:TExpressionVarEC;
    varfun:array of TVarEC;
    tvar,tvar2,exvar1var,exvar2var:TVarEC;
    tcfun:TCodeEC;
    dwzn:DWORD;
    vtt:VariableTypeEC;
begin
    i:=0;
    while i<FVarCount do begin
        exvar0:=EVar[i];
        if exvar0.FType=evteArrayResult then exvar0.FVar:=nil;
        inc(i);
    end;

    i:=0;
    while i<FInstrCount do begin
        eli:=Instr[i];
        if (eli.FType=eieMinus) or (eli.FType=eieBitNot) or (eli.FType=eieNot) then begin
{            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            if (exvar1.FVar=nil) then raise ExceptionExpressionEC.Create('Not link var sou1:'+exvar1.FName);
            if (exvar0.FVar=nil) then begin
                if exvar0.FType=evteTemp then begin
                    exvar0.FVar:=TVarEC.Create(exvar1.FVar.VType);
                end else raise ExceptionExpressionEC.Create('Not link var des:'+exvar0.FName);
            end;
            case eli.FType of
                eieMinus: exvar0.FVar.OMinus(exvar1.FVar);
                eieBitNot: exvar0.FVar.OBitNot(exvar1.FVar);
                eieNot: exvar0.FVar.ONot(exvar1.FVar);
            end;}

            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            case eli.FType of
                eieMinus: exvar0.GetVar(exvar1.FVar.VType).OMinus(exvar1.GetVar);
                eieBitNot: exvar0.GetVar(exvar1.FVar.VType).OBitNot(exvar1.GetVar);
                eieNot: exvar0.GetVar(exvar1.FVar.VType).ONot(exvar1.GetVar);
            end;

        end else if (eli.FType<>eieFun) and (eli.FType<>eieAssume) and (eli.FType<>eieArray) then begin
{            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            exvar2:=EVar[eli.FIndex[2]];
            if (exvar1.FVar=nil) then raise ExceptionExpressionEC.Create('Not link var sou1:'+exvar1.FName);
            if (exvar2.FVar=nil) then raise ExceptionExpressionEC.Create('Not link var sou2:'+exvar2.FName);
            if (exvar0.FVar=nil) then begin
                if exvar0.FType=evteTemp then begin
                    if (eli.FType=eieAdd) or (eli.FType=eieSub) or (eli.FType=eieMul) or (eli.FType=eieDiv) then begin
                        exvar0.FVar:=TVarEC.Create(exvar1.FVar.VType);
                    end else begin
                        exvar0.FVar:=TVarEC.Create(vtInt);
                    end;
                end else raise ExceptionExpressionEC.Create('Not link var des:'+exvar0.FName);
            end;

            case eli.FType of
                eieAdd: exvar0.FVar.OAdd(exvar1.FVar,exvar2.FVar);
                eieSub: exvar0.FVar.OSub(exvar1.FVar,exvar2.FVar);
                eieMul: exvar0.FVar.OMul(exvar1.FVar,exvar2.FVar);
                eieDiv: exvar0.FVar.ODiv(exvar1.FVar,exvar2.FVar);
                eieMod: exvar0.FVar.OMod(exvar1.FVar,exvar2.FVar);
                eieBitAnd: exvar0.FVar.OBitAnd(exvar1.FVar,exvar2.FVar);
                eieBitOr: exvar0.FVar.OBitOr(exvar1.FVar,exvar2.FVar);
                eieBitXor: exvar0.FVar.OBitXor(exvar1.FVar,exvar2.FVar);
                eieAnd: exvar0.FVar.OAnd(exvar1.FVar,exvar2.FVar);
                eieOr: exvar0.FVar.OOr(exvar1.FVar,exvar2.FVar);
                eieShl: exvar0.FVar.OShl(exvar1.FVar,exvar2.FVar);
                eieShr: exvar0.FVar.OShr(exvar1.FVar,exvar2.FVar);
                eieEqual: exvar0.FVar.OEqual(exvar1.FVar,exvar2.FVar);
                eieNotEqual: exvar0.FVar.ONotEqual(exvar1.FVar,exvar2.FVar);
                eieLess: exvar0.FVar.OLess(exvar1.FVar,exvar2.FVar);
                eieMore: exvar0.FVar.OMore(exvar1.FVar,exvar2.FVar);
                eieLessEqual: exvar0.FVar.OLessEqual(exvar1.FVar,exvar2.FVar);
                eieMoreEqual: exvar0.FVar.OMoreEqual(exvar1.FVar,exvar2.FVar);
            end;}
            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            exvar2:=EVar[eli.FIndex[2]];

            vtt:=vtUnknown;
            if (exvar0.FVar=nil) and (exvar0.FType=evteTemp) then begin
                if (eli.FType=eieAdd) or (eli.FType=eieSub) or (eli.FType=eieMul) or (eli.FType=eieDiv) then vtt:=exvar1.GetVar.VType
                else vtt:=vtInt;
            end;

            case eli.FType of
                eieAdd: exvar0.GetVar(vtt).OAdd(exvar1.GetVar,exvar2.GetVar);
                eieSub: exvar0.GetVar(vtt).OSub(exvar1.GetVar,exvar2.GetVar);
                eieMul: exvar0.GetVar(vtt).OMul(exvar1.GetVar,exvar2.GetVar);
                eieDiv: exvar0.GetVar(vtt).ODiv(exvar1.GetVar,exvar2.GetVar);
                eieMod: exvar0.GetVar(vtt).OMod(exvar1.GetVar,exvar2.GetVar);
                eieBitAnd: exvar0.GetVar(vtt).OBitAnd(exvar1.GetVar,exvar2.GetVar);
                eieBitOr: exvar0.GetVar(vtt).OBitOr(exvar1.GetVar,exvar2.GetVar);
                eieBitXor: exvar0.GetVar(vtt).OBitXor(exvar1.GetVar,exvar2.GetVar);
                eieAnd: exvar0.GetVar(vtt).OAnd(exvar1.GetVar,exvar2.GetVar);
                eieOr: exvar0.GetVar(vtt).OOr(exvar1.GetVar,exvar2.GetVar);
                eieShl: exvar0.GetVar(vtt).OShl(exvar1.GetVar,exvar2.GetVar);
                eieShr: exvar0.GetVar(vtt).OShr(exvar1.GetVar,exvar2.GetVar);
                eieEqual: exvar0.GetVar(vtt).OEqual(exvar1.GetVar,exvar2.GetVar);
                eieNotEqual: exvar0.GetVar(vtt).ONotEqual(exvar1.GetVar,exvar2.GetVar);
                eieLess: exvar0.GetVar(vtt).OLess(exvar1.GetVar,exvar2.GetVar);
                eieMore: exvar0.GetVar(vtt).OMore(exvar1.GetVar,exvar2.GetVar);
                eieLessEqual: exvar0.GetVar(vtt).OLessEqual(exvar1.GetVar,exvar2.GetVar);
                eieMoreEqual: exvar0.GetVar(vtt).OMoreEqual(exvar1.GetVar,exvar2.GetVar);
            end;
        end else if eli.FType=eieAssume then begin
{            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            if (exvar0.FVar=nil) then raise ExceptionExpressionEC.Create('Not link var des:'+exvar0.FName);
            if (exvar1.FVar=nil) then raise ExceptionExpressionEC.Create('Not link var sou:'+exvar1.FName);
            exvar0.FVar.Assume(exvar1.FVar);}
            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            exvar0.GetVar.Assume(exvar1.GetVar);
        end else if eli.FType=eieArray then begin
{            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            tvar:=exvar1.FVar;
            if (tvar=nil) then raise ExceptionExpressionEC.Create('Not link array:'+exvar1.FName);
            if (tvar.VType<>vtArray) then raise ExceptionExpressionEC.Create('Not array:'+exvar1.FName);

            for u:=2 to eli.FCount-1 do begin
                exvar2:=EVar[eli.FIndex[u]];
                if (exvar2.FVar=nil) then raise ExceptionExpressionEC.Create('Not link array['+IntToStr(u-2)+'] :'+exvar2.FName);
                if exvar2.FVar.VType=vtStr then begin
                    tvar:=tvar.VArray.GetVarNE(exvar2.FVar.VStr);
                    if tvar=nil then raise ExceptionExpressionEC.Create('Error array. index='+exvar2.FVar.VStr);
                end else begin
                    tvar:=tvar.VArray.ItemsTB[exvar2.FVar.VInt];
                    if tvar=nil then raise ExceptionExpressionEC.Create('Error array. index='+IntToStr(exvar2.FVar.VInt));
                end;
                if (u<>eli.FCount-1) and (tvar.VType<>vtArray) then raise ExceptionExpressionEC.Create('Error array:'+exvar1.FName);
            end;
            exvar0.FVar:=tvar;}
            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            tvar:=exvar1.GetVar;
            if (tvar.VType<>vtArray) then raise ExceptionExpressionEC.Create('Not array:'+exvar1.FName);

            for u:=2 to eli.FCount-1 do begin
                exvar2:=EVar[eli.FIndex[u]];
                tvar2:=exvar2.GetVar;
//                if (exvar2.FVar=nil) then raise ExceptionExpressionEC.Create('Not link array['+IntToStr(u-2)+'] :'+exvar2.FName);
                if tvar2.VType=vtStr then begin
                    tvar:=tvar.VArray.GetVarNE(tvar2.VStr);
                    if tvar=nil then raise ExceptionExpressionEC.Create('Error array. index='+exvar2.FVar.VStr);
                end else begin
                    tvar:=tvar.VArray.ItemsTB[tvar2.VInt];
                    if tvar=nil then raise ExceptionExpressionEC.Create('Error array. index='+IntToStr(exvar2.FVar.VInt));
                end;
                if (u<>eli.FCount-1) and (tvar.VType<>vtArray) then raise ExceptionExpressionEC.Create('Error array:'+exvar1.FName);
            end;
            exvar0.FVar:=tvar;
        end else begin
{            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            if (exvar0.FVar=nil) then begin
                exvar0.FVar:=TVarEC.Create(vtUnknown);
            end;
            if (exvar1.FVar=nil) then raise ExceptionExpressionEC.Create('Not link fun:'+exvar1.FName);}
            exvar0:=EVar[eli.FIndex[0]];
            exvar1:=EVar[eli.FIndex[1]];
            exvar0.GetVar(vtUnknown);
            exvar1var:=exvar1.GetVar;
//            if (exvar1.FVar.VType=vtLibraryFun) then begin
            if (exvar1var.VType=vtLibraryFun) then begin

                tvar:=exvar1var.GetByRef();
                if (eli.FCount-2)<>(High(tvar.FVLibraryFun)+1-2) then raise ExceptionExpressionEC.Create('Count variable : '+exvar1.FName);

                for u:=(eli.FCount-2-1) downto 0 do begin
                    exvar2var:=EVar[eli.FIndex[u+2]].GetVar;
//                    if exvar2.FVar=nil then raise ExceptionExpressionEC.Create('Not link var : '+exvar2.FName);

                    case tvar.FVLibraryFun[2+u] of
                        1: dwzn:=exvar2var.VInt;
                        2: dwzn:=exvar2var.VDW;
                        3: begin
                            tvar2:=exvar2var.GetByRef();
                            if tvar2.FVType<>vtStr then raise ExceptionExpressionEC.Create('Variable not string');
                            dwzn:=DWORD(PWideChar(tvar2.FVStr));
                        end;
                    else
                        dwzn:=0;
                    end;

                    asm
                        push    dwzn
                    end;
                end;
                dwzn:=tvar.FVLibraryFun[1];
                asm
                    call    dwzn
                    mov     dwzn,eax
                end;
                if tvar.FVLibraryFun[0]=1 then begin
                    exvar0.FVar.VInt:=integer(dwzn);
                end else if tvar.FVLibraryFun[0]=2 then begin
                    exvar0.FVar.VDW:=dwzn;
                end;
{                dw:=CreateFile('1.txt',
                         GENERIC_READ,
                         FILE_SHARE_READ,nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);
                GetFileSize(dw,nil);
                CloseHandle(dw);}

//            end else if (exvar1.FVar.VType=vtExternFun) then begin
            end else if (exvar1var.VType=vtExternFun) then begin
                SetLength(varfun,eli.FCount-1);
                varfun[0]:=exvar0.FVar;
                for u:=2 to eli.FCount-1 do begin
                    exvar2var:=EVar[eli.FIndex[u]].GetVar;
//                    if exvar2.FVar=nil then raise ExceptionExpressionEC.Create('Not link var '+IntToStr(u-2)+': '+exvar2.FName);
                    varfun[u-1]:=exvar2var;
                end;
                exvar1var.VExternFun(varfun,code);
//            end else if (exvar1.FVar.VType=vtFun) then begin
            end else if (exvar1var.VType=vtFun) then begin
//            funBaseVarCount
                if exvar1var.VFun.FLocalVar.GetVar('funBaseVarCount').VInt<(eli.FCount-2) then raise ExceptionExpressionEC.Create('Count var error. fun:'+exvar1.FName);
                tcfun:=TCodeEC.Create;
                tcfun.FParent:=exvar1var.VFun;
                tcfun.CopyFromFast(exvar1var.VFun);
                for u:=2 to eli.FCount-1 do begin
                    exvar2var:=EVar[eli.FIndex[u]].GetVar;
//                    if exvar2.FVar=nil then raise ExceptionExpressionEC.Create('Not link var '+IntToStr(u-2)+': '+exvar2.FName);
                    if tcfun.FLocalVar.Items[u-2].RealVType=vtRef then begin
                        tcfun.FLocalVar.Items[u-2].VRef:=exvar2var;
                    end else begin
                        tcfun.FLocalVar.Items[u-2].Assume(exvar2var);
                    end;
                end;
                try
                    tcfun.FLocalVar.GetVar('result').VRef:=exvar0.FVar;
                    if cd=nil then tcfun.Run(cpr)
                    else tcfun.RunDebug(cpr,cd);
                except
                    tcfun.Free;
                    raise;
                end;
                tcfun.Free;
            end else raise ExceptionExpressionEC.Create('Not fun:'+exvar1.FName);
        end;

        inc(i);
    end;
end;

function TExpressionEC.Return:TVarEC;
begin
    if (FRet<0) or (EVar[FRet].FVar=nil) then raise ExceptionExpressionEC.Create('Not link var return');
    Result:=EVar[FRet].FVar;
end;

function TExpressionEC.EndCode(level:WideString):WideString;
var
    ev:TExpressionVarEC;
    ei:TExpressionInstrEC;
    i,u:integer;
    tstr:WideString;
begin
    Result:='';
    for i:=0 to FVarCount-1 do begin
        ev:=EVar[i];
        if ev.FType=evteExtern then Result:=Result+level+IntToStr(i)+'-Extern '+ev.FName+#13#10
        else if ev.FType=evteTemp then begin
            Result:=Result+level+IntToStr(i)+'-Temp';
            if ev.FVar<>nil then Result:=Result+' '+ev.FVar.VStr;
            Result:=Result+#13#10;
        end else if ev.FType=evteArrayResult then Result:=Result+level+IntToStr(i)+'-AResult'+#13#10
        else raise Exception.Create('TExpressionEC.EndCode');
    end;

    for i:=0 to FInstrCount-1 do begin
        ei:=Instr[i];
        tstr:='';
        case ei.FType of
            eieMinus: tstr:=IntToStr(ei.FIndex[0])+'=-'+IntToStr(ei.FIndex[1]);
            eieAdd: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'+'+IntToStr(ei.FIndex[2]);
            eieSub: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'-'+IntToStr(ei.FIndex[2]);
            eieMul: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'*'+IntToStr(ei.FIndex[2]);
            eieDiv: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'/'+IntToStr(ei.FIndex[2]);
            eieMod: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'%'+IntToStr(ei.FIndex[2]);
            eieBitAnd: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'&'+IntToStr(ei.FIndex[2]);
            eieBitOr: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'|'+IntToStr(ei.FIndex[2]);
            eieBitXor: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'^'+IntToStr(ei.FIndex[2]);
            eieBitNot: tstr:=IntToStr(ei.FIndex[0])+'=~'+IntToStr(ei.FIndex[1]);

            eieAnd: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'&&'+IntToStr(ei.FIndex[2]);
            eieOr: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'||'+IntToStr(ei.FIndex[2]);
            eieNot: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'!'+IntToStr(ei.FIndex[2]);
            eieShl: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'<<'+IntToStr(ei.FIndex[2]);
            eieShr: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'>>'+IntToStr(ei.FIndex[2]);
            eieLess: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'<'+IntToStr(ei.FIndex[2]);
            eieMore: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'>'+IntToStr(ei.FIndex[2]);
            eieEqual: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'=='+IntToStr(ei.FIndex[2]);
            eieNotEqual: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'!='+IntToStr(ei.FIndex[2]);
            eieLessEqual: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'<='+IntToStr(ei.FIndex[2]);
            eieMoreEqual: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'>='+IntToStr(ei.FIndex[2]);

            eieAssume: tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1]);
            eieFun: begin
                tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'(';
                for u:=2 to ei.FCount-1 do begin
                    if u<>2 then tstr:=tstr+',';
                    tstr:=tstr+IntToStr(ei.FIndex[u]);
                end;
                tstr:=tstr+')';
            end;
            eieArray: begin
                tstr:=IntToStr(ei.FIndex[0])+'='+IntToStr(ei.FIndex[1])+'[';
                for u:=2 to ei.FCount-1 do begin
                    if u<>2 then tstr:=tstr+',';
                    tstr:=tstr+IntToStr(ei.FIndex[u]);
                end;
                tstr:=tstr+']';
            end;
        else
            raise Exception.Create('TExpressionEC.EndCode');
        end;
        Result:=Result+level+tstr+#13#10
    end;

    Result:=Result+level+'Return '+IntToStr(FRet)+#13#10;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TCompilerEC.Create;
begin
    inherited Create;
end;

destructor TCompilerEC.Destroy;
begin
    Clear;
    inherited Destroy;
end;

procedure TCompilerEC.Clear;
begin
    while FFirst<>nil do UnitDel(FLast);
end;

function TCompilerEC.UnitAdd:TCompilerUnitEC;
var
    el:TCompilerUnitEC;
begin
    el:=TCompilerUnitEC.Create;

	if FLast<>nil then FLast.FNext:=el;
	el.FPrev:=FLast;
	el.FNext:=nil;
	FLast:=el;
	if FFirst=nil then FFirst:=el;

	Result:=el;
end;

procedure TCompilerEC.UnitDel(el:TCompilerUnitEC);
begin
	if (el.FPrev<>nil) then el.FPrev.FNext:=el.FNext;
	if (el.FNext<>nil) then el.FNext.FPrev:=el.FPrev;
	if (FLast=el) then FLast:=el.FPrev;
	if (FFirst=el) then FFirst:=el.FNext;

	el.Free;
end;

function TCompilerEC.GetOper:TCompilerUnitEC;
var
    i:integer;
    el,el2:TCompilerUnitEC;
    l:array[0..10] of TCompilerUnitEC;
begin
    for i:=0 to 10 do l[i]:=nil;

    el:=FFirst;
    while el<>nil do begin
        if el.FType=cutOperatorUnary then begin
            if (el.FNext<>nil) and (el.FNext.FType=cutVar) then begin
                if l[0]=nil then l[0]:=el;
            end;
        end else if el.FType=cutOperator then begin
            if (el.FPrev.FType=cutVar) and (el.FNext.FType=cutVar) then begin
                el2:=el.FNext.FNext;
                while el2<>nil do begin
                    if (el2.FType=cutOpen) or (el2.FType=cutOpenArray) or (el2.FType=cutFun) then break;
                    if (el2.FType=cutClose) or (el2.FType=cutCloseArray) then break;
                    el2:=el2.FNext;
                end;
                if (el2=nil) or (not ((el2.FType=cutOpen) or (el2.FType=cutOpenArray) or (el2.FType=cutFun))) then begin
                    if (el.FOper=caeMul) or (el.FOper=caeDiv) or (el.FOper=caeMod) then begin
                        if l[1]=nil then l[1]:=el;
                    end else if (el.FOper=caeAdd) or (el.FOper=caeSub) then begin
                        if l[2]=nil then l[2]:=el;
                    end else if (el.FOper=caeShl) or (el.FOper=caeShr) then begin
                        if l[3]=nil then l[3]:=el;
                    end else if (el.FOper=caeEqual) or (el.FOper=caeNotEqual) or (el.FOper=caeLess) or (el.FOper=caeMore) or (el.FOper=caeLessEqual) or (el.FOper=caeMoreEqual) then begin
                        if l[4]=nil then l[4]:=el;
                    end else if (el.FOper=caeBitAnd) then begin
                        if l[5]=nil then l[5]:=el;
                    end else if (el.FOper=caeBitXor) then begin
                        if l[6]=nil then l[6]:=el;
                    end else if (el.FOper=caeBitOr) then begin
                        if l[7]=nil then l[7]:=el;
                    end else if (el.FOper=caeAnd) then begin
                        if l[8]=nil then l[8]:=el;
                    end else if (el.FOper=caeOr) then begin
                        if l[9]=nil then l[9]:=el;
                    end;
                end;
            end;
        end else if el.FType=cutAssume then begin
            if (el.FPrev.FType=cutVar) and (el.FNext.FType=cutVar) then begin
                if l[10]=nil then l[10]:=el;
            end;
        end;
        el:=el.FNext;
    end;

    for i:=0 to 10 do begin
        if l[i]<>nil then begin Result:=l[i]; Exit; End;
    end;
    Result:=nil;
end;

function TCompilerEC.GetArray:TCompilerUnitEC;
var
    el,el2:TCompilerUnitEC;
begin
    el:=FFirst;
    while el<>nil do begin
        if el.FType=cutArray then begin
            el2:=el.FNext;
            while el2<>nil do begin
                if (el2.FType=cutCloseArray) then begin Result:=el; Exit; end;
                if (el2.FType<>cutComma) and (el2.FType<>cutVar) then break;
                el2:=el2.FNext;
            end;
        end;
        el:=el.FNext;
    end;
    Result:=nil;
end;

function TCompilerEC.GetFun:TCompilerUnitEC;
var
    el,el2:TCompilerUnitEC;
begin
    el:=FFirst;
    while el<>nil do begin
        if el.FType=cutFun then begin
            el2:=el.FNext;
            while el2<>nil do begin
                if (el2.FType=cutClose) then begin Result:=el; Exit; end;
//                if (el2.FType=cutFun) then break;
                if (el2.FType<>cutComma) and (el2.FType<>cutVar) then break;
                el2:=el2.FNext;
            end;
        end;
        el:=el.FNext;
    end;
    Result:=nil;
end;

////////////////////////////////////////////////////////////////////////////////
//// TCodeUnitEC ///////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
destructor TCodeUnitEC.Destroy;
begin
    if FExperssion<>nil then begin FExperssion.Free; FExperssion:=nil; End;
    inherited Destroy;
end;

////////////////////////////////////////////////////////////////////////////////
//// TCodeProcessEC ////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TCodeProcessEC.Create;
begin
    inherited Create;
    FTry:=TList.Create;
    FThrow:=TList.Create;
end;

destructor TCodeProcessEC.Destroy;
begin
    Clear;
    FTry.Free; FTry:=nil;
    FThrow.Free; FThrow:=nil;
    inherited Destroy;
end;

procedure TCodeProcessEC.Clear;
var
    ut:PCodeProcessTryEC;
    uth:PCodeProcessThrowEC;
    i:integer;
begin
    for i:=0 to FTry.Count-1 do begin
        ut:=FTry.Items[i];
        HeapFree(GetProcessHeap(),0,ut);
    end;
    for i:=0 to FThrow.Count-1 do begin
        uth:=FThrow.Items[i];
        if uth.FVar<>nil then begin uth.FVar.Free; uth.FVar:=nil end;
        HeapFree(GetProcessHeap(),0,uth);
    end;
end;

procedure TCodeProcessEC.TryAdd(code:TCodeEC; cu:TCodeUnitEC);
var
    pt:PCodeProcessTryEC;
begin
    pt:=HeapAlloc(GetProcessHeap(),0,sizeof(TCodeProcessTryEC));
    pt.FCode:=code;
    pt.FUnit:=cu;
    FTry.Add(pt);
end;

procedure TCodeProcessEC.TryDelLast;
var
    pt:PCodeProcessTryEC;
    cnt:integer;
begin
    cnt:=FTry.Count;
    if cnt<1 then Exit;
    pt:=FTry.Items[cnt-1];
    HeapFree(GetProcessHeap(),0,pt);
    FTry.Delete(cnt-1);
end;

function TCodeProcessEC.TryGetLast:PCodeProcessTryEC;
var
    cnt:integer;
begin
    cnt:=FTry.Count;
    if cnt<1 then begin Result:=nil; Exit; end;
    Result:=FTry.Items[cnt-1];
end;

procedure TCodeProcessEC.ThrowAdd(tv:TVarEC);
var
    pth:PCodeProcessThrowEC;
begin
    pth:=HeapAlloc(GetProcessHeap(),0,sizeof(TCodeProcessThrowEC));
    pth.FVar:=TVarEC.Create(tv.VType);
    pth.FVar.Assume(tv);
    FThrow.Add(pth);
end;

procedure TCodeProcessEC.ThrowAddNotCreate(tv:TVarEC);
var
    pth:PCodeProcessThrowEC;
begin
    pth:=HeapAlloc(GetProcessHeap(),0,sizeof(TCodeProcessThrowEC));
    pth.FVar:=tv;
    FThrow.Add(pth);
end;

procedure TCodeProcessEC.ThrowDelLast;
var
    pth:PCodeProcessThrowEC;
    cnt:integer;
begin
    cnt:=FThrow.Count;
    if cnt<1 then Exit;
    pth:=FThrow.Items[cnt-1];
    HeapFree(GetProcessHeap(),0,pth);
    FThrow.Delete(cnt-1);
end;

function TCodeProcessEC.ThrowGetLast:PCodeProcessThrowEC;
var
    cnt:integer;
begin
    cnt:=FThrow.Count;
    if cnt<1 then begin Result:=nil; Exit; end;
    Result:=FThrow.Items[cnt-1];
end;

procedure TCodeProcessEC.TestError;
var
    pth:PCodeProcessThrowEC;
    tstr:WideString;
    i:integer;
begin
    tstr:='';
    for i:=0 to FThrow.Count-1 do begin
        pth:=FThrow.Items[i];
        if i>0 then tstr:=tstr+#13#10;
        tstr:='Exception : '+pth.FVar.VStr;
    end;
    if tstr<>'' then raise ExceptionExpressionEC.Create(tstr);
end;


////////////////////////////////////////////////////////////////////////////////
//// TCodeDebugEC //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TCodeDebugEC.Create;
begin
    inherited Create;

    FStop:=false;

    FEventBreak:=CreateEvent(nil,true,false,nil);
    if FEventBreak=0 then raise Exception.Create('CreateEvent');
    FEventBPEnd:=CreateEvent(nil,true,true,nil);
    if FEventBPEnd=0 then raise Exception.Create('CreateEvent');

    FStopType:=cdst_BP;
    FStopLastCode:=nil;
end;

destructor TCodeDebugEC.Destroy;
begin
    if FEventBreak<>0 then begin CloseHandle(FEventBreak); FEventBreak:=0; end;
    if FEventBPEnd<>0 then begin CloseHandle(FEventBPEnd); FEventBPEnd:=0; end;
    inherited Destroy;
end;

procedure TCodeDebugEC.Break;
begin
    SetEvent(FEventBreak);
end;

function TCodeDebugEC.IsStop:boolean;
begin
    Result:=WaitForSingleObject(FEventBPEnd,0)<>WAIT_OBJECT_0;
end;

procedure TCodeDebugEC.Run(typestop:TCodeDebugST);
begin
    FStop:=false;
    FStopType:=typestop;
    SetEvent(FEventBPEnd);
end;

procedure TCodeDebugEC.RunStart(typestop:TCodeDebugST);
begin
    FStop:=false;
    FStopType:=typestop;
    if FStopType<>cdst_BP then FStop:=true;
    FStopLastCode:=nil;
    ResetEvent(FEventBreak);
    SetEvent(FEventBPEnd);
end;

procedure TCodeDebugEC.Stop;
begin
    FStop:=true;
end;

////////////////////////////////////////////////////////////////////////////////
//// TCodeEC ///////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TCodeEC.Create;
begin
    Inherited Create;
    FLocalVar:=TVarArrayEC.Create;
end;

destructor TCodeEC.Destroy;
begin
    Clear;
    FLocalVar.Free;
    Inherited Destroy;
end;

procedure TCodeEC.Clear;
begin
    while FFirst<>nil do UnitDel(FLast);
    FLocalVar.Clear;
end;

procedure TCodeEC.CopyFrom(sou:TCodeEC);
var
    cudes,cu:TCodeUnitEC;
    cudes2,cu2:TCodeUnitEC;
begin
    Clear;

    FIsClass:=sou.FIsClass;
    FClassName:=sou.FClassName;
    FParent:=FParent;

    cu:=sou.FFirst;
    while cu<>nil do begin
        cudes:=UnitAdd();

        cudes.FType:=cu.FType;
        cudes.FSme:=cu.FSme;
        cudes.FLen:=cu.FLen;
        cudes.FUnit:=cu.FUnit;
        cudes.FJump:=cu.FJump;
        cudes.FBP:=cu.FBP;
        cudes.FExperssion:=nil;

        if cu.FExperssion<>nil then begin
            cudes.FExperssion:=TExpressionEC.Create;
            cudes.FExperssion.CopyFrom(cu.FExperssion);
        end;

        cu:=cu.FNext;
    end;

    cu:=sou.FFirst;
    cudes:=FFirst;
    while cu<>nil do begin
        if cu.FJump<>nil then begin
            cu2:=sou.FFirst;
            cudes2:=FFirst;
            while cu2<>nil do begin
                if cu.FJump=cu2 then begin
                    cudes.FJump:=cudes2;
                end;
                cu2:=cu2.FNext;
                cudes2:=cudes2.FNext;
            end;
        end;
        cu:=cu.FNext;
        cudes:=cudes.FNext;
    end;

    FLocalVar.CopyFrom(sou.FLocalVar);
end;

procedure TCodeEC.CopyFromFast(sou:TCodeEC);
var
    cudes,cu:TCodeUnitEC;
    cudes2,cu2:TCodeUnitEC;
begin
    Clear;

    cu:=sou.FFirst;
    while cu<>nil do begin
        cudes:=UnitAdd();

        cudes.FType:=cu.FType;
        cudes.FSme:=cu.FSme;
        cudes.FLen:=cu.FLen;
        cudes.FUnit:=cu.FUnit;
        cudes.FJump:=cu.FJump;
        cudes.FBP:=cu.FBP;
        cudes.FExperssion:=nil;

        if cu.FExperssion<>nil then begin
            cudes.FExperssion:=TExpressionEC.Create;
            cudes.FExperssion.CopyFromFast(cu.FExperssion);
        end;

        cu:=cu.FNext;
    end;

    cu:=sou.FFirst;
    cudes:=FFirst;
    while cu<>nil do begin
        if cu.FJump<>nil then begin
            cu2:=sou.FFirst;
            cudes2:=FFirst;
            while cu2<>nil do begin
                if cu.FJump=cu2 then begin
                    cudes.FJump:=cudes2;
                end;
                cu2:=cu2.FNext;
                cudes2:=cudes2.FNext;
            end;
        end;
        cu:=cu.FNext;
        cudes:=cudes.FNext;
    end;

    FLocalVar.CopyFrom(sou.FLocalVar);
end;

function TCodeEC.FindClassMember(name:WideString):TVarEC;
var
    tv:TVarEC;
    i:integer;
begin
    Result:=FLocalVar.GetVarNE(name);
    if Result=nil then begin
        for i:=0 to FLocalVar.Count-1 do begin
            tv:=FLocalVar.Items[i];
            if (tv.FVType=vtFun) and (tv.FVFun.FIsClass) then begin
                Result:=tv.FVFun.FindClassMember(name);
                if Result<>nil then Exit;
            end;
        end;
    end;
end;

procedure TCodeEC.UnitDel(el:TCodeUnitEC);
begin
	if (el.FPrev<>nil) then el.FPrev.FNext:=el.FNext;
	if (el.FNext<>nil) then el.FNext.FPrev:=el.FPrev;
	if (FLast=el) then FLast:=el.FPrev;
	if (FFirst=el) then FFirst:=el.FNext;

	el.Free;
end;

function TCodeEC.UnitAdd:TCodeUnitEC;
var
    el:TCodeUnitEC;
begin
    el:=TCodeUnitEC.Create;

	if FLast<>nil then FLast.FNext:=el;
	el.FPrev:=FLast;
	el.FNext:=nil;
	FLast:=el;
	if FFirst=nil then FFirst:=el;

    Result:=el;
end;

function TCodeEC.UnitInsert(perel:TCodeUnitEC):TCodeUnitEC;
var
    el:TCodeUnitEC;
begin
    if perel=nil then begin Result:=UnitAdd; Exit; end;

    el:=TCodeUnitEC.Create;

    el.FPrev:=perel.FPrev;
	el.FNext:=perel;
	if perel.FPrev<>nil then perel.FPrev.FNext:=el;
	perel.FPrev:=el;
	if perel=FFirst then FFirst:=el;

	Result:=el;
end;

function TCodeEC.UnitToNum(el:TCodeUnitEC):integer;
begin
    Result:=-1;
    while el<>nil do begin
        inc(Result);
        el:=el.FPrev;
    end;
end;

function TCodeEC.Compiler(ca:TCodeAnalyzerEC; codeunit:integer; funinclude:FunctionIncludeUnitEC; el:TCodeAnalyzerUnitEC; elendcomp:PDWORD; curclass:TCodeEC):WideString;
begin
//    Clear;
    Result:='';

    if el=nil then el:=ca.FFirst;

    Result:=CompilerR(ca,codeunit,funinclude,el,nil,elendcomp,nil,nil,nil,curclass);
end;

// elendcomp  - найдена }. возращает указательна нее
// elcontinue - продолжение кода. продолжить компеляцию с elcontinue ( для конструкции типа - if() code; )
{$WARNINGS OFF}
function TCodeEC.CompilerR(ca:TCodeAnalyzerEC; codeunit:integer; funinclude:FunctionIncludeUnitEC; el:TCodeAnalyzerUnitEC; insertto:TCodeUnitEC; elendcomp:PDWORD; elcontinue:PDWORD; opBreak:TCodeUnitEC; opContinue:TCodeUnitEC; curclass:TCodeEC):WideString;
var
    cainclude:TCodeAnalyzerEC;
    unitinclude:integer;
    el2:TCodeAnalyzerUnitEC;
    oper:WideString;
    un,un2,un3,unempty,unif:TCodeUnitEC;
    countopen:integer;
    tvar,tvar2:TVarEC;
    cfun:TCodeEC;
    cnt:integer;

    zfloat:double;
    zdword:DWORD;
    zint:integer;
    zstr:WideString;
    zbool:boolean;

    procedure AddVarByType(tstr,name:WideString);
    begin
        if tstr='unknown' then FLocalVar.Add(name,vtUnknown)
        else if tstr='int' then FLocalVar.Add(name,vtInt)
        else if tstr='dword' then FLocalVar.Add(name,vtDW)
        else if tstr='float' then FLocalVar.Add(name,vtFloat)
        else if tstr='str' then FLocalVar.Add(name,vtStr)
        else if tstr='ref' then FLocalVar.Add(name,vtRef)
        else if tstr='array' then FLocalVar.Add(name,vtArray);
    end;
    function InDeclareVar(el:TCodeAnalyzerUnitEC):boolean;
    begin
        Result:=(el<>nil) and (el.FNext<>nil) and (el.FNext.FType=caeName) and (el.FType=caeName) and
                ((el.FStr='unknown') or (el.FStr='int') or (el.FStr='dword') or (el.FStr='float') or (el.FStr='str') or (el.FStr='ref') or (el.FStr='array')) and
                (IsVarEXP(el.FNext.FStr));
    end;
    function DeclareVar(var el:TCodeAnalyzerUnitEC):WideString;
    var
        un:TCodeUnitEC;
        el2:TCodeAnalyzerUnitEC;
        oper:WideString;
    begin
        Result:='';
        oper:=el.FStr;
        el:=el.FNext;
        while (el.FType=caeName) and IsVarEXP(el.FStr) do begin
            if FLocalVar.GetVarNE(el.FStr)<>nil then begin Result:=CErrorEXP(0,el.FSme); Exit; End;
            AddVarByType(oper,el.FStr);

            if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; End;

            el:=el.FNext;
            if el.FType=caeComma then begin
                el:=el.FNext;
            end else if el.FType=caeAssume then begin
                un:=UnitInsert(insertto);
                un.FType:=cuteExpression;
                un.FExperssion:=TExpressionEC.Create;
                un.FSme:=el.FPrev.FSme; un.FLen:=0; un.FUnit:=codeunit;
                Result:=un.FExperssion.Compiler(ca,curclass,el.FPrev,nil,@el2);
                if Result<>'' then Exit;
                un.FLen:=el2.FPrev.FSme+el2.FPrev.FLen-un.FSme;
                el:=el2;
                if el.FType=caeComma then el:=el.FNext;
            end;
        end;
    end;
begin
    Result:='';
    countopen:=0;

    while el<>nil do begin
        if el.FType=caeName then begin
            oper:=LowerCase(el.FStr);
            if InDeclareVar(el) then begin
                Result:=DeclareVar(el); if Result<>'' then Exit;

                if el.FType<>caeSemicolon then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                el:=el.FNext;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;

            end else if oper='if' then begin
                unempty:=UnitInsert(insertto); unempty.FType:=cuteEmpty; unempty.FSme:=unempty.FSme; unempty.FLen:=0; unempty.FUnit:=codeunit;
                while true do begin
                    if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                    if (el.FNext.FType<>caeOpen1) or (el.FNext.FNext=nil) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                    un:=UnitInsert(unempty); un.FType:=cuteIf; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    un.FJump:=unempty;
                    un.FExperssion:=TExpressionEC.Create;
                    Result:=un.FExperssion.Compiler(ca,curclass,el.FNext.FNext,nil,@el2); if Result<>'' then Exit;
                    if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                    if el2.FType<>caeClose1 then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    el:=el2.FNext;
                    un.FLen:=el2.FSme-un.FSme+el2.FLen;
                    unif:=un;

                    un:=UnitInsert(unempty); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    un.FJump:=unempty;
                    un2:=un;

                    if el.FType=caeSemicolon then begin
                        el:=el.FNext;
                    end else begin
                        Result:=CompilerR(ca,codeunit,funinclude,el,un2,elendcomp,@el,opBreak,opContinue,curclass); if Result<>'' then Exit;
                    end;

                    if el=nil then Exit;
                    if (el.FType=caeName) then begin
                        oper:=LowerCase(el.FStr);
                        if oper='else' then begin
                            un:=UnitInsert(unempty); un.FType:=cuteEmpty; un.FSme:=0; un.FLen:=0; un.FUnit:=codeunit;
                            unif.FJump:=un;

                            if (el.FNext<>nil) and (el.FNext.FType=caeName) and (LowerCase(el.FNext.FStr)='if') then begin
                                el:=el.FNext;
                                continue;
                            End;

                            if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                            if el.FNext.FType<>caeSemicolon then begin
                                Result:=CompilerR(ca,codeunit,funinclude,el.FNext,unempty,elendcomp,@el,opBreak,opContinue,curclass); if Result<>'' then Exit;
                                if (elcontinue<>nil) and (countopen=0) then begin
                                    elcontinue^:=DWORD(el);
                                    Exit;
                                end;
                                break;
                            end;
                        end else break;
                    end else break;
                end;
                continue;
            end else if oper='while' then begin
                unempty:=UnitInsert(insertto); unempty.FType:=cuteEmpty; unempty.FSme:=unempty.FSme; unempty.FLen:=0; unempty.FUnit:=codeunit;

                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if (el.FNext.FType<>caeOpen1) or (el.FNext.FNext=nil) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                un:=UnitInsert(unempty); un.FType:=cuteIf; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                un.FJump:=unempty;
                un.FExperssion:=TExpressionEC.Create;
                Result:=un.FExperssion.Compiler(ca,curclass,el.FNext.FNext,nil,@el2); if Result<>'' then Exit;
                if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if el2.FType<>caeClose1 then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                el:=el2.FNext;
                un.FLen:=el2.FSme-un.FSme+el2.FLen;
                un2:=un;

                un:=UnitInsert(unempty); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                un.FJump:=un2;

                if el.FType=caeSemicolon then begin
                    el:=el.FNext;
                end else begin
                    Result:=CompilerR(ca,codeunit,funinclude,el,un,elendcomp,@el,unempty,un2,curclass); if Result<>'' then Exit;
                end;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;
            end else if oper='for' then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if (el.FNext.FType<>caeOpen1) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;
                if (el.FNext.FNext=nil) then begin Result:=CErrorEXP(0,el.FNext.FSme+el.FNext.FLen); Exit; end;

                el:=el.FNext.FNext;
                if el.FType=caeSemicolon then begin
                end else if InDeclareVar(el) then begin
                    Result:=DeclareVar(el); if Result<>'' then Exit;
                end else begin
                    while true do begin
                        un:=UnitInsert(insertto); un.FType:=cuteExpression; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                        un.FExperssion:=TExpressionEC.Create;
                        Result:=un.FExperssion.Compiler(ca,curclass,el,nil,@el2); if Result<>'' then Exit;
                        if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                        un.FLen:=el2.FSme-un.FSme+el2.FLen;

                        if el2.FType=caeSemicolon then begin
                            el:=el2;
                            break;
                        end else if el2.FType=caeComma then begin
                            el:=el2.FNext;
                        end else begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    end;
                end;

                if el.FType<>caeSemicolon then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                el:=el.FNext;

                unempty:=UnitInsert(insertto); unempty.FType:=cuteEmpty; unempty.FSme:=unempty.FSme; unempty.FLen:=0; unempty.FUnit:=codeunit;

                if el.FType=caeSemicolon then begin
                    un:=UnitInsert(unempty); un.FType:=cuteEmpty; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    el:=el.FNext;
                end else begin
                    un:=UnitInsert(unempty); un.FType:=cuteIf; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    un.FJump:=unempty;
                    un.FExperssion:=TExpressionEC.Create;
                    Result:=un.FExperssion.Compiler(ca,curclass,el,nil,@el2); if Result<>'' then Exit;
                    if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                    if el2.FType<>caeSemicolon then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    if el2.FNext=nil then begin Result:=CErrorEXP(0,el2.FSme+el2.FLen); Exit; end;
                    el:=el2.FNext;
                    un.FLen:=el2.FPrev.FSme-un.FSme+el2.FPrev.FLen;
                end;
                un2:=un;

                un:=UnitInsert(un2); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                un.FJump:=un2;

                un3:=nil;
                if el.FType=caeClose1 then begin
                    un:=UnitInsert(un2); un.FType:=cuteEmpty; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    un3:=un;
                    el:=el.FNext;
                end else begin
                    while true do begin
                        un:=UnitInsert(un2); un.FType:=cuteExpression; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                        un.FExperssion:=TExpressionEC.Create;
                        Result:=un.FExperssion.Compiler(ca,curclass,el,nil,@el2); if Result<>'' then Exit;
                        if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                        un.FLen:=el2.FPrev.FSme-un.FSme+el2.FPrev.FLen;
                        if un3=nil then un3:=un;

                        if el2.FType=caeClose1 then begin
                            el:=el2.FNext;
                            break;
                        end else if el2.FType=caeComma then begin
                            el:=el2.FNext;
                        end else begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    end;
                end;

                un:=UnitInsert(unempty); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                un.FJump:=un3;

                if el.FType=caeSemicolon then begin
                    el:=el.FNext;
                end else begin
                    Result:=CompilerR(ca,codeunit,funinclude,el,un,elendcomp,@el,unempty,un2,curclass); if Result<>'' then Exit;
                end;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;

            end else if oper='break' then begin
                if (opBreak=nil) or (el.FNext=nil) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if (el.FNext.FType<>caeSemicolon) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                un:=UnitInsert(insertto); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=el.FNext.FSme-el.FSme+el.FNext.FLen; un.FUnit:=codeunit;
                un.FJump:=opBreak;

                el:=el.FNext.FNext;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;
            end else if oper='continue' then begin
                if (opContinue=nil) or (el.FNext=nil) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                if (el.FNext.FType<>caeSemicolon) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                un:=UnitInsert(insertto); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=el.FNext.FSme-el.FSme+el.FNext.FLen; un.FUnit:=codeunit;
                un.FJump:=opContinue;

                el:=el.FNext.FNext;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;
            end else if oper='exit' then begin
                if (el.FNext=nil) then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if (el.FNext.FType<>caeSemicolon) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                un:=UnitInsert(insertto); un.FType:=cuteExit; un.FSme:=el.FSme; un.FLen:=el.FNext.FSme-el.FSme+el.FNext.FLen; un.FUnit:=codeunit;

                el:=el.FNext.FNext;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;
            end else if (oper='#include') or (oper='#insert') then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if (el.FNext.FType<>caeStr) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                if not Assigned(funinclude) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;

                zbool:=oper='#insert';

                cainclude:=TCodeAnalyzerEC.Create;
                zint:=funinclude(codeunit,el.FNext.FStr,zbool,unitinclude,cainclude);
                if (zint=2) or (zint=3) then begin
                    cainclude.Free;
                    Result:=CErrorEXP(0,el.FNext.FSme);
                    Exit;
                end else if (zint=0) then begin
                    zstr:=cainclude.TestOpenClose;
                    if zstr<>'' then begin
                        cainclude.Free;
                        Result:=CErrorEXP(0,el.FNext.FSme);
                        Exit;
                    end;

//                  Compiler(cainclude,unitinclude,funinclude);
                    Result:=CompilerR(cainclude,unitinclude,funinclude,cainclude.FFirst,insertto,nil,nil,nil,nil,curclass);
                    if Result<>'' then begin
                        cainclude.Free;
                        Exit;
                    end;
                end;
                cainclude.Free;

                el:=el.FNext.FNext;
                continue;
            end else if oper='function' then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if (el.FNext.FType<>caeName) or (not IsVarEXP(el.FNext.FStr)) or (el.FNext.FNext=nil) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;
                if (el.FNext.FNext.FType<>caeOpen1) or (el.FNext.FNext.FNext=nil) then begin Result:=CErrorEXP(0,el.FNext.FNext.FSme); Exit; end;

                tvar:=FLocalVar.Add(el.FNext.FStr,vtFun);
                cfun:=tvar.VFun;
                cfun.FParent:=self;

                el2:=el.FNext.FNext.FNext;
                while (el2<>nil) and (el2.FType=caeName) and (IsVarEXP(el2.FStr)) do begin
                    oper:=LowerCase(el2.FStr);
                    if (oper='unknown') or (oper='int') or (oper='dword') or (oper='float') or (oper='str') or (oper='ref') or (oper='array') then begin
                        el2:=el2.FNext;
                    end else oper:='unknown';
                    if (el2=nil) or (el2.FType<>caeName) or (not IsVarEXP(el2.FStr)) then break;

                    tvar:=nil;
                    if oper='unknown' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtUnknown)
                    else if oper='int' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtInt)
                    else if oper='dword' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtDW)
                    else if oper='float' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtFloat)
                    else if oper='str' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtStr)
                    else if oper='ref' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtRef)
                    else if oper='array' then tvar:=cfun.FLocalVar.Add(el2.FStr,vtArray);

                    el2:=el2.FNext; if el2=nil then begin Result:=CErrorEXP(0,ca.FLast.FSme+ca.FLast.FLen); Exit; end;

                    if (oper<>'ref') and (el2.FType=caeAssume) then begin
                        if el2.FNext=nil then begin Result:=CErrorEXP(0,ca.FLast.FSme+ca.FLast.FLen); Exit; end;
                        el2:=el2.FNext;

                        if DecodeFloatEXP(el2,zfloat) then tvar.VFloat:=zfloat
                        else if DecodeDWEXP(el2,zdword) then tvar.VDW:=zdword
                        else if DecodeIntEXP(el2,zint) then tvar.VInt:=zint
                        else if DecodeStrEXP(el2,zstr) then tvar.VStr:=zstr
                        else begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    end;

                    if (el2=nil) or (el2.FType<>caeComma) then break;
                    el2:=el2.FNext;
                end;
                if (el2=nil) or (el2.FType<>caeClose1) then begin Result:=CErrorEXP(0,el.FNext.FNext.FNext.FSme); Exit; end;
                el:=el2.FNext;
                if el=nil then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                if (el.FType<>caeOpen2) or (el.FNext=nil) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;

                cnt:=cfun.FLocalVar.Count;
                cfun.FLocalVar.Add('funBaseVarCount',vtInt).VInt:=cnt;
                cfun.FLocalVar.Add('result',vtRef);

                el2:=nil;
                Result:=cfun.Compiler(ca,codeunit,funinclude,el.FNext,@el2,curclass); if Result<>'' then Exit;
                if el2=nil then begin Result:=CErrorEXP(0,ca.FLast.FSme+ca.FLast.FLen); Exit; end;
                if el2.FType<>caeClose2 then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                el:=el2.FNext;
                continue;
            end else if oper='class' then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if (el.FNext.FType<>caeName) or (not IsVarEXP(el.FNext.FStr)) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;
                if el.FNext.FNext=nil then begin Result:=CErrorEXP(0,el.FNext.FSme+el.FNext.FLen); Exit; end;

                tvar:=FLocalVar.Add(el.FNext.FStr,vtFun);
                cfun:=tvar.VFun;
                cfun.FParent:=self;
                cfun.FIsClass:=true;
                cfun.FClassName:=el.FNext.FStr;

                el:=el.FNext.FNext;

                if el.FType=caeColon then begin
                    el:=el.FNext;
                    while True do begin
                        if el.FType<>caeName then break;

                        tvar2:=FLocalVar.GetVarNE(el.FStr);
                        if (tvar2=nil) or (tvar2.VType<>vtFun) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                        cfun.FLocalVar.Add(el.FStr,vtFun).VFun.CopyFrom(tvar2.VFun);

                        el:=el.FNext;
                        if el.FType<>caeComma then break;
                        el:=el.FNext;
                    end;
                end;

                if (el.FType<>caeOpen2) then begin Result:=CErrorEXP(0,el.FSme); Exit; end;

                el2:=nil;
                Result:=cfun.Compiler(ca,codeunit,funinclude,el.FNext,@el2,cfun); if Result<>'' then Exit;
                if el2=nil then begin Result:=CErrorEXP(0,ca.FLast.FSme+ca.FLast.FLen); Exit; end;
                if el2.FType<>caeClose2 then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                el:=el2.FNext;
                continue;

            end else if oper='try' then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if (el.FNext.FType<>caeOpen2) then begin Result:=CErrorEXP(0,el.FNext.FSme); Exit; end;

                un2:=UnitInsert(insertto); un2.FType:=cuteTry; un2.FSme:=el.FSme; un2.FLen:=0{el.FLen}; un2.FUnit:=codeunit;

                Result:=CompilerR(ca,codeunit,funinclude,el.FNext,insertto,elendcomp,@el,nil,nil,curclass); if Result<>'' then Exit;

                un:=UnitInsert(insertto); un.FType:=cuteTryEnd; un.FSme:=el.FSme; un.FLen:=0{el.FLen}; un.FUnit:=codeunit;

                if el=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;
                if el.FType<>caeName then begin Result:=CErrorEXP(1001,el.FSme); Exit; end;
                if (el.FStr<>'catch') and (el.FStr<>'finally') then begin Result:=CErrorEXP(1001,el.FSme); Exit; end;
                if (el.FNext=nil) then begin Result:=CErrorEXP(1001,el.FSme+el.FLen); Exit; end;

                if el.FStr='catch' then zint:=0 else zint:=1;
                el:=el.FNext;

                tvar:=nil;
                if el.FType=caeOpen1 then begin
                    if el.FNext=nil then begin Result:=CErrorEXP(1001,el.FSme+el.FLen); Exit; end;
                    el:=el.FNext;
                    if el.FType<>caeName then begin Result:=CErrorEXP(1001,el.FSme); Exit; end;
                    tvar:=FLocalVar.Add(el.FStr,vtUnknown);
                    if el.FNext=nil then begin Result:=CErrorEXP(1001,el.FSme+el.FLen); Exit; end;
                    el:=el.FNext;
                    if el.FType<>caeClose1 then begin Result:=CErrorEXP(1001,el.FSme); Exit; end;
                    if el.FNext=nil then begin Result:=CErrorEXP(1001,el.FSme+el.FLen); Exit; end;
                    el:=el.FNext;
                end;

                if (el.FType<>caeOpen2) then begin Result:=CErrorEXP(1001,el.FSme); Exit; end;

                unempty:=UnitInsert(insertto); unempty.FType:=cuteEmpty; unempty.FSme:=unempty.FSme; unempty.FLen:=0; unempty.FUnit:=codeunit;

                if zint=0 then begin
                    un:=UnitInsert(unempty); un.FType:=cuteJump; un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                    un.FJump:=unempty;
                end;

                un:=UnitInsert(unempty); un.FType:=cuteEmpty; un.FSme:=un.FSme; un.FLen:=0; un.FUnit:=codeunit;
                un2.FJump:=un;
                un.FVar:=tvar;

                un:=unempty;
                if zint=1 then begin
                    un:=UnitInsert(un); un.FType:=cuteThrow; un.FSme:=el.FSme; un.FLen:=0{el.FLen}; un.FUnit:=codeunit;
                end;

                Result:=CompilerR(ca,codeunit,funinclude,el,un{unempty},elendcomp,@el,nil,nil,curclass); if Result<>'' then Exit;
                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;

                continue;

            end else if oper='throw' then begin
                if el.FNext=nil then begin Result:=CErrorEXP(0,el.FSme+el.FLen); Exit; end;

                if (el.FNext.FType=caeSemicolon) then begin
                    un:=UnitInsert(insertto); un.FType:=cuteThrow; un.FSme:=el.FSme; un.FLen:=el.FNext.FSme-el.FSme+el.FNext.FLen; un.FUnit:=codeunit;

                    el:=el.FNext.FNext;

                end else begin
                    un:=UnitInsert(insertto); un.FType:=cuteThrow; un.FSme:=el.FSme; un.FLen:=el.FNext.FSme-el.FSme+el.FNext.FLen; un.FUnit:=codeunit;
                    un.FExperssion:=TExpressionEC.Create;
                    Result:=un.FExperssion.Compiler(ca,curclass,el.FNext,nil,@el2); if Result<>'' then Exit;
                    if el2=nil then begin Result:=CErrorEXP(0,el.FSme); Exit; end;
                    if el2.FType<>caeSemicolon then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                    el:=el2.FNext;
                    un.FLen:=el2.FSme-un.FSme+el2.FLen;
                end;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el);
                    Exit;
                end;
                continue;

            end else begin
                un:=UnitInsert(insertto);
                un.FType:=cuteExpression;
                un.FExperssion:=TExpressionEC.Create;
                un.FSme:=el.FSme; un.FLen:=0; un.FUnit:=codeunit;
                Result:=un.FExperssion.Compiler(ca,curclass,el,nil,@el2);
                if Result<>'' then Exit;
                if el2=nil then begin Result:=CErrorEXP(0,ca.FLast.FSme+ca.FLast.FLen); Exit; end;
                if el2.FType<>caeSemicolon then begin Result:=CErrorEXP(0,el2.FSme); Exit; end;
                un.FLen:=el2.FSme+el2.FLen-un.FSme;

                if (elcontinue<>nil) and (countopen=0) then begin
                    elcontinue^:=DWORD(el2.FNext);
                    Exit;
                end;

                el:=el2.FNext;
                continue;
            end;
        end else if el.FType=caeOpen2 then begin
            inc(countopen);
        end else if el.FType=caeClose2 then begin
            dec(countopen);
            if (elcontinue<>nil) and (countopen=0) then begin
                elcontinue^:=DWORD(el.FNext);
                Exit;
            end else if countopen=-1 then begin
                if elendcomp<>nil then elendcomp^:=DWORD(el);
                Exit;
            end;
        end else begin
            Result:=CErrorEXP(0,el.FSme);
            Exit;
        end;
        if el=nil then Exit;
        el:=el.FNext;
    end;
end;
{$WARNINGS ON}

procedure TCodeEC.Link(va:TVarArrayEC);
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
        //if un.FType=cuteExpression then
        if un.FExperssion<>nil then un.FExperssion.Link(va);
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                VFun.Link(va);
            end else if (FVType=vtClass) and (VFun<>nil) then begin
                VClass.Link(va);
            end;
        end;
    end;
end;

procedure TCodeEC.LinkAll(va:TVarArrayEC);
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
{        if (un.FType=cuteExpression) or (un.FType=cuteIf) then}
        if un.FExperssion<>nil then un.FExperssion.LinkAll(va);
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                VFun.LinkAll(va);
            end else if (FVType=vtClass) and (VClass<>nil) then begin
                VClass.LinkAll(va);
            end;
        end;
    end;
end;

procedure TCodeEC.LinkClass;
var
    i:integer;
begin
    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (FVFun<>nil) and (FVFun.FIsClass) then begin
                FVFun.LinkClass;
            end;
        end;
    end;
    LinkAll(FLocalVar);
end;

procedure TCodeEC.UnLink(va:TVarArrayEC);
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
        if un.FType=cuteExpression then un.FExperssion.UnLink(va);
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (VType=vtFun) and (VFun<>nil) then VFun.UnLink(va)
            else if (VType=vtClass) and (VClass<>nil) then VClass.UnLink(va);
        end;
    end;
end;

procedure TCodeEC.Run(cpr:TCodeProcessEC);
var
    un:TCodeUnitEC;
    pt:PCodeProcessTryEC;
    pth:PCodeProcessThrowEC;
    throwvar:TVarEC;
begin
    LinkAll(FLocalVar);

    throwvar:=nil;

    un:=FFirst;
    while un<>nil do begin
        if un.FType=cuteExpression then begin
            un.FExperssion.Run(cpr,self);
        end else if un.FType=cuteJump then begin
            un:=un.FJump;
            continue;
        end else if un.FType=cuteIf then begin
            un.FExperssion.Run(cpr,self);
            if not un.FExperssion.Return.IsTrue then begin
                un:=un.FJump;
                continue;
            end;
        end else if un.FType=cuteExit then begin
            while true do begin
                pt:=cpr.TryGetLast;
                if (pt=nil) or (pt.FCode<>self) then break;
                cpr.TryDelLast;
            end;
            break;
        end else if un.FType=cuteTry then begin
            cpr.TryAdd(self,un.FJump);
        end else if un.FType=cuteTryEnd then begin
            cpr.TryDelLast;
        end else if un.FType=cuteThrow then begin
            if un.FExperssion<>nil then begin
                un.FExperssion.Run(cpr,self);
                cpr.ThrowAdd(un.FExperssion.Return);
            end else begin
                if throwvar<>nil then begin
                    cpr.ThrowAdd(throwvar);
                    throwvar:=nil;
                end;// else raise ExceptionExpressionEC.Create('throw');
            end;
{        end else if un.FType=cuteThrowEnd then begin
            cpr.ThrowDelLast;}
        end;

        pth:=cpr.ThrowGetLast;
        if (pth<>nil) then begin
            pt:=cpr.TryGetLast;
            if (pt<>nil) then begin
                if pt.FCode=self then begin
                    un:=pt.FUnit;
                    throwvar:=pth.FVar; pth.FVar:=nil;
                    if un.FVar<>nil then begin
                        un.FVar.Assume(throwvar);
                    end;
                    cpr.TryDelLast;
                    cpr.ThrowDelLast;
                    continue;
                end else begin
                    break;
                end;
            end;
        end;

        un:=un.FNext;
    end;

    if throwvar<>nil then begin throwvar.Free; end;
end;

procedure TCodeEC.RunDebug(cpr:TCodeProcessEC; cd:TCodeDebugEC);
var
    un:TCodeUnitEC;
    aev: array[0..1] of THandle;
    rz:DWORD;
    pt:PCodeProcessTryEC;
    pth:PCodeProcessThrowEC;
    throwvar:TVarEC;
begin
    LinkAll(FLocalVar);

    throwvar:=nil;

    aev[0]:=cd.FEventBreak;
    aev[1]:=cd.FEventBPEnd;

    un:=FFirst;
    while un<>nil do begin

        rz:=WaitForSingleObject(cd.FEventBreak,0);
        if rz=WAIT_FAILED then break;
        if (rz=WAIT_OBJECT_0) or (rz=WAIT_ABANDONED) then break;

        if (cd.FStop and (un.FLen>0)) or un.FBP then begin
            cd.FStopUnit:=un;
            ResetEvent(cd.FEventBPEnd);
            rz:=WaitForMultipleObjects(2,@aev,false,INFINITE);
            if rz=WAIT_FAILED then break;
            if rz=WAIT_OBJECT_0 then break;
            if (rz>=WAIT_ABANDONED_0) and (rz<(WAIT_ABANDONED_0+2)) then break;

            cd.FStopLastCode:=self;

            if cd.FStopType=cdst_StepIn then cd.FStop:=true;
        end;
        if un.FType=cuteExpression then begin
            un.FExperssion.Run(cpr,self,cd);
        end else if un.FType=cuteJump then begin
            un:=un.FJump;
            continue;
        end else if un.FType=cuteIf then begin
            un.FExperssion.Run(cpr,self,cd);
            if not un.FExperssion.Return.IsTrue then begin
                un:=un.FJump;
                continue;
            end;
        end else if un.FType=cuteExit then begin
            while true do begin
                pt:=cpr.TryGetLast;
                if (pt=nil) or (pt.FCode<>self) then break;
                cpr.TryDelLast;
            end;
            break;
        end else if un.FType=cuteTry then begin
            cpr.TryAdd(self,un.FJump);
        end else if un.FType=cuteTryEnd then begin
            cpr.TryDelLast;
        end else if un.FType=cuteThrow then begin
            if un.FExperssion<>nil then begin
                un.FExperssion.Run(cpr,self);
                cpr.ThrowAdd(un.FExperssion.Return);
            end else begin
                if throwvar<>nil then begin
                    cpr.ThrowAdd(throwvar);
                    throwvar:=nil;
                end;// else raise ExceptionExpressionEC.Create('throw');
            end;
{        end else if un.FType=cuteThrowEnd then begin
            cpr.ThrowDelLast;}
        end;

        pth:=cpr.ThrowGetLast;
        if (pth<>nil) then begin
            pt:=cpr.TryGetLast;
            if (pt<>nil) then begin
                if pt.FCode=self then begin
                    un:=pt.FUnit;
                    throwvar:=pth.FVar; pth.FVar:=nil;
                    if un.FVar<>nil then begin
                        un.FVar.Assume(throwvar);
                    end;
                    cpr.TryDelLast;
                    cpr.ThrowDelLast;
                    continue;
                end else begin
                    break;
                end;
            end else break;
        end;

        if (cd.FStopType=cdst_StepNext) and (cd.FStopLastCode=self) then cd.FStop:=true;
        un:=un.FNext;
    end;

    if ((cd.FStopType=cdst_StepNext) or (cd.FStopType=cdst_StepOut)) and (cd.FStopLastCode=self) then cd.FStop:=true;

    if throwvar<>nil then begin throwvar.Free; end;
end;

function TCodeEC.EndCode(level:WideString):WideString;
var
    un:TCodeUnitEC;
    tv:TVarEC;
    i:integer;
    tstr:WideString;
begin
    Result:='';

    for i:=0 to FLocalVar.Count-1 do begin
        tv:=FLocalVar.Items[i];
        if tv.FVType=vtFun then begin
            Result:=Result+level+'function '+tv.Name+#13#10+'{'+#13#10;
            Result:=Result+tv.VFun.EndCode(level+'    ');
            Result:=Result+level+'}'+#13#10;
        end;
    end;
    for i:=0 to FLocalVar.Count-1 do begin
        tv:=FLocalVar.Items[i];
        if tv.FVType<>vtFun then begin
            case tv.FVType of
                vtUnknown: tstr:='unknown';
                vtInt: tstr:='int';
                vtDW: tstr:='dw';
                vtFloat: tstr:='float';
                vtStr: tstr:='str';
                vtExternFun: tstr:='externfun';
                vtLibraryFun: tstr:='libraryfun';
                vtFun: tstr:='fun';
                vtClass: tstr:='class';
                vtArray: tstr:='array';
                vtRef: tstr:='ref';
            else
                raise Exception.Create('TCodeEC.EndCode');
            end;
            Result:=Result+level+tstr+' '+tv.FName+#13#10;
        end;
    end;

    un:=FFirst;
    while un<>nil do begin
        Result:=Result+level+IntToStr(UnitToNum(un))+': ';
        if un.FType=cuteEmpty then begin
            Result:=Result+level+'Empty'#13#10;
        end else if un.FType=cuteExpression then begin
            Result:=Result+level+'Expresion'#13#10;
            Result:=Result+un.FExperssion.EndCode(level+'    ');
        end else if un.FType=cuteJump then begin
            Result:=Result+level+'Jump '+IntToStr(UnitToNum(un.FJump))+#13#10;
        end else if un.FType=cuteIf then begin
            Result:=Result+level+'if '+IntToStr(UnitToNum(un.FJump))+#13#10;
        end;
        un:=un.FNext;
    end;
end;

function TCodeEC.BPNearest(codeunit:integer; tsme:integer; tsmemin:integer; tsmemax:integer):TCodeUnitEC;
var
    un:TCodeUnitEC;
    mindist:integer;
begin
//    Result:=nil;
    if FFirst=nil then begin Result:=BPNearestFun(codeunit,tsme,tsmemin,tsmemax); Exit; end;

    un:=FFirst;
    while un<>nil do begin
        if un.FUnit<>codeunit then begin un:=un.FNext; continue; end;
        if (un.FLen>0) and (un.FSme>=tsmemin) then break;
        un:=un.FNext;
    end;
    if un=nil then begin Result:=BPNearestFun(codeunit,tsme,tsmemin,tsmemax); Exit; end;
    if (un.FSme{+un.FLen})>=tsmemax then begin Result:=BPNearestFun(codeunit,tsme,tsmemin,tsmemax); Exit; end;

    Result:=un;
    if (tsme>=un.FSme) and (tsme<(un.FSme+un.FLen)) then Exit;

    mindist:=abs(un.FSme-tsme);
    un:=un.FNext;
    while un<>nil do begin
        if un.FUnit<>codeunit then begin un:=un.FNext; continue; end;
        if (un.FSme{+un.FLen})>=tsmemax then break;
        if (tsme>=un.FSme) and (tsme<(un.FSme+un.FLen)) then begin Result:=un; Exit; End;
        if (un.FLen>0) then begin
            if mindist>abs(un.FSme-tsme) then begin
                mindist:=abs(un.FSme-tsme);
                Result:=un;
            end;// else Exit;
        end;
        un:=un.FNext;
    end;
end;

function TCodeEC.BPNearestFun(codeunit:integer; tsme:integer; tsmemin:integer; tsmemax:integer):TCodeUnitEC;
var
    i:integer;
begin
    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                Result:=VFun.BPNearest(codeunit,tsme,tsmemin,tsmemax);
                if Result<>nil then Exit;
            end;
        end;
    end;
    Result:=nil;
end;

procedure TCodeEC.BPAllEqual(el:TCodeUnitEC; li:TList);
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
        if (un.FSme=el.FSme) and (un.FLen=el.FLen) and (un.FUnit=el.FUnit) and (un.FType=el.FType) then begin
            li.Add(un);
        end;
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                VFun.BPAllEqual(el,li);
            end;
        end;
    end;
end;

procedure TCodeEC.BPDeleteAll;
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
        un.FBP:=false;
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                VFun.BPDeleteAll;
            end;
        end;
    end;
end;

procedure TCodeEC.BPFindAll(list:TList);
var
    un:TCodeUnitEC;
    i:integer;
begin
    un:=FFirst;
    while un<>nil do begin
        if un.FBP then begin
            list.Add(un);
        end;
        un:=un.FNext;
    end;

    for i:=0 to FLocalVar.Count-1 do begin
        with FLocalVar.Items[i] do begin
            if (FVType=vtFun) and (VFun<>nil) then begin
                VFun.BPFindAll(list);
            end;
        end;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
//// Std Function //////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
procedure SF_Min(av:array of TVarEC; code:TCodeEC);
var
    i,cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].Assume(av[1]);
    for i:=2 to cnt-1 do begin
        if av[i].Less(av[0]) then begin av[0].VType:=av[i].VType; av[0].Assume(av[i]); end;
    end;
end;

procedure SF_Max(av:array of TVarEC; code:TCodeEC);
var
    i,cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].Assume(av[1]);
    for i:=2 to cnt-1 do begin
        if av[i].More(av[0]) then begin av[0].VType:=av[i].VType; av[0].Assume(av[i]); end;
    end;
end;

procedure SF_NewArray(av:array of TVarEC; code:TCodeEC);
var
    i,cnt:integer;
    ar:array of integer;
begin
    cnt:=High(av)+1;
    av[0].VType:=vtArray;
    if cnt<2 then Exit;
    dec(cnt);
    SetLength(ar,cnt);
    for i:=0 to cnt-1 do begin
        if (av[i+1].VType<>vtInt) or (av[i+1].VInt<1) then begin ar:=nil; Exit; End;
        ar[i]:=av[i+1].VInt;
    end;
    av[0].ArrayInit(ar);
    ar:=nil;
end;

procedure SF_Free(av:array of TVarEC; code:TCodeEC);
var
    cnt,i:integer;
begin
    cnt:=High(av)+1-1;
    if cnt<1 then Exit;
    av[0].Assume(av[1]);
    for i:=0 to cnt-1 do begin
        av[i+1].ArrayClear;
    end;
end;

procedure SF_Count(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1-1;
    if cnt<1 then Exit;
    if av[1].VType=vtArray then av[0].VInt:=av[1].VArray.Count;
    if av[1].VType=vtStr then av[0].VInt:=Length(av[1].VStr);
end;

procedure SF_Copy(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1-1;
    if cnt<2 then Exit;
    av[1].VType:=av[2].VType;
    av[1].Assume(av[2]);
end;

procedure SF_abs(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    if av[1].VType=vtInt then av[0].VInt:=abs(av[1].VInt)
    else av[0].VFloat:=abs(av[1].VFloat);
end;

procedure SF_arctan(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=arctan(av[1].VFloat);
end;

procedure SF_exp(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=exp(av[1].VFloat);
end;

procedure SF_ln(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=ln(av[1].VFloat);
end;

procedure SF_round(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    if av[1].VType=vtFloat then av[0].VInt:=Round(av[1].VFloat)
    else av[0].VInt:=av[1].VInt;
end;

procedure SF_sin(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=sin(av[1].VFloat);
end;

procedure SF_cos(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=cos(av[1].VFloat);
end;

procedure SF_sqr(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    if av[1].VType=vtInt then av[0].VInt:=av[1].VInt*av[1].VInt
    else av[0].VFloat:=sqr(av[1].VFloat);
end;

procedure SF_sqrt(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=sqrt(av[1].VFloat);
end;

procedure SF_frac(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VFloat:=frac(av[1].VFloat);
end;

procedure SF_int(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VInt:=Trunc(av[1].VFloat);
end;

procedure SF_rnd(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VInt:=Random(av[1].VInt);
end;

procedure SF_randomize(av:array of TVarEC; code:TCodeEC);
begin
    Randomize();
end;

procedure SF_randseed(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<1 then Exit;
    av[0].VInt:=RandSeed;
    if cnt<2 then Exit;
    RandSeed:=av[1].VInt;
end;

procedure SF_substr(av:array of TVarEC; code:TCodeEC);
var
    cnt,sme,tlen,lenstr:integer;
begin
    cnt:=High(av)+1;
    if cnt<3 then Exit;
    lenstr:=Length(av[1].VStr);
    sme:=av[2].VInt;
    if cnt>=4 then tlen:=av[3].VInt
    else tlen:=1999999999;

    if (sme<0) or (sme>=lenstr) then begin
        av[0].VStr:='';
        Exit;
    end;
    if sme+tlen>lenstr then tlen:=lenstr-sme;
    av[0].VStr:=Copy(av[1].VStr,sme+1,tlen);
end;

procedure SF_trim(av:array of TVarEC; code:TCodeEC);
var
    cnt:integer;
begin
    cnt:=High(av)+1;
    if cnt<2 then Exit;
    av[0].VStr:=TrimEXP(av[1].VStr);
end;

procedure SF_LoadLibrary(av:array of TVarEC; code:TCodeEC);
begin
    if High(av)<>1 then Exit;
    av[0].VDW:=LoadLibrary(PChar(AnsiString(av[1].VStr)));
end;

procedure SF_FreeLibrary(av:array of TVarEC; code:TCodeEC);
begin
    if High(av)<>1 then Exit;
    av[0].VInt:=integer(FreeLibrary(av[1].VDW));
end;

procedure SF_LibraryFunction(av:array of TVarEC; code:TCodeEC);
var
    i:integer;
    fun:Pointer;
    tstr:WideString;
begin
    if High(av)<3 then Exit;

    fun:=GetProcAddress(av[1].VDW,PChar(AnsiString(av[3].VStr)));
    if fun=nil then begin av[0].VInt:=0; Exit; End;

    av[0].ChangeVType(vtLibraryFun);

    SetLength(av[0].FVLibraryFun,2+High(av)-3);

    if av[2].VStr='int' then av[0].FVLibraryFun[0]:=1
    else if av[2].VStr='dword' then av[0].FVLibraryFun[0]:=2
    else av[0].FVLibraryFun[0]:=0;

    av[0].FVLibraryFun[1]:=DWORD(fun);

    for i:=0 to High(av)-3-1 do begin
        tstr:=av[4+i].VStr;
        if tstr='int' then av[0].FVLibraryFun[2+i]:=1
        else if tstr='dword' then av[0].FVLibraryFun[2+i]:=2
        else if tstr='str' then av[0].FVLibraryFun[2+i]:=3
        else raise ExceptionExpressionEC.Create('LibraryFunction. Unknown type');
    end;
end;

procedure SF_New(av:array of TVarEC; code:TCodeEC);
var
    tvar:TVarEC;
    tc,tcnew:TCodeEC;
//    tstr:WideString;
begin
    if High(av)<>1 then Exit;
    if code=nil then Exit;
    while (code<>nil) and (code.FParent<>nil){and (not code.FIsClass)} do code:=code.FParent;
//    if code=nil then Exit;

{    tstr:=code.FLocalVar.Items[0].FName;
    tstr:=code.FLocalVar.Items[1].FName;
    tstr:=code.FLocalVar.Items[2].FName;
    tstr:=code.FLocalVar.Items[3].FName;
    tstr:=code.FLocalVar.Items[4].FName;
    tstr:=code.FLocalVar.Items[5].FName;}

    tvar:=code.FLocalVar.GetVar(av[1].VStr);
    if tvar.VType<>vtFun then Exit;
    tc:=tvar.VFun;
    if not tc.FIsClass then Exit;

//    tstr:=tc.LocalVar.Items[2].VStr;
//    tc.LocalVar.Items[2].VStr:=tstr;

    tcnew:=TCodeEC.Create;
    tcnew.CopyFromFast(tc);
    tcnew.LinkClass;
    av[0].VClass:=tcnew;
end;

procedure SF_Delete(av:array of TVarEC; code:TCodeEC);
begin
    if High(av)<>1 then Exit;

    if av[1].VType=vtClass then begin
        av[1].VClass.Free;
        av[1].SetVType(vtUnknown);
    end;
end;

procedure TVarArrayEC.AddStdFunction;
begin
    Add('pi',vtFloat).VFloat:=Pi;

    Add('min',vtExternFun).VExternFun:=SF_Min;
    Add('max',vtExternFun).VExternFun:=SF_Max;
    Add('newarray',vtExternFun).VExternFun:=SF_NewArray;
    Add('free',vtExternFun).VExternFun:=SF_Free;
    Add('count',vtExternFun).VExternFun:=SF_Count;
    Add('copy',vtExternFun).VExternFun:=SF_Copy;

    Add('abs',vtExternFun).VExternFun:=SF_abs;
    Add('arctan',vtExternFun).VExternFun:=SF_arctan;
    Add('exp',vtExternFun).VExternFun:=SF_exp;
    Add('ln',vtExternFun).VExternFun:=SF_ln;
    Add('round',vtExternFun).VExternFun:=SF_round;
    Add('sin',vtExternFun).VExternFun:=SF_sin;
    Add('cos',vtExternFun).VExternFun:=SF_cos;
    Add('sqr',vtExternFun).VExternFun:=SF_sqr;
    Add('sqrt',vtExternFun).VExternFun:=SF_sqrt;
    Add('frac',vtExternFun).VExternFun:=SF_frac;
    Add('int',vtExternFun).VExternFun:=SF_int;

    Add('rnd',vtExternFun).VExternFun:=SF_rnd;
    Add('randomize',vtExternFun).VExternFun:=SF_randomize;
    Add('randseed',vtExternFun).VExternFun:=SF_randseed;

    Add('substr',vtExternFun).VExternFun:=SF_substr;
    Add('trim',vtExternFun).VExternFun:=SF_trim;

    Add('LoadLibrary',vtExternFun).VExternFun:=SF_LoadLibrary;
    Add('FreeLibrary',vtExternFun).VExternFun:=SF_FreeLibrary;
    Add('LibraryFunction',vtExternFun).VExternFun:=SF_LibraryFunction;

    Add('new',vtExternFun).VExternFun:=SF_New;
    Add('delete',vtExternFun).VExternFun:=SF_Delete;
end;

end.

