//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet   : FlexPoint
// Unit     : FMntSafeToBankCA : main Form MaiNTenance SAFE to BANK CASTORAMA
//-----------------------------------------------------------------------------
// PVCS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntSafeToBankCA.pas,v 1.1 2007/01/11 08:11:41 smete Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FMntSafeToBankCA - CVS revision 1.2
//=============================================================================

unit FMntSafeToBankCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SfMaintenance_BDE_DBC, ScTskMgr_BDE_DBC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtRunPrmPrint    = '/Ff : f=Print    : Reprint report containers';
  CtTxtRunPrmTransfer = '/Ff : f=Transfer : Transfer containers to bank';

type
  TFrmMntSafeToBankCA = class(TFrmMaintenance)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskFrmContainers: TSvcFormTask;
    SvcTskFrmSafeToBankReport: TSvcFormTask;
    SvcTskFrmLogOn: TSvcFormTask;
    procedure FormActivate(Sender: TObject);
    procedure SvcTskFrmContainersCreateExecutor (    Sender     : TObject;
                                                 var NewObject  : TObject;
                                                 var FlgCreated : Boolean);
    procedure SvcTskFrmSafeToBankReportCreateExecutor (    Sender     : TObject;
                                                       var NewObject  : TObject;
                                                       var FlgCreated : Boolean);
    procedure SvcTskFrmSafeToBankReportExecute (    Sender    : TObject;
                                                    SvcTask   : TSvcCustomTask;
                                                var FlgAllow  : Boolean;
                                                var FlgResult : Boolean);
    procedure SvcTskFrmContainersBeforeExecute (    Sender   : TObject;
                                                    SvcTask  : TSvcCustomTask;
                                                var FlgAllow : Boolean);
    procedure SvcTskFrmLogOnCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  protected
    { Protected declarations }
    // Datafields for run parameters
    CodRunFunc : Integer;          // Functionality to execute
    // Methods
    procedure DefineStandardRunParams; override;
    procedure AfterCheckRunParams; override;
  public
    { Public declarations }
  end; // of TFrmMntSafeToBankCA

var
  FrmMntSafeToBankCA: TFrmMntSafeToBankCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  DFpnUtils,
  DFpnTenderCA,
  FVSRptContainerCA,
  FFpnTndSafeToBankCA,
  FLoginTenderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntSafeToBankCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntSafeToBankCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/01/11 08:11:41 $';

//*****************************************************************************
// Implementation of TFrmMntSafeToBankCA
//*****************************************************************************

//=============================================================================
// TFrmMntSafeToBankCA - Event Handlers
//=============================================================================

//=============================================================================
// TFrmMntSafeToBankCA.FormActivate
//=============================================================================

procedure TFrmMntSafeToBankCA.FormActivate (Sender: TObject);
begin  // of TFrmMntSafeToBankCA.FormActivate
  inherited;
  DmdFpnUtils.PromoteStandardParam;
end;   // of TFrmMntSafeToBankCA.FormActivate

//=============================================================================
// TFrmMntSafeToBankCA.SvcTskFrmContainersCreateExecutor
//=============================================================================

procedure TFrmMntSafeToBankCA.SvcTskFrmContainersCreateExecutor
                                                (    Sender: TObject;
                                                 var NewObject: TObject;
                                                 var FlgCreated: Boolean);
begin // of TFrmMntSafeToBankCA.SvcTskFrmContainersCreateExecutor
  inherited;
  NewObject := TFrmTndSafeToBankCA.Create (Application);
  FlgCreated := True;
  if assigned (NewObject) then
    if not assigned (FrmTndSafeToBankCA) then
      FrmTndSafeToBankCA := TFrmTndSafeToBankCA(NewObject);
  SvcTskFrmContainers.DynamicExecutor := False;
end; // of TFrmMntSafeToBankCA.SvcTskFrmContainersCreateExecutor

//=============================================================================
// TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportCreateExecutor
//=============================================================================

procedure TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportCreateExecutor
                                 (    Sender     : TObject;
                                  var NewObject  : TObject;
                                  var FlgCreated : Boolean);
begin // of TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportCreateExecutor
  inherited;
  NewObject := TFrmVSRptcontainerCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmSafeToBankReport.DynamicExecutor := False;
end;  // of TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportCreateExecutor

//=============================================================================
// TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportExecute
//=============================================================================

procedure TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportExecute
                                 (    Sender    : TObject;
                                      SvcTask   : TSvcCustomTask;
                                  var FlgAllow  : Boolean;
                                  var FlgResult : Boolean);
var
  CntDuplex        : Integer;          // Current print of baserapport
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).GenerateReport;
  DmdFpnUtils.CloseInfo;
  NumDuplex := 1;
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Application);
  case CodRunFunc of
    CtCodFuncReprint  :
      NumDuplex := DmdFpnTenderCA.ExPrnContainer;
    CtCodFuncTransfer :
      NumDuplex := DmdFpnTenderCA.ExPrnTransBank;
  end;

  CntDuplex := 1;
  // print the baserapport several times
  while CntDuplex <= NumDuplex do begin
    TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
      (False, 1,
       TFrmVSRptcontainerCA(TSvcFormTask(Sender).Executor).NumEndBaseRapport);
    Inc (CntDuplex);
  end;
  FlgAllow := False;
end;  // of TFrmMntSafeToBankCA.SvcTskFrmSafeToBankReportExecute

//=============================================================================

procedure TFrmMntSafeToBankCA.DefineStandardRunParams;
begin  // of TFrmMntSafeToBankCA.DefineStandardRunParams
  inherited;
  ViSetAllowEntryCmds := [];
  ViFlgAllowFullFunc  := False;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'F';
  ViTxtRunPmReq := ViTxtRunPmReq + 'F';
  AddRunParams ('/Ff', CtTxtRunPrmPrint);
  AddRunParams ('/Ff', CtTxtRunPrmTransfer);
end;   // of TFrmMntSafeToBankCA.DefineStandardRunParams

//=============================================================================
// TFrmMntSafeToBankCA.AfterCheckRunParams
//=============================================================================

procedure TFrmMntSafeToBankCA.AfterCheckRunParams;
begin // of TFrmMntSafeToBankCA.AfterCheckRunParams
  inherited;
  if AnsiCompareText (ViTxtFunction, 'Print') = 0 then
    CodRunFunc := CtCodFuncReprint
  else if AnsiCompareText (ViTxtFunction, 'Transfer') = 0 then
    CodRunFunc := CtCodFuncTransfer
  else if ViTxtFunction <> '' then
    InvalidRunParam ('/F' + ViTxtFunction)
  else
    MissingRunParam ('/F');
end;  // of TFrmMntSafeToBankCA.AfterCheckRunParams

//=============================================================================
// TFrmMntSafeToBankCA.SvcTskFrmContainersBeforeExecute
//=============================================================================

procedure TFrmMntSafeToBankCA.SvcTskFrmContainersBeforeExecute
                                              (     Sender   : TObject;
                                                    SvcTask  : TSvcCustomTask;
                                                var FlgAllow : Boolean);
begin // of TFrmMntSafeToBankCA.SvcTskFrmContainersBeforeExecute
  TFrmTndSafeToBankCA(TSvcFormTask(Sender).Executor).CodRunFunc := CodRunFunc;
end;  // of TFrmMntSafeToBankCA.SvcTskFrmContainersBeforeExecute

//=============================================================================
// TFrmMntCrContainerCA.SvcTskFrmLogOnCreateExecutor
//=============================================================================

procedure TFrmMntSafeToBankCA.SvcTskFrmLogOnCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin   // of TFrmMntSafeToBankCA.SvcTskFrmLogOnCreateExecutor
  NewObject := TFrmLoginTenderCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmLogOn.RelativeFormPosition := rfpCenter;
end;   // of TFrmMntSafeToBankCA.SvcTskFrmLogOnCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.

