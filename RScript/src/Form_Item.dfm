object FormItem: TFormItem
  Left = 207
  Top = 419
  BorderStyle = bsDialog
  Caption = 'Item'
  ClientHeight = 264
  ClientWidth = 282
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
    Height = 14
    Caption = 'Name :'
  end
  object Label15: TLabel
    Left = 8
    Top = 39
    Width = 31
    Height = 13
    Caption = 'Class :'
  end
  object EditName: TEdit
    Left = 64
    Top = 8
    Width = 209
    Height = 21
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 120
    Top = 233
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 200
    Top = 233
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
  object Notebook1: TNotebook
    Left = 8
    Top = 64
    Width = 265
    Height = 161
    PageIndex = 4
    TabOrder = 3
    object TPage
      Left = 0
      Top = 0
      Caption = 'Equipment'
      object Label5: TLabel
        Left = 8
        Top = 10
        Width = 30
        Height = 13
        Caption = 'Type :'
      end
      object Label2: TLabel
        Left = 8
        Top = 42
        Width = 26
        Height = 13
        Caption = 'Size :'
      end
      object Label3: TLabel
        Left = 8
        Top = 73
        Width = 32
        Height = 13
        Caption = 'Level :'
      end
      object Label4: TLabel
        Left = 8
        Top = 103
        Width = 37
        Height = 13
        Caption = 'Owner :'
      end
      object ComboBoxEqType: TComboBox
        Left = 56
        Top = 8
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'FuelTanks'
          'Engine'
          'Radar'
          'Scaner'
          'RepairRobot'
          'CargoHook'
          'DefGenerator')
      end
      object EditEqSize: TEdit
        Left = 56
        Top = 39
        Width = 193
        Height = 21
        TabOrder = 1
      end
      object RxSpinEditEqLevel: TRxSpinEdit
        Left = 56
        Top = 70
        Width = 193
        Height = 21
        MaxValue = 7
        MinValue = 1
        Value = 1
        TabOrder = 2
      end
      object ComboBoxEqOwner: TComboBox
        Left = 56
        Top = 101
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 3
        Items.Strings = (
          'Maloc'
          'Peleng'
          'People'
          'Fei'
          'Gaal'
          'Kling'
          'None')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Weapon'
      object Label6: TLabel
        Left = 8
        Top = 10
        Width = 30
        Height = 13
        Caption = 'Type :'
      end
      object Label7: TLabel
        Left = 8
        Top = 42
        Width = 26
        Height = 13
        Caption = 'Size :'
      end
      object Label8: TLabel
        Left = 8
        Top = 73
        Width = 32
        Height = 13
        Caption = 'Level :'
      end
      object Label10: TLabel
        Left = 8
        Top = 103
        Width = 39
        Height = 13
        Caption = 'Radius :'
      end
      object Label9: TLabel
        Left = 8
        Top = 133
        Width = 37
        Height = 13
        Caption = 'Owner :'
      end
      object ComboBoxWeType: TComboBox
        Left = 56
        Top = 8
        Width = 193
        Height = 21
        Style = csDropDownList
        DropDownCount = 15
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          '1=Photon gun'
          '2=Industrial laser'
          '3=Zipgun'
          '4=Graviton beamer'
          '5=Retractor'
          '6=Kelller'#39's phaser'
          '7=Aeonic blaster'
          '8=X-defibrillator'
          '9=Submesonic cannon'
          '10=Field annihilator'
          '11=Tachyon blade'
          '12=Vortex projector'
          '13=Ultimate matrix'
          '14=Hellwave'
          '15=Eyes of Machpella')
      end
      object EditWeSize: TEdit
        Left = 56
        Top = 39
        Width = 193
        Height = 21
        TabOrder = 1
      end
      object RxSpinEditWeLevel: TRxSpinEdit
        Left = 56
        Top = 70
        Width = 193
        Height = 21
        MaxValue = 7
        MinValue = 1
        Value = 1
        TabOrder = 2
      end
      object EditWeRadius: TEdit
        Left = 56
        Top = 101
        Width = 193
        Height = 21
        TabOrder = 3
      end
      object ComboBoxWeOwner: TComboBox
        Left = 56
        Top = 130
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 4
        Items.Strings = (
          'Maloc'
          'Peleng'
          'People'
          'Fei'
          'Gaal'
          'Kling'
          'None')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Goods'
      object Label11: TLabel
        Left = 8
        Top = 10
        Width = 30
        Height = 13
        Caption = 'Type :'
      end
      object Label12: TLabel
        Left = 8
        Top = 42
        Width = 34
        Height = 13
        Caption = 'Count :'
      end
      object ComboBoxGoType: TComboBox
        Left = 56
        Top = 8
        Width = 193
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'Food'
          'Medicine'
          'Technics'
          'Luxury'
          'Minerals'
          'Minerals (natural)'
          'Alcohol'
          'Arms'
          'Narcotics'
          'Protoplasm')
      end
      object EditGoCount: TEdit
        Left = 56
        Top = 39
        Width = 193
        Height = 21
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Artifact'
      object Label13: TLabel
        Left = 8
        Top = 10
        Width = 30
        Height = 13
        Caption = 'Type :'
      end
      object Label14: TLabel
        Left = 8
        Top = 41
        Width = 37
        Height = 13
        Caption = 'Owner :'
      end
      object ComboBoxArType: TComboBox
        Left = 56
        Top = 8
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        Items.Strings = (
          'ArtefactHull'
          'ArtefactFuel'
          'ArtefactSpeed'
          'ArtefactPower'
          'ArtefactRadar'
          'ArtefactScaner'
          'ArtefactDroid'
          'ArtefactNano'
          'ArtefactHook'
          'ArtefactDef'
          'ArtefactAnalyzer'
          'ArtefactMiniExpl'
          'ArtefactAntigrav'
          'ArtefactTransmitter'
          'ArtefactBomb'
          'ArtefactTranclucator')
      end
      object ComboBoxArOwner: TComboBox
        Left = 56
        Top = 39
        Width = 193
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        Items.Strings = (
          'Maloc'
          'Peleng'
          'People'
          'Fei'
          'Gaal'
          'Kling'
          'None')
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Useless'
      object Label16: TLabel
        Left = 8
        Top = 10
        Width = 34
        Height = 13
        Caption = 'Name :'
      end
      object EditUselessName: TEdit
        Left = 48
        Top = 8
        Width = 209
        Height = 25
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Unknown'
    end
  end
  object ComboBoxType: TComboBox
    Left = 64
    Top = 37
    Width = 209
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ComboBoxTypeChange
    Items.Strings = (
      'Equipment'
      'Weapon'
      'Goods'
      'Artifact'
      'Useless'
      'Unknown')
  end
end
