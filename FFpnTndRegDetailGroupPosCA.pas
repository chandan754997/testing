//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : Castorama Flexpos Development
// Unit     : FFpnTndRegDetailGroupPosCA = Form FlexPoiNT TeNDeR REGister DETAIL
//            GROUP for POS CAstorama : shows the detailled registration for
//            a TenderGroup.
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndRegDetailGroupPosCA.pas,v 1.1 2006/12/22 14:43:33 NicoCV Exp $
// History :
// - Started from Castorama - FlexPoint 2.0 - FFpnTndRegDetailGroupPosCA - CVS revision 1.1.1.1
//=============================================================================

unit FFpnTndRegDetailGroupPosCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, Grids, StdCtrls, ScUtils, Buttons, ComCtrls, ExtCtrls,
  DFpnTenderGroupPosCA;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Parameters to configure StringGrid
//=============================================================================

var    // Columns in StringGrid
  ViNumColQtyUnit  : Integer = 0;      // Column QtyUnit
  ViNumColValUnit  : Integer = 1;      // Column ValUnit
  ViNumColValAmount: Integer = 2;      // Column ValAmount (QtyUnit * ValUnit)
  ViNumColTxtDescr : Integer = 3;      // Column Description

var    // Widths of columns in StringGrid
  ViValWidthQty    : Integer =  40;    // Width of column for quantity
  ViValWidthVal    : Integer =  70;    // Width of column for value
  ViValWidthDescr  : Integer = 140;    // Width of column for description

//*****************************************************************************
// TFrmTndRegDetailGroup
//                                  -----
// IMPORTANT REMARKS concering use of TFrmTndRegDetailGroup:
// - assumes ObjTenderGroup contains the TenderGroup to process.
// - assumes the global LstSafeTransaction contains the detail of the
//   TenderGroup to process.
// - StrGrdDetail.Rows[ARow].Objects[0] is used to keep the reference to the
//   the detail of the line (LstSafeTransAction.LstTransDetail.TransDetail[x]).
//                                  -----
// PROPERTIES :
// - ObjTenderGroup = TenderGroup to process.
// - IdtSafeTransaction = idt of the SafeTransaction to process.
// - NumSeqSafeTrans = NumSeq of the SafeTransaction to process.
// - LstRemove = list of SafeTransDetail-objects removed from StrGrdDetail.
//     The SafeTransDetail-objects still exists in LstSafeTransaction, they
//     can be removed from there only after the OK-button is pressed.
//*****************************************************************************

type
  TFrmTndRegDetailGroup = class(TFrmCommon)
    PnlBottom: TPanel;
    StsBarInfo: TStatusBar;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    BtnRemove: TBitBtn;
    StrGrdDetail: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StrGrdDetailDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StrGrdDetailSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnRemoveClick(Sender: TObject);
  private
    { Private declarations }
  protected
    // Datafields
    FTxtOrigCaption     : string;      // Save original caption of form
    FLstRemove          : TList;       // List of TransDetail attempt to remove
    FObjTenderGroup     : TObjTenderGroup;  // TenderGroup to process
    FIdtSafeTransaction : Integer;     // IdtSafeTransaction to process
    FNumSeqSafeTrans    : Integer;     // NumSeq of SafeTransaction to process
  public
    { Public declarations }
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Overriden methods
    procedure Loaded; override;
    // Methods
    procedure ClearDetail; virtual;
    procedure RefreshDetail; virtual;
    // Properties
    property TxtOrigCaption : string read FTxtOrigCaption;
    property LstRemove : TList read FLstRemove;
  published
    // Properties
    property ObjTenderGroup : TObjTenderGroup read  FObjTenderGroup
                                              write FObjTenderGroup;
    property IdtSafeTransaction : Integer read  FIdtSafeTransaction
                                          write FIdtSafeTransaction;
    property NumSeqSafeTrans : Integer read  FNumSeqSafeTrans
                                       write FNumSeqSafeTrans;
  end;  // of TFrmTndRegDetailGroup

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SrStnCom,

  DFpnSafeTransactionPosCA,

  RFpnCom,
  RFpnTenderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FFpnTndRegDetailGroupPosCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FFpnTndRegDetailGroupPosCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 14:43:33 $';

//*****************************************************************************
// Implementation of TFrmTndRegDetailGroup
//*****************************************************************************

//=============================================================================
// Constructors & destructors
//=============================================================================

constructor TFrmTndRegDetailGroup.Create (AOwner : TComponent);
begin  // of TFrmTndRegDetailGroup.Create
  FLstRemove := TList.Create;

  inherited Create (AOwner);
end;   // of TFrmTndRegDetailGroup.Create

//=============================================================================

destructor TFrmTndRegDetailGroup.Destroy;
begin  // of TFrmTndRegDetailGroup.Destroy
  FLstRemove.Free;
  FLstRemove := nil;

  inherited Destroy;
end;   // of TFrmTndRegDetailGroup.Destroy

//=============================================================================
// TFrmTndRegDetailGroup - Overriden methods
//=============================================================================

procedure TFrmTndRegDetailGroup.Loaded;
begin  // of TFrmTndRegDetailGroup.Loaded
  inherited Loaded;

  FTxtOrigCaption := Caption;
end;   // of TFrmTndRegDetailGroup.Loaded

//=============================================================================
// TFrmTndRegDetailGroup - Added methods
//=============================================================================

//=============================================================================
// TFrmTndRegDetailGroup.ClearDetail : clears StrGrdDetail.
//=============================================================================

procedure TFrmTndRegDetailGroup.ClearDetail;
var
  CntRow           : Integer;          // Counter rows in grid
begin  // of TFrmTndRegDetailGroup.ClearDetail
  if StrGrdDetail.RowCount > 2 then begin
    for CntRow := 1 to (StrGrdDetail.RowCount - 2) do
      StrGrdDetail.Rows[CntRow].Clear;
    StrGrdDetail.RowCount := 2;
  end;
  StrGrdDetail.Rows[2].Clear;

  BtnRemove.Enabled := False;
end;   // of TFrmTndRegDetailGroup.ClearDetail

//=============================================================================
// TFrmTndRegDetailGroup.RefreshDetail : refreshes StrGrdDetail according
// to the current IdtTenderGroup, IdtSafeTransaction, NumSeq with ignorance
// of detail in LstRemove.
//=============================================================================

procedure TFrmTndRegDetailGroup.RefreshDetail;
var
  QtyUnitTotal     : Integer;          // Count Total units
  ValAmountTotal   : Currency;         // Count Total amount
  NumTransDetail   : Integer;          // Number found TransDetail
  ObjTransDetail   : TObjTransDetail;  // Found TransDetail
  NumRow           : Integer;          // Current row in grid
begin  // of TFrmTndRegDetailGroup.RefreshDetail
  ClearDetail;
  QtyUnitTotal := 0;
  ValAmountTotal := 0;

  NumTransDetail := -1;
  repeat
    ObjTransDetail := LstSafeTransaction.NextTransDetail
                        (IdtSafeTransaction, NumSeqSafeTrans,
                         ObjTenderGroup.IdtTenderGroup, NumTransDetail);
    if not Assigned (ObjTransDetail) then
      Break;
    if LstRemove.IndexOf (ObjTransDetail) < 0 then begin
      QtyUnitTotal   := QtyUnitTotal + ObjTransDetail.QtyUnit;
      ValAmountTotal := ValAmountTotal +
                        (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit);
      StrGrdDetail.RowCount := StrGrdDetail.RowCount + 1;
      NumRow := StrGrdDetail.RowCount - 2;
      StrGrdDetail.Rows[NumRow].Objects[0] := ObjTransDetail;
      StrGrdDetail.Cells[ViNumColQtyUnit, NumRow]   :=
        IntToStr (ObjTransDetail.QtyUnit);
      StrGrdDetail.Cells[ViNumColValUnit, NumRow]   :=
        CurrToStrF (ObjTransDetail.ValUnit, ffFixed, ObjTenderGroup.QtyDecim);
      StrGrdDetail.Cells[ViNumColValAmount, NumRow] :=
        CurrToStrF (ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit,
                    ffFixed, ObjTenderGroup.QtyDecim);
      StrGrdDetail.Cells[ViNumColTxtDescr, NumRow]  := ObjTransDetail.TxtDescr;
    end;
  until not Assigned (ObjTransDetail);

  NumRow := StrGrdDetail.RowCount - 1;
  StrGrdDetail.Cells[ViNumColQtyUnit, NumRow]   := IntToStr (QtyUnitTotal);
  StrGrdDetail.Cells[ViNumColValAmount, NumRow] :=
    CurrToStrF (ValAmountTotal, ffFixed, ObjTenderGroup.QtyDecim);
  StrGrdDetail.Cells[ViNumColTxtDescr, NumRow]  := CtTxtRptTotal;

  BtnRemove.Enabled := StrGrdDetail.RowCount > 2;
end;   // of TFrmTndRegDetailGroup.RefreshDetail

//=============================================================================
// TFrmTndRegDetailGroup - Event Handlers
//=============================================================================

procedure TFrmTndRegDetailGroup.FormCreate(Sender: TObject);
begin  // of TFrmTndRegDetailGroup.FormCreate
  inherited;

  // Adjust width of columns in StrGrdDetail
  StrGrdDetail.ColWidths[ViNumColQtyUnit]   := ViValWidthQty;
  StrGrdDetail.ColWidths[ViNumColValUnit]   := ViValWidthVal;
  StrGrdDetail.ColWidths[ViNumColValAmount] := ViValWidthVal;
  StrGrdDetail.ColWidths[ViNumColTxtDescr]  := ViValWidthDescr;

  // Set titles in StrGrdDetail
  StrGrdDetail.Cells[ViNumColQtyUnit, 0]   := CtTxtHdrQtyUnit;
  StrGrdDetail.Cells[ViNumColValUnit, 0]   := CtTxtHdrValUnit;
  StrGrdDetail.Cells[ViNumColValAmount, 0] := CtTxtHdrValAmount;
  StrGrdDetail.Cells[ViNumColTxtDescr, 0]  := CtTxtHdrDescr;
end;   // of TFrmTndRegDetailGroup.FormCreate

//=============================================================================

procedure TFrmTndRegDetailGroup.FormActivate(Sender: TObject);
begin  // of TFrmTndRegDetailGroup.FormActivate
  inherited;
  if Assigned (ObjTenderGroup) then begin
    Caption := Format ('%s %s', [TxtOrigCaption, ObjTenderGroup.TxtPublDescr]);
    RefreshDetail;
  end
  else begin
    Caption := TxtOrigCaption;
    ClearDetail;
  end;
  ActiveControl := StrGrdDetail;
end;   // of TFrmTndRegDetailGroup.FormActivate

//=============================================================================

procedure TFrmTndRegDetailGroup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin  // of TFrmTndRegDetailGroup.FormKeyDown
  inherited;
  if (Shift = [ssCtrl]) and (Key = VK_F1) then
    ShowAbout;
end;   // of TFrmTndRegDetailGroup.FormKeyDown

//=============================================================================

procedure TFrmTndRegDetailGroup.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin  // of TFrmTndRegDetailGroup.FormCloseQuery
  inherited;

  if ModalResult = mrCancel then begin  // <Alt+F4> or border-icon close
    // Check if data is modified, and if so, ask confirmation to save
    if (LstRemove.Count > 0) and
       (MessageDlg (CtTxtConfirmChanges, mtConfirmation,
                    [mbYes, mbNo], 0) = mrYes) then
      ModalResult := mrOK;
  end;
end;   // of TFrmTndRegDetailGroup.FormCloseQuery

//=============================================================================

procedure TFrmTndRegDetailGroup.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  NumItem          : Integer;          // Index of item in list
begin  // of TFrmTndRegDetailGroup.FormClose
  inherited;

  try
    if (LstRemove.Count > 0) and (ModalResult = mrOK) then begin
      while LstRemove.Count > 0 do begin
        NumItem := LstSafeTransaction.LstTransDetail.IndexOf (LstRemove[0]);
        if NumItem >= 0 then begin
          LstSafeTransaction.LstTransDetail.FreeTransDetail (NumItem);
          LstRemove.Delete (0);
        end;
      end;
    end;
  finally
    LstRemove.Clear;
  end;
end;   // of TFrmTndRegDetailGroup.FormClose

//=============================================================================

procedure TFrmTndRegDetailGroup.StrGrdDetailDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  TxtCell          : string;           // Text in cell
  ValLeft          : Integer;          // Left coordinate for value
begin  // of TFrmTndRegDetailGroup.StrGrdDetailDrawCell
  inherited;

  TxtCell := StrGrdDetail.Cells[ACol, ARow];

  if ACol in [ViNumColQtyUnit, ViNumColValUnit, ViNumColValAmount] then
    // Show numeric data right aligned
    ValLeft := Rect.Right - StrGrdDetail.Canvas.TextWidth(TxtCell) - 3
  else
    ValLeft := Rect.Left + 3;

  if ARow = StrGrdDetail.RowCount - 1 then
    StrGrdDetail.Canvas.Font.Color := clBtnFace
  else if gdSelected in State then
    StrGrdDetail.Canvas.Font.Color := clHighlightText
 else
    StrGrdDetail.Canvas.Font.Color := clWindowText;

  ExtTextOut (StrGrdDetail.Canvas.Handle, ValLeft, Rect.Top + 2,
              ETO_OPAQUE or ETO_CLIPPED, @Rect,
              PChar(TxtCell), Length(TxtCell), nil);
end;   // of TFrmTndRegDetailGroup.StrGrdDetailDrawCell

//=============================================================================

procedure TFrmTndRegDetailGroup.StrGrdDetailSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin  // of TFrmTndRegDetailGroup.StrGrdDetailSelectCell
  inherited;
  CanSelect := ARow <> StrGrdDetail.RowCount - 1;
end;   // of TFrmTndRegDetailGroup.StrGrdDetailSelectCell

//=============================================================================

procedure TFrmTndRegDetailGroup.BtnRemoveClick(Sender: TObject);
begin  // of TFrmTndRegDetailGroup.BtnRemoveClick
  inherited;
  LstRemove.Add (StrGrdDetail.Rows[StrGrdDetail.Row].Objects[0]);
  RefreshDetail;
end;   // of TFrmTndRegDetailGroup.BtnRemoveClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FFpnTndRegDetailGroupPosCA
