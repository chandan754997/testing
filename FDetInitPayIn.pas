//=====Copyright 2009 (c) Centric Retail Solutions. All rights reserved.=======
// Packet   : Flexpoint Development Castorama
// Unit     : fDetInitPayIn = DETail form for INITial PAYIN
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetInitPayIn.pas,v 1.7 2010/04/13 12:39:36 BEL\DVanpouc Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FDetInitPayIn - CVS revision 1.7
//=============================================================================

unit FDetInitPayIn;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OvcBase, ComCtrls, StdCtrls, Buttons, ExtCtrls, OvcEF, OvcPB,
  SfMaintenance_BDE_DBC, OvcPF, ScUtils, ScDBUtil_BDE, ScTskMgr_BDE_DBC, Db,
  DFpnSafeTransaction, SfDetail_BDE_DBC, cxMaskEdit, ScUtils_Dx, cxControls,
  cxContainer, cxEdit, cxTextEdit;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtNtAllowDateBefore = 'It is not allowed to enter a date before %s';
  CtTxtSaveChanges       = 'Do you want to save the changes?';
  // Error messages
  CtTxtEmCombRunPmReq    = 'Run parameter "%s" can''t be used ' +
                           'without parameter "%s"';
  CtTxtEmUnableToRead    = 'Unable to read %s log from %s';

//=============================================================================
// Width of at run time created components
//=============================================================================

var
  ViValWidthSpace  : Integer =   1;    // Width between 2 components
  ViValWidthLblSign: Integer =  10;    // Width of labels for signs (X, =)
  ViValWidthQty    : Integer =  50;    // Width of component for quantity
  ViValWidthVal    : Integer =  70;    // Width of component for value
  ViValWidthDescr  : Integer = 140;    // Width of component for description
  ViValWidthBtn    : Integer =  20;    // Width for buttons
  ViValWidthDetail : Integer = 140;    // Width of component for descr.detail

  // Standard provided run states for application
  ViFlgVNDV  : Boolean = False;        // Start up by focus on first field
  StrHelp          : String;

//=============================================================================

type
  TObjOperator = class
  private
    FIdtOperator   : string;          // Ident. of the operator
    FTxtOperator   : string;           // Name of the operator
    FFlgPayIn      : Boolean;          // Is there a PayIn value?
    FValPayIn      : Double;           // Value just initialised.
    FValTotPayIn   : Double;           // Total Initial Value already init.
    FNumSeq        : Integer;          // Number of the sequence
  protected
    procedure FillFromDB (DsrSource    : TDataSet;
                          ValInitValue : Double  ;
                          ValTotAmount : Double  ); virtual;
  public
    property IdtOperator : string read  FIdtOperator
                                   write FIdtOperator;
    property TxtOperator : string read  FTxtOperator
                                  write FTxtOperator;
    property FlgPayIn    : Boolean read FFlgPayIn
                                   write FFlgPayIn;
    property ValPayIn    : Double read  FValPayIn
                                  write FValPayIn;
    property ValTotPayIn : Double read  FValTotPayIn
                                  write FValTotPayIn;
    property NumSeq      : Integer read  FNumSeq
                                   write FNumSeq;
  end;  // of TObjOperator

//=============================================================================

type
  TPnlInitPayIn = class (TPanel)
  private
    FSvcMEIdtOperator   : TSvcMaskEdit;   // Number of the operator
    FSvcMETxtOperator   : TSvcMaskEdit;   // Name of the operator
    FSvcLFNumAmount     : TSvcLocalField;   // Amount
    FSvcLFNumTotAmount  : TSvcLocalField;   // Total Amount already init.
    FSvcDBLblCurrency   : TSvcDBLabelLoaded;// Currency
    FChkBxSelected      : TCheckBox;        // Selected
    FObjOperator        : TObjOperator;     // Information of current operator

    function FocusNextPnlPayIn (FlgUp : Boolean) : Boolean; virtual;
  public
    // Constructor and destructor
    constructor CreateInitPayIn (Sender      : TComponent  ;
                                 Parent      : TWinControl ;
                                 ObjOperator : TObjOperator); virtual;
    procedure ChkBxOnClick (Sender: TObject); virtual;
    procedure SvcLFKeyDown (    Sender : TObject;
                            var Key    : Word;
                                Shift  : TShiftState); virtual;
    procedure SvcLFChange (Sender : TObject); virtual;
    function CreateSvcIdtOperator (var ValLeft  : Integer;
                                       ValWidth : Integer) : TSvcMaskEdit;
                                                                        virtual;
    function CreateSvcTxtOperator (var ValLeft  : Integer;
                                       ValWidth : Integer) : TSvcMaskEdit;
                                                                        virtual;
    function CreateSvcAmount (var ValLeft  : Integer;
                                  ValWidth : Integer) : TSvcLocalField; virtual;
    function CreateSvcTotAmount (var ValLeft  : Integer;
                                     ValWidth : Integer) : TSvcLocalField;
                                                                        virtual;
    function CreateSvcLbl (var ValLeft  : Integer) : TSvcDBLabelLoaded; virtual;
    function CreateChkBxSel (var ValLeft : Integer) : TCheckBox; virtual;
    procedure PnlEnter (Sender : TObject); virtual;
    procedure PnlExit (Sender : TObject); virtual;
    procedure FocusFirst; virtual;
    procedure ClearLastRegistration; virtual;

    property SvcMEIdtOperator : TSvcMaskEdit read  FSvcMEIdtOperator
                                               write FSvcMEIdtOperator;
    property SvcMETxtOperator : TSvcMaskEdit read  FSvcMETxtOperator
                                               write FSvcMETxtOperator;
    property SvcLFNumAmount : TSvcLocalField read  FSvcLFNumAmount
                                             write FSvcLFNumAmount;
    property SvcLFNumTotAmount : TSvcLocalField read  FSvcLFNumTotAmount
                                                write FSvcLFNumTotAmount;
    property SvcDBLblCurrency : TSvcDBLabelLoaded read  FSvcDBLblCurrency
                                                  write FSvcDBLblCurrency;
    property ChkBxSelected : TCheckBox read  FChkBxSelected
                                       write FChkBxSelected;
    property ObjOperator : TObjOperator read  FObjOperator
                                        write FObjOperator;
  end;

//=============================================================================
// Global type definitions
//=============================================================================

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetInitPayIn = class(TFrmDetail)
    DTPckTransAction: TDateTimePicker;
    TbShtInitPayIn: TTabSheet;
    SbxOperator: TScrollBox;
    PnlTop: TPanel;
    BtnSelectAll: TButton;
    BtnDeselectAll: TButton;
    LblTraitementDate: TLabel;
    LblNumOperator: TLabel;
    LblNameOperator: TLabel;
    LblAmount: TLabel;
    LblSelect: TLabel;
    LblAcpAmount: TLabel;
    procedure BtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure BtnDeselectAllClick(Sender: TObject);
    procedure DTPckTransActionKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DTPckTransActionKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DTPckTransActionUserInput(Sender: TObject;
      const UserString: String; var DateAndTime: TDateTime;
      var AllowChange: Boolean);
    procedure DTPckTransActionCloseUp(Sender: TObject);
  private
    { Private declarations }
  protected
    FFlgChanged         : Boolean;     // Is there something changed
    FDatReg             : TDate;       // Date to initialise
    FValInitPayIn       : Double;      // Value of initial PayIn
    FLstOperators       : TList;       // List of Operators
    FFlgEverActivated   : Boolean;     // Indicates first time form is activated
    FlgReBuildList      : Boolean;

    function GetFlgChanged : Boolean; virtual;
    procedure SetAllOperators (FlgCheck : Boolean); virtual;
    function FindNextIdtSafeTrans  (LstSafeTrans : TLstSafeTransaction;
                                    IdtSafeTrans : Integer  ) : Integer;virtual;
    function CreateNewSafeTransaction (    CodType    : Integer;
                                           IdtOperReg : string ;
                                       var NumSeq     : Integer;
                                           DatReg     : TDate):
                                                   TObjSafeTransaction; virtual;
    function CreateNewTransDetail (ObjSafeTrans: TObjSafeTransaction) :
                                                       TObjTransDetail; virtual;
    procedure FinishRegistration; virtual;
    procedure ClearRegistraction; virtual;
    procedure SaveRegistraction; virtual;
  public
    DateHelp           : TDateTime;
    constructor Create (AOwner : TComponent); override;
    function FindNextPnl (PnlStart : TPnlInitPayIn;
                          FlgUp    : Boolean      ) : TPnlInitPayIn; virtual;
    procedure RemoveOldInitPays; virtual;
    procedure BuildOperators ; virtual;
    property ValInitPayIn : Double read  FValInitPayIn
                                   write FValInitPayIn;
    property FlgEverActivated : Boolean read  FFlgEverActivated
                                        write FFlgEverActivated;
    property FlgChanged : Boolean read GetFlgChanged;
  published
    property DatReg : TDate read  FDatReg
                            write FDatReg;
    property LstOperators : TList read  FLstOperators
                                  write FLstOperators;
  end;

//=============================================================================

var
  FrmDetInitPayIn: TFrmDetInitPayIn;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  DFpnUtils,
  UFpsSyst,
  
  DFpnInitPayIn,
  DFpnTender,
  DFpnTenderCA,
  DFpnTenderGroup,
  DFpnTenderGroupCA,
  DFpnSafeTransactionCA,
  FMntInitPayIn;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'fDetInitPayIn';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetInitPayIn.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2010/04/13 12:39:36 $';

//*****************************************************************************
// Implementation of TObjOperator
//*****************************************************************************

//=============================================================================
// TObjOperator.FillFromDB : Fills the object with the values found in the
// given dataset.  Set the Initial value and the Total Value
//=============================================================================

procedure TObjOperator.FillFromDB (DsrSource    : TDataSet;
                                   ValInitValue : Double  ;
                                   ValTotAmount : Double  );
begin  // of TObjOperator.FillFromDB
  TxtOperator := DsrSource.FieldByName ('TxtName').AsString;
  IdtOperator := DsrSource.FieldByName ('IdtOperator').AsString;
  ValTotPayIn := ValTotAmount;
  // if ObjOperator.ValTotPayIn <> 0 then ...
  if Abs (ValTotAmount) >= CtValMinFloat then
    ValPayIn := 0
  else
    ValPayIn := DmdFpnInitPayIn.ValInit;
end;   // of TObjOperator.FillFromDB

//*****************************************************************************
// Implementation of TPnlInitPayIn
//*****************************************************************************

constructor TPnlInitPayIn.CreateInitPayIn (Sender      : TComponent  ;
                                           Parent      : TWinControl ;
                                           ObjOperator : TObjOperator);
var
  ValLeft          : Integer;          // Var-parameter for CreateHeader
begin  // of TPnlInitPayIn.CreateInitPayIn
  Self := TPnlInitPayIn.Create (Sender);
  Self.Top := TScrollBox (Parent).VertScrollBar.Range;
  Self.Height := 30;
  TScrollBox (Parent).VertScrollBar.Range :=
    TScrollBox (Parent).VertScrollBar.Range + Self.Height;
  Self.Parent := Parent;
  Self.Align := alTop;
  Self.BevelOuter := bvNone;
  Self.OnEnter := PnlEnter;
  Self.OnExit := PnlExit;
  Self.ObjOperator := ObjOperator;
  ValLeft := 8;
  SvcMEIdtOperator := CreateSvcIdtOperator (ValLeft, 73);
  SvcMETxtOperator := CreateSvcTxtOperator (ValLeft, 193);
  SvcLFNumAmount   := CreateSvcAmount (ValLeft, 73);
  SvcDBLblCurrency := CreateSvcLbl (ValLeft);
  ValLeft := 435;
  ChkBxSelected    := CreateChkBxSel (ValLeft);
  SvcLFNumTotAmount:= CreateSvcTotAmount (ValLeft, 73);

  SvcMEIdtOperator.Text  := ObjOperator.IdtOperator;
  SvcMETxtOperator.Text  := ObjOperator.TxtOperator;
  SvcLFNumAmount.AsFloat     := ObjOperator.ValPayIn;
  SvcLFNumTotAmount.AsFloat  := ObjOperator.ValTotPayIn;
  ChkBxSelected.Checked := False;
end;   // of TPnlInitPayIn.CreateInitPayIn

//=============================================================================

function TPnlInitPayIn.FocusNextPnlPayIn (FlgUp : Boolean) : Boolean;
var
  PnlFocus         : TPnlInitPayIn;    // Find panel to focus on
begin  // of TPnlInitPayIn.FocusNextPnlPayIn
  PnlFocus := Self;
  repeat
    PnlFocus := TFrmDetInitPayIn(Owner).FindNextPnl (PnlFocus, FlgUp);
    if Assigned (PnlFocus) then
      Break;
  until not Assigned (PnlFocus);
  Result := Assigned (PnlFocus);
  if Result then
    PnlFocus.FocusFirst
end;   // of TPnlInitPayIn.FocusNextPnlPayIn

//=============================================================================

procedure TPnlInitPayIn.ChkBxOnClick (Sender: TObject);
begin  // of TPnlInitPayIn.ChkBxOnClick
  ObjOperator.FlgPayIn := TCheckBox (Sender).Checked;
  SvcLFNumAmount.Enabled := TCheckBox (Sender).Checked;
  if SvcLFNumAmount.Enabled then
    SvcLFNumAmount.SetFocus;
end;   // of TPnlInitPayIn.ChkBxOnClick

//=============================================================================

procedure TPnlInitPayIn.SvcLFKeyDown (    Sender : TObject;
                                      var Key    : Word;
                                          Shift  : TShiftState);
begin  // of TPnlInitPayIn.SvcLFKeyDown
  if (Shift = []) and (Key = VK_RETURN) then begin
    FocusNextPnlPayIn (False);
    Key := 0;
  end
  else if (Shift = []) and (Key in [VK_UP, VK_DOWN]) then begin
    FocusNextPnlPayIn (Key = VK_UP);
    Key := 0;
  end;
end;   // of TPnlInitPayIn.SvcLFKeyDown

//=============================================================================

procedure TPnlInitPayIn.SvcLFChange (Sender : TObject);
begin  // of TPnlInitPayIn.SvcLFChange
  ObjOperator.ValPayIn := TSvcLocalField (Sender).AsFloat;
end;   // of TPnlInitPayIn.SvcLFChange

//=============================================================================

function TPnlInitPayIn.CreateSvcIdtOperator (var ValLeft  : Integer;
                                                 ValWidth : Integer) :
                                                                 TSvcMaskEdit;
begin  // of TPnlInitPayIn.CreateSvcIdtOperator
  Result := TSvcMaskEdit.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 5;
  Result.Left          := ValLeft;
  Result.Width         := ValWidth;
  Result.Enabled       := False;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateSvcIdtOperator

//=============================================================================

function TPnlInitPayIn.CreateSvcTxtOperator
                                      (var ValLeft  : Integer;
                                           ValWidth : Integer) : TSvcMaskEdit;
begin  // of TPnlInitPayIn.CreateSvcTxtOperator
  Result               := TSvcMaskEdit.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 5;
  Result.Left          := ValLeft;
  Result.Properties.MaxLength := 30;
  Result.Width         := ValWidth;
  Result.Enabled       := False;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateSvcTxtOperator

//=============================================================================

function TPnlInitPayIn.CreateSvcAmount (var ValLeft  : Integer;
                                            ValWidth : Integer) :TSvcLocalField;
begin  // of TPnlInitPayIn.CreateSvcAmount
  Result               := TSvcLocalField.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 5;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign,efoRightJustify];
  Result.Width         := ValWidth;
  Result.Enabled       := False;
  Result.OnKeyUp       := SvcLFKeyDown;
  Result.OnChange      := SvcLFChange;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateSvcAmount

//=============================================================================

function TPnlInitPayIn.CreateSvcTotAmount (var ValLeft  : Integer;
                                               ValWidth : Integer) :
                                                                 TSvcLocalField;
begin  // of TPnlInitPayIn.CreateSvcTotAmount
  Result               := TSvcLocalField.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 5;
  Result.Left          := ValLeft;
  Result.DataType      := pftDouble;
  Result.Local         := True;
  Result.LocalOptions  := [lfoLimitValue];
  Result.Options       := Result.Options + [efoRightAlign,efoRightJustify];
  Result.Width         := ValWidth;
  Result.Enabled       := False;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateSvcTotAmount

//=============================================================================

function TPnlInitPayIn.CreateSvcLbl (var ValLeft  : Integer) : TSvcDBLabelLoaded;
begin  // of TPnlInitPayIn.CreateSvcLbl
  Result               := TSvcDBLabelLoaded.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 9;
  Result.Left          := ValLeft;
  Result.Caption       := DmdFpnUtils.IdtCurrencyMain;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateSvcLbl

//=============================================================================

function TPnlInitPayIn.CreateChkBxSel (var ValLeft : Integer) : TCheckBox;
begin  // of TPnlInitPayIn.CreateChkBxSel
  Result := TCheckBox.Create (Owner);
  Result.Parent        := Self;
  Result.Top           := 5;
  Result.Left          := ValLeft;
  Result.OnClick       := ChkBxOnClick;
  Result.OnKeyUp       := SvcLFKeyDown;
  Inc (ValLeft, Result.Width + ViValWidthSpace);
end;   // of TPnlInitPayIn.CreateChkBxSel

//=============================================================================

procedure TPnlInitPayIn.PnlEnter (Sender : TObject);
begin  // of TPnlInitPayIn.PnlEnter
  BevelOuter := bvRaised;
end;   // of TPnlInitPayIn.PnlEnter

//=============================================================================

procedure TPnlInitPayIn.PnlExit (Sender : TObject);
begin  // of TPnlInitPayIn.PnlExit
  BevelOuter := bvNone;
end;   // of TPnlInitPayIn.PnlExit

//=============================================================================

procedure TPnlInitPayIn.FocusFirst;
begin  // of TPnlInitPayIn.FocusFirst
  if SvcLFNumAmount.Enabled then
    SvcLFNumAmount.SetFocus
  else if ChkBxSelected.Enabled then
    ChkBxSelected.SetFocus;
end;   // of TPnlInitPayIn.FocusFirst

//=============================================================================

procedure TPnlInitPayIn.ClearLastRegistration;
begin  // of TPnlInitPayIn.ClearLastRegistration
  SvcLFNumAmount.AsFloat     := ObjOperator.ValPayIn;
end;   // of TPnlInitPayIn.ClearLastRegistration

//=============================================================================

//*****************************************************************************
// Implementation of TFrmDetInitPayIn
//*****************************************************************************

function TFrmDetInitPayIn.GetFlgChanged : Boolean;
var
  CntOperator      : Integer;          // Loop all operators
begin  // of TFrmDetInitPayIn.GetFlgChanged
  Result := False;
  for CntOperator := 0 to Pred (LstOperators.Count) do begin
    if TObjOperator (LstOperators [CntOperator]).FlgPayIn then begin
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmDetInitPayIn.GetFlgChanged

//=============================================================================
// TFrmDetInitPayIn.SetAllOperators : Changes the state of the checkbox on the
// dynamic created panels
//=============================================================================

procedure TFrmDetInitPayIn.SetAllOperators (FlgCheck : Boolean);
var
  PnlInitPayIn     : TPnlInitPayIn;    // Initial PayIn panel to work with.
begin  // of TFrmDetInitPayIn.SetAllOperators
  inherited;
  PnlInitPayIn := nil;
  PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
  while PnlInitPayIn <> nil do begin
    PnlInitPayIn.ChkBxSelected.Checked := FlgCheck;
    PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
  end;
end;   // of TFrmDetInitPayIn.SetAllOperators

//=============================================================================
// TFrmDetInitPayIn.FindNextIdtSafeTrans : searches the next IdtSafeTrans
// in the passed list (next Idt = Idt differing from the passed Idt)
//                                  -----
// INPUT   : LstSafeTrans = list of safetransactions to search next Idt in.
//           IdtSafeTrans = IdtSafeTransaction to start with.
//                                  -----
// FUNCRES : next IdtSafeTransaction, -1 if no next Idt found.
//=============================================================================

function TFrmDetInitPayIn.FindNextIdtSafeTrans
                                 (LstSafeTrans : TLstSafeTransaction;
                                  IdtSafeTrans : Integer            ) : Integer;
var
  CntItem          : Integer;          // Counter item scroll through lis
begin  // of TFrmDetInitPayIn.FindNextIdtSafeTrans
  Result := -1;
  CntItem := LstSafeTrans.IndexOfIdt (IdtSafeTrans);
  if CntItem < 0 then
    Exit;
  repeat
    Inc (CntItem);
  until (CntItem >= LstSafeTrans.Count)
     or (LstSafeTrans.SafeTransaction[CntItem].IdtSafeTransaction <>
         IdtSafeTrans);

  if CntItem < LstSafeTrans.Count then
    Result := LstSafeTrans.SafeTransaction[CntItem].IdtSafeTransaction;
end;   // of TFrmDetInitPayIn.FindNextIdtSafeTrans

//=============================================================================
// TFrmDetInitPayIn.CreateNewSafeTransaction : creates a new SafeTransaction in
// LstSafeTransaction, with the properties for the passed CodType, IdtOperReg
// and Date of registration and the current settings.
//                                  -----
// INPUT   : CodType    = CodType of the SafeTransaction to create.
//           IdtOperReg = Identification of the operator to registrate for
//           NumSeq     = Sequence in the safetransaction
//           DatReg     = Date onwich take effect
//
//                                  -----
// FUNCRES : created SafeTransaction.
//=============================================================================

function TFrmDetInitPayIn.CreateNewSafeTransaction (    CodType    : Integer;
                                                        IdtOperReg : string;
                                                    var NumSeq     : Integer;
                                                        DatReg     : TDate) :
                                                            TObjSafeTransaction;
begin  // of TFrmDetInitPayIn.CreateNewSafeTransaction
  // Create SafeTransaction
  Result := LstSafeTransaction.AddSafeTransaction (0, NumSeq,
                                                   CodType, CtCodDbsNew);
  Result.IdtOperReg      := DmdFpnUtils.IdtOperatorCurrentOperator;
  Result.IdtOperator     := IdtOperReg;
  Result.DatReg          := DatReg;
  Result.IdtCurrency     := DmdFpnUtils.IdtCurrencyMain;
  Result.ValExchange     := DmdFpnUtils.ValExchangeCurrencyMain;
  Result.FlgExchMultiply := DmdFpnUtils.FlgExchMultiplyCurrencyMain;
  Inc (NumSeq);
end;   // of TFrmDetInitPayIn.CreateNewSafeTransaction

//=============================================================================

function TFrmDetInitPayIn.CreateNewTransDetail
                         (ObjSafeTrans : TObjSafeTransaction) : TObjTransDetail;
begin  // of TFrmDetInitPayIn.CreateNewTransDetail
  Result := LstSafeTransaction.AddTransDetail
      (ObjSafeTrans.IdtSafeTransaction, ObjSafeTrans.NumSeq, 1, 1, CtCodDbsNew);
  Result.QtyUnit     := 1;
  Result.IdtCurrency := DmdFpnUtils.IdtCurrencyMain;
  Result.ValExchange := DmdFpnUtils.ValExchangeCurrencyMain;
end;   // of TFrmDetInitPayIn.CreateNewTransDetail

//=============================================================================
// TFrmDetInitPayIn.FinishRegistration : end-execution of registration.
//=============================================================================

procedure TFrmDetInitPayIn.FinishRegistration;
var
  CntOperator      : Integer;          // Loop all operators
  CntExPrn         : Integer;          // Number of copies to print
  ObjOperator      : TObjOperator;     // Current Operator to process

  ObjSafeTrans     : TObjSafeTransaction;   // SafeTransaction to work with
  ObjSafeDetail    : TObjTransDetail;       // SafeTransDetail to work with
  NumSeq           : Integer;          // Sequence of the detail
begin  // of TFrmDetInitPayIn.FinishRegistration
  if LstOperators.Count > 0 then begin
    LstSafeTransaction.ClearSafeTransactions;
    NumSeq := 1;
    for CntOperator := 0 to Pred (LstOperators.Count) do begin
      ObjOperator := TObjOperator (LstOperators[CntOperator]);
      if ObjOperator.FlgPayIn then begin
        ObjSafeTrans :=
            CreateNewSafeTransaction (CtCodSttPayInInit,
                                 ObjOperator.IdtOperator,
                                 NumSeq, DatReg);
        // Create SafeTransdetail
        ObjSafeDetail := CreateNewTransDetail (ObjSafeTrans);
        ObjSafeDetail.ValUnit := ObjOperator.FValPayIn;
      end;
    end;
    DmdFpnSafeTransaction.InsertLstSafeTransaction (LstSafeTransaction);
    for CntExPrn := 0 to Pred (DmdFpnInitPayIn.NumExPrn) do
      SvcTaskMgr.LaunchTask ('GenerateRapport');
  end;
  DmdFpnSafeTransactionCA.ActivateInitialPayin
end;   // of TFrmDetInitPayIn.FinishRegistration

//=============================================================================

procedure TFrmDetInitPayIn.ClearRegistraction;
var
  CntControls      : Integer;          // Loop all controls on the scrollbox
begin  // of TFrmDetInitPayIn.ClearRegistraction
  SbxOperator.VertScrollBar.Range := 0;
  FlgReBuildList := False;
  for CntControls := Pred (LstOperators.Count) downto 0 do begin
    TObjOperator (LstOperators.Items [CntControls]).Destroy;
  end;
  LstOperators.Clear;
  for CntControls := Pred (SbxOperator.ControlCount) downto 0 do begin
    SbxOperator.Controls [CntControls].Destroy;
  end;
  BtnOK.Visible          := False;
  BtnSelectAll.Enabled   := False;
  BtnDeSelectAll.Enabled := False;
end;   // of TFrmDetInitPayIn.ClearRegistraction

//=============================================================================

procedure TFrmDetInitPayIn.SaveRegistraction;
var
  PnlInitPayIn   : TPnlInitPayIn; // Initial PayIn panel to work with.
  StrValCheck    : string;        // Initial PayIn controls Checkbox checked Y/N
begin  // of TFrmDetInitPayIn.SaveRegistraction
  PnlInitPayIn := nil;
  PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
  StrHelp := '';
  while PnlInitPayIn <> nil do begin
    if PnlInitPayIn.ChkBxSelected.Checked then
      StrValCheck := 'True'
    else
      StrValCheck := 'False';
    StrHelp      := StrHelp + PnlInitPayIn.SvcLFNumAmount.AsString + '|' +
                    StrValCheck + '|' +
                    PnlInitPayIn.SvcLFNumTotAmount.AsString + '|';
    PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
  end;
end;   // of TFrmDetInitPayIn.SaveRegistraction
//=============================================================================

constructor TFrmDetInitPayIn.Create (AOwner : TComponent);
begin  // of TFrmDetInitPayIn.Create
  inherited;
  BtnApply.Visible := False;
  DTPckTransAction.Date := Now;
  if not Assigned (LstOperators) then
    LstOperators := TList.Create;
end;   // of TFrmDetInitPayIn.Create

//=============================================================================

function TFrmDetInitPayIn.FindNextPnl(PnlStart : TPnlInitPayIn;
                                      FlgUp    : Boolean      ): TPnlInitPayIn;
var
  CntCtl           : Integer;          // Counter controls
  NumCtlCheck      : Integer;          // Number of control to check
begin  // of TFrmDetInitPayIn.FindNextPnl
  Result := nil;
  if not Assigned (PnlStart) then begin
    if FlgUp then
      NumCtlCheck := Pred (SbxOperator.ControlCount)
    else
      NumCtlCheck := 0;
  end // of if not Assigned (PnlStart)
  else begin
    NumCtlCheck := -1;
    for CntCtl := 0 to Pred (SbxOperator.ControlCount) do begin
      if SbxOperator.Controls[CntCtl] = PnlStart then begin
        NumCtlCheck := CntCtl;
        Break;
      end; // of if SbxOperator.Controls[CntCtl] = PnlStart
    end; // of for CntCtl := 0 to Pred (SbxOperator.ControlCount)
    if FlgUp then
      Dec (NumCtlCheck)
    else
      Inc (NumCtlCheck);
  end; // of else begin
  while (NumCtlCheck >= 0) and (NumCtlCheck < SbxOperator.ControlCount) do begin
    if SbxOperator.Controls[NumCtlCheck] is TPnlInitPayIn then begin
      Result := TPnlInitPayIn(SbxOperator.Controls[NumCtlCheck]);
      Break;
    end;
    if FlgUp then
      Dec (NumCtlCheck)
    else
      Inc (NumCtlCheck);
  end;
end;   // of TFrmDetInitPayIn.FindNextPnl

//=============================================================================
// TFrmDetInitPayIn.RemoveOldInitPays : Remove all initial payin's how are
// older than the given parameter.
//=============================================================================

procedure TFrmDetInitPayIn.RemoveOldInitPays;
var
  NumHistory       : Integer;          // Number of days to remove
begin  // of TFrmDetInitPayIn.RemoveOldInitPays
  NumHistory := DmdFpnInitPayIn.NumHistory;
  DmdFpnUtils.QryInfo.SQL.Clear;
  DmdFpnUtils.QryInfo.SQL.Add ('DELETE FROM INITPAYIN ');
  DmdFpnUtils.QryInfo.SQL.Add (' WHERE DATREG < ' +
         AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, Now - NumHistory) + ' ' +
                    FormatDateTime (ViTxtDBHouFormat, 0), ''''));
  DmdFpnUtils.QryInfo.ExecSQL;
end;   // of TFrmDetInitPayIn.RemoveOldInitPays

//=============================================================================

procedure TFrmDetInitPayIn.BuildOperators;
var
  ObjOperator      : TObjOperator;
  CntLoop          : Integer;
  CntLp            : Integer;
  QtyTotal         : Integer;          // Qty of initial PayIN's
  ValTotal         : Currency;         // Total value
  PnlInitPayIn     : TPnlInitPayIn;    // Initial PayIn panel to work with.
  ValCount         : Currency;         // Counted value
  IdtSafeTrans     : Integer;          // Idt of Safetransaction
  IdtOperator      : string;           // Idt of operator
  TxtLeft          : string;
  TxtRight         : string;
begin  // of TFrmDetInitPayIn.BuildOperators
  LockWindowUpdate (SbxOperator.Handle);
  try
    DatReg := DTPckTransAction.Date;
    // Get all the needed safetransactions.
    LstSafeTransaction.ClearSafeTransactions;
    DmdFpnSafeTransactionCA.BuildListSafeTransAndDetailInitPayIn
        (DatReg, LstSafeTransaction);
    try
      if DmdFpnUtils.QueryInfo
        (#10'SELECT TxtName, IdtOperator FROM Operator') then begin
        while not DmdFpnUtils.QryInfo.Eof do begin
          ValCount := 0;
          if LstSafeTransaction.Count <> 0 then begin
            IdtSafeTrans :=
                LstSafeTransaction.SafeTransaction [0].IdtSafeTransaction;
            // Get the total for given operator
            repeat
              IdtOperator :=
                     DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString;
              TLstSafeTransactionCA (LstSafeTransaction).TotalTransForOperator
                  (IdtSafeTrans, CtCodSttPayInInit, IdtOperator, 1, True,
                   QtyTotal, ValTotal);
              ValCount := ValCount + ValTotal;
              IdtSafeTrans := FindNextIdtSafeTrans (LstSafeTransaction,
                                                    IdtSafeTrans);
            until IdtSafeTrans < 0;
          end; // of if LstSafeTransaction.Count <> 0
          ObjOperator := TObjOperator.Create;
          ObjOperator.FillFromDB (DmdFpnUtils.QryInfo,
                                  DmdFpnInitPayIn.ValInit, ValCount);
          LstOperators.Add (ObjOperator);
          DmdFpnUtils.QryInfo.Next;
        end; // of while not DmdFpnUtils.QryInfo.Eof
      end; // of if DmdFpnUtils.QueryInfo
    finally
      DmdFpnUtils.CloseInfo;
    end;  // of try... finally
    // Make list with all operators.
    for CntLoop := 0 to Pred (LstOperators.Count) do
      TPnlInitPayIn.CreateInitPayIn (Self, SbxOperator,
                                     TObjOperator(LstOperators [CntLoop]));
    if FrmMntInitPayIn.FFlgVNDV then begin
      CntLp := LstOperators.Count-1;
      LstOperators[CntLp];
      ObjOperator := TObjOperator (LstOperators[CntLp]);
      TxtRight := StrHelp;
      if Length(TxtRight) > 10 then begin
        PnlInitPayIn := nil;
        PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
        while PnlInitPayIn <> nil do begin
          for CntLoop := 0 to 2 do begin
            case CntLoop of
              0 : begin
                    SplitString(TxtRight,'|',TxtLeft,TxtRight);
                    try
                      PnlInitPayIn.SvcLFNumAmount.AsFloat := StrToFloat(TxtLeft);
                      ObjOperator.FValPayIn := StrToFloat(TxtLeft);
                    except
                      PnlInitPayIn.SvcLFNumAmount.AsFloat := 0;
                    end; // of try ... except
                  end; // of begin
              1 : begin
                    SplitString(TxtRight,'|',TxtLeft,TxtRight);
                    if TxtLeft = 'True' then begin
                      PnlInitPayIn.ChkBxSelected.Checked := True;
                      ObjOperator.FFlgPayIn := True
                    end // of if TxtLeft = 'True'
                    else begin
                      PnlInitPayIn.ChkBxSelected.Checked := False;
                      ObjOperator.FFlgPayIn := False;
                    end; // of else begin
                  end; // of begin
              2 : begin
                    SplitString(TxtRight,'|',TxtLeft,TxtRight);
                  end; // of begin
            end; // of case CntLoop of
          end; // of for CntLoop := 0 to 2
          PnlInitPayIn := FindNextPnl (PnlInitPayIn, True);
          CntLp := CntLp - 1;
          if CntLp >= 0 then
            ObjOperator := TObjOperator (LstOperators[CntLp]);
        end; // of while PnlInitPayIn <> nil
      end; // of if Length(TxtRight) > 10 
      TPnlInitPayIn (FindNextPnl (nil, False)).FocusFirst;
    end; // of if FrmMntInitPayIn.FFlgVNDV
  finally
    LockWindowUpdate (0);
  end;
end;   // of TFrmDetInitPayIn.BuildOperators

//=============================================================================

procedure TFrmDetInitPayIn.FormCreate(Sender: TObject);
begin  // of TFrmDetInitPayIn.FormCreate
  inherited;
  if not Assigned (LstSafeTransaction) then
    LstSafeTransaction := TLstSafeTransactionCA.Create;
  if not Assigned (LstTenderGroup) then
    LstTenderGroup := TLstTenderGroup.Create;
  if not Assigned (LstTenderClass) then
    LstTenderClass := TLstTenderClass.Create;
  if not Assigned (LstTenderUnit) then
    LstTenderUnit := TLstTenderUnit.Create;
end;  // of TFrmDetInitPayIn.FormCreate

//=============================================================================

procedure TFrmDetInitPayIn.FormActivate(Sender: TObject);
Var
  Key                  : Word;
  Shift                : TShiftState;
begin  // of TFrmDetInitPayIn.FormActivate
  inherited;
  if not FlgEverActivated then begin
    ClearRegistraction;
    RemoveOldInitPays;
    if DTPckTransAction.Enabled then
      DTPckTransAction.SetFocus;
  end;
  FFlgEverActivated := True;
  if FrmMntInitPayIn.FFlgVNDV then begin    // For Brico Spain
    Key := VK_RETURN;
    Shift := [];
    DTPckTransActionKeyDown(Application,Key,Shift);
    DTPckTransActionKeyUp(Application,Key,Shift);
  end;
end;   // of TFrmDetInitPayIn.FormActivate

//=============================================================================

procedure TFrmDetInitPayIn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin  // of TFrmDetInitPayIn.FormClose
  inherited;
  LstOperators.Destroy;
  LstOperators := nil;
end;   // of TFrmDetInitPayIn.FormClose

//=============================================================================

procedure TFrmDetInitPayIn.FormDestroy(Sender: TObject);
begin  // of TFrmDetInitPayIn.FormDestroy
  inherited;
  LstSafeTransaction.Free;
  LstSafeTransaction := nil;
  LstTenderGroup.Free;
  LstTenderGroup := nil;
  LstTenderClass.Free;
  LstTenderClass := nil;
  LstTenderUnit.Free;
  LstTenderUnit := nil;
end;   // of TFrmDetInitPayIn.FormDestroy

//=============================================================================

procedure TFrmDetInitPayIn.BtnOKClick(Sender: TObject);
begin  // of TFrmDetInitPayIn.BtnOKClick
  inherited;
  BtnOK.Enabled := False;
  FinishRegistration;
  ModalResult := mrOk;
end;   // of TFrmDetInitPayIn.BtnOKClick

//=============================================================================

procedure TFrmDetInitPayIn.BtnSelectAllClick(Sender: TObject);
begin  // of TFrmDetInitPayIn.BtnSelectAllClick
  inherited;
  LockWindowUpdate (SbxOperator.Handle);
  try
    SetAllOperators (True);
  finally
    LockWindowUpdate (0);
  end;
end;   // of TFrmDetInitPayIn.BtnSelectAllClick

//=============================================================================

procedure TFrmDetInitPayIn.BtnDeselectAllClick(Sender: TObject);
begin  // of TFrmDetInitPayIn.BtnDeselectAllClick
  inherited;
  LockWindowUpdate (SbxOperator.Handle);
  try
    SetAllOperators (False);
  finally
    LockWindowUpdate (0);
  end;
end;   // of TFrmDetInitPayIn.BtnDeselectAllClick

//=============================================================================

procedure TFrmDetInitPayIn.DTPckTransActionKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetInitPayIn.DTPckTransActionKeyDown
  inherited;
  if (Shift = []) and (Key = VK_RETURN) then begin
    if DTPckTransAction.Date < Now - 1 then begin
      DTPckTransAction.Date := Now;
      raise Exception.Create (Format (CtTxtNtAllowDateBefore,
                          [FormatDateTime (CtTxtDatFormat, Date)]));
    end // of if DTPckTransAction.Date < Now - 1
    else
      FlgReBuildList := True
  end // of if (Shift = []) and (Key = VK_RETURN)
  else begin
    if FrmMntInitPayIn.FFlgVNDV then
      SaveRegistraction
    else
      ClearRegistraction;
  end; // of else begin
end;   // of TFrmDetInitPayIn.DTPckTransActionKeyDown

//=============================================================================

procedure TFrmDetInitPayIn.DTPckTransActionKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin  // of TFrmDetInitPayIn.DTPckTransActionKeyUp
  inherited;
  if (Shift = []) and (Key = VK_RETURN) then begin
    if FlgReBuildList then begin
      ClearRegistraction;
      BuildOperators;
      BtnOK.Visible := True;
      BtnCancel.Enabled := True;
      BtnSelectAll.Enabled := True;
      BtnDeSelectAll.Enabled := True;
      FlgReBuildList := False;
    end;
  DateHelp := DTPckTransAction.Date;
  end;
end;   // of TFrmDetInitPayIn.DTPckTransActionKeyUp

//=============================================================================

procedure TFrmDetInitPayIn.DTPckTransActionUserInput(Sender: TObject;
  const UserString: String; var DateAndTime: TDateTime;
  var AllowChange: Boolean);
begin  // of TFrmDetInitPayIn.DTPckTransActionUserInput
  inherited;
  if FrmMntInitPayIn.FFlgVNDV then begin
    SaveRegistraction;
    ClearRegistraction
  end
  else
    ClearRegistraction;
end;   // ofTFrmDetInitPayIn.DTPckTransActionUserInput

//=============================================================================

procedure TFrmDetInitPayIn.DTPckTransActionCloseUp(Sender: TObject);
Var
  Key     :Word;
  Shift   :TShiftState;
begin  // of TFrmDetInitPayIn.DTPckTransActionCloseUp
  inherited;
  if FrmMntInitPayIn.FFlgVNDV then begin
    SaveRegistraction;
    Key := VK_RETURN;
    Shift := [];
    DTPckTransActionKeyDown(Application,Key,Shift);
    DTPckTransActionKeyUp(Application,Key,Shift)
  end
  else
    ClearRegistraction;
end;   // of TFrmDetInitPayIn.DTPckTransActionCloseUp

//=============================================================================

procedure TFrmDetInitPayIn.BtnCancelClick(Sender: TObject);
begin // of TFrmDetInitPayIn.BtnCancelClick
  Close;
end; // of TFrmDetInitPayIn.BtnCancelClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of fDetInitPayIn


