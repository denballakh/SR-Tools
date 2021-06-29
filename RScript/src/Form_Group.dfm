object FormGroup: TFormGroup
  Left = 483
  Top = 351
  BorderStyle = bsDialog
  Caption = 'Group'
  ClientHeight = 556
  ClientWidth = 376
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
    Top = 275
    Width = 103
    Height = 13
    Caption = 'Count ship (min,max) :'
  end
  object Label3: TLabel
    Left = 219
    Top = 307
    Width = 47
    Height = 13
    Caption = 'Weapon :'
  end
  object Label4: TLabel
    Left = 8
    Top = 339
    Width = 60
    Height = 13
    Caption = 'CargoHook :'
  end
  object Label5: TLabel
    Left = 200
    Top = 340
    Width = 67
    Height = 13
    Caption = 'Empty space :'
  end
  object Label6: TLabel
    Left = 232
    Top = 275
    Width = 35
    Height = 13
    Caption = 'Friend :'
  end
  object Label7: TLabel
    Left = 8
    Top = 307
    Width = 84
    Height = 13
    Caption = 'Speed (min,max) :'
  end
  object Label11: TLabel
    Left = 8
    Top = 427
    Width = 81
    Height = 13
    Caption = 'Rating (min,max):'
  end
  object Label12: TLabel
    Left = 200
    Top = 427
    Width = 81
    Height = 13
    Caption = 'Rating (min,max):'
  end
  object Label13: TLabel
    Left = 8
    Top = 458
    Width = 39
    Height = 13
    Caption = 'Dialog : '
  end
  object Label14: TLabel
    Left = 200
    Top = 459
    Width = 80
    Height = 13
    Caption = 'Max dist search :'
  end
  object Label15: TLabel
    Left = 8
    Top = 490
    Width = 87
    Height = 13
    Caption = 'Strange (min,max):'
  end
  object BitBtn2: TBitBtn
    Left = 264
    Top = 518
    Width = 75
    Height = 25
    TabOrder = 0
    Kind = bkCancel
  end
  object BitBtn1: TBitBtn
    Left = 184
    Top = 518
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
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
  object GroupBox3: TGroupBox
    Left = 7
    Top = 33
    Width = 362
    Height = 71
    Caption = '        Owner'
    TabOrder = 2
    object CheckBoxOwner: TCheckBox
      Left = 12
      Top = -1
      Width = 17
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
      Left = 88
      Top = 22
      Width = 57
      Height = 17
      Caption = 'Peleng'
      TabOrder = 2
    end
    object CheckBoxOwnerPeople: TCheckBox
      Left = 168
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
      Left = 88
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Gaal'
      TabOrder = 5
    end
    object CheckBoxOwnerKling: TCheckBox
      Left = 168
      Top = 46
      Width = 57
      Height = 17
      Caption = 'Kling'
      TabOrder = 6
    end
    object CheckBoxOwnerByPlayer: TCheckBox
      Left = 248
      Top = 46
      Width = 97
      Height = 17
      Caption = 'as Player'
      TabOrder = 7
    end
  end
  object EditName: TEdit
    Left = 56
    Top = 8
    Width = 313
    Height = 21
    TabOrder = 3
  end
  object EditCntShip: TEdit
    Left = 120
    Top = 272
    Width = 89
    Height = 21
    TabOrder = 4
  end
  object ComboBoxWeapon: TComboBox
    Left = 272
    Top = 304
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
    Items.Strings = (
      ''
      'Yes'
      'No')
  end
  object ComboBoxCargoHook: TComboBox
    Left = 72
    Top = 336
    Width = 113
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      ''
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7')
  end
  object EditEmptySpace: TEdit
    Left = 272
    Top = 336
    Width = 97
    Height = 21
    TabOrder = 7
  end
  object CheckBoxPlayer: TCheckBox
    Left = 8
    Top = 520
    Width = 73
    Height = 17
    Caption = 'Add Player'
    TabOrder = 8
  end
  object ComboBoxFriend: TComboBox
    Left = 272
    Top = 272
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 9
    Items.Strings = (
      'Free'
      'Help')
  end
  object EditSpeed: TEdit
    Left = 96
    Top = 304
    Width = 105
    Height = 21
    TabOrder = 10
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 365
    Width = 361
    Height = 49
    Caption = 'Status (min,max)'
    TabOrder = 11
    object Label9: TLabel
      Left = 8
      Top = 24
      Width = 37
      Height = 13
      Caption = 'Trader :'
    end
    object Label8: TLabel
      Left = 124
      Top = 24
      Width = 40
      Height = 13
      Caption = 'Warrior :'
    end
    object Label10: TLabel
      Left = 247
      Top = 24
      Width = 33
      Height = 13
      Caption = 'Pirate :'
    end
    object EditSTrader: TEdit
      Left = 48
      Top = 20
      Width = 65
      Height = 21
      TabOrder = 0
    end
    object EditSWarrior: TEdit
      Left = 168
      Top = 20
      Width = 65
      Height = 21
      TabOrder = 1
    end
    object EditSPirate: TEdit
      Left = 286
      Top = 20
      Width = 67
      Height = 21
      TabOrder = 2
    end
  end
  object EditRating: TEdit
    Left = 96
    Top = 424
    Width = 81
    Height = 21
    TabOrder = 12
  end
  object EditScore: TEdit
    Left = 288
    Top = 424
    Width = 81
    Height = 21
    TabOrder = 13
  end
  object ComboBoxDialog: TComboBox
    Left = 56
    Top = 456
    Width = 121
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 14
  end
  object GroupBox4: TGroupBox
    Left = 7
    Top = 104
    Width = 362
    Height = 153
    Caption = '        Type'
    TabOrder = 15
    object Label16: TLabel
      Left = 320
      Top = 49
      Width = 27
      Height = 13
      Hint = 'RC,PB,WB,SC'
      Caption = 'Ruins'
    end
    object Label17: TLabel
      Left = 32
      Top = 72
      Width = 32
      Height = 13
      Caption = 'Blazer:'
    end
    object Label18: TLabel
      Left = 32
      Top = 96
      Width = 29
      Height = 13
      Caption = 'Keller:'
    end
    object Label19: TLabel
      Left = 32
      Top = 120
      Width = 34
      Height = 13
      Caption = 'Terron:'
    end
    object CheckBoxType: TCheckBox
      Left = 11
      Top = -1
      Width = 16
      Height = 17
      TabOrder = 0
      OnClick = CheckBoxTypeClick
    end
    object CheckBoxRanger: TCheckBox
      Left = 8
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Ranger'
      TabOrder = 1
    end
    object CheckBoxWarrior: TCheckBox
      Left = 80
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Warrior'
      TabOrder = 2
    end
    object CheckBoxPirate: TCheckBox
      Left = 136
      Top = 24
      Width = 57
      Height = 17
      Caption = 'Pirate'
      TabOrder = 3
    end
    object CheckBoxTransport: TCheckBox
      Left = 8
      Top = 48
      Width = 73
      Height = 17
      Caption = 'Transport'
      TabOrder = 4
    end
    object CheckBoxLiner: TCheckBox
      Left = 80
      Top = 48
      Width = 57
      Height = 17
      Caption = 'Liner'
      TabOrder = 5
    end
    object CheckBoxDiplomat: TCheckBox
      Left = 136
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Diplomat'
      TabOrder = 6
    end
    object CheckBoxTranclucator: TCheckBox
      Left = 208
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Tranclucator'
      TabOrder = 7
    end
    object EditRuins: TEdit
      Left = 208
      Top = 46
      Width = 105
      Height = 21
      TabOrder = 8
    end
    object CheckBoxK0Blazer: TCheckBox
      Left = 80
      Top = 72
      Width = 41
      Height = 17
      Caption = 'K0'
      TabOrder = 9
    end
    object CheckBoxK1Blazer: TCheckBox
      Left = 120
      Top = 72
      Width = 33
      Height = 17
      Caption = 'K1'
      TabOrder = 10
    end
    object CheckBoxK2Blazer: TCheckBox
      Left = 160
      Top = 72
      Width = 41
      Height = 17
      Caption = 'K2'
      TabOrder = 11
    end
    object CheckBoxK3Blazer: TCheckBox
      Left = 200
      Top = 72
      Width = 41
      Height = 17
      Caption = 'K3'
      TabOrder = 12
    end
    object CheckBoxK4Blazer: TCheckBox
      Left = 240
      Top = 72
      Width = 41
      Height = 17
      Caption = 'K4'
      TabOrder = 13
    end
    object CheckBoxK5Blazer: TCheckBox
      Left = 280
      Top = 72
      Width = 41
      Height = 17
      Caption = 'K5'
      TabOrder = 14
    end
    object CheckBoxK0Keller: TCheckBox
      Left = 80
      Top = 96
      Width = 41
      Height = 17
      Caption = 'K0'
      TabOrder = 15
    end
    object CheckBoxK1Keller: TCheckBox
      Left = 120
      Top = 96
      Width = 33
      Height = 17
      Caption = 'K1'
      TabOrder = 16
    end
    object CheckBoxK2Keller: TCheckBox
      Left = 160
      Top = 96
      Width = 41
      Height = 17
      Caption = 'K2'
      TabOrder = 17
    end
    object CheckBoxK3Keller: TCheckBox
      Left = 200
      Top = 96
      Width = 41
      Height = 17
      Caption = 'K3'
      TabOrder = 18
    end
    object CheckBoxK4Keller: TCheckBox
      Left = 240
      Top = 96
      Width = 41
      Height = 17
      Caption = 'K4'
      TabOrder = 19
    end
    object CheckBoxK5Keller: TCheckBox
      Left = 280
      Top = 96
      Width = 41
      Height = 17
      Caption = 'K5'
      TabOrder = 20
    end
    object CheckBoxK0Terron: TCheckBox
      Left = 80
      Top = 120
      Width = 41
      Height = 17
      Caption = 'K0'
      TabOrder = 21
    end
    object CheckBoxK1Terron: TCheckBox
      Left = 120
      Top = 120
      Width = 33
      Height = 17
      Caption = 'K1'
      TabOrder = 22
    end
    object CheckBoxK2Terron: TCheckBox
      Left = 160
      Top = 120
      Width = 41
      Height = 17
      Caption = 'K2'
      TabOrder = 23
    end
    object CheckBoxK3Terron: TCheckBox
      Left = 200
      Top = 120
      Width = 41
      Height = 17
      Caption = 'K3'
      TabOrder = 24
    end
    object CheckBoxK4Terron: TCheckBox
      Left = 240
      Top = 120
      Width = 41
      Height = 17
      Caption = 'K4'
      TabOrder = 25
    end
    object CheckBoxK5Terron: TCheckBox
      Left = 280
      Top = 120
      Width = 41
      Height = 17
      Caption = 'K5'
      TabOrder = 26
    end
  end
  object EditDistSearch: TEdit
    Left = 288
    Top = 456
    Width = 81
    Height = 21
    TabOrder = 16
  end
  object EditStrength: TEdit
    Left = 104
    Top = 488
    Width = 265
    Height = 21
    TabOrder = 17
  end
end
