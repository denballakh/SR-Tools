unit Form_Group;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids;

type
  TFormGroup = class(TForm)
    BitBtn1: TBitBtn;
    DGG: TDrawGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormShow(Sender: TObject);
    procedure DGGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DGGGetEditText(Sender: TObject; ACol, ARow: Integer;
      var Value: String);
    procedure DGGSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure DGGSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure DGGDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormGroup: TFormGroup;

implementation

uses ABKey,Global;

{$R *.dfm}

procedure TFormGroup.FormShow(Sender: TObject);
begin
	DGG.RowCount:=KeyGroup_Count;
	DGG.Row:=KeyGroup_Cur;
    DGG.Invalidate;
end;

procedure TFormGroup.DGGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
	tstr:WideString;
begin
    tstr:=TKeyGroup(KeyGroup_List.Items[ARow]).FName;
    if tstr='' then tstr:='unknown';

	SaveCanvasPar(DGG.Canvas);
    DGG.Canvas.Font.Style:=[];
	DrawRectText(DGG.Canvas,Rect,
    			 bsClear,0,
           	     psClear,0,0,1,
               	 -1,0,false,
	             tstr);
    LoadCanvasPar(DGG.Canvas);
end;

procedure TFormGroup.DGGGetEditText(Sender: TObject; ACol, ARow: Integer;
  var Value: String);
begin
	Value:=TKeyGroup(KeyGroup_List.Items[ARow]).FName;
end;

procedure TFormGroup.DGGSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
begin
	TKeyGroup(KeyGroup_List.Items[ARow]).FName:=Value;
end;

procedure TFormGroup.Button3Click(Sender: TObject);
begin
	KeyGroup_Insert(DGG.Row);
	DGG.RowCount:=KeyGroup_Count;
    DGG.Invalidate;
end;

procedure TFormGroup.Button4Click(Sender: TObject);
begin
	KeyGroup_Insert(KeyGroup_Count);
	DGG.RowCount:=KeyGroup_Count;
    KeyGroup_Cur:=KeyGroup_Count-1;
	DGG.Row:=KeyGroup_Cur;
    DGG.Invalidate;
end;

procedure TFormGroup.Button5Click(Sender: TObject);
begin
	KeyGroup_Delete(DGG.Row);
	DGG.RowCount:=KeyGroup_Count;
    DGG.Invalidate;
end;

procedure TFormGroup.DGGSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
	CanSelect:=true;
	KeyGroup_Cur:=ARow;
end;

procedure TFormGroup.Button1Click(Sender: TObject);
begin
	if DGG.Row>0 then begin
		KeyGroup_Swap(DGG.Row-1,DGG.Row);
    end;
    dec(KeyGroup_Cur);
	DGG.Row:=KeyGroup_Cur;
    DGG.Invalidate;
end;

procedure TFormGroup.Button2Click(Sender: TObject);
begin
	if DGG.Row<=(KeyGroup_Count-1) then begin
		KeyGroup_Swap(DGG.Row+1,DGG.Row);
    end;
    inc(KeyGroup_Cur);
	DGG.Row:=KeyGroup_Cur;
    DGG.Invalidate;
end;

procedure TFormGroup.DGGDblClick(Sender: TObject);
begin
	ModalResult:=mrOk;
end;

end.
