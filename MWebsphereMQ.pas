//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : MWebsphereMQ: Module WEBSPHERE Message Queueing.
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/MWebsphereMQ.pas,v 1.9 2007/06/21 08:20:19 JozuaVL Exp $
// History :
//=============================================================================

unit MWebsphereMQ;

//*****************************************************************************

interface

uses
  SysUtils,
  Dialogs,

  (*$IFNDEF MWebSpereMQClient *)
  MMQI;
  (*$ENDIF*)

  (*$IFDEF MWebSpereMQClient *)
  MMQIC;
  (*$ENDIF*)


//*****************************************************************************
// TWebSphereMQ
//*****************************************************************************

type
  TReceiveProcedure = procedure (TxtMessageInBody: string;
                                 TxtMessageInFormat: string;
                             var TxtMessageOutBody: string;
                             var TxtMessageOutFormat: string);
  TWebSphereMQ = Class
    private
      // Result information
      CodComp       : MQLONG;
      CodReason     : MQLONG;
      MQHObjOutput  : MQHobj;
      MQHObjInput   : MQHobj;

      // QManager information
      FTxtInputQueue: string;
      FTxtInputQMgr : string;
      HConn         : MQHCONN;
    public
      // Intializing
      procedure initialize;

      // QueueManager
     procedure ConnectQMgr (TxtQMgrName: string);
     procedure DisconnectQMgr;

      // Queue
      procedure OpenQueueForOutput (TxtQueueName: string);
      procedure CloseQueueForOutput;

      procedure OpenQueueForInput (TxtQueueName: string);
      procedure CloseQueueForInput;

      // Message
      procedure SendMessage (TxtMessageBody: string;
                                     TxtMessageFormat: string);
      procedure RecieveAssyncMessage (var TxtMessageBody: string;
                                      var TxtMessageformat: string);
      procedure SendSynchronousMessage (TxtMessageOutBody: string;
                                                TxtMessageOutFormat: string;
                                                var TxtMessageInBody: string;
                                                var TxtMessageInFormat: string;
                                                WaitInterval: integer);
      procedure ReceiveSynchronousMessage (ReceiveProcedure: TReceiveProcedure ;
                                           WaitInterval: integer);

      // Transactions
      procedure BeginTransaction;
      procedure CommitTransaction;
      procedure RollbackTransaction;

      // Properties
      property TxtInputQueue : string read FTxtInputQueue write FTxtInputQueue;
      property TxtInputQMgr : string read FTxtInputQMgr write FTxtInputQMgr;
  end;

  const
(*TEMP*)        MQMI_test    : MQBYTE24  = ($1,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,
(*TEMP*)                                    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0);

//=============================================================================

type
  ESvcWebSphereMQTimeOut     = class (Exception);
  ESvcWebSphereMsgOut        = class (Exception);

//*****************************************************************************

implementation

{ TWebsphereMQ }

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'MWebSphereMQ';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile: $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2007/06/21 08:20:19 $';

//*****************************************************************************
// Implementation of TWebSphereMQ
//*****************************************************************************

procedure TWebsphereMQ.CloseQueueForInput;
begin  // of TWebsphereMQ.CloseQueueForInput
  MQCLOSE (HConn,@MQHObjInput,MQCO_NONE,@CodComp,@CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['closing incoming queue',CodReason]);
end;   // of TWebsphereMQ.CloseQueueForInput

//=============================================================================

procedure TWebsphereMQ.CloseQueueForOutput;
begin  // of TWebsphereMQ.CloseQueueForOutput
  MQCLOSE (HConn,@MQHObjOutput,MQCO_NONE,@CodComp,@CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['closing outgoing queue',CodReason]);
end;   // of TWebsphereMQ.CloseQueueForOutput

//=============================================================================

procedure TWebsphereMQ.ConnectQMgr(TxtQMgrName: string);
var
  QMgrName: MQCHAR48;
begin  // of TWebsphereMQ.ConnectQMgr
  StrPCopy (QMgrName, TxtQMgrName);

  MQCONN (@QMgrName,@hconn,@CodComp,@CodReason);
  if CodComp <> MQCC_OK then begin
    if CodReason <> MQRC_ALREADY_CONNECTED then
      raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                               ['connecting',CodReason]);
  end;
end;   // of TWebsphereMQ.ConnectQMgr

//=============================================================================

procedure TWebsphereMQ.DisconnectQMgr;
begin  // of TWebsphereMQ.DisconnectQMgr
  MQDISC (@HConn, @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                              ['disconnecting',CodReason]);
end;   // of TWebsphereMQ.DisconnectQMgr

//=============================================================================

procedure TWebsphereMQ.initialize;
begin  // of TWebsphereMQ.initialize
  // Result information
  MQHObjOutput := 0;
  MQHObjInput := 0;

  // QManager information
  HConn:= 0;
end;   // of TWebsphereMQ.initialize

//=============================================================================

procedure TWebsphereMQ.OpenQueueForInput(TxtQueueName: string);
var

   ObjDesc: MQOD;
   Options: MQLONG;
begin  // of TWebsphereMQ.OpenQueueForInput
  Options := MQOO_INPUT_AS_Q_DEF + MQOO_FAIL_IF_QUIESCING;
  ObjDesc := MQOD_DEFAULT;
  StrPCopy (ObjDesc.objectname, TxtQueueName);
  MQOPEN (HConn,@ObjDesc,Options,@MQHObjInput,@CodComp,@CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['opening incoming queue',CodReason]);
end;   // of TWebsphereMQ.OpenQueueForInput

//=============================================================================

procedure TWebsphereMQ.OpenQueueForOutput(TxtQueueName: string);
var
   ObjDesc: MQOD;
   Options: MQLONG;
begin  // of TWebsphereMQ.OpenQueueForOutput
  Options := MQOO_Output + MQOO_FAIL_IF_QUIESCING;
  ObjDesc := MQOD_DEFAULT;
  StrPCopy (ObjDesc.objectname, TxtQueueName);
  MQOPEN (HConn,@ObjDesc,Options,@MQHObjOutput,@CodComp,@CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['opening outgoing queue',CodReason]);
end;   // of TWebsphereMQ.OpenQueueForOutput

//=============================================================================

procedure TWebsphereMQ.ReceiveSynchronousMessage(
  ReceiveProcedure: TReceiveProcedure; WaitInterval: integer);
var
  MsgDesc: MQMD;
  Bufferlength: MQLONG;
  Buffer: array [0..300000] of char;
  PutMsgOptions : MQPMO;
  DataLength: Integer;
  GetMsgOptions: MQGMO;
  CorrelID: MQBYTE24;
  TxtMessageInBody: string;
  TxtMessageInFormat: string;
  TxtMessageOutBody: string;
  TxtMessageOutFormat: string;
begin  // of TWebsphereMQ.ReceiveSynchronousMessage
  BufferLength := 300000;
  FillChar(Buffer, Length(Buffer), #0);
  DataLength := 0;
  GetMsgOptions := MQGMO_DEFAULT;
  GetMsgOptions.Options := MQGMO_WAIT + MQGMO_FAIL_IF_QUIESCING;
  GetMsgOptions.WaitInterval := WaitInterval;
  MsgDesc := MQMD_DEFAULT;

  MQGET (HConn, MQHObjInput, @MsgDesc, @GetMsgOptions , BufferLength, Buffer,
         @DataLength, @CodComp, @codReason);
  if CodComp <> MQCC_OK then begin
    // When timeout received, raise specific exception
    if CodReason = MQRC_NO_MSG_AVAILABLE then
      raise ESvcWebSphereMQTimeOut.CreateFmt('Error when %s. Reason code: %d  ',
                                             ['receiving message',CodReason])
    else
      raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                                ['receiving message',CodReason]);
  end;
  TxtMessageInBody := Buffer;
  TxtMessageInFormat := MsgDesc.Format;
  CorrelID := MsgDesc.MsgId;

  // ProcessMessage
  ReceiveProcedure (TxtMessageInBody, TxtMessageInFormat, TxtMessageOutBody,
                    TxtMessageOutFormat);
  if (Trim (TxtMessageOutBody) = '') or (Trim (TxtMessageOutFormat) = '') then
    raise ESvcWebSphereMsgOut.CreateFmt ('No valid response constructed for ' +
      'message.  Format: %s, Body: %s', [TxtMessageInFormat, TxtMessageInBody]);

  // SendMessage
  BufferLength := Length (TxtMessageOutBody);
  FillChar(Buffer, Length(Buffer), #0);
  StrPCopy (Buffer, TxtMessageOutBody);
  PutMsgOptions := MQPMO_DEFAULT;
  PutMsgOptions.TimeOut := 3600000;
  MsgDesc := MQMD_DEFAULT;

  StrPCopy (MsgDesc.ReplyToQ, TxtInputQueue);
  MsgDesc.MsgType := MQMT_DATAGRAM;
  MsgDesc.CorrelId := CorrelID;
  MsgDesc.Report := MQRO_PAN + MQRO_COPY_MSG_ID_TO_CORREL_ID;

  StrPCopy (MsgDesc.Format, TxtMessageOutFormat);
  MQPUT (HConn, MQHObjOutput, @MsgDesc, @PutMsgOptions , Bufferlength, @Buffer,
         @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['sending message',CodReason]);
end;   // of TWebsphereMQ.ReceiveSynchronousMessage

//=============================================================================

procedure TWebsphereMQ.RecieveAssyncMessage(var TxtMessageBody: string;
   var TxtMessageformat: string);var
   MsgDesc: MQMD;
   Bufferlength: MQLONG;
   Buffer: array [0..300000] of char;
   GetMsgOptions: MQGMO;
   DataLength: Integer;
begin  // of TWebsphereMQ.RecieveAssyncMessage
  BufferLength := 300000;
  DataLength := 0;
  GetMsgOptions := MQGMO_DEFAULT;
  MsgDesc := MQMD_DEFAULT;
  FillChar(Buffer, Length(Buffer), #0);

  MQGET (HConn, MQHObjInput, @MsgDesc, @GetMsgOptions , BufferLength, Buffer,
         @DataLength, @CodComp, @codReason);
  if (CodComp <> MQCC_OK) and (CodReason <> MQRC_NO_MSG_AVAILABLE) then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['receiving message',CodReason]);
  TxtMessageBody := Buffer;
  TxtMessageFormat := MsgDesc.Format;

end;   // of TWebsphereMQ.RecieveAssyncMessage

//=============================================================================

procedure TWebsphereMQ.SendMessage(TxtMessageBody,
  TxtMessageFormat: string);
var
  MsgDesc: MQMD;
  Bufferlength: MQLONG;
  Buffer: array [0..300000] of char;
  PutMsgOptions : MQPMO;
//  DataLength: Integer;
begin  // of TWebsphereMQ.SendMessage
  FillChar(Buffer, Length(Buffer), #0);
  BufferLength := Length (TxtMessageBody);
  StrPCopy (Buffer, TxtMessageBody);
  PutMsgOptions := MQPMO_DEFAULT;
  MsgDesc := MQMD_DEFAULT;
  StrPCopy (MsgDesc.Format, TxtMessageFormat);
  MQPUT (HConn, MQHObjOutput, @MsgDesc, @PutMsgOptions , Bufferlength, @Buffer,
        @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['sending message',CodReason]);
end;   // of TWebsphereMQ.SendMessage

//=============================================================================

procedure TWebsphereMQ.SendSynchronousMessage(TxtMessageOutBody,
  TxtMessageOutFormat: string; var TxtMessageInBody,
  TxtMessageInFormat: string; WaitInterval: integer);
var
  MsgDesc: MQMD;
  Bufferlength: MQLONG;
  Buffer: array [0..300000] of char;
  PutMsgOptions : MQPMO;
  DataLength: Integer;
  GetMsgOptions: MQGMO;
  CorrelID: MQBYTE24;
begin  // of TWebsphereMQ.SendSynchronousMessage
  // SendMessage
  FillChar(Buffer, Length(Buffer), #0);
  BufferLength := Length (TxtMessageOutBody);
  StrPCopy (Buffer, TxtMessageOutBody);
  PutMsgOptions := MQPMO_DEFAULT;
  PutMsgOptions.TimeOut := 3600000;
  MsgDesc := MQMD_DEFAULT;

  StrPCopy (MsgDesc.ReplyToQ, TxtInputQueue);
  StrPCopy (MsgDesc.ReplyToQMgr, TxtInputQMgr);
  MsgDesc.MsgType := MQMT_DATAGRAM;
  MsgDesc.Report := MQRO_PAN + MQRO_COPY_MSG_ID_TO_CORREL_ID;

  StrPCopy (MsgDesc.Format, TxtMessageOutFormat);
  MQPUT (HConn, MQHObjOutput, @MsgDesc, @PutMsgOptions , Bufferlength, @Buffer,
         @CodComp, @CodReason);
  CorrelId := MsgDesc.MsgId;
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['sending message',CodReason]);

  BufferLength := 300000;
  FillChar(Buffer, Length(Buffer), #0);
  DataLength := 0;
  GetMsgOptions := MQGMO_DEFAULT;
  GetMsgOptions.MatchOptions :=  MQMO_MATCH_CORREL_ID;
  GetMsgOptions.Options := MQGMO_WAIT + MQGMO_FAIL_IF_QUIESCING;
  GetMsgOptions.WaitInterval := WaitInterval;
  MsgDesc := MQMD_DEFAULT;
  MsgDesc.CorrelId := CorrelID;

  MQGET (HConn, MQHObjInput, @MsgDesc, @GetMsgOptions , BufferLength, Buffer,
        @DataLength, @CodComp, @codReason);
  if CodComp <> MQCC_OK then begin
    // When timeout received, raise specific exception
    if CodReason = MQRC_NO_MSG_AVAILABLE then
      raise ESvcWebSphereMQTimeOut.CreateFmt('Error when %s. Reason code: %d  ',
                                             ['receiving message',CodReason])
    else
      raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                                ['receiving message',CodReason]);
  end;
  TxtMessageInBody := Buffer;
  TxtMessageInFormat := MsgDesc.Format;
end;   // of TWebsphereMQ.SendSynchronousMessage

//=============================================================================

procedure TWebsphereMQ.BeginTransaction;
var
  BeginOptions : PMQBO;
begin  // of TWebsphereMQ.BeginTransaction
  MQBEGIN (HConn, BeginOptions, @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['beginning transaction',CodReason]);
end;   // of TWebsphereMQ.BeginTransaction

//=============================================================================

procedure TWebsphereMQ.CommitTransaction;
begin  // of TWebsphereMQ.CommitTransaction
  MQCMIT (HConn, @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['beginning transaction',CodReason]);
end;   // of TWebsphereMQ.CommitTransaction

//=============================================================================

procedure TWebsphereMQ.RollbackTransaction;
begin  // of TWebsphereMQ.RollbackTransaction
  MQBACK (HConn, @CodComp, @CodReason);
  if CodComp <> MQCC_OK then
    raise Exception.CreateFmt('Error when %s. Reason code: %d  ',
                             ['beginning transaction',CodReason]);
end;   // of TWebsphereMQ.RollbackTransaction

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of MWebSphereMQ
