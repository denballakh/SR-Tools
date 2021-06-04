object FormAbout: TFormAbout
  Left = 579
  Top = 126
  BorderStyle = bsDialog
  Caption = 'About ABWorld'
  ClientHeight = 154
  ClientWidth = 316
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
    Left = 33
    Top = 17
    Width = 220
    Height = 20
    Caption = 'ABWorld for game Rangers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnShadow
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 32
    Top = 16
    Width = 220
    Height = 20
    Caption = 'ABWorld for game Rangers'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 16
    Top = 48
    Width = 38
    Height = 13
    Caption = 'Version:'
  end
  object Label4: TLabel
    Left = 56
    Top = 48
    Width = 32
    Height = 13
    Caption = 'Label4'
  end
  object Label5: TLabel
    Left = 16
    Top = 72
    Width = 182
    Height = 13
    Caption = 'Copyright (c) 2002 NewGame software'
  end
  object Label6: TLabel
    Left = 16
    Top = 96
    Width = 86
    Height = 13
    Caption = 'All rights reserved.'
  end
  object BitBtn1: TBitBtn
    Left = 232
    Top = 120
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkOK
  end
end
