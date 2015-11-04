//================= Real Software - Retail Division (c) 2006 ==================
// Packet : FlexPoint 2.0.1
// Customer : Castorama
// Unit   : FMntTransPaymentCA : main Form MaiNTenance TRANSfer PAYMENTs after
//          deliveries for CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTransPaymentCA.pas,v 1.2 2006/12/22 13:39:45 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FMntTransPaymentCA - CVS rev 1.4
//=============================================================================

unit FMntTransPaymentCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC;


resourcestring  // Help runparameters for functionality
  CtTxtHlRunPmMinLength      = '/VML=x = Set minimum length of secret code';


//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmMntTransPaymentCA = class(TFrmMaintenance)
    SvcTskFrmMntTransPayment: TSvcTaskManager;
    SvcTskFrmLogOn: TSvcFormTask;
    SvcTskFrmTransPayment: TSvcFormTask;
    SvcTskFrmPayment: TSvcFormTask;
    SvcTskFrmReport: TSvcFormTask;
    procedure SvcTskFrmLogOnCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmTransPaymentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmPaymentCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmReportCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmReportExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
  private
    FValMinimumLength: integer;
    { Private declarations }
  protected
    { Protected declarations }
    // Methods
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
  published
    property ValMinimumLength: integer read FValMinimumLength
                                   write FValMinimumLength;
  end;

var
  FrmMntTransPaymentCA: TFrmMntTransPaymentCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
    
  FTransPaymentCA,
  FLoginCA,
  FDetManInvoicePaymentCA,
  FVSRptTransPaymentCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntTransPaymentCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntTransPaymentCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:45 $';

//*****************************************************************************
// Implementation of TFrmMntTransPaymentCA
//*****************************************************************************

procedure TFrmMntTransPaymentCA.SvcTskFrmTransPaymentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntTransPaymentCA.SvcTskFrmTransPaymentCreateExecutor
  inherited;
  NewObject := TFrmTransPaymentCA.Create (Application);
  if assigned (NewObject) then
    if not assigned (FrmTransPaymentCA) then
      FrmTransPaymentCA := TFrmTransPaymentCA(NewObject);
  FrmTransPaymentCA.ValMinimumLength := ValMinimumLength;
  FlgCreated := True;
  SvcTskFrmTransPayment.DynamicExecutor := False;
end;   // of TFrmMntTransPaymentCA.SvcTskFrmTransPaymentCreateExecutor

//=============================================================================

procedure TFrmMntTransPaymentCA.SvcTskFrmLogOnCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin
  NewObject := TFrmLoginFpnCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmLogOn.RelativeFormPosition := rfpCenter;
end;

//=============================================================================

procedure TFrmMntTransPaymentCA.SvcTskFrmPaymentCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntTransPaymentCA.SvcTskFrmPaymentCreateExecutor
  inherited;
  NewObject := TFrmDetManInvoicePaymentCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntTransPaymentCA.SvcTskFrmPaymentCreateExecutor

//=============================================================================

procedure TFrmMntTransPaymentCA.SvcTskFrmReportCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntTransPaymentCA.SvcTskFrmReportCreateExecutor
  inherited;
  NewObject := TFrmVSRptTransPaymentCA.Create (Application);
  FlgCreated := True;
  SvcTskFrmReport.DynamicExecutor := False;
end;   // of TFrmMntTransPaymentCA.SvcTskFrmReportCreateExecutor

//=============================================================================

procedure TFrmMntTransPaymentCA.SvcTskFrmReportExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntTransPaymentCA.SvcTskFrmReportExecute
  inherited;
  TFrmVSRptTransPaymentCA(TSvcFormTask(Sender).Executor).PreviewReport := False;
  TFrmVSRptTransPaymentCA(TSvcFormTask(Sender).Executor).GenerateReport;
  TFrmVSRptTransPaymentCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
     (False, 1,
      TFrmVSRptTransPaymentCA(TSvcFormTask(Sender).Executor).NumEndBaseRapport);
  FlgAllow := False;
end;   // of TFrmMntTransPaymentCA.SvcTskFrmReportExecute

//=============================================================================

procedure TFrmMntTransPaymentCA.BeforeCheckRunParams;
begin  // of TFrmMntTransPaymentCA.BeforeCheckRunParams
  inherited;
  AddRunParams ('/VML=x', CtTxtHlRunPmMinLength);
end;   // of TFrmMntTransPaymentCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntTransPaymentCA.CheckAppDependParams(TxtParam: string);
begin
  if AnsiCompareText (Copy(TxtParam,0,4), '/VML') = 0 then
    ValMinimumLength := StrToInt(Copy (TxtParam, 5, Length (TxtParam)))
  else
    inherited;
end;   // of TFrmMntTransPaymentCA.CheckAppDependParams

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
