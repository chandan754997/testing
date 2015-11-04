//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Castorama
// Unit   : FXMLADOSafeTransCA : XML SAFETRANSaction = processes XML-string to
//                               DB for a safetransaction
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOSafeTransCA.pas,v 1.3 2009/09/21 16:04:53 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOSafeTransCA - CVS revision 1.6
//=============================================================================

unit FXMLADOSafeTransCA;

//*****************************************************************************

interface

uses
  MSXML_TLB, ADODB, DFpnADOBagCA, Windows;

//*****************************************************************************
// TXMLADOSafeTransCA
//*****************************************************************************

type
  TXMLADOSafeTransCA = class
  protected
    IdtSafeTrans   : Integer;          // Identifier of running safe transaction
    NumSeq         : Integer;          // Sequence of transaction
    function GetLastNumSequenceForTrans (VIdtSafeTrans : Integer) : Integer;
                                                                        virtual;
    procedure ProcessSafeTransaction (NdeXML : IXMLDOMNode); virtual;
    procedure ProcessSafeTransDetail (NdeXML : IXMLDOMNode); virtual;
    procedure ProcessLstSafeTransaction (NdeXML : IXMLDOMNode); virtual;
  public
    procedure ProcessXML (TxtXML: string); virtual;
  end;  // of TXMLADOSafeTransCA

var
  XMLADOSafeTransCA: TXMLADOSafeTransCA;

implementation

uses
  Classes,
  SysUtils,
  SfDialog,
  DFpnADOSafeTransaction,
  DFpnADOSafeTransactionCA,
  FXMLADOGeneral,
  DFpnADOUtilsCA,
  StDate,
  StDatest,
  SmUtils,
  DFpnADOServiceMQ,
  MLogging;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOSafeTransCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOSafeTransCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 16:04:53 $';

//=============================================================================
// TXMLADOSafeTransCA.GetLastNumSequenceForTrans :
//                                  -----
// INPUT  : VIdtSafeVar = Transaction Id to find next numseq for
//                                  -----
// FUNCRES : Next Numsequence for the transaction
//=============================================================================

function TXMLADOSafeTransCA.GetLastNumSequenceForTrans (VIdtSafeTrans : Integer)
                                                                      : Integer;
begin  // of TXMLADOSafeTransCA.GetLastNumSequenceForTrans          ttimestamp
  Result := 1;
  if DmdFpnADOUtilsCA.QueryInfo ('SELECT MAX (NumSeq) NumMax' +
                            #10'FROM SafeTransaction TABLOCKX' +
                            #10'WHERE IdtSafeTransaction = ' +
                            IntToStr (VIdtSafeTrans)) then
    Result := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName ('NumMax').AsInteger + 1;
  DmdFpnADOUtilsCA.CloseInfo;
end;   // of TXMLADOSafeTransCA.GetLastNumSequenceForTrans

//=============================================================================
// TXMLADOSafeTransCA.ProcessLstSafeTransaction : Processes a complete
// safetransaction
//                                  -----
// INPUT  : NdeXML = XML that contains the transaction
//=============================================================================

procedure TXMLADOSafeTransCA.ProcessLstSafeTransaction (NdeXML : IXMLDOMNode);
var
  ObjChildNode     : IXMLDOMNode;      // Childnode with safetransaction
begin  // of TXMLADOSafeTransCA.ProcessLstSafeTransaction
  LstSafeTransaction := TLstSafeTransactionCA.Create;
  try
    ObjChildNode := NdeXML.firstChild;
    while Assigned (ObjChildNode) do begin
      if AnsiCompareText (ObjChildNode.nodeName, 'SafeTransaction') = 0 then
        ProcessSafeTransaction (ObjChildNode)
      else if AnsiCompareText (ObjChildNode.nodeName, 'SafeTransDetail') = 0 then
        ProcessSafeTransDetail (ObjChildNode);
      ObjChildNode := ObjChildNode.nextSibling;
    end;

    try
      DmdFpnADOSafeTransaction.InsertLstSafeTransaction (LstSafeTransaction);
      DmdFpnADOBagCA.UpdateLstBag (TLstSafeTransactionCA (LstSafeTransaction).LstBag,
                                                     ['IdtSafeTransaction']);
    except
      on E:Exception do begin
        DmdFpnServiceMQ.ExceptionHandler (Self, E);
      end;
    end;
  finally
    LstSafeTransaction.Free;
  end;
end;   // of TXMLADOSafeTransCA.ProcessLstSafeTransaction

//=============================================================================
// TXMLADOSafeTransCA.ProcessSafeTransaction : Process a record into the
// safetransaction table
//                                  -----
// INPUT  : NdeXML = the xml that contains the transaction
//=============================================================================

procedure TXMLADOSafeTransCA.ProcessSafeTransaction (NdeXML : IXMLDOMNode);
var
  ObjSafeTransaction: TObjSafeTransaction;   // Loaded safetransaction
  TxtDate          : string;           // Date string
  TxtTime          : string;           // Time string
  XMLNode          : IXMLDOMNode;      // Node with safetransaction
  TxtBag           : string;           // To use to get bags
  TxtBagKeyWord    : string;           // Bag keywords
  ObjBag           : TObjBagCA;        // bag object
  TxtDummy         : string;           // Left of splitstring
  NumIndex         : Integer;          // index of bag
  IdtOperator      : string;           // Operator Id for safetransaction
  IdtCheckout      : Integer;           // checkout Id for safetransaction
begin  // of TXMLADOSafeTransCA.ProcessSafeTransaction
  IdtOperator := NdeXML.selectSingleNode ('IdtOperator').text;
  try
    if Trim (IdtOperator) <> '' then begin
      if DmdFpnADOUtilsCA.QueryInfo
         ('SELECT IdtOperator FROM Operator WHERE IdtPos = ' + IdtOperator) then
        IdtOperator := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName ('IdtOperator').AsString;
    end;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
  IdtCheckout := StrToInt (NdeXML.SelectSingleNode ('IdtCheckout').text);
  if IdtOperator <> '' then begin
    IdtSafeTrans :=
      DmdFpnADOSafeTransaction.RetrieveRunningSafeTransOperator (IdtOperator);
  end
  else begin
    IdtSafeTrans :=
      DmdFpnADOSafeTransaction.RetrieveRunningSafeTransCashdesk (IdtCheckout);
  end;
  NumSeq := GetLastNumSequenceForTrans (IdtSafeTrans);
  ObjSafeTransaction :=
    LstSafeTransaction.AddSafeTransaction
     (IdtSafeTrans, NumSeq, StrToInt (NdeXML.SelectSingleNode ('CodType').text),
      CtCodDbsNew);

  XMLNode := NdeXML.SelectSingleNode ('CodReason');
  if Assigned (XMLNode) then
    ObjSafeTransaction.CodReason := XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('IdtCheckout');
  if Assigned (XMLNode) then
    ObjSafeTransaction.IdtCheckout := XMLNode.nodeTypedValue;

  if IdtOperator <> '' then
    ObjSafeTransaction.IdtOperator := IdtOperator;

  XMLNode := NdeXML.SelectSingleNode ('IdtOperReg');
  if Assigned (XMLNode) then
    ObjSafeTransaction.IdtOperReg := XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('DatReg');
  if Assigned (XMLNode) then begin
    SplitString (XMLNode.nodeTypedValue, ' ', TxtDate, TxtTime);
    if TxtDate > '' then
      ObjSafeTransaction.DatReg :=
        StDateToDateTime (DateStringToStDate (ViTxtISODateFormat,
                                              TxtDate, 1950));
    if TxtTime > '' then
      ObjSafeTransaction.DatReg := ObjSafeTransaction.DatReg +
        StTimeToDateTime (TimeStringToStTime (ViTxtISOTimeFormat,
                                              TxtTime));
  end;

  XMLNode := NdeXML.SelectSingleNode ('TxtExplanation');
  if Assigned (XMLNode) then
    ObjSafeTransaction.StrLstExplanation.Text:= XMLNode.nodeTypedValue;
  // Retrieve bags en place it
  if Assigned (XMLNode) then begin
    SplitString (CtTxtFmtExplBagCA, '=', TxtBagKeyWord, TxtDummy);
    NumIndex := ObjSafeTransaction.StrLstExplanation.IndexOfName(TxtBagKeyWord);
    while NumIndex > -1 do begin
      TxtBag := ObjSafeTransaction.StrLstExplanation.Strings [NumIndex];
      ObjSafeTransaction.StrLstExplanation.Delete (NumIndex);
      SplitString (TxtBag, '=', TxtDummy, TxtBag);
      SplitString (TxtBag, ';', TxtDummy, TxtBag);
      if TxtBag <> '' then begin
        try
          ObjBag:= TLstSafeTransactionCA (LstSafeTransaction).LstBag.AddBag
                                                           (IdtSafeTrans,
                                                            NumSeq,
                                                            StrToInt (TxtDummy),
                                                            CtCodDbsNew);
          ObjBag.IdtBag := TxtBag;
        except
        end;
      end;
      NumIndex :=
               ObjSafeTransaction.StrLstExplanation.IndexOfName (TxtBagKeyWord);
    end;
  end;

  XMLNode := NdeXML.SelectSingleNode ('IdtCurrency');
  if Assigned (XMLNode) then
    ObjSafeTransaction.IdtCurrency := XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('ValExchange');
  if Assigned (XMLNode) then
    ObjSafeTransaction.ValExchange := XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('FlgExchMultiply');
  if Assigned (XMLNode) then
    ObjSafeTransaction.FlgExchMultiply := XMLNode.nodeTypedValue <> False;

  XMLNode := NdeXML.SelectSingleNode ('IdtPayOrgan');
  if Assigned (XMLNode) then
    ObjSafeTransaction.IdtPayOrgan := XMLNode.nodeTypedValue;
end;   // of TXMLADOSafeTransCA.ProcessSafeTransaction

//=============================================================================
// TXMLADOSafeTransCA.ProcessSafeTransDetail : Process a record into the
// safetransDetail table
//                                  -----
// INPUT  : NdeXML = the xml that contains the detail safe transaction
//=============================================================================

procedure TXMLADOSafeTransCA.ProcessSafeTransDetail (NdeXML : IXMLDOMNode);
var
  ObjTransDetail    : TObjTransDetail;   // Safetransdetail object
  XMLNode           : IXMLDOMNode;       // XML Node
begin  // of TXMLADOSafeTransCA.ProcessSafeTransDetail
  ObjTransDetail :=
    LstSafeTransaction.AddTransDetail
      (IdtSafeTrans, NumSeq, 0,
       NdeXML.SelectSingleNode ('IdtTenderGroup').nodeTypedValue, CtCodDbsNew);

  XMLNode := NdeXML.SelectSingleNode ('FlgTransfer');
  if Assigned (XMLNode) then
    ObjTransDetail.FlgTransfer :=
      XMLNode.nodeTypedValue <> 0;

  XMLNode := NdeXML.SelectSingleNode ('TxtDescr');
  if Assigned (XMLNode) then
    ObjTransDetail.TxtDescr :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('QtyUnit');
  if Assigned (XMLNode) then
    ObjTransDetail.QtyUnit :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('ValUnit');
  if Assigned (XMLNode) then
    ObjTransDetail.ValUnit :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('QtyArticle');
  if Assigned (XMLNode) then
    ObjTransDetail.QtyArticle :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('QtyCustomer');
  if Assigned (XMLNode) then
    ObjTransDetail.QtyCustomer :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('ValDiscount');
  if Assigned (XMLNode) then
    ObjTransDetail.ValDiscount :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('IdtCurrency');
  if Assigned (XMLNode) then
    ObjTransDetail.IdtCurrency :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('ValExchange');
  if Assigned (XMLNode) then
    ObjTransDetail.ValExchange :=
      XMLNode.nodeTypedValue;

  XMLNode := NdeXML.SelectSingleNode ('FlgExchMultiply');
  if Assigned (XMLNode) then
    ObjTransDetail.FlgExchMultiply :=
      XMLNode.nodeTypedValue;
end;   // of TXMLADOSafeTransCA.ProcessSafeTransDetail

//=============================================================================
// TXMLADOSafeTransCA.ProcessXML : Process the XML passed
//                                  -----
// INPUT  : TxtXML = A safetransaction in XML format
//=============================================================================

procedure TXMLADOSafeTransCA.ProcessXML (TxtXML: string);
var
  ObjXMLDoc        : IXMLDOMDocument;  // XML document
begin  // of TXMLADOSafeTransCA.ProcessXML
  ObjXMLDoc := CoDOMDocument.Create;
  try
    ObjXMLDoc.loadXML (TxtXML);
    if ObjXMLDoc.childNodes.Length = 0 then
      raise EInvalidOperation.Create ('Invalid XML statement');
    ProcessLstSafeTransaction (ObjXMLDoc.firstChild);
  finally
    ObjXMLDoc := nil;
  end;
end;   // of TXMLADOSafeTransCA.ProcessXML

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
