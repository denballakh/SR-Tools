object Form_Rescale: TForm_Rescale
  Left = 702
  Top = 519
  BorderStyle = bsDialog
  Caption = 'Rescale'
  ClientHeight = 163
  ClientWidth = 278
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
    Width = 30
    Height = 13
    Caption = 'Size X'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Size Y'
  end
  object Label3: TLabel
    Left = 8
    Top = 72
    Width = 22
    Height = 13
    Caption = 'Filter'
  end
  object ButtonBuild: TButton
    Left = 16
    Top = 131
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 0
    OnClick = ButtonBuildClick
  end
  object ButtonOk: TButton
    Left = 98
    Top = 131
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = ButtonOkClick
  end
  object ButtonCancel: TButton
    Left = 183
    Top = 131
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = ButtonCancelClick
  end
  object EditSizeX: TEdit
    Left = 48
    Top = 8
    Width = 161
    Height = 21
    TabOrder = 3
    Text = '100'
  end
  object EditSizeY: TEdit
    Left = 48
    Top = 40
    Width = 161
    Height = 21
    TabOrder = 4
    Text = '100'
  end
  object CheckBoxAll: TCheckBox
    Left = 8
    Top = 104
    Width = 41
    Height = 17
    Caption = 'All'
    TabOrder = 5
  end
  object ComboBoxFilter: TComboBox
    Left = 48
    Top = 72
    Width = 225
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'Box'
      'Triangle'
      'Bell'
      'B-Spline'
      'Filter'
      'Lanczos3'
      'Mitchell')
  end
  object CheckBoxXPercent: TCheckBox
    Left = 216
    Top = 8
    Width = 57
    Height = 17
    Caption = 'percent'
    TabOrder = 7
  end
  object CheckBoxYPercent: TCheckBox
    Left = 215
    Top = 42
    Width = 57
    Height = 17
    Caption = 'percent'
    TabOrder = 8
  end
  object BitBtn1: TBitBtn
    Left = 224
    Top = 102
    Width = 48
    Height = 17
    Caption = '1024 to 800'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = BitBtn1Click
  end
end
