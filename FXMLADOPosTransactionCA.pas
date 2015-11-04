//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint for castorama
// Unit   : FXMLADOPosTransactionCA : processes XML-string to DB for
//                                    PosTransaction for CAstorama
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosTransactionCA.pas,v 1.29 2010/07/16 12:21:23 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOPosTransactionCA - CVS revision 1.25
//=============================================================================

unit FXMLADOPosTransactionCA;

interface

uses
  Classes,
  MSXML_TLB,
  Db,
  FXMLADOPosTransaction,
  DmADODummyCA,
  Messages,
  Dialogs,
  ADODB,
  DFpnADOCA,
  windows;

type
  TXMLADOPosTransactionCA = class (TXMLADOPosTransaction)
  private
    FFlgNoRepl : Boolean;
    FFlgMatGroup: Boolean;
  protected
    StrLstGAPosTrans    : TSTringList; // Stringlist for fields to store in
                                       // GlobalAcomptes coming from
                                       // PosTransaction
    StrLstGAPosTransDetail: TSTringList; // Stringlist for fields to store in
                                         // GlobalAcomptes coming from
                                         // PosTransDetail
    StrLstCCPosTrans    : TSTringList; // Stringlist for fields to store in
                                       // GlobalCredCoup coming from
                                       // PosTransaction
    StrLstCCPosTransDetail: TSTringList; // Stringlist for fields to store in
                                         // GlobalCredCoup coming from
                                         // PosTransDetail
    StrLstGCPosTrans    : TSTringList; // Stringlist for fields to store in
                                       // CreditCoupon coming from
                                       // PosTransaction
    StrLstGCPosTransDetail: TStringList; // Stringlist for fields to store in
                                         // CreditCoupon coming from
                                         // PosTransDetail
    StrLstASPosTransDetail: TSTringList; // Stringlist for fields to update
                                         // ArtStock with coming from
                                         // PosTransDetail
    StrLstTransRepl     : TStringList; // Stringlist for fields for replication
    StrLstTransReplKeys : TStringList; // Stringlist for fields for replication
    StrLstCommPOSTrans  : TStringList; // Stringlist for fields for interface comm.
    FlgFirstPass        : Boolean;     // So that the insert of postransaction
                                       // can only happen once
    FlgRetakeInvoice    : Boolean;     // if the ticket is a retake from a
                                       // ticket
    FlgTickAnnul        : Boolean;     // If ticket is cancelled
    ValCodReturn        : string;      // Value of codreturn
    FlgTraining         : Boolean;     // if ticket is training
    FlgAnnulLine        : Boolean;     // annulation of line (used for avoirs)
    FlgBankTransferInfo : Boolean;     // bank transfer with informative lines
    FlgGiftCoupon       : Boolean;     // Gift coupon
    ValCredCoup         : Real;        // Value of gift coupon
    TxtCodPos           : string;      // Checkout type
    FlgReturnTicket     : Boolean;     // Return ticket
    FlgCoupIntOffline   : Boolean;     // Offline payment with internal coupon
    NumCoupon           : string;      // Number of used coupon

    QryReturnTicket     : TADOQuery;
    QryInfoOrigTicket   : TADOQuery;
    QryUpdReturnTicket  : TADOQuery;

    // Set of codtypes service article (important for return)
    SetCodTypesServArt  : set of Byte;

    //POSTransaction
    procedure FillSetCodTypesServArt (TxtXMLVal : string); virtual;
    procedure ProcessPosTransaction (NdePosTrans : IXMLDOMNode;
                                     CodActKind  : Integer ); override;
    procedure ProcessPosTransFld (NdeXMLFld    : IXMLDOMNode;
                                  StrLstFields : TStringList); override;
    procedure ProcessDetailTablesFromXML (NdeXML     : IXMLDOMNode;
                                          CodActKind : Integer ); override;

    //POSTransDetail
    procedure ProcessPosTransDetail (NdePosTransDetail : IXMLDOMNode;
                                     CodActKind        : Integer ); override;
    procedure ProcessPosTransDetailFld (NdeXMLFld    : IXMLDOMNode;
                                        StrLstFields : TStringList); override;
    procedure ProcessBankTransfer (IdtPosTrans   : Integer;
                                   IdtCheckout   : Integer;
                                   CodTrans      : Integer;
                                   DatTransBegin : TDateTime);
    procedure ProcessGiftCoupon;

    procedure ProcessCoupIntOffline(IdtPosTrans   : Integer;
                                    IdtCheckout   : Integer;
                                    CodTrans      : Integer;
                                    DatTransBegin : TDateTime);

    procedure CheckChangeQtyReturned (    IdtPosTransCurr   : Integer;
                                          IdtCheckoutCurr   : Integer;
                                          CodTransCurr      : Integer;
                                          DatTransBeginCurr : TDateTime;
                                          NumLineStartCurr  : Integer;
                                          NumLineEndCurr    : Integer;
                                          IdtPosTransOrig   : Integer;
                                          IdtCheckoutOrig   : Integer;
                                          CodTransOrig      : Integer;
                                          DatTransBeginOrig : TDateTime;
                                          IdtCVenteOrig     : string;
                                          NumPlu            : string;
                                          CodTypeArt        : Integer;
                                          FlgTraining       : Integer;
                                      var QtyReturn         : Double); virtual;
    procedure ProcessReturnTicket (IdtPosTrans   : Integer;
                                   IdtCheckout   : Integer;
                                   CodTrans      : Integer;
                                   DatTransBegin : TDateTime;
                                   FlgCancel     : Boolean);
    procedure ProcessCancelTicket (IdtPosTrans   : Integer;
                                   IdtCheckout   : Integer;
                                   CodTrans      : Integer;
                                   DatTransBegin : TDateTime;
                                   FlgTraining   : Boolean);
    procedure UpdatePosTransDetQtyReturned
                                  (IdtPosTrans   : String;
                                   IdtCheckout   : String;
                                   CodTrans      : String;
                                   DatTransBegin : String;
                                   IdtCVente     : String;
                                   NumPlu        : String;
                                   QtyReturn     : Double;
                                   FlgTraining   : Integer);
    procedure UpdatePosTransDetCancelReturn
                                  (IdtPosTrans   : String;
                                   IdtCheckout   : String;
                                   CodTrans      : String;
                                   DatTransBegin : String;
                                   IdtCVente     : String;
                                   NumPlu        : String;
                                   QtyReturn     : Double;
                                   FlgTraining   : Integer);

    //POSTransCust
    procedure ProcessPosTransCust (NdePosTransCust : IXMLDOMNode;
                                   CodActKind      : Integer ); override;
    procedure ProcessPosTransCustFld (NdeXMLFld    : IXMLDOMNode;
                                      StrLstFields : TStringList); override;

    //POSTransInvoice
    procedure ProcessPosTransInvoice (NdePosTransInvoice : IXMLDOMNode;
                                      CodActKind         : Integer ); override;
    procedure ProcessPosTransInvFld (NdeXMLFld    : IXMLDOMNode;
                                     StrLstFields : TStringList); override;

    function ConvertDateTimeStringForCasto (TxtDatISO : string) : string;
                                                                       virtual;

    procedure ChangeQtyLine (IdtArticle : string;
                             StrLstLine : TStringList); virtual;

    procedure ChangeQtyLineDepositDocBo (IdtArticle : string;
                                         StrLstLine: TStringList); virtual;

    procedure AddFieldToList (NdeXMLFld    : IXMLDOMNode;
                              TxtFieldName : string;
                              StrLstFields : TStringList;
                              TxtTableName : string;
                              FieldValue   : string); reintroduce;
                                                      overload; virtual;
    //PosTransDetAddOn
    procedure ProcessPosTransDetAddOn (NdePosTransDetAddOn : IXMLDOMNode;
                                          CodActKind         : Integer);
                                                                      virtual;
    procedure ProcessPosTransDetAddOnFld (NdeXMLFld    : IXMLDOMNode;
                                           StrLstFields : TStringList);
                                                                      virtual;

  public
    constructor Create; override;
    destructor Destroy; override;
    property FlgNoRepl : Boolean read FFlgNoRepl write FFlgNoRepl;
    property FlgMatGroup : Boolean read FFlgMatGroup write FFlgMatGroup;
  end;  // of TXMLADOPosTransactionCA

implementation

uses
  SysUtils,

  StFin,

  SfDialog,
  Smutils,
  MFpnDBUtil_ADO,
  FXMLADOGeneral,
  DmADODummy,
  StDateSt,
  StDate,
  DFpnADOUtilsCA,
  DFpnADOBODocumentCA,
  DFpnADOPOSTransactionCA,
  mlogging, DFpnADOPosTransAction;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOPosTransactionCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosTransactionCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.29 $';
  CtTxtSrcDate    = '$Date: 2010/07/16 12:21:23 $';

//=============================================================================

constructor TXMLADOPosTransactionCA.Create;
begin  // of TXMLADOPosTransactionCA.Create
  StrLstTransRepl := TStringList.Create;
  StrLstTransReplKeys := TStringList.Create;
  StrLstCommPOSTrans := TStringList.Create;
  StrLstGAPosTrans := TStringList.Create;
  StrLstGAPosTransDetail := TStringList.Create;
  StrLstCCPosTrans := TStringList.Create;
  StrLstCCPosTransDetail := TStringList.Create;
  StrLstGCPosTrans := TStringList.Create;
  StrLstGCPosTransDetail := TStringList.Create;
  StrLstASPosTransDetail := TStringList.Create;

  SetCodTypesServArt := [];

  QryReturnTicket := TADOQuery.Create (nil);
  QryReturnTicket.Connection := DmdFpnADOCA.ADOConFlexpoint;
  QryReturnTicket.CursorLocation := clUseClient;
  QryReturnTicket.CursorType := ctKeyset;
  QryReturnTicket.LockType := ltReadOnly;
  QryReturnTicket.MarshalOptions := moMarshalModifiedOnly;

  QryUpdReturnTicket := TADOQuery.Create (nil);
  QryUpdReturnTicket.Connection := DmdFpnADOCA.ADOConFlexpoint;
  QryUpdReturnTicket.CursorLocation := clUseClient;
  QryUpdReturnTicket.CursorType := ctKeyset;
  QryUpdReturnTicket.LockType := ltReadOnly;
  QryUpdReturnTicket.MarshalOptions := moMarshalModifiedOnly;

  QryInfoOrigTicket := TADOQuery.Create (nil);
  QryInfoOrigTicket.Connection := DmdFpnADOCA.ADOConFlexpoint;
  QryInfoOrigTicket.CursorLocation := clUseClient;
  QryInfoOrigTicket.CursorType := ctKeyset;
  QryInfoOrigTicket.LockType := ltReadOnly;
  QryInfoOrigTicket.MarshalOptions := moMarshalModifiedOnly;

  try
    DmdFpnADOUtilsCA.QueryInfo ('SELECT ValParam FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('SrvMQPosTransNoRepl', ''''));
    If DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('ValParam').AsInteger = 1 then
      FlgNoRepl := True
    else
      FlgNoRepl := False;
  finally
    DmdFpnADOUtilsCA.ClearQryInfo;
    DmdFpnADOUtilsCA.CloseInfo;
  end;

  try
    DmdFpnADOUtilsCA.QueryInfo ('SELECT ValParam FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('SrvMQPosTransMatGr', ''''));
    If DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('ValParam').AsInteger = 1 then
      FlgMatGroup := True
    else
      FlgMatGroup := False;
  finally
    DmdFpnADOUtilsCA.ClearQryInfo;
    DmdFpnADOUtilsCA.CloseInfo;
  end;

  inherited;
end;   // of TXMLADOPosTransactionCA.Create

//=============================================================================

destructor TXMLADOPosTransactionCA.Destroy;
begin  // of TXMLADOPosTransactionCA.Destroy
  inherited;
  StrLstTransRepl.Free;
  StrLstTransReplKeys.Free;
  StrLstCommPOSTrans.Free;
  StrLstGAPosTrans.Free;
  StrLstGAPosTransDetail.Free;
  StrLstCCPosTrans.Free;
  StrLstCCPosTransDetail.Free;
  StrLstGCPosTrans.Free;
  StrLstGCPosTransDetail.Free;
  StrLstASPosTransDetail.Free;

  if Assigned (QryReturnTicket) then
    QryReturnTicket.Free;

  if Assigned (QryUpdReturnTicket) then
    QryUpdReturnTicket.Free;

  if Assigned (QryInfoOrigTicket) then
    QryInfoOrigTicket.Free;
end;   // of TXMLADOPosTransactionCA.Destroy

//=============================================================================

procedure TXMLADOPosTransactionCA.FillSetCodTypesServArt (TxtXMLVal : string);
var
  TxtCod           : string;           // code to add
  TxtRest          : string;           // rest of the string
begin  // of TXMLADOPosTransactionCA.FillSetCodTypesServArt
  if TxtXMLVal = '' then
    Exit;

  SetCodTypesServArt := [];
  TxtRest := TxtXMLVal;
  repeat
    SplitString (TxtRest, ';', TxtCod, TxtRest);
    if TxtCod <> '' then
      SetCodTypesServArt := SetCodTypesServArt + [StrToIntDef (TxtCod, 0)];
  until TxtRest = '';
end;   // of TXMLADOPosTransactionCA.FillSetCodTypesServArt

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransaction
                                                     (NdePosTrans : IXMLDOMNode;
                                                      CodActKind  : Integer);
var
  TxtDate          : string;           // Date part of a date-time value
  TxtTime          : string;           // Time part of a date-time value
  IdtPosTransaction: Integer;
  CodTrans         : Integer;
  IdtCheckout      : Integer;
  DatTransBegin    : TDateTime;
  CntItem          : Integer;          // Index for loop
  StrLstFields     : TStringList;      // List with names and values of fields
begin  // of TXMLADOPosTransactionCA.ProcessPosTransaction
  FlgFirstPass := True;
  FlgRetakeInvoice := False;
  FlgTickAnnul := False;
  ValCodReturn := '';
  FlgTraining := False;
  FlgBankTransferInfo := False;
  FlgGiftCoupon := False;
  FlgReturnTicket := False;
  FlgCoupIntOffline := False;
  StrLstTransRepl.Clear;
  StrLstTransReplKeys.Clear;
  StrLstCommPOSTrans.Clear;
  StrLstGAPosTrans.Clear;
  StrLstCCPosTrans.Clear;
  StrLstGCPosTrans.Clear;
  StrLstFields := TStringList.Create;
  StrLstkeys.Clear;
  try
    for CntItem := 0 to Pred (NdePostrans.childNodes.length) do
      ProcessPosTransFld (NdePostrans.childNodes[CntItem], StrLstFields);
    StrLstFields.Add ('DatLoaded=' +
                      AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                                 ViTxtDBHouFormat, Now), ''''));
    if CodActKind = CtCodActKindInsert then begin
      StrLstFields.AddStrings (StrLstKeys);
      DmdADODummy.InsertPOSTransaction (StrLstFields);
    end
    else if CodActKind = CtCodActKindUpdate then
      DmdADODummy.UpdatePOSTransaction (StrLstFields, StrLstkeys)
    else
      raise EInvalidOperation.Create ('Invalid Action for table ' +
                                      AnsiQuotedStr ('PosTransaction', ''''));

    for CntItem := 0 to Pred (NdePostrans.childNodes.length) do
      ProcessDetailTablesFromXML (Ndepostrans.ChildNodes[CntItem], CodActKind);
  finally
    StrLstFields.Free;
  end;
  if CodActKind = CtCodActKindInsert then begin
    if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
       ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
       and not FlgTraining then begin
      if not FlgNoRepl then
        DmdADODummyCA.InsertPosTransactionRepl (StrLstTransReplKeys,
                                                CtCodTypeTRFPOSTransEnd);
      DmdADODummyCA.InsertCommPOSTrans(StrLstCommPOSTrans);
    end;
    if not FlgTickAnnul and not FlgRetakeInvoice and not FlgTraining then begin
      TxtDate := copy (StrLstTransReplKeys.Values ['DatTransBegin'],2,8);
      TxtTime := copy (StrLstTransReplKeys.Values ['DatTransBegin'],10,6);

      DmdFpnADOBODocumentCA.FlgLogging := True;
      DmdFpnADOBODocumentCA.LinkTicketToBODoc (
        StrToInt (StrLstTransReplKeys.Values ['IdtPosTransaction']),
        StrToInt (StrLstTransReplKeys.Values ['IdtCheckout']),
        StrLstTransReplKeys.Values ['IdtOperator'],
        StrToInt (StrLstTransReplKeys.Values ['CodTrans']),
        StDateToDateTime (DateStringToStDate ('YYYYMMDD', TxtDate, 50)) +
        StTimeToDateTime (TimeStringToStTime ('HHMMSS', TxtTime)),-1);
      if not FlgBankTransferInfo then
        LogDebugMessage('FlgBankTransfer is false')
      else
        LogDebugMessage('FlgBankTransfer is true');


      if FlgBankTransferInfo then begin
        ProcessBankTransfer(
          StrToInt (StrLstTransReplKeys.Values ['IdtPosTransaction']),
          StrToInt (StrLstTransReplKeys.Values ['IdtCheckout']),
          StrToInt (StrLstTransReplKeys.Values ['CodTrans']),
          StDateToDateTime (DateStringToStDate ('YYYYMMDD', TxtDate, 50)) +
          StTimeToDateTime (TimeStringToStTime ('HHMMSS', TxtTime)))
      end;
      if FlgCoupIntOffline then begin
        ProcessCoupIntOffline(
          StrToInt (StrLstTransReplKeys.Values ['IdtPosTransaction']),
          StrToInt (StrLstTransReplKeys.Values ['IdtCheckout']),
          StrToInt (StrLstTransReplKeys.Values ['CodTrans']),
          StDateToDateTime (DateStringToStDate ('YYYYMMDD', TxtDate, 50)) +
          StTimeToDateTime (TimeStringToStTime ('HHMMSS', TxtTime)));
      end;
    end;
    if not FlgTickAnnul and not FlgRetakeInvoice then
      DmdFpnADOUtilsCA.GetNextCounter ('POSTransactionRepl','NumTransSend');
  end;
  //if returnticket
  if FlgReturnTicket and not FlgTickAnnul then begin
    TxtDate := copy (StrLstTransReplKeys.Values ['DatTransBegin'],2,8);
    TxtTime := copy (StrLstTransReplKeys.Values ['DatTransBegin'],10,6);
    ProcessReturnTicket (
          StrToInt (StrLstTransReplKeys.Values ['IdtPosTransaction']),
          StrToInt (StrLstTransReplKeys.Values ['IdtCheckout']),
          StrToInt (StrLstTransReplKeys.Values ['CodTrans']),
          StDateToDateTime (DateStringToStDate ('YYYYMMDD', TxtDate, 50)) +
          StTimeToDateTime (TimeStringToStTime ('HHMMSS', TxtTime)),
          False);
  end;
  LogDebugMessage ('ValCodReturn = ' + ValCodReturn);
  if CodActKind = CtCodActKindUpdate then
    LogDebugMessage ('CodActKind = CtCodActKindUpdate');
  if (ValCodReturn = IntToStr(CtCodPtrCancelFinReceipt))
     and (CodActKind = CtCodActKindUpdate)  then begin
    //Is it a cancellation of a returnticket?
    //Check if there are postransdetaddon's linked to the original ticket
    LogDebugMessage('DatTransBegin: ' + StrLstKeys.Values ['DatTransBegin']);
    TxtDate := copy (StrLstKeys.Values ['DatTransBegin'],2,10);
    TxtTime := copy (StrLstKeys.Values ['DatTransBegin'],13,8);
    LogDebugMessage('Date: ' + TxtDate + ' time: ' + txttime);

    IdtPosTransaction := StrToInt(StrLstkeys.Values ['IdtPosTransaction']);
    IdtCheckout := StrToInt(StrLstKeys.Values ['IdtCheckout']);
    CodTrans := StrToInt(StrLstKeys.Values ['CodTrans']);
    DatTransBegin :=
          StDateToDateTime (DateStringToStDate (ViTxtDBDatFormat, TxtDate, 50)) +
          StTimeToDateTime (TimeStringToStTime (ViTxtDBHouFormat, TxtTime));
    ProcessCancelTicket (IdtPosTransaction, IdtCheckout,
                         CodTrans, DatTransbegin, FlgTraining);
  end;


end;   // of TXMLADOPosTransactionCA.ProcessPosTransaction

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
var
  TxtValue         : string;           // Date time as string
  TxtFieldName     : string;           // fieldname
begin  // of TXMLADOPosTransactionCA.ProcessPosTransFld
  inherited;
  TxtFieldName := NdeXMLFld.nodeName;
  if (CompareText (Copy (NdeXMLFld.nodeName,1,3), 'Dat') = 0) then
    TxtValue := ConvertDateTimeStringForCasto (NdeXMLFld.Text)
  else
    TxtValue := NdeXMLFld.Text;

  if (CompareText (TxtFieldName, 'IdtPosTransaction') = 0)
     or (CompareText (TxtFieldName, 'IdtCheckout') = 0)
     or (CompareText (TxtFieldName, 'CodTrans') = 0)
     or (CompareText (TxtFieldName, 'DatTransBegin') = 0) then begin
    AddFieldToList (NdeXMLFld, StrLstTransReplKeys, 'PosTransactionRepl',
                    TxtValue);
    AddFieldToList (NdeXMLFld, StrLstCommPOSTrans, 'CommPOSTrans',
                    NdeXMLFld.Text);
    if CompareText (TxtFieldName, 'IdtCheckout') = 0 then begin
      //Save CodPOS from POS
      txtCodPos := DmdADODummyCA.GetInfoCodPos(NdeXMLFld.Text, 'CodPos');
      AddFieldToList ('TypeC', StrLstTransRepl, 'PosTransactionRepl',txtCodPos);
    end;
  end
  else if (CompareText (TxtFieldName, 'IdtOperator') = 0) then
    AddFieldToList (NdeXMLFld, StrLstTransReplKeys, 'PosTransactionRepl',
                    TxtValue)
  else begin
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    TxtValue);
  end;

  if (CompareText (TxtFieldName, 'IdtPosTransaction') = 0) or
     (CompareText (TxtFieldName, 'IdtCheckOut') = 0) or
     (CompareText (TxtFieldName, 'CodTrans') = 0) or
     (CompareText (TxtFieldName, 'DatTransBegin') = 0) or
     (CompareText (TxtFieldName, 'IdtOperator') = 0) then begin
    AddFieldToList (NdeXMLFld, StrLstGAPosTrans, 'GlobalAcomptes', NdeXMLFld.Text);
    AddFieldToList (NdeXMLFld, StrLstCCPosTrans, 'GlobalCredCoup', NdeXMLFld.Text);
  end;

  if AnsiSameText (TxtFieldName, 'CodTypesServiceArt') then
    FillSetCodTypesServArt(NdeXMLFld.Text);
end;   // of TXMLADOPosTransactionCA.ProcessPosTransFld

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessDetailTablesFromXML (
                                                       NdeXML     : IXMLDOMNode;
                                                       CodActKind : Integer);
begin  // of TXMLADOPosTransactionCA.ProcessDetailTablesFromXML
  if FlgFirstPass then begin
    if CodActKind = CtCodActKindInsert then begin
      FlgRetakeInvoice := DmdFpnADOUtilsCA.QueryInfo ('SELECT * ' +
                             'FROM postransaction (NOLOCK)' +
                             'WHERE codreturn in (11,12) ' +
                             '  AND IdtPostransResume =  ' +
                               StrLstKeys.Values ['IdtPosTransaction']+
                             '  AND IdtCheckoutResume = ' +
                               StrLstKeys.Values ['IdtCheckout']+
                             '  AND DatTransBeginResume = ' +
                               StrLstKeys.Values ['DatTransBegin']);
      DmdFpnADOUtilsCA.CloseInfo;
      if (StrLstTransRepl.Values ['CodReturn'] <> '') and
         (StrLstTransRepl.Values ['CodReturn'] <> '0') then begin
        FlgTickAnnul := true;
        ValCodReturn := StrLstTransRepl.Values ['CodReturn'];
      end;
      if (StrLstTransRepl.Values ['FlgTraining'] <> '') and
         (StrLstTransRepl.Values ['FlgTraining'] <> '0') then
        FlgTraining := true;
      if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
      ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
      and not FlgTraining then begin
        if not FlgNoRepl then
          DmdADODummyCA.InsertPosTransactionRepl (StrLstTransReplKeys,
                                                  CtCodTypeTRFPOSTransBegin);
       end;
      StrLstTransRepl.AddStrings (StrLstTransReplKeys);
      if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
      ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
      and not FlgTraining then begin
        if not FlgNoRepl then
          DmdADODummyCA.InsertPosTransactionRepl (StrLstTransRepl,
                                                  CtCodTypeTRFPOSTransHeader);
      end;
    end;
    if (CodActKind = CtCodActKindUpdate) then begin
      if (StrLstTransRepl.Values ['CodReturn'] <> '') and
         (StrLstTransRepl.Values ['CodReturn'] <> '0') then begin
        ValCodReturn := StrLstTransRepl.Values ['CodReturn'];
      end;
    end;
    FlgFirstPass := False;
  end;
  if AnsiCompareText (NdeXML.nodeName, 'POSTransDetAddOn') = 0 then begin
    ProcessPosTransDetAddOn (NdeXML, CodActKind);
  end;
  inherited;
end;   // of TXMLADOPosTransactionCA.ProcessDetailTablesFromXML

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransDetail (
                                                NdePosTransDetail : IXMLDOMNode;
                                                CodActKind        : Integer);
var
  QtyReg           : Real;             // To convert
  QtyLine          : Real;             // To convert
  NumConvert       : Integer;          // Error number when converting
  StrVal           : string;           // string value of float
  CodSalesUnit     : Integer;          // CodSalesUnit of article
  CntItem          : Integer;          // Index for loop
  StrLstFields     : TStringList;      // List for fields and values
  CntGiftCoupon    : Integer;
begin  // of TXMLADOPosTransactionCA.ProcessPosTransDetail
  StrLstTransRepl.Clear;
  StrLstGAPosTransDetail.Clear;
  StrLstCCPosTransDetail.Clear;
  StrLstGCPosTransDetail.Clear;
  StrLstASPosTransDetail.Clear;
  FlgAnnulLine  := False;
  FlgGiftCoupon := False;
  ValCredCoup   := 0;
  CodSalesUnit  := 0;
  StrLstFields  := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransDetail.childNodes.length) do
      ProcessPosTransDetailFld (NdePosTransDetail.childNodes[CntItem],
                                    StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummyCA.InsertPOSTransDetail (StrLstFields,FlgTickAnnul);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransDetail', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
  if CodActKind = CtCodActKindInsert then begin
    if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
       ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
       and not FlgTraining then begin
      StrLstTransRepl.AddStrings (StrLstTransReplKeys);
      if not FlgNoRepl then
        DmdADODummyCA.InsertPosTransactionRepl (StrLstTransRepl,
                                                CtCodTypeTRFPosTransDetail);
      if StrToIntDef (StrLstGAPosTransDetail.Values['CodType'], 0) in
         [CtCodTypPayAdvance, CtCodTypChangeAdvance,
          CtCodTypTakeBackAdvance] then begin
        StrLstGAPosTransDetail.AddStrings (StrLstGAPosTrans);
        DmdADODummyCA.InsertGlobal (StrLstGAPosTransDetail, 'GlobalAcomptes');
      end;
      if (StrLstCCPosTransDetail.Values ['CodType'] <> '') and
         (StrToIntDef (StrLstCCPosTransDetail.Values['CodType'], 0) in
         [CtCodTypRegistered, CtCodTypPayedBack]) and (not FlgAnnulLine)
         then begin
        StrLstCCPosTransDetail.AddStrings (StrLstCCPosTrans);
        if Length(StrLstCCPosTransDetail.Values ['IdtCredCoup']) <= 0  then begin
          CntGiftCoupon := DmdADODummyCA.IntPluNum;
          LogDebugMessage('Toevoegen van CntGiftCoupon aan lijst : ' + IntToStr(CntGiftCoupon));
          StrLstCCPosTransDetail.Values ['IdtCredCoup'] := IntToStr(CntGiftCoupon);
          StrLstGCPosTransDetail.Values ['IdtCredCoup'] := IntToStr(CntGiftCoupon);
          LogDebugMessage('Toevoegen van CntGiftCoupon aan StrLstGCPosTransDetail : ' +
                          StrLstGCPosTransDetail.Values ['IdtCredCoup']);
          end;
        DmdADODummyCA.InsertGlobal (StrLstCCPosTransDetail, 'GlobalCredCoup');
        if StrToIntDef (StrLstCCPosTransDetail.Values['CodType'], 0) =
           CtCodTypPayedBack then begin
          DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text := 'UPDATE CreditCoupon' +
                                               #10'SET CodState = 1, ' +
                                               #10'    DatSettle = ' +
                                               AnsiQuotedStr(FormatDateTime(
                                               ViTxtDBDatFormat, Now), '''') +
                                               #10'WHERE IdtCredCoup = ' +
                                               StrLstCCPosTransDetail.
                                               Values['IdtCredCoup'];
          DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
        end;
      end;
      if (StrLstASPosTransDetail.Values ['NumPLU'] <> '') and
      (StrToIntDef(StrLstASPosTransDetail.Values ['QtyReg'],0) <> 0) then begin
        Val (StrLstASPosTransDetail.Values ['QtyReg'], QtyReg, NumConvert);
        Val (StrLstASPosTransDetail.Values ['QtyLine'], QtyLine, NumConvert);
        try
          if DmdFpnADOUtilsCA.QueryInfo
               ('SELECT Article.CodSalesUnit' +
                #10'FROM Article (NOLOCK)' +
                #10'INNER JOIN ArtPLU ON' +
                #10' Article.IdtArticle = ArtPLU.IdtArticle' +
                #10'WHERE ArtPLU.NumPLU = ' +
                              StrLstASPosTransDetail.Values ['NumPLU']) then
            CodSalesUnit :=
              DmdFpnADOUtilsCA.ADOQryInfo.FieldByName ('CodSalesUnit').AsInteger;
        finally
          DmdFpnADOUtilsCA.CloseInfo;
        end;
        if CodSalesUnit > 0 then
          Str(QtyReg * QtyLine * 100, StrVal)
        else
          Str(QtyReg * 100, StrVal);
        DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text := 'UPDATE ArtStock' +
                                             #10'SET QtySale = QtySale + (' +
                                             #10'CAST(' + StrVal + ' AS DEC' +
                                             #10'(13,4))/100)' +
                                             #10'WHERE IdtArticle = ' +
                                             StrLstASPosTransDetail.Values ['NumPLU'];
        DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
      end;
      if FlgGiftCoupon then
        ProcessGiftCoupon;
    end;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessPosTransDetail

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransDetailFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
var
  TxtValue         : string;           // datetime to string
  TxtFieldName     : string;           // fieldname
  TxtFieldValue    : string;           // fieldvalue
  ValAmount        : Real;             // To convert
  NumConvert       : Integer;          // Error number when converting
  txtNumGTD        : string;
  txtISOCountry    : string;
  txtIdtClassification : string;
  CntItem          : Integer;          // Index to loop items
  FlgPLU           : boolean;
  NumItem          : integer;
begin  // of TXMLADOPosTransactionCA.ProcessPosTransDetailFld
  if AnsiCompareText (NdeXMLFld.nodeName, 'IdtClassification') = 0 then begin
    if not FlgMatGroup then
      AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetail',
                      DmdADODummy.GetIdtClassification (
                                  StrToInt (NdeXMLFld.text)))
    else begin
      FlgPlu := False;
      NumItem := -1;
      for CntItem := 0 to Pred (StrLstFields.Count) do begin
        SplitString(StrLstFields[CntItem], '=', TxtFieldName, TxtFieldValue);
        if AnsiCompareText (TxtFieldName, 'IdtClassification') = 0 then begin
          FlgPlu := True;
          if txtFieldValue = QuotedStr('') then begin
            NumItem := CntItem;
            FlgPLU := False;
          end;
        end;
      end;
      if NumItem > -1 then
        StrLstFields.Delete(NumItem);
      if not FlgPLU then
        AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetail',
                        DmdADODummy.GetIdtClassification (
                                    StrToInt (NdeXMLFld.text)))
    end;
  end
  else begin
    AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetail', NdeXMLFld.Text);
    if AnsiCompareText (NdeXMLFld.nodeName, 'NumPLU') = 0 then begin
      StrLstFields.Add ('IdtArticle=' +
             AnsiQuotedStr (DmdADODummy.GetIdtArticle (NdeXMLFld.Text), ''''));
      if FlgMatGroup then begin
        txtIdtClassification := DmdADODummyCA.GetInfoArtAssort(
                                       DmdADODummy.GetIdtArticle (NdeXMLFld.Text),
                                       'IdtClassification');
        StrLstFields.Add ('IdtClassification=' +
                          AnsiQuotedStr (txtIdtClassification, ''''));
      end;
    end;
  end;
  TxtFieldName := NdeXMLFld.nodeName;
  if (CompareText (Copy (TxtFieldName, 1, 3), 'Dat') = 0) then
    TxtValue := ConvertDateTimeStringForCasto (NdeXMLFld.Text)
  else
    TxtValue := NdeXMLFld.Text;

  if (CompareText (Copy (TxtFieldName, 1, 3), 'Dat') = 0) then
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    TxtValue)
  else if AnsiCompareText (TxtFieldName, 'IdtClassification') = 0 then begin
    if not FlgMatGroup then
      AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransDetail',
                      DmdADODummy.GetIdtClassification (StrToInt (TxtValue)));
  end
  else if AnsiCompareText (TxtFieldName, 'NumPlu') = 0 then begin
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl', TxtValue);
    //Save IdtClassification for material group B&Q China
    if FlgMatGroup then
      AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransDetail',
                      DmdADODummyCA.GetInfoArtAssort(
                                     DmdADODummy.GetIdtArticle (NdeXMLFld.Text),
                                     'IdtClassification'));
    //Save NumGTD from article
    txtNumGTD := DmdADODummyCA.GetInfoArticle(DmdADODummy.GetIdtArticle (NdeXMLFld.Text),
                                              'NumGTD');
    StrLstFields.Add ('NumGTD=' + AnsiQuotedStr (txtNumGTD, ''''));
    AddFieldToList ('NumGTD', StrLstTransRepl, 'PosTransactionRepl', txtNumGTD);
    //Save txtISOCountry from article
    txtISOCountry := DmdADODummyCA.GetInfoArticle(
                    DmdADODummy.GetIdtArticle (NdeXMLFld.Text),'txtISOCountry');
    StrLstFields.Add ('TxtISOCountry=' + AnsiQuotedStr (txtISOCountry, ''''));
    AddFieldToList ('TxtISOCountry', StrLstTransRepl, 'PosTransactionRepl',
                    txtISOCountry);
    ChangeQtyLine (StrLstFields.Values['IdtArticle'], StrLstTransRepl);

    AddFieldToList (NdeXMLFld, StrLstASPosTransDetail, 'PosTransDetail',
                    DmdADODummy.GetIdtArticle (NdeXMLFld.Text));

    AddFieldToList (NdeXMLFld, 'BarCode', StrLstGCPosTransDetail, 'CreditCoupon'
                    ,NdeXMLFld.Text);
  end
  else if (CompareText (TxtFieldName, 'NumLineReg') = 0) and
          (CompareText (TxtCodPos, '') <> 0) then begin
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl', TxtValue);// Bugfix 27058
    AddFieldToList ('TypeC', StrLstTransRepl, 'PosTransactionRepl', TxtCodPos);
  end
  else if AnsiCompareText (TxtFieldName, 'CodType') = 0 then begin
    if StrToInt(TxtValue) = CtCodPdtAdminCoupIntOffline then
      AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl', IntToStr(CtCodPdtAdmin))
    else
      AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl', TxtValue);
  end
  else
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl', TxtValue);
  // data needed to update ArtStock
  if AnsiCompareText (TxtFieldName, 'QtyReg') = 0 then

    AddFieldToList (NdeXMLFld, StrLstASPosTransDetail, 'PosTransDetail',
                    TxtValue);
  if AnsiCompareText (TxtFieldName, 'QtyLine') = 0 then begin
    Val (TxtValue, ValAmount, NumConvert);
    TxtValue := FormatFloat('0.0000', ValAmount);
    AddFieldToList (NdeXMLFld, StrLstASPosTransDetail, 'PosTransDetail',
                    TxtValue);
    if StrToInt(strLstFields.Values['CodType']) = CtCodPdtCommentArtInfoCustOrder then
      ChangeQtyLineDepositDocBo(StrLstFields.Values['IdtArticle'], StrLstFields);
  end;
  //data needed for record GlobalAcomptes
  if (AnsiCompareText (TxtFieldName, 'IdtCVente') = 0) or
     (AnsiCompareText (TxtFieldName, 'CodTypeVente') = 0) then begin
    AddFieldToList (NdeXMLFld, StrLstGAPosTransDetail, 'GlobalAcomptes',
                    TxtValue);
  end
  else if (CompareText (TxtFieldName, 'IdtCredCoup') = 0) then begin
    AddFieldToList (NdeXMLFld, StrLstCCPosTransDetail, 'GlobalCredCoup',
                    TxtValue);
  end
  else if (CompareText (TxtFieldName, 'CodAction') = 0) then begin
    if StrToInt (TxtValue) = CtCodActChangeAdvance then
      AddFieldToList (NdeXMLFld, 'CodType', StrLstGAPosTransDetail,
                      'GlobalAcomptes', IntToStr (CtCodTypChangeAdvance))
    else if StrToInt (TxtValue) in [CtCodActTakeBackAdvance,
                                    CtCodActTakeBackForfait] then
      AddFieldToList (NdeXMLFld, 'CodType', StrLstGAPosTransDetail,
                      'GlobalAcomptes', IntToStr (CtCodTypTakeBackAdvance))

    else if StrToInt (TxtValue) in [CtCodActPayAdvance,
                                    CtCodActPayForfait] then
      AddFieldToList (NdeXMLFld, 'CodType', StrLstGAPosTransDetail,
                      'GlobalAcomptes', IntToStr (CtCodTypPayAdvance))
    else if StrToInt (TxtValue) in [CtCodActCredCoupCreate] then
      AddFieldToList (NdeXMLFld, 'CodType', StrLstCCPosTransDetail,
                      'GlobalCredCoup', IntToStr (CtCodTypRegistered))
    else if StrToInt (TxtValue) in [CtCodActCredCoupAccept] then
      AddFieldToList (NdeXMLFld, 'CodType', StrLstCCPosTransDetail,
                      'GlobalCredCoup', IntToStr (CtCodTypPayedBack))
    else if StrToInt (TxtValue) in [CtCodActGiftCoupon] then begin
      FlgGiftCoupon := True;
      AddFieldToList (NdeXMLFld, 'CodState', StrLstGCPosTransDetail,
                      'CreditCoupon', IntToStr (CtCodStateCredCoupPayed));
      LogDebugMessage('FlgGiftCoupon is set to true');
    end;


  end
  else if (CompareText (TxtFieldName, 'CodType') = 0) then begin
    if TxtValue = IntToStr(CtCodPdtCommentBankTransPayMent) then begin
      FlgBankTransferInfo := True;
      LogDebugMessage('FlgBankTransfer is set to true');
    end
    else begin
      if TxtValue = IntToStr(CtCodPdtInfoReturnOrigStart) then begin
        FlgReturnTicket := True;
        LogDebugMessage('FlgReturnTicket is set to true');
      end;
    end;
    if TxtValue = IntToStr(CtCodPdtAdminCoupIntOffline) then
      FlgCoupIntOffline := True;
  end
  else if (CompareText (TxtFieldName, 'ValInclVAT') = 0) then begin
    if StrLstGAPosTransDetail.Values ['CodType'] <> '' then begin
      if StrToInt (StrLstGAPosTransDetail.Values ['CodType']) =
                                              CtCodTypTakeBackAdvance then begin
        Val (TxtValue, ValAmount, NumConvert);
        ValAmount := - ValAmount;
        Str (ValAmount, TxtValue);
        AddFieldToList (NdeXMLFld, 'ValAmount', StrLstGAPosTransDetail,
                       'GlobalAcomptes', TxtValue);

      end
      else
        AddFieldToList (NdeXMLFld, 'ValAmount', StrLstGAPosTransDetail,
                       'GlobalAcomptes',  TxtValue);
    end;
    if StrLstCCPosTransDetail.Values ['CodType'] <> '' then begin
      if StrToInt (StrLstCCPosTransDetail.Values ['CodType']) =
                                              CtCodTypPayedBack then begin
        Val (TxtValue, ValAmount, NumConvert);
        ValAmount := - ValAmount;
        Str (ValAmount, TxtValue);
      end;
      AddFieldToList (NdeXMLFld, 'ValAmount', StrLstCCPosTransDetail,
                     'GlobalCredCoup',  TxtValue);
    end;
    if FlgGiftCoupon then begin
      Val (TxtValue, ValCredCoup, NumConvert);
      ValAmount := Abs(ValCredCoup);
      Str (ValAmount, TxtValue);
      AddFieldToList (NdeXMLFld, 'ValCredCoup', StrLstGCPosTransDetail,
                     'CreditCoupon',  TxtValue);
    end;
  end
  else if (CompareText (TxtFieldName, 'NumSeq') = 0) then begin
    if StrToInt (TxtValue) = 200 then
      FlgAnnulLine := True;
  end
  else if (CompareText (TxtFieldName, 'CodAnnul') = 0) then begin
    if TxtValue <> '' then
      FlgAnnulLine := True;
  end
  else if (CompareText (TxtFieldName, 'TxtMemo') = 0) then begin
    AddFieldToList(NdeXMLFld, 'CodType', StrLstGCPosTransDetail, 'CreditCoupon',
                   TxtValue);
  end
  else if (CompareText (TxtFieldName, 'IdtCurrency') = 0) then begin
    AddFieldToList(NdeXMLFld, 'IdtCurrency', StrLstGCPosTransDetail,
                   'CreditCoupon', TxtValue);
  end
  else if (CompareText (TxtFieldName, 'DatReg') = 0) then begin
    AddFieldToList (NdeXMLFld, 'DatCredCoup', StrLstGCPosTransDetail,
                   'CreditCoupon', NdeXMLFld.Text);
  end
  else if (CompareText (TxtFieldName, 'NumCoupon') = 0) then begin
    NumCoupon := TxtValue;
  end
  else if (CompareText (TxtFieldName, 'DatCouponEnd') = 0) then begin
    TxtValue := ConvertDateTimeStringForCasto (NdeXMLFld.Text);
    AddFieldToList ('DatCoupEnd', StrLstTransRepl, 'PosTransactionRepl', TxtValue);
  end;
end;   // of TXMLADOPosTransactionCA.ProcessPosTransDetailFld

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransCust (
                                                  NdePosTransCust : IXMLDOMNode;
                                                  CodActKind      : Integer);
begin  // of TXMLADOPosTransactionCA.ProcessPosTransCust
  StrLstTransRepl.Clear;
  inherited;
  if CodActKind = CtCodActKindInsert then begin
    if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
       ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
       and not FlgTraining then begin
      StrLstTransRepl.AddStrings (StrLstTransReplKeys);
      if not FlgNoRepl then
        DmdADODummyCA.InsertPosTransactionRepl (StrLstTransRepl,
                                                CtCodTypeTRFPOSTransCust);
    end;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessPosTransCust

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransCustFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin  // of TXMLADOPosTransactionCA.ProcessPosTransCustFld
  inherited;
  if (CompareText (Copy (NdeXMLFld.nodeName,1,3), 'Dat') = 0) then
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    ConvertDateTimeStringForCasto (NdeXMLFld.Text))
  else
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    NdeXMLFld.Text);
end;   // of TXMLADOPosTransactionCA.ProcessPosTransCustFld

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransInvoice (
                                               NdePosTransInvoice : IXMLDOMNode;
                                               CodActKind         : Integer);
begin  // of TXMLADOPosTransactionCA.ProcessPosTransInvoice
  StrLstTransRepl.Clear;
  inherited;
  if CodActKind = CtCodActKindInsert then begin
    if not FlgRetakeInvoice and
      ((not FlgTickAnnul) or
       ((ValCodReturn = IntToStr(CtCodPtrCancellationReceipt)) and FlgTickAnnul))
       and not FlgTraining then begin
      StrLstTransRepl.AddStrings (StrLstTransReplKeys);
      if not FlgNoRepl then
        DmdADODummyCA.InsertPosTransactionRepl (StrLstTransRepl,
                                                CtCodTypeTRFPOSTransInvoice);
    end;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessPosTransInvoice

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransInvFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin  // of TXMLADOPosTransactionCA.ProcessPosTransInvFld
  inherited;
  if (CompareText (Copy (NdeXMLFld.nodeName,1,3), 'Dat') = 0) then
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    ConvertDateTimeStringForCasto (NdeXMLFld.Text))
  else
    AddFieldToList (NdeXMLFld, StrLstTransRepl, 'PosTransactionRepl',
                    NdeXMLFld.Text);
end;   // of TXMLADOPosTransactionCA.ProcessPosTransInvFld

//=============================================================================

function TXMLADOPosTransactionCA.ConvertDateTimeStringForCasto
                                                  (TxtDatISO : string) : string;
var
  TxtDate          : string;           // Date part of a date-time value
  TxtTime          : string;           // Time part of a date-time value
begin  // of TXMLADOPosTransactionCA.ConvertDateTimeString
  SplitString (TxtDatISO, ' ', TxtDate, TxtTime);
  if TxtDate > '' then
    TxtDate := ReformatTxtStDate (TxtDate, ViTxtISODateFormat,
                                  ViTxtFormatDateCasto);
  if TxtTime > '' then
    TxtTime := ReformatTxtStTime (TxtTime, ViTxtISOTimeFormat,
                                  ViTxtFormatTimeCasto);
  Result := TxtDate + TxtTime;
end;   // of TXMLADOPosTransactionCA.ConvertDateTimeString

//=============================================================================

procedure TXMLADOPosTransactionCA.ChangeQtyLine (IdtArticle : string;
                                                 StrLstLine : TStringList);
var
  NumCode          : Integer;          // Code returned
  ValLine          : real;             // Qty in qtyline
  ValReg           : real;             // Qty registred
  TxtTotal         : string;           // Txt Total
begin  // of TXMLADOPosTransactionCA.ChangeQtyLine
  if DmdFpnADOUtilsCA.QueryInfo ('SELECT CodSalesUnit ' +
                            #10'FROM ARTICLE WHERE IDTARTICLE = ' + IdtArticle +
                            #10' AND CodSalesUnit <> 0') then begin

    Val (StrLstLine.Values ['QtyLine'], ValLine, NumCode);
    Val (StrLstLine.Values ['QtyReg'], ValReg, NumCode);
    Str ((ValLine * ValReg):10:4, TxtTotal);
    StrLstLine.Values ['QtyLine'] := TxtTotal;
  end;
  DmdFpnADOUtilsCA.CloseInfo;
end;   // of TXMLADOPosTransactionCA.ChangeQtyLine

//=============================================================================

procedure TXMLADOPosTransactionCA.AddFieldToList (NdeXMLFld    : IXMLDOMNode;
                                                  TxtFieldName : string;
                                                  StrLstFields : TStringList;
                                                  TxtTableName : string;
                                                  FieldValue   : string);
var
  FldType          : TFieldType;       // Type of the field to add
  TxtFieldValue    : string;           // Value of the field to add
  TxtDate          : string;           // Date part of a date-time value
  TxtTime          : string;           // Time part of a date-time value
begin // of TXMLADOPosTransactionCA.AddFieldToList
  FldType := GetFieldType (TxtTableName, TxtFieldName);
  if FldType <> ftUnknown then begin
    case Fldtype of
      ftString, ftMemo, ftFixedChar:
          TxtFieldValue :=  AnsiQuotedStr(FieldValue, '''');
      ftSmallInt: begin
        if AnsiCompareText (FieldValue, 'True') = 0 then
          TxtFieldValue := '1'
        else if AnsiCompareText (FieldValue, 'False') = 0 then
          TxtFieldValue := '0'
        else
          TxtFieldValue := FieldValue;
      end;
      ftDateTime: begin
        SplitString (FieldValue, ' ', TxtDate, TxtTime);
        if TxtDate > '' then
          TxtDate := ReformatTxtStDate (TxtDate, ViTxtISODateFormat,
                                        ViTxtDBDatFormat);
        if TxtTime > '' then
          TxtTime := ReformatTxtStTime (TxtTime, ViTxtISOTimeFormat,
                                        ViTxtDBHouFormat);
        TxtFieldValue := AnsiQuotedStr (Trim (TxtDate + ' ' + TxtTime), '''');
      end;
      else
        TxtFieldValue := FieldValue;
    end;
    if TxtFieldValue <> '' then
      StrLstFields.Add (TxtFieldName + '=' + TxtFieldValue);
  end;
end; // of TXMLADOPosTransactionCA.AddFieldToList

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessBankTransfer(IdtPosTrans  : Integer;
                                                      IdtCheckout  : Integer;
                                                      CodTrans     : Integer;
                                                      DatTransBegin: TDateTime);
var
  CodType          : Integer;
  IdtClassification: string;
  Id_trf           : Integer;
begin  // of TXMLADOPosTransactionCA.ProcessBankTransfer
  LogDebugMessage('Perform processBankTransfer') ;
  CodType := 0;
  Id_trf  := 0;
  //get info
  if DmdFpnADOUtilsCA.QueryInfo (
          'SELECT TOP 1 ID_TRF, CodType, IdtClassification ' +
          #10'FROM PosTransactionRepl ' +
          #10'WHERE IdtPosTransaction = ' + IntToStr(IdtPosTrans) +
          #10' AND IdtCheckout = ' + IntToStr(IdtCheckout) +
          #10' AND CodTrans = ' + IntToStr(CodTrans) +
          #10' AND DatTransBegin = ' + AnsiQuotedStr (FormatDateTime
          (ViTxtDBDatFormat + 'HHMMSS', DatTransBegin), '''') + ' ' +
          #10' AND CodAction = ' + IntToStr(CtCodActBankTransfer) + ' ' +
          #10'ORDER BY ID_TRF DESC') then begin
    Id_trf  := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('ID_TRF').AsInteger;
    CodType := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('CodType').AsInteger;
    IdtClassification := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName
                                                 ('IdtClassification').AsString;
  end;
  DmdFpnADOUtilsCA.CloseInfo;
  //Delete record payment bank transfer
  DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
    'DELETE FROM POSTRANSACTIONREPL ' +
    #10' WHERE ID_TRF = ' + IntToStr(Id_trf);
  DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
  //Change comment lines to payment lines
  DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
    'UPDATE POSTRANSACTIONREPL ' +
    #10' SET CodType = ' + IntToStr(CodType) + ', ' +
    #10' CodAction = ' + IntToStr(CtCodActBankTransfer) + ', ' +
    #10' IdtClassification = ' + AnsiQuotedStr(IdtClassification, '''') +
    #10' WHERE IdtPosTransaction = ' + IntToStr(IdtPosTrans) +
    #10' AND IdtCheckout = ' + IntToStr(IdtCheckout) +
    #10' AND CodTrans = ' + IntToStr(CodTrans) +
    #10' AND DatTransBegin = ' + AnsiQuotedStr (FormatDateTime
          (ViTxtDBDatFormat + 'HHMMSS', DatTransBegin), '''') +
    #10' AND CodType IN (' + IntToStr(CtCodPdtCommentBankTransPayMent) + ', ' +
                             IntToStr(CtCodPdtCommentBankTransReturn) + ')';
  DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
end;   // of TXMLADOPosTransactionCA.ProcessBankTransfer

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessGiftCoupon;
var
  CodGiftCoupon    : integer;
  BarCode          : String;
  FlgInsert        : Boolean;
begin  // of TXMLADOPosTransactionCA.ProcessGiftCoupon
  if not FlgGiftCoupon then
    LogDebugMessage('FlgGiftCoupon is false')
  else
    LogDebugMessage('FlgGiftCoupon is true');
  if FlgGiftCoupon and not FlgAnnulLine then begin
     LogDebugMessage('Begin action giftcoupon');
     CodGiftCoupon := StrToIntDef(StrLstGCPosTransDetail.Values['CodType'], 0);
     LogDebugMessage('CodGiftCoupon = ' + IntToStr(codgiftcoupon));
     if (CodGiftCoupon >= CtCodTypeGiftCoupMin) and
        (CodGiftCoupon <= CtCodTypeGiftCoupMax) then begin
       BarCode := StrLstGCPosTransDetail.Values['BarCode'];
       //Payment with gift coupon
       if ValCredCoup <= 0 then begin
         try
            if not DmdFpnADOUtilsCA.QueryInfo
                 ('SELECT *' +
                  #10'FROM CreditCoupon (NOLOCK)' +
                  #10'WHERE CodType = ' + IntToStr(CodGiftCoupon) +
                  #10'AND DatCredCoup = ' +
                      StrLstGCPosTransDetail.Values ['DatCredCoup'] +
                  #10'AND BarCode = ' + BarCode) then begin
              //Insert CreditCoupon
              FlgInsert := True;
              LogDebugMessage('Set FlgInsert to true');
            end
            else begin
              FlgInsert := False;
              LogDebugMessage('Creditcoupon: ' + BarCode +
                              ' already exists.');
            end;
         finally
           DmdFpnADOUtilsCA.CloseInfo;
         end;
         if FlgInsert then begin
           try
             //IdtCredCoup invullen
             DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
                DmdADODummyCA.BuildSQLInsertGiftCoupon
                              (StrLstGCPosTransDetail.Values['BarCode'],
                               StrLstGCPosTransDetail.Values['CodType'],
                               IntToStr(CtCodStateCredCoupPayed),
                               StrLstGCPosTransDetail.Values['ValCredCoup'],
                               StrLstGCPosTransDetail.Values['DatCredCoup'],
                               StrLstGCPosTransDetail.Values['IdtCurrency']);
             DmdFpnADOUtilsCA.ExecQryInfo;
             LogDebugMessage('Inserted creditcoupon: ' + BarCode);
           finally
             DmdFpnADOUtilsCA.CloseInfo;
           end;
         end;
       end
       //Annulation of payment with gift coupon
       else begin
         if ValCredCoup > 0 then begin
           try
             DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
                 'DELETE ' +
                  #10'FROM CreditCoupon (NOLOCK)' +
                  #10'WHERE CodType = ' + IntToStr(CodGiftCoupon) +
                  #10'AND DatCredCoup = ' +
                      StrLstGCPosTransDetail.Values['DatCredCoup'] +
                  #10'AND BarCode = ' + BarCode;
             DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
             LogDebugMessage('Deleted creditcoupon: ' + BarCode);
          finally
            DmdFpnADOUtilsCA.CloseInfo;
          end;
         end;
       end;
     end;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessGiftCoupon

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransDetAddOnFld(
  NdeXMLFld: IXMLDOMNode; StrLstFields: TStringList);
begin  // of TXMLADOPosTransactionCA.ProcessPosTransDetAddOnFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetAddOn',
                  NdeXMLFld.Text);
end;   // of TXMLADOPosTransactionCA.ProcessPosTransDetAddOnFld

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessPosTransDetAddOn(
  NdePosTransDetAddOn: IXMLDOMNode; CodActKind: Integer);
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin  // of TXMLADOPosTransactionCA.ProcessPosTransDetAddOn
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransDetAddOn.childNodes.length) do
      ProcessPosTransDetAddOnFld (NdePosTransDetAddOn.childNodes[CntItem],
                                     StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransDetAddOn (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransDetAddOn', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessPosTransDetAddOn

//=============================================================================

procedure TXMLADOPosTransactionCA.CheckChangeQtyReturned
                                             (    IdtPosTransCurr   : Integer;
                                                  IdtCheckoutCurr   : Integer;
                                                  CodTransCurr      : Integer;
                                                  DatTransBeginCurr : TDateTime;
                                                  NumLineStartCurr  : Integer;
                                                  NumLineEndCurr    : Integer;
                                                  IdtPosTransOrig   : Integer;
                                                  IdtCheckoutOrig   : Integer;
                                                  CodTransOrig      : Integer;
                                                  DatTransBeginOrig : TDateTime;
                                                  IdtCVenteOrig     : string;
                                                  NumPlu            : string;
                                                  CodTypeArt        : Integer;
                                                  FlgTraining       : Integer;
                                              var QtyReturn         : Double);
var
  FlgServiceArt    : Boolean;          // Service article
  ValCurrTrans     : Double;           // Value current transaction
  ValOrigTrans     : Double;           // Value original transaction
  QtyOrigTrans     : Double;           // Quantity original transaction
begin  // of TXMLADOPosTransactionCA.CheckChangeQtyReturned
  FlgServiceArt := CodTypeArt in SetCodTypesServArt;
  if not FlgServiceArt then
    Exit;

  LogDebugMessage('Start Retrieve value current transaction');
  try
    // Retrieve value current transaction
    DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.SQL.Text :=
      DmdFpnADOPosTransactionCA.BuildSQLRetrieveValueTransArt
        (IdtPosTransCurr, IdtCheckoutCurr, CodTransCurr, DatTransBeginCurr,
         NumLineStartCurr, NumLineEndCurr, IdtCVenteOrig, NumPlu, FlgTraining);
    DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.Active := True;
    try
      ValCurrTrans :=
        DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.
          FieldByName('Value').AsFloat;
      ValCurrTrans := ValCurrTrans * (-1);
    finally
      DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.Active := False;
    end;
  except
    on E: Exception do begin
      LogDebugMessage('Error retrieving val curr trans: ' + E.Message);
      raise;
    end;
  end;
  LogDebugMessage('End Retrieve value current transaction');

  // Retrieve value of original transaction
  DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.SQL.Text :=
    DmdFpnADOPosTransactionCA.BuildSQLRetrieveValueTransArt
      (IdtPosTransOrig, IdtCheckoutOrig, CodTransOrig, DatTransBeginOrig,
       -1, -1, IdtCVenteOrig, NumPlu, FlgTraining);
  DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.Active := True;
  try
    ValOrigTrans :=
      DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.
        FieldByName('Value').AsFloat;
    QtyOrigTrans :=
      DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.
        FieldByName('Quantity').AsFloat;
  finally
    DmdFpnADOPosTransactionCA.ADOQryCalcQtyReturned.Active := False;
  end;
  LogDebugMessage('Retrieve value original transaction');

  // Calculate qtyreturned
  if (Abs (ValOrigTrans) >= CtValMinFloat) and
     (Abs (ValCurrTrans) >= CtValMinFloat) then begin
    QtyReturn :=  (ValCurrTrans / ValOrigTrans) * QtyOrigTrans;
    QtyReturn := RoundToDecimal(QtyReturn, 4, False);
    LogDebugMessage('Change QtyReturn');
  end;
end;   // of TXMLADOPosTransactionCA.CheckChangeQtyReturned

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessReturnTicket(IdtPosTrans  : Integer;
                                                      IdtCheckout  : Integer;
                                                      CodTrans     : Integer;
                                                      DatTransBegin: TDateTime;
                                                      FlgCancel    : Boolean);
var
  TxtSQL           : string;
  NumLineStart     : Integer;
  NumLineEnd       : Integer;
  CodType          : Integer;
  CodAction        : Integer;
  TxtDescr         : string;
  DatTick          : TDateTime;
  NumStore         : string;
  NumCashDesk      : string;
  NumTick          : string;
  NumDoc           : string;
  NumPLU           : string;
  PrevNumPLU       : string;
  QtyReturned      : Double;
  NumLineReg       : string;
  NumSeq           : string;
  FlgTraining      : Integer;
  StrDatTick       : string;
  StartDate        : string;
  EndDate          : string;
  FlgOffline       : Boolean;
  CodTypeArt       : Integer;
  CodSalesUnit     : integer;          // CodSalesUnit of article
  CodTransorig     : integer;
begin  // of TXMLADOPosTransactionCA.ProcessReturnTicket
  CodTypeArt := 0;
  FlgOffline := False;
  CodTransorig := CodTrans;
  if FlgCancel then
    LogDebugMessage('START CANCELLATION OF RETURN TICKET');
  LogDebugMessage('Start process return ticket');
  TxtSQL := DmdFpnADOPosTransactionCA.BuildSQLPosTransDetReturns(
              IdtPosTrans, IdtCheckout, CodTrans, DatTransBegin);
  try
    if DmdFpnADOUtilsCA.QueryInfo(TxtSql) then begin;
      while not DmdFpnADOUtilsCA.ADOQryInfo.Eof do begin
        FlgTraining  := DmdFpnADOUtilsCA.ADOQryInfo.
                          FieldByName('FlgTraining').AsInteger;
        NumLineStart := DmdFpnADOUtilsCA.ADOQryInfo.
                          FieldByName('NumLineReg').AsInteger;
        DmdFpnADOUtilsCA.ADOQryInfo.Next;
        NumLineEnd := DmdFpnADOUtilsCA.ADOQryInfo.
                        FieldByName('NumLineReg').AsInteger;
        //Get info original ticket
        LogDebugMessage('Get info original ticket');
        TxtSql :=  DmdFpnADOPosTransactionCA.BuildSQLPosTransDetReturnInfo(
                     IdtPosTrans, IdtCheckout, CodTrans, DatTransBegin,
                     NumLineStart, NumLineEnd);
        QryReturnTicket.SQL.Text := TxtSql;
        try
          QryReturnTicket.Open;
          while not QryReturnTicket.Eof do begin
            CodType  := QryReturnTicket.FieldByName('CodType').AsInteger;
            TxtDescr := QryReturnTicket.FieldByName('TxtDescr').AsString;
            case CodType of
              CtCodPdtCommentTakeBackDatTick: Begin
                  FlgOffline := Length(QryReturnTicket.
                                  FieldByName('TxtDescr').AsString) <= 10;
                  DatTick    := StrToDateTime (QryReturnTicket.
                                  FieldByName('TxtDescr').AsString,
                                  'DD-MM-YYYY', ViTxtDBHouFormat);
              end;
              CtCodPdtCommentTakeBackNumStore: NumStore       := TxtDescr;
              CtCodPdtCommentTakeBackNumCashDesk: NumCashDesk := TxtDescr;
              CtCodPdtCommentTakeBackNumTick: NumTick         := TxtDescr;
              CtCodPdtCommentTakeBackNumDocument: NumDoc      := TxtDescr;
            end;
            QryReturnTicket.Next;
          end;
        finally
          QryReturnTicket.Close;
        end;
        if numdoc = '' then begin
          LogDebugMessage('dattick = ' +
               FormatDateTime( ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,dattick));
          LogDebugMessage('numstore = ' + numstore);
          LogDebugMessage('NumCashDesk = ' + NumCashDesk);
          LogDebugMessage('NumTick = ' + NumTick);
        end
        else begin
          LogDebugMessage('numstore = ' + numstore);
          LogDebugMessage('NumDoc = ' + NumDoc);
        end;
        //Get articles
        LogDebugMessage('Get Articles');
        TxtSql := DmdFpnADOPosTransactionCA.BuildSQLPosTransDetReturnArticles(
                    IdtPosTrans, IdtCheckout, CodTrans, DatTransBegin,
                    NumLineStart, NumLineEnd);
        QryReturnTicket.SQL.Clear;
        QryReturnTicket.SQL.Text := TxtSql;
        try
          QryReturnTicket.Open;
          if not QryReturnTicket.Eof then begin
            PrevNumPlu := QryReturnTicket.FieldByName('NumPLU').AsString;
            CodTypeArt :=
              QryReturnTicket.FieldByName('CodTypeArticle').AsInteger;
          end;
          QtyReturned := 0;
          while not QryReturnTicket.Eof do begin
            NumLineReg := QryReturnTicket.FieldByName('NumLineReg').AsString;
            NumSeq := '100';
            NumPlu := QryReturnTicket.FieldByName('NumPLU').AsString;
            if not QryReturnTicket.FieldByName('CodSalesUnit').IsNull then
              CodSalesUnit :=
                     QryReturnTicket.FieldByName('CodSalesUnit').AsInteger
            else
              CodSalesUnit := 0;
            LogDebugMessage('Get original ticket info');
            //Get original ticket info in case of numdoc or offline
            if NumDoc <> '' then begin
              TxtSql := 'Select * from postransdetail ' +
                        #10'where idtcvente = ' + trim(numdoc) +
                        #10'and numplu = ' + QuotedStr(numplu);
              QryInfoOrigTicket.SQL.Text := TxtSql;
              try
                QryInfoOrigTicket.Open;
                if not QryInfoOrigTicket.Eof then begin
                  LogDebugMessage('Retrieved original ticket info');
                  DatTick     := QryInfoOrigTicket.
                                   FieldByName('DatTransBegin').AsDateTime;
                  NumCashDesk := QryInfoOrigTicket.
                                   FieldByName('IdtCheckout').AsString;
                  NumTick     := QryInfoOrigTicket.
                                  FieldByName('IdtPosTransaction').AsString;
                  CodTransorig    := QryInfoOrigTicket.
                                   FieldByName('CodTrans').AsInteger;
                end
                else
                  LogDebugMessage('NUMDOC ' + trim(numdoc) +
                                  ' DOES NOT EXIST OR ARTICLE NOT FOUND.');
              finally
                QryInfoOrigTicket.Close;
              end;
            end
            else begin
              strDatTick := FormatDateTime( ViTxtDBDatFormat + ' ' +
                                        ViTxtDBHouFormat, dattick);
              if not FlgOffline then begin
                StartDate := strDatTick;
                EndDate := strDatTick;
              end
              else begin
                StartDate := FormatDateTime(ViTxtDBDatFormat + ' 00:00:00' ,
                                            dattick);
                EndDate   := FormatDateTime( ViTxtDBDatFormat + ' 23:59:59' ,
                                            dattick);
              end;
              TxtSql := 'SELECT * FROM postransdetail ' +
                        #10'WHERE dattransbegin BETWEEN ' +
                                    AnsiQuotedStr(StartDate, '''') +
                          ' AND ' + AnsiQuotedStr(EndDate, '''') +
                        #10'AND idtpostransaction = ' + NumTick +
                      //  #10'AND codtrans = ' + IntToStr(CodTrans) +
                        #10'AND idtcheckout = ' + NumCashDesk;
              QryInfoOrigTicket.SQL.Text := TxtSql;
              try
                QryInfoOrigTicket.Open;
                if not QryInfoOrigTicket.Eof then begin
                  DatTick     := QryInfoOrigTicket.
                                   FieldByName('DatTransBegin').AsDateTime;
                  NumCashDesk := QryInfoOrigTicket.
                                   FieldByName('IdtCheckout').AsString;
                  NumTick     := QryInfoOrigTicket.
                                   FieldByName('IdtPosTransaction').AsString;
                  CodTransorig    := QryInfoOrigTicket.
                                   FieldByName('CodTrans').AsInteger;
                end
                else
                  LogDebugMessage('TICKET ' + trim(NumTick) + ' DOES NOT EXIST.');
              finally
                QryInfoOrigTicket.Close;
              end;
            end;
            if not FlgCancel then begin
              //check if record exists in PosTransDetAddOn
              LogDebugMessage('check if record exists in PosTransDetAddOn');
              TxtSql := DmdFpnADOPosTransactionCA.BuildSQLInsPosTransDetAddOn(
                          IdtPosTrans,IdtCheckout,CodTrans,DatTransBegin,
                          FlgTraining, NumLineReg, NumSeq,
                          FormatDateTime( ViTxtDBDatFormat + ' ' +
                          ViTxtDBHouFormat,dattick), NumTick, NumCashDesk,
                          NumStore);
              LogDebugMessage ('build sql insert postransdetaddon');
              QryUpdReturnTicket.SQL.Text := TxtSql;
              try
                QryUpdReturnTicket.ExecSQL;
              finally
                QryUpdReturnTicket.Close;
                QryUpdReturnTicket.SQL.Clear;
              end;
            end;
            if PrevNumPLU <> NumPLU then begin
              CheckChangeQtyReturned
                (IdtPosTrans, IdtCheckout, CodTrans, DatTransBegin,NumLineStart,
                 NumLineEnd,  StrToIntDef (NumTick, 0),
                 StrToIntDef (NumCashDesk, 0), CodTransorig, Dattick, NumDoc,
                 PrevNumPLU, CodTypeArt, FlgTraining, QtyReturned);
              if FlgCancel then begin
                UpdatePosTransDetCancelReturn
                  (NumTick, NumCashDesk, IntToStr(CodTransorig), FormatDateTime
                  (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,dattick),
                   NumDoc, PrevNumPLU, QtyReturned, FlgTraining);
                QtyReturned := 0;
              end
              else begin
                UpdatePOSTransDetQtyReturned
                  (NumTick, NumCashDesk, IntToStr(CodTransorig), FormatDateTime(
                   ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,dattick),
                   NumDoc, PrevNumPLU, QtyReturned, FlgTraining);
                QtyReturned := 0;
              end;
            end;
            if CodSalesUnit <>  0 then
              QtyReturned := QtyReturned +
                             Abs(QryReturnTicket.FieldByName('QtyLine').AsFloat
                             * QryReturnTicket.FieldByName('QtyReg').AsInteger)
            else
              QtyReturned := QtyReturned +
                            Abs(QryReturnTicket.FieldByName('QtyLine').AsFloat);
            PrevNumPLU := QryReturnTicket.FieldByName('NumPLU').AsString;
            CodTypeArt :=
              QryReturnTicket.FieldByName('CodTypeArticle').AsInteger;
            QryReturnTicket.Next;
          end;
          if PrevNumPLU <> '' then begin
            CheckChangeQtyReturned
              (IdtPosTrans, IdtCheckout, CodTrans, DatTransBegin,NumLineStart,
               NumLineEnd,  StrToIntDef (NumTick, 0),
               StrToIntDef (NumCashDesk, 0), CodTransorig, Dattick, NumDoc,
               PrevNumPLU, CodTypeArt, FlgTraining, QtyReturned);
            if FlgCancel then begin
              UpdatePosTransDetCancelReturn (
                 NumTick, NumCashDesk, IntToStr(CodTransorig),
                 FormatDateTime( ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,dattick),
                 NumDoc, PrevNumPLU, QtyReturned, FlgTraining);
              LogDebugMessage('updated cancel last article');
            end
            else begin
              UpdatePOSTransDetQtyReturned (
                 NumTick, NumCashDesk, IntToStr(CodTransorig),
                 FormatDateTime( ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,dattick),
                 NumDoc, PrevNumPLU, QtyReturned, FlgTraining);
              LogDebugMessage('updated last article');
            end;
          end;
        finally
          QryReturnTicket.Close;
        end;
        DmdFpnADOUtilsCA.ADOQryInfo.Next;
      end;
    end;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessReturnTicket

//=============================================================================

procedure TXMLADOPosTransactionCA.UpdatePosTransDetQtyReturned(
                                                      IdtPosTrans   : String;
                                                      IdtCheckout   : String;
                                                      CodTrans      : String;
                                                      DatTransBegin : String;
                                                      IdtCVente     : String;
                                                      NumPlu        : String;
                                                      QtyReturn     : Double;
                                                      FlgTraining   : Integer);
begin  // of TXMLADOPosTransactionCA.UpdatePosTransDetQtyReturned
  LogDebugMessage('update qtyreturned ' + FloatToStr(qtyreturn) + ' for article ' + numplu);
  if IdtCVente <> '' then begin
    LogDebugMessage('update with idtcvente = ' + IdtCVente);
    try
      with DmdFpnADOPosTransactionCA.ADOQryUpdQtyReturnedDoc do begin
        Close;
        Parameters.ParamByName('IdtCVente').Value := IdtCVente;
        Parameters.ParamByName('FlgTraining').Value := FlgTraining;
        Parameters.ParamByName('NumPLU').Value := NumPLU;
        Parameters.ParamByName('QtyReturned').Value := QtyReturn;
        Prepared := True;
        ExecSQL;
      end;
    finally
      DmdFpnADOPosTransactionCA.ADOQryUpdQtyReturnedDoc.Close;
    end;
  end
  else begin
    LogDebugMessage('Update with ticket data');
    try
      with DmdFpnADOPosTransactionCA.ADOQryUpdQtyReturnedTicket do begin
        Close;
        Parameters.ParamByName('IdtPOSTransaction').Value := StrToInt(IdtPosTrans);
        Parameters.ParamByName('IdtCheckout').Value := StrToInt(IdtCheckout);
        Parameters.ParamByName('CodTrans').Value := StrToInt(CodTrans);
        Parameters.ParamByName('DatTransBegin').Value := DatTransBegin;
        Parameters.ParamByName('NumPLU').Value := NumPLU;
        Parameters.ParamByName('QtyReturned').Value := QtyReturn;
        Parameters.ParamByName('FlgTraining').Value := FlgTraining;
        Prepared := True;
        ExecSQL;
      end;
    finally
      DmdFpnADOPosTransactionCA.ADOQryUpdQtyReturnedTicket.Close;
    end;
  end;
  LogDebugMessage('updated qtyreturn');
end;   // of TXMLADOPosTransactionCA.UpdatePosTransDetQtyReturned

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessCancelTicket(IdtPosTrans  : Integer;
                                                      IdtCheckout  : Integer;
                                                      CodTrans     : Integer;
                                                      DatTransBegin: TDateTime;
                                                      FlgTraining  : Boolean);
var
  TxtSQL           : string;
  FlgReturnTicket  : Boolean;
begin  // of TXMLADOPosTransactionCA.ProcessCancelTicket
  FlgReturnTicket := False;
  LogDebugMessage('START PROCESS CANCEL TICKET');
  TxtSQL  :=
       'Select * from postransdetaddon' +
    #10'where idtpostransaction = ' + IntToStr(IdtPosTrans) +
    #10'and idtcheckout = ' + IntToStr(IdtCheckout) +
    #10'and codtrans = ' + IntToStr(CodTrans) +
    #10'and dattransbegin = ' + AnsiQuotedStr (FormatDateTime
    (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat, DatTransBegin), '''');
  try
    if DmdFpnADOUtilsCA.QueryInfo(TxtSql) then
      FlgReturnTicket := True;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
  if FlgReturnTicket then
    ProcessReturnTicket(IdtPosTrans, IdtCheckout, CodTrans,
                        DatTransBegin, True);
end;   // of TXMLADOPosTransactionCA.ProcessCancelTicket

//=============================================================================

procedure TXMLADOPosTransactionCA.UpdatePosTransDetCancelReturn(
                                                      IdtPosTrans   : String;
                                                      IdtCheckout   : String;
                                                      CodTrans      : String;
                                                      DatTransBegin : String;
                                                      IdtCVente     : String;
                                                      NumPlu        : String;
                                                      QtyReturn     : Double;
                                                      FlgTraining   : Integer);
begin  // of TXMLADOPosTransactionCA.UpdatePosTransDetCancelReturn

  LogDebugMessage('CANCEL TICKET: update qtyreturned ' + FloatToStr(qtyreturn) + ' for article ' + numplu);
  if IdtCVente <> '' then begin
    LogDebugMessage('CANCEL TICKET: update with idtcvente = ' + IdtCVente);
    try
      with DmdFpnADOPosTransactionCA.ADOQryUpdCancelReturnDoc do begin
        Close;
        Parameters.ParamByName('IdtCVente').Value := IdtCVente;
        Parameters.ParamByName('FlgTraining').Value := FlgTraining;
        Parameters.ParamByName('NumPLU').Value := NumPLU;
        Parameters.ParamByName('QtyReturned').Value := QtyReturn;
        Prepared := True;
        ExecSQL;
      end;
    finally
      DmdFpnADOPosTransactionCA.ADOQryUpdCancelReturnDoc.Close;
    end;
  end
  else begin
    LogDebugMessage('CANCEL TICKET: Update with ticket data');
    try
      with DmdFpnADOPosTransactionCA.ADOQryUpdCancelReturnTicket do begin
        Close;
        Parameters.ParamByName('IdtPOSTransaction').Value := StrToInt(IdtPosTrans);
        Parameters.ParamByName('IdtCheckout').Value := StrToInt(IdtCheckout);
        Parameters.ParamByName('CodTrans').Value := StrToInt(CodTrans);
        Parameters.ParamByName('DatTransBegin').Value := DatTransBegin;
        Parameters.ParamByName('NumPLU').Value := NumPLU;
        Parameters.ParamByName('QtyReturned').Value := QtyReturn;
        Parameters.ParamByName('FlgTraining').Value := FlgTraining;
        Prepared := True;
        ExecSQL;
      end;
    finally
      DmdFpnADOPosTransactionCA.ADOQryUpdCancelReturnTicket.Close;
    end;
  end;
  LogDebugMessage('CANCEL TICKET: updated qtyreturn');

end;   // of TXMLADOPosTransactionCA.UpdatePosTransDetCancelReturn

//=============================================================================

procedure TXMLADOPosTransactionCA.ChangeQtyLineDepositDocBo(
                                                      IdtArticle: string;
                                                      StrLstLine: TStringList);
begin  // of TXMLADOPosTransactionCA.ChangeQtyLineDepositDocBo
  if IdtArticle <> '' then begin
    try
      if DmdFpnADOUtilsCA.QueryInfo ('SELECT CodSalesUnit ' +
                                #10'FROM ARTICLE WHERE IDTARTICLE = ' + IdtArticle +
                                #10' AND CodSalesUnit <> 0') then begin
        StrLstLine.Values ['QtyReg'] := '1';
        LogDebugMessage('Commentline with codtype 443:');
        LogDebugMessage('Changed QtyReg to 1');
      end;
    finally
      DmdFpnADOUtilsCA.CloseInfo;
    end;
  end;
end;   // of TXMLADOPosTransactionCA.ChangeQtyLineDepositDocBo

//=============================================================================

procedure TXMLADOPosTransactionCA.ProcessCoupIntOffline(IdtPosTrans  : Integer;
                                                      IdtCheckout  : Integer;
                                                      CodTrans     : Integer;
                                                      DatTransBegin: TDateTime);
var
  TxtNumCoupon     : string;
  IdtCoupStatus    : Integer;
begin  // of TXMLADOPosTransactionCA.ProcessCoupIntOffline
  IdtCoupStatus := 0;
  try
    //get lines with codtype 150
    DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.SQL.Text :=
           DmdFpnADOPosTransactionCA.BuildSQLLstCoupOffline(IdtPosTrans,
                                         IdtCheckout, CodTrans, DatTransBegin);
    DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.Open;
    while not DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.Eof do begin
      //for every line in this ticket with codtype 150
      TxtNumCoupon := DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.
                                        FieldByName('TxtSrcNumCoupon').AsString;
      // Get IdtCouponStatus
      try
        if DmdFpnADOUtilsCA.QueryInfo('SELECT * FROM CouponStatus ' +
                                  #10'WHERE TxtSrcNumCoupon = ' +
                                  AnsiQuotedStr(trim(TxtNumCoupon), '''')) then
          IdtCoupStatus := DmdFpnADOUtilsCA.ADOQryInfo.
                             FieldByName('IdtCouponStatus').AsInteger;
      finally
        DmdFpnADOUtilsCA.CloseInfo;
      end;
      //change codstate to used (codstate = 1)
      try
        DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
                                  'UPDATE CouponStatus ' +
                                  #10'SET CodState = 1 ' +
                                  #10'WHERE TxtSrcNumCoupon = ' +
                                  AnsiQuotedStr(trim(TxtNumCoupon), '''');
        DmdFpnADOUtilsCA.ExecQryInfo;
        LogDebugMessage('Changed codstate to 1 for coupon ' + TxtNumCoupon);
      finally
        DmdFpnADOUtilsCA.CloseInfo;
      end;
      // insert into coupstathis
      try
        DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
                DmdADODummyCA.BuildSQLInsertCoupStatHis
                            (IdtCoupStatus, 1, now,
                             DmdFpnADOUtilsCA.IdtOperatorCurrentOperator,
                            DatTransBegin, IdtPosTrans, IdtCheckout, CodTrans);
        DmdFpnADOUtilsCA.ExecQryInfo;
      finally
        DmdFpnADOUtilsCA.CloseInfo;
      end;
      DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.Next;
    end;
    //change codtype to 101 in postransdetail
    try
      DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
      'UPDATE PosTransDetail ' +
        #10'SET CodType = ' + IntToStr(CtCodPdtAdmin) +
        #10'WHERE IdtPosTransaction = ' + IntToStr(IdtPosTrans) +
        #10' AND IdtCheckout = ' + IntToStr(IdtCheckout) +
        #10' AND CodTrans = ' + IntToStr(CodTrans) +
        #10' AND DatTransBegin = ' + AnsiQuotedStr (FormatDateTime
        (ViTxtDBDatFormat + ' ' + viTxtDBHouFormat, DatTransBegin), '''') + ' ' +
        #10'AND CodType = ' + IntToStr(CtCodPdtAdminCoupIntOffline);
      DmdFpnADOUtilsCA.ExecQryInfo;
    finally
      DmdFpnADOUtilsCA.CloseInfo;
    end;
  finally
    DmdFpnADOPosTransactionCA.ADOQryLstCoupOffline.Close;
  end;
end;   // of TXMLADOPosTransactionCA.ProcessCoupIntOffline

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FXMLADOPosTransactionCA
