//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Form specific for printing Castorama Rapports
// Customer : Castorama
// Unit     : FDetGeneralCA.PAS : General Detailform to print CAstorama rapports
//-----------------------------------------------------------------------------
// CVS      : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetGeneralCA.pas,v 1.4 2009/09/21 12:54:51 BEL\KDeconyn Exp $
// History  :
// - Started from Castorama - FlexPoint 2.0 - FDetGeneralCA.pas - CVS revision 1.2
// Version  ModifiedBy    Reason
// 1.3      TK   (TCS)    R2014.2.Req.26050.AllOPCO.Caskdesk number in control operadores
// 1.4      SN   (TCS)    R2014.2.Req.31040.CARU/CAFR.Report_Blocked_for_Sale 
//=============================================================================

unit FDetGeneralCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, SfVSPrinter7,
  SmVSPrinter7Lib_TLB, Db, DBTables;

//*****************************************************************************
// Global definitions
//*****************************************************************************

const              // general to the form
  TxtSep           = '|';              // Seperator character
  CRLF             = #13#10;           // Indicate a new line
  CtTxtFrmNumber   = '#,##0.00';       // How to format a number.
  CtTxtLogoName    = 'flexpoint.report.bmp';   // Logo to print on the rapport

resourcestring     // for header of the document.
  CtTxtOperator    = 'Operator';
  CtTxtDate        = 'Rapport on %s at %s';
  CtTxtTckDate     = 'Date Ticket';
  CtTxtLoadDate    = 'Date Loaded';
  CtTxtTcktMissing = '';               //'It''s possible that some tickets are missing';
  CtTxtTcktAvail   = 'All tickets are available';

resourcestring
  CtTxtHeader      = 'Castorama';					// R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)
  CtTxtTitle       = 'Title';
  CtTxtReference   = 'Rep';
  CtTxtTotal       = 'Total';

resourcestring
  CtTxtNoSelection = 'There are no items selected!';

resourcestring
  CtTxtOnlyOneType = 'It''s not allowed to define two of the same type '+
                     'runparameters.';

resourcestring     // for footer of the document.                     
  CtTxtPage        = 'Page';           // Show's the word Page on the buttom of
                                       // each page.

resourcestring
  CtTxtRunparamCarteCadeau = '/VCC=Allow Carte Cadeau functionality';
  CtTxtRunparamBlockedArticle = '/VBA=Allow Blocked Article functionality';    // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetGeneralCA = class(TFrmAutoRun)
    SvcDBLblDateFrom: TSvcDBLabelLoaded;
    BtnPreview: TSpeedButton;
    BtnPrintSetup: TSpeedButton;
    BtnPrint: TSpeedButton;
    DtmPckDayFrom: TDateTimePicker;
    Panel1: TPanel;
    ChkLbxOperator: TCheckListBox;
    BtnSelectAll: TBitBtn;
    BtnDeSelectAll: TBitBtn;
    SvcDBLblDateLoadedFrom: TSvcDBLabelLoaded;
    DtmPckLoadedFrom: TDateTimePicker;
    RbtDateDay: TRadioButton;
    RbtDateLoaded: TRadioButton;
    SvcDBLblDateTo: TSvcDBLabelLoaded;
    DtmPckDayTo: TDateTimePicker;
    SvcDBLblDateLoadedTo: TSvcDBLabelLoaded;
    DtmPckLoadedTo: TDateTimePicker;
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPrintSetupClick(Sender: TObject);
    procedure BtnSelectAllClick(Sender: TObject);
    procedure BtnDeSelectAllClick(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure RbtDateDayClick(Sender: TObject);
  private
    { Private declarations }
    FFrmVSPreview  : TFrmVSPreview;    // VS Preview form
    FFlgPreview    : Boolean;          // Print or Preview the rapport.
    FFlgCC         : Boolean;          // Flg to indicate use of Carte Cadeau
    FFlgBA         : Boolean;          // Flg to indicate use of Blocked Article				// R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)

    // Logo to be printed
    FFNLogo        : string;           // Filename logo
    FPicLogo       : TImage;           // Logo
  protected
    procedure DefineStandardRunParams; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;
    procedure AutoStart (Sender : TObject); override;

    procedure SetPicLogo (Value : string); virtual;
    function GetPicLogo : TImage; virtual;

    // Formats of the rapport
    function GetFmtTableHeader : string; virtual;
    function GetFmtTableBody : string; virtual;
    function GetTxtTableTitle : string; virtual;
    function GetTxtTableFooter : string; virtual;

    function GetFrmVSPreview : TFrmVSPreview; virtual;
    function GetVspPreview : TVSPrinter; virtual;
    function GetItemsSelected : Boolean; virtual;
    function GetTxtLstOperID : string; virtual;
    function GetTxtTitRapport : string; virtual;
    function GetTxtHeadRapport : string; virtual;				// R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)
    function GetTxtRefRapport : string; virtual;

    function CalcWidthText (ValLength  : Byte;
                            FlgNumeric : Boolean) : Integer; virtual;
    function GetTxtLstOperIDforSP : string; virtual;                            //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP
  public
    { Public declarations }
    property ItemsSelected : Boolean read GetItemsSelected;
    property FrmVSPreview : TFrmVSPreview read GetFrmVSPreview;
    property VspPreview : TVSPrinter read GetVspPreview;
    property TxtLstOperID : string read GetTxtLstOperID;
    property FlgPreview : Boolean read FFlgPreview
                                  write FFlgPreview;
    property TxtTitRapport : string read GetTxtTitRapport;
    property TxtHeadRapport :string read GetTxtHeadRapport ;        // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)
    property TxtRefRapport : string read GetTxtRefRapport;

    // Property for the logo
    property FNLogo : string read  FFNLogo
                             write SetPicLogo;
    property Logo : TImage read GetPicLogo;

    // Property to build the table rapport
    property FmtTableHeader : string read GetFmtTableHeader;
    property FmtTableBody : string read GetFmtTableBody;
    property TxtTableTitle : string read GetTxtTableTitle;
    property TxtTableFooter : string read GetTxtTableFooter;

    procedure NewPage (Sender : TObject); virtual;
    procedure SetGeneralSettings; virtual;
    procedure PrintHeader; virtual;
    procedure PrintTableHeader; virtual;
    procedure PrintTableBody; virtual;
    procedure PrintTableFooter; virtual;
    procedure PrintPageNumbers; virtual;
    procedure PrintReferences; virtual;

    procedure CreateAdditionalModules; override;
    procedure Execute; override;

    property FlgCC: Boolean read FFlgCC
                            write FFlgCC;
    property TxtLstOperIDforSP : string read GetTxtLstOperIDforSP;              //R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP

  end;

var
  FrmDetGeneralCA: TFrmDetGeneralCA;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetGeneralCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 12:54:51 $';

//*****************************************************************************
// Implementation of TFrmDetGeneralCA
//*****************************************************************************

function TFrmDetGeneralCA.GetItemsSelected : Boolean;
var
  CntIx            : Integer;          // Looping the CheckListBox.
begin  // of TFrmDetGeneralCA.GetItemsSelected
  Result := False;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      Result := True;
      Break;
    end;
  end;
end;   // of TFrmDetGeneralCA.GetItemsSelected

//=============================================================================

function TFrmDetGeneralCA.GetTxtLstOperID : string;
var
  CntOper          : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmDetGeneralCA.GetTxtLstOperID
  Result := '';
  for CntOper := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntOper] then
      Result :=
          Result +
          AnsiQuotedStr
            (IntToStr(Integer(ChkLbxOperator.Items.Objects[CntOper])), '''') +
          ',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmDetGeneralCA.GetTxtLstOperID

//=============================================================================

function TFrmDetGeneralCA.GetTxtTitRapport : string;
begin  // of TFrmDetGeneralCA.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetGeneralCA.GetTxtTitRapport

//=============================================================================

function TFrmDetGeneralCA.GetTxtRefRapport : string;
begin  // of TFrmDetGeneralCA.GetTxtRefRapport
  Result := CtTxtReference;
end;   // of TFrmDetGeneralCA.GetTxtRefRapport

//=============================================================================
// R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS).Start
function TFrmDetGeneralCA.GetTxtHeadRapport : string;
begin  // of TFrmDetGeneralCA.GetTxtHeadRapport
  Result := CtTxtHeader;
end;   // of TFrmDetGeneralCA.GetTxtHeadRapport
// R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS).End
//=============================================================================

procedure TFrmDetGeneralCA.SetPicLogo (Value : string);
begin  // of TFrmDetGeneralCA.SetPicLogo
  try
    FFNLogo := ReplaceEnvVar (Value);
    if FileExists (FFNLogo) then
      Logo.Picture.LoadFromFile (FFNLogo);
  except
  end;
end;   // of TFrmDetGeneralCA.SetPicLogo

//=============================================================================

function TFrmDetGeneralCA.GetPicLogo : TImage;
begin  // of TFrmDetGeneralCA.GetPicLogo
  if not Assigned (FPicLogo) then
    FPicLogo := TImage.Create (Self);
  Result := FPicLogo;
end;   // of TFrmDetGeneralCA.GetPicLogo

//=============================================================================

function TFrmDetGeneralCA.GetFmtTableHeader: string;
begin  // of TFrmDetGeneralCA.GetFmtTableHeader
end;   // of TFrmDetGeneralCA.GetFmtTableHeader

//=============================================================================

function TFrmDetGeneralCA.GetFmtTableBody: string;
begin  // of TFrmDetGeneralCA.GetFmtTableBody
end;   // of TFrmDetGeneralCA.GetFmtTableBody

//=============================================================================

function TFrmDetGeneralCA.GetTxtTableTitle : string;
begin  // of TFrmDetGeneralCA.GetTxtTableTitle
end;   // of TFrmDetGeneralCA.GetTxtTableTitle

//=============================================================================

function TFrmDetGeneralCA.GetTxtTableFooter : string;
begin  // of TFrmDetGeneralCA.GetTxtTableFooter
end;   // of TFrmDetGeneralCA.GetTxtTableFooter

//=============================================================================

procedure TFrmDetGeneralCA.DefineStandardRunParams;
begin  // of TFrmDetGeneralCA.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'V';
end;   // of TFrmDetGeneralCA.DefineStandardRunParams

//=============================================================================

procedure TFrmDetGeneralCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetGeneralCA.BeforeCheckRunParams
  inherited;
  SplitString(CtTxtRunparamCarteCadeau, '=', TxtPartLeft , TxtPartRight);
  SplitString(CtTxtRunparamBlockedArticle, '=', TxtPartLeft , TxtPartRight);			  // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmDetGeneralCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetGeneralCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmDetGeneralCA.CheckAppDependParams
 if Copy(TxtParam,3,4)= 'CC' then
    FlgCC := True
 else
  inherited;
end;   // of TFrmDetGeneralCA.CheckAppDependParams

//=============================================================================

procedure TFrmDetGeneralCA.AfterCheckRunParams;
begin  // of TFrmDetGeneralCA.AfterCheckRunParams
  inherited;
end;   // of TFrmDetGeneralCA.AfterCheckRunParams

//=============================================================================

procedure TFrmDetGeneralCA.AutoStart (Sender : TObject);
begin  // of TFrmDetGeneralCA.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  try
    if DmdFpnUtils.QueryInfo
        ('SELECT IdtOperator, TxtName FROM Operator') then begin

      DmdFpnUtils.QryInfo.First;
      ChkLbxOperator.Items.Clear;
      while not DmdFpnUtils.QryInfo.Eof do begin
        ChkLbxOperator.Items.AddObject
           (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ' : ' +
            DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString,
            TObject (DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger));
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;

  if ViFlgAutom then
    BtnSelectAllClick (Sender);
  DtmPckDayFrom.DateTime := Now;

  DtmPckLoadedFrom.DateTime := Now;
  DtmPckDayTo.DateTime := Now;
  DtmPckLoadedTo.DateTime := Now;

  SetGeneralSettings;
  VspPreview.OnNewPage := NewPage;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmDetGeneralCA.AutoStart

//=============================================================================

function TFrmDetGeneralCA.GetFrmVSPreview : TFrmVSPreview;
begin  // of TFrmDetGeneralCA.GetFrmVSPreview
  if not Assigned (FFrmVSPreview) then begin
    FFrmVSPreview := TFrmVSPreview.Create (Application);
    FFrmVSPreview.VspPreview.HdrFont.CharSet := DEFAULT_CHARSET;
  end;
  Result := FFrmVSPreview;
end;   // of TFrmDetGeneralCA.GetFrmVSPreview

//=============================================================================

function TFrmDetGeneralCA.GetVspPreview : TVSPrinter;
begin  // of TFrmDetGeneralCA.GetVspPreview
  Result := FrmVSPreview.VspPreview;
end;   // of TFrmDetGeneralCA.GetVspPreview

//=============================================================================

function TFrmDetGeneralCA.CalcWidthText (ValLength  : Byte;
                                         FlgNumeric : Boolean) : Integer;
begin  // of TFrmDetGeneralCA.CalcWidthText
  if FlgNumeric then
    Result := Trunc (VspPreview.TextWidth [CharStrW ('9', ValLength)])
  else
    Result := Trunc (VspPreview.TextWidth [CharStrW ('X', ValLength)]);
end;   // of TFrmDetGeneralCA.CalcWidthText

//=============================================================================

procedure TFrmDetGeneralCA.NewPage (Sender : TObject);
begin  // of TFrmDetGeneralCA.NewPage
  PrintHeader;

  PrintTableHeader;
end;   // of TFrmDetGeneralCA.NewPage

//=============================================================================

procedure TFrmDetGeneralCA.SetGeneralSettings;
begin  // of TFrmDetGeneralCA.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  VspPreview.MarginTop := 2500;

  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtTxtLogoName;
end;   // of TFrmDetGeneralCA.SetGeneralSettings

//=============================================================================

procedure TFrmDetGeneralCA.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtStoreHdr      : string;		   // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS)
begin  // of TFrmDetGeneralCA.PrintHeader
  TxtHdr := TxtHeadRapport + CRLF;
  TxtHdr :=TxtHdr +TxtTitRapport + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  if RbtDateDay.Checked then
  // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS).Start
    begin
    TxtStoreHdr := TxtHdr;
  // R2014.2.Req.31040.Report_Blocked_for_Sale.SN(TCS).End
    TxtHdr := TxtHdr +
      Format (CtTxtDate, [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
                          FormatDateTime (CtTxtHouFormat, DtmPckDayFrom.Date)]) +
      ' (' + CtTxtTckDate + ')' + CRLF;
  end    
  else if RbtDateLoaded.Checked then begin
    TxtStoreHdr := TxtHdr;
    TxtHdr := TxtHdr +
      Format (CtTxtDate, [FormatDateTime (CtTxtDatFormat, DtmPckLoadedTo.Date),
                          FormatDateTime (CtTxtHouFormat, DtmPckLoadedTo.Date)]) +
      ' (' + CtTxtLoadDate + ')' + CRLF;
  end;
  VspPreview.Header := TxtHdr;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetGeneralCA.PrintHeader

//=============================================================================

procedure TFrmDetGeneralCA.PrintTableHeader;
begin  // of TFrmDetGeneralCA.PrintTableHeader
  VspPreview.TableBorder := tbBoxColumns;
//  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableHeader, '', TxtTableTitle,
                       clWhite, clLTGray, False);
//  VspPreview.EndTable;
end;   // of TFrmDetGeneralCA.PrintTableHeader

//=============================================================================

procedure TFrmDetGeneralCA.PrintTableBody;
begin  // of TFrmDetGeneralCA.PrintTableBody
end;   // of TFrmDetGeneralCA.PrintTableBody

//=============================================================================

procedure TFrmDetGeneralCA.PrintTableFooter;
begin  // of TFrmDetGeneralCA.PrintTableFooter
  VspPreview.Text := CRLF;

  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableBody, '', TxtTableFooter, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetGeneralCA.PrintTableFooter

//=============================================================================

procedure TFrmDetGeneralCA.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmDetGeneralCA.PrintPageNumbers
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 350;
      Text := CtTxtPage + ' ' + IntToStr (CntPageNb) + '/' +
                                IntToStr (VspPreview.PageCount);
      EndOverlay;
    end;
  end;
end;   // of TFrmDetGeneralCA.PrintPageNumbers

//=============================================================================

procedure TFrmDetGeneralCA.PrintReferences;
var
  CntPageNb        : Integer;          // Temp Pagenumber
  TxtHdr           : string;
begin  // of TFrmDetGeneralCA.PrintReferences
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 50;
      Text := GetTxtRefRapport;
      CurrentX := VspPreview.MarginLeft;
      FontSize := VspPreview.FontSize + 5;
      if ViFlgAutom then
        TxtHdr := CtTxtTcktAvail
      else
        TxtHdr := CtTxtTcktMissing;
      Text := TxtHdr;

      FontSize := VspPreview.FontSize - 5;
      EndOverlay;
    end;
  end;
end;   // of TFrmDetGeneralCA.PrintReferences

//=============================================================================

procedure TFrmDetGeneralCA.CreateAdditionalModules;
begin  // of TFrmDetGeneralCA.CreateAdditionalModules
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Application);

  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Application);

  inherited;
end;   // of TFrmDetGeneralCA.CreateAdditionalModules

//=============================================================================

procedure TFrmDetGeneralCA.Execute;
begin  // of TFrmDetGeneralCA.Execute
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  PrintTableBody;
  PrintTableFooter;
  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;   // of TFrmDetGeneralCA.Execute

//=============================================================================

procedure TFrmDetGeneralCA.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetGeneralCA.BtnPrintClick
  inherited;
  FlgPreview := (Sender = BtnPreview);
  ActStartExec.Execute;
end;   // of TFrmDetGeneralCA.BtnPrintClick

//=============================================================================

procedure TFrmDetGeneralCA.BtnPrintSetupClick(Sender: TObject);
begin  // of TFrmDetGeneralCA.BtnPrintSetupClick
  inherited;
  FrmVSPreview.ActPrinterSetupExecute (nil);
end;   // of TFrmDetGeneralCA.BtnPrintSetupClick

//=============================================================================

procedure TFrmDetGeneralCA.BtnSelectAllClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetGeneralCA.BtnSelectAllClick
  inherited;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := True;
end;   // of TFrmDetGeneralCA.BtnSelectAllClick

//=============================================================================

procedure TFrmDetGeneralCA.BtnDeSelectAllClick(Sender: TObject);
var
  CntIx            : Integer;          // Looping all items in de listcheckbox
begin  // of TFrmDetGeneralCA.BtnDeSelectAllClick
  inherited;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do
    ChkLbxOperator.Checked [CntIx] := False;
end;   // of TFrmDetGeneralCA.BtnDeSelectAllClick

//=============================================================================

procedure TFrmDetGeneralCA.ActStartExecExecute(Sender: TObject);
begin  // of TFrmDetGeneralCA.ActStartExecExecute
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;

  inherited;
end;   // of TFrmDetGeneralCA.ActStartExecExecute

//=============================================================================

procedure TFrmDetGeneralCA.RbtDateDayClick(Sender: TObject);
begin  // of TFrmDetGeneralCA.RbtDateDayClick
  inherited;
  DtmPckDayFrom.Enabled := RbtDateDay.Checked;
  DtmPckLoadedFrom.Enabled := RbtDateLoaded.Checked;
  DtmPckDayTo.Enabled := RbtDateDay.Checked;
  DtmPckLoadedTo.Enabled := RbtDateLoaded.Checked;
end;   // of TFrmDetGeneralCA.RbtDateDayClick

//=============================================================================

//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP.Start

function TFrmDetGeneralCA.GetTxtLstOperIDforSP : string;
var
  CntOper          : Integer;          // Loop the operators in the Checklistbox
begin  // of TFrmDetGeneralCA.GetTxtLstOperIDforSP
  Result := '';
  for CntOper := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntOper] then
      Result := Result + IntToStr(Integer(ChkLbxOperator.Items.Objects[CntOper])) + ',';
  end;
  Result := Copy (Result, 0, Length (Result) - 1);
end;   // of TFrmDetGeneralCA.GetTxtLstOperIDforSP

//=============================================================================
//R2014.2.Req26050.AllOPCO.Caskdesk number in control operadores.TCS-CP.End

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetGeneralCA

