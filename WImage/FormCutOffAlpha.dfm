object Form_CutOffAlpha: TForm_CutOffAlpha
  Left = 73
  Top = 598
  BorderStyle = bsDialog
  Caption = 'Cut off by alpha'
  ClientHeight = 90
  ClientWidth = 258
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Alpha bound :'
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 0
    Text = '0'
  end
  object ButtonBuild: TButton
    Left = 8
    Top = 59
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 90
    Top = 59
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 173
    Top = 59
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = ButtonCancelClick
  end
  object CheckBoxAll: TCheckBox
    Left = 9
    Top = 37
    Width = 97
    Height = 17
    Caption = 'All'
    TabOrder = 4
  end
end
