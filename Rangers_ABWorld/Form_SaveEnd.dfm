object FormSaveEnd: TFormSaveEnd
  Left = 557
  Top = 140
  BorderStyle = bsDialog
  Caption = 'Save End'
  ClientHeight = 305
  ClientWidth = 381
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 304
    Top = 216
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 304
    Top = 200
    Width = 41
    Height = 13
    Caption = 'Opt size:'
  end
  object BitBtn1: TBitBtn
    Left = 304
    Top = 272
    Width = 73
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object DGL: TDrawGrid
    Left = 8
    Top = 8
    Width = 289
    Height = 289
    ColCount = 3
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    OnDrawCell = DGLDrawCell
    OnGetEditText = DGLGetEditText
    OnSelectCell = DGLSelectCell
    OnSetEditText = DGLSetEditText
    ColWidths = (
      156
      48
      56)
  end
  object BitBtnAdd: TBitBtn
    Left = 304
    Top = 8
    Width = 73
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = BitBtnAddClick
  end
  object BitBtnDelete: TBitBtn
    Left = 304
    Top = 32
    Width = 73
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = BitBtnDeleteClick
  end
  object BitBtnSave: TBitBtn
    Left = 304
    Top = 56
    Width = 73
    Height = 25
    Caption = 'Save'
    TabOrder = 4
    OnClick = BitBtnSaveClick
  end
  object BitBtnSaveTest: TBitBtn
    Left = 304
    Top = 80
    Width = 73
    Height = 25
    Caption = 'Save test'
    TabOrder = 5
    OnClick = BitBtnSaveTestClick
  end
end
