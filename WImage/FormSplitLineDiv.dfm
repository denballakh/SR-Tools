object FormSplitLineDivForm: TFormSplitLineDivForm
  Left = 130
  Top = 570
  BorderStyle = bsDialog
  Caption = 'Split line div form'
  ClientHeight = 105
  ClientWidth = 273
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
    Width = 73
    Height = 13
    Caption = 'Count sector X:'
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 73
    Height = 13
    Caption = 'Count sector X:'
  end
  object BitBtn1: TBitBtn
    Left = 56
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkCancel
  end
  object BitBtn2: TBitBtn
    Left = 144
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object EditSX: TEdit
    Left = 88
    Top = 8
    Width = 177
    Height = 21
    TabOrder = 2
    Text = '2'
  end
  object EditSY: TEdit
    Left = 88
    Top = 40
    Width = 177
    Height = 21
    TabOrder = 3
    Text = '2'
  end
end
