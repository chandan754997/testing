inherited FrmDetInvoiceExtract: TFrmDetInvoiceExtract
  Left = 471
  Top = 210
  Width = 531
  Height = 195
  Caption = 'Invoice Extract'
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 32
    Top = 72
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 280
    Top = 72
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 138
    Width = 515
  end
  inherited PgsBarExec: TProgressBar
    Top = 122
    Width = 515
  end
  inherited PnlBtnsTop: TPanel
    Width = 515
    inherited BtnExit: TSpeedButton
      Left = 457
    end
    inherited BtnPreview: TSpeedButton
      Visible = False
    end
    inherited BtnPrintSetup: TSpeedButton
      Visible = False
    end
    inherited BtnPrint: TSpeedButton
      Visible = False
    end
    object BtnExport: TSpeedButton
      Left = 201
      Top = 2
      Width = 60
      Height = 36
      AllowAllUp = True
      Caption = 'E&xport'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        0400000000000001000000000000000000001000000010000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        555555FFFFFFFFFF55555000000000055555577777777775FFFF00B8B8B8B8B0
        0000775F5555555777770B0B8B8B8B8B0FF07F75F555555575F70FB0B8B8B8B8
        B0F07F575FFFFFFFF7F70BFB0000000000F07F557777777777570FBFBF0FFFFF
        FFF07F55557F5FFFFFF70BFBFB0F000000F07F55557F777777570FBFBF0FFFFF
        FFF075F5557F5FFFFFF750FBFB0F000000F0575FFF7F777777575700000FFFFF
        FFF05577777F5FF55FF75555550F00FF00005555557F775577775555550FFFFF
        0F055555557F55557F755555550FFFFF00555555557FFFFF7755555555000000
        0555555555777777755555555555555555555555555555555555}
      Layout = blGlyphTop
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = False
      Spacing = 2
      OnClick = BtnExportClick
    end
  end
  inherited GbxLogging: TGroupBox
    Top = -273
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 64
  end
  inherited Panel1: TPanel
    Top = 81
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
      Enabled = False
      Font.Color = clGrayText
      ParentFont = False
      Visible = False
    end
    inherited BtnSelectAll: TBitBtn
      Top = -318
      Enabled = False
      Visible = False
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -286
      Enabled = False
      Visible = False
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    Left = 8
    Top = 50
  end
  inherited RbtDateLoaded: TRadioButton
    Enabled = False
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 320
    Top = 64
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 256
    Top = 64
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 88
    Top = 112
  end
  inherited ActLstApp: TActionList
    Left = 264
    Top = 272
  end
  object SprRptInvExtrct: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprRptInvExtrct;1'
    Left = 280
    Top = 224
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 352
    Top = 224
  end
end
