//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Castorama
// Unit     :FDetCatalogueInput.pas : Report for catalogue input by the operator
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version   Modified by  Reason
// V 1.0     MeD   (TCS)    R2014.2.16140-Export_Excel_Features.BDES
//=============================================================================

unit FDetInvoiceExtract;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE,
  ScUtils, SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables,
  FDetGeneralCA, ExtDlgs;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

const
  CtMaxNumDays         =  30;
//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // of header.
  CtTxtTitle            = 'Invoice Extract';
  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';

resourcestring     // of table header.
  CtTxtInvNumber        = 'INVOICE NUMBER';
  CtTxtInvDate          = 'INVOICE DATE';
  CtTxtCIF              = 'CIF NUMBER';
  CtTxtCustName         = 'CUSTOMER NAME';
  CtTxtInvAmount        = 'INVOICE AMOUNT';
  CtTxtTickNumber       = 'TICKET NUMBER';
  CtTxtTickDate         = 'TICKET DATE';
  CtTxtTickAmount       = 'TICKET AMOUNT';
  CtTxtNoData           = 'NO DATA IN THIS DATARANGE';

resourcestring          // of date errors
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtMaxDays          = 'Selected daterange may not contain more than %s days';
  CtTxtErrorHeader      = 'Incorrect Date';

resourcestring // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetInvoiceExtract = class(TFrmDetGeneralCA)
    SprRptInvExtrct: TStoredProc;
    SavDlgExport: TSaveTextFileDialog;
    BtnExport: TSpeedButton;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  Protected
    function GetTxtTableTitle  : string; override;
  public
    { Public declarations }
    procedure Execute; override;
  end;

var
  FrmDetInvoiceExtract: TFrmDetInvoiceExtract;
  Totalvalinv: integer;

//*****************************************************************************

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,
  DFpnTradeMatrix;
 // DFpnPosTransaction;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source:';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 09:50:31 $';

//*****************************************************************************
// Implementation of TFrmDetCancelLines
//*****************************************************************************
//=============================================================================

procedure TFrmDetInvoiceExtract.Execute;
begin  // of TFrmDetCancelLines.Execute
 BtnExportClick(BtnExport);
end;   // of TFrmDetInvoiceExtract.Execute

//=============================================================================

function TFrmDetInvoiceExtract.GetTxtTableTitle : string;
begin  // of TFrmDetCAEtatCodesInconnus.GetTxtTableTitle
 Result :=   CtTxtInvNumber  + TxtSep +  CtTxtInvDate  + TxtSep +  CtTxtCIF  +
              TxtSep + CtTxtCustName + TxtSep + CtTxtInvAmount + TxtSep + CtTxtTickNumber
              + TxtSep +  CtTxtTickDate + TxtSep + CtTxtTickAmount;
end;

//=============================================================================
// BtnExportClick : generate required report in excel format
//=============================================================================
procedure TFrmDetInvoiceExtract.BtnExportClick(Sender: TObject);

var
  TxtTitles           : string;
  TxtWriteLine        : string;
  Current             : string;
  TxtDatFormat        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  NumDupliInvNum      : integer;


begin // of TFrmDetInvoiceExtract.BtnExportClick
  NumDupliInvNum  := 0;
  //set focus to other fields than on datefields
  QryHlp := TQuery.Create(self);
  TxtDatFormat := CtTxtDatFormat;
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                    
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  //ChkLbxOperator.SetFocus;
  // Check is DayFrom < DayTo
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
     (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckDayTo.Date      := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date   := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date    := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date    := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else if (DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays) or
          (DtmPckLoadedTo.Date - DtmPckLoadedFrom.Date > CtMaxNumDays) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayto.Date   := Now;
    Application.MessageBox(PChar(Format(CtTxtMaxDays, [IntToStr(CtMaxNumDays)])),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
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
    TxtWriteLine := TxtWriteLine + Format (CtTxtReportDate,
                   [FormatDateTime (TxtDatFormat, DtmPckDayFrom.Date),
                     FormatDateTime (TxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
    //TxtWriteLine := TxtWriteLine + Format (CtTxtPrintDate,
    //               [FormatDateTime (TxtDatFormat, Now),
    //                FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
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
      SprRptInvExtrct.Active := False;
      SprRptInvExtrct.Prepare;
      SprRptInvExtrct.ParamByName('@PrmTxtFrom').AsString :=
        FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
        FormatDateTime(ViTxtDBHouFormat, 0);
      SprRptInvExtrct.ParamByName('@PrmTxtTo').AsString :=
        FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
        FormatDateTime(ViTxtDBHouFormat, 0);
      SprRptInvExtrct.Active := True;
      SprRptInvExtrct.First;
      if SprRptInvExtrct.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else

        while not SprRptInvExtrct.Eof do begin
          TxtWriteLine := '';
          Current := SprRptInvExtrct.FieldByName('InvoiceNumber').AsString;

          if (NumDupliInvNum = 0 ) then
          TxtWriteLine := TxtWriteLine +
            SprRptInvExtrct.FieldByName('InvoiceNumber').AsString + ';' +
            SprRptInvExtrct.FieldByName('InvoiceDate').AsString + ';' +
            SprRptInvExtrct.FieldByName('CIF').AsString + ';' +
            SprRptInvExtrct.FieldByName('CustomerName').AsString + ';' +
            SprRptInvExtrct.FieldByName('InvoiceAmount').AsString + ';'+
            SprRptInvExtrct.FieldByName('TicketNumber').AsString +';'+
            SprRptInvExtrct.FieldByName('TicketDate').AsString + ';'+
            SprRptInvExtrct.FieldByName('TicketAmount').AsString + ';'
          else
            TxtWriteLine := TxtWriteLine +
            '' + ';' +
            '' + ';' +
            '' + ';' +
            '' + ';' +
            '' + ';' +
            SprRptInvExtrct.FieldByName('TicketNumber').AsString +';'+
            SprRptInvExtrct.FieldByName('TicketDate').AsString + ';'+
            SprRptInvExtrct.FieldByName('TicketAmount').AsString + ';';
          WriteLn(F, TxtWriteLine);
          SprRptInvExtrct.Next;
          if (Current = SprRptInvExtrct.FieldByName('InvoiceNumber').AsString) then
            NumDupliInvNum := NumDupliInvNum + 1
          else
            NumDupliInvNum := 0 ;
       end;
      System.Close(F);
    end;
    DecimalSeparator := ChrDecimalSep;
  end;
end; // of TFrmDetInvoiceExtract.BtnExportClick

//=============================================================================

procedure TFrmDetInvoiceExtract.FormCreate(Sender: TObject);
begin // of TFrmDetInvoiceExtract.FormCreate
  inherited;
 application.Title := CtTxtTitle;
end; // of TFrmDetInvoiceExtract.FormCreate

//=============================================================================

procedure TFrmDetInvoiceExtract.FormPaint(Sender: TObject);
begin // of TFrmDetInvoiceExtract.FormPain
  inherited;
 BtnSelectAllClick(Self)
end; // of TFrmDetInvoiceExtract.FormPain

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetCancelLines


