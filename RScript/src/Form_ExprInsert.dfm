object FormExprInsert: TFormExprInsert
  Left = 156
  Top = 344
  BorderStyle = bsDialog
  Caption = 'insert'
  ClientHeight = 337
  ClientWidth = 577
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
    Left = 400
    Top = 306
    Width = 75
    Height = 25
    TabOrder = 0
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 480
    Top = 306
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 561
    Height = 289
    ActivePage = TabSheet1
    TabIndex = 0
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Function'
      object StringGridFun: TStringGrid
        Left = 0
        Top = 0
        Width = 553
        Height = 261
        Align = alClient
        ColCount = 3
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        ParentFont = False
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
        ColWidths = (
          67
          344
          506)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Star'
      ImageIndex = 1
      object ListBoxStar: TListBox
        Left = 0
        Top = 0
        Width = 553
        Height = 261
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Planet'
      ImageIndex = 2
      object ListBoxPlanet: TListBox
        Left = 0
        Top = 0
        Width = 553
        Height = 261
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Place'
      ImageIndex = 3
      object ListBoxPlace: TListBox
        Left = 0
        Top = 0
        Width = 553
        Height = 261
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Item'
      ImageIndex = 4
      object ListBoxItem: TListBox
        Left = 0
        Top = 0
        Width = 553
        Height = 261
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Group'
      ImageIndex = 5
      object ListBoxGroup: TListBox
        Left = 0
        Top = 0
        Width = 435
        Height = 205
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet9: TTabSheet
      Caption = 'Variable'
      ImageIndex = 6
      object ListBoxVar: TListBox
        Left = 0
        Top = 0
        Width = 435
        Height = 205
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
    object TabSheet10: TTabSheet
      Caption = 'Dialog'
      ImageIndex = 7
      object ListBoxDialog: TListBox
        Left = 0
        Top = 0
        Width = 436
        Height = 205
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = StringGridFunDblClick
      end
    end
  end
end
