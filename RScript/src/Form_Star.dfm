object FormStar: TFormStar
  Left = 474
  Top = 523
  ActiveControl = BitBtn1
  BorderStyle = bsDialog
  Caption = 'Star'
  ClientHeight = 156
  ClientWidth = 223
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
    Top = 10
    Width = 34
    Height = 13
    Caption = 'Name :'
  end
  object Label2: TLabel
    Left = 8
    Top = 42
    Width = 66
    Height = 13
    Caption = 'Constellation :'
  end
  object Label3: TLabel
    Left = 10
    Top = 77
    Width = 37
    Height = 13
    Caption = 'Priority :'
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 128
    Top = 128
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object EditName: TEdit
    Left = 48
    Top = 8
    Width = 169
    Height = 21
    TabOrder = 2
  end
  object EditConst: TEdit
    Left = 80
    Top = 40
    Width = 137
    Height = 21
    TabOrder = 3
  end
  object EditPriority: TEdit
    Left = 64
    Top = 74
    Width = 57
    Height = 21
    TabOrder = 4
  end
  object CheckBoxSubspace: TCheckBox
    Left = 144
    Top = 74
    Width = 73
    Height = 17
    Caption = 'Subspace'
    TabOrder = 5
  end
  object CheckBoxNoKling: TCheckBox
    Left = 8
    Top = 104
    Width = 65
    Height = 17
    Caption = 'No kling'
    TabOrder = 6
  end
  object CheckBoxNoComeKling: TCheckBox
    Left = 88
    Top = 104
    Width = 97
    Height = 17
    Caption = 'No come kling'
    TabOrder = 7
  end
end
