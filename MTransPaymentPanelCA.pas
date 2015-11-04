//=Copyright 2004 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : MTransPaymentPanelCA : Module TRANSFER PAYMENTs PANEL for
//                                   CAstorama
//-----------------------------------------------------------------------------
// PVCS     : $ $
// History  :
//
//=============================================================================

unit MTransPaymentPanelCA;

//*****************************************************************************

interface

uses
  Classes,                             // TComponent
  ExtCtrls,                            // TPanel
  StdCtrls,
  Graphics,
  IniFiles,
  Forms,
  Controls;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Position variables
//=============================================================================

var
  ViValTicket     : Integer = 65;      // Width of 'N° Ticket' column
  ViValOrder      : Integer = 65;      // Width of 'N° Order' column
  ViValCashdesk   : Integer = 70;      // Width of 'N° Cashdesk' column
  ViValOperator   : Integer = 70;      // Width of 'N° Operator' column
  ViValDate       : Integer = 75;      // Width of 'Ticketdate' column
  ViValAmount     : Integer = 75;      // Width of 'Amount to transfer' column
  ViValCount      : Integer = 75;      // Width of 'Count processed?' column
  ViValProcess    : Integer = 30;      // Width of 'Process button'
  ViValSep        : Integer = 10;      // Width between columns
  ViValTop        : Integer = 7;       // top of objects
  ViValHeight     : Integer = 20;      // height of objects

//=============================================================================
// Object names
//=============================================================================

const
  CtTxtValTicket  = 'LblValTicket';    // name of LblValTicket
  CtTxtValOrder   = 'LblValOrder';     // name of LblValOrder
  CtTxtValCashDesk= 'LblValCashDesk';  // name of LblValCashDesk
  CtTxtValOperator= 'LblValOperator';  // name of LblValOperator
  CtTxtValDate    = 'LblValDate';      // name of LblValDate
  CtTxtValAmount  = 'LblValAmount';    // name of LblValAmount
  CtTxtValCount   = 'LblValCount';     // name of LblValCoung
  CtTxtProcess    = 'BtnProcess';      // name of BtnProcess

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtBtnCaption = '>>';              // caption of BtnProcess

//*****************************************************************************
// Global type definitions
//*****************************************************************************

type
  TTransPaymentPanel = class(TCustomPanel)
  private
    { Private declarations }
    FLblValTicket   : TLabel;
    FLblValOrder    : TLabel;
    FLblValCashDesk : TLabel;
    FLblValOperator : TLabel;
    FLblValDate     : TLabel;
    FLblValAmount   : TLabel;
    FLblValCount    : TLabel;
    FBtnProcess     : TButton;
  protected
    { Protected declarations }
    FLstPaymethods       : TList;           // List with the paymethods.
    FLstPrevPaymethods   : TList;           // List with the paymethods.
    FFlgValidated        : boolean;         // Indicates that this row is OK
  public
    { Public declarations }
    // constructors and destructors
    constructor Create(AOwner: TComponent); override;
    function Countable(IdtClassification : string) : boolean;
    procedure SetTransfered; virtual;
    procedure ResetTransfered; virtual;
    procedure FillPaymentsMethods; virtual;
  published
    { Published declarations }
    property LblValTicket   : TLabel    read FLblValTicket
                                       write FLblValTicket;
    property LblValOrder    : TLabel    read FLblValOrder
                                       write FLblValOrder;
    property LblValCashDesk : TLabel    read FLblValCashDesk
                                       write FLblValCashDesk;
    property LblValOperator : TLabel    read FLblValOperator
                                       write FLblValOperator;
    property LblValDate     : TLabel    read FLblValDate
                                       write FLblValDate;
    property LblValAmount   : TLabel    read FLblValAmount
                                       write FLblValAmount;
    property LblValCount    : TLabel    read FLblValCount
                                       write FLblValCount;
    property BtnProcess     : TButton   read FBtnProcess
                                       write FBtnProcess;
    property LstPaymethods  : TList     read FLstPaymethods
                                       write FLstPaymethods;
    property LstPrevPaymethods : TList read FLstPrevPaymethods
                                      write FLstPrevPaymethods;
    property FlgValidated   : boolean   read FFlgValidated
                                       write FFlgValidated;
  end;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  Dialogs,
  SysUtils,
  DFpnUtils,
  MMntInvoice;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName  = 'MTransPaymentPanelCA';

const  // PVCS-keywords
  CtTxtSrcName     = '$Workfile: MTransPaymentPanelCA.PAS $';
  CtTxtSrcVersion  = '$ $';
  CtTxtSrcDate     = '$ $';

//*****************************************************************************
// Implementation of TTransPaymentPanel
//*****************************************************************************

//=============================================================================
// Constructors & destructors
//=============================================================================

constructor TTransPaymentPanel.Create(AOwner: TComponent);
var
  FBvlVertLines     : array [1..7] of TBevel;  // Vertical lines between columns
begin  // of TTransPaymentPanel.Create
  inherited Create(AOwner);

  // Panel settings
  Self.BorderStyle := bsNone;
  Self.BevelInner := bvNone;
  Self.BevelOuter := bvLowered;
  Self.Align := alTop;
  Self.Height := ViValHeight + (2 * ViValTop) - 2;

  // Create column for ValTicket
  FLblValTicket := TLabel.Create(Self);
  FLblValTicket.Name := CtTxtValTicket;
  FLblValTicket.Parent := Self;
  FLblValTicket.Top := ViValTop;
  FLblValTicket.Left := 5;
  FLblValTicket.Height := ViValHeight;
  FLblValTicket.Width := ViValTicket;
  FBvlVertLines[1] := TBevel.Create(Self);
  FBvlVertLines[1].Parent := Self;
  FBvlVertLines[1].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[1].Width := 1;
  FBvlVertLines[1].Top := 0;
  FBvlVertLines[1].Left := FLblValTicket.Left + FLblValTicket.Width + 3;

  // Create column for ValOrder
  FLblValOrder := TLabel.Create(Self);
  FLblValOrder.Name := CtTxtValOrder;
  FLblValOrder.Parent := Self;
  FLblValOrder.Top   := ViValTop;
  FLblValOrder.Left  := FLblValTicket.Left + FLblValTicket.Width + ViValSep;
  FLblValOrder.Height := ViValHeight;
  FLblValOrder.Width := ViValOrder;
  FBvlVertLines[2] := TBevel.Create(Self);
  FBvlVertLines[2].Parent := Self;
  FBvlVertLines[2].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[2].Width := 1;
  FBvlVertLines[2].Top := 0;
  FBvlVertLines[2].Left := FLblValOrder.Left + FLblValOrder.Width + 3;

  // Create colum for ValCashDesk
  FLblValCashDesk := TLabel.Create(Self);
  FLblValCashDesk.Name := CtTxtValCashDesk;
  FLblValCashDesk.Parent := Self;
  FLblValCashDesk.Top   := ViValTop;
  FLblValCashDesk.Left  := FLblValOrder.Left + FLblValOrder.Width + ViValSep;
  FLblValCashDesk.Height := ViValHeight;
  FLblValCashDesk.Width := ViValCashDesk;
  FBvlVertLines[3] := TBevel.Create(Self);
  FBvlVertLines[3].Parent := Self;
  FBvlVertLines[3].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[3].Width := 1;
  FBvlVertLines[3].Top := 0;
  FBvlVertLines[3].Left := FLblValCashDesk.Left + FLblValCashDesk.Width + 3;

  // Create column for ValOperator
  FLblValOperator := TLabel.Create(Self);
  FLblValOperator.Name := CtTxtValOperator;
  FLblValOperator.Parent := Self;
  FLblValOperator.Top   := ViValTop;
  FLblValOperator.Left  := FLblValCashDesk.Left + FLblValCashDesk.Width + ViValSep;
  FLblValOperator.Height := ViValHeight;
  FLblValOperator.Width := ViValOperator;
  FBvlVertLines[4] := TBevel.Create(Self);
  FBvlVertLines[4].Parent := Self;
  FBvlVertLines[4].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[4].Width := 1;
  FBvlVertLines[4].Top := 0;
  FBvlVertLines[4].Left := FLblValOperator.Left + FLblValOperator.Width + 3;

  // Create column for ValDate
  FLblValDate := TLabel.Create(Self);
  FLblValDate.Name := CtTxtValDate;
  FLblValDate.Parent := Self;
  FLblValDate.Top   := ViValTop;
  FLblValDate.Left  := FLblValOperator.Left + FLblValOperator.Width + ViValSep;
  FLblValDate.Height := ViValHeight;
  FLblValDate.Width := ViValDate;
  FBvlVertLines[5] := TBevel.Create(Self);
  FBvlVertLines[5].Parent := Self;
  FBvlVertLines[5].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[5].Width := 1;
  FBvlVertLines[5].Top := 0;
  FBvlVertLines[5].Left := FLblValDate.Left + FLblValDate.Width + 3;

  // Create column for ValAmount
  FLblValAmount := TLabel.Create(Self);
  FLblValAmount.Name := CtTxtValAmount;
  FLblValAmount.Parent := Self;
  FLblValAmount.Top   := ViValTop;
  FLblValAmount.Left  := FLblValDate.Left + FLblValDate.Width + ViValSep;
  FLblValAmount.Height := ViValHeight;
  FLblValAmount.Width := ViValAmount;
  FLblValAmount.Alignment := taRightJustify;
  FBvlVertLines[6] := TBevel.Create(Self);
  FBvlVertLines[6].Parent := Self;
  FBvlVertLines[6].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[6].Width := 1;
  FBvlVertLines[6].Top := 0;
  FBvlVertLines[6].Left := FLblValAmount.Left + FLblValAmount.Width + 3;

  // Create column for ValCount
  FLblValCount := TLabel.Create(Self);
  FLblValCount.Name := CtTxtValCount;
  FLblValCount.Parent := Self;
  FLblValCount.Top   := ViValTop;
  FLblValCount.Left  := FLblValAmount.Left + FLblValAmount.Width + ViValSep;
  FLblValCount.Height := ViValHeight;
  FLblValCount.Width := ViValCount;
  FBvlVertLines[7] := TBevel.Create(Self);
  FBvlVertLines[7].Parent := Self;
  FBvlVertLines[7].Height := FBvlVertLines[1].Parent.Height;
  FBvlVertLines[7].Width := 1;
  FBvlVertLines[7].Top := 0;
  FBvlVertLines[7].Left := FLblValCount.Left + FLblValCount.Width + 3;

  // Create Process button
  FBtnProcess := TButton.Create(Self);
  FBtnProcess.Name := CtTxtProcess;
  FBtnProcess.Parent := Self;
  FBtnProcess.Top   := ViValTop - 2;
  FBtnProcess.Left  := FLblValCount.Left + FLblValCount.Width + ViValSep;
  FBtnProcess.Height := ViValHeight;
  FBtnProcess.Width := ViValProcess;
  FBtnProcess.Caption := CtTxtBtnCaption;

  LstPaymethods := TList.Create;
  LstPrevPaymethods := TList.Create;

end;   // of TTransPaymentPanel.Create

//=============================================================================
// Methods
//=============================================================================

//=============================================================================
// TTransPaymentPanel.SetTransfered : set panel green indicating that for this
//                                    row the payment is transfered.
//=============================================================================

procedure TTransPaymentPanel.SetTransfered;
begin  // of TTransPaymentPanel.SetTransfered
  Self.Color := TColor($00CC66);
  FlgValidated := True;
end;   // of TTransPaymentPanel.SetTransfered

//=============================================================================
// TTransPaymentPanel.ResetTransfered : reset panel grey indicating that for
//                                      this row the payment is no longer
//                                      completely transfered.
//=============================================================================

procedure TTransPaymentPanel.ResetTransfered;
begin  // of TTransPaymentPanel.ResetTransfered
  Self.Color := ClBtnFace;
  FlgValidated := False;
end;   // of TTransPaymentPanel.ResetTransfered

//=============================================================================
// TTransPaymentPanel.FillPaymentsMethods : Get all the payment-types out of
// an ini file and the DB and put it in objects.
//=============================================================================

procedure TTransPaymentPanel.FillPaymentsMethods;
var
  IniFile              : TIniFile;          // IniObject to the INI-file
  ObjTransPayment     : TObjTransPayment;   // Paymenttypes
  ObjPrevTransPayment : TObjTransPayment;   // Paymenttypes
  TxtPath             : String;             // Path of the ini-file
  NumPaymentMethods   : Integer;            // Number of payment methods
  NumCounter          : Integer;            // Counter used for loop
  FlgTransferable     : boolean;            // Paymentmethod is transferable
begin  // of TFrmDetManInvoiceCA.FillPaymentsMethods
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPoint\Ini\PaymentMethod.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  NumPaymentMethods := StrToInt(IniFile.ReadString('General', 'Items', ''));
  for NumCounter := 1 to NumPaymentMethods do begin
    FlgTransferable := False;
    if IniFile.ValueExists('PaymentMethod'+IntToStr(NumCounter),
                           'Transferable') then begin
      if AnsiUpperCase(IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
      'Transferable', '')) = 'TRUE' then
        FlgTransferable := True;
    end;
    if IniFile.ValueExists('PaymentMethod'+IntToStr(NumCounter),
                           'IdtClassification') then begin
      try
        if Countable(IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
           'IdtClassification', '')) or FlgTransferable then begin
          ObjTransPayment := TObjTransPayment.Create;
          ObjPrevTransPayment := TObjTransPayment.Create;
          ObjTransPayment.IdtAdmClassi :=
               IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
               'IdtClassification', '');
          ObjPrevTransPayment.IdtAdmClassi := ObjTransPayment.IdtAdmClassi;
          DmdFpnUtils.CloseInfo;
          DmdFpnUtils.ClearQryInfo;
          DmdFpnUtils.QueryInfo
            ('SELECT TxtPublDescr' +
             #10'FROM Classification' +
             #10'WHERE IdtClassification =' +
             AnsiQuotedStr (ObjTransPayment.IdtAdmClassi,''''));
          ObjTransPayment.TxtDescrAdm :=
               DmdFpnUtils.QryInfo.FieldByName ('TxtPublDescr').AsString;
          DmdFpnUtils.ClearQryInfo;
          ObjPrevTransPayment.TxtDescrAdm := ObjTransPayment.TxtDescrAdm;
          ObjTransPayment.CodActAdm :=
               StrToInt(IniFile.ReadString('PaymentMethod'+IntToStr(NumCounter),
               'CodAction', ''));
          ObjPrevTransPayment.CodActAdm := ObjTransPayment.CodActAdm;
          ObjTransPayment.PrcAdmInclVAT := 0;
          ObjPrevTransPayment.PrcAdmInclVAT := ObjTransPayment.PrcAdmInclVAT;
          ObjTransPayment.ValAdmInclVAT := 0;
          ObjPrevTransPayment.ValAdmInclVAT := ObjTransPayment.ValAdmInclVAT;

          // Add the object toe the rest of the list.
          LstPaymethods.Add (ObjTransPayment);
          LstPrevPaymethods.Add(ObjPrevTransPayment);
        end;
      finally
      end;
    end;
  end;
end;   // of TTransPaymentPanel.FillPaymentsMethods

//=============================================================================
// TTransPaymentPanel.Countable :
// Is this a countable payment method?
//=============================================================================
function TTransPaymentPanel.Countable (IdtClassification : string) : boolean;
begin  // of TTransPaymentPanel.Countable
  DmdFpnUtils.CloseInfo;
  DmdFpnUtils.ClearQryInfo;
  if DmdFpnUtils.QueryInfo(
           'SELECT CodType FROM TenderGroup TG' +
        #10'INNER JOIN TenderClass TC' +
        #10'ON TC.IdtClassMin = ' + AnsiQuotedStr(IdtClassification,'''') +
        #10'AND TC.IdtTenderGroup = TG.IdtTenderGroup') then begin
    if DmdFpnUtils.QryInfo.FieldByName('CodType').AsInteger IN [0, 1] then
      Result := True
    else
      Result := False;
  end
  else
    Result := False;
  DmdFpnUtils.CloseInfo;
  DmdFpnUtils.ClearQryInfo;
end;    // of TTransPaymentPanel.Countable

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of MTimeIntervalPanelBS

