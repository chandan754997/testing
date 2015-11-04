//=Copyright 2003-2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint
// Unit     : RFpnTenderCA = Resources FlexPoiNt Tender CAstorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnTenderCA.pas,v 1.2 2006/12/22 09:45:25 NicoCV Exp $
// History :
// - Started from Castorama - FlexPoint 2.0 - RFpnTenderCA - CVS revision 1.2
// Version  Modified By    Reason
// 1.3      AS/RK (TCS)    R2013.1 - Applix 2676776 - CAFR - Header display issue 
// 1.4      AJ (TCS)    R2014.1 - Req(45040) - CARU - Payout Process  
//=============================================================================

unit RFpnTenderCA;

//*****************************************************************************

interface

//=============================================================================
// Specific identifiers for the Tender module of CASTORAMA
//=============================================================================

resourcestring  // Messages concerning IdtBag
  CtTxtBagAlreadyExists = 'The bag exists already';
  CtTxtBagInvalidLength = 'Bagnumber should be %s characters long';

var // Global identifiers
  ViValWidthIdtBag : Integer = 13;     // The number of characters for a bag

resourcestring  // Tables and identifiers for Tender
  CtTxtTblPayOrgan           = 'Payment organisation';
  CtTxtIdtPayOrgan           = 'Identification payment organisation';

  CtTxtTblSafeTransaction    = 'Safe transaction';
  CtTxtIdtSafeTransaction    = 'Number safe transaction';

  CtTxtTblTenderGroup        = 'Tendergroup';
  CtTxtIdtTenderGroup        = 'Number tendergroup';


resourcestring  // Kinds of operations in Tender count
  CtTxtPayIn               = 'Pay in';
  CtTxtPayOut              = 'Pay out';
  CtTxtRetPayIn            = 'Return Pay in';
  CtTxtTransferH           = 'Transfer';                                        // R2013.1V2-Applix 2676776-TCS(AS/RK)
  CtTxtTransfer            = 'Checkout -> Checkout';
  CtTxtTransferCM          = 'Money Checkout -> Checkout';
  CtTxtPayinC              = 'Safe -> Checkout(s)';
  CtTxtPayoutC             = 'Checkout(s) -> Safe';
  CtTxtCountCashdeskPI     = 'Transfer To';
  CtTxtCountCashdeskPO     = 'Transfer From';

resourcestring  // Registrating operator
  CtTxtOperReg     = 'Registrating operator';

resourcestring  // Registration for...
  CtTxtCashdesk    = 'Cashdesk';
  CtTxtOperator    = 'Operator';
  CtTxtSafe        = 'Safe';
  CtTxtCheckoutCM  = 'Money Checkout';
  CtTxtCheckoutCE  = 'Expense Checkout';

resourcestring  // Strings for transfer
  CtTxtTransferFromTo   = 'Transfer from %s (%s) to %s (%s)';
  CtTxtTransferCMTo     = 'Transfer from money checkout to %s (%s)';
  CtTxtMoneyCheckout    = 'MoneyCheckout';
  CtTxtFrom             = 'From';
  CtTxtTo               = 'To';

//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
resourcestring  // Strings for PayOut Report
  CtTxtOperatorResponsible = 'Pay Out Responsible';
  CtTxtPayOutReport        = 'Pay out Report';
  CtTxtPayOutDate          = 'Payout date';
  CtTxtCash                = 'Cash';
  CtTxtDrawer              = 'Drawer';
  CtTxtPayOutTitle         = 'Pay out';
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End

//=============================================================================

resourcestring  // Titles of global counted TenderGroups
  CtTxtHdrCashCurrency  = 'CASH other currencies';
  CtTxtHdrCountReceipt  = 'Other receipts';
  CtTxtHdrMeansOfPay    = 'Means of payment';
  CtTxtHdrNumber        = 'Number';

resourcestring  // Captions for labels, headers for columns on reports
  CtTxtHdrQtyUnit       = 'Number';
  CtTxtHdrValUnit       = 'Value';
  CtTxtHdrValAmount     = 'Amount';
  CtTxtHdrQtyTotal      = 'Total Number';
  CtTxtHdrValTotal      = 'Total Amount';
  CtTxtHdrRate          = 'Rate';
  CtTxtHdrValCurrency   = 'Amount %s';

  CtTxtHdrQtyTheor      = 'Number theor.';
  CtTxtHdrValTheor      = 'Amount theoretic';
  CtTxtHdrValTheorCurr  = 'Theoretic %s';

  CtTxtHdrValFixChange  = 'Fixed amount';
  CtTxtHdrValMaxChange  = 'Maximum amount';

  CtTxtHdrTotalCount    = 'Total count';
  CtTxtHdrTotalTheor    = 'Total theoretic';
  CtTxtHdrDifference    = 'Difference';

  CtTxtHdrDiffExplain   = 'Explanation';

resourcestring  // Captions for buttons
  CtTxtBtnAccept        = 'Accept';
  CtTxtBtnNewCount      = 'Restart counting';
  CtTxtBtnContCount     = 'Proceed counting';

resourcestring  // Hints for compontens
  CtTxtHintBtnDetail    = 'Show detail registration';

resourcestring  // Headers for reports
  CtTxtHdrRptCount      = 'Cashdesk report';
  CtTxtHdrExecBy        = 'Executed by';
  CtTxtHdrDatReg        = 'Registration on';
  CtTxtHdrChangeOnStart = 'On start';
  CtTxtHdrChangeForNext = 'For new';
  CtTxtHdrTotalDrawer   = 'Cashdesk';
  CtTxtHdrCountable     = 'Countable';
  CtTxtHdrNotCountable  = 'Not countable';
  CtTxtHdrInformative   = 'Informative';
  CtTxtHdrDetail        = 'Detail';
  CtTxtHdrSummaryCurr   = 'Summary other currencies';
  CtTxtHdrOverview      = 'Overview';
  CtTxtHdrType          = 'Type';

resourcestring  // Headers for informative data on count report
  CtTxtHdrQtyArt        = 'Number articles';
  CtTxtHdrQtyCust       = 'Number customers';
  CtTxtHdrValSales      = 'Total value';
  CtTxtHdrDiscount      = 'Discount';

resourcestring  // Headers for agreements on reports
  CtTxtAgreeOperator    = 'Agreement Operator';
  CtTxtAgreeManager     = 'Agreement Manager';

//=============================================================================

resourcestring  // Warnings
  CtTxtWmUnableToAccept = 'It is not possible to accept the amount for %s';
  CtTxtWmCountDiff      = 'There is a difference between the counted amount ' +
                          'and the theoretic amount of %s !';
  CtTxtWmMaxAttempts    = 'Counting again is not possible, the maximum number '+
                          'attempted counts has been reached.';
  CtTxtWmExceedsTheor   = 'The total amount exceeds the theoretic amout !';
  CtTxtWmExceedsMax     = 'The total amount exceeds the maximum amount !';
  CtTxtWmFixedDiff      = 'The total amount must be equal to the fixed amount!';
  CtTxtWmExplainDiff    = 'Enter an explanation for the differences';

resourcestring  // Errormessages
  CtTxtEmNotAMultiple        = '%f is not a multiple of %f';
  CtTxtEmCannotExec          = 'It is not possible to execute the applicaton.';
  CtTxtEmNoTenderGroup       = 'No TenderGroups found to process';
  CtTxtEmNoSafeTransType     = 'No SafeTransaction found for type %s';
  CtTxtEmNoDrawerData        = 'There is no registered data available ' +
                               'for %s %s !';
  CtTxtEmLoggedOn            = 'Operator %s is still logged on on cashdesk %d';
  CtTxtEmGenerateReport      = 'Unable to generate the report';
  CtTxtEmSaveReport          = 'Unable to save the report';

//*****************************************************************************

implementation

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'RFpnTenderCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/RFpnTenderCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2013/04/17 03:11:25 $';


//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of RFpnTender
