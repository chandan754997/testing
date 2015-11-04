//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet  : FlexPoint
// Customer: Castorama
// Unit    : FDetRptCarteCadeauCA.PAS : based on FDetGeneralCA (General
//                                      Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRptCarteCadeauCA.PAS.pas,v 1.8 2010/06/28 06:52:24 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetRptCarteCadeauCA.PAS - CVS revision 1.2
// 1.9  SMB (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
//==============================================================================

unit FDetRptCarteCadeauCA;

//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA, ExtDlgs;

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
  CtTxtTitle             = 'Carte Cadeau Report';
  CtTxtCardNumber        = 'Card Number';
  CtTxtBarCode           = 'Bar Code';
  CtTxtDescr             = 'Description';
  CtTxtDays              = 'Days';
  CtTxtDuration          = 'DaysValid';
  CtTxtDatModify         = 'Date Modify';

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
  TFrmDetRptCarteCadeauCA = class(TFrmDetGeneralCA)
    SprCACarteCadeau: TStoredProc;
    SavDlgExport: TSaveTextFileDialog;
    CmbAskSelection: TComboBox;
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  protected
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody   : string; override;
    function GetTxtTableTitle  : string; override;
    function GetTxtTitRapport  : string; override;
    function GetTxtRefRapport  : string; override;
    // Run params

  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure Execute; override;
  end;

var
  FrmDetRptCarteCadeauCA: TFrmDetRptCarteCadeauCA;

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
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetRptCarteCadeauCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 06:52:24 $';

//******************************************************************************
// Implementation of TFrmDetRptCarteCadeauCA
//******************************************************************************

function TFrmDetRptCarteCadeauCA.GetFmtTableHeader: string;


begin  // of TFrmDetRptCarteCadeauCA.GetFmtTableHeader
  Result := '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
end;   // of TFrmDetRptCarteCadeauCA.GetFmtTableHeader

//==============================================================================

function TFrmDetRptCarteCadeauCA.GetFmtTableBody: string;


begin  // of TFrmDetRptCarteCadeauCA.GetFmtTableBody
 Result := '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(22, False));
end;   // of TFrmDetRptCarteCadeauCA.GetFmtTableBody

//==============================================================================

function TFrmDetRptCarteCadeauCA.GetTxtTableTitle : string;
begin  // of TFrmDetRptCarteCadeauCA.GetTxtTableTitle
  Result :=   CtTxtCardNumber  + TxtSep +  CtTxtBarCode  + TxtSep +  CtTxtDescr  +
              TxtSep +  CtTxtDuration + TxtSep + CtTxtDatModify;
end;   // of TFrmDetRptCarteCadeauCA.GetTxtTableTitle)

//==============================================================================

function TFrmDetRptCarteCadeauCA.GetTxtTitRapport : string;
begin  // of TFrmDetRptCarteCadeauCA.GetTxtTitRapport
   Result := CtTxtTitle;

end;   // of TFrmDetRptCarteCadeauCA.GetTxtTitRapport

//==============================================================================

function TFrmDetRptCarteCadeauCA.GetTxtRefRapport : string;
begin  // of TFrmDetRptCarteCadeauCA.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0005';
end;   // of TFrmDetRptCarteCadeauCA.GetTxtRefRapport

//==============================================================================

procedure TFrmDetRptCarteCadeauCA.Execute;
begin  // of TFrmDetRptCarteCadeauCA.Execute


  SprCACarteCadeau.Active := True;


  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  If SprCACarteCadeau.RecordCount = 0 then
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                         clWhite, False)
  else
  PrintTableBody;
  SprCACarteCadeau.Active := False;  
  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetRptCarteCadeauCA.Execute

//==============================================================================

procedure TFrmDetRptCarteCadeauCA.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetRptCarteCadeauCA.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + ' ' +  DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr +
             CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetRptCarteCadeauCA.PrintHeader

//==============================================================================

procedure TFrmDetRptCarteCadeauCA.PrintTableBody;
var
  TxtPrintLine        : string;           // String to print

begin  // of TFrmDetRptCarteCadeauCA.PrintTableBody
  //inherited;

  VspPreview.TableBorder := tbBoxColumns;


  while not SprCACarteCadeau.Eof do begin
   VspPreview.StartTable;
  TxtPrintLine :=
                     SprCACarteCadeau.FieldByName ('IdtArtCode').AsString
                     + TxtSep + SprCACarteCadeau.FieldByName ('CardBarCode').AsString
                     + TxtSep + SprCACarteCadeau.FieldByName ('TxtPublDescr').AsString
                     + TxtSep + SprCACarteCadeau.FieldByName ('DaysValid').AsString
                     + TxtSep + SprCACarteCadeau.FieldByName ('DatModify').AsString;
                VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,clWhite,False);

           VspPreview.EndTable;

           SprCACarteCadeau.Next;
    end;








end;   // of TFrmDetRptCarteCadeauCA.PrintTableBody


//==============================================================================

procedure TFrmDetRptCarteCadeauCA.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetRptCarteCadeauCA.BtnPrintClick

  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else if (DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayto.Date := Now;
      MessageDlg (Format (CtTxtMaxDays,
                  [IntToStr(CtMaxNumDays)]), mtWarning, [mbOK], 0);
  end
  else begin 
     FlgPreview := (Sender = BtnPreview);
     Execute;
  end;
end;  // of TFrmDetRptCarteCadeauCA.BtnPrintClick


//==============================================================================

procedure TFrmDetRptCarteCadeauCA.FormCreate(Sender: TObject);
var
  TxtParam               : string;
begin
  inherited;
  Self.Caption := CtTxtTitle;
  TxtParam := FindRunParam(TxtParam);
end;

//==============================================================================

procedure TFrmDetRptCarteCadeauCA.BtnExportClick(Sender: TObject);
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
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                      //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
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
      SprCACarteCadeau.Active := True;
      SprCACarteCadeau.First;
     if SprCACarteCadeau.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
        while not SprCACarteCadeau.Eof do begin
          TxtWriteLine := SprCACarteCadeau.FieldByName ('IdtArtCode').AsString
                     + ';' + SprCACarteCadeau.FieldByName ('CardBarCode').AsString
                     + ';' + SprCACarteCadeau.FieldByName ('TxtPublDescr').AsString
                     + ';' + SprCACarteCadeau.FieldByName ('DaysValid').AsString
                     + ';' + SprCACarteCadeau.FieldByName ('DatModify').AsString;

           WriteLn(F, TxtWriteLine);
          SprCACarteCadeau.Next;
        end;
      System.Close(F);
      SprCACarteCadeau.Active := False;
    end;
    DecimalSeparator := ChrDecimalSep;

end;




initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun
