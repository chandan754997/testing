//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Standard Development
// Unit   : FDetEtatCheque.PAS
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetEtatCheque.pas,v 1.2 2009/09/22 12:37:29 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptEtatCheque - CVS revision 1.3
//=============================================================================

unit FDetEtatCheque;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils, SfVSPrinter7,
  SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring          // of header
  CtTxtTitle            = 'Report of cheques';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';  

resourcestring          // of table header
  CtTxtCaissiere        = 'Operator nr';
  CtTxtNbCashDesk       = 'Nr of cash register';
  CtTxtDate             = 'Date';
  CtTxtNbTicket         = 'Ticket Nr';
  CtTxtNbCheque         = 'Nr of cheque';
  CtTxtAmountCheque     = 'Amount of cheque';
  CtTxtSubTotCaissiere  = 'S/Total operator';
  CtTxtTotal            = 'Total';

resourcestring          // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetEtatCheques = class(TFrmDetGeneralCA)
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  protected
    QtyAmount      : Integer;          // Number of cheques
    ValAmount      : Double;           // total value of the cheques

    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string ; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;

    function GetTxtTitRapport : string; override;
    function BuildSQLStatement : string;
    function GetTxtRefRapport :  string; override;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintSubTotal (NumOperator   : Integer;
                             QtyOperAmount : Integer;
                             ValOperAmount : Double); virtual;
    procedure PrintTableFooter; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
  end;

var
  FrmDetEtatCheques: TFrmDetEtatCheques;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,

  DFpnPosTransAction,
  DFpnPosTransActionCA, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetEtatCheque.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 12:37:29 $';

//*****************************************************************************
// Implementation of TFrmDetEtatCheques
//*****************************************************************************

function TFrmDetEtatCheques.GetFmtTableHeader: string;
begin  // of TFrmDetEtatCheques.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (45, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetEtatCheques.GetFmtTableHeader

//=============================================================================

function TFrmDetEtatCheques.GetFmtTableBody: string;
begin  // of TFrmDetEtatCheques.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (45, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetEtatCheques.GetFmtTableBody

//=============================================================================

function TFrmDetEtatCheques.GetFmtTableSubTotal : string ;
begin  // of TFrmDetEtatCheques.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (45, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetEtatCheques.GetFmtTableSubTotal

//=============================================================================

function TFrmDetEtatCheques.GetTxtTableTitle : string;
begin  // of TFrmDetEtatCheques.GetTxtTableTitle
  Result :=   CtTxtCaissiere  + TxtSep +
              CtTxtNbCashDesk + TxtSep +
              CtTxtDate       + TxtSep +
              CtTxtNbTicket   + TxtSep +
              CtTxtNbCheque   + TxtSep +
              CtTxtAmountCheque;
end;   // of TFrmDetEtatCheques.GetTxtTableTitle

//=============================================================================

function TFrmDetEtatCheques.GetTxtTableFooter : string;
begin  // of TFrmDetEtatCheques.GetTxtTableFooter
  Result := CtTxtTotal + TxtSep + TxtSep + TxtSep + TxtSep + IntToStr (QtyAmount) +
            TxtSep + FormatFloat (CtTxtFrmNumber, ValAmount);
end;   // of TFrmDetEtatCheques.GetTxtTableFooter

//=============================================================================

function TFrmDetEtatCheques.GetTxtTitRapport : string;
begin  // of TFrmDetEtatCheques.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetEtatCheques.GetTxtTitRapport

//=============================================================================

function TFrmDetEtatCheques.BuildSQLStatement;
begin  // of TFrmDetEtatCheques.BuildSQLStatement
    Result :=
        #10'SELECT a.TxtDescr, POSTransaction.DatTransBegin,' +
        #10'       POSTransaction.IdtOperator, POSTransaction.IdtCheckOut, '+
        #10'       POSTransaction.IdtPOSTransaction, Det.PrcInclVAT'+
        #10' FROM POSTransaction'+
        #10' INNER JOIN POSTransDetail as det'+
        #10'    on det.IdtPOSTransaction = POSTransaction.IdtPOSTransaction'+
        #10'    AND det.IdtCheckOut = POSTransaction.IdtCheckOut'+
        #10'    AND det.CodTrans = POSTransaction.CodTrans'+
        #10'    AND det.DatTransBegin = POSTransaction.DatTransBegin'+
        #10'    AND det.CodAction in (' + IntToStr (CtCodActCheque) + ')'+
        #10' LEFT JOIN POSTransDetail as a'+
        #10'    on Det.IdtPOSTransaction = a.IdtPOSTransaction'+
        #10'   and det.CodTrans          = a.CodTrans'+
        #10'   and det.IdtCheckOut       = a.IdtCheckOut'+
        #10'   and det.DatTransBegin     = a.DatTransBegin'+
        #10'   and det.NumLineReg        = a.NumLineReg'+
        #10'   and a.CodType = ' + IntToStr (CtCodPdtInfoEFTNumCard);

    if RbtDateDay.Checked then begin
      Result := Result +
        #10' WHERE PosTransaction.DatTransBegin BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             'PosTransaction.CodReturn IS NULL';
    end
    else if RbtDateLoaded.Checked then begin
      Result := Result +
        #10' WHERE PosTransaction.DatLoaded BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             'PosTransaction.CodReturn IS NULL';;
    end;

    Result := Result +
        #10'   AND POSTransaction.IdtPOSTransaction > 0' +    
        #10'   AND POSTransaction.IdtOperator IN (' + TxtLstOperID  + ')'+
        #10'   AND POSTransaction.FlgTraining = 0' +
        #10' ORDER BY IdtOperator, POSTransaction.IdtCheckOut';
end;   // of TFrmDetEtatCheques.BuildSQLStatement

//=============================================================================

function TFrmDetEtatCheques.GetTxtRefRapport :  string;
begin  // of TFrmDetEtatCheques.GetTxtRefRapport
  result := inherited GetTxtRefRapport + '0009';
end;   // of TFrmDetEtatCheques.GetTxtRefRapport

//=============================================================================

procedure TFrmDetEtatCheques.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetEtatCheques.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  if RbtDateDay.Checked then
     TxtHdr := TxtHdr + Format (CtTxtReportDate,
               [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
               FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF
  else
     TxtHdr := TxtHdr + Format (CtTxtReportDate,
               [FormatDateTime (CtTxtDatFormat, DtmPckLoadedFrom.Date),
               FormatDateTime (CtTxtDatFormat, DtmPckLoadedTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
      
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetEtatCheques.PrintHeader

//=============================================================================

procedure TFrmDetEtatCheques.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  ValOperAmount    : Double;           // Turnover for 1 operator
  QtyOperAmount    : Integer;          // Qty cheques per operator.

  TxtLine          : string;           // Line to print
begin  // of TFrmDetEtatCheques.PrintTableBody
  ValAmount := 0;
  QtyAmount := 0;
  try
    if DmdFpnUtils.QueryInfo (BuildSQLStatement) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        NumCurrentOper :=
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
        ValOperAmount := 0;
        QtyOperAmount := 0;
        while (NumCurrentOper =
               DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
               not DmdFpnUtils.QryInfo.Eof do begin
          TxtLine :=
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString + TxtSep +
            FormatDateTime
                ('dd-mm-yyyy hh:mm:ss',
                 DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
            TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString +
            TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('TxtDescr').AsString +
            TxtSep +
            FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat);
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                                 clWhite, False);
          Inc (QtyOperAmount);
          ValOperAmount := ValOperAmount +
                           DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat;
          DmdFpnUtils.QryInfo.Next;
        end;
        PrintSubTotal (NumCurrentOper, QtyOperAmount, ValOperAmount);
      end;
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetEtatCheques.PrintTableBody

//=============================================================================

procedure TFrmDetEtatCheques.PrintSubTotal (NumOperator    : Integer;
                                            QtyOperAmount  : Integer;
                                            ValOperAmount  : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetEtatCheques.PrintSubTotal
  VspPreview.EndTable;
  VspPreview.StartTable;
  TxtLine := CtTxtSubTotCaissiere + ' ' + IntToStr (NumOperator) + TxtSep +
    TxtSep + TxtSep + TxtSep + IntToStr (QtyOperAmount) + TxtSep +
    FormatFloat (CtTxtFrmNumber, ValOperAmount);

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;
  VspPreview.StartTable;

  ValAmount := ValAmount + ValOperAmount;
  QtyAmount := QtyAmount + QtyOperAmount;
end;   // of TFrmDetEtatCheques.PrintSubTotal

//=============================================================================

procedure TFrmDetEtatCheques.PrintTableFooter;
begin  // of TFrmDetEtatCheques.PrintTableFooter
  VspPreview.Text := CRLF;

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtTableFooter, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetEtatCheques.PrintTableFooter

//=============================================================================

procedure TFrmDetEtatCheques.BtnPrintClick(Sender: TObject);
begin
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
  else
     inherited;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

   