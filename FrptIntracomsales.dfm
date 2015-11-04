inherited FrmRptIntracomSales: TFrmRptIntracomSales
  Width = 683
  Height = 481
  Caption = 'FrmRptIntracomSales'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Left = 40
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Left = 248
    Top = 80
  end
  object Label1: TLabel [4]
    Left = 24
    Top = 56
    Width = 55
    Height = 13
    Caption = 'Sales Date:'
  end
  inherited StsBarExec: TStatusBar
    Top = 416
    Width = 675
  end
  inherited PgsBarExec: TProgressBar
    Top = 400
    Width = 675
  end
  inherited PnlBtnsTop: TPanel
    Width = 675
    inherited BtnStart: TSpeedButton
      Left = 240
    end
    inherited BtnExit: TSpeedButton
      Left = 609
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
  inherited GbxLogging: TGroupBox
    Left = 96
    Top = 69
    inherited LblDescrInfo: TLabel
      Left = -16
      Top = 48
    end
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 96
    Date = 0.429163692133443000
    Time = 0.429163692133443000
  end
  inherited Panel1: TPanel
    Width = 9
    Height = 19
    inherited ChkLbxOperator: TCheckListBox
      Width = 7
      Height = 0
    end
    inherited BtnSelectAll: TBitBtn
      Top = -91
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = -59
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Top = 112
  end
  inherited RbtDateDay: TRadioButton
    Left = 24
    Top = 240
  end
  inherited RbtDateLoaded: TRadioButton
    Left = 296
    Top = 80
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 288
    Top = 72
    Date = 0.429163692133443000
    Time = 0.429163692133443000
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 376
    Top = 152
  end
  inherited ActLstApp: TActionList
    Left = 480
    Top = 184
  end
  inherited MnuApp: TMainMenu
    inherited MniFile: TMenuItem
      object Preview1: TMenuItem [0]
        Bitmap.Data = {
          2E020000424D2E0200000000000036000000280000000C0000000E0000000100
          180000000000F801000000000000000000000000000000000000008080008080
          0000007F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F0000000080800080
          80008080008080008080000000BFBFBFBFBFBFBFBFBF00000000808000808000
          8080000000000000000000000000000000000000000000000000000000000000
          000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFF0000FFFFFFFFFFFFFF7F7F7FBFBFBFBFBFBFBFBFBFBFBFBFBFBFBFBF
          BFBFBFBFBFBFBFBFBFBFBF7F7F7FFFFFFF7F7F7F000000000000000000000000
          000000000000000000000000000000BFBFBFFFFFFF7F7F7F00000000FF0000FF
          0000FF0000FF0000FF0000FF0000FF00000000BFBFBFFFFFFF7F7F7F00000000
          FF00FF00FFFF00FFFF00FFFF00FFFF00FF00FF00000000BFBFBFFFFFFF7F7F7F
          00000000FF000000FF0000FF00FF000000FF0000FF00FF00000000BFBFBFFFFF
          FF7F7F7F00000000FF000000FF0000FF00FF000000FF0000FF00FF00000000BF
          BFBFFFFFFF7F7F7F00000000FF0000FF0000FF0000FF0000FF0000FF0000FF00
          000000BFBFBFFFFFFF7F7F7F0000000000000000000000000000000000000000
          00000000000000BFBFBFFFFFFF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Caption = 'Preview'
        OnClick = Preview1Click
      end
      inherited MniStart: TMenuItem
        Visible = False
      end
    end
  end
  object IntracomSalesSpr: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprIntracomSalesRpt'
    Left = 560
    Top = 96
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
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
    Left = 32
    Top = 120
  end
end