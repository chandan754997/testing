inherited FrmRptGiftCoup: TFrmRptGiftCoup
  Caption = 'Specific BA statement and clearing'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Enabled = False
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Enabled = False
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 365
    Width = 489
  end
  inherited PgsBarExec: TProgressBar
    Top = 349
    Width = 489
  end
  inherited PnlBtnsTop: TPanel
    Width = 489
    inherited BtnStart: TSpeedButton
      Left = 280
    end
    inherited BtnStop: TSpeedButton
      Left = 352
    end
    object BtnExport: TSpeedButton
      Left = 201
      Top = 2
      Width = 60
      Height = 36
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
      ShowHint = True
      Spacing = 2
      OnClick = BtnExportClick
    end
  end
  inherited GbxLogging: TGroupBox
    Top = -126
    Height = 10
    Enabled = False
    Visible = True
  end
  inherited Panel1: TPanel
    Height = 132
    TabOrder = 6
    inherited ChkLbxOperator: TCheckListBox
      Height = 68
    end
    inherited BtnSelectAll: TBitBtn
      Top = 68
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 100
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    TabOrder = 7
    Visible = False
  end
  inherited RbtDateDay: TRadioButton
    TabOrder = 8
  end
  inherited RbtDateLoaded: TRadioButton
    Enabled = False
    TabOrder = 9
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker
    TabOrder = 5
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  object Panel2: TPanel [15]
    Left = 240
    Top = 216
    Width = 241
    Height = 89
    TabOrder = 11
    object RbtClearing: TRadioButton
      Left = 13
      Top = 40
      Width = 225
      Height = 17
      Caption = 'BA statement Cde clearing'
      TabOrder = 0
    end
    object RbtSpecific: TRadioButton
      Left = 13
      Top = 64
      Width = 201
      Height = 17
      Caption = 'Specific BA statement'
      TabOrder = 1
    end
    object RbtDeactiv: TRadioButton
      Left = 13
      Top = 16
      Width = 225
      Height = 17
      Caption = 'BA Deactivation'
      TabOrder = 2
    end
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 376
    Top = 16
  end
  inherited TmrExec: TTimer
    Left = 336
    Top = 328
  end
  inherited ActLstApp: TActionList
    Left = 256
    Top = 328
  end
  inherited ImgLstApp: TImageList
    Left = 88
    Top = 296
  end
  inherited MnuApp: TMainMenu
    Left = 176
    Top = 320
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 416
    Top = 296
  end
end
