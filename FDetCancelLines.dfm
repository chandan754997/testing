inherited FrmDetCancelLines: TFrmDetCancelLines
  Left = 413
  Top = 174
  Caption = 'Cancel Lines'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Top = 74
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Top = 98
  end
  inherited PgsBarExec: TProgressBar
    TabOrder = 2
  end
  inherited PnlBtnsTop: TPanel
    TabOrder = 3
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
  inherited GbxLogging: TGroupBox
    Top = -651
    TabOrder = 10
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Left = 344
    Top = 66
    Width = 137
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Top = 54
    Height = 235
    TabOrder = 0
    inherited ChkLbxOperator: TCheckListBox
      Height = 155
    end
    inherited BtnSelectAll: TBitBtn
      Top = 163
      Height = 26
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 200
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
    Left = 344
    Width = 137
    TabOrder = 8
  end
  inherited RbtDateDay: TRadioButton
    Top = 50
    TabOrder = 4
  end
  inherited RbtDateLoaded: TRadioButton
    Top = 122
    TabOrder = 7
  end
  inherited DtmPckDayTo: TDateTimePicker
    Left = 344
    Top = 90
    Width = 137
    TabOrder = 6
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    Left = 344
    Width = 137
    TabOrder = 9
  end
  object PnlCheckout: TPanel [15]
    Left = 245
    Top = 238
    Width = 236
    Height = 0
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 11
    DesignSize = (
      236
      0)
    object ChkLbxCheckout: TCheckListBox
      Left = 1
      Top = 1
      Width = 234
      Height = 0
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      ItemHeight = 13
      TabOrder = 0
    end
    object BtnSelectAllCheckout: TBitBtn
      Left = 13
      Top = -64
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Select All'
      TabOrder = 1
      OnClick = BtnSelectAllCheckoutClick
    end
    object BtnDESelectAllCheckout: TBitBtn
      Left = 13
      Top = -32
      Width = 209
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Deselect All'
      TabOrder = 2
      OnClick = BtnDESelectAllCheckoutClick
    end
  end
  object PnlType: TPanel [16]
    Left = 264
    Top = 192
    Width = 217
    Height = 57
    BevelOuter = bvNone
    TabOrder = 12
    object Label1: TLabel
      Left = 5
      Top = 29
      Width = 60
      Height = 13
      Caption = 'Cancel Type'
    end
    object CmbbxCancelLine: TComboBox
      Left = 80
      Top = 27
      Width = 137
      Height = 22
      Style = csDropDownList
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ItemHeight = 0
      ParentFont = False
      TabOrder = 0
      OnChange = CmbbxCancelLineChange
      OnKeyDown = CmbbxCancelLineKeyDown
    end
  end
  inherited SvcExHApp: TSvcExceptHandler
    Left = 448
  end
  inherited SvcAppInstCheck: TSvcAppInstance
    Left = 272
    Top = 280
  end
  inherited TmrExec: TTimer
    Left = 328
    Top = 288
  end
  inherited ActLstApp: TActionList
    Left = 216
    Top = 296
  end
  inherited ImgLstApp: TImageList
    Left = 272
    Top = 344
  end
  inherited MnuApp: TMainMenu
    Left = 200
    Top = 248
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 440
    Top = 248
  end
end
