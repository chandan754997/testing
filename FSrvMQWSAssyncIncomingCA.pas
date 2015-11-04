//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : FSrvMQWSAssyncIncomingCA: SeRVice to check Message Queue WebSphere
//            for ASSYNChronous INCOMING messages for CAstorama.
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSrvMQWSAssyncIncomingCA.pas,v 1.10 2008/04/21 15:10:11 JozuaVL Exp $
// History :
//=============================================================================

unit FSrvMQWSAssyncIncomingCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  MWebsphereMQ, MMQI, ScEHdler, ExtCtrls;

//=============================================================================
// Initialized variables
//=============================================================================

var
  ViTxtQueueName        : string  = 'OUTPUTQ_A_'; // queue name
  ViTxtQMgrName         : string  = 'QM_';        // queue manager name

//=============================================================================
// Constants for format types of interfaces
//=============================================================================

const
  CtCodLastHigh         = 1;                // Number of high priority interfaces
  CtCodLastLow          = 8;                // Numbe of low priority interfaces

var
  ViArrTxtFrmtInterfLow : array [1..CtCodLastLow] of string[6] = ('I01_1C', 'I01_2C',
                          'I01_4C', 'I01_6C', 'I01_7C', 'I07_1C', 'I11_3C',
                          'I16_1C');
                          // 'I01_1C' --> Article & price
                          // 'I01_4C' --> Material group master
                          // 'I01_6C' --> Promotion rule
                          // 'I01_7C' --> Tax rate
                          // 'I07_1C' --> Customer data
                          // 'I11_3C' --> Update ticket as "coupon redeemed"
                          // 'I16_1C' --> Coupon usage rules
  ViArrTxtFrmtInterfHigh : array [1..CtCodLastHigh] of string[6] = ('I03_1C');
                          // 'I03_1C' --> Customer order

//=============================================================================
// General constants
//=============================================================================

const
  CtTxtCheckFile        = '\Data\POS\QMgrNtAvail.chk';

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring // Error messages
  CtTxtErrOnStop        = 'Occurs when service stops';
  CtTxtErrOnStart       = 'Occurs when service starts';
  CtTxtErrOnExecute     = 'Occurs when service executes';

//*****************************************************************************
// Interface of TSrvMQWSAssyncIncomingCA
//*****************************************************************************

type
  TSrvMQWSAssyncIncomingCA = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceCreate(Sender: TObject);
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
  SrvMQWSAssyncIncomingCA: TSrvMQWSAssyncIncomingCA;

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
  CtTxtModuleName = 'FSrvMQWSAssyncIncomingCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile: $';
  CtTxtSrcVersion = '$Revision: 1.10 $';
  CtTxtSrcDate    = '$Date: 2008/04/21 15:10:11 $';

//*****************************************************************************
// Implementation of not-interfaced routines
//*****************************************************************************

procedure ServiceController(CtrlCode: DWord); stdcall;
begin // of ServiceController
  SrvMQWSAssyncIncomingCA.Controller(CtrlCode);
end;  // of ServiceController

//*****************************************************************************
// Implementation of TSrvMQWSAssyncIncomingCA
//*****************************************************************************

function TSrvMQWSAssyncIncomingCA.GetServiceController: TServiceController;
begin  // of TSrvMQWSAssyncIncomingCA.GetServiceController
  Result := ServiceController;
end;   // of TSrvMQWSAssyncIncomingCA.GetServiceController

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceCreate(Sender: TObject);
var
  CntParam         : Integer;         // Parameter index
begin  // of TSrvMQWSAssyncIncomingCA.ServiceCreate
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
end;   // of TSrvMQWSAssyncIncomingCA.ServiceCreate

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceStart(Sender: TService;
  var Started: Boolean);
begin  // of TSrvMQWSAssyncIncomingCA.ServiceStart
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
end;   // of TSrvMQWSAssyncIncomingCA.ServiceStart

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceExecute(Sender: TService);
var
  TxtMsgFormat     : string;           // Format of message
  TxtMsgBody       : string;           // Body of message
  StrLstMsgBody    : TStringList;      // Stringlist of body message
  CntItem          : Integer;          // Counter item
  FlgConnected     : boolean;          // Connected with Queue manager
  ValSleep         : integer;
begin
  inherited;
  FlgConnected := False;
  try
    try
      StrLstMsgBody := TStringList.Create;
      while not Terminated do begin
        //ServiceThread.ProcessRequests (False);
        if not FlgConnected then begin
          try
            MQ.ConnectQMgr (ViTxtQMgrName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
            MQ.OpenQueueForInput (ViTxtQueueName + DmdFpnADOUtilsCA.IdtTradeMatrixAssort);
            FlgConnected := True;
          except
            FlgConnected := False;
            FileClose(FileCreate(ReplaceEnvVar ('%sycroot%') + CtTxtCheckFile));
          end;
        end
        else begin
          if FileExists(ReplaceEnvVar ('%sycroot%') + CtTxtCheckFile) then
            DeleteFile(ReplaceEnvVar ('%sycroot%') + CtTxtCheckFile);
          //MQ.BeginTransaction;
          MQ.RecieveAssyncMessage(TxtMSgBody, TxtMsgFormat);
          if Trim(TxtMsgFormat) <> '' then begin
            StrLstMsgBody.Text := TxtMsgBody;
            try
              for CntItem := 1 to CtCodLastLow do
                if Trim(TxtMsgFormat) = ViArrTxtFrmtInterfLow [CntItem] then
                  ADOMQWSInterfaces.ProcessAssyncIn (StrLstMsgBody, TxtMsgFormat, False);
              for CntItem := 1 to CtCodLastHigh do
                if Trim(TxtMsgFormat) = ViArrTxtFrmtInterfHigh [CntItem] then
                  ADOMQWSInterfaces.ProcessAssyncIn (StrLstMsgBody, TxtMsgFormat, True);
              //MQ.CommitTransaction;
            except
              on E: Exception do begin
                //MQ.RollbackTransaction;
                ExceptionHandler(Sender, E);
              end;
            end;
          end;
          ValSleep := 0;
          while ValSleep < ValSleepTime do begin
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
      MQ.DisconnectQMgr;
    end;
  end;
end;

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin  // of TSrvMQWSAssyncIncomingCA.ServiceStop
  try
    Stopped := True;
  except
    on E: Exception do begin
      E.message := E.message + #10 + CtTxtErrOnStop;
      ExceptionHandler(Sender, E);
    end;
  end;
end;   // of TSrvMQWSAssyncIncomingCA.ServiceStop

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceDestroy(Sender: TObject);
begin  // of TSrvMQWSAssyncIncomingCA.ServiceDestroy
  try
    MQ.Destroy;
  except
    on E: Exception do
      ExceptionHandler(Sender, E);
  end;
  inherited;
end;   // of TSrvMQWSAssyncIncomingCA.ServiceDestroy

//=============================================================================
// TSrvMQWSAssyncCA.ExceptionHandler : Procedure called to log exception
//                                  -----
// INPUT  : Sender = The sender that has raised the error
//          E = The exception that occurred
//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ExceptionHandler (Sender : TObject;
                                             E      : Exception);
var
  ItmExcept        : TExceptItem;      // Found item in DefinedExceptions
begin  // of TSrvMQWSAssyncIncomingCA.ExceptionHandler
  SvcExceptHandler.LogMessage (CtChrLogError,
    SvcExceptHandler.BuildLogMessage (CtNumErrorMin, [E.Message]));
end;   // of TSrvMQWSAssyncIncomingCA.ExceptionHandler

//=============================================================================

procedure TSrvMQWSAssyncIncomingCA.ServiceAfterInstall(Sender: TService);
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

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSrvMQWSAssyncIncomingCA
