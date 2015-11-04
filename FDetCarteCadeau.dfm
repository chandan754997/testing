inherited FrmDetCarteCadeau: TFrmDetCarteCadeau
  Top = 205
  Caption = 'Report Gift card Satisfaction'
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlBtnsTop: TPanel
    inherited BtnStart: TSpeedButton
      Left = 266
    end
    inherited BtnExit: TSpeedButton
      Left = 439
    end
    inherited BtnStop: TSpeedButton
      Left = 330
    end
    object BtnExport: TSpeedButton
      Left = 202
      Top = 2
      Width = 60
      Height = 36
      BiDiMode = bdLeftToRight
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
      ParentBiDiMode = False
      ShowHint = True
      Visible = False
      OnClick = BtnExportClick
    end
  end
  inherited GbxLogging: TGroupBox
    Top = -202
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Top = 48
    Height = 149
    Caption = ''
    TabOrder = 3
    inherited ChkLbxOperator: TCheckListBox
      Height = 69
    end
    inherited BtnSelectAll: TBitBtn
      Top = 85
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 117
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Visible = False
  end
  inherited RbtDateLoaded: TRadioButton
    Visible = False
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Visible = False
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 320
    Top = 296
  end
end
