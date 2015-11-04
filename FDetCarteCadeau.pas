//=== Copyright 2008 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FDetCarteCadeau
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCarteCadeau.pas,v 1.2 2009/02/11 10:18:46 dietervk Exp $
// History:
// Version     Modified by     Reason
//  1.3         AS   (TCS)     R2013.2-req31050-CAFR-GiftCardReport
//  1.4         SMB (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================


unit FDetCarteCadeau;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils, SfVSPrinter7,
  SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA, ExtDlgs;                   //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring          // of header
  CtTxtTitle             = 'Report Gift card Satisfaction';
  CtTxtPrintDate         = 'Printed on %s at %s';
  CtTxtReportDate        = 'Report from %s to %s';

resourcestring          // of table header
  CtTxtCaissiere         = 'Operator nr';
  CtTxtDate              = 'Date';
  CtTxtAmountCarteCadeau = 'Amount';
  CtTxtNbCarteCadeau     = 'Card number';
  CtTxtNbTicket          = 'Ticket number';
  CtTxtSubTotCaissiere   = 'Subtotal';
  CtTxtTotal             = 'Total';

resourcestring          // of date errors
  CtTxtStartEndDate      = 'Startdate is after enddate!';
  CtTxtStartFuture       = 'Startdate is in the future!';
  CtTxtEndFuture         = 'Enddate is in the future!';
  CtTxtErrorHeader       = 'Incorrect Date';
  //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
resourcestring     // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';
  CtTxtExpParam         = '/VEXP=EXP export to excel for CAFR';
  //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
    TFrmDetCarteCadeau = class(TFrmDetGeneralCA)
    BtnExport: TSpeedButton;                                            //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    SavDlgExport: TSaveTextFileDialog;                                  //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure FormCreate(Sender: TObject);                              //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure BtnExportClick(Sender: TObject);                          //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
     FFlgExp       : boolean;                                           //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
  protected
    QtyAmount      : Integer;          // Number of gift cards
    ValAmount      : Double;           // Total value of the gift cards
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string ; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTitRapport : string; override;
    function BuildSQLStatement : string;
    function GetTxtRefRapport :  string; override;
    function GetItemsSelected : Boolean; override;                  //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
  public
    procedure BeforeCheckRunParams; override;                       //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure CheckAppDependParams (TxtParam : string); override;   //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintSubTotal (QtyOperAmount : Integer;
                             ValOperAmount : Double); virtual;
    procedure PrintTableFooter; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    property FlgExp: boolean read FFlgExp write FFlgExp;            //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS
    procedure Execute; override;
    procedure PrintReferences; override;
  end;
var
  FrmDetCarteCadeau: TFrmDetCarteCadeau;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,

  DFpnPosTransActionCA,
  DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCarteCadeau.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 10:18:46 $';

//*****************************************************************************
// Implementation of TFrmDetCarteCadeau
//*****************************************************************************

//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
procedure TFrmDetCarteCadeau.CheckAppDependParams(TxtParam: string);
begin  // of TFrmDetCarteCadeau.CheckAppDependParams
if Copy(TxtParam, 3, 3) = 'EXP' then
    FlgExp := True
else
  inherited;
end; // of TFrmDetCarteCadeau.CheckAppDependParams
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end

//=======================================================================

//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
procedure TFrmDetCarteCadeau.BeforeCheckRunParams ;
var
TxtPartLeft      : string;
TxtPartRight     : string;
begin    // of TFrmDetCarteCadeau.BeforeCheckRunParams
  SplitString(CtTxtExpParam, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
end;   // of TFrmDetCarteCadeau.BeforeCheckRunParams
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end
//========================================================================

function TFrmDetCarteCadeau.GetFmtTableHeader: string;
begin  // of TFrmDetCarteCadeau.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
end;   // of TFrmDetCarteCadeau.GetFmtTableHeader

//=============================================================================

function TFrmDetCarteCadeau.GetFmtTableBody: string;
begin  // of TFrmDetCarteCadeau.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (10, False));
end;   // of TFrmDetCarteCadeau.GetFmtTableBody

//=============================================================================

function TFrmDetCarteCadeau.GetFmtTableSubTotal : string ;
begin  // of TFrmDetCarteCadeau.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (10, False));
end;   // of TFrmDetCarteCadeau.GetFmtTableSubTotal

//=============================================================================

function TFrmDetCarteCadeau.GetTxtTableTitle : string;
begin  // of TFrmDetCarteCadeau.GetTxtTableTitle
  Result :=   CtTxtCaissiere         + TxtSep +
              CtTxtDate              + TxtSep +
              CtTxtAmountCarteCadeau + TxtSep +
              CtTxtNbCarteCadeau     + TxtSep +
              CtTxtNbTicket;
end;   // of TFrmDetCarteCadeau.GetTxtTableTitle

//=============================================================================

function TFrmDetCarteCadeau.GetTxtTableFooter : string;
begin  // of TFrmDetCarteCadeau.GetTxtTableFooter
  Result := CtTxtTotal + TxtSep + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValAmount) + TxtSep +
            IntToStr (QtyAmount) + TxtSep + TxtSep;
end;   // of TFrmDetCarteCadeau.GetTxtTableFooter

//=============================================================================

//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
function TFrmDetCarteCadeau.GetItemsSelected : Boolean;
begin // of TFrmDetCarteCadeau.GetItemsSelected
  Result :=inherited GetItemsSelected;
end;  // of TFrmDetCarteCadeau.GetItemsSelected
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end

//=============================================================================
function TFrmDetCarteCadeau.GetTxtTitRapport : string;
Var
TxtHdr    : string;
begin  // of TFrmDetCarteCadeau.GetTxtTitRapport
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
  TxtHdr := CtTxtTitle + CRLF + CRLF;
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
  Result := TxtHdr;
  //R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end
end;   // of TFrmDetCarteCadeau.GetTxtTitRapport

//=============================================================================
//TFrmDetCarteCadeau.BuildSQLStatement: Builds the SQL statement to retrieve the
// data for the report. Report will show:
//    - all the payments with carte satisfaction (issued by the operator)
//    - and if a carte cadeau was sold in the same receipt,  the card number of
//      the first card sold, will also be shown
//=============================================================================

function TFrmDetCarteCadeau.BuildSQLStatement;
begin  // of TFrmDetCarteCadeau.BuildSQLStatement
  Result :=
    #10'SELECT PTrans.IdtOperator,' +
    #10'       PTrans.DatTransBegin,' +
    #10'       PTrans.IdtPOSTransaction,' +
    #10'       Det1.PrcInclVAT,' +
    #10'       Max (Det2.TxtDescr) as CardNumber' +
    #10'FROM POSTransaction PTrans' +
    #10'INNER JOIN POSTransDetail as Det1' +
    #10'  ON Det1.IdtPOSTransaction = PTrans.IdtPOSTransaction' +
    #10'  AND Det1.CodTrans         = PTrans.CodTrans' +
    #10'  AND Det1.DatTransBegin    = PTrans.DatTransBegin' +
    #10'  AND Det1.CodAction in (' + IntToStr (CtCodPaySatCard) + ')' +
    #10'LEFT OUTER JOIN POSTransDetail as Det2' +
    #10'  ON Det2.IdtPOSTransaction = PTrans.IdtPOSTransaction' +
    #10'  AND Det2.CodTrans         = PTrans.CodTrans' +
    #10'  AND Det2.DatTransBegin    = PTrans.DatTransBegin' +
    #10'  AND Det2.CodAction in (' + IntToStr (CtCodActGiftCard) + ')' +
    #10'  AND Det2.TxtDescr in (' +
    #10'    SELECT TOP 1 Det3.TxtDescr FROM postransdetail det3' +
    #10'    WHERE Det3.IdtPOSTransaction = det2.IdtPOSTransaction' +
    #10'    AND Det3.CodTrans         = det2.CodTrans' +
    #10'    AND Det3.DatTransBegin    = det2.DatTransBegin' +
    #10'    AND Det3.CodAction in (' + IntToStr (CtCodActGiftCard) + ')' +
    #10'    AND NOT EXISTS(' +
    #10'      SELECT PDet.IdtPosTransaction' +
    #10'      FROM POSTransDetail PDet (NOLOCK)' +
    #10'      WHERE Det3.IdtPOSTransaction = PDet.IdtPOSTransaction' +
    #10'      AND Det3.IdtCheckOut = PDet.IdtCheckOut' +
    #10'      AND Det3.CodTrans = PDet.CodTrans' +
    #10'      AND Det3.DatTransBegin = PDet.DatTransBegin' +
    #10'      AND Det3.TxtDescr = PDet.TxtDescr  '+
    #10'      AND (PDet.CodAnnul IS NOT NULL OR PDet.CodAction IN (6,7,8))) '+
    #10'    ORDER BY NumLineReg) '+
    #10'WHERE PTrans.DatTransBegin BETWEEN ' +
        AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') +
    #10'AND' +
        AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') +
    #10'AND PTrans.CodReturn IS NULL' +
    #10'AND PTrans.FlgTraining =0' +
    #10'AND PTrans.IdtPOSTransaction > 0' +
    #10'AND NOT EXISTS(' +
    #10'  SELECT *' +
    #10'  FROM POSTransDetail PDet (NOLOCK)' +
    #10'  WHERE PTrans.IdtPOSTransaction = PDet.IdtPOSTransaction' +
    #10'  AND PTrans.IdtCheckOut = PDet.IdtCheckOut' +
    #10'  AND PTrans.CodTrans = PDet.CodTrans' +
    #10'  AND PTrans.DatTransBegin = PDet.DatTransBegin' +
    #10'  AND Det2.NumLineReg = PDet.NumLineReg' +
    #10'  AND (PDet.CodAnnul IS NOT NULL' +
    #10'  OR PDet.CodAction IN (6,7,8)))' +
    #10'AND PTrans.IdtOperator IN (' + TxtLstOperID  + ')'+
    #10'GROUP BY IdtOperator,' +
    #10'         PTrans.DatTransBegin,' +
    #10'         PTrans.IdtPOSTransaction,' +
    #10'         Det1.NumLineReg,' +
    #10'         Det1.PrcInclVAT,' +
    #10'         Det2.TxtDescr';
end;   // of TFrmDetCarteCadeau.BuildSQLStatement

//=============================================================================

function TFrmDetCarteCadeau.GetTxtRefRapport :  string;
begin  // of TFrmDetEtatCheques.GetTxtRefRapport
  result := inherited GetTxtRefRapport + '0013';
end;   // of TFrmDetCarteCadeau.GetTxtRefRapport

//=============================================================================

procedure TFrmDetCarteCadeau.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCarteCadeau.PrintHeader
  inherited;
  TxtHdr := CtTxtTitle + CRLF + CRLF;
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
end;   // of TFrmDetCarteCadeau.PrintHeader

//=============================================================================

procedure TFrmDetCarteCadeau.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  ValOperAmount    : Double;           // Turnover for 1 operator
  QtyOperAmount    : Integer;          // Qty gift cards per operator.
  QtyLine          : Integer;          // Which line to print
  TxtLine          : string;           // Line to print
begin  // of TFrmDetCarteCadeau.PrintTableBody
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
        QtyLine := 1;
        while (NumCurrentOper =
               DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
               not DmdFpnUtils.QryInfo.Eof do begin
          if QtyLine = 1 then begin
            TxtLine :=
              DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep +
              FormatDateTime
                  ('dd-mm-yyyy',
                   DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
              TxtSep +
              FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat) +
              TxtSep +
              DmdFpnUtils.QryInfo.FieldByName ('CardNumber').AsString +
              TxtSep +
              DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                                   clWhite, False)
          end
          else begin
            TxtLine :=
              ' ' + TxtSep +
              FormatDateTime
                  ('dd-mm-yyyy',
                   DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
              TxtSep +
              FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat) +
              TxtSep +
              DmdFpnUtils.QryInfo.FieldByName ('CardNumber').AsString +
              TxtSep +
              DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                                   clWhite, False);
          end;
          Inc (QtyLine);
          Inc (QtyOperAmount);
          ValOperAmount := ValOperAmount +
                           DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat;
          DmdFpnUtils.QryInfo.Next;
        end;
        PrintSubTotal (QtyOperAmount, ValOperAmount);
      end;
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCarteCadeau.PrintTableBody

//=============================================================================

procedure TFrmDetCarteCadeau.PrintSubTotal (QtyOperAmount  : Integer;
                                            ValOperAmount  : Double);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetCarteCadeau.PrintSubTotal
  VspPreview.EndTable;
  VspPreview.StartTable;
  TxtLine := CtTxtSubTotCaissiere + TxtSep + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValOperAmount) + TxtSep +
             IntToStr (QtyOperAmount) + TxtSep + TxtSep;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);
  VspPreview.EndTable;
  VspPreview.StartTable;

  ValAmount := ValAmount + ValOperAmount;
  QtyAmount := QtyAmount + QtyOperAmount;
end;   // of TFrmDetCarteCadeau.PrintSubTotal

//=============================================================================

procedure TFrmDetCarteCadeau.PrintTableFooter;
begin  // of TFrmDetCarteCadeau.PrintTableFooter
  VspPreview.Text := CRLF;

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtTableFooter, clWhite,
                       clLTGray, False);
  VspPreview.EndTable;
end;   // of TFrmDetCarteCadeau.PrintTableFooter

//=============================================================================

procedure TFrmDetCarteCadeau.BtnPrintClick(Sender: TObject);
begin // of TFrmDetCarteCadeau.BtnPrintClick
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
end; // of TFrmDetCarteCadeau.BtnPrintClick

//=============================================================================

procedure TFrmDetCarteCadeau.Execute;
begin  // of TFrmDetGeneralCA.Execute
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
end;   // of TFrmDetCarteCadeau.Execute

//=============================================================================

procedure TFrmDetCarteCadeau.PrintReferences;
var
  CntPageNb        : Integer;          // Temp Pagenumber
  TxtHdr           : string;
begin  // of TFrmDetGeneralCA.PrintReferences
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 50;
      Text := GetTxtRefRapport;
      CurrentX := VspPreview.MarginLeft;
      FontSize := VspPreview.FontSize + 5;
      Text := TxtHdr;
      FontSize := VspPreview.FontSize - 5;
      EndOverlay;
    end;
  end;
end;   // of TFrmDetCarteCadeau.PrintReferences

//=============================================================================
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
procedure TFrmDetCarteCadeau.BtnExportClick(Sender: TObject);

var
  TxtTitles           : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  NumCurrentOper      : Integer;
  ValOperAmount       : Double;
  QtyOperAmount       : Integer;
  QtyLine             : Integer;
  TxtLine             : string;
begin       // of TFrmDetCarteCadeau.BtnExportClick
  ValAmount := 0;
  QtyAmount := 0;
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
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  ChkLbxOperator.SetFocus;
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
      ChrDecimalSep    := DecimalSeparator;
      DecimalSeparator := ',';
      if not DirectoryExists(TxtPath) then
        ForceDirectories(TxtPath);
        SavDlgExport.InitialDir := TxtPath;
        TxtTitles := GetTxtTableTitle();
        TxtLine := GetTxtTitRapport() + '';
        for counter := 1 to Length(TxtTitles) do
        if TxtTitles[counter] = '|' then
          TxtLine := TxtLine + ';'
        else
          TxtLine := TxtLine + TxtTitles[counter];
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
          WriteLn(F, TxtLine);
        try
          if DmdFpnUtils.QueryInfo(BuildSQLStatement) then begin
            while not DmdFpnUtils.QryInfo.Eof do begin
              NumCurrentOper := DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
              ValOperAmount := 0;
              QtyOperAmount := 0;
              QtyLine := 1;
             while (NumCurrentOper =
               DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
               not DmdFpnUtils.QryInfo.Eof do begin
               if QtyLine = 1 then begin
                  TxtLine :=
                            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ';' +
                            FormatDateTime
                            ('dd-mm-yyyy',
                             DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime)+
                             ';' +
                             FormatFloat (CtTxtFrmNumber,
                             DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat) +
                             ';' +
                             DmdFpnUtils.QryInfo.FieldByName ('CardNumber').AsString +
                             ';' +
                             DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString;
                  WriteLn(F, TxtLine);
               end
               else begin
                  TxtLine :=
                            ' ' + ';' +
                            FormatDateTime
                            ('dd-mm-yyyy',
                            DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
                            ';' +
                            FormatFloat (CtTxtFrmNumber,
                            DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat) +
                            ';' +
                            DmdFpnUtils.QryInfo.FieldByName ('CardNumber').AsString +
                            ';' +
                            DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString ;
                  WriteLn(F, TxtLine);
               end ;
               Inc (QtyLine);
               Inc (QtyOperAmount);
               ValOperAmount := ValOperAmount +
                                DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat;

               DmdFpnUtils.QryInfo.Next;
          end;
          ValAmount := ValAmount + ValOperAmount;
          QtyAmount := QtyAmount + QtyOperAmount;
          TxtLine := CtTxtSubTotCaissiere + ';' + ';' +
                    FormatFloat (CtTxtFrmNumber, ValOperAmount) + ';' +
                     IntToStr (QtyOperAmount) + ';' ;
          WriteLn(F, TxtLine);

      end;
      end;
      TxtLine := CtTxtTotal + ';' +  ';' +
               FormatFloat (CtTxtFrmNumber, ValAmount) + ';' +
                IntToStr (QtyAmount) + ';'  ;
      WriteLn(F, TxtLine);
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;      //of TFrmDetCarteCadeau.BtnExportClick
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end

//======================================================================

//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-Start
procedure TFrmDetCarteCadeau.FormCreate(Sender: TObject);
begin   //of TFrmDetCarteCadeau.FormCreate
  inherited;
   if FlgExp then
    BtnExport.Visible := True
end;   //of TFrmDetCarteCadeau.FormCreate
//R2013.2-req31050-CAFR-GiftCardReport-TCS-AS-end

//======================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

   