//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : FSrvMQWSAssyncOutgoingCA: SeRVice to put on Message Queue WebSphere
//            ASSYNChronous OUTGOING messages for CAstorama.
//-----------------------------------------------------------------------------
// PVCS    : $ $
// History :
//=============================================================================

unit FSrvMQWSAssyncOutgoingCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  MWebsphereMQ, MMQI, MFpnMSMQ, ScEHdler, ExtCtrls, MSXML_TLB;

//=============================================================================
// Initialized variables
//=============================================================================

var
  ViTxtQueueName        : string  = 'INPUTQ_A_';  // queue name
//  ViTxtQueueName        : string  = 'OUTPUTQ_A_';  // queue name
  ViTxtQMgrName         : string  = 'QM_';        // queue manager name

var
  XMLDoc           : IXMLDOMDocument = nil; // The XML to be made

var
  XMLNode          : IXMLDOMElement;   // Node of the XML

//=============================================================================
// Constants for format types of interfaces
//=============================================================================

const
  CtTxtInterface        = 'I02C';                 //  Format of XML message

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring // Error messages
  CtTxtErrOnStop        = 'Occurs when service stops';
  CtTxtErrOnStart       = 'Occurs when service starts';
  CtTxtErrOnExecute     = 'Occurs when service executes';

//*****************************************************************************
// Interface of TSrvMQWSAssyncOutgoingCA
//*****************************************************************************

type
  TSrvMQWSAssyncOutgoingCA = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
    ValSleepTime : integer;
  protected
    { Protected declarations }
    FFlgDebugMode       : Boolean;     // Flag is set when in debugmode
    procedure SendMessage (TxtBody  : string);
  public
    { Public declarations }

    // Websphere MQ
    CompCode, reason:  MQLONG;
    HConn : MQHCONN;
    QMgrName: MQCHAR48;
    HObj: MQHobj;
    ObjDesc: MQOD;
    Options: MQLONG;
    MQ: TWebSphereMQ;

    //Properties
    property FlgDebugMode: boolean read  FFlgDebugMode
                                   write FFlgDebugMode;

    //Functions
    function GetServiceController: TServiceController; override;

    //Procedures
    procedure ExceptionHandler (Sender : TObject;
                                E      : Exception); virtual;
  end;

var
  SrvMQWSAssyncOutgoingCA: TSrvMQWSAssyncOutgoingCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  StStrW,
  SmUtils,
  SmWinApi,
  Registry,
  DFpnADOUtilsCA,
  FADOMQWSInterfaces;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSrvMQWSAssyncOutgoingCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile: $';
  CtTxtSrcVersion = '$Revision: 1.10 $';
  CtTxtSrcDate    = '$Date: 2008/04/21 15:10:11 $';

//*****************************************************************************
// Implementation of not-interfaced routines
//*****************************************************************************

procedure ServiceController(CtrlCode: DWord); stdcall;
begin  // of ServiceController
  SrvMQWSAssyncOutgoingCA.Controller(CtrlCode);
end;   // of ServiceController

//*****************************************************************************
// Implementation of TSrvMQWSAssyncOutgoingCA
//*****************************************************************************

function TSrvMQWSAssyncOutgoingCA.GetServiceController: TServiceController;
begin  // of TSrvMQWSAssyncOutgoingCA.GetServiceController
  Result := ServiceController;
end;   // of TSrvMQWSAssyncOutgoingCA.GetServiceController

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceAfterInstall(Sender: TService);
var
  RegDependencies  : TRegistry;        // Registry
  ArrByte          : array[1..127] of Byte; // buffer to write
  TxtValue         : string;           // Value
  CntDepend        : Integer;          // Index for dependency loop
  CntText          : Integer;          // Index for text loop
  CntIndex         : Integer;          // Index for array
begin  // of TSrvMQWSAssyncOutgoingCA.ServiceAfterInstall
 if Dependencies.Count <> 0 then begin
   TxtValue := '';
   CntIndex := 1;
   for CntDepend := 0 to Pred (Dependencies.Count) do begin
     TxtValue := Dependencies[CntDepend].Name;
     for CntText := 1 to Length (TxtValue) do begin
       ArrByte[CntIndex] :=  Ord (TxtValue[CntText]);
       Inc (CntIndex);
     end;
     ArrByte[CntIndex] := 0;
     Inc (CntIndex);
   end;
   ArrByte[CntIndex] := 0;

   RegDependencies := TRegistry.Create;
   try
     RegDependencies.RootKey := HKEY_LOCAL_MACHINE;
     RegDependencies.OpenKey ('SYSTEM\CURRENTCONTROLSET\SERVICES\' + Name,
                              false);
     RegSetValueEx (RegDependencies.CurrentKey, 'DependOnService', 0,
                    REG_MULTI_SZ, @ArrByte, CntIndex);
   finally
     RegDependencies.Free;
   end;
  end;
end;   // of TSrvMQWSAssyncOutgoingCA.ServiceAfterInstall

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceCreate(Sender: TObject);
var
  CntParam         : Integer;         // Parameter index
begin  // of TSrvMQWSAssyncOutgoingCA.ServiceCreate
  try
    MQ := TWebsphereMQ.Create;
  except
    on E: Exception do
      ExceptionHandler(Sender, E);
  end;
  SmUtils.ViFlgAutom := True;
  // To start in debug mode
  SfDialog.AddRunParams ('/DEBUG', 'To run from command prompt');
  for CntParam := 1 to System.ParamCount do begin
    if AnsiCompareText (Paramstr (CntParam),'/DEBUG') = 0 then begin
      FlgDebugMode := True;
      DoStart;
      Break;
    end;
  end;
end;   // of TSrvMQWSAssyncOutgoingCA.ServiceCreate

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceStart(Sender: TService;
  var Started: Boolean);
begin  // of TSrvMQWSAssyncOutgoingCA.ServiceStart
 inherited;
  try
    if Assigned (ADOMQWSInterfaces) then begin
      ADOMQWSInterfaces.Free;
      ADOMQWSInterfaces := nil;
    end;
    ADOMQWSInterfaces := TADOMQWSInterfaces.Create;
    ValSleeptime := ADOMQWSInterfaces.GetSleeptime;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStart;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvMQWSAssyncOutgoingCA.ServiceStart

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceExecute(Sender: TService);
var
  ValSleep : integer;
  ValTimeToSleep : integer;
begin
  while not Terminated do begin
    try
      ValTimeToSleep := ValSleepTime;
      MQ.ConnectQMgr (ViTxtQMgrName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
      MQ.OpenQueueForOutput(ViTxtQueueName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
      ADOMQWSInterfaces.ProcessAssyncOut(MQ);
      MQ.CloseQueueForOutput;
      MQ.DisconnectQMgr;
    except
      on E: Exception do begin
        ValTimeToSleep := ValSleepTime * 100;
        E.message := E.message + #10 + CtTxtErrOnStart;
        ExceptionHandler(Sender, E);
      end;
    end;
    ValSleep := 0;
    while ValSleep < ValTimeToSleep do begin
      Sleep(500);
      ServiceThread.ProcessRequests (False);
      ValSleep := ValSleep + 500;
    end;
  end;
end;

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin  // of TSrvMQWSAssyncOutgoingCA.ServiceStop
  try
    Stopped := True;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStop;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvMQWSAssyncOutgoingCA.ServiceStop

//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ServiceDestroy(Sender: TObject);
begin  // of TSrvMQWSAssyncOutgoingCA.ServiceDestroy
  try
    MQ.Destroy;
  except
    on E: Exception do
      ExceptionHandler(Sender, E);
  end;
  inherited;
end;   // of TSrvMQWSAssyncOutgoingCA.ServiceDestroy

//=============================================================================
// TSrvMQWSAssyncOutgoingCA.SendMessage : To send a message to message queue
//                                  -----
// INPUT : TxtLabel = The label of the message
//         TxtBody = Body of the message
//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.SendMessage (TxtBody  : string);
begin  // of TSrvMQWSAssyncOutgoingCA.SendMessage
  try
    try
      MQ.ConnectQMgr (ViTxtQMgrName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
      MQ.OpenQueueForOutput (ViTxtQueueName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
      MQ.SendMessage(TxtBody , CtTxtInterface);
    finally;
      MQ.CloseQueueForOutput;
      MQ.DisconnectQMgr;
    end;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnExecute;
      ExceptionHandler(Self, E);
    end;
  end;
end;   // of TSrvMQWSAssyncOutgoingCA.SendMessage

//=============================================================================
// TSrvMQWSAssyncIncomingCA.ExceptionHandler : Procedure called to log exception
//                                  -----
// INPUT  : Sender = The sender that has raised the error
//          E = The exception that occurred
//=============================================================================

procedure TSrvMQWSAssyncOutgoingCA.ExceptionHandler (Sender : TObject;
                                             E      : Exception);
var
  ItmExcept        : TExceptItem;      // Found item in DefinedExceptions
begin  // of TSrvMQWSAssyncOutgoingCA.ExceptionHandler
  ItmExcept := SvcExceptHandler.DefinedExceptions.FindException (E);
  if Assigned (ItmExcept) or SvcExceptHandler.HandleUndefined then
    SvcExceptHandler.ProcessException (Sender, E, ItmExcept);
end;   // of TSrvMQWSAssyncOutgoingCA.ExceptionHandler

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSrvMQWSAssyncIncomingCA
