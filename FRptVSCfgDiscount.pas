//=Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved.=
// Packet   : FlexPoint Development 2.0.1
// Customer : Castorama
// Unit     : FRptVSCfgDiscount.PAS : Configuration form to print discount reportts
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptVSCfgDiscount.pas,v 1.8 2007/05/24 06:57:49 NicoCV Exp $
// History :
//=============================================================================

unit FRptVSCfgDiscount;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FRptVSCfgGeneral, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, ComCtrls, SfVSPrinter7, CheckLst, ScDBUtil_BDE,
  ovcbase, ovcef, ovcpb, ovcpf, ScUtils;

//=============================================================================
// Resource-strings
//=============================================================================

resourcestring  // Warnings
  CtTxtWnStartEndDate        = 'Startdate is after enddate!';
  CtTxtWnStartFuture         = 'Startdate is in the future!';
  CtTxtWnEndFuture           = 'Enddate is in the future!';
  CtTxtWnPeriodTooBig        = 'Period is too big! (max %s days)';

//=============================================================================
// Global definitions
//=============================================================================

var    //
  ViValDaysFromTo : Integer  = 30;     // Maximum number of days in period

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmRptCfgDiscount = class(TFrmRptCfgGeneral)
    SbxGeneral: TScrollBox;
    PnlCheckOperators: TPanel;
    SplSettings: TSplitter;
    PnlSettings: TPanel;
    PnlSelectLeft: TPanel;
    BtnSelectAllLeft: TBitBtn;
    BtnDeSelectAllLeft: TBitBtn;
    SbxSettings: TScrollBox;
    SbxCheck: TScrollBox;
    PnlDates: TPanel;
    SvcDBLblDateFrom: TSvcDBLabelLoaded;
    SvcDBLblDateTo: TSvcDBLabelLoaded;
    DtmPckDayFrom: TDateTimePicker;
    DtmPckDayTo: TDateTimePicker;
    PnlLayout: TPanel;
    SvcDBLblLayout: TSvcDBLabelLoaded;
    PnlDetail: TPanel;
    SvcDBLblDetail: TSvcDBLabelLoaded;
    PnlSelectRight: TPanel;
    BtnSelectAllRight: TBitBtn;
    BtnDeSelectRight: TBitBtn;
    PnlCheckDiscountCustCategories: TPanel;
    CbxLayout: TComboBox;
    CbxDetail: TComboBox;
    PgeCtlCheck: TPageControl;
    TabShtDiscount: TTabSheet;
    TabShtCustCategories: TTabSheet;
    ChkLbxDiscountTypes: TCheckListBox;
    ChkLbxCustCategories: TCheckListBox;
    ChkLbxOperators: TCheckListBox;
    PnlNumber: TPanel;
    SvcDBLblNumber: TSvcDBLabelLoaded;
    OvcCtlDetail: TOvcController;
    SvcLFNumber: TSvcLocalField;
    procedure CbxLayoutChange(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnDeSelectRightClick(Sender: TObject);
    procedure BtnSelectAllRightClick(Sender: TObject);
    procedure BtnDeSelectAllLeftClick(Sender: TObject);
    procedure BtnSelectAllLeftClick(Sender: TObject);
  private
    { Private declarations }
  protected
    function GetFrmVSPreview : TFrmVSPreview; override;
    procedure DefineStandardRunParams; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure RetrieveOperator; virtual;
    procedure RetrieveCustCategory; virtual;
    procedure RetrieveDiscount; virtual;
    procedure PrepareForm; override;
    procedure BtnSelectAllClick(ChkLbx: TCheckListBox); virtual;
    procedure BtnDeSelectAllClick(ChkLbx: TCheckListBox); virtual;
    function GetItemsSelected : Boolean; override;
    function ItemsSelected (ChkLbx: TCheckListBox) : Boolean; virtual;
    procedure PreparePreview; override;
    procedure GeneratePreview; override;
    function GetTxtLstOperators : string; virtual;
    procedure FillStrLstCustCategories (StrLst : TStringList); virtual;
    procedure FillStrLstDiscountTypes (StrLst : TStringList); virtual;

  public
    { Public declarations }
    procedure CreateAdditionalModules; override;
  end;

var
  FrmRptCfgDiscount: TFrmRptCfgDiscount;

//*****************************************************************************

implementation

uses
  SfDialog,
  smUtils,

  DFpnUtils,

  FVSRptDiscount,

  DFpnEmployee,
  DFpnCustomer;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptVSCfgDiscount';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptVSCfgDiscount.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2007/05/24 06:57:49 $';

//*****************************************************************************
// Implementation of TFrmRptCfgGeneral
//*****************************************************************************

//=============================================================================

//=============================================================================

function TFrmRptCfgDiscount.GetFrmVSPreview : TFrmVSPreview;
begin  // of TFrmRptCfgDiscount.GetFrmVSPreview
  if not Assigned (FFrmVSPreview) then
    FFrmVSPreview := TFrmVSRptDiscount.Create (Application);
  Result := FFrmVSPreview;
end;   // of TFrmRptCfgDiscount.GetFrmVSPreview

//=============================================================================

procedure TFrmRptCfgDiscount.DefineStandardRunParams;
begin  // of TFrmRptCfgDiscount.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'VD';
end;   // of TFrmRptCfgDiscount.DefineStandardRunParams

//=============================================================================

procedure TFrmRptCfgDiscount.BeforeCheckRunParams;
begin  // of TFrmRptCfgDiscount.BeforeCheckRunParams
  inherited;
end;   // of TFrmRptCfgDiscount.BeforeCheckRunParams

//=============================================================================
// TFrmRptCfgDiscount.CheckAppDependParams: Placeholder to provide an inherited
// form with the possibility of examing extra variants (/V)
//                              ------
// INPUT: TxtParam = Complete run parameter (in other words: '/' and main
//                                           letter included)
//=============================================================================

procedure TFrmRptCfgDiscount.CheckAppDependParams (TxtParam : string);
var
  TxtPrmCheck      : string;           // Parameter to check
  TxtLeft          : string;           // Leftside of string after splitstring
  TxtRight         : string;           // Rightside of string after splitstring
begin  // of TFrmRptCfgDiscount.CheckAppDependParams
  if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
     (UpCase (TxtParam[2]) = 'V') then begin
    TxtPrmCheck := AnsiUpperCase (Copy (TxtParam, 3, Length (TxtParam)));
    SplitString (TxtPrmCheck, ',', TxtLeft, TxtRight);
    if TxtLeft = 'MD' then
      ViValDaysFromTo := StrToInt (TxtRight)
    else
      InvalidRunParam (TxtParam);
  end
  else
    InvalidRunParam (TxtParam);
end;   // of TFrmRptCfgDiscount.CheckAppDependParams

//=============================================================================

function TFrmRptCfgDiscount.GetItemsSelected : Boolean;
begin  // of TFrmRptCfgDiscount.GetItemsSelected
  Result := ItemsSelected (ChkLbxOperators) and
            (not TabShtCustCategories.TabVisible or
             ItemsSelected (ChkLbxCustCategories)) and
            ItemsSelected (ChkLbxDiscountTypes);
  if not Result then begin
    if not ItemsSelected (ChkLbxOperators) then  begin
      if not ChkLbxOperators.CanFocus then
        ChkLbxOperators.Show;
      ChkLbxOperators.SetFocus;
    end
    else if (TabShtCustCategories.TabVisible and
             not ItemsSelected (ChkLbxCustCategories)) then
      PgeCtlCheck.ActivePage := TabShtCustCategories
    else
      PgeCtlCheck.ActivePage := TabShtDiscount
  end;
end;   // of TFrmRptCfgDiscount.GetItemsSelected

//=============================================================================

function TFrmRptCfgDiscount.ItemsSelected (ChkLbx: TCheckListBox) : Boolean;
var
  CntIx            : Integer;          // Looping the CheckListBox.
begin  // of TFrmRptCfgDiscount.ItemsSelected
  Result := False;
  for CntIx := 0 to Pred (ChkLbx.Items.Count) do begin
    if ChkLbx.Checked [CntIx] then begin
      Result := True;
      Break;
    end;
  end;
end;  // of TFrmRptCfgDiscount.ItemsSelected

//=============================================================================

procedure TFrmRptCfgDiscount.PreparePreview;
begin  // of TFrmRptCfgDiscount.PreparePreview
  with TFrmVSRptDiscount(FrmVSPreview) do begin
    CodLayout := CbxLayout.ItemIndex;
    CodDetail := CbxDetail.ItemIndex;
    IdtCustPers := SvcLFNumber.AsInteger;
    StrLstOperators.CommaText := GetTxtLstOperators;
    FillStrLstDiscountTypes (StrLstDiscountTypes);
    FillStrLstCustCategories (strLstCustCategories);
    DtmFromDate := DtmPckDayFrom.DateTime;
    DtmToDate := DtmPckDayTo.DateTime;
  end;
end;   // of TFrmRptCfgDiscount.PreparePreview

//=============================================================================

procedure TFrmRptCfgDiscount.GeneratePreview;
begin  // of TFrmRptCfgDiscount.GeneratePreview
  TFrmVSRptDiscount(FrmVSPreview).PrintReport;
end;   // of TFrmRptCfgDiscount.GeneratePreview

//=============================================================================

function TFrmRptCfgDiscount.GetTxtLstOperators : string;
var
  Cnt              : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmRptCfgDiscount.GetTxtLstOperators
  Result := '';
  for Cnt := 0 to Pred (ChkLbxOperators.Items.Count) do begin
    if ChkLbxOperators.Checked [Cnt] then
      Result := Result +
                 IntToStr (Integer (
                     ChkLbxOperators.Items.Objects[Cnt])) + ',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmRptCfgDiscount.GetTxtLstOperators

//=============================================================================

procedure TFrmRptCfgDiscount.FillStrLstCustCategories (StrLst : TStringList);
var
  Cnt              : Integer;          // Loop the customer categories
begin  // of TFrmRptCfgDiscount.FillStrLstCustomerCategories
  StrLst.Clear;
  for Cnt := 0 to Pred (ChkLbxCustCategories.Items.Count) do begin
    if ChkLbxCustCategories.Checked [Cnt] then
      StrLst.AddObject (
        IntToStr (Integer (ChkLbxCustCategories.Items.Objects[Cnt])),
        TCategoryTotal.CreateWithParams (
          IntToStr (Integer (ChkLbxCustCategories.Items.Objects[Cnt])),
          ChkLbxCustCategories.Items[Cnt]));
  end;
end;   // of TFrmRptCfgDiscount.FillStrLstCustomerCategories

//=============================================================================

procedure TFrmRptCfgDiscount.FillStrLstDiscountTypes (StrLst : TStringList);
var
  Cnt              : Integer;          // Loop the discount types
begin  // of TFrmRptCfgDiscount.FillStrLstDiscountTypes
  StrLst.Clear;
  for Cnt := 0 to Pred (ChkLbxDiscountTypes.Items.Count) do begin
    if ChkLbxDiscountTypes.Checked [Cnt] then
      StrLst.AddObject (
        IntToStr (Integer (ChkLbxDiscountTypes.Items.Objects[Cnt])),
        TDiscountTotal.CreateWithParams (
          IntToStr (Integer (ChkLbxDiscountTypes.Items.Objects[Cnt])),
          ChkLbxDiscountTypes.Items[Cnt]));
  end;
end;   // of TFrmRptCfgDiscount.FillStrLstDiscountTypes

//=============================================================================
// TFrmRptCfgDiscount.RetrieveOperator : fills the checkListbox for the
// operators with values from the database
//=============================================================================

procedure TFrmRptCfgDiscount.RetrieveOperator;
begin  // of TFrmRptCfgDiscount.RetrieveOperator
  try
    if DmdFpnUtils.QueryInfo
        ('SELECT IdtOperator, TxtName FROM Operator') then begin
      DmdFpnUtils.QryInfo.First;
      ChkLbxOperators.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ChkLbxOperators.Items.AddObject
           (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ' : ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString,
            TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmRptCfgDiscount.RetrieveOperator

//=============================================================================
// TFrmRptCfgDiscount.RetrieveCustCategory : fills the checkListbox for the
// customer categories with values from the database
//=============================================================================

procedure TFrmRptCfgDiscount.RetrieveCustCategory;
begin  // of TFrmRptCfgDiscount.RetrieveCustCategory
  try
    ChkLbxCustCategories.Items.Clear;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmIdtLanguage').Value := DmdFpnUtils.IdtLanguageTradeMatrix;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtField').Value := CtCodCustCategoryField;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtTable').Value := CtCodCustCategoryTable;
    DmdFpnUtils.SprCnvCodes.Active := True;
    DmdFpnUtils.SprCnvCodes.First;
    while not DmdFpnUtils.SprCnvCodes.Eof do begin
      ChkLbxCustCategories.Items.AddObject
        (DmdFpnUtils.SprCnvCodes.FieldByName ('TxtFldCode').AsString + ' : ' +
         DmdFpnUtils.SprCnvCodes.FieldByName ('TxtChcLong').AsString,
         TObject (DmdFpnUtils.SprCnvCodes.FieldByName ('TxtFldCode').AsInteger));
        DmdFpnUtils.SprCnvCodes.Next;
    end;
  finally
    DmdFpnUtils.SprCnvCodes.Active := False;
  end;
end;  // of TFrmRptCfgDiscount.RetrieveCustCategory

//=============================================================================
// TFrmRptCfgDiscount.RetrieveDiscount : fills the checkListbox for the
// discounts with values from the database
//=============================================================================

procedure TFrmRptCfgDiscount.RetrieveDiscount;
begin  // of TFrmRptCfgDiscount.RetrieveDiscount
  try
    ChkLbxDiscountTypes.Items.Clear;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmIdtLanguage').Value := DmdFpnUtils.IdtLanguageTradeMatrix;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtField').Value := CtCodDiscountTypeField;
    DmdFpnUtils.SprCnvCodes.
      ParamByName ('@PrmTxtTable').Value := CtCodDiscountTypeTable;
    DmdFpnUtils.SprCnvCodes.Active := True;
    DmdFpnUtils.SprCnvCodes.First;
    while not DmdFpnUtils.SprCnvCodes.Eof do begin
      ChkLbxDiscountTypes.Items.AddObject
        (DmdFpnUtils.SprCnvCodes.FieldByName ('TxtChcLong').AsString,
         TObject (DmdFpnUtils.SprCnvCodes.FieldByName ('TxtFldCode').AsInteger));
        DmdFpnUtils.SprCnvCodes.Next;
    end;
  finally
    DmdFpnUtils.SprCnvCodes.Active := False;
  end;
end;  // of TFrmRptCfgDiscount.RetrieveDiscount

//=============================================================================

procedure TFrmRptCfgDiscount.PrepareForm;
begin  // of TFrmRptCfgDiscount.PrepareForm
  inherited;

  RetrieveOperator;
  RetrieveCustCategory;
  RetrieveDiscount;
  BtnSelectAllClick(ChkLbxDiscountTypes);
  BtnSelectAllClick(ChkLbxCustCategories);
  CbxLayoutChange (nil);

  if ViFlgAutom then begin
    BtnSelectAllClick (ChkLbxOperators);
    if CbxLayout.ItemIndex = CtCodRptLayOutCustomer then
      BtnSelectAllClick (ChkLbxCustCategories);
  end;

  DtmPckDayFrom.DateTime := viDtmExecute;
  DtmPckDayTo.DateTime := viDtmExecute;
end;   // of TFrmRptCfgDiscount.AutoStart

//=============================================================================

procedure TFrmRptCfgDiscount.CreateAdditionalModules;
begin  // of TFrmRptCfgDiscount.CreateAdditionalModules
  inherited;
  if not Assigned (DmdFpnCustomer) then
    DmdFpnCustomer := TDmdFpnCustomer.Create (Application);
  if not Assigned (DmdFpnEmployee) then
    DmdFpnEmployee := TDmdFpnEmployee.Create (Application);
end;   // of TFrmRptCfgDiscount.CreateAdditionalModules

//=============================================================================

procedure TFrmRptCfgDiscount.BtnSelectAllClick(ChkLbx: TCheckListBox);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmRptCfgDiscount.BtnSelectAllClick
  for CntIx := 0 to Pred (ChkLbx.Items.Count) do
    ChkLbx.Checked [CntIx] := True;
end;   // of TFrmRptCfgDiscount.BtnSelectAllClick

//=============================================================================

procedure TFrmRptCfgDiscount.BtnDeSelectAllClick(ChkLbx: TCheckListBox);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmRptCfgDiscount.BtnDeSelectAllClick
  inherited;
  for CntIx := 0 to Pred (ChkLbx.Items.Count) do
    ChkLbx.Checked [CntIx] := False;
end;   // of TFrmRptCfgDiscount.BtnDeSelectAllClick

//=============================================================================
// Event handlers
//=============================================================================

procedure TFrmRptCfgDiscount.BtnSelectAllLeftClick(Sender: TObject);
begin  // of TFrmRptCfgDiscount.BtnSelectAllLeftClick
  inherited;
  BtnSelectAllClick (ChkLbxOperators);
end;   // of TFrmRptCfgDiscount.BtnSelectAllLeftClick

//=============================================================================

procedure TFrmRptCfgDiscount.BtnDeSelectAllLeftClick(Sender: TObject);
begin  // of TFrmRptCfgDiscount.BtnDeSelectAllLeftClick
  inherited;
  BtnDeSelectAllClick (ChkLbxOperators);
end;   // of TFrmRptCfgDiscount.BtnDeSelectAllLeftClick

//=============================================================================

procedure TFrmRptCfgDiscount.BtnSelectAllRightClick(Sender: TObject);
begin  // of TFrmRptCfgDiscount.BtnSelectAllRightClick
  inherited;
  case PgeCtlCheck.ActivePageIndex of
    0: BtnSelectAllClick (ChkLbxDiscountTypes);
    1: BtnSelectAllClick (ChkLbxCustCategories);
  end;
end;   // of TFrmRptCfgDiscount.BtnSelectAllRightClick

//=============================================================================

procedure TFrmRptCfgDiscount.BtnDeSelectRightClick(Sender: TObject);
begin  // of TFrmRptCfgDiscount.BtnDeSelectRightClick
  inherited;
  case PgeCtlCheck.ActivePageIndex of
    0: BtnDeSelectAllClick (ChkLbxDiscountTypes);
    1: BtnDeSelectAllClick (ChkLbxCustCategories);
  end;
end;   // of TFrmRptCfgDiscount.BtnDeSelectRightClick

//=============================================================================

procedure TFrmRptCfgDiscount.BtnPrintClick(Sender: TObject);
begin
  if (SvcLFNumber.ValidateContents (True) <> 0)  then
    Exit;

  ChkLbxOperators.SetFocus;            // The date fields must loose their focus
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    if not DtmPckDayTo.CanFocus then
      DtmPckDayTo.Show;
    DtmPckDayTo.SetFocus;
    MessageDlg (CtTxtWnStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    if not DtmPckDayTo.CanFocus then
      DtmPckDayTo.Show;
    DtmPckDayTo.SetFocus;
    MessageDlg (CtTxtWnStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayTo.Date := Now;
    if not DtmPckDayTo.CanFocus then
      DtmPckDayTo.Show;
    DtmPckDayTo.SetFocus;
    MessageDlg (CtTxtWnEndFuture, mtWarning, [mbOK], 0);
  end
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > ViValDaysFromTo then begin
    DtmPckDayFrom.Date := DtmPckDayTo.Date - ViValDaysFromTo;
    if not DtmPckDayFrom.CanFocus then
      DtmPckDayFrom.Show;
    DtmPckDayFrom.SetFocus;
    MessageDlg (Format (CtTxtWnPeriodTooBig, [IntToStr (ViValDaysFromTo)]),
                mtWarning, [mbOK], 0);
  end
  else
     inherited;
end;

//=============================================================================

procedure TFrmRptCfgDiscount.CbxLayoutChange(Sender: TObject);
begin
  inherited;
  TabShtCustCategories.TabVisible :=
    CbxLayout.ItemIndex = CtCodRptLayOutCustomer;
  PnLNumber.Visible :=
    CbxLayout.ItemIndex in [CtCodRptLayOutCustomer, CtCodRptLayOutPersonnel];
  if CbxLayout.ItemIndex = CtCodRptLayOutCustomer then
    PgeCtlCheck.ActivePage := TabShtCustCategories
  else
    PgeCtlCheck.ActivePage := TabShtDiscount;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.   // of FRptVSCfgDiscount
