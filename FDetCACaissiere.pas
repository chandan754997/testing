//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Flexpoint Development
// Unit   : FDetCACaissiere.PAS
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCACaissiere.pas,v 1.6 2010/09/23 07:18:07 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptCACaissiere - CVS revision 1.7
// VERSION        DONE BY               REASON
// 1.9           AM(TCS)              Defect Fix 248
//=============================================================================

unit FDetCACaissiere;

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
  CtTxtTitle            = 'CA Operators';

resourcestring          // of table header.
  CtTxtCaissiere        = 'Operator nr';
  CtTxtChiffreAff       = 'Turnover';
  CtTxtMontantRemises   = 'Amount of the discounts';
  CtTxtMontantAcomptes  = 'Amount of the down payments';
  CtTxtCANetHors        = 'CA Net without down payment';
  CtTxtNbClient         = 'Nb of clients';
  CtTxtMoyChiffreAff    = 'Turnover / Client';
  CtTxtNombreArticle    = 'Number of articles';
  CtTxtNoyNombreArticle = 'Number of articles / Client';
  CtTxtValeurAbsolue    = 'Difference in absolute value';
  CtTxtValeurRelative   = 'Difference in relatif value';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtMontantCarteActivee = 'Amount of the activated gift cards';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetCACaissiere = class(TFrmDetGeneralCA)
    SprCACaissiere: TStoredProc;
  protected
    QtyAmount      : Double;           // Total turnover
    QtyRemises     : Double;           // Total Remises
    QtyAcomptes    : Double;           // Montant des acomptes
    QtyCarteAct    : Double;           // Montant des Carte Activéé
    QtyCANetHors   : Double;           // CA Net hors acomptes
    QtyNbClient    : Integer;          // Nombre de client
    QtyNombreArt   : Integer;          // Nombre d'article
    ValValeurAbs   : Double;           // Ecarts en Valeur Absolute
    ValValeurRel   : Double;           // Ecarts en Valeur Relative
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure Execute; override;
  end;

var
  FrmDetCACaissiere: TFrmDetCACaissiere;

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
  CtTxtModuleName = '';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCACaissiere.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2011/01/27 07:18:07 $';

//*****************************************************************************
// Implementation of TFrmDetCACaissiere
//*****************************************************************************

function TFrmDetCACaissiere.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCACaissiere.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (20, False));
  for CntFmt := 0 to 9 do begin
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (12, False));
  end;
end;   // of TFrmDetCACaissiere.GetFmtTableHeader

//=============================================================================

function TFrmDetCACaissiere.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCACaissiere.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (20, False));
  for CntFmt := 0 to 9 do begin
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False));
  end;
end;   // of TFrmDetCACaissiere.GetFmtTableBody

//=============================================================================

function TFrmDetCACaissiere.GetTxtTableTitle : string;
begin  // of TFrmDetCACaissiere.GetTxtTableTitle
  if FlgCC then
  Result :=   CtTxtCaissiere + TxtSep + CtTxtChiffreAff + TxtSep +
              CtTxtMontantRemises + TxtSep + CtTxtMontantAcomptes + TxtSep +
              CtTxtMontantCarteActivee + TxtSep + CtTxtNbClient +
              TxtSep + CtTxtMoyChiffreAff + TxtSep +
              CtTxtNombreArticle + TxtSep + CtTxtNoyNombreArticle + TxtSep +
              CtTxtValeurAbsolue + TxtSep + CtTxtValeurRelative
   else
  Result :=   CtTxtCaissiere + TxtSep + CtTxtChiffreAff + TxtSep +
              CtTxtMontantRemises + TxtSep + CtTxtMontantAcomptes + TxtSep +
              CtTxtNbClient + TxtSep + CtTxtMoyChiffreAff + TxtSep +
              CtTxtNombreArticle + TxtSep + CtTxtNoyNombreArticle + TxtSep +
              CtTxtValeurAbsolue + TxtSep + CtTxtValeurRelative;
end;   // of TFrmDetCACaissiere.GetTxtTableTitle

//=============================================================================

function TFrmDetCACaissiere.GetTxtTableFooter : string;
var
  AVGAmount        : Double;           // Average Amount
  AVGArt           : Double;           // Average Articles
begin  // of TFrmDetCACaissiere.GetTxtTableFooter
  AVGAmount := 0;
  AVGArt    := 0;

  if QtyNbClient <> 0 then begin
    AVGAmount := QtyAmount / QtyNbClient;
    AVGArt    :=  QtyNombreArt / QtyNbClient
  end;
  if FlgCC then
    Result := CtTxtTotal + ' : ' + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyAmount) + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyRemises) + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyAcomptes) + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyCarteAct) + TxtSep +
            IntToStr (QtyNbClient) + TxtSep +
            FormatFloat (CtTxtFrmNumber, AVGAmount) + TxtSep +
            IntToStr (QtyNombreArt) + TxtSep +
            FormatFloat (CtTxtFrmNumber, AVGArt) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValValeurAbs) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValValeurRel)
  else
    Result := CtTxtTotal + ' : ' + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyAmount) + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyRemises) + TxtSep +
            FormatFloat (CtTxtFrmNumber, QtyAcomptes) + TxtSep +
            IntToStr (QtyNbClient) + TxtSep +
            FormatFloat (CtTxtFrmNumber, AVGAmount) + TxtSep +
            IntToStr (QtyNombreArt) + TxtSep +
            FormatFloat (CtTxtFrmNumber, AVGArt) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValValeurAbs) + TxtSep +
            FormatFloat (CtTxtFrmNumber, ValValeurRel);
end;   // of TFrmDetCACaissiere.GetTxtTableFooter

//=============================================================================

function TFrmDetCACaissiere.GetTxtTitRapport : string;
begin  // of TFrmDetCACaissiere.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCACaissiere.GetTxtTitRapport

//=============================================================================

function TFrmDetCACaissiere.GetTxtRefRapport : string;
begin  // of TFrmDetCACaissiere.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0011';
end;   // of TFrmDetCACaissiere.GetTxtRefRapport

//==============================================================================

procedure TFrmDetCACaissiere.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCACaissiere.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;  

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
end;   // of TFrmDetCACaissiere.PrintHeader

//=============================================================================

procedure TFrmDetCACaissiere.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  NumOperAmount    : Double;           // Turnover for 1 operator
  NumOperRemise    : Double;           // Discount for 1 operator
  NumOperAcomptes  : Double;
  NumOperCarteActi : Double;           // Carte Activéé
  NumOperCANetHors : Double;
  NumOperNumbClient: Integer;          // Number of client for 1 operator
  NumOperNumArt    : Integer;          // Number of articles

  TxtPrintLine     : string;           // String to print
  IdxOperator      : Integer;          // Index of the operator in the list.
  FlgProcessOper   : Boolean;          // Must the operator by processed.
begin  // of TFrmDetCACaissiere.PrintTableBody
  inherited;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  while not SprCACaissiere.Eof do begin
    NumCurrentOper := SprCACaissiere.FieldByName ('IdtOperator').AsInteger;
    IdxOperator := ChkLbxOperator.Items.IndexOfObject (TObject (NumCurrentOper));
    FlgProcessOper := (IdxOperator <> -1) and
                      ChkLbxOperator.Checked [IdxOperator];
    NumOperAmount  := 0;
    NumOperRemise  := 0;
    NumOperAcomptes  := 0;
    NumOperCarteActi := 0;
    NumOperCANetHors := 0;
    NumOperNumbClient:= 0;
    NumOperNumArt    := 0;

    while (NumCurrentOper =
        SprCACaissiere.FieldByName ('IdtOperator').AsInteger)
        and (not SprCACaissiere.Eof) do begin

      if FlgProcessOper then begin
        // If the codtype between 1 and 30, you must count it als turnover.
        if (SprCACaissiere.FieldByName ('CodType').AsInteger > 0) and
           (SprCACaissiere.FieldByName ('CodType').AsInteger < 31) then begin
          NumOperAmount := NumOperAmount +
             SprCACaissiere.FieldByName ('ValInclVAT').AsFloat;
          NumOperAcomptes := NumOperAcomptes +
             SprCACaissiere.FieldByName ('ValAccompte').AsFloat;
        end;

        case SprCACaissiere.FieldByName ('CodType').AsInteger of
          1 : begin
            NumOperNumbClient := NumOperNumbClient +
                SprCACaissiere.FieldByName ('NumCustomer').AsInteger;
            NumOperNumArt := NumOperNumArt +
                SprCACaissiere.FieldByName ('NumArticle').AsInteger;
          end;
          11 : begin
            NumOperRemise := NumOperRemise +
                SprCACaissiere.FieldByName ('ValInclVAT').AsFloat;
          end;
          301 : begin
            if (SprCACaissiere.FieldByName ('CodAction').AsInteger = 161) or
            (SprCACaissiere.FieldByName ('CodAction').AsInteger = 166) then  //Defect Fix 248 (A.M.) TCS
            NumOperCarteActi := NumOperCarteActi +
                SprCACaissiere.FieldByName ('ValInclVAT').AsFloat;
          end;
        end;
      end;
      SprCACaissiere.Next;
    end;
    if FlgProcessOper then begin
      if FlgCC then
        TxtPrintLine := CtTxtOperator + ' ' + IntToStr (NumCurrentOper) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperAmount) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperRemise) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperAcomptes) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperCarteActi) + TxtSep +
                      IntToStr (NumOperNumbClient) + TxtSep +
                      FormatFloat (CtTxtFrmNumber,
                                   NumOperAmount / NumOperNumbClient) + TxtSep +
                      IntToStr (NumOperNumArt) + TxtSep +
                      FormatFloat (CtTxtFrmNumber,
                                   NumOperNumArt / NumOperNumbClient) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, 0) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, 0)
      else
        TxtPrintLine := CtTxtOperator + ' ' + IntToStr (NumCurrentOper) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperAmount) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperRemise) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, NumOperAcomptes) + TxtSep +
                      IntToStr (NumOperNumbClient) + TxtSep +
                      FormatFloat (CtTxtFrmNumber,
                                   NumOperAmount / NumOperNumbClient) + TxtSep +
                      IntToStr (NumOperNumArt) + TxtSep +
                      FormatFloat (CtTxtFrmNumber,
                                   NumOperNumArt / NumOperNumbClient) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, 0) + TxtSep +
                      FormatFloat (CtTxtFrmNumber, 0);
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                           clWhite, False);

      QtyAmount := QtyAmount + NumOperAmount;
      QtyRemises := QtyRemises + NumOperRemise;
      QtyAcomptes := QtyAcomptes + NumOperAcomptes;
      QtyCarteAct := QtyCarteAct + NumOperCarteActi;
      QtyCANetHors := QtyCANetHors + NumOperCANetHors;
      QtyNbClient := QtyNbClient + NumOperNumbClient;
      QtyNombreArt := QtyNombreArt + NumOperNumArt;
      ValValeurAbs := ValValeurAbs + 0;
      ValValeurRel := ValValeurRel + 0;
    end;
  end;

  VspPreview.EndTable;
end;   // of TFrmDetCACaissiere.PrintTableBody

//=============================================================================

procedure TFrmDetCACaissiere.Execute;
begin  // of TFrmDetCACaissiere.Execute
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
    QtyAmount := 0;
    QtyRemises := 0;
    QtyAcomptes := 0;
    QtyCarteAct := 0;
    QtyCANetHors := 0;
    QtyNbClient := 0;
    QtyNombreArt := 0;
    ValValeurAbs := 0;
    ValValeurRel := 0;

    SprCACaissiere.Active := False;
    SprCACaissiere.ParamByName ('@PrmTxtFrom').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    SprCACaissiere.ParamByName ('@PrmTxtTo').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    SprCACaissiere.ParamByName ('@PrmTxtSequence').AsString :=
        'IdtOperator, Result.CodType, Result.CodAction, Result.CodTypeVente';
    SprCACaissiere.Active := True;

    VspPreview.Orientation := orLandscape;
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
  end;
end;   // of TFrmDetCACaissiere.Execute

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

