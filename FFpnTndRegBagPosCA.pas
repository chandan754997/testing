//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : Flexpoint
// Customer : Castorama
// Unit     : FFpnTndRegBagPosCA = Form FlexPoinT TeNDer TeNDeR  REGister BAT :
//            shows the sealbag numers per TenderGroup for POS of CAstorama.
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndRegBagPosCA.pas,v 1.9 2010/02/12 12:43:12 BEL\DVanpouc Exp $
// History :
// - Started from Castorama - FlexPoint 2.0 - FFpnTndRegBagPosCA - CVS revision 1.14
// VERSION       MODIFIED BY       REASON
// 1.15          TK (TCS)          R2013.2.Req32040.CARU.Container-Number
// 1.16          RC (TCS)          R2014.2.Req.51030.CAFR.Payout_without_ended_sale
//=============================================================================

unit FFpnTndRegBagPosCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, Buttons, ExtCtrls, ScUtils, DFpnTenderGroupPosCA,
  OvcBase,
  flogintenderposca;									//R2014.2.Req51030.CAFR.Payout_without_ended_sale.TCS-RC


//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtBagAlreadyExists = 'The bag exists already';
  CtTxtBagInvalidLength = 'Bagnumber should be %s characters long';
  CtTxtInvalidKey       = 'Only numeric keys are allowed';

//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
const
  WM_ACTIVATED = WM_USER + 1;
  CtTxtFormat  = 'yymmddhhmmss';
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End

//=============================================================================
// Width of at run time created components
//=============================================================================

var
  ViValWidthSpace  : Integer =   1;    // Width between 2 components
  ViValWidthQty    : Integer =  50;    // Width of component for quantity
  ViValWidthVal    : Integer =  70;    // Width of component for value
  ViValWidthDescr  : Integer = 140;    // Width of component for description
  ViValWidthBag    : Integer = 140;    // Width of component for bag number

var
  ViValWidthIdtBag : Integer = 13;     // The number of characters for a bag

//*****************************************************************************
// TFrmTndRegBagCA
//                                  -----
// IMPORTANT REMARKS concering use of TFrmTndRegBagCA:
// - assumes :
//   * IdtSafeTransaction and NumSeqSafeTrans are the key-identifiers for the
//     SafeTransaction to process.
//   * the global LstSafeTransaction contains all SafeTransactions
//     to process for the given CodRunFunc.
//   * the global LstTenderGroup contains all TenderGroups.
// - Panels for bags:
//   - the panels and its components are dynamically created based on
//     LstTenderGroup, IdtSafeTransaction and NumSeqSafeTrans :
//     * a panel is created per TenderGroup with CodPayOrgan <> 0 AND
//       amount <> 0 in the current SafeTransaction.
//     * for each panel, the property Tag is used to hold the reference to
//       the ObjTenderGroup for the panel (to retrieve ObjTenderGroup for
//       components on the panel: use Parent.Tag).
//     * during creation, all components for holding bag-numbers are added
//       to a list, so we just have to scroll through this list to check if
//       all bag-numbers are filled in.
//                                  -----
// PROPERTIES :
// - LstCmpBag = list of components to hold bag-numbers.
// - IdtSafeTransaction, NumSeqSafeTrans = key-identifiers for the
//   SafeTransaction to process.
// - TxtDescrFunc = description of the function to process bags for.
//*****************************************************************************

type
  TFrmTndRegBagCA = class(TFrmCommon)
    PnlTop: TPanel;
    LblFunc: TLabel;
    PnlBottom: TPanel;
    BtnOk: TBitBtn;
    SbxBagHdr: TScrollBox;
    PnlBagHdr: TPanel;
    LblHdrDescr: TLabel;
    LblHdrAmount: TLabel;
    LblHdrBag: TLabel;
    SbxBagDetail: TScrollBox;
    OvcCtlBag: TOvcController;
    LblHdrQtyUnit: TLabel;
    LblNoBags: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    FTxtKeyboardIni: string;
    procedure WMActivated(var Message: TMessage); message WM_ACTIVATED;         //R2013.2.Req32040.CARU.Container-Number.TCS-TK
  protected
    // Datafields for properties
    FLstCmpBag          : TList;       // List of components to hold bag-numbers
    FIdtSafeTransaction : Integer;     // IdtSafeTransaction to process
    FNumSeqSafeTrans    : Integer;     // NumSeq SafeTransaction to process
    // Internal used datafields
    FlgDoCreateCmp      : Boolean;     // Indicates if components need created
    CntCmp              : Integer;     // Component counter (used for names)
    // Methods for Read/Write properties
    function GetTxtDescrFunc : string; virtual;
    procedure SetTxtDescrFunc (Value : string); virtual;
    procedure SetIdtSafeTransaction (Value : Integer); virtual;
    procedure SetNumSeqSafeTrans (Value : Integer); virtual;
    function CheckDBAvailable : Boolean; virtual;
    // Methods
    function CalcRandomBag (ObjTenderGroup : TObjTenderGroup;
                            QtyBag         : Integer;
                            ValBag         : Currency       ) : string; virtual;
    procedure RemoveParentChildCtls (CtlParent : TControl); virtual;
    procedure RemovePanelsBags; virtual;
    procedure ConfigHeader; virtual;
    function CreateLabel (    CtlParent  : TWinControl;
                          var ValLeft    : Integer;
                              ValWidth   : Integer;
                              TxtCaption : string     ) : TLabel; virtual;
    function CreateSvcLFQty  (    CtlParent : TWinControl;
                              var ValLeft   : Integer;
                                  QtyBag    : Integer) : TSvcLocalField;virtual;
    function CreateSvcLFVal (    CtlParent : TWinControl;
                             var ValLeft   : Integer;
                                 ValBag    : Currency) : TSvcLocalField;virtual;
    function CreateSvcLFBag (    CtlParent : TWinControl;
                             var ValLeft   : Integer;
                                 NumBag    : String = '') : TSvcLocalField; virtual; //R2013.2.Req32040.CARU.Container-Number.TCS-TK.modified
    procedure CreatePanelTenderGroup (ObjTenderGroup :TObjTenderGroup;
                                      QtyBag         : Integer;
                                      ValBag         : Currency      ); virtual;
    procedure CreatePanelsBags; virtual;
    function CheckAndSaveBags : Boolean; virtual;
  public
    { Public declarations }
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Methods
    procedure OnMessage (var Msg     : TMsg;
                         var Handled : Boolean); virtual;    
    procedure SvcLFBagKeyDown (    Sender : TObject;
                               var Key    : Word;
                                   Shift  : TShiftState); virtual;
    procedure SvcLFBagExit (Sender : TObject); virtual;
    // Properties
    property LstCmpBag : TList read  FLstCmpBag
                               write FLstCmpBag;
  published
    // Properties
    property TxtDescrFunc : string read  GetTxtDescrFunc
                                   write SetTxtDescrFunc;
    property IdtSafeTransaction : Integer read  FIdtSafeTransaction
                                          write SetIdtSafeTransaction;
    property NumSeqSafeTrans : Integer read  FNumSeqSafeTrans
                                       write SetNumSeqSafeTrans;
    property TxtKeyboardIni : string read  FTxtKeyboardIni
                                     write FTxtKeyboardIni;
  end;  // of TFrmTndRegBagCA

//*****************************************************************************

implementation

{$R *.DFM}

uses
  IdEcho,

  OvcEF,
  OvcPf,

  StStrW,

  SfDialog,
  SmUtils,
  SrStnCom,

  DFpn,
  DFpnSafeTransactionPosCA,
  DFpnTenderPosCA,
  DFpnUtils,
  FNumericInput,

  UFpsSyst,
  MGoPosLinkCA, UUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FFpnTndRegBagPosCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndRegBagPosCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2010/02/12 12:43:12 $';

//*****************************************************************************
// Implementation of TFrmTndRegBagCA
//*****************************************************************************

constructor TFrmTndRegBagCA.Create (AOwner : TComponent);
begin  // of TFrmTndRegBagCA.Create
  inherited;
  FLstCmpBag := TList.Create;
end;   // of TFrmTndRegBagCA.Create

//=============================================================================

destructor TFrmTndRegBagCA.Destroy;
begin  // of TFrmTndRegBagCA.Destroy
  FLstCmpBag.Free;
  FLstCmpBag := nil;

  inherited;
end;   // of TFrmTndRegBagCA.Destroy

//=============================================================================
// TFrmTndRegBagCA - Methods for Read/Write properties
//=============================================================================

function TFrmTndRegBagCA.GetTxtDescrFunc : string;
begin  // of TFrmTndRegBagCA.GetTxtDescrFunc
  Result := LblFunc.Caption;
end;   // of TFrmTndRegBagCA.GetTxtDescrFunc

//=============================================================================
 //R2014.2.Req(51030).CAFR.PayOut-Without-Ended-Sale.TCS-Ravi.Start
// start=================================================================
function KBHookCallback(nCode: Integer; wParam: WPARAM; lParam: LPARAM): HRESULT; stdcall;
type
  PKBHOOKSTRUCT = ^TKBHOOKSTRUCT;
  TKBHOOKSTRUCT = packed record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: DWORD;
  end;
const
// Low-Level Keyboard Constants from Windows
   HC_ACTION : Integer = 0;
   LLKHF_EXTENDED : Integer = $1;
   LLKHF_INJECTED : Integer = $10;
   LLKHF_UP : Integer = $80;
   WH_KEYBOARD_LL : Integer = $13;
   LLKHF_ALTDOWN = $20;
var
  pkbhs: PKBHOOKSTRUCT;
begin
  pkbhs := PKBHOOKSTRUCT(lParam);
  if nCode = HC_ACTION then
  begin
    // Disable CTRL+ESC  the below code is masking control key to check if its pressed

    // Disable ALT+TAB  LLKHF_ALTDOWN Windows constant 1 if Alt is pressed
    if (pkbhs^.vkCode = VK_TAB) and LongBool(pkbhs^.flags and LLKHF_ALTDOWN) then
    begin
      Result := 1;
      Exit;
    end;
    // Disable ALT+ESC

  end;
  //Send rest of the keys to the target window
  Result := CallNextHookEx(hKeybaordHook, nCode, wParam, lParam);
end;


function DisableSysKeys: Boolean;
const
  WH_KEYBOARD_LL : Integer = 13;
begin
  if hKeybaordHook = 0 then
    hKeybaordHook := SetWindowsHookEx(WH_KEYBOARD_LL, @KBHookCallback, HInstance, 0);
  Result := (hKeybaordHook <> 0)
end;


function EnableSysKeys: Boolean;
begin
  Result := False;
  if (hKeybaordHook <> 0) and UnhookWindowsHookEx(hKeybaordHook) then
  begin
    hKeybaordHook := 0;
    Result := True;
  end;
end;

// end======================================================================
   //R2014.2.Req(51030).CAFR.PayOut-Without-Ended-Sale.TCS-Ravi.End
procedure TFrmTndRegBagCA.SetTxtDescrFunc (Value : string);
begin  // of TFrmTndRegBagCA.SetTxtDescrFunc
  LblFunc.Caption := Value;
end;   // of TFrmTndRegBagCA.SetTxtDescrFunc

//=============================================================================

procedure TFrmTndRegBagCA.SetIdtSafeTransaction (Value : Integer);
begin  // of TFrmTndRegBagCA.SetIdtSafeTransaction
  if Value = FIdtSafeTransaction then
    Exit;

  // If form is active: alteration of IdtSafeTransaction not allowed anymore
  if Active then
    raise EInvalidOperation.Create ('Implementation error: Property ' +
                                    'IdtSafeTransaction cannot be changed in ' +
                                    'current application state');

  FIdtSafeTransaction := Value;
  FlgDoCreateCmp := True;
end;   // of TFrmTndRegBagCA.SetIdtSafeTransaction

//=============================================================================

procedure TFrmTndRegBagCA.SetNumSeqSafeTrans (Value : Integer);
begin  // of TFrmTndRegBagCA.SetNumSeqSafeTrans
  if Value = FNumSeqSafeTrans then
    Exit;

  // If form is active: alteration of IdtSafeTransaction not allowed anymore
  if Active then
    raise EInvalidOperation.Create ('Implementation error: Property ' +
                                    'NumSeqSafeTrans cannot be changed in ' +
                                    'current application state');

  FNumSeqSafeTrans := Value;
  FlgDoCreateCmp := True;
end;   // of TFrmTndRegBagCA.SetNumSeqSafeTrans

//=============================================================================
// TFrmTndRegBagCA - Protected methods
//=============================================================================

//=============================================================================
// TFrmTndRegBagCA.CalcRandomBag : calculates a random number for a bag for
// a TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to calculate a random number for.
//           QtyBag = number of units in bag (can be used to calculate random).
//           ValBag = value in bag (can be used to calculate random).
//                                  -----
// FUNCRES : calculated random number, as string.
//=============================================================================

function TFrmTndRegBagCA.CalcRandomBag (ObjTenderGroup : TObjTenderGroup;
                                        QtyBag         : Integer;
                                        ValBag         : Currency    ) : string;
var
  TimNow           : TTimeStamp;       // Current date and time
  NumBase          : Integer;          // Calc. sum of some factors
begin  // of TFrmTndRegBagCA.CalcRandomBag
  TimNow := DateTimeToTimeStamp (Now);
  // Calculate a number from some factors of the current process
  NumBase := Abs (TimNow.Date + TimNow.Time +
                  ObjTenderGroup.IdtTenderGroup +
                  ObjTenderGroup.CodTypePayOrgan +
                  QtyBag + Round (ValBag));

  Result := IntToStr (GetCurrentProcessID) + IntToStr (NumBase);
  if Length (Result) > 10 then
    Result := Copy (Result, Length (Result) - 9, Length (Result))
  else if Length (Result) < 10 then
    Result := LeftPadStringCh (Result, '0', 10);
end;   // of TFrmTndRegBagCA.CalcRandomBag

//=============================================================================
// TFrmTndRegBagCA.RemoveParentChildCtls : removes a given parentcontrol, and
// all his child-controls.
//                                   ----
// INPUT   : CtlParent = parent control to remove (with al his childs).
//                                   ----
// Restrictions:
// - recursive: if a control in CtlParent has child-components,
//   RemoveParentChildCtls is called to remove the child-components as well.
//=============================================================================

procedure TFrmTndRegBagCA.RemoveParentChildCtls (CtlParent : TControl);
var
  CntCtl           : Integer;          // Counter control in CtlParent.Controls
begin  // TFrmTndRegBagCA.RemoveParentChildCtls
  // Remove the child-controls
  if (CtlParent is TWinControl) and
     (TWinControl(CtlParent).ControlCount > 0) then begin
    for CntCtl := Pred (TWinControl(CtlParent).ControlCount) downto 0 do
      RemoveParentChildCtls (TWinControl(CtlParent).Controls[CntCtl]);
  end;

  // Remove CtlParent
  CtlParent.Free;
end;   // TFrmTndRegBagCA.RemoveParentChildCtls

//=============================================================================
// TFrmTndRegBagCA.RemovePanelsBags : removes all existing panels for bags,
// and clears the list of components for bags; which prepares the form to
// create new bag-components (for another SafeTransaction).
//=============================================================================

procedure TFrmTndRegBagCA.RemovePanelsBags;
var
  CntCtl           : Integer;          // Counter control in CtlParent.Controls
begin  // of TFrmTndRegBagCA.RemovePanelsBags
  LstCmpBag.Clear;
  // Remove the all controls on SbxBagDetail
  for CntCtl := Pred (SbxBagDetail.ControlCount) downto 0 do
    if SbxBagDetail.Controls[CntCtl] is TPanel then
      RemoveParentChildCtls (SbxBagDetail.Controls[CntCtl]);
end;   // of TFrmTndRegBagCA.RemovePanelsBags

//=============================================================================
// TFrmTndRegBagCA.ConfigHeader : configures the header according to the
// width of the components to create.
//                                  -----
// Restrictions :
// - the range of the horizontal scrollbar is incremented with 20 to leave
//   some place for the vertical scrollbar.
//=============================================================================

procedure TFrmTndRegBagCA.ConfigHeader;
begin  // of TFrmTndRegBagCA.ConfigHeader
  LblHdrDescr.Left := 8;

  LblHdrQtyUnit.Left  := LblHdrDescr.Left + ViValWidthDescr + ViValWidthSpace;
  LblHdrQtyUnit.Width := ViValWidthQty;

  LblHdrAmount.Left  := LblHdrQtyUnit.Left + ViValWidthQty + ViValWidthSpace;
  LblHdrAmount.Width := ViValWidthVal;

  LblHdrBag.Left  := LblHdrAmount.Left + ViValWidthVal + ViValWidthSpace;
  LblHdrBag.Width := ViValWidthBag;

  if SbxBagHdr.HorzScrollBar.Range < LblHdrBag.Left + LblHdrBag.Width + 20 then
    SbxBagHdr.HorzScrollBar.Range := LblHdrBag.Left + LblHdrBag.Width + 20;
end;   // of TFrmTndRegBagCA.ConfigHeader

//=============================================================================
// TFrmTndRegBagCA.CreateLabel : creates a label.
//                                  -----
// INPUT   : CtlParent = Parent for the created component.
//           ValLeft = left property for the created component.
//           ValWidth = property Width for the label.
//           TxtCaption = Caption for the label.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmTndRegBagCA.CreateLabel (    CtlParent  : TWinControl;
                                      var ValLeft    : Integer;
                                          ValWidth   : Integer;
                                          TxtCaption : string     ) : TLabel;
begin  // of TFrmTndRegBagCA.CreateLabel
  Result := TLabel.Create (Owner);

  Inc (CntCmp);
  Result.Name := Format ('Lbl%d', [CntCmp]);

  Result.Parent     := CtlParent;
  Result.Caption    := TxtCaption;
  Result.AutoSize   := False;
  Result.Left       := ValLeft;
  Result.Top        := 4;
  Result.Width      := ValWidth;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmTndRegBagCA.CreateLabel

//=============================================================================
// TPnlTender.CreateSvcLFQty : creates a new component to show the quantity
// of a bag.
//                                  -----
// INPUT   : CtlParent = Parent for the created component.
//           ValLeft = left property for the created component.
//           QtyBag = quantity to set in component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmTndRegBagCA.CreateSvcLFQty  (    CtlParent : TWinControl;
                                          var ValLeft   : Integer;
                                              QtyBag    : Integer    ) :
                                                                 TSvcLocalField;
begin  // of TFrmTndRegBagCA.CreateSvcLFQty
  Result := TSvcLocalField.Create (Owner);

  Inc (CntCmp);
  Result.Name := Format ('Qty%d', [CntCmp]);

  Result.Parent        := CtlParent;
  Result.Left          := ValLeft;
  Result.DataType      := pftLongInt;
  Result.Options       := Result.Options +
    [efoForceOvertype, efoRightAlign, efoRightJustify];
  Result.PictureMask   := '99999';
  Result.MaxLength     := 5;
  Result.RangeHi       := '99999';
  Result.RangeLo       := '0';
  Result.Width         := ViValWidthQty;
  Result.AsInteger     := QtyBag;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmTndRegBagCA.CreateSvcLFQty

//=============================================================================
// TFrmTndRegBagCA.CreateSvcLFVal : creates a new component to show the amount
// of a bag.
//                                  -----
// INPUT   : CtlParent = Parent for the created component.
//           ValLeft = left property for the created component.
//           ValBag = value to set in component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmTndRegBagCA.CreateSvcLFVal (    CtlParent : TWinControl;
                                         var ValLeft   : Integer;
                                             ValBag    : Currency   ) :
                                                                 TSvcLocalField;
begin  // of TFrmTndRegBagCA.CreateSvcLFVal
  Result := TSvcLocalField.Create (Owner);

  Inc (CntCmp);
  Result.Name := Format ('Val%d', [CntCmp]);

  Result.Parent        := CtlParent;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Options       := Result.Options +
    [efoForceOvertype, efoRightAlign, efoRightJustify];
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Width         := ViValWidthVal;
  Result.AsFloat       := ValBag;
  Result.Enabled       := False;

  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmTndRegBagCA.CreateSvcLFVal

//=============================================================================
// TFrmTndRegBagCA.CreateSvcLFBag : creates a new component to show or enter
// the number of a bag.
//                                  -----
// INPUT   : CtlParent = Parent for the created component.
//           ValLeft = left property for the created component.
//                                  -----
// OUTPUT  : ValLeft = incremented with width of created component and width
//                     for space between components.
//                                  -----
// FUNCRES : created component.
//=============================================================================

function TFrmTndRegBagCA.CreateSvcLFBag (    CtlParent : TWinControl;
                                         var ValLeft   : Integer;
                                             NumBag    : String    ) :          //R2013.2.Req32040.CARU.Container-Number.TCS-TK.modified
                                                                 TSvcLocalField;
begin  // of TFrmTndRegBagCA.CreateSvcLFBag
  Result := TSvcLocalField.Create (Owner);
  Inc (CntCmp);
  Result.Name          := Format ('Bag%d', [CntCmp]);
  Result.Parent        := CtlParent;
  Result.Left          := ValLeft;
  Result.DataType      := pftString;
  Result.Options       := Result.Options + [efoForceOvertype];
  Result.PictureMask   := CharStrW ('9', ViValWidthIdtBag);
  Result.MaxLength     := ViValWidthIdtBag;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Width         := ViValWidthBag;
  Result.OnKeyDown     := SvcLFBagKeyDown;
  Result.OnExit        := SvcLFBagExit;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
  if ViFlgRecountOperator then
  begin
    Result.AsString    := NumBag;
    Result.Enabled     := False;
  end;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TFrmTndRegBagCA.CreateSvcLFBag

//=============================================================================
// TFrmTndRegBagCA.CreatePanelTenderGroup : creates a new panel for the
// bag-number for the passed TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to create the panel for.
//           QtyBag = number of units in Bag.
//           ValBag = total amount in Bag.
//                                  -----
// Restrictions :
// - the range of the vertical scrollbar is incremented with 20 to leave
//   some place for the horizontal scrollbar.
//=============================================================================

procedure TFrmTndRegBagCA.CreatePanelTenderGroup(ObjTenderGroup:TObjTenderGroup;
                                                 QtyBag        : Integer;
                                                 ValBag        : Currency     );
var
  ValLeft          : Integer;          // Left-property for next component
  PnlBag           : TPanel;           // Created Panel
  SvcLFBag         : TSvcLocalField;   // Component for bagnumber
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
  NumBag           : String;
  Date             : String;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
begin  // of TFrmTndRegBagCA.CreatePanelTenderGroup
  PnlBag := TPanel.Create (Owner);
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
  DateTimetoString(Date, CtTxtFormat, Now);
  NumBag := Date + IntToStr(ObjTenderGroup.IdtTenderGroup);
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
  PnlBag.Parent     := SbxBagDetail;
  PnlBag.Tag        := Integer(ObjTenderGroup);
  PnlBag.Caption    := '';
  PnlBag.BevelOuter := bvNone;
  PnlBag.Height     := 24;
  // Set Top to Height of Parent, to ensure the already existing Panels stays
  //  alligned on Top, then change it to align on Top.
  PnlBag.Top   := SbxBagDetail.VertScrollBar.Range;
  PnlBag.Align := alTop;

  ValLeft := 8;
  CreateLabel (PnlBag, ValLeft, ViValWidthDescr, ObjTenderGroup.TxtPublDescr);
  CreateSvcLFQty (PnlBag, ValLeft, QtyBag);
  CreateSvcLFVal (PnlBag, ValLeft, ValBag);
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
  if ViFlgRecountOperator then
    SvcLFBag := CreateSvcLFBag (PnlBag, ValLeft, NumBag)
  else
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
    SvcLFBag := CreateSvcLFBag (PnlBag, ValLeft);
  LstCmpBag.Add (SvcLFBag);
  if not ViFlgRecountOperator then                                              //R2013.2.Req32040.CARU.Container-Number.TCS-TK
    SvcLFBag.Enabled := not DmdFpnTender.FlgUseRandomBag;
  if DmdFpnTender.FlgUseRandomBag then
    SvcLFBag.AsString := CalcRandomBag (ObjTenderGroup, QtyBag, ValBag);

  if SbxBagDetail.VertScrollBar.Range < PnlBag.Top + PnlBag.Height + 20 then
    SbxBagDetail.VertScrollBar.Range := PnlBag.Top + PnlBag.Height + 20;
end;   // of TFrmTndRegBagCA.CreatePanelTenderGroup

//=============================================================================
// TFrmTndRegBagCA.CreatePanelsBags : creates a new panel for each TenderGroup
// with CodPayOrgan <> 0, and amount for current SafeTransaction <> 0.
//=============================================================================

procedure TFrmTndRegBagCA.CreatePanelsBags;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
begin  // of TFrmTndRegBagCA.CreatePanelsBags
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if LstTenderGroup.TenderGroup[CntTenderGroup].CodTypePayOrgan <> 0
       then begin
      LstSafeTransaction.TotalTransDetail
        (IdtSafeTransaction, NumSeqSafeTrans,
         LstTenderGroup.TenderGroup[CntTenderGroup].IdtTenderGroup,
         False, QtyTrans, ValTrans);
      if ValTrans <> 0 then
        CreatePanelTenderGroup (LstTenderGroup.TenderGroup[CntTenderGroup],
                                QtyTrans, ValTrans);
    end;
  end;

  if (LstCmpBag.Count > 0) and TWinControl(LstCmpBag[0]).Enabled then
    TWinControl(LstCmpBag[0]).SetFocus
  else
    BtnOK.SetFocus;
end;   // of TFrmTndRegBagCA.CreatePanelsBags

//=============================================================================
// TFrmTndRegBagCA.CheckAndSaveBags : checks if all necessary bagnumbers are
// filled in, and saves them in the SafeTransaction.
//                                  -----
// Restrictions :
// - if not all bagnumbers are filled in, an exception is raised.
//=============================================================================

function TFrmTndRegBagCA.CheckAndSaveBags : Boolean;
var
  CntItem          : Integer;          // Number item in list
  CntItem2         : Integer;          // Number item in list
  SvcLFBag         : TSvcLocalField;   // Local field to get bagnumber
  ObjSafeTrans     : TObjSafeTransaction;   // ObjSafeTransaction to save in
begin  // of TFrmTndRegBagCA.CheckAndSaveBags
  CntItem := 0;
  Result := False;
  try
    if LstCmpBag.Count <= 0 then begin
      Result := True;
      Exit;
    end;
    // Check if all bagnumbers are filled in
    for CntItem := 0 to Pred (LstCmpBag.Count) do begin
      if TSvcLocalField(LstCmpBag[CntItem]).AsString = '' then begin
        TSvcLocalField(LstCmpBag[CntItem]).SetFocus;
        MessageDlgBtns (LblHdrBag.Caption + ' ' +
        CtTxtRequired,mtWarning, ['OK'], 1, 0, 0);
        Exit;
      end;
      if length( Trim (TSvcLocalField(LstCmpBag[CntItem]).AsString)) <>
         ViValWidthIdtBag then begin
        TSvcLocalField(LstCmpBag[CntItem]).Text := '';
        TSvcLocalField(LstCmpBag[CntItem]).SetFocus;
        MessageDlgBtns (Format(CtTxtBagInvalidLength,[IntToStr(ViValWidthIdtBag)]),
                        mtWarning, ['OK'], 1, 0, 0);
        Exit;
      end;
      for CntItem2 := 0 to Pred (LstCmpBag.Count) do begin
        if (TSvcLocalField(LstCmpBag[CntItem]).Text = TSvcLocalField(LstCmpBag
        [CntItem2]).Text) and (CntItem <> CntItem2) then begin
          TSvcLocalField(LstCmpBag[CntItem]).SetFocus;
          MessageDlgBtns (CtTxtBagAlreadyExists,mtWarning, ['OK'], 1, 0, 0);
          exit;
        end;
      end;
    end;
    // Save bagnumbers in SafeTransaction
    CntItem := LstSafeTransaction.IndexOfIdtAndSeq (IdtSafeTransaction,
                                                    NumSeqSafeTrans);
    ObjSafeTrans := LstSafeTransaction.SafeTransaction[CntItem];
    for CntItem := 0 to Pred (LstCmpBag.Count) do begin
      SvcLFBag := TSvcLocalField(LstCmpBag[CntItem]);
      ObjSafeTrans.StrLstExplanation.Add
        (Format (CtTxtFmtExplBagCA,
                 [TObjTenderGroup(SvcLFBag.Parent.Tag).IdtTenderGroup,
                  SvcLFBag.AsString]));
    end;
    CntItem := 0;
    Result := True;
  except
    TSvcLocalField(LstCmpBag[CntItem]).Text := '';
    TSvcLocalField(LstCmpBag[CntItem]).SetFocus;
  end;
end;   // of TFrmTndRegBagCA.CheckAndSaveBags

//=============================================================================
// TFrmTndRegBagCA - Public methods
//=============================================================================

//=============================================================================
// TFrmTndRegBagCA.SvcLFBagKeyDown : general Event Handler OnKeyDown for
// Local Field Bag.
// See TOvcPictureField.OnKeyDown.
//=============================================================================

procedure TFrmTndRegBagCA.SvcLFBagKeyDown (    Sender : TObject;
                                            var Key    : Word;
                                                Shift  : TShiftState);
var
  NumCmpInList     : Integer;          // Find component in list
begin  // of TFrmTndRegBagCA.SvcLFBagKeyDown
  if (Shift = []) and (Key = VK_RETURN) then begin
    PostMessage (TWinControl(Sender).Handle, WM_KeyDown, VK_TAB, 0);
    Key := 0;
  end

  else if (Shift = []) and (Key = VK_UP) then begin
    NumCmpInList := LstCmpBag.IndexOf (Sender);
    if NumCmpInList > 0 then begin
      TWinControl(LstCmpBag[NumCmpInList - 1]).SetFocus;
      Key := 0;
    end;
  end

  else if (Shift = []) and (Key = VK_DOWN) then begin
    NumCmpInList := LstCmpBag.IndexOf (Sender);
    if NumCmpInList < (LstCmpBag.Count - 1) then begin
      TWinControl(LstCmpBag[NumCmpInList + 1]).SetFocus;
    end
    else
      BtnOK.SetFocus;
    Key := 0;
  end;
end;   // of TFrmTndRegBagCA.SvcLFBagKeyDown

//=============================================================================
// TFrmTndRegBagCA.SvcLFBagExit : general Event Handler OnExit for
// Local Field Bag.
//=============================================================================

procedure TFrmTndRegBagCA.SvcLFBagExit (Sender : TObject);
var
  FlgError            : Boolean;        // Invalid pochettenumber
begin  // of TFrmTndRegBagCA.SvcLFBagExit
  FlgError := False;
  try
    try
      if (length (Trim (TSvcLocalField (Sender).Text)) < ViValWidthIdtBag)
         and not FlgError then begin
        TSvcLocalField (Sender).SetFocus;
        MessageDlgBtns (Format(CtTxtBagInvalidLength,[IntToStr(ViValWidthIdtBag)]),
                        mtWarning, ['OK'], 1, 0, 0);
        FlgError := True;
      end;
      if not FlgError and CheckDBAvailable  then begin
        if not Assigned (DmdFpn) then
          DmdFpn := TDmdFpn.Create (Self);
        if not Assigned (DmdFpnUtils) then
          DmdFpnUtils := TDmdFpnUtils.Create (Self);
        try
          if (Trim (TSvcLocalField (Sender).Text) <> '') and DmdFpnUtils.QueryInfo
               ('SELECT * ' +
                ' FROM Pochette ' +
                ' WHERE IdtPochette = ' +
                AnsiQuotedStr (Trim (TSvcLocalField (Sender).Text),
                               '''')) then begin
            TSvcLocalField (Sender).SetFocus;
            MessageDlgBtns (CtTxtBagAlreadyExists,mtWarning, ['OK'], 1, 0, 0);
            FlgError := True;
          end;
        finally
          DmdFpnUtils.CloseInfo;
        end;
      end;
    except
      TSvcLocalField (Sender).Text := '';
      TSvcLocalField (Sender).SetFocus;
    end;
  finally
    if FlgError then begin
      TSvcLocalField (Sender).Text := '';
      TSvcLocalField (Sender).SetFocus;
    end;
  end;
end;   // of TFrmTndRegBagCA.SvcLFBagExit

//=============================================================================

function TFrmTndRegBagCA.CheckDBAvailable : Boolean;
var
  IdEcho           : TIdEcho;          // Ping to the DB
begin  // of TFrmTndRegBagCA.CheckDBAvailable
  IdEcho := TIdEcho.Create (Self);
  try
    try
      Result := True;
      IdEcho.ConnectTimeOut := 20000;
      IdEcho.Host := ReplaceEnvVar ('%POSSRV1%');
      IdEcho.Port := 1433;
      IdEcho.Connect;
    except
      Result := False;
    end;
  finally
    IdEcho.Free;
  end;
end;   // of TFrmTndRegBagCA.CheckDBAvailable

//=============================================================================
// TFrmTndRegBagCA - Event Handlers
//=============================================================================

procedure TFrmTndRegBagCA.FormActivate(Sender: TObject);
var
ViFlgCashDesk   : Boolean;                                                     //R2013.2.Req32040.CARU.Container-Number.TCS-TK
begin  // of TFrmTndRegBagCA.FormActivate
  inherited;
  ViFlgCashDesk := False;                                                      //R2013.2.Req32040.CARU.Container-Number.TCS-TK
  if FlgDoCreateCmp then begin
    RemovePanelsBags;
    ConfigHeader;
    CreatePanelsBags;
    FlgDoCreateCmp := False;
    LblNoBags.Visible := LstCmpBag.Count = 0;
    if ViFlgTouchScreen then begin
      if assigned(FrmNumericInput) then
        FrmNumericInput.Free;
      FrmNumericInput := TFrmNumericInput.Create(Self);
      FrmNumericInput.TxtKeyboardIni := TxtKeyboardIni;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
      if not ViFlgContainerBag then
      begin
        PostMessage(Handle, WM_ACTIVATED, 0, 0);
        ViFlgCashDesk := True;
      end;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
      Self.SetFocus;
    end;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
    if not ViFlgCashDesk then
    begin
      if not ViFlgContainerBag then
        PostMessage(Handle, WM_ACTIVATED, 0, 0);
    end;
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End
  end;
end;   // of TFrmTndRegBagCA.FormActivate

//=============================================================================

procedure TFrmTndRegBagCA.OnMessage (var Msg     : TMsg;
                                        var Handled : Boolean);
var
  MsgwParam        : integer;
  TxtLeft          : string;           // Left part
  TxtRight         : string;           // Right part
begin  // of TFrmTndRegBagCA.OnMessage
  MsgWParam := 0;
  if (Msg.message = WM_CHAR) and (Msg.wParam = 46) and (Msg.lParam <> 1) then
  begin
    PostMessage (Screen.ActiveControl.Handle, WM_KEYDOWN,
                 Ord (DecimalSeparator), 1);
    PostMessage (Screen.ActiveControl.Handle, WM_CHAR,
                 Ord (DecimalSeparator), 1);
    PostMessage (Screen.ActiveControl.Handle, WM_KEYUP,
                 Ord (DecimalSeparator), 1);
    Handled := True;
  end; // of if (Msg.message = WM_CHAR)
  if (Msg.message = WM_CHAR) and (Msg.wParam >= 48) and (Msg.wParam < 58) and
     (Msg.lParam <> 1) then begin
    PostMessage (Screen.ActiveControl.handle, WM_KEYDOWN, Msg.wParam, 1);
    PostMessage (Screen.ActiveControl.handle, WM_CHAR, Msg.wParam, 1);
    PostMessage (Screen.ActiveControl.handle, WM_KEYUP, Msg.wParam, 1);
    Handled := True;
  end; // of if (Msg.message = WM_CHAR)
  if (Msg.message = WM_CHAR) and (Msg.wParam = 13) and (Msg.lParam = 13) then
  begin
    keybd_event (VK_RETURN, 0,0,0);
    Handled := True;
  end; // of if (Msg.message = WM_CHAR)
  if (ViCodIsRunningOn = CtCodRunOnCashdesk) then begin
    if (Msg.message = WM_KEYUP) or (Msg.message = WM_CHAR) or
      ((Msg.message = WM_SYSKEYUP) and (Msg.wParam = VK_F10)) then begin
      if (not Assigned (StrLstTransKeys)) then
        Exit;
      TxtLeft := StrLstTransKeys.Values[IntToStr(Msg.message) + ',' +
                                        IntToStr(Byte(Msg.wParam))];
      if TxtLeft = '' then
        Exit;
      // Change the message using the parameters from the ini-file.
      SplitString (TxtLeft, ',', TxtLeft, TxtRight);
      if (TxtLeft = '') or (TxtRight = '') then
        Exit;
      MsgWParam := StrToIntDef (TxtRight, MsgWParam);
      if MsgWParam = VK_UP then begin
        keybd_event(VK_SHIFT, 0, 0, 0);
        keybd_event(VK_TAB, 0, 0, 0);
        keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, 0);
        Handled := True;
      end
      else begin
        PostMessage (Screen.ActiveControl.Handle, WM_KEYDOWN,
                   MsgwParam, Msg.lParam);
        Handled := True;
      end;
    end;
  end;
end;   // of TFrmTndRegBagCA.OnMessage

//=============================================================================

procedure TFrmTndRegBagCA.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin  // of TFrmTndRegBagCA.FormKeyDown
  inherited;

  if (Shift = [ssAlt, ssCtrl]) and (Chr(Key) in ['S', 's']) then begin
    if MessageDlg (CtTxtAskExecInterrupt, mtConfirmation,
                   [mbYes, mbNo], 0) = mrYes then
      ModalResult := mrAbort;
  end

  else if (Shift = [ssCtrl]) and (Key = VK_F1) then
    ShowAbout;
end;   // of TFrmTndRegBagCA.FormKeyDown

//=============================================================================

procedure TFrmTndRegBagCA.BtnOkClick(Sender: TObject);
begin  // of TFrmTndRegBagCA.BtnOkClick
  inherited;
  EnableSysKeys;                   //R2014.2.Req(51030).CAFR.PayOut-Without-Ended-Sale.TCS-Ravi.
  if CheckAndSaveBags then
    ModalResult := mrOK;
end;   // of TFrmTndRegBagCA.BtnOkClick

//=============================================================================

procedure TFrmTndRegBagCA.FormCreate(Sender: TObject);
begin  // of TFrmTndRegBagCA.FormCreate
  inherited;
  if CheckDBAvailable then begin
    try
      if not Assigned (DmdFpn) then
        DmdFpn := TDmdFpn.Create (Self);
      if not Assigned (DmdFpnUtils) then
        DmdFpnUtils := TDmdFpnUtils.Create (Self);
        if DmdFpnUtils.QueryInfo
            (#10'SELECT ValWidtIdtBag = ValParam' +
             #10'FROM ApplicParam' +
             #10'WHERE IdtApplicParam = ' +
               AnsiQuotedStr('ValWidthIdtBag', '''')) then
          ViValWidthIdtBag := DmdFpnUtils.QryInfo.FieldByName ('ValWidtIdtBag').AsInteger;
    finally
      DmdFpnUtils.ClearQryInfo;
      DmdFpnUtils.CloseInfo;
    end;
  end
  else begin
    ViValWidthIdtBag := DmdFpnTender.ValWidthIdtBag;
  end;
  Application.OnMessage := OnMessage;
end;   // of TFrmTndRegBagCA.FormCreate

//=============================================================================

procedure TFrmTndRegBagCA.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin  // of TFrmTndRegBagCA.FormCloseQuery
  inherited;
  if (ModalResult = mrCancel) then
    // <Alt+F4> is not allowed
    CanClose := False;
end;   // of TFrmTndRegBagCA.FormCloseQuery

//=============================================================================

procedure TFrmTndRegBagCA.FormDestroy(Sender: TObject);
begin  // of TFrmTndRegBagCA.FormDestroy
  if assigned(FrmNumericInput) then begin
    FrmNumericInput.Free;
    FrmNumericInput := nil;
  end;
  inherited;
end;   // of TFrmTndRegBagCA.FormDestroy

//=============================================================================

//R2013.2.Req32040.CARU.Container-Number.TCS-TK.Start
procedure TFrmTndRegBagCA.WMActivated(var Message: TMessage);
begin
  if CheckAndSaveBags then
    ModalResult := mrOK;
end;

//=============================================================================
//R2013.2.Req32040.CARU.Container-Number.TCS-TK.End

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
