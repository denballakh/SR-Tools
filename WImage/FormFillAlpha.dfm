object Form_FillAlpha: TForm_FillAlpha
  Left = 253
  Top = 481
  BorderStyle = bsDialog
  Caption = 'Fill by alpha'
  ClientHeight = 201
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 66
    Height = 13
    Caption = 'Alpha bound :'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 41
    Height = 13
    Caption = 'Fill color:'
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 169
    Height = 21
    TabOrder = 0
    Text = '10'
  end
  object ButtonBuild: TButton
    Left = 8
    Top = 171
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 90
    Top = 171
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 175
    Top = 171
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = ButtonCancelClick
  end
  object EditColor: TEdit
    Left = 80
    Top = 40
    Width = 169
    Height = 21
    TabOrder = 4
    Text = '0,0,0,0'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 241
    Height = 53
    TabOrder = 5
    object RadioButton1: TRadioButton
      Left = 7
      Top = 13
      Width = 113
      Height = 17
      Caption = 'Fill down    <='
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 30
      Width = 113
      Height = 17
      Caption = 'Fill up         >'
      TabOrder = 1
    end
  end
  object CheckBoxRed: TCheckBox
    Left = 8
    Top = 66
    Width = 49
    Height = 17
    Caption = 'Red'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object CheckBoxGreen: TCheckBox
    Left = 64
    Top = 66
    Width = 57
    Height = 17
    Caption = 'Green'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
  object CheckBoxBlue: TCheckBox
    Left = 136
    Top = 66
    Width = 49
    Height = 17
    Caption = 'Blue'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object CheckBoxAlpha: TCheckBox
    Left = 192
    Top = 66
    Width = 57
    Height = 17
    Caption = 'Alpha'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object CheckBoxAll: TCheckBox
    Left = 8
    Top = 147
    Width = 41
    Height = 17
    Caption = 'All'
    TabOrder = 10
  end
end
