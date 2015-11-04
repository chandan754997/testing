//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : FSrvMQWSSyncIncomingCA: SeRVice to  process Message Queue WebSphere
//            SYNChronous ONCOMING messages for CAstorama.
//-----------------------------------------------------------------------------
// PVCS    : $ $
// History :
//=============================================================================

unit FSrvMQWSSyncIncomingCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  MWebsphereMQ, MMQI, MFpnMSMQ, ScEHdler, ExtCtrls, ComObj;

//=============================================================================
// Initialized variables
//=============================================================================

var
  ViTxtQueueName        : string  = 'OUTPUTQ_S_'; // queue name
  ViTxtQMgrName         : string  = 'QM_';        // queue manager name
  ViTxtReplyQueue       : string  = 'REPLYQ_';    // reply queue name
//  ViTxtReplyQueue       : string  = 'OUTPUTQ_A_';    // reply queue name

//=============================================================================
// Constants for format types of interfaces
//=============================================================================

  CtTxtIntFormat : string = 'I15_2C';

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
  TSrvMQWSSyncIncomingCA = class(TService)
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
    ValSleepTime : integer;
  protected
    { Protected declarations }
    FFlgDebugMode       : Boolean;     // Flag is set when in debugmode
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
  SrvMQWSSyncIncomingCA: TSrvMQWSSyncIncomingCA;

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
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2008/04/21 15:10:11 $';

//*****************************************************************************
// Implementation of non-interfaced routines
//*****************************************************************************

procedure ServiceController(CtrlCode: DWord); stdcall;
begin  // of ServiceController
  SrvMQWSSyncIncomingCA.Controller(CtrlCode);
end;   // of ServiceController

//*****************************************************************************
// Implementation of TSrvMQWSSyncIncomingCA
//*****************************************************************************

function TSrvMQWSSyncIncomingCA.GetServiceController: TServiceController;
begin  // of TSrvMQWSSyncIncomingCA.GetServiceController
  Result := ServiceController;
end;   // of TSrvMQWSSyncIncomingCA.GetServiceController

//=============================================================================

procedure ProcessSyncMessage(TxtMsgInBody: string;
                             TxtMsgInFormat: string;
                         var TxtMsgOutBody: string;
                         var TxtMsgOutFormat: string);// stdcall;
begin  // of ProcessSyncMessage
  if Trim(TxtMsgInFormat) = CtTxtIntFormat then begin
    AnsiPos('', TxtMsgInBody);
    TxtMsgInBody := Copy(TxtMsgInBody, AnsiPos('<In_Stock_Delivery>', TxtMsgInBody),
                        length(TxtMsgInBody));
    TxtMsgInBody := Copy(TxtMsgInBody, 1,
                        AnsiPos('</In_Stock_Delivery>', TxtMsgInBody) +
                        length('</In_Stock_Delivery>')-1);

    ADOMQWSInterfaces.ProcessSyncIn (TxtMsgInBody);
    TxtMsgOutBody := ADOMQWSInterfaces.TxtMsgOutBody;
    TxtMsgOutFormat := ADOMQWSInterfaces.TxtMsgOutFormat;
  end;
end;   // of ProcessSyncMessage

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceCreate(Sender: TObject);
var
  CntParam         : Integer;         // Parameter index
begin  // of TSrvMQWSSyncIncomingCA.ServiceCreate
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
end;   // of TSrvMQWSSyncIncomingCA.ServiceCreate

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceStart(Sender: TService;
  var Started: Boolean);
begin  // of TSrvMQWSSyncIncomingCA.ServiceStart
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
end;   // of TSrvMQWSSyncIncomingCA.ServiceStart

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceExecute(Sender: TService);
var
  TxtMsgFormat     : string;           // Format of message
  TxtMsgBody       : string;           // Body of message
  ValSleep         : integer;
  ValSleepTotal    : integer;
  FlgConnected     : boolean;          // Connected with Queue manager
begin  // of TSrvMQWSSyncIncomingCA.ServiceExecute
  FlgConnected := False;
  try
    try
      while not Terminated do begin
        if not FlgConnected then begin
          try
            MQ.ConnectQMgr (ViTxtQMgrName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
            MQ.OpenQueueForInput (ViTxtQueueName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
            MQ.OpenQueueForOutput(ViTxtReplyQueue + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
            MQ.TxtInputQueue := ViTxtReplyQueue + DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
            FlgConnected := True;
          except
            FlgConnected := False;
          end;
        end
        else begin
          try
            MQ.ReceiveSynchronousMessage(@ProcessSyncMessage, 2000);
          except
            on ESvcWebSphereMQTimeOut do;
            on E: Exception do begin
              E.message := E.message + #10 + CtTxtErrOnExecute;
              ExceptionHandler(Sender, E);
            end;
          end;
          ValSleep := 0;
          ValSleepTotal := ValSleepTime - 2000;
          if ValSleepTotal < 0 then
            ValSleepTotal := 1000;
          while ValSleep <= ValSleepTotal do begin
            Sleep(500);
            ServiceThread.ProcessRequests (False);
            ValSleep := ValSleep + 500;
          end;
        end;
      end;
    except
      on E: Exception do begin
        E.message := E.message + #10 + CtTxtErrOnExecute;
        ExceptionHandler(Sender, E);
      end;
    end;
  finally
    if FlgConnected then begin
      MQ.CloseQueueForInput;
      MQ.CloseQueueForOutput;
      MQ.DisconnectQMgr;
    end;
  end;
end;   // of TSrvMQWSSyncIncomingCA.ServiceExecute

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin  // of TSrvMQWSSyncIncomingCA.ServiceStop
  try
    Stopped := True;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStop;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvMQWSSyncIncomingCA.ServiceStop

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceDestroy(Sender: TObject);
begin  // of TSrvMQWSSyncIncomingCA.ServiceDestroy
  try
    MQ.Destroy;
  except
    on E: Exception do
      ExceptionHandler(Sender, E);
  end;
  inherited;
end;   // of TSrvMQWSSyncIncomingCA.ServiceDestroy

//=============================================================================
// TSrvMQWSSyncIncomingCA.ExceptionHandler : Procedure called to log exception
//                                  -----
// INPUT  : Sender = The sender that has raised the error
//          E = The exception that occurred
//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ExceptionHandler (Sender : TObject;
                                             E      : Exception);
var
  ItmExcept        : TExceptItem;      // Found item in DefinedExceptions
begin  // of TSrvMQWSSyncIncomingCA.ExceptionHandler
  SvcExceptHandler.LogMessage (CtChrLogError,
    SvcExceptHandler.BuildLogMessage (CtNumErrorMin, [E.Message]));
end;   // of TSrvMQWSSyncIncomingCA.ExceptionHandler

//=============================================================================

procedure TSrvMQWSSyncIncomingCA.ServiceAfterInstall(Sender: TService);
var
  RegDependencies  : TRegistry;        // Registry
  ArrByte          : array[1..127] of Byte; // buffer to write
  TxtValue         : string;           // Value
  CntDepend        : Integer;          // Index for dependency loop
  CntText          : Integer;          // Index for text loop
  CntIndex         : Integer;          // Index for array
begin  // of TSrvMQWSSyncIncomingCA.ServiceAfterInstall
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
end;   // of TSrvMQWSSyncIncomingCA.ServiceAfterInstall

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSrvMQWSSyncIncomingCA
