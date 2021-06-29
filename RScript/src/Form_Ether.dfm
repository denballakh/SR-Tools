object FormEther: TFormEther
  Left = 289
  Top = 368
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderStyle = bsDialog
  Caption = 'Ether'
  ClientHeight = 323
  ClientWidth = 362
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
    Top = 11
    Width = 30
    Height = 13
    Caption = 'Type :'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 40
    Height = 13
    Caption = 'Unique :'
  end
  object Label3: TLabel
    Left = 8
    Top = 211
    Width = 36
    Height = 13
    Caption = 'Ship 1 :'
  end
  object Label4: TLabel
    Left = 8
    Top = 235
    Width = 36
    Height = 13
    Caption = 'Ship 2 :'
  end
  object Label5: TLabel
    Left = 8
    Top = 259
    Width = 36
    Height = 13
    Caption = 'Ship 3 :'
  end
  object RxSpeedButton2: TRxSpeedButton
    Left = 8
    Top = 284
    Width = 65
    Height = 25
    Caption = 'Insert'
    OnClick = RxSpeedButton2Click
  end
  object ButFast: TRxSpeedButton
    Left = 80
    Top = 284
    Width = 73
    Height = 25
    DropDownMenu = PopupMenuGroup
    Caption = 'fast'
  end
  object SpeedButton1: TSpeedButton
    Left = 328
    Top = 40
    Width = 23
    Height = 22
    Caption = 'N'
    OnClick = SpeedButton1Click
  end
  object BitBtn1: TBitBtn
    Left = 192
    Top = 284
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 277
    Top = 284
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object ComboBoxType: TComboBox
    Left = 56
    Top = 8
    Width = 297
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 2
    Items.Strings = (
      'Galaxy'
      'Ether'
      'Ship'
      'Quest'
      'QuestOk'
      'QuestCancel')
  end
  object EditUnique: TEdit
    Left = 55
    Top = 40
    Width = 266
    Height = 21
    TabOrder = 3
  end
  object ComboBoxShip1: TComboBox
    Left = 56
    Top = 208
    Width = 297
    Height = 21
    ItemHeight = 13
    TabOrder = 4
  end
  object ComboBoxShip2: TComboBox
    Left = 56
    Top = 232
    Width = 297
    Height = 21
    ItemHeight = 13
    TabOrder = 5
  end
  object ComboBoxShip3: TComboBox
    Left = 56
    Top = 256
    Width = 297
    Height = 21
    ItemHeight = 13
    TabOrder = 6
  end
  object MemoMsg: TRichEdit
    Left = 8
    Top = 72
    Width = 345
    Height = 129
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnChange = MemoMsgChange
    OnSelectionChange = MemoMsgSelectionChange
  end
  object PopupMenuGroup: TPopupMenu
    AutoHotkeys = maManual
    Left = 112
    Top = 144
    object Text11: TMenuItem
      Caption = 'Text 1'
    end
    object Text21: TMenuItem
      Caption = 'Text 2'
    end
  end
end
