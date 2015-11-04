//=Copyright 2002-2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : Detail form specific for Castorama.
// Unit   : FDetCautions.pas
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCautions.pas,v 1.1 2006/12/18 13:06:09 JurgenBT Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCautions.pas - CVS revision 1.2
//=============================================================================

unit FDetCautions;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, OvcBase, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SmVSPrinter7Lib_TLB;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring     // of header
  CtTxtTitle       = 'Etat des cautions';
  CtTxtJour        = 'du jour';
  CtTxtGlobal      = 'global';

resourcestring     // of table header
  CtTxtCaissiere   = 'Operator nr';
  CtTxtNbCashDesk  = 'Nr de caisse';
  CtTxtNbDocument  = 'Nr document';
  CtTxtDate        = 'Date de transaction';
  CtTxtNbTicket    = 'Ticket Nr';
  CtTxtTypeCaution = 'Type de caution';
  CtTxtVersCaution = 'Versement caution';
  CtTxtReprCaution = 'Reprise caution';
  CtTxtSubTotCaissiere  = 'S/Total operator';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetEtatCaution = class(TFrmDetGeneralCA)
    RbtGlobalRapport: TRadioButton;
  private
    { Private declarations }
  protected
    QtyTypeWarrant : Integer;          // Quantity of Type warrant
    ValPayedWarrant: Double;           // Value of Payed warrant
    ValTakedWarrant: Double;           // Value of Taked warrant

    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;
    function GetFmtTableSubTotal : string; virtual;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
    function BuildSQLStatement : string;
  public
    procedure PrintSubTotal (NumOperator   : Integer;
                             QtyTypWarrant : Integer;
                             ValPayWarrant : Double ;
                             ValTakWarrant : Double ); virtual;
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;

    property FmtTableSubTotal : string read GetFmtTableSubTotal;
  end;

var
  FrmDetEtatCaution: TFrmDetEtatCaution;

//*****************************************************************************

implementation

uses
  SfDialog,
  DFpn,
  DFpnUtils,
  SmDBUtil_BDE;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCautions.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 13:06:09 $';

//*****************************************************************************
// Implementation of TFrmDetEtatCaution
//*****************************************************************************

function TFrmDetEtatCaution.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetEtatCaution.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (20, False));
  for CntFmt := 0 to 1 do
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  for CntFmt := 0 to 2 do
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (18, False));
end;   // of TFrmDetEtatCaution.GetFmtTableHeader

//=============================================================================

function TFrmDetEtatCaution.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetEtatCaution.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (20, False));
  for CntFmt := 0 to 1 do
    Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  for CntFmt := 0 to 2 do
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (18, False));
end;   // of TFrmDetEtatCaution.GetFmtTableBody

//=============================================================================

function TFrmDetEtatCaution.GetTxtTableTitle : string;
begin  // of TFrmDetEtatCaution.GetTxtTableTitle
  Result := CtTxtCaissiere   + TxtSep +
            CtTxtNbCashDesk  + TxtSep +
            CtTxtNbDocument  + TxtSep +
            CtTxtDate        + TxtSep +
            CtTxtNbTicket    + TxtSep +
            CtTxtTypeCaution + TxtSep +
            CtTxtVersCaution + TxtSep +
            CtTxtReprCaution ;
end;   // of TFrmDetEtatCaution.GetTxtTableTitle

//=============================================================================

function TFrmDetEtatCaution.GetTxtTableFooter : string;
begin  // of TFrmDetEtatCaution.GetTxtTableFooter
  Result := 'Total' + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
             IntToStr (QtyTypeWarrant) + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValPayedWarrant) + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValTakedWarrant);
end;   // of TFrmDetEtatCaution.GetTxtTableFooter

//=============================================================================

function TFrmDetEtatCaution.GetFmtTableSubTotal : string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetEtatCaution.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (20, False));
  for CntFmt := 0 to 1 do
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
  for CntFmt := 0 to 2 do
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (18, False));
end;   // of TFrmDetEtatCaution.GetFmtTableSubTotal

//=============================================================================

function TFrmDetEtatCaution.GetTxtTitRapport : string;
begin  // of TFrmDetEtatCaution.GetTxtTitRapport
  Result := CtTxtTitle + ' ';
  if RbtGlobalRapport.Checked then
    Result := Result + CtTxtGlobal
  else
    Result := Result + CtTxtJour
end;   // of TFrmDetEtatCaution.GetTxtTitRapport

//=============================================================================

function TFrmDetEtatCaution.GetTxtRefRapport : string;
begin  // of TFrmDetEtatCaution.GetTxtRefRapport
  //if RbtGlobalRapport.Checked then
  //  Result := inherited GetTxtRefRapport + '0010'
  //else
  //  Result := inherited GetTxtRefRapport + '0009';
  Result := inherited GetTxtRefRapport + '0018';
end;   // of TFrmDetEtatCaution.GetTxtRefRapport

//=============================================================================

function TFrmDetEtatCaution.BuildSQLStatement : string;
begin  // of TFrmDetEtatCaution.BuildSQLStatement
    Result :=
      #10'SELECT POSAct.IdtOperator, POSDet.IdtCheckOut, POSDet.IdtCVente, ' +
      #10'       POSDet.DatTransBegin, POSDet.IdtPOSTransaction, ' +
      #10'       POSDet.TxtDescr, POSDet.ValInclVAT, POSDet.CodAction ' +
      #10'  FROM POSTransDetail POSDet ' +
      #10'  JOIN POSTransaction POSAct ' +
      #10'    ON (    POSAct.IdtPOSTransaction = POSDet.IdtPOSTransaction ' +
      #10'        AND POSAct.DatTransBegin = POSDet.DatTransBegin ' +
      #10'        AND POSAct.CodTrans = POSDet.CodTrans ' +
      #10'        AND POSAct.IdtCheckOut = POSDet.IdtCheckOut) ' +
      #10' WHERE POSDet.CodAction IN (140, 141) ';


    if RbtDateDay.Checked then begin
      Result := Result +
        #10' AND POSAct.DatTransBegin BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
    end
    else if RbtDateLoaded.Checked then begin
      Result := Result +
        #10' AND POSAct.DatLoaded BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
    end
    else if RbtGlobalRapport.Checked then begin
      Result := Result +
        #10' AND POSAct.DatTransBegin BETWEEN ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, 0) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
             AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, Now + 10000) +
                        ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
    end;
    Result := Result +
        #10'   AND POSAct.IdtOperator IN (' + TxtLstOperID  + ')' +
        #10' ORDER BY POSAct.IdtOperator, POSAct.IdtCheckOut';
end;   // of TFrmDetEtatCaution.BuildSQLStatement

//=============================================================================

procedure TFrmDetEtatCaution.PrintSubTotal (NumOperator   : Integer;
                                            QtyTypWarrant : Integer;
                                            ValPayWarrant : Double ;
                                            ValTakWarrant : Double );
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetEtatCaution.PrintSubTotal
  VspPreview.EndTable;
  VspPreview.StartTable;

  TxtLine := CtTxtSubTotCaissiere + ' ' + IntToStr (NumOperator) + TxtSep +
             TxtSep + TxtSep + TxtSep + TxtSep + IntToStr (QtyTypWarrant) +
             TxtSep + FormatFloat (CtTxtFrmNumber, ValPayWarrant) + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValTakWarrant);

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLTGray, False);
  VspPreview.EndTable;
  VspPreview.StartTable;

  QtyTypeWarrant  := QtyTypeWarrant  + QtyTypWarrant;
  ValPayedWarrant := ValPayedWarrant + ValPayWarrant;
  ValTakedWarrant := ValTakedWarrant + ValTakWarrant;
end;   // of TFrmDetEtatCaution.PrintSubTotal

//=============================================================================

procedure TFrmDetEtatCaution.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Current operator in process
  TxtLine          : string;           // Temp string to fill the line
  QtyWarrant       : Integer;          // Number of cautions for current oper
  ValPayWarrant    : Double;           // Payed warrant for curr. operator
  ValTakWarrant    : Double;           // Taken warrant for curr. operator
begin  // of TFrmDetEtatCaution.PrintTableBody
  try
    if DmdFpnUtils.QueryInfo (BuildSQLStatement) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        NumCurrentOper :=
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
        QtyWarrant := 0;
        ValPayWarrant := 0;
        ValTakWarrant := 0;

        while (NumCurrentOper =
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
            not DmdFpnUtils.QryInfo.Eof do begin
          TxtLine :=
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtCVente').AsString + TxtSep +
            FormatDateTime
                ('dd-mm-yyyy hh:mm:ss',
                 DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
            TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString +
            TxtSep + DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString +
            TxtSep;

          // In case of a payment, put value is first column
          if DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger = 140
              then begin
            TxtLine := TxtLine +
                       FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName('ValInclVAT').AsFloat);
            ValPayWarrant := ValPayWarrant +
                DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsFloat;
          end
          // In case of a taken, put value is second column
          else begin
            TxtLine := TxtLine + TxtSep + FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsFloat);
            ValTakWarrant := ValTakWarrant +
                DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsFloat;
          end;

          VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                               clWhite, False);
          Inc (QtyWarrant);
          DmdFpnUtils.QryInfo.Next;
        end;
        PrintSubTotal(NumCurrentOper, QtyWarrant, ValPayWarrant, ValTakWarrant);
      end;
      VspPreview.EndTable;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetEtatCaution.PrintTableBody

//=============================================================================

procedure TFrmDetEtatCaution.PrintTableFooter;
begin  // of TFrmDetEtatCaution.PrintTableFooter
  VspPreview.Text := CRLF;

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtTableFooter, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetEtatCaution.PrintTableFooter

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetGeneralCA1
