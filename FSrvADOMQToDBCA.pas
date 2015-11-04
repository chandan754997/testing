//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : Development for Castorama
// Unit   : FSrvADOMQToDBCA = Form Service for Message Queue to DataBase fof
//          CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSrvADOMQToDBCA.pas,v 1.4 2007/11/02 14:16:44 NicoCV Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FSrvADOMQToDBCA - CVS revision 1.11
// Version      Modified By    Reason
// 1.5          ARB            R2011.2   (Clients en attente, BDFR)
// 1.7          KB (TCS)       R2012.1 - All OPCO - Bug-148, BA Offline
// 1.8          SC (TCS)       R2012.1 - CAFR - Ajout_points_acquis_Carte_Castorama
//=============================================================================

unit FSrvADOMQToDBCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SvcMgr, FSrvADOMQToDB, DFpnADOServiceMQ;

//=============================================================================
// Initialized variables
//=============================================================================

var // Message names
  ViTxtDocumentBO  : string = 'DocumentBO';
  ViTxtSalesTotals : string = 'SalesTotals';
  ViTxtSafeTrans   : string = 'LstSafeTrans';
  ViTxtFiscPayInOut: string = 'FiscalPayInOut';
  //Clients en attente - BDFR  - Start
  ViTxtRecordQueue : string = 'RecordQueue';
  //Clients en attente - BDFR  - End
  // Offline BA - CAFR - TCS(KB) - Begin
  ViTxtCouponStatus : String =  'CouponStatus';
  ViTxtCoupStatHis  : String = 'CoupStatHis';
//  ViTxiPromCouponRepl : String = 'PromCouponRepl';
  // Offline BA - CAFR - TCS(KB) - End
  ViTxtPtsAcquiredCarteCasto : string = 'PtsAcquiredCarteCasto';                //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc)
  const
  CtTxtDebugLogFailed : string = 'Logging of debug messages failed...';

//*****************************************************************************
// Interface of TSrvMQToDBCA
//*****************************************************************************

type
  TSrvMQToDBCA = class(TSrvMQToDB)
    procedure DmdSrvADOServiceMQCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    FlgDebugLogging     : boolean;       // Flag debug logging Y/N
    procedure ProcessMQMessage (PtrMsg : Pointer); override;
    procedure DoOnStart (    Sender  : TService;
                         var Started : Boolean); override;
    procedure DoOnStop  (    Sender  : TService;
                         var Started : Boolean); override;
    function ActivateDebugLogging: boolean; virtual;
  public
    { Public declarations }
    function GetServiceController: TServiceController; override;
  end;  // of TSrvMQToDBCA

var
  SrvMQToDBCA: TSrvMQToDBCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmFile,
  MFpnMSMQ,
  SmUtils,

  DmADODummyCA,
  DFpnADOUtilsCA,

  FXMLADODocumentBOCA,
  FXMLADOPosTransaction,
  FXMLADOPosTransactionCA,
// Is not used anymore  FXMLADOSalesTotalsCA,
  FXMLADOSafeTransCA,
  FXMLADOPosState,
  FXMLADOPosStateCA,
  DFpnADOCA,
  MLogging,
  FXMLADOGeneral;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FSrvADOMQToDBCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FSrvADOMQToDBCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2012/05/08 10:10:13 $';

//*****************************************************************************
// Implementation of not-interfaced routines
//*****************************************************************************

procedure ServiceController (CtrlCode : DWord); stdcall;
begin // of ServiceController
  SrvMQToDBCA.Controller (CtrlCode);
end;  // of ServiceController

//*****************************************************************************
// Implementation of TSrvMQToDBCA
//*****************************************************************************

function TSrvMQToDBCA.GetServiceController: TServiceController;
begin // of TSrvMQToDBCA.GetServiceController
  Result := @ServiceController;
end;  // of TSrvMQToDBCA.GetServiceController

//=============================================================================

procedure TSrvMQToDBCA.ProcessMQMessage (PtrMsg : Pointer);
var
  TxtMsgType       : string;           // Text with message description
  TxtRight         : string;           // Used only for splitstring
  TxtMsgBody       : string;           // The body of the message
begin // of TSrvMQToDBCA.ProcessMQMessage
  inherited;
  if MSMQVersion = 1 then begin
    TxtMsgBody := MSMQ10Message (PtrMsg).Body;
    SplitString (MSMQ10Message (PtrMsg).Label_, ' ', TxtMsgType, TxtRight);
  end
  else begin
    TxtMsgBody := MSMQ20Message (PtrMsg).Body;
    SplitString (MSMQ20Message (PtrMsg).Label_, ' ', TxtMsgType, TxtRight);
  end;

  if AnsiCompareText (TxtMsgType, ViTxtDocumentBO) = 0 then
      XMLADODocumentBOCA.ProcessXML (TxtMsgBody)
//SVE deactivated because the décompte works on the database
//  else if AnsiCompareText (TxtMsgType, ViTxtSalesTotals) = 0 then
//    XMLADOSalesTotalsCA.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, ViTxtSafeTrans) = 0 then
    XMLADOSafeTransCA.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, ViTxtFiscPayInOut) = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody)
  else if AnsiCompareText (TxtMsgType, 'PosAction') = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody)
  //ARB R2011.2 Clients en attente - BDFR  - Start
  else if AnsiCompareText (TxtMsgType,ViTxtRecordQueue) = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody)
  //ARB R2011.2 Clients en attente - BDFR  - End
  //Offline Ba - CAFR - TCS(KB) - Start
   else if AnsiCompareText (TxtMsgType,ViTxtCouponStatus) = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody)
   else if AnsiCompareText (TxtMsgType,ViTxtCoupStatHis) = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody)
//   else if AnsiCompareText (TxtMsgType,ViTxiPromCouponRepl) = 0 then
//    XMLADOGeneral.ProcessXML (TxtMsgBody);
  //Offline Ba - CAFR - TCS(KB) - End
  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc) - start
  else if AnsiCompareText (TxtMsgType,ViTxtPtsAcquiredCarteCasto) = 0 then
    XMLADOGeneral.ProcessXML (TxtMsgBody);
  //TCS Modification R2012.1(CAFR) Ajout_points_acquis_Carte_Castorama (sc) - end
end;  // of TSrvMQToDBCA.ProcessMQMessage

//=============================================================================

procedure TSrvMQToDBCA.DoOnStart (    Sender  : TService;
                                  var Started : Boolean);
begin  // of TSrvMQToDBCA.DoOnStart
  ViSetDBError := [sfdMsgNumRec, sfdMsgExtend, sfdException];
  inherited;
  try

    if Assigned (XMLADOPOSTransaction) then begin
      XMLADOPOSTransaction.Free;
      XMLADOPOSTransaction := nil;
    end;
    XMLADOPOSTransaction := TXMLADOPOSTransactionCA.Create;

    if Assigned (XMLADOPosState) then begin
      XMLADOPosState.Free;
      XMLADOPosState := nil;
    end;
    XMLADOPosState := TXMLADOPosStateCA.Create;

    XMLADODocumentBOCA := TXMLADODocumentBOCA.Create;


// Is not used anymore    XMLADOSalesTotalsCA := TXMLADOSalesTotalsCA.Create;

    XMLADOSafeTransCA := TXMLADOSafeTransCA.Create;

    XMLADOGeneral := TXMLADOGeneral.Create;

  except
    on E: Exception do begin
      E.message := E.message + #10'error in procedure TSrvMQToDBCA.DoOnStart';
      ExceptionHandler (Self, E);
    end;
  end;
end;   // of TSrvMQToDBCA.DoOnStart

//=============================================================================

procedure TSrvMQToDBCA.DoOnStop (    Sender  : TService;
                                 var Started : Boolean);
begin // of TSrvMQToDBCA.DoOnStop
  inherited;
  if Assigned (XMLADODocumentBOCA) then begin
    XMLADODocumentBOCA.Free;
    XMLADODocumentBOCA := nil;
  end;
// Is not used anymore  if Assigned (XMLADOSalesTotalsCA) then begin
// Is not used anymore    XMLADOSalesTotalsCA.Free;
// Is not used anymore    XMLADOSalesTotalsCA := nil;
// Is not used anymore  end;
  if Assigned (XMLADOSafeTransCA) then begin
    XMLADOSafeTransCA.Free;
    XMLADOSafeTransCA := nil;
  end;

   if Assigned (XMLADOGeneral) then begin
    XMLADOGeneral.Free;
    XMLADOGeneral := nil;
  end;
end;  // of TSrvMQToDBCA.DoOnStop

//=============================================================================

procedure TSrvMQToDBCA.DmdSrvADOServiceMQCreate(Sender: TObject);
begin  // TSrvMQToDBCA.DmdSrvADOServiceMQCreate
{pdw private queuing - set this flag to true if you want to turn on private queuing}
  inherited;
end;   // TSrvMQToDBCA.DmdSrvADOServiceMQCreate

//=============================================================================


//=============================================================================

function TSrvMQToDBCA.ActivateDebugLogging: boolean;
begin // of TSrvMQToDBCA.ActivateDebugLogging
  try
    DmdFpnADOUtilsCA.QueryInfo ('SELECT ValParam FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('SrvMQPosTransDebug', ''''));
    If DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('ValParam').AsInteger = 1 then
      Result := True
    else
      Result := False;
  finally
    DmdFpnADOUtilsCA.ClearQryInfo;
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;  // of TSrvMQToDBCA.ActivateDebugLogging

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FSrvADOMQToDBCA
