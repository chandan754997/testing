inherited FrmDetCAEtatCodesInconnus: TFrmDetCAEtatCodesInconnus
  Left = 405
  Top = 161
  Width = 408
  Height = 218
  Caption = 'caption'
  OnPaint = FormPaint
  DesignSize = (
    400
    191)
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 16
    Top = 72
  end
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 232
    Top = 72
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
    Top = 172
    Width = 400
  end
  inherited PgsBarExec: TProgressBar
    Top = 156
    Width = 400
  end
  inherited PnlBtnsTop: TPanel
    Width = 400
    inherited BtnExit: TSpeedButton
      Left = 334
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
    Top = -435
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 96
  end
  inherited DtmPckLoadedFrom: TDateTimePicker [10]
    Visible = False
  end
  inherited RbtDateDay: TRadioButton [11]
    Left = 8
    Top = 48
  end
  inherited RbtDateLoaded: TRadioButton [12]
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker [13]
    Left = 272
    Top = 72
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
    Text = 'CmbAskSelection'
    Visible = False
  end
  inherited Panel1: TPanel [16]
    Height = 0
    Visible = False
    DesignSize = (
      225
      0)
    inherited ChkLbxOperator: TCheckListBox
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -95
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -63
    end
  end
  object SprCAEtatCodesInconnus: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstEtatForcagePrix;1'
    Left = 288
    Top = 200
    ParamData = <
      item
        DataType = ftInteger
        Name = 'RETURN_VALUE'
        ParamType = ptResult
        Value = 0
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatFrom'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatTo'
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
