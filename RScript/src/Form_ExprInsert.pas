unit Form_ExprInsert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ComCtrls, StdCtrls, Buttons;

type
  TFormExprInsert = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StringGridFun: TStringGrid;
    ListBoxStar: TListBox;
    TabSheet3: TTabSheet;
    TabSheet6: TTabSheet;
    ListBoxPlanet: TListBox;
    ListBoxPlace: TListBox;
    ListBoxItem: TListBox;
    ListBoxGroup: TListBox;
    TabSheet7: TTabSheet;
    ListBoxVar: TListBox;
    TabSheet8: TTabSheet;
    ListBoxDialog: TListBox;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure StringGridFunDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTypeFun:integer;
    FResult:WideString;
  end;

var
  FormExprInsert: TFormExprInsert;

implementation

{$R *.DFM}

uses main,GraphUnit,Form_Group,Form_Place,Form_Item,Form_Planet,
     Form_Star,Form_Var,Form_Dialog,EC_Str;

procedure TFormExprInsert.FormShow(Sender: TObject);
var
    i,cnt:integer;
    gp:TGraphPoint;
begin
    FResult:='';

    StringGridFun.Cells[0,0]:='Result';
    StringGridFun.Cells[1,0]:='Function';
    StringGridFun.Cells[2,0]:='Description';

    cnt:=0;
    for i:=0 to High(GFun) do begin
        if (GFun[i].FType and FTypeFun)<>0 then inc(cnt);
    end;

    StringGridFun.RowCount:=cnt+1;

    cnt:=0;
    for i:=0 to High(GFun) do begin
        if (GFun[i].FType and FTypeFun)<>0 then begin
            StringGridFun.Cells[0,cnt+1]:=GFun[i].FResult;
            StringGridFun.Cells[1,cnt+1]:=GFun[i].FName+'('+GFun[i].FArg+')';
            StringGridFun.Cells[2,cnt+1]:=GFun[i].FDesc;
            inc(cnt);
        end;
    end;

    ListBoxStar.Clear;
    ListBoxPlanet.Clear;
    ListBoxPlace.Clear;
    ListBoxItem.Clear;
    ListBoxGroup.Clear;
    ListBoxVar.Clear;
    ListBoxDialog.Clear;
    for i:=0 to GGraphPoint.Count-1 do begin
        gp:=GGraphPoint.Items[i];
        if gp is TStar then ListBoxStar.Items.Add(gp.FText);
        if gp is TPlanet then ListBoxPlanet.Items.Add(gp.FText);
        if gp is TPlace then ListBoxPlace.Items.Add(gp.FText);
        if gp is TItem then ListBoxItem.Items.Add(gp.FText);
        if gp is TGroup then ListBoxGroup.Items.Add(gp.FText);
        if gp is TVar then ListBoxVar.Items.Add(gp.FText);
        if gp is TDialog then ListBoxDialog.Items.Add(gp.FText);
    end;
    ListBoxStar.ItemIndex:=0;
    ListBoxPlanet.ItemIndex:=0;
    ListBoxPlace.ItemIndex:=0;
    ListBoxItem.ItemIndex:=0;
    ListBoxGroup.ItemIndex:=0;
    ListBoxVar.ItemIndex:=0;
    ListBoxDialog.ItemIndex:=0;
end;

procedure TFormExprInsert.BitBtn1Click(Sender: TObject);
var
    i:integer;
begin
    if PageControl1.ActivePageIndex=0 then begin
        i:=StringGridFun.Row-1;
        FResult:=StringGridFun.Cells[1,i+1];//GFun[i].FName+'('+GFun[i].FArg+')';
        if FindSubstringEC(FResult,'EndState')>=0 then FResult:='EndState'; 
    end else if PageControl1.ActivePageIndex=1 then begin
        FResult:=ListBoxStar.Items[ListBoxStar.ItemIndex];
    end else if PageControl1.ActivePageIndex=2 then begin
        FResult:=ListBoxPlanet.Items[ListBoxPlanet.ItemIndex];
    end else if PageControl1.ActivePageIndex=3 then begin
        FResult:=ListBoxPlace.Items[ListBoxPlace.ItemIndex];
    end else if PageControl1.ActivePageIndex=4 then begin
        FResult:=ListBoxItem.Items[ListBoxItem.ItemIndex];
    end else if PageControl1.ActivePageIndex=5 then begin
        FResult:=ListBoxGroup.Items[ListBoxGroup.ItemIndex];
    end else if PageControl1.ActivePageIndex=6 then begin
        FResult:=ListBoxVar.Items[ListBoxVar.ItemIndex];
    end else if PageControl1.ActivePageIndex=7 then begin
        FResult:=ListBoxDialog.Items[ListBoxDialog.ItemIndex];
    end;
    ModalResult:=mrOk;
end;

procedure TFormExprInsert.StringGridFunDblClick(Sender: TObject);
begin
    BitBtn1Click(sender);
end;

end.
