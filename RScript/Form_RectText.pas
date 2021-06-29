unit Form_RectText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, RxCombos;

type
  TFormRectText = class(TForm)
    PageControl1: TPageControl;
    BitBtnOK: TBitBtn;
    BitBtnCancel: TBitBtn;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    BitBtnDelete: TBitBtn;
    MemoText: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    ScrollBarBColorR: TScrollBar;
    ScrollBarBColorG: TScrollBar;
    ScrollBarBColorB: TScrollBar;
    ScrollBarFColorR: TScrollBar;
    ScrollBarFColorG: TScrollBar;
    ScrollBarFColorB: TScrollBar;
    Label3: TLabel;
    ComboBoxFStyle: TComboBox;
    Label4: TLabel;
    EditBSize: TEdit;
    Label5: TLabel;
    EditBCoeff: TEdit;
    ImageR: TImage;
    Label6: TLabel;
    ComboBoxBStyle: TComboBox;
    CheckBoxTAlignRect: TCheckBox;
    Label7: TLabel;
    ComboBoxTAlignX: TComboBox;
    Label8: TLabel;
    ComboBoxTAlignY: TComboBox;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    FontComboBoxTFont: TFontComboBox;
    Label10: TLabel;
    ScrollBarTColorR: TScrollBar;
    ScrollBarTColorG: TScrollBar;
    ScrollBarTColorB: TScrollBar;
    Label11: TLabel;
    ComboBoxTSize: TComboBox;
    CheckBoxTBold: TCheckBox;
    CheckBoxTItalic: TCheckBox;
    CheckBoxTUnderline: TCheckBox;
    procedure ReDraw(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    function GetFStyle:TBrushStyle;
    procedure SetFStyle(zn:TBrushStyle);

    function GetBStyle:TPenStyle;
    procedure SetBStyle(zn:TPenStyle);

    function GetTAlignX:integer;
    procedure SetTAlignX(zn:integer);

    function GetTAlignY:integer;
    procedure SetTAlignY(zn:integer);
end;

var
  FormRectText: TFormRectText;

implementation

uses GraphUnit,EC_Str,Form_Main;

{$R *.DFM}

procedure TFormRectText.FormShow(Sender: TObject);
begin
    with GCurGraphUnit as TGraphRectText do begin
        SetFStyle(FFStyle);
        ScrollBarFColorR.Position:=GetRValue(FFColor);
        ScrollBarFColorG.Position:=GetGValue(FFColor);
        ScrollBarFColorB.Position:=GetBValue(FFColor);
        SetBStyle(FBStyle);
        ScrollBarBColorR.Position:=GetRValue(FBColor);
        ScrollBarBColorG.Position:=GetGValue(FBColor);
        ScrollBarBColorB.Position:=GetBValue(FBColor);
        EditBSize.Text:=IntToStr(FBSize);
        EditBCoeff.Text:=FloatToStrEC(Round((FBCoef*100))/100);
        SetTAlignX(FTAlignX);
        SetTAlignY(FTAlignY);
        CheckBoxTAlignRect.Checked:=FTAlignRect;
        MemoText.Text:=FTText;
        ScrollBarTColorR.Position:=GetRValue(FTColor);
        ScrollBarTColorG.Position:=GetGValue(FTColor);
        ScrollBarTColorB.Position:=GetBValue(FTColor);
        FontComboBoxTFont.FontName:=FTFont;
        ComboBoxTSize.Text:=IntToStr(FTFontSize);
        CheckBoxTBold.Checked:=fsBold in FTFontStyle;
        CheckBoxTItalic.Checked:=fsItalic in FTFontStyle;
        CheckBoxTUnderline.Checked:=fsUnderline in FTFontStyle;
    end;

    ReDraw(nil);
end;

function TFormRectText.GetFStyle:TBrushStyle;
begin
    case ComboBoxFStyle.ItemIndex of
        0: Result:=bsSolid;
        1: Result:=bsClear;
        2: Result:=bsBDiagonal;
        3: Result:=bsFDiagonal;
        4: Result:=bsCross;
        5: Result:=bsDiagCross;
        6: Result:=bsHorizontal;
        7: Result:=bsVertical;
    else
        Result:=bsSolid;
    end;
end;

procedure TFormRectText.SetFStyle(zn:TBrushStyle);
begin
    case zn of
        bsSolid: ComboBoxFStyle.ItemIndex:=0;
        bsClear: ComboBoxFStyle.ItemIndex:=1;
        bsBDiagonal: ComboBoxFStyle.ItemIndex:=2;
        bsFDiagonal: ComboBoxFStyle.ItemIndex:=3;
        bsCross: ComboBoxFStyle.ItemIndex:=4;
        bsDiagCross: ComboBoxFStyle.ItemIndex:=5;
        bsHorizontal: ComboBoxFStyle.ItemIndex:=6;
        bsVertical: ComboBoxFStyle.ItemIndex:=7;
    end;
end;

function TFormRectText.GetBStyle:TPenStyle;
begin
    case ComboBoxBStyle.ItemIndex of
        0: Result:=psSolid;
        1: Result:=psClear;
        2: Result:=psDash;
        3: Result:=psDot;
        4: Result:=psDashDot;
        5: Result:=psDashDotDot;
    else
        Result:=psSolid;
    end;
end;

procedure TFormRectText.SetBStyle(zn:TPenStyle);
begin
    case zn of
        psSolid: ComboBoxBStyle.ItemIndex:=0;
        psClear: ComboBoxBStyle.ItemIndex:=1;
        psDash: ComboBoxBStyle.ItemIndex:=2;
        psDot: ComboBoxBStyle.ItemIndex:=3;
        psDashDot: ComboBoxBStyle.ItemIndex:=4;
        psDashDotDot: ComboBoxBStyle.ItemIndex:=5;
    end;
end;

function TFormRectText.GetTAlignX:integer;
begin
    if ComboBoxTAlignX.ItemIndex=0 then Result:=-1
    else if ComboBoxTAlignX.ItemIndex=1 then Result:=0
    else Result:=1;
end;

procedure TFormRectText.SetTAlignX(zn:integer);
begin
    ComboBoxTAlignX.ItemIndex:=zn+1;
end;

function TFormRectText.GetTAlignY:integer;
begin
    if ComboBoxTAlignY.ItemIndex=0 then Result:=-1
    else if ComboBoxTAlignY.ItemIndex=1 then Result:=0
    else Result:=1;
end;

procedure TFormRectText.SetTAlignY(zn:integer);
begin
    ComboBoxTAlignY.ItemIndex:=zn+1;
end;

procedure TFormRectText.ReDraw(Sender: TObject);
begin
    ImageR.Canvas.Pen.Color:=RGB(0,0,0);
    ImageR.Canvas.Brush.Color:=RGB(0,0,0);
    ImageR.Canvas.Brush.Style:=bsSolid;
    ImageR.Canvas.Rectangle(0,0,ImageR.Width,ImageR.Height);

    ImageR.Canvas.Font.Color:=RGB(ScrollBarTColorR.Position,ScrollBarTColorG.Position,ScrollBarTColorB.Position);
    ImageR.Canvas.Font.Name:=FontComboBoxTFont.FontName;
    ImageR.Canvas.Font.Size:=StrToIntEC(ComboBoxTSize.Text);
    ImageR.Canvas.Font.Style:=[];
    if CheckBoxTBold.Checked then ImageR.Canvas.Font.Style:=ImageR.Canvas.Font.Style+[fsBold];
    if CheckBoxTItalic.Checked then ImageR.Canvas.Font.Style:=ImageR.Canvas.Font.Style+[fsItalic];
    if CheckBoxTUnderline.Checked then ImageR.Canvas.Font.Style:=ImageR.Canvas.Font.Style+[fsUnderline];

    DrawRectText(ImageR.Canvas,
                 Rect(10,10,ImageR.Width-10,ImageR.Height-10),
                 GetFStyle,
                 RGB(ScrollBarFColorR.Position,ScrollBarFColorG.Position,ScrollBarFColorB.Position),
                 GetBStyle,
                 RGB(ScrollBarBColorR.Position,ScrollBarBColorG.Position,ScrollBarBColorB.Position),
                 StrToIntEC(EditBSize.Text),
                 StrToFloatEC(EditBCoeff.Text),
                 GetTAlignX,
                 GetTAlignY,
                 CheckBoxTAlignRect.Checked,
                 MemoText.Text
                );
end;

procedure TFormRectText.BitBtnOKClick(Sender: TObject);
begin
    with GCurGraphUnit as TGraphRectText do begin
        FFStyle:=GetFStyle;
        FFColor:=RGB(ScrollBarFColorR.Position,ScrollBarFColorG.Position,ScrollBarFColorB.Position);
        FBStyle:=GetBStyle;
        FBColor:=RGB(ScrollBarBColorR.Position,ScrollBarBColorG.Position,ScrollBarBColorB.Position);
        FBSize:=StrToIntEC(EditBSize.Text);
        FBCoef:=StrToFloatEC(EditBCoeff.Text);
        FTAlignX:=GetTAlignX;
        FTAlignY:=GetTAlignY;
        FTAlignRect:=CheckBoxTAlignRect.Checked;
        FTText:=MemoText.Text;
        FTColor:=RGB(ScrollBarTColorR.Position,ScrollBarTColorG.Position,ScrollBarTColorB.Position);
        FTFont:=FontComboBoxTFont.FontName;
        FTFontSize:=StrToIntEC(ComboBoxTSize.Text);

        FTFontStyle:=[];
        if CheckBoxTBold.Checked then FTFontStyle:=FTFontStyle+[fsBold];
        if CheckBoxTItalic.Checked then FTFontStyle:=FTFontStyle+[fsItalic];
        if CheckBoxTUnderline.Checked then FTFontStyle:=FTFontStyle+[fsUnderline];
    end;
end;

end.

