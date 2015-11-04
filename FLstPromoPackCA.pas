//===== Copyright 2011 (c) Kingfisher IT Services. All rights reserved. =======
// Packet   : FlexPoint Development
// Unit     : FLstPromoPackCA.PAS : Form List PromoPack
//-----------------------------------------------------------------------------
// PVCS   :  $Header: $
// History:
// Version      Modified By     Reason
// 1.0          TT.    (TCS)    Initial Write - R2011.2 - CAFR - Gestion des promopack
// 1.1          Teesta (TCS)    Internal defect_347 fix, BDES
// 1.2          SRM    (TCS)    R2014.1.Req(31110).Promopack_Improvement
//=============================================================================

unit FLstPromoPackCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FLstPromoPack, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids,SfVSPrinter7,SmVSPrinter7Lib_TLB,  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM
  SmUtils,DBTables, ExtDlgs;                                                    // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM

//=============================================================================
// TFrmLstPromoPackCA
//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
const
  CtMaxNumDays         =  30;
  TxtSep               = '|';                     // Seperator character
  TxtSepSem            = ';';                     // Seperator character
  CRLF                 = #13#10;                  // Indicate a new line
  CtLogoName           = 'flexpoint.report.bmp';  // Logo to print on the rapport
  CtDefaultPlace       = 'D:\sycron\transfertbo\excel';
  TxtDatFormat         = 'dd/mm/yyyy';
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
resourcestring                                                                  // Internal defect_347 fix, Teesta, BDES
  CtTxtAppTitle = 'Maintenance Promopack';                                      // Internal defect_347 fix, Teesta, BDES
  // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  CtTxtReference        = 'Rep';
  CtTxtPage             = 'Page';    // Show's the word Page on the buttom of
  CtTxtExists           = 'File exists, Overwrite?';
  CtTxtPrintDate        = 'Printed on %s';
  CtTxtAllPromo         = 'All Promo Packs';
  CtTxtCurrentPromo     = 'Current Promo Packs';
  CtTxtNoData           = 'No data exists in this date range';
  // Report table titles
  CtTxtPromNo           = 'Promopack Number';
  CtTxtKind             = 'Kind';
  CtTxtExpl             = 'Explanation';
  CtTxtLevel            = 'Level';
  CtTxtCustom           = 'Custom';
  CtTxtIniDate          = 'Initial date';
  CtTxtEndDate          = 'End Date';
  CtTxtDescr            = 'Description';
  CtTxtStatus           = 'Status';
 // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
type
  TFrmLstPromoPackCA = class(TFrmLstPromoPack)
    BtnPrint: TSpeedButton;                                                     // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    BtnExprt: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    procedure BtnExprtClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);                                   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
    procedure FormCreate(Sender: TObject);                                      // Internal defect_383 fix, teesta, BDES - Start
    procedure DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
       DataCol: Integer; Column: TColumn; State: TGridDrawState);
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
    procedure SetAllowedJobs (Value : TSetListJobs); override;
    procedure SetActiveJobs (Value : TSetListJobs); override;
  private
    { Private declarations }
    FFrmVSPreview  : TFrmVSPreview; // VS Preview form                    
    FFlgPreview    : Boolean;       // Print or Preview the rapport.

    // Logo to be printed
    FFNLogo        : string;        // Filename logo
    FPicLogo       : TImage;        // Logo
  protected
    procedure SetPicLogo (Value : string); virtual;
    function GetPicLogo : TImage; virtual;
    
     // Formats of the rapport
    function GetFmtTableHeader : string; virtual;
    function GetFmtTableBody : string; virtual;
    function GetTxtTableTitle : string; virtual;
    function GetTxtTitRapport : string; virtual;
    function GetTxtRefRapport : string; virtual;
    function GetFrmVSPreview : TFrmVSPreview;
    function GetVspPreview : TVSPrinter;
    
    function CalcWidthText (ValLength  : Byte;
                            FlgNumeric : Boolean) : Integer; virtual;
  public
    { Public declarations }
    property FrmVSPreview : TFrmVSPreview read GetFrmVSPreview;
    property VspPreview : TVSPrinter read GetVspPreview;
    property FlgPreview : Boolean read FFlgPreview
                                  write FFlgPreview;
    property TxtTitRapport : string read GetTxtTitRapport;
    property TxtRefRapport : string read GetTxtRefRapport;
    // Property for the logo
    property FNLogo : string read  FFNLogo
                             write SetPicLogo;
    property Logo : TImage read GetPicLogo;
    // Property to build the table rapport
    property FmtTableHeader : string read GetFmtTableHeader;
    property FmtTableBody : string read GetFmtTableBody;
    property TxtTableTitle : string read GetTxtTableTitle;
    
    procedure NewPage (Sender : TObject); virtual;
    procedure SetGeneralSettings; virtual;
    procedure PrintHeader; virtual;
    procedure PrintTableHeader; virtual;
    procedure PrintTableBody; virtual;
    procedure PrintPageNumbers; virtual;
    procedure PrintReferences; virtual;
  end;
   // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
var
  FrmLstPromoPackCA : TFrmLstPromoPackCA;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  SfDialog,                                                                     // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
  FMntPromoPackCA,
  StStrW,
  
  DFpnUtils,
  DFpnPromoPackCA,
  DFpnTradeMatrix,
  DFpnCoupon,
  DFpnPromoPack;                                                                // R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'TFLstPromoPackCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2014/03/24 08:13:53 $';

//=============================================================================
// Constants
//=============================================================================

const
  // Possible values of CodState
  CtCodStatInactive = 0;
  CtCodStatActive = 1;

//=============================================================================

procedure TFrmLstPromoPackCA.DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid : TDBGrid;
  CodState : String;
begin
  inherited;
  Grid := sender as TDBGrid;
  CodState := Grid.DataSource.DataSet.FieldByName('CodStateId').AsString;
  if CodState = IntToStr(CtCodStatInactive) then
    Grid.Canvas.Brush.Color := clDkGray;
  // Highlight
  if (gdSelected in State) then
  begin
    if CodState = IntToStr(CtCodStatInactive) then
      Grid.Canvas.Brush.Color := clSilver
    else
      Grid.Canvas.Brush.Color := clHighlight
  end;
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State) ;
end;

//=============================================================================

// Internal defect_347 fix, Teesta, BDES - Start
procedure TFrmLstPromoPackCA.FormCreate(Sender: TObject);
begin
  inherited;
  Application.Title := CtTxtAppTitle;
end;
// Internal defect_347 fix, Teesta, BDES - End

//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.Start
//=============================================================================
procedure TFrmLstPromoPackCA.BtnPrintClick(Sender: TObject);
begin  // of TFrmLstPromoPackCA.BtnPrintClick
  inherited;
  if (not DscList.DataSet.Active) or (not FlgEverRefreshed) then
    raise EAbort.Create ('No data');
  if Application.Terminated then
    Exit;
  VspPreview.Orientation := orLandscape;
  SetGeneralSettings;
  VspPreview.OnNewPage := NewPage;
  VspPreview.StartDoc;
  PrintTableBody;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;  // of TFrmLstPromoPackCA.BtnPrintClick

//=============================================================================

function TFrmLstPromoPackCA.GetFrmVSPreview : TFrmVSPreview;
begin  // of TFrmLstPromoPackCA.GetFrmVSPreview
  if not Assigned (FFrmVSPreview) then begin
    FFrmVSPreview := TFrmVSPreview.Create (Application);
    FFrmVSPreview.VspPreview.HdrFont.CharSet := DEFAULT_CHARSET;
  end;
  Result := FFrmVSPreview;
end;   // of TFrmLstPromoPackCA.GetFrmVSPreview

//=============================================================================

function TFrmLstPromoPackCA.GetVspPreview : TVSPrinter;
begin  // of TFrmLstPromoPackCA.GetVspPreview
  Result := FrmVSPreview.VspPreview;
end;   // of TFrmLstPromoPackCA.GetVspPreview

//=============================================================================

function TFrmLstPromoPackCA.CalcWidthText (ValLength  : Byte;
                                         FlgNumeric : Boolean) : Integer;
begin  // of TFrmLstPromoPackCA.CalcWidthText
  if FlgNumeric then
    Result := Trunc (VspPreview.TextWidth [CharStrW ('9', ValLength)])
  else
    Result := Trunc (VspPreview.TextWidth [CharStrW ('X', ValLength)]);
end;   // of TFrmLstPromoPackCA.CalcWidthText

//=============================================================================
// GetFmtTableHeader: Construct the structure of the Table Header of the report
//=============================================================================

function TFrmLstPromoPackCA.GetFmtTableHeader: string;
begin  // of TFrmLstPromoPackCA.GetFmtTableHeader
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (30, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (25, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))
end;   // of TFrmLstPromoPackCA.GetFmtTableHeader

//=============================================================================
//  GetFmtTableBody : Construct the structure of the Table Body of the report
//=============================================================================

function TFrmLstPromoPackCA.GetFmtTableBody : string;
begin  // of TFrmLstPromoPackCA.GetFmtTableBody
    Result := '<' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (30, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (25, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (20, False))  + TxtSep +
              '<' + IntToStr (CalcWidthText (10, False))
end;   // of TFrmLstPromoPackCA.GetFmtTableBody

//=============================================================================
//  GetTxtTableTitle : Generate the main table titles
//=============================================================================

function TFrmLstPromoPackCA.GetTxtTableTitle : string;
begin  // of TFrmLstPromoPackCA.GetTxtTableTitle
  Result := CtTxtPromNo   + TxtSep +
            CtTxtKind     + TxtSep +
            CtTxtExpl     + TxtSep +
            CtTxtLevel    + TxtSep +
            CtTxtCustom   + TxtSep +
            CtTxtIniDate  + TxtSep +
            CtTxtEndDate  + TxtSep +
            CtTxtDescr    + TxtSep +
            CtTxtStatus
end;   // of TFrmLstPromoPackCA.GetTxtTableTitle

//=============================================================================
//  GetTxtTitRapport : Generate the main title of the report
//=============================================================================

function TFrmLstPromoPackCA.GetTxtTitRapport : string;
begin  // of TFrmLstPromoPackCA.GetTxtTitRapport
  if MniFinishedPP.Checked then
    Result := CtTxtAllPromo + CRLF
  else
    Result := CtTxtCurrentPromo + CRLF;
end;   // of TFrmLstPromoPackCA.GetTxtTitRapport

//=============================================================================

function TFrmLstPromoPackCA.GetTxtRefRapport : string;
begin  // of TFrmLstPromoPackCA.GetTxtRefRapport
  Result := CtTxtReference + '0006';
end;   // of TFrmLstPromoPackCA.GetTxtRefRapport

//=============================================================================
//  SetGeneralSettings : Set general settings
//=============================================================================

procedure TFrmLstPromoPackCA.SetGeneralSettings;
begin  // of TFrmLstPromoPackCA.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  VspPreview.MarginTop := 2500;
  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtLogoName;
end;   // of TFrmLstPromoPackCA.SetGeneralSettings

//=============================================================================
//  PrintHeader : construct the header of the report
//=============================================================================

procedure TFrmLstPromoPackCA.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;
begin  // of TFrmLstPromoPackCA.PrintHeader
  TxtHdr := TxtTitRapport + CRLF;
  TxtDatFormat := CtTxtDatFormat;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
              [FormatDateTime (TxtDatFormat, Now)]) + CRLF;
  TxtHdr := TxtHdr +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmLstPromoPackCA.PrintHeader

//=============================================================================

function TFrmLstPromoPackCA.GetPicLogo : TImage;
begin  // of TFrmLstPromoPackCA.GetPicLogo
  if not Assigned (FPicLogo) then
    FPicLogo := TImage.Create (Self);
  Result := FPicLogo;
end;   // of TFrmLstPromoPackCA.GetPicLogo

//=============================================================================

procedure TFrmLstPromoPackCA.SetPicLogo (Value : string);
begin  // of TFrmLstPromoPackCA.SetPicLogo
  try
    FFNLogo := ReplaceEnvVar (Value);
    if FileExists (FFNLogo) then
      Logo.Picture.LoadFromFile (FFNLogo);
  except
  end;
end;   // of TFrmLstPromoPackCA.SetPicLogo

//=============================================================================

procedure TFrmLstPromoPackCA.NewPage (Sender : TObject);
begin  // of TFrmLstPromoPackCA.NewPage
  PrintHeader;

  PrintTableHeader;
end;   // of TFrmLstPromoPackCA.NewPage

//=============================================================================
//  PrintTableHeader : Costruct the header part of the report body with
//                     table titles
//=============================================================================

procedure TFrmLstPromoPackCA.PrintTableHeader;
begin  // of TFrmLstPromoPackCA.PrintTableHeader
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.AddTable (FmtTableHeader, '', TxtTableTitle,
                       clWhite, clLTGray, False);
end;   // of TFrmLstPromoPackCA.PrintTableHeader

//=============================================================================
//  PrintTableBody : Construct the main report body 
//=============================================================================

procedure TFrmLstPromoPackCA.PrintTableBody;
var
  TxtPrintLine        : string;         // String to print
begin  // of TFrmLstPromoPackCA.PrintTableBody
 inherited;
  VspPreview.TableBorder := tbBoxColumns;
  TxtPrintLine := '';
  if DmdFpnPromoPackCA.SprLstPromoPack.RecordCount = 0 then begin
    TxtPrintLine := CtTxtNoData;
    VspPreview.StartTable;
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine,
                         clWhite, clWhite, False);
    VspPreview.EndTable;
  end
  else begin
    DmdFpnPromoPackCA.SprLstPromoPack.First;
    while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do begin
      VspPreview.StartTable;
      
      TxtPrintLine := TxtPrintLine +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('IdtPromopack').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodTypeAsTxtShort').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('TxtExplanation').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodAffectAsTxtShort').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodCustomerAsTxtShort').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('DatBeginAsDate').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('DatEndAsDate').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('TxtPublDescr').AsString
      + TxtSep +
      DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodState').AsString;
            
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clWhite, False);
      VspPreview.EndTable;
      TxtPrintLine := '';
     DmdFpnPromoPackCA.SprLstPromoPack.Next;
    end;
  end;
end;   // of TFrmLstPromoPackCA.PrintTableBody

//=============================================================================

procedure TFrmLstPromoPackCA.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmLstPromoPackCA.PrintPageNumbers
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
end;   // of TFrmLstPromoPackCA.PrintPageNumbers

//=============================================================================

procedure TFrmLstPromoPackCA.PrintReferences;
var
  CntPageNb        : Integer;          // Temp Pagenumber
  TxtHdr           : string;
begin  // of TFrmLstPromoPackCA.PrintReferences
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, TRUE);
      CurrentX := VspPreview.PageWidth - VspPreview.MarginRight - 1000;
      CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom + 50;
      Text := GetTxtRefRapport;
      CurrentX := VspPreview.MarginLeft;
      FontSize := VspPreview.FontSize + 5;
      Text := TxtHdr;
      FontSize := VspPreview.FontSize - 5;
      EndOverlay;
    end;
  end;
end;   // of TFrmLstPromoPackCA.PrintReferences

//=============================================================================
//  BtnExprtClick : Construct the main report body to export it in a csv format
//=============================================================================

procedure TFrmLstPromoPackCA.BtnExprtClick(Sender: TObject);
var
  TxtTitles           : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;

begin // of TFrmLstPromoPackCA.BtnExportClick
  if (not DscList.DataSet.Active) or (not FlgEverRefreshed) then
    raise EAbort.Create ('No data');
  QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtDefaultPlace;
  finally
    QryHlp.Free;
  end;
   ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtWriteLine := '';
    if MniFinishedPP.Checked then
      TxtWriteLine := CtTxtAllPromo + CRLF
    else
      TxtWriteLine := CtTxtCurrentPromo + CRLF;

    TxtWriteLine := TxtWriteLine + Format (CtTxtPrintDate,
                   [FormatDateTime (TxtDatFormat, Now)]) + CRLF;
    TxtWriteLine := TxtWriteLine +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

    TxtTitles := GetTxtTableTitle();
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then
        TxtWriteLine := TxtWriteLine + ';'
      else
        TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists, mtError, mbOKCancel, 0);
      if not FlgOK then
        Btnselect := mrOK;
    until Btnselect = mrOk;
   if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      DmdFpnPromoPackCA.SprLstPromoPack.Active := True;
      DmdFpnPromoPackCA.SprLstPromoPack.First;
     if DmdFpnPromoPackCA.SprLstPromoPack.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
        while not DmdFpnPromoPackCA.SprLstPromoPack.Eof do begin
          TxtWriteLine := '';
          TxtWriteLine := TxtWriteLine +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('IdtPromopack').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodTypeAsTxtShort').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('TxtExplanation').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodAffectAsTxtShort').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodCustomerAsTxtShort').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('DatBeginAsDate').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('DatEndAsDate').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('TxtPublDescr').AsString
           + TxtSepSem +
           DmdFpnPromoPackCA.SprLstPromoPack.FieldByName('CodState').AsString;
           WriteLn(F, TxtWriteLine);
           DmdFpnPromoPackCA.SprLstPromoPack.Next;
        end;
      System.Close(F);
    end;
    DecimalSeparator := ChrDecimalSep;
end; // of TFrmLstPromoPackCA.BtnExportClick

//=============================================================================
// TFrmLstPromoPackCA.SetAllowedJobs : sets the property AllowedJobs & enables
// or disables the buttons & menu-items according to the AllowedJobs.
//=============================================================================

procedure TFrmLstPromoPackCA.SetAllowedJobs (Value : TSetListJobs);
begin  // of TFrmLstPromoPackCA.SetAllowedJobs
 inherited;
  if not FrmMntPromoPackCA.FlgPromImprov then begin
    BtnPrint.Visible := False;
    BtnExprt.Visible := False;
  end
  else begin
    ConfigOneJob (MniRecNew, BtnPrint, CtCodJobRecPrint in FAllowedJobs);
    ConfigOneJob (MniRecNew, BtnExprt, CtCodJobRecExport in FAllowedJobs);
  end
end;   // of TFrmLstPromoPackCA.SetAllowedJobs

//=============================================================================
// TFrmLstPromoPackCA.SetActiveJobs: sets the property ActiveJobs & enables or
// disables the buttons & menu-items according to the ActiveJobs.
//=============================================================================

procedure TFrmLstPromoPackCA.SetActiveJobs (Value : TSetListJobs);
begin   // of TFrmLstPromoPackCA.SetActiveJobs
 inherited;
 if not FrmMntPromoPackCA.FlgPromImprov then
   Exit;
  ConfigOneJob (MniRecNew, BtnPrint, CtCodJobRecPrint in FActiveJobs);
  ConfigOneJob (MniRecNew, BtnExprt, CtCodJobRecExport in FActiveJobs);
end;   // of TFrmLstPromoPackCA.SetActiveJobs

//=============================================================================
// R2014.1.Req(31110).Promopack_Improvement.TCS-SRM.End
//=============================================================================
initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of FLstPromoPackCA
