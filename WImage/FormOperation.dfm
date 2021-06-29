object Form_Operation: TForm_Operation
  Left = 691
  Top = 494
  BorderStyle = bsDialog
  Caption = 'Operation'
  ClientHeight = 192
  ClientWidth = 309
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
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = 'Source :'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 40
    Height = 13
    Caption = 'Formula:'
  end
  object Label3: TLabel
    Left = 8
    Top = 99
    Width = 51
    Height = 13
    Caption = 'Error color:'
  end
  object Label4: TLabel
    Left = 8
    Top = 128
    Width = 41
    Height = 13
    Caption = 'Fill color:'
  end
  object ComboBoxSou: TComboBox
    Left = 55
    Top = 8
    Width = 242
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object ComboBox1: TComboBox
    Left = 56
    Top = 40
    Width = 241
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    Items.Strings = (
      'ADD: alpha*sou_color+(1-alpha)*des_color'
      'SUB: (sou_color-(1-alpha)*des_color)/alpha'
      'ADD: des_color+sou_color'
      'SUB: des_color-sou_color'
      'COPY: sou_color>0')
  end
  object EditColor: TEdit
    Left = 64
    Top = 96
    Width = 233
    Height = 21
    TabOrder = 2
    Text = '0,0,0,0'
  end
  object ButtonBuild: TButton
    Left = 24
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 3
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 120
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 4
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 216
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = ButtonCancelClick
  end
  object EditColorBG: TEdit
    Left = 64
    Top = 128
    Width = 209
    Height = 21
    TabOrder = 6
    Text = '0,0,0,0'
  end
  object CheckBox1: TCheckBox
    Left = 280
    Top = 128
    Width = 17
    Height = 17
    TabOrder = 7
  end
  object CheckBoxColInv: TCheckBox
    Left = 8
    Top = 72
    Width = 121
    Height = 17
    Caption = 'Color Sou1<->Sou2'
    TabOrder = 8
  end
end
