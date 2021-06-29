object FormMain: TFormMain
  Left = 192
  Top = 105
  Width = 750
  Height = 501
  Caption = 'Ranger ABUnit'
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 750
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3D: TPanel
    Left = 0
    Top = 25
    Width = 565
    Height = 384
    Align = alClient
    BevelOuter = bvNone
    Color = clNone
    TabOrder = 0
    OnMouseDown = Panel3DMouseDown
    OnMouseMove = Panel3DMouseMove
    OnMouseUp = Panel3DMouseUp
  end
  object Panel1: TPanel
    Left = 565
    Top = 25
    Width = 177
    Height = 384
    Align = alRight
    TabOrder = 1
    object NInfo: TNotebook
      Left = 1
      Top = 1
      Width = 175
      Height = 382
      Align = alClient
      PageIndex = 5
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'Main'
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Point'
        object Label1: TLabel
          Left = 8
          Top = 10
          Width = 21
          Height = 13
          Caption = 'Pos:'
        end
        object Label14: TLabel
          Left = 8
          Top = 146
          Width = 12
          Height = 13
          Caption = 'Id:'
        end
        object EditPointPos: TEdit
          Left = 32
          Top = 8
          Width = 137
          Height = 21
          TabOrder = 0
          OnKeyDown = EditPointPosKeyDown
        end
        object ButtonPointDelete: TButton
          Left = 96
          Top = 176
          Width = 75
          Height = 25
          Caption = 'Delete'
          TabOrder = 1
          OnClick = ButtonPointDeleteClick
        end
        object GroupBox2: TGroupBox
          Left = 8
          Top = 40
          Width = 161
          Height = 97
          Caption = ' Port '
          TabOrder = 2
          object Label2: TLabel
            Left = 8
            Top = 42
            Width = 27
            Height = 13
            Caption = 'Type:'
          end
          object Label3: TLabel
            Left = 8
            Top = 18
            Width = 12
            Height = 13
            Caption = 'Id:'
          end
          object Label4: TLabel
            Left = 8
            Top = 66
            Width = 23
            Height = 13
            Caption = 'Link:'
          end
          object EditPointPortType: TEdit
            Left = 40
            Top = 40
            Width = 113
            Height = 21
            TabOrder = 1
            OnChange = EditPointPortIdChange
          end
          object EditPointPortId: TEdit
            Left = 40
            Top = 16
            Width = 113
            Height = 21
            TabOrder = 0
            OnChange = EditPointPortIdChange
          end
          object EditPointPortLink: TEdit
            Left = 40
            Top = 64
            Width = 113
            Height = 21
            TabOrder = 2
            OnChange = EditPointPortIdChange
          end
        end
        object EditPointId: TEdit
          Left = 24
          Top = 144
          Width = 145
          Height = 21
          TabOrder = 3
          OnChange = EditPointIdChange
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Triangle'
        object ButtonTriDelete: TButton
          Left = 96
          Top = 160
          Width = 73
          Height = 25
          Caption = 'Delete'
          TabOrder = 0
          OnClick = ButtonTriDeleteClick
        end
        object ButtonTriInvert: TButton
          Left = 8
          Top = 160
          Width = 81
          Height = 25
          Caption = 'Invert'
          TabOrder = 1
          OnClick = ButtonTriInvertClick
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 8
          Width = 161
          Height = 73
          Caption = ' Texture '
          TabOrder = 2
          object EditTriTexture: TComboBox
            Left = 8
            Top = 16
            Width = 145
            Height = 21
            Style = csDropDownList
            DropDownCount = 20
            ItemHeight = 13
            TabOrder = 0
            OnSelect = EditTriTextureSelect
          end
          object ButtonTriLoad: TButton
            Left = 88
            Top = 40
            Width = 65
            Height = 25
            Caption = 'Load'
            TabOrder = 1
            OnClick = ButtonTriLoadClick
          end
          object ButtonTriClear: TButton
            Left = 8
            Top = 40
            Width = 65
            Height = 25
            Caption = 'Clear'
            TabOrder = 2
            OnClick = ButtonTriClearClick
          end
        end
        object EditTriBackFace: TCheckBox
          Left = 8
          Top = 88
          Width = 161
          Height = 17
          Caption = 'Back face'
          TabOrder = 3
          OnClick = EditTriBackFaceClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'TriPoint'
        object Label8: TLabel
          Left = 8
          Top = 10
          Width = 42
          Height = 13
          Caption = 'Tex UV :'
        end
        object GroupBox4: TGroupBox
          Left = 8
          Top = 32
          Width = 161
          Height = 129
          Caption = ' Color '
          TabOrder = 0
          object Label9: TLabel
            Left = 8
            Top = 42
            Width = 13
            Height = 13
            Caption = 'A :'
          end
          object Label10: TLabel
            Left = 8
            Top = 61
            Width = 14
            Height = 13
            Caption = 'R :'
          end
          object Label11: TLabel
            Left = 8
            Top = 80
            Width = 14
            Height = 13
            Caption = 'G :'
          end
          object Label12: TLabel
            Left = 8
            Top = 100
            Width = 13
            Height = 13
            Caption = 'B :'
          end
          object ButtonTPColorKey: TSpeedButton
            Left = 131
            Top = 16
            Width = 22
            Height = 21
            Caption = 'K'
            OnClick = ButtonTPColorKeyClick
          end
          object EditTPColor: TEdit
            Left = 8
            Top = 16
            Width = 119
            Height = 21
            TabOrder = 0
            OnKeyDown = EditTPColorKeyDown
          end
          object ScrollBarTPA: TScrollBar
            Left = 32
            Top = 40
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 1
            OnChange = ScrollBarTPAChange
          end
          object ScrollBarTPR: TScrollBar
            Left = 32
            Top = 60
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 2
            OnChange = ScrollBarTPAChange
          end
          object ScrollBarTPG: TScrollBar
            Left = 32
            Top = 80
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 3
            OnChange = ScrollBarTPAChange
          end
          object ScrollBarTPB: TScrollBar
            Left = 32
            Top = 100
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 4
            OnChange = ScrollBarTPAChange
          end
        end
        object EditTPTex: TComboBox
          Left = 56
          Top = 8
          Width = 113
          Height = 21
          ItemHeight = 13
          TabOrder = 1
          OnKeyDown = EditTPTexKeyDown
          OnSelect = EditTPTexSelect
          Items.Strings = (
            '0.000,0.0000'
            '1.000,0.0000'
            '0.000,1.0000'
            '1.000,1.0000')
        end
        object ButtonTPCopy: TBitBtn
          Left = 8
          Top = 184
          Width = 75
          Height = 25
          Caption = 'Copy'
          TabOrder = 2
          OnClick = ButtonTPCopyClick
        end
        object ButtonTPPaste: TBitBtn
          Left = 88
          Top = 184
          Width = 75
          Height = 25
          Caption = 'Paste'
          TabOrder = 3
          OnClick = ButtonTPPasteClick
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Line'
        object Label15: TLabel
          Left = 8
          Top = 10
          Width = 27
          Height = 13
          Caption = 'Type:'
        end
        object ButtonLineDelete: TButton
          Left = 96
          Top = 136
          Width = 75
          Height = 25
          Caption = 'Delete'
          TabOrder = 0
          OnClick = ButtonLineDeleteClick
        end
        object EditLineType: TEdit
          Left = 40
          Top = 8
          Width = 129
          Height = 21
          TabOrder = 1
          OnChange = EditLineTypeChange
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'LinePoint'
        object GroupBox3: TGroupBox
          Left = 8
          Top = 8
          Width = 161
          Height = 129
          Caption = 'Color'
          TabOrder = 0
          object ButtonLPColorKey: TSpeedButton
            Left = 131
            Top = 16
            Width = 22
            Height = 21
            Caption = 'K'
            OnClick = ButtonLPColorKeyClick
          end
          object Label5: TLabel
            Left = 8
            Top = 42
            Width = 13
            Height = 13
            Caption = 'A :'
          end
          object Label6: TLabel
            Left = 8
            Top = 61
            Width = 14
            Height = 13
            Caption = 'R :'
          end
          object Label7: TLabel
            Left = 8
            Top = 80
            Width = 14
            Height = 13
            Caption = 'G :'
          end
          object Label13: TLabel
            Left = 8
            Top = 100
            Width = 13
            Height = 13
            Caption = 'B :'
          end
          object EditLPColor: TEdit
            Left = 8
            Top = 16
            Width = 119
            Height = 21
            TabOrder = 0
            OnKeyDown = EditLPColorKeyDown
          end
          object ScrollBarLPB: TScrollBar
            Left = 32
            Top = 100
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 1
            OnChange = ScrollBarLPAChange
          end
          object ScrollBarLPG: TScrollBar
            Left = 32
            Top = 80
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 2
            OnChange = ScrollBarLPAChange
          end
          object ScrollBarLPR: TScrollBar
            Left = 32
            Top = 60
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 3
            OnChange = ScrollBarLPAChange
          end
          object ScrollBarLPA: TScrollBar
            Left = 32
            Top = 40
            Width = 121
            Height = 16
            Max = 255
            PageSize = 0
            TabOrder = 4
            OnChange = ScrollBarLPAChange
          end
        end
        object ButtonLPCopy: TButton
          Left = 8
          Top = 160
          Width = 75
          Height = 25
          Caption = 'Copy'
          TabOrder = 1
          OnClick = ButtonLPCopyClick
        end
        object ButtonLPPaste: TButton
          Left = 88
          Top = 160
          Width = 75
          Height = 25
          Caption = 'Paste'
          TabOrder = 2
          OnClick = ButtonLPPasteClick
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 409
    Width = 742
    Height = 46
    Align = alBottom
    TabOrder = 2
    object ITime: TImage
      Left = 6
      Top = 29
      Width = 579
      Height = 16
    end
    object Edit1: TEdit
      Left = 680
      Top = 5
      Width = 49
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
      Visible = False
    end
    object TBTime: TTrackBar
      Left = 3
      Top = 1
      Width = 585
      Height = 27
      Max = 10000
      Orientation = trHorizontal
      PageSize = 1000
      Frequency = 100
      Position = 1000
      SelEnd = 0
      SelStart = 0
      TabOrder = 1
      TickMarks = tmBottomRight
      TickStyle = tsAuto
      OnChange = TBTimeChange
    end
    object CheckBoxPlay: TCheckBox
      Left = 594
      Top = 3
      Width = 41
      Height = 17
      Caption = 'Play'
      TabOrder = 2
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 742
    Height = 25
    Align = alTop
    TabOrder = 3
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 168
    Top = 80
  end
  object OpenDialogTexture: TOpenDialog
    Filter = '*.bmp;*.jpg;*.png;*.psd;*.gi|*.bmp;*.jpg;*.png;*.psd;*.gi'
    Left = 520
    Top = 40
  end
  object MainMenu1: TMainMenu
    Left = 112
    Top = 32
    object File1: TMenuItem
      Caption = 'File'
      object Load1: TMenuItem
        Caption = 'Load ...'
        OnClick = Load1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As ...'
        OnClick = SaveAs1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MM_File_Clear: TMenuItem
        Caption = 'Clear'
        OnClick = MM_File_ClearClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object Edit2: TMenuItem
      Caption = 'Edit'
      object MM_Edir_Group: TMenuItem
        Caption = 'Group'
        OnClick = MM_Edir_GroupClick
      end
    end
    object About1: TMenuItem
      Caption = 'Help'
      object About2: TMenuItem
        Caption = 'About ...'
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.txt'
    Filter = '*.txt|*.txt'
    Left = 64
    Top = 144
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.txt'
    Filter = '*.txt|*.txt'
    Left = 96
    Top = 144
  end
end
