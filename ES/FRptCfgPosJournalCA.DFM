�
 TFRMRPTCFGPOSJOURNALCA 0  TPF0�TFrmRptCfgPosJournalCAFrmRptCfgPosJournalCAHeight�PixelsPerInch`
TextHeight �
TStatusBar
StsBarExecTop�  �TProgressBar
PgsBarExecTop�  �	TGroupBox
GbxLoggingLeft Top�  �TPageControlPgeCtlCriteriaHeightF �	TTabSheetTabShtMainCriteria �	TGroupBoxGbxDateHour �	TGroupBoxGbxSpecifDate �TLabelLblToLeft�   �TSvcLocalFieldSvcLFDatFromWidthQAutoSizeEpoch 	RangeHigh

   %`       RangeLow

               �TSvcLocalField
SvcLFDatToLeft� WidthQAutoSizeEpoch 	RangeHigh

   %`       RangeLow

               �TSvcLocalFieldSvcLFTimFromWidthQAutoSizeEpoch 	RangeHigh

   Q       RangeLow

               �TSvcLocalField
SvcLFTimToLeft� WidthQAutoSizeEpoch 	RangeHigh

   Q       RangeLow

                 �	TGroupBox
GbxOptions �	TCheckBoxChkShowApprovalWidth�     �	TTabSheetTabShtDetailCriteria �
TScrollBox	SbxRptCfgHeight* �	TSplitterSptRptCfgChoiceHeight*  �TPanelPnlLeftHeight* �TListBoxLbxCondItemsHeight*Items.Strings'// For translator : Translate after '=';// For developer: see description of LbxCondItems in source--- Global --->   INT(RLO:0);POSTransaction.IdtPOSTransaction=N° ticket de cajaO   COD(ACTBL:POSTrans,ACFLD:CodTrans);POSTransaction.CodTrans=Código transacción<INT(RLO:1);POSTransInvoice.IdtDelivNote=Ticket de suministro1   INT(RLO:1);POSTransInvoice.IdtInvoice=N° factura:   INT(RLO:0,INULL:TRUE);POSTransCust.IdtCustomer=N° cliente5TXT(KEYSTR:FALSE);POSTransCust.TxtName=Nombre cliente5   FLG;POSTransaction.FlgTraining=Indicación formaciónP   COD(ACTBL:POSTrans,ACFLD:CodReturn);POSTransaction.CodReturn=Código devolución=   TXT;POSTransApproval.IdtOperApproval=Comprobación supervisor;   INT(RLO:0);POSTransaction.NumFiscalTicket=N° ticket fiscal--- Detalles ---SPRC(FLD:ValInclVat,ACT:13);POSTransDetail.ValInclVAT=Total ticket de caja IVA incl.A   ACT(ACT:7);POSTransDetail.FlgActionCorrection=Anulación de lineaF   ACT(ACT:6);POSTransDetail.FlgActionAnnulation=Anulación última linea5   ACT(ACT:8);POSTransDetail.FlgActionReturn=DevoluciónK   ACT(ACT:86);POSTransDetail.FlgActionCancelReceipt=Anulación ticket de caja.   // TXT;POSTransDetail.IdtArticle=N° artículoKTXT(PIC:999999999999999999999,LEFTPAD:TRUE);POSTransDetail.TxtSrcNumPLU=PLU6   TXT(KEYSTR:FALSE);POSTransDetail.TxtDescr=Descripción"INT;POSTransDetail.QtyReg=Cantidad$PRC;POSTransDetail.PrcInclVAT=Precio%PRC;POSTransDetail.ValInclVAT=ImportePCT;POSTransDetail.PctVAT=% IVA+TXT(KEYSTR:TRUE);POSTransCust.TxtNumVat=CIF3   TXT;POSTransDetail.IdtClassification=Clasificación*PCT;POSTransDetail.PctDiscount=% descuento6   INT(RLO:1);POSTransDetail.IdtCredCoup=Bono de crédito8   INT(RLO:1);POSTransDetail.IdtPromopack=Número promopackW   INT(PIC:iiiiiiii,RLO:1,RHI:99999999);POSTransDetail.NumCoupon=Número de vale de compra0INT(RLO:1);POSTransDetail.IdtCVente=Documento BOH   TXT;POSTransDetApproval.IdtOperApproval=Detalle comprobación supervisor    �	TGroupBox
GbxFldCondHeight* �TSvcMaskEditSvcMECondLowerOnKeyUpSvcMECondLowerKeyDown  �TSvcLocalFieldSvcLFCondLowerEpoch OnKeyUpSvcLFCondLowerKeyDown	RangeHigh

   �ߌ�3��G  RangeLow

   �ߌ�3���    �TSvcLocalFieldSvcLFCondUpperEpoch       �TOvcControllerOvcCtlConfigRepEntryCommands.TableListDefault	 WordStar Grid     