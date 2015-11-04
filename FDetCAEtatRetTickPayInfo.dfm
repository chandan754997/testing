inherited FrmDetCAEtatRetTickPayInfo: TFrmDetCAEtatRetTickPayInfo
  Caption = 'FrmDetCAEtatRetTickPayInfo'
  PixelsPerInch = 96
  TextHeight = 13
  object LblSelect: TLabel [4]
    Left = 264
    Top = 184
    Width = 30
    Height = 13
    Caption = 'Select'
  end
  inherited StsBarExec: TStatusBar
    Top = 374
  end
  inherited PgsBarExec: TProgressBar
    Top = 358
  end
  inherited PnlBtnsTop: TPanel
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
    Top = -65
  end
  inherited Panel1: TPanel
    Height = 234
    Caption = ''
    inherited ChkLbxOperator: TCheckListBox
      Height = 154
    end
    inherited BtnSelectAll: TBitBtn
      Top = 162
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 194
    end
  end
  object CmbxRptType: TComboBox [16]
    Left = 336
    Top = 184
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 11
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 344
    Top = 72
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 288
    Top = 64
  end
  object CARetTickPayInfo: TStoredProc
    DatabaseName = 'DBFlexpoint'
    StoredProcName = 'SprRetOrigTick'
    Left = 288
    Top = 280
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftString
        Name = '@DateFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@DateTo'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@OperatorSequence'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@ReportType'
        ParamType = ptInput
      end>
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 352
    Top = 56
  end
end
