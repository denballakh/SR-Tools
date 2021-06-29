unit Form_Key;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ABKey;

type
  TFormKey = class(TForm)
    BitBtn1: TBitBtn;
    DGG: TDrawGrid;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure DGGDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
    procedure DGGGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
    procedure DGGSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
    procedure DGGSelectCell(Sender: TObject; ACol, ARow: integer; var CanSelect: boolean);
    procedure DGGDblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FKey: TKeyAB;
  end;

var
  FormKey: TFormKey;

implementation

uses Global, EC_Str;

{$R *.dfm}

procedure TFormKey.FormShow(Sender: TObject);
begin
  DGG.RowCount := FKey.FCount;
  DGG.Row := FKey.FCur;
  DGG.Invalidate;
end;

procedure TFormKey.DGGDrawCell(Sender: TObject; ACol, ARow: integer; Rect: TRect; State: TGridDrawState);
var
  tstr: WideString;
begin
  tstr := IntToStr(FKey.FUnitT[ARow]);

  SaveCanvasPar(DGG.Canvas);
  DGG.Canvas.Font.Style := [];
  DrawRectText(DGG.Canvas, Rect,
    bsClear, 0,
    psClear, 0, 0, 1, -1, 0, false,
    tstr);
  LoadCanvasPar(DGG.Canvas);
end;

procedure TFormKey.DGGGetEditText(Sender: TObject; ACol, ARow: integer; var Value: string);
begin
  Value := IntToStr(FKey.FUnitT[ARow]);
end;

procedure TFormKey.DGGSetEditText(Sender: TObject; ACol, ARow: integer; const Value: string);
begin
  FKey.FUnitT[ARow] := StrToIntEC(Value);
end;

procedure TFormKey.DGGSelectCell(Sender: TObject; ACol, ARow: integer; var CanSelect: boolean);
begin
  CanSelect := true;
  FKey.FCur := ARow;
end;

procedure TFormKey.DGGDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormKey.Button3Click(Sender: TObject);
begin
  FKey.KeyInsert(DGG.Row);
  DGG.RowCount := FKey.FCount;
  DGG.Invalidate;
end;

procedure TFormKey.Button4Click(Sender: TObject);
begin
  FKey.KeyInsert(FKey.FCount);
  DGG.RowCount := FKey.FCount;
  FKey.FCur := FKey.FCount - 1;
  DGG.Row := FKey.FCur;
  DGG.Invalidate;
end;

procedure TFormKey.Button5Click(Sender: TObject);
begin
  if FKey.FCount <= 1 then
    exit;
  FKey.KeyDelete(DGG.Row);
  DGG.RowCount := FKey.FCount;//FKey.FCur;
  DGG.Invalidate;
end;

procedure TFormKey.Button1Click(Sender: TObject);
begin
  if DGG.Row > 0 then
    FKey.KeySwap(DGG.Row - 1, DGG.Row);
  Dec(FKey.FCur);
  DGG.Row := FKey.FCur;
  DGG.Invalidate;
end;

procedure TFormKey.Button2Click(Sender: TObject);
begin
  if DGG.Row <= (FKey.FCount - 1) then
    FKey.KeySwap(DGG.Row + 1, DGG.Row);
  Inc(FKey.FCur);
  DGG.Row := FKey.FCur;
  DGG.Invalidate;
end;

end.