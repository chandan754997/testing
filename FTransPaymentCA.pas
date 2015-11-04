//================= Real Software - Retail Division (c) 2006 ==================
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FTransPaymentCA : Form TRANSfer PAYMENTs after deliveries for
//            CAstorama
//---------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FTransPaymentCA.pas,v 1.1 2006/12/21 14:42:34 hofmansb Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FTransPaymentCA - CVS rev 1.6
//=============================================================================

unit FTransPaymentCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, ComCtrls, StdCtrls, ExtCtrls, Buttons, IniFiles,
  MTransPaymentPanelCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtOperReg     = 'Registrating operator';
  CtTxtAmountNOK   = 'Paied amount doesn''t match amount to transfer!';
  CtTxtNoData      = 'No data found!';

//=============================================================================
// Panels on statusbar
//=============================================================================

var
  ViNumPnlMsg      : Integer = 0;      // Pnl for user messages
  ViNumPnlOperReg  : Integer = 2;      // Pnl show registrating operator

//=============================================================================
// Position variables
//=============================================================================

var
  ViValTicket     : Integer = 65;      // Width of 'No Ticket' column
  ViValOrder      : Integer = 65;      // Width of 'No Order' column
  ViValCashdesk   : Integer = 70;      // Width of 'No Cashdesk' column
  ViValOperator   : Integer = 70;      // Width of 'No Operator' column
  ViValDate       : Integer = 75;      // Width of 'Ticketdate' column
  ViValAmount     : Integer = 75;      // Width of 'Amount to transfer' column
  ViValCount      : Integer = 75;      // Width of 'Count processed?' column
  ViValProcess    : Integer = 30;      // Width of 'Process button'

//=============================================================================
// Position variables
//=============================================================================

const
  CtTopMargin      : Integer = 5;
  CtLeftMargin     : Integer = 5;

type
  TFrmTransPaymentCA = class(TFrmCommon)
    StsBarInfo: TStatusBar;
    ScrlbxGrid: TScrollBox;
    PnlTitle: TPanel;
    PnlBottom: TPanel;
    PnlBottomRight: TPanel;
    PnlBottomLeft: TPanel;
    BtnCancel: TBitBtn;
    BtnValidate: TBitBtn;
    PnlBottomTop: TPanel;
    procedure FormActivate(Sender: TObject);
    procedure BtnValidateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLblTicket,                            // Column title 'No Ticket'
    FLblOrder,                             // Column title 'No Order'
    FLblCashDesk,                          // Column title 'No Cashdesk'
    FLblOperator,                          // Column title 'No Operator'
    FLblDate,                              // Column title 'Ticketdate'
    FLblAmount,                            // Column title 'Amount to transfer'
    FLblCount           : TLabel;          // Column title 'Count processed?'
    FTransPaymentPanels : array of         // Panels with payment data
                          TTransPaymentPanel;
    FNumTotal           : Currency;        // Total amount to Pay
    ValTotalAmount      : currency;        // Total of the amounts
    NumPayments         : integer;         // Number of payments
    FLblTotal,                             // Total title
    FLblValTotal        : TLabel;          // Total value
    ValAmount           : currency;        // Payed amount (processed)
    FLstFields          : array of TStringList;
                                           // Stringlist with all record fields
    FLstTransPayments   : TList;           // List with all tranfered records
    FValMinimumLength   : integer;         // Minimum length for secret code
  protected
    SavAppOnIdle        : TIdleEvent;      // Save original OnIdle evt hndlr
    FFlgEverActivated   : Boolean;         // Indicates first time activated
    FIdtOperReg         : string;          // IdtOperator registrating
    FTxtNameOperReg     : string;          // Name operator
    FLstPaymethods     : TList;           // List with the Paymethods.
    FLstPrevPaymethods : TList;           // List with the Paymethods.
    FLstAllPaymethods   : TList;           // List of all LstPaymethods.
    function GetIdtOperReg : string; virtual;
    function BuildLstTransPayments :  boolean; virtual;
    procedure SetIdtOperReg (Value : string); virtual;
    procedure SetTxtNameOperReg (Value : string); virtual;
    procedure OnFirstIdle (    Sender : TObject;
                           var Done   : Boolean); virtual;
    procedure LogOn; virtual;
    procedure BuildTitles; virtual;
    procedure BuildGrid; virtual;
    procedure ShowTotal; virtual;
    procedure ProcessPayment(Sender: TObject); virtual;
    procedure ValidatePayment(Sender: TObject); virtual;
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
  published
    property IdtOperReg : string read  GetIdtOperReg
                                 write SetIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write SetTxtNameOperReg;
    property LstPaymethods : TList read FLstPaymethods
                                    write FLstPaymethods;
    property LstAllPaymethods : TList read FLstAllPaymethods
                                     write FLstAllPaymethods;
    property LstPrevPaymethods : TList read FLstPrevPaymethods
                                    write FLstPrevPaymethods;
    property LstTransPayments : TList read FLstTransPayments
                                     write FLstTransPayments;
    property NumTotal : Currency read FNumTotal
                                 write FNumTotal;
    property ValMinimumLength: integer read FValMinimumLength
                                       write FValMinimumLength;
  end;  // of TFrmTransPaymentCA

var
  FrmTransPaymentCA: TFrmTransPaymentCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  smutils,
  ScTskMgr_BDE_DBC,
  DFpnUtils,
  DFpnTransPaymentCA,
  MMntInvoice,
  FVSRptTransPaymentCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FTransPaymentCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FTransPaymentCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/21 14:42:34 $';


//*****************************************************************************
// Implementation of TFrmTransPaymentCA
//*****************************************************************************

procedure TFrmTransPaymentCA.FormCreate(Sender: TObject);
begin
  inherited;
  LstTransPayments := TList.Create;
  LstPaymethods := TList.Create;
  LstPrevPaymethods := TList.Create;
  LstAllPaymethods := TList.Create;
end;

//=============================================================================

procedure TFrmTransPaymentCA.FormDestroy(Sender: TObject);
begin
  inherited;
  LstPrevPaymethods.Free;
  LstPrevPaymethods := nil;
end;

//=============================================================================

procedure TFrmTransPaymentCA.FormActivate(Sender: TObject);
begin
  inherited;
  if not FlgEverActivated then begin
    SavAppOnIdle := Application.OnIdle;
    Application.OnIdle := OnFirstIdle;

  end;
  FFlgEverActivated := True;
end;

//=============================================================================

function TFrmTransPaymentCA.GetIdtOperReg : string;
begin  // of TFrmTransPaymentCA.GetIdtOperReg
  Result := FIdtOperReg;
end;   // of TFrmTransPaymentCA.GetIdtOperReg

//=============================================================================

procedure TFrmTransPaymentCA.SetIdtOperReg (Value : string);
begin  // of TFrmTransPaymentCA.GetIdtOperReg
  FIdtOperReg := Value;
end;   // of TFrmTransPaymentCA.GetIdtOperReg

//=============================================================================

procedure TFrmTransPaymentCA.SetTxtNameOperReg (Value : string);
begin  // of TFrmTransPaymentCA.SetTxtNameOperReg
  FTxtNameOperReg := Value;
  StsBarInfo.Panels[ViNumPnlOperReg].Text := Format ('%s : %s',
                                                     [CtTxtOperReg, Value]);
end;   // of TFrmTransPaymentCA.SetTxtNameOperReg

//=============================================================================
// TFrmTransPaymentCA.OnFirstIdle : installed as OnIdle Event in OnActivate,
// to execute some things as soon as the application becomes idle.
//=============================================================================

procedure TFrmTransPaymentCA.OnFirstIdle (    Sender : TObject;
                                            var Done   : Boolean);
begin  // of TFrmTransPaymentCA.OnFirstIdle
  Application.OnIdle := SavAppOnIdle;
  if IdtOperReg = '' then
    LogOn;
end;   // of TFrmTransPaymentCA.OnFirstIdle

//=============================================================================

procedure TFrmTransPaymentCA.BtnValidateClick(Sender: TObject);
begin
  inherited;
  if BuildLstTransPayments then begin
    SvcTaskMgr.LaunchTask ('PrintReport');
    DmdFpnTransPaymentCA.ExecutePaymentTransfers(LstTransPayments,
                                                 LstAllPaymethods,
                                                 IdtOperReg);
  end;
  Application.Terminate;
end;

//=============================================================================
// TFrmTransPaymentCA.LogOn : LogOn registrating Operator.
//=============================================================================

procedure TFrmTransPaymentCA.LogOn;
begin  // of TFrmTransPaymentCA.LogOn
  if SvcTaskMgr.LaunchTask ('LogOn') then begin
    PnlTitle.Visible := True;
    PnlBottom.Visible := True;
    BuildTitles;
    BuildGrid;
  end
  else begin
    ModalResult := mrCancel;
  end;
end;   // of TFrmTransPaymentCA.LogOn

//=============================================================================
// TFrmTransPaymentCA.BuildTitles : Build column titles of grid
//=============================================================================

procedure TFrmTransPaymentCA.BuildTitles;
var
  FBvlVertLines     : array [1..7] of TBevel;  // Vertical lines between columns
begin  // of TFrmTransPaymentCA.BuildTitles
  // Create title column for Ticket
  FLblTicket := TLabel.Create(Self);
  FLblTicket.Parent := PnlTitle;
  FLblTicket.AutoSize := True;
  FLblTicket.Top := CtTopMargin;
  FLblTicket.Left := CtLeftMargin;
  FLblTicket.Font.Style := [fsBold];
  FLblTicket.WordWrap := True;
  FLblTicket.Caption := CtTxtTicket;
  FLblTicket.Width := ViValTicket;
  FBvlVertLines[1] := TBevel.Create(Self);
  FBvlVertLines[1].Parent := PnlTitle;
  FBvlVertLines[1].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[1].Width := 1;
  FBvlVertLines[1].Top := 0;
  FBvlVertLines[1].Left := FLblTicket.Left + FLblTicket.Width + 3;

  // Create title column for Order
  FLblOrder := TLabel.Create(Self);
  FLblOrder.Parent := PnlTitle;
  FLblOrder.AutoSize := True;
  FLblOrder.Top := CtTopMargin;
  FLblOrder.Left := FLblTicket.Left + FLblTicket.Width + ViValSep;
  FLblOrder.Font.Style := [fsBold];
  FLblOrder.WordWrap := True;
  FLblOrder.Caption := CtTxtOrder;
  FLblOrder.Width := ViValOrder;
  FBvlVertLines[2] := TBevel.Create(Self);
  FBvlVertLines[2].Parent := PnlTitle;
  FBvlVertLines[2].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[2].Width := 1;
  FBvlVertLines[2].Top := 0;
  FBvlVertLines[2].Left := FLblOrder.Left + FLblOrder.Width + 3;

  // Create title column for CashDesk
  FLblCashDesk := TLabel.Create(Self);
  FLblCashDesk.Parent := PnlTitle;
  FLblCashDesk.AutoSize := True;
  FLblCashDesk.Top := CtTopMargin;
  FLblCashDesk.Left := FLblOrder.Left + FLblOrder.Width + ViValSep;
  FLblCashDesk.Font.Style := [fsBold];
  FLblCashDesk.WordWrap := True;
  FLblCashDesk.Caption := CtTxtCashDesk;
  FLblCashDesk.Width := ViValCashDesk;
  FBvlVertLines[3] := TBevel.Create(Self);
  FBvlVertLines[3].Parent := PnlTitle;
  FBvlVertLines[3].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[3].Width := 1;
  FBvlVertLines[3].Top := 0;
  FBvlVertLines[3].Left := FLblCashDesk.Left + FLblCashDesk.Width + 3;

  // Create title column for Operator
  FLblOperator := TLabel.Create(Self);
  FLblOperator.Parent := PnlTitle;
  FLblOperator.AutoSize := True;
  FLblOperator.Top := CtTopMargin;
  FLblOperator.Left := FLblCashDesk.Left + FLblCashDesk.Width + ViValSep;
  FLblOperator.Font.Style := [fsBold];
  FLblOperator.WordWrap := True;
  FLblOperator.Caption := CtTxtOperator;
  FLblOperator.Width := ViValOperator;
  FBvlVertLines[4] := TBevel.Create(Self);
  FBvlVertLines[4].Parent := PnlTitle;
  FBvlVertLines[4].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[4].Width := 1;
  FBvlVertLines[4].Top := 0;
  FBvlVertLines[4].Left := FLblOperator.Left + FLblOperator.Width + 3;

  // Create title column for Date
  FLblDate := TLabel.Create(Self);
  FLblDate.Parent := PnlTitle;
  FLblDate.AutoSize := True;
  FLblDate.Top := CtTopMargin;
  FLblDate.Left := FLblOperator.Left + FLblOperator.Width + ViValSep;
  FLblDate.Font.Style := [fsBold];
  FLblDate.WordWrap := True;
  FLblDate.Caption := CtTxtDate;
  FLblDate.Width := ViValDate;
  FBvlVertLines[5] := TBevel.Create(Self);
  FBvlVertLines[5].Parent := PnlTitle;
  FBvlVertLines[5].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[5].Width := 1;
  FBvlVertLines[5].Top := 0;
  FBvlVertLines[5].Left := FLblDate.Left + FLblDate.Width + 3;

  // Create title column for Amount
  FLblAmount := TLabel.Create(Self);
  FLblAmount.Parent := PnlTitle;
  FLblAmount.AutoSize := True;
  FLblAmount.Top := CtTopMargin;
  FLblAmount.Left := FLblDate.Left + FLblDate.Width + ViValSep;
  FLblAmount.Font.Style := [fsBold];
  FLblAmount.WordWrap := True;
  FLblAmount.Caption := CtTxtAmount;
  FLblAmount.Width := ViValAmount;
  FBvlVertLines[6] := TBevel.Create(Self);
  FBvlVertLines[6].Parent := PnlTitle;
  FBvlVertLines[6].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[6].Width := 1;
  FBvlVertLines[6].Top := 0;
  FBvlVertLines[6].Left := FLblAmount.Left + FLblAmount.Width + 3;

  // Create title column for Count
  FLblCount := TLabel.Create(Self);
  FLblCount.Parent := PnlTitle;
  FLblCount.AutoSize := True;
  FLblCount.Top := CtTopMargin;
  FLblCount.Left := FLblAmount.Left + FLblAmount.Width + ViValSep;
  FLblCount.Font.Style := [fsBold];
  FLblCount.WordWrap := True;
  FLblCount.Caption := CtTxtCount;
  FLblCount.Width := ViValCount;
  FBvlVertLines[7] := TBevel.Create(Self);
  FBvlVertLines[7].Parent := PnlTitle;
  FBvlVertLines[7].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[7].Width := 1;
  FBvlVertLines[7].Top := 0;
  FBvlVertLines[7].Left := FLblCount.Left + FLblCount.Width + 3;
end;   // of TFrmTransPaymentCA.BuildTitles

//=============================================================================
// TFrmTransPaymentCA.BuildGrid : Build grid based on data in database
//=============================================================================

procedure TFrmTransPaymentCA.BuildGrid;
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin  // of TFrmTransPaymentCA.BuildGrid
  DmdFpnTransPaymentCA.QryTransferPayments.Open;
  if DmdFpnTransPaymentCA.QryTransferPayments.RecordCount > 0 then begin
    NumPayments := DmdFpnTransPaymentCA.QryTransferPayments.RecordCount;
    SetLength(FTransPaymentPanels, NumPayments);
    CntPayments := 0;
    ValTotalAmount := 0;
    DmdFpnTransPaymentCA.QryTransferPayments.First;
    while not DmdFpnTransPaymentCA.QryTransferPayments.Eof do begin
      FTransPaymentPanels[CntPayments] := TTransPaymentPanel.Create(Self);
      FTransPaymentPanels[CntPayments].Parent := ScrlbxGrid;
      if CntPayments = 0 then
        FTransPaymentPanels[CntPayments].Top := CtTopMargin
      else
        FTransPaymentPanels[CntPayments].Top :=
                                  FTransPaymentPanels[CntPayments-1].Top +
                                  FTransPaymentPanels[CntPayments-1].Height +
                                  CtTopMargin;
      FTransPaymentPanels[CntPayments].Left := CtLeftMargin;
      FTransPaymentPanels[CntPayments].LblValTicket.Caption :=
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('IdtPosTransaction').AsString;
      FTransPaymentPanels[CntPayments].LblValOrder.Caption :=
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('IdtCVente').AsString;
      FTransPaymentPanels[CntPayments].LblValCashDesk.Caption :=
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('IdtCheckOut').AsString;
      FTransPaymentPanels[CntPayments].LblValOperator.Caption :=
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('IdtOperator').AsString;
      FTransPaymentPanels[CntPayments].LblValDate.Caption :=
                                  FormatDateTime(CtTxtDatFormat,
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('DatTransBegin').AsDateTime);
      FTransPaymentPanels[CntPayments].LblValAmount.Caption :=
                                  FormatCurr('0.00',
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('ValInclVat').AsCurrency);
      FTransPaymentPanels[CntPayments].LblValCount.Caption :=
                                  DmdFpnTransPaymentCA.QryTransferPayments.
                                  FieldbyName('CountProc').AsString;
      FTransPaymentPanels[CntPayments].BtnProcess.OnClick := ProcessPayment;
      ValTotalAmount := ValTotalAmount +
                        DmdFpnTransPaymentCA.QryTransferPayments.
                        FieldbyName('ValInclVat').AsCurrency;
      CntPayments := CntPayments + 1;
      DmdFpnTransPaymentCA.QryTransferPayments.Next;
    end;
    for CntPayments := 0 to NumPayments - 1 do
      FTransPaymentPanels[CntPayments].FillPaymentsMethods;
    ShowTotal;
  end
  else begin
    StsBarInfo.Panels[ViNumPnlMsg].Text := CtTxtNoData;
    BtnValidate.Enabled := False;
  end;
end;   // of TFrmTransPaymentCA.BuildGrid

//=============================================================================
// TFrmTransPaymentCA.ShowTotal : Show row with total amounts
//=============================================================================

procedure TFrmTransPaymentCA.ShowTotal;
begin  // of TFrmTransPaymentCA.ShowTotal
  // Create title label for Total
  FLblTotal := TLabel.Create(Self);
  FLblTotal.Parent := PnlBottomTop;
  FLblTotal.AutoSize := True;
  FLblTotal.Top := CtTopMargin;
  FLblTotal.Left := FTransPaymentPanels[NumPayments - 1].Left +
                    FTransPaymentPanels[NumPayments - 1].LblValDate.Left;
  FLblTotal.Font.Style := [fsBold];
  FLblTotal.Caption := CtTxtTotal;
  FLblTotal.Width := ViValDate;

  // Create value for Total
  FLblValTotal := TLabel.Create(Self);
  FLblValTotal.Parent := PnlBottomTop;
  FLblValTotal.Top := CtTopMargin;
  FLblValTotal.Left := FLblTotal.Left + FLblTotal.Width + ViValSep;
  FLblValTotal.Font.Style := [fsBold];
  FLblValTotal.Width := ViValAmount;
  FLblValTotal.Alignment := taRightJustify;
  FLblValTotal.Caption := FormatCurr('0.00', ValTotalAmount);
end;   // of TFrmTransPaymentCA.ShowTotal


//=============================================================================
// TFrmTransPaymentCA.ProcessPayment : Process payment for certain row
//=============================================================================

procedure TFrmTransPaymentCA.ProcessPayment(Sender: TObject);
var
  ValAmount     : string;
begin  // of TFrmTransPaymentCA.ProcessPayment
  LstPaymethods := TTransPaymentPanel(TButton(Sender).Parent).LstPaymethods;
  LstPrevPaymethods := TTransPaymentPanel(TButton(Sender).Parent).LstPrevPaymethods;
  ValAmount := TTransPaymentPanel(TButton(Sender).Parent).LblValAmount.Caption;
  if AnsiPos(',', ValAmount) > 0 then
    NumTotal := StrToCurrency(Copy(ValAmount, 1 , AnsiPos(',', ValAmount)-1) + '.' +
                Copy(ValAmount, AnsiPos(',', ValAmount)+1, length(ValAmount)))
  else
    NumTotal := StrToCurrency(ValAmount);
  SvcTaskMgr.LaunchTask ('Payment');
  ValidatePayment(Sender);
end;   // of TFrmTransPaymentCA.ProcessPayment

//=============================================================================
// TFrmTransPaymentCA.ValidatePayment : check if the full amount is payed
//=============================================================================

procedure TFrmTransPaymentCA.ValidatePayment(Sender: TObject);
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin  // of TFrmTransPaymentCA.ValidatePayment
  inherited;
  ValAmount := 0;
  for CntPayments := 0 to Pred (LstPaymethods.Count) do begin
    ValAmount:= ValAmount +
                TObjTransPayment(LstPaymethods[CntPayments]).PrcAdmInclVAT;
  end;
  if FormatCurr('0.00', ValAmount) =
  TTransPaymentPanel(TButton(Sender).Parent).LblValAmount.Caption then
    TTransPaymentPanel(TButton(Sender).Parent).SetTransfered
  else begin
    TTransPaymentPanel(TButton(Sender).Parent).ResetTransfered;
    MessageDlg(CtTxtAmountNOK, mtWarning, [mbOK], 0);
  end;
end;   // of TFrmTransPaymentCA.ValidatePayment

//=============================================================================
// TFrmTransPaymentCA.WriteValidatedToDB : Write validated data to DB
//=============================================================================

function TFrmTransPaymentCA.BuildLstTransPayments :  boolean;
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin  // of TFrmTransPaymentCA.BuildLstTransPayments
  inherited;
  Result := False;
  SetLength(FLstFields, NumPayments);
  for CntPayments := 0 to NumPayments -1 do begin
    if FTransPaymentPanels[CntPayments].FlgValidated then begin
      Result := True;
      FLstFields[CntPayments] := TStringList.Create;
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValTicket.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValOrder.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValCashDesk.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValOperator.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValDate.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValAmount.Caption);
      FLstFields[CntPayments].Add(FTransPaymentPanels[CntPayments].
                                  LblValCount.Caption);
      LstTransPayments.Add(FLstFields[CntPayments]);
      LstAllPaymethods.Add(FTransPaymentPanels[CntPayments].LstPaymethods);
    end;
  end;
end;   // of TFrmTransPaymentCA.BuildLstTransPayments

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
