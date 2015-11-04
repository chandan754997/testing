//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FVSRptGenInvVATLst : VSView report Invoices VAT Listing generator.
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptGenInvVATLst.pas,v 1.9 2007/10/16 08:44:22 smete Exp $
//=============================================================================

unit FVSRptGenInvVATLst;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FVSRptGenInvoices, ActnList, ImgList, Menus, ExtCtrls, Buttons,
  OleCtrls, SmVSPrinter7Lib_TLB, ComCtrls, DB, MMntInvoice, FVSRptInvoiceCA;


//*****************************************************************************
// Global definitions
//*****************************************************************************

(*

  Notes:

  - Since the paper this report is ment to be printed on is 244mm wide, instead
    of the normal 210mm for A4, the left margin of 16mm is dropped when the
    report is printed on A4 (typical when developing).
    Like that, the report fits exactly on the A4 paper, since the body of the
    report is exactly 210mm wide according to the TA documentation.
  - This means that all measurements are ignoring the left margin for positioning.
  - Most positioning is done through tables, which means an empty cell is used
    when the table is not left aligned.

*)


type
  TFrmVSRptGenInvVATLst = class(TFrmVSRptGenInvoices)
  private
    { Private declarations }
  protected

    ValTransTotExclVAT: Double;
    CntTransLine      : Integer; // Number of trans.lines printed in body.

    FTxtNumVATInvoice : string;
    FTxtCodVATInvoice    : string;

    FTxtVATCodCompany : string;
    FTxtVATCodCustomer: string;

    function GetTicketBodyLine (ObjTransTicket : TObjTransTicketCA;
                                FlgStart       : Boolean): string; override;
    function GetTransBodyLine (ObjTrans: TObjTransactionCA): string; override;
    function GetTransFmtLine: string; override;
    procedure InitialiseReport; override;
    procedure InitialiseBody; override;


    procedure GenerateHeader; override;

    procedure GenerateSubtotal; virtual;
    procedure FinaliseBody; override;
    procedure FinaliseReport; override;

    procedure UpdateTransStats(ObjTrans: TObjTransactionCA); override;

  public
    { Public declarations }
    property TxtNumVATInvoice : string read  FTxtNumVATInvoice
                                       write FTxtNumVATInvoice;

    property TxtCodVATInvoice : string read  FTxtCodVATInvoice
                                       write FTxtCodVATInvoice;

    property TxtVATCodCompany : string read  FTxtVATCodCompany
                                       write FTxtVATCodCompany;

    property TxtVATCodCustomer: string read  FTxtVATCodCustomer
                                       write FTxtVATCodCustomer;

  end;

var
  FrmVSRptGenInvVATLst: TFrmVSRptGenInvVATLst;

//*****************************************************************************

implementation

uses
  SfDialog,
  SfVSPrinter7,
  DFpnPosTransaction,
  DFpnPosTransactionCA;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2007/10/16 08:44:22 $';

//*****************************************************************************
// Implementation of FVSRptGenInvVATLst
//*****************************************************************************

{ TFrmVSRptGenInvVATLst }

//=============================================================================
// TFrmVSRptGenInvVATLst.FinaliseBody
//=============================================================================

procedure TFrmVSRptGenInvVATLst.FinaliseBody;
begin  // of TFrmVSRptGenInvVATLst.FinaliseBody
  inherited;
  GenerateSubtotal;
end;   // of TFrmVSRptGenInvVATLst.FinaliseBody

//=============================================================================
// TFrmVSRptGenInvVATLst.GenerateHeader
//=============================================================================

procedure TFrmVSRptGenInvVATLst.FinaliseReport;
var
  CntPage          : Integer;
begin  // of TFrmVSRptGenInvVATLst.FinaliseReport
  inherited;
  // Print page numbers on all pages
  for CntPage := 1 to VspPreview.PageCount do begin
    VspPreview.StartOverlay (CntPage, True);
    try
      VspPreview.CurrentY := '54mm';
      VspPreview.CurrentX := '195mm';
      VspPreview.CurrentX := VspPreview.CurrentX + VspPreview.MarginLeft;
      //VspPreview.Text := Format ('%d    %d', [CntPage, VspPreview.PageCount]);
      VspPreview.Text := IntToStr (CntPage);
      VspPreview.CurrentX := '213mm';
      VspPreview.CurrentX := VspPreview.CurrentX + VspPreview.MarginLeft;
      VspPreview.Text := IntToStr (VspPreview.PageCount);
    finally
      VspPreview.EndOverlay;
    end;
  end;
end;   // of TFrmVSRptGenInvVATLst.FinaliseReport

//=============================================================================
// TFrmVSRptGenInvVATLst.GenerateHeader
//=============================================================================

procedure TFrmVSRptGenInvVATLst.GenerateHeader;
var
  TxtFmt           : string;
  TxtBody          : string;
begin  // of TFrmVSRptGenInvVATLst.GenerateHeader
  with VspPreview do begin

    CurrentY := '33mm';
    StartTable;
    TxtFmt := '35mm' + SepCol +
              FormatAlignLeft + '144mm' + SepCol +
              FormatAlignLeft + '40mm';
    TxtBody := '' + SepCol + TxtNumVATInvoice;
    AddTable(TxtFmt, '', SepCol + TxtBody, clWhite, clWhite, False);
    AddTable(TxtFmt, '', SepCol, clWhite, clWhite, False); // Empty line

    TxtBody := TxtCustName + SepCol + TxtVATCodCustomer;
    AddTable(TxtFmt, '', SepCol + TxtBody, clWhite, clWhite, False);
    AddTable(TxtFmt, '', SepCol, clWhite, clWhite, False); // Empty line

    TxtBody := TxtCompanyName + SepCol + TxtVATCodCompany;
    AddTable(TxtFmt, '', SepCol + TxtBody, clWhite, clWhite, False);
    EndTable;

    // Line with VAT invoice code
    CurrentY := '53mm';
    StartTable;
    TxtFmt := '66mm' + SepCol +
              FormatAlignLeft + '111mm' + SepCol; // VAT invoice code
    TxtBody := TxtCodVATInvoice;
    AddTable(TxtFmt, '', SepCol + TxtBody, clWhite, clWhite, False);
    EndTable
  end;
end;   // of TFrmVSRptGenInvVATLst.GenerateHeader

//=============================================================================
// TFrmVSRptGenInvVATLst.GenerateSubtotal : generate subtotal to be printed
//  for the report.
//=============================================================================

procedure TFrmVSRptGenInvVATLst.GenerateSubtotal;
var
  TxtBody          : string;
begin  // of TFrmVSRptGenInvVATLst.GenerateSubtotal

  with VspPreview do  begin
    CurrentY := '244mm';
    StartTable;
    // Sub total line for sales & tax amount
    AddTable ('153mm' + SepCol + '32mm' + SepCol + '32mm', '',
              SepCol +
              Format (ViTxtFmtPrice, [ValTransTotInclVAT]) + SepCol +
              Format (ViTxtFmtPrice, [ValTransTotExclVAT]),
              clWhite, clWhite, False);
    if FlgForcedNewPage then
      TxtBody := ''
    else
      TxtBody := Format (ViTxtFmtPrice, [ValGlobalTotal]) + SepCol +
                 Format (ViTxtFmtPrice, [ValTransTotExclVAT]);
    // Total line
    AddTable ('', '', SepCol, clWhite, clWhite, False); // Empty line
    AddTable ('', '', SepCol + TxtBody, clWhite, clWhite, False);
    EndTable;

    // Line with username and date
    CurrentY := '260mm';
    StartTable;
    AddTable ('109mm' + SepCol + '60mm' + SepCol + '50mm', '',
              SepCol + TxtUsername + SepCol + DateToStr(Date),
              clWhite, clWhite, False);
    EndTable;
  end;

end;   // of TFrmVSRptGenInvVATLst.GenerateSubtotal

//=============================================================================
// TFrmVSRptGenInvVATLst.GetTicketBodyLine
//=============================================================================

function TFrmVSRptGenInvVATLst.GetTicketBodyLine (ObjTransTicket: TObjTransTicketCA;
                                                  FlgStart: Boolean): string;
begin  // of TFrmVSRptGenInvVATLst.GetTransBodyLine
  Result := '';
end;   // of TFrmVSRptGenInvVATLst.GetTransBodyLine

//=============================================================================
// TFrmVSRptGenInvVATLst.GetTransBodyLine
//=============================================================================

function TFrmVSRptGenInvVATLst.GetTransBodyLine(ObjTrans: TObjTransactionCA): string;
begin  // of TFrmVSRptGenInvVATLst.GetTransBodyLine
  CntTransLine := CntTransLine + 1;
  with ObjTrans do begin
    if ObjTrans.CodMainAction in [CtCodActPayAdvance,
                                   CtCodActChangeAdvance,
                                   CtCodActPayForfait] then
      Result := IntToStr (CntTransLine) + SepCol +
                SepCol + // Spacer column inbetween count & description.
                NumPLU + ' ' + TxtDescrTurnOver + ' ' +
                CurrToStr(ObjTrans.NumDocBO) + SepCol +
                SepCol + SepCol + // 2 empty columns
                FloatToStr(QtyArt) + SepCol +
                Format (ViTxtFmtPrice, [GetSalesPrice]) + SepCol +
                Format (ViTxtFmtPrice, [-GetSalesValue]) + SepCol +
                FloatToStr (PctVATCode) + SepCol + // tax rate
                Format (ViTxtFmtPrice, [-GetSalesValue -
                                        GetSalesValue(True)]) + // Tax value.
                SepCol
    else if (ObjTrans.CodActComment = CtCodActComment) and
              (ObjTrans.CodType = CtCodPdtCommentArtInfoCustOrder) then
      Result := IntToStr (CntTransLine) + SepCol +
                SepCol + // Spacer column inbetween count & description.
                NumPLU + ' ' + TxtDescrTurnOver + SepCol +
                SepCol + SepCol + // 2 empty columns
                FloatToStr(QtyArt) + SepCol +
                Format (ViTxtFmtPrice, [GetSalesPrice])
    else
      Result := IntToStr (CntTransLine) + SepCol +
                SepCol + // Spacer column inbetween count & description.
                NumPLU + ' ' + TxtDescrTurnOver + SepCol +
                SepCol + SepCol + // 2 empty columns
                FloatToStr(QtyArt) + SepCol +
                Format (ViTxtFmtPrice, [GetSalesPrice]) + SepCol +
                Format (ViTxtFmtPrice, [GetSalesValue]) + SepCol +
                FloatToStr (PctVATCode) + SepCol + // tax rate
                Format (ViTxtFmtPrice, [GetSalesValue -
                                        GetSalesValue(True)]) + // Tax value.
                SepCol;
  end;
end;   // of TFrmVSRptGenInvVATLst.GetTransBodyLine

//=============================================================================
// TFrmVSRptGenInvVATLst.GetTransFmtLine
//=============================================================================

function TFrmVSRptGenInvVATLst.GetTransFmtLine: string;
begin  // of TFrmVSRptGenInvVATLst.GetTransFmtLine
  Result :=
    FormatAlignRight + '17mm' + SepCol + // First column + page margin
    FormatAlignRight + '9mm' + SepCol +  // Empty spacer column
    FormatAlignLeft  + '37mm' + SepCol + // SKU and art. description
    '24mm' + SepCol + '28mm' + SepCol +  // 2 empty columns
    FormatAlignRight + '13mm' + SepCol + // Sales qty
    FormatAlignRight + '27mm' + SepCol + // Selling price
    FormatAlignRight + '24mm' + SepCol + // Sales amount
    FormatAlignRight + '18mm' + SepCol + // Tax rate
    FormatAlignRight + '18mm';           // Tax value
end;   // of TFrmVSRptGenInvVATLst.GetTransFmtLine

//=============================================================================

procedure TFrmVSRptGenInvVATLst.InitialiseBody;
begin  // of TFrmVSRptGenInvVATLst.InitialiseBody
  VspPreview.CurrentY   := '70mm';
  inherited;
end;  // of TFrmVSRptGenInvVATLst.InitialiseBody

//=============================================================================

procedure TFrmVSRptGenInvVATLst.InitialiseReport;
begin  // of TFrmVSRptGenInvVATLst.InitialiseReport
  inherited;

  //VspPreview.TableBorder := tbAll;
  VspPreview.TableBorder := tbNone;
  ValMaxHeightBody := Round (100 * 56.69);
  CntTransLine := 0;
  ValTransTotExclVAT := 0;
end;   // of TFrmVSRptGenInvVATLst.InitialiseReport

//=============================================================================

procedure TFrmVSRptGenInvVATLst.UpdateTransStats(ObjTrans: TObjTransactionCA);
begin  // of TFrmVSRptGenInvVATLst.UpdateTransStats
  inherited;
  if ObjTrans.CodMainAction in [CtCodActPayAdvance,
                                 CtCodActChangeAdvance,
                                 CtCodActPayForfait] then
    ValTransTotExclVAT := ValTransTotExclVAT -
                          (ObjTrans.GetSalesValue + ObjTrans.GetSalesValue(True))
  else
    ValTransTotExclVAT := ValTransTotExclVAT +
                          (ObjTrans.GetSalesValue - ObjTrans.GetSalesValue(True));
end;   // of TFrmVSRptGenInvVATLst.UpdateTransStats

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                               CtTxtSrcDate);
end.   // of FVSRptGenInvVATLst

