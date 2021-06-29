unit EC_BlockMem;

interface

uses Windows, Messages, Forms, MMSystem, SysUtils, Math, EC_Mem;

type
  PBlockMemUnitEC = ^TBlockMemUnitEC;

  TBlockMemUnitEC = record
    FPrev: PBlockMemUnitEC;
    FNext: PBlockMemUnitEC;

    FBuf: Pointer;
    FMaxSize: integer;
    FSize: integer;
  end;

  TBlockMemEC = class(TObject)
  public
    FFirst: PBlockMemUnitEC;
    FLast: PBlockMemUnitEC;

    FBlockSizeDefault: integer;
    FAllocClear: boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    property BlockSizeDefault: integer read FBlockSizeDefault write FBlockSizeDefault;
    property AllocClear: boolean read FAllocClear write FAllocClear;

    function BlockAdd: PBlockMemUnitEC;
    procedure BlockDel(el: PBlockMemUnitEC);

    function Alloc(size: integer): Pointer;
    procedure FreeFast(pos: DWORD; size: integer);
  end;

implementation

constructor TBlockMemEC.Create;
begin
  inherited Create;

  FBlockSizeDefault := 10 * 1024;
  FAllocClear := false;
end;

destructor TBlockMemEC.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TBlockMemEC.Clear;
begin
  while FFirst <> nil do
    BlockDel(FLast);
end;

function TBlockMemEC.BlockAdd: PBlockMemUnitEC;
var
  el: PBlockMemUnitEC;
begin
  el := AllocClearEC(sizeof(TBlockMemUnitEC));

  if FLast <> nil then
    FLast.FNext := el;
  el.FPrev := FLast;
  el.FNext := nil;
  FLast := el;
  if FFirst = nil then
    FFirst := el;

  result := el;
end;

procedure TBlockMemEC.BlockDel(el: PBlockMemUnitEC);
begin
  if el.FPrev <> nil then
    el.FPrev.FNext := el.FNext;
  if el.FNext <> nil then
    el.FNext.FPrev := el.FPrev;
  if FLast = el then
    FLast := el.FPrev;
  if FFirst = el then
    FFirst := el.FNext;

  if el.FBuf <> nil then
  begin
    FreeEC(el.FBuf);
    el.FBuf := nil;
  end;

  FreeEC(el);
end;

function TBlockMemEC.Alloc(size: integer): Pointer;
begin
  if (FLast = nil) or (size > (FLast.FMaxSize - FLast.FSize)) then
  begin
    BlockAdd();
    if size <= (FBlockSizeDefault shr 1) then
      FLast.FMaxSize := FBlockSizeDefault
    else
      FLast.FMaxSize := size;
    if FAllocClear then
      FLast.FBuf := AllocClearEC(FLast.FMaxSize)
    else
      FLast.FBuf := AllocEC(FLast.FMaxSize);
  end;
  result := Ptr(DWORD(FLast.FBuf) + DWORD(FLast.FSize));
  FLast.FSize := FLast.FSize + size;
end;

procedure TBlockMemEC.FreeFast(pos: DWORD; size: integer);
var
  el: PBlockMemUnitEC;
begin
  el := PBlockMemUnitEC(pos);
  el.FSize := el.FSize - size;
  if el.FSize <= 0 then
    BlockDel(el);
end;

end.