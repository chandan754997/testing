//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Unit     : FRptOprReinitialise.PAS : Operator Reinitialise Report
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version    Created by                     Reason
// 1.0        A.M.(TCS)      Initial version created  for Operator Reinitialise Report in R2012.1
// 2.0        SMB (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================

unit FRptOprReinitialise;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, StdCtrls,cxControls, cxContainer,cxEdit,cxTextEdit,
  cxMaskEdit, ScUtils_Dx, Menus, ImgList, ActnList, ExtCtrls,ScAppRun, ScEHdler,
  Buttons, CheckLst, ComCtrls, ScDBUtil_BDE,SmVSPrinter7Lib_TLB, Db, DBTables,
  ExtDlgs;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Constants
//=============================================================================

const

 CtTxtHouFormat             = 'hh:mm';       // Default hour-format
 CtMaxNumDays               = 30;           //  Default Max no. of days

//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // of header.
 CtTxtReportDate            = 'Report from %s to %s';
 CtTxtPrintDate             = 'Printed on %s at %s';
 CtTxtAppTitle              = 'Operator Reinitialise Report';
 CtTxtTitList               = 'Report :Operator Reinitialise Report';

 resourcestring // for table header of the document.

 CtTxtDate                  = 'Date of Action';
 CtTxtOperaorNo             = 'No. Operator';
 CtTxtOperaorName           = 'Name Operator';
 CtTxtSupervisorNo          = 'No. Supervisor';
 CtTxtSupervisorName        = 'Name Supervisor';
 CtTxtSupervisor            = 'Support';

 resourcestring          // of date errors
 CtTxtStartEndDate          = 'Startdate is after enddate!';
 CtTxtStartFuture           = 'Startdate is in the future!';
 CtTxtEndFuture             = 'Enddate is in the future!';

 resourcestring
 CtTxtSubTot                = 'SubTotal';
 CtTxtTotal                 = 'Total';
 CtTxtPreview               = 'Preview';
 CtTxtExists                = 'File exists, Overwrite?';
 CtTxtPlace                 = 'D:\sycron\transfertbo\excel';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

 type
    TFrmRptOprReinitialise = class(TFrmDetGeneralCA)
    Preview1: TMenuItem;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    procedure BtnExportClick(Sender: TObject);
    procedure Preview1Click(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    private
    { Private declarations }

    protected
    { Protected declarations }

    function GetTxtTitRapport: string; override;
    function GetTxtTableTitle: string; override;
    function GetFmtTableHeader: string; override;
    function GetFmtTableBody: string; override;
    function BuildSQLReinitialise: string;

    public
     { Public declarations }


    procedure PrintHeader;override;
    procedure PrintSubTotal(SubTotCount   : Integer);
    procedure PrintTotal(TotCount : Integer);


    procedure PrintTableBody; override;
    procedure Execute; override;
  end;

var
  FrmRptOprReinitialise: TFrmRptOprReinitialise;

//*****************************************************************************

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
  CtTxtModuleName             = 'FRptOprReinitialise';

const // PVCS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 2.0 $';
  CtTxtSrcDate                = '$Date: 2014/03/06 18:40:26 $';

//*****************************************************************************
// Implementation of TFrmRptIntracomSales
//*****************************************************************************

procedure TFrmRptOprReinitialise.FormCreate(Sender: TObject);
begin   // of TFrmRptOprReinitialise.FormCreate
  inherited;
  DtmPckLoadedFrom.Visible := False;
  DtmPckLoadedTo.Visible := False;
  RbtDateDay.Visible := False;
  RbtDateLoaded.Visible := False;
  SvcDBLblDateLoadedFrom.Visible := False;
  SvcDBLblDateLoadedTo.Visible := False;
  Panel1.Visible := False;
  FrmRptOprReinitialise.Height := 200;
  FrmRptOprReinitialise.Width := 477;
  FrmRptOprReinitialise.Caption := CtTxtAppTitle;
  Application.Title:= CtTxtAppTitle;
end; // of TFrmRptOprReinitialise.FormCreate
//=============================================================================
procedure TFrmRptOprReinitialise.PrintHeader;
var
  TxtHdr                      : string; // Text stream for the header
begin // of TFrmRptOprReinitialise.PrintHeader
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr +
                 DmdFpnTradeMatrix.InfoTradeMatrix [
                 DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
                 DmdFpnTradeMatrix.InfoTradeMatrix [
                 DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'] + CRLF;


  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF+ CRLF;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo(Logo);
end; // of TFrmRptOprReinitialise.PrintHeader

//=============================================================================
function TFrmRptOprReinitialise.GetTxtTitRapport: string ;
begin // of  TFrmRptOprReinitialise.GetTxtTitRapport
    Result := CtTxtTitList
end; // of  TFrmRptOprReinitialise.GetTxtTitRapport

//=============================================================================
function TFrmRptOprReinitialise.GetTxtTableTitle: string;
begin // of  TFrmRptOprReinitialise.GetTxtTableTitle

    Result := CtTxtOperaorNo + TxtSep +
      CtTxtOperaorName  + TxtSep +
      CtTxtDate  + TxtSep +
      CtTxtSupervisorNo + TxtSep +
      CtTxtSupervisorName
end; // of  TFrmRptOprReinitialise.GetTxtTableTitle

//=============================================================================
function TFrmRptOprReinitialise.GetFmtTableHeader: string;
begin // of  TFrmRptOprReinitialise.GetFmtTableHeader

    Result := '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(20, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(20, False));

end; // of  TFrmRptOprReinitialise.GetFmtTableHeader

//=============================================================================

function TFrmRptOprReinitialise.GetFmtTableBody: string;
begin // of  TFrmRptOprReinitialise.GetFmtTableHeader

    Result := '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(20, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15 , False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(20, False));
end; // of  TFrmRptOprReinitialise.GetFmtTableBody

//=============================================================================

procedure TFrmRptOprReinitialise.PrintSubTotal (SubTotCount : Integer);
  var
  TxtLine          : string;           // Line to print
begin  // of TFrmRptOprReinitialise.PrintSubTotal
  VspPreview.StartTable;
  TxtLine :=
      CtTxtSubTot +  TxtSep + IntToStr(SubTotCount) + TxtSep +
      TxtSep + TxtSep + TxtSep;

  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
  VspPreview.EndTable;

end;   // of TFrmRptOprReinitialise.PrintSubTotal

//============================================================================

function TFrmRptOprReinitialise.BuildSQLReinitialise: string;
var
  TxtDateToLoad    : string;           // Sting that contains the date to load
begin  // of TFrmRptOprReinitialise.BuildSQLReinitialise
  TxtDateToLoad :=
      #10' DatModify BETWEEN ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
          AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date+ 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');

  Result :=
  #10'SELECT IdtOperator, ' +
  #10'       TxtNameOperator,        ' +
  #10'       Convert(VARCHAR(11),DatModify,103) AS DatModify,   ' +
  #10'       IdtSupervisor,       ' +
  #10'       TxtNameSupervisor  ' +
  #10'FROM OprReinitialise       ' +
  #10'Where ' +
      TxtDateToLoad +
  #10'ORDER BY IdtOperator,DatModify '  ;

end;
//=============================================================================
procedure TFrmRptOprReinitialise.PrintTableBody;
var
  TxtLine          : string;           // Line to print
  TotCount         : Integer;          // Counter for total line count
  SubOperatorPrev  : string;           // To store Operator name
  SubTotCount       : Integer;          // Counter for sub-total count
  SupervisorID      : string;
  SupervisorName    : string;

  begin  // of TFrmRptOprReinitialise.PrintTableBody
  inherited;
   TotCount := 0;
  try
    VspPreview.TableBorder := tbBoxColumns;

    if DmdFpnUtils.QueryInfo (BuildSQLReinitialise) then begin

      SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
      TotCount := 0;
      SubTotCount := 1;
      while not DmdFpnUtils.QryInfo.Eof do begin
         if DmdFpnUtils.QryInfo.FieldByName('IdtSupervisor').AsString = 'EXECUTEALL' then begin
          SupervisorID:=  CtTxtSupervisor;
          SupervisorName:= CtTxtSupervisor;
         end;
        VspPreview.StartTable;
        if DmdFpnUtils.QryInfo.FieldByName('IdtSupervisor').AsString = 'EXECUTEALL' then begin
          if TotCount = 0 then begin         //To print the first line
            TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + SupervisorID
                     + TxtSep + SupervisorName;
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
            VspPreview.EndTable;
          end
          else begin
           if SubOperatorPrev = DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString then begin
              TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + SupervisorID
                     + TxtSep + SupervisorName;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
              VspPreview.EndTable;
              SubTotCount := SubTotCount +1;
           end
           else begin
               TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + SupervisorID
                     + TxtSep + SupervisorName;
              PrintSubTotal(SubTotCount);
              SubTotCount := 1;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
              VspPreview.EndTable;
           end;
          end ;
        end
        else begin
            if TotCount = 0 then begin         //To print the first line
            TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtSupervisor').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameSupervisor').AsString;
            VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
            VspPreview.EndTable;
          end
          else begin
           if SubOperatorPrev = DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString then begin
              TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtSupervisor').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameSupervisor').AsString;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
              VspPreview.EndTable;
              SubTotCount := SubTotCount +1;
           end
           else begin
               TxtLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('IdtSupervisor').AsString
                     + TxtSep + DmdFpnUtils.QryInfo.FieldByName ('TxtNameSupervisor').AsString;
               PrintSubTotal(SubTotCount);
               SubTotCount := 1;
              VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);//format of the table
              VspPreview.EndTable;
            end;
          end ;
        end;
          SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
          TotCount:= TotCount + 1;
          DmdFpnUtils.QryInfo.Next;
      end ;  //of while
    end;
    PrintSubTotal(SubTotCount);
    PrintTotal(TotCount);
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmRptOprReinitialise.PrintTableBody

//=============================================================================

procedure TFrmRptOprReinitialise.BtnPrintClick(Sender: TObject);
begin    // of TFrmRptOprReinitialise.BtnPrintClick

  DtmPckDayTo.SetFocus;
  DtmPckDayFrom.SetFocus;
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
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
   FlgPreview := (Sender = BtnPreview);
   Execute;
  end;
end; // of TFrmRptOprReinitialise.BtnPrintClick
//=============================================================================

procedure TFrmRptOprReinitialise.Execute;
begin   // of TFrmRptOprReinitialise.Execute
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  PrintTableBody;
  PrintTableFooter;
  VspPreview.EndDoc;
  PrintPageNumbers;
  //PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  FrmVSPreview.OnActivate(Self);

end;  // of TFrmRptOprReinitialise.Execute
//=============================================================================
procedure TFrmRptOprReinitialise.PrintTotal(TotCount :Integer);
var
  TxtLine          : string;           // Line to print
begin   // of TFrmRptOprReinitialise.PrintTotal
  VspPreview.StartTable;
   TxtLine := ' ';
   VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
  VspPreview.EndTable;
  VspPreview.StartTable;
  TxtLine :=
       CtTxtTotal +  TxtSep + IntToStr(TotCount) + TxtSep +
      TxtSep + TxtSep + TxtSep;

  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);
  VspPreview.EndTable;
end; // of TFrmRptOprReinitialise.PrintTotal
//=============================================================================
procedure TFrmRptOprReinitialise.Preview1Click(Sender: TObject);
begin
  inherited;
  BtnPrintClick(BtnPreview);
end;
//=============================================================================
procedure TFrmRptOprReinitialise.BtnExportClick(Sender: TObject);
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
  TotCount            : Integer;          // Counter for total line count
  SubOperatorPrev     : string;           // To store Operator name
  SupervisorID      : string;
  SupervisorName    : string;

begin

  //set focus to other fields than on datefields
    QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if (QryHlp.FieldByName('TxtParam').AsString <> '') then                     //R2013.2.ALM Defect Fix 164.All OPCO.SMB.TCS
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  // Check is DayFrom < DayTo
   DtmPckDayTo.SetFocus;
  DtmPckDayFrom.SetFocus;
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
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtTitles := GetTxtTableTitle();
    TxtWriteLine := '';
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
     try
        if DmdFpnUtils.QueryInfo (BuildSQLReinitialise) then begin
          SubOperatorPrev         := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
          TotCount := 0;
      while not DmdFpnUtils.QryInfo.Eof do begin
         if DmdFpnUtils.QryInfo.FieldByName('IdtSupervisor').AsString = 'EXECUTEALL' then begin
          SupervisorID:=  CtTxtSupervisor;
          SupervisorName:= CtTxtSupervisor;
         end;
          if DmdFpnUtils.QryInfo.FieldByName('IdtSupervisor').AsString = 'EXECUTEALL' then begin
           if TotCount = 0 then begin         //To print the first line
            TxtWriteLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString + ';'+
                      SupervisorID + ';'+
                      SupervisorName;
            WriteLn(F, TxtWriteLine);
           end
           else begin
              TxtWriteLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString   + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString  + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString  + ';'+
                      SupervisorID  + ';'+
                      SupervisorName;
              WriteLn(F, TxtWriteLine);
            end
           end
          else begin
             if TotCount = 0 then begin         //To print the first line
               TxtWriteLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('IdtSupervisor').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameSupervisor').AsString;
                WriteLn(F, TxtWriteLine);
               end
               else begin
                   TxtWriteLine :=   DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameOperator').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('DatModify').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('IdtSupervisor').AsString + ';'+
                      DmdFpnUtils.QryInfo.FieldByName ('TxtNameSupervisor').AsString;
                 WriteLn(F, TxtWriteLine);
               end;
           end;

          SubOperatorPrev := DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString;
          TotCount:= TotCount + 1;
          DmdFpnUtils.QryInfo.Next;
      end ;  //of while
    end;
  finally
       DmdFpnUtils.CloseInfo;
       System.Close(F);
       DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;
//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent(CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
    CtTxtSrcDate);
end.  // of FRptOprReinitialise



