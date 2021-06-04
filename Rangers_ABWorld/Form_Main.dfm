object FormMain: TFormMain
  Left = 191
  Top = 105
  Width = 634
  Height = 510
  Caption = 'Rangers ABWorld'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 440
    Top = 0
    Width = 178
    Height = 425
    Align = alRight
    TabOrder = 0
    object NotebookAction: TNotebook
      Left = 1
      Top = 1
      Width = 176
      Height = 423
      Align = alClient
      TabOrder = 0
      object TPage
        Left = 0
        Top = 0
        Caption = 'Main'
        object Label7: TLabel
          Left = 8
          Top = 10
          Width = 62
          Height = 13
          Caption = 'World radius:'
        end
        object EditMainWorldRadius: TEdit
          Left = 80
          Top = 8
          Width = 89
          Height = 21
          TabOrder = 0
          OnKeyDown = EditMainWorldRadiusKeyDown
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Unit'
        object Label3: TLabel
          Left = 8
          Top = 42
          Width = 55
          Height = 13
          Caption = 'Time offset:'
        end
        object Label4: TLabel
          Left = 8
          Top = 106
          Width = 51
          Height = 13
          Caption = 'Key group:'
        end
        object Label5: TLabel
          Left = 8
          Top = 8
          Width = 27
          Height = 13
          Caption = 'Type:'
        end
        object Label14: TLabel
          Left = 8
          Top = 74
          Width = 55
          Height = 13
          Caption = 'Time lengh:'
        end
        object EditUnitTimeOffset: TEdit
          Left = 72
          Top = 40
          Width = 97
          Height = 21
          TabOrder = 0
          OnChange = EditUnitTimeOffsetChange
        end
        object ComboBoxUnitKeyGroup: TComboBox
          Left = 72
          Top = 104
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = ComboBoxUnitKeyGroupChange
        end
        object ComboBoxUnitType: TComboBox
          Left = 72
          Top = 8
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 2
          OnChange = ComboBoxUnitTypeChange
          Items.Strings = (
            'None'
            'Exit 1'
            'Exit 2'
            'Exit 3')
        end
        object EditUnitTimeLength: TEdit
          Left = 72
          Top = 72
          Width = 97
          Height = 21
          TabOrder = 3
          OnChange = EditUnitTimeLengthChange
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'Zone'
        object Label6: TLabel
          Left = 8
          Top = 10
          Width = 30
          Height = 13
          Caption = 'Type :'
        end
        object Label8: TLabel
          Left = 8
          Top = 42
          Width = 39
          Height = 13
          Caption = 'Radius :'
        end
        object Label9: TLabel
          Left = 8
          Top = 74
          Width = 35
          Height = 13
          Caption = 'Graph :'
        end
        object Label11: TLabel
          Left = 8
          Top = 106
          Width = 47
          Height = 13
          Caption = 'Hitpoints :'
        end
        object Label12: TLabel
          Left = 8
          Top = 138
          Width = 31
          Height = 13
          Caption = 'Mass :'
        end
        object Label13: TLabel
          Left = 8
          Top = 170
          Width = 46
          Height = 13
          Caption = 'Damage :'
        end
        object ComboBoxZoneType: TComboBox
          Left = 56
          Top = 8
          Width = 113
          Height = 21
          Style = csDropDownList
          DropDownCount = 15
          ItemHeight = 13
          TabOrder = 0
          OnChange = ComboBoxZoneTypeChange
          Items.Strings = (
            'Path'
            'Entry'
            'Exit 1'
            'Exit 2'
            'Exit 3'
            'Wall'
            'Wall Exit 1'
            'Wall Exit 2'
            'Wall Exit 3'
            'Other'
            'Exclude')
        end
        object EditZoneRadius: TEdit
          Left = 56
          Top = 40
          Width = 113
          Height = 21
          TabOrder = 1
          OnChange = EditZoneRadiusChange
        end
        object ComboBoxZoneGraph: TComboBox
          Left = 56
          Top = 72
          Width = 113
          Height = 21
          ItemHeight = 0
          TabOrder = 2
          OnChange = ComboBoxZoneGraphChange
        end
        object EditZoneHitpoints: TEdit
          Left = 56
          Top = 104
          Width = 113
          Height = 21
          TabOrder = 3
          OnChange = EditZoneHitpointsChange
        end
        object EditZoneMass: TEdit
          Left = 56
          Top = 136
          Width = 113
          Height = 21
          TabOrder = 4
          OnChange = EditZoneMassChange
        end
        object EditZoneDamage: TEdit
          Left = 56
          Top = 168
          Width = 113
          Height = 21
          TabOrder = 5
          OnChange = EditZoneDamageChange
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 200
          Width = 161
          Height = 145
          Caption = 'Items'
          TabOrder = 6
          object CheckBoxZoneI0: TCheckBox
            Left = 8
            Top = 16
            Width = 65
            Height = 17
            Caption = 'Life'
            TabOrder = 0
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI1: TCheckBox
            Left = 8
            Top = 32
            Width = 65
            Height = 17
            Caption = 'Fast'
            TabOrder = 1
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI2: TCheckBox
            Left = 8
            Top = 48
            Width = 65
            Height = 17
            Caption = 'Slow'
            TabOrder = 2
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI3: TCheckBox
            Left = 8
            Top = 64
            Width = 65
            Height = 17
            Caption = 'Lock'
            TabOrder = 3
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI4: TCheckBox
            Left = 80
            Top = 16
            Width = 73
            Height = 17
            Caption = 'Damage'
            TabOrder = 4
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI5: TCheckBox
            Left = 80
            Top = 32
            Width = 73
            Height = 17
            Caption = 'Reload'
            TabOrder = 5
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI6: TCheckBox
            Left = 80
            Top = 48
            Width = 73
            Height = 17
            Caption = 'Defence'
            TabOrder = 6
            OnClick = CheckBoxZoneI0Click
          end
          object CheckBoxZoneI7: TCheckBox
            Left = 80
            Top = 64
            Width = 73
            Height = 17
            Caption = 'Invisible'
            TabOrder = 7
            OnClick = CheckBoxZoneI0Click
          end
          object ComboBoxZoneIFreq: TComboBox
            Left = 8
            Top = 112
            Width = 145
            Height = 21
            Style = csDropDownList
            ItemHeight = 13
            TabOrder = 8
            OnChange = ComboBoxZoneIFreqChange
            Items.Strings = (
              'Fast'
              'Average'
              'Slow')
          end
          object CheckBoxZoneI31: TCheckBox
            Left = 32
            Top = 88
            Width = 97
            Height = 17
            Caption = 'No show'
            TabOrder = 9
            OnClick = CheckBoxZoneI0Click
          end
        end
      end
      object TPage
        Left = 0
        Top = 0
        Caption = 'ZoneLink'
        object Label10: TLabel
          Left = 8
          Top = 10
          Width = 30
          Height = 13
          Caption = 'Type :'
        end
        object ComboBoxZoneLinkType: TComboBox
          Left = 40
          Top = 8
          Width = 129
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = ComboBoxZoneLinkTypeChange
          Items.Strings = (
            'Normal'
            'StopLine')
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 425
    Width = 618
    Height = 26
    Align = alBottom
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 23
      Height = 13
      Caption = 'FPS:'
    end
    object LabelFPS: TLabel
      Left = 40
      Top = 8
      Width = 20
      Height = 13
      Caption = 'FPS'
    end
    object Label2: TLabel
      Left = 80
      Top = 8
      Width = 31
      Height = 13
      Caption = 'Coord:'
    end
    object LabelCoord: TLabel
      Left = 120
      Top = 8
      Width = 28
      Height = 13
      Caption = 'Coord'
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 440
    Height = 425
    Align = alClient
    BevelOuter = bvNone
    Color = clGray
    TabOrder = 2
    object Panel3D: TPanel
      Left = 0
      Top = 0
      Width = 386
      Height = 337
      BevelOuter = bvNone
      Color = clNone
      TabOrder = 0
      OnMouseDown = Panel3DMouseDown
      OnMouseMove = Panel3DMouseMove
      OnMouseUp = Panel3DMouseUp
    end
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 51
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open...'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save As...'
        OnClick = SaveAs1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Saveend1: TMenuItem
        Caption = 'Save end old...'
        Visible = False
        OnClick = Saveend1Click
      end
      object MM_File_SaveEnd: TMenuItem
        Caption = 'Save end...'
        OnClick = MM_File_SaveEndClick
      end
      object N5: TMenuItem
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
    object Unit1: TMenuItem
      Caption = 'Unit'
      object MM_Unit_Load: TMenuItem
        Caption = 'Load...'
        OnClick = MM_Unit_LoadClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object MM_Unit_Path: TMenuItem
        Caption = 'Path...'
        OnClick = MM_Unit_PathClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object MM_Unit_BBCalcCurrent: TMenuItem
        Caption = 'BB calc current'
        OnClick = MM_Unit_BBCalcCurrentClick
      end
      object MM_Unit_BBCalcAll: TMenuItem
        Caption = 'BB calc all'
        OnClick = MM_Unit_BBCalcAllClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MM_Unit_ReloadCur: TMenuItem
        Caption = 'Reload current'
        OnClick = MM_Unit_ReloadCurClick
      end
      object MM_Unit_ReloadCurType: TMenuItem
        Caption = 'Reload current type'
        OnClick = MM_Unit_ReloadCurTypeClick
      end
      object MM_Unit_ReloadAll: TMenuItem
        Caption = 'Reload all'
        OnClick = MM_Unit_ReloadAllClick
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object MM_View_WorldLine: TMenuItem
        Caption = 'WorldLine         (Ctrl-W)'
        Checked = True
        OnClick = MM_View_WorldLineClick
      end
      object MM_View_Point: TMenuItem
        Caption = 'Point                 (Ctrl-P)'
        OnClick = MM_View_PointClick
      end
      object MM_View_Zone: TMenuItem
        Caption = 'Zone                 (Ctrl-Z)'
        Checked = True
        OnClick = MM_View_ZoneClick
      end
      object MM_View_Background: TMenuItem
        Caption = 'Background      (Ctrl-B)'
        OnClick = MM_View_BackgroundClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MM_View_SLDefault: TMenuItem
        Caption = 'Default StopLine'
        Checked = True
        OnClick = MM_View_SLDefaultClick
      end
      object MM_View_SLShow: TMenuItem
        Caption = 'Show StopLine'
        OnClick = MM_View_SLDefaultClick
      end
      object MM_View_SLHide: TMenuItem
        Caption = 'Hide StopLine'
        OnClick = MM_View_SLDefaultClick
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object MM_Options_Options: TMenuItem
        Caption = 'Options...'
        OnClick = MM_Options_OptionsClick
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Caption = 'About'
        OnClick = About1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20
    OnTimer = Timer1Timer
    Left = 144
    Top = 107
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.raw'
    Filter = '*.raw|*.raw'
    Left = 40
    Top = 131
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '*.raw'
    Filter = '*.raw|*.raw'
    Left = 72
    Top = 131
  end
  object OpenDialogUnit: TOpenDialog
    DefaultExt = '*.txt'
    Filter = '*.txt|*.txt'
    Left = 72
    Top = 32
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '*.map'
    Filter = '*.map|*.map'
    Left = 40
    Top = 168
  end
end
