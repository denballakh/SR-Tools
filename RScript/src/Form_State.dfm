object FormState: TFormState
  Left = 95
  Top = 270
  BorderStyle = bsDialog
  Caption = 'State'
  ClientHeight = 412
  ClientWidth = 329
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
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Label2: TLabel
    Left = 8
    Top = 43
    Width = 33
    Height = 13
    Caption = 'Move :'
  end
  object LabelMoveObj: TLabel
    Left = 160
    Top = 44
    Width = 49
    Height = 13
    Caption = 'MoveObj :'
  end
  object Label3: TLabel
    Left = 8
    Top = 75
    Width = 37
    Height = 13
    Caption = 'Attack :'
  end
  object Label4: TLabel
    Left = 8
    Top = 171
    Width = 53
    Height = 13
    Caption = 'Take item :'
  end
  object BitBtn1: TBitBtn
    Left = 160
    Top = 384
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 384
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object EditName: TEdit
    Left = 64
    Top = 8
    Width = 257
    Height = 21
    TabOrder = 2
  end
  object ComboBoxMove: TComboBox
    Left = 64
    Top = 40
    Width = 89
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
    OnChange = ComboBoxMoveChange
    Items.Strings = (
      'None'
      'Move'
      'Follow'
      'Jump'
      'Landing')
  end
  object ComboBoxMoveObj: TComboBox
    Left = 216
    Top = 40
    Width = 105
    Height = 21
    Style = csDropDownList
    DropDownCount = 12
    ItemHeight = 13
    TabOrder = 4
  end
  object CheckListAttack: TRxCheckListBox
    Left = 64
    Top = 72
    Width = 257
    Height = 84
    ItemHeight = 13
    TabOrder = 5
    OnClickCheck = CheckListAttackClickCheck
    InternalVersion = 202
    Strings = (
      '1'
      0
      True
      '2'
      0
      True
      '3'
      0
      True
      '4'
      0
      True
      '5'
      0
      True
      '6'
      0
      True)
  end
  object ComboBoxTakeItem: TComboBox
    Left = 64
    Top = 168
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object CheckBoxTakeAllItem: TCheckBox
    Left = 224
    Top = 168
    Width = 89
    Height = 17
    Caption = 'Take all item'
    TabOrder = 7
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 200
    Width = 313
    Height = 177
    ActivePage = TabSheet3
    TabOrder = 8
    object TabSheet1: TTabSheet
      Caption = 'Out player'
      object MemoMsgOut: TMemo
        Left = 0
        Top = 0
        Width = 305
        Height = 149
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'In player'
      ImageIndex = 1
      object MemoMsgIn: TMemo
        Left = 0
        Top = 0
        Width = 305
        Height = 149
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Ether'
      ImageIndex = 2
      object Label5: TLabel
        Left = 0
        Top = 3
        Width = 30
        Height = 13
        Caption = 'Type :'
      end
      object Label6: TLabel
        Left = 136
        Top = 4
        Width = 40
        Height = 13
        Caption = 'Unique :'
      end
      object SpeedButton1: TSpeedButton
        Left = 280
        Top = 0
        Width = 23
        Height = 22
        Caption = 'N'
        OnClick = SpeedButton1Click
      end
      object ComboBoxEType: TComboBox
        Left = 32
        Top = 0
        Width = 89
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'Galaxy'
          'Ether')
      end
      object EditEUnique: TEdit
        Left = 179
        Top = 0
        Width = 94
        Height = 21
        TabOrder = 1
      end
      object MemoEMsg: TMemo
        Left = 0
        Top = 27
        Width = 305
        Height = 122
        ScrollBars = ssBoth
        TabOrder = 2
      end
    end
  end
end
