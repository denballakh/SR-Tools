object Form_InfoProject: TForm_InfoProject
  Left = 498
  Top = 300
  BorderStyle = bsDialog
  Caption = 'Info project'
  ClientHeight = 378
  ClientWidth = 464
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
  object MemoText: TMemo
    Left = 8
    Top = 8
    Width = 449
    Height = 257
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
  end
  object Button1: TButton
    Left = 384
    Top = 352
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 336
    Top = 272
    Width = 121
    Height = 25
    Caption = 'Position and size (tree)'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 216
    Top = 272
    Width = 113
    Height = 25
    Caption = 'Position and size (list)'
    TabOrder = 3
    OnClick = Button3Click
  end
  object EditMaskName: TEdit
    Left = 8
    Top = 304
    Width = 385
    Height = 21
    TabOrder = 4
    Text = '<z>=<z>.gi'
  end
  object ButtonName: TButton
    Left = 400
    Top = 301
    Width = 57
    Height = 25
    Caption = 'Name'
    TabOrder = 5
    OnClick = ButtonNameClick
  end
  object EditSme: TEdit
    Left = 8
    Top = 272
    Width = 201
    Height = 21
    TabOrder = 6
    Text = '0,0'
  end
end
