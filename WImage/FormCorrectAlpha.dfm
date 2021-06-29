object Form_CorrectAlpha: TForm_CorrectAlpha
  Left = 322
  Top = 544
  BorderStyle = bsDialog
  Caption = 'Correct alpha'
  ClientHeight = 137
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Formula:'
  end
  object Label1: TLabel
    Left = 8
    Top = 42
    Width = 12
    Height = 13
    Caption = 'a :'
  end
  object ButtonBuild: TButton
    Left = 16
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 0
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 112
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 208
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object ComboBox1: TComboBox
    Left = 60
    Top = 8
    Width = 241
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    Items.Strings = (
      'alpha=alpha*a'
      'alpha=alpha^a')
  end
  object EditA: TEdit
    Left = 60
    Top = 40
    Width = 241
    Height = 21
    TabOrder = 4
    Text = '0.5'
  end
  object CheckBoxAll: TCheckBox
    Left = 8
    Top = 72
    Width = 49
    Height = 17
    Caption = 'All'
    TabOrder = 5
  end
  object CheckBox1: TCheckBox
    Left = 160
    Top = 72
    Width = 129
    Height = 17
    Caption = 'Alpha not max(color)'
    TabOrder = 6
  end
end
