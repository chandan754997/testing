//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   :
// Unit     : FFpnTndBankOrderCA = Form FlexPoiNt TeNDeR BANK ORDER CAstorama
//            Place order for cash money with bank
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndBankOrderCA.pas,v 1.2 2009/09/16 15:56:42 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FFpnTndBankOrderCA - CVS revision 1.3
//=============================================================================

unit FFpnTndBankOrderCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, ComCtrls, StdCtrls, Buttons, ExtCtrls, ScUtils, DFpnTenderGroup,
  DFpnSafeTransaction, OvcBase, OvcEF, OvcPB, OvcPF, DFpnAddress;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtTabShtCaptAccept = 'Acceptation orders';
  CtTxtEmOrderNotExist  = 'Order %s does not exist';
  CtTxtEmInvalidOrderNr = 'Invalid OrderNumber';
  CtTxtEmNoOrdersAvail  = 'No orders found to accept';
  CtTxtNoSuppliers      = '<No Pay Organization found in database>';
  CtTxtManualSupplier   = '<To be filled in later...>';
  CtTxtEmNoSupplier     = 'No supplier selected.';
  CtTxtNoOrders         = '<No orders>';
  CtTxtWantToContinue   = 'Do you want to continue?';

const  // Run function parameters
  CtCodFuncOrder        = 1;
  CtCodFuncAccept       = CtCodFuncOrder + 1;
  CtCodFuncOrderParam   = CtCodFuncAccept + 1;

const
  CtTxtPCaisseMonnaie   = '93';

//=============================================================================
// Names for at run time created components - formatted at run time with the
// number of the TabSheet.
//=============================================================================

const
  CtTxtNameTabSht       = 'TabSht%d';       // TabSheet for TenderGroup(s)
  CtTxtNamePnlHeader    = 'PnlHdrTab%d';    // Panel headers TabSheet
  CtTxtNamePnlFooter    = 'PnlFtrTab%d';    // Panel bottom TabSheet
  CtTxtNameSbxHeader    = 'SbxHdrTab%d';    // ScrollBox headers TabSheet
  CtTxtNameSbxCount     = 'SbxCount%d';     // ScrollBox Count on TabSheet

//=============================================================================
// Width of at run time created components
//=============================================================================

var
  ViValWidthSpace  : Integer =   1;    // Width between 2 components
  ViValWidthLblSign: Integer =  10;    // Width of labels for signs (X, =)
  ViValWidthQty    : Integer =  50;    // Width of component for quantity
  ViValWidthVal    : Integer =  70;    // Width of component for value
  ViValWidthDescr  : Integer = 120;    // Width of component for description

//=============================================================================
// Panels on statusbar
//=============================================================================

var
  ViNumPnlOperReg  : Integer = 2;      // Pnl show registrating operator

//*****************************************************************************
// Components at run time created
//*****************************************************************************

type
  TTabShtTender   = class;

//=============================================================================
// TPnlTender : common parent panel to administer a TenderGroup or a
// TenderUnit.
//=============================================================================

  TPnlTender       = class (TPanel)
  protected
    // Visual components on panel
    FLblDescr           : TLabel;           // Description TenderGroup or -Unit
    FSvcLFQtyUnit       : TSvcLocalField;   // Quantity units
    FSvcLFValUnit       : TSvcLocalField;   // Value unit
    FSvcLFValAmount     : TSvcLocalField;   // Amount
    // Datafields
    FObjTenderGroup     : TObjTenderGroup;  // TenderGroup for current panel
    FTabShtTender       : TTabShtTender;    // TabSheet where Panel belongs to
    // Methods
    function FocusNextPnlTender (FlgUp : Boolean) : Boolean; virtual;
  public
    // Methods for components on the Panel
    function CreateLabel (var ValLeft    : Integer;
                              ValWidth   : Integer;
                              TxtCaption : string ) : TLabel; virtual;
    function CreateLblSign (var ValLeft : Integer;
                                ChrSign : Char   ) : TLabel; virtual;
    function CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    procedure CreateForTender (var ValLeft : Integer); virtual;
    procedure FocusFirst; virtual;
    // Event Handlers
    procedure SvcLFChange (Sender : TObject); virtual;
    procedure SvcLFKeyDown (    Sender : TObject;
                            var Key    : Word;
                                Shift  : TShiftState); virtual;
    // Properties
    property LblDescr : TLabel read  FLblDescr
                               write FLblDescr;
    property SvcLFQtyUnit : TSvcLocalField read  FSvcLFQtyUnit
                                           write FSvcLFQtyUnit;
    property SvcLFValUnit : TSvcLocalField read  FSvcLFValUnit
                                           write FSvcLFValUnit;
    property SvcLFValAmount : TSvcLocalField read  FSvcLFValAmount
                                             write FSvcLFValAmount;
    property ObjTenderGroup : TObjTenderGroup read  FObjTenderGroup
                                              write FObjTenderGroup;
    property TabShtTender : TTabShtTender read  FTabShtTender
                                          write FTabShtTender;
  end;  // of TPnlTender

//=============================================================================
// TTabShtTender : common parent TabSheet to administer a collection of
// TenderUnits (for a TenderGroup) or a collection of TenderGroups.
//=============================================================================

  TTabShtTender    = class (TTabSheet)
  protected
    // Visual components on TabSheet
    FPnlHeader          : TPanel;           // Panel header TabSheet
    FPnlFooter          : TPanel;           // Panel footer results TabSheet
    FSbxHeader          : TScrollBox;       // Scroll-box header TabSheet
    FSbxCount           : TScrollBox;       // Scroll-box for Count in Tender
    // Datafields
    FObjTenderGroup     : TObjTenderGroup;  // Current TenderGroup in TabSheet
    FCtlFocusOnExit     : TWinControl;      // Control to focus on Exit TabSht
    FCtlCancel          : TWinControl;      // Control used to cancel operations
  public
    // Constructor and destructor
    constructor CreateForTender (PgeCtlParent   : TPageControl;
                                 ObjTenderGroup : TObjTenderGroup); virtual;
    // Methods for components on the TabSheet
    procedure AdjustScrollBarRange (ValHorz : Integer;
                                    ValVert : Integer); virtual;
    procedure CreateFooter (var ValLeft : Integer); virtual;
    procedure CreateHeader (var ValLeft : Integer); virtual;
    function CreateLblHeader (var ValLeft    : Integer;
                                  ValWidth   : Integer;
                                  TxtCaption : string ) : TLabel; virtual;
    function CreateLblFooter (var ValLeft    : Integer;
                                  TxtCaption : string ) : TLabel; virtual;
    function CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreatePnlTheor (CtlParent : TWinControl;
                             ValLeft   : Integer;
                             ValWidth  : Integer   ) : TPanel; virtual;
    procedure AdjustPnlCount (PnlCount : TPnlTender); virtual;
    function FindNextPnlTender (PnlStart : TPnlTender;
                                FlgUp    : Boolean) : TPnlTender; virtual;
    procedure FocusFirst; virtual;
    // Properties
    property PnlHeader : TPanel read  FPnlHeader
                                write FPnlHeader;
    property PnlFooter : TPanel read  FPnlFooter
                                write FPnlFooter;
    property SbxHeader : TScrollBox read  FSbxHeader
                                    write FSbxHeader;
    property SbxCount : TScrollBox read  FSbxCount
                                   write FSbxCount;
    property ObjTenderGroup : TObjTenderGroup read  FObjTenderGroup
                                              write FObjTenderGroup;
    property CtlFocusOnExit : TWinControl read  FCtlFocusOnExit
                                          write FCtlFocusOnExit;
    property CtlCancel : TWinControl read  FCtlCancel
                                     write FCtlCancel;
  end;  // of TTabShtTender

//=============================================================================
// TPnlCashUnit : panel to show a TenderUnit of the Cash TenderGroup.
//=============================================================================

type
  TPnlCashUnit     = class (TPnlTender)
  protected
    FObjTenderUnit : TObjTenderUnit;        // to what object Tenderunit is this
                                            // panel linked ?
  public
    // Methods for components on the Panel
    procedure CreateForTender (var ValLeft : Integer); override;
    procedure ConfigForTenderUnit (ObjTenderUnit : TObjTenderUnit); virtual;
    // Event Handlers
    procedure SvcLFChange (Sender : TObject); override;
    procedure SvcLFQtyKeyDown (    Sender : TObject;
                               var Key    : Word;
                                   Shift  : TShiftState); virtual;
    procedure SvcLFValAmountValidate (    Sender    : TObject;
                                      var ErrorCode : Word   );
    // Properties
    property ObjTenderUnit : TObjTenderUnit read  FObjTenderUnit
                                            write FObjTenderUnit;
  end;  // of TPnlCashUnit

//=============================================================================
// TTabShtCashUnit : TabSheet to administer a collection of TenderUnits
// for a TenderGroup Cash
//=============================================================================

type
  TTabShtCashUnit  = class (TTabShtTender)
  protected
    // Visual components on TabSheet
    FSvcLFValTotal      : TSvcLocalField;   // Total amount currency group
    FSvcLFValTotalCM    : TSvcLocalField;   // Total amount currency main
  public
    // Constructor and destructor
    constructor CreateForTender (PgeCtlParent   : TPageControl;
                                 ObjTenderGroup : TObjTenderGroup); override;
    // Methods for components on the TabSheet
    procedure CreateFooter (var ValLeft : Integer); override;
    function CreateCountItem (ObjTenderUnit  : TObjTenderUnit ) : TPnlTender;
                                                                        virtual;
    // Properties
    property SvcLFValTotal : TSvcLocalField read  FSvcLFValTotal
                                            write FSvcLFValTotal;
    property SvcLFValTotalCM : TSvcLocalField read  FSvcLFValTotalCM
                                              write FSvcLFValTotalCM;
  end;  // of TTabShtCashUnit

//=============================================================================
// TTabShtAcceptation : TabSheet to administer a collection of TenderUnits
// of one order.  Tabsheet has a fixed title as is NOT linked to any tendergroup
//=============================================================================

type
  TTabShtAcceptation  = class (TTabShtCashUnit)
  protected
    FObjSafeTrans    : TObjSafeTransaction; // object safetrans money order
    FNewObjSafeTrans : TObjSafeTransaction; // object safetrans acceptation
  public
    // Constructor
    constructor CreateForTender (PgeCtlParent   : TPageControl;
                                 ObjTenderGroup : TObjTenderGroup); override;
    property ObjSafeTrans : TObjSafeTransaction read  FObjSafeTrans
                                                write FObjSafeTrans;
    property NewObjSafeTrans : TObjSafeTransaction read  FNewObjSafeTrans
                                                   write FNewObjSafeTrans;
  end;  // of TTabShtAcceptation

type
  TFrmTndBankOrderCA = class(TFrmCommon)
    PnlTop: TPanel;
    StsBarInfo: TStatusBar;
    PnlBottom: TPanel;
    BtnAccept: TBitBtn;
    BtnCancel: TBitBtn;
    PgeCtlCount: TPageControl;
    OvcCtlCount: TOvcController;
    CbxSupplier: TComboBox;
    LblSupplier: TLabel;
    CbxOrder: TComboBox;
    LblOrders: TLabel;
    procedure OvcCtlCountIsSpecialControl(Sender: TObject; Control: TWinControl;
      var Special: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure BtnAcceptClick(Sender: TObject);
    procedure CbxOrderExit(Sender: TObject);
    procedure CbxOrderKeyDown(Sender: TObject; var Key:Word; Shift:TShiftState);
    procedure CbxSupplierKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    { Protected declarations }
    // Datafields
    SavAppOnIdle        : TIdleEvent;  // Save original OnIdle event handler
    FIdtOperReg         : string;      // IdtOperator registrating
    FTxtNameOperReg     : string;      // Name operator registrating
    FFlgEverActivated   : Boolean;     // Indicates first time form is activated
    FCodRunFunc         : Integer;     // Function Print or Transfer
    FIdtOrderNumber     : Integer;     // new ordernr to store in TxtExplanation
    FLstTransDet        : TLstTransDetail; // list of SafeTransdetail
    FIdtAddrPayOrg      : Integer;     // Selected IdtAddrPayOrg from Combobox
    FlgPayOrganFound    : Boolean;     // Flag if payorgan found in database
    FNumAmount          : Currency;        // Maximum amount for coin in a roll
    function GetIdtOperReg : string; virtual;
    procedure SetIdtOperReg (Value : string); virtual;
    procedure SetTxtNameOperReg (Value : string); virtual;
    procedure CreateTenderGroupLists; virtual;
    procedure AddTenderUnits; virtual;
    procedure CreateTabShtTenderUnits (ObjTenderGroup: TObjTenderGroup);virtual;
    procedure CreateTenderGroupTabShts; virtual;
    procedure CreateAcceptationTabSht; virtual;
    procedure OnFirstIdle (    Sender : TObject;
                           var Done   : Boolean); virtual;
    function AllowTenderGroup (ObjTenderGroup : TObjTenderGroup) : Boolean;
                                                                        virtual;
    procedure PrepareSafeTransdetail (ObjSafeTrans   : TObjSafeTransaction;
                                      PnlCash        : TPnlCashUnit;
                                      ObjTendergroup : TObjTendergroup); virtual;
    procedure CommitMoneyOrderToDatabase; virtual;
    procedure CommitAcceptedOrderToDatabase; virtual;
    procedure PrintReportMoneyOrder; virtual;
    procedure PrintReportAcceptedOrder; virtual;
    procedure PrintReportMoneyOrderParam; virtual;
    procedure RetrievePayOrgan (CodTypePayOrgan : Integer); virtual;
    procedure RetrieveOrders; virtual;
    procedure FillPanelsWithOrderData (ObjSafeTrans : TObjSafeTransaction);virtual;
    procedure SaveAndPrintMoneyOrder; virtual;
    procedure SaveAndPrintAcceptedOrder; virtual;
    procedure SaveAndPrintMoneyOrderParam; virtual;
    procedure ClearPanels; virtual;
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
  published
    { Published declarations }
    property CodRunFunc       : Integer read  FCodRunFunc
                                        write FCodRunFunc;    
    property IdtOperReg : string read  GetIdtOperReg
                                 write SetIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write SetTxtNameOperReg;
    property IdtOrderNumber : integer read  FIdtOrderNumber
                                      write FIdtOrderNumber;
    property IdtAddrPayOrg : Integer read  FIdtAddrPayOrg
                                     write FIdtAddrPayOrg;
    property LstTransDet : TLstTransDetail read  FLstTransDet
                                           write FLstTransDet;
  end;

var
  FrmTndBankOrderCA : TFrmTndBankOrderCA;

implementation

{$R *.DFM}

uses

  OvcData,
  ScTskMgr_BDE_DBC,
  sfDialog,
  SmUtils,
  RFpnCom,
  RFpnTender,
  DFpnTender,
  DFpnTenderCA,
  DFpnTenderGroupCA,
  FLoginTenderCA,
  DFpnUtils,
  DFpnSafeTransactionCA,
  SmDBUtil_BDE;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FFpnTndBankOrderCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndBankOrderCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/16 15:56:42 $';

//*****************************************************************************
// Implementation of TPnlTender
//*****************************************************************************

//=============================================================================
// TPnlTender.FocusNextPnlTender : sets the focus on the first enabled
// component of the next (or previous) Panel for Tender.
// count item.
//                                  -----
// INPUT   : PnlCurrent = Panel current count item.
//           FlgUp = True to return the next Panel;
//                   False to return the previous Panel.
//                                  -----
// FUNCRES : True if next (or previous) Panel found;
//           False if no next (or previous) Panel found.
//=============================================================================

function TPnlTender.FocusNextPnlTender (FlgUp : Boolean) : Boolean;
var
  PnlFocus         : TPnlTender;       // Find panel to focus on
begin  // of TPnlTender.FocusNextPnlTender
  PnlFocus := Self;
  repeat
    PnlFocus := TabShtTender.FindNextPnlTender (PnlFocus, FlgUp);
    if Assigned (PnlFocus) then
      Break;
  until not Assigned (PnlFocus);

  Result := Assigned (PnlFocus);
  if Result then
    PnlFocus.FocusFirst
  else if (not FlgUp) and Assigned (TabShtTender.CtlFocusOnExit) and
          TabShtTender.CtlFocusOnExit.CanFocus then
    TabShtTender.CtlFocusOnExit.SetFocus
  else if Enabled then
    FocusFirst;
end;   // of TPnlTender.FocusNextPnlTender

//=============================================================================
// TPnlTender.CreateLabel : creates a label.
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

function TPnlTender.CreateLabel (var ValLeft    : Integer;
                                     ValWidth   : Integer;
                                     TxtCaption : string    ) : TLabel;
begin  // of TPnlTender.CreateLabel
  Result := TLabel.Create (Owner);

  Result.Parent     := Self;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := False;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlTender.CreateLabel

//=============================================================================
// TPnlTender.CreateLblSign : creates a label for a sign-character.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//           ChrSign = Caption for the label.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlTender.CreateLblSign (var ValLeft : Integer;
                                       ChrSign : Char    ) : TLabel;
begin  // of TPnlTender.CreateLblSign
  Result := CreateLabel (ValLeft, ViValWidthLblSign, ChrSign);
  Result.Alignment := taCenter;
end;   // of TPnlTender.CreateLblSign

//=============================================================================
// TPnlTender.CreateSvcLFQty : creates a new component to hold or enter
// a quantity.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlTender.CreateSvcLFQty (var ValLeft : Integer): TSvcLocalField;
begin  // of TPnlTender.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := Self;
  Result.Left          := ValLeft;
  Result.DataType      := pftLongInt;
  Result.PictureMask   := '99999';
  Result.MaxLength     := 5;
  Result.RangeHi       := '99999';
  Result.RangeLo       := '0';
  Result.Options := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthQty;

  Result.OnChange  := SvcLFChange;
  Result.OnKeyDown := SvcLFKeyDown;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlTender.CreateSvcLFQty

//=============================================================================
// TPnlTender.CreateSvcLFVal : creates a new component to hold or enter
// a value.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlTender.CreateSvcLFVal (var ValLeft : Integer): TSvcLocalField;
begin  // of TPnlTender.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := Self;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthVal;

  Result.OnChange  := SvcLFChange;
  Result.OnKeyDown := SvcLFKeyDown;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlTender.CreateSvcLFVal

//=============================================================================
// TPnlTender.CreateForTender : creates the components for count on the Panel.
//                                  -----
// INPUT   : ValLeft = left property for the first component to create.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append components.
//=============================================================================

procedure TPnlTender.CreateForTender (var ValLeft : Integer);
begin  // of TPnlTender.CreateForTender
  // Component for Quantity
  SvcLFQtyUnit := CreateSvcLFQty (ValLeft);
  // Label for Multiply sign
  CreateLblSign (ValLeft, 'X');
  // Component for Value of unit
  SvcLFValUnit := CreateSvcLFVal (ValLeft);
  // Label for description of count item
  LblDescr := CreateLabel (ValLeft, ViValWidthDescr, '');
  // Label for Equal sign
  CreateLblSign (ValLeft, '=');
  // Create component for Amount of Count-item
  SvcLFValAmount         := CreateSvcLFVal (ValLeft);
  SvcLFValAmount.Enabled := False;

  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlTender.CreateForTender

//=============================================================================
// TPnlTender.FocusFirst : sets the focus on the first enabled component
// on the panel.
//=============================================================================

procedure TPnlTender.FocusFirst;
begin  // of TPnlTender.FocusFirst
  if SvcLFQtyUnit.Enabled then
    SvcLFQtyUnit.SetFocus
  else if SvcLFValUnit.Enabled then
    SvcLFValUnit.SetFocus
  else if SvcLFValAmount.Enabled then
    SvcLFValAmount.SetFocus;
end;   // of TPnlTender.FocusFirst

//=============================================================================
// TPnlTender.SvcLFChange : general Event Handler OnChange for TSvcLocalField.
// See TOvcPictureField.OnChange.
//=============================================================================

procedure TPnlTender.SvcLFChange (Sender : TObject);
begin  // of TPnlTender.SvcLFChange
  inherited;
  SvcLFValAmount.AsFloat := SvcLFQtyUnit.AsInteger * SvcLFValUnit.AsFloat;
end;   // of TPnlTender.SvcLFChange

//=============================================================================
// TPnlTender.SvcLFKeyDown : general Event Handler OnKeyDown for TSvcLocalField.
// See TOvcPictureField.OnKeyDown.
//=============================================================================

procedure TPnlTender.SvcLFKeyDown (    Sender : TObject;
                                   var Key    : Word;
                                       Shift  : TShiftState);
begin  // of TPnlTender.SvcLFKeyDown
  if (Shift = []) and (Key = VK_RETURN) then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := 0;
  end

  else if (Shift = []) and (Key in [VK_UP, VK_DOWN]) then begin
    FocusNextPnlTender (Key = VK_UP);
    Key := 0;
  end;
end;   // of TPnlTender.SvcLFKeyDown

//*****************************************************************************
// Implementation of TTabShtTender
//*****************************************************************************

//=============================================================================
// TTabShtTender.CreateForTender : creates a new TabSheet.
//                                  -----
// INPUT   : PgeCtlParent = PageControl to create the TabSheet for (also used
//                          to determine the Owner of the created components).
//           ObjTenderGroup = TenderGroup to create the TabSheet for.
//=============================================================================

constructor TTabShtTender.CreateForTender (PgeCtlParent   : TPageControl;
                                           ObjTenderGroup : TObjTenderGroup);
var
  ValLeft          : Integer;          // Var-parameter for CreateHeader
begin  // of TTabShtTender.CreateForTender
  inherited Create (PgeCtlParent.Owner);
  TabVisible := True;
  FObjTenderGroup := ObjTenderGroup;

  PageControl := PgeCtlParent;
  Name        := Format (CtTxtNameTabSht, [PgeCtlParent.PageCount - 1]);
  Caption     := ObjTenderGroup.TxtPublDescr;

  // Panel Footer for totals on TabSheet
  PnlFooter            := TPanel.Create (PgeCtlParent.Owner);
  PnlFooter.Name       := Format (CtTxtNamePnlFooter,
                                  [PgeCtlParent.PageCount - 1]);
  PnlFooter.Parent     := Self;
  PnlFooter.Caption    := '';
  PnlFooter.Align      := alBottom;
  PnlFooter.BevelInner := bvLowered;
  PnlFooter.BevelOuter := bvRaised;
  PnlFooter.Height     := 40;

  // ScrollBox Header for labels - a seperate ScrollBox for horizontal scroll
  // only, scroll header-labels as well as count-panels.
  SbxHeader             := TScrollBox.Create (PgeCtlParent.Owner);
  SbxHeader.Name        := Format (CtTxtNameSbxHeader,
                                   [PgeCtlParent.PageCount - 1]);
  SbxHeader.Parent      := Self;
  SbxHeader.Align       := alClient;
  SbxHeader.BorderStyle := bsNone;
  SbxHeader.VertScrollBar.Visible := False;

  // Panel Header for labels
  PnlHeader := TPanel.Create (PgeCtlParent.Owner);
  PnlHeader.Name       := Format (CtTxtNamePnlHeader,
                                  [PgeCtlParent.PageCount - 1]);
  PnlHeader.Parent     := SbxHeader;
  PnlHeader.Caption    := '';
  PnlHeader.Align      := alTop;
  PnlHeader.BevelOuter := bvNone;
  PnlHeader.Height     := 20;

  // Scrollbox for TenderGroups or TenderUnits on TabSheet - shows only
  // vertical scrollbar (horizontal scrolling is taken care of by SbxHeader).
  SbxCount             := TScrollBox.Create (PgeCtlParent.Owner);
  SbxCount.Name        := Format (CtTxtNameSbxCount,
                                   [PgeCtlParent.PageCount - 1]);
  SbxCount.Parent      := SbxHeader;
  SbxCount.Align       := alClient;
  SbxCount.BorderStyle := bsNone;
  SbxCount.VertScrollBar.Increment := 24;
  SbxCount.VertScrollBar.Tracking := True;
  SbxCount.HorzScrollBar.Visible := False;

  // Header on TabSheet
  ValLeft := 8;
  CreateHeader (ValLeft);
  CreateFooter (ValLeft);
end;   // of TTabShtTender.CreateForTender

//=============================================================================
// TTabShtTender.AdjustScrollBarRange : adjusts the Range for the ScrollBars
// on the ScrollBoxes on the TabSheet.
//                                  -----
// INPUT   : ValHorz = Range for Horizontal ScrollBar.
//           ValVert = Range for Vertical ScrollBar.
//                                  -----
// Restrictions :
// - the passed ranges are incremented with 20 to leave some place for the
//   vertical scrollbar on the horizontal scrollbar (and opposite).
//=============================================================================

procedure TTabShtTender.AdjustScrollBarRange (ValHorz : Integer;
                                              ValVert : Integer);
begin  // of TTabShtTender.AdjustScrollBarRange
  if SbxHeader.HorzScrollBar.Range < ValHorz then
    SbxHeader.HorzScrollBar.Range := ValHorz;

  if SbxCount.VertScrollBar.Range < ValVert then
    SbxCount.VertScrollBar.Range := ValVert;
end;   // of TTabShtTender.AdjustScrollBarRange

//=============================================================================
// TTabShtTender.CreateFooter : ready to create the components for totals
// on the Footer of the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for components to create.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append components.
//=============================================================================

procedure TTabShtTender.CreateFooter (var ValLeft : Integer);
begin  // of TTabShtTender.CreateFooter
  ValLeft := 8;
end;   // of TTabShtTender.CreateFooter

//=============================================================================
// TTabShtTender.CreateHeader : creates the header for the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for first created header-label.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append header-labels.
//=============================================================================

procedure TTabShtTender.CreateHeader (var ValLeft : Integer);
begin  // of TTabShtTender.CreateHeader
  // Header Quantity Unit
  CreateLblHeader (ValLeft, ViValWidthQty, CtTxtHdrQtyUnit);
  // Leave room for multiply sign
  Inc (ValLeft, ViValWidthLblSign + ViValWidthSpace);

  // Header Value Unit
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValUnit);

  // Leave room for description and equal sign
  Inc (ValLeft, ViValWidthDescr + ViValWidthLblSign + (2 * ViValWidthSpace));

  // Header Value Amount
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValAmount);
end;   // of TTabShtTender.CreateHeader

//=============================================================================
// TTabShtTender.CreateLblHeader : creates a label for a header.
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

function TTabShtTender.CreateLblHeader (var ValLeft    : Integer;
                                            ValWidth   : Integer;
                                            TxtCaption : string ) : TLabel;
begin  // of TTabShtTender.CreateLblHeader
  Result := TLabel.Create (Owner);

  Result.Parent     := PnlHeader;
  Result.WordWrap   := True;
  Result.Caption    := TxtCaption;
  Result.Alignment  := taRightJustify;
  Result.AutoSize   := False;
  Result.Font.Style := [fsBold, fsUnderline];
  Result.Left       := ValLeft;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtTender.CreateLblHeader

//=============================================================================
// TTabShtTender.CreateLblFooter : creates a label on the Footer.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//           TxtCaption = Caption for the label.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtTender.CreateLblFooter (var ValLeft    : Integer;
                                            TxtCaption : string ) : TLabel;
begin  // of TTabShtTender.CreateLblFooter
  Result := TLabel.Create (Owner);

  Result.Parent     := PnlFooter;
  Result.Caption    := TxtCaption;
  Result.Left       := ValLeft;
  Result.Top        := 12;

  Inc (ValLeft, Result.Width + (2 * ViValWidthSpace));
end;   // of TTabShtTender.CreateLblFooter

//=============================================================================
// TTabShtTender.CreateSvcLFQty : creates a new component on the Footer for
// consulting a quantity.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtTender.CreateSvcLFQty (var ValLeft : Integer): TSvcLocalField;
begin  // of TTabShtTender.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.Top           := 8;
  Result.DataType      := pftLongInt;
  Result.PictureMask   := '99999';
  Result.MaxLength     := 5;
  Result.RangeHi       := '99999';
  Result.RangeLo       := '0';
  Result.Options := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthQty;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtTender.CreateSvcLFQty

//=============================================================================
// TTabShtTender.CreateSvcLFVal : creates a new component on the Footer for
// consulting a value.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtTender.CreateSvcLFVal (var ValLeft : Integer): TSvcLocalField;
begin  // of TTabShtTender.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.Top           := 8;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthVal;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtTender.CreateSvcLFVal

//=============================================================================
// TTabShtTender.CreatePnlTheor : creates a Panel for theoretic results.
//                                  -----
// INPUT   : CtlParent = Parent for the created Panel.
//           ValLeft = Left for the created Panel.
//           ValWidth = With for the created Panel.
//                                  -----
// FUNCRES : created Panel.
//=============================================================================

function TTabShtTender.CreatePnlTheor (CtlParent : TWinControl;
                                       ValLeft   : Integer;
                                       ValWidth  : Integer   ) : TPanel;
begin  // of TTabShtTender.CreatePnlTheor
  Result := TPanel.Create (Owner);

  Result.Parent     := CtlParent;
  Result.Left       := ValLeft;
  Result.Width      := ValWidth;
  Result.Height     := CtlParent.Height;
  Result.Top        := 0;
  Result.BevelOuter := bvNone;
end;   // of TTabShtTender.CreatePnlTheor

//=============================================================================
// TTabShtTender.AdjustPnlCount : configures the panel for a countable item.
//                                  -----
// INPUT   : PnlCount = Panel to configure.
//                                  -----
// Restrictions :
// - assumes the Panel is created by an inherited method.
//=============================================================================

procedure TTabShtTender.AdjustPnlCount (PnlCount : TPnlTender);
begin  // of TTabShtTender.AdjustPnlCount
  PnlCount.Parent := SbxCount;
  PnlCount.Caption    := '';
  PnlCount.BevelOuter := bvNone;
  PnlCount.Height     := 24;

  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  alligned on Top, then change it to align on Top.
  PnlCount.Top   := SbxCount.VertScrollBar.Range;
  PnlCount.Align := alTop;
end;   // of TTabShtTender.AdjustPnlCount

//=============================================================================
// TTabShtTender.FindNextPnlTender : returns the next (or previous) Panel for
// Tender with the same Parent.
//                                  -----
// INPUT   : PnlStart = Pnl to start looking from;
//                      nil to find the first (with FlgUp = False) or
//                      the last (with FlgUp = True) TenderPanel.
//           FlgUp = True to return the next TenderPanel;
//                   False to return the previous TenderPanel.
//                                  -----
// FUNCRES : found TenderPanel; nil if no next (or previous) TenderPanel found.
//=============================================================================

function TTabShtTender.FindNextPnlTender (PnlStart : TPnlTender;
                                          FlgUp    : Boolean   ) : TPnlTender;
var
  CntCtl           : Integer;          // Counter controls
  NumCtlCheck      : Integer;          // Number of control to check
begin  // of TTabShtTender.FindNextPnlTender
  Result := nil;

  if not Assigned (PnlStart) then begin
    if FlgUp then
      NumCtlCheck := Pred (SbxCount.ControlCount)
    else
      NumCtlCheck := 0;
  end
  else begin
    NumCtlCheck := -1;
    for CntCtl := 0 to Pred (SbxCount.ControlCount) do begin
      if SbxCount.Controls[CntCtl] = PnlStart then begin
        NumCtlCheck := CntCtl;
        Break;
      end;
    end;
    if FlgUp then
      Dec (NumCtlCheck)
    else
      Inc (NumCtlCheck);
  end;

  while (NumCtlCheck >= 0) and (NumCtlCheck < SbxCount.ControlCount) do begin
    if SbxCount.Controls[NumCtlCheck] is TPnlTender then begin
      Result := TPnlTender(SbxCount.Controls[NumCtlCheck]);
      Break;
    end;
    if FlgUp then
      Dec (NumCtlCheck)
    else
      Inc (NumCtlCheck);
  end;
end;   // of TTabShtTender.FindNextPnlTender

//=============================================================================
// TTabShtTender.FocusFirst : sets the focus on the first enabled component
// on the first TenderPanel.
//=============================================================================

procedure TTabShtTender.FocusFirst;
var
  PnlTender        : TPnlTender;       // Find first Panel for Tender
begin  // of TTabShtTender.FocusFirst
  PnlTender := FindNextPnlTender (nil, False);
  if Assigned (PnlTender) then
    PnlTender.FocusFirst;
end;   // of TTabShtTender.FocusFirst

//*****************************************************************************
// Implementation of TPnlCashUnit
//*****************************************************************************

procedure TPnlCashUnit.CreateForTender (var ValLeft : Integer);
begin  // of TPnlCashUnit.CreateForTender
  inherited CreateForTender (ValLeft);

  // Adjust default components
  SvcLFQtyUnit.OnKeyDown := SvcLFQtyKeyDown;
  SvcLFQtyUnit.Enabled   := True;
  SvcLFValUnit.Enabled   := False;
  SvcLFValAmount.Enabled := False;
  if ObjTenderGroup.CodDetail = CtCodTgdAmount then begin
    SvcLFQtyUnit.Enabled   := False;
    SvcLFValAmount.Enabled := True;
    SvcLFValAmount.OnUserValidation := SvcLFValAmountValidate;
    SvcLFValAmount.OnKeyDown := SvcLFQtyKeyDown;
    SvcLFValAmount.OnChange := SvcLFChange;
  end;
end;   // of TPnlCashUnit.CreateForTender

//=============================================================================
// TPnlCashUnit.ConfigForTenderUnit : configures the components on the panel
// for the current TenderUnit.
//                                  -----
// INPUT   : ObjTenderUnit = TenderUnit to adjust the components for.
//=============================================================================

procedure TPnlCashUnit.ConfigForTenderUnit (ObjTenderUnit : TObjTenderUnit);
begin  // of TPnlCashUnit.ConfigForTenderUnit
  SvcLFValUnit.AsFloat := ObjTenderUnit.ValUnit;
  LblDescr.Caption := ObjTenderUnit.TxtDescr;
  Self.ObjTenderUnit := ObjTenderUnit;
end;   // of TPnlCashUnit.ConfigForTenderUnit

//=============================================================================

procedure TPnlCashUnit.SvcLFChange (Sender : TObject);
var
  CntCtl           : Integer;          // Counter controls on parent
  ValTotal         : Currency;         // Calculate total for panels
begin  // of TPnlCashUnit.SvcLFChange
  if SvcLFQtyUnit.Enabled then
    inherited
  else
    SvcLFQtyUnit.AsInteger := Round (SvcLFValAmount.AsFloat /
                                     SvcLFValUnit.AsFloat);

  ValTotal := 0;
  for CntCtl := 0 to Pred (TabShtTender.SbxCount.ControlCount) do begin
    if TabShtTender.SbxCount.Controls[CntCtl] is TPnlCashUnit then
      ValTotal := ValTotal +
                  TPnlCashUnit(TabShtTender.SbxCount.Controls[CntCtl]).
                  SvcLFValAmount.AsFloat;
  end;
  TTabShtCashUnit(TabShtTender).SvcLFValTotal.AsFloat := ValTotal;
  FrmTndBankOrderCA.BtnAccept.Enabled :=
    ((FrmTndBankOrderCA.CodRunFunc = CtCodFuncOrder) and
    (Abs (TTabShtCashUnit(TabShtTender).SvcLFValTotal.AsFloat) >= CtValMinFloat))
    or
    (FrmTndBankOrderCA.CodRunFunc = CtCodFuncAccept)
    or
    ((FrmTndBankOrderCA.CodRunFunc = CtCodFuncOrderParam) and
    (Abs (TTabShtCashUnit(TabShtTender).SvcLFValTotal.AsFloat) >= CtValMinFloat));
  if Assigned (TTabShtCashUnit(TabShtTender).SvcLFValTotalCM) then
    TTabShtCashUnit(TabShtTender).SvcLFValTotalCM.AsFloat :=
      DmdFpnUtils.ExchangeCurr (ValTotal, ObjTenderGroup.ValExchange,
                                ObjTenderGroup.FlgExchMultiply,
                                DmdFpnUtils.ValExchangeBase, True);
end;   // of TPnlCashUnit.SvcLFChange

//=============================================================================
// TPnlCashUnit.SvcLFQtyKeyDown : Event Handler OnKeyDown for SvcLFQtyUnit.
// See TOvcPictureField.OnChange.
//=============================================================================

procedure TPnlCashUnit.SvcLFQtyKeyDown (    Sender : TObject;
                                        var Key    : Word;
                                            Shift  : TShiftState);
begin  // of TPnlCashUnit.SvcLFQtyKeyDown
  if (Shift = []) and (Key = VK_RETURN) then begin
    FocusNextPnlTender (False);
    Key := 0;
  end
  else
    SvcLFKeyDown (Sender, Key, Shift);
end;   // of TPnlCashUnit.SvcLFQtyKeyDown

//=============================================================================
// TPnlCashUnit.SvcLFValAmountValidate : Event Handler OnUserValidation for
// SvcLFValAmount.
// See TOvcPictureField.OnChange.
//=============================================================================

procedure TPnlCashUnit.SvcLFValAmountValidate (    Sender    : TObject;
                                               var ErrorCode : Word   );
var
  ValAmount        : Currency;         // ValAmount as Currency
  ValUnit          : Currency;         // ValUnit as Currency
begin  // of TPnlCashUnit.SvcLFValAmountValidate
  // Avoid using floats to get the fractional part of a division:
  //   when using floats, 0.15 is not a multiple of 0.05 because
  //   Frac (ValAmount / ValUnit) results in 1.
  ValAmount := SvcLFValAmount.AsFloat;
  ValUnit   := SvcLFValUnit.AsFloat;
  if Abs (Frac (ValAmount / ValUnit)) > CtValMinFloat then begin
    // ValAmount MUST be a multiple of ValUnit
    ErrorCode := oeCustomError;
    SvcLFValAmount.Controller.ErrorText := Format (CtTxtEmNotAMultiple,
                                                   [SvcLFValAmount.AsFloat,
                                                    SvcLFValUnit.AsFloat]);
  end;
end;   // of TPnlCashUnit.SvcLFValAmountValidate

//*****************************************************************************
// Implementation of TTabShtCashUnit
//*****************************************************************************

constructor TTabShtCashUnit.CreateForTender (PgeCtlParent   : TPageControl;
                                             ObjTenderGroup : TObjTenderGroup);
begin  // of TTabShtCashUnit.CreateForTender
  inherited CreateForTender (PgeCtlParent, ObjTenderGroup);

  Caption := Format ('%s %s', [ObjTenderGroup.TxtPublDescr,
                               ObjTenderGroup.IdtCurrency]);
end;   // of TTabShtCashUnit.CreateForTender

//=============================================================================
// TTabShtCashUnit.CreateFooter : creates the footer panel for the tabsheet
// INPUT   : ValLeft = where to start on the panel
//=============================================================================


procedure TTabShtCashUnit.CreateFooter (var ValLeft : Integer);
begin  // of TTabShtCashUnit.CreateFooter
  inherited CreateFooter (ValLeft);

  if (ObjTenderGroup.IdtCurrency <> DmdFpnUtils.IdtCurrencyMain) then
    // Adjust Height of PnlFooter for totals in Main currency
    PnlFooter.Height := PnlFooter.Height + 24;

  // Label for Total Amount
  CreateLblFooter (ValLeft, CtTxtHdrTotalCount + ': ');
  // Component for Total Amount
  SvcLFValTotal := CreateSvcLFVal (ValLeft);
  // Label for Currency abbreviation
  CreateLblFooter (ValLeft, ObjTenderGroup.IdtCurrency);
end;   // of TTabShtCashUnit.CreateFooter

//=============================================================================
// TTabShtCashUnit.CreateCountItem : creates the Panel and necessary
// componentsfor a cash unit.
//                                  -----
// INPUT   : ObjTenderUnit = TenderUnit to create the Panel for.
//                                  -----
// FUNCRES : created Panel.
//=============================================================================

function TTabShtCashUnit.CreateCountItem (ObjTenderUnit : TObjTenderUnit) :
                                                                     TPnlTender;
var
  ValLeft          : Integer;          // Left property for new components
begin  // of TTabShtCashUnit.CreateCountItem
  Result := TPnlCashUnit.Create (Owner);

  Result.TabShtTender   := Self;
  Result.ObjTenderGroup := ObjTenderGroup;

  AdjustPnlCount (Result);

  ValLeft := 8;

  TPnlCashUnit(Result).CreateForTender (ValLeft);
  TPnlCashUnit(Result).ConfigForTenderUnit (ObjTenderUnit);
end;   // of TTabShtCashUnit.CreateCountItem

//*****************************************************************************
// Implementation of TTabShtAcceptation
//*****************************************************************************

constructor TTabShtAcceptation.CreateForTender
                                      (PgeCtlParent   : TPageControl;
                                       ObjTenderGroup : TObjTenderGroup);
begin  // of TTabShtAcceptation.CreateForTender
  inherited CreateForTender (PgeCtlParent, ObjTenderGroup);

  Caption := CtTxtTabShtCaptAccept;
end;   // of TTabShtAcceptation.CreateForTender

//*****************************************************************************
// Implementation of TFrmTndBankOrderCA
//*****************************************************************************

procedure TFrmTndBankOrderCA.FormActivate(Sender: TObject);
begin // of TFrmTndBankOrderCA.FormActivate
  inherited;
  if not FlgEverActivated then begin
    SavAppOnIdle := Application.OnIdle;
    Application.OnIdle := OnFirstIdle;
  end;

  FFlgEverActivated := True;
end;  // of TFrmTndBankOrderCA.FormActivate

//=============================================================================
// TFrmTndBankOrderCA.GetIdtOperReg : Setter for IdtOperReg
//=============================================================================

function TFrmTndBankOrderCA.GetIdtOperReg : string;
begin  // of TFrmTndBankOrderCA.GetIdtOperReg
  Result := FIdtOperReg;
end;   // of TFrmTndBankOrderCA.GetIdtOperReg

//=============================================================================
// TFrmTndBankOrderCA.SetIdtOperReg : Setter for IdtOperReg
//=============================================================================

procedure TFrmTndBankOrderCA.SetIdtOperReg (Value : string);
begin  // of TFrmTndBankOrderCA.SetIdtOperReg
  FIdtOperReg := Value;
end;   // of TFrmTndBankOrderCA.SetIdtOperReg

//=============================================================================
// TFrmTndBankOrderCA.SetTxtNameOperReg : Setter for TxtnameOperReg
//=============================================================================

procedure TFrmTndBankOrderCA.SetTxtNameOperReg (Value : string);
begin  // of TFrmTndBankOrderCA.SetTxtNameOperReg
  FTxtNameOperReg := Value;
  StsBarInfo.Panels[ViNumPnlOperReg].Text := Format ('%s : %s',
                                                     [CtTxtOperReg, Value]);
end;   // of TFrmTndBankOrderCA.SetTxtNameOperReg

//=============================================================================
// TFrmTndBankOrderCA.CreateTenderGroupLists : creates and loads from database
// the lists with TenderGroup and TenderUnit, which weren't created yet.
//=============================================================================

procedure TFrmTndBankOrderCA.CreateTenderGroupLists;
var
  CntItem          : Integer;          // TenderGroups
  ValUnit          : Currency;         // Valunit
begin  // of TFrmTndBankOrderCA.CreateTenderGroupLists
  if not Assigned (LstTenderGroup) then begin
    LstTenderGroup := TLstTenderGroup.Create;
    DmdFpnTenderGroup.BuildListTenderGroup (LstTenderGroup);
  end;

  if not Assigned (LstTenderUnit) then begin
    AddTenderUnits;

    DmdFpnTenderGroup.BuildListTenderUnit (LstTenderUnit);
    for CntItem := Pred (LstTenderUnit.Count) downto 0 do begin
      if LstTenderUnit.TenderUnit [CntItem].IdtTenderGroup = 1 then begin
        ValUnit := LstTenderUnit.TenderUnit[CntItem].ValUnit;
        if (ValUnit < FNumAmount) then begin
          LstTenderUnit.TenderUnit[CntItem].Free;
          LstTenderUnit.Delete (CntItem);
        end;
      end
      else if LstTenderUnit.TenderUnit [CntItem].IdtTenderGroup = 99 then
        LstTenderUnit.TenderUnit [CntItem].IdtTenderGroup := 1;
    end;
  end;
end;   // of TFrmTndBankOrderCA.CreateTenderGroupLists

//=============================================================================
// TFrmTndBankOrderCA.AddTenderUnits : Create and load tenderunits
//=============================================================================

procedure TFrmTndBankOrderCA.AddTenderUnits;
var
  NumCounter      : Integer;    // Counter to loop Tenderrolls
begin  // of TFrmTndBankOrderCA.AddTenderUnits
  LstTenderUnit := TLstTenderUnit.Create;
  DmdFpnUtils.QueryInfo(
    #10'SELECT IdtApplicParam, ValParam, TxtParam' +
    #10'FROM ApplicParam' +
    #10'WHERE IdtApplicParam LIKE ' + AnsiQuotedStr('TenderCashRoll%', '''') +
    #10'AND NOT (IdtApplicParam = ' +
                           AnsiQuotedStr('TenderCashRollAmount', '''') + ')' +
    #10'ORDER BY IdtApplicParam ASC');

  for NumCounter := 1 to DmdFpnUtils.QryInfo.RecordCount do begin
    LstTenderUnit.AddTenderUnit (99,
                        DmdFpnUtils.QryInfo.FieldByName('ValParam').AsCurrency,
                        DmdFpnUtils.QryInfo.FieldByName('TxtParam').AsString);
    DmdFpnUtils.QryInfo.Next;
  end;

  DmdFpnUtils.ClearQryInfo;
  DmdFpnUtils.QueryInfo(
    #10'SELECT IdtApplicParam, ValParam, TxtParam' +
    #10'FROM ApplicParam' +
    #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('TenderCashRollAmount', ''''));
  FNumAmount := DmdFpnUtils.QryInfo.FieldByName('ValParam').AsCurrency;
  DmdFpnUtils.CloseInfo;
end;   // of TFrmTndBankOrderCA.AddTenderUnits

//=============================================================================
// TFrmTndBankOrderCA.CreateTabShtTenderUnits : creates a TabSheet and the
// panels for a TenderGroup with TenderUnits.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to create the Units for.
//=============================================================================

procedure TFrmTndBankOrderCA.CreateTabShtTenderUnits
                                             (ObjTenderGroup : TObjTenderGroup);
var
  CntUnit          : Integer;          // Counter TenderUnit
  ObjTenderUnit    : TObjTenderUnit;   // Current TenderUnit
  TabShtNew        : TTabShtCashUnit;  // New TabSheet
begin  // of TFrmTndBankOrderCA.CreateTabShtTenderUnits
  TabShtNew := TTabShtCashUnit.CreateForTender (PgeCtlCount, ObjTenderGroup);
  TabShtNew.CtlFocusOnExit := BtnAccept;
  TabShtNew.CtlCancel      := BtnCancel;

  CntUnit :=  - 1;
  repeat
    ObjTenderUnit := LstTenderUnit.NextTenderUnit
                       (ObjTenderGroup.IdtTenderGroup, CntUnit);
    if Assigned (ObjTenderUnit) then
      TabShtNew.CreateCountItem (ObjTenderUnit);
  until not Assigned (ObjTenderUnit);
end;   // of TFrmTndBankOrderCA.CreateTabShtTenderUnits

//=============================================================================
// TFrmTndBankOrderCA.CreateTenderGroupTabShts : adjusts the form depending on
// the TenderGroups in LstTenderGroup, with the units for each TenderGroup in
// LstTenderUnit.
//                                  -----
// Restrictions :
// - assumes LstTenderGroup if filled with the TenderGroups, ordered by at
//   least NumOrder.
// - to avoid flickering, PgeCtlCount is hidden during creation of components.
//=============================================================================

procedure TFrmTndBankOrderCA.CreateTenderGroupTabShts;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup in LstTenderGroup
begin  // of TFrmTndBankOrderCA.CreateTenderGroupTabShts
  PgeCtlCount.Visible := False;
  try
    for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
      if AllowTenderGroup (LstTenderGroup.TenderGroup[CntTenderGroup]) then begin
        CreateTabShtTenderUnits (LstTenderGroup.TenderGroup[CntTenderGroup]);
        RetrievePayOrgan
             (LstTenderGroup.TenderGroup[CntTenderGroup].CodTypePayOrgan);
      end;
    end;
  finally
    BtnAccept.Enabled := False;
    PgeCtlCount.Visible := True;
    if CbxSupplier.Enabled then
      CbxSupplier.SetFocus
    else
      TTabShtTender(PgeCtlCount.Pages[0]).FocusFirst;
  end;
end;   // of TFrmTndBankOrderCA.CreateTenderGroupTabShts

//=============================================================================
// TFrmTndBankOrderCA.CreateAcceptationTabSht : creates a single tabsheet for
// holding the tenderunits of a selected order
//=============================================================================

procedure TFrmTndBankOrderCA.CreateAcceptationTabSht;
var
  CntUnit          : Integer;          // Counter TenderUnit
  ObjTenderUnit    : TObjTenderUnit;   // Current TenderUnit
  ObjTenderGroup   : TObjTenderGroup;  // Current Tendergroup
  TabShtNew        : TTabShtAcceptation;  // New TabSheet
begin  // of TFrmTndBankOrderCA.CreateAcceptationTabSht
  PgeCtlCount.Visible := False;
  try
    ObjTenderGroup := LstTenderGroup.FindIdtTenderGroup (1); (** PDW  **)
    TabShtNew := TTabShtAcceptation.CreateForTender (PgeCtlCount, ObjTenderGroup);
    TabShtNew.CtlFocusOnExit := BtnAccept;
    TabShtNew.CtlCancel      := BtnCancel;

    CntUnit :=  - 1;
    repeat
      ObjTenderUnit := LstTenderUnit.NextTenderUnit
                         (ObjTenderGroup.IdtTenderGroup, CntUnit);
      if Assigned (ObjTenderUnit) then
        TabShtNew.CreateCountItem (ObjTenderUnit);
    until not Assigned (ObjTenderUnit);
    RetrieveOrders;
  finally
    BtnAccept.Enabled := False;
    PgeCtlCount.Visible := True;
  end;
end;   // of TFrmTndBankOrderCA.CreateAcceptationTabSht


//=============================================================================
// TFrmTndBankOrderCA.OnFirstIdle : installed as OnIdle Event in OnActivate, to
// execute some things as soon as the application becomes idle.
//=============================================================================

procedure TFrmTndBankOrderCA.OnFirstIdle (    Sender : TObject;
                                          var Done   : Boolean);
begin  // of TFrmTndBankOrderCA.OnFirstIdle
  Application.OnIdle := SavAppOnIdle;
  if IdtOperReg = '' then begin
    if SvcTaskMgr.LaunchTask ('LogOn') then begin
      CreateTenderGroupLists;
      case CodRunFunc of
      CtCodFuncOrder  : CreateTenderGroupTabShts;
      CtCodFuncAccept : CreateAcceptationtabSht;
      CtCodFuncOrderParam  : CreateTenderGroupTabShts;
      end;
    end
    else
      ModalResult := mrCancel;
  end;
end;   // of TFrmTndBankOrderCA.OnFirstIdle

//=============================================================================
// TFrmTndBankOrderCA.AllowTenderGroup : checks if a TenderGroup is allowed for
// the passed function.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to check for.
//                                  -----
// FUNCRES : True if TenderGroup is allowed;
//           False if TenderGroup is not allowed.
//=============================================================================

function TFrmTndBankOrderCA.AllowTenderGroup
                            (ObjTenderGroup : TObjTenderGroup) : Boolean;
begin  // of TFrmTndBankOrderCA.AllowTenderGroup
  Result := ObjTenderGroup.IdtTenderGroup = 1; (** PDW  **)
end;   // of TFrmTndBankOrderCA.AllowTenderGroup

//=============================================================================
// TFrmTndBankOrderCA.PrepareSafeTransdetail : Fills the Object safetransdetail
// ready for committing to database
//                                  -----
// INPUT   : ObjSafeTrans   = object SafeTransaction
//           PnlCash        = Panel containing all detail information of
//                            the TenderUnit.
//           ObjTendergroup = Object Tendergroup
//=============================================================================

procedure TFrmTndBankOrderCA.PrepareSafeTransdetail
                                        (ObjSafeTrans   : TObjSafeTransaction;
                                         PnlCash        : TPnlCashUnit;
                                         ObjTendergroup : TObjTendergroup);
var
  ObjTransDetail   : TObjTransdetail;     // Object Transdetail
  ObjTenderUnit    : TObjTenderUnit;      // Object TenderUnit
begin // of TFrmTndBankOrderCA.PrepareSafeTransdetail
  // save the needed objects in a more readable variable
  ObjTenderUnit := PnlCash.ObjTenderUnit;
  ObjTransDetail := LstSafeTransaction.LstTransDetail.AddTransDetail
                      (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq,
                       0, ObjTendergroup.IdtTenderGroup, CtCodDbsNew);
  // add additional information to SafeTransdetail
  with ObjTransDetail do begin
    IdtTenderGroup  := ObjTendergroup.IdtTenderGroup;
    FlgTransfer     := False;
    TxtDescr        := ObjTenderunit.TxtDescr;
    QtyUnit         := PnlCash.SvcLFQtyUnit.AsInteger;
    ValUnit         := PnlCash.SvcLFValUnit.AsFloat;
    IdtCurrency     := ObjTenderGroup.IdtCurrency;
    ValExchange     := ObjTenderGroup.ValExchange;
    FlgExchMultiply := ObjTenderGroup.FlgExchMultiply;
  end;
end;  // of TFrmTndBankOrderCA.PrepareSafeTransdetail

//=============================================================================
// TFrmTndBankOrderCA.BtnAcceptClick
//=============================================================================

procedure TFrmTndBankOrderCA.BtnAcceptClick (Sender: TObject);

begin // of TFrmTndBankOrderCA.BtnAcceptClick
  case CodRunFunc of
    CtCodFuncOrder  :
      begin
        SaveAndPrintMoneyOrder;
      end;
    CtCodFuncAccept :
      begin
        SaveAndPrintAcceptedOrder;
      end;
    CtCodFuncOrderParam  :
      begin
        SaveAndPrintMoneyOrderParam;
      end;
  end;
  Application.Terminate;
end;  // of TFrmTndBankOrderCA.BtnAcceptClick

//=============================================================================
// TFrmTndBankOrderCA.SaveAndPrintMoneyOrder : Saves and prints money order
// (function /FOrder
//=============================================================================

procedure TFrmTndBankOrderCA.SaveAndPrintMoneyOrder;
var
  ObjSafeTrans     : TObjSafeTransaction; // Object SafeTransaction
  CntPage          : Integer;             // counter for pages in pagecontrol
  CntPnl           : Integer;             // counter for panels on tabsheet
  SbxCurrent       : TScrollBox;          // current scrollbox component
  IntSelectedItem  : Integer;             // selected IdtAddrPayOrg from cbx
  IntPayOrgan      : Integer;             // link with PayOrgan
  StrLstPayOrgan   : TStringList;         // stringlist for IdtPayOrgan and
                                          // IdtAddrPayOrg
begin // of TFrmTndBankOrderCA.SaveAndPrintMoneyOrder

  // check the supplier if it is filled in
  IntSelectedItem := CbxSupplier.ItemIndex;
  // No choice is made from the suppliers combobox
  if (IntSelectedItem = 0) and FlgPayOrganFound then
    if MessageDlg (CtTxtEmNoSupplier + #13 + #10 +
                  CtTxtWantToContinue,
                  mtWarning, [mbYes, mbNo], 0) = mrNo then
      Exit;
  IdtAddrPayOrg := 0;
  IntPayOrgan := 0;
  if IntSelectedItem >= 0 then begin
    StrLstPayOrgan := TStringList(CbxSupplier.Items.Objects[IntSelectedItem]);
    if Assigned (StrLstPayOrgan) then begin
      IntPayOrgan := StrToInt (StrLstPayOrgan.Strings[0]);
      IdtAddrPayOrg := StrToInt (StrLstPayOrgan.Strings[1]);
    end;
  end;
  // new Ordernumber
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransactionCA.Create;
  IdtOrderNumber := DmdFpnUtils.GetNextCounter
                      ('SafeTransaction', 'IdtOrderNumber');

  // New Safetransaction
  ObjSafeTrans := LstSafeTransaction.AddSafeTransaction
                    (0, 0, CtCodSttOrderMoney, CtCodDbsNew);
  with ObjSafeTrans do begin
    //IdtOperator     := Self.IdtOperReg;
    IdtOperReg      := Self.IdtOperReg;
    NumReport       := 0;
    DatReg          := Now;
    IdtPayOrgan     := '';
    if IntPayOrgan <> 0 then
      IdtPayOrgan := IntToStr (IntPayOrgan);
    IdtCurrency     := DmdFpnUtils.IdtCurrencyMain;
    ValExchange     := DmdFpnUtils.ValExchangeCurrencyMain;
    FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
    StrLstExplanation.Add (Format (CtTxtFmtOrderNr,[IdtOrderNumber]));
    StrLstExplanation.Add (Format (CtTxtFmtPayOrgan,[IdtAddrPayOrg]));
  end;

  // New Safetransdetail
  if PgeCtlCount.PageCount = 0 then
    exit;

  //run over all tabsheets (normally there should be only one)
  for CntPage := 0 to Pred (PgeCtlCount.PageCount) do begin
    // store current scrollbox on tabsheet in a more readable variable
    SbxCurrent := TTabShtTender(PgeCtlCount.Pages[CntPage]).SbxCount;
    // run over all controls in the scrollbox
    for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
     if SbxCurrent.Controls[CntPnl] is TPnlCashUnit then begin
       PrepareSafeTransdetail
                   (ObjSafeTrans,
                    TPnlCashUnit(SbxCurrent.Controls[CntPnl]),
                    TTabShtTender(PgeCtlCount.Pages[CntPage]).ObjTenderGroup);
     end; // if SbxCurrent.Controls[CntPnl] is TPnlCashUnit
    end; // for CntPnl
  end; // for CntPage
  LstTransDet := LstSafeTransaction.LstTransDetail;
  PrintReportMoneyOrder;
  CommitMoneyOrderToDatabase;
end;  // of TFrmTndBankOrderCA.SaveAndPrintMoneyOrder

//=============================================================================
// TFrmTndBankOrderCA.SaveAndPrintAcceptedOrder : Saves and prints acceptation
// of money order (function /FAccept)
//=============================================================================

procedure TFrmTndBankOrderCA.SaveAndPrintAcceptedOrder;
begin // of TFrmTndBankOrderCA.SaveAndPrintAcceptedOrder
  CommitAcceptedOrderToDatabase;
  PrintReportAcceptedOrder;
end;  // of TFrmTndBankOrderCA.SaveAndPrintOrder

//=============================================================================
// TFrmTndBankOrderCA.SaveAndPrintMoneyOrderParam
// Saves and prints money order using parameters from PMntOrderChangeMoney.exe
// (function /FOrderParam)
//=============================================================================

procedure TFrmTndBankOrderCA.SaveAndPrintMoneyOrderParam;
var
  ObjSafeTrans     : TObjSafeTransaction; // Object SafeTransaction
  CntPage          : Integer;             // counter for pages in pagecontrol
  CntPnl           : Integer;             // counter for panels on tabsheet
  SbxCurrent       : TScrollBox;          // current scrollbox component
  IntSelectedItem  : Integer;             // selected IdtAddrPayOrg from cbx
  IntPayOrgan      : Integer;             // link with PayOrgan
  StrLstPayOrgan   : TStringList;         // stringlist for IdtPayOrgan and
                                          // IdtAddrPayOrg
begin // of TFrmTndBankOrderCA.SaveAndPrintMoneyOrderParam

  // check the supplier if it is filled in
  IntSelectedItem := CbxSupplier.ItemIndex;
  // No choice is made from the suppliers combobox
  if (IntSelectedItem = 0) and FlgPayOrganFound then
    if MessageDlg (CtTxtEmNoSupplier + #13 + #10 +
                  CtTxtWantToContinue,
                  mtWarning, [mbYes, mbNo], 0) = mrNo then
      Exit;
  IdtAddrPayOrg := 0;
  IntPayOrgan := 0;
  if IntSelectedItem >= 0 then begin
    StrLstPayOrgan := TStringList(CbxSupplier.Items.Objects[IntSelectedItem]);
    if Assigned (StrLstPayOrgan) then begin
      IntPayOrgan := StrToInt (StrLstPayOrgan.Strings[0]);
      IdtAddrPayOrg := StrToInt (StrLstPayOrgan.Strings[1]);
    end;
  end;
  // new Ordernumber
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransactionCA.Create;
  IdtOrderNumber := DmdFpnUtils.GetNextCounter
                      ('SafeTransaction', 'IdtOrderNumber');

  // New Safetransaction
  ObjSafeTrans := LstSafeTransaction.AddSafeTransaction
                    (0, 0, CtCodSttOrderMoney, CtCodDbsNew);
  with ObjSafeTrans do begin
    //IdtOperator     := Self.IdtOperReg;
    IdtOperReg      := Self.IdtOperReg;
    NumReport       := 0;
    DatReg          := Now;
    IdtPayOrgan     := '';
    if IntPayOrgan <> 0 then
      IdtPayOrgan := IntToStr (IntPayOrgan);
    IdtCurrency     := DmdFpnUtils.IdtCurrencyMain;
    ValExchange     := DmdFpnUtils.ValExchangeCurrencyMain;
    FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
    StrLstExplanation.Add (Format (CtTxtFmtOrderNr,[IdtOrderNumber]));
    StrLstExplanation.Add (Format (CtTxtFmtPayOrgan,[IdtAddrPayOrg]));
  end;

  // New Safetransdetail
  if PgeCtlCount.PageCount = 0 then
    exit;

  //run over all tabsheets (normally there should be only one)
  for CntPage := 0 to Pred (PgeCtlCount.PageCount) do begin
    // store current scrollbox on tabsheet in a more readable variable
    SbxCurrent := TTabShtTender(PgeCtlCount.Pages[CntPage]).SbxCount;
    // run over all controls in the scrollbox
    for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
     if SbxCurrent.Controls[CntPnl] is TPnlCashUnit then begin
       PrepareSafeTransdetail
                   (ObjSafeTrans,
                    TPnlCashUnit(SbxCurrent.Controls[CntPnl]),
                    TTabShtTender(PgeCtlCount.Pages[CntPage]).ObjTenderGroup);
     end; // if SbxCurrent.Controls[CntPnl] is TPnlCashUnit
    end; // for CntPnl
  end; // for CntPage
  LstTransDet := LstSafeTransaction.LstTransDetail;
  PrintReportMoneyOrderParam;
  CommitMoneyOrderToDatabase;
end;  // of TFrmTndBankOrderCA.SaveAndPrintMoneyOrderParam

//=============================================================================
// TFrmTndBankOrderCA.ClearPanels : sets all quantities in the panels on the
// tabsheets to zero.
//=============================================================================

procedure TFrmTndBankOrderCA.ClearPanels;
var
  CntPnl           : Integer;          // counter for panels
  SbxCurrent       : TScrollBox;       // current scrollbox
begin // of TFrmTndBankOrderCA.ClearPanels
  PgeCtlCount.Visible := False;
  SbxCurrent := TTabShtTender(PgeCtlCount.Pages[0]).SbxCount;
  for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
    if SbxCurrent.Controls[CntPnl] is TPnlCashUnit then begin
      TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFQtyUnit.AsInteger := 0;
      // trigger change of quantity field (it is not automatically trigger'd
      // when the field is casted.
      TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFChange (
               TPnlCashUnit(SbxCurrent.Controls[CntPnl]));
    end; // if SbxCurrent.Controls[CntPnl] is TPnlCashUnit
  end; // for CntPnl
  SbxCurrent.VertScrollBar.Position := 0;
  PgeCtlCount.Visible := True;
end;  // of TFrmTndBankOrderCA.ClearPanels

//=============================================================================
// TFrmTndBankOrderCA.CommitMoneyOrderToDatabase : commit money order to
// database.
// The LstSafetransaction and LstTransdetail (global variables) will be saved
//=============================================================================

procedure TFrmTndBankOrderCA.CommitMoneyOrderToDatabase;
begin // of TFrmTndBankOrderCA.CommitMoneyOrderToDatabase
  if not Assigned (DmdFpnSafeTransactionCA) then
    DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
  // save LstSafeTransaction + LstTransDetail to database
  DmdFpnSafeTransactionCA.InsertLstSafeTransaction (LstSafeTransaction);
end;  // of TFrmTndBankOrderCA.CommitMoneyOrderToDatabase

//=============================================================================
// TFrmTndBankOrderCA.CommitAcceptedOrderToDatabase : commit accepted order to
// database.
// The following actions will be executed in one single transaction.
// The field FlgTransfer will be set to true for the safetransaction of the
// money order.  A new SafeTransaction will be added (read: new numseq) if a
// running safetransaction exists for CtIdtSafe (=300).  If no runnning found,
// then create a new one.  To delete a money order, set all values to zero.
// In this case no new SafeTransaction will be added to the running one.
//=============================================================================

procedure TFrmTndBankOrderCA.CommitAcceptedOrderToDatabase;
var
  ObjSafeTrans      : TObjSafeTransaction; // SafeTransaction linked to the
                                           // Money Order
  IdtLast           : Integer;             // Last running SafeTransaction
  NumSeq            : Integer;             // New NumSeq
  NewObjSafeTrans   : TObjSafeTransaction; // Newly created SafeTransaction
  ValIndex          : Integer;             // index in LstSafeTransaction
  ValIndexDetail    : Integer;             // Index of LstTransdetail
  ObjTransDetail    : TObjTransDetail;     // Object SafeTransDetail
  NewObjTransDetail : TObjTransDetail;     // New Object SafeTransDetail
  FlgTransStarted   : Boolean;             // Flag database transaction started
  SbxCurrent        : TScrollBox;          // current scrollbox
  CntPnl            : Integer;             // counter for tenderunit panels
  // Flag to see if all values for the order are set to zero by the user.
  // This is the only way for deleting an existing money order
  FlgDelSafeTrans   : Boolean;
begin // of TFrmTndBankOrderCA.CommitAcceptedOrderToDatabase
  ObjSafeTrans := TTabShtAcceptation(PgeCtlCount.Pages[0]).ObjSafeTrans;

  // Locate the current SafeTransaction in LstSafeTransaction
  ValIndex := LstSafeTransaction.IndexOfIdtAndSeq
               (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq);
  if ValIndex = -1 then
    DmdFpnSafeTransactionCA.BuildListSafeTransactionAndDetail
                      (LstSafeTransaction, ObjSafeTrans.IdtSafeTransaction);
  LstSafeTransaction.SafeTransaction[ValIndex].CodDBState := CtCodDbsModify;

  // Loop the SafeTransdetail objects and set FlgTransfer to True
  ValIndexDetail := -1;
  ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail (
    ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq, ValIndexDetail);
  while Assigned (ObjTransDetail) do begin
    ObjTransDetail.FlgTransfer := True;
    ObjTransDetail.CodDBState := CtCodDbsModify;
    ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail
      (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq, ValIndexDetail);
  end;

  FlgTransStarted := not DmdFpnSafeTransaction.DbsUpdate.InTransaction;
  if FlgTransStarted then
    DmdFpnSafeTransaction.DbsUpdate.StartTransaction;
  try

    // update LstSafeTransaction/Detail to database
    DmdFpnSafeTransactionCA.UpdateLstSafeTransaction
        (LstSafeTransaction,
         [], ['FlgTransfer']);

    // fetch running transaction
    IdtLast := DmdFpnSafeTransactionCA.
               RetrieveRunningSafeTransCashdesk (CtIdtSafe);
    // if no running SafeTransaction found
    if IdtLast = 0 then
      IdtLast := DmdFpnUtils.GetNextCounter
                (CtTxtACSafeTransactionIdtAC, CtTxtACSafeTransactionField);
    NumSeq := DmdFpnSafeTransactionCA.RetrieveMaxNumSeq (IdtLast) + 1;
    NewObjSafeTrans := LstSafeTransaction.AddSafeTransaction
                       (IdtLast, NumSeq, CtCodSttPayInTender, CtCodDbsNew);
    LstSafeTransaction.CopySafeTransaction (ObjSafeTrans, NewObjSafeTrans);
    NewObjSafeTrans.CodReason := CtCodStrPayIn;
    NewObjSafeTrans.IdtCheckout := CtIdtSafe;
    NewObjSafeTrans.IdtOperator := '';
    NewObjSafeTrans.IdtOperReg  := IdtOperReg;
    TTabShtAcceptation(PgeCtlCount.Pages[0]).NewObjSafeTrans := NewObjSafeTrans;
    // store the acceptation of the money order into LstSafeTransdetail
    SbxCurrent := TTabShtTender(PgeCtlCount.Pages[0]).SbxCount;

    // run over all controls in the scrollbox
    FlgDelSafeTrans := True;
    for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
      if SbxCurrent.Controls[CntPnl] is TPnlCashUnit then begin
        if TPnlCashUnit(SbxCurrent.Controls[CntPnl]).
           SvcLFQtyUnit.AsInteger <> 0 then begin
          FlgDelSafeTrans := False;
          NewObjTransDetail := LstSafetransaction.AddTransDetail (
                               NewObjSafeTrans.IdtSafeTransaction,
                               NewObjSafeTrans.NumSeq,
                               0,
                               TTabShtTender(PgeCtlCount.Pages[0]).
                                  ObjTenderGroup.IdtTenderGroup,
                               CtCodDbsNew);
          NewObjTransDetail.TxtDescr :=
            TPnlCashUnit(SbxCurrent.Controls[CntPnl]).ObjTenderUnit.TxtDescr;
          NewObjTransDetail.QtyUnit :=
            TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFQtyUnit.AsInteger;
          NewObjTransDetail.ValUnit :=
            TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFValUnit.AsFloat;
          NewObjTransDetail.IdtCurrency :=
            TTabShtTender(PgeCtlCount.Pages[0]).ObjTenderGroup.IdtCurrency;
          NewObjTransDetail.ValExchange :=
            TTabShtTender(PgeCtlCount.Pages[0]).ObjTenderGroup.ValExchange;
          NewObjTransDetail.FlgExchMultiply :=
            TTabShtTender(PgeCtlCount.Pages[0]).ObjTenderGroup.FlgExchMultiply;
        end;
      end; // if SbxCurrent.Controls[CntPnl] is TPnlCashUnit
    end; // for CntPnl
    if not FlgDelSafeTrans then
      DmdFpnSafeTransactionCA.InsertLstSafeTransaction (LstSafeTransaction);
    if FlgTransStarted then
      DmdFpnSafeTransaction.DbsUpdate.Commit;

    // build LstTransDet to pass on to the report acceptation money order
    if not Assigned (LstTransDet) then
      LstTransDet := TLstTransDetail.Create;
    ValIndexDetail := -1;
    ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail (
           NewObjSafeTrans.IdtSafeTransaction, NewObjSafeTrans.NumSeq,
           ValIndexDetail);
    while Assigned (ObjTransDetail) do begin
      NewObjTransDetail :=
        LstTransDet.AddTransDetail (ObjTransDetail.IdtSafeTransaction,
                                    ObjTransDetail.NumSeq,
                                    ObjTransDetail.NumSeqDetail,
                                    ObjTransDetail.IdtTenderGroup,
                                    CtCodDbsExist);
      NewObjTransDetail.FlgTransfer := ObjTransDetail.FlgTransfer;
      NewObjTransDetail.TxtDescr := ObjTransDetail.TxtDescr;
      NewObjTransDetail.QtyUnit := ObjTransDetail.QtyUnit;
      NewObjTransDetail.ValUnit := ObjTransDetail.ValUnit;
      NewObjTransDetail.IdtCurrency := ObjTransDetail.IdtCurrency;
      NewObjTransDetail.ValExchange := ObjTransDetail.valExchange;
      NewObjTransDetail.FlgExchMultiply := ObjTransDetail.FlgExchMultiply;
      ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail (
             NewObjSafeTrans.IdtSafeTransaction, NewObjSafeTrans.NumSeq,
             ValIndexDetail);
    end;

  except
    if FlgTransStarted then
      DmdFpnSafeTransaction.DbsUpdate.RollBack;
    raise;
  end;
end;  // of TFrmTndBankOrderCA.CommitAcceptedOrderToDatabase

//=============================================================================
// TFrmTndBankOrderCA.PrintReport : Launches the task to print the money order
//=============================================================================

procedure TFrmTndBankOrderCA.PrintReportMoneyOrder;
begin // of TFrmTndBankOrderCA.PrintReportMoneyOrder
  SvcTaskMgr.LaunchTask ('ReportMoneyOrder');
end;  // of TFrmTndBankOrderCA.PrintReportMoneyOrder

//=============================================================================
// TFrmTndBankOrderCA.PrintReportAcceptedOrder : Launches the task to print the
// accepted money order
//=============================================================================

procedure TFrmTndBankOrderCA.PrintReportAcceptedOrder;
begin // of TFrmTndBankOrderCA.PrintReportAcceptedOrder
  SvcTaskMgr.LaunchTask ('ReportAcceptedOrder');
end;  // of TFrmTndBankOrderCA.PrintReportAcceptedOrder

//=============================================================================
// TFrmTndBankOrderCA.PrintReportMoneyOrderParam : Launches the task to print
// the money order
//=============================================================================

procedure TFrmTndBankOrderCA.PrintReportMoneyOrderParam;
begin // of TFrmTndBankOrderCA.PrintReportMoneyOrderParam
  SvcTaskMgr.LaunchTask ('ReportMoneyOrderParam');
end;  // of TFrmTndBankOrderCA.PrintReportMoneyOrderParam

//=============================================================================
// TFrmTndBankOrderCA.RetrievePayOrgan : retrieve the suppliers from table
// PayOrgan to leave the choice to the user.  Retrieved suppliers are put into
// a combobox for selection.  If no supplier is found, the combobox shows
// 'No Pay Organization found'
//                                  -----
// INPUT   : CodTypePayOrgan = CodeType of Pay Organization
//=============================================================================

procedure TFrmTndBankOrderCA.RetrievePayOrgan (CodTypePayOrgan : Integer);
var
  TxtSQL           : string;           // sql string
  CntItem          : Integer;          // number of items in Combobox
  StrLstPayOrgan   : TStringlist;      // stringlist with data from PayOrgan
begin // of TFrmTndBankOrderCA.RetrievePayOrgan
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Application);
  CbxSupplier.Top := ((PnlTop.Height - CbxSupplier.Height) div 2) + 1;
  LblSupplier.Top := ((PnlTop.Height - LblSupplier.Height) div 2) + 1;  
  CbxSupplier.Clear;
  CbxSupplier.Visible := False;
  CbxSupplier.Enabled := False;
  CntItem := 0;
  FlgPayOrganFound := False;
  StrLstPayOrgan := TStringList.Create;
  try
    TxtSQL := 'SELECT TxtPublName, IdtPayOrgan, IdtAddrPayOrg FROM PayOrgan';
    TxtSQL := TxtSQL + ' WHERE CodType = ' + IntToStr (CodTypePayOrgan);
    TxtSQL := TxtSQL + ' ORDER BY TxtPublName ASC';
    DmdFpnUtils.QueryInfo (TxtSQL);
    DmdFpnUtils.QryInfo.FindFirst;
    // Initialize the first two strings with zero
    StrLstPayOrgan.Add ('0');
    StrLstPayOrgan.Add ('0');
    if DmdFpnUtils.QryInfo.Eof then
      CbxSupplier.ItemIndex :=
                      CbxSupplier.Items.AddObject (CtTxtNoSuppliers,
                                                   TObject(StrLstPayOrgan));
    while not DmdFpnUtils.QryInfo.Eof do begin
      if CntItem = 0 then
        CbxSupplier.ItemIndex :=
          CbxSupplier.Items.AddObject (CtTxtManualSupplier,
                                       TObject(StrLstPayOrgan));
      StrLstPayOrgan := TStringList.Create;
      StrLstPayOrgan.Add (
               DmdFpnUtils.QryInfo.FieldByName ('IdtPayOrgan').AsString);
      StrLstPayOrgan.Add (
               DmdFpnUtils.QryInfo.FieldByName ('IdtAddrPayOrg').AsString);
      CbxSupplier.Items.AddObject (
               DmdFpnUtils.QryInfo.FieldByName ('TxtPublName').AsString,
               TObject(StrLstPayOrgan));

      Inc (CntItem);
      FlgPayOrganFound := True;

      DmdFpnUtils.QryInfo.Next;
    end;
    if CntItem > 1 then
      CbxSupplier.Enabled := True;
  finally
    DmdFpnUtils.CloseInfo;
    CbxSupplier.Visible := True;
    LblSupplier.Visible := True;
    end;
  if CodRunFunc = CtCodFuncOrderParam then begin
    LblSupplier.Visible := false;
    CbxSupplier.Visible := false;
    LblSupplier.Enabled := false;
    CbxSupplier.Enabled := false;
  end;
end;  // of TFrmTndBankOrderCA.RetrievePayOrgan

//=============================================================================
// TFrmTndBankOrderCA.RetrieveOrders : retrieve the orders from table
// SafeTransaction to leave the choice to the user for acceptation.
// Retrieved orders are put into a combobox for selection.
// If no supplier is found, the combobox shows 'No orders found'
//=============================================================================

procedure TFrmTndBankOrderCA.RetrieveOrders;
var
  TxtSQL             : string;              // sql string
  CntItem            : Integer;             // number of items in Combobox
  ObjSafeTransaction : TObjSafeTransaction; // Object SafeTransaction
  IdtSafeTransaction : Integer;             // Identifier SafeTransaction
  IdxSafeTrans       : Integer;             // Index of IdtSafeTransaction in
                                            // LstSafeTransaction
  TxtOrderNr         : string;              // ordernumber
  TxtKeyword         : string;
  TxtDummy           : string;
  NumSeq             : Integer;             // Sequence
  FlgOrdersFound     : Boolean;             // Flag are there any orders
                                            // to accept ?
begin // of TFrmTndBankOrderCA.RetrieveOrders
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Application);
  if not Assigned (DmdFpnSafeTransactionCA) then
    DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
  CbxOrder.Clear;
  CbxOrder.Top := ((PnlTop.Height - CbxOrder.Height) div 2) + 1;
  LblOrders.Top := ((PnlTop.Height - LblOrders.Height) div 2) + 1;
  CbxOrder.Visible := False;
  CbxOrder.Enabled := False;
  CntItem := 0;
  FlgOrdersFound := False;
  try
    SplitString (CtTxtFmtOrderNr, '=', TxtKeyword, TxtDummy);
    TxtSQL := 'SELECT * FROM SafeTransaction' +
              #10' WHERE CodType = ' + IntToStr (CtCodSttOrderMoney) +
              #10' AND not exists' +
              #10' (SELECT * from SafeTransdetail' +
              #10' WHERE SafeTransaction.IdtSafeTransaction = SafeTransdetail.IdtSafeTransaction' +
              #10' AND SafeTransaction.NumSeq = SafeTransDetail.NumSeq' +
              #10' AND SafeTransDetail.FlgTransfer <> 0)' +
              #10' AND SafeTransaction.TxtExplanation LIKE' +
              #10' ' + AnsiQuotedStr ('%' + TxtKeyword + '%', '''') +
              #10' ORDER BY SafeTransaction.DatReg';

    DmdFpnUtils.QueryInfo (TxtSQL);
    DmdFpnUtils.QryInfo.FindFirst;
    if DmdFpnUtils.QryInfo.Eof then
      CbxOrder.Items.Add (CtTxtNoOrders)
    else begin
      if not Assigned (LstSafeTransaction) then
        LstSafeTransaction := TLstSafeTransactionCA.Create;
      while not DmdFpnUtils.QryInfo.Eof do begin
        IdtSafeTransaction := DmdFpnUtils.QryInfo.FieldByName
                                   ('IdtSafeTransaction').AsInteger;
        NumSeq := DmdFpnUtils.QryInfo.FieldByName('NumSeq').AsInteger;
        IdxSafeTrans := LstSafeTransaction.IndexOfIdtAndSeq (IdtSafeTransaction,
                                                             NumSeq);
        if IdxSafeTrans = -1 then begin
          DmdFpnSafeTransaction.BuildListSafeTransactionAndDetail
            (LstSafeTransaction, IdtSafeTransaction);
          IdxSafeTrans := LstSafeTransaction.IndexOfIdtAndSeq
                            (IdtSafeTransaction, NumSeq);
        end;
        ObjSafeTransaction := LstSafeTransaction.SafeTransaction[IdxSafeTrans];
        SplitString (CtTxtFmtOrderNr, '=', TxtKeyword, TxtDummy);
        TxtOrderNr := ObjSafeTransaction.StrLstExplanation.Values[TxtKeyword];
        CbxOrder.Items.AddObject (TxtOrderNr, TObject(ObjSafeTransaction));
        Inc (CntItem);

        DmdFpnUtils.QryInfo.Next;
      end;
      if CntItem > 0 then begin
        CbxOrder.Enabled := True;
        FlgOrdersFound := True;
      end;
    end;

  finally
    DmdFpnUtils.CloseInfo;
    if FlgOrdersFound then begin
      CbxOrder.Visible := True;
      LblOrders.Visible := True;
      if CbxOrder.Enabled then
        CbxOrder.SetFocus;
    end
    else begin
      MessageDlg (CtTxtEmNoOrdersAvail, mtInformation, [mbOK], 0);
      ModalResult := mrOk;
    end;
  end;
end;  // of TFrmTndBankOrderCA.RetrieveOrders

//=============================================================================
// TFrmTndBankOrderCA.CbxOrderExit
//=============================================================================

procedure TFrmTndBankOrderCA.CbxOrderExit(Sender: TObject);
var
  IntOrder         : Integer;          // Integer value of choosen order
  ObjSafeTrans     : TObjSafeTransaction; // Object SafeTransaction
  IntSelectedItem  : Integer;          // selected item from CbxOrder
  CntItem          : Integer;          // counter items in CbxOrder
  TxtKeyword       : string;           // contains fixed word in expl.
  TxtDummy         : string;           // dummy variable
begin // of TFrmTndBankOrderCA.CbxOrderExit
  // Refuse to leave CbxOrder as long as no order is selected (and
  // if not Cancel).
  ObjSafeTrans := Nil;
  if ActiveControl = BtnCancel then
    Exit
  else if CbxOrder.Text = '' then begin
    CbxOrder.SetFocus;
    Exit;
  end;
  try
    IntOrder := StrToInt (CbxOrder.Text);
  except
    CbxOrder.ItemIndex := -1;
    CbxOrder.SetFocus;
    raise exception.Create (CtTxtEmInvalidOrderNr);
  end;
  // check existence of ordernumber
  IntSelectedItem := CbxOrder.ItemIndex;
  if IntSelectedItem <> -1 then begin
    ObjSafeTrans := TObjSafeTransaction(CbxOrder.Items.Objects[IntSelectedItem]);
  end
  else begin
    // locate ordernumber in combobox to find linked safetransaction-object
    for CntItem := 0 to Pred (CbxOrder.Items.Count) do begin
      if CbxOrder.Items[CntItem] = IntToStr(IntOrder) then begin
        ObjSafeTrans := TObjSafeTransaction(CbxOrder.Items.Objects[CntItem]);
        break;
      end;
    end;
  end;
  if not Assigned (ObjSafeTrans) then begin
    if IntOrder <> 0 then
      MessageDlg (Format (CtTxtEmOrderNotExist, [IntToStr(IntOrder)]),
                  mtError, [mbOK], 0);
    CbxOrder.ItemIndex := -1;
    CbxOrder.SetFocus;
  end
  else begin
    IdtOrderNumber := IntOrder;
    SplitString (CtTxtFmtPayOrgan, '=', TxtKeyword, TxtDummy);
    IdtAddrPayOrg := StrToInt (ObjSafeTrans.StrLstExplanation.
                               Values[TxtKeyword]);
    FillPanelsWithOrderData (ObjSafeTrans);
  end;
end;  // of TFrmTndBankOrderCA.CbxOrderExit

//=============================================================================
// TFrmTndBankOrderCA.FillPanelsWithOrderData : fetches the data from
// LstTransDetail (global variable) and stores it in the panels on the scrollbox
// SbxCount.
//                                  -----
// INPUT   : ObjSTrans = Object to fetch the transdetail from.
//=============================================================================

procedure TFrmTndBankOrderCA.FillPanelsWithOrderData
                                           (ObjSafeTrans : TObjSafeTransaction);
var
  ValIndex         : Integer;          // Index of LstSafeTransaction
  ObjTransDetail   : TObjTransDetail;  // object SafeTransDetail
  ValIndexDetail   : Integer;          // Index of LstTransdetail
  SbxCurrent       : TScrollBox;       // current scrollbox
  CntPnl           : Integer;          // couneter for panels on tabsheet
  FlgAccept        : Boolean;          // can button accept be enabled or not ?
begin // of TFrmTndBankOrderCA.FillPanelsWithOrderData
  TTabShtAcceptation(PgeCtlCount.Pages[0]).ObjSafeTrans := ObjSafeTrans;
  ValIndex := LstSafeTransaction.IndexOfIdtAndSeq
                  (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq);
  if ValIndex = -1 then
  DmdFpnSafeTransactionCA.BuildListSafeTransactionAndDetail
                      (LstSafeTransaction, ObjSafeTrans.IdtSafeTransaction);
  ValIndexDetail := -1;
  ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail (
    ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq, ValIndexDetail);
  FlgAccept := False;
  while Assigned (ObjTransDetail) do begin
    // store current scrollbox on tabsheet in a more readable variable
    SbxCurrent := TTabShtTender(PgeCtlCount.Pages[0]).SbxCount;
    // run over all controls in the scrollbox
    for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
      if SbxCurrent.Controls[CntPnl] is TPnlCashUnit then begin
        if (TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFValUnit.AsFloat =
             ObjTransDetail.ValUnit) and
           (TPnlCashUnit(SbxCurrent.Controls[CntPnl]).LblDescr.Caption =
             ObjTransDetail.TxtDescr) then begin
          TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFQtyUnit.AsInteger :=
                   ObjTransDetail.QtyUnit;
          // trigger change of quantity field (it is not automatically trigger'd
          // when the field is casted.
          TPnlCashUnit(SbxCurrent.Controls[CntPnl]).SvcLFChange (
                   TPnlCashUnit(SbxCurrent.Controls[CntPnl]));
          if ObjTransDetail.QtyUnit <> 0 then
            FlgAccept := True;
        end;
      end; // if SbxCurrent.Controls[CntPnl] is TPnlCashUnit
    end; // for CntPnl
    ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail (
      ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq, ValIndexDetail);
  end;  // while Assigned (ObjTransDetail)
  if FlgAccept then begin
    CbxOrder.Enabled := False;
    BtnAccept.Enabled := True;
    TTabShtTender(PgeCtlCount.Pages[0]).FocusFirst;
  end;
end;  // of TFrmTndBankOrderCA.FillPanelsWithOrderData

//=============================================================================
// TFrmTndBankOrderCA.CbxOrderKeyDown
//=============================================================================

procedure TFrmTndBankOrderCA.CbxOrderKeyDown (    Sender: TObject;
                                              var Key: Word;
                                                  Shift: TShiftState);
begin // of TFrmTndBankOrderCA.CbxOrderKeyDown
  if (Key = VK_RETURN) then begin
    CbxOrder.Style := csSimple;
    try
      TTabShtTender (PgeCtlCount.Pages[0]).FocusFirst;
    finally
      CbxOrder.Style := csDropDown;
    end;
  end;
  inherited;
end;  // of TFrmTndBankOrderCA.CbxOrderKeyDown

//=============================================================================

procedure TFrmTndBankOrderCA.CbxSupplierKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmTndBankOrderCA.CbxSupplierKeyDown
  if (Key = VK_RETURN) then begin
    CbxOrder.Style := csSimple;
    try
      TTabShtTender (PgeCtlCount.Pages[0]).FocusFirst;
    finally
      CbxOrder.Style := csDropDown;
    end;
  end;
  inherited;
end;   // of TFrmTndBankOrderCA.CbxSupplierKeyDown

//=============================================================================

procedure TFrmTndBankOrderCA.OvcCtlCountIsSpecialControl(Sender: TObject;
  Control: TWinControl; var Special: Boolean);
begin  // of TFrmTndBankOrderCA.OvcCtlCountIsSpecialControl
  inherited;
  if Control = BtnCancel then
    Special := True;
end; // of TFrmTndBankOrderCA.OvcCtlCountIsSpecialControl

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FFpnTndBankOrderCA
