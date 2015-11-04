//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : FlexPoint
// Unit     : FMntBankOrderCA = Form MaiNTenance BANK ORDER CAstorama
//            Maintenance Form for placing orders for cash money with bank
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntBankOrderCA.pas,v 1.3 2009/10/14 11:48:10 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FMntBankOrderCA - CVS revision 1.1
//=============================================================================

unit FMntBankOrderCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtRunPrmOrder    = '/Ff : f=Order  : Place a money order with bank';
  CtTxtRunPrmAccept   = '/Ff : f=Accept : Accept money order from bank';
  CtTxtRunPrmOrderParam = '/Ff : f=OrderParam : Place a money order with bank '+
                          'using parameters in PPrmOrderChangeMoney';

//=============================================================================
// Form declaration
//=============================================================================

type
  TFrmMntBankOrderCA = class(TFrmMaintenance)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskFrmBankOrder: TSvcFormTask;
    SvcTskFrmLogOn: TSvcFormTask;
    SvcTskFrmReportMoneyOrder: TSvcFormTask;
    SvcTskFrmReportAcceptedOrder: TSvcFormTask;
    SvcTskFrmReportMoneyOrderParam: TSvcFormTask;
    procedure SvcTskFrmBankOrderBeforeExecute (    Sender   : TObject;
                                                   SvcTask  : TSvcCustomTask;
                                               var FlgAllow : Boolean);
    procedure SvcTskFrmBankOrderCreateExecutor (    Sender     : TObject;
                                                var NewObject  : TObject;
                                                var FlgCreated : Boolean);
    procedure SvcTskFrmLogOnCreateExecutor (    Sender     : TObject;
                                            var NewObject  : TObject;
                                            var FlgCreated : Boolean);
    procedure SvcTskFrmReportMoneyOrderCreateExecutor (    Sender     : TObject;
                                             var NewObject  : TObject;
                                             var FlgCreated : Boolean);
    procedure SvcTskFrmReportMoneyOrderParamCreateExecutor (    Sender     : TObject;
                                             var NewObject  : TObject;
                                             var FlgCreated : Boolean);
    procedure SvcTskFrmReportMoneyOrderExecute (    Sender    : TObject;
                                                    SvcTask   : TSvcCustomTask;
                                                var FlgAllow  : Boolean;
                                                var FlgResult : Boolean);
    procedure SvcTskFrmReportMoneyOrderParamExecute (    Sender    : TObject;
                                                    SvcTask   : TSvcCustomTask;
                                                var FlgAllow  : Boolean;
                                                var FlgResult : Boolean);
    procedure SvcTskFrmReportAcceptedOrderCreateExecutor
                                                     (    Sender     : TObject;
                                                      var NewObject  : TObject;
                                                      var FlgCreated : Boolean);
    procedure SvcTskFrmReportAcceptedOrderExecute
                                                (    Sender    : TObject;
                                                     SvcTask   : TSvcCustomTask;
                                                 var FlgAllow  : Boolean;
                                                 var FlgResult : Boolean);
  protected
    { Protected declarations }
    CodRunFunc : Integer;          // Functionality to execute
    // Methods
    procedure DefineStandardRunParams; override;
    procedure AfterCheckRunParams; override;
  public
    { Public declarations }
  end;

var
  FrmMntBankOrderCA: TFrmMntBankOrderCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,

  DFpnTenderCA,

  FFpnTndBankOrderCA,
  FLoginTenderCA,
  FVSRptBankOrderCA;


//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntBankOrderCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntBankOrderCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/10/14 11:48:10 $';

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmBankOrderBeforeExecute
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmBankOrderBeforeExecute
                                               (    Sender   : TObject;
                                                    SvcTask  : TSvcCustomTask;
                                                var FlgAllow : Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmBankOrderBeforeExecute
  inherited;
  TFrmTndBankOrderCA(TSvcFormTask(Sender).Executor).CodRunFunc := CodRunFunc;
end;  // of TFrmMntBankOrderCA.SvcTskFrmBankOrderBeforeExecute

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmBankOrderCreateExecutor
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmBankOrderCreateExecutor
                                                    (    Sender     : TObject;
                                                     var NewObject  : TObject;
                                                     var FlgCreated : Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmBankOrderCreateExecutor
  NewObject := TFrmTndBankOrderCA.Create (Application);
  if assigned (NewObject) then
    if not assigned (FrmTndBankOrderCA) then
      FrmTndBankOrderCA := TFrmTndBankOrderCA(NewObject);
  FlgCreated := True;
  SvcTskFrmBankOrder.RelativeFormPosition := rfpCenter;
  SvcTskFrmBankOrder.DynamicExecutor := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmBankOrderCreateExecutor

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmLogOnCreateExecutor
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmLogOnCreateExecutor
                                                    (    Sender     : TObject;
                                                     var NewObject  : TObject;
                                                     var FlgCreated : Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmLogOnCreateExecutor
  NewObject := TFrmLoginTenderCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmLogOn.DynamicExecutor := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmLogOnCreateExecutor

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor
                                                     (    Sender    : TObject;
                                                      var NewObject : TObject;
                                                      var FlgCreated: Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor
  inherited;
  NewObject := TFrmVSRptBankOrderCA.Create (Application);
  TFrmVSRptBankOrderCA (NewObject).NumRef := 'REP0022';
  if assigned (NewObject) then
    if not assigned (FrmVSRptBankOrderCA) then
      FrmVSRptBankOrderCA := TFrmVSRptBankOrderCA(NewObject);
  FlgCreated := True;
  SvcTskFrmReportMoneyOrder.DynamicExecutor := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderParamCreateExecutor
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderParamCreateExecutor
                                                     (    Sender    : TObject;
                                                      var NewObject : TObject;
                                                      var FlgCreated: Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor
  inherited;
  NewObject := TFrmVSRptBankOrderCA.Create (Application);
  TFrmVSRptBankOrderCA (NewObject).NumRef := 'REP0022';
  if assigned (NewObject) then
    if not assigned (FrmVSRptBankOrderCA) then
      FrmVSRptBankOrderCA := TFrmVSRptBankOrderCA(NewObject);
  FlgCreated := True;
  SvcTskFrmReportMoneyOrderParam.DynamicExecutor := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderCreateExecutor

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderExecute
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderExecute
                                           (    Sender    : TObject;
                                                SvcTask   : TSvcCustomTask;
                                            var FlgAllow  : Boolean;
                                            var FlgResult : Boolean);
var
  CntDuplex        : Integer;          // Current print of report
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).GenerateReport;
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Application);
  NumDuplex := DmdFpnTenderCA.ExPrnCashOrder;
  CntDuplex := 1;
  // print the baserapport several times
  while CntDuplex <= NumDuplex do begin
    TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
      (False, 1,
       TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).NumEndPageRapport);
    Inc (CntDuplex);
  end;
  FlgAllow := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderExecute

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderParamExecute
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderParamExecute
                                           (    Sender    : TObject;
                                                SvcTask   : TSvcCustomTask;
                                            var FlgAllow  : Boolean;
                                            var FlgResult : Boolean);
var
  CntDuplex        : Integer;          // Current print of report
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderParamExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).GenerateReport;
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Application);
  NumDuplex := DmdFpnTenderCA.ExPrnCashOrder;
  CntDuplex := 1;
  // print the baserapport several times
  while CntDuplex <= NumDuplex do begin
    TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
      (False, 1,
       TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).NumEndPageRapport);
    Inc (CntDuplex);
  end;
  FlgAllow := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportMoneyOrderExecute

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderCreateExecutor
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderCreateExecutor
                                               (    Sender     : TObject;
                                                var NewObject  : TObject;
                                                var FlgCreated : Boolean);
begin // of TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderCreateExecutor
  inherited;
  NewObject := TFrmVSRptBankOrderCA.Create (Application);
  TFrmVSRptBankOrderCA (NewObject).NumRef := 'REP0024';
  if assigned (NewObject) then
    if not assigned (FrmVSRptBankOrderCA) then
      FrmVSRptBankOrderCA := TFrmVSRptBankOrderCA(NewObject);
  FlgCreated := True;
  SvcTskFrmReportAcceptedOrder.DynamicExecutor := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderCreateExecutor

//=============================================================================
// TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderExecute
//=============================================================================

procedure TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderExecute
                                               (    Sender    : TObject;
                                                    SvcTask   : TSvcCustomTask;
                                                var FlgAllow  : Boolean;
                                                var FlgResult : Boolean);
var
  CntDuplex        : Integer;          // Current print of report
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).GenerateReport;
  NumDuplex := DmdFpnTenderCA.ExPrnAccOrder;
  CntDuplex := 1;
  // print the baserapport several times
  while CntDuplex <= NumDuplex do begin
    TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
      (False, 1,
       TFrmVSRptBankOrderCA(TSvcFormTask(Sender).Executor).NumEndPageRapport);
    Inc (CntDuplex);
  end;
  FlgAllow := False;
end;  // of TFrmMntBankOrderCA.SvcTskFrmReportAcceptedOrderExecute

//=============================================================================

procedure TFrmMntBankOrderCA.DefineStandardRunParams;
begin  // of TFrmMntBankOrderCA.DefineStandardRunParams
  inherited;
  ViSetAllowEntryCmds := [];
  ViFlgAllowFullFunc  := False;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'F';
  ViTxtRunPmReq := ViTxtRunPmReq + 'F';
  AddRunParams ('/Ff', CtTxtRunPrmOrder);
  AddRunParams ('/Ff', CtTxtRunPrmAccept);
end;   // of TFrmMntBankOrderCA.DefineStandardRunParams

//=============================================================================
// TFrmMntBankOrderCA.AfterCheckRunParams
//=============================================================================

procedure TFrmMntBankOrderCA.AfterCheckRunParams;
begin // of TFrmMntBankOrderCA.AfterCheckRunParams
  inherited;
  if AnsiCompareText (ViTxtFunction, 'Order') = 0 then
    CodRunFunc := CtCodFuncOrder
  else if AnsiCompareText (ViTxtFunction, 'Accept') = 0 then
    CodRunFunc := CtCodFuncAccept
  else if AnsiCompareText (ViTxtFunction, 'OrderParam') = 0 then
    CodRunFunc := CtCodFuncOrderParam
  else if ViTxtFunction <> '' then
    InvalidRunParam ('/F' + ViTxtFunction)
  else
    MissingRunParam ('/F');
end;  // of TFrmMntBankOrderCA.AfterCheckRunParams

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end. // of FMntBankOrderCA
