inherited FrmRptCfgGenInvoices: TFrmRptCfgGenInvoices
  Width = 645
  Height = 484
  Caption = 'Generate invoices'
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 637
    Height = 137
    Align = alTop
    TabOrder = 0
    object LblTaxCodCompany: TLabel
      Left = 328
      Top = 14
      Width = 149
      Height = 13
      Caption = 'Tax code purchasing company:'
    end
    object LblNumVATInvoice: TLabel
      Left = 328
      Top = 39
      Width = 99
      Height = 13
      Caption = 'VAT invoice number:'
    end
    object LblCustAddress: TLabel
      Left = 16
      Top = 40
      Width = 41
      Height = 13
      Caption = 'Address:'
    end
    object LbLCustName: TLabel
      Left = 16
      Top = 16
      Width = 31
      Height = 13
      Caption = 'Name:'
    end
    object LblNumCust: TLabel
      Left = 16
      Top = 82
      Width = 71
      Height = 13
      Alignment = taRightJustify
      Caption = 'Customer card:'
    end
    object LblVATInvoiceCode: TLabel
      Left = 328
      Top = 62
      Width = 88
      Height = 13
      Caption = 'VAT invoice code:'
    end
    object DBTxtTxtPublName: TDBText
      Left = 120
      Top = 16
      Width = 153
      Height = 17
      DataField = 'TxtPublName'
      DataSource = DscCustomer
    end
    object DBTxtTxtStreet: TDBText
      Left = 120
      Top = 40
      Width = 193
      Height = 17
      DataField = 'TxtStreet'
      DataSource = DscAddress
    end
    object DBTxtTxtMunicipality: TDBText
      Left = 120
      Top = 58
      Width = 193
      Height = 17
      DataField = 'MunicipalityTxtName'
      DataSource = DscAddress
    end
    object SvcMETxtNumVATInvoice: TSvcMaskEdit
      Left = 487
      Top = 36
      Properties.Alignment.Horz = taRightJustify
      Properties.EditMask = '99999999;1; '
      Properties.MaxLength = 0
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 3
      Text = '        '
      Width = 141
    end
    object BtnSelectCust: TBitBtn
      Left = 14
      Top = 106
      Width = 235
      Height = 25
      Caption = 'Lookup customer'
      TabOrder = 1
      OnClick = BtnSelectCustClick
    end
    object SvcLFNumCustCard: TSvcLocalField
      Left = 119
      Top = 80
      Width = 162
      Height = 21
      Cursor = crIBeam
      DataType = pftString
      CaretOvr.Shape = csBlock
      Controller = OvcController1
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
      MaxLength = 21
      Options = [efoCaretToEnd]
      PictureMask = 'XXXXXXXXXXXXXXXXXXXXX'
      TabOrder = 0
      OnExit = SvcLFNumCustCardExit
      LocalOptions = []
      Local = False
    end
    object SvcMETxtCodVATInvoice: TSvcMaskEdit
      Left = 487
      Top = 60
      Properties.Alignment.Horz = taLeftJustify
      Properties.MaxLength = 0
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 4
      Width = 141
    end
    object SvcMETxtVATCodCustomer: TSvcMaskEdit
      Left = 487
      Top = 12
      Properties.Alignment.Horz = taLeftJustify
      Properties.MaxLength = 0
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 2
      Width = 141
    end
  end
  object PnlAddTicket: TPanel
    Left = 0
    Top = 137
    Width = 637
    Height = 56
    Align = alTop
    TabOrder = 1
    object LblIdtPOSTransaction: TLabel
      Left = 16
      Top = 8
      Width = 68
      Height = 13
      Caption = 'Ticket number'
    end
    object LblNumCheckout: TLabel
      Left = 152
      Top = 8
      Width = 84
      Height = 13
      Caption = 'Checkout number'
    end
    object LblDate: TLabel
      Left = 288
      Top = 8
      Width = 23
      Height = 13
      Caption = 'Date'
    end
    object SvcLFIdtPOSTransaction: TSvcLocalField
      Left = 15
      Top = 24
      Width = 130
      Height = 21
      Cursor = crIBeam
      DataType = pftLongInt
      CaretOvr.Shape = csBlock
      Controller = OvcController1
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
      Options = [efoCaretToEnd]
      PictureMask = 'iiiiiiiiiii'
      TabOrder = 0
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000080000000000000}
    end
    object SvcLFIdtCheckout: TSvcLocalField
      Left = 151
      Top = 24
      Width = 130
      Height = 21
      Cursor = crIBeam
      DataType = pftLongInt
      CaretOvr.Shape = csBlock
      Controller = OvcController1
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
      Options = [efoCaretToEnd]
      PictureMask = 'iiiiiiiiiii'
      TabOrder = 1
      LocalOptions = []
      Local = False
      RangeHigh = {FFFFFF7F000000000000}
      RangeLow = {00000080000000000000}
    end
    object DtmPckTickDate: TDateTimePicker
      Left = 288
      Top = 24
      Width = 121
      Height = 21
      Date = 39155.000000000000000000
      Time = 39155.000000000000000000
      TabOrder = 2
    end
    object BtnAddTicket: TBitBtn
      Left = 496
      Top = 21
      Width = 137
      Height = 25
      Caption = 'Add ticket'
      Default = True
      TabOrder = 3
      OnClick = BtnAddTicketClick
    end
  end
  object PnlTicketList: TPanel
    Left = 0
    Top = 193
    Width = 637
    Height = 169
    Align = alClient
    TabOrder = 2
    DesignSize = (
      637
      169)
    object DBGrdTicket: TDBGrid
      Left = 1
      Top = 1
      Width = 496
      Height = 167
      Align = alLeft
      DataSource = DscTicket
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'IdtPOSTransaction'
          Title.Caption = 'Ticket number'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IdtCheckout'
          Title.Caption = 'Cashdesk number'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DatTransBegin'
          Title.Caption = 'Date/time'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ValInclVAT'
          Title.Caption = 'Amount'
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'TxtRefundTickets'
          Title.Caption = 'Refund tickets'
          Visible = True
        end>
    end
    object BtnDelTicket: TBitBtn
      Left = 504
      Top = 7
      Width = 128
      Height = 25
      Hint = 'Remove selected ticket'
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Remove'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnClick = BtnDelTicketClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333FF3333333333333003333333333333377F33333333333307
        733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
        000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
        777077777777777777773CCCCC00000000003777777777777777333330030FFF
        FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
        FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
        0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
        0F03333333337FFF7F7333333333000000333333333377777733}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
    object BtnRemoveAll: TBitBtn
      Left = 504
      Top = 40
      Width = 128
      Height = 25
      Hint = 'Remove selected ticket'
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Remove all'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
      OnClick = BtnRemoveAllClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333FF3333333333333003333333333333377F33333333333307
        733333FFF333337773333C003333307733333777FF333777FFFFC0CC03330770
        000077777FF377777777C033C03077FFFFF077FF77F777FFFFF7CC00000F7777
        777077777777777777773CCCCC00000000003777777777777777333330030FFF
        FFF03333F77F7F3FF3F7333C0C030F00F0F03337777F7F77373733C03C030FFF
        FFF03377F77F7F3F333733C03C030F0FFFF03377F7737F733FF733C000330FFF
        0000337777F37F3F7777333CCC330F0F0FF0333777337F737F37333333330FFF
        0F03333333337FFF7F7333333333000000333333333377777733}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
  end
  object PnlPrintOptions: TPanel
    Left = 0
    Top = 362
    Width = 637
    Height = 95
    Align = alBottom
    TabOrder = 3
    object LblNumTickets: TLabel
      Left = 16
      Top = 8
      Width = 86
      Height = 13
      Caption = 'Number of tickets:'
    end
    object LblTotalAmount: TLabel
      Left = 16
      Top = 32
      Width = 65
      Height = 13
      Caption = 'Total amount:'
    end
    object LblNumTicketsData: TLabel
      Left = 151
      Top = 8
      Width = 24
      Height = 13
      Alignment = taRightJustify
      Caption = '1234'
    end
    object LblTotalAmountData: TLabel
      Left = 136
      Top = 32
      Width = 39
      Height = 13
      Alignment = taRightJustify
      Caption = '1234,56'
    end
    object LblGenDescr: TLabel
      Left = 200
      Top = 34
      Width = 94
      Height = 13
      Alignment = taRightJustify
      Caption = 'General description:'
    end
    object LblReportType: TLabel
      Left = 406
      Top = 10
      Width = 58
      Height = 13
      Alignment = taRightJustify
      Caption = 'Report type:'
    end
    object ChxPrintGenDescr: TCheckBox
      Left = 200
      Top = 8
      Width = 177
      Height = 17
      Caption = 'Print general description'
      TabOrder = 0
    end
    object SvcMETxtGeneralDescr: TSvcMaskEdit
      Left = 304
      Top = 32
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      StyleDisabled.Color = clWindow
      TabOrder = 1
      Width = 321
    end
    object CbxReportType: TComboBox
      Left = 480
      Top = 8
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
      OnChange = CbxReportTypeChange
      Items.Strings = (
        'Invoice'
        'VAT listing')
    end
    object BtnPrintPreview: TBitBtn
      Left = 480
      Top = 60
      Width = 145
      Height = 25
      Hint = 'Remove selected ticket'
      Caption = 'Print preview'
      ParentShowHint = False
      ShowHint = False
      TabOrder = 3
      OnClick = BtnPrintPreviewClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
        00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
        8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
        8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
        8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
        03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
        03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
        33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
        33333337FFFF7733333333300000033333333337777773333333}
      Margin = 2
      NumGlyphs = 2
      Spacing = 2
    end
  end
  object DxMDTicket: TdxMemData
    Indexes = <>
    SortOptions = []
    AfterPost = DxMDTicketAfterPost
    AfterDelete = DxMDTicketAfterDelete
    Left = 32
    Top = 280
    object NumTicket: TLargeintField
      FieldName = 'IdtPOSTransaction'
    end
    object NumCashD: TLargeintField
      FieldName = 'IdtCheckout'
    end
    object DatTicket: TDateTimeField
      FieldName = 'DatTransBegin'
    end
    object QtyAmount: TFloatField
      FieldName = 'ValInclVAT'
      DisplayFormat = '######.00'
    end
    object CodTrans: TSmallintField
      FieldName = 'CodTrans'
    end
    object DxMDTicketFlgRefundTickets: TBooleanField
      FieldName = 'FlgRefundTickets'
      OnChange = DxMDTicketFlgRefundTicketsChange
    end
    object DxMDTicketTxtRefundTickets: TStringField
      FieldKind = fkCalculated
      FieldName = 'TxtRefundTickets'
      Size = 1
      Calculated = True
    end
  end
  object DscCustomer: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetCustomer
    Left = 144
    Top = 280
  end
  object DscPOSTransactionCA: TDataSource
    DataSet = DmdFpnPosTransactionCA.QryLstPosTransaction
    Left = 232
    Top = 280
  end
  object DscTicket: TDataSource
    DataSet = DxMDTicket
    Left = 88
    Top = 280
  end
  object DscAddress: TDataSource
    DataSet = DmdFpnCustomerCA.QryDetCustAddress
    Left = 320
    Top = 280
  end
  object OvcController1: TOvcController
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
    Epoch = 2000
    Left = 576
    Top = 96
  end
end
