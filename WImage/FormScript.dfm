object Form_Script: TForm_Script
  Left = 174
  Top = 408
  Width = 442
  Height = 293
  Caption = 'Script'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 434
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 56
      Height = 33
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 4
        Width = 43
        Height = 13
        Caption = 'Script file'
      end
    end
    object FilenameScript: TFilenameEdit
      Left = 55
      Top = 4
      Width = 274
      Height = 21
      DefaultExt = '*.txt'
      Filter = '*.txt|*.txt'
      NumGlyphs = 1
      TabOrder = 1
    end
    object ButtonRun: TButton
      Left = 333
      Top = 2
      Width = 52
      Height = 25
      Caption = 'Run'
      TabOrder = 2
      OnClick = ButtonRunClick
    end
    object ButtonCancelRun: TButton
      Left = 384
      Top = 2
      Width = 46
      Height = 25
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = ButtonCancelRunClick
    end
  end
  object MemoConsole: TRichEdit
    Left = 0
    Top = 33
    Width = 434
    Height = 233
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object TimerConsole: TTimer
    Interval = 100
    OnTimer = TimerConsoleTimer
    Left = 248
    Top = 56
  end
end
