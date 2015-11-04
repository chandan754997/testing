//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorama Development
// Unit   : FMntDocumentBO.Pas : Form maintenance document Back Office
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntDocumentBO.pas,v 1.3 2007/11/16 08:33:07 smete Exp $
// History:
//=============================================================================

unit FMntDocumentBO;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FFpnMnt, scEHdler, FAutoRunDocBO, ScTskMgr_BDE_DBC;

resourcestring // for runtime parameters
  CtTxtRunParamLog   = 'LOG=Log SQL-activity';
  CtTxtRunParamRep   = 'REP1=Print documents that still needs connection';
  CtTxtRunParamDays  = 'DAYSxx=Maximum number (xx) to give info';
  CtTxtRunParamDel   = 'DELxx=Change status to deleted if older then xx days';
  CtTxtRunParamCon   = 'CON=Connect documents';
  CtTxtRunParamDet   = 'DET=Enable detail button';
  CtTxtRunParamCAFR  = 'CAFR';                                                    //Regression Defect Fix R2012

resourcestring // for error messages
  CtTxtErrRep1       = 'Parameter ''/VREP1'' is not allowed without ''/A''.';
  CtTxtErrCon        = 'Parameter ''/VCON'' is not allowed without ''/A''.';  
  CtTxtErrDel        = 'Parameter ''/VDELxx'' is not allowed without ''/A''.';
//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmMntDocumentBO = class(TFrmFpnMnt)
    SvcTmgMaintenance: TSvcTaskManager;
    SvcTskLstDocumentBO: TSvcListTask;
    SvcTskDetDocumentBO: TSvcFormTask;
    SvcTskRptDocBoGlobal: TSvcFormTask;
    SvcTskChangeDocBONb: TSvcFormTask;
    SvcTskRptDocBODetail: TSvcFormTask;
    SvcSelectdate: TSvcFormTask;
    SvcTskAutoRunDocBO: TSvcFormTask;
    SvcTskPrintRep1: TSvcFormTask;
    procedure SvcTskLstDocumentBOCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetDocumentBOCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskRptDocBoGlobalCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskRptDocBoGlobalExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
    procedure SvcTskChangeDocBONbCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskRptDocBODetailCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskRptDocBODetailExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
    procedure SvcSelectdateCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskAutoRunDocBOCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskPrintRep1CreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskPrintRep1Execute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SvcTskLstDocumentBOExecute(Sender: TObject;
      SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
  private
    FFlgPrintRep1      : boolean;         //Print documents
    FFlgConnect        : boolean;         //Connect documents
    FFlgDetButton      : boolean;         //Connect documents        
    FNumDaysInfo       : integer;         //Max days info to give
    FNumDaysDel        : integer;         //Set deleted after NumDaysDel old
    FrmAutoRunDocBO    : TFrmAutoRunDocBO;
    FFlgCAFR           : Boolean;         //Regression Defect Fix R2012
  protected
    { Protected declarations }
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
  public
    { Public declarations }
    property FlgPrintRep1 : boolean read FFlgPrintRep1 write FFlgPrintRep1;
    property FlgConnect : boolean read FFlgConnect write FFlgConnect;
    property FlgDetButton : boolean read FFlgDetButton write FFlgDetButton;    
    property NumDaysInfo : integer read FNumDaysInfo write FNumDaysInfo;
    property NumDaysDel : integer read FNumDaysDel write FNumDaysDel;
    property FlgCAFR : Boolean read FFlgCAFR write FFlgCAFR;  //Regression Defect Fix R2012
  end;

var
  FrmMntDocumentBO: TFrmMntDocumentBO;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfList_BDE_DBC,
  SfDialog,
  SmUtils,

  DFpnBODocument,

  FLstDocumentBO,
  FVSRptDocumentBO,
  FDetDocumentBO,
  FDetChangeDocBONb,
  FSelDateTime;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntDocumentBO';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntDocumentBO.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2007/11/16 08:33:07 $';

//*****************************************************************************
// Implementation of TFrmMntDocumentBO
//*****************************************************************************

procedure TFrmMntDocumentBO.SvcTskLstDocumentBOCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskLstDocumentBOCreateExecutor
  inherited;
  NewObject := TFrmLstDocumentBO.Create (Self);
  TFrmLstDocumentBO (NewObject).AllowedJobs := SetEntryCmds;
  TFrmLstDocumentBO (NewObject).NumDaysInfo := NumDaysInfo;
  TFrmLstDocumentBO (NewObject).FlgDetButton := FlgDetButton;  
  FlgCreated := True;
  TFrmlstDocumentBO(NewObject).FlgCAFR := FlgCAFR;  //Regression Defect Fix R2012
end;  // of TFrmMntDocumentBO.SvcTskLstDocumentBOCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskDetDocumentBOCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcDetDocumentBOCreateExecutor
  inherited;
  NewObject := TFrmDetDocumentBO.Create (Self);
  FlgCreated := True;
end;   // of TFrmMntDocumentBO.SvcDetDocumentBOCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskRptDocBoGlobalCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskRptDocumentBoCreateExecutor
  inherited;
  FVSRptDocumentBO.ViFlgDetail := False;
  NewObject := TFrmVSRptDocumentBO.Create (Self);
  TFrmVSRptDocumentBO (NewObject).FlgPrintRep1 := FlgPrintRep1;
  TFrmVSRptDocumentBO (NewObject).NumDaysInfo := NumDaysInfo;
  FlgCreated := True;
end;   // of TFrmMntDocumentBO.SvcTskRptDocumentBoCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskRptDocBoGlobalExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskRptDocumentBoExecute
  inherited;
  if TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).GenerateReport then
    TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).ShowModal;
  FlgAllow := False;
  //SvcTskRptDocBoGlobal.DynamicExecutor := False;
end;   // of TFrmMntDocumentBO.SvcTskRptDocumentBoExecute

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskChangeDocBONbCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskChangeDocBONbCreateExecutor
  inherited;
  NewObject := TFrmDetChangeDocBONb.Create (Self);
  FlgCreated := True;
  TFrmDetChangeDocBONb(NewObject).FlgCAFR := FlgCAFR;                 //Regression Defect Fix R2012
end;   // of TFrmMntDocumentBO.SvcTskChangeDocBONbCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskRptDocBODetailCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskRptDocBODetailCreateExecutor
  inherited;
  FVSRptDocumentBO.ViFlgDetail := True;
  NewObject := TFrmVSRptDocumentBO.Create (Self);
  TFrmVSRptDocumentBO (NewObject).FlgPrintRep1 := FlgPrintRep1;
  TFrmVSRptDocumentBO (NewObject).NumDaysInfo := NumDaysInfo;
  FlgCreated := True;
  //SvcTskRptDocBoDetail.DynamicExecutor := False;
end;   // of TFrmMntDocumentBO.SvcTskRptDocBODetailCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskRptDocBODetailExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskRptDocBODetailExecute
  inherited;
  if TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).GenerateReport then
    TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).ShowModal;
  FlgAllow := False;
end;   // of TFrmMntDocumentBO.SvcTskRptDocBODetailExecute

//=============================================================================

procedure TFrmMntDocumentBO.SvcSelectdateCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of SvcSelectdateCreateExecutor
  inherited;
  NewObject := TFrmSelDateTime.Create (Self);
  FlgCreated := True;
  SvcSelectdate.DynamicExecutor := False;
end;   // of SvcSelectdateCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.BeforeCheckRunParams;
begin // of TFrmMntDocumentBO.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'A';
  AddRunParams ('/VLOG', CtTxtRunParamLog);
  AddRunParams ('/VREP1', CtTxtRunParamRep);
  AddRunParams ('/VDAYSxx', CtTxtRunParamDays);
  AddRunParams ('/VDELxx', CtTxtRunParamDel);
  AddRunParams ('/VCON', CtTxtRunParamCon);
  AddRunParams ('/VDET', CtTxtRunParamDet);
  AddRunParams ('/VCAFR', CtTxtRunParamCAFR);                                     //Regression Defect Fix R2012
end;  // of TFrmMntDocumentBO.BeforeCheckRunParams

//=============================================================================

procedure TFrmMntDocumentBO.CheckAppDependParams(TxtParam: string);
begin // of TFrmMntDocumentBO.CheckAppDependParams
  if AnsiCompareText (copy(TxtParam, 3, 3), 'Log') = 0 then begin
    DmdFpnBODocument.FlgLogging := True;
  end
  else if AnsiCompareText (copy(TxtParam, 3, 4), 'REP1') = 0 then
    FlgPrintRep1 := True
  else if AnsiCompareText (copy(TxtParam, 3, 4), 'DAYS') = 0 then
    if copy(TxtParam, 7, length(TxtParam)-6) <> '' then
      NumDaysInfo := StrToInt(copy(TxtParam, 7, length(TxtParam)-6))
    else NumDaysInfo := 0
  else if AnsiCompareText (copy(TxtParam, 3, 3), 'DEL') = 0 then
    if copy(TxtParam, 6, length(TxtParam)-5) <> '' then
      NumDaysDel := StrToInt(copy(TxtParam, 6, length(TxtParam)-5))
    else NumDaysDel := 0
  else if AnsiCompareText (copy(TxtParam, 3, 3), 'CON') = 0 then
    FlgConnect := True
  else if AnsiCompareText (copy(TxtParam, 3, 3), 'DET') = 0 then
    FlgDetButton := True
  else if AnsiCompareText (Copy(TxtParam, 3, 4), 'CAFR') = 0 then   //Regression Defect Fix R2012              
    FlgCAFR := True;
end;  // of TFrmMntDocumentBO.CheckAppDependParams

//=============================================================================

procedure TFrmMntDocumentBO.AfterCheckRunParams;
var
  FlgErrMessage    : boolean;    // set to true is errormessage is displayed
begin // of TFrmMntDocumentBO.AfterCheckRunParams
  FlgErrMessage := False;
  if FlgPrintRep1 and (not ViFlgAutom) then begin
    MessageDlg (CtTxtErrRep1, mtError, [mbOK], 0);
    FlgErrMessage := True;
  end
  else if FlgConnect and (not ViFlgAutom) then begin
    MessageDlg (CtTxtErrCon, mtError, [mbOK], 0);
    FlgErrMessage := True;
  end
  else if (NumDaysDel > 0) and (not ViFlgAutom) then begin
    MessageDlg (CtTxtErrDel, mtError, [mbOK], 0);
    FlgErrMessage := True;
  end;
  if FlgErrMessage then
    Application.Terminate;
end;  // of TFrmMntDocumentBO.AfterCheckRunParams

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskAutoRunDocBOCreateExecutor(
  Sender: TObject; var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskAutoRunDocBOCreateExecutor
  inherited;
  NewObject := FrmAutoRunDocBO;
  TFrmAutoRunDocBO (NewObject).FlgPrintRep1 := FlgPrintRep1;
  TFrmAutoRunDocBO (NewObject).FlgConnect := FlgConnect;
  TFrmAutoRunDocBO (NewObject).NumDaysDel := NumDaysDel;
  TFrmAutoRunDocBO (NewObject).NumDaysInfo := NumDaysInfo;
  FlgCreated := True;
  SvcTskAutoRunDocBO.DynamicExecutor := False;
end;   // of TFrmMntDocumentBO.SvcTskAutoRunDocBOCreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskPrintRep1CreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskPrintRep1CreateExecutor
  inherited;
  FVSRptDocumentBO.ViFlgDetail := False;
  NewObject := TFrmVSRptDocumentBO.Create (Self);
  TFrmVSRptDocumentBO (NewObject).FlgPrintRep1 := FlgPrintRep1;
  TFrmVSRptDocumentBO (NewObject).NumDaysInfo := NumDaysInfo;
  FlgCreated := True;
end;   // of TFrmMntDocumentBO.SvcTskPrintRep1CreateExecutor

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskPrintRep1Execute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskPrintRep1Execute
  inherited;
  if TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).GenerateReport then
    if not TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).FlgNoData then
      TFrmVSRptDocumentBO(TSvcFormTask(Sender).Executor).BtnPrintAll.Click;
  FlgAllow := False;
  //SvcTskRptDocBoGlobal.DynamicExecutor := False;
end;   // of TFrmMntDocumentBO.SvcTskPrintRep1Execute

//=============================================================================

procedure TFrmMntDocumentBO.FormCreate(Sender: TObject);
begin  // of TFrmMntDocumentBO.FormCreate
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'AV';
  FrmAutoRunDocBO := TFrmAutoRunDocBO.Create (Self);
  inherited;
end;   // of TFrmMntDocumentBO.FormCreate

//=============================================================================

procedure TFrmMntDocumentBO.SvcTskLstDocumentBOExecute(Sender: TObject;
  SvcTask: TSvcCustomTask; var FlgAllow, FlgResult: Boolean);
begin  // of TFrmMntDocumentBO.SvcTskLstDocumentBOExecute
  inherited;
  if ViFlgAutom then begin
    FlgAllow := false;
    SvcTaskMgr.LaunchTask ('AutoRunDocBO');
  end;
end;   // of TFrmMntDocumentBO.SvcTskLstDocumentBOExecute

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FMntDocumentBO
