object FormOptions: TFormOptions
  Left = 545
  Top = 119
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 228
  ClientWidth = 361
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
  object BitBtn1: TBitBtn
    Left = 184
    Top = 200
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 264
    Top = 200
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 345
    Height = 185
    ActivePage = TabSheet1
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Path'
      object Label1: TLabel
        Left = 8
        Top = 10
        Width = 66
        Height = 13
        Caption = 'Relative path:'
      end
      object Label2: TLabel
        Left = 8
        Top = 42
        Width = 67
        Height = 13
        Caption = 'Rangers path:'
      end
      object EditUnitPath: TEdit
        Left = 80
        Top = 8
        Width = 249
        Height = 21
        TabOrder = 0
      end
      object EditRangersPath: TEdit
        Left = 80
        Top = 40
        Width = 249
        Height = 21
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'WorldLine'
      ImageIndex = 1
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Count:'
      end
      object Label4: TLabel
        Left = 8
        Top = 42
        Width = 53
        Height = 13
        Caption = 'Front color:'
      end
      object Label5: TLabel
        Left = 8
        Top = 74
        Width = 54
        Height = 13
        Caption = 'Back color:'
      end
      object EditWLCount: TEdit
        Left = 48
        Top = 8
        Width = 281
        Height = 21
        TabOrder = 0
      end
      object EditWLFront: TEdit
        Left = 72
        Top = 40
        Width = 257
        Height = 21
        TabOrder = 1
      end
      object EditWLBack: TEdit
        Left = 72
        Top = 72
        Width = 257
        Height = 21
        TabOrder = 2
      end
    end
  end
end
