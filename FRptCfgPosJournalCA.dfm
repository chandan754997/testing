inherited FrmRptCfgPosJournalCA: TFrmRptCfgPosJournalCA
  Height = 488
  PixelsPerInch = 96
  TextHeight = 13
  inherited StsBarExec: TStatusBar
    Top = 420
  end
  inherited PgsBarExec: TProgressBar
    Top = 404
  end
  inherited GbxLogging: TGroupBox
    Left = 288
    Top = -83
  end
  inherited PgeCtlCriteria: TPageControl
    Height = 326
    inherited TabShtMainCriteria: TTabSheet
      inherited GbxDateHour: TGroupBox
        inherited GbxSpecifDate: TGroupBox
          inherited LblTo: TLabel
            Left = 152
          end
          inherited SvcLFDatFrom: TSvcLocalField
            Width = 81
            AutoSize = False
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcLFDatTo: TSvcLocalField
            Left = 152
            Width = 81
            AutoSize = False
            Epoch = 0
            RangeHigh = {25600D00000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcLFTimFrom: TSvcLocalField
            Width = 81
            AutoSize = False
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
          inherited SvcLFTimTo: TSvcLocalField
            Left = 152
            Width = 81
            AutoSize = False
            Epoch = 0
            RangeHigh = {7F510100000000000000}
            RangeLow = {00000000000000000000}
          end
        end
      end
      inherited GbxOptions: TGroupBox
        inherited ChkShowApproval: TCheckBox
          Width = 200
        end
      end
    end
    inherited TabShtDetailCriteria: TTabSheet
      inherited SbxRptCfg: TScrollBox
        Height = 298
        inherited SptRptCfgChoice: TSplitter
          Height = 298
        end
        inherited PnlLeft: TPanel
          Height = 298
          inherited LbxCondItems: TListBox
            Height = 298
            Items.Strings = (
              '// For translator : Translate after '#39'='#39
              '// For developer: see description of LbxCondItems in source'
              '--- Header Items ---'
              'INT(RLO:0);POSTransaction.IdtPOSTransaction=Ticket Number'
              
                'COD(ACTBL:POSTrans,ACFLD:CodTrans);POSTransaction.CodTrans=Trans' +
                'action Code'
              'INT(RLO:1);POSTransInvoice.IdtDelivNote=Delivery Note'
              'INT(RLO:1);POSTransInvoice.IdtInvoice=Invoice Number'
              'INT(RLO:0,INULL:TRUE);POSTransCust.IdtCustomer=Customer Number'
              'TXT(KEYSTR:FALSE);POSTransCust.TxtName=Customer Name'
              'FLG;POSTransaction.FlgTraining=Training Flag'
              
                'COD(ACTBL:POSTrans,ACFLD:CodReturn);POSTransaction.CodReturn=Ret' +
                'urn Code'
              'TXT;POSTransApproval.IdtOperApproval=Supervisor Validation'
              'INT(RLO:0);POSTransaction.NumFiscalTicket=Fiscal Ticket Number'
              '--- Detail Line Items ---'
              
                'PRC(FLD:ValInclVat,ACT:13);POSTransDetail.ValInclVAT=Ticket Tota' +
                'l Incl. VAT'
              'ACT(ACT:7);POSTransDetail.FlgActionCorrection=Correction'
              'ACT(ACT:6);POSTransDetail.FlgActionAnnulation=Annulation'
              'ACT(ACT:8);POSTransDetail.FlgActionReturn=Return'
              'ACT(ACT:86);POSTransDetail.FlgActionCancelReceipt=Cancel Receipt'
              '// TXT;POSTransDetail.IdtArticle=Article Number'
              
                'TXT(PIC:999999999999999999999,LEFTPAD:TRUE);POSTransDetail.TxtSr' +
                'cNumPLU=PLU Number'
              'TXT(KEYSTR:FALSE);POSTransDetail.TxtDescr=Description'
              'INT;POSTransDetail.QtyReg=Quantity'
              'PRC;POSTransDetail.PrcInclVAT=Price'
              'PRC;POSTransDetail.ValInclVAT=Amount'
              'PCT;POSTransDetail.PctVAT=% VAT'
              'TXT(KEYSTR:TRUE);POSTransCust.TxtNumVat=VAT Number'
              'TXT;POSTransDetail.IdtClassification=Classification'
              'PCT;POSTransDetail.PctDiscount=% Discount'
              'INT(RLO:1);POSTransDetail.IdtCredCoup=Credit Coupon'
              'INT(RLO:1);POSTransDetail.IdtPromopack=Promopack Number'
              
                'INT(PIC:iiiiiiii,RLO:1,RHI:99999999);POSTransDetail.NumCoupon=Co' +
                'upon Number'
              'INT(RLO:1);POSTransDetail.IdtCVente=BO Document'
              
                'TXT;POSTransDetApproval.IdtOperApproval=Detail Supervisor Valida' +
                'tion')
          end
        end
        inherited GbxFldCond: TGroupBox
          Height = 298
          inherited SvcMECondLower: TSvcMaskEdit
            OnKeyUp = SvcMECondLowerKeyDown
          end
          inherited SvcLFCondLower: TSvcLocalField
            Epoch = 0
            OnKeyUp = SvcLFCondLowerKeyDown
            RangeHigh = {ADDF8CC733F9DF470000}
            RangeLow = {ADDF8CC733F9DFC70000}
          end
          inherited SvcLFCondUpper: TSvcLocalField
            Epoch = 0
          end
        end
      end
    end
  end
  inherited OvcCtlConfigRep: TOvcController
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
