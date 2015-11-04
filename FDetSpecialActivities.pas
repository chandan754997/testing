//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint
// Unit     : FDetSpecialActivities: DETail form for SPECIAL ACTIVITIES report
//-----------------------------------------------------------------------------
// PVCS    : $
// History :
//=============================================================================

unit FDetSpecialActivities;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SfVSPrinter7,
  SmVSPrinter7Lib_TLB;

//******************************************************************************
// Global definitions
//******************************************************************************

Const
  CtMaxNumDays        = 30;


	CtCodActLogon       = 0;
	CtCodActLogoff      = 52;
  CtCodActStore       = 58;
	CtCodActRecall      = 59;
  CtCodActOpenDrawer  = 62;
  CtCodActCancelSale  = 86;
	CtCodActManDiscount = 90;
	CtCodActReprint     = 111;
  CtCodActChangePrice = 120;
	CtCodActPostSalesVoid = 154;
  CtCodActOfflineCoupon = 155;
  CtTxtDatFormatChina = 'yyyy-mm-dd';


resourcestring     // of header.
  CtTxtTitle            = 'SPECIAL ACTIVITIES REPORT';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtSearchDate       = 'Ticket date between %s and %s';
  CtTxtSearchOperator   = 'Cashier n°: %s';
  CtTxtSearchCheckout   = 'Till n°: %s';
  CtTxtHeaderSep        = '; ';

resourcestring     // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more then %s days';
  CtTxtErrorHeader      = 'Incorrect Date';

resourcestring     // of table header
  CtTxtOperatorNum      = 'Cashier n°';
  CtTxtCheckoutNum      = 'Till n°';
  CtTxtIntervention     = 'Intervention type';
  CtTxtTime             = 'Time';
  CtTxtAmount           = 'Amount';
  CtTxtTransNum         = 'Transaction';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetSpecialActivities = class(TFrmDetGeneralCA)
    LblDate: TLabel;
    Panel2: TPanel;
    ChkLbxCheckout: TCheckListBox;
    BtnSelectAllCheckout: TBitBtn;
    BtnDESelectAllCheckout: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnSelectAllClickCheckout(Sender: TObject);
    procedure BtnDeSelectAllClickCheckout(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    // General
    procedure AutoStart (Sender : TObject); override;
    function GetItemsSelected : Boolean; override;

    // Formats of the report
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
  public
    { Public declarations }
    function BuildQrySpecialActivities : string; virtual;

    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;
    procedure Execute; override;
  end;

var
  FrmDetSpecialActivities: TFrmDetSpecialActivities;

//******************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  DFpnUtils,
  DFpnTradeMatrix,
  DFpnSpecialActivities;

{$R *.dfm}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetSpecialActivities';

const  // PVCS-keywords
  CtTxtSrcName    = '$ $';
  CtTxtSrcVersion = '$ $';
  CtTxtSrcDate    = '$ $';

//******************************************************************************
// Implementation of TFrmDetSpecialActivities
//******************************************************************************

procedure TFrmDetSpecialActivities.AutoStart (Sender : TObject);
begin  // of TFrmDetSpecialActivities.AutoStart
  inherited;
  // Fill checkout checkbox listbox
  try
    if DmdFpnUtils.QueryInfo
        ('SELECT IdtCheckout, TxtPublDescr' +
      #10'FROM WorkStat WHERE CodType = 1') then begin
      DmdFpnUtils.QryInfo.First;
      ChkLbxCheckout.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ChkLbxCheckout.Items.AddObject
           (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsString + ' : ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString,
            TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetSpecialActivities.AutoStart

//=============================================================================

procedure TFrmDetSpecialActivities.BtnDeSelectAllClickCheckout(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetSpecialActivities.BtnDeSelectAllClickCheckout
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := False;
end;   // of TFrmDetSpecialActivities.BtnDeSelectAllClickCheckout

//=============================================================================

procedure TFrmDetSpecialActivities.BtnSelectAllClickCheckout(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetSpecialActivities.BtnSelectAllClickCheckout
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do
    ChkLbxCheckout.Checked [CntIx] := True;
end;   // of TFrmDetSpecialActivities.BtnSelectAllClickCheckout

//==============================================================================

function TFrmDetSpecialActivities.GetFmtTableHeader: string;
begin  // of TFrmDetSpecialActivities.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (30, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetSpecialActivities.GetFmtTableHeader

//=============================================================================

function TFrmDetSpecialActivities.GetFmtTableBody : string;
begin  // of TFrmDetSpecialActivities.GetFmtTableBody
  Result := '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (30, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetSpecialActivities.GetFmtTableBody

//=============================================================================

function TFrmDetSpecialActivities.GetFmtTableSubTotal : string;
begin  // of TFrmDetSpecialActivities.GetFmtTableSubTotal
  Result := '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (10, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (30, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False)) + TxtSep +
            '^+' + IntToStr (CalcWidthText (15, False));
end;   // of TFrmDetSpecialActivities.GetFmtTableSubTotal

//=============================================================================

function TFrmDetSpecialActivities.GetTxtTableTitle : string;
begin  // of TFrmDetSpecialActivities.GetTxtTableTitle
  Result :=   CtTxtOperatorNum  + TxtSep +
              CtTxtCheckoutNum  + TxtSep +
              CtTxtIntervention + TxtSep +
              CtTxtTime         + TxtSep +
              CtTxtAmount       + TxtSep +
              CtTxtTransNum;
end;   // of TFrmDetSpecialActivities.GetTxtTableTitle

//=============================================================================

function TFrmDetSpecialActivities.GetTxtTableFooter : string;
begin  // of TFrmDetSpecialActivities.GetTxtTableFooter
  Result := TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
            TxtSep;
end;   // of TFrmDetSpecialActivities.GetTxtTableFooter

//=============================================================================

function TFrmDetSpecialActivities.GetTxtTitRapport : string;
begin  // of TFrmDetSpecialActivities.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetSpecialActivities.GetTxtTitRapport

//=============================================================================

function TFrmDetSpecialActivities.GetTxtRefRapport : string;
begin  // of TFrmDetSpecialActivities.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0038';
end;   // of TFrmDetSpecialActivities.GetTxtRefRapport

//=============================================================================

procedure TFrmDetSpecialActivities.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  CntIx            : Integer;          // Looping the CheckListBox.
  TxtOperators     : string;           // Selected operators
  TxtCheckouts     : string;           // Selected checkouts
begin  // of TFrmDetSpecialActivities.PrintHeader
  inherited;
  // Report title
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  // Tradematrix information
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  // Search criteria
  TxtHdr := TxtHdr + Format (CtTxtSearchDate,
            [FormatDateTime (CtTxtDatFormatChina, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormatChina, DtmPckDayTo.Date)]);
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      if TxtOperators = '' then
        TxtOperators := IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx]))
      else
        TxtOperators := TxtOperators + ', ' + IntToStr(Integer(
                        ChkLbxOperator.Items.Objects[CntIx]));
    end;
  end;
  if TxtOperators <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format (CtTxtSearchOperator,
              [TxtOperators]);
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
    if ChkLbxCheckout.Checked [CntIx] then begin
      if TxtCheckouts = '' then
        TxtCheckouts := IntToStr(Integer(ChkLbxCheckout.Items.Objects[CntIx]))
      else
        TxtCheckouts := TxtCheckouts + ', ' + IntToStr(Integer(
                        ChkLbxCheckout.Items.Objects[CntIx]));
    end;
  end;
  if TxtCheckouts <> '' then
    TxtHdr := TxtHdr + CtTxtHeaderSep + Format (CtTxtSearchCheckout,
              [TxtCheckouts]);

    // Report date
  TxtHdr := TxtHdr + CRLF + CRLF + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormatChina, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
  VspPreview.CurrentY := VspPreview.CurrentY + 600;
end;   // of TFrmDetSpecialActivities.PrintHeader

//=============================================================================

procedure TFrmDetSpecialActivities.PrintTableBody;
var
  TxtLine          : string;           // Line to print
  TxtSQL           : string;
begin  // of TFrmDetSpecialActivities.PrintTableBody
  inherited;
  txtSQL := BuildQrySpecialActivities;
  try
    DmdFpnSpecialActivities.QryPosActions.SQL.Text := txtSQL;
    DmdFpnSpecialActivities.QryPosActions.Open;
    while not DmdFpnSpecialActivities.QryPosActions.Eof do begin
      TxtLine :=
        DmdFpnSpecialActivities.QryPosActions.FieldByName('IdtOperator').AsString +
        TxtSep +
        DmdFpnSpecialActivities.QryPosActions.FieldByName('IdtCheckout').AsString +
        TxtSep +
        DmdFpnSpecialActivities.QryPosActions.FieldByName('ActionDescr').AsString +
        TxtSep + FormatDateTime(CtTxtDatFormatChina,
        DmdFpnSpecialActivities.QryPosActions.FieldByName('DatSale').AsDateTime) +
        ' ' + FormatDateTime(CtTxtHouFormatS,
        DmdFpnSpecialActivities.QryPosActions.FieldByName('DatSale').AsDateTime) +
        TxtSep +  CurrToStrF (DmdFpnSpecialActivities.QryPosActions.FieldByName('ValAmount').AsCurrency, ffFixed, DmdFpnUtils.QtyDecsValue) +
        TxtSep +
        DmdFpnSpecialActivities.QryPosActions.FieldByName('IdtPOSTransaction').AsString;

      VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
      DmdFpnSpecialActivities.QryPosActions.Next;
    end;
  finally
    DmdFpnSpecialActivities.QryPosActions.Close;
  end;
end;   // of TFrmDetSpecialActivities.PrintTableBody

//=============================================================================

procedure TFrmDetSpecialActivities.PrintTableFooter;
begin  // of TFrmDetSpecialActivities.PrintTableFooter
  VspPreview.Text := CRLF;
end;   // of TFrmDetSpecialActivities.PrintTableFooter

//=============================================================================

procedure TFrmDetSpecialActivities.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetSpecialActivities.BtnPrintClick
  ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      Application.MessageBox(PChar(CtTxtStartEndDate),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if DtmPckDayFrom.Date > Now then begin
      DtmPckDayFrom.Date := Now;
      Application.MessageBox(PChar(CtTxtStartFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if DtmPckDayTo.Date > Now then begin
      DtmPckDayto.Date := Now;
      Application.MessageBox(PChar(CtTxtEndFuture),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayto.Date := Now;
      Application.MessageBox(PChar(Format (CtTxtMaxDays,
                             [IntToStr(CtMaxNumDays)])),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
     inherited;
  end;
end;   // of TFrmDetSpecialActivities.BtnPrintClick

//=============================================================================

function TFrmDetSpecialActivities.BuildQrySpecialActivities: string;
var
  TxtOperators     : string;
  TxtCheckouts     : string;
  CntIx            : integer;
begin  // of TFrmDetSpecialActivities.BuildQrySpecialActivities
  // overlopen listbox operators
  TxtOperators := '';
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      if TxtOperators = '' then
        TxtOperators := IntToStr(Integer(ChkLbxOperator.Items.Objects[CntIx]))
      else
        TxtOperators := TxtOperators + ', ' + IntToStr(Integer(
                        ChkLbxOperator.Items.Objects[CntIx]));
    end;
  end;
  // overlopen listbox checkout
  TxtCheckouts := '';
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
    if ChkLbxCheckout.Checked [CntIx] then begin
      if TxtCheckouts = '' then
        TxtCheckouts := IntToStr(Integer(ChkLbxCheckout.Items.Objects[CntIx]))
      else
        TxtCheckouts := TxtCheckouts + ', ' + IntToStr(Integer(
                        ChkLbxCheckout.Items.Objects[CntIx]));
    end;
  end;

  Result :=
    'SELECT *, ApplicDescr.TxtChcLong as ActionDescr ' +
    #10'FROM POSAction ' +
    #10'LEFT JOIN ApplicDescr ON ' +
      #10'IdtApplicConv = ' + AnsiQuotedStr('CodAction', '''') +
      #10'AND TxtTable = ' + AnsiQuotedStr('POSAction', '''') +
      #10'AND TxtFldCode = POSAction.CodAction ' +
      #10'AND IdtLanguage = ' + AnsiQuotedStr(DmdFpnUtils.IdtLanguageMain, '''') +
    #10'WHERE CodAction in (' +
                            IntToStr(CtCodActLogon) + ', ' +
                            IntToStr(CtCodActLogoff) + ', ' +
                            IntToStr(CtCodActStore) + ', ' +
                            IntToStr(CtCodActRecall) + ', ' +
                            IntToStr(CtCodActOpenDrawer) + ', ' +
                            IntToStr(CtCodActCancelSale) + ', ' +
                            IntToStr(CtCodActManDiscount) + ', ' +
                            IntToStr(CtCodActReprint) + ', ' +
                            IntToStr(CtCodActChangePrice) + ', ' +
                            IntToStr(CtCodActPostSalesVoid) + ', ' +
                            IntToStr(CtCodActOfflineCoupon) + ')' +
    #10'AND DatSale >= ' + AnsiQuotedStr(FormatDateTime('YYYY-MM-DD', DtmPckDayFrom.Date) + ' 00:00:00', '''') +
    #10'AND DatSale <= ' + AnsiQuotedStr(FormatDateTime('YYYY-MM-DD', DtmPckDayTo.Date) + ' 23:59:59', '''') ;
    if TxtOperators <> '' then begin
      Result := Result +
                #10'AND IdtOperator in (' + TxtOperators + ')';
    end;
    if TxtCheckouts <> '' then begin
      Result := Result +
                #10'AND IdtCheckout in (' + TxtCheckouts + ')';
    end;


end;   // of TFrmDetSpecialActivities.BuildQrySpecialActivities

//=============================================================================

procedure TFrmDetSpecialActivities.FormCreate(Sender: TObject);
begin
  inherited;
  Panel1.Height := StsBarExec.Top - Panel1.top - 10;
  Panel2.Height := StsBarExec.Top - Panel2.top - 10;
end;

//=============================================================================

procedure TFrmDetSpecialActivities.Execute;
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
end;   // of TFrmDetSpecialActivities.Execute

//=============================================================================

function TFrmDetSpecialActivities.GetItemsSelected: Boolean;
var
  CntIx      : Integer;          // Loop the checkouts in the Checklistbox
begin  // of TFrmDetSpecialActivities.GetItemsSelected
  Result := False;
  for CntIx := 0 to Pred (ChkLbxCheckout.Items.Count) do begin
    if ChkLbxCheckout.Checked [CntIx] then begin
      Result := True;
      Break;
    end;
  end;

  if Result then
    Result := inherited GetItemsSelected;

end;   // of TFrmDetSpecialActivities.GetItemsSelected

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetSpecialActivities
