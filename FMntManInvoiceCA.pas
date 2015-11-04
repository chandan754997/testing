//=========== Sycron Computers Belgium (c) 2003 ===============================
// Packet : Manuel Invoice
// Unit   : FMntManInvoiceCA.PAS : Form MaiNTenance MANuele INVOICES
// Customer : Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntManInvoiceCA.pas,v 1.4 2009/10/15 10:20:08 BEL\BHofmans Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FMntManInvoiceCA - CVS revision 1.21
//=============================================================================

unit FMntManInvoiceCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FFpnMnt, ScTskMgr_BDE_DBC, DBTables;
//=============================================================================
// Global definitions
//=============================================================================

resourcestring
  CtTxtPricing        = '/VPR=Pricing';

//=============================================================================
// TFrmMntManInvoiceCA
//=============================================================================

type
  TFrmMntManInvoiceCA = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskDetManInvoice: TSvcFormTask;
    SvcTskDetManInvoiceArticle: TSvcFormTask;
    SvcTskDetManInvoiceComment: TSvcFormTask;
    SvcTskDetManInvoicePayments: TSvcFormTask;
    SvcTskLstArticle: TSvcListTask;
    SvcTskLstCustomer: TSvcListTask;
    SvcTskLstClassification: TSvcListTask;
    SvcTskDetCustomer: TSvcFormTask;
    SvcTskDetDepartment: TSvcFormTask;
    procedure SvcTskDetManInvoiceCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoiceArticleCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoiceCommentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetManInvoicePaymentsCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstArticleCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstClassificationCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskLstClassificationBeforeExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
    procedure SvcTskDetCustomerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetDepartmentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
    FFlgFiscal: Boolean;
    FFlgItaly: Boolean;
    FFlgRussia: Boolean;
    FFlgDisableBonPassage: Boolean;
    FFlgCustFunc: Boolean;
    FFlgPricing    : Boolean;
  protected
    SprRTLstClass  : TStoredProc;      // Runtime Spr for Classification
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
  published
    property FlgFiscal: Boolean read FFlgFiscal
                               write FFlgFiscal;
    property FlgItaly: Boolean read FFlgItaly
                               write FFlgItaly;
    property FlgRussia: Boolean read FFlgRussia
                               write FFlgRussia;
    property FlgDisableBonPassage: Boolean read FFlgDisableBonPassage
                                          write FFlgDisableBonPassage;
    property FlgCustFunc: Boolean read FFlgCustFunc
                                          write FFlgCustFunc;
    property FlgPricing: Boolean read FFlgPricing
                                  write FFlgPricing;
  end;  // of TFrmMntManInvoiceCA

var
  FrmMntManInvoiceCA: TFrmMntManInvoiceCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SfList_BDE_DBC,
  SmUtils,
  SmDBUtil_BDE,

  FDetManInvoiceCA,
  FDetManInvoiceArticleCA,
  FDetManInvoiceCommentCA,
  FDetManInvoicePaymentCA,
  FVSRptInvoice,

  DFpnArticle,
  DFpnArticleCA,
  DFpnCustomer,
  DFpnVATCode,
  DFpnClassification,
  FDetCustomerCA,
  FDlgAskDepartment;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntManInvoiceCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntManInvoiceCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2009/10/15 10:20:08 $';

//*****************************************************************************
// Implementation of TFrmMntManInvoiceCA
//*****************************************************************************

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetManInvoiceCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceCA.Create (Self);
  TFrmDetManInvoiceCA(NewObject).FlgFiscal := FlgFiscal;
  TFrmDetManInvoiceCA(NewObject).FlgItaly := FlgItaly;  
  TFrmDetManInvoiceCA(NewObject).FlgRussia := FlgRussia;
  TFrmDetManInvoiceCA(NewObject).FlgPricing := FlgPricing;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetManInvoiceArticleCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceArticleCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceArticleCA.Create (Self);
  TFrmDetManInvoiceArticleCA(NewObject).FlgPricing := FlgPricing;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceArticleCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetManInvoiceCommentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceCommentCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoiceCommentCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetManInvoiceCommentCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetManInvoicePaymentsCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetManInvoicePaymentsCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoicePaymentCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetManInvoicePaymentsCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskLstArticleCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskLstArticleCreateExecutor
  inherited;

  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  TFrmList(NewObject).TxtSelectMaster := Application.Title;  
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskLstArticleCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskLstCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskLstCustomerCreateExecutor
  inherited;

  NewObject  := TFrmList.Create (Self);
  if FlgCustFunc then 
    TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel, CtCodJobRecCons, CtCodJobRecNew]
  else
    TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  TFrmList(NewObject).TxtSelectMaster := Application.Title;
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskLstCustomerCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskLstClassificationCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskLstClassificationCreateExecutor
  inherited;

  NewObject  := TFrmList.Create (Self);
  TFrmList(NewObject).AllowedJobs := [CtCodJobRecSel];
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskLstClassificationCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskLstClassificationBeforeExecute(
  Sender: TObject; SvcTask: TSvcCustomTask; var FlgAllow: Boolean);
var
  CntItem          : Integer;          // Loop all Datasets
begin  // of TFrmMntManInvoiceCA.SvcTskLstClassificationBeforeExecute
  inherited;
  if not Assigned (SprRTLstClass) then begin
    SprRTLstClass :=
        CopyStoredProc (Self, 'SprRTLstClass',
                        DmdFpnClassification.SprLstClassification, ['']);
    SprRTLstClass.ParamByName ('@PrmTxtCondition').AsString :=
        'CodType = ' + IntToStr (CtCodClassTypeTurnOver);
    for CntItem := 0 to Pred (SvcTskLstClassification.Sequences.Count) do
      SvcTskLstClassification.Sequences.Items[CntItem].DataSet :=
        SprRTLstClass;
  end;
end;    // of TFrmMntManInvoiceCA.SvcTskLstClassificationBeforeExecute

//=============================================================================

procedure TFrmMntManInvoiceCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // TFrmMntManInvoiceCA.BeforeCheckRunParams
  inherited;
  // param /VFisc toevoegen aan help
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString(CtTxtFiscalInfo, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtPricing, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmMntManInvoiceCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntManInvoiceCA.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntManInvoiceCA.CheckAppDependParams
  if Copy(TxtParam,3,4)= 'Fisc' then
    FlgFiscal := True
  else if Copy(TxtParam,3,2)= 'It' then
    FlgItaly := True
  else if Copy(TxtParam,3,2)= 'Ru' then
    FlgRussia := True
  else if Copy(TxtParam,3,3)= 'DBP' then
    FlgDisableBonPassage := True
  else if Copy(TxtParam,3,4)= 'Cust' then
    FlgCustFunc := True
  else if Copy(TxtParam,3,2)= 'PR' then
    FlgPricing := True
  else
    inherited;
end;   // of TFrmMntManInvoiceCA.CheckAppDependParams

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetCustomerCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetCustomerCreateExecutor
  NewObject := TFrmDetCustomerCA.Create (Self);
  TFrmDetCustomerCA(NewObject).FlgVatRequired := FlgFiscal;
  TFrmDetCustomerCA(NewObject).FlgDisableBonPassage := FlgDisableBonPassage;

  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetCustomerCreateExecutor

//=============================================================================

procedure TFrmMntManInvoiceCA.SvcTskDetDepartmentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntManInvoiceCA.SvcTskDetDepartmentCreateExecutor
  NewObject := TFrmDlgAskDepartment.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntManInvoiceCA.SvcTskDetDepartmentCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FMntManInvoiceCA
