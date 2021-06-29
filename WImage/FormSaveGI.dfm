object Form_SaveGI: TForm_SaveGI
  Left = 603
  Top = 411
  BorderStyle = bsDialog
  Caption = 'Save gi'
  ClientHeight = 271
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 19
    Height = 13
    Caption = 'File:'
  end
  object SpeedButton1: TSpeedButton
    Left = 376
    Top = 56
    Width = 23
    Height = 22
    Caption = 'F'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 35
    Height = 13
    Caption = 'Format:'
  end
  object Label3: TLabel
    Left = 8
    Top = 32
    Width = 16
    Height = 13
    Caption = 'Dir:'
    Visible = False
  end
  object Label4: TLabel
    Left = 8
    Top = 122
    Width = 60
    Height = 13
    Caption = 'Pixel format :'
  end
  object EditFile: TEdit
    Left = 38
    Top = 56
    Width = 331
    Height = 21
    TabOrder = 0
    Text = '*.gi'
  end
  object ComboBoxFormat: TComboBox
    Left = 48
    Top = 88
    Width = 353
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'Bitmap'
      'Trans'
      'Alpha'
      'AlphaIndexed8'
      'BitmapPal')
  end
  object ButtonSave: TButton
    Left = 247
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object ButtonClose: TButton
    Left = 328
    Top = 116
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 3
  end
  object MemoText: TMemo
    Left = 0
    Top = 146
    Width = 408
    Height = 125
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 4
    WantTabs = True
  end
  object DirectoryEditDir: TDirectoryEdit
    Left = 39
    Top = 29
    Width = 361
    Height = 21
    NumGlyphs = 1
    TabOrder = 5
    Visible = False
  end
  object CheckBoxAll: TCheckBox
    Left = 8
    Top = 5
    Width = 65
    Height = 17
    Caption = 'All image'
    TabOrder = 6
    OnClick = CheckBoxAllClick
  end
  object CheckBoxAutoSize: TCheckBox
    Left = 166
    Top = 5
    Width = 67
    Height = 17
    Caption = 'Auto size'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object ComboBoxPF: TComboBox
    Left = 80
    Top = 120
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    Items.Strings = (
      '555'
      '565'
      '8888')
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.gi'
    Filter = '*.gi|*.gi'
    Left = 324
    Top = 56
  end
end
