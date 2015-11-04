//=========== Sycron Computers Belgium (c) 1999 ===============================
// Packet : Standard Development
// Unit   : SfRptVSCfgChoice_BDE_DBC = Standard Form RePorT VSview ConFiGuration
//          CHOICE, using BDE, Double Byte character set Compatible.
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/core/devstand2005/src/DevStand2005/Develop/SfRptVSCfgChoice_BDE_DBC.pas,v 1.1 2006/12/14 12:47:25 marleenks Exp $
// History:
// - Started from DevStand2005 - SfRptVSCfgChoice - CVS Revision 1.3
// PVCS   : $Header: $
// Version   Modified by     Reason
// 1.2       SRM.  (TCS)     R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM
//=============================================================================

unit SfRptVSCfgChoice_BDE_DBC;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OvcBase, OvcEF, ExtCtrls, ComCtrls, OvcPB, OvcPF, Menus,
  ScTskMgr_BDE_DBC, SmUtils, ScUtils, Buttons, OvcMeter, SfRptVSCfg_BDE_DBC,
  IniFiles, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Keywords for save/load configuration of choicelists to/from ini-file.
//=============================================================================

const  // Sections in INI-file
  CtTxtSecFields        = 'Fields';
  CtTxtSecConditions    = 'Conditions';

const  // Items in INI-file
  CtTxtItmPrnLegend          = 'Legend';
  CtTxtItmPrnConditions      = 'Conditions';
  CtTxtItmName               = 'ReportField';
  CtTxtItmCondition          = 'Condition';
  CtTxtItmConditionFrom      = 'ConditionFrom';
  CtTxtItmConditionTo        = 'ConditionTo';
  CtTxtItmConditionSubString = 'ConditionSubStr';

//=============================================================================
// TFrmRptCfgChoice
//=============================================================================

type
  TFrmRptCfgChoice = class(TFrmRptCfg)
    MniSelection: TMenuItem;
    MniIncl: TMenuItem;
    MniInclAll: TMenuItem;
    MniSep5: TMenuItem;
    MniExcl: TMenuItem;
    MniExclAll: TMenuItem;
    MniSep6: TMenuItem;
    MniMoveUp: TMenuItem;
    MniMoveDn: TMenuItem;
    PnlLeft: TPanel;
    SptRptCfgChoice: TSplitter;
    PnlRight: TPanel;
    PnlLeftCenter: TPanel;
    BtnIncl: TSpeedButton;
    BtnInclAll: TSpeedButton;
    BtnExcl: TSpeedButton;
    BtnExclAll: TSpeedButton;
    BtnMoveUp: TSpeedButton;
    BtnMoveDn: TSpeedButton;
    GbxFldCond: TGroupBox;
    LblCondLower: TLabel;
    LblCondUpper: TLabel;
    CbxFieldCond: TComboBox;
    GbxInclOnRpt: TGroupBox;
    ChxInclLegend: TCheckBox;
    ChxInclConditions: TCheckBox;
    LblFldCondTrue: TLabel;
    RbtFldCondAll: TRadioButton;
    RbtFldCondOne: TRadioButton;
    LblCondition: TLabel;
    SvcLFCondLower: TSvcLocalField;
    SvcLFCondUpper: TSvcLocalField;
    LbxChoice: TListBox;
    LbxAvail: TListBox;
    CbxCondLower: TComboBox;
    CbxCondUpper: TComboBox;
    LblCondSubStr: TLabel;
    SptRptFields: TSplitter;
    SvcMECondLower: TSvcMaskEdit;
    SvcMECondUpper: TSvcMaskEdit;
    procedure MniExportToFileClick(Sender: TObject);                            //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.End
    procedure SvcMECondUpperPropertiesValidate(Sender: TObject;                 
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure SvcMECondLowerPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure MniPrintClick(Sender: TObject);
    procedure MniInclExclClick(Sender: TObject);
    procedure MniInclExclAllClick(Sender: TObject);
    procedure MniMoveUpClick(Sender: TObject);
    procedure MniMoveDnClick(Sender: TObject);
    procedure CbxFieldCondChange(Sender: TObject);
    procedure SvcLFCondLowUpChange(Sender: TObject);
    procedure SvcLFCondLowerUserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure SvcLFCondUpperUserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure CbxCondLowUpChange(Sender: TObject);
    procedure LbxAvailChoiceClick(Sender: TObject);
    procedure LbxAvailChoiceDblClick(Sender: TObject);
    procedure LbxAvailChoiceEnter(Sender: TObject);
    procedure LbxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CbxFontSizeChange(Sender: TObject);
  private
    { Private declarations }
    // DataFields
    FActiveListBox : TListBox;         // Current active listbox
    FRptFldCond    : TRptFldItem;      // ReportField for current conditions

    // Methods for read & write properties
    procedure SetActiveListBox (Value : TListBox);
    function GetSelectedItem : Integer;
    procedure SetSelectedItem (Value : Integer);
    function GetRptFldSelectedItem : TRptFldItem;
  protected
    { Protected declarations }
    // Data
    TxtVspHdrTitle : string;           // Column titles for report
    TxtVspHdrFormat: string;           // Column formats for report
    FlgPrintTblHdr : Boolean;          // Print table header or not
    NumPrintedLines: Integer;          // Number of printed lines

    // Methods
    function GetFlgAllConditions : Boolean; virtual;
    procedure AdjustBtnsDependListBox;
    procedure AdjustConditionFromTo; virtual;
    procedure AdjustCurrReportWidth (RptFld     : TRptFldItem;
                                     FlgInclude : Boolean    ); virtual;
    procedure MoveOneItem (NumItem : Integer); virtual;
    procedure AutoGenerate (    Sender : TObject;
                            var Done   : Boolean); override;
    // Properties
    property RptFldCondition : TRptFldItem read  FRptFldCond
                                           write FRptFldCond;
    property ActiveListBox : TListBox read  FActiveListBox
                                      write SetActiveListBox;
    property SelectedItem : Integer read  GetSelectedItem
                                    write SetSelectedItem;
    property RptFldSelectedItem : TRptFldItem read  GetRptFldSelectedItem;
  public
    { Public declarations }
    // Methods
    procedure ConfigureConditionComponents; virtual;
    procedure ReadIniRptHeader (ObjIniFile : TIniFile); override;
    procedure ReadIniRptCorps (ObjIniFile : TIniFile); override;
    procedure WriteIniRptHeader (ObjIniFile : TIniFile); override;
    procedure WriteIniRptCorps (ObjIniFile : TIniFile); override;
    procedure ReportHdrDetail; override;
    procedure ReportLegend; override;
    procedure ReportConditions; virtual;
    procedure ConfigureDataSet; override;
    procedure ActivateDataSet; override;
    procedure DeActivateDataSet; override;
    procedure ReportNeedData (var FlgMoreData : Boolean;
                              var TxtRptLine  : string;
                              var FlgInclude  : Boolean); overload; virtual;
    procedure CheckBeforeGenerate; override;
    procedure PrepareReport; override;
    procedure GenerateReport; override;
    procedure AdjustRptExportDialogs; override;                                 //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.End
  published
    { Published declarations }
    // Properties
    property FlgAllConditions : Boolean read GetFlgAllConditions;
  end;   // of TFrmRptCfgChoice

var
  FrmRptCfgChoice       : TFrmRptCfgChoice;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  DBTables,

  StDate,
  StDateSt,
  StStrW,

  SmVSPrinter7Lib_TLB,

  ScEHdler,
  SfBusy,
  SfDialog,
  SfVSPrinter7,
  SmDBUtil_BDE,
  SrStnCom,                                                                     //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM
  FChlVSCustomerCA;                                                             //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'SfRptVSCfgChoice_BDE_DBC';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/core/devstand2005/src/DevStand2005/Develop/SfRptVSCfgChoice_BDE_DBC.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2013/01/10 12:47:25 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation TFrmRptCfgChoice
//*****************************************************************************

//=============================================================================
// Methods to read & write properties.
//=============================================================================

procedure TFrmRptCfgChoice.SetActiveListBox (Value : TListBox);
begin  // of TFrmRptCfgChoice.SetActiveListBox
  if Value = FActiveListBox then
    Exit;

  if Assigned (ActiveListBox) then
    SelectedItem := -1;

  FActiveListBox := Value;
  SelectedItem := ActiveListBox.TopIndex;
end;   // of TFrmRptCfgChoice.SetActiveListBox

//=============================================================================
// TFrmRptCfgChoice.GetSelectedItem : gets the number of the first
// selected item in ActiveListBox.
//=============================================================================

function TFrmRptCfgChoice.GetSelectedItem : Integer;
begin  // of TFrmRptCfgChoice.GetSelection
  if ActiveListBox.Items.Count > 0 then
    for Result := 0 to ActiveListBox.Items.Count - 1 do
      if ActiveListBox.Selected[Result] then
        Exit;
  Result := LB_ERR;
end;   // of TFrmRptCfgChoice.GetSelectedItem

//=============================================================================
// TFrmRptCfgChoice.SetSelectedItem : selects the given item in the
// ActiveListBox.
//=============================================================================

procedure TFrmRptCfgChoice.SetSelectedItem (Value : Integer);
begin  // of TFrmRptCfgChoice.SetSelectedItem
  if (Value >= 0) and (Value < ActiveListBox.Items.Count) then
    ActiveListBox.Selected[Value] := True
  else if Value < 0 then begin
    Value := GetSelectedItem;
    while Value <> LB_ERR do begin
      ActiveListBox.Selected[Value] := False;
      Value := GetSelectedItem;
    end;
  end;

  AdjustBtnsDependListBox;
  ConfigureConditionComponents;
end;   // of TFrmRptCfgChoice.SetSelectedItem

//=============================================================================
// TFrmRptCfgChoice.GetRptFldSelectedItem : get the ReportField of the
// SelectedItem (do not confuse with RptFldCondition with is the ReportField
// for the current Condition-data in the Form).
//=============================================================================

function TFrmRptCfgChoice.GetRptFldSelectedItem : TRptFldItem;
var
  NumSelItem       : Integer;          // Number selected item
begin  // of TFrmRptCfgChoice.GetRptFldSelectedItem
  NumSelItem := SelectedItem;
  if NumSelItem <> LB_ERR then
    Result := TRptFldItem(ActiveListBox.Items.Objects[NumSelItem])
  else
    Result := nil;
end;   // of TFrmRptCfgChoice.GetRptFldSelectedItem

//=============================================================================

function TFrmRptCfgChoice.GetFlgAllConditions : Boolean;
begin  // of TFrmRptCfgChoice.GetFlgAllConditions
  Result := RbtFldCondAll.Checked;
end;   // of TFrmRptCfgChoice.GetFlgAllConditions

//=============================================================================
// Methods
//=============================================================================

//=============================================================================
// TFrmRptCfgChoice.AdjustBtnsDependListBox : enable/disable the options
// (menu and speedbuttons) INCLUDE, INCLUDE ALL, EXCLUDE, EXCLUDE ALL, MOVE UP
// and // MOVE DOWN according to the ActiveListBox and the number of items in
// LbxAvial and LbxChoice.
//=============================================================================

procedure TFrmRptCfgChoice.AdjustBtnsDependListBox;
begin  // of TFrmRptCfgChoice.AdjustBtnsDependListBox
  MniIncl.Enabled    := LbxAvail.SelCount > 0;
  MniInclAll.Enabled := LbxAvail.Items.Count > 0;
  MniExcl.Enabled    := LbxChoice.SelCount > 0;
  MniExclAll.Enabled := LbxChoice.Items.Count > 0;
  MniMoveUp.Enabled  := LbxChoice.SelCount > 0;
  MniMoveDn.Enabled  := LbxChoice.SelCount > 0;

  BtnIncl.Enabled    := MniIncl.Enabled;
  BtnInclAll.Enabled := MniInclAll.Enabled;
  BtnExcl.Enabled    := MniExcl.Enabled;
  BtnExclAll.Enabled := MniExclAll.Enabled;
  BtnMoveDn.Enabled  := MniMoveDn.Enabled;
  BtnMoveUp.Enabled  := MniMoveUp.Enabled;
end;   // of TFrmRptCfgChoice.AdjustBtnsDependListBox

//=============================================================================
// TFrmRptCfgChoice.AdjustConditionFromTo : enables/disablas components for
// upper and lower condition, depending on selected condition.
//=============================================================================

procedure TFrmRptCfgChoice.AdjustConditionFromTo;
begin  // of TFrmRptCfgChoice.AdjustConditionFromTo
  SvcLFCondLower.Enabled := SvcLFCondLower.Visible and
                            Assigned (RptFldCondition) and
                            (RptFldCondition.rfoCondition in
                                [rfoInLimits, rfoSubString]) and
                           (RptFldCondition.DataType <> pftString) and
                           (not (rioRangeList in RptFldCondition.RangeOptions));

  SvcMECondLower.Enabled := SvcMECondLower.Visible and
                            Assigned (RptFldCondition) and
                            (RptFldCondition.rfoCondition in
                                [rfoInLimits, rfoSubString]) and
                           (RptFldCondition.DataType = pftString) and
                           (not (rioRangeList in RptFldCondition.RangeOptions));

  CbxCondLower.Enabled := CbxCondLower.Visible and
                          Assigned (RptFldCondition) and
                          (RptFldCondition.rfoCondition = rfoInLimits) and
                          (rioRangeList in RptFldCondition.RangeOptions);

  LblCondSubStr.Visible  := Assigned (RptFldCondition) and
                            (RptFldCondition.rfoCondition = rfoSubString);
  LblCondLower.Visible   := not LblCondSubStr.Visible;
  LblCondLower.Enabled   := SvcLFCondLower.Enabled or SvcMECondLower.Enabled or
                            CbxCondLower.Enabled;

  SvcLFCondUpper.Enabled := SvcLFCondLower.Enabled and
                            not LblCondSubStr.Visible;
  SvcMECondUpper.Enabled := SvcMECondLower.Enabled and
                            not LblCondSubStr.Visible;
  CbxCondUpper.Enabled   := CbxCondLower.Enabled and not LblCondSubStr.Visible;
  LblCondUpper.Enabled   := SvcLFCondUpper.Enabled or SvcMECondUpper.Enabled or
                            CbxCondUpper.Enabled;
end;   // of TFrmRptCfgChoice.AdjustConditionFromTo

//=============================================================================
// TFrmRptCfgChoice.AdjustCurrReportWidth : adjust current total ReportWidth
// for included or excluded ReportField.
//                                  -----
// INPUT : RptFld = ReportField to adjust total ReportWidth for.
//         FlgInclude = True to adjust for Include;
//                      False to adjust for Exclude.
//                                  -----
// Restrictions:
// - an exception is raised if RptFld can't be included within the
//   maximum ReportWidth.
//=============================================================================

procedure TFrmRptCfgChoice.AdjustCurrReportWidth (RptFld     : TRptFldItem;
                                                  FlgInclude : Boolean    );
var
  ValFldWidth      : Integer;          // Width of a field
begin   // of TFrmRptCfgChoice.AdjustCurrReportWidth
  ValFldWidth := FrmVSPreview.ColumnWidthInTwips (RptFld.ReportWidth);

  if FlgInclude then begin
    if CurrentReportWidth + ValFldWidth >= MaxReportWidth then
      raise ERangeError.Create
         (Format (CtTxtExceedPageWidth,
                  [RptFld.Title, '+/-' + IntToStr (MaxReportWidthInChar)]));
    CurrentReportWidth := CurrentReportWidth + ValFldWidth;
  end   // of if FlgInclude then begin
  else
    CurrentReportWidth := CurrentReportWidth - ValFldWidth;
end;    // of TFrmRptCfgChoice.AdjustCurrReportWidth

//=============================================================================
// TFrmRptCfgChoice.MoveOneItem : moves one item form ActiveListBox to the
// other ListBox.
//                                  -----
// INPUT : NumItem = number of the item in ActiveListBox to move.
//=============================================================================

procedure TFrmRptCfgChoice.MoveOneItem (NumItem : Integer);
var
  LbxOpposite      : TListBox;         // Opposite listbox
  NumInsert        : Integer;          // Number to insert item (-1 to add)
  NumRptFld        : Integer;          // Number RptFld in ReportFields
begin  // of TFrmRptCfgChoice.MoveOneItem
  NumInsert := -1;
  if ActiveListBox = LbxAvail then
    LbxOpposite := LbxChoice
  else begin
    LbxOpposite := LbxAvail;
    if LbxAvail.Items.Count > 0 then begin
      NumRptFld := SvcTskActive.FindIDReportField
                     (TRptFldItem(ActiveListBox.Items.Objects[NumItem]));
      for NumInsert := 0 to Pred (LbxAvail.Items.Count) do begin
        if SvcTskActive.FindIDReportField
            (TRptFldItem(LbxAvail.Items.Objects[NumInsert])) > NumRptFld then
          Break;
      end;
    end;
  end;

  AdjustCurrReportWidth (TRptFldItem(ActiveListBox.Items.Objects[NumItem]),
                         ActiveListBox = LbxAvail);
  if NumInsert = -1 then
    LbxOpposite.Items.AddObject (ActiveListBox.Items[NumItem],
                                 ActiveListBox.Items.Objects[NumItem])
  else
    LbxOpposite.Items.InsertObject (NumInsert, ActiveListBox.Items[NumItem],
                                    ActiveListBox.Items.Objects[NumItem]);
  TRptFldItem(ActiveListBox.Items.Objects[NumItem]).Checked :=
    ActiveListBox = LbxAvail;
  ActiveListBox.Items.Delete(NumItem);
end;   // of TFrmRptCfgChoice.MoveOneItem

//=============================================================================
// TFrmRptCfgChoice.AutoGenerate : generates the list automatic.
//=============================================================================

procedure TFrmRptCfgChoice.AutoGenerate (    Sender : TObject;
                                         var Done   : Boolean);
begin  // of TFrmRptCfgChoice.AutoGenerate
  try
    inherited AutoGenerate (Sender, Done);

    case CodOutputMedium of
      CtCodOutExportFile : begin
        if TxtFNReportExport <> '' then
          ExportReport (TxtFNReportExport);
      end;

      else
        MniPrintClick (MniPrint);
    end;

    SvcExceptHandler.LogMessage (CtChrLogInfo,
                                 SvcExceptHandler.BuildLogMessage
                                   (CtNumInfoMin, [CtTxtExecEnd]));
  except
    Application.HandleException (Self);
  end;

  Close;
end;   // of TFrmRptCfgChoice.AutoGenerate

//=============================================================================
// TFrmRptCfgChoice.ConfigureConditionComponents : configures the components
// for condition, depending on selected ReportField.
//=============================================================================

procedure TFrmRptCfgChoice.ConfigureConditionComponents;
begin  // of TFrmRptCfgChoice.ConfigureConditionComponents
  RptFldCondition := RptFldSelectedItem;

  if Assigned (RptFldCondition) then
    LblCondition.Caption := RptFldCondition.Title + ':';

  if (Assigned (RptFldCondition)) and RptFldCondition.AllowEdit then begin
    CbxFieldCond.Enabled := True;
    CbxFieldCond.ItemIndex := Ord (RptFldCondition.rfoCondition);
    if rioRangeList in RptFldCondition.RangeOptions then begin
      SvcLFCondLower.Visible := False;
      SvcLFCondUpper.Visible := False;
      SvcMECondLower.Visible := False;
      SvcMECondUpper.Visible := False;
      RptFldCondition.ConfigureFromToComponents (CbxCondLower, CbxCondUpper);
    end
    else if RptFldCondition.DataType = pftString then begin
      SvcLFCondLower.Visible := False;
      SvcLFCondUpper.Visible := False;
      CbxCondLower.Visible   := False;
      CbxCondUpper.Visible   := False;
      RptFldCondition.ConfigureFromToComponents (SvcMECondLower,SvcMECondUpper);
    end
    else begin
      SvcMECondLower.Visible := False;
      SvcMECondUpper.Visible := False;
      CbxCondLower.Visible   := False;
      CbxCondUpper.Visible   := False;
      RptFldCondition.ConfigureFromToComponents (SvcLFCondLower,SvcLFCondUpper);
    end;
  end
  else begin
    CbxFieldCond.Enabled   := False;
    SvcLFCondLower.Visible := False;
    SvcLFCondUpper.Visible := False;
    SvcMECondLower.Visible := False;
    SvcMECondUpper.Visible := False;
    CbxCondLower.Visible   := False;
    CbxCondUpper.Visible   := False;
  end;

  AdjustConditionFromTo;
end;   // of TFrmRptCfgChoice.ConfigureConditionComponents

//=============================================================================

procedure TFrmRptCfgChoice.ReadIniRptHeader (ObjIniFile : TIniFile);
begin  // of TFrmRptCfgChoice.ReadIniRptHeader
  inherited;
  // Load settings Legend and Condition
  ChxInclLegend.Checked := ObjIniFile.ReadBool (CtTxtSecReport,
                                                CtTxtItmPrnLegend, False);
  ChxInclConditions.Checked := ObjIniFile.ReadBool (CtTxtSecReport,
                                                    CtTxtItmPrnConditions,
                                                    False);
end;   // of TFrmRptCfgChoice.ReadIniRptHeader

//=============================================================================

procedure TFrmRptCfgChoice.ReadIniRptCorps (ObjIniFile : TIniFile);
var
  RptFields        : TReportFields;    // Ptr to ReportFields
  TxtIni           : string;           // Item-value from INI
  CntRptFld        : Integer;          // Counter ReportFields in INI
  NumRptFld        : Integer;          // ID ReportField found in INI
  NumSelItem       : Integer;          // Itemnumber in LbxAvail
  CntCondition     : Integer;          // Counter Fields with conditions
begin  // of TFrmRptCfgChoice.ReadIniRptCorps
  RptFields := SvcTskActive.ReportFields;

  AdjustCmpReportWidth;

  // Deselect all fields
  MniInclExclAllClick (MniExclAll);
  if ActiveListBox = LbxAvail then
    // Make sure ActiveListBox switches to deselect all items
    ActiveListBox := LbxChoice;
  ActiveListbox := LbxAvail;
  SelectedItem := -1;
  // Remove all conditions
  RptFields.ClearConditions;

  // Read selected fields
  CntRptFld := 0;
  TxtIni := ObjIniFile.ReadString (CtTxtSecFields,
                                   CtTxtItmName + IntToStr (CntRptFld),
                                   '');
  while TxtIni <> '' do begin
    try
      NumRptFld := RptFields.FindIDName (TxtIni);
      if NumRptFld < 0 then
        raise ESvcLocalScope.Create (Format (CtTxtEmFieldNotFound, [TxtIni]));
      NumSelItem := LbxAvail.Items.IndexOfObject (RptFields[NumRptFld]);
      if NumSelItem >= 0 then begin
        SelectedItem := NumSelItem;
        MniInclExclClick (MniIncl);
        SelectedItem := -1;
      end;
    except
      on E:Exception do begin
        SelectedItem := -1;
        TxtFNReportConfig := '';
        Application.HandleException (E);
        Break;
      end;
    end;
    Inc (CntRptFld);
    TxtIni := ObjIniFile.ReadString (CtTxtSecFields,
                                     CtTxtItmName + IntToStr (CntRptFld),
                                     '');
  end;
  if LbxChoice.Items.Count > 0 then begin
    ActiveListBox := LbxChoice;
    SelectedItem := 0;
  end;

  // Read conditions
  CntCondition := 0;
  TxtIni := ObjIniFile.ReadString
              (CtTxtSecConditions + IntToStr (CntCondition),
               CtTxtItmName, '');
  while TxtIni <> '' do begin
    try
      NumRptFld := RptFields.FindIDName (TxtIni);
      if NumRptFld < 0 then
        raise ESvcLocalScope.Create (Format (CtTxtEmFieldNotFound, [TxtIni]));
      RptFields[NumRptFld].rfoCondition :=
        TCodRptFldCond (Ord (ObjIniFile.ReadInteger
                             (CtTxtSecConditions + IntToStr (CntCondition),
                              CtTxtItmCondition, 0)));
      if RptFields[NumRptFld].rfoCondition = rfoInLimits then begin
        RptFields[NumRptFld].RangeFromAsDefFmt :=
          ObjIniFile.ReadString (CtTxtSecConditions + IntToStr (CntCondition),
                                 CtTxtItmConditionFrom, '');
        RptFields[NumRptFld].RangeToAsDefFmt :=
          ObjIniFile.ReadString
            (CtTxtSecConditions + IntToStr (CntCondition),
             CtTxtItmConditionTo, '');
      end
      else if RptFields[NumRptFld].rfoCondition = rfoSubString then
        RptFields[NumRptFld].ConditionSubString :=
          ObjIniFile.ReadString
            (CtTxtSecConditions + IntToStr (CntCondition),
             CtTxtItmConditionSubString, '');
    except
      on E:Exception do begin
        Application.HandleException (E);
        TxtFNReportConfig := '';
      end;
    end;
    Inc (CntCondition);
    TxtIni := ObjIniFile.ReadString
                (CtTxtSecConditions + IntToStr (CntCondition),
                 CtTxtItmName, '');
  end;
end;   // of TFrmRptCfgChoice.ReadIniRptCorps

//=============================================================================

procedure TFrmRptCfgChoice.WriteIniRptHeader (ObjIniFile : TIniFile);
begin  // of TFrmRptCfgChoice.WriteIniRptHeader
  inherited;
  // Load settings Legend and Condition
  ObjIniFile.WriteBool (CtTxtSecReport, CtTxtItmPrnLegend,
                        ChxInclLegend.Checked);
  ObjIniFile.WriteBool (CtTxtSecReport, CtTxtItmPrnConditions,
                        ChxInclConditions.Checked);
end;   // of TFrmRptCfgChoice.WriteIniRptHeader

//=============================================================================

procedure TFrmRptCfgChoice.WriteIniRptCorps (ObjIniFile : TIniFile);
var
  RptFields        : TReportFields;    // Ptr to ReportFields
  CntRptFld        : Integer;          // Counter in ReportFields
  CntCondition     : Integer;          // Counter Fields with conditions
begin  // of TFrmRptCfgChoice.WriteIniRptCorps
  RptFields := SvcTskActive.ReportFields;

  if LbxChoice.Items.Count > 0 then begin
    // Create section selected ReportFields
    ObjIniFile.EraseSection (CtTxtSecFields);
    for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do
      ObjIniFile.WriteString
        (CtTxtSecFields,
         CtTxtItmName + IntToStr (CntRptFld),
         TRptFldItem(LbxChoice.Items.Objects[CntRptFld]).Name);
  end;

  CntCondition := 0;
  ObjIniFile.EraseSection (CtTxtSecConditions);
  for CntRptFld := 0 to Pred (RptFields.Count) do begin
    // Find conditions & create a section for each condition
    if RptFields[CntRptFld].rfoCondition <>
       rfoNoCondition then begin
      ObjIniFile.WriteString
        (CtTxtSecConditions + IntToStr (CntCondition),
         CtTxtItmName, RptFields[CntRptFld].Name);
      ObjIniFile.WriteString
        (CtTxtSecConditions + IntToStr (CntCondition),
         CtTxtItmCondition,
         IntToStr (Ord (RptFields[CntRptFld].rfoCondition)));
      if RptFields[CntRptFld].rfoCondition = rfoInLimits then begin
        ObjIniFile.WriteString
          (CtTxtSecConditions + IntToStr (CntCondition),
           CtTxtItmConditionFrom, RptFields[CntRptFld].RangeFromAsDefFmt);
        ObjIniFile.WriteString
          (CtTxtSecConditions + IntToStr (CntCondition),
           CtTxtItmConditionTo, RptFields[CntRptFld].RangeToAsDefFmt);
      end
      else if RptFields[CntRptFld].rfoCondition = rfoSubString then
        ObjIniFile.WriteString
          (CtTxtSecConditions + IntToStr (CntCondition),
           CtTxtItmConditionSubString,
           RptFields[CntRptFld].ConditionSubString);
      Inc (CntCondition);
    end;
  end;
end;   // of TFrmRptCfgChoice.WriteIniRptCorps

//=============================================================================
// TFrmRptCfgChoice.ReportHdrDetail: Adds headerlins for listheader.
//=============================================================================

procedure TFrmRptCfgChoice.ReportHdrDetail;
var
  CntRptFld        : Integer;          // Loop-variable reportfields
  RptFld           : TRptFldItem;      // Current ReportField
  TxtSep           : string;           // Seperator character
begin  // of TFrmRptCfgChoice.ReportHdrDetail
  TxtVspHdrFormat := '';
  TxtVspHdrTitle  := '';
  TxtSep          := '';

  for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do begin
    RptFld := TRptFldItem(LbxChoice.Items.Objects[CntRptFld]);

    TxtVspHdrTitle := TxtVspHdrTitle + TxtSep + RptFld.PrintTitle;
    TxtVspHdrFormat := TxtVspHdrFormat + TxtSep + BuildFmtForRptField (RptFld);

    TxtSep := TxtSeparatorColumn;
  end;

  TxtVspHdrTitle  := TxtVspHdrTitle + TxtSeparatorRow;
  TxtVspHdrFormat := TxtVspHdrFormat + TxtSeparatorRow;
end;   // of TFrmRptCfgChoice.ReportHdrDetail

//=============================================================================
// TFrmRptCfgChoice.ReportLegend: Adds legend lines to the report.
//=============================================================================

procedure TFrmRptCfgChoice.ReportLegend;
var
  CntRptFld        : Integer;          // Loop-variable
  SavFontSize      : Single;           // Saved font size property
  SavTableBorder   : Integer;          // Saved table border property
  TxtSep           : string;           // Seperator character
begin  // of TFrmRptCfgChoice.ReportLegend
  ReportSimpleText ('');
  PrintHdrSubreport (CtTxtLegend);

  TxtSep := TxtSeparatorColumn;
  SavFontSize := VspPreview.FontSize;
  SavTableBorder := VspPreview.TableBorder;
  try
    VspPreview.FontSize := FontSizeSubreport;
    VspPreview.TableBorder := tbNone;
    for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do begin
      AddLineToLegend
        (TRptFldItem(LbxChoice.Items.Objects[CntRptFld]).PrintTitle,
         TRptFldItem(LbxChoice.Items.Objects[CntRptFld]).Title);
    end;
  finally
    VspPreview.FontSize := SavFontSize;
    VspPreview.TableBorder := SavTableBorder;
  end;
end;   // of TFrmRptCfgChoice.ReportLegend

//=============================================================================
// TFrmRptCfgChoice.ReportConditions: Adds condition lines to the report.
//=============================================================================

procedure TFrmRptCfgChoice.ReportConditions;
var
  CntRptFld         : Integer;         // Loop-variable
  FlgCondPrint      : Boolean;         // At least one condition printed
  TxtSep           : string;           // Seperator character

//------------------------------------------------------------------------------

procedure CreateConditionLine (RptFld : TRptFldItem);
var
  TxtRptLine       : string;           // Build line to print
  SavFontSize      : Single;           // Saved font size property
  SavTableBorder   : Integer;          // Saved table border property
begin  // of CreateConditionLine
  if not FlgCondPrint then begin
    if FlgAllConditions then
      TxtRptLine := CtTxtConditionsAll
    else
      TxtRptLine := CtTxtConditionsOne;

    ReportSimpleText ('');
    PrintHdrSubreport (TxtRptLine);
    FlgCondPrint := True;
  end;

  SavFontSize := VspPreview.FontSize;
  SavTableBorder := VspPreview.TableBorder;
  try
    VspPreview.FontSize := FontSizeSubreport;
    VspPreview.TableBorder := tbNone;

    TxtRptLine := RptFld.Title +
                  TxtSeparatorColumn + ':' + TxtSep +
                  CbxFieldCond.Items[Ord (RptFld.rfoCondition)];
    if RptFld.rfoCondition = rfoInLimits then begin
      // If Conditions are empty for non-string fields, then use Ranges to
      // build ConditionLine
      if (RptFld.DataType <> pftString) and (RptFld.ConditionFrom = '') then
        TxtRptLine := TxtRptLine + ' ' + RptFld.RangeLo
      else
        TxtRptLine := TxtRptLine + ' ' + RptFld.ConditionFrom;
      if (RptFld.DataType <> pftString) and (RptFld.ConditionTo = '') then
        TxtRptLine := TxtRptLine + ' - ' + RptFld.RangeHi
      else
        TxtRptLine := TxtRptLine + ' - ' + RptFld.ConditionTo;
    end
    else if RptFld.rfoCondition = rfoSubString then
      TxtRptLine := TxtRptLine + ' ' + RptFld.ConditionSubString;

    TxtRptLine := TxtRptLine + TxtSeparatorRow;

      case CodOutputMedium of
        CtCodOutExportFile : AppendExportLine (TxtRptLine);
        else
          VspPreview.AddTable (BuildFmtForLegend, '', TxtRptLine,
                               clWhite, clWhite, False);
      end;  // case CodOutputMedium of ...
  finally
    VspPreview.FontSize := SavFontSize;
    VspPreview.TableBorder := SavTableBorder;
  end;
end;   // of CreateConditionLine

//------------------------------------------------------------------------------

begin  // of TFrmRptCfgChoice.ReportConditions
  FlgCondPrint := False;
  TxtSep := TxtSeparatorColumn;

  for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do
    if TRptFldItem(LbxChoice.Items.Objects[CntRptFld]).rfoCondition <>
       rfoNoCondition then
      CreateConditionLine (TRptFldItem(LbxChoice.Items.Objects[CntRptFld]));
  for CntRptFld := 0 to Pred (LbxAvail.Items.Count) do
    if TRptFldItem(LbxAvail.Items.Objects[CntRptFld]).rfoCondition <>
       rfoNoCondition then
      CreateConditionLine (TRptFldItem(LbxAvail.Items.Objects[CntRptFld]));
end;   // of TFrmRptCfgChoice.ReportConditions

//=============================================================================
// TFrmRptCfgChoice.ConfigureDataSet : configures the DataSet of the ReportTask.
// Provides an inherited form with the possibility to perform specific DataSet
// actions such as making Queries and/or StoredProcs to launch.
// This method is triggered from within the method PrepareReport.
//=============================================================================

procedure TFrmRptCfgChoice.ConfigureDataSet;
begin  // of TFrmRptCfgChoice.ConfigureDataSet
  if SvcTskActive.DataSet is TQuery then
    SvcTskActive.BuildQrySQL (FlgAllConditions);
end;   // of TFrmRptCfgChoice.ConfigureDataSet

//=============================================================================
// TFrmRptCfgChoice.ActivateDataSet : activates the DataSet of the ReportTask.
//=============================================================================

procedure TFrmRptCfgChoice.ActivateDataSet;
begin  // of TFrmRptCfgChoice.ActivateDataSet
  SvcTskActive.DataSet.Active := True;
  SvcTskActive.DataSet.First;
  SvcTskActive.PrepareReport;
end;   // of TFrmRptCfgChoice.ActivateDataSet

//=============================================================================
// TFrmRptCfgChoice.DeActivateDataSet : deactivates the DataSet of ReportTask.
//=============================================================================

procedure TFrmRptCfgChoice.DeActivateDataSet;
begin  // of TFrmRptCfgChoice.DeActivateDataSet
  SvcTskActive.UnprepareReport;
  SvcTskActive.DataSet.Active := False;
end;   // of TFrmRptCfgChoice.DeActivateDataSet

//=============================================================================
// TFrmRptCfgChoice.ReportNeedData: procedure for filling report with data.
// It is meant as a placeholder for the QuickReport.OnNeedData EventHandler
// and is defined here to avoid inheriting of SfRptChoice for each choicelist.
//                                         ----
// OUTPUT : FlgMoreData = True if another row has to be printed.
//          TxtRptLine = row to print.
//          FlgInclude = True to include the row on the report;
//                       False to skip the row.
//=============================================================================

procedure TFrmRptCfgChoice.ReportNeedData (var FlgMoreData : Boolean;
                                           var TxtRptLine  : string;
                                           var FlgInclude  : Boolean);
var
  CntRptFld        : Integer;          // Counter reportfields
  RptFld           : TRptFldItem;      // Current ReportField
  TxtFldValue      : string;           // FieldValue current ReportField
  TxtSep           : string;           // Seperator character
begin  // of TFrmRptCfgChoice.ReportNeedData
  FlgMoreData := not SvcTskActive.DataSet.EOF;
  if not FlgMoreData then
    Exit;

  TxtRptLine := '';
  FlgInclude := True;
  if Assigned (SvcTskActive.BeforeBuildRptLine) then
    SvcTskActive.BeforeBuildRptLine (SvcTskActive, TxtRptLine, FlgInclude);

  if FlgInclude then begin
    TxtSep := '';
    for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do begin
      // Create detail
      RptFld := TRptFldItem(LbxChoice.Items.Objects[CntRptFld]);

      if Assigned (RptFld.FldData) then
        TxtFldValue := RptFld.FldData.DisplayText
      else
        TxtFldValue := '';
      if Assigned (RptFld.OnGetRptValue) then
        RptFld.OnGetRptValue (SvcTskActive, RptFld, TxtFldValue);
      if Assigned (SvcTskActive.OnGetRptValue) then
        SvcTskActive.OnGetRptValue (SvcTskActive, RptFld, TxtFldValue);

      TxtRptLine := TxtRptLine + TxtSep + TxtFldValue;

      TxtSep := TxtSeparatorColumn;
    end;
    TxtRptLine := TxtRptLine + TxtSeparatorRow;

    if Assigned (SvcTskActive.AfterBuildRptLine) then
      SvcTskActive.AfterBuildRptLine (SvcTskActive, TxtRptLine, FlgInclude);
  end;  // of FlgInclude = True

  SvcTskActive.DataSet.Next;
end;   // of TFrmRptCfgChoice.ReportNeedData

//=============================================================================

procedure TFrmRptCfgChoice.CheckBeforeGenerate;
begin  // of TFrmRptCfgChoice.CheckBeforeGenerate
  // Check if list contains selected items
  if LbxChoice.Items.Count = 0 then
    raise EInvalidOperation.Create (CtTxtNoFieldsSel);
end;   // of TFrmRptCfgChoice.CheckBeforeGenerate

//=============================================================================

procedure TFrmRptCfgChoice.PrepareReport;
begin  // of TFrmRptCfgChoice.PrepareReport
  inherited;

  if (CodOutputMedium = CtCodOutExportFile) and (not FlgExportRawData) and
     (not Assigned (RptExportFile) or RptExportFile.IncludeTableHeader) then
    ReportSimpleText (TxtVspHdrTitle);
end;   // of TFrmRptCfgChoice.PrepareReport

//=============================================================================
// procedure TFrmRptCfgChoice.GenerateReport: generates the report while
// displaying a window to abort.
//=============================================================================

procedure TFrmRptCfgChoice.GenerateReport;
var
  FlgMoreData      : Boolean;          // True as long as new lines generated
  TxtRptLine       : string;           // Generated reportline
  FlgInclude       : Boolean;          // True=include; False=skip current line
begin  // of TFrmRptCfgChoice.GenerateReport
  CreateFormGenerate;

  try
    try
      // Set properties for progress form
      FrmGenerate.PgsBarBusy.Max := SvcTskActive.DataSet.RecordCount;
      FrmGenerate.PgsBarBusy.Position := 0;
      FrmGenerate.Show;

      VspPreview.TableBorder := tbBoxRows;
      FlgMoreData := True;
      repeat
        CheckAbortGenerate;

        case FrmGenerate.ModalResult of
          mrAbort : begin
            ReportComment (CtTxtExecInterrupt);
            Abort;
          end;

          mrCancel : begin
            ReportComment (CtTxtExecInterrupt);
            Break;
          end;

          mrNone : begin
            ReportNeedData (FlgMoreData, TxtRptLine, FlgInclude);
            if FlgMoreData and FlgInclude then begin
              case CodOutputMedium of
                CtCodOutExportFile : begin
                  AppendExportLine (TxtRptLine);
                  Inc (NumPrintedLines);
                end;

                else begin
                  VspPreview.AddTable (TxtVspHdrFormat, TxtVspHdrTitle,
                                       TxtRptLine, clSilver, clWhite,
                                       not FlgPrintTblHdr);
                  Inc (NumPrintedLines);
                  FlgPrintTblHdr := False;
                end;
              end;  // of case CodOutputMedium of ...
            end;
            if FlgMoreData then
              FrmGenerate.PgsBarBusy.StepIt;
          end;  // of FrmProgess.ModalResult = mrNone
        end;  // of case FrmGenerate.ModalResult

      until (not FlgMoreData) or (FrmGenerate.ModalResult <> mrNone);

      if FrmGenerate.ModalResult = mrNone then begin
        if NumPrintedLines = 0 then
          ReportComment (CtTxtNoSelData);
      end;

     if (CodOutputMedium <> CtCodOutExportFile) or
        (not FlgExportRawData) then begin
        if ChxInclLegend.Checked then
          ReportLegend;
        if ChxInclConditions.Checked then
          ReportConditions;
     end;
    except
      FrmVSPreview.Hide;
      raise;
    end;
  finally
    FrmGenerate.Hide;
    FrmGenerate.Release;
    FrmGenerate := nil;
    Application.ProcessMessages;
    if Assigned (ActiveControl) then
      ActiveControl.SetFocus
    else
      LbxAvail.SetFocus;
  end;
end;   // of TFrmRptCfgChoice.GenerateReport

//=============================================================================
// Event handlers
//=============================================================================

procedure TFrmRptCfgChoice.FormActivate(Sender: TObject);

begin  // of TFrmRptCfgChoice.FormActivate

  if not Assigned (SvcTskActive) then
    raise Exception.Create (Format (CtTxtEmPropMissing, ['ActiveTask']));

  if FlgFirstActive then begin
    // Build Listbox with available fields to include in report
    SvcTskActive.BuildStrLstReportFields (TStringList(LbxAvail.Items));

    inherited;

    // Initialize Combobox conditions
    if not Assigned (ActiveListBox) then
      ActiveListBox := LbxAvail;
    if SelectedItem = LB_ERR then
      SelectedItem := 0;


   //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.Start
    if FrmChlCustomerCA.FFlgLCBDFR then begin
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCCAFR then begin
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCCARU then begin
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
    if FrmChlCustomerCA.FFlgLCBDES then begin
      LbxAvail.Items.Delete(22);
      LbxAvail.Items.Delete(21);
      LbxAvail.Items.Delete(17);
      LbxAvail.Items.Delete(13);
      LbxAvail.Items.Delete(12);
      LbxAvail.Items.Delete(11);
      LbxAvail.Items.Delete(10);
      LbxAvail.Items.Delete(9);
      LbxAvail.Items.Delete(8);
    end;
  //R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.End
  end;
end;   // of TFrmRptCfgChoice.FormActivate

//=============================================================================

procedure TFrmRptCfgChoice.MniPrintClick(Sender: TObject);
begin  // of TFrmRptCfgChoice.MniPrintClick
  inherited;

  try
    if (Sender = BtnPrint) or (Sender = MniPrint) then
      VspPreview.Preview := False
    else
      VspPreview.Preview := True;

    VspPreview.FontSize := CurrentFontSize;
    FrmVSPreview.Show;
    VspPreview.StartDoc;

    FlgPrintTblHdr  := True;
    NumPrintedLines := 0;
    try
      PrepareReport;
      GenerateReport;
    finally
      VspPreview.EndDoc;
    end;

    if Assigned (SvcTskActive.OnEndGenerate) then
      SvcTskActive.OnEndGenerate (SvcTskActive);

    FrmVSPreview.Hide;
    // Show progress of report generation
    if (Sender = BtnPreview) or (Sender = MniPreview) then
      FrmVSPreview.ShowModal;
  finally
    DeactivateDataSet;
  end;
end;   // of TFrmRptCfgChoice.MniPrintClick

//=============================================================================

procedure TFrmRptCfgChoice.MniInclExclClick(Sender: TObject);
var
  NumSelItem       : Integer;          // Number first selected item
  NumLastMoved     : Integer;          // Number last moved item
begin  // of TFrmRptCfgChoice.MniInclExclClick
  ForceFocusChange;

  // Move selected items from active listbox to opposite listbox
  if (Sender = MniIncl) or (Sender = BtnIncl) then
    ActiveListBox := LbxAvail
  else
    ActiveListBox := LbxChoice;

  NumLastMoved := -1;
  if ActiveListBox.Items.Count > 0 then begin
    NumSelItem := SelectedItem;
    while NumSelItem <> LB_ERR do begin
      MoveOneItem (NumSelItem);
      NumLastMoved := NumSelItem;
      NumSelItem := SelectedItem;
    end;   // of while NumSelItem <> LB_ERR

    if (ActiveListBox.SelCount = 0) and (NumLastMoved >= 0) then begin
      // Select next item after moved items
      if NumLastMoved < ActiveListBox.Items.Count then
        SelectedItem := NumLastMoved
      else begin
        if ActiveListBox.Items.Count = 0 then begin
          if ActiveListBox = LbxAvail then
            ActiveListBox := LbxChoice
          else
            ActiveListBox := LbxAvail;
          ActiveListBox.SetFocus;
        end;
        SelectedItem := 0;
      end;
    end;
  end;
end;   // of TFrmRptCfgChoice.MniInclExclClick

//=============================================================================

procedure TFrmRptCfgChoice.MniInclExclAllClick(Sender: TObject);
var
  NumMoveItem      : Integer;          // Itemnumber to move
begin  // of TFrmRptCfgChoice.MniInclExclAllClick
  ForceFocusChange;

  // Move all items from active listbox to opposite listbox
  if (Sender = MniInclAll) or (Sender = BtnInclAll) then
    ActiveListBox := LbxAvail
  else
    ActiveListBox := LbxChoice;

  NumMoveItem := 0;
  while NumMoveItem < ActiveListBox.Items.Count do begin
    try
      MoveOneItem (NumMoveItem);
    except
      on E:ERangeError do
        Inc (NumMoveItem);
        // Drop exception on maximum ReportWidth, proceed with following
        // fields.
      else
        raise;
    end;
  end;

  if ActiveListBox.Items.Count = 0 then begin
    if ActiveListBox = LbxAvail then
      ActiveListBox := LbxChoice
    else
      ActiveListBox := LbxAvail;
    ActiveListBox.SetFocus;
  end;
  SelectedItem := 0;
end;   // of TFrmRptCfgChoice.MniInclExclAllClick

//=============================================================================

procedure TFrmRptCfgChoice.MniMoveUpClick(Sender: TObject);
var
  CntForLoop       : Integer;          // Counter for-loop
  CntItemSel       : Integer;          // Counter current item
begin  // of TFrmRptCfgChoice.MniMoveUpClick
  ForceFocusChange;

  if LbxChoice.Items.Count = 0 then
    Exit;

  LbxChoice.Setfocus;

  CntItemSel := 0;
  for CntForLoop := 0 to Pred (LbxChoice.Items.Count) do begin
    if LbxChoice.Selected[CntItemSel] then begin
      if CntItemSel > 0 then begin
        LbxChoice.Items.Move (CntItemSel, CntItemSel - 1);
        LbxChoice.Selected[CntItemSel - 1] := True;
      end
      else begin
        LbxChoice.Items.Move (0, Pred (LbxChoice.Items.Count));
        LbxChoice.Selected[Pred (LbxChoice.Items.Count)] := True;
        Break;
      end;
    end;
    Inc (CntItemSel);
  end;
end;   // of TFrmRptCfgChoice.MniMoveUpClick

//=============================================================================

procedure TFrmRptCfgChoice.MniMoveDnClick(Sender: TObject);
var
  CntForLoop       : Integer;          // Counter for-loop
  CntItemSel       : Integer;          // Counter current item
begin  // of TFrmRptCfgChoice.MniMoveDnClick
  ForceFocusChange;

  if LbxChoice.Items.Count = 0 then
    Exit;

  LbxChoice.Setfocus;

  CntItemSel := Pred (LbxChoice.Items.Count);
  for CntForLoop := 0 to Pred (LbxChoice.Items.Count) do begin
    if LbxChoice.Selected[CntItemSel] then begin
      if CntItemSel < Pred (LbxChoice.Items.Count) then begin
        LbxChoice.Items.Move (CntItemSel, CntItemSel + 1);
        LbxChoice.Selected[CntItemSel + 1] := True;
      end
      else begin
        LbxChoice.Items.Move (CntItemSel, 0);
        LbxChoice.Selected[0] := True;
        Break;
      end;
    end;
    Dec (CntItemSel);
  end;
end;   // of TFrmRptCfgChoice.MniMoveDnClick

//=============================================================================

procedure TFrmRptCfgChoice.CbxFieldCondChange(Sender: TObject);
begin  // of TFrmRptCfgChoice.CbxFieldCondChange
  if Assigned (RptFldCondition) then begin
    if (TCodRptFldCond (CbxFieldCond.ItemIndex) = rfoSubString) and
       (not RptFldCondition.SubStringPossible) then
      CbxFieldCond.ItemIndex := Ord (rfoNoCondition);
    RptFldCondition.rfoCondition := TCodRptFldCond (CbxFieldCond.ItemIndex);
    ConfigureConditionComponents;
  end;
end;   // of TFrmRptCfgChoice.CbxFieldCondChange

//=============================================================================

procedure TFrmRptCfgChoice.SvcLFCondLowUpChange(Sender: TObject);
begin  // of TFrmRptCfgChoice.SvcLFCondLowUpChange
  if TSvcLocalField(Sender).Modified then begin
    if (Trim (TSvcLocalField(Sender).Text) = '') and
       (not RptFldCondition.RangeIsSubString) then
      if Sender = SvcLFCondLower then
        SvcLFCondLower.Text := SvcLFCondLower.RangeLo
      else if Sender = SvcLFCondUpper then
        SvcLFCondUpper.Text := SvcLFCondUpper.RangeHi;
  end;
end;   // of TFrmRptCfgChoice.SvcLFCondLowUpChange

//=============================================================================

procedure TFrmRptCfgChoice.SvcLFCondLowerUserValidation(Sender: TObject;
  var ErrorCode: Word);
begin  // of TFrmRptCfgChoice.SvcLFCondLowerUserValidation
  if ErrorCode = 0 then
    if RptFldCondition.RangeIsSubString then
      RptFldCondition.ConditionSubString := SvcLFCondLower.Text
    else
      RptFldCondition.ConditionFrom := SvcLFCondLower.Text;
end;   // of TFrmRptCfgChoice.SvcLFCondLowerUserValidation

//=============================================================================

procedure TFrmRptCfgChoice.SvcLFCondUpperUserValidation(Sender: TObject;
  var ErrorCode: Word);
begin  // of TFrmRptCfgChoice.SvcLFCondUpperUserValidation
  if ErrorCode = 0 then
    RptFldCondition.ConditionTo := SvcLFCondUpper.Text;
end;   // of TFrmRptCfgChoice.SvcLFCondUpperUserValidation

//=============================================================================

procedure TFrmRptCfgChoice.CbxCondLowUpChange(Sender: TObject);
begin  // of TFrmRptCfgChoice.CbxCondLowUpChange
  inherited;

  if Sender = CbxCondLower then
    RptFldCondition.ConditionFrom :=
      RptFldCondition.ValueRangeItem[CbxCondLower.Text]
  else if Sender = CbxCondUpper then
    RptFldCondition.ConditionTo :=
      RptFldCondition.ValueRangeItem[CbxCondUpper.Text];
end;   // of TFrmRptCfgChoice.CbxCondLowUpChange

//=============================================================================

procedure TFrmRptCfgChoice.LbxAvailChoiceClick(Sender: TObject);
begin  // of TFrmRptCfgChoice.LbxAvailChoiceClick
  ActiveListBox := TListBox(Sender);
  if SelectedItem = LB_ERR then
    SelectedItem := 0
  else
    ConfigureConditionComponents;
end;   // of TFrmRptCfgChoice.LbxAvailChoiceClick

//=============================================================================

procedure TFrmRptCfgChoice.LbxAvailChoiceDblClick(Sender: TObject);
begin  // of TFrmRptCfgChoice.LbxAvailChoiceDblClick
  ActiveListBox := TListBox(Sender);
  if ActiveListBox = LbxAvail then
    MniInclExclClick (MniIncl)
  else
    MniInclExclClick (MniExcl);
end;   // of TFrmRptCfgChoice.LbxAvailChoiceDblClick

//=============================================================================

procedure TFrmRptCfgChoice.LbxAvailChoiceEnter(Sender: TObject);
begin  // of TFrmRptCfgChoice.LbxAvailChoiceEnter
  ActiveListBox := TListBox(Sender);
  if SelectedItem = LB_ERR then
    SelectedItem := ActiveListBox.TopIndex;
end;   // of TFrmRptCfgChoice.LbxAvailChoiceEnter

//=============================================================================

procedure TFrmRptCfgChoice.LbxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin  // of TFrmRptCfgChoice.LbxDrawItem
  inherited;
  
  if (not Assigned (TListBox(Control).Items.Objects[Index])) or
     (TRptFldItem (TListBox(Control).Items.Objects[Index]).rfoCondition =
      rfoNoCondition) then
    TListBox(Control).Canvas.Font.Style :=
      TListBox(Control).Canvas.Font.Style - [fsBold]
  else
    TListBox(Control).Canvas.Font.Style :=
      TListBox(Control).Canvas.Font.Style + [fsBold];

  TListBox(Control).Canvas.FillRect (Rect);
  TListBox(Control).Canvas.TextOut (Rect.Left + 2, Rect.Top,
                                    TListBox(Control).Items[Index]);
end;   // of TFrmRptCfgChoice.LbxDrawItem

//=============================================================================

procedure TFrmRptCfgChoice.CbxFontSizeChange(Sender: TObject);
var
  CntRptFld        : Integer;          // Loop-variable reportfields
  RptFld           : TRptFldItem;      // Current ReportField
  ValCalcTable     : Integer;          // Calculated table width
  SavFontSize      : Integer;          // Original Font size
begin  // of TFrmRptCfgChoice.CbxFontSizeChange
  SavFontSize := VspPreview.Font.Size;

  VspPreview.Font.Size := CurrentFontSize;
  ValCalcTable := 0;
  for CntRptFld := 0 to Pred (LbxChoice.Items.Count) do begin
    RptFld := TRptFldItem(LbxChoice.Items.Objects[CntRptFld]);
    ValCalcTable := ValCalcTable +
                    FrmVSPreview.ColumnWidthInTwips (RptFld.ReportWidth);
  end;
  if ValCalcTable > MaxReportWidth then begin
    CurrentFontSize := SavFontSize;
    raise Exception.Create (CtTxtSizeChange);
  end;

  CurrentReportWidth := ValCalcTable;
end;   // of TFrmRptCfgChoice.CbxFontSizeChange

//=============================================================================

procedure TFrmRptCfgChoice.SvcMECondLowerPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin  // of TFrmRptCfgChoice.SvcMECondLowerPropertiesValidate
  inherited;
  if not Error then
    if RptFldCondition.RangeIsSubString then
      RptFldCondition.ConditionSubString := SvcMECondLower.TrimText
    else
      RptFldCondition.ConditionFrom := SvcMECondLower.TrimText;
end;   // of TFrmRptCfgChoice.SvcMECondLowerPropertiesValidate

//=============================================================================

procedure TFrmRptCfgChoice.SvcMECondUpperPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin  // of TFrmRptCfgChoice.SvcMECondUpperPropertiesValidate
  inherited;
  if not Error then
    RptFldCondition.ConditionTo := SvcMECondUpper.TrimText;
end;   // of TFrmRptCfgChoice.SvcMECondUpperPropertiesValidate

//=============================================================================
//R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.Start
//=============================================================================
// TFrmRptCfgChoice.AdjustRptExportDialogs : adjusts the dialogs for export the
// report to a file.
//                                         ----
// Restrictions:
// - is mainly intented to call just once from FormActivate.
//=============================================================================

procedure TFrmRptCfgChoice.AdjustRptExportDialogs;
var
  QryHlp              : TQuery;                                                 
begin  // of TFrmRptCfg.AdjustRptCfgDialogs
  if not SvcTskActive.AllowExport then begin
    MniExport.Visible := False;
    BtnExportToFile.Visible := False;
    Exit;
  end;
  if FrmChlCustomerCA.FlgListOfCustomer then begin
    QryHlp := TQuery.Create(self);
    try
      QryHlp.DatabaseName := 'DBFlexPoint';
      QryHlp.Active := False;
      QryHlp.SQL.Clear;
      QryHlp.SQL.Add('select * from ApplicParam' +
                     ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
      QryHlp.Active := True;
       TxtDirReportExport := QryHlp.FieldByName('TxtParam').AsString;
       if not DirectoryExists(TxtDirReportExport) then
        TxtDirReportExport :=
        ExtractFilePath (ExtractFileDir (Application.ExeName)) + 'Spool\';
    finally
      QryHlp.Active := False;
      QryHlp.Free;
    end;
  end;
  if not DirectoryExists(TxtDirReportExport) then
      ForceDirectories(TxtDirReportExport);
    SavDlgExportFile.InitialDir := TxtDirReportExport;

  // Configure Save-dialog
  SavDlgExportFile.Filter := SvcTskActive.ExportFiles.Filter;

  SavDlgExportFile.Title :=
    Format (SavDlgExportFile.Title, [SvcTskActive.TaskName]);
end;   // of TFrmRptCfg.AdjustRptExportDialogs

//=============================================================================
procedure TFrmRptCfgChoice.MniExportToFileClick(Sender: TObject);
var
  TxtFNSave        : string;           // FileName to save
begin  // of TFrmRptCfg.MniExportToFileClick
  ForceFocusChange;

  TxtFNSave := TxtFNReportExport;
  if TxtFNReportExport <> '' then
    SavDlgExportFile.FileName := TxtFNReportExport;

  SavDlgExportFile.InitialDir := TxtDirReportExport;
  if not SavDlgExportFile.Execute then
    Exit;

  TxtFNSave := SavDlgExportFile.FileName;

  if Assigned (RptExportFile) then begin
    TxtSeparatorColumn := RptExportFile.SeparatorColumnAsRptFmt;
    TxtSeparatorRow    := RptExportFile.SeparatorRowAsRptFmt;
    if (JustExtensionW (TxtFNSave) = '') and
       (RptExportFile.DefaultExtension <> '') then
      TxtFNSave := ForceExtensionW (SavDlgExportFile.FileName,
                                    RptExportFile.DefaultExtension);
  end
  else begin
    TxtSeparatorColumn := CtTxtDefSepColumn;
    TxtSeparatorRow    := CtTxtDefSepRow;
  end;

  if TxtFNSave <> '' then
    ExportReport (TxtFNSave);
end;

//=============================================================================
//R2013.1.ID26030.ListOfCustomer.ALL.TCS-SRM.End
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate, CtTxtSrcTag);
end.   // of SfRptVSCfgChoice_BDE_DBC

