object FormPlanet: TFormPlanet
  Left = 38
  Top = 274
  BorderStyle = bsDialog
  Caption = 'Planet'
  ClientHeight = 411
  ClientWidth = 337
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
    Top = 8
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Label2: TLabel
    Left = 8
    Top = 322
    Width = 82
    Height = 13
    Caption = 'Range (min,max):'
  end
  object Label3: TLabel
    Left = 8
    Top = 355
    Width = 36
    Height = 13
    Caption = 'Dialog :'
  end
  object BitBtn1: TBitBtn
    Left = 160
    Top = 382
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = BitBtn1Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 382
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object EditName: TEdit
    Left = 56
    Top = 8
    Width = 273
    Height = 21
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 184
    Width = 321
    Height = 49
    Caption = '        Economy'
    TabOrder = 3
    object CheckBoxAgriculture: TCheckBox
      Left = 8
      Top = 24
      Width = 73
      Height = 17
      Caption = 'Agriculture'
      TabOrder = 0
    end
    object CheckBoxIndustrial: TCheckBox
      Left = 88
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Industrial'
      TabOrder = 1
    end
    object CheckBoxMixed: TCheckBox
      Left = 176
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Mixed'
      TabOrder = 2
    end
    object CheckBoxEconomy: TCheckBox
      Left = 11
      Top = -1
      Width = 16
      Height = 17
      TabOrder = 3
      OnClick = CheckBoxEconomyClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 240
    Width = 321
    Height = 71
    Caption = '        Goverment'
    TabOrder = 4
    object CheckBoxGoverment: TCheckBox
      Left = 11
      Top = -1
      Width = 16
      Height = 17
      TabOrder = 0
      OnClick = CheckBoxGovermentClick
    end
    object CheckBoxAnarchy: TCheckBox
      Left = 8
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Anarchy'
      TabOrder = 1
    end
    object CheckBoxDictatorship: TCheckBox
      Left = 88
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Dictatorship'
      TabOrder = 2
    end
    object CheckBoxMonarchy: TCheckBox
      Left = 176
      Top = 24
      Width = 73
      Height = 17
      Caption = 'Monarchy'
      TabOrder = 3
    end
    object CheckBoxRepublic: TCheckBox
      Left = 8
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Republic'
      TabOrder = 4
    end
    object CheckBoxDemocracy: TCheckBox
      Left = 88
      Top = 48
      Width = 81
      Height = 17
      Caption = 'Democracy'
      TabOrder = 5
    end
  end
  object GroupBox3: TGroupBox
    Left = 7
    Top = 112
    Width = 322
    Height = 71
    Caption = '        Owner'
    TabOrder = 5
    object CheckBoxOwner: TCheckBox
      Left = 11
      Top = -1
      Width = 16
      Height = 17
      TabOrder = 0
      OnClick = CheckBoxOwnerClick
    end
    object CheckBoxOwnerMaloc: TCheckBox
      Left = 8
      Top = 22
      Width = 57
      Height = 17
      Caption = 'Maloc'
      TabOrder = 1
    end
    object CheckBoxOwnerPeleng: TCheckBox
      Left = 80
      Top = 22
      Width = 57
      Height = 17
      Caption = 'Peleng'
      TabOrder = 2
    end
    object CheckBoxOwnerPeople: TCheckBox
      Left = 160
      Top = 22
      Width = 57
      Height = 17
      Caption = 'People'
      TabOrder = 3
    end
    object CheckBoxOwnerFei: TCheckBox
      Left = 8
      Top = 46
      Width = 65
      Height = 17
      Caption = 'Fei'
      TabOrder = 4
    end
    object CheckBoxOwnerGaal: TCheckBox
      Left = 80
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Gaal'
      TabOrder = 5
    end
    object CheckBoxOwnerKling: TCheckBox
      Left = 160
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Kling'
      TabOrder = 6
    end
    object CheckBoxOwnerNone: TCheckBox
      Left = 240
      Top = 46
      Width = 49
      Height = 17
      Caption = 'None'
      TabOrder = 7
    end
    object CheckBoxOwnerByPlayer: TCheckBox
      Left = 241
      Top = 22
      Width = 72
      Height = 17
      Caption = 'as Player'
      TabOrder = 8
    end
  end
  object GroupBox4: TGroupBox
    Left = 7
    Top = 37
    Width = 322
    Height = 71
    Caption = '        Race'
    TabOrder = 6
    object CheckBoxRace: TCheckBox
      Left = 11
      Top = -1
      Width = 16
      Height = 17
      TabOrder = 0
      OnClick = CheckBoxRaceClick
    end
    object CheckBoxRaceMaloc: TCheckBox
      Left = 8
      Top = 22
      Width = 57
      Height = 17
      Caption = 'Maloc'
      TabOrder = 1
    end
    object CheckBoxRacePeleng: TCheckBox
      Left = 88
      Top = 22
      Width = 57
      Height = 17
      Caption = 'Peleng'
      TabOrder = 2
    end
    object CheckBoxRacePeople: TCheckBox
      Left = 176
      Top = 22
      Width = 57
      Height = 17
      Caption = 'People'
      TabOrder = 3
    end
    object CheckBoxRaceFei: TCheckBox
      Left = 8
      Top = 46
      Width = 65
      Height = 17
      Caption = 'Fei'
      TabOrder = 4
    end
    object CheckBoxRaceGaal: TCheckBox
      Left = 88
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Gaal'
      TabOrder = 5
    end
  end
  object EditRange: TEdit
    Left = 96
    Top = 320
    Width = 233
    Height = 21
    TabOrder = 7
  end
  object ComboBoxDialog: TComboBox
    Left = 96
    Top = 352
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
  end
end
