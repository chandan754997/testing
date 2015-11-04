inherited FrmDetRptBlockedArticleCA: TFrmDetRptBlockedArticleCA
  Left = 405
  Top = 161
  Width = 555
  Height = 125
  Caption = 'caption'
  DesignSize = (
    539
    87)
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 24
    Visible = False
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 232
    Top = 72
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  object SvcDBLblAskSelection: TSvcDBLabelLoaded [4]
    Left = 17
    Top = 104
    Width = 30
    Height = 13
    Caption = 'Select'
    Visible = False
    IdtLabel = 'SvcDBLblAskSelection'
  end
  inherited StsBarExec: TStatusBar
    Top = 68
    Width = 539
  end
  inherited PgsBarExec: TProgressBar
    Top = 52
    Width = 539
  end
  inherited PnlBtnsTop: TPanel
    Width = 539
    inherited BtnStart: TSpeedButton
      Left = 272
    end
    inherited BtnExit: TSpeedButton
      Left = 464
    end
    inherited BtnStop: TSpeedButton
      Left = 336
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
    Top = -879
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 104
    Top = 96
    Visible = False
  end
  inherited DtmPckLoadedFrom: TDateTimePicker [10]
    Visible = False
  end
  inherited RbtDateDay: TRadioButton [11]
    Left = 24
    Top = 120
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton [12]
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker [13]
    Left = 272
    Top = 72
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker [14]
    Visible = False
  end
  object CmbAskSelection: TComboBox [15]
    Left = 96
    Top = 103
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 11
    Visible = False
  end
  inherited Panel1: TPanel [16]
    Left = 48
    Top = 121
    Width = 177
    Height = 0
    Visible = False
    DesignSize = (
      177
      0)
    inherited ChkLbxOperator: TCheckListBox
      Width = 175
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -120
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -88
    end
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 240
    Top = 48
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 352
    Top = 88
  end
  object SprLstBlockArticle: TStoredProc
    DatabaseName = 'DBFlexPointUpdates'
    StoredProcName = 'SprLstBlockArticle;1'
    Left = 288
    Top = 200
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 288
    Top = 96
  end
end
