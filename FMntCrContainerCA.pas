//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint 2.0
// Unit     : FMntCrContainerCA : main Form MaiNTenance CReate CONTAINER
//            for CAstorama
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCrContainerCA.pas,v 1.1 2007/01/11 08:11:15 smete Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FMntCrContainer - CVS revision 1.2
//=============================================================================

unit FMntCrContainerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmMntCrContainerCA = class(TFrmMaintenance)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskFrmBags: TSvcFormTask;
    SvcTskFrmContainer: TSvcFormTask;
    SvcTskFrmSafeToBankReport: TSvcFormTask;
    SvcTskFrmLogOn: TSvcFormTask;
    procedure FormActivate(Sender: TObject);
    procedure SvcTskFrmBagsCreateExecutor(
              Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmContainerCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmSafeToBankReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmSafeToBankReportExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
    procedure SvcTskFrmLogOnCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  end; // of TFrmMntCrContainerCA

var
  FrmMntCrContainerCA: TFrmMntCrContainerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,

  DFpnUtils,
  DFpnTenderCA,

  FContainerCA,
  FVSRptContainerCA,
  FFpnTndCrContainerCA,
  FLoginTenderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCrContainerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCrContainerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/01/11 08:11:15 $';

//*****************************************************************************
// Implementation of TFrmTndCrContainerCA
//*****************************************************************************

//=============================================================================
// TFrmMntCrContainerCA - Event Handlers
//=============================================================================

procedure TFrmMntCrContainerCA.FormActivate(Sender: TObject);
begin  // of TFrmMntSafeBank.FormActivate
  inherited;
  DmdFpnUtils.PromoteStandardParam;
end;   // of TFrmMntSafeBank.FormActivate

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmBagsCreateExecutor
//=============================================================================

procedure TFrmMntCrContainerCA.SvcTskFrmBagsCreateExecutor
                                                (    Sender: TObject;
                                                 var NewObject: TObject;
                                                 var FlgCreated: Boolean);
begin // of TFrmMntCrContainerCA.SvcTskFrmBagsCreateExecutor
  inherited;
  NewObject := TFrmTndCrContainerCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmBags.DynamicExecutor := False;
end; // of TFrmMntCrContainerCA.SvcTskFrmBagsCreateExecutor

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmContainerCreateExecutor
//=============================================================================

procedure TFrmMntCrContainerCA.SvcTskFrmContainerCreateExecutor
                                             (    Sender: TObject;
                                              var NewObject: TObject;
                                              var FlgCreated: Boolean);
begin // of TFrmMntCrContainerCA.SvcTskFrmContainerCreateExecutor
  inherited;
  NewObject := TFrmContainerCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmContainer.DynamicExecutor := False;
end;  // of TFrmMntCrContainerCA.SvcTskFrmContainerCreateExecutor

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportCreateExecutor
//=============================================================================

procedure TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportCreateExecutor
                                 (    Sender     : TObject;
                                  var NewObject  : TObject;
                                  var FlgCreated : Boolean);
begin // of TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportCreateExecutor
  inherited;
  NewObject := TFrmVSRptcontainerCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmSafeToBankReport.DynamicExecutor := False;
end;  // of TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportCreateExecutor

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportExecute
//=============================================================================

procedure TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportExecute
                                 (    Sender    : TObject;
                                      SvcTask   : TSvcCustomTask;
                                  var FlgAllow  : Boolean;
                                  var FlgResult : Boolean);
var
  CntDuplex        : Integer;          // Current print of baserapport
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).GenerateReport;
  // here we use the same number of prints-parameter like in
  //PTndSafeToBank with function /FPrint
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Application);
  DmdFpnUtils.CloseInfo;
  NumDuplex := DmdFpnTenderCA.ExPrnContainer;
  // print the baserapport several times
  for CntDuplex := 1 to NumDuplex do
    TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
      (False, 1,
       TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).NumEndBaseRapport);
  FlgAllow := False;
end;  // of TFrmMntCrContainerCA.SvcTskFrmSafeToBankReportExecute

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmLogOnCreateExecutor
//=============================================================================

procedure TFrmMntCrContainerCA.SvcTskFrmLogOnCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmMntCrContainerCA.SvcTskFrmLogOnCreateExecutor
  NewObject := TFrmLoginTenderCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmLogOn.RelativeFormPosition := rfpCenter;
end;  // of TFrmMntCrContainerCA.SvcTskFrmLogOnCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
