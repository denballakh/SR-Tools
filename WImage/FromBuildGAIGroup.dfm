object Form_BuildGAIGroup: TForm_BuildGAIGroup
  Left = 19
  Top = 400
  BorderStyle = bsDialog
  Caption = 'Build GAI Group'
  ClientHeight = 279
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 16
    Height = 13
    Caption = 'Dir:'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 55
    Height = 13
    Caption = 'Time frame:'
  end
  object Label3: TLabel
    Left = 10
    Top = 75
    Width = 36
    Height = 13
    Caption = 'Radius:'
  end
  object DirectoryEdit1: TDirectoryEdit
    Left = 32
    Top = 8
    Width = 401
    Height = 21
    NumGlyphs = 1
    TabOrder = 0
  end
  object EditTimeFrame: TEdit
    Left = 72
    Top = 40
    Width = 361
    Height = 21
    TabOrder = 1
    Text = '50'
  end
  object ButtonBuild: TButton
    Left = 272
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 2
    OnClick = ButtonBuildClick
  end
  object ButtonClose: TButton
    Left = 356
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 3
  end
  object MemoText: TMemo
    Left = 8
    Top = 104
    Width = 425
    Height = 169
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object EditRadius: TEdit
    Left = 73
    Top = 72
    Width = 49
    Height = 21
    TabOrder = 5
    Text = '12'
  end
  object CheckBox1: TCheckBox
    Left = 130
    Top = 73
    Width = 79
    Height = 17
    Caption = 'Back anim'
    TabOrder = 6
  end
end
