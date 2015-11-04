inherited FrmRptCouponStatus: TFrmRptCouponStatus
  Caption = 'Report coupon status'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Visible = False
  end
  inherited StsBarExec: TStatusBar
    Top = 366
  end
  inherited PgsBarExec: TProgressBar
    Top = 385
  end
  inherited PnlBtnsTop: TPanel
    inherited BtnStart: TSpeedButton
      Left = 264
    end
    inherited BtnStop: TSpeedButton
      Left = 328
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
  inherited DtmPckDayFrom: TDateTimePicker [7]
  end
  inherited Panel1: TPanel [8]
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -64
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -32
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker [9]
    Visible = False
  end
  inherited RbtDateDay: TRadioButton [10]
  end
  inherited RbtDateLoaded: TRadioButton [11]
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker [12]
  end
  inherited DtmPckLoadedTo: TDateTimePicker [13]
    Visible = False
  end
  object Gbx: TGroupBox [14]
    Left = 8
    Top = 49
    Width = 225
    Height = 128
    TabOrder = 11
    object RbtNotUsed: TRadioButton
      Left = 11
      Top = 15
      Width = 113
      Height = 17
      Caption = 'Not used'
      TabOrder = 0
      OnClick = RbtReportTypeClick
    end
    object RbtAll: TRadioButton
      Left = 11
      Top = 39
      Width = 113
      Height = 17
      Caption = 'All'
      TabOrder = 1
      OnClick = RbtReportTypeClick
    end
    object RbtVoucherNumber: TRadioButton
      Left = 11
      Top = 63
      Width = 175
      Height = 17
      Caption = 'Credit voucher number'
      TabOrder = 2
      OnClick = RbtReportTypeClick
    end
    object SvcMECreditVoucherNr: TSvcMaskEdit
      Left = 32
      Top = 88
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 3
      Width = 121
    end
  end
  inherited GbxLogging: TGroupBox [15]
    Left = 248
    Top = -340
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 376
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 216
    Top = 280
  end
  inherited TmrExec: TTimer
    Left = 440
    Top = 296
  end
  inherited ActLstApp: TActionList
    Left = 360
    Top = 224
  end
  inherited ImgLstApp: TImageList
    Left = 240
    Top = 224
  end
  inherited MnuApp: TMainMenu
    Left = 312
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 128
    Top = 248
  end
end
