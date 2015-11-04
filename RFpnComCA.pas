//=========== Sycron Computers Belgium (c) 1997 ===============================
// Packet   : FlexPoint
// Unit     : RFpnComCA = Resources FlexPoiNt COMmon CAstorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnComCA.pas,v 1.2 2008/02/13 10:55:20 NicoCV Exp $
// History :
//=============================================================================

unit RFpnComCA;                                                

//*****************************************************************************

interface

//=============================================================================
// Instalment : labels for printing
//=============================================================================

resourcestring
  CtTxtLblPrnInstAccount     = 'CARD:';
  CtTxtLblPrnInstLoanID      = 'LOAN ID:';
  CtTxtLblPrnInstLoanPeriod  = 'LOAN PERIOD:';
  CtTxtLblPrnInstLoanType    = 'TYPE:';

//=============================================================================
// Promopack : specific text (for use in several applications) for KingFisher
//=============================================================================

resourcestring
  CtTxtPromopackCoupAttributed    =
    'Attributed %u gift coupon(s) of %.2f %s - promotion %u';

//*****************************************************************************

implementation

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'RFpnComCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnComCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2008/02/13 10:55:20 $';

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of RFpnComCA
