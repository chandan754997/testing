//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Castorama Development
// Unit   : FAutoRunDocBO.Pas : Form AUTOmatic RUN of DOCument BO application
//-----------------------------------------------------------------------------
// PVCS   : $Header : $
// History:
//=============================================================================

unit FAutoRunDocBO;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, Db;

resourcestring // errormessages
  CtTxtConnectSucceeded = 'Connect succeeded for %s - %s - %s - %s - %s';
  CtTxtErrAutom         = 'When using parameter ''/A'' one of the following ' +
                          'parameters must be used: ''/VDELxx'', ''/VREP1'' or ' +
                          '''/VCon''.';

//=============================================================================
// Global type definitions
//=============================================================================

type
  TFrmAutoRunDocBO = class(TFrmAutoRun)
    DscDocumentBO: TDataSource;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  protected
    FFlgPrintRep1      : boolean;         //Print documents
    FFlgConnect        : boolean;         //Connect documents
    FNumDaysInfo       : integer;         //Max days info to give
    FNumDaysDel        : integer;         //Set deleted after NumDaysDel old
    procedure AutoStart (Sender : TObject); override;

    procedure OnIdle (Sender : TObject; var FlgIdle : Boolean); virtual;
    procedure CheckAppDependParams (TxtParam : string); override;

  public
    { Public declarations }
    procedure Execute; override;
  published
    property FlgPrintRep1 : boolean read FFlgPrintRep1 write FFlgPrintRep1;
    property FlgConnect : boolean read FFlgConnect write FFlgConnect;
    property NumDaysInfo : integer read FNumDaysInfo write FNumDaysInfo;
    property NumDaysDel : integer read FNumDaysDel write FNumDaysDel;
  end;

var
  FrmAutoRunDocBO: TFrmAutoRunDocBO;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  DBTables,
  SmUtils,
  ScTskMgr_BDE_DBC,
  SfDialog,
  DFpnBODocument,
  DFpn;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FAutoRunDocBO';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FAutoRunDocBO.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/20 14:35:54 $';

//*****************************************************************************
// Implementation of TFrmAutoRunDocBO
//*****************************************************************************

procedure TFrmAutoRunDocBO.AutoStart (Sender : TObject);
begin  // of TFrmAutoRunDocBO.AutoStart
  Application.OnActivate := nil;
  if Application.Terminated then
    Exit;
  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
    Application.OnIdle := OnIdle;
  end;
//  Self.Hide;
//  Execute;
end;   // of TFrmAutoRunDocBO.AutoStart

//=============================================================================

procedure TFrmAutoRunDocBO.CheckAppDependParams(TxtParam: string);
begin
  { This check is done on two places, in FMntDocumentBO and FAutoRunDocBO.
    Since we only want to do this check once, we don't implement is here.
    Also CheckAppDependParams is overriden, just to avoid the inherited
    CheckAppDependParams is executed. }
   sleep (1);
end;

//=============================================================================

procedure TFrmAutoRunDocBO.Execute;
var
  LstDeletedRecs  : TStringList;  // List with information messages
  CntIndex        : integer;      // Counter to loop list
begin  // of TFrmAutoRunDocBO.Execute
  if  ViFlgAutom and ((not FlgConnect) and (not FlgPrintRep1) and
  (NumDaysDel = 0)) then begin
    SvcExceptHandler.LogMessage (CtChrLogInfo,
      SvcExceptHandler.BuildLogMessage (CtNumErrorMin, [CtTxtErrAutom]));
    Application.Terminate;
  end;
  DscDocumentBO.DataSet.Active := False;
  // Set range if application is started with /VDAYSxx
  TStoredProc(DscDocumentBO.DataSet).ParamByName('@PrmTxtSearch').AsString :=
                                    'IdtPOSTransaction';
  if NumDaysInfo > 0 then begin
    TStoredProc(DscDocumentBO.DataSet).ParamByName('@PrmDatTransFrom').AsString :=
                                      FormatDatetime('yyyymmdd hh:mm:ss',
                                      Now-NumDaysInfo);
    TStoredProc(DscDocumentBO.DataSet).ParamByName('@PrmDatTransTo').AsString :=
                                      FormatDatetime('yyyymmdd hh:mm:ss', Now);
  end;
  DscDocumentBO.DataSet.Active := True;
  // Connect all documents in dataset
  if FlgConnect then begin
    try
      DscDocumentBO.DataSet.First;
      While not DscDocumentBO.DataSet.Eof do begin
        if DmdFpnBODocument.LinkTicketToBODoc (
            DscDocumentBO.DataSet.FieldByName ('IdtPosTransaction').AsInteger,
            DscDocumentBO.DataSet.FieldByName ('IdtCheckout').AsInteger,
            StrToInt(DscDocumentBO.DataSet.FieldByName ('IdtOperator').AsString),
            DscDocumentBO.DataSet.FieldByName ('CodTrans').AsInteger,
            DscDocumentBO.DataSet.FieldByName ('DatTransBegin').AsDateTime,
            DscDocumentBO.DataSet.FieldByName ('IdtCVente').AsInteger) then
          SvcExceptHandler.LogMessage (CtChrLogInfo,
            SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
            [Format(CtTxtConnectSucceeded,[
            DscDocumentBO.DataSet.FieldByName ('IdtPosTransaction').AsString,
            DscDocumentBO.DataSet.FieldByName ('IdtCheckout').AsString,
            DscDocumentBO.DataSet.FieldByName ('CodTrans').AsString,
            DscDocumentBO.DataSet.FieldByName ('DatTransBegin').AsString,
            DscDocumentBO.DataSet.FieldByName ('IdtCVente').AsString])]));
        DscDocumentBO.DataSet.Next;
      end;
    except
      if DmdFpn.DbsFlexPoint.InTransaction then
        DmdFpn.DbsFlexPoint.Rollback;
      raise;
    end;
  end;
  // Set records as 'deleted' if application is started with /VDELxx
  if NumDaysDel > 0 then begin
    LstDeletedRecs := TStringList.Create;
    DmdFpnBODocument.DeleteTicketSince(NumDaysDel, LstDeletedRecs);
    for CntIndex := 0 to LstDeletedRecs.Count - 1 do
      SvcExceptHandler.LogMessage (CtChrLogInfo,
        SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
        [LstDeletedRecs.Strings[CntIndex]]));
    LstDeletedRecs.Clear;
    DmdFpnBODocument.DeleteBV(LstDeletedRecs);
    for CntIndex := 0 to LstDeletedRecs.Count - 1 do
      SvcExceptHandler.LogMessage (CtChrLogInfo,
        SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
        [LstDeletedRecs.Strings[CntIndex]]));
    DmdFpnBODocument.CorrectDocBOTypes;
  end;
  // Print report if application is started with /VREP1
  if FlgPrintRep1 then
    SvcTaskMgr.LaunchTask ('PrintRep1');
  Application.Terminate;
end;   // of TFrmAutoRunDocBO.Execute

//=============================================================================

procedure TFrmAutoRunDocBO.FormActivate(Sender: TObject);
begin  // of TFrmAutoRunDocBO.FormActivate
  inherited;
  if Assigned (Application.OnActivate) then
    Application.OnActivate (Sender);
end;  // of TFrmAutoRunDocBO.FormActivate

//=============================================================================
//  This procedure is added because the form doesn't close automatically when
// run in automatic mode.  It is assigned to application.onidle after the creation
// of the report
//=============================================================================

procedure TFrmAutoRunDocBO.OnIdle (Sender : TObject; var FlgIdle : Boolean);
begin  // of TFrmAutoRunDocBO.OnIdle
  Application.Terminate;
end;   // of TFrmAutoRunDocBO.OnIdle

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
