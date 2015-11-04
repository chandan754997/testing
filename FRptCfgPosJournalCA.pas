//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint
// Unit   : FRptCfgPosJournalCA.PAS : Form RePorT ConFiG POS JOURNAL for
//                                    CAstorama - Form to select the criteria
//                                    of the journals
// Customer : Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCfgPosJournalCA.pas,v 1.23 2010/02/08 09:57:00 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FRptCfgPosJournalCA - CVS revision 1.20
// Version      Modified By    Reason
// V 1.21       AM   (TCS)     R2011.2 BDES-Traductions(A.M)
// V 1.22       TT   (TCS)     R2012.1 - BRES - Format de facture
// V 1.23       AM   (TCS)     R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
// V 1.24       KC   (TCS)     R2012.1 BRES-Facture_multi-tickets(K.C)
// V 1.25       CP   (TCS)     Regression Fix 2012.1
// V 1.26       SC   (TCS)     R2013.1-Internal defect fix 682-BDES
//=============================================================================

unit FRptCfgPosJournalCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FRptCfgPosJournal, OvcBase, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, OvcEF, OvcPB, OvcPF, ScUtils, Buttons, ComCtrls,
  DFpnPosTransaction, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  ScUtils_Dx;

//=============================================================================
// Global definitions
//=============================================================================

Const
  CtMaxTickets    = 1000;
  CtMaxDate       = 30;

resourcestring
  CtTxtErrorCriteria = 'Please use at least one of the following criteria ' +
                       'correctly:' +
                    #10'   - Date range (max. %s days)' +
                    #10'   - Ticket numbers (max. range of %s)' +
                    #10'   - BO Documents';
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtFiscalInfo     = '/VFisc=Print fiscal receipt info on invoice';
  CtTxtItaly          = '/VIt=Italy';
  CtTxtDisableInvoice = '/VDI=Disable possibility to make an invoice';
  CtTxtRussia         = '/VRu=Russia';
  CtTxtPricing        = '/VPR=Pricing';
  CtTxtEnableCustomer = '/VCust=Enable customer functions';
  CtTxtDisableBonPassage= '/VDBP = Disable making or reprinting bon de passage';
  CtTxtHlpCustCard    = '/VCC=Search on customer card n°';
  CtTxtCustCard       = 'N° customer card';
  CtTxtHlpDBRem       = '/VDBRem=Remark text from database';
  CtTxtShowEquals     = '/VEQU=Show equal limit';
  CtTxtMultiRecInv    = '/VMRI=Allow multiple cash receipts for invoice';
  CtTxtEquals         = 'Equals';
  CtTxtAuthorisation  = '/VAUTD=Print authorised by section in cancelled ticket'; //R2011.2 BDES-Traductions(A.M)-Start
  CtTxtInvForm        = '/VINVF=Display new format';                            //R2012.1 - BRES - Format de facture, TT
  CtTxtAnnulation     = '/VAnnulation=Remove line for supervisor';              //R2013.1-defect 682-Fix(sc)
  CtTxtMonth          = '/VMonth=Allow month check for invoice';    //R2012.1 BRES-Facture_multi-tickets(K.C.)
  CtTxtTitle          ='Configuration Report POS Journal';    // Regression Fix R2012.1(Chayanika)
  // TFrmRptCfgPosJournal
//*****************************************************************************

type
  TFrmRptCfgPosJournalCA = class(TFrmRptCfgPosJournal)
    procedure FormActivate(Sender: TObject);  // Regression Fix R2012.1(Chayanika)

    procedure SvcMECondLowerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SvcLFCondLowerKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CbxFieldCondChange(Sender: TObject);
    procedure ActSelCheckoutExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActPreviewExecute(Sender: TObject);
    procedure ActSelOperatorExecute(Sender: TObject);
  private
    { Private declarations }
    FlgSeperateCNNumber   : Boolean;   // Seperate number for creditnotes
    FFlgFiscal            : Boolean;
    FFlgDisableInvoice    : Boolean;
    FFlgItaly             : Boolean;
    FFlgRussia            : Boolean;
    FFlgCustFunc          : Boolean;
    FFlgDisableBonPassage : Boolean;
    FFlgCustCard          : Boolean;
    FFlgRevSign           : Boolean;
    FFlgPricing           : Boolean;
    FFlgMultiRecInv       : Boolean;
    FFlgEquals             : Boolean;
    FFlgAuthorised         : Boolean;      //R2011.2 BDES-Traductions(A.M)
    FFlgInvForm           : Boolean;                                            //R2012.1 - BRES - Format de facture, TT 
    FFlgAnnulation         : Boolean;      //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
    FFlgMonth              : Boolean;      //R2012.1 BRES-Facture_multi-tickets(K.C)
  protected
    procedure ReadParams; virtual;
    function CheckCriteria : boolean; virtual;
    procedure FillCbxCondition; override;
    procedure SetCondItemActive (Value: TObjConditionItem); override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    function AddConditionItemToList (TxtDescription : string;
                                     TxtCondition   : string) :
                                                     TObjConditionItem; override;
  public
    { Public declarations }
    procedure CreateAdditionalModules; override;
  published
    property FlgFiscal: Boolean read FFlgFiscal
                               write FFlgFiscal;
    property FlgItaly: Boolean read FFlgItaly write FFlgItaly;
    property FlgDisableInvoice: Boolean read FFlgDisableInvoice
                                       write FFlgDisableInvoice;
    property FlgRussia: Boolean read FFlgRussia write FFlgRussia;
    property FlgCustFunc: Boolean read FFlgCustFunc
                                 write FFlgCustFunc;
    property FlgDisableBonPassage: Boolean read FFlgDisableBonPassage
                                          write FFlgDisableBonPassage;
    property FlgCustCard: Boolean read FFlgCustCard
                                 write FFlgCustCard;
    property FlgPricing: Boolean read FFlgPricing
                                write FFlgPricing;
    property FlgRevSign: Boolean read FFlgRevSign
                                write FFlgRevSign;
    property FlgMultiRecInv: Boolean read FFlgMultiRecInv
                                    write FFlgMultiRecInv;
    property FlgEquals: Boolean read FFlgEquals
                              write FFlgEquals;
    property FlgAuthorised: Boolean read FFlgAuthorised                         //R2011.2 BDES-Traductions(A.M)
                              write FFlgAuthorised;                             //R2011.2 BDES-Traductions(A.M)
    // R2012.1 - BRES - Format de facture, TT - Start
    property FlgInvForm: Boolean read FFlgInvForm
                                 write FFlgInvForm;
    // R2012.1 - BRES - Format de facture, TT - End
	    property FlgAnnulation: Boolean read FFlgAnnulation                         //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
                              write FFlgAnnulation;                             //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
	// Facture Multi-Tickets, KC, 2012.1 - Start
        property FlgMonth: Boolean read FFlgMonth
                               write FFlgmonth;
    // Facture Multi-Tickets, KC, 2012.1 - End						  
  end;

var
  FrmRptCfgPosJournalCA: TFrmRptCfgPosJournalCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  DB,
  RFpnCom,
  SfDialog,
  SmUtils,  

  DFpnPosTransactionCA,
  FVWPosJournalCA,
  FChkLstOperatorCA,
  IniFiles,
  FVSRptInvoice,
  FVSRptInvoiceCA,
  DFpnCustomerCA,
  DFpnCurrency,
  DFpnMunicipality,
  DFpnBonPassage,
  DFpnOperator,
  DFpnVATCode,
  DFpnCampaign,
  DFpnArtPrice,
  DFpnClassification,
  DFpnArticle,
  DFpnDepartment,
  DFpnTradeMatrix,
  DFpnAddress,
  DFpnArticleCA,
  FChkLstWorkStat,
  MMntInvoice,
  FChkLstWorkStatCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptCfgPosJournalCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCfgPosJournalCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.24 $';
  CtTxtSrcDate    = '$Date: 2011/12/08 09:57:00 $';

//*****************************************************************************
// Implementation of TFrmRptCfgPosJournalCA
//*****************************************************************************

procedure TFrmRptCfgPosJournalCA.CreateAdditionalModules;
begin // of TFrmRptCfgPosJournalCA.CreateAdditionalModules
  if not Assigned (DmdFpnPosTransactionCA) then
    DmdFpnPosTransactionCA := TDmdFpnPostransactionCA.Create (Self);
  if not Assigned (DmdFpnCustomerCA) then
    DmdFpnCustomerCA := TDmdFpnCustomerCA.Create (Self);
  if not Assigned (DmdFpnCurrency) then
    DmdFpnCurrency := TDmdFpnCurrency.Create (Self);
  if not Assigned (DmdFpnMunicipality) then
    DmdFpnMunicipality := TDmdFpnMunicipality.Create (Self);
  if not Assigned (DmdFpnBonPassage) then
    DmdFpnBonPassage := TDmdFpnBonPassage.Create (Self);
  if not Assigned (DmdFpnOperator) then
    DmdFpnOperator := TDmdFpnOperator.Create (Self);
  if not Assigned (DmdFpnVATCode) then
    DmdFpnVATCode := TDmdFpnVATCode.Create (Self);
  if not Assigned (DmdFpnCampaign) then
    DmdFpnCampaign := TDmdFpnCampaign.Create (Self);
  if not Assigned (DmdFpnArtPrice) then
    DmdFpnArtPrice := TDmdFpnArtPrice.Create (Self);
  if not Assigned (DmdFpnClassification) then
    DmdFpnClassification := TDmdFpnClassification.Create (Self);
  if not Assigned (DmdFpnArticle) then
    DmdFpnArticle := TDmdFpnArticle.Create (Self);
  if not Assigned (DmdFpnDepartment) then
    DmdFpnDepartment := TDmdFpnDepartment.Create (Self);
  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Self);
  if not Assigned (DmdFpnAddress) then
    DmdFpnAddress := TDmdFpnAddress.Create (Self);
  if not Assigned (DmdFpnArticleCA) then
    DmdFpnArticleCA := TDmdFpnArticleCA.Create (Self);
  inherited;      
end;  // of TFrmRptCfgPosJournalCA.CreateAdditionalModules

//=============================================================================
// TFrmRptCfgPosJournalCA.ReadParams : Get param out of FpsSyst.ini
//=============================================================================

procedure TFrmRptCfgPosJournalCA.ReadParams;
var
  IniFile            : TIniFile;          // IniObject to the INI-file
  TxtPath            : string;            // Path of the ini-file
  TxtSepNumb         : string;            // String with separate number
begin  // of TFrmRptCfgPosJournalCA.ReadParams
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  TxtSepNumb := IniFile.ReadString('Common', 'SeperateNumberCreditNote', '');
  if Trim (TxtSepNumb) <> '' then
    FlgSeperateCNNumber :=  StrToBool(TxtSepNumb, 'T')
  else
    FlgSeperateCNNumber :=  False;
end;   // of TFrmRptCfgPosJournalCA.ReadParams

//=============================================================================

function TFrmRptCfgPosJournalCA.CheckCriteria : Boolean;
var
  CntItem          : Integer;          // Index in loop
begin  // of TFrmRptCfgPosJournalCA.CheckCriteria
  Result := False;
  for CntItem := 0 to Pred (LbxCondItems.Items.Count) do begin
    if Assigned (LbxCondItems.Items.Objects[CntItem]) and
       (TObjConditionItem(LbxCondItems.Items.Objects[CntItem]).FieldName =
       'IdtPOSTransaction')and
       (TObjConditionItem(LbxCondItems.Items.Objects[CntItem]).Condition <>
       fcNoCondition) and
       (StrToInt(TObjConditionItem(LbxCondItems.Items.Objects[CntItem]).
       ConditionTo) - StrToInt(TObjConditionItem(LbxCondItems.Items.
       Objects[CntItem]).ConditionFrom) <= CtMaxTickets) then
      Result := True
    else if Assigned (LbxCondItems.Items.Objects[CntItem]) and
       (TObjConditionItem(LbxCondItems.Items.Objects[CntItem]).FieldName =
       'IdtCVente') and
       (TObjConditionItem(LbxCondItems.Items.Objects[CntItem]).Condition <>
       fcNoCondition) then
      Result := True;
  end;
  if RbtDateTimeSpecif.Checked and (not Result) and
     (SvcLFDatTo.AsDateTime > 0) and (SvcLFDatFrom.AsDateTime > 0) and
     (SvcLFDatTo.AsDateTime - SvcLFDatFrom.AsDateTime <= CtMaxDate) then
    Result := True;
end;   // of TFrmRptCfgPosJournalCA.CheckCriteria

//=============================================================================

procedure TFrmRptCfgPosJournalCA.FillCbxCondition;
begin // of TFrmRptCfgPosJournalCA.FillCbxCondition
  CbxFieldCond.Clear;
  CbxFieldCond.Items.Add (CtTxtNoCondition);

  if CondItemActive.IsCode then begin
    if not Assigned (CondItemActive.StrLstCodes) then
      CondItemActive.FillStrLstCodes;
    if CondItemActive.StrLstCodes.Count = 0 then
      CondItemActive.IsCode := False
    else
      CbxFieldCond.Items.Add (CtTxtValueIs);
  end;

  if (CondItemActive.CodAction >= 0) and
     (CondItemActive.Fieldname = 'CodAction') then
    CbxFieldCond.Items.Add (CtTxtTicketContainsIt)
  else if CondItemActive.FieldType = ftBoolean then begin
    CbxFieldCond.Items.Add (CtTxtYes);
    CbxFieldCond.Items.Add (CtTxtNo);
  end
  else if not CondItemActive.IsCode then begin
    CbxFieldCond.Items.Add (CtTxtBetweenLimits);
    if CondItemActive.FieldType in [ftString] then
      CbxFieldCond.Items.Add (CtTxtContainsSubStr);
    if FlgEquals then
     CbxFieldCond.Items.Add (CtTxtEquals);
  end;
end;  // of TFrmRptCfgPosJournalCA.FillCbxCondition

//=============================================================================

procedure TFrmRptCfgPosJournalCA.SetCondItemActive (Value: TObjConditionItem);
var
  FlgIsLF          : Boolean;          // Indicates if ranges are LocalFields
begin // of TFrmRptCfgPosJournalCA.SetCondItemActive
  if FCondItemActive <> Value then begin
    FCondItemActive := Value;
    if Value = nil then begin
      GbxFldCond.Visible := False;
      Exit;
    end;
    LblCondition.Caption := FCondItemActive.DisplayName + ':';
    FillCbxCondition;

    // Hide before changing properties
    SvcLFCondLower.Visible := False;
    SvcLFCondUpper.Visible := False;

    FlgIsLF := True;
    case FCondItemActive.FieldType of
      ftInteger : begin
        SvcLFCondLower.DataType := pftLongInt;
        SvcLFCondLower.MaxLength := 11;
      end;
      ftFloat   : SvcLFCondLower.DataType := pftReal;
      else begin
        SvcLFCondLower.DataType := pftString;
        if not SameText (FCondItemActive.Fieldname, 'TxtSrcNumPLU') then
          FlgIsLF := False;
      end;
    end;

    if FlgIsLF then begin
      SvcLFCondLower.RangeLo := FCondItemActive.RangeLo;
      SvcLFCondLower.RangeHi := FCondItemActive.RangeHi;
      SvcLFCondLower.AsString := FCondItemActive.RangeLo;
      if SvcLFCondLower.DataType in [pftLongInt, pftReal] then
        SvcLFCondLower.Options := SvcLFCondLower.Options +
          [efoRightAlign, efoRightJustify]
      else
        SvcLFCondLower.Options := SvcLFCondLower.Options -
          [efoRightAlign, efoRightJustify];

      SvcLFCondUpper.DataType := SvcLFCondLower.DataType;
      SvcLFCondUpper.MaxLength := SvcLFCondLower.MaxLength;
      SvcLFCondUpper.RangeLo := FCondItemActive.RangeLo;
      SvcLFCondUpper.RangeHi := FCondItemActive.RangeHi;
      SvcLFCondUpper.AsString := FCondItemActive.RangeHi;
      if SvcLFCondUpper.DataType in [pftLongInt, pftReal] then
        SvcLFCondUpper.Options := SvcLFCondUpper.Options +
          [efoRightAlign, efoRightJustify]
      else
        SvcLFCondUpper.Options := SvcLFCondUpper.Options -
          [efoRightAlign, efoRightJustify];

      if FCondItemActive.PictureMask <> '' then begin
        SvcLFCondLower.PictureMask := FCondItemActive.PictureMask;
        SvcLFCondUpper.PictureMask := FCondItemActive.PictureMask;
      end
    end;
  end;
    if Value = nil then begin
      GbxFldCond.Visible := False;
      Exit;
    end;

  CbxFieldCond.ItemIndex := Ord(FCondItemActive.Condition);
  if (FCondItemActive.FieldType = ftBoolean) and
     (FCondItemActive.ConditionFrom = '0') then
    CbxFieldCond.ItemIndex := CbxFieldCond.ItemIndex + 1;
  if Assigned(CbxFieldCond.OnChange) then
    CbxFieldCond.OnChange(Self);
  GbxFldCond.Visible := True;
end;  // of TFrmRptCfgPosJournalCA.SetCondItemActive

//=============================================================================
// TFrmRptCfgPosJournalCA - Event handlers
//=============================================================================

procedure TFrmRptCfgPosJournalCA.FormCreate(Sender: TObject);
begin  // of TFrmRptCfgPosJournalCA.FormCreate
  inherited;

  Readparams;
  if FlgSeperateCNNumber then begin
    LbxCondItems.Items.Delete(4);
    LbxCondItems.Items.Insert
         (4, 'INT(RLO:1,RHI:999999);POSTransInvoice.IdtInvoice=' +
         CtTxtInvoiceNumber);
    LbxCondItems.Items.Insert
         (5, 'INT(RLO:1000000);POSTransInvoice.IdtInvoice=' +
         CtTxtCreditNoteNr);
    if FlgCustCard then begin
      LbxCondItems.Items.Insert
         (8, 'TXT;POSTransaction.NumCard=' + CtTxtCustCard);
    end;
    AddConditionItems;
  end
  else begin
    LbxCondItems.Items.Delete(4);
    LbxCondItems.Items.Insert
         (4, 'INT(RLO:1,RHI:9999999);POSTransInvoice.IdtInvoice=' +
         CtTxtInvoiceCreditnote);
    if FlgCustCard then begin
      LbxCondItems.Items.Insert
         (7, 'TXT;POSTransaction.NumCard=' + CtTxtCustCard);
    end;
    AddConditionItems;
  end;
  if not FlgFiscal then begin
    if FlgSeperateCNNumber then begin
      if FlgCustCard then
        LbxCondItems.Items.Delete(12)
      else
        LbxCondItems.Items.Delete(11);
    end
    else begin
      if FlgCustCard then
        LbxCondItems.Items.Delete(11)
      else
        LbxCondItems.Items.Delete(10);
    end;
    AddConditionItems;
  end;
  FrmRptCfgPosJournal := Self;
end;   // of TFrmRptCfgPosJournalCA.FormCreate

//=============================================================================

procedure TFrmRptCfgPosJournalCA.ActPreviewExecute(Sender: TObject);
var
  FlgCheckDate       : boolean;   // is entered date valid?
begin  // of TFrmRptCfgPosJournalCA.ActPreviewExecute
  FlgCheckDate := True;

  if RbtDateTimeSpecif.Checked then begin
    if SvcLFDatTo.AsDateTime = 0 then
      SvcLFDatTo.AsDateTime := Now;
  end;
  if CheckCriteria then begin
    if RbtDateTimeSpecif.Checked then begin
      // Check is DayFrom < DayTo
      if (SvcLFDatFrom.AsDateTime + SvcLFTimFrom.AsDateTime >
         SvcLFDatTo.AsDateTime + SvcLFTimTo.AsDateTime) then begin
        MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
        FlgCheckDate := False;
        SvcLFDatFrom.SetFocus;
      end
      // Check if DayFrom is in the future
      else if SvcLFDatFrom.AsDateTime + SvcLFTimFrom.AsDateTime > Now then begin
        MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
        FlgCheckDate := False;
        SvcLFDatFrom.SetFocus;
      end
      // Check if DayTo is in the future
      else if SvcLFDatTo.AsDateTime > Now then begin
        MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
        FlgCheckDate := False;
        SvcLFDatTo.SetFocus;
      end;
    end;
    if FlgCheckDate then begin
      if not Assigned (FrmVWPosJournalCA) then
        FrmVWPosJournalCA                      := TFrmVWPosJournalCA.Create (Self);
        FrmVWPosJournalCA.FlgFiscal            := FlgFiscal;
        FrmVWPosJournalCA.FlgDisableInvoice    := FlgDisableInvoice;
        FrmVWPosJournalCA.FlgItaly             := FlgItaly;
        FrmVWPosJournalCA.FlgRussia            := FlgRussia;
        FrmVWPosJournalCA.FlgCustFunc          := FlgCustFunc;
        FrmVWPosJournalCA.FlgRevSign           := FlgRevSign;
        FrmVWPosJournalCA.FlgDisableBonPassage := FlgDisableBonPassage;
        FrmVWPosJournalCA.FlgMultiRecInv       := FlgMultiRecInv;
        FrmVWPosJournalCA.FlgAuthorised        := FlgAuthorised; // R2011.2 BDES TCS(AM) Traductions
	    FrmVWPosJournalCA.FlgAnnulation        := FlgAnnulation;  //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
        FrmVWPosJournalCA.FlgMonth             := FlgMonth;      //R2012.1 BRES-Facture_multi-tickets(K.C)
	  // R2012.1 - BRES - Format de facture, TT - Start
      if not Assigned(FrmVSRptInvoiceCA) then
        FrmVSRptInvoiceCA                      := TFrmVSRptInvoiceCA.Create(Self);
        FrmVSRptInvoiceCA.FlgInvForm           := FlgInvForm;
      // R2012.1 - BRES - Format de facture, TT - End
      if SvcLFTimTo.AsDateTime = 0 then
        SvcLFTimTo.AsDateTime := 0.99999;

      if SvcLFTimFrom.AsDateTime = 0 then
        SvcLFTimFrom.AsDateTime := 0;
      inherited;
    end;
  end
  else
    MessageDlg (Format(CtTxtErrorCriteria, [IntToStr(CtMaxDate), IntToStr(
      CtMaxTickets)]), mtError, [mbOK], 0);
end;   // of TFrmRptCfgPosJournalCA.ActPreviewExecute

//=============================================================================

procedure TFrmRptCfgPosJournalCA.ActSelOperatorExecute(Sender: TObject);
begin // of TFrmRptCfgPosJournalCA.ActSelOperatorExecute
  if not Assigned (FrmChkLstOperatorCA) then
    FrmChkLstOperatorCA := TFrmChkLstOperatorCA.Create (Self);
  FrmChkLstOperatorCA.SelectedItems := TxtIdtSelOperator;
  if FrmChkLstOperatorCA.ShowModal = mrOk then begin
    TxtIdtSelOperator := FrmChkLstOperatorCA.SelectedItems;
    RbtOperatorsAll.Checked := (TxtIdtSelOperator = '');
    RbtOperatorsSel.Checked := not RbtOperatorsAll.Checked;
  end;
end; // of TFrmRptCfgPosJournalCA.ActSelOperatorExecute

//=============================================================================

procedure TFrmRptCfgPosJournalCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin // of TFrmRptCfgPosJournalCA.BeforeCheckRunParams
  inherited;
  // param /VFisc toevoegen aan help
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString(CtTxtFiscalInfo, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VDI to help
  SplitString(CtTxtDisableInvoice, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VIt to help
  SplitString(CtTxtItaly, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtPricing, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);

  SplitString(CtTxtRussia, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VCust to help
  SplitString(CtTxtEnableCustomer, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VDBP to help
  SplitString(CtTxtDisableBonPassage, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VCC to help
  SplitString(CtTxtHlpCustCard, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VEQU to help
  SplitString(CtTxtShowEquals, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VMRI to help
  SplitString(CtTxtMultiRecInv, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // add param /VAUTD to help                                                   //R2011.2 BDES-Traductions(A.M)
  SplitString(CtTxtAuthorisation, '=', TxtPartLeft, TxtPartRight);              //R2011.2 BDES-Traductions(A.M)
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);                            //R2011.2 BDES-Traductions(A.M)
// R2012.1 - BRES - Format de facture, TT - Start
  // add param /VINVF to help
  SplitString(CtTxtInvForm, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // R2012.1 - BRES - Format de facture, TT - End
  // add param /VCAFR to help
  SplitString(CtTxtAnnulation, '=', TxtPartLeft, TxtPartRight);                 //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);                            //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  // Facture Multi-Tickets, KC, 2012.1 - Start
  // add param /VMonth to help
  SplitString(CtTxtMonth, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  // Facture Multi-Tickets, KC, 2012.1 - End
end; // of TFrmRptCfgPosJournalCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmRptCfgPosJournalCA.CheckAppDependParams(TxtParam: string);
begin // of TFrmRptCfgPosJournalCA.CheckAppDependParams
  if Copy(TxtParam,3,4)= 'Fisc' then
    FlgFiscal := True
  else if Copy(TxtParam,3,2)= 'DI' then
    FlgDisableInvoice := True
  else if Copy(TxtParam,3,2)= 'It' then
    FlgItaly := True
  else if Copy(TxtParam,3,2)= 'Ru' then
    FlgRussia := True
  else if Copy(TxtParam,3,4)= 'Cust' then
    FlgCustFunc := True
  else if Copy(TxtParam,3,4)= 'DBP' then
    FlgDisableBonPassage := True
  else if Copy(TxtParam,3,2)= 'CC' then
    FlgCustCard := True
  else if Copy(TxtParam,3,7)= 'RevSign' then
    FlgRevSign := True
  else if Copy(TxtParam,3,2)= 'PR' then
    FlgPricing := True
  else if Copy(TxtParam,3,3)= 'MRI' then
    FlgMultiRecInv := True
  else if Copy(TxtParam,3,4)= 'AUTD' then                                       //R2011.2 BDES-Traductions(A.M)
    FlgAuthorised := True                                                       //R2011.2 BDES-Traductions(A.M)
  //Flag for adding the comment line for ticket Annulation for CAFR             //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
   else if Copy(TxtParam,3,10)= 'Annulation' then                               //R2013.1-defect 682-Fix(sc)
    FlgAnnulation := True                                                       //R2012.1 AnnulationTicket_sansAutoeng - TCS(AM)
  else if Copy(TxtParam,3,3)= 'EQU' then
    FlgEquals := True
  // R2012.1 - BRES - Format de facture, TT - Start
  else if Copy(TxtParam,3,4)= 'INVF' then
    FlgInvForm := True
  // R2012.1 - BRES - Format de facture, TT - End
   // Facture Multi-Tickets, KC, 2012.1 - Start
  else if Copy(TxtParam,3,5)= 'Month' then
    FlgMonth := True
 // Facture Multi-Tickets, KC, 2012.1 - End
  else
    inherited;
end; // of TFrmRptCfgPosJournalCA.CheckAppDependParams

//=============================================================================

procedure TFrmRptCfgPosJournalCA.ActSelCheckoutExecute(Sender: TObject);
begin // of TFrmRptCfgPosJournalCA.ActSelCheckoutExecute
  if not Assigned (FrmChkLstWorkstat) then
    FrmChkLstWorkstat := TFrmChkLstWorkstatCA.Create (Self);
  inherited;
end; // of TFrmRptCfgPosJournalCA.ActSelCheckoutExecute

//=============================================================================

function TFrmRptCfgPosJournalCA.AddConditionItemToList (TxtDescription : string;
                                                        TxtCondition   : string) :
                                                              TObjConditionItem;
var
  TxtTable         : string;           // TableName to get field from
  TxtField         : string;           // Name of the field used by condition
  TxtType          : string;           // Typ of the field
  TxtOptions       : string;           // Options for the condition
  StrLstOptions    : TStringList;      // String list for options
  CntIndex         : Integer;          // Index for loop
  TxtOptionName    : string;           // Name of an option
  TxtOptionValue   : string;           // Value of an option
begin // of TFrmRptCfgPosJournalCA.AddConditionItemToList
  Result := TObjConditionItemCA.Create;
  try
    Result.CodAction := -1;
    Result.FieldType := ftUnknown;
    Result.DisplayName := TxtDescription;

    SplitString (TxtCondition, ';', TxtType, TxtField);

    // Extract TableName and FieldName from TxtField
    if AnsiPos ('.', TxtField) > 0 then begin
      SplitString (TxtField, '.', TxtTable, TxtField);
      Result.TableName := TxtTable;
    end
    else
      Result.TableName := 'PosTransaction';
    Result.FieldName := TxtField;

    // Extract Type and Options from TxtType
    SplitString (TxtType, '(', TxtType, TxtOptions);
    TxtOptions := Copy (TxtOptions, 1, Length (TxtOptions) -1);

    ConfigConditionType (Result, TxtType, TxtCondition);
    if TxtOptions <> '' then begin
      StrLstOptions := TStringList.Create;
      try
        StrLstOptions.CommaText := TxtOptions;
        for CntIndex := 0 to Pred (StrLstOptions.Count) do begin
          SplitString (StrLstOptions.Strings[CntIndex], ':', TxtOptionName,
                       TxtOptionValue);
          ConfigConditionOption (Result, TxtOptionName, TxtOptionValue,
                                 TxtCondition);
      end;
      finally
        StrLstOptions.Free;
      end;
    end;
    Result.IsCode := Result.IsCode and (Result.ApplicConvTable <> '') and
                     (Result.ApplicConvField <> '');
  except
    Result.Free;
    raise;
  end;
end;  // of TFrmRptCfgPosJournalCA.AddConditionItemToList

//=============================================================================
// TFrmRptCfgPosJournalCA.CbxFieldCondChange :  : overriden to fix some
// deficiencies in the parent method.
//                                  -----
// DO NOT CALL inherited, because parent method has bugs that we try to fix
// here.
//=============================================================================


procedure TFrmRptCfgPosJournalCA.CbxFieldCondChange(Sender: TObject);
var
  CntItem          : Integer;          // Index in loop
  FlgIsLF          : Boolean;          // Indicates if ranges are LocalFields
begin  // of TFrmRptCfgPosJournalCA.CbxFieldCondChange
  LblCondLower.Visible      := False;
  LblCondUpper.Visible      := False;
  LblCondSubStr.Visible     := False;
  SvcLFCondLower.Visible    := False;
  SvcLFCondUpper.Visible    := False;
  SvcMECondLower.Visible    := False;
  SvcMECondUpper.Visible    := False;
  CbxCondLower.Visible      := False;
  CbxCondUpper.Visible      := False;
  CbxFieldCondCodes.Visible := False;

  if CondItemActive.FieldType = ftBoolean then begin
    case CbxFieldCond.ItemIndex of
      0 : CondItemActive.Condition := fcNoCondition;
      1 : begin
        CondItemActive.Condition := fcInLimits;
        CondItemActive.ConditionFrom := '1';
        CondItemActive.ConditionTo := '1';
      end;
      2 : begin
        CondItemActive.Condition := fcInLimits;
        CondItemActive.ConditionFrom := '0';
        CondItemActive.ConditionTo := '0';
      end;
    end;
  end  // of CondItemActive.FieldType = ftBoolean

  else if CondItemActive.IsCode then begin
    case CbxFieldCond.ItemIndex of
      0 : CondItemActive.Condition := fcNoCondition;
      1 : begin
        FillCbxCodes;
        CondItemActive.Condition := fcInLimits;
        CbxFieldCondCodes.Visible := True;
        CbxFieldCondCodes.ItemIndex := 0;
        if CondItemActive.Conditionfrom <> '' then begin
          for CntItem := 0 to Pred (CbxFieldCondCodes.Items.Count) do
            if Integer(CbxFieldCondCodes.Items.Objects[CntItem])
                   = StrToInt (CondItemActive.ConditionFrom) then begin
              CbxFieldCondCodes.ItemIndex := CntItem;
              Break;
            end;
        end;    
      end;
    end;
  end  // of CondItemActive.IsCode

  else begin
    FlgIsLF := (FCondItemActive.FieldType in [ftInteger, ftFloat]) or
               (SameText (FCondItemActive.Fieldname, 'TxtSrcNumPLU'));
    CondItemActive.Condition := TCodFieldCond(CbxFieldCond.ItemIndex);
    if CbxFieldCond.Text = CtTxtEquals then CondItemActive.Condition := fcInLimits;
    case CondItemActive.Condition of
      fcNoCondition: begin
      end;
      fcInLimits: begin
        if CondItemActive.ConditionFrom = '' then
          CondItemActive.ConditionFrom := CondItemActive.RangeLo;
        if CondItemActive.ConditionTo = '' then
          CondItemActive.ConditionTo := CondItemActive.RangeHi;
        LblCondLower.Visible := True;
        LblCondUpper.Visible := True;
        if FlgIsLF then begin
          SvcLFCondLower.Visible := True;
          SvcLFCondUpper.Visible := True;
          if CondItemActive.FieldType = FtFloat then
            SvcLFCondLower.AsFloat := StrToFloat(CondItemActive.ConditionFrom)
          else
            SvcLFCondLower.Text := CondItemActive.ConditionFrom;
          if CondItemActive.FieldType = FtFloat then
            SvcLFCondUpper.AsFloat := StrToFloat (CondItemActive.ConditionTo)
          else
            SvcLFCondUpper.Text := CondItemActive.ConditionTo;
        end
        else begin
          SvcMECondLower.Visible := True;
          SvcMECondUpper.Visible := True;
          SvcMECondLower.TrimText := CondItemActive.ConditionFrom;
          SvcMECondUpper.TrimText := CondItemActive.ConditionTo;
        end;
        if CbxFieldCond.Text = CtTxtEquals then begin
          SvcMECondUpper.Visible := False;
          SvcLFCondUpper.Visible := False;
          LblCondUpper.Visible := False;
        end;
      end;
      fcSubString: begin
        LblCondSubstr.Visible := True;
        if FlgIsLF then begin
          SvcLFCondLower.Visible := True;
          SvcLFCondLower.Text := CondItemActive.ConditionSubstr;
        end
        else begin
          SvcMECondLower.Visible := True;
          SvcMECondLower.TrimText := CondItemActive.ConditionSubstr;
        end;
      end;
    end;
  end;
  LbxCondItems.Repaint;
end;   // of TFrmRptCfgPosJournalCA.CbxFieldCondChange

//=============================================================================

procedure TFrmRptCfgPosJournalCA.SvcLFCondLowerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmRptCfgPosJournalCA.SvcLFCondLowerKeyDown
  inherited;
  if CbxFieldCond.Text = CtTxtEquals then begin
    if SvcLFCondUpper.DataType  = pftReal then
      SvcLFCondUpper.AsFloat := StrToFloat(CondItemActive.ConditionFrom);
    if SvcLFCondUpper.DataType  = pftLongInt then
      SvcLFCondUpper.AsInteger := StrToInt(CondItemActive.ConditionFrom);
    CondItemActive.ConditionTo := CondItemActive.ConditionFrom;
  end;
end;   // of TFrmRptCfgPosJournalCA.SvcLFCondLowerKeyDown

//=============================================================================

procedure TFrmRptCfgPosJournalCA.SvcMECondLowerKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmRptCfgPosJournalCA.SvcMECondLowerKeyDown
  inherited;
  if CbxFieldCond.Text = CtTxtEquals then
    SvcMECondUpper.Text := SvcMECondLower.Text;
end;  // of TFrmRptCfgPosJournalCA.SvcMECondLowerKeyDown

//=============================================================================

// Regression Fix R2012.1(Chayanika):: Start
procedure TFrmRptCfgPosJournalCA.FormActivate(Sender: TObject);
begin
  inherited;
 Application.Title:= CtTxtTitle;
end;
// Regression Fix R2012.1(Chayanika):: End

//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
