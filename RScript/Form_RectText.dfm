object FormRectText: TFormRectText
  Left = 331
  Top = 278
  BorderStyle = bsDialog
  Caption = 'RectText'
  ClientHeight = 401
  ClientWidth = 449
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
  object ImageR: TImage
    Left = 8
    Top = 8
    Width = 433
    Height = 121
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 136
    Width = 433
    Height = 225
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Frame'
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 44
        Height = 13
        Caption = 'Fill color :'
      end
      object Label2: TLabel
        Left = 8
        Top = 106
        Width = 63
        Height = 13
        Caption = 'Border color :'
      end
      object Label3: TLabel
        Left = 224
        Top = 8
        Width = 42
        Height = 13
        Caption = 'Fill style :'
      end
      object Label4: TLabel
        Left = 224
        Top = 129
        Width = 58
        Height = 13
        Caption = 'Border size :'
      end
      object Label5: TLabel
        Left = 224
        Top = 154
        Width = 64
        Height = 13
        Caption = 'Border coeff :'
      end
      object Label6: TLabel
        Left = 224
        Top = 104
        Width = 61
        Height = 13
        Caption = 'Border style :'
      end
      object ScrollBarBColorR: TScrollBar
        Left = 80
        Top = 104
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 3
        OnChange = ReDraw
      end
      object ScrollBarBColorG: TScrollBar
        Left = 80
        Top = 126
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 4
        OnChange = ReDraw
      end
      object ScrollBarBColorB: TScrollBar
        Left = 80
        Top = 149
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 5
        OnChange = ReDraw
      end
      object ScrollBarFColorR: TScrollBar
        Left = 80
        Top = 8
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 0
        OnChange = ReDraw
      end
      object ScrollBarFColorG: TScrollBar
        Left = 80
        Top = 32
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 1
        OnChange = ReDraw
      end
      object ScrollBarFColorB: TScrollBar
        Left = 80
        Top = 56
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 2
        OnChange = ReDraw
      end
      object ComboBoxFStyle: TComboBox
        Left = 296
        Top = 8
        Width = 124
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 6
        OnChange = ReDraw
        Items.Strings = (
          'Solid'
          'Clear'
          'BDiagonal'
          'FDiagonal'
          'Cross'
          'DiagCross'
          'Horizontal'
          'Vertical')
      end
      object EditBSize: TEdit
        Left = 296
        Top = 128
        Width = 124
        Height = 21
        TabOrder = 8
        Text = '1'
        OnChange = ReDraw
      end
      object EditBCoeff: TEdit
        Left = 296
        Top = 152
        Width = 124
        Height = 21
        TabOrder = 9
        Text = '1.0'
        OnChange = ReDraw
      end
      object ComboBoxBStyle: TComboBox
        Left = 296
        Top = 104
        Width = 124
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 7
        OnChange = ReDraw
        Items.Strings = (
          'Solid'
          'Clear'
          'Dash'
          'Dot'
          'DashDot'
          'DashDotDot')
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Text'
      ImageIndex = 1
      object Label7: TLabel
        Left = 6
        Top = 7
        Width = 36
        Height = 13
        Caption = 'Align X:'
      end
      object Label8: TLabel
        Left = 174
        Top = 7
        Width = 36
        Height = 13
        Caption = 'Align Y:'
      end
      object MemoText: TMemo
        Left = 0
        Top = 32
        Width = 425
        Height = 161
        ScrollBars = ssBoth
        TabOrder = 3
        WordWrap = False
        OnChange = ReDraw
      end
      object CheckBoxTAlignRect: TCheckBox
        Left = 342
        Top = 7
        Width = 81
        Height = 17
        Caption = 'Align by rect'
        TabOrder = 2
        OnClick = ReDraw
      end
      object ComboBoxTAlignX: TComboBox
        Left = 55
        Top = 4
        Width = 104
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ReDraw
        Items.Strings = (
          'Left'
          'Center'
          'Right')
      end
      object ComboBoxTAlignY: TComboBox
        Left = 223
        Top = 4
        Width = 104
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = ReDraw
        Items.Strings = (
          'Top'
          'Center'
          'Bottom')
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Font'
      ImageIndex = 2
      object Label9: TLabel
        Left = 5
        Top = 9
        Width = 24
        Height = 13
        Caption = 'Font:'
      end
      object Label10: TLabel
        Left = 8
        Top = 48
        Width = 30
        Height = 13
        Caption = 'Color :'
      end
      object Label11: TLabel
        Left = 232
        Top = 48
        Width = 26
        Height = 13
        Caption = 'Size :'
      end
      object FontComboBoxTFont: TFontComboBox
        Left = 40
        Top = 8
        Width = 377
        Height = 20
        TabOrder = 0
        OnChange = ReDraw
      end
      object ScrollBarTColorR: TScrollBar
        Left = 56
        Top = 48
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 1
        OnChange = ReDraw
      end
      object ScrollBarTColorG: TScrollBar
        Left = 56
        Top = 72
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 2
        OnChange = ReDraw
      end
      object ScrollBarTColorB: TScrollBar
        Left = 56
        Top = 96
        Width = 110
        Height = 16
        Max = 255
        PageSize = 0
        TabOrder = 3
        OnChange = ReDraw
      end
      object ComboBoxTSize: TComboBox
        Left = 272
        Top = 48
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 4
        OnChange = ReDraw
        Items.Strings = (
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30')
      end
      object CheckBoxTBold: TCheckBox
        Left = 240
        Top = 88
        Width = 49
        Height = 17
        Caption = 'Bold'
        TabOrder = 5
        OnClick = ReDraw
      end
      object CheckBoxTItalic: TCheckBox
        Left = 240
        Top = 112
        Width = 49
        Height = 17
        Caption = 'Italic'
        TabOrder = 6
        OnClick = ReDraw
      end
      object CheckBoxTUnderline: TCheckBox
        Left = 240
        Top = 136
        Width = 73
        Height = 17
        Caption = 'Underline'
        TabOrder = 7
        OnClick = ReDraw
      end
    end
  end
  object BitBtnOK: TBitBtn
    Left = 281
    Top = 372
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = BitBtnOKClick
    Kind = bkOK
  end
  object BitBtnCancel: TBitBtn
    Left = 363
    Top = 372
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
  object BitBtnDelete: TBitBtn
    Left = 201
    Top = 372
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 1
    Kind = bkAbort
  end
end
