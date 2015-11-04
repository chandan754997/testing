//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     :FRptGiftCoup.pas : Reports for Specific BA statement and clearing
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version     Modified by      Reason
// 1.0         TT    (TCS)      R2011.2-Initial Write  - CAFR - Edition BA spécifiques
// 1.2         SMB   (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
// 1.3         SRM   (TCS)      R2014.1.Req(31110).Promopack_Improvement
// 1.4         MeD   (TCS)      R2014.1.ALM Defect Fix 82.CAFR
//=============================================================================

unit FRptGiftCoup;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SmVSPrinter7Lib_TLB,
  ExtDlgs, DBTables;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

//=============================================================================
// Resource strings
//=============================================================================
const
 CtCodDeactivate        = 4;                                                    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
resourcestring
  CtTxtWinTitle         = 'Specific BA statement and clearing';
  CtTxtTitleCl          = 'List of purchase voucher clearing';
  CtTxtTitleSp          = 'List of specific purchase vouchers';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';

resourcestring          // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtNoEleSelected    = 'no element was selected!';
  CtTxtTitleReportType  = 'Report type selected:';

resourcestring          // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';

resourcestring          // of table header.
  CtTxtNbOperator       = 'Operator' +
                          #10'Number';
  CtTxtNbOperatorEx     = 'Operator Number';
  CtTxtIssueDate        = 'Issue Date';
  CtTxtBAAmnt           = 'BA Amount';
  CtTxtBANum            = 'BA Number';
  CtTxtEvent            = 'Event';
  CtTxtRef              = 'Reference';
  CtTxtCashNum          = 'Cash' +
                          #10'Number';
  CtTxtCashNumEx        = 'Cash Number';
  CtTxtBODocNum         = 'BO Document Number';
  CtTxtSubTot           = 'Sub/Total';
  CtTxtTot              = 'Total';
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtDateDecV         = 'Date of deactivation';
  CtTxtoperatorNo       = 'Operator';
  CtTxtNoVoucher        = 'No voucher';
  CtTxtDateOfIssue      = 'Date of issue';
  CtTxtCoupDeacVamount  = 'Amount';
  CtTxtDeacVReason      = 'Reason';
  CtTxtTitleDv          = 'List of vouchers deactivated';
  CtTxtTotBonDectv      = 'Nb good purchase';
  CtTxtPromImprv        = '/VPI=Promopack Improvement';
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmRptGiftCoup = class(TFrmDetGeneralCA)
    Panel2: TPanel;
    RbtClearing: TRadioButton;
    RbtSpecific: TRadioButton;
    RbtDeactiv: TRadioButton;                                                   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure CheckAppDependParams (TxtParam : string); override;               // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    procedure BeforeCheckRunParams; override;                                   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    function GetFmtTableHeader : string; override;
    function GetTxtTableTitle : string; override;
    function GetTxtTableTitleEx : string;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetFmtTableTotal : string; virtual;
    function GetTxtTitRapport : string; override;
    function BuildSQLGiftCoup: string;
    function GetTxtLstOperID : string; override;
    function GetTxtRefRapport : string; override;                               
  private
    { Private declarations }
    FFlagPromImprv        : Boolean;                                            // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  public
    { Public declarations }
    procedure PrintHeader; override;
    procedure PrintSubTotal(SubTotalBAAmount: Double; SubTotCount:   Integer);
    procedure PrintTotal(TotalBAAmount: Double; TotCount:   Integer);
    procedure Execute; override;
    procedure PrintTableBody; override;
  protected
    procedure AutoStart (Sender : TObject); override;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  published
    property FlgPromImprv     : Boolean read FFlagPromImprv
                                        write FFlagPromImprv;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
 end;

var
  FrmRptGiftCoup: TFrmRptGiftCoup;

implementation

uses
  DFpnUtils,
  SmUtils,
  DFpnTradeMatrix,
  SmDBUtil_BDE,
  sfDialog, SfAutoRun, DB;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptGiftCoup';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 10:54:51 $';

//*****************************************************************************
// Implementation of TFrmRptGiftCoup
//*****************************************************************************

procedure TFrmRptGiftCoup.Execute;
begin  // of TFrmRptGiftCoup.Execute
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  PrintTableBody;
  PrintTableFooter;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;   // of TFrmRptGiftCoup.Execute

//============================================================================
function TFrmRptGiftCoup.GetTxtRefRapport : string;                             
begin
;
end;
//============================================================================
function TFrmRptGiftCoup.GetFmtTableHeader: string;
begin  // of TFrmRptGiftCoup.GetFmtTableHeader
 if RbtSpecific.Checked = True then
   Result := '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (25, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (18, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (7, False))
 else if RbtClearing.Checked = True then
   Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (15, False))
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
 else if RbtDeactiv.Checked = True then
   Result := '<+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
             '<+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
             '<+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
             '<+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
             '^+' + IntToStr (CalcWidthText (20, False));
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;   // of TFrmRptGiftCoup.GetFmtTableHeader

//============================================================================

function TFrmRptGiftCoup.GetFmtTableBody : string;
begin  // of TFrmRptGiftCoup.GetFmtTableBody
  if RbtSpecific.Checked = True then
    Result := '^' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (25, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (7, False))                         
  else if RbtClearing.Checked = True then
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (15, False))
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked = True then
    Result := '>+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '<+' + IntToStr (CalcWidthText (20, False));
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;   // of TFrmRptGiftCoup.GetFmtTableBody

//============================================================================

function TFrmRptGiftCoup.GetFmtTableSubTotal : string;
begin  // of TFrmRptGiftCoup.GetFmtTableBody
  if RbtSpecific.Checked = True then
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (25, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (7, False))
  else if RbtClearing.Checked = True then
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False))
end;   // of TFrmRptGiftCoup.GetFmtTableBody

//============================================================================

function TFrmRptGiftCoup.GetFmtTableTotal : string;
begin  // of TFrmRptGiftCoup.GetFmtTableTotal
  if RbtSpecific.Checked = True then
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (25, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (18, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (7, False))                         
  else if RbtClearing.Checked = True then
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (15, False))
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked = True then
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (16, False)) + TxtSep +
              '<+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (20, False));
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;   // of TFrmRptGiftCoup.GetFmtTableTotal

//============================================================================

function TFrmRptGiftCoup.GetTxtTableTitle : string;
begin  // of TFrmRptGiftCoup.GetTxtTableTitle
  if RbtSpecific.Checked = True then
    Result := CtTxtNbOperator   + TxtSep +
              CtTxtIssueDate    + TxtSep +
              CtTxtBAAmnt       + TxtSep +
              CtTxtBANum        + TxtSep +
              CtTxtEvent        + TxtSep +
              CtTxtRef          + TxtSep +
              CtTxtCashNum
  else if RbtClearing.Checked = True then
    Result := CtTxtNbOperator   + TxtSep +
              CtTxtIssueDate    + TxtSep +
              CtTxtBODocNum     + TxtSep +
              CtTxtBAAmnt       + TxtSep +
              CtTxtBANum
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked = True then
    Result := CtTxtDateDecV         + TxtSep +
              CtTxtoperatorNo       + TxtSep +
              CtTxtNoVoucher        + TxtSep +
              CtTxtDateOfIssue      + TxtSep +
              CtTxtCoupDeacVamount  + TxtSep +
              CtTxtDeacVReason;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;   // of TFrmRptGiftCoup.GetTxtTableTitle

//=============================================================================
function TFrmRptGiftCoup.GetTxtTableTitleEx : string;
begin  // of TFrmRptGiftCoup.GetTxtTableTitle
  if RbtSpecific.Checked = True then
    Result := CtTxtNbOperatorEx + TxtSep +
              CtTxtIssueDate    + TxtSep +
              CtTxtBAAmnt       + TxtSep +
              CtTxtBANum        + TxtSep +
              CtTxtEvent        + TxtSep +
              CtTxtRef          + TxtSep +
              CtTxtCashNumEx
  else if RbtClearing.Checked = True then
    Result := CtTxtNbOperatorEx + TxtSep +
              CtTxtIssueDate    + TxtSep +
              CtTxtBODocNum     + TxtSep +
              CtTxtBAAmnt       + TxtSep +
              CtTxtBANum
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked = True then
    Result := CtTxtDateDecV         + TxtSep +
              CtTxtoperatorNo       + TxtSep +
              CtTxtNoVoucher        + TxtSep +
              CtTxtDateOfIssue      + TxtSep +
              CtTxtCoupDeacVamount  + TxtSep +
              CtTxtDeacVReason;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;

//=============================================================================

function TFrmRptGiftCoup.GetTxtTitRapport : string;
begin
  if RbtClearing.Checked = True then
    Result := CtTxtTitleCl + CRLF
  else if RbtSpecific.Checked = True then
    Result := CtTxtTitleSp + CRLF
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked = True then
    Result := CtTxtTitleDv + CRLF;
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;

//=============================================================================

procedure TFrmRptGiftCoup.AutoStart(Sender: TObject);
begin  // of TFrmRptGiftCoup.AutoStart(Sender: TObject)
  inherited;
    GbxLogging.visible := False;
end;   // of TFrmRptGiftCoup.AutoStart(Sender: TObject)

//=============================================================================

procedure TFrmRptGiftCoup.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;
begin  // of TFrmRptGiftCoup.PrintHeader
  inherited;
    if (RbtClearing.Checked = True) or
       (RbtSpecific.Checked = True) or                                          // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
       (RbtDeactiv.Checked = True ) then                                        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
    begin
      TxtHdr := TxtTitRapport;        
      TxtHdr := TxtHdr +
                 DmdFpnTradeMatrix.InfoTradeMatrix [
                 DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
                 DmdFpnTradeMatrix.InfoTradeMatrix [
                 DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'] + CRLF + CRLF;
      TxtDatFormat := CtTxtDatFormat;
        if RbtDateDay.Checked then
          TxtHdr := TxtHdr + Format (CtTxtReportDate,
                     [FormatDateTime (TxtDatFormat, DtmPckDayFrom.Date),
                       FormatDateTime (TxtDatFormat, DtmPckDayTo.Date)]) + CRLF
        else
           TxtHdr := TxtHdr + Format (CtTxtReportDate,
                     [FormatDateTime (TxtDatFormat, DtmPckLoadedFrom.Date),
                   FormatDateTime (TxtDatFormat, DtmPckLoadedTo.Date)])+ CRLF;
      TxtHdr := TxtHdr + Format (CtTxtPrintDate,
                [FormatDateTime (TxtDatFormat, Now),
                FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;                  
      VspPreview.Header := TxtHdr;
      FrmVSPreview.DrawLogo (Logo);
    end;
end;   // of TFrmRptGiftCoup.PrintHeader

//=============================================================================

procedure TFrmRptGiftCoup.BtnPrintClick(Sender: TObject);
begin
  //set focus to other fields than on datefields
  ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date)then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      DtmPckLoadedFrom.Date := Now;
      DtmPckLoadedTo.Date := Now;
      Application.MessageBox(PChar(CtTxtStartEndDate),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now)then begin
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
  else begin
     inherited;
  end;
end;

//=============================================================================

procedure TFrmRptGiftCoup.FormActivate(Sender: TObject);
begin  // of TFrmRptGiftCoup.FormActivate
  inherited;
  RbtSpecific.Checked := True;
  Application.Title := CtTxtWinTitle;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  if not FlgPromImprv then begin
    RbtDeactiv.Visible := False;
    RbtSpecific.Top := 13;
    RbtClearing.Top := 40;
    Panel2.Height := 81;
  end
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;  // of TFrmRptGiftCoup.FormActivate

//=============================================================================

procedure TFrmRptGiftCoup.ActStartExecExecute(Sender: TObject);
begin  // of TFrmRptGiftCoup.ActStartExecExecute
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoEleSelected, mtWarning, [mbOK], 0);
    Exit;
  end;
  inherited;
end;   // of TFrmRptGiftCoup.ActStartExecExecute

//=============================================================================

function TFrmRptGiftCoup.BuildSQLGiftCoup: string;
var
  TxtDateToLoad         : string; // Sting that contains the date to load
  TxtDateToLoadModify   : string; // Sting that contains the date to load       // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
begin  // of TFrmRptGiftCoup.BuildSQLGiftCoup
  TxtDateToLoad :=
      #10' AND Coup.DatIssue BETWEEN ' +   
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  TxtDateToLoadModify :=
      #10' AND Coup.DatModify BETWEEN ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

  if RbtClearing.Checked then  begin
  Result :=
  #10'SELECT CoupSHis.IdtOperator, ' +
  #10'       Coup.DatIssue,        ' +
  #10'       CoupSHis.IdtCVente,   ' +
  #10'       Coup.ValCoupon,       ' +
  #10'       Coup.IdtCouponStatus  ' +
  #10'FROM Couponstatus Coup       ' +
  #10'Right JOIN CoupStatHis CoupSHis ' +
  #10'ON Coup.IdtCouponStatus = CoupSHis.IdtCouponStatus ' +
  #10'Where Coup.codtype = 1' +
  #10'AND Coup.Idtpromopack <> 0 ' +
  #10'AND CoupSHis.IdtCVente <> 0 ' +
      TxtDateToLoad +
  #10'AND CoupSHis.IdtOperator IN (' + TxtLstOperID  + ')' +
  #10'ORDER BY CoupSHis.IdtOperator,Coup.DatIssue,Coup.IdtCouponStatus '  ;
  end;

  if RbtSpecific.Checked then  begin
  Result :=
  #10'SELECT Distinct CoupSHis.IdtOperator, ' +
  #10'       Coup.DatIssue,        ' +
  #10'       Coup.ValCoupon,       ' +
  #10'       Coup.IdtCouponStatus, ' +
  #10'       Coup.Event,           ' +
  #10'       Coup.Reference,       ' +
  #10'       CoupSHis.IdtCheckout  ' +
  #10'FROM Couponstatus Coup       ' +
  #10'Right JOIN CoupStatHis CoupSHis ' +
  #10'ON Coup.IdtCouponStatus = CoupSHis.IdtCouponStatus ' +
  #10' Where Coup.Idtpromopack = 0 ' +
  #10' AND CoupSHis.Idtpostransaction = 0 ' +
      TxtDateToLoad +
  #10'AND CoupSHis.IdtOperator IN (' + TxtLstOperID  + ')' +
  #10'ORDER BY CoupSHis.IdtOperator,Coup.DatIssue,Coup.IdtCouponStatus '  ;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  // Getting the details of the deactivated coupon details
  if RbtDeactiv.Checked then  begin
  Result :=
  #10'SELECT Coup.DatModify,          ' +
  #10'       CoupSHis.IdtOperator,    ' +
  #10'       CASE WHEN (Substring(Coup.NumCoupon,7,2))=''00''' +
  #10'       THEN CAST(substring(NumCoupon,7,10) as bigInt)'   +
  #10'       ELSE Substring ((Coup.NumCoupon),7,10)'           +
  #10'       END as IdtCouponStatus,  ' +
  #10'       Coup.DatIssue,           ' +
  #10'       Coup.ValCoupon,          ' +
  #10'       ApplCnv.TxtPublDescr     ' +
  #10'FROM Couponstatus Coup          ' +
  #10'Right JOIN CoupStatHis CoupSHis ' +
  #10' ON Coup.IdtCouponStatus = CoupSHis.IdtCouponStatus ' +
  #10'Right JOIN Applicconv ApplCnv    '+
  #10' ON Coup.CodReason = ApplCnv.TxtFldcode '+
  #10' Where Coup.CodState ='+ IntToStr(CtCodDeactivate) +
  #10' AND CoupSHis.CodState ='+ IntToStr(CtCodDeactivate) +
  #10' AND ApplCnv.IdtApplicConv = ''CodReason'' '+
  #10' AND ApplCnv.TxtTable = ''CouponStatus''   '+ TxtDateToLoadModify +
  #10' AND CoupSHis.IdtOperator IN             (' + TxtLstOperID + ')' +
  #10' ORDER BY Coup.DatModify,CoupSHis.IdtOperator,Coup.IdtCouponStatus '  ;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
end;
//=============================================================================
// PrintTableBody : required to struct the data of basic report  with the
//                  calculation of the Total and sub/Total
//=============================================================================
procedure TFrmRptGiftCoup.PrintTableBody;
var
  TxtLine               : string;           // Line to print
  SubPrevDatIssue       : string;           // To store the issued date of BA
  SubOperatorPrev       : string;           // To store Operator name
  TotCount              : Integer;          // Counter for total line count
  SubTotalBAAmount      : Double;           // To Count SUB-TOTAL BA amount
  SubTotCount           : Integer;          // To count number of BA per operator
  TotalBAAmount         : Double;           // To Count TOTAL BA amount
begin  // of TFrmRptGiftCoup.PrintTableBody
  inherited;
  SubTotalBAAmount := 0;
  SubTotCount      := 0;
  TotCount         := 0;
  TotalBAAmount    := 0;
  try
    VspPreview.TableBorder := tbBoxColumns;

    if DmdFpnUtils.QueryInfo (BuildSQLGiftCoup) then begin
      SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
      SubPrevDatIssue := DmdFpnUtils.QryInfo.FieldByName('DatIssue').AsString;
      TotCount := 0;

      while not DmdFpnUtils.QryInfo.Eof do begin
        VspPreview.StartTable;
        TotalBAAmount:= TotalBAAmount + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsFloat;

        if RbtClearing.Checked then  begin
          if TotCount = 0 then begin         
            TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString;
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
            VspPreview.EndTable;
          end
          else if SubOperatorPrev <> DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString then begin
              TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString;

              PrintSubTotal(SubTotalBAAmount,SubTotCount);
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
              VspPreview.EndTable;
              SubTotalBAAmount := 0;
              SubTotCount := 0;
          end
          else begin
            if SubPrevDatIssue <> DmdFpnUtils.QryInfo.FieldByName('DatIssue').AsString then begin
              TxtLine :=   ''
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
              VspPreview.EndTable;
            end
            else begin
             TxtLine := '' + TxtSep + '' + TxtSep
                   + DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
              VspPreview.EndTable;
            end;
          end;
          SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
          SubPrevDatIssue := DmdFpnUtils.QryInfo.FieldByName('DatIssue').AsString;
          TotCount:= TotCount +1;
          SubTotalBAAmount:= SubTotalBAAmount + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsFloat;
          SubTotCount := SubTotCount+ 1 ;
          DmdFpnUtils.QryInfo.Next;
        end
        else if RbtSpecific.Checked then begin
          if TotCount = 0 then begin
            TxtLine :=  DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Event').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Reference').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString;

            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
            VspPreview.EndTable;
          end
          else if SubOperatorPrev <> DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString then begin
            TxtLine :=  DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Event').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Reference').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString;
            PrintSubTotal(SubTotalBAAmount,SubTotCount);
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
            VspPreview.EndTable;
            SubTotalBAAmount := 0;
            SubTotCount := 0;
          end
          else begin
            if SubPrevDatIssue <> DmdFpnUtils.QryInfo.FieldByName('DatIssue').AsString then begin
              TxtLine := ''
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Event').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Reference').AsString
                 + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
              VspPreview.EndTable;
            end
            else begin
              TxtLine := '' + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString + TxtSep +  DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Event').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('Reference').AsString
                   + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString;

              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
              VspPreview.EndTable;
            end;
          end;
          SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
          SubPrevDatIssue := DmdFpnUtils.QryInfo.FieldByName('DatIssue').AsString;
          TotCount:= TotCount +1;
          SubTotalBAAmount:= SubTotalBAAmount + DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsFloat;
          SubTotCount := SubTotCount+ 1 ;
          DmdFpnUtils.QryInfo.Next;
        end  //of inner if
        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
        else if RbtDeactiv.Checked then begin
          TxtLine :=
                  (FormatDateTime('dd/mm/yyyy',
                  DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsDateTime))    //R2014.1.ALM Defect Fix 82.CAFR.MeD.TCS
                   + TxtSep +
                   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                   + TxtSep +
                   DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString
                   + TxtSep +
                   DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString
                   + TxtSep +
                   DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString
                   + TxtSep +
                   DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString;
                   
          VspPreview.AddTable (FmtTableBody, '',
                                 TxtLine, clWhite, clWhite, False);
          VspPreview.EndTable;
          TotCount:= TotCount + 1;
          DmdFpnUtils.QryInfo.Next;
          if DmdFpnUtils.QryInfo.Eof then begin
            PrintTotal(TotalBAAmount,TotCount);
            Exit;
          end
        end;  //of inner if
        // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
      end;  //of while
    end; //of outer if
    PrintSubTotal(SubTotalBAAmount,SubTotCount);
    PrintTotal(TotalBAAmount,TotCount);
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;

//=============================================================================

procedure TFrmRptGiftCoup.PrintSubTotal   ( SubTotalBAAmount: Double;
                                            SubTotCount:   Integer);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmRptGiftCoup.PrintSubTotal
  VspPreview.StartTable;
  if RbtSpecific.Checked then
    TxtLine := CtTxtSubTot + TxtSep + '' + TxtSep +
    Floattostr(SubTotalBAAmount) + TxtSep + Inttostr(SubTotCount) + TxtSep + TxtSep + TxtSep+ TxtSep
  else if RbtClearing.Checked then
    TxtLine := CtTxtSubTot + TxtSep + '' + TxtSep + '' + TxtSep +
    Floattostr(SubTotalBAAmount) + TxtSep + Inttostr(SubTotCount);
  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;
end;   // of TFrmRptGiftCoup.PrintSubTotal

//=============================================================================

procedure TFrmRptGiftCoup.PrintTotal     ( TotalBAAmount: Double;
                                            TotCount:   Integer);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmRptGiftCoup.PrintSubTotal
  VspPreview.StartTable;
  if RbtSpecific.Checked then
    TxtLine := CtTxtTot + TxtSep + '' + TxtSep +
    Floattostr(TotalBAAmount) + TxtSep + Inttostr(TotCount) + TxtSep + TxtSep + TxtSep+ TxtSep
  else if RbtClearing.Checked then
    TxtLine := CtTxtTot + TxtSep + '' + TxtSep + '' + TxtSep +
    Floattostr(TotalBAAmount) + TxtSep + Inttostr(TotCount)
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  else if RbtDeactiv.Checked then begin
    TxtLine := '' + TxtSep + '' + TxtSep + CtTxtTotBonDectv + TxtSep +
     Inttostr(TotCount)+ TxtSep + Floattostr(TotalBAAmount)+ TxtSep + '' ;
     VspPreview.AddTable (FmtTableBody, '',TxtLine, clWhite, clWhite, False);
    VspPreview.EndTable;
    Exit;
  end;
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.Text := CRLF;
  VspPreview.EndTable;
end;   // of TFrmRptGiftCoup.PrintSubTotal

//=============================================================================

function TFrmRptGiftCoup.GetTxtLstOperID : string;
var
  CntOper             : Integer;          // Loop the operators in the Checklistbox
  OperatorId,ItemName : string;           // To get the value of the operator ID
begin  // of TFrmRptGiftCoup.GetTxtLstOperID
  Result := '';
  for CntOper := 0 to Pred (ChkLbxOperator.Items.Count) do begin

    ItemName := Trim(ChkLbxOperator.Items[CntOper]);
    OperatorId := Trim(Copy(ItemName,1,Pos(':',ItemName)-1));

    if ChkLbxOperator.Checked [CntOper] then
      Result :=
          Result +
          AnsiQuotedStr(OperatorId, '''') +',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmRptGiftCoup.GetTxtLstOperID

//=============================================================================

procedure TFrmRptGiftCoup.BtnExportClick(Sender: TObject);
var
 TxtTitles            : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
begin // of TFrmRptGiftCoup.BtnExportClick

  if not ItemsSelected then begin
    MessageDlg (CtTxtNoEleSelected, mtWarning, [mbOK], 0);
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
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  ChkLbxOperator.SetFocus;
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
  else if not ItemsSelected then begin
    Exit;
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitleEx();
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
        if DmdFpnUtils.QueryInfo(BuildSQLGiftCoup) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            if RbtClearing.Checked = True then  begin
              TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsVariant + ';'+
              DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString  + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString;
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end
            else if RbtSpecific.Checked = True then  begin
              TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsVariant + ';'+
              DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString  + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('Event').AsString     + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('Reference').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString;
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end
            // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
            else if RbtDeactiv.Checked = True then  begin
              TxtWriteLine :=
              FormatDateTime('dd/mm/yy',
              DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsVariant)+ ';' +   //R2014.1.ALM Defect Fix 82.CAFR.MeD.TCS
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('IdtCouponStatus').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('DatIssue').AsString    + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('ValCoupon').AsString   + ';' +
              DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString ;
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end;
            // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
          end;    //end of while loop
        end
        else begin
          TxtWriteLine := '';
          WriteLn(F, TxtWriteLine);
        end;  // end of else part of if loop
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;

//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
 procedure TFrmRptGiftCoup.CheckAppDependParams(TxtParam: string);
begin
 if AnsiUpperCase(Copy(TxtParam,3,4))= 'PI' then
   FlgPromImprv := True
 else
   inherited;
 end;

//=============================================================================

procedure TFrmRptGiftCoup.BeforeCheckRunParams;
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
