//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : FlexPoint
// Unit     : FMntCaisseMonnaieCA.PAS : Form MaiNTenance CAISSE MONNAIE for
//            CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCaisseMonnaieCA.pas,v 1.2 2009/09/22 09:03:09 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FMntCaisseMonnaieCA - CVS revision 1.2
//=============================================================================

unit FMntCaisseMonnaieCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC;

//=============================================================================
// Definitions for run-parameters
//=============================================================================

resourcestring  // Help runparameters for functionality
  CtTxtHlRunPmMinLength      = '/VMLx = Set minimum length of secret code';

//=============================================================================
// TFrmMntCaisseMonnaieCA
//=============================================================================

type
  TFrmMntCaisseMonnaieCA = class(TFrmMaintenance)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskFrmCaisseMonnaie: TSvcFormTask;
    SvcTskFrmLogOn: TSvcFormTask;
    SvcTskFrmCaisseMonnaieReport: TSvcFormTask;
    procedure SvcTskFrmLogOnCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmCaisseMonnaieCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmCaisseMonnaieReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmCaisseMonnaieReportExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
  protected
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    ViValMinLength    : integer;
  end;

var
  FrmMntCaisseMonnaieCA: TFrmMntCaisseMonnaieCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  FFpnTndCaisseMonnaieCA,
  FVSRptCaisseMonnaieCA,
  FLoginTenderCA,
  SmUtils,
  SfDialog,
  DFpnTenderCA,
  DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCaisseMonnaieCA';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCaisseMonnaieCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 09:03:09 $';

//=============================================================================

procedure TFrmMntCaisseMonnaieCA.SvcTskFrmLogOnCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCaisseMonnaieCA.SvcTskFrmLogOnCreateExecutor
  NewObject := TFrmLoginTenderCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmLogOn.RelativeFormPosition := rfpCenter;
end;   // of TFrmMntCaisseMonnaieCA.SvcTskFrmLogOnCreateExecutor

//=============================================================================

procedure TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieCreateExecutor
             (Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieCreateExecutor
  inherited;
  NewObject := TFrmTndCaisseMonnaieCA.Create (Application);
  if assigned (NewObject) then
    if not assigned (FrmTndCaisseMonnaieCA) then
      FrmTndCaisseMonnaieCA := TFrmTndCaisseMonnaieCA(NewObject);
  FrmTndCaisseMonnaieCA.ValMinimumLength := ViValMinLength;
  FlgCreated := True;
  SvcTskFrmCaisseMonnaie.DynamicExecutor := False;
end;   // of TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieCreateExecutor

//=============================================================================

procedure TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportCreateExecutor
             (Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin // of TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportCreateExecutor
  inherited;
  NewObject := TFrmVSRptCaisseMonnaieCA.Create (Application);
  TFrmVSRptCaisseMonnaieCA(NewObject).NumRef := 'REP0019';
  if assigned (NewObject) then
    if not assigned (FrmVSRptCaisseMonnaieCA) then
      FrmVSRptCaisseMonnaieCA := TFrmVSRptCaisseMonnaieCA(NewObject);
  FlgCreated := True;
  SvcTskFrmCaisseMonnaieReport.DynamicExecutor := False;
end;  // of TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportCreateExecutor

//=============================================================================

procedure TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportExecute
  (Sender: TObject; SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
var
  CntDuplex        : Integer;          // Current print of baserapport
  NumDuplex        : Integer;          // Total Ex. to print
begin // of TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportExecute
  // Do you want to see the preview of the report first, then change the
  // following property of the report to true.
  TFrmVSRptCaisseMonnaieCA(TSvcFormTask(Sender).Executor).PreviewReport :=False;
  TFrmVSRptCaisseMonnaieCA(TSvcFormTask(Sender).Executor).GenerateReport;
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Application);
  // JVL NumDuplex := DmdFpnTenderCA.ExPrnTransCaisseM;
  NumDuplex := 1;
  CntDuplex := 1;
  // print the baserapport several times
  while CntDuplex <= NumDuplex do begin
    TFrmVSRptCaisseMonnaieCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
    (False, 1,
     TFrmVSRptCaisseMonnaieCA(TSvcFormTask(Sender).Executor).NumEndPageRapport);
    Inc (CntDuplex);
  end;
  FlgAllow := False;
end; //TFrmMntCaisseMonnaieCA.SvcTskFrmCaisseMonnaieReportExecute

//=============================================================================

procedure TFrmMntCaisseMonnaieCA.CheckAppDependParams(TxtParam: string);
begin
  if AnsiCompareText (Copy(TxtParam,0,4), '/VML') = 0 then
    ViValMinLength := StrToInt(Copy (TxtParam, 5, Length (TxtParam)))
  else
    inherited;
end;

//=============================================================================                                                                 //=============================================================================

procedure TFrmMntCaisseMonnaieCA.BeforeCheckRunParams;
begin
  inherited;
  AddRunParams ('/VML', CtTxtHlRunPmMinLength);
end;

//=============================================================================                                                                 //=============================================================================


initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FMntCaisseMonnaieCA
