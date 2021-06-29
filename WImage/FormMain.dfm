object Form_Main: TForm_Main
  Left = 190
  Top = 107
  Width = 753
  Height = 552
  Caption = 'WImage'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 28
    Width = 533
    Height = 452
    Align = alClient
    TabOrder = 0
    OnResize = Panel1Resize
    object ImageR: TImage
      Left = 1
      Top = 1
      Width = 518
      Height = 434
      Align = alClient
      OnMouseDown = ImageRMouseDown
      OnMouseMove = ImageRMouseMove
      OnMouseUp = ImageRMouseUp
    end
    object ScrollBar1: TScrollBar
      Left = 1
      Top = 435
      Width = 531
      Height = 16
      Align = alBottom
      PageSize = 0
      TabOrder = 0
      TabStop = False
    end
    object ScrollBar2: TScrollBar
      Left = 519
      Top = 1
      Width = 13
      Height = 434
      Align = alRight
      Kind = sbVertical
      PageSize = 0
      TabOrder = 1
      TabStop = False
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 28
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 626
      Top = 3
      Width = 50
      Height = 22
      Caption = 'Rander'
      OnClick = SpeedButton1Click
    end
    object SBBufLeft: TSpeedButton
      Left = 3
      Top = 2
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = SBBufLeftClick
    end
    object SBBufRight: TSpeedButton
      Left = 72
      Top = 2
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = SBBufRightClick
    end
    object LBuf: TLabel
      Left = 29
      Top = 7
      Width = 41
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'LBuf'
      PopupMenu = PopupMenuBuf
    end
    object RxSpinEditScale: TRxSpinEdit
      Left = 528
      Top = 4
      Width = 45
      Height = 21
      Decimal = 0
      EditorEnabled = False
      MaxValue = 32
      MinValue = 1
      Value = 1
      TabOrder = 0
      OnChange = RxSpinEditScaleChange
    end
    object CBAction: TComboBox
      Left = 381
      Top = 4
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      Visible = False
      Items.Strings = (
        'World'
        'Move')
    end
    object CBTypeShow: TComboBox
      Left = 574
      Top = 4
      Width = 51
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = CBTypeShowChange
      Items.Strings = (
        'RGB'
        'R'
        'G'
        'B'
        'A')
    end
  end
  object Panel3: TPanel
    Left = 536
    Top = 28
    Width = 209
    Height = 452
    Align = alRight
    TabOrder = 2
    object SGListHist: TStringGrid
      Left = 1
      Top = 1
      Width = 207
      Height = 348
      TabStop = False
      Align = alClient
      ColCount = 1
      DefaultColWidth = 32
      DefaultRowHeight = 15
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing]
      TabOrder = 0
      OnMouseDown = SGListHistMouseDown
      OnSelectCell = SGListHistSelectCell
      OnSetEditText = SGListHistSetEditText
    end
    object Panel5: TPanel
      Left = 1
      Top = 352
      Width = 207
      Height = 99
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      OnResize = Panel5Resize
      object ButtonHistUp: TSpeedButton
        Left = 8
        Top = 5
        Width = 40
        Height = 22
        Caption = 'Up'
        OnClick = ButtonHistUpClick
      end
      object ButtonHistDown: TSpeedButton
        Left = 48
        Top = 5
        Width = 40
        Height = 22
        Caption = 'Down'
        OnClick = ButtonHistDownClick
      end
      object ButtonHistCopy: TSpeedButton
        Left = 94
        Top = 5
        Width = 40
        Height = 22
        Caption = 'Copy'
        OnClick = ButtonHistCopyClick
      end
      object ButtonHistDel: TSpeedButton
        Left = 139
        Top = 5
        Width = 40
        Height = 22
        Caption = 'Del'
        OnClick = ButtonHistDelClick
      end
      object ButtonHistDelAll: TSpeedButton
        Left = 139
        Top = 29
        Width = 40
        Height = 22
        Caption = 'Del all'
        OnClick = ButtonHistDelAllClick
      end
      object CBRenderCur: TCheckBox
        Left = 8
        Top = 34
        Width = 97
        Height = 17
        Caption = 'Render current'
        TabOrder = 0
        OnClick = CBRenderCurClick
      end
      object CheckBoxPlay: TCheckBox
        Left = 8
        Top = 66
        Width = 49
        Height = 17
        Caption = 'Play'
        TabOrder = 1
      end
      object EditPlayInterval: TEdit
        Left = 56
        Top = 64
        Width = 123
        Height = 21
        TabOrder = 2
        Text = '50'
        OnChange = EditPlayIntervalChange
      end
    end
    object RxSplitter1: TRxSplitter
      Left = 1
      Top = 349
      Width = 207
      Height = 3
      ControlFirst = Panel5
      Align = alBottom
      BevelOuter = bvLowered
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 480
    Width = 745
    Height = 26
    Align = alBottom
    TabOrder = 3
    object Label1: TLabel
      Left = 4
      Top = 6
      Width = 30
      Height = 13
      Caption = 'RGBA'
    end
    object X: TLabel
      Left = 134
      Top = 6
      Width = 7
      Height = 13
      Caption = 'X'
    end
    object Label2: TLabel
      Left = 218
      Top = 5
      Width = 7
      Height = 13
      Caption = 'Y'
    end
    object Label3: TLabel
      Left = 300
      Top = 6
      Width = 20
      Height = 13
      Caption = 'Size'
    end
    object Label4: TLabel
      Left = 414
      Top = 6
      Width = 55
      Height = 13
      Caption = 'Pos mouse:'
    end
    object EditRGBA: TEdit
      Left = 40
      Top = 2
      Width = 89
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object EditX: TEdit
      Left = 147
      Top = 2
      Width = 63
      Height = 21
      TabOrder = 1
      OnKeyDown = EditXKeyDown
    end
    object EditY: TEdit
      Left = 231
      Top = 2
      Width = 63
      Height = 21
      TabOrder = 2
      OnKeyDown = EditXKeyDown
    end
    object EditSize: TEdit
      Left = 325
      Top = 2
      Width = 84
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object EditPosMouse: TEdit
      Left = 473
      Top = 2
      Width = 121
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
  end
  object RxSplitter2: TRxSplitter
    Left = 533
    Top = 28
    Width = 3
    Height = 452
    ControlFirst = Panel3
    Align = alRight
    BevelOuter = bvLowered
  end
  object MainMenu1: TMainMenu
    Left = 16
    Top = 44
    object Open1: TMenuItem
      Caption = 'File'
      object MMFile_AddImage: TMenuItem
        Caption = 'Add image'
        OnClick = MMFile_AddImageClick
      end
      object MMFile_SaveImage: TMenuItem
        Caption = 'Save image'
        OnClick = MMFile_SaveImageClick
      end
      object MMFile_SaveImageWAlpha: TMenuItem
        Caption = 'Save image without alpha'
        OnClick = MMFile_SaveImageWAlphaClick
      end
      object MMFile_SaveGI: TMenuItem
        Caption = 'Save gi'
        OnClick = MMFile_SaveGIClick
      end
      object MMFile_SaveGAI: TMenuItem
        Caption = 'Save gai'
        OnClick = MMFile_SaveGAIClick
      end
      object MMFile_LoadGAI: TMenuItem
        Caption = 'Load gai'
        OnClick = MMFile_LoadGAIClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MMFile_LoadProject: TMenuItem
        Caption = 'Load project'
        OnClick = MMFile_LoadProjectClick
      end
      object MMFile_SaveProject: TMenuItem
        Caption = 'Save project'
        OnClick = MMFile_SaveProjectClick
      end
    end
    object Splitline1: TMenuItem
      Caption = 'SplitLine'
      object MMSL_DivX: TMenuItem
        Caption = 'Div X'
        OnClick = MMSL_DivXClick
      end
      object MMSL_DivY: TMenuItem
        Caption = 'Div Y'
        OnClick = MMSL_DivYClick
      end
      object MMSL_DivForm: TMenuItem
        Caption = 'Div form'
        OnClick = MMSL_DivFormClick
      end
      object MMSL_Delete: TMenuItem
        Caption = 'Delete'
        OnClick = MMSL_DeleteClick
      end
      object MMSL_Clear: TMenuItem
        Caption = 'Clear'
        OnClick = MMSL_ClearClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MMSL_SplitImage: TMenuItem
        Caption = 'Split image'
        OnClick = MMSL_SplitImageClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MMSL_UnionLeft: TMenuItem
        Caption = 'UnionLeft       <'
        OnClick = MMSL_UnionLeftClick
      end
      object MMSL_UnionRight: TMenuItem
        Caption = 'UnionRight     >'
        OnClick = MMSL_UnionLeftClick
      end
      object MMSL_UnionTop: TMenuItem
        Caption = 'UnionTop       ^'
        OnClick = MMSL_UnionLeftClick
      end
      object MMSL_UnionBottom: TMenuItem
        Caption = 'UnionBottom'
        OnClick = MMSL_UnionLeftClick
      end
    end
    object Utilite1: TMenuItem
      Caption = 'Image'
      object MMFilter_CutOffAlpha: TMenuItem
        Caption = 'Cut off by alpha'
        OnClick = MMFilter_CutOffAlphaClick
      end
      object MMFilter_FillAlpha: TMenuItem
        Caption = 'Fill by alpha'
        OnClick = MMFilter_FillAlphaClick
      end
      object MMFilter_Different: TMenuItem
        Caption = 'Different'
        OnClick = MMFilter_DifferentClick
      end
      object MMFilter_Operation: TMenuItem
        Caption = 'Operation'
        OnClick = MMFilter_OperationClick
      end
      object MMFilter_Rescale: TMenuItem
        Caption = 'Rescale'
        OnClick = MMFilter_RescaleClick
      end
    end
    object Select1: TMenuItem
      Caption = 'Select'
      object MMSelect_SelectByAlpha: TMenuItem
        Caption = 'Select by alpha'
        OnClick = MMSelect_SelectByAlphaClick
      end
      object MMSelect_SelectInverse: TMenuItem
        Caption = 'Inverse'
        OnClick = MMSelect_SelectInverseClick
      end
    end
    object Filter1: TMenuItem
      Caption = 'Filter'
      object MMFilter_CorrectImageByAlpha: TMenuItem
        Caption = 'Correct image by alpha'
        OnClick = MMFilter_CorrectImageByAlphaClick
      end
      object MMFilter_CorrectAlpha: TMenuItem
        Caption = 'Correct alpha'
        OnClick = MMFilter_CorrectAlphaClick
      end
      object MMFilter_Dithering16bit: TMenuItem
        Caption = 'Dithering 16 bit'
        OnClick = MMFilter_Dithering16bitClick
      end
      object MMFilter_Indexed8: TMenuItem
        Caption = 'Indexed8'
        OnClick = MMFilter_Indexed8Click
      end
      object MMFilter_AlphaIndexed8: TMenuItem
        Caption = 'AlphaIndexed8'
        OnClick = MMFilter_AlphaIndexed8Click
      end
    end
    object Utilite2: TMenuItem
      Caption = 'Tools'
      object MMTools_InfoProject: TMenuItem
        Caption = 'Info project'
        OnClick = MMTools_InfoProjectClick
      end
      object BuildGAIanim: TMenuItem
        Caption = 'Build GAI anim'
        OnClick = BuildGAIanimClick
      end
      object BuildGAIExanim: TMenuItem
        Caption = 'Build GAIEx anim'
        OnClick = BuildGAIExanimClick
      end
      object BuildGAIgroup: TMenuItem
        Caption = 'Build GAI group'
        OnClick = BuildGAIgroupClick
      end
      object MMTools_Script: TMenuItem
        Caption = 'Script'
        OnClick = MMTools_ScriptClick
      end
    end
  end
  object OpenDialogFile: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 56
    Top = 44
  end
  object PopupMenuBuf: TPopupMenu
    Left = 96
    Top = 44
    object PopupMenuBufClear: TMenuItem
      Caption = 'Clear'
      OnClick = PopupMenuBufClearClick
    end
    object PopupMenuBufDelCur: TMenuItem
      Caption = 'Delete current'
      OnClick = PopupMenuBufDelCurClick
    end
    object PopupMenuBufDelAll: TMenuItem
      Caption = 'Delete all'
      OnClick = PopupMenuBufDelAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PopupMenuBufAllImageClear: TMenuItem
      Caption = 'All image clear'
      OnClick = PopupMenuBufAllImageClearClick
    end
  end
  object SaveDialogFile: TSaveDialog
    Left = 56
    Top = 84
  end
  object OpenDialogGAI: TOpenDialog
    DefaultExt = '*.gai'
    Filter = '*.gai|*.gai'
    Left = 56
    Top = 124
  end
  object TimerPlay: TTimer
    Interval = 50
    OnTimer = TimerPlayTimer
    Left = 216
    Top = 236
  end
end
