inherited FrmDetRetoursMarchandises: TFrmDetRetoursMarchandises
  Left = 298
  Top = 211
  Caption = 'Return of merchandise'
  PixelsPerInch = 96
  TextHeight = 13
  inherited SvcDBLblDateFrom: TSvcDBLabelLoaded
    Top = 74
  end
  inherited SvcDBLblDateTo: TSvcDBLabelLoaded
    Top = 98
  end
  inherited StsBarExec: TStatusBar
    Top = 374
  end
  inherited PgsBarExec: TProgressBar
    Top = 358
    TabOrder = 2
  end
  inherited PnlBtnsTop: TPanel
    TabOrder = 3
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
    Top = -480
    TabOrder = 11
  end
  inherited DtmPckDayFrom: TDateTimePicker
    Top = 66
    TabOrder = 5
  end
  inherited Panel1: TPanel
    Top = 46
    Height = 189
    TabOrder = 0
    DesignSize = (
      225
      189)
    inherited ChkLbxOperator: TCheckListBox
      Height = 117
    end
    inherited BtnSelectAll: TBitBtn
      Top = 125
    end
    inherited BtnDeSelectAll: TBitBtn
      Top = 157
    end
  end
  inherited DtmPckLoadedFrom: TDateTimePicker
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
    Top = 90
    TabOrder = 6
  end
  inherited DtmPckLoadedTo: TDateTimePicker
    TabOrder = 9
  end
  object PnlBQC: TPanel [15]
    Left = 240
    Top = 121
    Width = 248
    Height = 121
    BevelOuter = bvNone
    TabOrder = 10
    object LblTransNum: TLabel
      Left = 5
      Top = 7
      Width = 97
      Height = 13
      Caption = 'Transaction number:'
    end
    object LbLBarcode: TLabel
      Left = 5
      Top = 31
      Width = 63
      Height = 13
      Caption = 'SKU number:'
    end
    object LblDepartment: TLabel
      Left = 5
      Top = 54
      Width = 58
      Height = 13
      Caption = 'Department:'
    end
    object LblSalesType: TLabel
      Left = 5
      Top = 77
      Width = 52
      Height = 13
      Caption = 'Sales type:'
    end
    object Label1: TLabel
      Left = 5
      Top = 101
      Width = 67
      Height = 13
      Caption = 'Reason code:'
    end
    object EdtTransNum: TEdit
      Left = 120
      Top = 3
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object EdtBarcode: TEdit
      Left = 120
      Top = 27
      Width = 121
      Height = 21
      MaxLength = 7
      TabOrder = 1
    end
    object CmbbxDepartment: TComboBox
      Left = 119
      Top = 51
      Width = 122
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnKeyDown = CmbbxDepartmentKeyDown
    end
    object CmbbxSalesType: TComboBox
      Left = 119
      Top = 75
      Width = 122
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnKeyDown = CmbbxSalesTypeKeyDown
    end
    object CmbbxReasonCode: TComboBox
      Left = 118
      Top = 99
      Width = 122
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 4
      OnKeyDown = CmbbxReasonCodeKeyDown
    end
  end
  object PnlCheckout: TPanel [16]
    Left = 245
    Top = 238
    Width = 236
    Height = 0
    Anchors = [akLeft, akTop, akBottom]
    TabOrder = 12
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
  inherited TmrExec: TTimer
    Left = 200
    Top = 320
  end
  inherited ActLstApp: TActionList
    Left = 88
    Top = 320
  end
  inherited ImgLstApp: TImageList
    Left = 40
    Top = 320
  end
  inherited MnuApp: TMainMenu
    Left = 152
    Top = 320
  end
  object SprRetourDetail: TStoredProc
    DatabaseName = 'dbFlexPoint'
    StoredProcName = 'SprLstRetourMarchandise;1'
    Left = 288
    Top = 312
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatTransBegin'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtPOSTransaction'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtCheckout'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmCodTrans'
        ParamType = ptInput
      end>
  end
  object SprRetourDetailBQ: TStoredProc
    DatabaseName = 'dBFlexpoint'
    StoredProcName = 'SprLstRefund;1'
    Left = 368
    Top = 312
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftDateTime
        Name = '@PrmDatTransBegin'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtPOSTransaction'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtCheckOut'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmCodTrans'
        ParamType = ptInput
      end>
  end
  object SavDlgExport: TSaveTextFileDialog
    DefaultExt = 'csv'
    Filter = 'Excel files|*.csv'
    Left = 352
    Top = 56
  end
  object SprPaymentMethodExport: TStoredProc
    DatabaseName = 'DBFlexPoint'
    StoredProcName = 'SprPaymentMethodExport;1'
    Left = 432
    Top = 248
    ParamData = <
      item
        DataType = ftInteger
        Name = '@RETURN_VALUE'
        ParamType = ptResult
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtPosTransaction'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = '@PrmDattransbegin'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmCodTrans'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = '@PrmIdtCheckout'
        ParamType = ptInput
      end>
  end
end
