object Form_Different: TForm_Different
  Left = 711
  Top = 523
  Width = 312
  Height = 189
  Caption = 'Different image'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 40
    Height = 13
    Caption = 'Source :'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 78
    Height = 13
    Caption = 'Radius equality :'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 87
    Height = 13
    Caption = 'Background color:'
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Mode'
  end
  object ComboBoxSou: TComboBox
    Left = 55
    Top = 40
    Width = 242
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object ButtonBuild: TButton
    Left = 16
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 120
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 216
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = ButtonCancelClick
  end
  object EditREQ: TEdit
    Left = 88
    Top = 72
    Width = 209
    Height = 21
    TabOrder = 4
    Text = '12'
  end
  object EditColor: TEdit
    Left = 104
    Top = 104
    Width = 193
    Height = 21
    TabOrder = 5
    Text = '0,0,0,0'
  end
  object ComboBoxMode: TComboBox
    Left = 56
    Top = 8
    Width = 241
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'Cur-Source'
      'All-Source'
      'Series')
  end
end
