object FormVar: TFormVar
  Left = 234
  Top = 551
  BorderStyle = bsDialog
  Caption = 'Variable'
  ClientHeight = 132
  ClientWidth = 282
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
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 30
    Height = 13
    Caption = 'Type :'
  end
  object Label3: TLabel
    Left = 8
    Top = 74
    Width = 46
    Height = 13
    Caption = 'Init state :'
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 101
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 192
    Top = 101
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object EditName: TEdit
    Left = 64
    Top = 8
    Width = 209
    Height = 21
    TabOrder = 2
  end
  object ComboBoxType: TComboBox
    Left = 64
    Top = 40
    Width = 209
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'unknown'
      'int'
      'dword'
      'str')
  end
  object EditInitState: TEdit
    Left = 64
    Top = 72
    Width = 209
    Height = 21
    TabOrder = 4
  end
  object CheckBoxGlobal: TCheckBox
    Left = 8
    Top = 104
    Width = 57
    Height = 17
    Caption = 'Global'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
