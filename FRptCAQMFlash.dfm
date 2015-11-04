inherited FrmRptCAQMFlash: TFrmRptCAQMFlash
  Left = 438
  Top = 101
  Width = 604
  Height = 523
  Caption = 'CA - Flash'
  OnActivate = FormActivate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Height = 466
  end
  object PnlGraphic: TPanel
    Left = 3
    Top = 0
    Width = 585
    Height = 466
    Align = alClient
    TabOrder = 0
    object SvcDBLblChiffre: TSvcDBLabelLoaded
      Left = 152
      Top = 432
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
      Visible = False
      IdtLabel = 'SvcDBLblChiffre'
    end
    object SvcDBLblAVGAmount: TSvcDBLabelLoaded
      Left = 168
      Top = 432
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
      Visible = False
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
    object SvcDBLabelLoadedReport: TSvcDBLabelLoaded
      Left = 16
      Top = 16
      Width = 297
      Height = 33
      AutoSize = False
      Caption = 'Report'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblReport'
    end
    object SvcDBLabelLoadedStoreDetail: TSvcDBLabelLoaded
      Left = 16
      Top = 56
      Width = 297
      Height = 20
      AutoSize = False
      Caption = 'StoreDetail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblStoreDetail'
    end
    object SvcDBLabelLoadedPrintedOn: TSvcDBLabelLoaded
      Left = 16
      Top = 80
      Width = 297
      Height = 20
      AutoSize = False
      Caption = 'PrintedOn'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      IdtLabel = 'SvcDBLblPrintedOn'
    end
    object DBChtStatus: TChart
      Left = 1
      Top = 101
      Width = 583
      Height = 332
      AllowPanning = pmNone
      AllowZoom = False
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
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
        'File d'#39'attente')
      Title.Visible = False
      BottomAxis.LabelsFont.Charset = DEFAULT_CHARSET
      BottomAxis.LabelsFont.Color = clBlack
      BottomAxis.LabelsFont.Height = -11
      BottomAxis.LabelsFont.Name = 'MS Sans Serif'
      BottomAxis.LabelsFont.Style = []
      BottomAxis.LabelsMultiLine = True
      BottomAxis.LabelsSeparation = 0
      BottomAxis.LabelStyle = talText
      BottomAxis.RoundFirstLabel = False
      BottomAxis.Title.Caption = 'N'#176' active cash register'
      Chart3DPercent = 20
      LeftAxis.LabelsFont.Charset = DEFAULT_CHARSET
      LeftAxis.LabelsFont.Color = clBlack
      LeftAxis.LabelsFont.Height = -11
      LeftAxis.LabelsFont.Name = 'MS Sans Serif'
      LeftAxis.LabelsFont.Style = []
      LeftAxis.MinorTickCount = 2
      LeftAxis.MinorTickLength = 1
      LeftAxis.Title.Angle = 0
      LeftAxis.Title.Caption = 'no of queuing customers'
      Legend.ColorWidth = 45
      Legend.DividingLines.Width = 2
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
      View3DOptions.Elevation = 316
      View3DOptions.Perspective = 0
      View3DOptions.Rotation = 360
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
      object Series2: TFastLineSeries
        HorizAxis = aTopAxis
        Marks.ArrowLength = 8
        Marks.Visible = False
        SeriesColor = clRed
        LinePen.Color = clRed
        LinePen.Width = 2
        XValues.DateTime = False
        XValues.Name = 'X'
        XValues.Multiplier = 1.000000000000000000
        XValues.Order = loAscending
        YValues.DateTime = False
        YValues.Name = 'Y'
        YValues.Multiplier = 1.000000000000000000
        YValues.Order = loNone
      end
    end
    object PnlButton: TPanel
      Left = 1
      Top = 433
      Width = 583
      Height = 32
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        583
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
        Left = 507
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        TabOrder = 0
        Kind = bkClose
      end
      object BtnRapport: TBitBtn
        Left = 427
        Top = 3
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Rapport'
        TabOrder = 1
        Visible = False
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
        OnChange = SvcLFRefreshRateAfterExit
        LocalOptions = []
        Local = False
        RangeHigh = {7F000000000000000000}
        RangeLow = {00000000000000000000}
      end
    end
    object grpWarnMsg: TGroupBox
      Left = 312
      Top = 8
      Width = 273
      Height = 105
      TabOrder = 2
      object lblWarnMsg: TLabel
        Left = 8
        Top = 16
        Width = 153
        Height = 13
        Caption = 'Threshold Value Exceeded'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
      end
      object btnOK: TButton
        Left = 200
        Top = 72
        Width = 57
        Height = 25
        Caption = 'OK'
        TabOrder = 0
        OnClick = btnOKClick
      end
    end
  end
  object StsBarInfo: TStatusBar
    Left = 0
    Top = 466
    Width = 588
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
  object TmrRefreshRate: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = TmrRefreshRateTimer
    Left = 180
    Top = 400
  end
  object dsrClassifications: TDataSource
    Left = 40
    Top = 368
  end
  object dsrAmounts: TDataSource
    DataSet = DmdFpnCAQMFlash.QryAmount
    Left = 24
    Top = 208
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 264
    Top = 416
  end
end
