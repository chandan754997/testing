//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FInputLabelerCA : Form Input LABELER CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputLabelerCA.pas,v 1.4 2007/04/27 10:20:57 goegebkr Exp $
// History:
//=============================================================================

unit FInputLabelerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfCommon, StdCtrls, Buttons, Grids;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtTitleType   = 'Type';
  CtTxtTitleQty    = 'Qty';
  CtTxtTitleSheets = 'Sheets';

//=============================================================================
// Interfaced constants
//=============================================================================

const  // Constants for Column numbers
  CtNumColType          = 0;           // ColumnNumber Type
  CtNumColQty           = 1;           // ColumnNumber Quantity
  CtNumColSheets        = 2;           // ColumnNumber Sheets
  CtNumColMax           = CtNumColSheets;

const  // Constants for Column Widths
  CtNumWidthType        = 20;           // Column width Type
  CtNumWidthQty         = 7;            // Column width Quantity
  CtNumWidthSheets      = 0;            // Column width Sheets

//=============================================================================
// TFrmInputLabalerCA
//=============================================================================

type
  TFrmInputLabelerCA = class(TFrmCommon)
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    LblTypesOfLabels: TLabel;
    LblDefaultLabel: TLabel;
    StrGrdLabelTypes: TStringGrid;
    CbxDefaultLabel: TComboBox;
    procedure FormActivate(Sender: TObject);
    procedure CbxDefaultLabelChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure ConfigGridLabelTypes; virtual;
  public
    { Public declarations }
    FlgEverActivated : Boolean;
  published
    { Published declarations }
    function ShowModalWithParams (StrLstLabelTypes : TStringList) :
                                                               Integer; virtual;
  end;

var
  FrmInputLabelerCA: TFrmInputLabelerCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  CMBTll11,

  SfDialog,

  StStrL,

  DFpnArticleCA,
  DFpnLabeler,
  DFpnLabelerCA,
  DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FInputLabelerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FInputLabelerCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2007/04/27 10:20:57 $';

//*****************************************************************************
// Implementation of TFrmInputLabelerCA
//*****************************************************************************

//=============================================================================
// TFrmInputLabelerCA.ConfigGrid : configures the grid according to
// needed columns.
//=============================================================================

procedure TFrmInputLabelerCA.ConfigGridLabelTypes;
begin  // of TFrmInputLabelerCA.ConfigGridLabelTypes
  with StrGrdLabelTypes do begin
    RowCount := 2;
    FixedRows := 1;
    ColCount := CtNumColMax + 1;
    Cells[CtNumColType     , 0] := CtTxtTitleType;
    ColWidths[CtNumColType] :=
      Canvas.TextWidth (CharStrL ('M', CtNumWidthType));
    Cells[CtNumColQty      , 0] := CtTxtTitleQty;
    ColWidths[CtNumColQty] :=
      Canvas.TextWidth (CharStrL ('M', CtNumWidthQty));
    Cells[CtNumColSheets   , 0] := CtTxtTitleSheets;
    ColWidths[CtNumColSheets] :=
      Canvas.TextWidth (CharStrL ('M', CtNumWidthSheets));
  end;
end;   // of TFrmDetTicketInfo.ConfigGridLabelTypes

//=============================================================================

function TFrmInputLabelerCA.ShowModalWithParams (
                                      StrLstLabelTypes : TStringList) : Integer;
var
  Cnt : Integer;                       // Counter
begin   // of TFrmInputLabelerCA.ShowModal
  CbxDefaultLabel.Items.Clear;
  StrGrdLabelTypes.RowCount := 2;
  for Cnt := 0 to StrLstLabelTypes.Count - 1 do begin
    CbxDefaultLabel.Items.Add (StrLstLabelTypes[Cnt]);
    if TLabelType (StrLstLabelTypes.Objects[Cnt]).Qty <> 0 then begin
      StrGrdLabelTypes.Cells[CtNumColType, StrGrdLabelTypes.RowCount - 1] :=
        StrLstLabelTypes[Cnt];
      StrGrdLabelTypes.Cells[CtNumColQty, StrGrdLabelTypes.RowCount - 1] :=
        IntToStr (TLabelType (StrLstLabelTypes.Objects[Cnt]).Qty);
      StrGrdLabelTypes.Cells[CtNumColSheets, StrGrdLabelTypes.RowCount - 1] :=
        IntToStr (TLabelType (StrLstLabelTypes.Objects[Cnt]).Sheets);
      StrGrdLabelTypes.RowCount := StrGrdLabelTypes.RowCount + 1;
    end;
  end;
  if StrGrdLabelTypes.Cells[CtNumColType, StrGrdLabelTypes.RowCount-1] = '' then
    StrGrdLabelTypes.RowCount := StrGrdLabelTypes.RowCount - 1;
  CbxDefaultLabel.ItemIndex := 0;      // default
  CbxDefaultLabel.Enabled :=
    TLabelType (StrLstLabelTypes.Objects[0]).Qty <> 0;
  BtnOK.Enabled := StrGrdLabelTypes.Cells[CtNumColType, 1] <> '';
  Result := inherited ShowModal;
  if (Result = mrOK) and CbxDefaultLabel.Enabled then begin
    StrLstLabelTypes [0] :=
      TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).Descr;
    TLabelType (StrLstLabelTypes.Objects [0]).Descr :=
      TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).Descr;
    TLabelType (StrLstLabelTypes.Objects [0]).LabelType :=
      TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).LabelType;
    TLabelType (StrLstLabelTypes.Objects [0]).ReportNorm :=
      TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).ReportNorm;
    TLabelType (StrLstLabelTypes.Objects [0]).ReportCamp :=
      TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).ReportCamp;
    TLabelType (StrLstLabelTypes.Objects[CbxDefaultLabel.ItemIndex]).
      FlgPrintNoType := True;
  end;
end;    // of TFrmInputLabelerCA.ShowModal

//=============================================================================

procedure TFrmInputLabelerCA.FormCreate(Sender: TObject);
begin   // of TFrmInputLabelerCA.FormCreate
  inherited;
  ConfigGridLabelTypes;
end;    // of TFrmInputLabelerCA.FormCreate

//=============================================================================

procedure TFrmInputLabelerCA.CbxDefaultLabelChange(Sender: TObject);
begin  // of TFrmInputLabelerCA.CbxDefaultLabelChange
  inherited;
  StrGrdLabelTypes.Cells[CtNumColType, 1] := CbxDefaultLabel.Text;
  BtnOK.Enabled := StrGrdLabelTypes.Cells[CtNumColType, 1] <> '';
end;   // of TFrmInputLabelerCA.CbxDefaultLabelChange

//=============================================================================

procedure TFrmInputLabelerCA.FormActivate(Sender: TObject);
begin  // of TFrmInputLabelerCA.FormActivate
  inherited;
  if not FlgEverActivated then begin
    if not BtnOK.Enabled then
      MessageDlg(LblDefaultLabel.Caption, mtInformation, [mbOK], 0);
   FlgEverActivated := True;
 end;
end;   // of TFrmInputLabelerCA.FormActivate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FInputLabelerCA
