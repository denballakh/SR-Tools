unit EC_BlockPar;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, EC_Str, EC_File, EC_Buf;

type
  TBlockParEC = class;

  TBlockParElEC = class(TObject)
  public
    m_Prev: TBlockParElEC;
    m_Next: TBlockParElEC;
    m_Parent: TBlockParEC;

    m_Tip: DWORD; // 0-пусто 1-параметр 2-блок
    m_Name: WideString;
    m_Zn: WideString;
    m_Com: WideString;
    m_Block: TBlockParEC;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure CreateBlock;

    procedure CopyFrom(bp: TBlockParElEC);
  end;

  TBlockParEC = class(TObject)
  protected
    m_First: TBlockParElEC;
    m_Last: TBlockParElEC;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure CopyFrom(bp: TBlockParEC);

  protected
    function El_Add: TBlockParElEC;
    procedure El_Del(el: TBlockParElEC);
    function El_Get(path: WideString): TBlockParElEC;
  public

    procedure ParPath_Add(path, zn: WideString);
    procedure ParPath_Set(path, zn: WideString);
    procedure ParPath_SetAdd(path, zn: WideString);
    procedure ParPath_Delete(path: WideString);
    function ParPath_Get(path: WideString): WideString;
    function ParPath_Count(path: WideString): integer;
    property ParPath[path: WideString]: WideString read ParPath_Get write ParPath_SetAdd;

    function Par_Add(Name, zn: WideString): TBlockParElEC;
    procedure Par_Set(Name, zn: WideString);
    procedure Par_SetAdd(Name, zn: WideString);
    procedure Par_Delete(Name: WideString); overload;
    procedure Par_Delete(no: integer); overload;
    function Par_Get(Name: WideString): WideString; overload;
    function Par_GetNE(Name: WideString): WideString;
    property Par[Name: WideString]: WideString read Par_Get write Par_SetAdd;
    property ParNE[Name: WideString]: WideString read Par_GetNE write Par_SetAdd;

    function Par_Count: integer; overload;
    function Par_Count(Name: WideString): integer; overload;
    function Par_Get(no: integer): WideString; overload;
    function Par_GetName(no: integer): WideString;
    procedure Par_SetName(no: integer; tstr: WideString); overload;
    procedure Par_SetName(oldname, tstr: WideString); overload;

    function BlockPath_Add(path: WideString): TBlockParEC;
    function BlockPath_Get(path: WideString): TBlockParEC;
    function BlockPath_GetAdd(path: WideString): TBlockParEC;
    property BlockPath[path: WideString]: TBlockParEC read BlockPath_Get;

    function Block_Add(Name: WideString): TBlockParEC;
    function Block_Get(Name: WideString): TBlockParEC; overload;
    function Block_GetNE(Name: WideString): TBlockParEC; overload;
    function Block_GetAdd(Name: WideString): TBlockParEC;
    property Block[Name: WideString]: TBlockParEC read Block_Get;

    function Block_Count: integer; overload;
    function Block_Count(Name: WideString): integer; overload;
    function Block_Get(no: integer): TBlockParEC; overload;
    function Block_GetName(no: integer): WideString;
    procedure Block_SetName(no: integer; tstr: WideString);
    procedure Block_Delete(Name: WideString); overload;
    procedure Block_Delete(no: integer); overload;

    function All_Count: integer;
    function All_GetTip(no: integer): integer; // 0 - пусто   1 - Par     2 - Block
    function All_GetBlock(no: integer): TBlockParEC;
    function All_GetPar(no: integer): WideString;
    function All_GetName(no: integer): WideString;

  private
    procedure SaveInBuf_r(tbuf: TBufEC; level: integer = 0);
  private
    procedure SaveInBufAnsi_r(tbuf: TBufEC; level: integer = 0);
  public
    procedure SaveInBuf(tbuf: TBufEC; fansi: boolean = false);
    procedure SaveInFile(filename: PChar; fansi: boolean = false);

  private
    procedure LoadFromBuf_r(tbuf: TBufEC; predstr: WideString; fa: boolean = false; fcom: boolean = true);
  public
    procedure LoadFromBuf(tbuf: TBufEC; fcom: boolean = false);
    procedure LoadFromFile(filename: PChar; fcom: boolean = false);
  end;

implementation

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TBlockParElEC.Create;
begin
  inherited Create;
end;

destructor TBlockParElEC.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TBlockParElEC.Clear;
begin
  if m_Block <> nil then
  begin
    m_Block.Free;
    m_Block := nil;
  end;
  m_Tip := 0;
  m_Name := '';
  m_Zn := '';
  m_Com := '';
end;

procedure TBlockParElEC.CreateBlock;
begin
  if m_Block <> nil then
  begin
    m_Block.Free;
    m_Block := nil;
  end;
  m_Block := TBlockParEC.Create;
  m_Tip := 2;
  m_Zn := '';
end;

procedure TBlockParElEC.CopyFrom(bp: TBlockParElEC);
begin
  Clear;

  m_Tip := bp.m_Tip;
  m_Name := bp.m_Name;
  m_Zn := bp.m_Zn;
  m_Com := bp.m_Com;
  m_Block := nil;
  if bp.m_Block <> nil then
  begin
    m_Block := TBlockParEC.Create;
    m_Block.CopyFrom(bp.m_Block);
  end;
end;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
constructor TBlockParEC.Create;
begin
  inherited Create;
end;

destructor TBlockParEC.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TBlockParEC.Clear;
var
  t, tt: TBlockParElEC;
begin
  t := m_First;
  while t <> nil do
  begin
    tt := t;
    t := t.m_Next;
    tt.Free;
  end;
  m_First := nil;
  m_Last := nil;
end;

procedure TBlockParEC.CopyFrom(bp: TBlockParEC);
var
  el: TBlockParElEC;
begin
  Clear;
  el := bp.m_First;
  while el <> nil do
  begin
    El_Add.CopyFrom(el);
    el := el.m_Next;
  end;
end;

{var
    bd:TBufEC;
begin
    Clear;
    bd:=TBufEC.Create;
    bp.SaveInBuf(bd);
    bd.Pointer:=0;
    LoadFromBuf(bd);
    bd.Free;
end;}

function TBlockParEC.El_Add: TBlockParElEC;
var
  el: TBlockParElEC;
begin
  el := TBlockParElEC.Create;

  el.m_Parent := Self;

  if m_Last <> nil then
    m_Last.m_Next := el;
  el.m_Prev := m_Last;
  el.m_Next := nil;
  m_Last := el;
  if m_First = nil then
    m_First := el;

  result := el;
end;

procedure TBlockParEC.El_Del(el: TBlockParElEC);
begin
  if el.m_Prev <> nil then
    el.m_Prev.m_Next := el.m_Next;
  if el.m_Next <> nil then
    el.m_Next.m_Prev := el.m_Prev;
  if m_Last = el then
    m_Last := el.m_Prev;
  if m_First = el then
    m_First := el.m_Next;

  el.Free;
end;

function TBlockParEC.El_Get(path: WideString): TBlockParElEC;
var
  countraz: integer;
  i, u, no: integer;
  Name: WideString;
  ne: TBlockParElEC;
  us: TBlockParEC;
begin
  countraz := GetCountParEC(path, './\');
  if countraz < 1 then
    raise Exception.Create('GetEl. Path=' + path);
  us := Self;
  ne := nil;
  for i := 0 to countraz - 1 do
  begin
    Name := TrimEx(GetStrParEC(path, i, './\'));
    if GetCountParEC(Name, ':') > 1 then
    begin
      no := StrToInt(GetStrParEC(Name, 1, ':'));
      Name := TrimEx(GetStrParEC(Name, 0, ':'));
    end
    else
      no := 0;
    ne := us.m_First;
    u := 0;
    while (u <= no) and (ne <> nil) do
    begin
      while ne <> nil do
      begin
        if ne.m_Name = Name then
        begin
          if u < no then
            ne := ne.m_Next;
          break;
        end;
        ne := ne.m_Next;
      end;
      Inc(u);
    end;
    if ne = nil then
      raise Exception.Create('GetEl. Path=' + path);
    if i = countraz - 1 then
      break;
    if ne.m_Tip <> 2 then
      raise Exception.Create('GetEl. Path=' + path);
    us := ne.m_Block;
  end;
  result := ne;
end;

procedure TBlockParEC.ParPath_Add(path, zn: WideString);
var
  countep: integer;
  Name: WideString;
  el: TBlockParElEC;
  cd: TBlockParEC;
begin
  countep := GetCountParEC(path, './\');
  if countep > 1 then
  begin
    cd := BlockPath_GetAdd(GetStrParEC(path, 0, countep - 2, './\'));
    Name := GetStrParEC(path, countep - 1, './\');
  end
  else
  begin
    Name := path;
    cd := Self;
  end;
  el := cd.El_Add;
  el.m_Tip := 1;
  el.m_Name := Name;
  el.m_Zn := zn;
end;

procedure TBlockParEC.ParPath_Set(path, zn: WideString);
var
  te: TBlockParElEC;
begin
  te := El_Get(path);
  if te.m_Tip <> 1 then
    raise Exception.Create('Par_Set. Path=' + path + ' zn=' + zn);
  te.m_Zn := zn;
end;

procedure TBlockParEC.ParPath_SetAdd(path, zn: WideString);
var
  te: TBlockParElEC;
begin
  try
    te := El_Get(path);
    if te.m_Tip <> 1 then
      raise Exception.Create('Par_SetAdd. Path=' + path + ' zn=' + zn);
    te.m_Zn := zn;
  except
    on E: Exception do
    begin
      ParPath_Add(path, zn);
    end;
  end;
end;

procedure TBlockParEC.ParPath_Delete(path: WideString);
var
  te: TBlockParElEC;
begin
  te := El_Get(path);
  if te.m_Tip <> 1 then
    raise Exception.Create('Par_Delete. Path=' + path);
  te.m_Parent.El_Del(te);
end;

function TBlockParEC.ParPath_Get(path: WideString): WideString;
var
  te: TBlockParElEC;
begin
  te := El_Get(path);
  if te.m_Tip <> 1 then
    raise Exception.Create('Par_Get. Path=' + path);
  result := te.m_Zn;
end;

function TBlockParEC.ParPath_Count(path: WideString): integer;
var
  countep: integer;
  Name: WideString;
  cd: TBlockParEC;
begin
  countep := GetCountParEC(path, './\');
  if countep > 1 then
  begin
    cd := BlockPath_GetAdd(GetStrParEC(path, 0, countep - 2, './\'));
    Name := GetStrParEC(path, countep - 1, './\');
  end
  else
  begin
    Name := path;
    cd := Self;
  end;
  result := cd.Par_Count(Name);
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Par_Add(Name, zn: WideString): TBlockParElEC;
var
  el: TBlockParElEC;
begin
  el := El_Add;
  el.m_Tip := 1;
  el.m_Name := Name;
  el.m_Zn := zn;
  result := el;
end;

procedure TBlockParEC.Par_Set(Name, zn: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 1) then
    begin
      el.m_Zn := zn;
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. name=' + Name);
end;

procedure TBlockParEC.Par_SetAdd(Name, zn: WideString);
begin
  try
    Par_Set(Name, zn);
  except
    on E: Exception do
    begin
      Par_Add(Name, zn);
    end;
  end;
end;

procedure TBlockParEC.Par_Delete(Name: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 1) then
    begin
      El_Del(el);
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. name=' + Name);
end;

procedure TBlockParEC.Par_Delete(no: integer);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 1) then
    begin
      if no = 0 then
      begin
        El_Del(el);
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Par_Get. no=' + IntToStr(no));
end;

procedure TBlockParEC.Block_Delete(Name: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 2) then
    begin
      El_Del(el);
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. name=' + Name);
end;

procedure TBlockParEC.Block_Delete(no: integer);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 2) then
    begin
      if no = 0 then
      begin
        El_Del(el);
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. no=' + IntToStr(no));
end;

function TBlockParEC.Par_Get(Name: WideString): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 1) then
    begin
      result := el.m_Zn;
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. name=' + Name);
end;

function TBlockParEC.Par_GetNE(Name: WideString): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 1) then
    begin
      result := el.m_Zn;
      exit;
    end;
    el := el.m_Next;
  end;
  result := '';
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Par_Count: integer;
var
  el: TBlockParElEC;
  Count: integer;
begin
  el := m_First;
  Count := 0;
  while el <> nil do
  begin
    if (el.m_Tip = 1) then
      Inc(Count);
    el := el.m_Next;
  end;
  result := Count;
end;

function TBlockParEC.Par_Count(Name: WideString): integer;
var
  el: TBlockParElEC;
  Count: integer;
begin
  el := m_First;
  Count := 0;
  while el <> nil do
  begin
    if (el.m_Tip = 1) and (el.m_Name = Name) then
      Inc(Count);
    el := el.m_Next;
  end;
  result := Count;
end;

function TBlockParEC.Par_Get(no: integer): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 1) then
    begin
      if no = 0 then
      begin
        result := el.m_Zn;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Par_Get. no=' + IntToStr(no));
end;

function TBlockParEC.Par_GetName(no: integer): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 1) then
    begin
      if no = 0 then
      begin
        result := el.m_Name;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Par_GetName. no=' + IntToStr(no));
end;

procedure TBlockParEC.Par_SetName(no: integer; tstr: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 1) then
    begin
      if no = 0 then
      begin
        el.m_Name := tstr;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Par_SetName. no=' + IntToStr(no));
end;

procedure TBlockParEC.Par_SetName(oldname, tstr: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = oldname) and (el.m_Tip = 1) then
    begin
      el.m_Name := tstr;
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_SetName. oldname=' + oldname);
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.BlockPath_Add(path: WideString): TBlockParEC;
var
  countep: integer;
  Name: WideString;
  el: TBlockParElEC;
  cd: TBlockParEC;
begin
  countep := GetCountParEC(path, './\');
  if countep > 1 then
  begin
    cd := BlockPath_GetAdd(GetStrParEC(path, 0, countep - 2, './\'));
    Name := GetStrParEC(path, countep - 1, './\');
  end
  else
  begin
    Name := path;
    cd := Self;
  end;
  el := cd.El_Add;
  el.CreateBlock;
  el.m_Name := Name;
  result := el.m_Block;
end;

function TBlockParEC.BlockPath_Get(path: WideString): TBlockParEC;
var
  te: TBlockParElEC;
begin
  te := El_Get(path);
  if te.m_Tip <> 2 then
    raise Exception.Create('TBlockParEC.BlockPath_Get. Path=' + path);
  result := te.m_Block;
end;

function TBlockParEC.BlockPath_GetAdd(path: WideString): TBlockParEC;
var
  te: TBlockParEC;
begin
  try
    te := BlockPath_Get(path);
    result := te;
  except
    on E: Exception do
    begin
      result := BlockPath_Add(path);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Block_Add(Name: WideString): TBlockParEC;
var
  el: TBlockParElEC;
begin
  el := El_Add;
  el.CreateBlock;
  el.m_Name := Name;
  result := el.m_Block;
end;

function TBlockParEC.Block_Get(Name: WideString): TBlockParEC;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 2) then
    begin
      result := el.m_Block;
      exit;
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. name=' + Name);
end;

function TBlockParEC.Block_GetNE(Name: WideString): TBlockParEC;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Name = Name) and (el.m_Tip = 2) then
    begin
      result := el.m_Block;
      exit;
    end;
    el := el.m_Next;
  end;
  result := nil;
end;

function TBlockParEC.Block_GetAdd(Name: WideString): TBlockParEC;
var
  te: TBlockParEC;
begin
  try
    te := Block_Get(Name);
    result := te;
  except
    on E: Exception do
    begin
      result := Block_Add(Name);
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.Block_Count: integer;
var
  el: TBlockParElEC;
  Count: integer;
begin
  el := m_First;
  Count := 0;
  while el <> nil do
  begin
    if (el.m_Tip = 2) then
      Inc(Count);
    el := el.m_Next;
  end;
  result := Count;
end;

function TBlockParEC.Block_Count(Name: WideString): integer;
var
  el: TBlockParElEC;
  Count: integer;
begin
  el := m_First;
  Count := 0;
  while el <> nil do
  begin
    if (el.m_Tip = 2) and (el.m_Name = Name) then
      Inc(Count);
    el := el.m_Next;
  end;
  result := Count;
end;

function TBlockParEC.Block_Get(no: integer): TBlockParEC;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 2) then
    begin
      if no = 0 then
      begin
        result := el.m_Block;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_Get. no=' + IntToStr(no));
end;

function TBlockParEC.Block_GetName(no: integer): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 2) then
    begin
      if no = 0 then
      begin
        result := el.m_Name;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_GetName. no=' + IntToStr(no));
end;

procedure TBlockParEC.Block_SetName(no: integer; tstr: WideString);
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if (el.m_Tip = 2) then
    begin
      if no = 0 then
      begin
        el.m_Name := tstr;
        exit;
      end;
      Dec(no);
    end;
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.Block_SetName. no=' + IntToStr(no));
end;

////////////////////////////////////////////////////////////////////////////////
function TBlockParEC.All_Count: integer;
var
  el: TBlockParElEC;
  Count: integer;
begin
  el := m_First;
  Count := 0;
  while el <> nil do
  begin
    Inc(Count);
    el := el.m_Next;
  end;
  result := Count;
end;

function TBlockParEC.All_GetTip(no: integer): integer;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if no = 0 then
    begin
      result := el.m_Tip;
      exit;
    end;
    Dec(no);
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.All_GetTip. no=' + IntToStr(no));
end;

function TBlockParEC.All_GetBlock(no: integer): TBlockParEC;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if no = 0 then
    begin
      if el.m_Tip <> 2 then
        raise Exception.Create('TBlockParEC.All_GetBlock. Error tip.');
      result := el.m_Block;
      exit;
    end;
    Dec(no);
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.All_GetBlock. no=' + IntToStr(no));
end;

function TBlockParEC.All_GetPar(no: integer): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if no = 0 then
    begin
      if el.m_Tip <> 1 then
        raise Exception.Create('TBlockParEC.All_GetPar. Error tip.');
      result := el.m_Zn;
      exit;
    end;
    Dec(no);
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.All_GetPar. no=' + IntToStr(no));
end;

function TBlockParEC.All_GetName(no: integer): WideString;
var
  el: TBlockParElEC;
begin
  el := m_First;
  while el <> nil do
  begin
    if no = 0 then
    begin
      if (el.m_Tip <> 1) and (el.m_Tip <> 2) then
        raise Exception.Create('TBlockParEC.All_GetName. Error tip.');
      result := el.m_Name;
      exit;
    end;
    Dec(no);
    el := el.m_Next;
  end;
  raise Exception.Create('TBlockParEC.All_GetName. no=' + IntToStr(no));
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlockParEC.SaveInBuf_r(tbuf: TBufEC; level: integer = 0);
var
  tt: TBlockParElEC;
  i: integer;
begin
  tt := m_First;
  while tt <> nil do
  begin
    if tt.m_Tip = 0 then
    begin
      if tt.m_Com <> '' then
        tbuf.AddN0(PWideChar(tt.m_Com));
      tbuf.Add(word($0d));
      tbuf.Add(word($0a));
    end
    else if tt.m_Tip = 1 then
    begin
      for i := 1 to level * 4 do
        tbuf.Add(word(32));
      tbuf.AddN0(PWideChar(tt.m_Name));
      tbuf.Add(word(61));
      tbuf.AddN0(PWideChar(tt.m_Zn));
      if tt.m_Com <> '' then
        tbuf.AddN0(PWideChar(tt.m_Com));
      tbuf.Add(word($0d));
      tbuf.Add(word($0a));
    end
    else
    begin
      for i := 1 to level * 4 do
        tbuf.Add(word(32));
      tbuf.AddN0(PWideChar(tt.m_Name));
      tbuf.Add(word(32));
      tbuf.Add(word(123));
      tbuf.Add(word($0d));
      tbuf.Add(word($0a));

      tt.m_Block.SaveInBuf_r(tbuf, level + 1);

      for i := 1 to level * 4 do
        tbuf.Add(word(32));
      tbuf.Add(word(125));
      if tt.m_Com <> '' then
        tbuf.AddN0(PWideChar(tt.m_Com));
      tbuf.Add(word($0d));
      tbuf.Add(word($0a));
    end;
    tt := tt.m_Next;
  end;
end;

procedure TBlockParEC.SaveInBufAnsi_r(tbuf: TBufEC; level: integer = 0);
var
  tt: TBlockParElEC;
  i: integer;
begin
  tt := m_First;
  while tt <> nil do
  begin
    if tt.m_Tip = 0 then
    begin
      if tt.m_Com <> '' then
        tbuf.AddN0(PAnsiChar(ansistring(tt.m_Com)));
      tbuf.Add(byte($0d));
      tbuf.Add(byte($0a));
    end
    else if tt.m_Tip = 1 then
    begin
      for i := 1 to level * 4 do
        tbuf.Add(byte(32));
      tbuf.AddN0(PAnsiChar(ansistring(tt.m_Name)));
      tbuf.Add(byte(61));
      tbuf.AddN0(PAnsiChar(ansistring(tt.m_Zn)));
      if tt.m_Com <> '' then
        tbuf.AddN0(PAnsiChar(ansistring(tt.m_Com)));
      tbuf.Add(byte($0d));
      tbuf.Add(byte($0a));
    end
    else
    begin
      for i := 1 to level * 4 do
        tbuf.Add(byte(32));
      tbuf.AddN0(PAnsiChar(ansistring(tt.m_Name)));
      tbuf.Add(byte(32));
      tbuf.Add(byte(123));
      tbuf.Add(byte($0d));
      tbuf.Add(byte($0a));

      tt.m_Block.SaveInBufAnsi_r(tbuf, level + 1);

      for i := 1 to level * 4 do
        tbuf.Add(byte(32));
      tbuf.Add(byte(125));
      if tt.m_Com <> '' then
        tbuf.AddN0(PAnsiChar(ansistring(tt.m_Com)));
      tbuf.Add(byte($0d));
      tbuf.Add(byte($0a));
    end;
    tt := tt.m_Next;
  end;
end;

procedure TBlockParEC.SaveInBuf(tbuf: TBufEC; fansi: boolean);
begin
  if not fansi then
  begin
    tbuf.Add(word($0FEFF));
    SaveInBuf_r(tbuf);
  end
  else
    SaveInBufAnsi_r(tbuf);
end;

procedure TBlockParEC.SaveInFile(filename: PChar; fansi: boolean);
var
  fa: TFileEC;
  tbuf: TBufEC;
begin
  fa := TFileEC.Create;
  tbuf := TBufEC.Create;
  try
    SaveInBuf(tbuf, fansi);
    fa.Init(filename);
    fa.CreateNew;
    fa.write(tbuf.Buf, tbuf.Len);
    fa.Close;
  finally
    fa.Free;
    tbuf.Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
procedure TBlockParEC.LoadFromBuf_r(tbuf: TBufEC; predstr: WideString; fa: boolean; fcom: boolean);
var
  tstr, tstr2, tstr3, com: WideString;
  tb: TBlockParEC;
  countpar: integer;
  tel: TBlockParElEC;
begin
  tstr := TrimEx(predstr);
  while (not tbuf.TestEnd) do
  begin
    if tstr = '' then
      if fa then
        tstr := TrimEx(tbuf.GetAnsiTextStr)
      else
        tstr := TrimEx(tbuf.GetWideTextStr);

    com := GetComEC(tstr);
    tstr := TrimEx(GetStrNoComEC(tstr));

    countpar := GetCountParEC(tstr, '{');
    if countpar > 1 then
    begin
      tstr2 := TrimEx(GetStrParEC(tstr, 0, '{'));
      if tstr2 = '' then
        raise Exception.Create('TBlockParEC.LoadFromBuf_r. tstr=' + tstr);

      tstr3 := '';
      if GetCountParEC(tstr2, '=') = 2 then
      begin
        tstr3 := TrimEx(GetStrParEC(tstr2, 1, '='));
        tstr2 := TrimEx(GetStrParEC(tstr2, 0, '='));
      end;

      tb := Block_Add(tstr2);
      tstr2 := TrimEx(GetStrParEC(tstr, 1, countpar - 1, '{'));
      tb.LoadFromBuf_r(tbuf, tstr2, fa, fcom);

      if tstr3 <> '' then
        tb.LoadFromFile(PChar(ansistring(tstr3))){if tstr3='cfg\Rus\Lang.txt' then begin
    if tstr3='cfg\Rus\Lang.txt' then begin end;
end;};
    end
    else
    begin
      if GetCountParEC(tstr, '}') > 1 then
        exit;
      countpar := GetCountParEC(tstr, '=');
      if countpar > 1 then
      begin
        tstr2 := TrimEx(GetStrParEC(tstr, 0, '='));
{if tstr2='Exit' then begin
    if tstr2='Exit' then begin end;
end;}
        tstr3 :={Trim}(GetStrParEC(tstr, 1, countpar - 1, '='));
        if fcom then
          Par_Add(tstr2, tstr3).m_Com := com
        else
          Par_Add(tstr2, tstr3);
      end
      else {if TrimEx(com)<>'' then} if fcom then
      begin
        tel := El_Add;
        tel.m_Tip := 0;
        tel.m_Com := com;
      end;
    end;
    tstr := '';
  end;
end;

procedure TBlockParEC.LoadFromBuf(tbuf: TBufEC; fcom: boolean = false);
begin
  if tbuf.Len - tbuf.BPointer > 2 then
    if tbuf.GetWORD <> $0feff then
    begin
      tbuf.BPointerSet(tbuf.BPointer - 2);
      LoadFromBuf_r(tbuf, WideString(''), true, fcom);
    end
    else
      LoadFromBuf_r(tbuf, WideString(''), false, fcom);
end;

procedure TBlockParEC.LoadFromFile(filename: PChar; fcom: boolean = false);
var
  tbuf: TBufEC;
begin
  tbuf := TBufEC.Create;
  try
    tbuf.LoadFromFile(filename);
    LoadFromBuf(tbuf, fcom);
  finally
    tbuf.Free;
  end;
end;

end.