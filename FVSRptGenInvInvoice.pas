//=Copyright 2009 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FVSRptGenInvInvoice.PAS : VSView Invoice report generator.
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptGenInvInvoice.pas,v 1.19 2009/09/28 13:16:16 BEL\KDeconyn Exp $
//=============================================================================

unit FVSRptGenInvInvoice;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FVSRptGenInvoices, ActnList, ImgList, Menus, ExtCtrls, Buttons,
  OleCtrls, SmVSPrinter7Lib_TLB, ComCtrls, DB, MMntInvoice, FVSRptInvoiceCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtSubtotal     = 'Sub total:';
  // Payment types in footer.
  // Weird abbreviations are used here to sort of get the same formatting
  // as it will be when translated to Chinese.
  CtTxtFtrCash      = 'CS';
  CtTxtFtrCoupon    = 'CPN';
  CtTxtFtrCheque    = 'CQ';
  CtTxtFtrBankCard  = 'BCR';
  CtTxtFtrOther     = 'OT';
  CtTxtFtrSavCard   = 'SCR';
  CtTxtFtrBankTrans = 'BT';

type
  TFrmVSRptGenInvInvoice = class(TFrmVSRptGenInvoices)
  protected
    ValDeposit        : Real;   // total value of deposit actions
    FNumCard  : string;                // Bank card from ticket data.
    // Column length properties
    NumLenColPLU      : Integer;
    NumLenColArtDescr : Integer;
    NumLenColUnit     : Integer;
    NumLenColUnitPrc  : Integer;
    NumLenColQty      : Integer;
    NumLenColAmount   : Integer;
    NumTicket         : Integer;
    FlgMultiBankCard  : Boolean; // True if multiple bankcards are used in the
                                 // list of tickets.
    // General description to use when printing the detail, instead of the
    // actual transaction lines.
    FTxtGeneralDescription : string;
    procedure InitFlgMultiBankCard;
    // Methods for report layout
    procedure GenerateHeader; override;
    procedure GenerateSubtotal; virtual;
    function GetTransBodyLine (ObjTrans: TObjTransactionCA): string; override;
    function GetTransFmtLine: string; override;
    function GetTicketBodyLine (ObjTransTicket: TObjTransTicketCA;
                                FlgStart: Boolean): string; override;
    function GetGeneralBodyLine (ValGlobalTotal: Double): string; virtual;
    function GetPaymentBodyLine (NumLine: Integer;
                                 ObjPayments : TObjTransTicketCA): string; virtual;
    function GetPaymentAmount (NumPrior : integer;
                               ValNormPayment : double): double; virtual;
    function IsTransPrintable (ObjTrans: TObjTransactionCA): Boolean; override;
    procedure PrintTicketLine (ObjTransTicket: TObjTransTicketCA;
                               FlgStart: Boolean); override;
    procedure FinaliseBody; override;
    procedure InitialiseReport; override;
    procedure InitialiseBody; override;
    procedure GenerateReport; override;
    function GetBankCard: string; virtual;
  public
    { Public declarations }
    property TxtGeneralDescription : string read  FTxtGeneralDescription
                                            write FTxtGeneralDescription;
  end;

var
  FrmVSRptGenInvInvoice: TFrmVSRptGenInvInvoice;

//*****************************************************************************

implementation

uses
  StrUtils,
  SfDialog,
  SfVSPrinter7,

  DFpnPOSTransaction,
  DFpnPOSTransactionCA,

  MFpnUtilsCA;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptGenInvInvoice.pas';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptGenInvInvoice.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.19 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//*****************************************************************************
// Implementation of FVSRptGenInvInvoice
//*****************************************************************************

//=============================================================================

procedure TFrmVSRptGenInvInvoice.InitFlgMultiBankCard;
var
  IxTick           : Integer;
  IxCard           : Integer;
  CntIx            : Integer;
  StrLstNumCard    : TStringList;
  TxtNumCard       : string;
  LstNumCard       : TStringList;
  FlgNewCard       : Boolean;
begin  // of TFrmVSRptGenInvInvoice.GetFlgMultiBankCard
  FlgMultiBankCard := False;
  StrLstNumCard := TStringList.Create();
  for IxTick := 0 To LstTransTicket.Count - 1 do begin
    LstNumCard := TObjTransTicketCA (LstTransTicket[IxTick])
                                      .GetUniqueTransField('NumCard');
    if LstNumCard.Count > 0 then begin
      for CntIx := 0 to LstNumCard.Count - 1 do begin
        TxtNumCard := LstNumCard[CntIx];
        FlgNewCard := True;
        for IxCard := 0 To StrLstNumCard.Count - 1 do begin
          if StrLstNumCard[IxCard] = TxtNumCard then begin
            FlgNewCard := False;
            Break;
          end;
        end;
        if FlgNewCard then
          StrLstNumCard.Add (TxtNumCard);
      end;
    end;
  end;
  FlgMultiBankCard := StrLstNumCard.Count > 1;
  StrLstNumCard.Free;
end;  // of TFrmVSRptGenInvInvoice.GetFlgMultiBankCard

//=============================================================================
// TFrmVSRptGenInvInvoice.InitialiseReport
//=============================================================================

procedure TFrmVSRptGenInvInvoice.InitialiseReport;
begin  // of TFrmVSRptGenInvInvoice.InitialiseReport
  inherited;

  ValMaxHeightBody := 7107;  // 143mm
  //ValYPosBodyStart := 5782;  // 102mm
  //ValYPosSubTotal  := 14174; // 250mm

  NumLenColPLU      := 1391;
  NumLenColArtDescr := 3702;
  NumLenColUnit     := 823;
  NumLenColUnitPrc  := 1418;
  NumLenColQty      := 1190;
  NumLenColAmount   := 1531;

  if LstTransTicket.Count > 0 then
    NumTicket := TObjTransTicket(LstTransTicket.Items[0]).IdtPOSTransaction;

  InitFlgMultiBankCard;
  if FlgMultiBankCard then
    // Also print bankcard payment actions (bankcard = EFT1 for China...).
    AddPrintableActions ([CtCodActEFT]);

  VspPreview.TableBorder := tbNone;
  //VspPreview.TableBorder := tbAll;
end;   // of TFrmVSRptGenInvInvoice.InitialiseReport

//=============================================================================
// TFrmVSRptGenInvInvoice.InitialiseBody
//=============================================================================

procedure TFrmVSRptGenInvInvoice.InitialiseBody;
begin  // of TFrmVSRptGenInvInvoice.InitialiseBody
  VspPreview.CurrentY := '112mm';
  inherited;
end;   // of TFrmVSRptGenInvInvoice.InitialiseBody

//=============================================================================
// TFrmVSRptGenInvInvoice.FinaliseBody
//=============================================================================

procedure TFrmVSRptGenInvInvoice.FinaliseBody;
begin  // of TFrmVSRptGenInvInvoice.FinaliseBody
  inherited;
  GenerateSubtotal;
end;  // of TFrmVSRptGenInvInvoice.FinaliseBody

//=============================================================================
// TFrmVSRptGenInvInvoice.GenerateHeader
//=============================================================================

procedure TFrmVSRptGenInvInvoice.GenerateHeader;
begin  // of TFrmVSRptGenInvInvoice.GenerateHeader
  // Write header
  with VspPreview do  begin
    CurrentY := '88mm';
    StartTable;
    AddTable ('25mm' + SepCol + FormatAlignLeft + '100mm', '',
              SepCol + DateToStr(Date), clWhite, clWhite, False);
    EndTable;
  end;
end;   // of TFrmVSRptGenInvInvoice.GenerateHeader

//=============================================================================
// TFrmVSRptGenInvInvoice.GenerateSubtotal
//=============================================================================

procedure TFrmVSRptGenInvInvoice.GenerateSubtotal;
var
  TxtFmt           : string;           // Format string for table lines
  CntIx            : Integer;
  CntPayments      : Integer;
  LstPaymentTrans  : TList;            // Temp var for list of payments per ticket
  ObjPayments      : TObjTransTicketCA;// Used to store all payment transactions
  TxtBankCard      : string;
begin  // of TFrmVSRptGenInvInvoice.GenerateSubtotal
  ObjPayments := nil;
  if not FlgForcedNewPage then begin
    // Last page, get payment totals
    ObjPayments := TObjTransTicketCA.Create();
    for CntIx := 0 to LstTransTicket.Count-1 do begin
      LstPaymentTrans :=
        TObjTransTicket(LstTransTicket[CntIx]).GetPaymentTrans;
      // Cumulate or add found payment types in global list
      for CntPayments := 0 To LstPaymentTrans.Count-1 do
        ObjPayments.StrLstObjTransaction.AddObject ('', LstPaymentTrans[CntPayments]);
      LstPaymentTrans.Free;
    end;
  end;
  if not FlgForcedNewPage then begin
    if FlgMultiBankCard then
      // Don't print bankcard info when multiple bank cards have been used.
      TxtBankCard := ''
    else
      TxtBankCard := GetBankCard;
  end;
    
  with VspPreview do begin
    CurrentY := '249mm';
    // Write bank card number
    StartTable;
    AddTable ('140mm' + SepCol + FormatAlignLeft + '50mm', '',
              SepCol + CtTxtFtrBankCard + ':' + TxtBankCard,
              clWhite, clWhite, False);
    EndTable;

    CurrentY := '260mm';
    // Write total in numerals

    TxtFmt := '19mm' + SepCol;

    for CntIx := 1 to 8 do
      TxtFmt := TxtFmt + '19mm' + FormatAlignRight + SepCol;

    if FlgForcedNewPage then begin
      StartTable;
      AddTable (TxtFmt, '',
                SepCol +
                AnsiReplaceStr (
                  FloatToWrittenNumerals(ValSubTotal, 6, 2, '$', '',
                                         GetArrNumerals), '$', SepCol),
                clWhite, clWhite, False);
      EndTable;
      ValSubTotal := 0;
    end
    else begin
      StartTable;
      AddTable (TxtFmt, '',
                SepCol +
                AnsiReplaceStr (
                  FloatToWrittenNumerals(ValGlobalTotal, 6, 2, '$', '',
                                         GetArrNumerals), '$', SepCol),
                clWhite, clWhite, False);
      EndTable;
    end;
    // Write username and ticket info
    CurrentY := '266mm';
    StartTable;
    AddTable ('93mm' + SepCol + FormatAlignLeft + '63mm' + SepCol + '30mm', '',
              SepCol + TxtUsername + SepCol + IntToStr(NumTicket),
              clWhite, clWhite, False);
    EndTable;

    if not FlgForcedNewPage then begin
      // Write payment type table
      CurrentY := '269mm';
      TxtFmt :=  '36mm' + SepCol + // margin column
                 FormatAlignRight + '18mm' + SepCol +  // cash text
                 FormatAlignLeft + '16mm' + SepCol +   // amount
                 FormatAlignRight + '16mm' + SepCol +  // coupon text
                 FormatAlignLeft + '16mm' + SepCol +   // amount
                 FormatAlignRight + '16mm' + SepCol +  // ...
                 FormatAlignLeft + '20mm' + SepCol +
                 FormatAlignRight + '17mm' + SepCol +
                 FormatAlignLeft + '32mm' + SepCol +
                 FormatAlignRight + '20mm' + SepCol +
                 FormatAlignLeft + '40mm' + SepCol;
      StartTable;
      AddTable (TxtFmt, '', GetPaymentBodyLine(1, ObjPayments),
                ClWhite,ClWhite, False);
      AddTable (TxtFmt, '', GetPaymentBodyLine(2, ObjPayments),
                ClWhite, ClWhite, False);
      EndTable;
    end;
  end;

  if ObjPayments <> nil then
    FreeAndNil (ObjPayments);

end;   // of TFrmVSRptGenInvInvoice.GenerateSubtotal

//=============================================================================
// TFrmVSRptGenInvInvoice.GetTicketBodyLine
//=============================================================================

function TFrmVSRptGenInvInvoice.GetTicketBodyLine(
                                      ObjTransTicket: TObjTransTicketCA;
                                      FlgStart: Boolean): string;
var
  TicketId         : string;
begin  // of TFrmVSRptGenInvInvoice.GetTicketBodyLine
  if FlgStart then begin
    //if (LstTransTicket.Count > 1) then begin
      TicketId := CtTxtTicketDate + ': ' +
                  FormatDateTime ('YYYYMMDD',ObjTransTicket.DatTransBegin) +
                  ' ' + CtTxtCheckout + ': ' +
                  IntToStr (ObjTransTicket.IdtCheckOut) + ' ' +
                  CtTxtTicketNumber + ': ' +
                  IntToStr (ObjTransTicket.IdtPOSTransaction) + SepCol;
      Result := TicketId;
    //end;
  end
  else begin
    with ObjTransTicket do begin
      Result := SepCol + SepCol + SepCol +
                CtTxtSubtotal + SepCol + SepCol +
                Format (ViTxtFmtPrice, [GetTicketTotal + ValDeposit]);
    end;
  end;
  ValDeposit := 0;
end;   // of TFrmVSRptGenInvInvoice.GetTicketBodyLine

//=============================================================================
// TFrmVSRptGenInvInvoice.GetTransBodyLine
//=============================================================================

function TFrmVSRptGenInvInvoice.GetTransBodyLine(ObjTrans: TObjTransactionCA): string;
begin  // of TFrmVSRptGenInvInvoice.GetTransBodyLine
  with ObjTrans do begin

    if CodMainAction = CtCodActEFT then begin
      Result := SepCol +
                '  ' + CtTxtFtrBankCard + ':' + NumCard + SepCol +
                SepCol +
                SepCol +
                SepCol;
    end
    else begin
      if ObjTrans.CodMainAction  in [CtCodActPayAdvance,
                                     CtCodActChangeAdvance,
                                     CtCodActPayForfait] then begin


        Result := NumPLU + SepCol +
                  TxtDescrTurnOver + ' ' + CurrToStr(ObjTrans.NumDocBO) + SepCol +
                  SepCol + // Unit
                  Format (ViTxtFmtPrice, [GetSalesPrice]) + SepCol +
                  FloatToStr(QtyArt) + SepCol +
                  Format (ViTxtFmtPrice, [-GetSalesValue]);
        ValSubTotal := ValSubTotal - GetSalesValue;
        ValDeposit := ValDeposit-GetSalesValue;
      end
      else if (ObjTrans.CodActComment = CtCodActComment) and
              (ObjTrans.CodType = CtCodPdtCommentArtInfoCustOrder) then begin
        Result := NumPLU + SepCol +
                  TxtDescrTurnOver + SepCol +
                  SepCol + // Unit
                  Format (ViTxtFmtPrice, [GetSalesPrice]) + SepCol +
                  FloatToStr(QtyArt) + SepCol;

      end
      else begin
        Result := NumPLU + SepCol +
                  TxtDescrTurnOver + SepCol +
                  SepCol + // Unit
                  Format (ViTxtFmtPrice, [GetSalesPrice]) + SepCol +
                  FloatToStr(QtyArt) + SepCol +
                  Format (ViTxtFmtPrice, [GetSalesValue]);
        ValSubTotal := ValSubTotal + GetSalesValue;
      end;
    end;
  end;
end;   // of TFrmVSRptGenInvInvoice.GetTransBodyLine

//=============================================================================
// TFrmVSRptGenInvInvoice.GetTransFmtLine
//=============================================================================

function TFrmVSRptGenInvInvoice.GetTransFmtLine: string;
begin   // of TFrmVSRptGenInvInvoice.GetTransFmtLine
  Result :=
    Format ('%s%d', [FormatAlignLeft, NumLenColPLU])      + SepCol +
    Format ('%s%d', [FormatAlignLeft, NumLenColArtDescr]) + SepCol +
    Format ('%s%d', [FormatAlignRight, NumLenColUnit])     + SepCol +
    Format ('%s%d', [FormatAlignRight, NumLenColUnitPrc])  + SepCol +
    Format ('%s%d', [FormatAlignRight, NumLenColQty])      + SepCol +
    Format ('%s%d', [FormatAlignRight, NumLenColAmount]);
end;   // of TFrmVSRptGenInvInvoice.GetTransFmtLine

//=============================================================================
// TFrmVSRptGenInvInvoice.GetGeneralBodyLine
//=============================================================================

function TFrmVSRptGenInvInvoice.GetGeneralBodyLine(ValGlobalTotal: Double): string;
begin  // of TFrmVSRptGenInvInvoice.GetGeneralBodyLine
  Result := SepCol + TxtGeneralDescription + SepCol + SepCol + SepCol +
            Format (ViTxtFmtPrice, [ValGlobalTotal]) + SepCol;
end;   // of TFrmVSRptGenInvInvoice.GetGeneralBodyLine

//=============================================================================
// TFrmVSRptGenInvInvoice.IsTransPrintable
//=============================================================================

function TFrmVSRptGenInvInvoice.IsTransPrintable(ObjTrans: TObjTransactionCA): Boolean;
begin  // of TFrmVSRptGenInvInvoice.IsTransPrintable
  Result := inherited IsTransPrintable(ObjTrans);
end;   // of TFrmVSRptGenInvInvoice.IsTransPrintable

//=============================================================================
// TFrmVSRptGenInvInvoice.GenerateReport
//=============================================================================

procedure TFrmVSRptGenInvInvoice.GenerateReport;
var
  CntTicket        : Integer;
  ObjTransTick     : TObjTransTicketCA;
begin  // of TFrmVSRptGenInvInvoice.GenerateReport

  if TxtGeneralDescription <> '' then begin
    for CntTicket := 0 to LstTransTicket.Count - 1 do begin
      ObjTransTick := LstTransTicket.Items [CntTicket];
      PrintTicketLine (ObjTransTick, True);
    end;
    AddTableLine (TransFmtLine, GetGeneralBodyLine(ValGlobalTotal));
  end
  else
    inherited GenerateReport;
end;   // of TFrmVSRptGenInvInvoice.GenerateReport

//=============================================================================
// TFrmVSRptGenInvInvoice.GetPaymentBodyLine: returns body for payment lines
//    to be printed in the report footer.
//=============================================================================

function TFrmVSRptGenInvInvoice.GetPaymentBodyLine(
                                     NumLine: Integer;
                                     ObjPayments: TObjTransTicketCA): string;
var
  ValPayment1,
  ValPayment2,
  ValPayment3,
  ValPayment4 : double;
begin  // of TFrmVSRptGenInvInvoice.GetPaymentBodyLine
  if NumLine = 1 then begin
    ValPayment1 := GetPaymentAmount(1, ObjPayments.GetTotalByAct([CtCodActCash])) -
                   ObjPayments.GetTotalByAct([CtCodActReturn]);

    ValPayment2 := GetPaymentAmount(3, ObjPayments.GetTotalByAct(
                                             [CtCodActCoupExternal,
                                              CtCodActDiscCoup,
                                              CtCodActCoupPayment]));
    ValPayment3 := GetPaymentAmount(4, ObjPayments.GetTotalByAct(
                                             [CtCodActBankCard,
                                              CtCodActEFT]));
    ValPayment4 := GetPaymentAmount(2, ObjPayments.GetTotalByAct(
                           [CtCodActEFT2, CtCodActEFT3, CtCodActEFT4,
                            CtCodActForCurr, CtCodActForCurr2, CtCodActForCurr3,
                            CtCodActRndTotal, CtCodActCreditAllow,
                            CtCodActInstalment]));
    Result :=
      SepCol + CtTxtFtrCash + SepCol + Format (ViTxtFmtPrice, [ValPayment1]) +
      SepCol + CtTxtFtrCoupon + SepCol + Format (ViTxtFmtPrice, [ValPayment2]) +
      SepCol + CtTxtFtrBankCard + SepCol +
      // Bank card amount (which is action for EFT1) + coupon payment.
      Format (ViTxtFmtPrice, [ValPayment3]) + SepCol + CtTxtFtrOther +  SepCol +
      // All other payment types.
      Format (ViTxtFmtPrice, [ValPayment4]);
  end
  else begin
    ValPayment1 := GetPaymentAmount(5, ObjPayments.GetTotalByAct([CtCodActCheque]));
    ValPayment2 := GetPaymentAmount(6, ObjPayments.GetTotalByAct([CtCodActSavingCard]));
    ValPayment3 := GetPaymentAmount(7, ObjPayments.GetTotalByAct([CtCodActBankTransfer, CtCodActCheque2]));
    Result :=
      SepCol + CtTxtFtrCheque + SepCol + Format (ViTxtFmtPrice, [ValPayment1]) +
      SepCol + CtTxtFtrSavCard + SepCol + Format (ViTxtFmtPrice, [ValPayment2]) +
      SepCol + CtTxtFtrBankTrans + SepCol + Format (ViTxtFmtPrice,
        // Cheque2 = bank transfer key on B&Q keyboard.
        [ValPayment3]);
  end;
end;   // of TFrmVSRptGenInvInvoice.GetPaymentBodyLine

//=============================================================================

function TFrmVSRptGenInvInvoice.GetPaymentAmount (NumPrior       : Integer;
                                                  ValNormPayment : Double) :
                                                                         Double;
var
  CntItem   : Integer;
  FlgValSet : Boolean;
begin // of TFrmVSRptGenInvInvoice.GetPaymentAmount
  Result := 0;
  FlgValSet := False;
  if Assigned(LstRetourPayments) then begin
    for CntItem := 0 to LstRetourPayments.Count - 1 do begin
      if TObjRetourPayment(LstRetourPayments[CntItem]).NumPriority = NumPrior
      then begin
        if ABS(TObjRetourPayment(LstRetourPayments[CntItem]).ValInclVAT) <
           ValTotalRetour then begin
          Result := ValNormPayment - ABS(TObjRetourPayment(
                    LstRetourPayments[CntItem]).ValInclVAT);
          ValTotalRetour := ValTotalRetour - ABS(TObjRetourPayment(
                            LstRetourPayments[CntItem]).ValInclVAT);
        end
        else begin
          Result := ValNormPayment - ValTotalRetour;
          ValTotalRetour := 0;
        end;
        FlgValSet := True;
      end
      else if not FlgValSet then
        Result := ValNormPayment;
    end;
  end
  else
    Result := ValNormPayment;
end; // of TFrmVSRptGenInvInvoice.GetPaymentAmount

//=============================================================================
// TFrmVSRptGenInvInvoice.GetBankCard: get bank card data from the tickets
//  loaded.  Returns the first bank card line found in the tickets.
//                                     ---
// RESULT : string containing first bank card number found in ticket lines.
//=============================================================================

function TFrmVSRptGenInvInvoice.GetBankCard: string;
var
  CntTick          : Integer;          // variable_comment
  LstNumCard       : TStringList;
begin  // of TFrmVSRptGenInvInvoice.GetBankCard
  if FNumCard = '' then begin
    for CntTick := 0 To LstTransTicket.Count - 1 do begin
      LstNumCard :=
        TObjTransTicketCA (LstTransTicket[CntTick]).GetUniqueTransField('NumCard');
      if LstNumCard.Count > 0 then begin
        if LstNumCard[0] <> '' then begin
          Result := Copy(LstNumCard[0],0,20);
          FNumCard := Result;
        end;
        Break;
      end;
    end;
  end
  else
    Result := FNumCard;
end;   // of TFrmVSRptGenInvInvoice.GetBankCard

//=============================================================================

procedure TFrmVSRptGenInvInvoice.PrintTicketLine(
  ObjTransTicket: TObjTransTicketCA; FlgStart: Boolean);
var
  TxtBody          : string;
  TxtFmt           : string;
begin  // of TFrmVSRptGenInvInvoice.PrintTicketLine
  TxtBody := GetTicketBodyLine(ObjTransTicket, FlgStart);
  TxtFmt := Format ('%s%d', [FormatAlignLeft, 5093])      + SepCol +
    Format ('%s%d', [FormatAlignRight, 823])     + SepCol +
    Format ('%s%d', [FormatAlignRight, 1418])  + SepCol +
    Format ('%s%d', [FormatAlignRight, 1190])      + SepCol +
    Format ('%s%d', [FormatAlignRight, 1531]);
  if TxtBody <> '' then begin
    if FlgStart then
      AddTableLine (txtFmt, TxtBody)
      //VspPreview.AddTable (TxtFmt, '',TxtBody,
        //               clWhite, clWhite, False)
    else
      AddTableLine (TransFmtLine, TxtBody);
  end;

end;   // of TFrmVSRptGenInvInvoice.PrintTicketLine

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                               CtTxtSrcDate);
end.   // of FVSRptGenInvInvoice

