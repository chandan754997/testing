//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Brico Depot
// Unit     : FDetErrorModoDePago.PAS : Errors in payment methods report
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version    Modified by    Reason
// 1.0        S.M.(TCS)      Initial version created for Errrors in Payment Methods Report in R2011.2
// 1.1        S.M.(TCS)      Regression Fix
//=============================================================================


unit FDetErrorModoDePago;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring          // of header
  CtTxtTitle            = 'Errors in payment methods';

resourcestring          // of table header.
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtNoData           = 'No data exist';

  CtTxtDate             = 'Date';
  CtTxtNumOper          = 'Operator number';
  CtTxtNumCashDesk      = 'CashRegister';
  CtTxtNumTicket        = 'Ticket No.';
  CtTxtAmount           = 'Amount';
  CtTxtValidated        = 'Validated By';
  CtTxtCancelled        = 'Cancelled by';

resourcestring          //of Total
  CtTxtSubTot           = 'SubTotal';
  CtTxtTotal            = 'Total';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
    TFrmDetErrorModoDePago = class(TFrmDetGeneralCA)
    CAErrorModoDePago: TStoredProc;
    procedure FormCreate(Sender: TObject);
  protected
    CntTot         : Integer;
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTitRapport : string; override;
    function GetTxtTableTitle: string; override;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintSubTotal(QtyTickets   : Integer;
                            ValAmountVAT  : Currency;
                            SubTotOperator   : integer);
    procedure PrintTotal(TotQtyTickets:integer;
                         TotValAmountVAT:double;
                         TotOperator:integer);
    procedure Execute; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
 end;

var
  FrmDetErrorModoDePago: TFrmDetErrorModoDePago;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetErrorModoDePago';

const  // CVS-keywords
  CtTxtSrcName        = '$';
  CtTxtSrcVersion     = '$Revision: 1.1 $';
  CtTxtSrcDate        = '$Date: 2011/12/05 09:55:26 $';

//*****************************************************************************
// Implementation of TFrmDetErrorModoDePago
//*****************************************************************************

function TFrmDetErrorModoDePago.GetFmtTableHeader: string;
begin
   Result := '^+' + IntToStr(CalcWidthText(50, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(7, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(25, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(23, False));
end;   // of TFrmDetErrorModoDePago.GetFmtTableHeader

//=============================================================================

function TFrmDetErrorModoDePago.GetFmtTableBody: string;
begin // of  TFrmDetErrorModoDePago.GetFmtTableHeader
    Result := '<' + IntToStr(CalcWidthText(50, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(7 , False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(25, False));
    Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(23, False));
end;   // of TFrmDetErrorModoDePago.GetFmtTableBody

//=============================================================================

function TFrmDetErrorModoDePago.GetFmtTableSubTotal: string;
 begin // of  TFrmDetErrorModoDePago.GetFmtTableHeader
    Result := '<' + IntToStr(CalcWidthText(50, False));
    Result := Result + TxtSep + '^' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(7, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(25, False));
    Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(23, False));
end;

//=============================================================================

function TFrmDetErrorModoDePago.GetTxtTitRapport : string;
begin  // of TFrmDetErrorModoDePago.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetErrorModoDePago.GetTxtTitRapport

//=============================================================================

function TFrmDetErrorModoDePago.GetTxtTableTitle: string;
begin // of  TFrmDetErrorModoDePago.GetTxtTableTitle
    Result :=CtTxtNumOper  + TxtSep + CtTxtDate + TxtSep +
             CtTxtNumCashDesk + TxtSep +
             CtTxtNumTicket   + TxtSep +
             CtTxtAmount      + TxtSep +
             CtTxtValidated   + TxtSep +
             CtTxtCancelled
end; // of  TFrmDetErrorModoDePago.GetTxtTableTitle

//=============================================================================

procedure TFrmDetErrorModoDePago.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetErrorModoDePago.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF ;                                                              

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetErrorModoDePago.PrintHeader

//=============================================================================

procedure TFrmDetErrorModoDePago.PrintTableBody;
var

  TxtLine          : string;           // Line to print
  QtyTickets       : integer;          // No of tickets
  ValAmountVAT     : currency;         // Value of price incl. VAT for a
                                       // particular article
  TotQtyTickets    : integer;          // Total No of articles
  TotValAmountVAT  : double;
  NumOperator      : string;
  SubTotOperator   : integer;
  TotOperator      : integer;
  StrTickets       : string;
begin  // of TFrmDetErrorModoDePago.PrintTableBody
  inherited;
  ValAmountVAT     := 0.00;
  NumOperator      :='';
  TotQtyTickets    := 0;
  TotValAmountVAT  := 0;
  SubTotOperator   :=0;
  TotOperator      :=0;

  VspPreview.TableBorder := tbBoxColumns;
  StrTickets := CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString;
  NumOperator := CAErrorModoDePago.FieldByName('Operator').AsString;
  QtyTickets := 1;

  while not CAErrorModoDePago.Eof do begin
    if NumOperator<> CAErrorModoDePago.FieldByName ('Operator').AsString then begin
       PrintSubTotal (QtyTickets,ValAmountVAT,SubTotOperator);
       TotQtyTickets := TotQtyTickets +  QtyTickets;
       TotOperator:= TotOperator +  SubTotOperator;
       TotValAmountVAT := TotValAmountVAT + ValAmountVAT;
       ValAmountVAT := CAErrorModoDePago.FieldByName ('ValInclVAT').AsFloat;
       QtyTickets := 1;
       if trimright(trimleft((CAErrorModoDePago.FieldByName ('CancelledBy').AsString))) = '' then begin
         SubTotOperator := 0;
       end
       else begin
          SubTotOperator := 1;
       end;
       NumOperator := CAErrorModoDePago.FieldByName ('Operator').AsString;
       StrTickets :=  CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString;
    end
    else begin
         If StrTickets <> CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString
         then begin
         QtyTickets:= QtyTickets + 1;
         StrTickets :=  CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString;
         end
         else begin
         StrTickets:= CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString;
         end;
         ValAmountVAT := ValAmountVAT + CAErrorModoDePago.FieldByName ('ValInclVAT').AsFloat;
         if trimright(trimleft((CAErrorModoDePago.FieldByName ('CancelledBy').AsString))) = '' then begin
         end
         else begin
         SubTotOperator:= SubTotOperator + 1;
         end;
    end;
    VspPreview.StartTable;

    TxtLine :=  CAErrorModoDePago.FieldByName ('Operator').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('Dattransbegin').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('IdtCheckout').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('IdtPostransaction').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('ValInclVAT').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('Supervisor').AsString
            + TxtSep + CAErrorModoDePago.FieldByName ('CancelledBy').AsString;
    VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,clWhite,False);
    VspPreview.EndTable;
    CAErrorModoDePago.Next;
  end;
  if(QtyTickets > 0)then begin
    PrintSubTotal (QtyTickets,ValAmountVAT,SubTotOperator);
    TotQtyTickets := TotQtyTickets +  QtyTickets;
    TotValAmountVAT := TotValAmountVAT + ValAmountVAT;
    TotOperator:= TotOperator +  SubTotOperator;
    PrintTotal (TotQtyTickets,TotValAmountVAT,TotOperator);
  end
end;   // of TFrmDetErrorModoDePago.PrintTableBody

//=============================================================================

procedure TFrmDetErrorModoDePago.PrintSubTotal (QtyTickets   : Integer;
                                              ValAmountVAT  : Currency;
                                              SubTotOperator   : integer);
  var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin  // of TFrmDetErrorModoDePago.PrintSubTotal
  VspPreview.StartTable;
  TxtLine :=
      CtTxtSubTot +  TxtSep + TxtSep + TxtSep +
      IntToStr(QtyTickets) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ValAmountVAT) + TxtSep +
      TxtSep + IntToStr(SubTotOperator) + TxtSep;


  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
  //VspPreview.StartTable;
end;

//=============================================================================

procedure TFrmDetErrorModoDePago.Execute;
var CntIx     : Integer;
    OprString,tempstr : string ;
    Strposi :Integer;
begin  // of TFrmDetErrorModoDePago.Execute
  CntTot:=0;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      tempstr:='';
      tempstr := ChkLbxOperator.Items[CntIx];
      Strposi := pos(':',tempstr);
      Delete(tempstr,Strposi-1,Length(tempstr)-Strposi + 2);
      OprString:=OprString+ tempstr +',';
    end;
  end;
 Delete(OprString,Length(OprString),1);
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


    CAErrorModoDePago.Active := False;
    CAErrorModoDePago.ParamByName ('@DateFrom').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAErrorModoDePago.ParamByName ('@DateTo').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAErrorModoDePago.ParamByName ('@OperatorSequence').AsString :=
        OprString;
    CAErrorModoDePago.Active := True;
    VspPreview.Orientation := orLandscape;
    VspPreview.StartDoc;
    If CAErrorModoDePago.RecordCount = 0 then
    VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                         clWhite, False)
    else
    PrintTableBody;
    PrintTableFooter;
    VspPreview.EndDoc;

    PrintPageNumbers;
    PrintReferences;

    if FlgPreview then
      FrmVSPreview.Show
    else
      VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  end;
end;   // of TFrmDetErrorModoDePago.Execute

//=============================================================================

procedure TFrmDetErrorModoDePago.PrintTotal(TotQtyTickets:integer;
                                       TotValAmountVAT:double;
                                       TotOperator:integer);

var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin   // of TFrmDetErrorModoDePago.PrintTotal

  VspPreview.StartTable;
  TxtLine := CtTxtTotal +  TxtSep + TxtSep + TxtSep +
             IntToStr(TotQtyTickets) + TxtSep +
             FormatFloat (CtTxtFrmNumber, TotValAmountVAT) + TxtSep +
             TxtSep + IntToStr(TotOperator) + TxtSep;
             
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
end;  // of TFrmDetErrorModoDePago.PrintTotal

//=============================================================================

procedure TFrmDetErrorModoDePago.FormCreate(Sender: TObject);
begin  // of TFrmDetErrorModoDePago.FormCreate
  inherited;
  self.Caption := CtTxtTitle;
  Application.Title := CtTxtTitle;
end;  // of TFrmDetErrorModoDePago.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

