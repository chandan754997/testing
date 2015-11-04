//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     : FRptSalesBulletin.PAS : Report for coupon status
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version    Modified by    Reason
// 1.0        P.M.(TCS)      Initial version created  for Sales Bulletin Report in R2011.1
// 1.01       PRG (TCS)      R2011.2 - CAFR - Bug#30, #961, #969 fix
// 1.02       AM (TCS)       Internal Defect-41 Fix
//=============================================================================

unit FRptSalesBulletin;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, ScUtils_Dx, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, SmVSPrinter7Lib_TLB, Db, // Bug#30, #961, #969 fix, PRG, R2011.2
  IniFiles;                                                                     // Bug#30, #961, #969 fix, PRG, R2011.2

resourcestring // for table header of the document.

  CtTxtState                  = 'Closed';
  CtTxtTicketNb               = 'Ticket Number';
  CtTxtNoBV                   = 'No. BV';
  CtTxtID                     = 'ID';
  CtTxtAmountBV               = 'AmountBV';
  CtTxtArtCode                = 'Item code';
  CtTxtArtDescr               = 'Article Designation';
  CtTxtQty                    = 'Quantity';
  CtTxtPrix                   = 'Price';
  CtTxtNoArticle              = 'Number of articles';
  CtTxtTimePsgTerminal        = 'Time passage Terminal';
  CtTxtTotalBV                = 'Total BV:';
  CtTxtTotalAmountBV          = 'Amount BV:';
  CtTxtTotalArticles          = 'Total Articles:';
  CtTxtTotalClosure           = 'BV Closure:';
resourcestring
  CtTxtTitleGeneral           = 'Global report:';
  CtTxtTitListAll             = 'List of bulletins sale terminals';
  CtTxtTitList                = 'List of items per identifier and per Bulletin de Vente';
  CtTxtTitleReportType        = 'Report type selected:';
  CtTxtTitleNotUsed           = 'Bulletins sale terminal unfenced';
  CtTxtTitleAll               = 'Report of all entries Sale Terminal';
  CtTxtTitleVoucherNumber     = 'Bulletins from Sale Terminal Identifier: %s';
  CtTxtReportDate             = 'Date: %s';
  CtTxtErrorHeader            = 'Incorrect Data';
  CtTxtClentIdtRequired      = 'Client identification number is required!';
  CtTxtClientIdtNotPresent   = 'No "Bulletin de Vente" associated to that Client identifier';
  CtTxtNbPromoPack            = 'Nr promopack';
  CtTxtDescription            = 'Description';
  CtTxtRbtClientIdentifier    = 'Client Identifier';                            // Bug#30, #961, #969 fix, PRG, R2011.2
  CtTxtRbtAll                 = 'All';
  CtTxtRbtNotClosed           = 'Not Closed';
  CtTxtYes                    = 'Yes';
  CtTxtNo                     = '';
  CtTxtAppTitle               = 'Sales Bulletin Report';
  CtTxtValidate               = 'Client Identifier should be 4 digit';


const
  CtLongStateCancelled        = 'Annulé';

const // CodState
  CtCodStateNotUsed           = 0;
  CtCodStateUsed              = 1;
  CtCodStateCancelled         = 2;
  CtCodStateExpired           = 3;
  CtCodStateDeActivated       = 4;

const
  CtBulletinType             = '1';
  CtTxtClosed                = '';
  CtTxtHouFormat   = 'hh:mm';       // Default hour-format
  CtSeparator      = ':';

type
  TFrmRptSalesBulletin = class(TFrmDetGeneralCA)
    Gbx: TGroupBox;
    RbtNotClosed: TRadioButton;
    RbtClientIdentifier: TRadioButton;
    SvcMEClientIDNr: TSvcMaskEdit;
   // procedure SvcMEClientIDNrExit(Sender: TObject);
    //procedure SvcMEClientIDNrFocusChanged(Sender: TObject);
    //procedure SvcMEClientIDNrPropertiesChange(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure RbtReportTypeClick(Sender: TObject);
  private
    { Private declarations }
    TotNumCoupon: integer;
    TotValCoupon: Double;
    TotValUsed: Double;
    TotValSaldo: Double;
    ValCoupon: double;
    ValTotCoupon: double;
    TotNumArticle: longint;
    TotNumClosed: integer;
    Counter: integer;
    FlgNoRecord: Boolean;
    LenClientId: integer;                                                       // Bug#30, #961, #969 fix, PRG, R2011.2
  protected
    { Protected declarations }
    function GetFmtTableHeader: string; override;
    function GetFmtTableBody: string; override;

    function GetTxtTableTitle: string; override;

    function GetTxtTitRapport: string; override;
    function GetTxtTitTypeReport: string; virtual;
    procedure ReadParams; virtual;                                              // Bug#30, #961, #969 fix, PRG, R2011.2
  public
    { Public declarations }
    property TxtTitTypeReport: string read GetTxtTitTypeReport;

    function BuildStatement: string;
    function BuildLine(DtsSet: TDataSet): string; virtual;
    function BuildLineBulletin(DtsSet: TDataSet): string; virtual;
    function BuildLineMovement(DtsSet: TDataSet): string; virtual;
    function BuildTotalLine: string; virtual;

    procedure SetGeneralSettings; override;
    procedure PrintTableBody; override;
    procedure PrintHeader; override;
    procedure Execute; override;
  end;

var
  FrmRptSalesBulletin          : TFrmRptSalesBulletin;
  ValBVNo                      : Integer;

implementation

uses
  DFpnTradeMatrix,
  DFpnUtils,

  smUtils,
  SmDBUtil_BDE,
  sfDialog, SfAutoRun;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const // Module-name
  CtTxtModuleName             = 'FRptSalesBulletin';

const // PVCS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 1.01 $';
  CtTxtSrcDate                = '$Date: 2011/09/20 09:55:26 $';

//*****************************************************************************
// Implementation of TFrmRptCouponStatus
//*****************************************************************************

// Bug#30, #961, #969 fix, PRG, R2011.2 - start
//=============================================================================
// TFrmRptSalesBulletin.ReadParams : Get param out of FpsSyst.ini
//=============================================================================

procedure TFrmRptSalesBulletin.ReadParams;
var
  IniFile            : TIniFile;          // IniObject to the INI-file
  TxtPath            : string;            // Path of the ini-file
begin  // of TFrmRptSalesBulletin.ReadParams
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  LenClientId := StrToInt(IniFile.ReadString('Kiosk', 'LenClientId', '0'));
end;   // of TFrmRptSalesBulletin.ReadParams

// Bug#30, #961, #969 fix, PRG, R2011.2 - end
//=============================================================================

procedure TFrmRptSalesBulletin.RbtReportTypeClick(Sender: TObject);
begin // of TFrmRptCouponStatus.RbtReportTypeClick
  inherited;
  SvcMEClientIDNr.Enabled := RbtClientIdentifier.Checked;
end; // of TFrmRptCouponStatus.RbtReportTypeClick

//=============================================================================
procedure TFrmRptSalesBulletin.FormActivate(Sender: TObject);
begin // of TFrmRptCouponStatus.FormActivate
  inherited;
end; // of TFrmRptCouponStatus.FormActivate

//=============================================================================
procedure TFrmRptSalesBulletin.Execute;
begin // of TFrmRptCouponStatus.Execute


  if (RbtClientIdentifier.Checked) and
    (SvcMEClientIDNr.TrimText = '') then begin
    Application.MessageBox(PChar(CtTxtClentIdtRequired),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin

    VspPreview.Orientation := orPortrait;
    VspPreview.StartDoc;
    PrintTableBody;
    PrintTableFooter;

    If FlgNoRecord then begin
      Application.MessageBox(PChar(CtTxtClientIdtNotPresent),
                                             PChar(CtTxtErrorHeader), MB_OK);
       exit;
    end;

    VspPreview.EndDoc;

    PrintPageNumbers;

    if FlgPreview then begin
      FrmVSPreview.Show;
    end
    else
      VspPreview.PrintDoc(False, 1, VspPreview.PageCount);
  end;
end; // of TFrmRptCouponStatus.Execute

//=============================================================================
procedure TFrmRptSalesBulletin.PrintHeader;
var
  TxtHdr                      : string; // Text stream for the header
begin // of TFrmRptCouponStatus.PrintHeader
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'] + CRLF;

  TxtHdr := TxtHdr +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr +
            Format(CtTxtReportDate,[FormatDateTime(CtTxtDatFormat, Now)]) + '  ' +
            FormatDateTime(CtTxtHouFormat, Now) + CRLF + CRLF;


  TxtHdr := TxtHdr + TxtTitTypeReport;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo(Logo);
end; // of TFrmRptCouponStatus.PrintHeader

//=============================================================================
function TFrmRptSalesBulletin.GetTxtTitRapport: string;
begin // of TFrmRptCouponStatus.GetTxtTitRapport

    Result := CtTxtTitList
end; // of TFrmRptCouponStatus.GetTxtTitRapport
//=============================================================================

function TFrmRptSalesBulletin.GetTxtTitTypeReport: string;
begin // of TFrmRptCouponStatus.GetTxtTitTypeReport
  if RbtNotClosed.Checked then
    Result := CtTxtTitleReportType + ' ' + CtTxtTitleNotUsed
  else if RbtClientIdentifier.Checked then
    Result := CtTxtTitleReportType + ' ' + Format(CtTxtTitleVoucherNumber,
      [SvcMEClientIDNr.TrimText]);
end; // of TFrmRptCouponStatus.GetTxtTitTypeReport

//=============================================================================

function TFrmRptSalesBulletin.GetTxtTableTitle: string;
begin // of TFrmRptCouponStatus.GetTxtTableTitle

    Result := CtTxtTimePsgTerminal + TxtSep +
      CtTxtID + TxtSep +
      CtTxtNoBV + TxtSep +
      CtTxtAmountBV + TxtSep +
      CtTxtArtCode + TxtSep +
      CtTxtArtDescr + TxtSep +
      CtTxtQty + TxtSep +
      CtTxtPrix


end; // of TFrmRptCouponStatus.GetTxtTableTitle

//=============================================================================

function TFrmRptSalesBulletin.GetFmtTableBody: string;
begin // of TFrmRptCouponStatus.GetFmtTableHeader

    Result := '^' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(7, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(38, False));
    Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));


end; // of TFrmRptCouponStatus.GetFmtTableBody

//=============================================================================

function TFrmRptSalesBulletin.GetFmtTableHeader: string;
begin // of TFrmRptCouponStatus.GetFmtTableHeader

    Result := '^+' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(7, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(38, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));


end; // of TFrmRptCouponStatus.GetFmtTableHeader

//=============================================================================

function TFrmRptSalesBulletin.BuildLineMovement(DtsSet: TDataSet): string;
var
  TxtStateShort               : string;
  TxtMovement                 : string;
  TxtCheckout                 : string;
begin // of BuildLineMovement

end; // of BuildLineMovement

//=============================================================================
function TFrmRptSalesBulletin.BuildLineBulletin(DtsSet: TDataSet): string;
var
  TxtDatState                 : string;
  TxtValSaldo                 : string;
  TxtStateShort               : string;
  //TxtValUsed                  : string;
  TxtValue                    : string;
  TxtNoOfArticle              : string;
  TxtClosed                   : string;

begin // of BuildLineBulletin

  // Init
  ValTotCoupon := 0;
  TxtValSaldo := '0' + DecimalSeparator + '00';
  TxtDatState := '';
  TxtStateShort := '';
  TxtClosed     := '';



  // Fill coupon value
  TxtValue := FormatFloat('0.00', DtsSet.FieldByName('M_TOTAL_VENTE').AsFloat);

  //calculate the total article from the quantity

   //Defect48 Fix - start
   // QTE_SAISI replaced by QDIM1_SAISI
     If not DtsSet.FieldByName('QDIM1_SAISI').IsNull THEN
          TxtNoOfArticle := InttoStr(Abs (DtsSet.FieldByName ('QDIM1_SAISI').AsInteger));
   //Defect48 Fix - End

    IF Abs (DtsSet.FieldByName ('M_TOTAL_VENTE').AsInteger) = 10 THEN begin
       TxtClosed := CtTxtYes;
    end
    ELSE begin
       TxtClosed := '';
    END;

    Result := DtsSet.FieldByName('TimeCreate').AsString + TxtSep + //FormatDateTime(CtTxtHouFormatS, DtsSet.FieldByName('DCREATION').AsDateTime) + TxtSep +
            Format('%.*d', [LenClientId, DtsSet.FieldByName('CIDENTIF').AsInteger]) + TxtSep +  // Bug#30, #961, #969 fix, PRG, R2011.2
            DtsSet.FieldByName('CVENTE').AsString + TxtSep +
            //DtsSet.FieldByName ('M_TOTAL_VENTE').AsString + TxtSep +
            CurrToStrF (DtsSet.FieldByName ('M_TOTAL_VENTE').AsFloat, ffFixed,
                   DmdFpnUtils.QtyDecsValue) + TxtSep +
            DtsSet.FieldByName('CESCLAVE').AsString + TxtSep +
            DtsSet.FieldByName('LIB_ESCLAVE').AsString + TxtSep +
            //DtsSet.FieldByName('QTE_SAISI').AsString + TxtSep +
            DtsSet.FieldByName('QDIM1_SAISI').AsString + TxtSep +  //Defect48 Fix


            //DtsSet.FieldByName('M_PV_SAISI').AsString;
            CurrToStrF (DtsSet.FieldByName ('M_PV_SAISI').AsFloat, ffFixed,
                   DmdFpnUtils.QtyDecsValue);

   // TotValCoupon  := TotValCoupon + StrToFloat (TxtValue);   // Commented to fix Defect 971

  TotNumArticle := TotNumArticle + StrToInt(TxtNoOfArticle);
  //if TotValCoupon > 0 then
  if ValBVNo <>  DtsSet.FieldByName('CVENTE').AsInteger then begin // Count Distinct BV
    Inc (TotNumCoupon);
    ValBVNo :=  DtsSet.FieldByName('CVENTE').AsInteger;
    TotValCoupon  := TotValCoupon + StrToFloat (TxtValue); // Added to fix Defect 971
  end;

end; // of BuildLineBulletin
//=============================================================================
procedure TFrmRptSalesBulletin.PrintTableBody;
var
  TxtDescr                    : string;
  TxtIdtClientID              : string;
  TxtTicket                   : string;
  TxtCoupon                   : string;
  TxtNumSeq                   : string;


//  counterback      : integer;
begin // of TFrmRptCouponStatus.PrintTableBody
  inherited;
  TotNumCoupon  := 0;
  TotValCoupon  := 0;
  TotValUsed    := 0;
  TotValSaldo   := 0;
  TotNumArticle := 0;
  TotNumClosed  := 0;
  TxtTicket     := '';
  TxtCoupon     := '';
  TxtNumSeq     := '';
  TxtIdtClientID := '';
  ValCoupon     := 0;
  Counter       := 1;

  try
    FlgNoRecord := False;
    if DmdFpnUtils.QueryInfo(BuildStatement) then begin

        TxtIdtClientID := DmdFpnUtils.QryInfo.FieldByName('CIDENTIF').AsString;


      while not DmdFpnUtils.QryInfo.Eof do begin
        if RbtClientIdentifier.Checked then begin
          VspPreview.AddTable
            (FmtTableBody, '', BuildLine(DmdFpnUtils.QryInfo),
            clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end
        else begin
          VspPreview.AddTable
            (FmtTableBody, '', BuildLine(DmdFpnUtils.QryInfo),
            clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end;
      end;

      BuildTotalLine;

    end
    else begin
      if RbtClientIdentifier.Checked then begin
        If DmdFpnUtils.QryInfo.RecordCount = 0 then begin
                  FlgNoRecord := True;
                  exit;
        end;
     end;
   end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end; // of TFrmRptCouponStatus.PrintTableBody

//=============================================================================

function TFrmRptSalesBulletin.BuildStatement: string;
var
a : string;
begin // of TFrmRptCouponStatus.BuildStatement
  if RbtClientIdentifier.Checked then begin
     Result :=
        #10'select Substring(STUFF(a.DCREATION,11,0,' +AnsiQuotedStr(CtSeparator,'''') + '),9,5) as TimeCreate, ' +
        #10'a.CIDENTIF, a.CVENTE, a.M_TOTAL_VENTE, ' +
        #10'b.CESCLAVE, b.LIB_ESCLAVE, ' +
        //#10'b.QTE_SAISI, ' +
        #10'b.QDIM1_SAISI, '+ //Defect48 Fix
        #10'B.M_PV_SAISI ' +
        #10'from VENTE a, VENTE_ligne b' +
        #10'WHERE a.CVENTE = b.CVENTE' +
        #10'and a.Type_vente = ' + AnsiQuotedStr(CtBulletinType,'''') +
     // #10'AND Ltrim(rtrim(a.CIDENTIF)) = ' + AnsiQuotedStr(SvcMEClientIDNr.TrimText, '''') +                     // Bug#30, #961, #969 fix, PRG, R2011.2
        #10'AND Ltrim(rtrim(a.CIDENTIF)) = ' + AnsiQuotedStr(IntToStr(StrToInt(SvcMEClientIDNr.TrimText)), '''') + // Bug#30, #961, #969 fix, PRG, R2011.2
        #10'AND CONVERT(VARCHAR(8), CAST(Substring(a.DCREATION,1,8) as DateTime), 1) = CONVERT(VARCHAR(8), GETDATE(), 1)' +
        //#10'AND A.TSITUATION_C104 <> 10' +
        #10'ORDER BY a.DCREATION DESC, a.CVENTE';

  end
  else begin

     //Select query when the not closed option is selected from the screen
      Result :=

        #10'select Substring(STUFF(a.DCREATION,11,0,' +AnsiQuotedStr(CtSeparator,'''') + '),9,5) as TimeCreate, ' +
        #10'a.CIDENTIF, a.CVENTE, a.M_TOTAL_VENTE,' +
        #10'b.CESCLAVE, b.LIB_ESCLAVE, ' +
        //#10'b.QTE_SAISI, '+
        #10'b.QDIM1_SAISI, '+ //Defect48 Fix
        #10'B.M_PV_SAISI ' +
        #10'from VENTE a, VENTE_ligne b' +
        #10'WHERE a.CVENTE = b.CVENTE' +
        #10'AND Ltrim(rtrim(a.CIDENTIF)) IS NOT NULL ' +   //Added for Defect 974
        #10'AND CONVERT(VARCHAR(8), CAST(Substring(a.DCREATION,1,8) as DateTime), 1) = CONVERT(VARCHAR(8), GETDATE(), 1)' +
        #10'AND a.Type_vente = ' + AnsiQuotedStr(CtBulletinType,'''')  +
        //#10'AND A.TSITUATION_C104 <> 10' +   //10 means closed
        #10'ORDER BY a.DCREATION DESC, a.CVENTE';

  end;
end; // of TFrmRptCouponStatus.BuildStatement

//=============================================================================

function TFrmRptSalesBulletin.BuildLine(DtsSet: TDataSet): string;
begin // of TFrmRptCouponStatus.BuildLine
    Result := BuildLineBulletin(DtsSet);
end;

//=============================================================================

procedure TFrmRptSalesBulletin.BtnPrintClick(Sender: TObject);
begin // of TFrmRptCouponStatus.BtnPrintClick
  FlgPreview := (Sender = BtnPreview);
  {if RbtClientIdentifier.Checked then begin
      if SvcMEClientIDNr.Text <> '' then begin
        if  Length(SvcMEClientIDNr.TrimText) <> 4 then begin
          Application.MessageBox(PChar(CtTxtValidate),
                                             PChar(CtTxtErrorHeader), MB_OK);
          exit;
        end;
      end;
  end;  }
  Execute;

end; // of TFrmRptCouponStatus.BtnPrintClick

//=============================================================================

procedure TFrmRptSalesBulletin.FormCreate(Sender: TObject);
begin // of TFrmRptCouponStatus.FormCreate
  inherited;
  Readparams;                                                                   // Bug#30, #961, #969 fix, PRG, R2011.2
  RbtNotClosed.Checked := True;
  RbtReportTypeClick(Self);
  DtmPckDayFrom.DateTime := now;
  DtmPckDayTo.DateTime := now;
  //switch off the visibility of the components that are not required
  DtmPckDayFrom.Visible := False;
  DtmPckDayTo.Visible := False;
  DtmPckLoadedFrom.Visible := False;
  DtmPckLoadedTo.Visible := False;
  RbtDateDay.Visible := False;
  RbtDateLoaded.Visible := False;
  SvcDBLblDateFrom.Visible := False;
  SvcDBLblDateLoadedFrom.Visible := False;
  SvcDBLblDateTo.Visible := False;
  SvcDBLblDateLoadedTo.Visible := False;
  Panel1.Visible := False;
  //Set the initial dimentions
  Gbx.Width := 450;
  FrmRptSalesBulletin.Height := 260;
  FrmRptSalesBulletin.Width := 477;
  RbtNotClosed.Caption := CtTxtRbtNotClosed;
  RbtClientIdentifier.Caption := CtTxtRbtClientIdentifier;
  //TMenuItem. MniStart.Visible = False;
  FrmRptSalesBulletin.Caption := CtTxtAppTitle;
  Application.Title := CtTxtAppTitle;                 //Internal Defect-41 Fix(AM)
end; // of TFrmRptCouponStatus.FormCreate

//=============================================================================

procedure TFrmRptSalesBulletin.SetGeneralSettings;
begin // of TFrmRptCouponStatus.SetGeneralSettings
  inherited;
  VspPreview.MarginTop := 2800;
end; // of TFrmRptCouponStatus.SetGeneralSettings

//=============================================================================

function TFrmRptSalesBulletin.BuildTotalLine: string;
begin // of TFrmRptCouponStatus.BuildTotalLine
  Result := CtTxtTotalBV + TxtSep +
    IntToStr(TotNumCoupon) + TxtSep +
    FormatFloat('0.00', TotValCoupon) + TxtSep +
    TxtSep +
    FormatFloat('0.00', TotValUsed) + TxtSep +
    FormatFloat('0.00', TotValSaldo);


    VspPreview.Text := CRLF + CtTxtTotalBV + ' ' + IntToStr(TotNumCoupon) + CRLF +
                       CtTxtTotalAmountBV + ' ' + FormatFloat('0.00', TotValCoupon)+ CRLF +
                       CtTxtTotalArticles + ' ' + IntToStr(TotNumArticle);

end; // of TFrmRptCouponStatus.BuildTotalLine

//=============================================================================

procedure TFrmRptSalesBulletin.ActStartExecExecute(Sender: TObject);
begin
//  FlgPreview := (Sender = BtnPreview);
  FlgPreview := true;
 { if RbtClientIdentifier.Checked then begin
      if SvcMEClientIDNr.Text <> '' then begin
        if  Length(SvcMEClientIDNr.TrimText) <> 4 then begin
          Application.MessageBox(PChar(CtTxtValidate),
                                             PChar(CtTxtErrorHeader), MB_OK);
          exit;
        end;
      end;
  end;   }

  Execute;

end;

initialization
  // Add module to list for version control
  AddPVCSSourceIdent(CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
    CtTxtSrcDate);
end.

