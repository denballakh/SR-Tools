unit DebugMsg;

interface

uses Windows;

procedure DMcc(group: PChar; Text: PChar); cdecl; external 'DebugMsg.dll' Name 'DMcc';
procedure DMcc_(group: PChar; Text: PChar); cdecl; external 'DebugMsg.dll' Name 'DMcc_';
procedure DMww(group: PWideChar; Text: PWideChar); cdecl; external 'DebugMsg.dll' Name 'DMww';
procedure DMww_(group: PWideChar; Text: PWideChar); cdecl; external 'DebugMsg.dll' Name 'DMww_';

function DCGet(scom: PWideChar): DWORD; cdecl; external 'DebugMsg.dll' Name 'DCGet';
procedure DCFree(com: DWORD); cdecl; external 'DebugMsg.dll' Name 'DCFree';
function DCNameW(com: DWORD): PWideChar; cdecl; external 'DebugMsg.dll' Name 'DCNameW';
function DCNameA(com: DWORD): PChar; cdecl; external 'DebugMsg.dll' Name 'DCNameA';
function DCNameI(com: DWORD): integer; cdecl; external 'DebugMsg.dll' Name 'DCNameI';
function DCCnt(com: DWORD): integer; cdecl; external 'DebugMsg.dll' Name 'DCCnt';
function DCStrW(com: DWORD): PWideChar; cdecl; external 'DebugMsg.dll' Name 'DCStrW';
function DCStrA(com: DWORD): PChar; cdecl; external 'DebugMsg.dll' Name 'DCStrA';
function DCInt(com: DWORD): integer; cdecl; external 'DebugMsg.dll' Name 'DCInt';
function DCFloat(com: DWORD): double; cdecl; external 'DebugMsg.dll' Name 'DCFloat';
procedure DCAnswerW(com: DWORD; str: PWideChar); cdecl; external 'DebugMsg.dll' Name 'DCAnswerW';
procedure DCAnswerA(com: DWORD; str: PChar); cdecl; external 'DebugMsg.dll' Name 'DCAnswerA';

procedure DM(group: ansistring; Text: ansistring); overload;
procedure DM_(group: ansistring; Text: ansistring); overload;
procedure DM(group: WideString; Text: WideString); overload;
procedure DM_(group: WideString; Text: WideString); overload;

procedure DCAnswer(com: DWORD; str: ansistring); overload;
procedure DCAnswer(com: DWORD; str: WideString); overload;

function DMF(tstr: WideString; size: integer; align: integer = 1; char: widechar = ' '): WideString;

implementation

procedure DM(group: ansistring; Text: ansistring);
begin
  DMcc(PChar(group), PChar(Text));
end;

procedure DM_(group: ansistring; Text: ansistring);
begin
  DMcc_(PChar(group), PChar(Text));
end;

procedure DM(group: WideString; Text: WideString);
begin
  DMww(PWideChar(group), PWideChar(Text));
end;

procedure DM_(group: WideString; Text: WideString);
begin
  DMww_(PWideChar(group), PWideChar(Text));
end;

procedure DCAnswer(com: DWORD; str: ansistring);
begin
  DCAnswerA(com, PChar(str));
end;

procedure DCAnswer(com: DWORD; str: WideString);
begin
  DCAnswerW(com, PWideChar(str));
end;

function DMF(tstr: WideString; size: integer; align: integer = 1; char: widechar = ' '): WideString;
var
  l, i, sme: integer;
begin
  l := Length(tstr);
  if l > size then
    result := Copy(tstr, 1, size - 1) + '~'
  else if l < size then
  begin
    SetLength(result, size);
    if align > 0 then
    begin
      for i := 0 to size - l do
        result[i + 1] := char;
      CopyMemory(Ptr(DWORD(PWideChar(result)) + DWORD(size - l) * 2), PWideChar(tstr), l * 2);
    end
    else if align < 0 then
    begin
      for i := 0 to size - l do
        result[l + i + 1] := char;
      CopyMemory(PWideChar(result), PWideChar(tstr), l * 2);
    end
    else
    begin
      sme := (size - l) div 2;
      if ((size - l) and 1) <> 0 then
        Inc(sme);
      for i := 0 to sme - 1 do
        result[i + 1] := char;
      CopyMemory(Ptr(DWORD(PWideChar(result)) + DWORD(sme) * 2), PWideChar(tstr), l * 2);
      for i := 0 to size - l - sme do
        result[l + sme + i + 1] := char;
    end;
  end
  else
    result := tstr;
end;

end.