//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Flex Point
// Unit   : FSrvADOMQToDB : Form Service Message Queue POS TRANSaction
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSrvADOMQToDB.pas,v 1.1 2006/12/22 13:42:43 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FSrvADOMQToDB - CVS revision 1.4
//=============================================================================

unit FSrvADOMQToDB;

//*****************************************************************************

interface

uses
  DFpnADOServiceMQ, Windows, Messages, SysUtils, Classes, Graphics, Controls,
  SvcMgr, Dialogs, MFpnMSMQ, ADODB;

//=============================================================================
// Initialized variables
//=============================================================================

var // Message names
  ViTxtPosTransMessage  : string = 'PosTransaction';
  ViTxtPosStateMessage  : string = 'PosState';

//*****************************************************************************
// TSrvMQToDB
//*****************************************************************************

type
  TSrvMQToDB = class(TDmdFpnServiceMQ)
    procedure DmdSrvADOServiceMQCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    // Message Queue Objects
    procedure ProcessMQMessage (PtrMsg : Pointer); override;
    procedure DoOnStart (    Sender  : TService;
                         var Started : Boolean); override;
    procedure DoOnStop  (    Sender  : TService;
                         var Started : Boolean); override;
    procedure TransactionCommit; override;
    procedure TransactionStart; override;
    procedure TransactionRollback; override;
  public
    { Public declarations }
    function GetServiceController :TServiceController; override;
  end;  // of TSrvMQToDB

var
  SrvMQToDB: TSrvMQToDB;

//*****************************************************************************

implementation

uses
  STStrW,
  SfDialog,
  SmUtils,
  SmWinApi,

  DFpnADOCA,
  DMADODummy,
  DFpnADOCustomerCA,

  FXMLADOPosState,
  FXMLADOPosTransaction,
  FXMLADOCustomer,
  DFpnADOUtilsCA;


{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSrvADOMQToDB';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSrvADOMQToDB.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:42:43 $';

//*****************************************************************************
// Implementation of not-interfaced routines
//*****************************************************************************

procedure ServiceController (CtrlCode : DWord); stdcall;
begin // of ServiceController
  SrvMQToDB.Controller (CtrlCode);
end;  // of ServiceController

//*****************************************************************************
// Implementation of TSrvMQToDB
//*****************************************************************************

function TSrvMQToDB.GetServiceController: TServiceController;
begin // of TSrvMQToDB.GetServiceController
  Result := @ServiceController;
end;  // of TSrvMQToDB.GetServiceController

//=============================================================================
// TSrvMQToDB.ProcessMQMessage : processes the message(s) that are in the
// queue
//                                  -----
// INPUT  : CodType = Type of message(s) to process
//          ObjQueue = Message Queue of which the messages come from
//          ObjEvent = Event to enable after processing
//=============================================================================

procedure TSrvMQToDB.ProcessMQMessage (PtrMsg : Pointer);
var
  TxtMsgType       : string;           // Text with message description
  TxtRight         : string;           // Used only for splitstring
  TxtMsgBody       : string;           // The body of the message
begin // of TSrvMQToDB.ProcessMQMessage
  if MSMQVersion = 1 then begin
    TxtMsgBody := MSMQ10Message (PtrMsg).Body;
    SplitString (MSMQ10Message (PtrMsg).Label_, ' ', TxtMsgType, TxtRight);
  end
  else begin
    TxtMsgBody := MSMQ20Message (PtrMsg).Body;
    SplitString (MSMQ20Message (PtrMsg).Label_, ' ', TxtMsgType, TxtRight);
  end;

  if AnsiCompareText (TxtMsgType, ViTxtPosStateMessage) = 0 then
    XMLADOPosState.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, ViTxtPosTransMessage) = 0 then
    XMLADOPosTransaction.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, ViTxtCustCardMessage) = 0 then
    XMLADOCustomer.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, ViTxtCustomerMessage) = 0 then
    XMLADOCustomer.ProcessXML (TxtMsgBody);
end;  // of TSrvMQToDB.ProcessMQMessage

//=============================================================================

procedure TSrvMQToDB.DoOnStart (    Sender  : TService;
                                   var Started : Boolean);
begin // of TSrvMQToDB.DoOnStart
  FlgStopWhenError := False;
  FlgShowErrorMessage := False;
  FlgWriteErrorMessage := True;
  XMLADOPosState := TXMLADOPosState.Create;
  XMLADOPosTransaction := TXMLADOPosTransaction.Create;
  XMLADOCustomer := TXMLADOCustomer.Create;
end;  // of TSrvMQToDB.DoOnStart

//=============================================================================

procedure TSrvMQToDB.DoOnStop (    Sender  : TService;
                               var Started : Boolean);
begin // of TSrvMQToDB.DoOnStop
  if Assigned (DmdFpnADOCA.ADOConFlexpoint) then
    if DmdFpnADOCA.ADOConFlexpoint.Connected then
      DmdFpnADOCA.ADOConFlexpoint.Close;
  if Assigned (XMLADOPosState) then
    XMLADOPosState.Free;
  if Assigned (XMLADOPosTransaction) then
    XMLADOPosTransaction.Free;
  if Assigned (XMLADOCustomer) then
    XMLADOCustomer.Free;
end;  // of TSrvMQToDB.DoOnStop

//=============================================================================

procedure TSrvMQToDB.TransactionCommit;
begin // of TSrvMQToDB.TransactionCommit
  inherited;
  if DmdFpnADOCA.ADOConFlexpoint.InTransaction then
    DmdFpnADOCA.ADOConFlexpoint.CommitTrans;
end;  // of TSrvMQToDB.TransactionCommit

//=============================================================================

procedure TSrvMQToDB.TransactionStart;
begin // of TSrvMQToDB.TransactionStart
  inherited;
  DmdFpnADOCA.ADOConFlexpoint.BeginTrans;
end;  // of TSrvMQToDB.TransactionStart

//=============================================================================

procedure TSrvMQToDB.TransactionRollback;
begin // of TSrvMQToDB.TransactionRollback
  inherited;
  if DmdFpnADOCA.ADOConFlexpoint.InTransaction then
    DmdFpnADOCA.ADOConFlexpoint.RollbackTrans;
end;  // of TSrvMQToDB.TransactionRollback

//=============================================================================
// Generated Events
//=============================================================================

procedure TSrvMQToDB.DmdSrvADOServiceMQCreate(Sender: TObject);
begin // of TSrvMQToDB.DmdSrvADOServiceMQCreate
  ViTxtQueueName := 'FpnMessages';
  ViTxtPacketName := GetVersionInfoKey (ParamStr(0), 'ProductName');
  ViTxtPacketVersion := GetVersionInfoKey (ParamStr(0), 'ProductVersion');
  ViTxtApplicName := JustNameW (GetLongExeName);
  inherited;
end;  // of TSrvMQToDB.DmdSrvADOServiceMQCreate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSrvADOMQToDB
