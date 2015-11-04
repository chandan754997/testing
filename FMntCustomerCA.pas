//= Copyright 2009 (c) Real Software NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FMntCustomerCA.PAS : MainForm MaiNTenance CUSTOMER for Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCustomerCA.pas,v 1.7 2010/04/27 11:43:56 BEL\DVanpouc Exp $
// History:
// Version                              Modified By                          Reason
// V 1.8                                V.K.R (TCS)                          R2011.1 - BDFR - Suppression Local Client
// V 1.9                                KB.   (TCS)	                         R2011.1 - BDFR - Siret No.
// V 1.10                               TT.   (TCS)                          R2011.2 - BRES - Ficha Cliente
// V 1.11                               AM.   (TCS)                          R2011.2 - BDES - Creation Of Client Management of Post Code
// V 1.12                               SM    (TCS)                          R2012.1 - BDFR - Address de Facturation
// V 1.13                               SC    (TCS)                          R2012.1-5401-BRFR-Flux_des_clients_en_compte
// V 1.14                               SPN   (TCS)      		                 R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet
// V 1.15                               AJ    (TCS)                          R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
//=============================================================================

unit FMntCustomerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntCustomer, ScTskMgr_BDE_DBC;
  //FLstMunicipality;                              //R2011.2 - BDES - Creation Of Client Management of Post Code

//=============================================================================
// Resource strings
//=============================================================================

resourcestring  // for runtime parameters
  CtTxtRunParamRequiredVAT = 'VAT number is a required field';
  CtTxtRunParamCheckVAT    = 'Check VAT number';
  CtTxtRunParamRussia      = 'Russia';
  CtTxtRunParamCredit      = 'Disable Credit';
  CtTxtRunParamExpiry      = 'Invoice Expiry';
  CtTxtRunParamCustCard    = 'Customer card';
  CtTxtRunParamDelayDelete = 'Delay delete';
  CtTxtRunParamDelLocal    = 'Delete Local Client';                             //Suppression Local Clients, VKR, R2011.1, BDFR
  CtTxtCompanyNameSiret    = 'Display Siret Number';                            //Siret No, Modified by TCS(KB), R2011.1
  CtTxtRunParamBDFR        = 'BDFR';                   //R2012.1 Address De Facturation
  CtTxtMandAuthorisation   = 'Display validation message for a new client';     //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  CtTxtDisableTVAfrmSap    = 'Disable the N° TVA  field when data comes from SAP'; //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
  CtTxtAppTitle            = 'Maintenance Client';   //R2011.2 Phase 2 Defect 51 Fix - AM
  CtTxtRunParamBDES        = 'BDES';                                            //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmMntCustomerCA = class(TFrmMntCustomer)
    SvcFrmBonPassageReport: TSvcFormTask;
    SvcFrmBonPassage: TSvcFormTask;
    SvcFrmReprintBonPassage: TSvcFormTask;                                    //Ficha Cliente, TT, R2011.2
    procedure SvcFrmCustomerSheetReportCreateExecutor(Sender: TObject;          //Ficha Cliente, TT, R2011.2
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure SvcTskLstCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstAddressForCustomerCreateExecutor(
      Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstMunicipalityForAddressCreateExecutor(
      Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstSupplierForAddressCreateExecutor(
      Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstCustPrcCatForCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetMunicipalityCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCustPrcCatCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCustCardCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetCustCardBeforeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
    procedure SvcFrmBonPassageReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcFrmBonPassageCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcFrmReprintBonPassageCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgCheckVAT      : Boolean;
    FFlgVATRequired   : Boolean;
    FFlgRussia        : Boolean;
    FFlgBDFR          : Boolean;       //R2012.1 Address De Facturation
    FFlgDisableCredit : Boolean;
    FFlgInvExp        : Boolean;
    FFlgCustCard      : Boolean;
    FFlgDelayDel      : Boolean;
    FFlgDelLocal      : Boolean;       // Suppression Local Clients, VKR, R2011.1, BDFR
	  FFlagSiretNo      : Boolean;       // Siret No, Modified by TCS(KB), R2011.1
    FFlgCustomerSheet : Boolean;       //Ficha Cliente, TT, R2011.2
    FFlgMandatory     : Boolean;       //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
    FFlgDisableTVAFrmSap : Boolean;    //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
    FFlgBDES          : Boolean;       //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
    FFlgCustomerFromSAP: Boolean;                                               // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
    FStoreNum: String;                                                          // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
  protected
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    function GetStoreNum : string; // akash added
  public
    { Public declarations }
    property FlgCheckVAT : Boolean read FFlgCheckVAT write FFlgCheckVAT;
    property FlgVatRequired : Boolean read FFlgVATRequired write FFlgVATRequired;
    property FlgRussia : Boolean read FFlgRussia write FFlgRussia;
    property FlgBDFR : Boolean read FFlgBDFR write FFlgBDFR;                    //R2012.1 Address De Facturation
    property FlgDisableCredit : Boolean read FFlgDisableCredit
                                       write FFlgDisableCredit;
    property FlgInvExp : Boolean read FFlgInvExp write FFlgInvExp;
    property FlgCustCard : Boolean read FFlgCustCard write FFlgCustCard;
    property FlgDelayDel : Boolean read FFlgDelayDel write FFlgDelayDel;
    property FlgDelLocal : Boolean read FFlgDelLocal write FFlgDelLocal;        // Suppression Local Clients, VKR, R2011.1, BDFR
	property FlgSiretNo : Boolean read FFlagSiretNo write FFlagSiretNo;         //Siret No, Modified by TCS(KB), R2011.1
    property FlgCustomerSheet : Boolean read FFlgCustomerSheet                  //Ficha Cliente, TT, R2011.2
                                        write FFlgCustomerSheet;                //Ficha Cliente, TT, R2011.2
    property FlgMandatory : Boolean read FFlgMandatory                          //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
                                  write FFlgMandatory;                          //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
    property FlgDisableTVAFrmSap : Boolean read FFlgDisableTVAFrmSap
                                  write FFlgDisableTVAFrmSap;                   //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
    property FlgBDES : Boolean read FFlgBDES write FFlgBDES;                    //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
    // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.Start
    property FlgCustomerFromSAP    : Boolean read FFlgCustomerFromSAP
                                            write FFlgCustomerFromSAP;
    property StoreNum    : String read FStoreNum
                                   write FStoreNum;                            
    // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.End
  end;

var
  FrmMntCustomerCA: TFrmMntCustomerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,
  SmUtils,

  MFpnAddOn,

  DFpn,
  DFpnUtils,

  DFpnAddress,
  DFpnAddressCA,
  DFpnCustomer,
  DFpnCustomerCA,
  DFpnCustPrcCat,
  DFpnMunicipality,
  DFpnMunicipalityCA,
  DFpnSupplier,

  FBonPassageCA,
  FReprintBonPassageCA,
  FDetAddress,
  FDetCustCardCA,
  FDetCustomerCA,
  FDetCustPrcCat,
  FDetMunicipality,
  FDetMunicipalityCA,
  FVSBonPassageCA,
  FLstCustCA, // Suppression Local Clients, VKR, R2011.1, BDFR
  FLstMunicipality,                              //R2011.2 - BDES - Creation Of Client Management of Post Code
  FVSCustomerSheet;  //Ficha Cliente, TT, R2011.2

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCustomerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCustomerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.14 $';
  CtTxtSrcDate    = '$Date: 2013/10/03 17:37:50 $';

//*****************************************************************************
// Implementation of TFrmMntCustomerCA
//*****************************************************************************

procedure TFrmMntCustomerCA.FormActivate(Sender: TObject);
begin  // of TFrmMntCustomerCA.FormActivate
  inherited;
  Application.Title := CtTxtAppTitle;  //R2011.2 Phase 2 Defect 51 Fix - AM
  if FlgFullFunc then begin
    SvcTskLstSupplierForAddress.Enabled := True;
    SvcTskLstMunicipalityForAddress.Enabled := True;
    SvcTskLstCustPrcCatForCustomer.Enabled := True;
    SvcTskDetCustPrcCat.Enabled := True;
  end;   // of if FlgFullFunc
end;   // of TFrmMntCustomerCA.FormActivate

//=============================================================================
//Suppression Local Clients, VKR, R2011.1, BDFR - Start

procedure TFrmMntCustomerCA.SvcTskLstCustomerCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskLstCustomerCreateExecutor
//Siret No, Modified by TCS(KB), R2011.1
 if FlgSiretNo = False then
 begin
  SvcTskLstCustomer.HiddenFields.Add('TxtCompanyType');    
  SvcTskLstCustomer.Sequences.Delete(6);
 end;
// End Modification 
//  NewObject := TFrmList.Create (Self);
	NewObject := TFrmLstCustCA.Create (Self);
  if DmdFpnCustomerCA.FlgClientMarketing then
    //TFrmList(NewObject).AllowedJobs := [CtCodJobRecMod,CtCodJobRecCons]
    TFrmLstCustCA(NewObject).AllowedJobs := [CtCodJobRecMod,CtCodJobRecCons]
  else
    //TFrmList(NewObject).AllowedJobs := SetEntryCmds;
    TFrmLstCustCA(NewObject).AllowedJobs := SetEntryCmds;
    FlgCreated := True;
    TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskLstCustomerCreateExecutor

//Suppression Local Clients, VKR, R2011.1, BDFR - End

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskLstAddressForCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskLstAddressForCustomerCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskLstAddressForCustomerCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskLstMunicipalityForAddressCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskLstMunicipalityForAddressCreateExecutor
//R2011.2 - BDES - Creation Of Client Management of Post Code(AM)-Start
 If  FlgMandatory = True then begin
   NewObject := TFrmListMunicipality.Create (Self);
   TFrmListMunicipality(NewObject).AllowedJobs := SetEntryCmds + [CtCodJobRecSel];
   FlgCreated := True;
   TSvcFormTask(Sender).DynamicExecutor := False;
 end
 else begin
 //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)-End
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds + [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
 end;                                                                            //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
end;   // of TFrmMntCustomerCA.SvcTskLstMunicipalityForAddressCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskLstSupplierForAddressCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskLstSupplierForAddressCreateExecutor
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskLstSupplierForAddressCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskLstCustPrcCatForCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskLstCustPrcCatForCustomerCreateExecutor
  inherited;
  NewObject := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := SetEntryCmds + [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskLstCustPrcCatForCustomerCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetCustomerCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetCustomerCreateExecutor
  NewObject := TFrmDetCustomerCA.Create (Self);
  TFrmDetCustomerCA(NewObject).FlgCheckVAT      := FlgCheckVAT;
  TFrmDetCustomerCA(NewObject).FlgVATRequired   := FlgVATRequired;
  TFrmDetCustomerCA(NewObject).FlgRussia        := FlgRussia;
  TFrmDetCustomerCA(NewObject).FlgBDFR          := FlgBDFR;                      //R2012.1 Address De Facturation
  TFrmDetCustomerCA(NewObject).FlgDisableCredit := FlgDisableCredit;
  TFrmDetCustomerCA(NewObject).FlgInvExp        := FlgInvExp;
  TFrmDetCustomerCA(NewObject).FlgCustCard      := FlgCustCard;
  TFrmDetCustomerCA(NewObject).FlgDelayDel      := FlgDelayDel;
  TFrmDetCustomerCA(NewObject).FlgSiretNo       := FlgSiretNo;                  //Siret No, Modified by TCS(KB), R2011.1
  TFrmDetCustomerCA(NewObject).FlgCustomerSheet := FlgCustomerSheet;            // Ficha Cliente, TT, R2011.2
  TFrmDetCustomerCA(NewObject).FlgMandatory     := FlgMandatory;                //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  TFrmDetCustomerCA(NewObject).FlgDisableTVAFrmSap     := FlgDisableTVAFrmSap;  //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
  TFrmDetCustomerCA(NewObject).FlgBDES          := FlgBDES;                     //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
  TFrmDetCustomerCA(NewObject).FlgCustomerFromSAP := FlgCustomerFromSAP;        // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
  TFrmDetCustomerCA(NewObject).StoreNum := StoreNum;                            // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskDetCustomerCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetAddressCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetAddressCreateExecutor
  NewObject  := TFrmDetAddress.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskDetAddressCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetMunicipalityCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetMunicipalityCreateExecutor
  NewObject := TFrmDetMunicipalityCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskDetMunicipalityCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetCustPrcCatCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetCustPrcCatCreateExecutor
  inherited;
  NewObject := TFrmDetCustPrcCat.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskDetCustPrcCatCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetCustCardCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetCustCardCreateExecutor
  NewObject := TFrmDetCustCardCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcTskDetCustCardCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcTskDetCustCardBeforeExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
begin  // of TFrmMntCustomerCA.SvcTskDetCustCardBeforeExecute
  inherited;
  TFrmDetCustCardCA(TSvcFormTask(Sender).Executor).FlgAllowModNumCard :=
    FlgFullFunc;
  TFrmDetCustCardCA(TSvcFormTask(Sender).Executor).FlgAllowModPntStat :=
    FlgFullFunc;
end;   // of TFrmMntCustomerCA.SvcTskDetCustCardBeforeExecute

//=============================================================================

procedure TFrmMntCustomerCA.SvcFrmBonPassageReportCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcFrmBonPassageReportCreateExecutor
  inherited;
  NewObject  := TFrmVSBonPassageCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcFrmBonPassageReportCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcFrmBonPassageCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcFrmBonPassageCreateExecutor
  inherited;
  NewObject  := TFrmBonPassageCA.Create (Self);
  FlgCreated := True;
  TFrmBonPassageCA(NewObject).Russia := FlgRussia;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcFrmBonPassageCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.SvcFrmReprintBonPassageCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCustomerCA.SvcFrmReprintBonPassageCreateExecutor
  inherited;
  NewObject  := TFrmReprintBonPassageCA.Create (Self);
  FlgCreated := True;
  TFrmReprintBonPassageCA(NewObject).Russia := FlgRussia;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCustomerCA.SvcFrmReprintBonPassageCreateExecutor

//=============================================================================

procedure TFrmMntCustomerCA.BeforeCheckRunParams;
begin  // of TFrmMntCustomerCA.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams ('/VReqVAT', CtTxtRunParamRequiredVAT);
  AddRunParams ('/VCheckVAT', CtTxtRunParamCheckVAT);
  AddRunParams ('/VRussia', CtTxtRunParamRussia);
  AddRunParams ('/VBDFR', CtTxtRunParamBDFR);                                   //R2012.1 Address De Facturation
  AddRunParams ('/VDC', CtTxtRunParamCredit);
  AddRunParams ('/VExp', CtTxtRunParamExpiry);
  AddRunParams ('/VCC', CtTxtRunParamCustCard);
  AddRunParams ('/VDD', CtTxtRunParamDelayDelete);
  AddRunParams ('/VDL', CtTxtRunParamDelLocal);                                 //Suppression Local Clients, VKR, R2011.1, BDFR
  AddRunParams ('/VSiret', CtTxtCompanyNameSiret);                              //Siret No, Modified by TCS(KB), R2011.1
  AddRunParams ('/VMndy', CtTxtMandAuthorisation);                              //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  AddRunParams ('/VDisableTVAFrmSAP', CtTxtDisableTVAfrmSap);                   //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
  AddRunParams ('/VBDES', CtTxtRunParamBDES);                                   //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN
end;   // of TFrmMntCustomerCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntCustomerCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmMntCustomerCA.CheckAppDependParams
  if AnsiCompareText (Copy(TxtParam, 3, 6), 'ReqVAT') = 0 then
    FlgVatRequired := True;
  if AnsiCompareText (Copy(TxtParam, 3, 8), 'CheckVAT') = 0 then
    FlgCheckVAT := True;
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'Ru') = 0 then
    FlgRussia := True;
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'BDFR') = 0 then                    //R2012.1 Address De Facturation
    FlgBDFR := True;
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'DC') = 0 then
    FlgDisableCredit := True;
  if AnsiCompareText (Copy(TxtParam, 3, 3), 'Exp') = 0 then
    FlgInvExp := True;
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'CC') = 0 then
    FlgCustCard := True;
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'DD') = 0 then
    FlgDelayDel := True;
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'DL') = 0 then                      //Suppression Local Clients, VKR, R2011.1, BDFR
    FlgDelLocal := True;
  if AnsiCompareText (Copy(TxtParam, 3, 5), 'Siret') = 0 then                   //Siret No, Modified by TCS(KB), R2011.1
    FlgSiretNo := True;                                                         //Siret No, Modified by TCS(KB), R2011.1
  if AnsiCompareText (Copy(TxtParam, 3, 2), 'PR') = 0 then                      //Ficha Cliente, TT, R2011.2
    FlgCustomerSheet := True;                                                   //Ficha Cliente, TT, R2011.2
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'MNDY') = 0 then                    //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
    FlgMandatory := True;                                                       //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte--start
  if AnsiCompareText (Copy(TxtParam, 3, 18), 'DisableTVAFrmSAP') = 0 then
    FlgDisableTVAFrmSap := True;
  //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte--end
  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.start
  if AnsiCompareText (Copy(TxtParam, 3, 4), 'BDES') = 0 then
    FlgBDES := True;
  //R2013.2.ID26010.BDES.Commercial-information-in-the-customer-sheet.TCS-SPN.end
  // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.Start
  if AnsiCompareText (Copy(TxtParam, 3, 6), 'FCFSAP') = 0 then begin
    FlgCustomerFromSAP := True;
    StoreNum := GetStoreNum;
  end;
  // R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.End
end;   // of TFrmMntCustomerCA.CheckAppDependParams
//=============================================================================
// R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.Start

function TFrmMntCustomerCA.GetStoreNum : string;
begin
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtTradeMatrix' +
                #10'FROM TradeMatrix (NOLOCK)') then
        Result := DmdFpnUtils.QryInfo.FieldByName ('IdtTradeMatrix').AsString ;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;
// R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.End

//=============================================================================
//Ficha Cliente, TT, R2011.2 - Start
//=============================================================================
procedure TFrmMntCustomerCA.SvcFrmCustomerSheetReportCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  inherited;
  NewObject  := TFrmVSCustomerSheet.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;
//Ficha Cliente, TT, R2011.2 - End
//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FMntCustomerCA
