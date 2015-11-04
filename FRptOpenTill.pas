//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Flexpoint Development
// Unit   : FRptOpenTill = Form Report to show the when the OPENING of TILLS has
//          happened
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptOpenTill.pas,v 1.3 2009/10/16 12:27:03 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptOpenTill - CVS revision 1.6
//=============================================================================


unit FRptOpenTill;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, OvcBase, OvcEF, OvcPB, OvcPF, ScUtils, SfVsPrinter7,
  SmVSPrinter7Lib_TLB, DBTables, StDate;


//=============================================================================
// Global definitions
//=============================================================================

resourcestring          // of date errors
  CtTxtStartEndDate          = 'Startdate is after enddate!';
  CtTxtErrorHeader           = 'Incorrect Date';

resourcestring // Run params
  CtTxtRunParamDateTime = '/D=Date of excecution';

resourcestring  // header and footer items
  CtTxtReportTitle = 'Time checkouts opened';
  CtTxtDate        = 'Rapport between %s %s and %s %s';
  CtTxtReference   = 'REP0020';

resourcestring // Column titles
  CtTxtDateTime    = 'Date Time';
  CtTxtCheckout    = 'Checkout';
  CtTxtOperator    = 'Operator';
  CtTxtName        = 'Name';

var    // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1300;   // Adjust MarginTop to leave room for hdr

var    // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

var    // Positions and white space
  ViValPosXAddress : Integer = 7000;   // X-position for address
  ViValSpaceBetween: Integer =  200;   // White space between tables

var
  ViTxtFNLogo      : string = 'FlexPoint.Report.BMP';   // Logo to print on the rapport
  DatSelect        : TStDate;                   // Date to select on

//=============================================================================
// type definitions
//=============================================================================

type
  TFrmRptOpenTill = class(TFrmAutoRun)
    GbxDateHour: TGroupBox;
    GbxSpecifDate: TGroupBox;
    LblFrom: TLabel;
    LblTo: TLabel;
    LblDate: TLabel;
    LblHour: TLabel;
    SvcLFDatFrom: TSvcLocalField;
    SvcLFDatTo: TSvcLocalField;
    SvcLFTimFrom: TSvcLocalField;
    SvcLFTimTo: TSvcLocalField;
    RbtDateTimeAll: TRadioButton;
    RbtDateTimeSpecif: TRadioButton;
    OvcCtlConfigRep: TOvcController;
    BtnPreview: TSpeedButton;
    ActPreview: TAction;
    Preview1: TMenuItem;
    BtnPrint: TSpeedButton;
    ActPrint: TAction;
    Print1: TMenuItem;
    ActPrintSetup: TAction;
    BtnPrintSetup: TSpeedButton;
    PrintSetup1: TMenuItem;
    N2: TMenuItem;
    procedure SvcLFDatFromChange(Sender: TObject);
    procedure SvcLFDatFromExit(Sender: TObject);
    procedure SvcLFDatToChange(Sender: TObject);
    procedure SvcLFDatToExit(Sender: TObject);
    procedure RbtDateTimeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActPreviewExecute(Sender: TObject);
    procedure ActPrintSetupExecute(Sender: TObject);
  protected
    // Save default settings of VspPreview
    ValOrigMarginTop    : Double;      // Original MarginTop
    QtyLinesPrinted     : Integer;     // Number of lines printed in table
    // Data Objects
    TxtTableFmt         : string;      // Format for current Table on report
    TxtTableHdr         : string;      // Header for current Table on report
    FlgPreview          : Boolean;     // Preview (True) or Print (False);
    // property functions
    function GetVspPreview : TVSPrinter; virtual;
    procedure PrintHeader; virtual;
    procedure PrintFooter; virtual;
    procedure BuildTableFmtAndHdr; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure PrintLine (QryOpenTill : TQuery); virtual;
    procedure GenerateTableBody; virtual;
    procedure GenerateTable; virtual;
  public
    { Public declarations }
    procedure BeforeCheckRunParams; override;
    procedure AfterCheckRunParams; override;
    procedure Execute; override;
    procedure AutoStart (Sender : TObject); override;
    property VspPreview : TVSPrinter read GetVspPreview;
  end;

var
  FrmRptOpenTill: TFrmRptOpenTill;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  StDateSt,

  DFpnUtils,
  DFpnPosTransactionCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptCfgOpenTill';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptOpenTill.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/10/16 12:27:03 $';

//*****************************************************************************
// Implementation of TFrmRptOpenTill
//*****************************************************************************

procedure TFrmRptOpenTill.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtFNLogo        : string;           // Logo file name
  ImgLogo          : TImage;           // Image to print for logo
begin  // of TFrmRptOpenTill.PrintHeader
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CurrentY := ValOrigMarginTop;
  TxtHdr := CtTxtReportTitle + #10#10;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName + #10#10;
  if RbtDateTimeSpecif.Checked then
    TxtHdr := TxtHdr +
      Format (CtTxtDate,
              [FormatDateTime (CtTxtDatFormat, SvcLFDatFrom.AsDateTime),
               FormatDateTime (CtTxtHouFormat, SvcLFTimFrom.AsDateTime),
               FormatDateTime (CtTxtDatFormat, SvcLFDatTo.AsDateTime),
               FormatDateTime (CtTxtHouFormat, SvcLFTimTo.AsDateTime)]) + #10;
  VspPreview.Header := TxtHdr;
  VspPreview.CurrentY := ValOrigMarginTop + ViValMarginHeader;
  ImgLogo := nil;
  if not Assigned (ImgLogo) then
    ImgLogo := TImage.Create (Self);
  TxtFNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + ViTxtFNLogo;
  if FileExists (TxtFNLogo) then
    ImgLogo.Picture.LoadFromFile (TxtFNLogo);
  FrmVSPreview.DrawLogo (ImgLogo);
end;   // of TFrmRptOpenTill.PrintHeader

//=============================================================================

procedure TFrmRptOpenTill.PrintFooter;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
begin  // of TFrmRptOpenTill.AddFooterToPages
  // Add page number and date to report
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               (VspPreview.TextHeight ['X']);
        VspPreview.Text := CtTxtPrintDate + ' ' + DateToStr (Now);
        VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                               VspPreview.TextWidth [CtTxtReference] - 1;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 03;
        VspPreview.Text := CtTxtReference;
        TxtPage := Format ('P.%d/%d', [CntPage, VspPreview.PageCount]);
        VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                               VspPreview.TextWidth [TxtPage] - 1;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := TxtPage;
      finally
        VspPreview.EndOverlay;
      end;
    end;  // of for CntPage := 1 to VspPreview.PageCount
  end;  // of VspPreview.PageCount > 0
end;   // of TFrmRptOpenTill.AddFooterToPages

//=============================================================================

procedure TFrmRptOpenTill.BuildTableFmtAndHdr;
begin  // of TFrmRptOpenTill.BuildTableFmtAndHdr
  TxtTableFmt :=
    Format ('%s%d', [FrmVSPreview.FormatAlignLeft,
                     FrmVSPreview.ColumnWidthInTwips (20)]) +
    FrmVSPreview.SepCol +
    Format ('%s%d', [FrmVSPreview.FormatAlignLeft,
                     FrmVSPreview.ColumnWidthInTwips (10)]) +
    FrmVSPreview.SepCol +
    Format ('%s%d', [FrmVSPreview.FormatAlignLeft,
                     FrmVSPreview.ColumnWidthInTwips (10)]) +
    FrmVSPreview.SepCol +
    Format ('%s%d', [FrmVSPreview.FormatAlignLeft,
                     FrmVSPreview.ColumnWidthInTwips (30)]);
  TxtTableHdr := CtTxtDateTime + FrmVSPreview.SepCol +
                 CtTxtCheckout + FrmVSPreview.SepCol +
                 CtTxtOperator + FrmVSPreview.SepCol +
                 CtTxtName;
end;   // of TFrmRptOpenTill.BuildTableFmtAndHdr

//=============================================================================
// TFrmRptOpenTill.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmRptOpenTill.PrintTableLine (TxtLine : string);
begin  // of TFrmRptOpenTill.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, False);
  Inc (QtyLinesPrinted);
end;   // of TFrmRptOpenTill.PrintTableLine

//=============================================================================

procedure TFrmRptOpenTill.PrintLine (QryOpenTill : TQuery);
var
  TxtLine          : string;           // Line to print
begin  // of TFrmRptOpenTill.PrintLine
  TxtLine := QryOpenTill.FieldByName ('DatModState').AsString + FrmVSPreview.SepCol +
             QryOpenTill.FieldByName ('IdtCheckout').AsString + FrmVSPreview.SepCol +
             QryOpenTill.FieldByName ('IdtOperator').AsString + FrmVSPreview.SepCol +
             QryOpenTill.FieldByName ('TxtName').AsString;
  PrintTableLine (TxtLine);
end;   // of TFrmRptOpenTill.PrintLine

//=============================================================================

procedure TFrmRptOpenTill.GenerateTableBody;
var
  TxtSQL           : string;           // Query SQL
  DatFrom          : TDateTime;        // Selection Date from
  DatTo            : TDateTime;        // Selection Date To
begin  // of TFrmRptOpenTill.GenerateTableBody
  DatFrom := 0;
  DatTo := 0;
  try
    TxtSQL :=    'SELECT DatModState, IdtCheckout, IdtOperator, TxtName' +
              #10'  FROM PosState' +
              #10' WHERE CodState = ' + IntToStr (CtCodPtsDrawerOpened);
    if RbtDateTimeSpecif.Checked then begin
      if SvcLFDatFrom.IsValid then
        DatFrom := SvcLFDatFrom.AsDateTime + SvcLFTimFrom.AsDateTime;
      if DatFrom > 0 then
        TxtSQL := TxtSQL +
                  #10'   AND DatModState >= ' +
                    AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                                               ViTxtDBHouFormat, DatFrom), '''');
      if SvcLFDatTo.IsValid then
        DatTo := SvcLFDatTo.AsDateTime + SvcLFTimTo.AsDateTime;
      if DatTo > 0 then
        TxtSQL := TxtSQL +
                  #10'   AND DatModState <= ' +
                     AnsiQuotedstr (FormatDateTime (ViTxtDBDatFormat + ' ' +
                                                ViTxtDBHouFormat, DatTo), '''');
    end;
    TxtSQL := TxtSQL + #10'ORDER BY DatModState';
    DmdFpnUtils.QueryInfo (TxtSQL);
    while not DmdFpnUtils.QryInfo.Eof do begin
      PrintLine (DmdFpnUtils.QryInfo);
      DmdFpnUtils.QryInfo.Next;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmRptOpenTill.GenerateTableBody

//=============================================================================

procedure TFrmRptOpenTill.GenerateTable;
begin  // of TFrmRptOpenTill.GenerateTable
  BuildTableFmtAndHdr;

  VspPreview.StartTable;
  try
    GenerateTableBody;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmRptOpenTill.GenerateTable

//=============================================================================

function TFrmRptOpenTill.GetVspPreview : TVSPrinter;
begin  // of TFrmRptOpenTill.GetVspPreview
  Result := FrmVSPreview.VspPreview;
  FrmVSPreview.VspPreview.HdrFont.CharSet := DEFAULT_CHARSET;
end;   // of TFrmRptOpenTill.GetVspPreview

//=============================================================================

procedure TFrmRptOpenTill.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmRptOpenTill.BeforeCheckRunParams
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'D';
  SplitString (CtTxtRunParamDateTime,'=',TxtPartLeft,TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmRptOpenTill.BeforeCheckRunParams

//=============================================================================

procedure TFrmRptOpenTill.AfterCheckRunParams;
var
  TxtParam         : string;           // Run parameter
  CntParam         : Integer;          // Counter for loop
begin  // of TFrmRptOpenTill.AfterCheckRunParams
  for CntParam := 1 to ParamCount do begin
    TxtParam := ParamStr (CntParam);
    if (TxtParam[1] + TxtParam[2] = '/D') then
      DatSelect := DateStringToStDate (SmUtils.CtTxtDatFormat,
                                       Copy (Txtparam, 3, length (TxtParam)),
                                       SmUtils.CtValEpoch);
  end;
end;   // of TFrmRptOpenTill.AfterCheckRunParams

//=============================================================================

procedure TFrmRptOpenTill.Execute;
begin  // of TFrmRptOpenTill.Execute
  // Check is DayFrom < DayTo
  if RbtDateTimeSpecif.Checked then
    if SvcLFDatFrom.AsDateTime = 0 then
      SvcLFDatFrom.AsDateTime := Now;
    if SvcLFTimFrom.AsDateTime = 0 then
      SvcLFTimFrom.Text := '00:00:00';
    if SvcLFDatTo.AsDateTime = 0 then
      SvcLFDatTo.AsDateTime := Now;
    if SvcLFTimTo.AsDateTime = 0 then
      SvcLFTimTo.Text := '23:59:59';
    if (SvcLFDatFrom.AsDateTime + SvcLFTimFrom.AsDateTime >
             SvcLFDatTo.AsDateTime + SvcLFTimTo.AsDateTime) then begin
        SvcLFDatFrom.AsDateTime := Now;
        SvcLFDatTo.AsDateTime := Now;
        Application.MessageBox(PChar(CtTxtStartEndDate),
                               PChar(CtTxtErrorHeader), MB_OK);
        Exit;
    end;
  VspPreview.StartDoc;
  try
    PrintHeader;
    GenerateTable;
  finally
    VspPreview.EndDoc;
    PrintFooter;
  end;


  if FlgPreview then
    FrmVSPreview.Show
  else
  VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;   // of TFrmRptOpenTill.Execute

//=============================================================================

procedure TFrmRptOpenTill.AutoStart (Sender : TObject);
begin  // of TFrmRptOpenTill.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    FlgPreview := False;
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmRptOpenTill.AutoStart

//=============================================================================

procedure TFrmRptOpenTill.SvcLFDatFromChange(Sender: TObject);
begin  // of TFrmRptOpenTill.SvcLFDatFromExit
  inherited;
  SvcLFTimFrom.Enabled := (SvcLFDatFrom.AsDateTime <> 0);
end;   // of TFrmRptOpenTill.SvcLFDatFromExit

//=============================================================================

procedure TFrmRptOpenTill.SvcLFDatFromExit(Sender: TObject);
begin  // of TFrmRptOpenTill.SvcLFDatFromExit
  inherited;
  if SvcLFTimFrom.Enabled then
    if SvcLFTimFrom.AsDateTime = 0 then
      SvcLFTimFrom.AsDateTime := 0;
end;   // of TFrmRptOpenTill.SvcLFDatFromExit

//=============================================================================

procedure TFrmRptOpenTill.SvcLFDatToChange(Sender: TObject);
begin  // of TFrmRptOpenTill.SvcLFDatToChange
  inherited;
  SvcLFTimTo.Enabled := (SvcLFDatTo.AsDateTime <> 0);
end;   // of TFrmRptOpenTill.SvcLFDatToChange

//=============================================================================

procedure TFrmRptOpenTill.SvcLFDatToExit(Sender: TObject);
begin  // of TFrmRptOpenTill.SvcLFDatToExit
  inherited;
  if SvcLFTimTo.Enabled then
    if SvcLFTimTo.AsDateTime = 0 then
      SvcLFTimTo.AsDateTime := 0.99999;
end;   // of TFrmRptOpenTill.SvcLFDatToExit

//=============================================================================

procedure TFrmRptOpenTill.RbtDateTimeClick(Sender: TObject);
begin  // of TFrmRptOpenTill.RbtDateTimeClick
  inherited;
  SvcLFDatFrom.Enabled := RbtDateTimeSpecif.Checked;
  SvcLFTimFrom.Enabled := (RbtDateTimeSpecif.Checked and
                          (SvcLFDatFrom.AsDateTime <> 0));
  SvcLFDatTo.Enabled := RbtDateTimeSpecif.Checked;
  SvcLFTimTo.Enabled := (RbtDateTimeSpecif.Checked and
                        (SvcLFDatTo.AsDateTime <> 0));
end;   // of TFrmRptOpenTill.RbtDateTimeClick

//=============================================================================

procedure TFrmRptOpenTill.FormCreate(Sender: TObject);
begin // of TFrmRptOpenTill.FormCreate
  inherited;
  OvcCtlConfigRep.Epoch := CtValEpoch;
  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';

  if DatSelect > 0 then begin
    RbtDateTimeSpecif.Checked := True;
    SvcLFDatFrom.AsStDate := DatSelect;
    SvcLFDatTo.AsStDate := DatSelect;
    SvcLFTimFrom.Enabled := True;
    SvcLFTimTo.Enabled := True;
    SvcLFDatFrom.OnExit (SvcLFDatFrom);
    SvcLFDatTo.OnExit (SvcLFDatTo);
  end;
end;  // of TFrmRptOpenTill.FormCreate

//=============================================================================

procedure TFrmRptOpenTill.ActPreviewExecute(Sender: TObject);
begin  // of TFrmRptOpenTill.ActPreviewExecute
  inherited;
  FlgPreview := Sender = ActPreview;
  ActStartExec.Execute;
end;   // of TFrmRptOpenTill.ActPreviewExecute

//=============================================================================

procedure TFrmRptOpenTill.ActPrintSetupExecute(Sender: TObject);
begin  // of TFrmRptOpenTill.ActPrintSetupExecute
  inherited;
  FrmVSPreview.ActPrinterSetupExecute (nil);
end;   // of TFrmRptOpenTill.ActPrintSetupExecute

//=============================================================================

initialization
  // Add module to list for version control
  DatSelect := 0;
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FRptOpenTill
