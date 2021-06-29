object Form_SaveGAI: TForm_SaveGAI
  Left = 546
  Top = 352
  BorderStyle = bsDialog
  Caption = 'Save gai'
  ClientHeight = 331
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 19
    Height = 13
    Caption = 'File:'
  end
  object SpeedButton1: TSpeedButton
    Left = 424
    Top = 8
    Width = 23
    Height = 22
    Caption = 'F'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object Label3: TLabel
    Left = 8
    Top = 69
    Width = 26
    Height = 13
    Caption = 'Anim:'
  end
  object EditFile: TEdit
    Left = 32
    Top = 8
    Width = 385
    Height = 21
    TabOrder = 0
    Text = '*.gai'
  end
  object ButtonSave: TButton
    Left = 296
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = ButtonSaveClick
  end
  object ButtonClose: TButton
    Left = 376
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
  end
  object ComboBoxFormat: TComboBox
    Left = 48
    Top = 40
    Width = 401
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'Bitmap'
      'Trans'
      'Alpha'
      'AlphaIndexed8'
      'BitmapPal'
      'Different')
  end
  object CheckBoxSeries: TCheckBox
    Left = 15
    Top = 179
    Width = 65
    Height = 17
    Caption = 'Series'
    TabOrder = 4
  end
  object MemoText: TMemo
    Left = 0
    Top = 206
    Width = 454
    Height = 125
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 5
    WantTabs = True
  end
  object StringGridAnim: TStringGrid
    Left = 48
    Top = 72
    Width = 401
    Height = 97
    ColCount = 2
    DefaultColWidth = 80
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 50
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    TabOrder = 6
  end
  object CheckBoxCompress: TCheckBox
    Left = 88
    Top = 179
    Width = 73
    Height = 17
    Caption = 'Compress'
    TabOrder = 7
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.gai'
    Filter = '*.gai|*.gai'
    Left = 260
  end
end
