object FormDialogAnswer: TFormDialogAnswer
  Left = 38
  Top = 421
  BorderStyle = bsDialog
  Caption = 'Dialog answer'
  ClientHeight = 258
  ClientWidth = 522
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 49
    Height = 182
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 6
      Top = 2
      Width = 27
      Height = 13
      Caption = 'Text :'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 223
    Width = 522
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object RxSpeedButton2: TRxSpeedButton
      Left = 55
      Top = 6
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object ButFast: TRxSpeedButton
      Left = 127
      Top = 6
      Width = 73
      Height = 25
      DropDownMenu = PopupMenuGroup
      Caption = 'fast'
    end
    object Panel5: TPanel
      Left = 346
      Top = 0
      Width = 176
      Height = 35
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = BitBtn1Click
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 522
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label1: TLabel
      Left = 7
      Top = 10
      Width = 34
      Height = 13
      Caption = 'Name :'
    end
    object EditName: TEdit
      Left = 49
      Top = 8
      Width = 331
      Height = 21
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 510
    Top = 41
    Width = 12
    Height = 182
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
  end
  object MemoText: TRichEdit
    Left = 49
    Top = 41
    Width = 461
    Height = 182
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnChange = MemoTextChange
    OnSelectionChange = MemoTextSelectionChange
  end
  object PopupMenuGroup: TPopupMenu
    AutoHotkeys = maManual
    Left = 128
    Top = 120
    object Text11: TMenuItem
      Caption = 'Text 1'
    end
    object Text21: TMenuItem
      Caption = 'Text 2'
    end
  end
end
