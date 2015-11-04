inherited FrmDetCreditCoupon: TFrmDetCreditCoupon
  Left = 106
  Top = 153
  Width = 517
  Height = 434
  Caption = 'Report global credit coupons'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 78
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Left = 40
    Top = 138
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 280
    Top = 78
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded
    Left = 280
    Top = 138
  end
  inherited StsBarExec: TStatusBar
    Top = 377
    Width = 501
    Visible = False
  end
  inherited PgsBarExec: TProgressBar
    Top = 361
    Width = 501
  end
  inherited PnlBtnsTop: TPanel
    Width = 501
    inherited BtnStart: TSpeedButton
      Left = 264
    end
    inherited BtnExit: TSpeedButton
      Left = 443
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
      Visible = False
      OnClick = BtnExportClick
    end
  end
  inherited GbxLogging: TGroupBox
    Left = -50
    Top = -319
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 120
    Top = 73
  end
  inherited Panel1: TPanel
    Top = -228
    Height = 0
    Visible = False
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
      ParentFont = False
    end
    inherited BtnSelectAll: TBitBtn
      Top = -103
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -71
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 120
    Top = 133
  end
  inherited RbtDateDay: TRadioButton
    Left = 16
    Top = 54
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 16
    Top = 110
  end
  inherited DtmPckDayTo: TDateTimePicker
    Top = 73
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Top = 133
  end
  object GbxCoupons: TGroupBox [15]
    Left = 16
    Top = 168
    Width = 465
    Height = 161
    TabOrder = 11
    object RdbtnNotPayed: TRadioButton
      Left = 16
      Top = 16
      Width = 113
      Height = 17
      Caption = 'Not payed'
      TabOrder = 0
      OnClick = ChangeStatusDownPaymentNr
    end
    object RdbtnAll: TRadioButton
      Left = 16
      Top = 48
      Width = 113
      Height = 17
      Caption = 'All'
      TabOrder = 1
      OnClick = ChangeStatusDownPaymentNr
    end
    object RdbtnDownPaymentNr: TRadioButton
      Left = 16
      Top = 112
      Width = 193
      Height = 17
      Caption = 'Credit coupon n'#176':'
      TabOrder = 2
      OnClick = ChangeStatusDownPaymentNr
    end
    object EdtCreditCoupon: TEdit
      Left = 216
      Top = 110
      Width = 113
      Height = 21
      Enabled = False
      TabOrder = 3
      OnKeyPress = EdtCreditCouponKeyPress
    end
    object ChkbxDetail: TCheckBox
      Left = 216
      Top = 135
      Width = 97
      Height = 17
      Caption = 'Detail'
      Enabled = False
      TabOrder = 4
    end
    object RdbtnReprisPC: TRadioButton
      Left = 16
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Repris PC'
      TabOrder = 5
      OnClick = RdbtnReprisPCClick
    end
    object RdbtnReprisPCOutDated: TRadioButton
      Left = 16
      Top = 80
      Width = 113
      Height = 17
      Caption = 'Repris PC (P'#233'rim'#233')'
      TabOrder = 6
      Visible = False
      OnClick = RdbtnReprisPCClick
    end
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 424
    Top = 200
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 264
    Top = 200
  end
  inherited TmrExec: TTimer
    Left = 200
    Top = 40
  end
  inherited ActLstApp: TActionList
    Left = 392
    Top = 0
  end
  inherited ImgLstApp: TImageList
    Left = 312
    Top = 56
  end
  inherited MnuApp: TMainMenu
    Left = 344
    Top = 216
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 312
    Top = 176
  end
end
