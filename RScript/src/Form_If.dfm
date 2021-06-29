object FormIf: TFormIf
  Left = 53
  Top = 662
  Width = 506
  Height = 120
  Caption = 'if'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 73
    Height = 43
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 11
      Width = 57
      Height = 13
      Caption = 'Expression :'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 43
    Width = 498
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object RxSpeedButton2: TRxSpeedButton
      Left = 88
      Top = 7
      Width = 65
      Height = 25
      Caption = 'Insert'
      OnClick = RxSpeedButton2Click
    end
    object ButFast: TRxSpeedButton
      Left = 160
      Top = 7
      Width = 73
      Height = 25
      DropDownMenu = PopupMenuGroup
      Caption = 'fast'
    end
    object Panel3: TPanel
      Left = 321
      Top = 0
      Width = 177
      Height = 43
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn1: TBitBtn
        Left = 6
        Top = 7
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = BitBtn1Click
        Kind = bkOK
      end
      object BitBtn2: TBitBtn
        Left = 86
        Top = 7
        Width = 75
        Height = 25
        TabOrder = 1
        Kind = bkCancel
      end
    end
    object ComboBoxType: TComboBox
      Left = 13
      Top = 9
      Width = 68
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Items.Strings = (
        'Normal'
        'Init'
        'Global')
    end
  end
  object Panel4: TPanel
    Left = 490
    Top = 0
    Width = 8
    Height = 43
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel5: TPanel
    Left = 73
    Top = 0
    Width = 417
    Height = 43
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 417
      Height = 9
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
    end
    object Panel7: TPanel
      Left = 0
      Top = 34
      Width = 417
      Height = 9
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
    end
    object EditExpr: TRxRichEdit
      Left = 0
      Top = 9
      Width = 417
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
      TabOrder = 2
      WantReturns = False
      WordWrap = False
      OnSelectionChange = EditExprSelectionChange
    end
  end
  object PopupMenuGroup: TPopupMenu
    AutoHotkeys = maManual
    Left = 112
    Top = 32
    object Text11: TMenuItem
      Caption = 'Text 1'
    end
    object Text21: TMenuItem
      Caption = 'Text 2'
    end
  end
end
