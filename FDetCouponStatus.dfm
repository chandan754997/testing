inherited FrmDetCouponStatus: TFrmDetCouponStatus
  Caption = 'Coupon Status'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    object SvcDBLblIdtCouponStatus: TSvcDBLabelLoaded
      Left = 16
      Top = 11
      Width = 85
      Height = 13
      Caption = 'Nr. credit voucher'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtCouponStatus'
    end
    object SvcDBLblTxtValCoupon: TSvcDBLabelLoaded
      Left = 16
      Top = 39
      Width = 121
      Height = 13
      Caption = 'Description value coupon'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'TxtValCoupon'
    end
    object SvcDBLFIdtCouponStatus: TSvcDBLocalField
      Left = 152
      Top = 8
      Width = 130
      Height = 21
      DataField = 'IdtCouponStatus'
      DataSource = DscCouponStatus
      FieldType = ftInteger
      CaretOvr.Shape = csBlock
      Controller = OvcCtlDetail
      EFColors.Disabled.BackColor = clWindow
      EFColors.Disabled.TextColor = clGrayText
      EFColors.Error.BackColor = clRed
      EFColors.Error.TextColor = clBlack
      EFColors.Highlight.BackColor = clHighlight
      EFColors.Highlight.TextColor = clHighlightText
      MaxLength = 11
      Options = [efoCaretToEnd]
      PictureMask = 'iiiiiiiiiii'
      TabOrder = 0
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000080000000000000}
    end
    object SvcDBMETxtValCoupon: TSvcDBMaskEdit
      Left = 152
      Top = 35
      DataBinding.DataField = 'TxtValCoupon'
      DataBinding.DataSource = DscCouponStatus
      Properties.MaxLength = 40
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Width = 265
    end
  end
  inherited PnlBottom: TPanel
    inherited PnlBottomRight: TPanel
      Left = 436
      inherited BtnOK: TBitBtn
        OnClick = BtnOKClick
      end
    end
    inherited PnlBtnAdd: TPanel
      Left = 340
    end
  end
  inherited PgeCtlDetail: TPageControl
    ActivePage = TabShtCommon
    object TabShtCommon: TTabSheet
      Caption = 'Common'
      object SvcDBLblDatIssue: TSvcDBLabelLoaded
        Left = 8
        Top = 8
        Width = 99
        Height = 13
        Caption = 'Date purchase ticket'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'DatIssue'
      end
      object SvcDBLblDatDue: TSvcDBLabelLoaded
        Left = 8
        Top = 38
        Width = 55
        Height = 13
        Caption = 'Expiry date '
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'DatDue'
      end
      object SvcDBLblIdtCustomer: TSvcDBLabelLoaded
        Left = 8
        Top = 69
        Width = 82
        Height = 13
        Caption = 'Customer number'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'IdtCustomer'
      end
      object SvcDBLblIdtClassification: TSvcDBLabelLoaded
        Left = 8
        Top = 100
        Width = 99
        Height = 13
        Caption = 'Classification number'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'IdtClassification'
      end
      object SvcDBLblValCoupon: TSvcDBLabelLoaded
        Left = 8
        Top = 130
        Width = 72
        Height = 13
        Caption = 'Value in money'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'ValCoupon'
      end
      object SvcDBLblFlgCountCustomer: TSvcDBLabelLoaded
        Left = 8
        Top = 161
        Width = 133
        Height = 13
        Caption = 'Count coupons for customer'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'FlgCountCustomer'
      end
      object SvcDBLblCodState: TSvcDBLabelLoaded
        Left = 8
        Top = 192
        Width = 25
        Height = 13
        Caption = 'State'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'CodState'
      end
      object SvcDBLblCodReason: TSvcDBLabelLoaded
        Left = 344
        Top = 192
        Width = 37
        Height = 13
        Caption = 'Reason'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'CodReason'
      end
      object SvcDBMEDatIssue: TSvcDBMaskEdit
        Left = 136
        Top = 6
        DataBinding.DataField = 'DatIssue'
        DataBinding.DataSource = DscCouponStatus
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 0
        Width = 121
      end
      object SvcDBMEDatDue: TSvcDBMaskEdit
        Left = 136
        Top = 35
        DataBinding.DataField = 'DatDue'
        DataBinding.DataSource = DscCouponStatus
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 1
        Width = 121
      end
      object SvcDBMEIdtCustomer: TSvcDBMaskEdit
        Left = 136
        Top = 65
        DataBinding.DataField = 'IdtCustomer'
        DataBinding.DataSource = DscCouponStatus
        Properties.OnValidate = SvcDBMEIdtCustomerPropertiesValidate
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 2
        Width = 89
      end
      object SvcDBMEIdtClassification: TSvcDBMaskEdit
        Left = 136
        Top = 96
        DataBinding.DataField = 'IdtClassification'
        DataBinding.DataSource = DscCouponStatus
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 3
        Width = 89
      end
      object SvcDBMEValCoupon: TSvcDBMaskEdit
        Left = 136
        Top = 128
        DataBinding.DataField = 'ValCoupon'
        DataBinding.DataSource = DscCouponStatus
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 4
        Width = 121
      end
      object DBCbxFlgCountCustomer: TDBCheckBox
        Left = 150
        Top = 160
        Width = 25
        Height = 17
        DataField = 'FlgCountCustomer'
        DataSource = DscCouponStatus
        TabOrder = 5
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object DBLkpCbxCodState: TDBLookupComboBox
        Left = 136
        Top = 187
        Width = 145
        Height = 21
        DataField = 'LkpCodState'
        DataSource = DscCouponStatus
        TabOrder = 6
        OnClick = DBLkpCbxCodStateClick
      end
      object SvcMECustomerName: TSvcMaskEdit
        Left = 272
        Top = 65
        Enabled = False
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 7
        Width = 241
      end
      object SvcMEClassDescr: TSvcMaskEdit
        Left = 272
        Top = 96
        Enabled = False
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 8
        Width = 241
      end
      object BtnSelectCustomer: TBitBtn
        Left = 528
        Top = 62
        Width = 90
        Height = 25
        Caption = 'Select...'
        TabOrder = 9
        OnClick = BtnSelectCustomerClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          555555555555555555555555555555555555555555FF55555555555559055555
          55555555577FF5555555555599905555555555557777F5555555555599905555
          555555557777FF5555555559999905555555555777777F555555559999990555
          5555557777777FF5555557990599905555555777757777F55555790555599055
          55557775555777FF5555555555599905555555555557777F5555555555559905
          555555555555777FF5555555555559905555555555555777FF55555555555579
          05555555555555777FF5555555555557905555555555555777FF555555555555
          5990555555555555577755555555555555555555555555555555}
        Margin = 2
        NumGlyphs = 2
        Spacing = 2
      end
      object BtnSelectSubdivision: TBitBtn
        Left = 528
        Top = 93
        Width = 90
        Height = 25
        Caption = 'Select...'
        TabOrder = 10
        OnClick = BtnSelectSubdivisionClick
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          0400000000000001000000000000000000001000000010000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
          555555555555555555555555555555555555555555FF55555555555559055555
          55555555577FF5555555555599905555555555557777F5555555555599905555
          555555557777FF5555555559999905555555555777777F555555559999990555
          5555557777777FF5555557990599905555555777757777F55555790555599055
          55557775555777FF5555555555599905555555555557777F5555555555559905
          555555555555777FF5555555555559905555555555555777FF55555555555579
          05555555555555777FF5555555555557905555555555555777FF555555555555
          5990555555555555577755555555555555555555555555555555}
        Margin = 2
        NumGlyphs = 2
        Spacing = 2
      end
    end
  end
  object DBLkpCbxCodReason: TDBLookupComboBox [4]
    Left = 448
    Top = 272
    Width = 145
    Height = 21
    DataField = 'LkpCodReason'
    DataSource = DscCouponStatus
    TabOrder = 4
  end
  inherited OvcCtlDetail: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Left = 568
  end
  object DscCouponStatus: TDataSource
    DataSet = DmdFpnCouponStatusCA.QryDetCouponStatus
    Left = 200
    Top = 312
  end
end
