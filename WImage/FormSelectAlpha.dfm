object Form_SelectAlpha: TForm_SelectAlpha
  Left = 541
  Top = 526
  BorderStyle = bsDialog
  Caption = 'Select by color'
  ClientHeight = 158
  ClientWidth = 249
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = 'Color bound :'
  end
  object ButtonBuild: TButton
    Left = 26
    Top = 127
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 0
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 146
    Top = 127
    Width = 75
    Height = 26
    Caption = 'Close'
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object Edit1: TEdit
    Left = 80
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 2
    Text = '10'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 36
    Width = 233
    Height = 53
    TabOrder = 3
    object RadioButton1: TRadioButton
      Left = 7
      Top = 13
      Width = 113
      Height = 17
      Caption = 'Select down       <='
      TabOrder = 0
    end
    object RadioButton2: TRadioButton
      Left = 8
      Top = 30
      Width = 113
      Height = 17
      Caption = 'Select up            >'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object CheckBoxRed: TCheckBox
    Left = 8
    Top = 96
    Width = 49
    Height = 17
    Caption = 'Red'
    TabOrder = 4
  end
  object CheckBoxGreen: TCheckBox
    Left = 64
    Top = 96
    Width = 57
    Height = 17
    Caption = 'Green'
    TabOrder = 5
  end
  object CheckBoxBlue: TCheckBox
    Left = 128
    Top = 96
    Width = 49
    Height = 17
    Caption = 'Blue'
    TabOrder = 6
  end
  object CheckBoxAlpha: TCheckBox
    Left = 184
    Top = 96
    Width = 49
    Height = 17
    Caption = 'Alpha'
    Checked = True
    State = cbChecked
    TabOrder = 7
  end
end
