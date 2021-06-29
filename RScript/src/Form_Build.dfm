object FormBuild: TFormBuild
  Left = 478
  Top = 246
  BorderStyle = bsDialog
  Caption = 'Build'
  ClientHeight = 433
  ClientWidth = 537
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
    Top = 42
    Width = 51
    Height = 13
    Caption = 'Out script :'
  end
  object Label2: TLabel
    Left = 8
    Top = 74
    Width = 43
    Height = 13
    Caption = 'Out text :'
  end
  object Label3: TLabel
    Left = 8
    Top = 10
    Width = 62
    Height = 13
    Caption = 'Script name :'
  end
  object BitBtn1: TBitBtn
    Left = 440
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = BitBtn1Click
    NumGlyphs = 2
  end
  object FilenameEditScript: TFilenameEdit
    Left = 80
    Top = 40
    Width = 449
    Height = 21
    NumGlyphs = 1
    TabOrder = 1
  end
  object EditTextSName: TEdit
    Left = 80
    Top = 8
    Width = 449
    Height = 21
    TabOrder = 2
  end
  object BitBtnBuild: TBitBtn
    Left = 360
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 3
    OnClick = BitBtnBuildClick
  end
  object Co: TMemo
    Left = 8
    Top = 192
    Width = 521
    Height = 233
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 4
  end
  object DGOutText: TDrawGrid
    Left = 80
    Top = 72
    Width = 385
    Height = 81
    ColCount = 2
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing]
    TabOrder = 5
    OnDrawCell = DGOutTextDrawCell
    OnGetEditText = DGOutTextGetEditText
    OnSetEditText = DGOutTextSetEditText
    ColWidths = (
      64
      293)
  end
  object Button1: TButton
    Left = 472
    Top = 72
    Width = 59
    Height = 25
    Caption = 'Add'
    TabOrder = 6
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 472
    Top = 96
    Width = 59
    Height = 25
    Caption = 'Delete'
    TabOrder = 7
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 472
    Top = 120
    Width = 59
    Height = 25
    Caption = 'Load'
    TabOrder = 8
    OnClick = Button3Click
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.txt'
    Filter = '*.txt|*.txt'
    Left = 440
    Top = 120
  end
end
