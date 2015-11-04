//=========== Sycron Computers Belgium (c) 2003 ===============================
// Packet : Manuel Invoice
// Unit   : FDetManInvoicePaymentCA.PAS : Form DETail MANuele INVOICES payments
// Customer : Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoicePaymentCA.pas,v 1.1 2006/12/18 16:07:52 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDetManInvoicePaymentCA - CVS revision 1.8
//=============================================================================

unit FDetManInvoicePaymentCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sfdetail_BDE_DBC, OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, OvcEF, OvcPB,
  OvcPF, ScUtils, ScDBUtil_BDE;

//=============================================================================
// Width of at run time created components
//=============================================================================

var
  ViValWidthSpace  : Integer =   1;    // Width between 2 components
  ViValWidthDescr  : Integer = 200;    // Width of component for description
  ViValWidthQty    : Integer =  60;    // Width of component for quantity

//=============================================================================
// TFrmDetManInvoicePaymentCA
//                                  -----
// PROPERTIES :
// - LstPaymethodes = list of components to hold Payments.
//=============================================================================

type
  TFrmDetManInvoicePaymentCA = class(TFrmDetail)
    TabShtPayments: TTabSheet;
    SbxPayments: TScrollBox;
    LblNoPayments: TLabel;
    PnlTotalPayed: TPanel;
    SvcDBLblTotalPayed: TSvcDBLabelLoaded;
    LblTotalPayed: TLabel;
    LblCurrTotalPayed: TLabel;
    SvcDBLblTotalToPay: TSvcDBLabelLoaded;
    LblTotalToPay: TLabel;
    LblCurrTotalToPay: TLabel;
    SvcDBLblRemainingToPay: TSvcDBLabelLoaded;
    LblRemainingToPay: TLabel;
    LblCurrRemainingToPay: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FLstPaymethodes        : TList;       // List of components to hold payments
    FLstPrevPaymethodes    : TList;       // List of previous values
    FNumTotal              : Currency;    // Total amount to Pay    
    // Methods for components on the Panel
    function CreateLabel (    Owner      : TWinControl;
                          var ValLeft    : Integer    ;
                              ValWidth   : Integer    ;
                              TxtCaption : string     ) : TLabel; virtual;
    function CreateSvcLFQty
                          (    Owner   : TWinControl;
                           var ValLeft : Integer    ;
                               NumAmount : Currency ) : TSvcLocalField; virtual;
    procedure CreatePanelsPayment (TxtDescr  : String  ;
                                   NumAmount : Currency;
                                   NumOnList : Integer ); virtual;
    function IndexOfObject (Sender : TObject) : Integer; virtual;
    procedure CalcTotalPayed;
  public
    { Public declarations }
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;

    procedure SvcLFKeyDown (    Sender : TObject;
                            var Key    : Word;
                                Shift  : TShiftState); virtual;
    procedure SvcLFChange (Sender : TObject); virtual;
  published
    property LstPaymethodes : TList read  FLstPaymethodes
                                    write FLstPaymethodes;
    property LstPrevPaymethodes : TList read  FLstPrevPaymethodes
                                        write FLstPrevPaymethodes;
    property NumTotal : Currency read FNumTotal
                                 write FNumTotal;
  end;  // of TFrmDetManInvoicePaymentCA

var
  FrmDetManInvoicePaymentCA: TFrmDetManInvoicePaymentCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  MMntInvoice,
  DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetManInvoicePaymentCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetManInvoicePaymentCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 16:07:52 $';

//*****************************************************************************
// Implementation of TFrmDetManInvoicePaymentCA
//*****************************************************************************

//=============================================================================
// TFrmDetManInvoicePaymentCA.CreateLabel : creates a label.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//           ValWidth = property Width for the label.
//           TxtCaption = Caption for the label.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmDetManInvoicePaymentCA.CreateLabel
                                        (    Owner      : TWinControl;
                                         var ValLeft    : Integer    ;
                                             ValWidth   : Integer    ;
                                             TxtCaption : string     ) : TLabel;
begin  // of TFrmDetManInvoicePaymentCA.CreateLabel
  Result := TLabel.Create (Owner);

  Result.Parent     := Owner;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := False;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmDetManInvoicePaymentCA.CreateLabel

//=============================================================================
// TFrmDetManInvoicePaymentCA.CreateSvcLFQty : creates a new component to hold
// or enter a quantity.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : Owner   = Owner of this object.
//           ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmDetManInvoicePaymentCA.CreateSvcLFQty
                                  (    Owner     : TWinControl;
                                   var ValLeft   : Integer    ;
                                       NumAmount : Currency   ): TSvcLocalField;
begin  // of TFrmDetManInvoicePaymentCA.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := Owner;
  Result.Left          := ValLeft;
  Result.DataType      := pftReal;
  Result.MaxLength     := 5;
  Result.Options       := Result.Options + [EfoRightAlign];

  //Result.RightAlign    := True;
  //Result.RightJustify  := True;
  Result.Width         := ViValWidthQty;
  Result.DecimalPlaces := 2;
  Result.PictureMask   := '########.##';
  Result.AsFloat       := NumAmount;

  Result.OnKeyDown := SvcLFKeyDown;
  Result.OnChange  := SvcLFChange;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmDetManInvoicePaymentCA.CreateSvcLFQty

//=============================================================================
// TFrmDetManInvoicePaymentCA.CreatePanelsPayment : Create a panel for a
// specific payment-type
//                          ------------------
// Input : TxtDescr  : Discription of the payment
//         NumAmount : Total amount of the payment
//         NumOnList : Number of payment in the list.
//=============================================================================

procedure TFrmDetManInvoicePaymentCA.CreatePanelsPayment (TxtDescr  : String  ;
                                                          NumAmount : Currency;
                                                          NumOnList : Integer );
var
  ValLeft          : Integer;          // Left-property for next component
  PnlPayment       : TPanel;           // Panel of payment
  SvcLFPaymentTotal: TSvcLocalField;   // Component for bagnumber
begin  // of TFrmDetManInvoicePaymentCA.CreatePanelPayment
  PnlPayment := TPanel.Create (SbxPayments);

  PnlPayment.Parent     := SbxPayments;
  PnlPayment.Caption    := '';
  PnlPayment.BevelOuter := bvNone;
  PnlPayment.Height     := 24;
  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  alligned on Top, then change it to align on Top.
  PnlPayment.Top   := SbxPayments.VertScrollBar.Range;
  PnlPayment.Align := alTop;

  ValLeft := 8;
  CreateLabel (PnlPayment, ValLeft, ViValWidthDescr, TxtDescr);
  SvcLFPaymentTotal := CreateSvcLFQty (PnlPayment, ValLeft, NumAmount);
  TObjTransPayment(LstPaymethodes[NumOnList]).CmpName := SvcLFPaymentTotal;

  if SbxPayments.VertScrollBar.Range <
                                    PnlPayment.Top + PnlPayment.Height + 20 then
    SbxPayments.VertScrollBar.Range := PnlPayment.Top + PnlPayment.Height + 20;
end;   // of TFrmDetManInvoicePaymentCA.CreatePanelPayment

//=============================================================================
// TFrmDetManInvoicePaymentCA.IndexOfObject : Get's the indes of the object in
// the list.
//                          ------------------
// Input : Sender  : Object to find in the list
//=============================================================================

function TFrmDetManInvoicePaymentCA.IndexOfObject (Sender : TObject) : Integer;
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin  // of TFrmDetManInvoicePaymentCA.IndexOfObject
  Result := -1;
  for CntPayments := 0 to Pred (LstPaymethodes.Count) do begin
    if TObjTransPayment(LstPaymethodes[CntPayments]).CmpName = Sender then begin
      Result := CntPayments;
      Break;
    end;
  end;
end;   // of TFrmDetManInvoicePaymentCA.IndexOfObject

//=============================================================================
// TFrmDetManInvoicePaymentCA.CalcTotalPayed : Calculate the total amount that
// is payed
//=============================================================================

procedure TFrmDetManInvoicePaymentCA.CalcTotalPayed;
var
  CntPayments      : Integer;          // Loop all payment-methodes
  NumTotalPayed    : Currency;         // Total already payed.
begin  // of TFrmDetManInvoicePaymentCA.CalcTotalPayed
  NumTotalPayed := 0;
  for CntPayments := 0 to Pred (LstPaymethodes.Count) do begin
    NumTotalPayed := NumTotalPayed +
        TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT;
  end;
  LblTotalPayed.Caption := CurrToStrF (NumTotalPayed, ffFixed,
                                       DmdFpnUtils.QtyDecsPrice);
  LblCurrTotalPayed.Caption := DmdFpnUtils.IdtCurrencyMain;
  LblRemainingToPay.Caption := CurrToStrF (NumTotal-NumTotalPayed, ffFixed,
                                       DmdFpnUtils.QtyDecsPrice);
end;   // of TFrmDetManInvoicePaymentCA.CalcTotalPayed

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.PrepareFormDependJob;
var
 CntLstPayments    : Integer;          // Loop all payments-methodes
begin  // of TFrmDetManInvoicePaymentCA.PrepareFormDependJob
  if LstPaymethodes.Count = 0 then
    LblNoPayments.Visible := True
  else begin
    LblNoPayments.Visible := False;
    LblTotalToPay.Caption := CurrToStrF (NumTotal, ffFixed,
                                         DmdFpnUtils.QtyDecsPrice);
    LblCurrTotalToPay.Caption := DmdFpnUtils.IdtCurrencyMain;
    LblCurrRemainingToPay.Caption := DmdFpnUtils.IdtCurrencyMain;

    // Build the list with payments
    LockWindowUpdate (SbxPayments.Handle);
    try
      for CntLstPayments := 0 to Pred (LstPaymethodes.Count) do
        CreatePanelsPayment
            (TObjTransPayment(LstPaymethodes[CntLstPayments]).TxtDescrAdm,
             TObjTransPayment(LstPaymethodes[CntLstPayments]).PrcAdmInclVAT,
             CntLstPayments);
    finally
      LockWindowUpdate (0);
    end;

    // If there's a item, focus first item in the list.
    if LstPaymethodes.Count > 0 then
      TSvcLocalField (TObjTransPayment(LstPaymethodes[0]).CmpName).SetFocus;
  end;
end;   // of TFrmDetManInvoicePaymentCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.PrepareDataDependJob;
begin  // of TFrmDetManInvoicePaymentCA.PrepareDataDependJob
  // Calculate total payed
  CalcTotalPayed;
end;   // of TFrmDetManInvoicePaymentCA.PrepareDataDependJob

//=============================================================================
// TFrmDetManInvoicePaymentCA.SvcLFKeyDown : general Event Handler OnKeyDown
// for TSvcLocalField. See TOvcPictureField.OnKeyDown.
//=============================================================================

procedure TFrmDetManInvoicePaymentCA.SvcLFKeyDown (    Sender : TObject;
                                                   var Key    : Word;
                                                       Shift  : TShiftState);
var
  NumCmpInList     : Integer;          // Find component in list
  CmpName          : TComponent;       // Reference to the component.
begin  // of TFrmDetManInvoicePaymentCA.SvcLFKeyDown
  if (Shift = []) and (Key = VK_RETURN) then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := 0;
  end
  else if (Shift = []) and (Key = VK_UP) then begin
    NumCmpInList := IndexOfObject (Sender);
    if NumCmpInList > 0 then begin
      CmpName := TObjTransPayment(LstPaymethodes[NumCmpInList - 1]).CmpName;
      TWinControl(CmpName).SetFocus;
      Key := 0;
    end;
  end

  else if (Shift = []) and (Key = VK_DOWN ) then begin
    NumCmpInList := IndexOfObject (Sender);
    if NumCmpInList < Pred (LstPaymethodes.Count) then begin
      CmpName := TObjTransPayment(LstPaymethodes[NumCmpInList + 1]).CmpName;
      TWinControl(CmpName).SetFocus;
    end
    else
      BtnOK.SetFocus;
    Key := 0;
  end;
end;   // of TFrmDetManInvoicePaymentCA.SvcLFKeyDown

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.SvcLFChange (Sender : TObject);
var
  NumCmpInList     : Integer;          // Find component in list
begin  // of TFrmDetManInvoicePaymentCA.SvcLFChange
  NumCmpInList := IndexOfObject (Sender);
  TObjTransPayment(LstPaymethodes [NumCmpInList]).PrcAdmInclVAT :=
      (Sender as TSvcLocalField).AsFloat;

  // The values of the payments are saved inverted in the DB
  TObjTransPayment(LstPaymethodes [NumCmpInList]).ValAdmInclVAT :=
      - (Sender as TSvcLocalField).AsFloat;

  CalcTotalPayed;
end;   // of TFrmDetManInvoicePaymentCA.SvcLFChange

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CntItems         : Integer;          // Loop all panels on the panel
begin  // of TFrmDetManInvoicePaymentCA.FormClose
  inherited;
  // Destroy all autocreate panels.
  for CntItems := Pred (SbxPayments.ControlCount) downto 0 do begin
    if SbxPayments.Controls[CntItems] is TPanel then
      TPanel (SbxPayments.Controls[CntItems]).Free;
  end;
end;   // of TFrmDetManInvoicePaymentCA.FormClose

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.BtnCancelClick(Sender: TObject);
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin
  inherited;
  for CntPayments := 0 to Pred (LstPaymethodes.Count) do begin
    TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT :=
                TObjTransPayment(LstPrevPaymethodes[CntPayments]).PrcAdmInclVAT;
  end;
end;

//=============================================================================

procedure TFrmDetManInvoicePaymentCA.BtnOKClick(Sender: TObject);
var
  CntPayments      : Integer;          // Loop all payment-methodes
begin
  inherited;
  for CntPayments := 0 to Pred (LstPaymethodes.Count) do begin
    TObjTransPayment(LstPrevPaymethodes[CntPayments]).PrcAdmInclVAT :=
                    TObjTransPayment(LstPaymethodes[CntPayments]).PrcAdmInclVAT;
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FDetManInvoicePaymentCA
