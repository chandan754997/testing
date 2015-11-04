//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FRptCouponStatus.PAS : Report for coupon status
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCouponStatus.pas,v 1.22 2011/07/09 09:55:26 BEL\DVanpouc Exp $
//History
// Version    Modified by    Reason
// 1.23       SRM   (TCS)    R2011.2 - Liste des BA - CAFR - R2011.2
// 1.24       SRM   (TCS)    R2011.2 - Liste des BA - CAFR - DefectFix 137
// 1.25       SRM   (TCS)    R2011.2 - Liste des BA - CAFR - DefectFix 266
// 1.26       SRM   (TCS)    R2011.2 - Liste des BA - CAFR - DefectFix 339
// 1.27       SRM   (TCS)    R2011.2 - Liste des BA - CAFR - DefectFix 431
// 1.28       Teesta(TCS)    R2012.1 - Promopack - BRES - R2012.1
// 1.29       TK    (TCS)    R2013.1 - Req 21110 - All OPCO- Unlock Credit Coupon and Gift Coupon
// 1.30       AS    (TCS)    R2013.1 - HPQC Enhancement 172
// 1.31       TK    (TCS)    R2013.1.Applix 2781334.CAFR.Report giving SQL Error
// 1.32       SMB   (TCS)    R2013.2.ALM Defect Fix 164.All OPCO
// 1.33       SRM   (TCS)    R2014.1.Req(31110).Promopack_Improvement
//=============================================================================

unit FRptCouponStatus;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, ScUtils_Dx, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SmVSPrinter7Lib_TLB, Db,
  DBTables, ExtDlgs;

resourcestring // for table header of the document.
  CtTxtDatState               = 'Date';
  CtTxtOperator               = 'Operator Number';
  CtTxtMovement               = 'Movement';
  CtTxtState                  = 'State';
  CtTxtCashDesk               = 'Cashdesk';
  CtTxtTicketNb               = 'Ticket Number';
  CtTxtValue                  = 'Amount';
  CtTxtDateActive             = 'Date active';
  CtTxtDateUsed               = 'Date used';
  CtTxtSaldo                  = 'Saldo';
  CtTxtNbVoucher              = 'Nr credit voucher';
  CtTxtTotVouchers            = 'Nb credit vouchers';
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtPromImprv              = '/VPI=Promopack Improvement';
  CtTxtDatDue                 = 'Expiry Date';
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
resourcestring
  CtTxtTitleGeneral           = 'Global report:';
  CtTxtTitListAll             = 'List of all credit vouchers';
  CtTxtTitListNotUsed         = 'List of unused credit vouchers';
  CtTxtTitListMovements       = 'List of movements';
  CtTxtTitleReportType        = 'Type of chosen report:';
  CtTxtTitleNotUsed           = 'Report of unused credit vouchers';
  CtTxtTitleAll               = 'Report of all credit vouchers';
  CtTxtTitleVoucherNumber     = 'Report of credit voucher nr. %s';
  CtTxtReportDate             = 'Report from %s to %s';
  CtTxtPrintDate              = 'Printed on %s at %s';
  CtTxtStartEndDate           = 'Startdate is after enddate!';
  CtTxtStartFuture            = 'Startdate is in the future!';
  CtTxtEndFuture              = 'Enddate is in the future!';
  CtTxtErrorHeader            = 'Incorrect Date';
  CtTxtVoucherNrRequired      = 'Credit voucher number is required!';
  CtTxtNbPromoPack            = 'Nr promopack';
  CtTxtDescription            = 'Description';
  CtTxtBackoffice             = 'Backoffice';
  CtTxtPlace                  = 'D:\sycron\transfertbo\excel';                  //Liste des BA SRM R2011.2
  CtTxtExists                 = 'File exists, Overwrite?';                      //Liste des BA SRM R2011.2
  CtTxtApptitle               = 'Report coupon status';                         //Liste des BA SRM R2011.2
 //Promopack - BRES - R2012.1, Teesta - Start
  CtTxtIssued                 = 'Issued';
  CtTxtAdjusted               = 'Adjusted';
  CtTxtCancelled              = 'Cancelled';
  CtTxtLapsed                 = 'Lapsed';
  CtTxtDisabled               = 'Disabled';
 //Promopack - BRES - R2012.1, Teesta - End
const
  CtShStateNotUsed            = 'E';
  CtShStateUsed               = 'R';
  CtShStateExpired            = 'P';
  CtShStateNotActif           = 'D';
  CtShStateCancelled          = 'C';
  CtLongStateNotUsed          = 'Emis';
  CtLongStateUsed             = 'Repris';
  CtLongStateExpired          = 'Périmé';
  CtLongStateNotActif         = 'Désactivé';
  CtLongStateCancelled        = 'Annulé';

const // CodState
  CtCodStateNotUsed           = 0;
  CtCodStateUsed              = 1;
  CtCodStateCancelled         = 2;
  CtCodStateExpired           = 3;
  CtCodStateDeActivated       = 4;

type
  TFrmRptCouponStatus = class(TFrmDetGeneralCA)
    Gbx: TGroupBox;
    RbtNotUsed: TRadioButton;
    RbtAll: TRadioButton;
    RbtVoucherNumber: TRadioButton;
    SvcMECreditVoucherNr: TSvcMaskEdit;
    BtnExport: TSpeedButton;                                                    //Liste des BA SRM R2011.2
    SavDlgExport: TSaveTextFileDialog;                                          //Liste des BA SRM R2011.2
    procedure BtnExportClick(Sender: TObject);                                  //Liste des BA SRM R2011.2
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RbtReportTypeClick(Sender: TObject);
    procedure CheckAppDependParams (TxtParam : string); override;               // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    procedure BeforeCheckRunParams; override;                                   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  private
    { Private declarations }
    TotNumCoupon: integer;
    TotValCoupon: Double;
    TotValUsed: Double;
    TotValSaldo: Double;
    ValCoupon: double;
    ValTotCoupon: double;
//    ValusedCoupon  : double;
    Counter: integer;
	FFlagPromImprv        : Boolean;                                              // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  protected
    { Protected declarations }
    function GetFmtTableHeader: string; override;
    function GetFmtTableBody: string; override;

    function GetTxtTableTitle: string; override;

    function GetTxtTitRapport: string; override;
    function GetItemsSelected : Boolean; override;                              // R2011.2 TCS SRM Defect 137
    function GetTxtTitTypeReport: string; virtual;
  public
    { Public declarations }
    property TxtTitTypeReport: string read GetTxtTitTypeReport;

    function BuildStatement: string;
    function BuildLine(DtsSet: TDataSet): string; virtual;
    function BuildLineVoucher(DtsSet: TDataSet): string; virtual;
    function BuildLineMovement(DtsSet: TDataSet): string; virtual;
    function BuildTotalLine: string; virtual;

    procedure SetGeneralSettings; override;
    procedure PrintTableBody; override;
    procedure PrintHeader; override;
    procedure Execute; override;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  published
    property FlgPromImprv          : Boolean read FFlagPromImprv
                                      write FFlagPromImprv;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  end;

var
  FrmRptCouponStatus          : TFrmRptCouponStatus;

implementation

uses
  DFpnTradeMatrix,
  DFpnUtils,

  smUtils,
  SmDBUtil_BDE,
  sfDialog;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const // Module-name
  CtTxtModuleName             = 'FRptCouponStatus';

const // PVCS-keywords
  CtTxtSrcName                = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCouponStatus.pas,v $';
  CtTxtSrcVersion             = '$Revision: 1.33 $';
  CtTxtSrcDate                = '$Date: 2014/03/31 12:45:26 $';

//*****************************************************************************
// Implementation of TFrmRptCouponStatus
//*****************************************************************************

procedure TFrmRptCouponStatus.RbtReportTypeClick(Sender: TObject);
begin // of TFrmRptCouponStatus.RbtReportTypeClick
  inherited;
  SvcMECreditVoucherNr.Enabled := RbtVoucherNumber.Checked;
   //Liste des BA SRM R2011.2 Start
   if RbtAll.Checked then begin
      DtmPckDayFrom.Enabled     := True;
      DtmPckDayTo.Enabled       := True;
      DtmPckDayTo.Enabled       := True;
      SvcDBLblDateFrom.Enabled  := True;
      SvcDBLblDateTo.Enabled    := True;
      RbtDateDay.Enabled        := True;
   end;
    if RbtNotUsed.Checked or RbtVoucherNumber.Checked  then begin
      DtmPckDayFrom.Enabled    := False;
      DtmPckDayTo.Enabled      := False;
      DtmPckDayTo.Enabled      := False;
      SvcDBLblDateFrom.Enabled := False;
      SvcDBLblDateTo.Enabled   := False;
      RbtDateDay.Enabled       := False;

   end;
   //Liste des BA SRM R2011.2 End
end; // of TFrmRptCouponStatus.RbtReportTypeClick

//=============================================================================

procedure TFrmRptCouponStatus.FormActivate(Sender: TObject);
begin // of TFrmRptCouponStatus.FormActivate
  inherited;
end; // of TFrmRptCouponStatus.FormActivate

//=============================================================================

procedure TFrmRptCouponStatus.Execute;
begin // of TFrmRptCouponStatus.Execute
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
    (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  else if (RbtVoucherNumber.Checked) and
    (SvcMECreditVoucherNr.TrimText = '') then begin
    Application.MessageBox(PChar(CtTxtVoucherNrRequired),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    DtmPckDayFrom.Action;
    VspPreview.Orientation := orPortrait;
    VspPreview.StartDoc;
    PrintTableBody;
    PrintTableFooter;
    VspPreview.EndDoc;

    PrintPageNumbers;

    if FlgPreview then
      FrmVSPreview.Show
    else
      VspPreview.PrintDoc(False, 1, VspPreview.PageCount);
  end;
end; // of TFrmRptCouponStatus.Execute

//=============================================================================

procedure TFrmRptCouponStatus.PrintHeader;
var
  TxtHdr                      : string; // Text stream for the header
begin // of TFrmRptCouponStatus.PrintHeader
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix[
    DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  //Liste des BA SRM R2011.2 Start
if RbtAll.checked then begin
  TxtHdr := TxtHdr +
    Format(CtTxtReportDate, [FormatDateTime(CtTxtDatFormat, DtmPckDayFrom.Date),
    FormatDateTime(CtTxtDatFormat, DtmPckDayTo.Date)])
    + CRLF + CRLF;
    end;
   //Liste des BA SRM R2011.2 End
  TxtHdr := TxtHdr + Format(CtTxtPrintDate,
    [FormatDateTime(CtTxtDatFormat, Now),
    FormatDateTime(CtTxtHouFormat, Now)]) + CRLF + CRLF;

  TxtHdr := TxtHdr + TxtTitTypeReport;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo(Logo);
end; // of TFrmRptCouponStatus.PrintHeader

//=============================================================================

function TFrmRptCouponStatus.GetTxtTitRapport: string;
begin // of TFrmRptCouponStatus.GetTxtTitRapport
  if RbtNotUsed.Checked then
    Result := CtTxtTitleGeneral + ' ' + CtTxtTitListNotUsed
  else if RbtAll.Checked then
    Result := CtTxtTitleGeneral + ' ' + CtTxtTitListAll
  else if RbtVoucherNumber.Checked then
    Result := CtTxtTitleGeneral + ' ' + CtTxtTitListMovements;
end; // of TFrmRptCouponStatus.GetTxtTitRapport

//=============================================================================

function TFrmRptCouponStatus.GetTxtTitTypeReport: string;
begin // of TFrmRptCouponStatus.GetTxtTitTypeReport
  if RbtNotUsed.Checked then
    Result := CtTxtTitleReportType + ' ' + CtTxtTitleNotUsed
  else if RbtAll.Checked then
    Result := CtTxtTitleReportType + ' ' + CtTxtTitleAll
  else if RbtVoucherNumber.Checked then
    Result := CtTxtTitleReportType + ' ' + Format(CtTxtTitleVoucherNumber,
      [SvcMECreditVoucherNr.TrimText]);
end; // of TFrmRptCouponStatus.GetTxtTitTypeReport

//=============================================================================
// R2011.2 TCS SRM Defect 137 Start
function TFrmRptCouponStatus.GetItemsSelected: Boolean;
begin  // of TFrmDetCancelLines.GetItemsSelected

    Result := inherited GetItemsSelected;
end;   // of TFrmDetCancelLines.GetItemsSelected
// R2011.2 TCS SRM Defect 137 End
//=============================================================================

function TFrmRptCouponStatus.GetTxtTableTitle: string;
begin // of TFrmRptCouponStatus.GetTxtTableTitle
  if  not FlgPromImprv then begin                                               // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    if RbtVoucherNumber.Checked then
      Result := CtTxtDatState + TxtSep +
        CtTxtMovement + TxtSep +
        CtTxtCashDesk + TxtSep +
        CtTxtOperator + TxtSep +
        CtTxtTicketNb + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtState
    else
      Result := CtTxtNbVoucher + TxtSep +
        CtTxtDateActive + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtDateUsed + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtSaldo + TxtSep +
        CtTxtState
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  end
  else begin
    if RbtVoucherNumber.Checked then
      Result := CtTxtDatState + TxtSep +
        CtTxtMovement + TxtSep +
        CtTxtCashDesk + TxtSep +
        CtTxtOperator + TxtSep +
        CtTxtTicketNb + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtState
    else if RbtNotUsed.Checked then begin
      Result := CtTxtNbVoucher + TxtSep +
        CtTxtDateActive + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtDateUsed + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtSaldo + TxtSep +
        CtTxtState + TxtSep +
        CtTxtDatDue
    end
    else if RbtAll.Checked then begin
      Result := CtTxtNbVoucher + TxtSep +
        CtTxtDateActive + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtDateUsed + TxtSep +
        CtTxtValue + TxtSep +
        CtTxtSaldo + TxtSep +
        CtTxtState
    end
  end
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end; // of TFrmRptCouponStatus.GetTxtTableTitle

//=============================================================================

function TFrmRptCouponStatus.GetFmtTableBody: string;
begin // of TFrmRptCouponStatus.GetFmtTableHeader
  if not FlgPromImprv then begin                                                    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    if RbtVoucherNumber.Checked then begin
      Result := '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end
    else begin
      Result := '>' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  end
  else begin
    if RbtVoucherNumber.Checked then begin
      Result := '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end
    else if RbtNotUsed.Checked then begin
      Result := '>' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    end
    else if RbtAll.Checked then begin
      Result := '>' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end; // of TFrmRptCouponStatus.GetFmtTableBody

//=============================================================================

function TFrmRptCouponStatus.GetFmtTableHeader: string;
begin // of TFrmRptCouponStatus.GetFmtTableHeader
  if not FlgPromImprv then begin                                                    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    if RbtVoucherNumber.Checked then begin
      Result := '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end
    else begin
      Result := '^+' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  end
  else begin
    if RbtVoucherNumber.Checked then begin
      Result := '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end
    else if RbtNotUsed.Checked then begin
      Result := '^+' + IntToStr(CalcWidthText(16, False));                        
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    end
    else if RbtAll.Checked then begin
      Result := '^+' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
    end;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end; // of TFrmRptCouponStatus.GetFmtTableHeader

//=============================================================================

function TFrmRptCouponStatus.BuildLineMovement(DtsSet: TDataSet): string;
var
  TxtStateShort               : string;
  TxtMovement                 : string;
  TxtCheckout                 : string;
begin // of BuildLineMovement
  case DtsSet.FieldByName('CodState').AsInteger of
    CtCodStateNotUsed: begin
        TxtStateShort := CtShStateNotUsed;
        TxtMovement := CtTxtIssued;                                             //Promopack - BRES - R2012.1, Teesta
      end;
    CtCodStateUsed: begin
        TxtStateShort := CtShStateUsed;
        TxtMovement := CtTxtAdjusted;                                           //Promopack - BRES - R2012.1, Teesta
      end;
    CtCodStateExpired: begin
        TxtStateShort := CtShStateExpired;
        TxtMovement := CtTxtLapsed;                                             //Promopack - BRES - R2012.1, Teesta
      end;
    CtCodStateDeActivated: begin
        TxtStateShort := CtShStateNotActif;
        TxtMovement := CtTxtDisabled ;                                          //Promopack - BRES - R2012.1, Teesta
      end;
    CtCodStateCancelled: begin
        TxtStateShort := CtShStateCancelled;
        TxtMovement := CtTxtCancelled;                                          //Promopack - BRES - R2012.1, Teesta
      end;
  else begin
      TxtStateShort := '';
      TxtMovement := '';
    end;
  end;
  if DtsSet.FieldByName('IdtCheckout').IsNull then
    TxtCheckout := CtTxtBackoffice
  else
    TxtCheckout := DtsSet.FieldByName('IdtCheckout').AsString;
  Result := FormatDateTime(CtTxtDatFormat, DtsSet.FieldByName('DatState').AsDateTime) + TxtSep +
    TxtMovement + TxtSep +
    TxtCheckout + TxtSep +
    DtsSet.FieldByName('IdtOperator').AsString + TxtSep +
    DtsSet.FieldByName('IdtPosTransaction').AsString + TxtSep +
    FormatFloat('0.00', Abs(DtsSet.FieldByName('ValCoupon').AsFloat)) + TxtSep +
    TxtMovement;

end; // of BuildLineMovement

//=============================================================================

function TFrmRptCouponStatus.BuildLineVoucher(DtsSet: TDataSet): string;
var
  TxtDatState                 : string;
  TxtDatIssue                 : string;                                         //Liste des BA SRM R2011.2
  TxtDatDue                   : string;                                         // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  TxtValSaldo                 : string;
  TxtStateShort               : string;
  TxtValUsed                  : string;
  TxtValue                    : string;
  TxtDateFrom                 : string;                                         //Liste des BA -SRM - DefectFix 431
  TxtDateTo                   : string;                                         //Liste des BA -SRM - DefectFix 431

begin // of BuildLineVoucher

  // Init
  ValTotCoupon := 0;
  TxtValUsed  := '0' + DecimalSeparator + '00';
  TxtValSaldo := '0' + DecimalSeparator + '00';
  TxtDatState := '';
  TxtDatIssue := '';                                                            //Liste des BA SRM R2011.2
  TxtValue    := ''; 
  //TxtValue    := '0' + DecimalSeparator + '00';                               //Liste des BA SRM R2011.2
  TxtStateShort := '';
  TxtDateFrom := '';                                                            //Liste des BA -SRM - DefectFix 431
  TxtDateTo   :='';                                                             //Liste des BA -SRM - DefectFix 431
  TxtDateFrom :=(FormatDateTime(CtTxtDatFormat, DtmPckDayFrom.Date));           //Liste des BA -SRM - DefectFix 431
  TxtDateTo   :=(FormatDateTime(CtTxtDatFormat, DtmPckDayTo.Date));             //Liste des BA -SRM - DefectFix 431

  // Fill date the coupon is used
  //Liste des BA SRM R2011.2 Start
  if (DtsSet.FieldByName('CodState').AsInteger = CtCodStateUsed) or
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateCancelled) or
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateExpired) or          
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateDeActivated) then
    if not DtsSet.FieldByName('DatState').IsNull then
      TxtDatState := FormatDateTime (CtTxtDatFormat,
                                     DtsSet.FieldByName('DatState').AsDateTime);
  //Liste des BA SRM R2011.2 End


  //Liste des BA SRM R2011.2 Start
   if not DtsSet.FieldByName('DatIssue').IsNull then
      TxtDatIssue := FormatDateTime (CtTxtDatFormat,                            
                                     DtsSet.FieldByName('DatIssue').AsDateTime);
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
   if FlgPromImprv and RbtNotUsed.Checked then
     TxtDatDue := FormatDateTime (CtTxtDatFormat,
                                     DtsSet.FieldByName('DatDue').AsDateTime);
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM

   if not DtsSet.FieldByName('ValCoupon').IsNull then                           //Liste des BA SRM R2011.2
     if not DtsSet.FieldByName('DatIssue').IsNull then begin                    //Liste des BA SRM - DefectFix 339
      TxtValue := FormatFloat('0.00', DtsSet.FieldByName('ValCoupon').AsFloat); //Liste des BA SRM R2011.2
   end;                                                                         //Liste des BA SRM - DefectFix 339
   if DtsSet.FieldByName('ValCoupon').IsNull then
      TxtValue := '';
  //Liste des BA SRM R2011.2 End
  // Fill coupono state
  case DtsSet.FieldByName('CodState').AsInteger of
    CtCodStateNotUsed: TxtStateShort := CtTxtIssued;                            //R2012.1 - Promopack - BRES - R2012.1 Start
    CtCodStateUsed: TxtStateShort := CtTxtAdjusted;                             
    CtCodStateExpired: TxtStateShort := CtTxtLapsed;
    CtCodStateDeActivated: TxtStateShort := CtTxtDisabled;
    CtCodStateCancelled: TxtStateShort := CtTxtCancelled;                       //R2012.1 - Promopack - BRES - R2012.1  End
  end;

  // Fill coupon balance (debt of shop towards customer)
  if DtsSet.FieldByName('CodState').AsInteger = CtCodStateNotUsed then
    TxtValSaldo:= FormatFloat ('0.00',
                               Abs(DtsSet.FieldByName ('ValCoupon').AsFloat));

  // Fill used coupon value
  //Liste des BA SRM R2011.2 Start
  if (DtsSet.FieldByName('CodState').AsInteger = CtCodStateUsed) or
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateCancelled) or
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateExpired) or
     (DtsSet.FieldByName('CodState').AsInteger = CtCodStateDeActivated) then
    TxtValUsed := FormatFloat('0.00',
                              Abs (DtsSet.FieldByName ('ValCoupon').AsFloat));
  //Liste des BA SRM R2011.2 End

  if ( TxtDateFrom <= TxtDatState) and (TxtDatState <= TxtDateTo)  then begin   //Liste des BA -SRM - DefectFix 431 Start
     TxtDatState := FormatDateTime (CtTxtDatFormat,
                                     DtsSet.FieldByName('DatState').AsDateTime);
     TxtValUsed := FormatFloat('0.00',
                              Abs (DtsSet.FieldByName ('ValCoupon').AsFloat));
     TotValUsed    := TotValUsed + StrToFloat (TxtValUsed);
  end
  else begin
   TxtDatState := '';
   TxtValUsed := '';
  end;                                                                          //Liste des BA -SRM - DefectFix 431 End

  if not FlgPromImprv then                                                      // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    Result := DtsSet.FieldByName('NumCoupon').AsString + TxtSep +
      TxtDatIssue + TxtSep +
      TxtValue + TxtSep +                                                       //Liste des BA SRM R2011.2
      TxtDatState + TxtSep +
      TxtValUsed + TxtSep +
      TxtValSaldo + TxtSep +
      TxtStateShort
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else
    Result := DtsSet.FieldByName('NumCoupon').AsString + TxtSep +
      TxtDatIssue + TxtSep +
      TxtValue + TxtSep +
      TxtDatState + TxtSep +
      TxtValUsed + TxtSep +
      TxtValSaldo + TxtSep +
      TxtStateShort + TxtSep +
      TxtDatDue;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  //Liste des BA SRM R2011.2 Start
  if  TxtValue <> '' then
    if not DtsSet.FieldByName('DatIssue').IsNull then begin                     //Liste des BA -SRM - DefectFix 339
      TotValCoupon  := TotValCoupon + StrToFloat (TxtValue);
  end;                                                                          //Liste des BA -SRM - DefectFix 339
  //Liste des BA SRM R2011.2 End
    //TotValUsed    := TotValUsed + StrToFloat (TxtValUsed);                    //Liste des BA -SRM - DefectFix 431

  TotValSaldo   := TotValSaldo + StrToFloat (TxtValSaldo);
  if TotValCoupon > 0   then                                                    //Liste des BA -SRM - DefectFix 266  Start
   if not DtsSet.FieldByName('DatIssue').IsNull then
    Inc (TotNumCoupon);                                                         //Liste des BA -SRM - DefectFix 266  End

end; // of BuildLineVoucher

//=============================================================================

procedure TFrmRptCouponStatus.PrintTableBody;
var
  TxtDescr                    : string;
  TxtIdtPromoPack             : string;
  TxtTicket                   : string;
  TxtCoupon                   : string;
  TxtNumSeq                   : string;

//  counterback      : integer;
begin // of TFrmRptCouponStatus.PrintTableBody
  inherited;
  TotNumCoupon  := 0;
  TotValCoupon  := 0;
  TotValUsed    := 0;
  TotValSaldo   := 0;
  TxtTicket     := '';
  TxtCoupon     := '';
  TxtNumSeq     := '';
  ValCoupon     := 0;
  Counter       := 1;
  try
    if DmdFpnUtils.QueryInfo(BuildStatement) then begin
      if RbtVoucherNumber.Checked then begin
        TxtIdtPromoPack := DmdFpnUtils.QryInfo.FieldByName('IdtPromoPack').AsString;
        TxtDescr := DmdFpnUtils.QryInfo.FieldByName('TxtValCoupon').AsString;
      end;
      while not DmdFpnUtils.QryInfo.Eof do begin
        if RbtVoucherNumber.Checked then begin
          VspPreview.AddTable
            (FmtTableBody, '', BuildLine(DmdFpnUtils.QryInfo),
            clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end
        else begin
          VspPreview.AddTable
            (FmtTableBody, '', BuildLine(DmdFpnUtils.QryInfo),
            clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end;
      end;

      if RbtVoucherNumber.Checked then begin
        //Table with 2 columns
        VspPreview.Text := CRLF + CRLF + CRLF;
        VspPreview.Text := CtTxtNbPromoPack + ': ' + TxtIdtPromoPack + CRLF;
        VspPreview.Text := CtTxtDescription + ': ' + TxtDescr;
      end
      else begin
        VspPreview.AddTable
          (FmtTableBody, '', BuildTotalLine,
          clWhite, clWhite, False);
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end; // of TFrmRptCouponStatus.PrintTableBody

//=============================================================================

function TFrmRptCouponStatus.BuildStatement: string;
begin // of TFrmRptCouponStatus.BuildStatement
  if RbtVoucherNumber.Checked then begin
    Result :=
      #10'select coupstathis.datstate, coupstathis.IdtCheckout, ' +
      #10'coupstathis.IdtOperator, ' +
      #10'CASE When coupstathis.IdtPosTransaction = 0 Then NULL ' +             //Liste des BA SRM R2011.2  DefectFix 137
      #10'ELSE coupstathis.IdtPosTransaction END as IdtPosTransaction, couponstatus.valcoupon,' + //Liste des BA SRM DefectFix 137
      #10'coupstathis.codstate, couponstatus.txtvalcoupon, ' +
      #10'couponstatus.idtpromopack ' +
      #10'from couponstatus' +
      #10'left outer join coupstathis' +
      #10'on couponstatus.idtcouponstatus = coupstathis.idtcouponstatus ' +
// Offline BA - Start TCS(GG)
//      #10'where couponstatus.idtcouponstatus = ' +
//      AnsiQuotedStr(SvcMECreditVoucherNr.TrimText, '''') +
//      #10'where cast(substring(couponstatus.Numcoupon,9,8) as int) = '+
// R2013.1.Applix 2781334.CAFR.Report giving SQL Error.TCS(TK).Start
      #10'where  isnumeric(case when len(couponstatus.Numcoupon)=17 then substring(couponstatus.Numcoupon,7,10) '+
      #10'else substring(couponstatus.Numcoupon,7,6) end) = 1 '+
      #10'and (case when len(couponstatus.Numcoupon)=17 then cast(substring(couponstatus.Numcoupon,7,10)as int) '+
      #10'else cast(substring(couponstatus.Numcoupon,7,6) as int) end) = '+
// R2013.1.Applix 2781334.CAFR.Report giving SQL Error.TCS(TK).End
      AnsiQuotedStr(SvcMECreditVoucherNr.TrimText, '''') +
// Offline BA - End TCS(GG)
      #10' AND couponstatus.FlgTraining = ' + AnsiQuotedStr(inttostr(0), '''') +// R2013.1 - Req 21110 - All OPCO- Unlock Credit Coupon and Gift Coupon - TCS(TK)
      #10' AND coupstathis.CodState <> 5 ' +                                    // R2013.1 - Req 21110 - All OPCO- Unlock Credit Coupon and Gift Coupon - TCS(TK)
      #10' AND not(coupstathis.numseq <> 1 and coupstathis.codstate = 0) ' ;    // R2013.1 - enhancement 172 - All OPCO - TCS(AS)
      {+#10' AND coupstathis.datstate BETWEEN ' +
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) +
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''') + ' AND ' +
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''');    }
  end;
   if RbtAll.checked then begin
     { Sometimes publish of a coupon (ban achat) does not occur in the postrans
       tables, because it is made with the application 'BA Commande'
       (PCoupOrders) In this case the report shows a wrong value for ValCoupon.
       When a coupon is published and later used, normally the balance is 0,
       but in this last case the balance is negative, since coupon is used but
       the line where the coupon is published, is not found. Not showing
       negative values, solves this bug <see case structure ValTotCoupon>}

    Result :=
    //Liste des BA SRM R2011.2 Start
      #10'select cs1.numcoupon, cs1.idtcouponstatus,'+
      #10'CASE When cs1.datissue BETWEEN '+
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) +
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''') + ' AND ' +
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date ) +                    //Liste des BA -SRM - DefectFix 266  Start
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''')+
      #10'THEN cs1.datissue ELSE NULL'+
      #10'END as datissue,'+
      #10'CASE When cs1.datissue <=  '+                                         //Liste des BA -SRM - DefectFix 266  Start
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date ) +
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''')+
      #10'THEN cs1.Valcoupon ELSE NULL'+
      #10'END as Valcoupon,'+
      //#10'cs1.Valcoupon as Valcoupon, CodState,' +
      #10'CodState,' +                                                          //Liste des BA -SRM - DefectFix 266 End
      #10'(select MAX(datstate) from coupstathis csh '+
      #10' where csh.idtcouponstatus = cs1.idtcouponstatus) as datstate, ' +
      #10'(select MAX(idtpostransaction) from coupstathis csh '+
      #10'where csh.idtcouponstatus=cs1.idtcouponstatus) as idtpostransaction '+
      #10'from couponstatus cs1 ' +
      #10' WHERE (cs1.FlgTraining=' + AnsiQuotedStr(IntToStr(0),'''') +') AND '+
      #10' (cs1.datissue BETWEEN ' +
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) +
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''') + ' AND ' +
      AnsiQuotedStr
      (FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date) +                     //Liste des BA -SRM - DefectFix 266
      ' ' + FormatDateTime(ViTxtDBHouFormat, 0), '''')+
      #10' OR (cs1.datmodify BETWEEN ' +                                        //Liste des BA - CAFR
        AnsiQuotedStr
        (FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) +
        ' ' + '00:00:00', '''') + ' AND ' +
        AnsiQuotedStr
        (FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date) +
        ' ' + '23:59:59', '''')+ 'and (CodState <> 0)))' +                      //Liste des BA - CAFR
      #10'  AND (CodState <> 5)' +                                              // R2013.1 - Req 21110 - All OPCO- Unlock Credit Coupon and Gift Coupon - TCS(TK)
      #10' Group by cs1.numcoupon, cs1.idtcouponstatus, ' +
      #10' cs1.datissue, cs1.Valcoupon, cs1.codstate ' +
      #10' Order by cs1.numcoupon, cs1.idtcouponstatus, ' +
      #10' cs1.datissue, cs1.Valcoupon, cs1.codstate ';
      end;
    if RbtNotUsed.Checked then begin
        Result :=
      #10'select cs1.numcoupon, cs1.idtcouponstatus, cs1.datissue,cs1.DatDue, '+// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
      #10'cs1.Valcoupon as Valcoupon, CodState,' +
      #10'(select MAX(datstate) from coupstathis csh '+
      #10' where csh.idtcouponstatus = cs1.idtcouponstatus) as datstate, ' +
      #10'(select MAX(idtpostransaction) from coupstathis csh '+
      #10'where csh.idtcouponstatus=cs1.idtcouponstatus) as idtpostransaction '+
      #10'from couponstatus cs1 ' +
      #10' WHERE (cs1.FlgTraining=' + AnsiQuotedStr(IntToStr(0),'''') +')'+
      #10' AND cs1.CodState = 0'+
      #10' Group by cs1.numcoupon, cs1.idtcouponstatus, ' +
      #10' cs1.datissue,Cs1.DatDue ,cs1.Valcoupon, cs1.codstate ' +             // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
      #10' Order by cs1.numcoupon, cs1.idtcouponstatus, ' +
      #10' cs1.datissue, cs1.Valcoupon, cs1.codstate ';
      //Liste des BA SRM R2011.2 End
  end;
end; // of TFrmRptCouponStatus.BuildStatement

//=============================================================================

function TFrmRptCouponStatus.BuildLine(DtsSet: TDataSet): string;
begin // of TFrmRptCouponStatus.BuildLine
  if RbtVoucherNumber.Checked then
    Result := BuildLineMovement(DtsSet)
  else
    Result := BuildLineVoucher(DtsSet);
end; // of TFrmRptCouponStatus.BuildLine

//=============================================================================

procedure TFrmRptCouponStatus.BtnPrintClick(Sender: TObject);
begin // of TFrmRptCouponStatus.BtnPrintClick
  FlgPreview := (Sender = BtnPreview);
  Execute;
end; // of TFrmRptCouponStatus.BtnPrintClick

//=============================================================================

procedure TFrmRptCouponStatus.FormCreate(Sender: TObject);
begin // of TFrmRptCouponStatus.FormCreate
  inherited;
  RbtAll.Checked := True;
  RbtReportTypeClick(Self);
  DtmPckDayFrom.DateTime := now;
  DtmPckDayTo.DateTime := now;
  Application.Title := CtTxtApptitle;
end; // of TFrmRptCouponStatus.FormCreate

//=============================================================================

procedure TFrmRptCouponStatus.SetGeneralSettings;
begin // of TFrmRptCouponStatus.SetGeneralSettings
  inherited;
  VspPreview.MarginTop := 2800;
end; // of TFrmRptCouponStatus.SetGeneralSettings

//=============================================================================

function TFrmRptCouponStatus.BuildTotalLine: string;
begin // of TFrmRptCouponStatus.BuildTotalLine
  Result := CtTxtTotVouchers + TxtSep +
    IntToStr(TotNumCoupon) + TxtSep +
    FormatFloat('0.00', TotValCoupon) + TxtSep +
    TxtSep +
    FormatFloat('0.00', TotValUsed) + TxtSep +
    FormatFloat('0.00', TotValSaldo);
end; // of TFrmRptCouponStatus.BuildTotalLine

//=============================================================================
// BtnExportClick : is used to export the generated report in excel format
//                              ---
//=============================================================================
//Liste des BA SRM R2011.2 Start

procedure TFrmRptCouponStatus.BtnExportClick(Sender: TObject);
            
var
  TxtTitles              : string;
  TxtWriteLine           : string;
  counter                : integer;
  F                      : System.Text;
  ChrDecimalSep          : char;
  Btnselect              : integer;
  FlgOK                  : Boolean;
  TxtPath                : String;
  QryHlp                 : TQuery;
  TxtValTitles           : string;   // used to count the length of a line value
  TxtStoreVal            : String;   //Collecting the report values line by line
  TxtStoreValSemi        : String;   //used to remove "|" by ";"
begin // of TFrmRptCouponStatus.BtnExportClick
  QryHlp              := TQuery.Create(self);
  QryHlp.DatabaseName := 'DBFlexPoint';
  QryHlp.Active       := False;
  QryHlp.SQL.Clear;
  QryHlp.SQL.Add('select * from ApplicParam' +
                ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
  try
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  //RbtDateDay.SetFocus;
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
    (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  else if (RbtVoucherNumber.Checked) and
    (SvcMECreditVoucherNr.TrimText = '') then begin
    Application.MessageBox(PChar(CtTxtVoucherNrRequired),
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
        TxtWriteLine := TxtWriteLine + ';'
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
        if DmdFpnUtils.QueryInfo(BuildStatement) then begin                     //Collecting the report values line by line
          while not DmdFpnUtils.QryInfo.Eof do begin
            TxtStoreVal := '';
            TxtStoreVal :=  BuildLine(DmdFpnUtils.QryInfo);
            TxtValTitles :=  TxtStoreVal ;
            TxtStoreValSemi   := '';
              for counter := 1 to Length(TxtValTitles) do begin                 //Removing "|"  by ";"
                if TxtValTitles[counter] = '|' then
                  TxtStoreValSemi  := TxtStoreValSemi  + ';'
                else
                   TxtStoreValSemi  := TxtStoreValSemi  + TxtValTitles[counter];
              end;
              WriteLn(F, TxtStoreValSemi);
              DmdFpnUtils.QryInfo.Next;
           end;    //end of while loop
         end       // end of else part of if loop
         else begin
          TxtWriteLine := '';
          WriteLn(F, TxtWriteLine);
        end;
      finally
         DmdFpnUtils.CloseInfo;
         System.Close(F);
         DecimalSeparator := ChrDecimalSep;
       end;
    end;
end; // of TFrmDetCancelLines.BtnExportClick
end;

//Liste des BA SRM R2011.2 End
//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
 procedure TFrmRptCouponStatus.CheckAppDependParams(TxtParam: string);
begin
 if AnsiUpperCase(Copy(TxtParam,3,4))= 'PI' then
   FlgPromImprv := True
 else
   inherited;
 end;

//=============================================================================

procedure TFrmRptCouponStatus.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin
  inherited;
  SplitString(CtTxtPromImprv, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent(CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
    CtTxtSrcDate);
end.

