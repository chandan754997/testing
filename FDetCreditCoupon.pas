//===== Copyright 2009 (c) Centric Retail Solutions. All rights reserved ======
// Packet  : Form for printing Castorama Report: Global Acomptes
// Customer: Castorama
// Unit    : FDetCreditCoupon.PAS : based on FDetGeneralCA (General
//                                  Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCreditCoupon.pas,v 1.5 2010/02/09 10:07:24 BEL\nclevers Exp $
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCreditCoupon.pas,v 1.6 2011/02/08 11:20:54 TCS\Sashi Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCreditCoupon.PAS - CVS revision 1.4
// History:
// Version     Modified By     Reason
// V 1.5       GG    (TCS)     R2012- R2011.2 defect 283 fix
// V 1.6       CP    (TCS)     Regression Fix R2012.1
// V 1.7       GG    (TCS)     R2012.1 Defect fix(29,30)
// V 1.8       SM    (TCS)     R2012.1 Defect fix 62
// V 1.9       SRM   (TCS)     R2013.1 Internal DefectFix 802
// V 2.0       SMB   (TCS)     R2013.1 Defect ALM 92 SMB
// V 2.1       Teesta(TCS)     R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes
// V 2.2       SRM   (TCS)     R2013.2.ALM Defect Fix 164.All OPCO.SRM.TCS
// V 2.3       SRM   (TCS)     R2014.1.ALM-DefectFix(35)-CAFR
// V 2.4       CP    (TCS)     R2014.1.ALM-DefectFix(35&53).CAFR
// v 2.5       MeD   (TCS)     R2014.1.ALM Defect Fix 99.CAFR
// v 2.6       SN    (TCS)     R2014.1.ALM Defect Fix 53.CAFR
// v 2.7       MeD   (TCS)     R2014.1.ALM Defect Fix(35&53).CAFR
//==============================================================================

unit FDetCreditCoupon;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, OvcBase, OvcEF, OvcPB,
  OvcPF, ScUtils, SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA,
  ExtDlgs;                                                                      //added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta

//*****************************************************************************
// Global definitions
//*****************************************************************************
const              // general to the form
  TxtSepExp           = ';';              // Seperator character of export

resourcestring        // of header
  CtTxtTitle          = 'Report global credit coupons';

resourcestring        // of errormessages
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtNoNumber       = 'Please enter a credit coupon Nr';
  CtTxtErrorHeader    = 'Incorrect Date';                                       //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta

resourcestring        // for general report labels
  CtTxtNoData         = 'No data found';
  CtTxtNotExist       = 'Unexisting credit coupon Nr';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtReportDate     = 'Report from %s to %s';
  CtTxtDetail         = 'List of mouvements';
  CtTxtGlobal         = 'List of credit coupons';
  CtTxtSelected       = 'Selected reporttype: ';
  CtTxtUnpaid         = 'Report of all unpaid credit coupons';
  CtTxtAll            = 'Report of all credit coupons';
  CtTxtDownPaymentNr  = 'Report of credit coupon Nr';
  CtTxtNbCredCoups    = 'Nb credit coupons:';
  CtTxtNotFound       = 'Nr credit coupon does not exist';
  CtTxtOutDCredCoup   = 'Outdated Credit Coupons';                              //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta

resourcestring        // of table header global report.
  CtTxtCredCoup       = 'Nr credit coupon';
  CtTxtDatOut         = 'Date out';
  CtTxtDatIn          = 'Date in';
  CtTxtValOut         = 'Amount out';
  CtTxtValIn          = 'Amount in';
  CtTxtOutDated       = 'OutDated';                                             //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CtTxtDatInBDFR      = 'Resumption date or expired';                           //R2014.1.ALM-DefectFix(35)-CAFR
  CtTxtSaldo          = 'Saldo';

//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
resourcestring        // of table header Get Back PC Outdated report.
  CtTxtDocNum         = 'Document No';
  CtTxtTransDate      = 'Transaction date';
  CtTxtTotal          = 'Total';
  CtTxtSubTotal       = 'S/Total';
  CtTxtPC             = 'PC';
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End

resourcestring        // of table header detail report.
  CtTxtDate           = 'Date';
  CtTxtMouvement      = 'Mouvement';
  CtTxtCashDesk       = 'CashDesk';
  CtTxtOperator       = 'Nr Operator';
  CtTxtTicket         = 'Nr Ticket';
  CtTxtAmount         = 'Amount';
//Defect 283 fixed GG(TCS) ::START
resourcestring   // of run parameters
  CtTxtBRFR           = '/VRFR=VRFR Mouvement Column for BDFR';
//Defect 283 fixed GG(TCS) ::END
  CtTxtExport         = '/VEXP=EXP export to excel';                            //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CtTxtCAFROutD       = '/VOUTD=OUTD Outdated functionality add';               //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
resourcestring   // of mouvements
  CtTxtRegistered     = 'Registered';
  CtTxtPayedBack      = 'Payed back';
  CtTxtCanceled       = 'Canceled';
  CtTxtReprisPC       = 'Repris PC';                                            //Defect 283 fixed GG(TCS)
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
resourcestring   // of export to excel parameters
  CtTxtPlace          = 'D:\sycron\transfertbo\excel';
  CtTxtExists         = 'File exists, Overwrite?';
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
//R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.Start
var
  FlgSubTotal: Boolean;
//R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.End
//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetCreditCoupon = class(TFrmDetGeneralCA)
    GbxCoupons: TGroupBox;
    RdbtnNotPayed: TRadioButton;
    RdbtnAll: TRadioButton;
    RdbtnDownPaymentNr: TRadioButton;
    RdbtnReprisPC: TRadioButton;                                                //Defect 283 fixed GG(TCS)
    EdtCreditCoupon: TEdit;
    ChkbxDetail: TCheckBox;
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    BtnExport: TSpeedButton;                                                    
    SavDlgExport: TSaveTextFileDialog;
    RdbtnReprisPCOutDated: TRadioButton;
    procedure BtnExportClick(Sender: TObject);
    procedure RdbtnReprisPCOutDatedClick(Sender: TObject);
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    procedure RdbtnReprisPCClick(Sender: TObject);                              // R2012.1 Defect 62 Fix (SM)
    procedure EdtCreditCouponKeyPress(Sender: TObject; var Key: Char);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Procedure ChangeStatusDownPaymentNr(Sender: TObject); virtual;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FlgDetailReport          : boolean;   // Print detail or global report
    NumCredCoups             : integer;   // Number of down payments
    ValOut                   : double;    // Value of expected down payments
    ValIn                    : double;    // Value of real down payment
    ValSaldo                 : double;    // Value of saldo
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    FFlgBRFR                 : boolean; // Defect 283 fixed GG(TCS)
    FFlgExport               : boolean; // Flag to export
    FFlgOutDate              : boolean; // Flag to implement new outdated func
    FlgReprisePCOutdated     : boolean;
    NumCredCoupsSub          : integer; // Sub total (Number of down payments)
    ValOutDatedIn            : double;  // Total of outdated coupon
    ValInSub                 : double;  // Sub total(Value of real down payment)
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  protected
    // Formats of the rapport
    function GetFmtTableHeader       : string; override;
    function GetFmtTableBody         : string; override;
    function GetTxtTableTitle        : string; override;
    function GetTxtTitRapport        : string; override;
    function GetTxtRefRapport        : string; override;
    function BuildSQLStatementGlobal : string; virtual;
    function DetermineDateType       : string; virtual;
    function BuildSQLStatementDetail : string; virtual;
    function DetermineMouvementType  : string; virtual;
    procedure ResetValues; virtual;
    procedure CalculateValues; virtual;
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    procedure ResetSubValues; virtual;
    procedure CalculateSubValues; virtual;
    procedure PrintSubTotalGlobal; virtual;
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    procedure BeforeCheckRunParams; override;                                   //Defect 283 fixed GG(TCS)
    procedure CheckAppDependParams (TxtParam : string); override;               //Defect 283 fixed GG(TCS)
  public
    { Public declarations }
    procedure Execute; override;
    procedure PrintHeader; override;
    procedure PrintTableBodyGlobal; virtual;
    procedure PrintTableBodyDetail; virtual;
    procedure PrintTotalGlobal; virtual;
    Procedure PrintTotalRepriPCOutGlobal;virtual;                               //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    property FlgBRFR: boolean read FFlgBRFR write FFlgBRFR;                     //Defect 283 fixed GG(TCS)
    property FlgExport: boolean read FFlgExport write FFlgExport;               //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    property FlgOutDate: boolean read FFlgOutDate write FFlgOutDate;            //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  end;

var
  FrmDetCreditCoupon: TFrmDetCreditCoupon;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCreditCoupon.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.1 $';
  CtTxtSrcDate    = '$Date: 2014/05/27 10:07:24 $';

//******************************************************************************
// Implementation of TFrmDetCreditCoupon
//******************************************************************************

function TFrmDetCreditCoupon.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCreditCoupon.GetFmtTableHeader
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    for CntFmt := 0 to 3 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
  end
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  else if FlgReprisePCOutdated then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (15)]);
  end
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  else
  begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    //Defect 283 fixed GG(TCS) ::START
    If FlgBRFR then
    Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (10)]);                        //R2013.1Internal DefectFix (802) SRM (TCS)
    //Defect 283 fixed GG(TCS) ::END
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    if FlgOutDate then begin
      for CntFmt := 0 to 3 do
        Result := Result + TxtSep +
                  Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                   FrmVsPreview.ColumnWidthInTwips (15)]);
    end
    else begin
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
      for CntFmt := 0 to 2 do
        Result := Result + TxtSep +
                  Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                   FrmVsPreview.ColumnWidthInTwips (20)]);
    end;                                                                        //end added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  end;
end;   // of TFrmDetCreditCoupon.GetFmtTableHeader

//==============================================================================

function TFrmDetCreditCoupon.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCreditCoupon.GetFmtTableBody
  if FlgDetailReport then begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    for CntFmt := 0 to 2 do
      Result := Result + TxtSep +
                Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
                 FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignRight,
               FrmVsPreview.ColumnWidthInTwips (20)]);
  end
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  else if FlgReprisePCOutdated then begin
    //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.Start
    if FlgSubTotal then
      Result := Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (20)])
    else
      Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    if FlgSubTotal then
      Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignRight,
              FrmVsPreview.ColumnWidthInTwips (25)])
    else
      Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (25)]);
    //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.End
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignRight,
              FrmVsPreview.ColumnWidthInTwips (15)]);
  end
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  else
  begin
    Result := Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignHCenter,
              FrmVsPreview.ColumnWidthInTwips (20)]);
    //Defect 283 fixed GG(TCS) :: Start
    If FlgBRFR then
    Result := Result + TxtSep +
              Format ('%s%d', [FrmVsPreview.FormatAlignLeft,
              FrmVsPreview.ColumnWidthInTwips (10)]);                           //R2013.1Internal DefectFix (802) SRM (TCS)
    //Defect 283 fixed GG(TCS) :: End
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    if FlgOutDate then begin
      for CntFmt := 0 to 3 do
        Result := Result + TxtSep +
                  Format ('%s%d', [FrmVsPreview.FormatAlignRight,
                   FrmVsPreview.ColumnWidthInTwips (15)]);
    end
    else begin
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
      for CntFmt := 0 to 2 do
        Result := Result + TxtSep +
                  Format ('%s%d', [FrmVsPreview.FormatAlignRight,
                   FrmVsPreview.ColumnWidthInTwips (20)]);
    end;                                                                        //end added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  end;
end;   // of TFrmDetCreditCoupon.GetFmtTableBody

//==============================================================================

function TFrmDetCreditCoupon.GetTxtTableTitle : string;
begin  // of TFrmDetCreditCoupon.GetTxtTableTitle
  if FlgDetailReport then
    Result := CtTxtDate + TxtSep + CtTxtMouvement + TxtSep + CtTxtCashDesk +
              TxtSep + CtTxtOperator + TxtSep + CtTxtTicket + TxtSep +
              CtTxtAmount
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  else if (RdbtnReprisPCOutDated.Checked) then
    Result := CtTxtDocNum + TxtSep + CtTxtTransDate + TxtSep + CtTxtAmount
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  else
  //Defect 283 fixed GG(TCS) :: Start
   If FlgBRFR then
    Result := CtTxtCredCoup + TxtSep + CtTxtDatOut + TxtSep + CtTxtDatIn +
              TxtSep + CtTxtMouvement +
              TxtSep + CtTxtValOut + TxtSep + CtTxtValIn + Txtsep + CtTxtSaldo
   //Defect 283 fixed GG(TCS) :: End
   //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
   else if FlgOutDate then
     Result := CtTxtCredCoup + TxtSep + CtTxtDatOut + TxtSep + CtTxtDatInBDFR + //R2014.1.ALM-DefectFix(35)-CAFR
              TxtSep + CtTxtValOut + TxtSep + CtTxtValIn + TxtSep + CtTxtOutDated +
              Txtsep + CtTxtSaldo
   //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
   else
    Result := CtTxtCredCoup + TxtSep + CtTxtDatOut + TxtSep + CtTxtDatIn +
              TxtSep + CtTxtValOut + TxtSep + CtTxtValIn + Txtsep + CtTxtSaldo;
end;   // of TFrmDetCreditCoupon.GetTxtTableTitle)

//==============================================================================

function TFrmDetCreditCoupon.GetTxtTitRapport : string;
begin  // of TFrmDetCreditCoupon.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCreditCoupon.GetTxtTitRapport

//==============================================================================

function TFrmDetCreditCoupon.GetTxtRefRapport : string;
begin  // of TFrmDetCreditCoupon.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0035';
end;   // of TFrmDetCreditCoupon.GetTxtRefRapport

//=============================================================================

function TFrmDetCreditCoupon.BuildSQLStatementGlobal : string;
begin  // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
 //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
  if RdbtnNotPayed.Checked then begin
    Result :=
#10'SELECT G1.IdtCredCoup, DatOut = MIN(G1.DatOut), DatIn = ' +
#10'MAX(G1.DatIn), ValOut = SUM(G1.ValOut), ValIn = SUM(G1.ValIn),' +
#10'Saldo = SUM(G1.ValOut) - SUM(G1.ValIn),MAX(TxtChcLong) ' +
#10'AS TxtChcLong,MAX(CodType) as CodType FROM ' +
#10'( ' +
//To select the emmited records that is not expired or used
#10'SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
#10'MIN(G2.DatTransBegin), DatIn = NULL, ValOut = ' +
#10'Max(G2.ValAmount), ValIn = 0,MIN(TxtChcLong) AS TxtChcLong' +
#10'FROM GlobalCredCoup AS G2' +
#10'Inner Join Applicdescr on' +
#10'G2.Codtype =Applicdescr.txtfldcode' +
#10'and txttable = ''Globalcredcoup''' +
#10'WHERE G2.CodType = 0 ' +
#10'AND G2.IdtCredCoup NOT IN (SELECT IdtCredCoup FROM GLOBALCREDCOUP' +
#10'WHERE CODTYPE in (1,3))';
    Result := Result + DetermineDateType;
       Result := Result +
#10'GROUP BY G2.IdtCredCoup, G2.CodType ' +

#10'UNION ' +
//To select the emmited records that is not used
#10'SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
#10'MIN(G2.DatTransBegin), DatIn = NULL, ValOut = ' +
#10'Max(G2.ValAmount), ValIn = 0,MIN(TxtChcLong) AS TxtChcLong ' +
#10'FROM GlobalCredCoup AS G2 ' +
#10'Inner Join Applicdescr on ' +
#10'G2.Codtype =Applicdescr.txtfldcode ' +
#10'and txttable = ''Globalcredcoup''' +
#10'WHERE G2.CodType = 0 ' +
#10'AND G2.IdtCredCoup NOT IN (SELECT IdtCredCoup FROM GLOBALCREDCOUP' +
#10'WHERE CODTYPE in (1))' ;
    Result := Result + DetermineDateType;
       Result := Result +
#10'GROUP BY G2.IdtCredCoup, G2.CodType' +

#10'UNION ' +
// To select the expired records */
#10'SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
#10'NULL, DatIn = MAX(G2.DatTransBegin), ValOut = 0, ' +
#10'ValIn = Max(G2.ValAmount),MIN(TxtChcLong) AS TxtChcLong ' +
#10'FROM GlobalCredCoup AS G2 ' +
#10'Inner Join Applicdescr on ' +
#10'G2.Codtype =Applicdescr.txtfldcode ' +
#10'and txttable = ''Globalcredcoup''' +
#10'WHERE G2.CodType = 3 ' ;
    Result := Result + DetermineDateType;
       Result := Result +
#10'GROUP BY G2.IdtCredCoup, G2.CodType' +

#10') AS G1 ' +
#10'GROUP BY G1.IdtCredCoup ';


// select * from GlobalCredCoup
end
  else if RdbtnAll.Checked then begin
      Result :=
      #10'SELECT G1.IdtCredCoup, DatOut = MIN(G1.DatOut), DatIn = ' +
       #10'MAX(G1.DatIn), ValOut = SUM(G1.ValOut), ValIn = SUM(G1.ValIn),' +
       #10'Saldo = SUM(G1.ValOut) - SUM(G1.ValIn),MAX(TxtChcLong) AS TxtChcLong,' +
       #10'MAX(CodType) as CodType' +
       #10' FROM (SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
             #10'MIN(G2.DatTransBegin), DatIn = NULL, ValOut = ' +
             #10'SUM(G2.ValAmount), ValIn = 0,MIN(TxtChcLong) AS TxtChcLong' +
      #10'FROM GlobalCredCoup AS G2' +
      #10'Inner Join Applicdescr on' +
      #10'G2.Codtype =Applicdescr.txtfldcode' +
      #10'and txttable = ''Globalcredcoup''' +
      #10'WHERE G2.CodType = 0 ';
    Result := Result + DetermineDateType;
       Result := Result +
      #10'GROUP BY G2.IdtCredCoup, G2.CodType ' +
      #10'UNION ' +
      #10'SELECT G3.IdtCredCoup, G3.CodType, DatOut = NULL,' +
             #10'DatIn = MAX(G3.DatTransBegin), ValOut = 0,' +
             #10'ValIn = SUM(G3.ValAmount),MIN(TxtChcLong) AS TxtChcLong' +
      #10'FROM GlobalCredCoup AS G3 ' +
      #10'Inner Join Applicdescr on' +
      #10'G3.Codtype =Applicdescr.txtfldcode ' +
      #10'and txttable = ''Globalcredcoup''' +
      #10'and idtlanguage =(select idtlanguage from language where flgmain = 1)' +
      #10'WHERE G3.CodType IN (1,2,3)' ;
    Result := Result + DetermineDateType;
       Result := Result +
      #10'GROUP BY G3.IdtCredCoup, G3.CodType) AS G1' +
      #10'GROUP BY G1.IdtCredCoup' +
      #10'ORDER BY G1.DatIn DESC,G1.IdtCredCoup ';
   end
   else if RdbtnReprisPCOutDated.Checked then begin
       Result :=
       #10' SELECT G1.IdtCredCoup, DatOut = MIN(G1.DatOut), DatIn = ' +
       #10' MAX(G1.DatIn), ValOut = SUM(G1.ValOut), ValIn = SUM(G1.ValIn), ' +
       #10' Saldo = SUM(G1.ValOut) - SUM(G1.ValIn),MAX(TxtChcLong)' +
       #10' AS TxtChcLong,MAX(CodType) as CodType' +
       #10'FROM (SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
             #10' MIN(G2.DatTransBegin), DatIn = NULL, ValOut = ' +
             #10' SUM(G2.ValAmount), ValIn = 0,MIN(TxtChcLong) AS TxtChcLong  ' +
      #10' FROM GlobalCredCoup AS G2' +
      #10' Inner Join Applicdescr on ' +
      #10' G2.Codtype =Applicdescr.txtfldcode' +
      #10' and txttable = ''Globalcredcoup''' +
      #10' WHERE G2.CodType = 0 ';
    Result := Result + DetermineDateType;
       Result := Result +
      #10' GROUP BY G2.IdtCredCoup, G2.CodType' +
      #10' UNION ' +
      #10' SELECT G3.IdtCredCoup, G3.CodType, DatOut = NULL, ' +
             #10' DatIn = MAX(G3.DatTransBegin), ValOut = 0,' +
             #10' ValIn = SUM(G3.ValAmount),MIN(TxtChcLong) AS TxtChcLong ' +
      #10' FROM GlobalCredCoup AS G3 ' +
      #10' Inner Join Applicdescr on ' +
      #10' G3.Codtype =Applicdescr.txtfldcode ' +
      #10' and txttable = ''Globalcredcoup'' ' +
      #10' and idtlanguage =(select idtlanguage from language where flgmain = 1)' +
      #10' WHERE G3.CodType IN (1,2,3)' ;
      Result := Result + DetermineDateType;
       Result := Result +
      #10' GROUP BY G3.IdtCredCoup, G3.CodType) AS G1' +
#10' GROUP BY G1.IdtCredCoup ' +
#10' ORDER BY G1.DatIn DESC,G1.IdtCredCoup';
   end
    else if RdbtnDownPaymentNr.Checked then begin
      Result :=
    #10'SELECT G1.IdtCredCoup, DatOut = MIN(G1.DatOut), DatIn = ' +
      #10' MAX(G1.DatIn), ValOut = SUM(G1.ValOut), ValIn = SUM(G1.ValIn),' +
      #10' Saldo = SUM(G1.ValOut) - SUM(G1.ValIn),MAX(TxtChcLong) AS TxtChcLong,MAX(CodType) as CodType ' +
       #10' FROM (SELECT G2.IdtCredCoup, G2.CodType, DatOut = ' +
             #10'MIN(G2.DatTransBegin), DatIn = NULL, ValOut = ' +
             #10'SUM(G2.ValAmount), ValIn = 0,MIN(TxtChcLong) AS TxtChcLong' +
      #10'FROM GlobalCredCoup AS G2 ' +
      #10'Inner Join Applicdescr on ' +
      #10'G2.Codtype =Applicdescr.txtfldcode ' +
      #10'and txttable = ''Globalcredcoup''' +
      #10'WHERE G2.CodType = 0 ' +
      #10'GROUP BY G2.IdtCredCoup, G2.CodType ' +
      #10'UNION ' +
      #10'SELECT G3.IdtCredCoup, G3.CodType, DatOut = NULL,' +
            #10' DatIn = MAX(G3.DatTransBegin), ValOut = 0,' +
             #10'ValIn = SUM(G3.ValAmount),MIN(TxtChcLong) AS TxtChcLong ' +
      #10'FROM GlobalCredCoup AS G3 ' +
      #10'Inner Join Applicdescr on ' +
      #10'G3.Codtype =Applicdescr.txtfldcode' +
      #10'and txttable = ''Globalcredcoup''' +
      #10'and idtlanguage =(select idtlanguage from language where flgmain = 1)' +
     #10' WHERE G3.CodType IN (1,2,3) ' +
     #10' GROUP BY G3.IdtCredCoup, G3.CodType) AS G1 ' +
     #10'  WHERE G1.IdtCredCoup = ' + AnsiQuotedStr(EdtCreditCoupon.Text, '''') +
     #10'GROUP BY G1.IdtCredCoup ' +
     #10'ORDER BY G1.IdtCredCoup';
  end
  //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
end;   // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
//=============================================================================

function TFrmDetCreditCoupon.DetermineDateType : string;
begin  // of TFrmDetCreditCoupon.DetermineDateType
  if RbtDateDay.Checked then
    Result :=
      #10'AND DatTransBegin BETWEEN ' +
      AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
      AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''')
    else
      Result :=
      #10'AND DatTransBegin BETWEEN ' +
      AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
      AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1)+
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
end;   // of TFrmDetCreditCoupon.DetermineDateType

//=============================================================================

function TFrmDetCreditCoupon.BuildSQLStatementDetail : string;
begin  // of TFrmDetCreditCoupon.BuildSQLStatementGlobal
  Result :=
    #10'SELECT DatTransBegin, AD.TxtChcLong, IdtCheckOut,' +
    #10'       IdtOperator,  IdtPosTransaction, ValAmount' +
    #10'FROM GlobalCredCoup' +
    #10'  LEFT OUTER JOIN ApplicConv AS AC' +
    #10'    ON AC.IdtApplicConv = ' + AnsiQuotedStr('CodType', '''') +
    #10'    AND AC.TxtTable = ' + AnsiQuotedStr('GlobalCredCoup', '''') +
    #10'    AND AC.TxtFldCode = CodType' +
    #10'  LEFT OUTER JOIN ApplicDescr AS AD' +
    #10'    ON AD.IdtApplicConv = AC.IdtApplicConv' +
    #10'    AND AD.TxtTable = AC.TxtTable' +
    #10'    AND AD.TxtFldCode = AC.TxtFldCode' +
    #10'    AND AD.IdtLanguage = ' +
                AnsiQuotedStr(DmdFpnUtils.IdtLanguageTradeMatrix, '''') +
    #10'WHERE CodType = 0' +
    #10'AND IdtCredCoup = ' + AnsiQuotedStr(EdtCreditCoupon.Text, '''') +
    #10'UNION' +
    #10'SELECT DatTransBegin, AD.TxtChcLong, IdtCheckOut,' +
    #10'       IdtOperator,  IdtPosTransaction, ValAmount' +
    #10'FROM GlobalCredCoup' +
    #10'  LEFT OUTER JOIN ApplicConv AS AC' +
    #10'    ON AC.IdtApplicConv = ' + AnsiQuotedStr('CodType', '''') +
    #10'    AND AC.TxtTable = ' + AnsiQuotedStr('GlobalCredCoup', '''') +
    #10'    AND AC.TxtFldCode = CodType' +
    #10'  LEFT OUTER JOIN ApplicDescr AS AD' +
    #10'    ON AD.IdtApplicConv = AC.IdtApplicConv' +
    #10'    AND AD.TxtTable = AC.TxtTable' +
    #10'    AND AD.TxtFldCode = AC.TxtFldCode' +
    #10'    AND AD.IdtLanguage = ' +
                AnsiQuotedStr(DmdFpnUtils.IdtLanguageTradeMatrix, '''') +
    #10'WHERE CodType IN (1,2,3)' +                                             //Defect 283 fixed GG(TCS)
    #10'AND IdtCredCoup = ' + AnsiQuotedStr(EdtCreditCoupon.Text, '''');
end;   // of TFrmDetCreditCoupon.BuildSQLStatementDetail

//==============================================================================

procedure TFrmDetCreditCoupon.Execute;
begin  // of TFrmDetCreditCoupon.Execute
  ResetValues;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  if FlgDetailReport then begin
    PrintTableBodyDetail;
  end
  else begin
    PrintTableBodyGlobal;
  end;

  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetCreditCoupon.Execute
//==============================================================================
// TFrmDetGlobalAcomptes.PrintHeader : Print header of report
//==============================================================================

procedure TFrmDetCreditCoupon.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCreditCoupon.PrintHeader
  if FlgDetailReport or FlgReprisePCOutdated then                               //or FlgReprisePCOutdated added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    TxtHdr := TxtTitRapport + ': ' + CtTxtDetail + CRLF + CRLF
  else
    TxtHdr := TxtTitRapport + ': ' + CtTxtGlobal + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  if not RdbtnDownPaymentNr.Checked then                                        //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD
    TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
  if RdbtnNotPayed.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtUnpaid
  else if RdbtnAll.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtAll
  else if RdbtnDownPaymentNr.Checked then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtDownPaymentNr + ' ' +
              EdtCreditCoupon.Text
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  else if FlgReprisePCOutdated then
    TxtHdr := TxtHdr + CtTxtSelected + ' ' + CtTxtOutDCredCoup;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCreditCoupon.PrintHeader

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTableBodyGlobal : Print tablebody of global report
//==============================================================================

procedure TFrmDetCreditCoupon.PrintTableBodyGlobal;
var
  TxtPrintLine        : string;           // String to print
  TxtDate             : string;                                                 //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CodType          : integer;                                                   //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
begin  // of TFrmDetCreditCoupon.PrintTableBodyGlobal
  inherited;
  try
    ResetValues;
    ResetSubValues;                                                             //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    if DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal) then begin
      VspPreview.TableBorder := tbBoxColumns;
     //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
      if not FlgReprisePCOutdated then
        VspPreview.StartTable;
      //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
      while not DmdFpnUtils.QryInfo.Eof do begin
      //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.Start
		  if FlgReprisePCOutdated then begin
          VspPreview.StartTable;
          CodType := DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger;
          if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 3) then begin
            TxtPrintLine := DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString + TxtSep +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + TxtSep +
            FormatFloat (CtTxtFrmNumber, - DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat);
            TxtDate  :=  FormatDateTime (CtTxtDatFormat,
                       DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime);
			      CalculateSubValues;
            CalculateValues;
          end;
        end
        else
		      TxtPrintLine := DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString + TxtSep;
	      //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.End
        if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) and not FlgReprisePCOutdated then     //and not FlgReprisePCOutdated added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
          TxtPrintLine := TxtPrintLine + TxtSep
        else if not FlgReprisePCOutdated then                                   //if not FlgReprisePCOutdated added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
          TxtPrintLine := TxtPrintLine +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime) + TxtSep;
        if DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0 then
          TxtPrintLine := TxtPrintLine + TxtSep
        else if not FlgReprisePCOutdated then                                   //if not FlgReprisePCOutdated added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
          TxtPrintLine := TxtPrintLine +
            FormatDateTime (CtTxtDatFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + ' ' +
            FormatDateTime (CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + TxtSep;
          //Defect 283 fixed GG(TCS) ::START
        If FlgBRFR then
          TxtPrintLine := TxtPrintLine +
            DmdFpnUtils.QryInfo.FieldByName ('TxtChcLong').AsString + TxtSep;
          //Defect 283 fixed GG(TCS) ::END
        //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
        if not FlgReprisePCOutdated then begin
          if FlgOutDate then begin
            // Unused Credit Coupons
            if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 0) then
              TxtPrintLine := TxtPrintLine +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat) + TxtSep +
              '' + TxtSep +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
            // Outdated Credit Coupon
            else if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 3) then begin
              //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
              if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
                TxtPrintLine := TxtPrintLine +
                                '' + TxtSep +
                                '' + TxtSep +
                                FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
                                FormatFloat (CtTxtFrmNumber, 0)
              else if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
                TxtPrintLine := TxtPrintLine +
                                FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)
                                 + TxtSep +
                                '' + TxtSep +
                                '' + TxtSep +
                                FormatFloat (CtTxtFrmNumber, 0)
              else
              //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
			        TxtPrintLine := TxtPrintLine +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
              FormatFloat (CtTxtFrmNumber, 0);
            end
		        // Other than OutDated or Unused
            else begin
              //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
              if (DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0) then
              TxtPrintLine := TxtPrintLine +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat)
              + TxtSep +
              '' + TxtSep +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
              else if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
              TxtPrintLine := TxtPrintLine +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
             //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
              else
              TxtPrintLine := TxtPrintLine +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat) + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
              '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat);
            end;    //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD

          end
          else
            TxtPrintLine := TxtPrintLine +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat) + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat) + TxtSep +
              FormatFloat (CtTxtFrmNumber, DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat);
          VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                                 clWhite, False);
          CalculateValues;
        end
        else begin
          if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 3) then
            VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                                 clWhite, False);
        end;														//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
        DmdFpnUtils.QryInfo.Next;
        //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
        if FlgReprisePCOutdated then begin
          VspPreview.EndTable;
          //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.Start
          if ((CodType = 3) and (
          ((FormatDateTime(CtTxtDatFormat,DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime))<>TxtDate)
          or (DmdFpnUtils.QryInfo.Eof))) then begin
	          PrintSubTotalGlobal;
	          ResetSubValues;
	        end;
          //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP.End
        end;
        //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
      end;
      if not FlgReprisePCOutdated then                                          //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
        VspPreview.EndTable;
      if FlgReprisePCOutdated then
        PrintTotalRepriPCOutGlobal
      else
        PrintTotalGlobal;
    end
    else begin
      VspPreview.CurrentY := VspPreview.CurrentY + 250;
      VspPreview.TableBorder := tbNone;
      VspPreview.StartTable;
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False);
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCreditCoupon.PrintTableBodyGlobal

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTableBodyDetail : Print tablebody of global report
//==============================================================================

procedure TFrmDetCreditCoupon.PrintTableBodyDetail;
var
  TxtPrintLine        : string;           // String to print
begin  // of TFrmDetCreditCoupon.PrintTableBodyDetail
  inherited;
  try
    if DmdFpnUtils.QueryInfo (BuildSQLStatementDetail) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        TxtPrintLine :=
          FormatDateTime (CtTxtDatFormat, DmdFpnUtils.QryInfo.
          FieldByName ('DatTransBegin').AsDateTime) + ' ' + FormatDateTime
          (CtTxtHouFormat, DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').
          AsDateTime) + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtChcLong').
          AsString;
          // If CreditCoupon is outdated by PC (Daily Clouser) operator is '0'
          if (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsInteger = 0) then
            begin     //R2014.1.ALM Defect Fix 99.CAFR.MeD.TCS
            TxtPrintLine := TxtPrintLine + TxtSep + CtTxtPC + TxtSep + '' + TxtSep;
            //R2014.1.ALM Defect Fix 99.CAFR.MeD.TCS.Start
            TxtPrintLine := TxtPrintLine + TxtSep + FormatFloat (CtTxtFrmNumber,
            DmdFpnUtils.QryInfo.FieldByName ('ValAmount').AsFloat);
            end
            //R2014.1.ALM Defect Fix 99.CAFR.MeD.TCS.End
          else
            begin     //R2014.1.ALM Defect Fix 99.CAFR.MeD.TCS
            TxtPrintLine := TxtPrintLine + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').
            AsString + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString +          //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD
            TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtPostransaction').     //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD
            AsString;
            TxtPrintLine := TxtPrintLine + TxtSep + FormatFloat (CtTxtFrmNumber,
            DmdFpnUtils.QryInfo.FieldByName ('ValAmount').AsFloat);
            end;       //R2014.1.ALM Defect Fix 99.CAFR.MeD.TCS
          VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                               clWhite, False);
        DmdFpnUtils.QryInfo.Next;
      end;
      VspPreview.EndTable;
    end
    else begin
      VspPreview.CurrentY := VspPreview.CurrentY + 250;
      VspPreview.TableBorder := tbNone;
      VspPreview.StartTable;
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False);
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCreditCoupon.PrintTableBodyDetail

//==============================================================================
// TFrmDetGlobalAcomptes.PrintTotal: Print totals on Global report
//==============================================================================

procedure TFrmDetCreditCoupon.PrintTotalGlobal;
var
  TxtTotal      : string;
begin  // of TFrmDetCreditCoupon.PrintTotalGlobal
  If FlgBRFR then   //Defect ALM 92 SMB
    TxtTotal := CtTxtNbCredCoups + ' ' + IntToStr(NumCredCoups) + TxtSep + '' +
              TxtSep + '' + TxtSep + '' + TxtSep + FormatFloat (CtTxtFrmNumber, ValOut) + //Defect 283 fixed GG(TCS)
              TxtSep + FormatFloat (CtTxtFrmNumber, ValIn) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValSaldo)
  //Defect ALM 92 SMB Start
  else if not FlgReprisePCOutdated then begin                                         //if not FlgReprisePCOutdated then added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
      TxtTotal := CtTxtNbCredCoups + ' ' + IntToStr(NumCredCoups) + TxtSep + '' +
                TxtSep + '' + TxtSep + FormatFloat (CtTxtFrmNumber, ValOut)+
                TxtSep + FormatFloat (CtTxtFrmNumber, ValIn)+ TxtSep +
                FormatFloat (CtTxtFrmNumber, ValOutDatedIn) + TxtSep +
                FormatFloat (CtTxtFrmNumber, ValSaldo)
  end;
  //Defect ALM 92 SMB End
  VspPreview.CurrentY := VspPreview.CurrentY + 250;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtTotal, clWhite,
                       clWhite, False);
  VspPreview.TableCell[tcFontBold, 1, 1, 1, 8] := True;
  VspPreview.EndTable;
end;   // of TFrmDetCreditCoupon.PrintTotalGlobal
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
//==============================================================================
// TFrmDetGlobalAcomptes.PrintSubTotalGlobal: Print sub totals on Global report
//==============================================================================
procedure TFrmDetCreditCoupon.PrintTotalRepriPCOutGlobal;
var
  TxtTotal      : string;
begin
  if NumCredCoups = 0 then begin                                                //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
    VspPreview.CurrentY := VspPreview.CurrentY + 250;
    VspPreview.TableBorder := tbNone;
    VspPreview.StartTable;
    VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                         clWhite, False);
    VspPreview.EndTable;  
    Exit;
  end;

  TxtTotal := CtTxtTotal + TxtSep + IntToStr(NumCredCoups) + TxtSep +           //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
                FormatFloat (CtTxtFrmNumber, -ValOutDatedIn);
  VspPreview.CurrentY := VspPreview.CurrentY + 250;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtTotal, clWhite,
                       clWhite, False);
  VspPreview.TableCell[tcFontBold, 1, 1, 1, 8] := True;
  VspPreview.EndTable;
end;
//==============================================================================
// TFrmDetGlobalAcomptes.PrintSubTotalGlobal: Print sub totals on Global report
//==============================================================================
 procedure TFrmDetCreditCoupon.PrintSubTotalGlobal;
var
  TxtSubTotal      : string;
begin  // of TFrmDetCreditCoupon.PrintSubTotalGlobal
  FlgSubTotal:= True;                                                           //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
  if not FlgReprisePCOutdated and
     (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
    Exit;
  TxtSubTotal := CtTxtSubTotal + TxtSep + IntToStr(NumCredCoupsSub) + TxtSep +
                  FormatFloat (CtTxtFrmNumber, -ValInSub);
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtSubTotal, clWhite,
                         clGray, False);                                        //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
  VspPreview.TableCell[tcFont, 1, 1, 1, 8] := True;
  VspPreview.EndTable;
  FlgSubTotal:= False;                                                          //R2014.1.ALM-DefectFix(35&53).CAFR.TCS-CP
end;  // of TFrmDetCreditCoupon.PrintSubTotalGlobal
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
//==============================================================================
// TFrmDetGlobalAcomptes.DetermineMouvementType : Determine mouvement type
//==============================================================================

function TFrmDetCreditCoupon.DetermineMouvementType: string;
begin  // of TFrmDetGlobalAcomptes.DetermineMouvementType
  Case DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger of
    0: Result :=   CtTxtRegistered;
    1: Result :=   CtTxtPayedBack;
    2: Result :=   CtTxtCanceled;
    3: Result :=   CtTxtReprisPC;                                               //Defect 283 fixed GG(TCS)
  end;
end;   // of TFrmDetGlobalAcomptes.DetermineMouvementType

//==============================================================================
// TFrmDetGlobalAcomptes.ResetValues : Clear all total values
//==============================================================================

procedure TFrmDetCreditCoupon.ResetValues;
begin  // of TFrmDetGlobalAcomptes.ResetValues
  NumCredCoups    := 0;
  ValOut          := 0;
  ValIn           := 0;
  ValSaldo        := 0;
  ValOutDatedIn   := 0;															//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TFrmDetGlobalAcomptes.ResetValues
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
//==============================================================================
// TFrmDetGlobalAcomptes.ResetValues : Clear all sub total values
//==============================================================================
procedure TFrmDetCreditCoupon.ResetSubValues;
begin  // of TFrmDetCreditCoupon.ResetSubValues
  NumCredCoupsSub := 0;
  ValInSub        := 0;
end;  // of TFrmDetCreditCoupon.ResetSubValues
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
//==============================================================================
// TFrmDetGlobalAcomptes.CalculateValues : Calculate all total values
//==============================================================================

procedure TFrmDetCreditCoupon.CalculateValues;
begin  // of TFrmDetGlobalAcomptes.CalculateValues
  NumCredCoups    := NumCredCoups + 1;
  // Calculate outdated coupons value separately (CodType = 3) which should
  // only possible at CAFR
  if FlgOutDate then begin
    if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 3) then
      ValOutDatedIn  := ValOutDatedIn + StrToFloat(
                        DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsString)

    else
      ValIn         := ValIn + StrToFloat(
                        DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsString);
  end
  else
    ValIn         := ValIn + StrToFloat(
                        DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsString);
  ValOut        := ValOut + StrToFloat(
                      DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsString);
  //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
    if (DmdFpnUtils.QryInfo.FieldByName ('CodType').AsInteger = 3) then
        ValSaldo := 0
    else
  //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
        ValSaldo      := ValSaldo + StrToFloat(
                      DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsString);

end;   // of TFrmDetGlobalAcomptes.CalculateValues

//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
//==============================================================================
// TFrmDetGlobalAcomptes.CalculateSubValues : Calculate all sub total values
//==============================================================================
procedure TFrmDetCreditCoupon.CalculateSubValues;
begin  // of TFrmDetGlobalAcomptes.CalculateSubValues
  NumCredCoupsSub := NumCredCoupsSub + 1;
  ValInSub        := ValInsub + StrToFloat(
                     DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsString);
end;   // of TFrmDetGlobalAcomptes.CalculateSubValues
//=============================================================================
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End

procedure TFrmDetCreditCoupon.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetGlobalAcomptes.BtnPrintClick
  if RdbtnDownPaymentNr.Checked and ChkbxDetail.Checked then
    FlgDetailReport := True
  else
    FlgDetailReport := False;

  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if RdbtnReprisPCOutDated.Checked then
    FlgReprisePCOutdated := True
  else
    FlgReprisePCOutdated := False;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End

  if (not ItemsSelected) and (not RdbtnDownPaymentNr.Checked) then begin
      MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
      Exit;
  end;

  if RdbtnDownPaymentNr.Checked and (EdtCreditCoupon.Text = '') then begin
      MessageDlg (CtTxtNoNumber, mtWarning, [mbOK], 0);
      EdtCreditCoupon.SetFocus;
      Exit;
  end;

  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
      DtmPckDayTo.Date := Now;
      DtmPckLoadedTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
     FlgPreview := (Sender = BtnPreview);
     if FlgDetailReport then begin
       if not DmdFpnUtils.QueryInfo (BuildSQLStatementDetail) then begin
         MessageDlg (CtTxtNotExist, mtWarning, [mbOK], 0);
         EdtCreditCoupon.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;
     end
     else begin
       if not DmdFpnUtils.QueryInfo (BuildSQLStatementGlobal)
       and RdbtnDownPaymentNr.Checked then begin
         MessageDlg (CtTxtNotExist, mtWarning, [mbOK], 0);
         EdtCreditCoupon.Text := '';
         DmdFpnUtils.CloseInfo;
         exit;
       end;
     end;
     DmdFpnUtils.CloseInfo;
     Execute;
  end;
end;   // of TFrmDetGlobalAcomptes.BtnPrintClick

//=============================================================================

procedure TFrmDetCreditCoupon.FormCreate(Sender: TObject);
begin
  inherited;
  RdbtnNotPayed.Checked := True;
  DtmPckDayFrom.DateTime := now;
  EdtCreditCoupon.Text := '';
  //Defect 283 fixed GG(TCS) :: Start
  if not FlgBRFR and not FlgOutDate then  begin                                 //and not FlgOutDate added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
   FrmDetCreditCoupon.Height := 395;
   GbxCoupons.Height:= 129;
   RdbtnReprisPC.Visible:=False;
   RdbtnDownPaymentNr.Left:=16;
   RdbtnDownPaymentNr.Top:=80;
   EdtCreditCoupon.Top :=76;
   ChkbxDetail.Top:=104;
  end;
  //Defect 283 fixed GG(TCS) :: End
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgOutDate then
    RdbtnReprisPCOutDated.Visible:=True;
  if FlgExport then
    BtnExport.Visible := True;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
end;

//=============================================================================

procedure TFrmDetCreditCoupon.ChangeStatusDownPaymentNr(Sender: TObject);
begin
  // Enable textbox for number down payment and checkbox for detail report
  if Sender = RdbtnDownPaymentNr then begin
    // Disable date and operator selection
    DtmPckDayFrom.Enabled := False;
    DtmPckDayTo.Enabled := False;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    EdtCreditCoupon.Enabled := True;
    ChkbxDetail.Enabled := True;
    if FlgBRFR then
    ChkbxDetail.Checked := True;                                                //Defect 283 fixed GG(TCS)
    RbtDateLoaded.Enabled := False;
    RbtDateDay.Enabled := False;
  end
  else begin
    // Enable date and operator selection
    DtmPckDayFrom.Enabled := True;
    DtmPckDayTo.Enabled := True;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    EdtCreditCoupon.Enabled := False;
    ChkbxDetail.Enabled := False;
    ChkbxDetail.Checked := False;
    RbtDateLoaded.Enabled := True;
    RbtDateDay.Enabled := True;
    EdtCreditCoupon.Text := '';
  end;
end;

//=============================================================================

procedure TFrmDetCreditCoupon.FormActivate(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
  DtmSetDayFrom    : TDateTime;        // Variable to prevent date resetting after preview
begin
  inherited;
  DtmSetDayFrom := DtmPckDayFrom.DateTime;
  // Disable ChkLbxOperator and select all available operators
  AutoStart(Self);
  DtmPckDayFrom.DateTime := DtmSetDayFrom;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := True;
  ChkLbxOperator.Enabled := False;
  BtnSelectAll.Enabled := False;
  BtnDeSelectAll.Enabled := False;
  RbtDateDayClick(Self);
  Application.Title:=CtTxtTitle;                                                //Regression Fix R2012.1-CP(TCS)
end;

//=============================================================================

procedure TFrmDetCreditCoupon.EdtCreditCouponKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if Key in [chr(32)..chr(47)] + [chr(58)..chr(255)] then Key := #0
end;

//=============================================================================
//Defect 283 fixed GG(TCS) - Start
procedure TFrmDetCreditCoupon.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCreditCoupon.BeforeCheckRunParams
  inherited;
  // add param /VBQC to help
  SplitString(CtTxtBRFR, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  // add param /VEXP to help
  SplitString(CtTxtExport, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
  // add param /VOUTD to help
  SplitString(CtTxtCAFROutD, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
end; // of TFrmDetCreditCoupon.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCreditCoupon.CheckAppDependParams(TxtParam: string);
begin // of TFrmDetCreditCoupon.CheckAppDependParams
  if Copy(TxtParam, 3, 3) = 'BFR' then
    FlgBRFR := True
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  else if Copy(TxtParam, 3, 3)= 'EXP' then
    FlgExport := True
  else if Copy(TxtParam, 3, 4)= 'OUTD' then
    FlgOutDate := True
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  else
    inherited;
end; // of TFrmDetCreditCoupon.CheckAppDependParams

//Defect 283 fixed GG(TCS) - End
//==============================================================================
// R2012.1 Defect 62 Fix (SM) :: START
procedure TFrmDetCreditCoupon.RdbtnReprisPCClick(Sender: TObject);
begin
  inherited;
   DtmPckDayFrom.Enabled := True;
    DtmPckDayTo.Enabled := True;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    EdtCreditCoupon.Enabled := False;
    ChkbxDetail.Enabled := False;
    ChkbxDetail.Checked := False;
    RbtDateLoaded.Enabled := True;
    RbtDateDay.Enabled := True;
    EdtCreditCoupon.Text := '';
end;
// R2012.1 Defect 62 Fix (SM) :: END
//==============================================================================
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
procedure TFrmDetCreditCoupon.RdbtnReprisPCOutDatedClick(Sender: TObject);
begin
  inherited;
   DtmPckDayFrom.Enabled := True;
    DtmPckDayTo.Enabled := True;
    DtmPckLoadedFrom.Enabled := False;
    DtmPckLoadedTo.Enabled := False;
    EdtCreditCoupon.Enabled := False;
    ChkbxDetail.Enabled := False;
    ChkbxDetail.Checked := False;
    RbtDateLoaded.Enabled := True;
    RbtDateDay.Enabled := True;
    EdtCreditCoupon.Text := '';
    FlgReprisePCOutdated := True;
end;
//==============================================================================
procedure TFrmDetCreditCoupon.BtnExportClick(Sender: TObject);
var
  TxtTitles           : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;

begin // of TFrmDetAcomptesEtAvoirs.BtnExportClick
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  //set focus to other fields than on datefields
  QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SRM.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
     (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckDayTo.Date      := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date   := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date    := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then
        TxtWriteLine := TxtWriteLine + TxtSepExp
      else
        TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists, mtError, mbOKCancel, 0);
      if not FlgOK then
        Btnselect := mrOK;
    until Btnselect = mrOk;
    if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      try
        if  RdbtnDownPaymentNr.Checked and ChkbxDetail.Checked then begin
          if DmdFpnUtils.QueryInfo(BuildSQLStatementDetail) then begin
            TxtWriteLine := '';
            while not DmdFpnUtils.QryInfo.Eof do begin
            TxtWriteLine :=
            FormatDateTime (CtTxtDatFormat,
             DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime)+ ' '+
            FormatDateTime(CtTxtHouFormat,
            DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime)
              + TxtSepExp +
            DmdFpnUtils.QryInfo.FieldByName ('TxtChcLong').AsString;
            // If CreditCoupon is outdated by PC (Daily Clouser) operator is '0'
            if (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsInteger = 0) then
              TxtWriteLine := TxtWriteLine
                + TxtSepExp
                + CtTxtPC   + TxtSepExp
                + ''        + TxtSepExp
                + ''        + TxtSepExp
                + FormatFloat (CtTxtFrmNumber,
                  DmdFpnUtils.QryInfo.FieldByName ('ValAmount').AsFloat)
            else
              TxtWriteLine := TxtWriteLine
              + TxtSepExp + DmdFpnUtils.QryInfo.
                             FieldByName ('IdtCheckOut').AsString
              + TxtSepExp + DmdFpnUtils.QryInfo.
                             FieldByName ('IdtOperator').AsString
              + TxtSepExp + DmdFpnUtils.QryInfo.
                             FieldByName ('IdtPosTransaction').AsString
              + TxtSepExp + FormatFloat (CtTxtFrmNumber,
                        DmdFpnUtils.QryInfo.FieldByName ('ValAmount').AsFloat);
            WriteLn(F, TxtWriteLine);
            DmdFpnUtils.QryInfo.Next;
            end
          end;
          Exit
        end;  // of RdbtnDownPaymentNr.Checked...
        if DmdFpnUtils.QueryInfo(BuildSQLStatementGlobal) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            if RdbtnNotPayed.Checked or RdbtnAll.Checked then begin
              TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString
               + TxtSepExp ;
              if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
                TxtWriteLine := TxtWriteLine + ''
               + TxtSepExp
              else
                TxtWriteLine := TxtWriteLine + ' ' +
                FormatDateTime (CtTxtDatFormat,
                   DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime) + ' ' +
                FormatDateTime (CtTxtHouFormat,
                   DmdFpnUtils.QryInfo.FieldByName('DatOut').AsDateTime)
                + TxtSepExp ;
              if DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0 then
                TxtWriteLine := TxtWriteLine + ' ' + TxtSepExp
              else
                TxtWriteLine := TxtWriteLine +
                FormatDateTime (CtTxtDatFormat,
                  DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + ' ' +
                FormatDateTime (CtTxtHouFormat,
                  DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime)
                + TxtSepExp;
              if FlgOutDate then begin
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
                if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
                   TxtWriteLine := TxtWriteLine + ''
                                   + TxtSepExp
                else
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
                   TxtWriteLine := TxtWriteLine +
                                   FormatFloat (CtTxtFrmNumber,
                                   DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat)
                                   + TxtSepExp;
                // show outdated coupons in separate outdated column only.
                //  with other coupon status
                if (DmdFpnUtils.QryInfo.FieldByName('CodType').AsInteger = 3) then begin
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
                  if (DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0) then
                    TxtWriteLine := TxtWriteLine + '' + TxtSepExp + ''
                      + TxtSepExp +
                      FormatFloat (CtTxtFrmNumber,0)
                  else
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
                    TxtWriteLine := TxtWriteLine + '' + TxtSepExp +
                      FormatFloat (CtTxtFrmNumber,
                      DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)
                      + TxtSepExp +
                      FormatFloat (CtTxtFrmNumber,0)                            //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD
                  end
                else begin                                                      //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.Start
                  if (DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0) then
                    TxtWriteLine := TxtWriteLine + '' +
                      TxtSepExp + ''+ TxtSepExp +
                      FormatFloat (CtTxtFrmNumber,
                      DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
                  else
                //R2014.1.ALM-DefectFix(35).CAFR.TCS-MeD.End
                    TxtWriteLine := TxtWriteLine + FormatFloat (CtTxtFrmNumber,
                      DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)+
                      TxtSepExp + ''+ TxtSepExp +
                      FormatFloat (CtTxtFrmNumber,
                      DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat);
                end;
               end
              else
                TxtWriteLine := TxtWriteLine +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat)
                    + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)
                    + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat);
                  WriteLn(F, TxtWriteLine);
                  DmdFpnUtils.QryInfo.Next;
                end
            else if RdbtnReprisPCOutDated.Checked then begin
              if (DmdFpnUtils.QryInfo.
               FieldByName ('CodType').AsInteger = 3)then begin
                TxtWriteLine :=
                DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString
                + TxtSepExp +
                FormatDateTime (CtTxtDatFormat,
                DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime) + ' ' +
                FormatDateTime (CtTxtHouFormat,
                DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime)
                + TxtSepExp +
                FormatFloat (CtTxtFrmNumber,
                - DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat);
                WriteLn(F, TxtWriteLine);
              end;
              DmdFpnUtils.QryInfo.Next;
            end
            else if RdbtnDownPaymentNr.Checked then begin
                TxtWriteLine :=
                DmdFpnUtils.QryInfo.FieldByName ('IdtCredCoup').AsString
                + TxtSepExp ;
                if (DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime = 0) then
                  TxtWriteLine := TxtWriteLine + '' + TxtSepExp
                else
                  TxtWriteLine := TxtWriteLine + ' ' +
                  FormatDateTime (CtTxtDatFormat,
                    DmdFpnUtils.QryInfo.FieldByName ('DatOut').AsDateTime)+ ' ' +
                  FormatDateTime (CtTxtHouFormat,
                    DmdFpnUtils.QryInfo.FieldByName('DatOut').AsDateTime)
                  + TxtSepExp ;
                if DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime = 0 then
                  TxtWriteLine := TxtWriteLine + '' + TxtSepExp
                else
                  TxtWriteLine := TxtWriteLine +
                  FormatDateTime (CtTxtDatFormat,
                    DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime)+ ' ' +
                  FormatDateTime (CtTxtHouFormat,
                    DmdFpnUtils.QryInfo.FieldByName ('DatIn').AsDateTime)
                  + TxtSepExp;
                if FlgOutDate then
                    TxtWriteLine := TxtWriteLine +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat)
                  + TxtSepExp+ '' + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)
                  + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat)
                else
                    TxtWriteLine := TxtWriteLine +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValOut').AsFloat)
                  + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('ValIn').AsFloat)
                  + TxtSepExp +
                  FormatFloat (CtTxtFrmNumber,
                    DmdFpnUtils.QryInfo.FieldByName ('Saldo').AsFloat);
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end
          end  //end of while loop
        end  // end of DmdFpnUtils.QueryInfo...
        else begin
          TxtWriteLine := CtTxtNoData;
          WriteLn(F, TxtWriteLine);
        end;
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
//==============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetGlobalAcomptes
