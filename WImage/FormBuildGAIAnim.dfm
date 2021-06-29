object Form_BuildGAIAnim: TForm_BuildGAIAnim
  Left = 82
  Top = 288
  BorderStyle = bsDialog
  Caption = 'Build GAI anim'
  ClientHeight = 399
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 144
    Width = 38
    Height = 13
    Caption = 'Des file:'
  end
  object Label1: TLabel
    Left = 403
    Top = 203
    Width = 36
    Height = 13
    Caption = 'Radius:'
  end
  object Label4: TLabel
    Left = 192
    Top = 226
    Width = 26
    Height = 13
    Caption = 'Size :'
  end
  object Label5: TLabel
    Left = 328
    Top = 226
    Width = 67
    Height = 13
    Caption = 'Rescale filter :'
  end
  object Label6: TLabel
    Left = 8
    Top = 226
    Width = 32
    Height = 13
    Caption = 'Frame:'
  end
  object Label9: TLabel
    Left = 136
    Top = 173
    Width = 38
    Height = 13
    Caption = 'Format :'
  end
  object FilenameEditDes: TFilenameEdit
    Left = 56
    Top = 144
    Width = 441
    Height = 21
    Filter = '(*.gai)|*.gai'
    NumGlyphs = 1
    TabOrder = 0
  end
  object ButtonBuild: TButton
    Left = 344
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonClose: TButton
    Left = 424
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
  end
  object ListBoxFiles: TListBox
    Left = 8
    Top = 8
    Width = 489
    Height = 129
    ItemHeight = 13
    TabOrder = 3
  end
  object ButtonLoad: TButton
    Left = 8
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 4
    OnClick = ButtonLoadClick
  end
  object MemoText: TMemo
    Left = 8
    Top = 256
    Width = 489
    Height = 137
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 5
  end
  object CheckBoxSeries: TCheckBox
    Left = 111
    Top = 200
    Width = 58
    Height = 17
    Caption = 'Series'
    TabOrder = 6
  end
  object CheckBoxFillAlpha255: TCheckBox
    Left = 7
    Top = 199
    Width = 81
    Height = 17
    Caption = 'Fill alpha 255'
    TabOrder = 7
  end
  object ComboBoxFormat: TComboBox
    Left = 184
    Top = 170
    Width = 129
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    Items.Strings = (
      'Bitmap'
      'Trans'
      'Alpha'
      'AlphaIndexed8')
  end
  object EditRadius: TEdit
    Left = 448
    Top = 200
    Width = 49
    Height = 21
    TabOrder = 9
    Text = '12'
  end
  object CheckBoxCopyEnd: TCheckBox
    Left = 198
    Top = 201
    Width = 67
    Height = 17
    Caption = 'Copy end'
    Checked = True
    State = cbChecked
    TabOrder = 10
  end
  object CheckBoxCompress: TCheckBox
    Left = 304
    Top = 201
    Width = 73
    Height = 17
    Caption = 'Compress'
    TabOrder = 11
  end
  object EditScale: TEdit
    Left = 224
    Top = 224
    Width = 97
    Height = 21
    TabOrder = 12
    Text = '1024,768'
  end
  object ComboBoxFilter: TComboBox
    Left = 400
    Top = 224
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 13
    Items.Strings = (
      'Box'
      'Triangle'
      'Bell'
      'B-Spline'
      'Filter'
      'Lanczos3'
      'Mitchell')
  end
  object EditFrame: TEdit
    Left = 48
    Top = 224
    Width = 137
    Height = 21
    TabOrder = 14
  end
  object OpenDialogFile: TOpenDialog
    DefaultExt = '*.jpg;*.png'
    Filter = '*.jpg;*.png|*.jpg;*.png|*.*|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 176
    Top = 48
  end
end
