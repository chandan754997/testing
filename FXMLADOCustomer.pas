//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint
// Unit   : FXMLADOCustomer : processes XML-string to DB for Customers
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOCustomer.pas,v 1.2 2009/09/21 16:00:44 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOCustomer - CVS revision 1.2
//=============================================================================

unit FXMLADOCustomer;

//*****************************************************************************

interface

uses
  Classes, MSXML_TLB, FXMLADOGeneral, Windows;

//=============================================================================
// Initialized variables
//=============================================================================

var // Message names
  ViTxtCustCardMessage  : string = 'CustCard';
  ViTxtCustomerMessage  : string = 'Customer';


//*****************************************************************************
// TXMLADOCustomer
//*****************************************************************************

type
  TXMLADOCustomer = class (TXMLADOGeneral)
  protected
    procedure ProcessCustomer (NdeCustomer : IXMLDOMNode;
                               CodActKind  : Integer);
    procedure ProcessCustCard (NdeCustCard : IXMLDOMNode;
                               CodActKind  : Integer);
  public
    procedure ProcessXML (TxtXML: string); override;
  end;  // of TXMLADOCustomer

var
  XMLADOCustomer: TXMLADOCustomer;

implementation

uses
  SfDialog,
  SysUtils,

  DFpnADOCustomerCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOCustomer';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOCustomer.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 16:00:44 $';

//*****************************************************************************
// Implementation of TXMLADOCustomer
//*****************************************************************************

procedure TXMLADOCustomer.ProcessCustCard (NdeCustCard   : IXMLDOMNode;
                                        CodActKind    : Integer);
var
  NumCard          : string;           // Card Number
  QtyPntAcquire    : Integer;          // Points Acquired
  QtyPntExchange   : Integer;          // Points Exchanged
  CntItem          : Integer;          // Index for loop
begin // of TXMLADOCustomer.ProcessCustCard
  if CodActKind = CtCodActKindUpdate then begin
    NumCard := '';
    QtyPntAcquire := 0;
    QtyPntExchange := 0;
    for CntItem := 0 to Pred (NdeCustCard.childNodes.length) do begin
      if AnsiCompareText (NdeCustCard.ChildNodes[CntItem].nodeName, 'NumCard') = 0 then
        NumCard := NdeCustCard.ChildNodes[CntItem].Text
      else if AnsiCompareText (NdeCustCard.ChildNodes[CntItem].nodeName, 'QtyPntAcquire') = 0 then
        QtyPntAcquire := StrToInt (NdeCustCard.ChildNodes[CntItem].Text)
      else if AnsiCompareText (NdeCustCard.ChildNodes[CntItem].nodeName, 'QtyPntExchange') = 0 then
        QtyPntExchange := StrToInt (NdeCustCard.ChildNodes[CntItem].Text);
    end;
    if NumCard <> '' then begin
      if QtyPntAcquire <> 0 then
        DmdFpnADOCustomerCA.UpdatePntAcquire (NumCard, QtyPntAcquire);
      if QtyPntExchange <> 0 then
        DmdFpnADOCustomerCA.UpdatePntExchange (NumCard, QtyPntExchange);
    end;
  end
  else
    raise EInvalidOperation.Create ('Invalid Action for table ' +
                                    AnsiQuotedStr (ViTxtCustCardMessage, ''''));
end;  // of TXMLADOCustomer.ProcessCustCard

//=============================================================================

procedure TXMLADOCustomer.ProcessCustomer (NdeCustomer   : IXMLDOMNode;
                                           CodActKind    : Integer);
var
  IdtCustomer      : Integer;          // Card Number
  ValCredLim       : Currency;         // Points Acquired
  CntItem          : Integer;          // Index for loop
  Code             : integer;          // Code returned by Val ()
  ValDummy         : double;           // Dummy to receive ValCredLim
begin // of TXMLADOCustomer.ProcessCustomer
  if CodActKind = CtCodActKindUpdate then begin
    IdtCustomer := -1;
    ValCredLim := 0;
    for CntItem := 0 to Pred (NdeCustomer.childNodes.length) do begin
      if AnsiCompareText (NdeCustomer.ChildNodes[CntItem].nodeName,
                      'IdtCustomer') = 0 then
        IdtCustomer := StrToInt (NdeCustomer.ChildNodes[CntItem].Text)
      else if AnsiCompareText (NdeCustomer.ChildNodes[CntItem].nodeName,
                           'ValCredLim') = 0 then begin
        Val (NdeCustomer.ChildNodes[CntItem].Text, ValDummy, Code);
        ValCredLim := ValDummy;
      end;
    end;
    if IdtCustomer <> -1 then
      DmdFpnADOCustomerCA.UpdateCreditLim (IdtCustomer, ValCredLim);
  end
  else
    raise EInvalidOperation.Create ('Invalid Action for table ' +
                                    AnsiQuotedStr (ViTxtCustCardMessage, ''''));
end;  // of TXMLADOCustomer.ProcessCustomer

//=============================================================================

procedure TXMLADOCustomer.ProcessXML (TxtXML: string);
begin // of TXMLADOCustomer.ProcessXML
  ObjXMLDoc.loadXML (TxtXML);
  if ObjXMLDoc.childNodes.Length = 0 then
    raise EInvalidOperation.Create ('Invalid XML statement');
  if AnsiCompareText (ObjXMLDoc.firstChild.nodeName,
                  ViTxtCustCardMessage) = 0 then
    ProcessCustCard (ObjXMLDoc.firstChild,
                     GetCodeAction (ObjXMLDoc.FirstChild))
  else if AnsiCompareText (ObjXMLDoc.firstChild.nodeName,
                       ViTxtCustomerMessage) = 0 then
    ProcessCustomer (ObjXMLDoc.firstChild,
                     GetCodeAction (ObjXMLDoc.FirstChild));
end;  // of TXMLADOCustomer.ProcessXML

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end. // of FXMLADOCustomer
