//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint
// Unit     : RFpnInvoiceCA = Resources FlexPoiNt INVOICE CAstorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnInvoiceCA.pas,v 1.2 2006/12/18 16:08:16 smete Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - RFpnInvoiceCA - CVS revision 1.1
//=============================================================================

unit RFpnInvoiceCA;

//*****************************************************************************

interface

//=============================================================================
// Specific identifiers for the Invoice module of CASTORAMA
//=============================================================================

resourcestring     // Resources to print on 'OCR' strip on invoice
  CtTxtInvStoreNumber   = 'Nr Store:';
  CtTxtInvCustNumber    = 'Nr Customer:';
  CtTxtInvCustName      = 'Name Customer:';
  CtTxtInvNum           = 'Nr Invoice:';
  CtTxtInvDate          = 'Date Invoice:';
  CtTxtInvDateExpiry    = 'Expiry date settlement:';
  CtTxtInvAmountCredit  = 'Amount:';

//*****************************************************************************

implementation

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'RFpnInvoiceCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnInvoiceCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 16:08:16 $';


//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of RFpnInvoiceCA
