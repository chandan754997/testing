//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Brico Depot
// Unit     : FDetCAEtatRetTickPayInfo.pas :  ID26040-PaymentMethodReturn-BDES
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version     Modified by     Reason
// 1.0         SN  (TCS)       R2013.1-ID26040-PaymentMethodReturn-BDES
// 1.1         SC  (TCS)       R2013.1 Defect fix 29(SC)
// 1.2         SMB (TCS)       R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================
unit FDetCAEtatRetTickPayInfo;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA, ExtDlgs;

//*****************************************************************************
// Global definitions
//*****************************************************************************


//==============================================================================
// Resource strings
//==============================================================================

resourcestring          // of header
  CtTxtTitle            = 'List of Reimbursement payment modes';                //R2013.1-defect 807-Fix(SN)--end
  CtTxtRptTitle         = 'Reimbursement Payment Mode Report';                  //R2013.1-defect 807-Fix(SN)--end
resourcestring          // of table header.

  CtTxtPrintDate        = 'Printed on %s at %s';
  CtTxtReportDate       = 'Report from %s to %s';
  CtTxtNumOpr           = 'No Operator';
  CtTxtNumCashDesk      = 'CashDesk';
  CtTxtDate             = 'Date';
  CtTxtNumTick          = 'Ticket Number';
  CtTxtSalePayMode      = 'Sales';
  CtTxtRetPayMode       = 'Return';
  CtTxtAmtReturned      = 'Amount';
  CtTxtAuthName         = 'Authorised By';
  CtTxtNoData           = 'No data exist';
  CtTxtSelectedRptType  = 'Selected Report Type:';

  //report selection validation messages
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';

  //Report Types
  CtTxtAll              = 'All';
  CtTxtCash             = 'Cash';
  CtTxtTarjeta          = 'Card Payment';

  //Export to Excel Parameters
  CtTxtExists           = 'File exists, Overwrite?';
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
type
  TFrmDetCAEtatRetTickPayInfo = class(TFrmDetGeneralCA)
    CARetTickPayInfo: TStoredProc;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    CmbxRptType: TComboBox;
    LblSelect: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  protected
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTitRapport : string; override;
    function GetTxtTableTitle: string; override;
  private
    { Private declarations }
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure Execute; override;
   procedure SetGeneralSettings; override;
  end;

var
  FrmDetCAEtatRetTickPayInfo: TFrmDetCAEtatRetTickPayInfo;
  var
    OprString : string;
    RptType   : integer;

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnTradeMatrix;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAEtatRetTickPayInfo';

const  // CVS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 1.2 $';
  CtTxtSrcDate                = '$Date: 2014/03/06 09:55:26 $';
//*****************************************************************************
// Implementation of TFrmDetCAEtatRetTickPayInfo
//*****************************************************************************

function TFrmDetCAEtatRetTickPayInfo.GetFmtTableHeader: string;
begin  // of TFrmDetCAEtatRetTickPayInfo.GetFmtTableHeader

  Result := '^+' + IntToStr(CalcWidthText(20, False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(6, False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(11, False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));         //R2013.1-defect 828-Fix(SN)
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(7,False));
  Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(20,False));
end;   // of TFrmDetCAEtatRetTickPayInfo.GetFmtTableHeader

//=============================================================================

function TFrmDetCAEtatRetTickPayInfo.GetFmtTableBody: string;
begin // of  TFrmDetCAEtatRetTickPayInfo.GetFmtTableBody

    Result := '<' + IntToStr(CalcWidthText(20, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(6, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(9, False));        //R2013.1-defect 828-Fix(SN)
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(7, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(20, False));

end;   // of TFrmDetCAEtatRetTickPayInfo.GetFmtTableBody

//=============================================================================

function TFrmDetCAEtatRetTickPayInfo.GetTxtTitRapport : string;
begin  // of TFrmDetCAEtatRetTickPayInfo.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCAEtatRetTickPayInfo.GetTxtTitRapport

//=============================================================================

function TFrmDetCAEtatRetTickPayInfo.GetTxtTableTitle: string;
begin // of  TFrmDetCAEtatRetTickPayInfo.GetTxtTableTitle

    Result :=
      CtTxtNumOpr      + TxtSep +
      CtTxtNumCashDesk + TxtSep +
      CtTxtDate        + TxtSep +
      CtTxtNumTick     + TxtSep +
      CtTxtSalePayMode + TxtSep +
      CtTxtRetPayMode  + TxtSep +
      CtTxtAmtReturned + TxtSep +
      CtTxtAuthName
end; // of  TFrmDetCAEtatRetTickPayInfo.GetTxtTableTitle

//=============================================================================

procedure TFrmDetCAEtatRetTickPayInfo.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAEtatRetTickPayInfo.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF ;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
  //R2013.1-defect 807-Fix(SN)--Start
  case RptType of
    1:TxtHdr := TxtHdr + CtTxtSelectedRptType + CtTxtAll;
    2:TxtHdr := TxtHdr + CtTxtSelectedRptType + CtTxtCash;                      //R2013.1-defect 829-Fix(SN)
    3:TxtHdr := TxtHdr + CtTxtSelectedRptType + CtTxtTarjeta;                   //R2013.1-defect 829-Fix(SN)    
  end; 
  //R2013.1-defect 807-Fix(SN)--end

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAEtatRetTickPayInfo.PrintHeader

//=============================================================================

procedure TFrmDetCAEtatRetTickPayInfo.PrintTableBody;
var
  TxtLine    : string;
  StrPrevOpr : string;

begin  // of TFrmDetCAEtatRetTickPayInfo.PrintTableBody
  VspPreview.TableBorder := tbBoxColumns;
  StrPrevOpr             := CARetTickPayInfo.FieldByName('idtoperatorrettick').AsString;
  while not CARetTickPayInfo.Eof do begin
    if StrPrevOpr = CARetTickPayInfo.FieldByName('idtoperatorrettick').AsString then begin
    VspPreview.StartTable;
    TxtLine := CARetTickPayInfo.FieldByName('idtoperatorrettick').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('idtcheckout').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('datetrans').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('retticknum').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('salespaymode').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('rettickpaymode').AsString
               + TxtSep + FormatFloat('0.00', CARetTickPayInfo.FieldByName('AmntReturned').AsFloat)//R2013.1 Defect fix 29(SC)
               + TxtSep + CARetTickPayInfo.FieldByName('IdtOprRetTickAuth').AsString;
    VspPreview.AddTable(FmtTableBody, '', TxtLine,clWhite,clWhite,False);
    VspPreview.EndTable;

    end
    else
      begin
    VspPreview.AddTable(FmtTableBody, ' ', '', clLtGray,clLtGray,False);
    VspPreview.StartTable;
    TxtLine := CARetTickPayInfo.FieldByName('idtoperatorrettick').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('idtcheckout').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('datetrans').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('retticknum').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('salespaymode').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('rettickpaymode').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('AmntReturned').AsString
               + TxtSep + CARetTickPayInfo.FieldByName('IdtOprRetTickAuth').AsString;
    VspPreview.AddTable(FmtTableBody, '', TxtLine,clWhite,clWhite,False);
    VspPreview.EndTable;

      end;
    StrPrevOpr := CARetTickPayInfo.FieldByName('idtoperatorrettick').AsString;
    CARetTickPayInfo.Next;

  end;
end;  //of TFrmDetCAEtatRetTickPayInfo.PrintTableBody

//=============================================================================

procedure TFrmDetCAEtatRetTickPayInfo.Execute;
var
  CntIx     : integer;
  tempstr   : string;
  Strposi   : integer;
begin  //of TFrmDetCAEtatRetTickPayInfo.Execute
  RptType := 1;
  OprString := '';                                                              //R2013.1-defect 806-Fix(SN)
  SetGeneralSettings;
  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      tempstr:='';
      tempstr := ChkLbxOperator.Items[CntIx];
      Strposi := pos(':',tempstr);
      Delete(tempstr,Strposi-1,Length(tempstr)-Strposi + 2);
      OprString:=OprString+ tempstr +',';
    end;
  end;
  Delete(OprString,Length(OprString),1);
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
  (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date)then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now)then begin
    DtmPckDayFrom.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture),
                           PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    if (CmbxRptType.Text = CtTxtAll) then
      RptType := 1
    else if (CmbxRptType.Text = CtTxtCash) then
      RptType := 2
    else if (CmbxRptType.Text =  CtTxtTarjeta) then
      RptType := 3;

    CARetTickPayInfo.Active := False;
    CARetTickPayInfo.ParamByName('@OperatorSequence').AsString := OprString;
    CARetTickPayInfo.ParamByName('@DateFrom').AsString :=
      FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
      FormatDateTime (ViTxtDBHouFormat, 0);
    CARetTickPayInfo.ParamByName ('@DateTo').AsString :=
      FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
      FormatDateTime (ViTxtDBHouFormat, 0);
    CARetTickPayInfo.ParamByName('@ReportType').AsInteger := RptType;
    CARetTickPayInfo.Active := True;
    VspPreview.Orientation := orLandscape;
    VspPreview.StartDoc;
    if (CARetTickPayInfo.RecordCount = 0) then
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                           clWhite, False)
    else
      PrintTableBody;
      PrintTableFooter;
      VspPreview.EndDoc;

      PrintPageNumbers;
      PrintReferences;

    if FlgPreview then
      FrmVSPreview.Show
    else
      VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  end;
end; //of TFrmDetCAEtatRetTickPayInfo.Execute

//=============================================================================

 procedure TFrmDetCAEtatRetTickPayInfo.BtnExportClick(Sender: TObject);
var
  TxtTitles              : string;
  TxtWriteLine           : string;
  counter                : integer;
  F                      : System.Text;
  Strposi                : integer;
  tempstr                : string;
  ChrDecimalSep          : char;
  Btnselect              : integer;
  FlgOK                  : Boolean;
  TxtPath                : String;
  QryHlp                 : TQuery;
  CntIx                  : integer;

begin // of TFrmDetCAEtatRetTickPayInfo.BtnExportClick
  //R2013.1-defect 809-Fix(SN)--Start
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  //R2013.1-defect 809-Fix(SN)--End
  QryHlp              := TQuery.Create(self);
  QryHlp.DatabaseName := 'DBFlexPoint';
  QryHlp.Active       := False;
  QryHlp.SQL.Clear;
  QryHlp. SQL.Add('select * from ApplicParam' +
                ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
  try
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  RbtDateDay.SetFocus;
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg(CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg(CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayTo.Date := Now;
    MessageDlg(CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
    ChrDecimalSep := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
    TxtWriteLine := CtTxtTitle + CRLF+ CRLF;
    TxtWriteLine := TxtWriteLine + DmdFpnUtils.TradeMatrixName + CRLF ;
    TxtWriteLine := TxtWriteLine + DmdFpnTradeMatrix.InfoTradeMatrix [
                  DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
    TxtWriteLine := TxtWriteLine + Format (CtTxtReportDate,
                  [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
                  FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
    TxtWriteLine := TxtWriteLine + Format (CtTxtPrintDate,
                  [FormatDateTime (CtTxtDatFormat, Now),
                  FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF;
    if (CmbxRptType.Text = CtTxtAll) then
      RptType := 1
    else if (CmbxRptType.Text = CtTxtCash) then
      RptType := 2
    else if (CmbxRptType.Text = CtTxtTarjeta) then
      RptType := 3;

    case RptType of
      1:TxtWriteLine := TxtWriteLine +  CtTxtSelectedRptType + CtTxtAll + CRLF + CRLF;
      2:TxtWriteLine := TxtWriteLine + CRLF + CtTxtSelectedRptType + CtTxtCash + CRLF + CRLF;
      3:TxtWriteLine := TxtWriteLine + CRLF + CtTxtSelectedRptType + CtTxtTarjeta + CRLF + CRLF;                   
    end;
    for counter := 1 to Length(TxtTitles) do
      if TxtTitles[counter] = '|' then
        TxtWriteLine := TxtWriteLine + ';'
      else
        TxtWriteLine := TxtWriteLine + TxtTitles[counter];
    repeat
      Btnselect := mrOk;
      FlgOK := SavDlgExport.Execute;
      if FileExists(SavDlgExport.FileName) and FlgOK then
        Btnselect := MessageDlg(CtTxtExists,mtError, mbOKCancel,0);
      if not FlgOK then
        Btnselect := mrOK;
    until Btnselect = mrOk;
    if (CmbxRptType.Text = CtTxtAll) then
      RptType := 1
    else if (CmbxRptType.Text = CtTxtCash) then
      RptType := 2
    else if (CmbxRptType.Text = CtTxtTarjeta) then
      RptType := 3;
    for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
      if ChkLbxOperator.Checked [CntIx] then begin
        tempstr:='';
        tempstr := ChkLbxOperator.Items[CntIx];
        Strposi := pos(':',tempstr);
        Delete(tempstr,Strposi-1,Length(tempstr)-Strposi + 2);
        OprString:=OprString+ tempstr +',';
      end;
    end;
    if FlgOK then begin
      System.Assign(F, SavDlgExport.FileName);
      Rewrite(F);
      WriteLn(F, TxtWriteLine);
      CARetTickPayInfo.Active := False;
      CARetTickPayInfo.Prepare;
      CARetTickPayInfo.ParamByName('@OperatorSequence').AsString := OprString;
      CARetTickPayInfo.ParamByName('@DateFrom').AsString :=
        FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
        FormatDateTime (ViTxtDBHouFormat, 0);
      CARetTickPayInfo.ParamByName ('@DateTo').AsString :=
        FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
        FormatDateTime (ViTxtDBHouFormat, 0);
      CARetTickPayInfo.ParamByName('@ReportType').AsInteger := RptType;
      CARetTickPayInfo.Active := True;
      CARetTickPayInfo.First;

      if CARetTickPayInfo.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else

        while not CARetTickPayInfo.Eof do begin
          TxtWriteLine := '';
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('IdtOperatorRetTick').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('idtcheckout').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('datetrans').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('retticknum').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('salespaymode').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('rettickpaymode').AsString + ';' ;
          TxtWriteLine := TxtWriteLine +                         
                          FormatFloat('0.00', CARetTickPayInfo.FieldByName('AmntReturned').AsFloat) + ';' ;//R2013.1 Defect fix 29(SC)
          TxtWriteLine := TxtWriteLine +
                          CARetTickPayInfo.FieldByName('IdtOprRetTickAuth').AsString+ ';';
          WriteLn(F, TxtWriteLine);
          CARetTickPayInfo.Next;
        end;
        System.Close(F);

    end;
    DecimalSeparator := ChrDecimalSep;
  end;
end; // of TFrmDetCAEtatCodesInconnus.BtnExportClick

//=============================================================================

procedure TFrmDetCAEtatRetTickPayInfo.FormCreate(Sender: TObject);
begin  //of TFrmDetCAEtatRetTickPayInfo.FormCreate
  inherited;
  //Make unnecessary parent components invisible
  DtmPckLoadedFrom.Visible := False;
  DtmPckLoadedTo.Visible   := False;
  SvcDBLblDateLoadedFrom.Visible := False;
  SvcDBLblDateLoadedTo.Visible   := False;
  RbtDateLoaded.Visible    := False;
  BtnExport.Visible := True;
  // Set the report title
  //Self.Caption := CtTxtTitle;//commented for //R2013.1-defect 807-Fix(SN)--end
  Application.Title := CtTxtRptTitle;//R2013.1-defect 807-Fix(SN)--end
  Self.Caption := CtTxtRptTitle;//R2013.1-defect 807-Fix(SN)--end
  //Populate Report type combo box
  CmbxRptType.Items.Add(CtTxtAll);
  CmbxRptType.Items.Add(CtTxtCash);
  CmbxRptType.Items.Add(CtTxtTarjeta);
  CmbxRptType.ItemIndex := 0;                                                   //R2013.1-defect 805-Fix(SN)
end;  //of TFrmDetCAEtatRetTickPayInfo.FormCreate

//=============================================================================
 //SetGeneralSettings need to be override to adjust the position of
 //VspPreview.MarginTop
 //============================================================================
procedure TFrmDetCAEtatRetTickPayInfo.SetGeneralSettings;
begin  // of TFrmDetCAEtatRetTickPayInfo.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  VspPreview.MarginTop := 2900;

  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtTxtLogoName;
end;   // of TFrmDetCAEtatRetTickPayInfo.SetGeneralSettings
 //============================================================================
end.
