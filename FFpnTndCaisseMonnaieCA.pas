//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint 2.0
// Unit     : FFpnTndCaisseMonnaieCA = Form FlexPoiNt TeNDer CAISSE MONNAIE
//            CAstorama
//            Transferring responsability of the 'caisse monnaie'
//            for the Tender module.
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndCaisseMonnaieCA.pas,v 1.3 2009/09/22 08:24:30 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FFpnTndCaisseMonnaieCA - CVS revision 1.7
// Version ModifiedBy Reason
// 1.8     SC. (TCS)  R2012.1--CAFR-suppression mention cheque kdo
//=============================================================================

unit FFpnTndCaisseMonnaieCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, Buttons, ExtCtrls, ComCtrls, OvcBase, OvcEF, OvcPB, OvcPF,
  ScUtils, DFpnTendergroup, DFpnSafeTransaction, OvcDbPF, ScDBUtil,
  DFpnSafeTransactionCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtTabShtCaptOther   = 'Other Receipts';
  CtTxtHdrTotal          = 'Total';
  CtTxtHdrValTheor       = 'Theoretic amount';
  CtTxtHdrValReal        = 'Inventory amount';
  CtTxtWrnNoRunnSafeTrans= 'No running transaction found';

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

const
  ViValStartLeft     =   8;    // Left offset of the first component on each
                               // Panel of a tabsheet
  ViValWidthSpace    =  10;    // Default Horizontal Space between 2 components
                               // on the same panel
  ViValWidthQty      =  50;    // Width of component for quantity
  ViValWidthLblSign  =  10;    // Width of labels for signs (X, =)
  ViValWidthVal      =  70;    // Width of component for value
  ViValWidthDescr    = 120;    // Width of component for description
  ViValWidthThVal    = 120;    // Width of component for theoretic value
  ViValWidthRVal     = 120;    // Width of component for real value

  ViValColWidthThVal = 120;    // max column width of theoretic value
  ViValColWidthRVal  = 120;    // max column width of real value

  ViValLeftTheorVal = ViValStartLeft +
                      ViValWidthQty + ViValWidthSpace +
                      ViValWidthLblSign + ViValWidthSpace +
                      ViValWidthVal + ViValWidthSpace +
                      ViValWidthDescr + ViValWidthSpace +
                      ViValWidthLblSign + ViValWidthSpace;
  ViValLeftRealVal  = ViValLeftTheorVal + ViValColWidthThVal + ViValWidthSpace;

const
  ViValHeightPnlHeader = 20;   // height for PnlHeader on SbxHeader on Tabsheet
  ViValHeightPnlDetail = 27;   // height for PnlTenderunit on SbxCount and
                               // height for PnlTenderGroup on SbxCount
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

  TPnlTender      = class (TPanel)
  protected
    FTabShtTender : TTabShtTender;    // TabSheet where Panel belongs to
    FObjTenderGroup   : TObjTenderGroup;  // TenderGroup for current panel
    function FocusNextPnlTender (FlgUp : Boolean) : Boolean; virtual;
  public
    procedure CreatePanel (var ValLeft : Integer); virtual;
    function CreateLabel (var ValLeft    : Integer;
                              ValWidth   : Integer;
                              TxtCaption : string;
                              FlgBold    : Boolean = False) : TLabel; virtual;
    function CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreateSvcLFVal (var ValLeft : Integer; Width : Integer)
                                                      : TSvcLocalField; virtual;
    procedure FocusFirst; virtual;
    procedure SvcLFKeyDown (    Sender : TObject;
                            var Key    : Word;
                                Shift  : TShiftState); virtual;
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
    FPnlHeader      : TPanel;           // Panel header TabSheet
    FSbxHeader      : TScrollBox;       // Scroll-box header TabSheet
    FSbxCount       : TScrollBox;       // Scroll-box for Count in Tender
    // Datafields
    FCtlFocusOnExit : TWinControl;      // Control to focus on Exit TabSht
    FCtlCancel      : TWinControl;      // Control used to cancel operations
  public
    // Constructor and destructor
    constructor CreateTabSheet (PgeCtlParent : TPageControl); virtual;
    // Methods for components on the TabSheet
    procedure AdjustScrollBarRange (ValHorz : Integer;
                                    ValVert : Integer); virtual;
    procedure CreateHeader (var ValLeft : Integer); virtual;
    function CreateLblHeader (var ValLeft    : Integer;
                                  ValWidth   : Integer;
                                  TxtCaption : string ) : TLabel; virtual;
    procedure AdjustPnlCount (PnlCount : TPnlTender); virtual;
    function FindNextPnlTender (PnlStart : TPnlTender;
                                FlgUp    : Boolean) : TPnlTender; virtual;
    procedure FocusFirst; virtual;
    // Properties
    property PnlHeader : TPanel read  FPnlHeader
                                write FPnlHeader;
    property SbxHeader : TScrollBox read  FSbxHeader
                                    write FSbxHeader;
    property SbxCount : TScrollBox read  FSbxCount
                                   write FSbxCount;
    property CtlFocusOnExit : TWinControl read  FCtlFocusOnExit
                                          write FCtlFocusOnExit;
    property CtlCancel : TWinControl read  FCtlCancel
                                     write FCtlCancel;
  end;  // of TTabShtTender

//=============================================================================
// TPnlTenderUnit : panel to show a TenderUnit of the Cash TenderGroup.
//=============================================================================

type
  TPnlTenderUnit     = class (TPnlTender)
  protected
    FLblDescr         : TLabel;           // Description TenderGroup or -Unit
    FSvcLFQtyUnit     : TSvcLocalField;   // Quantity units
    FSvcLFValUnit     : TSvcLocalField;   // Value unit
    FSvcLFValAmount   : TSvcLocalField;   // Amount
    FObjTenderUnit    : TObjTenderUnit;   // to what object Tenderunit is this
                                          // panel linked ?
  public
    procedure CreatePanel (var ValLeft : Integer); override;
    procedure SvcLFChange (Sender : TObject); virtual;
    function CreateLblSign (var ValLeft : Integer;
                                ChrSign : Char   ) : TLabel; virtual;
    procedure ConfigForTenderUnit (ObjTenderUnit : TObjTenderUnit); virtual;
    // properties
    property LblDescr : TLabel read  FLblDescr
                               write FLblDescr;
    property SvcLFQtyUnit : TSvcLocalField read  FSvcLFQtyUnit
                                           write FSvcLFQtyUnit;
    property SvcLFValUnit : TSvcLocalField read  FSvcLFValUnit
                                           write FSvcLFValUnit;
    property SvcLFValAmount : TSvcLocalField read  FSvcLFValAmount
                                             write FSvcLFValAmount;
    property ObjTenderUnit : TObjTenderUnit read  FObjTenderUnit
                                            write FObjTenderUnit;
  end;  // of TPnlTenderUnit

//=============================================================================
// TPnlTenderGroup : panel to show a TenderGroup.
//=============================================================================

type
  TPnlTenderGroup = class (TPnlTender)
  protected
    FLblDescr           : TLabel;           // Description TenderGroup
    FSvcLFTheorAmount   : TSvcLocalField;   // Theoretic value
    FSvcLFRealAmount    : TSvcLocalField;   // Real value
    FFlgTitleOnly       : Boolean;          // does the panel contain amounts or
                                            // is there just a title in it ?
    FFlgShowCount       : Boolean;          // is amount or count to be shown
                                            // for this tendergroup
  public
    procedure CreatePanel (var ValLeft : Integer); override;
    procedure ConfigForTenderGroup (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure SvcLFChange (Sender : TObject); virtual;
    // properties
    property LblDescr : TLabel read  FLblDescr
                               write FLblDescr;
    property SvcLFTheorAmount : TSvcLocalField read  FSvcLFTheorAmount
                                               write FSvcLFTheorAmount;
    property SvcLFRealAmount : TSvcLocalField read  FSvcLFRealAmount
                                              write FSvcLFRealAmount;
    property FlgTitleOnly : Boolean read  FFlgTitleOnly
                                    write FFlgTitleOnly;
    property FlgShowCount : Boolean read  FFlgShowCount
                                    write FFlgShowCount;
  end;  // of TPnlTenderGroup

//=============================================================================
// TPnlTenderDetail : panel to show a TenderGroup detail
//=============================================================================

type
  TPnlTenderDetail = class (TPnlTender)
  protected
    FLblDescr           : TLabel;           // Description TenderGroup
    FSvcLFTheorAmount   : TSvcLocalField;   // Theoretic value
    FSvcLFRealAmount    : TSvcLocalField;   // Real value
    FObjTenderUnit      : TObjTenderUnit;   // TenderUnit for current panel
    FFlgShowCount       : Boolean;          // is amount or count to be shown
                                            // for this tendergroup
  public
    procedure CreatePanel (var ValLeft : Integer); override;
    procedure ConfigForTenderDetail (ObjTUnit : TObjTenderUnit); virtual;
    procedure SvcLFChange (Sender : TObject); virtual;
    // properties
    property LblDescr : TLabel read  FLblDescr
                               write FLblDescr;
    property SvcLFTheorAmount : TSvcLocalField read  FSvcLFTheorAmount
                                               write FSvcLFTheorAmount;
    property SvcLFRealAmount : TSvcLocalField read  FSvcLFRealAmount
                                              write FSvcLFRealAmount;
    property ObjTenderUnit : TObjTenderUnit read  FObjTenderUnit
                                            write FObjTenderUnit;
    property FlgShowCount : Boolean read  FFlgShowCount
                                    write FFlgShowCount;
  end;  // of TPnlTenderDetail

//=============================================================================
// TTabShtCashUnit : TabSheet to administer a collection of TenderUnits
// for a TenderGroup Cash
//=============================================================================

type
  TTabShtCashUnit  = class (TTabShtTender)
  protected
    // Visual components on TabSheet
    FSvcLFValTotalTheor : TSvcLocalField;   // Total amount theoretic
    FSvcLFValTotalReal  : TSvcLocalField;   // Total amount that user did put in
    FPnlFooter          : TPanel;           // Panel footer results TabSheet
    FObjTenderGroup     : TObjTenderGroup;  // Current TenderGroup in TabSheet
  public
    // Constructor and destructor
    constructor CreateTabSheet (PgeCtlParent   : TPageControl;
                                ObjTenderGroup : TObjTenderGroup); reintroduce;
    // Methods for components on the TabSheet
    procedure CreateHeader (var ValLeft : Integer); override;
    procedure CreateFooter (var ValLeft : Integer); virtual;
    function CreateLblFooter (var ValLeft    : Integer;
                                  TxtCaption : string ) : TLabel; virtual;
    function CreatePnlTenderUnit (ObjTenderUnit  : TObjTenderUnit )
                                                      : TPnlTenderUnit; virtual;
    function CreateSvcLFQty (var ValLeft : Integer) : TSvcLocalField; virtual;
    function CreateSvcLFVal (var ValLeft : Integer; NumWidth : Integer)
                                                      : TSvcLocalField; virtual;
    // Properties
    property SvcLFValTotalTheor : TSvcLocalField read  FSvcLFValTotalTheor
                                                 write FSvcLFValTotalTheor;
    property SvcLFValTotalReal : TSvcLocalField  read  FSvcLFValTotalReal
                                                 write FSvcLFValTotalReal;
    property PnlFooter : TPanel read  FPnlFooter
                                write FPnlFooter;
    property ObjTenderGroup : TObjTenderGroup read  FObjTenderGroup
                                              write FObjTenderGroup;
  end;  // of TTabShtCashUnit

//=============================================================================
// TTabShtOtherReceipts : TabSheet to administer a collection of TenderUnits
// of one order.  Tabsheet has a fixed title as is NOT linked to any tendergroup
//=============================================================================

type
  TTabShtOtherReceipts  = class (TTabShtTender)
  protected
    function SetFlgShowCount (ObjTenderGroup : TObjTenderGroup):Boolean;virtual;
  public
    // Constructor
    constructor CreateTabSheet (PgeCtlParent : TPageControl); reintroduce;
    procedure CreateHeader (var ValLeft : Integer); override;
    function CreatePnlTenderGroup (ObjTenderGroup: TObjTenderGroup;
                                   FlgTitleOnly  : Boolean)
                                                   : TPnlTenderGroup ;virtual;
    procedure CreateDetailPanelsForTenderGroup (ObjTenderGroup:TObjTenderGroup);
                                                                        virtual;
    function CreatePnlTenderDetail (ObjTenderGroup : TObjTenderGroup;
                                    ObjTenderUnit : TObjTenderUnit)
                                                    : TPnlTenderDetail; virtual;
  end;  // of TTabShtOtherReceipts

//=============================================================================
// TRptDetailLine : detailline for the report 'transfer of responsability of
// caisse monnaie containing the necessary items for printing the body of the
// report.
//=============================================================================

type
  TRptDetailLine   = class
  public
    ObjTendergroup : TObjTenderGroup;
    ObjTenderUnit  : TObjTenderUnit;
    FlgShowTitle   : Boolean;
    FlgShowCount   : Boolean;
    QtyTheor       : Integer;
    QtyReal        : Integer;
    ValTheor       : Currency;
    ValReal        : Currency;
  end;

  //=============================================================================
// TFrmTndCaisseMonnaieCA
//=============================================================================

type
  TFrmTndCaisseMonnaieCA = class(TFrmCommon)
    StsBarInfo: TStatusBar;
    PnlTop: TPanel;
    PnlBottom: TPanel;
    BtnAccept: TBitBtn;
    BtnCancel: TBitBtn;
    OvcCtlCount: TOvcController;
    PgeCtlCount: TPageControl;
    procedure OvcCtlCountIsSpecialControl(Sender: TObject; Control: TWinControl;
      var Special: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure BtnAcceptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
    { Protected declarations }
    SavAppOnIdle        : TIdleEvent;      // Save original OnIdle evt hndlr
    FFlgEverActivated   : Boolean;         // Indicates first time activated
    FFlgParamTotal      : Boolean;         // Flag ask for total/detail if cash
                                           // tendergroup
    FIdtOperReg         : string;          // IdtOperator registrating
    FTxtNameOperReg     : string;          // Name operator
    FStrLstBody         : TStringList;     // stringlist for printing the detail
                                           // body of the report
    FStrLstReceipts     : TStringList;
    FValMinimumLength   : integer;         // Minimum length of secret code
    function GetIdtOperReg : string; virtual;
    procedure SetIdtOperReg (Value : string); virtual;
    procedure SetTxtNameOperReg (Value : string); virtual;
    procedure OnFirstIdle (    Sender : TObject;
                           var Done   : Boolean); virtual;
    procedure LogOn; virtual;
    procedure CreateSeparateTabSheetCash; virtual;
    procedure CreateTenderLists; virtual;
    procedure CreateTabSheetOtherReceipts; virtual;
    function AllowTenderGroup (ObjTenderGroup : TObjTenderGroup;
                               FlgCash        : Boolean) : Boolean; virtual;
    function FlgShowTenderUnits (ObjTenderGroup : TObjTenderGroup) : Boolean;
                                                                        virtual;
    procedure InsertFinalCount; virtual;
    procedure AddDetailCount (LstSafetrans : TLstSafeTransactionCA;
                              ObjSafeTrans : TObjSafeTransaction); virtual;
    procedure AddRealValuesToStringList
                                  (LstSafetrans : TLstSafeTransactionCA;
                                   ObjSafeTrans : TObjSafeTransaction); virtual;
    procedure PrintReport; virtual;
    procedure AddItemToStringlist (ObjTendergroup : TObjTenderGroup;
                                   ObjTenderUnit  : TObjTenderUnit;
                                   FlgShowTitle   : Boolean;
                                   FlgShowCount   : Boolean;
                                   ValTheor       : Variant;
                                   ValReal        : Variant); virtual;
    procedure AdjustItemStringlist (ObjTendergroup : TObjTenderGroup;
                                    ObjTenderUnit  : TObjTenderUnit;
                                    ValReal        : Variant); virtual;
    procedure FillLstReceipts; virtual;
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
    property FlgParamTotal : Boolean read  FFlgParamTotal
                                     write FFlgParamTotal;
  published
    { Published declarations }
    property IdtOperReg : string read  GetIdtOperReg
                                 write SetIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write SetTxtNameOperReg;
    property StrLstBody : TStringList read  FStrLstBody
                                      write FStrLstBody;
    property StrLstReceipts : TStringList read  FStrLstReceipts
                                          write FStrLstReceipts;
    property ValMinimumLength : integer read FValMinimumLength
                                       write FvalMinimumLength;
  end; // of TFrmTndCaisseMonnaieCA

var
  FrmTndCaisseMonnaieCA: TFrmTndCaisseMonnaieCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  OvcData,
  ScTskMgr_BDE_DBC,
  SmUtils,
  RFpnTender,
  SfDialog,
  DFpnUtils, DFpnTenderGroupCA;
  //FMntCaisseMonnaieCA;            //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)



//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FFpnTndCaisseMonnaieCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndCaisseMonnaieCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2012/04/03 08:24:30 $';

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
// TPnlTender.CreatePanel
//=============================================================================

procedure TPnlTender.CreatePanel (var ValLeft: Integer);
begin // of TPnlTender.CreatePanel
end;  // of TPnlTender.CreatePanel

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
                                     TxtCaption : string;
                                     FlgBold    : Boolean = False) : TLabel;
begin  // of TPnlTender.CreateLabel
  Result := TLabel.Create (Owner);
  Result.Parent     := Self;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := True;
  Result.Left       := ValLeft;
  if FlgBold then
    Result.Font.Style := [fsBold];
  Result.Top        := (Self.Height - Result.Height) div 2 + 2;
  Result.Width      := ValWidth;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlTender.CreateLabel

//=============================================================================
// TPnlTenderUnit.CreateLblSign : creates a label for a sign-character.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//           ChrSign = Caption for the label.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlTenderUnit.CreateLblSign (var ValLeft : Integer;
                                         ChrSign : Char    ) : TLabel;
begin  // of TPnlTenderUnit.CreateLblSign
  Result := CreateLabel (ValLeft, ViValWidthLblSign, ChrSign);
  Result.Alignment := taCenter;
end;   // of TPnlTenderUnit.CreateLblSign

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
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Top           := (Self.Height - Result.Height) div 2 + 2;
  Result.Width         := ViValWidthQty;
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

function TPnlTender.CreateSvcLFVal (var ValLeft : Integer; Width : Integer)
                                                               : TSvcLocalField;
begin  // of TPnlTender.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);
  Result.Parent        := Self;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Top           := (Self.Height - Result.Height) div 2 + 2;
  Result.Width         := Width;
  Result.RangeLo       := '0';
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlTender.CreateSvcLFVal

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
// TTabShtTender.CreateTabSheet : creates a new TabSheet.
//                                  -----
// INPUT   : PgeCtlParent = PageControl to create the TabSheet for (also used
//                          to determine the Owner of the created components).
//           ObjTenderGroup = TenderGroup to create the TabSheet for.
//=============================================================================

constructor TTabShtTender.CreateTabSheet (PgeCtlParent : TPageControl);
var
  ValLeft          : Integer;          // Var-parameter for CreateHeader
begin  // of TTabShtTender.CreateTabSheet
  inherited Create (PgeCtlParent.Owner);
  TabVisible := True;
  PageControl := PgeCtlParent;
  Name        := Format (CtTxtNameTabSht, [PgeCtlParent.PageCount - 1]);
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
  PnlHeader.Height     := ViValHeightPnlHeader;
  // Scrollbox for TenderGroups or TenderUnits on TabSheet - shows only
  // vertical scrollbar (horizontal scrolling is taken care of by SbxHeader).
  SbxCount             := TScrollBox.Create (PgeCtlParent.Owner);
  SbxCount.Name        := Format (CtTxtNameSbxCount,
                                   [PgeCtlParent.PageCount - 1]);
  SbxCount.Parent      := SbxHeader;
  SbxCount.Align       := alClient;
  SbxCount.BorderStyle := bsNone;
  SbxCount.VertScrollBar.Increment := ViValHeightPnlDetail;
  SbxCount.VertScrollBar.Tracking := True;
  SbxCount.HorzScrollBar.Visible := False;
  // Header on TabSheet
  ValLeft := ViValStartLeft;
  CreateHeader (ValLeft);
end;   // of TTabShtTender.CreateTabSheet

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
// TTabShtTender.CreateHeader
//=============================================================================

procedure TTabShtTender.CreateHeader (var ValLeft: Integer);
begin // of TTabShtTender.CreateHeader
end;  // of TTabShtTender.CreateHeader

//=============================================================================
// TTabShtCashUnit.CreateHeader : creates the header for the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for first created header-label.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append header-labels.
//=============================================================================

procedure TTabShtCashUnit.CreateHeader (var ValLeft : Integer);
begin  // of TTabShtCashUnit.CreateHeader
  // Header Quantity Unit
  CreateLblHeader (ValLeft, ViValWidthQty, CtTxtHdrQtyUnit);
  // Leave room for multiply sign
  Inc (ValLeft, ViValWidthLblSign + ViValWidthSpace);
  // Header Value Unit
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValUnit);
  // Leave room for description and equal sign
  Inc (ValLeft, ViValWidthDescr + ViValWidthLblSign + (2 * ViValWidthSpace));
  // Header Value theoretic Amount
  ValLeft := ViValLeftTheorVal;
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValAmount);
end;   // of TTabShtCashUnit.CreateHeader

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
  Result.WordWrap   := False;
  Result.Caption    := TxtCaption;
  Result.Alignment  := taRightJustify;
  Result.Font.Style := [fsBold, fsUnderline];
  Result.Left       := ValLeft;
  Result.Width      := ValWidth;
  Result.AutoSize   := False;
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

function TTabShtCashUnit.CreateLblFooter (var ValLeft    : Integer;
                                            TxtCaption : string ) : TLabel;
begin  // of TTabShtTender.CreateLblFooter
  Result := TLabel.Create (Owner);
  Result.Parent     := PnlFooter;
  Result.Caption    := TxtCaption;
  Result.Height     := 25; // default height of a SvcLFLocalField
  Result.Layout     := tlCenter;
  Result.Left       := ValLeft;
  Result.Top        := (PnlFooter.Height - Result.Height) div 2 + 2;
  Inc (ValLeft, Result.Width + (2 * ViValWidthSpace));
end;   // of TTabShtTender.CreateLblFooter

//=============================================================================
// TTabShtCashUnit.CreateSvcLFQty : creates a new component on the Footer for
// consulting a quantity.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtCashUnit.CreateSvcLFQty (var ValLeft : Integer): TSvcLocalField;
begin  // of TTabShtCashUnit.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);
  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.DataType      := pftLongInt;
  Result.PictureMask   := '99999';
  Result.MaxLength     := 5;
  Result.RangeHi       := '99999';
  Result.RangeLo       := '0';
  Result.Top           := (Self.Height - Result.Height) div 2 + 2;
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthQty;
  Result.Enabled       := False;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtCashUnit.CreateSvcLFQty

//=============================================================================
// TTabShtCashUnit.CreateSvcLFVal : creates a new component on the Footer for
// consulting a total value.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TTabShtCashUnit.CreateSvcLFVal (var ValLeft : Integer;
                                             NumWidth : Integer)
                                                               : TSvcLocalField;
begin  // of TTabShtCashUnit.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);
  Result.Parent        := PnlFooter;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Top           := (PnlFooter.Height - Result.Height) div 2 + 2;
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := NumWidth;
  Result.Enabled       := False;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TTabShtCashUnit.CreateSvcLFVal

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
  PnlCount.Height     := ViValHeightPnlDetail;
  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  aligned on Top, then change it to align on Top.
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
  PnlTender        : TPnlTender;       // Find first Panel for Tabsheet
begin  // of TTabShtTender.FocusFirst
  PnlTender := FindNextPnlTender (nil, False);
  if Assigned (PnlTender) then
    PnlTender.FocusFirst;
end;   // of TTabShtTender.FocusFirst

//*****************************************************************************
// Implementation of TPnlTenderUnit
//*****************************************************************************

procedure TPnlTenderUnit.CreatePanel (var ValLeft : Integer);
begin  // of TPnlTenderUnit.CreatePanel
  inherited;
  // Component for Quantity
  SvcLFQtyUnit := CreateSvcLFQty (ValLeft);
  SvcLFQtyUnit.Enabled := True;
  // Label for Multiply sign
  CreateLblSign (ValLeft, 'X');
  // Component for Value of unit
  SvcLFValUnit := CreateSvcLFVal (ValLeft, ViValWidthVal);
  SvcLFValUnit.Enabled   := False;
  // Label for description of count item
  LblDescr := CreateLabel (ValLeft, ViValWidthDescr, '');
  // Label for Equal sign
  CreateLblSign (ValLeft, '=');
  // Create component for Amount of tenderunit
  ValLeft := ViValLeftTheorVal;
  SvcLFValAmount         := CreateSvcLFVal (ValLeft, ViValWidthVal);
  SvcLFValAmount.Enabled := False;
  SvcLFQtyUnit.OnChange  := SvcLFChange;
  SvcLFQtyUnit.OnKeyDown := SvcLFKeyDown;
  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlTenderUnit.CreatePanel

//=============================================================================
// TPnlTender.FocusFirst : sets the focus on the first enabled component
// on the panel.
//=============================================================================

procedure TPnlTender.FocusFirst;
var
  CntItem          : Integer;          // counter for components on panel
begin // of TPnlTender.FocusFirst
  for CntItem := 0 to Pred (ControlCount) do begin
    if Controls[CntItem] is TSvcLocalField then begin
      if TSvcLocalField(Controls[CntItem]).Enabled then begin
         TSvcLocalField(Controls[CntItem]).SetFocus;
         break;
      end;
    end;
  end;
end;  // of TPnlTender.FocusFirst

//=============================================================================
// TPnlTenderUnit.ConfigForTenderUnit : configures the components on the panel
// for the current TenderUnit.
//                                  -----
// INPUT   : ObjTenderUnit = TenderUnit to adjust the components for.
//=============================================================================

procedure TPnlTenderUnit.ConfigForTenderUnit (ObjTenderUnit : TObjTenderUnit);
begin  // of TPnlTenderUnit.ConfigForTenderUnit
  SvcLFValUnit.AsFloat := ObjTenderUnit.ValUnit;
  LblDescr.Caption := ObjTenderUnit.TxtDescr;
  Self.ObjTenderUnit := ObjTenderUnit;
end;   // of TPnlTenderUnit.ConfigForTenderUnit

//=============================================================================

procedure TPnlTenderUnit.SvcLFChange (Sender : TObject);
var
  CntCtl           : Integer;          // Counter controls on parent
  ValTotal         : Currency;         // Calculate total for panels
begin  // of TPnlTenderUnit.SvcLFChange
  if SvcLFQtyUnit.Enabled then
    SvcLFValAmount.AsFloat := SvcLFQtyUnit.AsInteger * SvcLFValUnit.AsFloat
  else
    SvcLFQtyUnit.AsInteger := Round (SvcLFValAmount.AsFloat /
                                     SvcLFValUnit.AsFloat);
  ValTotal := 0;
  for CntCtl := 0 to Pred (TabShtTender.SbxCount.ControlCount) do begin
    if TabShtTender.SbxCount.Controls[CntCtl] is TPnlTenderUnit then
      ValTotal := ValTotal +
                  TPnlTenderUnit(TabShtTender.SbxCount.Controls[CntCtl]).
                  SvcLFValAmount.AsFloat;
  end;
  TTabShtCashUnit(TabShtTender).SvcLFValTotalReal.AsFloat := ValTotal;
  if not (FrmTndCaisseMonnaieCA.BtnAccept.Enabled) and (ValTotal > 0) then
    FrmTndCaisseMonnaieCA.BtnAccept.Enabled := True;
end;   // of TPnlTenderUnit.SvcLFChange

//*****************************************************************************
// Implementation of TPnlTenderGroup
//*****************************************************************************

procedure TPnlTenderGroup.CreatePanel (var ValLeft : Integer);
begin  // of TPnlTenderGroup.CreatePanel
  inherited;
  // Component for Description of TenderGroup
  LblDescr := CreateLabel (ValLeft, ViValWidthDescr, '', True);
  if not FlgTitleOnly then begin
    // Create component for theoretic amount of tendergroup
    ValLeft := ViValLeftTheorVal;
    if FlgShowCount then begin
      ValLeft := ValLeft + ViValColWidthThVal - ViValWidthQty;
      SvcLFTheorAmount := CreateSvcLFQty (ValLeft);
    end
    else
      SvcLFTheorAmount := CreateSvcLFVal (ValLeft, ViValWidthThVal);
    SvcLFTheorAmount.Enabled := False;
    // Create component for real amount of tendergroup
    ValLeft := ViValLeftRealVal;
    if FlgShowCount then begin
      ValLeft := ValLeft + ViValColWidthRVal - ViValWidthQty;
      SvcLFRealAmount := CreateSvcLFQty (ValLeft);
    end
    else
      SvcLFRealAmount := CreateSvcLFVal (ValLeft, ViValWidthRVal);
    SvcLFRealAmount.Enabled := True;
    SvcLFRealAmount.OnKeyDown := SvcLFKeyDown;
    SvcLFRealAmount.OnChange  := SvcLFChange;
  end;
  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlTenderGroup.CreatePanel

//=============================================================================
// TPnlTenderGroup.ConfigForTenderGroup : configures the components on the panel
// for the current TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to adjust the components for.
//=============================================================================

procedure TPnlTenderGroup.ConfigForTenderGroup (ObjTenderGroup:TObjTenderGroup);
var
  QtyTotal         : Integer;          // total count
  ValTotal         : Currency;         // total amount
  CntItem          : Integer;          // Counter for safetransaction in
                                       // Lstsafetransaction
  QtyTotalTG       : Integer;          // total of QtyTotal
  ValTotalTG       : Currency;         // total of ValTotal
begin // of TPnlTenderGroup.ConfigForTenderGroup
  LblDescr.Caption := ObjTenderGroup.TxtPublDescr;
  QtyTotalTG := 0;
  ValTotalTG := 0.0;
  if Assigned (LstSafeTransaction) then begin
    for CntItem := 0 to Pred (LstSafeTransaction.Count) do begin
      QtyTotal := 0;
      ValTotal := 0.0;
      LstSafeTransaction.TotalTransDetail
                (LstSafeTransaction.SafeTransaction[CntItem].IdtSafeTransaction,
                 LstSafeTransaction.SafeTransaction[CntItem].NumSeq,
                 ObjTenderGroup.IdtTenderGroup,
                 False,
                 QtyTotal,
                 ValTotal);
      QtyTotalTG := QtyTotalTG + QtyTotal;
      if ((LstSafeTransaction.SafeTransaction[CntItem].CodType = CtCodSttPayOutTender)
      or (LstSafeTransaction.SafeTransaction[CntItem].CodType = CtCodSttPayOutTransfer))and
      (LstSafeTransaction.SafeTransaction[CntItem].IdtCheckOut = CtIdtChangeSafe) then
        ValTotalTG := ValTotalTG - ValTotal
      else
        ValTotalTG := ValTotalTG + ValTotal;
    end;
  end;
  if Assigned (SvcLFTheorAmount) then begin
    if (ObjTenderGroup.IdtTenderGroup = 2) or
    (ObjTenderGroup.IdtTenderGroup = 16) then begin
      DmdFpnUtils.ClearQryInfo;
      DmdFpnUtils.QueryInfo('SELECT ' +
            #10'  TxtParam = RTRIM (TxtParam)' +
            #10'FROM ApplicParam (NOLOCK)' +
            #10'WHERE IdtApplicParam=' +
            AnsiQuotedStr (ObjTenderGroup.TxtPublDescr, ''''));
      SvcLFTheorAmount.AsString :=
          DmdFpnUtils.QryInfo.FieldByName('TxtParam').AsString;
      DmdFpnUtils.CloseInfo;
      FrmTndCaisseMonnaieCA.AddItemToStringlist(Self.ObjTenderGroup,
                      nil, FlgTitleOnly, FlgShowCount,
                      SvcLFTheorAmount.AsInteger, 0);
    end
    else begin
      if FlgShowCount then begin
        SvcLFTheorAmount.AsInteger := QtyTotalTG;
        FrmTndCaisseMonnaieCA.AddItemToStringlist(Self.ObjTenderGroup,
                      nil, FlgTitleOnly, FlgShowCount,
                      QtyTotalTG, 0);
      end
      else begin
        SvcLFTheorAmount.AsFloat := ValTotalTG;
        FrmTndCaisseMonnaieCA.AddItemToStringlist(Self.ObjTenderGroup,
                                                nil, FlgTitleOnly, FlgShowCount,
                                                ValTotalTG, 0);
      end;
    end;
  end;
end;  // of TPnlTenderGroup.ConfigForTenderGroup

//=============================================================================

procedure TPnlTenderGroup.SvcLFChange (Sender : TObject);
begin  // of TPnlTenderGroup.SvcLFChange
end;   // of TPnlTenderGroup.SvcLFChange

//*****************************************************************************
// Implementation of TPnlTenderDetail
//*****************************************************************************

procedure TPnlTenderDetail.CreatePanel (var ValLeft : Integer);
begin  // of TPnlTenderDetail.CreatePanel
  inherited;
  // Component for Description of TenderGroup
  LblDescr := CreateLabel (ValLeft, ViValWidthDescr, '');
  // Create component for theoretic amount of tendergroup
  ValLeft := ViValLeftTheorVal;
  if FlgShowCount then begin
    ValLeft := ValLeft + ViValColWidthThVal - ViValWidthQty;
    SvcLFTheorAmount := CreateSvcLFQty (ValLeft);
  end
  else
    SvcLFTheorAmount := CreateSvcLFVal (ValLeft, ViValWidthThVal);
  SvcLFTheorAmount.Enabled := False;
  // Create component for real amount of tendergroup
  ValLeft := ViValLeftRealVal;
  if FlgShowCount then begin
      ValLeft := ValLeft + ViValColWidthRVal - ViValWidthQty;
    SvcLFRealAmount := CreateSvcLFQty (ValLeft);
  end
  else
    SvcLFRealAmount := CreateSvcLFVal (ValLeft, ViValWidthRVal);
  SvcLFRealAmount.Enabled := True;
  SvcLFRealAmount.OnKeyDown := SvcLFKeyDown;
  SvcLFRealAmount.OnChange  := SvcLFChange;
  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlTenderDetail.CreatePanel

//=============================================================================
// TPnlTenderDetail.ConfigForTenderDetail : configures the components on the
// panel for the current TenderUnit of the current Tendergroup
//                                  -----
// INPUT   : ObjTenderUnit = TenderUnit to adjust the components for.
//=============================================================================

procedure TPnlTenderDetail.ConfigForTenderDetail (ObjTUnit :TObjTenderUnit);
var
  QtyTotal         : Integer;          // total count
  ValTotal         : Currency;         // total amount
  CntST            : Integer;          // Counter for safetransaction in
                                       // Lstsafetransaction
  CntTD            : Integer;          // Counter for safetransdetail in
                                       // LstTransdetail
  QtyTotalTG       : Integer;          // total of QtyTotal
  ValTotalTG       : Currency;         // total of ValTotal
  ObjTransDetail   : TObjTransDetail;  // safetransdetail object
begin // of TPnlTenderDetail.ConfigForTenderDetail
  LblDescr.Caption := CurrToStr (ObjTUnit.ValUnit) + ' ' +
                      ObjTenderGroup.IdtCurrency;
  QtyTotalTG := 0;
  ValTotalTG := 0.0;
  if Assigned (LstSafeTransaction) then begin
    for CntST := 0 to Pred (LstSafeTransaction.Count) do begin
      QtyTotal := 0;
      ValTotal := 0.0;
      CntTD := -1;
      repeat
        ObjTransDetail := LstSafeTransaction.LstTransDetail.NextTransDetail
            (LstSafeTransaction.SafeTransaction[CntST].IdtSafeTransaction,
             LstSafeTransaction.SafeTransaction[CntST].NumSeq,
             ObjTUnit.IdtTenderGroup, CntTD);
        if not Assigned (ObjTransDetail) then
          Break;
        if ObjTransDetail.ValUnit = ObjTUnit.ValUnit then begin
          QtyTotal := QtyTotal + ObjTransDetail.QtyUnit;
          ValTotal := ValTotal +
                      (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
        end;
      until not Assigned (ObjTransDetail);
      QtyTotalTG := QtyTotalTG + QtyTotal;
      ValTotalTG := ValTotalTG + ValTotal;
    end;
  end;
  if Assigned (SvcLFTheorAmount) then begin
    if FlgShowCount then begin
      SvcLFTheorAmount.AsInteger := QtyTotalTG;
      FrmTndCaisseMonnaieCA.AddItemToStringlist (Self.ObjTenderGroup,
                                                 Self.ObjTenderUnit, False,
                                                 FlgShowCount,
                                                 QtyTotalTG, 0);
    end
    else begin
      SvcLFTheorAmount.AsFloat := ValTotalTG;
      FrmTndCaisseMonnaieCA.AddItemToStringlist (Self.ObjTenderGroup,
                                                 Self.ObjTenderUnit, False,
                                                 FlgShowCount,
                                                 ValTotalTG, 0);
    end;
  end;
end;  // of TPnlTenderDetail.ConfigForTenderDetail

//=============================================================================

procedure TPnlTenderDetail.SvcLFChange (Sender : TObject);
begin // of TPnlTenderDetail.SvcLFChange
end;  // of TPnlTenderDetail.SvcLFChange

//*****************************************************************************
// Implementation of TTabShtCashUnit
//*****************************************************************************

constructor TTabShtCashUnit.CreateTabSheet (PgeCtlParent   : TPageControl;
                                            ObjTenderGroup : TObjTenderGroup);
var
  ValLeft          : Integer;          // Var-parameter for CreateHeader
begin  // of TTabShtCashUnit.CreateTabSheet
  inherited CreateTabSheet (PgeCtlParent);
  TabVisible := True;
  Self.ObjTenderGroup := ObjTenderGroup;
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
  Caption := Format ('%s %s', [ObjTenderGroup.TxtPublDescr,
                               ObjTenderGroup.IdtCurrency]);
  ValLeft := ViValStartLeft;
  CreateFooter (ValLeft);
end;   // of TTabShtCashUnit.CreateTabSheet

//=============================================================================
// TTabShtCashUnit.CreateFooter : creates the footer panel for the tabsheet
// INPUT   : ValLeft = where to start on the panel
//=============================================================================


procedure TTabShtCashUnit.CreateFooter (var ValLeft : Integer);
var
  QtyTotal         : Integer;          // total count
  ValTotal         : Currency;         // total amount
  CntItem          : Integer;          // Counter for safetransaction in
                                       // Lstsafetransaction
  ValTotalTG       : Currency;         // total of ValTotal
begin  // of TTabShtCashUnit.CreateFooter
  ValLeft := ViValStartLeft;
  // Label for Total Amount
  CreateLblFooter (ValLeft, CtTxtHdrValTheor + ': ');
  // Component for Total theoretic Amount
  SvcLFValTotalTheor := CreateSvcLFVal (ValLeft, ViValWidthVal);
  // define total theoretic amount for tendergroup cash
  ValTotalTG := 0.0;
  if Assigned (LstSafeTransaction) then begin
    for CntItem := 0 to Pred (LstSafeTransaction.Count) do begin
      QtyTotal := 0;
      ValTotal := 0.0;
      LstSafeTransaction.TotalTransDetail
                (LstSafeTransaction.SafeTransaction[CntItem].IdtSafeTransaction,
                 LstSafeTransaction.SafeTransaction[CntItem].NumSeq,
                 ObjTenderGroup.IdtTenderGroup,
                 False,
                 QtyTotal,
                 ValTotal);
      ValTotalTG := ValTotalTG + ValTotal;
    end;
  end;
  SvcLFValTotalTheor.AsFloat := ValTotalTG;
  FrmTndCaisseMonnaieCA.AddItemToStringlist (Self.ObjTendergroup,
                                             nil, False, False,
                                             ValTotalTG, 0);
  ValLeft := ValLeft + (ViValWidthSpace * 2);
  // Component for Total real Amount
  CreateLblFooter (ValLeft, CtTxtHdrValReal + ': ');
  ValLeft := ViValLeftTheorVal;
  SvcLFValTotalReal := CreateSvcLFVal (ValLeft, ViValWidthVal);
  // Label for Currency abbreviation
  CreateLblFooter (ValLeft, ObjTenderGroup.IdtCurrency);
end;   // of TTabShtCashUnit.CreateFooter

//=============================================================================
// TTabShtCashUnit.CreatePnlTenderUnit : creates the Panel and necessary
// componentsfor a cash unit.
//                                  -----
// INPUT   : ObjTenderUnit = TenderUnit to create the Panel for.
//                                  -----
// FUNCRES : created Panel.
//=============================================================================

function TTabShtCashUnit.CreatePnlTenderUnit (ObjTenderUnit : TObjTenderUnit) :
                                                                 TPnlTenderUnit;
var
  ValLeft          : Integer;          // Left property for new components
begin  // of TTabShtCashUnit.CreatePnlTenderUnit
  Result := TPnlTenderUnit.Create (Owner);
  Result.TabShtTender   := Self;
  Result.ObjTenderGroup := ObjTenderGroup;
  AdjustPnlCount (Result);
  ValLeft := ViValStartLeft;
  Result.CreatePanel (ValLeft);
  Result.ConfigForTenderUnit (ObjTenderUnit);
end;   // of TTabShtCashUnit.CreatePnlTenderUnit

//*****************************************************************************
// Implementation of TTabShtOtherReceipts
//*****************************************************************************

constructor TTabShtOtherReceipts.CreateTabSheet (PgeCtlParent : TPageControl);
var
  ValLeft          : Integer;          // Var-parameter for CreateHeader
begin // of TTabShtOtherReceipts.CreateTabSheet
  inherited CreateTabSheet (PgeCtlParent);
  TabVisible := True;
  Caption    := CtTxtTabShtCaptOther;
  // Header on TabSheet
  // Align the start position of the first headertitle with the amount on the
  // first tabsheet if any.
  ValLeft :=   ViValLeftTheorVal;
  CreateHeader (ValLeft);
end;   // of TTabShtOtherReceipts.CreateTabSheet

//=============================================================================
// TTabShtOtherReceipts.SetFlgShowCount : do we need to show a number or an
// amount in the theoretic column of the panel.  Depends on the tendergroup.
//=============================================================================

function TTabShtOtherReceipts.SetFlgShowCount (ObjTenderGroup : TObjTenderGroup)
                                                                      : Boolean;
begin // of TTabShtOtherReceipts.FlgShowCount
  Result := ObjTenderGroup.IdtTenderGroup in [2, 3, 16];
end;  // of TTabShtOtherReceipts.FlgShowCount

//=============================================================================
// TTabShtOtherReceipts.CreateHeader : creates the header for the TabSheet.
//                                  -----
// INPUT   : ValLeft = Left property for first created header-label.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append header-labels.
//=============================================================================

procedure TTabShtOtherReceipts.CreateHeader (var ValLeft : Integer);
begin  // of TTabShtOtherReceipts.CreateHeader
  // Header Theoretic value
  ValLeft := ViValLeftTheorVal;
  CreateLblHeader (ValLeft, ViValWidthThVal, CtTxtHdrValTheor);
  // Header Real value
  ValLeft := ViValLeftRealVal;
  CreateLblHeader (ValLeft, ViValWidthRVal, CtTxtHdrValReal);
end;   // of TTabShtOtherReceipts.CreateHeader

//*****************************************************************************
// Implementation of TFrmTndCaisseMonnaieCA
//*****************************************************************************

procedure TFrmTndCaisseMonnaieCA.FormActivate(Sender: TObject);
begin // of TFrmTndCaisseMonnaieCA.FormActivate
  inherited;
  if not FlgEverActivated then begin
    SavAppOnIdle := Application.OnIdle;
    Application.OnIdle := OnFirstIdle;
  end;
  FFlgEverActivated := True;
end;  // of TFrmTndCaisseMonnaieCA.FormActivate

//=============================================================================
// Getters/Setters of properties of TFrmTndCaisseMonnaieCA
//=============================================================================

function TFrmTndCaisseMonnaieCA.GetIdtOperReg : string;
begin  // of TFrmTndCaisseMonnaieCA.GetIdtOperReg
  Result := FIdtOperReg;
end;   // of TFrmTndCaisseMonnaieCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.SetIdtOperReg (Value : string);
begin  // of TFrmTndCaisseMonnaieCA.GetIdtOperReg
  FIdtOperReg := Value;
end;   // of TFrmTndCaisseMonnaieCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.SetTxtNameOperReg (Value : string);
begin  // of TFrmTndCaisseMonnaieCA.SetTxtNameOperReg
  FTxtNameOperReg := Value;
  StsBarInfo.Panels[ViNumPnlOperReg].Text := Format ('%s : %s',
                                                     [CtTxtOperReg, Value]);
end;   // of TFrmTndCaisseMonnaieCA.SetTxtNameOperReg

//=============================================================================
// TFrmTndCaisseMonnaieCA.OnFirstIdle : installed as OnIdle Event in OnActivate,
// to execute some things as soon as the application becomes idle.
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.OnFirstIdle (    Sender : TObject;
                                              var Done   : Boolean);
begin // of TFrmTndCaisseMonnaieCA.OnFirstIdle
  Application.OnIdle := SavAppOnIdle;
  if IdtOperReg = '' then
    LogOn;
end;  // of TFrmTndCaisseMonnaieCA.OnFirstIdle

//=============================================================================
// TFrmTndCaisseMonnaieCA.LogOn : LogOn registrating Operator.
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.LogOn;
begin  // of TFrmTndCaisseMonnaieCA.LogOn
  FlgParamTotal := True;
  if SvcTaskMgr.LaunchTask ('LogOn') then begin
    CreateTenderLists;
    PgeCtlCount.Visible := False;
    try
      if not FlgParamTotal then
        CreateSeparateTabSheetCash;
      CreateTabSheetOtherReceipts;
    finally
      PgeCtlCount.Visible := True;
      BtnAccept.Enabled := True;
      TTabShtTender(PgeCtlCount.Pages[0]).FocusFirst;
    end;
  end
  else 
    ModalResult := mrCancel;
end;   // of TFrmTndCaisseMonnaieCA.LogOn

//=============================================================================
// TFrmTndCaisseMonnaieCA.CreateSeparateTabSheetCash : builds one single tabsht
// for tendergroup Cash.  This tabsheet will contain all tenderunits for
// tendergroup Cash
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.CreateSeparateTabSheetCash;
var
  CntItem          : Integer;          // counter items in LstTenderGroup
  CntUnit          : Integer;          // Counter TenderUnit
  ObjTenderUnit    : TObjTenderUnit;   // Current object TenderUnit
  TabShtNew        : TTabShtCashUnit;  // New TabSheet
  ObjTenderGroup   : TObjTenderGroup;  // Current object Tendergroup
begin // of TFrmTndCaisseMonnaieCA.CreateSeparateTabSheetCash
  for CntItem := 0 to Pred (LstTenderGroup.Count) do begin
    if AllowTenderGroup (LstTenderGroup.TenderGroup[CntItem], True) then begin
      ObjTenderGroup := LstTenderGroup.TenderGroup[CntItem];
      TabShtNew := TTabShtCashUnit.CreateTabSheet (PgeCtlCount, ObjTenderGroup);
      TabShtNew.CtlFocusOnExit := BtnAccept;
      TabShtNew.CtlCancel      := BtnCancel;
      CntUnit :=  - 1;
      repeat
        ObjTenderUnit := LstTenderUnit.NextTenderUnit
                         (ObjTenderGroup.IdtTenderGroup, CntUnit);
        if Assigned (ObjTenderUnit) then
        TabShtNew.CreatePnlTenderUnit (ObjTenderUnit);
      until not Assigned (ObjTenderUnit);
    end;
  end;
end;  // of TFrmTndCaisseMonnaieCA.CreateSeparateTabSheetCash

//=============================================================================
// TFrmTndCaisseMonnaieCA.CreateTenderLists : creates and loads from
// database the lists with TenderGroup and TenderUnit, which weren't created
// yet.
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.CreateTenderLists;
var
  IdtLastSTrans    : Integer;          // Last running SafeTransaction
begin  // of TFrmTndCaisseMonnaieCA.CreateTenderLists
  if not Assigned (LstTenderGroup) then begin
    LstTenderGroup := TLstTenderGroup.Create;
    //if FrmMntCaisseMonnaieCA.FlgRemoveChequeKDO then                       //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
     DmdFpnTenderGroupCA.BuildListTenderGroupActive(LstTenderGroup);          //TCS Modification R2012.1--CAFR-suppression mention cheque kdo (sc)
    //else
     //DmdFpnTenderGroup.BuildListTenderGroup (LstTenderGroup);
  end;
  if not Assigned (LstTenderUnit) then begin
    LstTenderUnit := TLstTenderUnit.Create;
    DmdFpnTenderGroup.BuildListTenderUnit (LstTenderUnit);
  end;
  if not Assigned (LstSafeTransaction) then begin
    LstSafeTransaction := TLstSafeTransactionCA.create;
    IdtLastSTrans :=
      DmdFpnSafeTransactionCA.RetrieveRunningSafeTransCashdesk (CtIdtChangeSafe);
    If IdtLastSTrans = 0 then
      MessageDlg (CtTxtWrnNoRunnSafeTrans, mtWarning, [mbOK], 0)
    else
      DmdFpnSafeTransactionCA.BuildListSafeTransactionAndDetail
                                        (LstSafeTransaction, IdtLastSTrans);
  end;
end;   // of TFrmTndCaisseMonnaieCA.CreateTenderLists

//=============================================================================
// TFrmTndCaisseMonnaieCA.CreateTabSheetOtherReceipts : builds one single tabsht
// for all the other tendergroups.  This tabsheet will contain all totals of
// all tendergroups (except the cash-tendergroup if it is already on
// a separate tabsheet)
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.CreateTabSheetOtherReceipts;
var
  TabShtNew        : TTabShtOtherReceipts; // New TabSheet
  CntItem          : Integer;          // counter items in LstTenderGroup
  ObjTenderGroup   : TObjTenderGroup;  // current object tendergroup
begin // of TFrmTndCaisseMonnaieCA.CreateTabSheetOtherReceipts
  TabShtNew := TTabShtOtherReceipts.CreateTabSheet (PgeCtlCount);
  TabShtNew.CtlFocusOnExit := BtnAccept;
  TabShtNew.CtlCancel      := BtnCancel;
  for CntItem := 0 to Pred (LstTenderGroup.Count) do begin
    ObjTenderGroup := LstTenderGroup.TenderGroup[CntItem];
    if ObjTenderGroup.CodType = 0 then begin
      if FlgParamTotal and AllowTenderGroup (ObjTenderGroup, True) then
        TabShtNew.CreatePnlTenderGroup (ObjTenderGroup, False);
    end
    else begin
      if AllowTenderGroup (ObjTenderGroup, False) then begin
        if FlgShowTenderUnits (ObjTenderGroup) then begin
          TabShtNew.CreatePnlTenderGroup (ObjTenderGroup, True);
          TabShtNew.CreateDetailPanelsForTenderGroup (ObjTenderGroup)
        end
        else
          TabShtNew.CreatePnlTenderGroup (ObjTenderGroup, False);
      end;
    end;
  end; // for CntItem := 0 to ...
end;  // of TFrmTndCaisseMonnaieCA.CreateTabSheetOtherReceipts

//=============================================================================
// TTabShtOtherReceipts.CreatePnlTenderGroup : creates a panel on the
// 'other receipts'-tabsheet
//                                  -----
// INPUT   : ObjTenderGroup = object tendergroup for which the panel should be
//                            created
//=============================================================================

function TTabShtOtherReceipts.CreatePnlTenderGroup
                        (ObjTenderGroup: TObjTenderGroup;
                         FlgTitleOnly  : Boolean) : TPnlTenderGroup;
var
  ValLeft          : Integer;          // Left property for new components
begin // of TTabShtOtherReceipts.CreatePnlTenderGroup
  Result := TPnlTenderGroup.Create (Owner);
  Result.TabShtTender   := Self;
  Result.ObjTenderGroup := ObjTenderGroup;
  Result.FlgTitleOnly   := FlgTitleOnly;
  Result.FlgShowCount   := SetFlgShowCount (ObjTendergroup);
  AdjustPnlCount (Result);
  ValLeft := ViValStartLeft;
  Result.CreatePanel (ValLeft);
  Result.ConfigForTenderGroup (ObjTenderGroup);
end;  // of TTabShtOtherReceipts.CreatePnlTenderGroup

//=============================================================================

procedure TTabShtOtherReceipts.CreateDetailPanelsForTenderGroup
                                           (ObjTenderGroup : TObjTenderGroup);
var
  CntUnit          : Integer;          // counter for items in LstTenderUnit
  ObjTenderUnit    : TObjTenderUnit;   // current object TenderUnit
begin // of TTabShtOtherReceipts.CreateDetailPanelsForTenderGroup
  CntUnit :=  - 1;
  repeat
    ObjTenderUnit := LstTenderUnit.NextTenderUnit
                     (ObjTenderGroup.IdtTenderGroup, CntUnit);
    if Assigned (ObjTenderUnit) then
      CreatePnlTenderDetail (ObjTenderGroup, ObjTenderUnit);
  until not Assigned (ObjTenderUnit);
end;  // of TTabShtOtherReceipts.CreateDetailPanelsForTenderGroup

//=============================================================================
// TTabShtOtherReceipts.CreatePnlTenderDetail
//                                  -----
// INPUT   : ObjTenderGroup = object TenderGroup linked to this panel
//           ObjTenderUnit  = object TenderUnit linked to this panel
//                                  -----
// OUTPUT  : created object PnlTenderDetail
//=============================================================================

function TTabShtOtherReceipts.CreatePnlTenderDetail
                                   (ObjTenderGroup : TObjTenderGroup;
                                    ObjTenderUnit  : TObjTenderUnit)
                                                             : TPnlTenderDetail;
var
  ValLeft          : Integer;          // Left property for new components
begin // of TTabShtOtherReceipts.CreatePnlTenderDetail
  Result := TPnlTenderDetail.Create (Owner);
  Result.TabShtTender   := Self;
  Result.ObjTenderUnit  := ObjTenderUnit;
  Result.ObjTenderGroup := ObjTenderGroup;
  Result.FlgShowCount   := SetFlgShowCount (ObjTendergroup);
  AdjustPnlCount (Result);
  ValLeft := ViValStartLeft;
  Result.CreatePanel (ValLeft);
  Result.ConfigForTenderDetail (ObjTenderUnit);
end;  // of TTabShtOtherReceipts.CreatePnlTenderDetail

//=============================================================================
// TFrmTndCaisseMonnaieCA.AllowTenderGroup : checks if a TenderGroup is allowed
// for the passed function.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to check for.
//           FlgCash        = check for Cash tendergroups
//                                  -----
// FUNCRES : True if TenderGroup is allowed;
//           False if TenderGroup is not allowed.
//=============================================================================

function TFrmTndCaisseMonnaieCA.AllowTenderGroup
                                  (ObjTenderGroup : TObjTenderGroup;
                                   FlgCash        : Boolean) : Boolean;
var
  NumCounter       : integer;          // Counter to use in a loop
begin // of TFrmTndCaisseMonnaieCA.AllowTenderGroup
  Result := False;
  for NumCounter := 0 to StrLstReceipts.Count - 1 do begin
    if StrLstReceipts[NumCounter] = IntToStr(ObjTenderGroup.IdtTenderGroup)
       then
      Result := True;
  end;
end;  // of TFrmTndCaisseMonnaieCA.AllowTenderGroup

//=============================================================================
// TFrmTndCaisseMonnaieCA.FlgShowTenderUnits : checks if the tenderunits of a
// TenderGroup are to be shown in detail on different panels.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to check for.
//           FlgCash        = check for Cash tendergroups
//                                  -----
// FUNCRES : True if Detail of TenderGroup (tenderunits) are to be shown
//           otherwise False.
//=============================================================================

function TFrmTndCaisseMonnaieCA.FlgShowTenderUnits
                                        (ObjTenderGroup : TObjTenderGroup)
                                                        : Boolean;
begin // of TFrmTndCaisseMonnaieCA.FlgShowTenderUnits
  Result := False;
end;  // of TFrmTndCaisseMonnaieCA.FlgShowTenderUnits

//=============================================================================
// TFrmTndCaisseMonnaieCA.BtnAcceptClick : confirms the transfer of caisse
// monnaie.
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.BtnAcceptClick(Sender: TObject);
begin // of TFrmTndCaisseMonnaieCA.BtnAcceptClick
  InsertFinalCount;
  PrintReport;
  ModalResult := mrOk;
end;  // of TFrmTndCaisseMonnaieCA.BtnAcceptClick

//=============================================================================
// TFrmTndCaisseMonnaieCA.InsertFinalCount : finalizes the last running
// transaction with a final count registration.
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.InsertFinalCount;
var
  IdtLastSTrans : Integer;             // running SafeTransaction
  NumSeq        : Integer;             // new sequence number for
  CntItem       : Integer;             // Counter transdetail
  ObjSafeTrans  : TObjSafetransaction; // SafeTransaction
  IdtNewSTrans  : Integer;             // New SafeTransaction
begin // of TFrmTndCaisseMonnaieCA.InsertFinalCount
  IdtLastSTrans :=
  DmdFpnSafeTransactionCA.RetrieveRunningSafeTransCashdesk (CtIdtChangeSafe);
  if IdtLastSTrans > 0 then begin
    // find last numseq
    NumSeq := DmdFpnSafeTransactionCA.RetrieveMaxNumSeq (IdtLastSTrans) + 1;
    // create a final count in the running safetransaction
    ObjSafeTrans := LstSafeTransaction.AddSafeTransaction
    (IdtLastSTrans, NumSeq, CtCodSttFinalCount, CtCodDbsNew);
    ObjSafeTrans.IdtCheckout := CtIdtChangeSafe;
    ObjSafeTrans.IdtOperator := '';
    ObjSafeTrans.IdtOperReg := IdtOperReg;
    ObjSafeTrans.DatReg := Now;
    ObjSafeTrans.IdtCurrency := DmdFpnUtils.IdtCurrencyMain;
    ObjSafeTrans.ValExchange := DmdFpnUtils.ValExchangeCurrencyMain;
    ObjSafeTrans.FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
    // Add Items into final count
    AddDetailCount (TLstSafeTransactionCA (LstSafeTransaction), ObjSafeTrans);
    // set the FlgTransfer of all TransDetail for the running SafeTrans to True
    for CntItem := 0 to Pred (LstSafeTransaction.LstTransDetail.Count) do
      LstSafeTransaction.LstTransDetail.TransDetail[CntItem].FlgTransfer := True;
      DmdFpnSafeTransactionCA.InsertLstSafeTransaction (LstSafeTransaction);
      DmdFpnSafeTransactionCA.UpdateLstSafeTransaction (LstSafeTransaction, [],
                                                          ['FlgTransfer']);
  end;
  IdtNewSTrans := DmdFpnUtils.GetNextCounter(CtTxtACSafeTransactionIdtAC,
                                           CtTxtACSafeTransactionField);
  // find last numseq
  NumSeq := DmdFpnSafeTransactionCA.RetrieveMaxNumSeq (IdtNewSTrans) + 1;
  // create a new running safetransaction
  ObjSafeTrans := LstSafeTransaction.AddSafeTransaction
    (IdtNewSTrans, NumSeq, CtCodSttPayInTender, CtCodDbsNew);
  ObjSafeTrans.IdtCheckout := CtIdtChangeSafe;
  ObjSafeTrans.IdtOperator := '';
  ObjSafeTrans.IdtOperReg := IdtOperReg;
  ObjSafeTrans.DatReg := Now;
  ObjSafeTrans.IdtCurrency := DmdFpnUtils.IdtCurrencyMain;
  ObjSafeTrans.ValExchange := DmdFpnUtils.ValExchangeCurrencyMain;
  ObjSafeTrans.FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
  // add to LstTransdetail
  AddDetailCount (TLstSafeTransactionCA (LstSafeTransaction), ObjSafeTrans);
  // save to database
  DmdFpnSafeTransactionCA.InsertLstSafeTransaction (LstSafeTransaction);

  AddRealValuesToStringList (TLstSafeTransactionCA (LstSafeTransaction),
                                 ObjSafeTrans);
end;  // of TFrmTndCaisseMonnaieCA.InsertFinalCount

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.AddDetailCount
                                          (LstSafeTrans : TLstSafeTransactionCA;
                                           ObjSafeTrans : TObjSafeTransaction);
var
  CntTabSht        : Integer;          // Tabsheet container
  CntPnlTender     : Integer;          // Tender panels
  ObjTransDet      : TObjTransDetail;  // Object to add
  PnlTenderUnit    : TPnlTenderUnit;   // Tender panel to safe
  PnlTenderDetail  : TPnlTenderDetail; // Tender panel to safe
  PnlTenderGroup   : TPnlTenderGroup;  // Tender panel to safe
  FlgValidValue    : Boolean;          // flag if value in panel is filled in
  QtyTotal         : Integer;          // quantity total for transdetail
  ValTotal         : Currency;         // value total for transdetail
begin  // of TFrmTndCaisseMonnaieCA.AddDetailCount
  for CntTabSht := 0 to Pred(PgeCtlCount.PageCount) do begin
    for CntPnlTender := 0 to Pred (TTabShtTender
            (PgeCtlCount.Pages[CntTabSht]).SbxCount.ControlCount) do begin
      // is it a tendergroup panel on 'other receipts' tabsheet ?
      if (TTabShtTender (PgeCtlCount.Pages[CntTabSht])
                .SbxCount.Controls[CntPnlTender]  is TPnlTenderGroup) then begin
        PnlTenderGroup := TPnlTenderGroup (TTabShtTender
               (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);
        if (PnlTenderGroup.ObjTenderGroup.IdtTenderGroup = 2) or
        (PnlTenderGroup.ObjTenderGroup.IdtTenderGroup = 16) then begin
          DmdFpnUtils.ClearQryInfo;
          DmdFpnUtils.AddSQLUpdateSysPrm(PnlTenderGroup.LblDescr.Caption, 0,
                                 PnlTenderGroup.SvcLFRealAmount.AsString, '');
          DmdFpnUtils.ExecQryInfo;
        end
        else begin
          if not PnlTenderGroup.FlgTitleOnly then begin
            if PnlTenderGroup.FlgShowCount then
              FlgValidValue := PnlTenderGroup.SvcLFRealAmount.AsInteger > 0
            else FlgValidValue :=
                         PnlTenderGroup.SvcLFRealAmount.AsFloat > CtValMinFloat;
            if FlgValidValue then begin
              ObjTransDet := LstSafeTrans.LstTransDetail.AddTransDetail
                                    (ObjSafeTrans.IdtSafeTransaction,
                                     ObjSafeTrans.NumSeq, 0,
                                     PnlTenderGroup.ObjTenderGroup.IdtTenderGroup,
                                     CtCodDbsNew);
              ObjTransDet.TxtDescr := PnlTenderGroup.ObjTenderGroup.TxtPublDescr;
              ObjTransDet.IdtCurrency :=
                                      PnlTenderGroup.ObjTenderGroup.IdtCurrency;
              if PnlTenderGroup.FlgShowCount then begin
                ObjTransDet.QtyUnit := PnlTenderGroup.SvcLFRealAmount.AsInteger;
                ValTotal := 0;
                LstSafetrans.TotalTransDetail
                 (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq,
                  PnlTenderGroup.ObjTenderGroup.IdtTenderGroup, False, QtyTotal,
                  ValTotal);
                ObjTransDet.ValUnit := ValTotal / ObjTransDet.QtyUnit;
              end
              else begin
                ObjTransDet.QtyUnit := 1;
                ObjTransDet.ValUnit := PnlTenderGroup.SvcLFRealAmount.AsFloat;
              end;
              ObjTransDet.ValExchange :=
                                  PnlTenderGroup.ObjTenderGroup.ValExchange;
              ObjTransDet.FlgExchMultiply :=
                                  PnlTenderGroup.ObjTenderGroup.FlgExchMultiply;
            end;
          end
        end;
      end
      // is it a panel on 'espèces' tabsheet ?
      else if (TTabShtTender(PgeCtlCount.Pages[CntTabSht]).
                   SbxCount.Controls[CntPnlTender] is TPnlTenderUnit) then begin
        PnlTenderUnit := TPnlTenderUnit (TTabShtTender
              (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);
       if PnlTenderUnit.SvcLFValAmount.AsFloat > CtValMinFloat then begin
          ObjTransDet := LstSafeTrans.LstTransDetail.AddTransDetail
                                   (ObjSafetrans.IdtSafeTransaction,
                                    ObjSafetrans.NumSeq, 0,
                                    PnlTenderUnit.ObjTenderGroup.IdtTenderGroup,
                                    CtCodDbsNew);
          ObjTransDet.TxtDescr := PnlTenderUnit.ObjTenderUnit.TxtDescr;
          ObjTransDet.IdtCurrency := PnlTenderUnit.ObjTenderGroup.IdtCurrency;
          ObjTransDet.QtyUnit := PnlTenderUnit.SvcLFQtyUnit.AsInteger;
          ObjTransDet.ValUnit := PnlTenderUnit.SvcLFValUnit.AsFloat;
          ObjTransDet.ValExchange := PnlTenderUnit.ObjTenderGroup.ValExchange;
          ObjTransDet.FlgExchMultiply :=
                                   PnlTenderUnit.ObjTenderGroup.FlgExchMultiply;
       end;
      end
      // is it a tendergroup detail panel on 'other receipts' tabsheet ?
      else if (TTabShtTender(PgeCtlCount.Pages[CntTabSht]).
                 SbxCount.Controls[CntPnlTender] is TPnlTenderDetail) then begin
        PnlTenderDetail := TPnlTenderDetail (TTabShtTender
               (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);
        if PnlTenderDetail.SvcLFRealAmount.AsFloat > CtValMinFloat then begin
          if PnlTenderDetail.FlgShowCount then
            FlgValidValue := PnlTenderDetail.SvcLFRealAmount.AsInteger > 0
          else FlgValidValue :=
                        PnlTenderDetail.SvcLFRealAmount.AsFloat > CtValMinFloat;
          if FlgValidValue then begin
            ObjTransDet := LstSafeTrans.LstTransDetail.AddTransDetail
                                 (ObjSafetrans.IdtSafeTransaction,
                                  ObjSafetrans.NumSeq, 0,
                                  PnlTenderDetail.ObjTenderGroup.IdtTenderGroup,
                                  CtCodDbsNew);
            ObjTransDet.TxtDescr := PnlTenderDetail.ObjTenderUnit.TxtDescr;
            ObjTransDet.IdtCurrency :=
                                   PnlTenderDetail.ObjTenderGroup.IdtCurrency;
            if PnlTenderDetail.FlgShowCount then begin
              ObjTransDet.QtyUnit := PnlTenderDetail.SvcLFRealAmount.AsInteger;
              ObjTransDet.ValUnit := PnlTenderDetail.ObjTenderUnit.ValUnit;
            end
            else begin
              ObjTransDet.QtyUnit := 1;
              ObjTransDet.ValUnit := PnlTenderDetail.SvcLFRealAmount.AsFloat;
            end;
            ObjTransDet.ValExchange :=
                                 PnlTenderDetail.ObjTenderGroup.ValExchange;
            ObjTransDet.FlgExchMultiply :=
                                 PnlTenderDetail.ObjTenderGroup.FlgExchMultiply;
          end;
        end;
      end
    end;
  end;
end;   // of TFrmTndCaisseMonnaieCA.AddDetailCount

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.AddRealValuesToStringList
                                          (LstSafeTrans : TLstSafeTransactionCA;
                                           ObjSafeTrans : TObjSafeTransaction);
var
  CntTabSht        : Integer;          // Tabsheet container
  CntPnlTender     : Integer;          // Tender panels
  PnlTenderUnit    : TPnlTenderUnit;   // Tender panel to safe
  PnlTenderDetail  : TPnlTenderDetail; // Tender panel to safe
  PnlTenderGroup   : TPnlTenderGroup;  // Tender panel to safe
  FlgValidValue    : Boolean;          // flag if value in panel is filled in
begin  // of TFrmTndCaisseMonnaieCA.AddRealValuesToStringList
  for CntTabSht := 0 to Pred (PgeCtlCount.PageCount) do begin
    for CntPnlTender := 0 to Pred (TTabShtTender
            (PgeCtlCount.Pages[CntTabSht]).SbxCount.ControlCount) do begin
      // is it a tendergroup panel on 'other receipts' tabsheet ?
      if (TTabShtTender(PgeCtlCount.Pages[CntTabSht])
                .SbxCount.Controls[CntPnlTender]  is TPnlTenderGroup) then begin
        PnlTenderGroup := TPnlTenderGroup (TTabShtTender
               (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);
        if not PnlTenderGroup.FlgTitleOnly then begin
          if PnlTenderGroup.FlgShowCount then
            FlgValidValue := PnlTenderGroup.SvcLFRealAmount.AsInteger > 0
          else FlgValidValue :=
                        PnlTenderGroup.SvcLFRealAmount.AsFloat > CtValMinFloat;
          if FlgValidValue then
            AdjustItemStringlist (PnlTenderGroup.ObjTenderGroup, nil,
                                  PnlTenderGroup.SvcLFRealAmount.AsFloat);
        end;
      end
      // is it a tendergroup detail panel on 'other receipts' tabsheet ?
      else if (TTabShtTender(PgeCtlCount.Pages[CntTabSht]).
                 SbxCount.Controls[CntPnlTender] is TPnlTenderDetail) then begin
        PnlTenderDetail := TPnlTenderDetail (TTabShtTender
               (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);
        if PnlTenderDetail.SvcLFRealAmount.AsFloat > CtValMinFloat then begin
          if PnlTenderDetail.FlgShowCount then
            FlgValidValue := PnlTenderDetail.SvcLFRealAmount.AsInteger > 0
          else FlgValidValue :=
                        PnlTenderDetail.SvcLFRealAmount.AsFloat > CtValMinFloat;
          if FlgValidValue then
            AdjustItemStringlist (PnlTenderDetail.ObjTenderGroup,
                                  PnlTenderDetail.ObjTenderUnit,
                                  PnlTenderDetail.SvcLFRealAmount.AsVariant);
        end;
      end
      else if (TTabShtTender(PgeCtlCount.Pages[CntTabSht]).
                 SbxCount.Controls[CntPnlTender] is TPnlTenderUnit) then begin
        PnlTenderUnit := TPnlTenderUnit (TTabShtTender
               (PgeCtlCount.Pages[CntTabSht]).SbxCount.Controls [CntPnlTender]);

            AdjustItemStringlist (PnlTenderUnit.ObjTenderGroup,
                                  nil,
                                  TTabShtCashUnit(PgeCtlCount.Pages[CntTabSht])
                                  .SvcLFValTotalReal.AsVariant);
      end
    end;
  end;
end;   // of TFrmTndCaisseMonnaieCA.AddRealValuesToStringList

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.PrintReport;
begin // of TFrmTndCaisseMonnaieCA.PrintReport
  SvcTaskMgr.LaunchTask('Report');
end;  // of TFrmTndCaisseMonnaieCA.PrintReport

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.AddItemToStringlist
                                            (ObjTendergroup : TObjTenderGroup;
                                             ObjTenderUnit  : TObjTenderUnit;
                                             FlgShowTitle   : Boolean;
                                             FlgShowCount   : Boolean;
                                             ValTheor       : Variant;
                                             ValReal        : Variant);
var
  ObjDetailLine    : TRptDetailLine;   // data detail line report
  TxtIdtTenderUnit : string;           // string for IdtTenderunit
begin // of TFrmTndCaisseMonnaieCA.AddItemToStringlist
  if not Assigned (StrLstBody) then
    StrLstBody := TStringList.Create;
  ObjDetailLine := TRptDetailLine.Create;
  ObjDetailLine.ObjTendergroup := ObjTendergroup;
  ObjDetailLine.ObjTenderUnit  := nil;
  TxtIdtTenderUnit := '';
  if Assigned (ObjTenderUnit) then begin
    ObjDetailLine.ObjTenderUnit  := ObjTenderUnit;
    TxtIdtTenderUnit := ';' + FloatToStr (ObjTenderUnit.ValUnit);
  end;

  ObjDetailLine.FlgShowTitle   := FlgShowTitle;
  ObjDetailLine.FlgShowCount   := FlgShowCount;
  if FlgShowCount then begin
    ObjDetailLine.QtyTheor := Integer(ValTheor);
    ObjDetailLine.QtyReal  := Integer(ValReal);
  end
  else begin
    ObjDetailLine.ValTheor := TVarData(ValTheor).VCurrency;
    ObjDetailLine.ValReal  := TVarData(ValReal).VCurrency;
  end;
  StrLstBody.AddObject (IntToStr (ObjTendergroup.IdtTendergroup) +
                        TxtIdtTenderUnit,ObjDetailLine);

end;  // of TFrmTndCaisseMonnaieCA.AddItemToStringlist

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.AdjustItemStringlist
                                            (ObjTendergroup : TObjTenderGroup;
                                             ObjTenderUnit  : TObjTenderUnit;
                                             ValReal        : Variant);
var
  CntItem          : Integer;          // counter stringlist
  TxtCompare       : string;           // string to compare with
  TxtIdtTenderUnit : string;           // string for IdtTenderunit
begin  // of TFrmTndCaisseMonnaieCA.AdjustItemStringlist
  if Assigned (StrLstBody) then begin
    for CntItem := 0 to Pred (StrLstBody.Count) do begin
      TxtIdtTenderUnit := '';
      if Assigned (ObjTenderUnit) then
        TxtIdtTenderUnit := ';' + FloatToStr (ObjTenderUnit.ValUnit);
      TxtCompare := IntToStr (ObjTendergroup.IdtTenderGroup) + TxtIdtTenderUnit;
      if AnsiCompareText (TxtCompare, StrLstBody.Strings[CntItem]) = 0 then begin
        if TRptDetailLine(StrLstBody.Objects[CntItem]).FlgShowCount then
          TRptDetailLine(StrLstBody.Objects[CntItem]).QtyReal := ValReal
        else
          TRptDetailLine(StrLstBody.Objects[CntItem]).ValReal := ValReal;
        break;
      end;
    end;
  end;
end;   // of TFrmTndCaisseMonnaieCA.AdjustItemStringlist
//=============================================================================

procedure TFrmTndCaisseMonnaieCA.FillLstReceipts;
var
  TxtSql           : string;           // insert temporary sqlstring
  TxtResult        : string;           // Result of the query
  TxtSearch        : string;           // Cashdesk to be searched
begin  // of TFrmTndCaisseMonnaieCA.FillLstReceipts
  inherited;
  TxtSql := 'SELECT TxtParam FROM ApplicParam' +
      #13#10'WHERE IdtApplicParam = ' + AnsiQuotedStr('LstCaisseMonnaie', '''');
  try
    if DmdFpnUtils.QueryInfo(TxtSql) then begin  // Records found
      TxtResult := DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString;
      // Loop all cashdesks with Formation Mode and remove from cashdesklist
      while AnsiPos(',', TxtResult) <> 0 do begin
        TxtSearch := Copy(TxtResult, 0, AnsiPos(',', TxtResult) - 1);
        StrLstReceipts.Add(TxtSearch);
        TxtResult := Copy(TxtResult, AnsiPos(',', TxtResult) + 1,
                          length(TxtResult) - AnsiPos(',', TxtResult));
      end;  // of while..do
      if TxtResult <> '' then
        StrLstReceipts.Add(TxtResult)
    end;  // of if..then
  finally
    DmdFpnUtils.ClearQryInfo;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmTndCaisseMonnaieCA.FillLstReceipts

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.FormCreate(Sender: TObject);
begin  // of TFrmTndCaisseMonnaieCA.FormCreate
  inherited;
  if not Assigned (StrLstReceipts) then
    StrLstReceipts := TStringList.Create;
  FillLstReceipts;
end;   // of TFrmTndCaisseMonnaieCA.FormCreate

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.FormDestroy(Sender: TObject);
begin  // of TFrmTndCaisseMonnaieCA.FormDestroy
  inherited;
  StrLstReceipts.Destroy;
  StrLstReceipts := nil;
end;   // of TFrmTndCaisseMonnaieCA.FormDestroy

//=============================================================================

procedure TFrmTndCaisseMonnaieCA.OvcCtlCountIsSpecialControl(Sender: TObject;
  Control: TWinControl; var Special: Boolean);
begin  // of TFrmTndCaisseMonnaieCA.OvcCtlCountIsSpecialControl
  inherited;
  if Control = BtnCancel then
    Special := True;
end;   // of TFrmTndCaisseMonnaieCA.OvcCtlCountIsSpecialControl

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.

