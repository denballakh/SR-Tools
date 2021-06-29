object Form_BuildGAIExAnim: TForm_BuildGAIExAnim
  Left = 455
  Top = 261
  BorderStyle = bsDialog
  Caption = 'Build GAI anim'
  ClientHeight = 424
  ClientWidth = 503
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
  object Label2: TLabel
    Left = 8
    Top = 144
    Width = 59
    Height = 13
    Caption = 'Des file GAI:'
  end
  object Label1: TLabel
    Left = 403
    Top = 235
    Width = 36
    Height = 13
    Caption = 'Radius:'
  end
  object Label3: TLabel
    Left = 8
    Top = 234
    Width = 50
    Height = 13
    Caption = 'Channels :'
  end
  object Label4: TLabel
    Left = 192
    Top = 258
    Width = 26
    Height = 13
    Caption = 'Size :'
  end
  object Label5: TLabel
    Left = 328
    Top = 258
    Width = 67
    Height = 13
    Caption = 'Rescale filter :'
  end
  object Label6: TLabel
    Left = 8
    Top = 258
    Width = 32
    Height = 13
    Caption = 'Frame:'
  end
  object Label7: TLabel
    Left = 200
    Top = 203
    Width = 57
    Height = 13
    Caption = 'Pixel format:'
  end
  object Label8: TLabel
    Left = 9
    Top = 168
    Width = 52
    Height = 13
    Caption = 'Des file GI:'
  end
  object Label9: TLabel
    Left = 88
    Top = 203
    Width = 38
    Height = 13
    Caption = 'Format :'
  end
  object ButtonLoad: TButton
    Left = 8
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 0
    OnClick = ButtonLoadClick
  end
  object ButtonBuild: TButton
    Left = 344
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Build'
    TabOrder = 1
    OnClick = ButtonBuildClick
  end
  object ButtonClose: TButton
    Left = 422
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 2
  end
  object MemoText: TMemo
    Left = 8
    Top = 286
    Width = 489
    Height = 129
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
  end
  object ListBoxFiles: TListBox
    Left = 8
    Top = 8
    Width = 409
    Height = 129
    ItemHeight = 13
    TabOrder = 4
  end
  object FilenameEditDesGAI: TFilenameEdit
    Left = 72
    Top = 144
    Width = 425
    Height = 21
    Filter = '(*.gai)|*.gai'
    NumGlyphs = 1
    TabOrder = 5
    Text = 'C:\dab\Prog\Delphi\Rangers\DATA\anim.gai'
  end
  object EditRadius: TEdit
    Left = 448
    Top = 232
    Width = 49
    Height = 21
    TabOrder = 6
    Text = '1'
  end
  object CheckBoxCompress: TCheckBox
    Left = 312
    Top = 232
    Width = 73
    Height = 17
    Caption = 'Compress'
    TabOrder = 7
  end
  object CheckBoxDithering: TCheckBox
    Left = 224
    Top = 232
    Width = 73
    Height = 17
    Caption = 'Dithering'
    TabOrder = 8
  end
  object ComboBoxChannels: TComboBox
    Left = 64
    Top = 231
    Width = 33
    Height = 22
    Style = csOwnerDrawFixed
    ItemHeight = 16
    TabOrder = 9
    Items.Strings = (
      '3'
      '4')
  end
  object EditScale: TEdit
    Left = 224
    Top = 256
    Width = 97
    Height = 21
    TabOrder = 10
    Text = '1024,768'
  end
  object ComboBoxFilter: TComboBox
    Left = 400
    Top = 256
    Width = 97
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
    Items.Strings = (
      'Box'
      'Triangle'
      'Bell'
      'B-Spline'
      'Filter'
      'Lanczos3'
      'Mitchell')
  end
  object CheckBoxSubBlackColor: TCheckBox
    Left = 112
    Top = 232
    Width = 97
    Height = 17
    Caption = 'Sub black color'
    Checked = True
    State = cbChecked
    TabOrder = 12
  end
  object EditFrame: TEdit
    Left = 48
    Top = 256
    Width = 129
    Height = 21
    TabOrder = 13
  end
  object EditPF: TEdit
    Left = 264
    Top = 200
    Width = 57
    Height = 21
    TabOrder = 14
    Text = '5,6,5,5'
  end
  object FilenameEditDesGI: TFilenameEdit
    Left = 72
    Top = 168
    Width = 425
    Height = 21
    Filter = '(*.gi)|*.gi'
    NumGlyphs = 1
    TabOrder = 15
    Text = 'C:\dab\Prog\Delphi\Rangers\DATA\anim.gi'
  end
  object ComboBoxFormat: TComboBox
    Left = 128
    Top = 200
    Width = 65
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 16
    Items.Strings = (
      'F5'
      'F6')
  end
  object ButtonDrop: TButton
    Left = 424
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Drop'
    TabOrder = 17
    OnClick = ButtonDropClick
  end
  object EditDrop: TEdit
    Left = 424
    Top = 8
    Width = 75
    Height = 21
    TabOrder = 18
    Text = '2'
  end
  object OpenDialogFile: TOpenDialog
    DefaultExt = '*.jpg;*.png'
    Filter = '*.jpg;*.png|*.jpg;*.png|*.*|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 176
    Top = 48
  end
end
