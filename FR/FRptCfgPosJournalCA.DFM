�
 TFRMRPTCFGPOSJOURNALCA 0�  TPF0�TFrmRptCfgPosJournalCAFrmRptCfgPosJournalCAHeight�PixelsPerInch`
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
TScrollBox	SbxRptCfgHeight* �	TSplitterSptRptCfgChoiceHeight*  �TPanelPnlLeftHeight* �TListBoxLbxCondItemsHeight*Items.Strings'// For translator : Translate after '=';// For developer: see description of LbxCondItems in source   --- En-tête ---6   INT(RLO:0);POSTransaction.IdtPOSTransaction=N° ticketKCOD(ACTBL:POSTrans,ACFLD:CodTrans);POSTransaction.CodTrans=Code transaction8INT(RLO:1);POSTransInvoice.IdtDelivNote=Bon de livraison1   INT(RLO:1);POSTransInvoice.IdtInvoice=N° facture9   INT(RLO:0,INULL:TRUE);POSTransCust.IdtCustomer=N° client1TXT(KEYSTR:FALSE);POSTransCust.TxtName=Nom client3FLG;POSTransaction.FlgTraining=Indicateur formationHCOD(ACTBL:POSTrans,ACFLD:CodReturn);POSTransaction.CodReturn=Code retour;TXT;POSTransApproval.IdtOperApproval=Validation Superviseur>   INT(RLO:0);POSTransaction.NumFiscalTicket=N° de ticket fiscal   --- Détails ---NPRC(FLD:ValInclVat,ACT:13);POSTransDetail.ValInclVAT=Ticket total TVA comprise>ACT(ACT:7);POSTransDetail.FlgActionCorrection=Annulation ligneFACT(ACT:6);POSTransDetail.FlgActionAnnulation=Annulation dernier ligne0ACT(ACT:8);POSTransDetail.FlgActionReturn=RetourCACT(ACT:86);POSTransDetail.FlgActionCancelReceipt=Annulation ticket,   // TXT;POSTransDetail.IdtArticle=N° articleKTXT(PIC:999999999999999999999,LEFTPAD:TRUE);POSTransDetail.TxtSrcNumPLU=PLU5TXT(KEYSTR:FALSE);POSTransDetail.TxtDescr=Description#   INT;POSTransDetail.QtyReg=Quantité"PRC;POSTransDetail.PrcInclVAT=Prix%PRC;POSTransDetail.ValInclVAT=MontantPCT;POSTransDetail.PctVAT=% TVA3   TXT(KEYSTR:TRUE);POSTransCust.TxtNumVat=Numéro TVA3TXT;POSTransDetail.IdtClassification=Classification*PCT;POSTransDetail.PctDiscount=% de remise1   INT(RLO:1);POSTransDetail.IdtCredCoup=Bon crédit4   INT(RLO:1);POSTransDetail.IdtPromopack=N° PromopackM   INT(PIC:iiiiiiii,RLO:1,RHI:99999999);POSTransDetail.NumCoupon=N° bon d'achat/INT(RLO:1);POSTransDetail.IdtCVente=Document BOF   TXT;POSTransDetApproval.IdtOperApproval=Détail validation superviseur    �	TGroupBox
GbxFldCondHeight* �TSvcMaskEditSvcMECondLowerOnKeyUpSvcMECondLowerKeyDown  �TSvcLocalFieldSvcLFCondLowerEpoch OnKeyUpSvcLFCondLowerKeyDown	RangeHigh

   �ߌ�3��G  RangeLow

   �ߌ�3���    �TSvcLocalFieldSvcLFCondUpperEpoch       �TOvcControllerOvcCtlConfigRepEntryCommands.TableListDefault	 WordStar Grid     