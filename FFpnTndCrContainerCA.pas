//========Copyright 2009 (c) Centric Retail Solutions. All rights reserved.====
// Packet   : FlexPoint 2.0
// Unit     : FFpnTndCrContainerCA = Form FlexPoiNt CReate CONTAINER CAstorama
//            Collecting bags into a container for the Tender module.
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndCrContainerCA.pas,v 1.2 2009/09/16 15:56:42 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - Flexpoint 2.0 - FFpnTndCrContainerCA - CVS revision 1.1
// Version            Modified By          Reason
// 1.11               TK   (TCS)           R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques
//=============================================================================

unit FFpnTndCrContainerCA;

//*****************************************************************************

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Messages,
  OvcBase, ComCtrls, StdCtrls, Buttons, OvcPF, ScUtils, ExtCtrls,
  DFpnTenderGroup, SfCommon, DFpnSafeTransaction, DFpnSafeTransactionCA,
  DFpnTender, DFpnBagCA, OvcEF, OvcPB;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring  // some general resourcestrings for messaging
  CtTxtNoBags               = 'No bags available';

resourcestring  // Resourcestrings for captions on Header and Footer panel
  CtTxtHdrBagNumber         = 'Bagnumber';
  CtTxtHdrDate              = 'Date';
  CtTxtHdrOper              = 'Operator';
  CtTxtHdrTotalAmount       = 'Total amount';
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  CtTxtHdrNbrCheq           = 'Nbr Cheques';
  CtTxtHdrTotalNbrCheq      = 'Total Nbr Cheques';
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
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
  CtMaxBags               = 11;                 // max number of bags in column
                                                // before it is split on a
                                                // second column
  CtTxtPTndCrContainer    = '96';

//=============================================================================
// Panels on statusbar
//=============================================================================

var
  ViNumPnlOperReg  : Integer = 2;      // Pnl show registrating operator

//=============================================================================
// Width of at runtime created components
//=============================================================================

var
  ViValWidthSpace   : Integer =   5;   // Width between 2 components
  ViValWidthBag     : Integer =  80;   // Width of component for bagnumber
  ViValWidthAccount : Integer =  10;   // Width of component for Accountancy
  ViValWidthVal     : Integer =  60;   // Width of component for value
  ViValWidthDate    : Integer =  35;   // Width of component for date
  ViValWidthIdtOper : Integer =  80;   // Width of component for idtoperator    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  ViValWidthIdtOperHdr : Integer = 80; // Width of the header of operator
  ViValWidthNbrCheqHdr : Integer = 100; // Width of the header for number of cheques   //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  ViValWidthNbrCheq : Integer = 60;     // Width of the component for number of cheques  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

//R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
var
  ViFlgNoBagCheques : Boolean = False;  // Flag for identifying the requirement
//R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End

//*****************************************************************************
// Components at run time created
//*****************************************************************************

//=============================================================================
// Declaration of later defined types
//=============================================================================

type
  TTabShtTender    = class;

//=============================================================================
// TPnlBag : common parent panel to administer a Bag within a Tendergroup
//=============================================================================

  TPnlBag          = class (TPanel)
  protected
    // Visual components on panel
    FLblBagNumber       : TLabel;           // Bagnumber
    FSvcLFValBag        : TSvcLocalField;   // Amount of money that's in the bag
    FLblDate            : TLabel;           // Date
    FLblIdtOper         : TLabel;           // IdtOperator
    FLblAccountancy     : TLabel;           // Indication of origin Accountancy
    FLblNbrCheques      : TLabel;           // Number of cheques                //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
    // Datafields
    FTabShtTender       : TTabShtTender;    // TabSheet where Panel belongs to
  public
    // Methods for components on the Panel
    function CreateLabel (var ValLeft    : Integer;
                              ValWidth   : Integer;
                              TxtCaption : string ) : TLabel; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    procedure CreateForTender (var ValLeft : Integer;
                                   FlgLeft : Boolean); virtual;
    procedure DataToBag (ObjBag : TObjBagCA); virtual;
    // Properties
    property LblBagNumber : TLabel read  FLblBagNumber
                                   Write FLblBagNumber;
    property SvcLFValBag : TSvcLocalField read  FSvcLFValBag
                                           write FSvcLFValBag;
    property LblDate : TLabel  read  FLblDate
                               write FLblDate;
    property LblIdtOper : TLabel read  FLblIdtOper
                                 write FLblIdtOper;
    property LblAccountancy : TLabel read  FLblAccountancy
                                     write FLblAccountancy;
     property LblNbrCheques :  TLabel read FLblNbrCheques                       //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
                                     write FLblNbrCheques;
    property TabShtTender : TTabShtTender read  FTabShtTender
                                          write FTabShtTender;
  end;  // of TPnlBag

//=============================================================================
// TTabShtTender : TabSheet to administer a collection of Bags
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
    FLstBag             : TLstBagCA;        // List containing the bags for a
                                            // specific TenderGroup.
    FFlgAllLeftColumn   : Boolean;          // True if there are less than 11
                                            // bags -> so  we have to put them
                                            // all in the left scrollbox for
                                            // esthetic reasons.
    FFlgLeftcolumn      : Boolean;          // If true put a new bagpanel in
                                            // the left scrollbox else the right
    FSvcLFValTotal      : TSvcLocalField;   // Total count currency group
    FSvcLFValAmount     : TSvcLocalField;   // Total amount currency group
    FSvcLFNbrCheq       : TSvcLocalField;   // Total number of cheques          //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
    FPnlFtrAmount       : TPanel;           // Panel Footer amount
    FPnlFtrCheques      : TPanel;           // Panel footer cheques             //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
    FOnChange           : TNotifyEvent;
  public
    // Constructor and destructor
    constructor CreateForTender (PgeCtlParent   : TPageControl;
                                 ObjTenderGroup : TObjTenderGroup); virtual;
    destructor Destroy; override;
    // Methods for components on the TabSheet
    procedure OnChange (    Sender    : TObject; var NewWidth : Integer;
                        var NewHeight : Integer; var Resize: Boolean); virtual;
    function CreateBagPanel (ObjBag  : TObjBagCA;
                             FlgLeft : Boolean) : TPnlBag; virtual;
    procedure AdjustScrollBarRange (ValHorz : Integer;
                                    ValVert : Integer); virtual;
    function CreateLblHeader (var ValLeft    : Integer;
                                  ValWidth   : Integer;
                                  TxtCaption : string ;
                                  PnlHeader  : TPanel) : TLabel; virtual;
    function CreateLblFooter (var ValLeft    : Integer;
                                  TxtCaption : string) : TLabel; virtual;
    function CreateSvcLFVal (var ValLeft : Integer) : TSvcLocalField; virtual;
    procedure CreateHeader (var ValLeft : Integer); virtual;
    function CreatePnlAmount (CtlParent : TWinControl;
                              ValLeft   : Integer;
                              ValWidth  : Integer) : TPanel; virtual;
    procedure CreateFooter (var ValLeft : Integer); virtual;

    procedure AdjustPnlBag (PnlBag    : TPnlBag;
                            FlgLeft   : Boolean); virtual;
    procedure AddContainerToBags (IdtContainer : string); virtual;
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
    property LstBag           : TLstBagCA       read  FLstBag
                                                write FLstBag;
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
    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
    property SvcLFNbrCheq     : TSvcLocalField  read  FSvcLFNbrCheq
                                                write FSvcLFNbrCheq;

    property PnlFtrCheques    : TPanel          read  FPnlFtrCheques
                                                write FPnlFtrCheques;
    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  end;  // of TTabShtTender

type
  TFrmTndCrContainerCA = class (TFrmcommon)
    PnlTop: TPanel;
    LblFunc: TLabel;
    PnlBottom: TPanel;
    BtnAccept: TBitBtn;
    BtnCancel: TBitBtn;
    PgeCtlTender: TPageControl;
    StsBarInfo: TStatusBar;
    OvcCtlCount: TOvcController;
    procedure OvcCtlCountIsSpecialControl(Sender: TObject; Control: TWinControl;
      var Special: Boolean);
    procedure FormActivate (Sender: TObject);
    procedure FormCreate (Sender: TObject);
    procedure BtnAcceptClick (Sender: TObject);
    procedure FormDestroy (Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    { Protected declarations }
    SavAppOnIdle        : TIdleEvent;      // Save original OnIdle evt hndlr
    FFlgEverActivated   : Boolean;         // Indicates first time activated
    FIdtOperReg         : string;          // IdtOperator registrating
    FTxtNameOperReg     : string;          // Name operator

    // some values to pass to the form AskContainerCA
    FObjTenderGroup     : TObjTenderGroup; // TenderGroup object
    FQtyTotal           : Currency;        // Number of bags on tabsheet
    FValTotal           : Currency;        // Total amount of bags on tabsheet
    FIdtContainer       : string;          // Container to store the bags into
                                           // Will be returned by
                                           // form AskContainer
    FQtyCheq            : Currency;        //Total number of cheques            //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

    // properties passed to Report
    FLstContainer       : TLstContainerCA; // List of containers

    function GetIdtOperReg : string; virtual;
    procedure SetIdtOperReg (Value : string); virtual;
    procedure SetTxtNameOperReg (Value : string); virtual;
    procedure OnFirstIdle (    Sender : TObject;
                           var Done   : Boolean); virtual;

    procedure HandleAppMessage (var Msg: TMsg; var Handled: Boolean);
    function FocusNextTabSht (TabShtStart : TTabSheet) : Boolean; virtual;
    procedure CreateTabSheetsForTenderGroups; virtual;
    procedure CreateTenderGroupLists; virtual;
    procedure InitButtons; virtual;
    procedure LogOn; virtual;
    procedure AdjustStsBarInfo; virtual;
    procedure DisableCloseForm; virtual;
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
  published
    property ObjTenderGroup  : TObjTenderGroup read  FObjTenderGroup
                                               write FObjTenderGroup;
    property QtyTotal : Currency read  FQtyTotal
                                 write FQtyTotal;
    property ValTotal : Currency read  FValTotal
                                 write FValTotal;
    property IdtContainer    : string read  FIdtContainer
                                      write FIdtContainer;
    property LstContainer    : TLstContainerCA read  FLstContainer
                                               write FLstContainer;
    property IdtOperReg : string read  GetIdtOperReg
                                 write SetIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write SetTxtNameOperReg;
    property QtyCheq  : Currency read FQtyCheq                                  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
                                 write FQtyCheq;
  end; // of TFrmTndCrContainerCA

var
  FrmTndCrContainerCA : TFrmTndCrContainerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  OvcData,
  ScTskMgr_BDE_DBC,

  SfDialog,
  SmUtils,
  SrStnCom,
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
  CtTxtModuleName = 'FFpnTndCrContainerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndCrContainerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.11 $';
  CtTxtSrcDate    = '$Date: 2014/01/29 15:56:42 $';

//*****************************************************************************
// Implementation of TPnlBag
//*****************************************************************************

//=============================================================================
// TPnlBag.CreateLabel : creates a label.
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

function TPnlBag.CreateLabel (var ValLeft    : Integer;
                                  ValWidth   : Integer;
                                  TxtCaption : string  ) : TLabel;
begin  // of TPnlBag.CreateLabel
  Result := TLabel.Create (Owner);

  Result.Parent     := Self;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := False;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlBag.CreateLabel

//=============================================================================
// TPnlBag.CreateSvcLFVal : creates a new component to hold or enter
// a value.
//                                  -----
// INPUT   : ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TPnlBag.CreateSvcLFVal (var ValLeft : Integer): TSvcLocalField;
begin  // of TPnlBag.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Result.Parent        := Self;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign, efoRightJustify];
  Result.Width         := ViValWidthVal;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlBag.CreateSvcLFVal

//=============================================================================
// TPnlBag.CreateForTender : creates the components for count on the Panel.
//                                  -----
// INPUT   : ValLeft = left property for the first component to create.
//                                  -----
// OUTPUT  : ValLeft = Left property ready to append components.
//=============================================================================

procedure TPnlBag.CreateForTender (var ValLeft : Integer;
                                       FlgLeft : Boolean);
begin  // of TPnlBag.CreateForTender
  // Label for Bagnumber
  LblBagNumber := CreateLabel (ValLeft, ViValWidthBag, '');
  // is bag coming from accountancy or not ?
  LblAccountancy := CreateLabel (ValLeft, ViValWidthAccount, '');
  // Component for Total amount in Bag
  SvcLFValBag    := CreateSvcLFVal (ValLeft);
  // label for date on which bag is created
  LblDate        := CreateLabel (ValLeft, ViValWidthDate, '');
  // label for operator who created the bag
  LblIdtOper     := CreateLabel (ValLeft, ViValWidthIdtOper, '');
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  // label for number of cheques in that bag
  if ViFlgNoBagCheques then
    LblNbrCheques  := CreateLabel (ValLeft, ViValWidthNbrCheq, '');
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  TabShtTender.AdjustScrollBarRange (ValLeft, Top + Height);
end;   // of TPnlBag.CreateForTender

//=============================================================================
// TPnlBag.DataToBag : configures the components on the panel
// for the current Bag.
//                                  -----
// INPUT   : ObjBag = Bag Object.
//=============================================================================

procedure TPnlBag.DataToBag (OBjBag : TObjBagCA);
var
  QtyTotal         : Integer;          // Total number of bags for TenderGroup
  ValTotal         : Currency;         // Total amount for bags for TenderGroup
  ValIndex         : Integer;          // Index of identifier
  StrLstOper       : TStringList;      // Stringlist operator
begin  // of TPnlBag.DataToBag

  // Bagnumber
  LblBagNumber.Caption := ObjBag.IdtBag;
  LblBagNumber.Alignment := taLeftJustify;

  if ObjBag.FlgAccountancy then
    LblAccountancy.Caption := 'C'
  else
    LblAccountancy.Caption := '';
  LblAccountancy.Alignment := taCenter;

  // Amount that is in the Bag
  // First check to see if all data for the calculation is already there
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransactionCA.Create;
  ValIndex := LstSafeTransaction.IndexOfIdt  (ObjBag.IdtSafeTransaction);
  if ValIndex = -1 then
    DmdFpnSafeTransactionCA.
        BuildListSafeTransactionAndDetail (LstSafeTransaction,
                                           ObjBag.IdtSafeTransaction);

  ValIndex := LstSafeTransaction.IndexOfIdtAndSeq (ObjBag.IdtSafeTransaction,
                                                     ObjBag.NumSeq);
  SvcLFValBag.Enabled := False;
  if ValIndex <> -1 then begin
    LstSafeTransaction.TotalTransDetail (ObjBag.IdtSafeTransaction,
                                           ObjBag.NumSeq,
                                           ObjBag.IdtTenderGroup,
                                           False,
                                           QtyTotal, ValTotal);
    SvcLFValBag.AsFloat := ValTotal;

    LblDate.Caption := FormatDateTime('dd-mmm',
        LstSafeTransaction.SafeTransaction[ValIndex].DatReg);
    StrLstOper := LstSafeTransaction.GetExplanationForKeyword (
                                  LstSafeTransaction.SafeTransaction [ValIndex],
                                  CtTxtFmtExplOper);
    if StrLstOper.Count > 0 then
      LblIdtOper.Caption  := StrLstOper.Strings[0];
    LblIdtOper.Alignment := taCenter;
    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
    if Assigned (LblNbrCheques) then
    begin
      LblNbrCheques.Caption := IntToStr(QtyTotal);
      LblNbrCheques.Alignment := taCenter;
    end;
    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  end;
end;   // of TPnlBag.DataToBag

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
  PnlHideScrollBar : TPanel;           // Panel to hide left vertical scrollbar
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
  SbxHeaderLeft.Align   := alLeft;
  SbxHeaderLeft.BorderStyle := bsNone;
  PgeCtlParent.Width:= 784;                                                     //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  SbxHeaderLeft.Width := PgeCtlParent.Width div 2;
  SbxHeaderLeft.HorzScrollBar.Visible := False;
  SbxHeaderLeft.VertScrollBar.Visible := False;

  SbxHeaderRight         := TScrollBox.Create (PgeCtlParent.Owner);
  SbxHeaderRight.Name    := Format (CtTxtNameSbxHeaderRight,
                                   [PgeCtlParent.PageCount - 1]);
  SbxHeaderRight.Parent      := Self;
  SbxHeaderRight.Align       := alClient;
  SbxHeaderRight.BorderStyle := bsNone;
  SbxHeaderRight.HorzScrollBar.Visible := False;
  SbxHeaderRight.VertScrollBar.Visible := True;
  SbxHeaderRight.OnCanResize := OnChange;

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

  // Panel Header for labels on the right scrollbox
  PnlHeaderRight := TPanel.Create (PgeCtlParent.Owner);
  PnlHeaderRight.Name       := Format (CtTxtNamePnlHeaderRight,
                                  [PgeCtlParent.PageCount - 1]);
  PnlHeaderRight.Parent     := SbxHeaderRight;
  PnlHeaderRight.Caption    := '';
  PnlHeaderRight.Align      := alTop;
  PnlHeaderRight.BevelInner := bvNone;
  PnlHeaderRight.BevelOuter := bvNone;
  PnlHeaderRight.Height     := 20;

  SbxLeft := TScrollBox.Create (Self);
  SbxLeft.Parent := SbxHeaderLeft;
  SbxLeft.Align := AlClient;
  SbxLeft.BorderStyle := bsNone;
  SbxLeft.VertScrollBar.Tracking := True;
  SbxLeft.HorzScrollBar.Visible := False;
  SbxLeft.VertScrollBar.Visible := True;

  SbxRight := TScrollBox.Create (Self);
  SbxRight.Parent := SbxHeaderRight;
  SbxRight.Align := AlClient;
  SbxRight.BorderStyle := bsNone;
  SbxRight.VertScrollBar.Tracking := True;
  SbxRight.HorzScrollBar.Visible := False;
  SbxRight.VertScrollBar.Visible := True;

  // Special panel for hiding the left vertical scrollbar of the left scrollbox
  // This is needed to keep this scrollbar visible without the user seeing it.
  // If the scrollbar would be set unvisible the movements would not be
  // synchronized as desired.

  PnlHideScrollBar := TPanel.Create (Self);
  PnlHideScrollBar.Parent := SbxHeaderLeft;
  PnlHideScrollBar.Left := SbxHeaderLeft.Width - 18;
  PnlHideScrollBar.Width := 18;
  PnlHideScrollBar.Top  := PnlHeaderLeft.Height;
  PnlHideScrollBar.Height := PgeCtlParent.Height -
                             PnlFooter.Height -
                             PnlHeaderLeft.Height;
  PnlHideScrollBar.Caption := '';
  PnlHideScrollBar.BevelInner := bvNone;
  PnlHideScrollBar.BevelOuter := bvNone;

  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if Caption = CtTxtBankCheques then
    ViFlgNoBagCheques := True;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  // Header on TabSheet
  ValLeft := 8;
  CreateHeader (ValLeft);
  // Footer on TabSheet
  ValLeft := 8;
  CreateFooter (ValLeft);
  // Set caption on tabsheet for TenderGroup
  Caption := Format ('%s %s', [ObjTenderGroup.TxtPublDescr,
                               ObjTenderGroup.IdtCurrency]);
end;   // of TTabShtTender.CreateForTender

//=============================================================================
// TTabShtTender.Destroy : destroys all created objects for this tabsheet
//=============================================================================

destructor TTabShtTender.Destroy;
begin // of TTabShtTender.Destroy
  inherited;
  if Assigned (LstBag) then
    LstBag.Free;
  LstBag := Nil;
end;  // of TTabShtTender.Destroy

//=============================================================================
// TTabShtTender.OnChange : Event to let the left scrollbox go along with
//                          the movements (up / down) of the sbx on the right.
//=============================================================================

procedure TTabShtTender.OnChange (    Sender    : TObject;
                                  var NewWidth  : Integer;
                                  var NewHeight : Integer;
                                  var Resize    : Boolean);
begin
   SbxLeft.VertScrollBar.Position := SbxRight.VertScrollBar.Position;
end;

//=============================================================================
// TTabShtTender.CreateBagPanel : creates the Panel and necessary
// components to show a bag's properties.
//                                  -----
// INPUT   : Objbag  = bag to create the Panel for.
//           FlgLeft = if true then put the panel on the left side of the tbsht
//                     else put it in the right column
//                                  -----
// FUNCRES : created Bag Panel.
//=============================================================================

function TTabShtTender.CreateBagPanel (OBjBag  : TObjBagCA;
                                       FlgLeft : Boolean  ) : TPnlBag;
var
  ValLeft          : Integer;          // Left property for new components
begin  // of TTabShtTender.CreateBagPanel
  Result := TPnlBag.Create (Owner);

  Result.TabShtTender   := Self;

  AdjustPnlBag (Result, FlgLeft);

  ValLeft := 8;

  TPnlBag(Result).CreateForTender (ValLeft, FlgLeft);
  TPnlBag(Result).DataToBag (ObjBag);
  SvcLFValTotal.AsFloat := SvcLFValTotal.AsFloat + 1;
  SvcLFValAmount.AsFloat := SvcLFValAmount.AsFloat +
                            TPnlBag(Result).SvcLFValBag.AsFloat;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if Assigned(SvcLFNbrCheq) then
    SvcLFNbrCheq.AsFloat := SvcLFNbrCheq.AsFloat +
                            StrToFloat(TPnlBag(Result).LblNbrCheques.Caption);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
end;   // of TTabShtTender.CreateBagPanel

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
  if SbxHeaderRight.HorzScrollBar.Range < ValHorz then
    SbxHeaderRight.HorzScrollBar.Range := ValHorz;

  if SbxLeft.VertScrollBar.Range < ValVert then
    SbxLeft.VertScrollBar.Range := ValVert;
  if SbxRight.VertScrollBar.Range < ValVert then
    SbxRight.VertScrollBar.Range := ValVert;
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
  CreateLblHeader (ValLeft, ViValWidthBag, CtTxtHdrBagNumber, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthAccount, '', PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValAmount, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthDate, CtTxtHdrDate, PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthIdtOperHdr, CtTxtHdrOper, PnlHeaderLeft);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ViFlgNoBagCheques then
  CreateLblHeader (ValLeft, ViValWidthNbrCheqHdr, CtTxtHdrNbrCheq, PnlHeaderLeft);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  ValLeft := ValLeftSave;
  // ValLeft is only to be increased once
  CreateLblHeader (ValLeft, ViValWidthBag, CtTxtHdrBagNumber, PnlHeaderRight);
  CreateLblHeader (ValLeft, ViValWidthAccount, '', PnlHeaderLeft);
  CreateLblHeader (ValLeft, ViValWidthVal, CtTxtHdrValAmount, PnlHeaderRight);
  CreateLblHeader (ValLeft, ViValWidthDate, CtTxtHdrDate, PnlHeaderRight);
  CreateLblHeader (ValLeft, ViValWidthIdtOperHdr, CtTxtHdrOper, PnlHeaderRight);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ViFlgNoBagCheques then
  CreateLblHeader (ValLeft, ViValWidthNbrCheqHdr, CtTxtHdrNbrCheq, PnlHeaderRight);
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
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
                                        ValWidth  : Integer    ) : TPanel;
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

  Inc (ValLeft, 60);                                                            //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  // Create Pnl for
  //   - set the width to a default (large enough) value
  //   - set the height to leave room for the border of PnlFooter
  FPnlFtrAmount := CreatePnlAmount (PnlFooter, ValLeft, 3 * ViValWidthVal);
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
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  if ViFlgNoBagCheques then
  begin
    Inc (ValLeft, 250);
  // Create panel for total number of cheques
    FPnlFtrCheques := CreatePnlAmount (PnlFooter, ValLeft, 3 * ViValWidthVal);
    FPnlFtrCheques.Top := FPnlFtrCheques.Top + 2;
    FPnlFtrCheques.Height := FPnlFtrCheques.Height - 4;
  // Label for Total number of cheques
    ValLeft := 0;
    LblNew := CreateLblFooter (ValLeft, CtTxtHdrTotalNbrCheq);
    LblNew.Parent := FPnlFtrCheques;
  // Component for total number of cheques
    SvcLFNbrCheq := CreateSvcLFVal (ValLeft);
    SvcLFNbrCheq.Picturemask := '999999999';
    SvcLFNbrCheq.Parent := FPnlFtrCheques;
  end;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
end;   // of TTabShtTender.CreateFooter

//=============================================================================
// TTabShtTender.AdjustPnlBag : Adjusts the panel's layout
//                                  -----
// INPUT   : PnlBag  = Panel to configure.
//           FlgLeft = is the panel linked to the left or right scrollbox
//=============================================================================

procedure TTabShtTender.AdjustPnlBag (PnlBag  : TPnlBag;
                                      FlgLeft : Boolean);
begin  // of TTabShtTender.AdjustPnlBag
  if FlgLeft then
    PnlBag.Parent := SbxLeft
  else
    PnlBag.Parent := SbxRight;
  PnlBag.Caption    := '';
  PnlBag.BevelInner := bvNone;
  PnlBag.BevelOuter := bvNone;
  PnlBag.Height     := 24;

  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  aligned on Top, then change it to align on Top.
  if FlgLeft then
    PnlBag.Top   := SbxLeft.VertScrollBar.Range
  else
    PnlBag.Top   := SbxRight.VertScrollBar.Range;
  PnlBag.Align := alTop;
end;   // of TTabShtTender.AdjustPnlBag

//=============================================================================
// TTabShtTender.AddContainerToBags : Store IdtContainer in LstBag
//                                  -----
// INPUT   : IdtContainer = IdtContainer to store in bags
//=============================================================================

procedure TTabShtTender.AddContainerToBags (IdtContainer: string);
var
  CntItem          : Integer;          // Counter for items in LstBag of Tabsht
begin // of TTabShtTender.AddContainerToBags
  for CntItem := 0 to LstBag.Count - 1 do begin
    LstBag.Bag[CntItem].IdtContainer := IdtContainer;
    LstBag.Bag[CntItem].CodDBState := CtCodDbsModify;
  end;
end;  // of TTabShtTender.AddContainerToBags

//*****************************************************************************
// Implementation of TFrmTndCrContainerCA
//*****************************************************************************

//=============================================================================
// Event Handlers of TFrmTndCrContainerCA
//=============================================================================

procedure TFrmTndCrContainerCA.FormActivate (Sender: TObject);
begin // of TFrmTndCrContainerCA.FormActivate
  inherited;
  if not FlgEverActivated then begin
    InitButtons;
    SavAppOnIdle := Application.OnIdle;
    Application.OnIdle := OnFirstIdle;

  end;
  FFlgEverActivated := True;
end;  // of TFrmTndCrContainerCA.FormActivate

//=============================================================================

procedure TFrmTndCrContainerCA.FormCreate (Sender: TObject);
begin // of TFrmTndCrContainerCA.FormCreate
  inherited;
  if not Assigned (DmdFpnTenderGroupCA) then
    DmdFpnTenderGroupCA := TDmdFpnTenderGroupCA.Create (Self);
  if not Assigned (DmdFpnTenderCA) then
    DmdFpnTenderCA := TDmdFpnTenderCA.Create (Self);
  if not Assigned (DmdFpnBagCA) then
    DmdFpnBagCA := TDmdFpnBagCA.Create (Self);
  if not Assigned (DMdFpnSafeTransactionCA) then
    DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
end;  // of TFrmTndCrContainerCA.FormCreate

//=============================================================================

procedure TFrmTndCrContainerCA.BtnAcceptClick (Sender: TObject);
var
  ObjContainer     : TObjContainerCA;  // container object
  FlgTransStarted  : Boolean;          // Flag database transaction started
begin // of TFrmTndCrContainerCA.BtnAcceptClick
  inherited;
  if PgeCtlTender.ActivePage is TTabShtTender then begin
    // Properties passed to form where user is asked for container number
    ObjTenderGroup := TTAbShtTender(PgeCtlTender.ActivePage).ObjTenderGroup;
    QtyTotal := TTabShtTender(PgeCtlTender.ActivePage).FSvcLFValTotal.AsFloat;
    ValTotal := TTabShtTender(PgeCtlTender.ActivePage).FSvcLFValAmount.AsFloat;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
    if Assigned(TTabShtTender(PgeCtlTender.ActivePage).FSvcLFNbrCheq) then
    QtyCheq  := TTabShtTender(PgeCtlTender.ActivePage).FSvcLFNbrCheq.AsFloat;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
  end;
  BtnAccept.Enabled := False;
  if SvcTaskMgr.LaunchTask ('AskContainer') then begin
    BtnCancel.Visible := False;
(** PDW Application.OnMessage := HandleAppMessage; **)    
    // Link the received container to each bag in LstBag
    if not Assigned (LstContainer) then
      LstContainer := TLstContainerCA.Create;
    // After each click on accept button the report should be printed for this
    // container.  Because we pass the variable "LstContainer" as a published
    // property to the report program, we have to clear it first so that only
    // one container is in the list.
    LstContainer.ClearContainers;
    ObjContainer := LstContainer.AddContainer (IdtContainer, CtCodDbsNew);
    with ObjContainer do begin
      DatContainer := Now;
      IdtOperator  := IdtOperReg;
      FlgTransfer  := False;
      LstBag       :=TTabShtTender(PgeCtlTender.ActivePage).LstBag;
    end;
    DmdFpnSafeTransactionCA.AddBagsToContainer
                (IdtContainer,
                 ObjContainer.LstBag);
    // Save changes to database
    FlgTransStarted := not DmdFpnBagCA.DbsUpdate.InTransaction;
    if FlgTransStarted then
      DmdFpnBagCA.DbsUpdate.StartTransaction;
    try
      DmdFpnBagCA.UpdateLstContainer (LstContainer,
                         ['IdtContainer',
                          'DatContainer',
                          'IdtOperator',
                          'FlgTransfer']);
      DmdFpnBagCA.UpdateLstBag
         (ObjContainer.LstBag, ['IdtContainer', 'FlgTransfer']);
      if FlgTransStarted then
        DmdFpnBagCA.DbsUpdate.Commit;
    except
      if FlgTransStarted then
        DmdFpnBagCA.DbsUpdate.RollBack;
      raise;
    end;
    if LstContainer.Count > 0 then begin
      Application.ProcessMessages;
      SvcTaskMgr.LaunchTask ('PrintReport');
    end;
    if not FocusNextTabSht (PgeCtlTender.ActivePage) then
      Application.Terminate;
  end;
    BtnAccept.Enabled := True;
end;  // of TFrmTndCrContainerCA.BtnAcceptClick

//=============================================================================

procedure TFrmTndCrContainerCA.FormDestroy (Sender: TObject);
begin
  if Assigned (LstContainer) then
    LstContainer.Free;
  LstContainer := Nil;
  inherited;
end;

//=============================================================================

function TFrmTndCrContainerCA.GetIdtOperReg : string;
begin  // of TFrmTndCrContainerCA.GetIdtOperReg
  Result := FIdtOperReg;
end;   // of TFrmTndCrContainerCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndCrContainerCA.SetIdtOperReg (Value : string);
begin  // of TFrmTndCrContainerCA.GetIdtOperReg
  FIdtOperReg := Value;
end;   // of TFrmTndCrContainerCA.GetIdtOperReg

//=============================================================================

procedure TFrmTndCrContainerCA.SetTxtNameOperReg (Value : string);
begin  // of TFrmTndCrContainerCA.SetTxtNameOperReg
  FTxtNameOperReg := Value;
  StsBarInfo.Panels[ViNumPnlOperReg].Text := Format ('%s : %s',
                                                     [CtTxtOperReg, Value]);
end;   // of TFrmTndCrContainerCA.SetTxtNameOperReg

//=============================================================================
// TFrmTndCrContainerCA.OnFirstIdle : installed as OnIdle Event in OnActivate,
// to execute some things as soon as the application becomes idle.
//=============================================================================

procedure TFrmTndCrContainerCA.OnFirstIdle (    Sender : TObject;
                                            var Done   : Boolean);
begin  // of TFrmTndCrContainerCA.OnFirstIdle
  Application.OnIdle := SavAppOnIdle;
  if IdtOperReg = '' then
    LogOn;

end;   // of TFrmTndCrContainerCA.OnFirstIdle

//=============================================================================
// TFrmTndCrContainerCA.HandleAppMessage : Handles the Alt-F4 event from the
// taskbar
//=============================================================================

procedure TFrmTndCrContainerCA.HandleAppMessage
                                      (var Msg: TMsg; var Handled: Boolean);
begin // of TFrmTndCrContainerCA.HandleAppMessage
  case Msg.Message of
    WM_QUERYENDSESSION :
      begin
        Handled := False;
      end;
  end;
end;  // of TFrmTndCrContainerCA.HandleAppMessage

//=============================================================================
// TFrmTndCrContainerCA.CreateTabSheetsForTenderGroups :
// creates the TabSheets for TenderGroups.
//=============================================================================

procedure TFrmTndCrContainerCA.CreateTabSheetsForTenderGroups;
var
  CntItem            : Integer;             // counter for Tendergroup
  CntBag             : Integer;             // counter for Bag
  TbShtNew           : TTabShtTender;       // last tabsheet created
  ObjBag             : TObjBagCA;           // current Bag object
  FlgSetVisible      : Boolean;             // Is true when at least one tabsht
                                            // is set to visible
  LstBag             : TLstBagCA;           // List of bags
begin  // of TFrmTndCrContainerCA.CreateTabSheetsForTenderGroups
  // Pagecontrol is made unvisible at first to prevent the screen
  // from flickering.
  PgeCtlTender.Visible := False;
  // Creation of the LstTenderGroup, LstTenderClass and LstTenderUnit.
  CreateTenderGroupLists;
  FlgSetVisible := False;
  for CntItem := 0 to LstTenderGroup.Count - 1 do begin
    LstBag := TLstBagCA.Create;
    DmdFpnBagCA.GetUnAssignedBags
       (LstBag, LstTenderGroup.TenderGroup [CntItem].IdtTenderGroup);
    if LstBag.Count = 0 then
      LstBag.Free
    else begin
      if (LstTenderGroup.TenderGroup[CntItem].CodTypePayOrgan = 1) then begin
        TbShtNew := TTabShtTender.CreateForTender (PgeCtlTender,
                                         LstTenderGroup.TenderGroup [CntItem]);
        TbShtNew.LstBag := LstBag;
        // Get all bags for this tendergroup that have not yet been assigned
        // to a container.
        TbShtNew.TabVisible := False;
        TbShtNew.FlgAllLeftColumn := True;
        if TbShtNew.LstBag.Count <> 0 then begin
          if TbShtNew.LstBag.Count > CtMaxBags then begin
            TbShtNew.FlgAllLeftColumn := False;
          end
          else begin
            TbShtNew.SbxHeaderRight.Visible := False;
            TbShtNew.SbxHeaderLeft.Align := alClient;
          end;
          TbShtNew.FlgLeftcolumn := True;
          for CntBag := 0 to TbShtNew.LstBag.Count - 1 do begin
            ObjBag := TbShtNew.LstBag.Bag[CntBag];
            if Assigned (ObjBag) then begin
              TbShtNew.CreateBagPanel (ObjBag, TbShtNew.FlgLeftColumn);
              if not TbShtNew.FlgAllLeftColumn then
                TbShtNew.FlgLeftcolumn := not TbShtNew.FlgLeftcolumn;
            end;
          end;
          // only the first tabsheet is visible
          if not FlgSetVisible then begin
            TbShtNew.TabVisible := True;
            FlgSetVisible := True;
          end;
        end;
      end;
    end;
  end;
  PgeCtlTender.Visible := True;
  // FlgSetVisible will be false if no tabsheets meet the requirements to be
  // shown to the user.  In that case the application will terminate.
  if not FlgSetVisible then begin
    MessageDlg (CtTxtNoBags, mtInformation, [mbOK], 0);
    Application.Terminate;
  end;
end;   // of TFrmTndCrContainerCA.CreateTabSheetsForTenderGroups

//=============================================================================
// TFrmTndCrContainerCA.CreateTenderGroupLists : creates and loads from database
// the lists with TenderGroup, TenderClass and TenderUnit, which weren't
// created yet.
//=============================================================================

procedure TFrmTndCrContainerCA.CreateTenderGroupLists;
begin  // of TFrmTndCrContainerCA.CreateTenderGroupLists
  if not Assigned (LstTenderGroup) then begin
    LstTenderGroup := TLstTenderGroup.Create;
    DmdFpnTenderGroupCA.BuildListTenderGroup (LstTenderGroup);
  end;
end;   // of TFrmTndCrContainerCA.CreateTenderGroupLists

//=============================================================================
// TFrmTndCrContainerCA.InitButtons : set button captions
//=============================================================================

procedure TFrmTndCrContainerCA.InitButtons;
begin // of TFrmTndCrContainerCA.InitButtons
  BtnAccept.Visible := True;
  BtnAccept.Enabled := True;
end;  // of TFrmTndCrContainerCA.InitButtons

//=============================================================================
// TFrmTndCrContainerCA.FocusNextTabSht : tries to focus the next TabSheet if any
//                                  -----
// INPUT   : TabShtStart = TabSheet to start from for searching next.
//                                  -----
// FUNCRES : True = next TabSheet found
//           False = no next TabSheet found
//=============================================================================

function TFrmTndCrContainerCA.FocusNextTabSht (TabShtStart: TTabSheet): Boolean;
var
  CntPage          : Integer;          // Counter pages in PgeCtl
  NumPage          : Integer;          // Number of current page
begin  // of TFrmTndCrContainerCA.FocusNextTabSht
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
end;   // of TFrmTndCrContainerCA.FocusNextTabSht

//=============================================================================
// TFrmTndCrContainerCA.LogOn : LogOn registrating Operator.
//=============================================================================

procedure TFrmTndCrContainerCA.LogOn;
begin  // of TFrmTndCrContainerCA.LogOn
  if SvcTaskMgr.LaunchTask ('LogOn') then begin
    AdjustStsBarInfo;
    CreateTabSheetsForTenderGroups;
  end
  else begin
    ModalResult := mrCancel;
  end;
end;   // of TFrmTndCrContainerCA.LogOn

//=============================================================================
// TFrmTndCrContainerCA.AdjustStsBarInfo : adjusts the forms statusbar depending
// on the current operator registrating.
//=============================================================================

procedure TFrmTndCrContainerCA.AdjustStsBarInfo;
begin  // of TFrmTndCrContainerCA.AdjustStsBarInfo
  StsBarInfo.Panels[ViNumPnlOperReg].Text := Format ('%s : %s',
                                                [CtTxtOperReg, TxtNameOperReg]);
end;   // of TFrmTndCrContainerCA.AdjustStsBarInfo

//=============================================================================

procedure TFrmTndCrContainerCA.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin // of TFrmTndCrContainerCA.FormKeyDown
  inherited;
  if (Shift = [ssAlt, ssCtrl]) and (Chr(Key) in ['S', 's']) then begin
    if BtnCancel.Visible and BtnCancel.Enabled then
      ModalResult := mrAbort
    else if MessageDlg (CtTxtAskExecInterrupt, mtConfirmation,
                        [mbYes, mbNo], 0) = mrYes then
      ModalResult := mrAbort;
  end

  else if (Shift = [ssCtrl]) and (Key = VK_F1) then
    ShowAbout;
end;  // of TFrmTndCrContainerCA.FormKeyDown

//=============================================================================
// Workaround for disabling the form close after accepting the first container
//=============================================================================

procedure TFrmTndCrContainerCA.DisableCloseForm;
var // of TFrmTndCrContainerCA.DisableCloseForm
  hwndHandle : THANDLE;
  hMenuHandle : HMENU;
begin
  hwndHandle := GetActiveWindow;
//  FindWindow (nil, Pchar(Application.Title));
  if (hwndHandle <> 0) then begin
    hMenuHandle := GetSystemMenu (hwndHandle, FALSE);
    if (hMenuHandle <> 0) then
      DeleteMenu (hMenuHandle, SC_CLOSE, MF_BYCOMMAND);
  end;
end;  // of TFrmTndCrContainerCA.DisableCloseForm

//=============================================================================

procedure TFrmTndCrContainerCA.OvcCtlCountIsSpecialControl(Sender: TObject;
  Control: TWinControl; var Special: Boolean);
begin  // of TFrmTndCrContainerCA.OvcCtlCountIsSpecialControl
  inherited;
  if Control = BtnCancel then
    Special := True;
end;   // of TFrmTndCrContainerCA.OvcCtlCountIsSpecialControl

//*****************************************************************************

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.





