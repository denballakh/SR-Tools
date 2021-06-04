unit DebugMsg;

interface

uses Windows;

procedure DMcc(group:PChar; text:PChar); cdecl; external 'DebugMsg.dll' name 'DMcc';
procedure DMcc_(group:PChar; text:PChar); cdecl; external 'DebugMsg.dll' name 'DMcc_';
procedure DMww(group:PWideChar; text:PWideChar); cdecl; external 'DebugMsg.dll' name 'DMww';
procedure DMww_(group:PWideChar; text:PWideChar); cdecl; external 'DebugMsg.dll' name 'DMww_';

function DCGet(scom:PWideChar):DWORD; cdecl; external 'DebugMsg.dll' name 'DCGet';
procedure DCFree(com:DWORD); cdecl; external 'DebugMsg.dll' name 'DCFree';
function DCNameW(com:DWORD):PWideChar; cdecl; external 'DebugMsg.dll' name 'DCNameW';
function DCNameA(com:DWORD):PChar; cdecl; external 'DebugMsg.dll' name 'DCNameA';
function DCNameI(com:DWORD):integer; cdecl; external 'DebugMsg.dll' name 'DCNameI';
function DCCnt(com:DWORD):integer; cdecl; external 'DebugMsg.dll' name 'DCCnt';
function DCStrW(com:DWORD):PWideChar; cdecl; external 'DebugMsg.dll' name 'DCStrW';
function DCStrA(com:DWORD):PChar; cdecl; external 'DebugMsg.dll' name 'DCStrA';
function DCInt(com:DWORD):integer; cdecl; external 'DebugMsg.dll' name 'DCInt';
function DCFloat(com:DWORD):double; cdecl; external 'DebugMsg.dll' name 'DCFloat';
procedure DCAnswerW(com:DWORD; str:PWideChar); cdecl; external 'DebugMsg.dll' name 'DCAnswerW';
procedure DCAnswerA(com:DWORD; str:PChar); cdecl; external 'DebugMsg.dll' name 'DCAnswerA';

procedure DM(group:AnsiString; text:AnsiString); overload;
procedure DM_(group:AnsiString; text:AnsiString); overload;
procedure DM(group:WideString; text:WideString); overload;
procedure DM_(group:WideString; text:WideString); overload;

procedure DCAnswer(com:DWORD; str:AnsiString); overload;
procedure DCAnswer(com:DWORD; str:WideString); overload;

function DMF(tstr:WideString; size:integer; align:integer=1; char:WideChar=' '):WideString;

implementation

procedure DM(group:AnsiString; text:AnsiString);
begin
	DMcc(PChar(group),PChar(text));
end;

procedure DM_(group:AnsiString; text:AnsiString);
begin
	DMcc_(PChar(group),PChar(text));
end;

procedure DM(group:WideString; text:WideString);
begin
	DMww(PWideChar(group),PWideChar(text));
end;

procedure DM_(group:WideString; text:WideString);
begin
	DMww_(PWideChar(group),PWideChar(text));
end;

procedure DCAnswer(com:DWORD; str:AnsiString);
begin
	DCAnswerA(com,PChar(str));
end;

procedure DCAnswer(com:DWORD; str:WideString);
begin
	DCAnswerW(com,PWideChar(str));
end;

function DMF(tstr:WideString; size:integer; align:integer=1; char:WideChar=' '):WideString;
var
	l,i,sme:integer;
begin
    	l:=Length(tstr);
        if l>size then begin
        	Result:=Copy(tstr,1,size-1)+'~';
        end else if l<size then begin
        	SetLength(Result,size);
            if align>0 then begin
	            for i:=0 to size-l do Result[i+1]:=char;
    	        CopyMemory(Ptr(DWORD(PWideChar(Result))+DWORD(size-l)*2),PWideChar(tstr),l*2);
            end else if align<0 then begin
	            for i:=0 to size-l do Result[l+i+1]:=char;
    	        CopyMemory(PWideChar(Result),PWideChar(tstr),l*2);
            end else begin
            	sme:=(size-l) div 2; if ((size-l) and 1)<>0 then inc(sme);
	            for i:=0 to sme-1 do Result[i+1]:=char;
    	        CopyMemory(Ptr(DWORD(PWideChar(Result))+DWORD(sme)*2),PWideChar(tstr),l*2);
	            for i:=0 to size-l-sme do Result[l+sme+i+1]:=char;
            end;
        end else Result:=tstr;
end;

end.

