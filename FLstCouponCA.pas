//================Copyright 2010 (c) KITS - All rights reserved.===============
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FLstCouponCA.PAS
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstCouponCA.pas,v 1.0 2014/04/10 11:44:11 SRM Exp $
// Version   Modified By       Reason
//  1.0      SRM   (TCS)       R2014.1.Req(31110).Promopack_Improvement
//=============================================================================

unit FLstCouponCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FLstCoupon, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids,DBTables, ExtDlgs,
  SmUtils,SfVSPrinter7,SmVSPrinter7Lib_TLB,ScTskMgr_BDE_DBC;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

const
  CtMaxNumDays         =  30;
  TxtSep               = '|';                      // Seperator character
  CRLF                 = #13#10;                   // Indicate a new line
  CtLogoName           = 'flexpoint.report.bmp';   // Logo to print on the rapport
  CtDefaultPlace       = 'D:\sycron\transfertbo\excel';
//=============================================================================
// Resource strings
//=============================================================================
Resourcestring
  CtTxtExists           = 'File exists, Overwrite?';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtTitle            = 'Maintenance coupon';
  CtTxtNoData           = 'No data exist';
  CtTxtCouponNo         = 'Coupon Number';
  CtTxtCoupDescr        = 'Coupon Descr';
  CtTxtCoupValid        = 'Coup .Valid';
  CtTxtValCoup          = 'Coup Val';
  CtTxtReference        = 'Rep';
  CtTxtPage             = 'Page';     // Show's the word Page on the buttom of
type
  TFrmLstCouponCA = class(TFrmLstCoupon)
    BtnExprt: TSpeedButton;
    BtnPrint: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnExprtClick(Sender: TObject);
    procedure SetAllowedJobs (Value : TSetListJobs); override;
    procedure SetActiveJobs (Value : TSetListJobs); override;
  private
    { Private declarations }
    FFrmVSPreview  : TFrmVSPreview;    // VS Preview form
    FFlgPreview    : Boolean;          // Print or Preview the rapport.
    // Logo to be printed
    FFNLogo        : string;           // Filename logo
    FPicLogo       : TImage;           // Logo
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
    
    // Property to build the table report
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

var
  FrmLstCouponCA: TFrmLstCouponCA;
  
//*****************************************************************************

implementation

uses

  SfDialog,
  DFpnUtils,
  DFpnCoupon,
  StStrW,
  FMntCouponCA,
  DFpnTradeMatrix;

{$R *.dfm}
//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'TFLstCouponCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: C:\IntDev\Castorama\Flexpoint201\Develop\FLstCouponCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2014/03/17 12:54:51 $';
  
//*****************************************************************************
// Implementation of TFrmLstCouponCA
//*****************************************************************************

procedure TFrmLstCouponCA.BtnPrintClick(Sender: TObject);
begin  // of TFrmLstCouponCA.BtnPrintClick
  inherited;
  if (not DscList.DataSet.Active) or (not FlgEverRefreshed) then
    raise EAbort.Create ('No data');
  if Application.Terminated then
    Exit;
  SetGeneralSettings;
    VspPreview.OnNewPage := NewPage;
    VspPreview.Orientation := orLandscape;
    VspPreview.StartDoc;
    PrintTableBody;
    VspPreview.EndDoc;
    PrintPageNumbers;
    PrintReferences;
  VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
end;  // of TFrmLstCouponCA.BtnPrintClick

//=============================================================================

function TFrmLstCouponCA.GetFrmVSPreview : TFrmVSPreview;
begin  // of TFrmLstCouponCA.GetFrmVSPreview
  if not Assigned (FFrmVSPreview) then begin
    FFrmVSPreview := TFrmVSPreview.Create (Application);
    FFrmVSPreview.VspPreview.HdrFont.CharSet := DEFAULT_CHARSET;
  end;
  Result := FFrmVSPreview;
end;   // of TFrmLstCouponCA.GetFrmVSPreview

//=============================================================================

function TFrmLstCouponCA.GetVspPreview : TVSPrinter;
begin  // of TFrmLstCouponCA.GetVspPreview
  Result := FrmVSPreview.VspPreview;
end;   // of TFrmLstCouponCA.GetVspPreview

//=============================================================================

function TFrmLstCouponCA.CalcWidthText (ValLength  : Byte;
                                         FlgNumeric : Boolean) : Integer;
begin  // of TFrmLstCouponCA.CalcWidthText
  if FlgNumeric then
    Result := Trunc (VspPreview.TextWidth [CharStrW ('9', ValLength)])
  else
    Result := Trunc (VspPreview.TextWidth [CharStrW ('X', ValLength)]);
end;   // of TFrmLstCouponCA.CalcWidthText

//=============================================================================
// GetFmtTableHeader: Construct the structure of the Table Header of the report
//=============================================================================

function TFrmLstCouponCA.GetFmtTableHeader: string;
begin  // of TFrmLstCouponCA.GetFmtTableHeader
    Result := '^+' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (30, False)) + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False))  + TxtSep +
              '^+' + IntToStr (CalcWidthText (10, False))
end;   // of TFrmLstCouponCA.GetFmtTableHeader

//=============================================================================
//  GetFmtTableBody : Construct the structure of the Table Body of the report
//=============================================================================

function TFrmLstCouponCA.GetFmtTableBody : string;
begin  // of TFrmLstCouponCA.GetFmtTableBody
    Result := '<' + IntToStr (CalcWidthText (20, False)) + TxtSep +
              '<' + IntToStr (CalcWidthText (30, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False)) + TxtSep +
              '>' + IntToStr (CalcWidthText (10, False))    
end;   // of TFrmLstCouponCA.GetFmtTableBody

//=============================================================================
//  GetTxtTableTitle : Generate the main report titles
//=============================================================================
function TFrmLstCouponCA.GetTxtTableTitle : string;
begin  // of TFrmLstCouponCA.GetTxtTableTitle
     Result :=CtTxtCouponNo   + TxtSep +
              CtTxtCoupDescr    + TxtSep +
              CtTxtCoupValid  + TxtSep +
              CtTxtValCoup
end;   // of TFrmLstCouponCA.GetTxtTableTitle
//=============================================================================
//  GetTxtTitRapport : Generate the main title of the report
//=============================================================================

function TFrmLstCouponCA.GetTxtTitRapport : string;
begin  // of TFrmLstCouponCA.GetTxtTitRapport
  Result := CtTxtTitle + CRLF;
end;   // of TFrmLstCouponCA.GetTxtTitRapport

//=============================================================================

function TFrmLstCouponCA.GetTxtRefRapport : string;
begin  // of TFrmLstCouponCA.GetTxtRefRapport
  Result := CtTxtReference + '0006';
end;   // of TFrmLstCouponCA.GetTxtRefRapport

//=============================================================================
//  PrintHeader : Set general settings
//=============================================================================

procedure TFrmLstCouponCA.SetGeneralSettings;
begin  // of TFrmLstCouponCA.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  VspPreview.MarginTop := 2500;

  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtLogoName;
end;   // of TFrmLstCouponCA.SetGeneralSettings

//=============================================================================
//  PrintHeader : construct the header of the report
//=============================================================================

procedure TFrmLstCouponCA.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;
begin  // of TFrmLstCouponCA.PrintHeader
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName+ CRLF;
  TxtHdr := TxtHdr +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  TxtDatFormat := CtTxtDatFormat;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
              [FormatDateTime (TxtDatFormat, Now),
              FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmLstCouponCA.PrintHeader

//=============================================================================

function TFrmLstCouponCA.GetPicLogo : TImage;
begin  // of TFrmLstCouponCA.GetPicLogo
  if not Assigned (FPicLogo) then
    FPicLogo := TImage.Create (Self);
  Result := FPicLogo;
end;   // of TFrmLstCouponCA.GetPicLogo

//=============================================================================

procedure TFrmLstCouponCA.SetPicLogo (Value : string);
begin  // of TFrmLstCouponCA.SetPicLogo
  try
    FFNLogo := ReplaceEnvVar (Value);
    if FileExists (FFNLogo) then
      Logo.Picture.LoadFromFile (FFNLogo);
  except
  end;
end;   // of TFrmLstCouponCA.SetPicLogo

//=============================================================================

procedure TFrmLstCouponCA.NewPage (Sender : TObject);
begin  // of TFrmLstCouponCA.NewPage
  PrintHeader;

  PrintTableHeader;
end;   // of TFrmLstCouponCA.NewPage

//=============================================================================
//  PrintTableHeader : Costruct the header part of the report
//=============================================================================
procedure TFrmLstCouponCA.PrintTableHeader;
begin  // of TFrmLstCouponCA.PrintTableHeader
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.AddTable (FmtTableHeader, '', TxtTableTitle,
                       clWhite, clLTGray, False);
end;   // of TFrmLstCouponCA.PrintTableHeader

//=============================================================================
//  PrintTableBody : Construct the main report body 
//=============================================================================
procedure TFrmLstCouponCA.PrintTableBody;
var
  TxtPrintLine        : string;         // String to print
begin  // of TFrmLstCouponCA.PrintTableBody
 inherited;
  VspPreview.TableBorder := tbBoxColumns;
  TxtPrintLine := '';
  if DmdFpnCoupon.SprLstCoupon.RecordCount = 0 then begin
    TxtPrintLine := CtTxtNoData;
    VspPreview.StartTable;
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clWhite, False);
    VspPreview.EndTable;
  end
  else begin
    DmdFpnCoupon.SprLstCoupon.First;
    while not DmdFpnCoupon.SprLstCoupon.Eof do begin
      VspPreview.StartTable;
      TxtPrintLine := TxtPrintLine +
        DmdFpnCoupon.SprLstCoupon.FieldByName('IdtCoupon').AsString + TxtSep +
        DmdFpnCoupon.SprLstCoupon.FieldByName('TxtPublDescr').AsString + TxtSep +
        DmdFpnCoupon.SprLstCoupon.FieldByName('QtyDayValid').AsString + TxtSep +
        DmdFpnCoupon.SprLstCoupon.FieldByName('ValCoupon').AsString;
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clWhite, False);
      VspPreview.EndTable;
      TxtPrintLine := '';
     DmdFpnCoupon.SprLstCoupon.Next;
    end;
  end;
end;   // of TFrmLstCouponCA.PrintTableBody

//=============================================================================

procedure TFrmLstCouponCA.PrintPageNumbers;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmLstCouponCA.PrintPageNumbers
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
end;   // of TFrmLstCouponCA.PrintPageNumbers

//=============================================================================

procedure TFrmLstCouponCA.PrintReferences;
var
  CntPageNb        : Integer;          // Temp Pagenumber
  TxtHdr           : string;
begin  // of TFrmLstCouponCA.PrintReferences
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
end;   // of TFrmLstCouponCA.PrintReferences

//=============================================================================
//  BtnExprtClick : Construct the main report body to export in a csv format
//=============================================================================

procedure TFrmLstCouponCA.BtnExprtClick(Sender: TObject);
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
  TxtDatFormat      : string;

begin // of TFrmLstCouponCA.BtnExportClick
  if (not DscList.DataSet.Active) and (not FlgEverRefreshed) then
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
    TxtWriteLine := CtTxtTitle + CRLF+ CRLF;
    TxtWriteLine := TxtWriteLine +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
   TxtWriteLine := TxtWriteLine + Format (CtTxtPrintDate,
                   [FormatDateTime (TxtDatFormat, Now),
                    FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
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
      DmdFpnCoupon.SprLstCoupon.Active := True;
      DmdFpnCoupon.SprLstCoupon.First;
     if DmdFpnCoupon.SprLstCoupon.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
        while not DmdFpnCoupon.SprLstCoupon.Eof do begin
          TxtWriteLine := '';
          TxtWriteLine := TxtWriteLine + 
             DmdFpnCoupon.SprLstCoupon.FieldByName('IdtCoupon').AsString + ';' +
             DmdFpnCoupon.SprLstCoupon.FieldByName('TxtPublDescr').AsString + ';' +
             DmdFpnCoupon.SprLstCoupon.FieldByName('QtyDayValid').AsString + ';'+
             DmdFpnCoupon.SprLstCoupon.FieldByName('ValCoupon').AsString;
            WriteLn(F, TxtWriteLine);
           DmdFpnCoupon.SprLstCoupon.Next;
        end;
      System.Close(F);
    end;
    DecimalSeparator := ChrDecimalSep;  
end; // of TFrmLstCouponCA.BtnExportClick

//=============================================================================
// TFrmLstCouponCA.SetAllowedJobs : sets the property AllowedJobs & enables
// or disables the buttons & menu-items according to the AllowedJobs.
//=============================================================================

procedure TFrmLstCouponCA.SetAllowedJobs (Value : TSetListJobs);
begin  // of TFrmLstCouponCA.SetAllowedJobs
 inherited;
  if not FlgPromImprov then begin
    BtnPrint.Visible := False;
    BtnExprt.Visible := False;
  end
  else begin
    ConfigOneJob (MniRecNew, BtnPrint, CtCodJobRecPrint in FAllowedJobs);
    ConfigOneJob (MniRecNew, BtnExprt, CtCodJobRecExport in FAllowedJobs);
  end;
end;   // of TFrmLstCouponCA.SetAllowedJobs

//=============================================================================
// TFrmLstCouponCA.SetActiveJobs: sets the property ActiveJobs & enables or
// disables the buttons & menu-items according to the ActiveJobs.
//=============================================================================

procedure TFrmLstCouponCA.SetActiveJobs (Value : TSetListJobs);
begin   // of TFrmLstCouponCA.SetActiveJobs
  inherited;
   if not FlgPromImprov then
     Exit;
   ConfigOneJob (MniRecNew, BtnPrint, CtCodJobRecPrint in FActiveJobs);
   ConfigOneJob (MniRecNew, BtnExprt, CtCodJobRecExport in FActiveJobs);
end;   // of TFrmLstCouponCA.SetActiveJobs

//=============================================================================
end.