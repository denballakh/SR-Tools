object FormDialog: TFormDialog
  Left = 32
  Top = 595
  BorderStyle = bsDialog
  Caption = 'Dialog'
  ClientHeight = 79
  ClientWidth = 242
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
    Left = 8
    Top = 10
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object EditName: TEdit
    Left = 48
    Top = 8
    Width = 185
    Height = 21
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 72
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 152
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
