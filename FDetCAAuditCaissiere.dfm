inherited FrmDetCAAuditCaissiere: TFrmDetCAAuditCaissiere
  Left = 471
  Top = 210
  Width = 565
  Height = 429
  Caption = 'Audit Operators'
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded [0]
    Left = 304
    Top = 168
    Visible = False
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded [1]
    Left = 304
    Top = 96
  end
  inherited SvcDBLblDateLoadedTo: TSvcDBLabelLoaded [2]
    Left = 304
    Top = 192
    Visible = False
  end
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded [3]
    Left = 304
    Top = 72
  end
  inherited Panel1: TPanel [4]
    Width = 233
    Height = 208
    inherited ChkLbxOperator: TCheckListBox
      Width = 231
      Height = 128
      TabOrder = 3
    end
    inherited BtnSelectAll: TBitBtn
      Top = -89
      Enabled = False
      TabOrder = 0
      Visible = False
    end
    object BitBtn1: TBitBtn [2]
      Left = 8
      Top = 142
      Width = 217
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Select All'
      TabOrder = 2
      OnClick = BtnSelectAllClick
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 175
      Width = 217
      TabOrder = 1
    end
  end
  inherited StsBarExec: TStatusBar [5]
    Top = 372
    Width = 549
  end
  inherited PgsBarExec: TProgressBar [6]
    Top = 356
    Width = 549
  end
  inherited PnlBtnsTop: TPanel [7]
    Width = 549
    TabOrder = 3
    inherited BtnStart: TSpeedButton
      Left = 272
    end
    inherited BtnExit: TSpeedButton
      Left = 491
    end
    inherited BtnStop: TSpeedButton
      Left = 344
    end
    object BtnExport: TSpeedButton
      Left = 201
      Top = 2
      Width = 60
      Height = 36
      AllowAllUp = True
      Caption = '&Export'
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
  inherited GbxLogging: TGroupBox [8]
    Left = 256
    Top = 107
    TabOrder = 6
  end
  inherited DtmPckLoadedFrom: TDateTimePicker [9]
    Left = 368
    Top = 168
    TabOrder = 7
    Visible = False
  end
  inherited RbtDateDay: TRadioButton [10]
    Left = 272
    Top = 50
    TabOrder = 2
  end
  inherited RbtDateLoaded: TRadioButton [11]
    Left = 272
    Top = 144
    Enabled = False
    Visible = False
  end
  inherited DtmPckDayTo: TDateTimePicker [12]
    Left = 368
  end
  inherited DtmPckLoadedTo: TDateTimePicker [13]
    Left = 368
    Top = 192
    Visible = False
  end
  inherited DtmPckDayFrom: TDateTimePicker [14]
    Left = 368
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 464
    Top = 296
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 272
    Top = 288
  end
  inherited TmrExec: TTimer
    Left = 512
    Top = 232
  end
  inherited ActLstApp: TActionList
    Left = 512
    Top = 296
  end
  inherited ImgLstApp: TImageList
    Left = 408
    Top = 256
  end
  inherited MnuApp: TMainMenu
    Left = 456
  end
  object SprCAAuditCaissiere: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprLstAuditCaissieres;1'
    Left = 368
    Top = 304
    ParamData = <
      item
        DataType = ftInteger
        Name = 'RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftString
        Name = '@PrmTxtSequence'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtFrom'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@PrmTxtTo'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@FlgLastLine'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = '@LstOperator'
        ParamType = ptInput
      end>
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 304
    Top = 256
  end
end
