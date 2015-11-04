//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet  : FlexPoint
// Customer: Castorama
// Unit    : FDetRptBlockedArticleCA.PAS : based on FDetGeneralCA (General
//                                      Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// History:
// - Started from Castorama - FlexPoint 1.0 - FDetRptBlockedArticleCA.PAS
// 1.0    SN      (TCS)        R2014.2.Req.31040.Report of articles blocked for sales.CAFR/CARU
//==============================================================================

unit FDetRptBlockedArticleCA;

//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, ExtDlgs,
  FDetGeneralCA;

//******************************************************************************
// Global definitions
//******************************************************************************

//==============================================================================
// Constants
//==============================================================================

const
  CtMaxNumDays        = 30;

//==============================================================================
// Resource strings
//==============================================================================

resourcestring     // of header
  CtTxtHeader     = 'Castorama';
  CtTxtTitle      = 'Blocked items for sale';
  CtTxtCode       = 'Code';
  CtTxtLabel      = 'Label';
  CtTxtDatBlock   = 'Date Blockage';


resourcestring     // of table header.

  CtTxtNoData      = 'No data for this daterange';
  CtTxtPrintDate   = 'Printed on %s at %s';
  CtTxtStartEndDate= 'Startdate is after enddate!';
  CtTxtStartFuture = 'Startdate is in the future!';
  CtTxtEndFuture   = 'Enddate is in the future!';
  CtTxtMaxDays     = 'Selected daterange may not contain more then %s days';

resourcestring // of export to excel parameters
  CtTxtPlace       = 'D:\sycron\transfertbo\excel';
  CtTxtExists      = 'File exists, Overwrite?';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetRptBlockedArticleCA = class(TFrmDetGeneralCA)
    SprLstBlockArticle: TStoredProc;
    SavDlgExport: TSaveTextFileDialog;
    CmbAskSelection: TComboBox;
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
   // procedure ActStartExecExecute(Sender: TObject);
  private

  protected
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody   : string; override;
    function GetTxtTableTitle  : string; override;
    function GetTxtTitRapport  : string; override;
    function GetTxtRefRapport  : string; override;
    function GetTxtHeadRapport : string; virtual;
    // Run params

  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure Execute; override;
  end;

var
  FrmDetRptBlockedArticleCA: TFrmDetRptBlockedArticleCA;

//******************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.DFM}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRptBlockedArticleCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.8 $';
  CtTxtSrcDate    = '$Date: 2010/06/28 06:52:24 $';

//******************************************************************************
// Implementation of TFrmDetRptBlockedArticleCA
//******************************************************************************

function TFrmDetRptBlockedArticleCA.GetFmtTableHeader: string;


begin  // of TFrmDetRptBlockedArticleCA.GetFmtTableHeader
  Result := '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));

end;   // of TFrmDetRptBlockedArticleCA.GetFmtTableHeader

//==============================================================================

function TFrmDetRptBlockedArticleCA.GetFmtTableBody: string;


begin  // of TFrmDetRptBlockedArticleCA.GetFmtTableBody
 Result := '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));

end;   // of TFrmDetRptBlockedArticleCA.GetFmtTableBody

//==============================================================================

function TFrmDetRptBlockedArticleCA.GetTxtTableTitle : string;
begin  // of TFrmDetRptBlockedArticleCA.GetTxtTableTitle
  Result :=   CtTxtCode  + TxtSep +  CtTxtLabel  + TxtSep +  CtTxtDatBlock;
end;   // of TFrmDetRptBlockedArticleCA.GetTxtTableTitle)

//==============================================================================

function TFrmDetRptBlockedArticleCA.GetTxtTitRapport : string;
begin  // of TFrmDetRptBlockedArticleCA.GetTxtTitRapport
   Result := CtTxtTitle;

end;   // of TFrmDetRptBlockedArticleCA.GetTxtTitRapport

//==============================================================================

function TFrmDetRptBlockedArticleCA.GetTxtHeadRapport : string;
begin  // of TFrmDetRptBlockedArticleCA.GetTxtHeadRapport
   Result := CtTxtHeader;

end;   // of TFrmDetRptBlockedArticleCA.GetTxtHeadRapport

//==============================================================================
function TFrmDetRptBlockedArticleCA.GetTxtRefRapport : string;
begin  // of TFrmDetRptBlockedArticleCA.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0005';
end;   // of TFrmDetRptBlockedArticleCA.GetTxtRefRapport

//==============================================================================

procedure TFrmDetRptBlockedArticleCA.Execute;
begin  // of TFrmDetRptBlockedArticleCA.Execute


  SprLstBlockArticle.Active := True;


  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  If SprLstBlockArticle.RecordCount = 0 then
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                         clWhite, False)
  else
  PrintTableBody;
  SprLstBlockArticle.Active := False;
  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetRptBlockedArticleCA.Execute

//==============================================================================

procedure TFrmDetRptBlockedArticleCA.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtStoreHdr      : string;
begin  // of TFrmDetRptBlockedArticleCA.PrintHeader
  inherited;

   TxtHdr:=TxtHeadRapport + ' ' + DmdFpnTradeMatrix.InfoTradeMatrix
   [DmdFpnUtils.IdtTradeMatrixAssort,'IdtTradeMatrix']+ CRLF;
   TxtHdr := TxtHdr +TxtTitRapport + CRLF;
   TxtHdr := TxtHdr;
   TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]); 

  VspPreview.Header := TxtHdr;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetRptBlockedArticleCA.PrintHeader

//==============================================================================

procedure TFrmDetRptBlockedArticleCA.PrintTableBody;
var
  TxtPrintLine        : string;           // String to print

begin  // of TFrmDetRptBlockedArticleCA.PrintTableBody
  //inherited;

  VspPreview.TableBorder := tbBoxColumns;


  while not SprLstBlockArticle.Eof do begin
        VspPreview.StartTable;

        TxtPrintLine :=
             SprLstBlockArticle.FieldByName ('IdtArticle').AsString
             + TxtSep + SprLstBlockArticle.FieldByName ('TxtPublDescr').AsString;

        if((SprLstBlockArticle.FieldByName ('DatBlocking').AsString) = '')
           then
             TxtPrintLine := TxtPrintLine + TxtSep +  'NULL'
        else begin
             TxtPrintLine := TxtPrintLine + TxtSep
             + SprLstBlockArticle.FieldByName ('DatBlocking').AsString
        end;
             VspPreview.AddTable (FmtTableBody, '', TxtPrintLine,
             clWhite,clWhite,False);


        VspPreview.EndTable;

        SprLstBlockArticle.Next;
   end;
end;   // of TFrmDetRptBlockedArticleCA.PrintTableBody


//==============================================================================

procedure TFrmDetRptBlockedArticleCA.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetRptBlockedArticleCA.BtnPrintClick
     FlgPreview := (Sender = BtnPreview);
     Execute;
  //end;
end;  // of TFrmDetRptBlockedArticleCA.BtnPrintClick


//==============================================================================

(*procedure TFrmDetRptBlockedArticleCA.ActStartExecExecute(Sender: TObject);
begin  // of TFrmDetRptBlockedArticleCA.ActStartExecExecute
  //BtnPrintClick(BtnPreview);
end;   // of TFrmDetRptBlockedArticleCA.ActStartExecExecute*)

//=============================================================================

procedure TFrmDetRptBlockedArticleCA.FormCreate(Sender: TObject);
var
  TxtParam               : string;
begin
  inherited;
  Self.Caption := CtTxtTitle;
  TxtParam := FindRunParam(TxtParam);
end;

//==============================================================================

procedure TFrmDetRptBlockedArticleCA.BtnExportClick(Sender: TObject);
var
  TxtTitles              : string;
  TxtWriteLine           : string;
  counter                : integer;
  F                      : System.Text;
  ChrDecimalSep          : char;
  Btnselect              : integer;
  FlgOK                  : Boolean;
  TxtPath                : String;
  QryHlp                 : TQuery;
begin
inherited;
  QryHlp              := TQuery.Create(self);
  QryHlp.DatabaseName := 'DBFlexPoint';
  QryHlp.Active       := False;
  QryHlp.SQL.Clear;
  QryHlp.SQL.Add('select * from ApplicParam' +
                ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
  try
    QryHlp.Active := True;
     
    if QryHlp.RecordCount > 0 then
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
   ChrDecimalSep := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then TxtWriteLine := TxtWriteLine + ';'
      else TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists,mtError, mbOKCancel,0);
      If not FlgOK then Btnselect := mrOK;
    until Btnselect = mrOk;
    if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      SprLstBlockArticle.Active := True;
      SprLstBlockArticle.First;
     if SprLstBlockArticle.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
        while not SprLstBlockArticle.Eof do begin
          TxtWriteLine := SprLstBlockArticle.FieldByName ('IdtArticle').AsString
                     + ';' + SprLstBlockArticle.FieldByName ('TxtPublDescr').AsString
                     + ';' + SprLstBlockArticle.FieldByName ('DatBlocking').AsString;

           WriteLn(F, TxtWriteLine);
          SprLstBlockArticle.Next;
        end;
      System.Close(F);
      SprLstBlockArticle.Active := False;
    end;
    DecimalSeparator := ChrDecimalSep;

end;




initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun
