object Form_CorrectImageByAlpha: TForm_CorrectImageByAlpha
  Left = 5
  Top = 534
  BorderStyle = bsDialog
  Caption = 'Correct image by alpha'
  ClientHeight = 151
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 87
    Height = 13
    Caption = 'Background color:'
  end
  object SpeedButton1: TSpeedButton
    Left = 256
    Top = 40
    Width = 23
    Height = 22
    Caption = 'C'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Formula:'
  end
  object Label3: TLabel
    Left = 8
    Top = 67
    Width = 51
    Height = 13
    Caption = 'Error color:'
  end
  object SpeedButton2: TSpeedButton
    Left = 256
    Top = 63
    Width = 23
    Height = 22
    Caption = 'C'
    OnClick = SpeedButton2Click
  end
  object Edit1: TEdit
    Left = 112
    Top = 40
    Width = 137
    Height = 21
    TabOrder = 0
    Text = '0,0,0'
  end
  object ButtonBuild: TButton
    Left = 8
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonCancel: TButton
    Left = 200
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object ButtonOk: TButton
    Left = 104
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 3
    OnClick = ButtonOkClick
  end
  object ComboBox1: TComboBox
    Left = 56
    Top = 8
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    Items.Strings = (
      'ADD: alpha*color+(1-alpha)*bg_color'
      'SUB: (color-(1-alpha)*bg_color)/alpha')
  end
  object Edit2: TEdit
    Left = 112
    Top = 64
    Width = 137
    Height = 21
    TabOrder = 5
    Text = '0,0,0'
  end
  object CheckBoxAll: TCheckBox
    Left = 8
    Top = 96
    Width = 49
    Height = 17
    Caption = 'All'
    TabOrder = 6
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 224
    Top = 48
  end
end
