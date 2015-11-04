inherited FrmRptCAFlash: TFrmRptCAFlash
  Left = 56
  Top = 102
  Width = 738
  Height = 516
  Caption = 'CA - Flash'
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 393
    Top = 0
    Height = 470
  end
  object PnlCipher: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 470
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 0
      Top = 257
      Width = 393
      Height = 3
      Cursor = crVSplit
      Align = alTop
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 393
      Height = 257
      Align = alTop
      Caption = 'Panel1'
      TabOrder = 0
      OnResize = FormResize
      DesignSize = (
        393
        257)
      object Shape1: TShape
        Left = 265
        Top = 218
        Width = 87
        Height = 2
        Anchors = [akRight, akBottom]
        Pen.Width = 4
      end
      object DBText8: TDBText
        Left = 248
        Top = 120
        Width = 65
        Height = 17
      end
      object SvcDBLFAmountTotAmount: TSvcLocalField
        Left = 264
        Top = 224
        Width = 90
        Height = 21
        Cursor = crIBeam
        DataType = pftExtended
        Anchors = [akRight, akBottom]
        CaretOvr.Shape = csBlock
        Controller = OvcController1
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Enabled = False
        Epoch = 0
        InitDateTime = False
        MaxLength = 13
        Options = [efoRightAlign]
        PictureMask = '##,###,###.##'
        TabOrder = 0
        LocalOptions = []
        Local = False
        RangeHigh = {000000000020BCBE1940}
        RangeLow = {000000000020BCBE19C0}
      end
      object DBCtlGrdAmount: TDBCtrlGrid
        Left = 8
        Top = 11
        Width = 369
        Height = 200
        AllowDelete = False
        AllowInsert = False
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = dsrAmounts
        PanelBorder = gbNone
        PanelHeight = 20
        PanelWidth = 353
        TabOrder = 1
        RowCount = 10
        ShowFocus = False
        object DBTxtAmountsTxtPublDescr: TDBText
          Left = 6
          Top = 0
          Width = 184
          Height = 17
          DataField = 'TxtPublDescr'
          DataSource = dsrAmounts
        end
        object DBTxtAmountQtyArt: TDBText
          Left = 202
          Top = 0
          Width = 70
          Height = 17
          Alignment = taRightJustify
          DataField = 'QtyArt'
          DataSource = dsrAmounts
        end
        object DBTxtAmountsValue: TDBText
          Left = 276
          Top = 0
          Width = 70
          Height = 17
          Alignment = taRightJustify
          DataField = 'Waarde'
          DataSource = dsrAmounts
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 260
      Width = 393
      Height = 210
      Align = alClient
      Caption = 'Panel2'
      TabOrder = 1
      OnResize = FormResize
      DesignSize = (
        393
        210)
      object Shape2: TShape
        Left = 264
        Top = 176
        Width = 91
        Height = 2
        Anchors = [akRight, akBottom]
        Pen.Width = 4
      end
      object DBCtlGrdClassification: TDBCtrlGrid
        Left = 8
        Top = 10
        Width = 369
        Height = 135
        AllowDelete = False
        AllowInsert = False
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataSource = dsrClassifications
        PanelBorder = gbNone
        PanelHeight = 15
        PanelWidth = 353
        TabOrder = 0
        RowCount = 9
        ShowFocus = False
        object DBTxtClassifQtyArt: TDBText
          Left = 202
          Top = 0
          Width = 70
          Height = 17
          Alignment = taRightJustify
          DataField = 'QtyArt'
          DataSource = dsrClassifications
        end
        object DBTxtClassifValue: TDBText
          Left = 276
          Top = 0
          Width = 70
          Height = 17
          Alignment = taRightJustify
          DataField = 'Waarde'
          DataSource = dsrClassifications
        end
        object DBTxtClassifTxtPublDescr: TDBText
          Left = 42
          Top = 0
          Width = 156
          Height = 17
          DataField = 'TxtPublDescr'
          DataSource = dsrClassifications
        end
        object DBTxtClassifIdtMember: TDBText
          Left = 2
          Top = 0
          Width = 33
          Height = 17
          Alignment = taRightJustify
          DataField = 'IdtMember'
          DataSource = dsrClassifications
        end
      end
      object SvcDBLFClassTotAmount: TSvcLocalField
        Left = 264
        Top = 181
        Width = 90
        Height = 21
        Cursor = crIBeam
        DataType = pftExtended
        Anchors = [akRight, akBottom]
        CaretOvr.Shape = csBlock
        Controller = OvcController1
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Enabled = False
        Epoch = 0
        InitDateTime = False
        MaxLength = 13
        Options = [efoRightAlign]
        PictureMask = '##,###,###.##'
        TabOrder = 1
        LocalOptions = []
        Local = False
        RangeHigh = {000000000020BCBE1940}
        RangeLow = {000000000020BCBE19C0}
      end
    end
  end
  object PnlGraphic: TPanel
    Left = 396
    Top = 0
    Width = 334
    Height = 470
    Align = alClient
    TabOrder = 1
    object SvcDBLblChiffre: TSvcDBLabelLoaded
      Left = 16
      Top = 48
      Width = 305
      Height = 20
      AutoSize = False
      Caption = 'Nombre of clients'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblChiffre'
    end
    object SvcDBLblAVGAmount: TSvcDBLabelLoaded
      Left = 16
      Top = 80
      Width = 297
      Height = 20
      AutoSize = False
      Caption = 'Average Caddy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblAVGAmount'
    end
    object SvcDBLblDate: TSvcDBLabelLoaded
      Left = 16
      Top = 16
      Width = 297
      Height = 20
      AutoSize = False
      Caption = 'Date'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblDate'
    end
    object DBChtStatus: TChart
      Left = 1
      Top = 112
      Width = 332
      Height = 325
      AllowPanning = pmNone
      AllowZoom = False
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      BackWall.Pen.Visible = False
      Foot.AdjustFrame = False
      Foot.Alignment = taRightJustify
      Foot.Visible = False
      MarginBottom = 1
      MarginLeft = 1
      MarginRight = 1
      MarginTop = 1
      Title.Font.Charset = DEFAULT_CHARSET
      Title.Font.Color = clBlack
      Title.Font.Height = -27
      Title.Font.Name = 'MS Sans Serif'
      Title.Font.Style = []
      Title.Text.Strings = (
        'CA Flash')
      Title.Visible = False
      BottomAxis.LabelsAngle = 90
      BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
      BottomAxis.LabelsFont.Color = clBlack
      BottomAxis.LabelsFont.Height = -11
      BottomAxis.LabelsFont.Name = 'MS Sans Serif'
      BottomAxis.LabelsFont.Style = []
      BottomAxis.LabelsMultiLine = True
      BottomAxis.LabelsSeparation = 0
      BottomAxis.LabelStyle = talText
      BottomAxis.RoundFirstLabel = False
      Chart3DPercent = 20
      Frame.Visible = False
      LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
      LeftAxis.LabelsFont.Color = clBlack
      LeftAxis.LabelsFont.Height = -11
      LeftAxis.LabelsFont.Name = 'MS Sans Serif'
      LeftAxis.LabelsFont.Style = []
      Legend.ColorWidth = 45
      Legend.LegendStyle = lsValues
      Legend.ShadowSize = 1
      Legend.TextStyle = ltsPlain
      Legend.TopPos = 5
      Legend.Visible = False
      RightAxis.LabelsFont.Charset = DEFAULT_CHARSET
      RightAxis.LabelsFont.Color = clBlack
      RightAxis.LabelsFont.Height = -11
      RightAxis.LabelsFont.Name = 'MS Sans Serif'
      RightAxis.LabelsFont.Style = []
      TopAxis.LabelsFont.Charset = DEFAULT_CHARSET
      TopAxis.LabelsFont.Color = clBlack
      TopAxis.LabelsFont.Height = -11
      TopAxis.LabelsFont.Name = 'MS Sans Serif'
      TopAxis.LabelsFont.Style = []
      Align = alBottom
      BevelOuter = bvNone
      BevelWidth = 2
      BorderWidth = 2
      TabOrder = 0
      Anchors = [akLeft, akTop, akRight, akBottom]
      object Series1: TBarSeries
        ColorEachPoint = True
        Marks.ArrowLength = 20
        Marks.Visible = False
        SeriesColor = clRed
        BarStyle = bsRectGradient
        BarWidthPercent = 75
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1.000000000000000000
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Bar'
        YValues.Multiplier = 1.000000000000000000
        YValues.Order = loNone
      end
    end
    object PnlButton: TPanel
      Left = 1
      Top = 437
      Width = 332
      Height = 32
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        332
        32)
      object SvcDBLblRefreshRate: TSvcDBLabelLoaded
        Left = 8
        Top = 11
        Width = 63
        Height = 13
        Caption = 'Refresh Rate'
        IdtLabel = 'RefreshRate'
      end
      object BtnClose: TBitBtn
        Left = 248
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        TabOrder = 0
        Kind = bkClose
      end
      object BtnRapport: TBitBtn
        Left = 168
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Rapport'
        TabOrder = 1
        OnClick = BtnRapportClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
          8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
          8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
          8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
          03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
          03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
          33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
          33333337FFFF7733333333300000033333333337777773333333}
        NumGlyphs = 2
      end
      object SvcLFRefreshRate: TSvcLocalField
        Left = 88
        Top = 5
        Width = 33
        Height = 21
        Cursor = crIBeam
        DataType = pftShortInt
        CaretOvr.Shape = csBlock
        Controller = OvcController1
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 4
        Options = [efoCaretToEnd]
        PictureMask = 'iiii'
        TabOrder = 2
        AfterExit = SvcLFRefreshRateAfterExit
        LocalOptions = []
        Local = False
        RangeHigh = {7F000000000000000000}
        RangeLow = {01000000000000000000}
      end
    end
  end
  object StsBarInfo: TStatusBar
    Left = 0
    Top = 470
    Width = 730
    Height = 19
    Panels = <
      item
        Width = 220
      end
      item
        Width = 220
      end
      item
        Width = 300
      end>
    Visible = False
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 2000
    Left = 24
    Top = 32
  end
  object TmrRefreshRate: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TmrRefreshRateTimer
    Left = 692
    Top = 8
  end
  object dsrClassifications: TDataSource
    DataSet = DmdFpnCAFlash.QryClass
    Left = 32
    Top = 432
  end
  object dsrAmounts: TDataSource
    DataSet = DmdFpnCAFlash.QryAmount
    Left = 24
    Top = 208
  end
end
