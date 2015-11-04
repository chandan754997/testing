//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : FlexPoint
// Unit     : FFpnTndSafeToBankCA = Form FlexPoiNt TeNDer SAFE to BANK CAstorama
//            Transferring containers from Safe to Bank in Tender module.
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndSafeToBankCA.pas,v 1.2 2009/09/16 15:56:42 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FFpnTndSafeToBankCA - CVS revision 1.2
//=============================================================================

unit FFpnTndSafeToBankCA;

//*****************************************************************************

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, OvcPF, ScUtils, ExtCtrls,
  DFpnTenderGroup, SfCommon, DFpnSafeTransaction, DFpnSafeTransactionCA,
  DFpnTender, DFpnBagCA, OvcBase, OvcEF, OvcPB;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring  // some general resourcestrings for Captions
  // Form Captions according to function parameter
  CtTxtFrmCaptionPrint      = 'Reprint Containers';
  CtTxtFrmCaptionTransfer   = 'Transfer Safe to Bank';
  // Button Captions
  CtTxtBtnPrintCaption      = 'Reprint';
  CtTxtBtnTransferCaption   = 'Transfer';
  CtTxtBtnCancelCaption     = 'Cancel';

resourcestring  // some general resourcestrings for messages
  CtTxtNoContainers               = 'No containers available';

resourcestring  // Resourcestrings for captions on Header and Footer panel
  CtTxtHdrContainerNumber   = 'Container';      // Containernumber
  CtTxtHdrDate              = 'Date';           // Date when container created
  CtTxtHdrOper              = 'Operator';       // operator who created the bag
  CtTxtHdrTransfer          = 'Selection';      // Selection of container Y/N
  CtTxtHdrTotalAmount       = 'Total amount';   // Amount in container

//=============================================================================
// Names for at run time created components - formatted at run time with the
// number of the TabSheet.
//=============================================================================

const
  CtTxtNameTabSht         = 'TabSht%d';         // TabSheet for TenderGroup(s)
  CtTxtNamePnlHeaderLeft  = 'PnlHdrLeftTab%d';  // Panel headers TabSheet
  CtTxtNamePnlHeaderRight = 'PnlHdrRightTab%d'; // Panel headers TabSheet
  CtTxtNamePnlFooter      = 'PnlFtrTab%d';      // Panel bottom TabSheet
  CtTxtNamePnlDivider     = 'PnlDivTab%d';      // Panel divider TabSheet
  CtTxtNameSbxHeaderLeft  = 'SbxHdrLeftTab%d';  // ScrollBox headers TabSheet
  CtTxtNameSbxHeaderRight = 'SbxHdrRighTab%d';  // ScrollBox headers TabSheet
  CtMaxContainers         = 11;                 // max number of containers in
                                                // column before it is split
                                                // on a second column

const  // Run function parameters
  CtCodFuncReprint        = 1;
  CtCodFuncTransfer       = CtCodFuncReprint + 1;
  CtTxtPTndSafeToBank     = '97';

//=============================================================================
// Width of at runtime created components
//=============================================================================

var
  ViValWidthSpace     : Integer =   5; // Width between 2 components
  ViValWidthContainer : Integer =  90; // Width of component for containernr
  ViValWidthVal       : Integer =  60; // Width of component for value
  ViValWidthQty       : Integer =  30; // Width of component for count selected
  ViValWidthDescr     : Integer =  70; // Width of component for description
  ViValWidthDate      : Integer =  120; // Width of component for date
  ViValWidthIdtOper   : Integer =  92;  // Width of component for idtoperator
  ViValWidthIdtOperHdr: Integer = 100; // Width for the header of operator
  VivalWidthTransfer  : Integer =  90;  // Width of component for transfer

//*****************************************************************************
// Components at run time created
//*****************************************************************************

//=============================================================================
// Declaration of later defined types
//=============================================================================

type
  TTabShtTender    = class;

//=============================================================================
// TPnlContainer : common parent panel to administer a Container
//=============================================================================

  TPnlContainer          = class (TPanel)
  protected
    // Visual components on panel
    FLblContainerNumber : TLabel;           // Bagnumber
    FSvcLFValContainer  : TSvcLocalField;   // Amount of money that's in Ctainer
    FLblDate            : TLabel;           // Date
    FLblIdtOper         : TLabel;           // IdtOperator
    FChxTransfer        : TCheckBox;        // Checkbox transfer container
    // Datafields
    FTabShtTender       : TTabShtTender;    // TabSheet where Panel belongs to
    FObjContainer       : TObjContainerCA;  // Container object
    FOnClick            : TNotifyEvent;     // on click checkbox
    FOnEnter            : TNotifyEvent;     // on enter checkbox
    FOnExit             : TNotifyEvent;     // on exiting checkbox
  public
    // Methods for components on the Panel
    function CreateLabel (var ValLeft    : Integer;
                              ValWidth   : Integer;
                              TxtCaption : string ) : TLabel; virtual;
    function CreateCheckBox (var ValLeft    : Integer;
                                 ValWidth   : Integer) : TCheckBox; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    procedure CreateForTender (var ValLeft : Integer;
                                   FlgLeft : Boolean); virtual;
    procedure DataToContainer (ObjContainer : TObjContainerCA); virtual;
    procedure OnClick (Sender : TObject); virtual;
    procedure OnEnter (Sender : TObject); virtual;
    procedure OnExit (Sender : TObject); virtual;
    procedure RefreshButtons; virtual;    
    // Properties
    property LblContainerNumber : TLabel         read  FLblContainerNumber
                                                 write FLblContainerNumber;
    property SvcLFValContainer  : TSvcLocalField read  FSvcLFValContainer
                                                 write FSvcLFValContainer;
    property LblDate            : TLabel         read  FLblDate
                                                 write FLblDate;
    property LblIdtOper         : TLabel         read  FLblIdtOper
                                                 write FLblIdtOper;
    property ChxTransfer        : TCheckBox      read  FChxTransfer
                                                 write FChxTransfer;
    property TabShtTender       : TTabShtTender  read  FTabShtTender
                                                 write FTabShtTender;
    property ObjContainer       : TObjContainerCA read  FObjContainer
                                                  write FObjContainer;
  end;  // of TPnlContainer

//=============================================================================
// TTabShtTender : TabSheet to administer a collection of Containers
//                 (for a TenderGroup).
//=============================================================================

  TTabShtTender    = class (TTabSheet)
  protected
    // Visual components on TabSheet
    FPnlHeaderLeft      : TPanel;           // Panel header TabSheet Left
    FPnlHeaderRight     : TPanel;           // Panel header TabSheet Right
    FPnlFooter          : TPanel;           // Panel footer results TabSheet
    FSbxHeaderLeft      : TScrollBox;       // Scroll-box header TabSheet Left
    FSbxHeaderRight     : TScrollBox;       // Scroll-box header TabSheet Right
    FSbxLeft            : TScrollBox;       // Left Scroll-box for tendergroups
    FSbxRight           : TScrollBox;       // Right Scroll-box for tendergroups
    // Datafields
    FObjTenderGroup     : TObjTenderGroup;  // Current TenderGroup in TabSheet
    FCtlCancel          : TWinControl;      // Control used to cancel operations
    FLstContainer       : TLstContainerCA;  // List containing the ctainers for
                                            // a specific TenderGroup.
    FFlgAllLeftColumn   : Boolean;          // True if there are less than 11
                                            // bags -> so  we have to put them
                                            // all in the left scrollbox for
                                            // esthetic reasons.
    FFlgLeftcolumn      : Boolean;          // If true put a new bagpanel in
                                            // the left scrollbox else the right
    FSvcLFValTotal      : TSvcLocalField;   // Total count currency group
    FSvcLFValAmount     : TSvcLocalField;   // Total amount currency group
    FPnlFtrAmount       : TPanel;           // Panel Footer amount
    FOnChange           : TNotifyEvent;
  public
    // Constructor and destructor
    constructor CreateForTender (PgeCtlParent   : TPageControl;
                                 ObjTenderGroup : TObjTenderGroup); virtual;
    destructor Destroy; override;
    // Methods for components on the TabSheet
    // event when changing selection of checkbox
    procedure OnChange (    Sender    : TObject; var NewWidth : Integer;
                        var NewHeight : Integer; var Resize: Boolean); virtual;
    function CreateContainerPanel (ObjContainer  : TObjContainerCA;
                                   FlgLeft : Boolean) : TPnlContainer; virtual;
    procedure AdjustScrollBarRange (ValHorz : Integer;
                                    ValVert : Integer); virtual;
    function CreateLblHeader (var ValLeft    : Integer;
                                  ValWidth   : Integer;
                                  TxtCaption : string ;
                                  PnlHeader  : TPanel) : TLabel; virtual;
    function CreateLblFooter (var ValLeft    : Integer;
                                  TxtCaption : string) : TLabel; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField; virtual;
    procedure CreateHeader (var ValLeft : Integer); virtual;
    function CreatePnlAmount (CtlParent : TWinControl;
                              ValLeft   : Integer;
                              ValWidth  : Integer) : TPanel; virtual;
    procedure CreateFooter (var ValLeft : Integer); virtual;
    procedure AdjusTPnlContainer (PnlContainer : TPnlContainer;
                                  FlgLeft      : Boolean); virtual;
    // Properties
    property PnlHeaderLeft    : TPanel          read  FPnlHeaderLeft
                                                write FPnlHeaderLeft;
    property PnlHeaderRight   : TPanel          read  FPnlHeaderRight
                                                write FPnlHeaderRight;
    property PnlFooter        : TPanel          read  FPnlFooter
                                                write FPnlFooter;
    property SbxHeaderLeft    : TScrollBox      read  FSbxHeaderLeft
                                                write FSbxHeaderLeft;
    property SbxHeaderRight   : TScrollBox      read  FSbxHeaderRight
                                                write FSbxHeaderRight;
    property SbxLeft          : TScrollBox      read  FSbxLeft
                                                write FSbxLeft;
    property SbxRight         : TScrollBox      read  FSbxRight
                                                write FSbxRight;
    property ObjTenderGroup   : TObjTenderGroup read  FObjTenderGroup
                                                write FObjTenderGroup;
    property CtlCancel        : TWinControl     read  FCtlCancel
                                                write FCtlCancel;
    property LstContainer     : TLstContainerCA read  FLstContainer
                                                write FLstContainer;
    property FlgAllLeftColumn : Boolean         read  FFlgAllLeftColumn
                                                write FFlgAllLeftColumn;
    property FlgLeftColumn    : Boolean         read  FFlgLeftColumn
                                                write FFlgLeftColumn;
    property SvcLFValTotal    : TSvcLocalField  read  FSvcLFValTotal
                                                write FSvcLFValTotal;
    property SvcLFValAmount   : TSvcLocalField  read  FSvcLFValAmount
                                                write FSvcLFValAmount;
    property PnlFtrAmount     : TPanel          read  FPnlFtrAmount
                                                write FPnlFtrAmount;
  end;  // of TTabShtTender

type
  TFrmTndSafeToBankCA = class (TFrmCommon)
    PnlTop: TPanel;
    PnlBottom: TPanel;
    BtnPrint: TBitBtn;
    BtnCancel: TBitBtn;
    PgeCtlTender: TPageControl;
    StsBarInfo: TStatusBar;
    OvcCtlCount: TOvcController;
    BtnTransfer: TBitBtn;
    procedure OvcCtlCountIsSpecialControl(Sender: TObject; Control: TWinControl;
      var Special: Boolean);
    procedure FormActivate (Sender: TObject);
    procedure FormCreate (Sender: TObject);
    procedure BtnExecuteClick (Sender: TObject);
    procedure FormDestroy (Sender: TObject);
  protected
    { Protected declarations }
    SavAppOnIdle          : TIdleEvent;      // Save original OnIdle event handler
    FFlgEverActivated     : Boolean;         // Indicates first time activated

    // some values to pass to the form FContainerCA (ask for containernumber)
    FObjTenderGroup       : TObjTenderGroup; // TenderGroup object
    FQtyTotal             : Currency;        // Number of bags on tabsheet
    FValTotal             : Currency;        // Total amount of bags on tabsheet
    // value to pass to form FVSRptContainerCA (print report containers)
    FLstContainer         : TLstContainerCA; // List of containers
    FCodRunFunc           : Integer;         // Function Print or Transfer
    FOnClick              : TNotifyEvent;
    FQtyContainersChecked : Integer;         // counts the selected containers
                                             // to keep track of the ability of
                                             // the buttons
    FIdtOperReg         : string;          // IdtOperator registrating                                             
    FTxtNameOperReg     : string;          // Name operator                                             
    procedure OnFirstIdle (    Sender : TObject;
                           var Done   : Boolean); virtual;
    function FocusNextTabSht (TabShtStart : TTabSheet) : Boolean; virtual;
    procedure CreateTabSheetsForTenderGroups; virtual;
    procedure CreateTenderGroupLists; virtual;
    procedure BuildLstContainers; virtual;
    procedure SetFlgTransferred; virtual;
    procedure InitButtons; virtual;
    procedure LogOn; virtual;
    function GetIdtOperReg : string; virtual;
    procedure SetIdtOperReg (Value : string); virtual;
    procedure SetTxtNameOperReg (Value : string); virtual;    
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
    property QtyContainersChecked : Integer read  FQtyContainersChecked
                                            write FQtyContainersChecked;
  published
    property ObjTenderGroup  : TObjTenderGroup read  FObjTenderGroup
                                               write FObjTenderGroup;
    property QtyTotal        : Currency read  FQtyTotal
                                        write FQtyTotal;
    property ValTotal        : Currency read  FValTotal
                                        write FValTotal;
    property LstContainer    : TLstContainerCA read  FLstContainer
                                               write FLstContainer;
    property CodRunFunc       : Integer read  FCodRunFunc
                                        write FCodRunFunc;
    property IdtOperReg       : string read  GetIdtOperReg
                                       write SetIdtOperReg;
    property TxtNameOperReg   : string read  FTxtNameOperReg
                                       write SetTxtNameOperReg;
  end; // of TFrmTndSafeToBankCA

var
  FrmTndSafeToBankCA : TFrmTndSafeToBankCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  ScTskMgr_BDE_DBC,

  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  RFpnCom,

  DFpnOperatorCA,
  DFpnTenderCA,
  DFpnTenderGroupCA,

  RFpnTender,

  DFpnOperator,
  DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FFpnTndSafeToBankCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndSafeToBankCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2009/09/16 15:56:42 $';

//*****************************************************************************
// Implementation of TPnlContainer
//*****************************************************************************

//=============================================================================
// TPnlContainer.CreateLabel : creates a label.
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

function TPnlContainer.CreateLabel (var ValLeft    : Integer;
                                        ValWidth   : Integer;
                                        TxtCaption : string  ) : TLabel;
begin  // of TPnlContainer.CreateLabel
  Result := TLabel.Create (Owner);

  Result.Parent     := Self;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := False;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlContainer.CreateLabel

//=============================================================================
// TPnlContainer.CreateCheckBox : creates a checkbox.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//           ValWidth = property Width for the Checkbox.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlContainer.CreateCheckBox (var ValLeft    : Integer;
                                           ValWidth   : Integer) : TCheckBox;
begin  // of TPnlContainer.CreateCheckBox
  Result := TCheckBox.Create (Owner);

  Result.Parent     := Self;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;
  Result.OnEnter    := OnEnter;
  Result.OnExit     := OnExit;


  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlContainer.CreateCheckBox

//=============================================================================
// TPnlContainer.CreateSvcLFVal : creates a new component to hold or enter
// a value.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlContainer.CreateSvcLFVal (var ValLeft : Integer): TSvcLocalField;
begin  // of TPnlContainer.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := Self;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthVal;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlContainer.CreateSvcLFVal

//=============================================================================
// TPnlContainer.CreateForTender : creates the components for count on the Panel.
//                                  -----
// INPUT   : ValLeft = left property for the first component to create.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append components.
//=============================================================================

procedure TPnlContainer.CreateForTender (var ValLeft : Integer;
                                             FlgLeft : Boolean);
begin  // of TPnlContainer.CreateForTender
  // Label for Bagnumber
  LblContainerNumber := CreateLabel (ValLeft, ViValWidthContainer, '');
  // Component for Total amount in Bag
  SvcLFValContainer := CreateSvcLFVal (ValLeft);
  // Component for bag date
  LblDate      := CreateLabel (ValLeft, ViValWidthDate, '');
  // Component for idtoperator
  LblIdtOper   := CreateLabel (ValLeft, ViValWidthIdtOperHdr, '');
  // Component for checkbox transfer
  ChxTransfer := CreateCheckBox (valLeft, VivalWidthTransfer);
  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlContainer.CreateForTender

//=============================================================================
// TPnlContainer.DataToContainer : configures the components on the panel
// for the current Bag.
//                                  -----
// INPUT   : ObjContainer = Bag Object.
//=============================================================================

procedure TPnlContainer.DataToContainer (OBjContainer : TObjContainerCA);
var
  ValTotal         : Currency;         // Total amount for bags for TenderGroup
begin  // of TPnlContainer.DataToContainer

  // Bagnumber
  LblContainerNumber.Caption := ObjContainer.IdtContainer;
  LblContainerNumber.Alignment := taLeftJustify;

  // Amount that is in the Container
  valTotal := DmdFpnSafeTransactionCA.AmountContainer (ObjContainer.LstBag);

  // Identifier of the operator
  LblIdtOper.Caption := ObjContainer.IdtOperator;

  // CreationDate of the container
  LblDate.Caption := DateTimeToStr(ObjContainer.DatContainer);

  SvcLFValContainer.AsFloat := ValTotal;
  SvcLFValContainer.Enabled := False;

  if assigned(FrmTndSafeToBankCA) then begin
    case FrmTndSafeToBankCA.CodRunFunc of
      CTCodFuncReprint  :
        begin
          ChxTransfer.Enabled := True;
          ChxTransfer.Checked := False;
          ChxTransfer.OnClick := OnClick;
        end;
      CTCodFuncTransfer :
        begin
          ChxTransfer.Enabled := False;
          ChxTransfer.Checked := True;
          FrmTndSafeToBankCA.QtyContainersChecked :=
                                  FrmTndSafeToBankCA.QtyContainersChecked + 1;
          FrmTndSafeToBankCA.BtnTransfer.Enabled := True;
        end;
    end; // end case FrmTndSafeToBankCA.CodRunFunc
  end; // if assigned(FrmTndSafeToBankCA)
end;   // of TPnlContainer.DataToContainer

//=============================================================================
// TPnlContainer.OnClick : Change the counter for the selected/unselected
//                         checkboxes (chxTransfer)
//=============================================================================

procedure TPnlContainer.OnClick (Sender: TObject);
begin // of TPnlContainer.OnClick
  if Sender is TCheckBox then begin
    if ChxTransfer.Checked then begin
      FrmTndSafeToBankCA.QtyContainersChecked :=
          FrmTndSafeToBankCA.QtyContainersChecked + 1;
    end
    else begin
      FrmTndSafeToBankCA.QtyContainersChecked :=
          FrmTndSafeToBankCA.QtyContainersChecked - 1;
    end;

    RefreshButtons;
  end;
end;  // of TPnlContainer.OnClick

//=============================================================================
// TPnlContainer.OnEnter : Change the caption for the checkboxes (chxTransfer)
// when entered with tabkey to see where the cursor is
//=============================================================================

procedure TPnlContainer.OnEnter (Sender: TObject);
begin // of TPnlContainer.OnEnter
  if Sender is TCheckBox then begin
    ChxTransfer.Caption := '<-';
  end;
end;  // of TPnlContainer.OnEnter

//=============================================================================
// TPnlContainer.OnExit : Change the caption for the checkboxes (chxTransfer)
// when leaving the checkbox with tabkey to see where the cursor is
//=============================================================================

procedure TPnlContainer.OnExit (Sender: TObject);
begin // of TPnlContainer.OnExit
  if Sender is TCheckBox then begin
    ChxTransfer.Caption := '';
  end;
end;  // of TPnlContainer.OnExit

//=============================================================================
// TPnlContainer.RefreshButtons : refreshing ability of buttons according to
//                                the number of selected containers
//=============================================================================

procedure TPnlContainer.RefreshButtons;
begin
  if FrmTndSafeToBankCA.QtyContainersChecked = 0 then
    case FrmTndSafeToBankCA.CodRunFunc of
      CtCodFuncReprint  :
        FrmTndSafeToBankCA.BtnPrint.Enabled := False;
      CtCodFuncTransfer :
        FrmTndSafeToBankCA.BtnTransfer.Enabled := False;
    end
  else
    case FrmTndSafeToBankCA.CodRunFunc of
      CtCodFuncReprint  :
        FrmTndSafeToBankCA.BtnPrint.Enabled := True;
      CtCodFuncTransfer :
        FrmTndSafeToBankCA.BtnTransfer.Enabled := True;
    end;
end;

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
  TabVisible := False;
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
  SbxHeaderLeft         := TScrollBox.Create (PgeCtlParent.Owner);
  SbxHeaderLeft.Name    := Format (CtTxtNameSbxHeaderLeft,
                                   [PgeCtlParent.PageCount - 1]);
  SbxHeaderLeft.Parent  := Self;
  SbxHeaderLeft.Align  := alClient;
  SbxHeaderLeft.BorderStyle := bsNone;
  SbxHeaderLeft.Width := PgeCtlParent.Width;
  SbxHeaderLeft.HorzScrollBar.Visible := False;
  SbxHeaderLeft.VertScrollBar.Visible := False;
  // Panel Header for labels on the left scrollbox
  PnlHeaderLeft := TPanel.Create (PgeCtlParent.Owner);
  PnlHeaderLeft.Name       := Format (CtTxtNamePnlHeaderLeft,
                                  [PgeCtlParent.PageCount - 1]);
  PnlHeaderLeft.Parent     := SbxHeaderLeft;
  PnlHeaderLeft.Caption    := '';
  PnlHeaderLeft.Align      := alTop;
  PnlHeaderLeft.BevelInner := bvNone;
  PnlHeaderLeft.BevelOuter := bvNone;
  PnlHeaderLeft.Height     := 20;
  SbxLeft := TScrollBox.Create (Self);
  SbxLeft.Parent := SbxHeaderLeft;
  SbxLeft.Align := AlClient;
  SbxLeft.BorderStyle := bsNone;
  SbxLeft.VertScrollBar.Tracking := True;
  SbxLeft.HorzScrollBar.Visible := False;
  SbxLeft.VertScrollBar.Visible := True;
  // Header on TabSheet
  ValLeft := 8;
  CreateHeader (ValLeft);
  // Footer on TabSheet
  ValLeft := 8;
  CreateFooter (ValLeft);
end;   // of TTabShtTender.CreateForTender

//=============================================================================
// TTabShtTender.Destroy : destroys all created objects for this tabsheet
//=============================================================================

destructor TTabShtTender.Destroy;
begin // of TTabShtTender.Destroy
  inherited;
  LstContainer.Free;
end;  // of TTabShtTender.Destroy

//=============================================================================
// TTabShtTender.OnChange : Event to let the left scrollbox go along with
//                          the movements (up / down) of the sbx on the right.
//=============================================================================

procedure TTabShtTender.OnChange (    Sender    : TObject;
                                  var NewWidth  : Integer;
                                  var NewHeight : Integer;
                                  var Resize    : Boolean);
begin // of TTabShtTender.OnChange
   SbxLeft.VertScrollBar.Position := SbxRight.VertScrollBar.Position;
end;  // of TTabShtTender.OnChange

//=============================================================================
// TTabShtTender.CreateContainerPanel : creates the Panel and necessary
// components to show a bag's properties.
//                                  -----
// INPUT   : ObjContainer  = bag to create the Panel for.
//           FlgLeft = if true then put the panel on the left side of the tbsht
//                     else put it in the right column
//                                  -----
// FUNCRES : created Bag Panel.
//=============================================================================

function TTabShtTender.CreateContainerPanel
                                   (OBjContainer  : TObjContainerCA;
                                    FlgLeft       : Boolean  ) : TPnlContainer;
var
  ValLeft          : Integer;          // Left property for new components
begin  // of TTabShtTender.CreateContainerPanel
  Result := TPnlContainer.Create (Owner);
  Result.TabShtTender   := Self;
  Result.ObjContainer := ObjContainer;
  AdjusTPnlContainer (Result, FlgLeft);
  ValLeft := 8;
  TPnlContainer(Result).CreateForTender (ValLeft, FlgLeft);
  TPnlContainer(Result).DataToContainer (ObjContainer);
  SvcLFValTotal.AsFloat := SvcLFValTotal.AsFloat + 1;
  SvcLFValAmount.AsFloat := SvcLFValAmount.AsFloat +
                            TPnlContainer(Result).SvcLFValContainer.AsFloat;
end;   // of TTabShtTender.CreateContainerPanel

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
  if SbxHeaderLeft.HorzScrollBar.Range < ValHorz then
    SbxHeaderLeft.HorzScrollBar.Range := ValHorz;
  if SbxLeft.VertScrollBar.Range < ValVert then
    SbxLeft.VertScrollBar.Range := ValVert;
end;   // of TTabShtTender.AdjustScrollBarRange

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
                                            TxtCaption : string ;
                                            PnlHeader  : TPanel  ) : TLabel;
begin  // of TTabShtTender.CreateLblHeader
  Result := TLabel.Create (Owner);

  Result.Parent     := PnlHeader;
  Result.WordWrap   := True;
  Result.Caption    := TxtCaption;
  Result.Alignment  := taLeftJustify;
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

function TTabShtTender.CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField;
begin  // of TTabShtTender.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.Top           := 8;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthVal;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtTender.CreateSvcLFVal

//=============================================================================
// TTabShtTender.CreateSvcLFQty : creates a new component on the Footer for
// showing a Counter value without decimals.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtTender.CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField;
begin  // of TTabShtTender.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.Top           := 8;
  Result.DataType      := pftInteger;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthQty;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtTender.CreateSvcLFQty

//=============================================================================
// TTabShtTender.CreateHeader : creates the header for the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for first created header-label.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append header-labels.
//=============================================================================

procedure TTabShtTender.CreateHeader (var ValLeft : Integer);
var
  ValLeftSave      : Integer;          // save the original val left
begin  // of TTabShtTender.CreateHeader
  ValLeftSave := ValLeft;
  // Header bag number
  CreateLblHeader (ValLeft, ViValWidthContainer, CtTxtHdrContainerNumber, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValAmount, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthDate, CtTxtHdrDate, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthIdtOperHdr, CtTxtHdrOper, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthTransfer, CtTxtHdrTransfer, PnlHeaderLeft);
  ValLeft := ValLeftSave;
end;   // of TTabShtTender.CreateHeader

//=============================================================================
// TTabShtTender.CreatePnlAmount : creates a Panel for the totals.
//                                  -----
// INPUT   : CtlParent = Parent for the created Panel.
//           ValLeft = Left for the created Panel.
//           ValWidth = With for the created Panel.
//                                  -----
// FUNCRES : created Panel.
//=============================================================================

function TTabShtTender.CreatePnlAmount (CtlParent : TWinControl;
                                        ValLeft   : Integer;
                                        ValWidth  : Integer) : TPanel;
begin  // of TTabShtTender.CreatePnlAmount
  Result := TPanel.Create (Owner);

  Result.Parent     := CtlParent;
  Result.Left       := ValLeft;
  Result.Width      := ValWidth;
  Result.Height     := CtlParent.Height;
  Result.Top        := 0;
  Result.BevelInner := bvNone;  
  Result.BevelOuter := bvNone;
end;   // of TTabShtTender.CreatePnlAmount

//=============================================================================
// TTabShtTender.CreateFooter : ready to create the components for totals
// on the Footer of the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for components to create.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append components.
//=============================================================================

procedure TTabShtTender.CreateFooter (var ValLeft : Integer);
var
  LblNew           : TLabel;           // Created Label
begin  // of TTabShtTender.CreateFooter
  ValLeft := 8;
  // Label for Total Count
  CreateLblFooter (ValLeft, CtTxtHdrTotalCount + ': ');
  // Component for Total Count
  SvcLFValTotal := CreateSvcLFVal (ValLeft);
  SvcLFValTotal.Picturemask := '999999999';  

  Inc (ValLeft, 100);
  // Create Pnl for
  //   - set the width to a default (large enough) value
  //   - set the height to leave room for the border of PnlFooter
  FPnlFtrAmount := CreatePnlAmount (PnlFooter, ValLeft, 4 * ViValWidthVal);
  FPnlFtrAmount.Top := FPnlFtrAmount.Top + 2;
  FPnlFtrAmount.Height := FPnlFtrAmount.Height - 4;
  // Label for total Amount
  ValLeft := 0;
  LblNew := CreateLblFooter (ValLeft, CtTxtHdrTotalAmount + ': ');
  LblNew.Parent := FPnlFtrAmount;
  // Component for total Amount
  SvcLFValAmount := CreateSvcLFVal (ValLeft);
  SvcLFValAmount.Parent := PnlFtrAmount;
  // Label for Currency abbreviation
  LblNew := CreateLblFooter (ValLeft, DmdFpnUtils.IdtCurrencyMain);
  LblNew.Parent := PnlFtrAmount;
end;   // of TTabShtTender.CreateFooter

//=============================================================================
// TTabShtTender.AdjusTPnlContainer : Adjusts the panel's layout
//                                  -----
// INPUT   : PnlBag  = Panel to configure.
//           FlgLeft = is the panel linked to the left or right scrollbox
//=============================================================================

procedure TTabShtTender.AdjusTPnlContainer (PnlContainer : TPnlContainer;
                                            FlgLeft      : Boolean);
begin  // of TTabShtTender.AdjusTPnlContainer
  if FlgLeft then
    PnlContainer.Parent := SbxLeft
  else
    PnlContainer.Parent := SbxRight;
  PnlContainer.Caption    := '';
  PnlContainer.BevelInner := bvNone;
  PnlContainer.BevelOuter := bvNone;
  PnlContainer.Height     := 24;

  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  aligned on Top, then change it to align on Top.
  if FlgLeft then
    PnlContainer.Top   := SbxLeft.VertScrollBar.Range
  else
    PnlContainer.Top   := SbxRight.VertScrollBar.Range;
  PnlContainer.Align := alTop;
end;   // of TTabShtTender.AdjusTPnlContainer

//*****************************************************************************
// Implementation of TFrmTndSafeToBankCA
//*****************************************************************************

//=============================================================================
// Event Handlers of TFrmTndSafeToBankCA
//=============================================================================

procedure TFrmTndSafeToBankCA.FormActivate (Sender: TObject);
begin // of TFrmTndSafeToBankCA.FormActivate
  inherited;
  if not FlgEverActivated then begin
    case CodRunFunc of
      CtCodFuncReprint  :
        Caption := CtTxtFrmCaptionPrint;
      CtCodFuncTransfer :
        Caption := CtTxtFrmCaptionTransfer;
    end;

    SavAppOnIdle := Application.OnIdle;
    Application.OnIdle := OnFirstIdle;

  end;
  FFlgEverActivated := True;
end;  // of TFrmTndSafeToBankCA.FormActivate

//=============================================================================

procedure TFrmTndSafeToBankCA.FormCreate (Sender: TObject);
begin // of TFrmTndSafeToBankCA.FormCreate
  inherited;
  if not Assigned (DmdFpnTenderGroupCA) then
    DmdFpnTenderGroupCA := TDmdFpnTenderGroupCA.Create (Self);
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Self);
  if not Assigned (DmdFpnBagCA) then
    DmdFpnBagCA := TDmdFpnBagCA.Create (Self);
  if not Assigned (DMdFpnSafeTransactionCA) then
    DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
end;  // of TFrmTndSafeToBankCA.FormCreate

//=============================================================================

procedure TFrmTndSafeToBankCA.BtnExecuteClick (Sender: TObject);
begin // of TFrmTndSafeToBankCA.BtnExecuteClick
  TBitBtn(Sender).Visible := False;
  BtnCancel.Visible := False;
  // here we fill LstContainer with all checked containers
  // this property will be passed to the report
  BuildLstContainers;
  if LstContainer.Count > 0 then begin
    SvcTaskMgr.LaunchTask ('PrintReport');
    if CodRunFunc = CtCodFuncTransfer then
      SetFlgTransferred;
  end;

  Application.Terminate;
end;  // of TFrmTndSafeToBankCA.BtnExecuteClick

//=============================================================================

procedure TFrmTndSafeToBankCA.FormDestroy (Sender: TObject);
begin
  inherited;
  LstSafeTransaction.Free;
  LstSafeTransaction := nil;
  LstContainer.Free;
  LstContainer := nil;
end;

//=============================================================================
// TFrmTndSafeToBankCA.OnFirstIdle : installed as OnIdle Event in OnActivate, to
// execute some things as soon as the application becomes idle.
//=============================================================================

procedure TFrmTndSafeToBankCA.OnFirstIdle (    Sender : TObject;
                                           var Done   : Boolean);
begin  // of TFrmTndSafeToBankCA.OnFirstIdle
  Application.OnIdle := SavAppOnIdle;
  if IdtOperReg = '' then
    LogOn;
end;   // of TFrmTndSafeToBankCA.OnFirstIdle

//=============================================================================
// TFrmTndSafeToBankCA.FocusNextTabSht : tries to focus the next TabSheet if any
//                                  -----
// INPUT   : TabShtStart = TabSheet to start from for searching next.
//                                  -----
// FUNCRES : True = next TabSheet found
//           False = no next TabSheet found
//=============================================================================

function TFrmTndSafeToBankCA.FocusNextTabSht (TabShtStart: TTabSheet): Boolean;
var
  CntPage          : Integer;          // Counter pages in PgeCtl
  NumPage          : Integer;          // Number of current page
begin  // of TFrmTndSafeToBankCA.FocusNextTabSht
  Result := False;
  if PgeCtlTender.PageCount = 0 then
    Exit;
  if Assigned (TabShtStart) then
    NumPage := TabShtStart.PageIndex
  else
    NumPage := -1;

  for CntPage := 0 to Pred (PgeCtlTender.PageCount) do begin
    if (PgeCtlTender.Pages[CntPage].PageIndex > NumPage) then begin
      if Assigned (PgeCtlTender.ActivePage) then
        PgeCtlTender.ActivePage.TabVisible := False;
      PgeCtlTender.Pages[CntPage].TabVisible := True;
      PgeCtlTender.ActivePage := PgeCtlTender.Pages[CntPage];
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmTndSafeToBankCA.FocusNextTabSht

//=============================================================================
// TFrmTndSafeToBankCA.CreateTabSheetsForTenderGroups :
// creates the TabSheets for TenderGroups.
//=============================================================================

procedure TFrmTndSafeToBankCA.CreateTabSheetsForTenderGroups;
var
  CntItem           : Integer;         // counter for Tendergroup
  CntContainer      : Integer;         // counter for Bag
  TbShtNew          : TTabShtTender;   // last tabsheet created
  ObjContainer      : TObjContainerCA; // current Container object
  FlgContainerFound : Boolean;         // Is true when at least one tabsht
                                       // is set to visible
begin  // of TFrmTndSafeToBankCA.CreateTabSheetsForTenderGroups

  // Pagecontrol is made unvisible at first to prevent the screen
  // from flickering.
  PgeCtlTender.Visible := False;

  // Creation of the LstTenderGroup, LstTenderClass and LstTenderUnit.
  CreateTenderGroupLists;
  FlgContainerFound := False;
  for CntItem := 0 to LstTenderGroup.Count - 1 do begin
    if LstTenderGroup.TenderGroup[CntItem].CodTypePayOrgan = 1 then begin
      TbShtNew := TTabShtTender.CreateForTender
                                      (PgeCtlTender,
                                       LstTenderGroup.TenderGroup [CntItem]);
      TbShtNew.LstContainer := TLstContainerCA.Create;
      // Get all containers for this tendergroup that have not yet been sent
      // to the bank.

      DmdFpnBagCA.GetUnTransferredContainers
                         (TbShtNew.LstContainer,
                          LstTenderGroup.TenderGroup [CntItem].IdtTenderGroup);

      TbShtNew.TabVisible := False;
      TbShtNew.FlgAllLeftColumn := True;
      if TbShtNew.LstContainer.Count <> 0 then begin
        if TbShtNew.LstContainer.Count > CtMaxContainers then begin
          TbShtNew.FlgAllLeftColumn := False;
        end
        else
          TbShtNew.SbxHeaderLeft.Align := alClient;
        TbShtNew.FlgLeftcolumn := True;
        for CntContainer := 0 to TbShtNew.LstContainer.Count - 1 do begin
          ObjContainer := TbShtNew.LstContainer.Container[CntContainer];
          if Assigned (ObjContainer) then
            TbShtNew.CreateContainerPanel (ObjContainer, TbShtNew.FlgLeftColumn);
        end;
        // only the first tabsheet is visible
        TbShtNew.TabVisible := True;
        if not FlgContainerFound then
          FlgContainerFound := True;
      end;
    end;
  end;
  PgeCtlTender.Visible := True;
  // FlgContainerFound will be false if no tabsheets meet the requirements to be
  // shown to the user.  In that case the application will terminate.
  if not FlgContainerFound then begin
    MessageDlg (CtTxtNoContainers, mtInformation, [mbOK], 0);
    Application.Terminate;
  end;
end;   // of TFrmTndSafeToBankCA.CreateTabSheetsForTenderGroups

//=============================================================================
// TFrmTndSafeToBankCA.CreateTenderGroupLists : creates and loads from database
// the lists with TenderGroup, TenderClass and TenderUnit, which weren't
// created yet.
//=============================================================================

procedure TFrmTndSafeToBankCA.CreateTenderGroupLists;
begin  // of TFrmTndSafeToBankCA.CreateTenderGroupLists
  if not Assigned (LstTenderGroup) then begin
    LstTenderGroup := TLstTenderGroup.Create;
    DmdFpnTenderGroupCA.BuildListTenderGroup (LstTenderGroup);
  end;
end;   // of TFrmTndSafeToBankCA.CreateTenderGroupLists

//=============================================================================
// TFrmTndSafeToBankCA.BuildLstContainers : constructs the LstContainer that
//                                          will be passed to the report
//                                          Only the checked containers will be
//                                          added to the list.
//                                          Remember: When function parameter
//                                          is /FTransfer the checkboxes are
//                                          initialized to checked and are dis-
//                                          abled so all the containers will be
//                                          printed. 
//=============================================================================

procedure TFrmTndSafeToBankCA.BuildLstContainers;
var
  CntPage          : Integer;          // counter for tabsheets
  CntPnl           : Integer;          // counter for container panels
  SbxCurrent       : TScrollBox;
  PnlCurrent       : TPnlContainer;
  ObjContainer     : TObjContainerCA;
begin // of TFrmTndSafeToBankCA.BuildLstTransferredContainers
  if not Assigned (LstContainer) then
    LstContainer := TLstContainerCA.Create;
  LstContainer.ClearContainers;
  if PgeCtlTender.PageCount = 0 then
    exit;
  for CntPage := 0 to Pred (PgeCtlTender.PageCount) do begin
    // run over the LEFT scrollbox to capture all containers there
    SbxCurrent := TTabShtTender(PgeCtlTender.Pages [CntPage]).SbxLeft;
    for CntPnl := 0 to Pred (SbxCurrent.ControlCount) do begin
     if SbxCurrent.Controls [CntPnl] is TPnlContainer then begin
       PnlCurrent := TPnlContainer(SbxCurrent.Controls [CntPnl]);
       if PnlCurrent.ChxTransfer.Checked then begin
         ObjContainer :=
           LstContainer.AddContainer (PnlCurrent.ObjContainer.IdtContainer,
                                      CtCodDbsExist);
         with ObjContainer do begin
           DatContainer := PnlCurrent.ObjContainer.DatContainer;
           IdtOperator  := PnlCurrent.ObjContainer.IdtOperator;
           FlgTransfer  := PnlCurrent.ObjContainer.FlgTransfer;
           LstBag       := PnlCurrent.ObjContainer.LstBag;
         end; // with ObjContainer
       end; // if PnlCurrent.ChxTransfer.Checked
     end; // if SbxCurrent.Controls [CntPnl] is TPnlContainer
    end; // for CntPnl
  end; // for CntPage
end;  // of TFrmTndSafeToBankCA.BuildLstContainers

//=============================================================================
// TFrmTndSafeToBankCA.SetFlgTransferred :
// This procedure is only executed when function CtCodFuncTransfer is active.
// It sets FlgTransfer = True for table Container, Pochette and Safetransdetail
//
// LstContainer should contain all containers that are visible over all the
// tendergroup-tabsheets. (BuildLstContainer)
//=============================================================================

procedure TFrmTndSafeToBankCA.SetFlgTransferred;
var
  CntContainer     : Integer;          // counter for list containers
  ObjContainer     : TObjContainerCA;  // Current object container
  CntBag           : Integer;          // Counter for bags of container
begin // of TFrmTndSafeToBankCA.SetFlgTransferred
  if LstContainer.Count = 0 then
    exit;
  for CntContainer := 0 to LstContainer.Count - 1 do begin
    ObjContainer := LstContainer.Container [CntContainer];
    ObjContainer.FlgTransfer := True;
    ObjContainer.CodDBState := CtCodDbsModify;
    for CntBag := 0 to ObjContainer.LstBag.Count - 1 do begin
      ObjContainer.LstBag.Bag [CntBag].FlgTransfer := True;
      ObjContainer.LstBag.Bag [CntBag].CodDBState := CtCodDbsModify;
    end;
    // updates the FlgTransfer for table Pochette
    // as a whole for ObjContainer.Lstbag
    DmdFpnBagCA.UpdateLstBag (ObjContainer.LstBag, ['FlgTransfer']);
  // updates the FlgTransfer for table SafeTransdetail
  // as a whole for ObjContainer.LstBag
    DmdFpnSafeTransactionCA.UpdateTransDetailFlgTransfer (ObjContainer.LstBag);
  end;
  // updates the FlgTransfer for table Container
  // as a whole for LstContainer
  DmdFpnBagCA.UpdateLstContainer (LstContainer, ['FlgTransfer']);
end;  // of TFrmTndSafeToBankCA.SetFlgTransferred

//=============================================================================

procedure TFrmTndSafeToBankCA.InitButtons;
begin  // of TFrmTndSafeToBankCA.InitButtons
  BtnCancel.Caption := CtTxtBtnCancelCaption;
  case CodRunFunc of
    CtCodFuncReprint :
      begin
        BtnPrint.Visible := True;
        BtnPrint.Enabled := False;
        BtnTransfer.Visible := False;
        BtnPrint.Caption := CtTxtBtnPrintCaption;
      end;
    CtCodFuncTransfer :
      begin
        BtnPrint.Visible := False;
        BtnTransFer.Left := 440;
        BtnTransfer.Visible := True;
        BtnTransfer.Enabled := False;
        BtnTransfer.Caption := CtTxtBtnTransferCaption;
      end;
  end;
end;  // of TFrmTndSafeToBankCA.InitButtons

//=============================================================================
// TFrmTndSafeToBankCA.LogOn : LogOn registrating Operator.
//=============================================================================

procedure TFrmTndSafeToBankCA.LogOn;
begin  // of TFrmTndSafeToBankCA.LogOn
  if SvcTaskMgr.LaunchTask ('LogOn') then begin
    InitButtons;
    CreateTabSheetsForTenderGroups;
  end
  else begin
    ModalResult := mrCancel;
  end;
end;   // of TFrmTndSafeToBankCA.LogOn

//=============================================================================

function TFrmTndSafeToBankCA.GetIdtOperReg : string;
begin  // of TFrmTndSafeToBankCA.GetIdtOperReg
  Result := FIdtOperReg;
end;   // of TFrmTndSafeToBankCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndSafeToBankCA.SetIdtOperReg (Value : string);
begin  // of TFrmTndSafeToBankCA.GetIdtOperReg
  FIdtOperReg := Value;
end;   // of TFrmTndSafeToBankCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndSafeToBankCA.SetTxtNameOperReg (Value : string);
begin  // of TFrmTndSafeToBankCA.SetTxtNameOperReg
  FTxtNameOperReg := Value;
end;   // of TFrmTndSafeToBankCA.SetTxtNameOperReg

//=============================================================================

procedure TFrmTndSafeToBankCA.OvcCtlCountIsSpecialControl(Sender: TObject;
  Control: TWinControl; var Special: Boolean);
begin  // of TFrmTndSafeToBankCA.OvcCtlCountIsSpecialControl
  inherited;
  if Control = BtnCancel then
    Special := True;
end;   // of TFrmTndSafeToBankCA.OvcCtlCountIsSpecialControl

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
