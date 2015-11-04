inherited FrmDetManInvoiceArticleCA: TFrmDetManInvoiceArticleCA
  Left = 298
  Top = 148
  Width = 435
  Height = 462
  Caption = 'Detail Article'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlInfo: TPanel
    Width = 427
    Height = 89
    object SvcDBLblArticleNumber: TSvcDBLabelLoaded
      Left = 8
      Top = 16
      Width = 69
      Height = 13
      Caption = 'Article Number'
      Enabled = False
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtArticle'
    end
    object SvcDBLblArticleDescription: TSvcDBLabelLoaded
      Left = 8
      Top = 40
      Width = 85
      Height = 13
      Caption = 'Article Description'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'TxtPublDescr'
    end
    object SvcDBLblArticleClassification: TSvcDBLabelLoaded
      Left = 8
      Top = 64
      Width = 93
      Height = 13
      Caption = 'Article Classification'
      StoredProc = DmdFpnUtils.SprCnvApplicText
      IdtLabel = 'IdtClassification'
    end
    object BtnSelectClassification: TBitBtn
      Left = 320
      Top = 56
      Width = 99
      Height = 25
      Caption = '&Classification'
      TabOrder = 3
      OnClick = BtnSelectClassificationClick
    end
    object SvcMEArticleNumber: TSvcMaskEdit
      Left = 112
      Top = 8
      Enabled = False
      Properties.MaxLength = 14
      Properties.PasswordChar = '*'
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 0
      Width = 130
    end
    object SvcMEArticleDescription: TSvcMaskEdit
      Left = 112
      Top = 32
      Properties.MaxLength = 40
      Properties.OnChange = SvcMEArticleDescriptionPropertiesChange
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Width = 305
    end
    object SvcMEArticleClassification: TSvcMaskEdit
      Left = 112
      Top = 56
      Enabled = False
      Properties.MaxLength = 12
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 2
      Width = 201
    end
  end
  inherited PnlBottom: TPanel
    Top = 384
    Width = 427
    inherited PnlBottomRight: TPanel
      Left = 239
    end
    inherited PnlBtnAdd: TPanel
      Left = 143
    end
  end
  inherited PgeCtlDetail: TPageControl
    Top = 89
    Width = 427
    Height = 295
    ActivePage = TabShtData
    object TabShtData: TTabSheet
      Caption = 'Data'
      object BvlExtra: TBevel
        Left = 17
        Top = 103
        Width = 388
        Height = 58
      end
      object BvlPrice: TBevel
        Left = 17
        Top = 16
        Width = 388
        Height = 81
      end
      object BvlTotal: TBevel
        Left = 17
        Top = 167
        Width = 388
        Height = 35
      end
      object SvcDBLblNormalPrice: TSvcDBLabelLoaded
        Left = 25
        Top = 30
        Width = 60
        Height = 13
        Caption = 'Normal Price'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PrcSale'
      end
      object SvcDBLblPromoPrice: TSvcDBLabelLoaded
        Left = 25
        Top = 54
        Width = 57
        Height = 13
        Caption = 'Promo Price'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PrcPromo'
      end
      object SvcDBLblDiscount: TSvcDBLabelLoaded
        Left = 25
        Top = 78
        Width = 59
        Height = 13
        Caption = 'Discount (%)'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PctDiscount'
      end
      object SvcDBLblVATCode: TSvcDBLabelLoaded
        Left = 25
        Top = 117
        Width = 66
        Height = 13
        Caption = 'VAT Code (%)'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PctVAT'
      end
      object SvcDBLblDisposit: TSvcDBLabelLoaded
        Left = 25
        Top = 141
        Width = 37
        Height = 13
        Caption = 'Disposit'
        Visible = False
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PrcDeposit'
      end
      object SvcDBLblTotal: TSvcDBLabelLoaded
        Left = 25
        Top = 179
        Width = 24
        Height = 13
        Caption = 'Total'
        StoredProc = DmdFpnUtils.SprCnvApplicText
        IdtLabel = 'PrcTotalArt'
      end
      object Bevel1: TBevel
        Left = 17
        Top = 223
        Width = 388
        Height = 34
      end
      object SvcLFQuantity: TSvcLocalField
        Left = 113
        Top = 22
        Width = 89
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 0
        OnChange = SvcLFQuantityChange
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object SvcLFPrcUnit: TSvcLocalField
        Left = 209
        Top = 22
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 1
        OnChange = SvcLFQuantityChange
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object SvcLFPrcInclVAT: TSvcLocalField
        Left = 313
        Top = 174
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Enabled = False
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign, efoSoftValidation]
        PictureMask = '########.##'
        TabOrder = 8
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object SvcLFPrcExclVAT: TSvcLocalField
        Left = 313
        Top = 70
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Enabled = False
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 4
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object SvcLFValVAT: TSvcLocalField
        Left = 313
        Top = 109
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Enabled = False
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 6
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object CbxVATCode: TComboBox
        Left = 209
        Top = 109
        Width = 81
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
        OnChange = SvcLFQuantityChange
      end
      object SvcLFPrcPromo: TSvcLocalField
        Left = 209
        Top = 46
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 2
        OnChange = SvcLFQuantityChange
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object SvcLFPrcDiscount: TSvcLocalField
        Left = 209
        Top = 70
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 3
        OnChange = SvcLFQuantityChange
        LocalOptions = []
        Local = False
        RangeHigh = {00000000000000C80540}
        RangeLow = {00000000000000000000}
      end
      object SvcLFDisposit: TSvcLocalField
        Left = 209
        Top = 133
        Width = 81
        Height = 21
        Cursor = crIBeam
        DataType = pftDouble
        CaretOvr.Shape = csBlock
        Controller = OvcCtlDetail
        ControlCharColor = clRed
        DecimalPlaces = 0
        EFColors.Disabled.BackColor = clWindow
        EFColors.Disabled.TextColor = clGrayText
        EFColors.Error.BackColor = clRed
        EFColors.Error.TextColor = clBlack
        EFColors.Highlight.BackColor = clHighlight
        EFColors.Highlight.TextColor = clHighlightText
        Epoch = 0
        InitDateTime = False
        MaxLength = 11
        Options = [efoRightAlign]
        PictureMask = '########.##'
        TabOrder = 7
        Visible = False
        OnChange = SvcLFQuantityChange
        LocalOptions = []
        Local = False
        RangeHigh = {73B2DBB9838916F2FE43}
        RangeLow = {73B2DBB9838916F2FEC3}
      end
      object ChkBxFreeArticle: TCheckBox
        Left = 24
        Top = 232
        Width = 81
        Height = 17
        Caption = 'Free Article'
        TabOrder = 9
        OnClick = ChkBxFreeArticleClick
      end
      object SvcMEFreeDescription: TSvcMaskEdit
        Left = 113
        Top = 229
        Properties.MaxLength = 40
        Style.BorderStyle = ebs3D
        Style.HotTrack = False
        StyleDisabled.Color = clWindow
        TabOrder = 10
        Width = 282
      end
    end
  end
  inherited StsBarInfo: TStatusBar
    Top = 416
    Width = 427
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
  end
end
