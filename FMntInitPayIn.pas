//=====Copyright 2009 (c) Centric Retail Solutions. All rights reserved.=======
// Packet   : Flexpoint Development Castorama
// Unit     : FMntInitPayIn = Maintenance form for INITial PAYIN
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntInitPayIn.pas,v 1.2 2009/09/16 15:57:10 BEL\KDeconyn Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FMntInitPayIn - CVS revision 1.1
//=============================================================================

unit FMntInitPayIn;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfmaintenance_BDE_DBC, ScTskMgr_BDE_DBC, Variants;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring  // for runtime parameters
  CtTxtRunParamVNDV          = 'Focussed on the first operator at startup';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmMntInitPayIn = class(TFrmMaintenance)
    SvcTskMgrInitPayIn: TSvcTaskManager;
    SvcTskFrmInitPayIn: TSvcFormTask;
    SvcTskFrmPrintInitPayIn: TSvcFormTask;
    procedure SvcTskFrmInitPayInCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmPrintInitPayInCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskFrmPrintInitPayInExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
  private
    { Private declarations }
  protected
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    FFlgVNDV: Boolean;
    property FlgVNDV: boolean read FFlgVNDV write FFlgVNDV;
  end;

//=============================================================================

var
  FrmMntInitPayIn: TFrmMntInitPayIn;

implementation

uses
  SmUtils,
  SfDialog,
  FDetInitPayIn,
  FVSRptInitPayInCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntInitPayIn';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntInitPayIn.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/16 15:57:10 $';

//*****************************************************************************
// Implementation of TFrmMntInitPayIn
//*****************************************************************************
procedure TFrmMntInitPayIn.BeforeCheckRunParams;
begin  // of TFrmMntInitPayIn.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow  + 'V';
  AddRunParams ('/VNDV', CtTxtRunParamVNDV);
end;   // of TFrmMntInitPayIn.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntInitPayIn.CheckAppDependParams(TxtParam: string);
begin  // of TFrmMntInitPayIn.CheckAppDependParams
  if AnsiCompareText (copy(TxtParam, 0, 5), '/VNDV') = 0 then
    FFlgVNDV := True;
end;   // of TFrmMntInitPayIn.CheckAppDependParams

//=============================================================================

procedure TFrmMntInitPayIn.SvcTskFrmInitPayInCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntInitPayIn.SvcTskFrmInitPayInCreateExecutor
  NewObject := TFrmDetInitPayIn.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntInitPayIn.SvcTskFrmInitPayInCreateExecutor

//=============================================================================

procedure TFrmMntInitPayIn.SvcTskFrmPrintInitPayInCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntInitPayIn.SvcTskFrmPrintInitPayInCreateExecutor
  NewObject := TFrmVSRptInitPayInCA.Create (Self);
  FlgCreated := True;
end;   // of TFrmMntInitPayIn.SvcTskFrmPrintInitPayInCreateExecutor

//=============================================================================

procedure TFrmMntInitPayIn.SvcTskFrmPrintInitPayInExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin
  TFrmVSRptInitPayInCA(TSvcFormTask(Sender).Executor).GenerateReport;
  TFrmVSRptInitPayInCA(TSvcFormTask(Sender).Executor).VspPreview.PrintDoc
    (False, Null, Null);
  FlgAllow := False;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of fMntInitPayIn


