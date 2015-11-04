//= Copyright 2007 (c) Centric NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Unit   : FLstEmployee.PAS : List of employees with printcard option
//-----------------------------------------------------------------------------
// PVCS   : $
// History:
// - Started from castorama - Flexpoint20 - FLstEmployee - rev 1.3
//   Version   ModifiedBy        Reason
//    1.1       CP       R2012.1 Defect fix(131)
//=============================================================================

unit FLstEmployee;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  sflist_BDE_DBC, Menus, ExtCtrls, Db, ComCtrls, 
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, StBarC, DBTables, ovcbase,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef,
  ovcpb, ovcpf;

//*****************************************************************************

resourcestring
  CtTxtNoSelection = 'There are no items selected!';
  CtTxtTitle = 'Maintenance Employee';            //R2012.1 Defect fix 131 (CP)

type
  TFrmLstEmployee = class(TFrmList)
    GrpBxPrintCards: TGroupBox;
    BtnSelect: TBitBtn;
    BtnDeselect: TBitBtn;
    BtnAllSelect: TBitBtn;
    BtnAllDeselect: TBitBtn;
    BtnPrintCards: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure BtnSelectClick(Sender: TObject);
    procedure BtnDeselectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure BtnPrintCardsClick(Sender: TObject);
    procedure BtnAllDeselectClick(Sender: TObject);
    procedure BtnAllSelectClick(Sender: TObject);
    procedure MniSeqRefreshClick(Sender: TObject);
  private
    { Private declarations }
    FFlgPrintCards: Boolean;
    FFlgShowCard: Boolean;
    // DataFields for properties
    FStrLstSelIdt  : TStringList;      // Stringlist selected Idt's
  protected
    { Protected declarations }
    // Data
    FlgDropTmpTbl  : Boolean;          // True = Selectiontable must be dropped
    CntSelected    : Integer;          // Counter to keep selection order

    function GetIdtItem (DstIdts : TDataSet) : string; virtual;
    function GetIdtCurrItem : string; virtual;
    procedure SetStrLstSelIdt (Value : TStringList); virtual;
    procedure AdjustQtySelected; virtual;
    procedure ChangeItemSelected (TxtItem   : string;
                                  FlgSelect : Boolean); virtual;
    procedure ChangeSelection (FlgSelect: Boolean); virtual;
  published
    property StrLstSelIdt : TStringList read  FStrLstSelIdt
                                        write SetStrLstSelIdt;
  public
    { Public declarations }
    property FlgPrintCards: Boolean read FFlgPrintCards write FFlgPrintCards;
    property FlgShowCard: Boolean read FFlgShowCard write FFlgShowCard;
    property TxtIdtCurrItem : string read  GetIdtCurrItem;
  end;

var
  FrmLstEmployee: TFrmLstEmployee;

implementation

{$R *.DFM}

uses
  SmDbUtil_BDE,
  ScTskMgr_BDE_DBC,
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmLstEmployee';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstEmployee.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2008/03/13 12:59:48 $';
  CtTxtSrcTag     = '$Name:  $';

//=============================================================================

procedure TFrmLstEmployee.FormActivate(Sender: TObject);
begin
  if not FlgShowCard then begin
    TStoredProc(DscList.DataSet).FieldByName('TxtCardNumber').Visible := False;
  end;
  if FlgPrintCards then
    GrpBxPrintCards.Visible := True
  else
    GrpBxPrintCards.Hide;
    Application.Title := CtTxtTitle;              //R2012.1 Defect fix 131 (CP)
  inherited;
end;

//=============================================================================

procedure TFrmLstEmployee.BtnSelectClick(Sender: TObject);
begin
  if (not Assigned (DscList.DataSet)) or DscList.DataSet.IsEmpty then
    raise EAbort.Create ('No data');

  ChangeSelection (True);
  DBGrdList.Refresh;
end;

//=============================================================================

procedure TFrmLstEmployee.BtnDeselectClick(Sender: TObject);
begin
  if (not Assigned (DscList.DataSet)) or DscList.DataSet.IsEmpty then
    raise EAbort.Create ('No data');

  ChangeSelection (False);
  DBGrdList.Refresh;
end;

//=============================================================================

procedure TFrmLstEmployee.ChangeSelection(FlgSelect: Boolean);
begin
  if not DscList.DataSet.IsEmpty then
    ChangeItemSelected (TxtIdtCurrItem, FlgSelect);

  if not DscList.DataSet.EOF then
    DscList.DataSet.Next;
end;

//=============================================================================

procedure TFrmLstEmployee.ChangeItemSelected(TxtItem  : string;
                                             FlgSelect: Boolean);
var
  NumItem          : Integer;          // Itemnumber Idt-fields in StringList
begin  // of TFrmLstEmployee.ChangeItemSelected
  if FlgSelect then begin
    if not StrLstSelIdt.Find (TxtItem, NumItem) then begin
      Inc (CntSelected);
      StrLstSelIdt.AddObject (TxtItem, TObject(CntSelected));
    end;
  end
  else if StrLstSelIdt.Find (TxtItem, NumItem) then
    StrLstSelIdt.Delete (NumItem);

  AdjustQtySelected;
end;

//=============================================================================

procedure TFrmLstEmployee.AdjustQtySelected;
begin
  //StsBarList.Panels[1].Text := IntToStr (StrLstSelIdt.Count) +
  //                             Copy (StsBarList.Panels[1].Text,
  //                               AnsiPos (' ', StsBarList.Panels[1].Text),
  //                                   Length (StsBarList.Panels[1].Text));
  if StrLstSelIdt.Count = 0 then
    CntSelected := 0;
end;

//=============================================================================

procedure TFrmLstEmployee.SetStrLstSelIdt(Value: TStringList);
begin
  FStrLstSelIdt.Assign (Value);
end;

//=============================================================================

function TFrmLstEmployee.GetIdtCurrItem: string;
begin
  Result := GetIdtItem (DscList.DataSet);
end;

//=============================================================================

function TFrmLstEmployee.GetIdtItem(DstIdts: TDataSet): string;
var
  CntItem          : Integer;          // Counter fields in selectiontable
  FldIdt           : TField;           // IdtField
  TxtFldValue      : string;           // FieldValue as string
  ValHour          : Word;             // Decode time
  ValMin           : Word;             // Decode time
  ValSec           : Word;             // Decode time
  ValMSec          : Word;             // Decode time
begin   // of TFrmLstEmployee.GetIdtItem
  Result := '';
  for CntItem := 0 to Pred (SvcTskOwner.IdtFields.Count) do begin
    FldIdt := DstIdts.FieldByName (SvcTskOwner.IdtFields[CntItem]);
    case FldIdt.DataType of
      ftString :
        TxtFldValue := AnsiQuotedStr (FldIdt.AsString, '''');
      ftCurrency, ftBCD :
        Str (FldIdt.AsCurrency:3:4, TxtFldValue);
      ftDateTime : begin
        TxtFldValue := FormatDateTime (ViTxtDBDatFormat+ ' ' + ViTxtDBHouFormat,
                                       FldIdt.AsDateTime);
        DecodeTime (FldIdt.AsDateTime, ValHour, ValMin, ValSec, ValMSec);
        if ValMSec <> 0 then
          TxtFldValue := TxtFldValue + Format ('.%.3d', [ValMSec]);
        TxtFldValue := AnsiQuotedStr (TxtFldValue, '''');
      end;
      else
        TxtFldValue := FldIdt.AsString;
    end;
    if Result <> '' then
      Result := Result + ',';
    Result := Result + TxtFldValue;
  end;
end;

//=============================================================================

procedure TFrmLstEmployee.FormCreate(Sender: TObject);
begin
  inherited;

  FStrLstSelIdt := TStringList.Create;
  StrLstSelIdt.Duplicates := dupIgnore;
  CntSelected   := 0;
end;

//=============================================================================

procedure TFrmLstEmployee.FormDestroy(Sender: TObject);
begin
  FStrLstSelIdt.Free;

  inherited;
end;

//=============================================================================

procedure TFrmLstEmployee.DBGrdListDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if StrLstSelIdt.IndexOf (TxtIdtCurrItem) >= 0 then
    DBGrdList.Canvas.Brush.Color := clTeal;

  DBGrdList.DefaultDrawColumnCell (Rect, DataCol, Column, State);
end;

//=============================================================================

procedure TFrmLstEmployee.BtnPrintCardsClick(Sender: TObject);
begin  // of TFrmLstEmployee.BtnPrintCardsClick
  inherited;
  if StrLstSelIdt.Count = 0 then
    MessageDlg(CtTxtNoSelection, mtInformation, [mbOk], 0)
  else
    SvcTaskMgr.LaunchTask ('PrintCards');
  BtnAllDeselect.Click;
end;   // of TFrmLstEmployee.BtnPrintCardsClick

//=============================================================================

procedure TFrmLstEmployee.BtnAllDeselectClick(Sender: TObject);
begin  // of TFrmLstEmployee.BtnAllDeselectClick
  TmrRefresh.Enabled := False;

  inherited;

  StrLstSelIdt.Clear;
  DBGrdList.Invalidate;
  AdjustQtySelected;

  if RefreshNeeded then
    TmrRefresh.Enabled := True;
end;   // of TFrmLstEmployee.BtnAllDeselectClick

//=============================================================================

procedure TFrmLstEmployee.BtnAllSelectClick(Sender: TObject);
var
  BmkRecord        : TBookmarkStr;     // Bookmark for current record
  FlgSelect        : Boolean;          // True to select; False to deselect
begin  // of TFrmLstEmployee.BtnAllSelectClick
  if (not Assigned (DscList.DataSet)) or DscList.DataSet.IsEmpty then
    raise EAbort.Create ('No data');

  // Disable TmrRefresh before calling inherited: if OnTimer is fired during
  // the selection, the system can 'hang'
  TmrRefresh.Enabled := False;

  inherited;

  FlgSelect := True;
  // Save bookmark
  BmkRecord := DscList.DataSet.Bookmark;
  try
    DscList.DataSet.DisableControls;
    Screen.Cursor := crHourGlass;
    DscList.DataSet.First;
    // Loop all records
    while (not DscList.DataSet.EOF) do begin
      // Add identification to list
      ChangeSelection (FlgSelect);
      Application.ProcessMessages;
    end;
  finally
    DscList.DataSet.EnableControls;
    Screen.Cursor := crDefault;
    // Goto bookmark
    DscList.DataSet.Bookmark := BmkRecord;
    DBGrdList.Refresh;
  end;

  if RefreshNeeded then
    TmrRefresh.Enabled := True;
end;   // of TFrmLstEmployee.BtnAllSelectClick

//=============================================================================

procedure TFrmLstEmployee.MniSeqRefreshClick(Sender: TObject);
begin  // of TFrmLstEmployee.MniSeqRefreshClick
  inherited;
  BtnAllDeselect.Click;
end;   // of TFrmLstEmployee.MniSeqRefreshClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);

end.
