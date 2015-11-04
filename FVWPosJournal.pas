//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet : FlexPoint
// Unit   : FVWPosJournal : Form VieW POS JOURNAL
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVWPosJournal.pas,v 1.1 2006/12/18 16:07:52 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVWPosJournal - CVS revision 1.1
//=============================================================================

unit FVWPosJournal;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, Menus, ComCtrls, StdCtrls, Buttons, ExtCtrls, Db,
  ScEHdler, ActnList, ImgList, Variants;

//*****************************************************************************
// Global Identifiers
//*****************************************************************************

resourcestring  // Indentification on printed report
  CtTxtPosJournalHeader = 'POS Journal Print-Out';

const
  CtValTicketWidth = 420;      // Width of the ticket in VS-View

const  // Type of ticket visualisation action
  CtCodVisActDisplay = 1;
  CtCodVisActPrint   = 2;
  CtCodVisActSave    = 3;

const  // Maximum of Ticket action type
  CtCodVisActHigh = CtCodVisActSave;

//=============================================================================

var  // Total width of ticket in preview
  ViValTicketWidthPreview    : Integer = 58;

var  // Format's for ticket
  ViTxtFmtQty           : string  = '%5s';     // Format Quantity
  ViTxtFmtDescr         : string  = '%-33.33s';// Format Description
  ViTxtFmtHdrPrice      : string  = '%8s';     // Format Header Price
  ViTxtFmtPrice         : string  = '%8.2f';   // Format Price
  ViTxtFmtHdrAmount     : string  = '%10s';    // Format Header Amount
  ViTxtFmtAmount        : string  = '%10.2f';  // Format Amount
  ViTxtFmtApproval      : string  = 'Approval: %s: %-20.20s';

//*****************************************************************************
// TFrmVWPosJournal
//*****************************************************************************

type
  TFrmVWPosJournal = class(TFrmCommon)
    PnlBtnsTop: TPanel;
    BtnClose: TSpeedButton;
    LblTicketNumber: TLabel;
    LblCurTicketNumber: TLabel;
    PnlScroll: TPanel;
    BtnNext: TSpeedButton;
    BtnPrevious: TSpeedButton;
    BtnLast: TSpeedButton;
    BtnFirst: TSpeedButton;
    SbxElecJournal: TScrollBox;
    SbrJournal: TScrollBar;
    StsBarDetail: TStatusBar;
    MnuDetPosJournal: TMainMenu;
    MniFile: TMenuItem;
    MniSave: TMenuItem;
    MniPrint: TMenuItem;
    MniPrintTicket: TMenuItem;
    MniPrintAllTicket: TMenuItem;
    MniSep: TMenuItem;
    MniExit: TMenuItem;
    RchEdtTicket: TRichEdit;
    PnlShadow: TPanel;
    SavDlg: TSaveDialog;
    ActLstReport: TActionList;
    ActAbout: TAction;
    MniHelp: TMenuItem;
    MniAbout: TMenuItem;
    ActDSFirst: TAction;
    ActDSPrevious: TAction;
    ActDSNext: TAction;
    ActDSLast: TAction;
    ActClose: TAction;
    ActSaveAll: TAction;
    ActPrintTicket: TAction;
    ActPrintAll: TAction;
    ImgLstFrm: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SbrJournalChange(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActDSNavigateExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActPrintTicketExecute(Sender: TObject);
    procedure ActPrintAllExecute(Sender: TObject);
    procedure ActSaveAllExecute(Sender: TObject);
  private
    { Private declarations }
  protected
    { Protected declarations }
    // Datafields current view
    QtyLines            : Integer;     // The Lines shown
    QtyTickets          : Integer;     // Total tickets in selection
    ValCurrentTicket    : Integer;     // Current number of ticket in selection
    FntHeader           : TFont;       // Font of header item
    FntNormal           : TFont;       // Normal Font of ticket
    ImgLogo             : TImage;      // Picture with logo
    CodVisActCurrent    : Integer;     // Action for ticket (display/print/...)
    ValTicketStartY     : Integer;     // Startposition of ticket when printing
    TxtFileName         : string;      // Name of file to save report to
    TxSave              : TextFile;    // File to save report to

    // Datafields for properties
    FTxtIdtSelOperator  : string;      // String with the operator Id's
    FTxtIdtSelCheckout  : string;      // String with the checkout Id's
    FDatFrom            : TDateTime;   // Date From
    FDatTo              : TDateTime;   // Dat To
    FTxtOrder           : string;      // Sort-string
    FDstLstTrans        : TDataSet;    // DataSet for transaction list
    FDstDetTrans        : TDataSet;    // DataSet for transaction list
    FFlgShowApproval    : Boolean;     // If approvals must be shown on ticket

    // Datafields identification of current POSTransaction
    IdtPosTransaction   : Integer;     // Ticket number
    IdtCheckOut         : Integer;     // Checkout number
    CodTrans            : Integer;     // CodTrans of current POSTransaction
    DatTransBegin       : TDateTime;   // Date Ticket

    procedure Init; virtual;
    procedure AddLineToTicket(TxtLine: string;
                              FntLine: TFont); virtual;
    procedure AddCustomerHeader; virtual;
    procedure AddTicketHeader; virtual;
    procedure AddTicketLine; virtual;
    procedure AddTicketLines; virtual;
    procedure AddTicketFooter; virtual;
    procedure ShowCurrentTicket; virtual;

    procedure RetrieveCurrentTicketInfo; virtual;

    // Methods to print the report
    procedure PrintReportHeader; virtual;
    procedure VspPreviewNewPage (Sender: TObject); virtual;
    procedure VspPreviewEndPage (Sender: TObject); virtual;
    procedure DrawLogo; virtual;
    procedure PrintTicket; virtual;
    procedure PrintAllTickets; virtual;

    procedure SaveToFile; virtual;

    // Events assigned at runtime
    procedure DstLstTransAfterScroll (DataSet: TDataSet); virtual;
    procedure DstLstTransAfterOpen (DataSet: TDataSet); virtual;
  public
    { Public declarations }
    // Properties
    property TxtIdtSelOperator: string read  FTxtIdtSelOperator
                                       write FTxtIdtSelOperator;
    property TxtIdtSelCheckout: string read  FTxtIdtSelCheckout
                                       write FTxtIdtSelCheckout;
    property DatFrom: TDateTime read  FDatFrom
                                write FDatFrom;
    property DatTo: TDateTime read  FDatTo
                              write FDatTo;
    property TxtOrderBy: string read  FTxtOrder
                                write FTxtOrder;
    property DstLstTrans: TDataSet read  FDstLstTrans
                                   write FDstLstTrans;
    property DstDetTrans: TDataSet read  FDstDetTrans
                                   write FDstDetTrans;
    property FlgShowApproval: Boolean read  FFlgShowApproval
                                      write FFlgShowApproval;
  end;

var
  FrmVWPosJournal: TFrmVWPosJournal;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  DBTables,

  StStrW,

  SfDialog,
  SfVSPrinter7,
  SrStnCom,
  SmFile,
  SmUtils,
  SmVSPrinter7Lib_TLB,

  DFpnUtils,
  DFpnPosTransaction,
  RFpnCom;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVWPosJournal';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVWPosJournal.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 16:07:52 $';

//*****************************************************************************
// Implementation of TFrmVWPosJournal
//*****************************************************************************

//=============================================================================
// TFrmVWPosJournal.Init : Initialization that need to be done if the
// form is shown
//=============================================================================

procedure TFrmVWPosJournal.Init;
begin // of TFrmVWPosJournal.Init
  LblTicketNumber.Visible := False;
  LblCurTicketNumber.visible := False;
  ActSaveAll.Enabled := False;
  ActPrintTicket.Enabled := ActSaveAll.Enabled;
  ActPrintAll.Enabled := ActSaveAll.Enabled;

  QtyTickets := 0;

  SbrJournal.Min := 0;
  SbrJournal.Position := 0;
  SbrJournal.Max := 0;
  CodVisActCurrent := CtCodVisActDisplay;

  PnlShadow.Width := CtValTicketWidth;
  RchEdtTicket.Width := CtValTicketWidth;

  SavDlg.InitialDir := ExtractFilePath (ExtractFileDir (Application.ExeName)) +
                       'SPOOL\';

  DstLstTrans := DmdFpnPosTransaction.QryLstPosTransaction;
  DstLstTrans.AfterScroll := DstLstTransAfterScroll;
  DstLstTrans.AfterOpen   := DstLstTransAfterOpen;

  DstDetTrans := DmdFpnPosTransaction.QryLstPOSTransDetail;

  if DstLstTrans.Active then
    DstLstTrans.Active := False;
  DmdFpnPosTransaction.BuildSQLLstPOSTrans
    (FTxtIdtSelOperator, FTxtIdtSelCheckout, DatFrom, DatTo, TxtOrderBy,
     DmdFpnPosTransaction.LstConditionItems);
  DstLstTrans.Active := True;

  QtyTickets := DstLstTrans.RecordCount;
  if QtyTickets = 0 then
    ValCurrentTicket := 0
  else
    ValCurrentTicket := 1;

  SbrJournal.Max := QtyTickets;
  SbrJournal.Min := ValCurrentTicket;
  SbrJournal.Position := ValCurrentTicket;
  StsBarDetail.Panels[0].Text := Format ('%s %d/%d', [CtTxtQtyTickets,
                                                      ValCurrentTicket,
                                                      QtyTickets]);
end;  // of TFrmVWPosJournal.Init

//=============================================================================
// TFrmVWPosJournal.AddLineToTicket : Adds the line to the ticket after checking
//    which kind of ticket
//                                  -----
// INPUT  : TxtLine = The text that has to be added to the ticket
//          FntLine = The font in which the texts needs to be displayed
//=============================================================================

procedure TFrmVWPosJournal.AddLineToTicket (TxtLine : string;
                                            FntLine : TFont );
begin // of TFrmVWPosJournal.AddLineToTicket
  Inc (QtyLines);
  case CodVisActCurrent of
    CtCodVisActDisplay : begin
      RchEdtTicket.SelAttributes.Assign (FntLine);
      RchEdtTicket.Lines.Add (TxtLine);
    end;  // of CodVisActCurrent = CtCodVisActDisplay

    CtCodVisActPrint : begin
      FrmVSPreview.VspPreview.TableCell[TcRows, null, null,
                                        null, null] := QtyLines;
      FrmVSPreview.VspPreview.TableCell[tcForeColor, QtyLines - 1, 1,
                                        null, null] := FntLine.Color;
      FrmVSPreview.VspPreview.TableCell[tcFontBold, QtyLines - 1, 1,
                                        null, null] :=
                                        Ord (fsBold in FntLine.Style);
      FrmVSPreview.VspPreview.TableCell[tcText, QtyLines - 1, 1,
                                        null, null] := TxtLine;
    end;  // of CodVisActCurrent = CtCodVisActPrint

    CtCodVisActSave : begin
      FTxWrite (TxtFileName, TxSave, TxtLine + #13#10);
    end;  // of CodVisActCurrent = CtCodVisActSave
  end;  // of case CodVisActCurrent of ...
end;  // of TFrmVWPosJournal.AddLineToTicket

//=============================================================================
// TFrmVWPosJournal.AddCustomerHeader : Add the customer info to the header
// of the ticket.
//=============================================================================

procedure TFrmVWPosJournal.AddCustomerHeader;
var
  TxtHdr           : string;           // Build the header line
  TxtLine          : string;           // Build the data line to add
  PctDiscount      : Currency;         // Get PctDiscount
begin // of TFrmVWPosJournal.AddCustomerHeader
  if DstLstTrans.FieldByName ('IdtCustomer').IsNull then
    Exit;

  AddLineToTicket (' ', FntNormal);
  TxtHdr  := '';
  TxtLine := '';

  PctDiscount := DstLstTrans.FieldByName ('PctDiscount').AsInteger;
  if PctDiscount <> 0 then begin
    TxtHdr  := CtTxtDiscount;
    TxtLine := Format ('%f',[PctDiscount]) + '%';
  end;
  TxtHdr  := PadString (CharStrW (' ', 3) + CtTxtCustomer + ' ' +
                   DstLstTrans.FieldByName ('IdtCustomer').AsString,
                   ViValTicketWidthPreview - Length (TxtHdr)) + TxtHdr;
  TxtLine := PadString (CharStrW (' ', 3) +
                   DstLstTrans.FieldByName ('TxtNameCustomer').AsString,
                   ViValTicketWidthPreview - Length (TxtLine)) + TxtLine;
  AddLineToTicket (TxtHdr, FntHeader);
  AddLineToTicket (TxtLine, FntNormal);

  AddLineToTicket (CharStrW (' ', 3) +
                   DstLstTrans.FieldByName ('TxtStreet').AsString + ' ',
                   FntNormal);
  AddLineToTicket (CharStrW (' ', 3) +
                   DstLstTrans.FieldByName ('TxtMunicip').AsString,
                   FntNormal);
end;  // of TFrmVWPosJournal.AddCustomerHeader

//=============================================================================
// TFrmVwPosJournal.AddTicketHeader : Adds the header of the ticket
//=============================================================================

procedure TFrmVwPosJournal.AddTicketHeader;
var
  TxtLine          : string;           // Build the line to add
  IdtInvDeliv      : Integer;          // Get IdtInvoice or IdtDelivNote
begin // of TFrmVwPosJournal.AddTicketHeader
  TxtLine := '';

  IdtInvDeliv := DstLstTrans.FieldByName ('IdtInvoice').AsInteger;
  if IdtInvDeliv <> 0 then
    TxtLine := Format ('%s %d - ', [CtTxtInvoice, IdtInvDeliv]);

  IdtInvDeliv := DstLstTrans.FieldByName ('IdtDelivNote').AsInteger;
  if IdtInvDeliv <> 0 then
    TxtLine := Format ('%s%s %d - ', [TxtLine, CtTxtDelivNote, IdtInvDeliv]);

  if TxtLine = '' then
    TxtLine := Format ('%s - ', [CtTxtTicket]);

  TxtLine := '   ' + TxtLine +
             CtTxtCheckout + ' ' + IntToStr (IdtCheckout) + ' ' +
             CtTxtOperator + ' ' +
             DstLstTrans.FieldByName ('IdtOperator').AsString +
             ' (' + DstLstTrans.FieldByName ('TxtName').AsString + ')';

  AddLineToTicket ('', FntHeader);
  AddLineToTicket (TxtLine, FntHeader);
  if DstLstTrans.FieldByName ('FlgTraining').AsInteger = 1 then
    AddLineToTicket ('   ' + CtTxtTraining, FntHeader);
  if DstLstTrans.FieldByname ('CodReturn').AsInteger = CtCodPtrDeliveryNote then
    AddLineToTicket ('   ' + CtTxtTransDelivNote, FntHeader)
  else if DstLstTrans.FieldByname ('CodReturn').AsInteger = CtCodPtrInvoice then
    AddLineToTicket ('   ' + CtTxtTransInvoice, FntHeader);
  AddCustomerHeader;

  AddLineToTicket ('', FntNormal);
  AddLineToTicket (' ' + Format (ViTxtFmtQty, [CtTxtQuantity]) +
                   ' ' + Format (ViTxtFmtDescr, [CtTxtHdrDescr]) +
                   Format (ViTxtFmtHdrPrice, [CtTxtHdrPrice]) +
                   Format (ViTxtFmtHdrAmount, [CtTxtAmount]),
                   FntHeader);
end;  // of TFrmVwPosJournal.AddTicketHeader

//=============================================================================
// TFrmVWPosJournal.AddTicketLine : Adds one detail line to the ticket
//=============================================================================

procedure TFrmVWPosJournal.AddTicketLine;
var
  TxtLine          : string;           // To build the line to add
  QtyReg           : Integer;          // Get QtyReg from dataset
begin // of TFrmVWPosJournal.AddTicketLine
  QtyReg := DstDetTrans.FieldByName ('QtyReg').AsInteger;

  if QtyReg <> 0 then
    TxtLine := ' ' + Format (ViTxtFmtQty, [IntToStr (QtyReg)])
  else
    TxtLine := ' ' + Format (ViTxtFmtQty, [' ']);

  TxtLine := TxtLine + ' ' +
             Format (ViTxtFmtDescr,
                     [DstDetTrans.FieldByName ('TxtDescr').AsString]) +
             Format (ViTxtFmtPrice,
                     [DstDetTrans.FieldByName ('PrcInclVat').AsCurrency]) +
             Format (ViTxtFmtAmount,
                     [DstDetTrans.FieldByName ('ValInclVat').AsCurrency]);
  
  AddLineToTicket (TxtLine, FntNormal);
  if FlgShowApproval and
     not DstDetTrans.FieldByName ('IdtOperApproval').IsNull then
    AddLineToTicket (Format (' ' + ViTxtFmtQty + '   ' + ViTxtFmtApproval,
              ['',
               DstDetTrans.FieldByName ('IdtOperApproval').AsString,
               DstDetTrans.FieldByName ('TxtNameApproval').AsString]),
               FntNormal);
end;  // of TFrmVWPosJournal.AddTicketLine

//=============================================================================
// TFrmVWPosJournal.AddTicketLines : Loops the detail lines of the ticket for
// adding
//=============================================================================

procedure TFrmVWPosJournal.AddTicketLines;
begin // of TFrmVWPosJournal.AddTicketLines
  DstDetTrans.First;
  while not DstDetTrans.EOF do begin
    AddTicketLine;
    DstDetTrans.Next;
  end;
end;  // of TFrmVWPosJournal.AddTicketLines

//=============================================================================
// TFrmVWPosJournal.AddTicketFooter : Adds the footer of the ticket
//=============================================================================

procedure TFrmVWPosJournal.AddTicketFooter;
begin // of TFrmVWPosJournal.AddTicketFooter
  // Get's the footer of the ticket
  AddLineToTicket ('', FntNormal);
  AddLineToTicket ('   ' + CtTxtTicketNumber + ' ' +
                   IntToStr (IdtPosTransaction) + CharStrW (' ', 10) +
                   DateTimeToStr (DatTransBegin), FntHeader);
  if FlgShowApproval and
     not DstLstTrans.FieldByName ('IdtOperApproval').IsNull then
    AddLineToTicket ('   ' +
      Format (ViTxtFmtApproval,
              [DstLstTrans.FieldByName ('IdtOperApproval').AsString,
               DstLstTrans.FieldByName ('TxtNameApproval').AsString]),
               FntHeader);
  if CodVisActCurrent = CtCodVisActDisplay then begin
    AddLineToTicket ('', FntHeader);
    AddLineToTicket ('', FntHeader);
  end;
end;  // of TFrmVWPosJournal.AddTicketFooter

//=============================================================================
// TFrmVWPosJournal.ShowCurrentTicket : Shows the ticket that is currently
//    the active record in the list dataset
//=============================================================================

procedure TFrmVWPosJournal.ShowCurrentTicket;
begin  // of TFrmVWPosJournal.ShowCurrentTicket
  // Initializations before creating ticket
  if CodVisActCurrent = CtCodVisActDisplay then
    RchEdtTicket.Clear;
  QtyLines := 0;

  // Creating ticket
  try
    AddTicketHeader;
    AddTicketLines;
  finally
    // Even when a problem occurs during show of ticket, always show footer,
    // since this is the only way to find out which ticket caused the problem.
    AddTicketFooter;
    if CodVisActCurrent = CtCodVisActDisplay then begin
      PnlShadow.Height := QtyLines * 16;
      RchEdtTicket.Height := QtyLines * 16;
      RchEdtTicket.Repaint;
      LblCurTicketNumber.Caption := IntToStr (IdtPosTransaction);
    end;
  end;
end;  // of TFrmVWPosJournal.ShowCurrentTicket

//=============================================================================
// TFrmVWPosJournal.FillMainTicketInformation : retrieving the main information
//    from the ticket and place it into local variables
//=============================================================================

procedure TFrmVWPosJournal.RetrieveCurrentTicketInfo;
begin // of TFrmVWPosJournal.RetrieveCurrentTicketInfo
  IdtPosTransaction  := DstLstTrans.FieldByName ('IdtPosTransaction').AsInteger;
  IdtCheckOut        := DstLstTrans.FieldByName ('IdtCheckout').AsInteger;
  CodTrans           := DstLstTrans.FieldByName ('CodTrans').AsInteger;
  DatTransBegin      := DstLstTrans.FieldByName ('DatTransBegin').AsDateTime;
end;  // of TFrmVWPosJournal.RetrieveCurrentTicketInfo

//=============================================================================
// TFrmVWPosJournal.PrintReportHeader : Sets the header of a report to print
//=============================================================================

procedure TFrmVWPosJournal.PrintReportHeader;
begin // of TFrmVWPosJournal.PrintReportHeader
  FrmVSPreview.VspPreview.OnNewPage := VspPreviewNewPage;
  FrmVSPreview.VspPreview.OnEndPage := VspPreviewEndPage;
  FrmVSPreview.VspPreview.Font.Assign (FntNormal);
  FrmVSPreview.VspPreview.MarginLeft := (FrmVSPreview.VspPreview.PageWidth -
                                        (CtValTicketWidth * 16)) / 2;
  FrmVSPreview.VspPreview.MarginRight := FrmVSPreview.VspPreview.MarginLeft;
  FrmVSPreview.VspPreview.Footer :=
    CtTxtPrintDate + ': ' + DateToStr (Now) + '||' + CtTxtPrintPage + ' %d';
  FrmVSPreview.VspPreview.TableBorder := tbNone;
end;  // of TFrmVWPosJournal.PrintReportHeader

//=============================================================================
// TFrmVWPosJournal.VspPreviewNewPage : Executed when a new pages ends used for
//    Drawing lines
//=============================================================================

procedure TFrmVWPosJournal.VspPreviewNewPage(Sender: TObject);
begin // of TFrmVWPosJournal.VspPreviewNewPage
  // Draw Logo
  DrawLogo;

  // Print's the page header
  FrmVSPreview.VspPreview.CurrentX := FrmVSPreview.VspPreview.MarginLeft;
  FrmVSPreview.VspPreview.CurrentY := 500;
  FrmVSPreview.VspPreview.Text     := DmdFpnUtils.TradeMatrixName;

  FrmVSPreview.VspPreview.CurrentX := FrmVSPreview.VspPreview.MarginLeft;
  FrmVSPreview.VspPreview.Fontbold := True;
  FrmVSPreview.VspPreview.CurrentY := FrmVSPreview.VspPreview.CurrentY + 200;
  FrmVSPreview.VspPreview.Text     := CtTxtPosJournalHeader;
  FrmVSPreview.VspPreview.Fontbold := False;

  FrmVSPreview.VspPreview.CurrentY := FrmVSPreview.VspPreview.CurrentY + 500;
end;  // of TFrmVWPosJournal.VspPreviewNewPage

//=============================================================================
// TFrmVWPosJournal.VspPreviewEndPage : Executed when a page ends used for
//    Drawing lines
//=============================================================================

procedure TFrmVWPosJournal.VspPreviewEndPage (Sender: TObject);
begin // of TFrmVWPosJournal.VspPreviewEndPage
  inherited;
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY);
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft +
                                    IntToStr (CtValTicketWidth * 16),
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    IntToStr (CtValTicketWidth * 16),
                                    FrmVSPreview.VspPreview.CurrentY);
  ValTicketStartY := FrmVSPreview.VspPreview.MarginTop;
end; // of TFrmVWPosJournal.VspPreviewEndPage

//=============================================================================
// TFrmVWPosJournal.DrawLogo : Retrieves the picture for the report
//=============================================================================

procedure TFrmVWPosJournal.DrawLogo;
begin  // of TFrmVWPosJournal.DrawLogo
  FrmVSPreview.DrawLogo (ImgLogo);
end;   // of TFrmVWPosJournal.DrawLogo

//=============================================================================
// TFrmVWPosJournal.PrintTicket : Prints one ticket of the current record in
// the list dataset
//=============================================================================

procedure TFrmVWPosJournal.PrintTicket;
begin // of TFrmVWPosJournal.PrintTicket
  ValTicketStartY := FrmVSPreview.VspPreview.CurrentY;

  // Draw Top line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);
  FrmVSPreview.VspPreview.StartTable;

  // Create a Column for a ticket
  FrmVSPreview.VspPreview.TableCell[TcCols, null, null, null, null] := 1;
  FrmVSPreview.VspPreview.TableCell[TcRows, null, null, null, null] := QtyLines;
  FrmVSPreview.VspPreview.TableCell[TcColwidth, 1, 1,
                                    null, null] := CtValTicketWidth * 16;
  Inc (QtyLines);

  ShowCurrentTicket;

  FrmVsPreview.VspPreview.EndTable;

  // Draw Bottom line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);

  // Draw Left Line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft,
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft,
                                    FrmVSPreview.VspPreview.CurrentY);
  // Draw Right Line
  FrmVSPreview.VspPreview.DrawLine (FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    ValTicketStartY,
                                    FrmVSPreview.VspPreview.MarginLeft +
                                    CtValTicketWidth * 16,
                                    FrmVSPreview.VspPreview.CurrentY);
end;  // of TFrmVWPosJournal.PrintTicket

//=============================================================================
// TFrmVWPosJournal.PrintAllTickets : Loops all tickets for printing
//=============================================================================

procedure TFrmVWPosJournal.PrintAllTickets;
var
  BmkLastPos       : TBookmark;        // Bookmark to save last position
begin // of TFrmVWPosJournal.PrintAllTickets
  CodVisActCurrent := CtCodVisActPrint;
  BmkLastPos := DstLstTrans.GetBookmark;
  try
    FrmVSPreview.Show;
    FrmVSPreview.Hide;
    PrintReportHeader;
    FrmVSPreview.VspPreview.StartDoc;

    DstLstTrans.First;
    while not DstLstTrans.Eof do begin
      PrintTicket;
      DstLstTrans.Next;
    end;
    FrmVSPreview.VspPreview.EndDoc;
    FrmVSPreview.ShowModal;
  finally
    CodVisActCurrent := CtCodVisActDisplay;
    if DstLstTrans.BookmarkValid (BmkLastPos) then
      DstLstTrans.GotoBookmark (BmkLastPos);
  end;
end;  // of TFrmVWPosJournal.PrintAllTickets

//=============================================================================
// TFrmVWPosJournal.SaveToFile : Saves all selected tickets to a given filename
//=============================================================================

procedure TFrmVWPosJournal.SaveToFile;
var
  BmkLastPos       : TBookmark;        // Bookmark to save last position
begin  // of TFrmVWPosJournal.SaveToFile
  CodVisActCurrent := CtCodVisActSave;
  FTxCreate (TxtFileName, TxSave);
  BmkLastPos := DstLstTrans.GetBookmark;
  try
    DstLstTrans.First;
    while not DstLstTrans.EOF do begin
      ShowCurrentTicket;

      FtxWrite (TxtFileName, TxSave, '' + #13#10);
      FtxWrite (TxtFileName, TxSave, '  ' + CharStrW ('-', 58) + #13#10);
      FtxWrite (TxtFileName, TxSave, '' + #13#10);
      DstLstTrans.Next;
    end;

  finally
    CodVisActCurrent := CtCodVisActDisplay;
    if DstLstTrans.BookmarkValid (BmkLastPos) then
      DstLstTrans.GotoBookmark (BmkLastPos);
    FtxClose (TxtFileName, TxSave);
  end;
end;   // of TFrmDetPosJournal.CreateTxtFile

//=============================================================================
// TFrmVWPosJournal - Event Handlers
//=============================================================================

procedure TFrmVWPosJournal.FormCreate(Sender: TObject);
var
  TxtImagePath     : string;           // Path of image directory
begin // of TFrmVWPosJournal.FormCreate
  inherited;
  FntNormal := TFont.Create;
  FntNormal.Size := 9;
  FntNormal.Name := 'COURIER NEW';

  FntHeader := TFont.Create;
  FntHeader.Assign (FntNormal);
  FntHeader.Color := clTeal;
  FntHeader.Style := [fsBold];

  ImgLogo := TImage.Create (Self);
  TxtImagePath := AddStartDirToFN ('\image');
  if FileExists (TxtImagePath + '\FlexPoint.Report.bmp') then begin
    ImgLogo.Picture.LoadFromFile (TxtImagePath + '\FlexPoint.Report.bmp');
  end;
 ImgLogo.AutoSize := True;

end;  // of TFrmVWPosJournal.FormCreate

//=============================================================================

procedure TFrmVWPosJournal.FormDestroy(Sender: TObject);
begin // of TFrmVWPosJournal.FormDestroy
  inherited;
  FntHeader.Free;
  FntNormal.Free;
end;  // of TFrmVWPosJournal.FormDestroy

//=============================================================================

procedure TFrmVWPosJournal.FormShow(Sender: TObject);
begin // of TFrmVWPosJournal.FormShow
  inherited;
  Init;
  if QtyTickets <> 0 then
    ShowCurrentTicket;
end;  // of TFrmVWPosJournal.FormShow

//=============================================================================

procedure TFrmVWPosJournal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin // of TFrmVWPosJournal.FormKeyDown
  inherited;
  case Key of
    VK_Down:  SbrJournal.Position := SbrJournal.Position + 1;
    VK_Up:    SbrJournal.Position := SbrJournal.Position - 1;
    VK_Next:  SbrJournal.Position := SbrJournal.Position +
                                     SbrJournal.LargeChange;
    VK_Prior: SbrJournal.Position := SbrJournal.Position -
                                     SbrJournal.LargeChange;
    VK_Home:  SbrJournal.Position := SbrJournal.Min;
    VK_End:   SbrJournal.Position := SbrJournal.Max;
  end;
end;  // of TFrmVWPosJournal.FormKeyDown

//=============================================================================

procedure TFrmVWPosJournal.SbrJournalChange(Sender: TObject);
var
  ValDiff          : Integer;          // Change made on scrollbar
begin // of TFrmVWPosJournal.SbrDetPosJournalChange
  inherited;
  ValDiff := SbrJournal.Position - ValCurrentTicket;
  ValCurrentTicket := SbrJournal.Position;
  if ValDiff <> 0 then
    DstLstTrans.MoveBy (ValDiff);
end;  // of TFrmVWPosJournal.SbrDetPosJournalChange

//=============================================================================

procedure TFrmVWPosJournal.ActAboutExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActAboutExecute
  inherited;
  ShowAbout;
end;  // of TFrmVWPosJournal.ActAboutExecute

//=============================================================================

procedure TFrmVWPosJournal.ActDSNavigateExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActDSNavigateExecute
  inherited;
  if Sender = ActDSFirst then begin
    ValCurrentTicket := 1;
    DstLstTrans.First;
  end
  else if Sender = ActDSLast then begin
    ValCurrentTicket := QtyTickets;
    DstLstTrans.Last;
  end
  else if Sender = ActDSNext then begin
    Inc (ValCurrentTicket);
    DstLstTrans.Next;
  end
  else if Sender = ActDSPrevious then begin
    Dec (ValCurrentTicket);
    DstLstTrans.Prior;
  end;
  SbrJournal.Position := ValCurrentTicket;
end;  // of TFrmVWPosJournal.ActDSNavigateExecute

//=============================================================================

procedure TFrmVWPosJournal.ActCloseExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActCloseExecute
  inherited;
  Close;
end;  // of TFrmVWPosJournal.ActCloseExecute

//=============================================================================

procedure TFrmVWPosJournal.ActPrintTicketExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActPrintTicketExecute
  inherited;
  CodVisActCurrent := CtCodVisActPrint;
  try
    FrmVSPreview.Show;
    FrmVSPreview.Hide;
    PrintReportHeader;
    FrmVSPreview.VspPreview.StartDoc;
    PrintTicket;
    FrmVSPreview.VspPreview.EndDoc;
    FrmVSPreview.ShowModal;
  finally
    CodVisActCurrent := CtCodVisActDisplay;
  end;
end;  // of TFrmVWPosJournal.ActPrintTicketExecute

//=============================================================================

procedure TFrmVWPosJournal.ActPrintAllExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActPrintAllExecute
  inherited;
  PrintAllTickets;
end;  // of TFrmVWPosJournal.ActPrintAllExecute

//=============================================================================

procedure TFrmVWPosJournal.ActSaveAllExecute(Sender: TObject);
begin // of TFrmVWPosJournal.ActSaveAllExecute
  inherited;
  if SavDlg.Execute then begin
    TxtFileName := SavDlg.FileName;
    SaveToFile;
  end;
end;  // of TFrmVWPosJournal.ActSaveAllExecute

//=============================================================================

procedure TFrmVWPosJournal.DstLstTransAfterScroll(DataSet: TDataSet);
begin // of TFrmVWPosJournal.DstLstTransAfterScroll
  RetrieveCurrentTicketInfo;

  // Set the detail dataset
  if DstDetTrans.Active then
    DstDetTrans.Active := False;
  DmdFpnPosTransAction.BuildSQLLstPOSTransDetailForTicket
    (IdtPOSTransaction, IdtCheckOut, CodTrans, DatTransBegin,
     'PosTransDetail.NumLineReg, PosTransDetail.NumSeq');
  DstDetTrans.Active := True;

  if CodVisActCurrent = CtCodVisActDisplay then begin
    if QtyTickets <> 0 then
      ShowCurrentTicket;

    ActDSFirst.Enabled := not DstLstTrans.Bof;
    ActDSPrevious.Enabled := ActDSFirst.Enabled;
    if not ActDSFirst.Enabled then begin
      ValCurrentTicket := 1;
    end;
    ActDSLast.Enabled := not DstLstTrans.Eof;
    ActDSNext.Enabled := ActDSLast.Enabled;
    if not ActDSLast.Enabled then begin
      ValCurrentTicket := QtyTickets;
    end;
    StsBarDetail.Panels[0].Text := Format ('%s %d/%d',[CtTxtQtyTickets,
                                                       ValCurrentTicket,
                                                       QtyTickets]);
  end;
end;  // of TFrmVWPosJournal.DstLstTransAfterScroll

//=============================================================================

procedure TFrmVWPosJournal.DstLstTransAfterOpen(DataSet: TDataSet);
begin // TFrmVWPosJournal.DstLstTransAfterOpen
  if not DstLstTrans.IsEmpty then begin
    LblTicketNumber.Visible := True;
    LblCurTicketNumber.visible := True;
    ActSaveAll.Enabled := True;
    ActPrintTicket.Enabled := ActSaveAll.Enabled;
    ActPrintAll.Enabled := ActSaveAll.Enabled;
  end
  else begin
    LblTicketNumber.Visible := False;
    LblCurTicketNumber.visible := False;
    RchEdtTicket.Clear;
    AddLineToTicket (CtTxtNoSelData, FntHeader);
  end;
  DmdFpnPosTransaction.CommonAfterOpen (DataSet);
end;  // TFrmVWPosJournal.DstLstTransAfterOpen

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of FVWPosJournal