�
 TFRMRPTCFGGENINVOICES 0%#  TPF0�TFrmRptCfgGenInvoicesFrmRptCfgGenInvoicesWidth�Height�CaptionGenerate invoices
OnActivateFormActivatePixelsPerInch`
TextHeight TPanelPnlTopLeft Top Width}Height� AlignalTopTabOrder  TLabelLblTaxCodCompanyLeftHTopWidth� HeightCaptionTax code purchasing company:  TLabelLblNumVATInvoiceLeftHTop'WidthcHeightCaptionVAT invoice number:  TLabelLblCustAddressLeftTop(Width)HeightCaptionAddress:  TLabelLbLCustNameLeftTopWidthHeightCaptionNombre:  TLabel
LblNumCustLeftTopRWidthGHeight	AlignmenttaRightJustifyCaption   N° cliente:  TLabelLblVATInvoiceCodeLeftHTop>WidthXHeightCaptionVAT invoice code:  TDBTextDBTxtTxtPublNameLeftxTopWidth� Height	DataFieldTxtPublName
DataSourceDscCustomer  TDBTextDBTxtTxtStreetLeftxTop(Width� Height	DataField	TxtStreet
DataSource
DscAddress  TDBTextDBTxtTxtMunicipalityLeftxTop:Width� Height	DataFieldMunicipalityTxtName
DataSource
DscAddress  TSvcMaskEditSvcMETxtNumVATInvoiceLeft�Top$Properties.Alignment.HorztaRightJustifyProperties.EditMask99999999;1; Properties.MaxLength Style.BorderStyleebs3DStyle.HotTrackStyleDisabled.ColorclWindowTabOrderText        Width�   TBitBtnBtnSelectCustLeftTopjWidth� HeightCaptionLookup customerTabOrderOnClickBtnSelectCustClick  TSvcLocalFieldSvcLFNumCustCardLeftwTopPWidth� HeightCursorcrIBeamDataType	pftStringCaretOvr.ShapecsBlock
ControllerOvcController1ControlCharColorclRedDecimalPlaces EFColors.Disabled.BackColorclWindowEFColors.Disabled.TextColor
clGrayTextEFColors.Error.BackColorclRedEFColors.Error.TextColorclBlackEFColors.Highlight.BackColorclHighlightEFColors.Highlight.TextColorclHighlightTextEpoch InitDateTime	MaxLengthOptionsefoCaretToEnd PictureMaskXXXXXXXXXXXXXXXXXXXXXTabOrder OnExitSvcLFNumCustCardExitLocalOptions Local  TSvcMaskEditSvcMETxtCodVATInvoiceLeft�Top<Properties.Alignment.HorztaLeftJustifyProperties.MaxLength Style.BorderStyleebs3DStyle.HotTrackStyleDisabled.ColorclWindowTabOrderWidth�   TSvcMaskEditSvcMETxtVATCodCustomerLeft�TopProperties.Alignment.HorztaLeftJustifyProperties.MaxLength Style.BorderStyleebs3DStyle.HotTrackStyleDisabled.ColorclWindowTabOrderWidth�    TPanelPnlAddTicketLeft Top� Width}Height8AlignalTopTabOrder TLabelLblIdtPOSTransactionLeftTopWidthDHeightCaption   N° de ticket de caja  TLabelLblNumCheckoutLeft� TopWidthTHeightCaptionCheckout number  TLabelLblDateLeft TopWidthHeightCaptionFecha  TSvcLocalFieldSvcLFIdtPOSTransactionLeftTopWidth� HeightCursorcrIBeamDataType
pftLongIntCaretOvr.ShapecsBlock
ControllerOvcController1ControlCharColorclRedDecimalPlaces EFColors.Disabled.BackColorclWindowEFColors.Disabled.TextColor
clGrayTextEFColors.Error.BackColorclRedEFColors.Error.TextColorclBlackEFColors.Highlight.BackColorclHighlightEFColors.Highlight.TextColorclHighlightTextEpoch InitDateTime	MaxLengthOptionsefoCaretToEnd PictureMaskiiiiiiiiiiiTabOrder LocalOptions Local	RangeHigh

   ���      RangeLow

      �        TSvcLocalFieldSvcLFIdtCheckoutLeft� TopWidth� HeightCursorcrIBeamDataType
pftLongIntCaretOvr.ShapecsBlock
ControllerOvcController1ControlCharColorclRedDecimalPlaces EFColors.Disabled.BackColorclWindowEFColors.Disabled.TextColor
clGrayTextEFColors.Error.BackColorclRedEFColors.Error.TextColorclBlackEFColors.Highlight.BackColorclHighlightEFColors.Highlight.TextColorclHighlightTextEpoch InitDateTime	MaxLengthOptionsefoCaretToEnd PictureMaskiiiiiiiiiiiTabOrderLocalOptions Local	RangeHigh

   ���      RangeLow

      �        TDateTimePickerDtmPckTickDateLeft TopWidthyHeightDate      �@Time      �@TabOrder  TBitBtnBtnAddTicketLeft�TopWidth� HeightCaption
Add ticketDefault	TabOrderOnClickBtnAddTicketClick   TPanelPnlTicketListLeft Top� Width}Height� AlignalClientTabOrder
DesignSize}�   TDBGridDBGrdTicketLeftTopWidth�Height� AlignalLeft
DataSource	DscTicketOptionsdgTitlesdgIndicatordgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgConfirmDeletedgCancelOnExit TabOrder TitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclWindowTextTitleFont.Height�TitleFont.NameMS Sans SerifTitleFont.Style ColumnsExpanded	FieldNameIdtPOSTransactionTitle.Caption   N° de ticket de cajaVisible	 Expanded	FieldNameIdtCheckoutTitle.CaptionCashdesk numberVisible	 Expanded	FieldNameDatTransBeginTitle.Caption
Fecha/HoraVisible	 Expanded	FieldName
ValInclVATTitle.CaptionImporteVisible	 	AlignmenttaCenterExpanded	FieldNameTxtRefundTicketsTitle.CaptionRefund ticketsVisible	    TBitBtnBtnDelTicketLeft�TopWidth� HeightHintRemove selected ticketAnchorsakLeftakTopakRight CaptionRemoverParentShowHintShowHintTabOrderOnClickBtnDelTicketClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 33333333333333�33333303333337333333s33��33ws3< 330w337w�37w����3p  ww�wwww�3�0w���w�w�w����  wwwpwwwwwwww<��     7wwwwwww330���33�?��3< ��37ww773�<���3w�?373�<��3w�ss?�3� 3�  3ww�?ww3<�3�37w3s73333�3333�s3333   33333www3Margin	NumGlyphsSpacing  TBitBtnBtnRemoveAllLeft�Top(Width� HeightHintRemove selected ticketAnchorsakLeftakTopakRight Caption
Remove allParentShowHintShowHintTabOrderOnClickBtnRemoveAllClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 33333333333333�33333303333337333333s33��33ws3< 330w337w�37w����3p  ww�wwww�3�0w���w�w�w����  wwwpwwwwwwww<��     7wwwwwww330���33�?��3< ��37ww773�<���3w�?373�<��3w�ss?�3� 3�  3ww�?ww3<�3�37w3s73333�3333�s3333   33333www3Margin	NumGlyphsSpacing   TPanelPnlPrintOptionsLeft TopjWidth}Height_AlignalBottomTabOrder TLabelLblNumTicketsLeftTopWidthVHeightCaptionNumber of tickets:  TLabelLblTotalAmountLeftTop WidthAHeightCaptionTotal amount:  TLabelLblNumTicketsDataLeft� TopWidthHeight	AlignmenttaRightJustifyCaption1234  TLabelLblTotalAmountDataLeft� Top Width'Height	AlignmenttaRightJustifyCaption1234,56  TLabelLblGenDescrLeft� Top"Width^Height	AlignmenttaRightJustifyCaptionGeneral description:  TLabelLblReportTypeLeft�Top
Width:Height	AlignmenttaRightJustifyCaptionReport type:  	TCheckBoxChxPrintGenDescrLeft� TopWidth� HeightCaptionPrint general descriptionTabOrder   TSvcMaskEditSvcMETxtGeneralDescrLeft0Top Style.BorderStyleebs3DStyle.HotTrackStyleDisabled.ColorclWindowTabOrderWidthA  	TComboBoxCbxReportTypeLeft�TopWidth� HeightStylecsDropDownList
ItemHeightTabOrderOnChangeCbxReportTypeChangeItems.StringsFacturaVAT listing   TBitBtnBtnPrintPreviewLeft�Top<Width� HeightHintRemove selected ticketCaptionEjemploParentShowHintShowHintTabOrderOnClickBtnPrintPreviewClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 0      ?��������������wwwwwww�������wwwwwww        ���������������wwwwwww�������wwwwwww�������wwwwww        wwwwwww30����337���?330� 337�wss330����337��?�330�  337�swws330���3337��73330��3337�ss3330�� 33337��w33330  33337wws333Margin	NumGlyphsSpacing   
TdxMemData
DxMDTicketIndexes SortOptions 	AfterPostDxMDTicketAfterPostAfterDeleteDxMDTicketAfterDeleteLeft Top TLargeintField	NumTicket	FieldNameIdtPOSTransaction  TLargeintFieldNumCashD	FieldNameIdtCheckout  TDateTimeField	DatTicket	FieldNameDatTransBegin  TFloatField	QtyAmount	FieldName
ValInclVATDisplayFormat	######.00  TSmallintFieldCodTrans	FieldNameCodTrans  TBooleanFieldDxMDTicketFlgRefundTickets	FieldNameFlgRefundTicketsOnChange DxMDTicketFlgRefundTicketsChange  TStringFieldDxMDTicketTxtRefundTickets	FieldKindfkCalculated	FieldNameTxtRefundTicketsSize
Calculated	   TDataSourceDscCustomerDataSetDmdFpnCustomerCA.QryDetCustomerLeft� Top  TDataSourceDscPOSTransactionCADataSet+DmdFpnPosTransactionCA.QryLstPosTransactionLeft� Top  TDataSource	DscTicketDataSet
DxMDTicketLeftXTop  TDataSource
DscAddressDataSet"DmdFpnCustomerCA.QryDetCustAddressLeft@Top  TOvcControllerOvcController1EntryCommands.TableListDefault	 WordStar Grid  Epoch�Left@Top`   