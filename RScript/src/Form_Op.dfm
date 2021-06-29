object FormOp: TFormOp
  Left = 49
  Top = 788
  Width = 475
  Height = 120
  Caption = 'Operation'
  Color = clBtnFace
  Constraints.MaxHeight = 120
  Constraints.MinHeight = 120
  Constraints.MinWidth = 400
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
  object Panel2: TPanel
    Left = 0
    Top = 34
    Width = 467
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object RxSpeedButton2: TRxSpeedButton
      Left = 56
      Top = 14
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object ButFast: TRxSpeedButton
      Left = 128
      Top = 14
      Width = 73
      Height = 25
      DropDownMenu = PopupMenuGroup
      Caption = 'fast'
    end
    object Panel3: TPanel
      Left = 290
      Top = 0
      Width = 177
      Height = 52
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 14
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = BitBtn1Click
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 14
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
    object CheckBoxInit: TCheckBox
      Left = 8
      Top = 18
      Width = 41
      Height = 17
      Caption = 'Init'
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 9
    Width = 73
    Height = 25
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 3
      Width = 57
      Height = 13
      Caption = 'Expression :'
    end
  end
  object Panel4: TPanel
    Left = 459
    Top = 9
    Width = 8
    Height = 25
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel6: TPanel
    Left = 0
    Top = 0
    Width = 467
    Height = 9
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object EditExpr: TRxRichEdit
    Left = 73
    Top = 9
    Width = 386
    Height = 25
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 4
    WantReturns = False
    WordWrap = False
    OnSelectionChange = EditExprSelectionChange
  end
  object PopupMenuGroup: TPopupMenu
    AutoHotkeys = maManual
    Left = 120
    Top = 32
    object Text11: TMenuItem
      Caption = 'Text 1'
    end
    object Text21: TMenuItem
      Caption = 'Text 2'
    end
  end
end
