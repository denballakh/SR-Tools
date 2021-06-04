object FormKey: TFormKey
  Left = 632
  Top = 152
  BorderStyle = bsDialog
  Caption = 'Key'
  ClientHeight = 239
  ClientWidth = 361
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BitBtn1: TBitBtn
    Left = 280
    Top = 208
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
  object DGG: TDrawGrid
    Left = 8
    Top = 8
    Width = 265
    Height = 225
    ColCount = 1
    DefaultColWidth = 240
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 1
    OnDblClick = DGGDblClick
    OnDrawCell = DGGDrawCell
    OnGetEditText = DGGGetEditText
    OnSelectCell = DGGSelectCell
    OnSetEditText = DGGSetEditText
  end
  object Button3: TButton
    Left = 280
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Insert'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 280
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 280
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button1: TButton
    Left = 280
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Up'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Down'
    TabOrder = 6
    OnClick = Button2Click
  end
end
