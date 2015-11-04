//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint
// Unit   : FXMLADOPosTransaction : FXMLADOPosTransaction = processes XML-string
//          to DB for PosTransaction
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosTransaction.pas,v 1.2 2009/09/21 16:04:36 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOPosTransaction - CVS revision 1.2
//=============================================================================

unit FXMLADOPosTransaction;

//*****************************************************************************

interface

uses
  Classes, MSXML_TLB, FXMLADOGeneral, Windows;

//*****************************************************************************
// TXMLADOPosTransaction
//*****************************************************************************

type
  TXMLADOPosTransaction = class (TXMLADOGeneral)
  protected
    //POSTransaction
    procedure ProcessPosTransaction (NdePosTrans : IXMLDOMNode;
                                     CodActKind  : Integer ); virtual;
    procedure ProcessPosTransFld (NdeXMLFld    : IXMLDOMNode;
                                  StrLstFields : TStringList); virtual;
    procedure ProcessDetailTablesFromXML (NdeXML     : IXMLDOMNode;
                                          CodActKind : Integer ); virtual;
    //POSTransDetail
    procedure ProcessPosTransDetail (NdePosTransDetail : IXMLDOMNode;
                                     CodActKind        : Integer ); virtual;
    procedure ProcessPosTransDetailFld (NdeXMLFld    : IXMLDOMNode;
                                        StrLstFields : TStringList); virtual;
    //POSTransCust
    procedure ProcessPosTransCust (NdePosTransCust : IXMLDOMNode;
                                   CodActKind      : Integer ); virtual;
    procedure ProcessPosTransCustFld (NdeXMLFld    : IXMLDOMNode;
                                      StrLstFields : TStringList); virtual;
    //POSTransInvoice
    procedure ProcessPosTransInvoice (NdePosTransInvoice : IXMLDOMNode;
                                      CodActKind         : Integer ); virtual;
    procedure ProcessPosTransInvFld (NdeXMLFld    : IXMLDOMNode;
                                     StrLstFields : TStringList); virtual;
    //POSTransApproval
    procedure ProcessPosTransApproval (NdePosTransAppr : IXMLDOMNode;
                                       CodActKind      : Integer); virtual;
    procedure ProcessPosTransApprovalFld (NdeXMLFld    : IXMLDOMNode;
                                          StrLstFields : TStringList); virtual;
    //POSTransDetApproval
    procedure ProcessPosTransDetApproval (NdePosTransDetAppr : IXMLDOMNode;
                                          CodActKind         : Integer);
                                                                      virtual;
    procedure ProcessPosTransDetApprovalFld (NdeXMLFld    : IXMLDOMNode;
                                             StrLstFields : TStringList);
                                                                      virtual;
  public
    procedure ProcessXML (TxtXML: string); override;
  end;  // of TXMLADOPosTransaction

var
  XMLADOPosTransaction: TXMLADOPosTransaction;

implementation

uses
  SysUtils,
  SfDialog,
  MFpnDBUtil_ADO,
  DMADODummy;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOPosTransaction';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosTransaction.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 16:04:36 $';

//*****************************************************************************
// Implementation of TXMLADOPosTransaction
//*****************************************************************************

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransaction : Processes the PosTransaction that
//    is included in the IXMLDOMNode
//                                  -----
// INPUT  : NdePosTrans = The node that contains the XML statement for a pos
//                        transaction is entered
//          CodActKind = The kind of action
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransaction
                                                     (NdePosTrans : IXMLDOMNode;
                                                      CodActKind  : Integer);
var
  CntItem          : Integer;          // Index for loop
  StrLstFields     : TStringList;      // List with names and values of fields
begin // of TXMLADOPosTransaction.ProcessPosTransaction
  // process the Pos Transaction data to the Pos Transaction table
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
end;  // of TXMLADOPosTransaction.ProcessPosTransaction

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransFld : Processes one field of the
//    POSTransaction table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the value of
//                         the field that has to be added
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransFld (NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransFld
  // is used for Key saving
  if (CompareText (NdeXMLFld.nodeName, 'IdtPosTransaction') = 0)
     or (CompareText (NdeXMLFld.nodeName, 'IdtCheckout') = 0)
     or (CompareText (NdeXMLFld.nodeName, 'CodTrans') = 0)
     or (CompareText (NdeXMLFld.nodeName, 'DatTransBegin') = 0) then
    AddFieldToList (NdeXMLFld, StrLstKeys, 'PosTransaction', NdeXMLFld.Text)
  else
    AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransaction', NdeXMLFld.Text);
end;  // of TXMLADOPosTransaction.ProcessPostransFld

//=============================================================================
// TXMLADOPosTransaction.ProcessDetailTablesFromXML : Extracts the detail tables of
//    a postransaction
//                                  -----
// INPUT  : NdeXML = XML Node that contains a postransaction
//=============================================================================

procedure TXMLADOPosTransaction.ProcessDetailTablesFromXML
                                                    (NdeXML     : IXMLDOMNode;
                                                     CodActKind : Integer );
begin // of TXMLADOPosTransaction.ProcessDetailTablesFromXML
  if AnsiCompareText (NdeXML.nodeName, 'POSTransDetail') = 0 then
    ProcessPosTransDetail (NdeXML, CodActKind)
  else if AnsiCompareText (NdeXML.nodeName, 'POSTransCust') = 0 then
    ProcessPosTransCust (NdeXML, CodActKind)
  else if AnsiCompareText (NdeXML.nodeName, 'POSTransInvoice') = 0 then
    ProcessPosTransInvoice (NdeXML, CodActKind)
  else if AnsiCompareText (NdeXML.nodeName, 'POSTransApproval') = 0 then
    ProcessPosTransApproval (NdeXML, CodActKind)
  else if AnsiCompareText (NdeXML.nodeName, 'POSTransDetApproval') = 0 then
    ProcessPosTransDetApproval (NdeXML, CodActKind);
end;  // of TXMLADOPosTransaction.ProcessDetailTablesFromXML

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransDetail : Processes the PosTransDetail that
//    is included in the IXMLDOMNode
//                                  -----
// INPUT  : NdePosTransDetail = The node that contains the XML statement for a
//                              detail pos transaction is entered
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransDetail (
                                           NdePosTransDetail : IXMLDOMNode;
                                           CodActKind        : Integer );
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin // of TXMLADOPosTransaction.ProcessPosTransDetail
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransDetail.childNodes.length) do
      ProcessPosTransDetailFld (NdePosTransDetail.childNodes[CntItem],
                                    StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransDetail (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransDetail', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOPosTransaction.ProcessPosTransDetail

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransDetailFld : Processes one field of the
//    POSTransDetail table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the
//                         value of the field that has to be added
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransDetailFld (
                                           NdeXMLFld    : IXMLDOMNode;
                                           StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransDetailFld
  if AnsiCompareText (NdeXMLFld.nodeName, 'IdtClassification') = 0 then begin
    AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetail',
                    DmdADODummy.GetIdtClassification (
                                                    StrToInt (NdeXMLFld.text)));
  end
  else begin
    AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetail', NdeXMLFld.Text);
    if AnsiCompareText (NdeXMLFld.nodeName, 'NumPLU') = 0 then
      StrLstFields.Add ('IdtArticle=' +
             AnsiQuotedStr (DmdADODummy.GetIdtArticle (NdeXMLFld.Text), ''''));
  end
end;  // of TXMLADOPosTransaction.ProcessPosTransDetailFld

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransCust : Processes the PosTransCust that
//    is included in the IXMLDOMNode
//                                  -----
// INPUT  : NdePosTransCust = The node that contains the XML statement for a
//                            cust pos transaction is entered
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransCust (
                                                  NdePosTransCust : IXMLDOMNode;
                                                  CodActKind      : Integer );
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin // of TXMLADOPosTransaction.ProcessPosTransCust
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransCust.childNodes.length) do
      ProcessPosTransCustFld (NdePosTransCust.childNodes[CntItem],
                                  StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransCust (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                        AnsiQuotedStr ('PosTransCust', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOPosTransaction.ProcessPosTransCust

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransCustFld : Processes one field of the
//    POSTransCust table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the
//                         value of the field that has to be added
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransCustFld (
                                              NdeXMLFld    : IXMLDOMNode;
                                              StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransCustFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransCust', NdeXMLFld.Text);
end;  // of TXMLADOPosTransaction.ProcessPosTransCustFld

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransInvoice : Processes the PosTransInvoice
// that is included in the IXMLDOMNode
//                                  -----
// INPUT  : NdePosTransInvoice = The node that contains the XML statement for a
//                               cust pos transaction is entered
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransInvoice (
                                              NdePosTransInvoice : IXMLDOMNode;
                                              CodActKind         : Integer );
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin // of TXMLADOPosTransaction.ProcessPosTransInvoice
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransInvoice.childNodes.length) do
      ProcessPosTransInvFld (NdePosTransInvoice.childNodes[CntItem],
                                  StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransInvoice (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransInvoice', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOPosTransaction.ProcessPosTransInvoice

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransInvFld : Processes one field of the
//    POSTransInvoice table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the
//                         value of the field that has to be added
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransInvFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransInvFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransInvoice', NdeXMLFld.Text);
end;  // of TXMLADOPosTransaction.ProcessPosTransInvFld

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransApproval :
//                                  -----
// INPUT  : Var = Explanation
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransApproval (
                                                  NdePosTransAppr : IXMLDOMNode;
                                                  CodActKind      : Integer);
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin // of TXMLADOPosTransaction.ProcessPosTransApproval
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransAppr.childNodes.length) do
      ProcessPosTransApprovalFld (NdePosTransAppr.childNodes[CntItem],
                                  StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransApproval (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransApproval', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOPosTransaction.ProcessPosTransApproval

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransApprovalFld :
//                                  -----
// INPUT  : Var = Explanation
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransApprovalFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransApprovalFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransApproval', NdeXMLFld.Text);
end;  // of TXMLADOPosTransaction.ProcessPosTransApprovalFld

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransDetApproval :
//                                  -----
// INPUT  : Var = Explanation
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransDetApproval (
                                               NdePosTransDetAppr : IXMLDOMNode;
                                               CodActKind         : Integer);
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin // of TXMLADOPosTransaction.ProcessPosTransDetApproval
  StrLstFields := TStringList.Create;
  try
    StrLstFields.Assign (StrLstKeys);
    for CntItem := 0 to Pred (NdePosTransDetAppr.childNodes.length) do
      ProcessPosTransDetApprovalFld (NdePosTransDetAppr.childNodes[CntItem],
                                     StrLstFields);
    case CodActKind of
      CtCodActKindInsert:
        DmdADODummy.InsertPOSTransDetApproval (StrLstFields);
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('PosTransDetApproval', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOPosTransaction.ProcessPosTransDetApproval

//=============================================================================
// TXMLADOPosTransaction.ProcessPosTransDetApprovalFld :
//                                  -----
// INPUT  : Var = Explanation
//=============================================================================

procedure TXMLADOPosTransaction.ProcessPosTransDetApprovalFld (
                                                    NdeXMLFld    : IXMLDOMNode;
                                                    StrLstFields : TStringList);
begin // of TXMLADOPosTransaction.ProcessPosTransDetApprovalFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'PosTransDetApproval',
                  NdeXMLFld.Text);
end;  // of TXMLADOPosTransaction.ProcessPosTransDetApprovalFld

//=============================================================================

procedure TXMLADOPosTransaction.ProcessXML (TxtXML: string);
begin // of TXMLADOPosTransaction.ProcessXML
  ObjXMLDoc.loadXML (TxtXML);
  if ObjXMLDoc.childNodes.Length = 0 then
    raise EInvalidOperation.Create ('Invalid XML statement');
  ProcessPosTransaction (ObjXMLDoc.firstChild,
                         GetCodeAction (ObjXMLDoc.FirstChild));
end;  // of TXMLADOPosTransaction.ProcessXML

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FXMLADOPosTransaction
