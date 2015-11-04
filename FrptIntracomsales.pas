//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Brico Depot
// Unit     : FRptIntracomsales.PAS : Report for Intracom Sales
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version   Modified by    Reason
// 1.0       S.M.(TCS)      Initial version created  for Intracom Sales Report in R2011.2
// 1.1       S.M.(TCS)      Regression Fix(R2011.2)
// 1.2       S.M.(TCS)      Regression Fix (SM)
// 1.3       S.M.(TCS)      Defect Fix 391 (SM) R2011.2
// 1.4       SRM.(TCS)      R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM
// 1.5       SMB (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================

unit FRptIntracomsales;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetGeneralCA, StdCtrls,cxControls, cxContainer,cxEdit,cxTextEdit,
  cxMaskEdit, ScUtils_Dx, Menus, ImgList, ActnList, ExtCtrls,ScAppRun, ScEHdler,
  Buttons, CheckLst, ComCtrls, ScDBUtil_BDE,SmVSPrinter7Lib_TLB, Db, DBTables,
  ExtDlgs;    																	//R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM

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
 CtTxtAppTitle              = 'Intracom Sales Report';
 CtTxtTitList               = 'Intracom Sales List';

 resourcestring // for table header of the document.

 CtTxtDate                  = 'Date';
 CtTxtFacture               = 'Invoice number';
 CtTxtTicket                = 'Ticket';
 CtTxtArticles              = 'Articles';
 CtTxtCAHT                  = 'Turnover excl. VAT';
 CtTxtStateNomclient        = 'Customer Name';
 CtTxtStateNumTVA           = 'Customer VAT number';
 CtTxtMoyenpaiement         = 'Means of payment';

 resourcestring          // of date errors
 CtTxtStartEndDate          = 'Startdate is after enddate!';
 CtTxtStartFuture           = 'Startdate is in the future!';
 CtTxtEndFuture             = 'Enddate is in the future!';
 CtTxtErrorHeader           = 'Incorrect Date';
 CtTxtMaxDays               = 'Selected daterange should not contain more then %s days';
 CtTxtNoData                = 'No data for this daterange';
 CtTxtPlace                 = 'D:\sycron\transfertbo\excel';                    //R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM
 CtTxtExists                = 'File exists, Overwrite?';                        //R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM


resourcestring
 CtTxtSubTot                = 'SubTotal';
 CtTxtTotal                 = 'Total';
 CtTxtFrom                  = 'From';
 CtTxtTo                    = 'To';
 CtTxtSalesDate             = 'Sales Date';
 CtTxtDepot                 = 'Depot:' ;
 CtTxtPreview               = 'Preview';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

 type
    TFrmRptIntracomSales = class(TFrmDetGeneralCA)
    IntracomSalesSpr :TStoredProc;                                              
    Label1: TLabel;
    Preview1: TMenuItem;
    SavDlgExport: TSaveTextFileDialog;                                          //R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM.Start
    BtnExport: TSpeedButton;
    procedure BtnExportClick(Sender: TObject);                                  //R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM.End
    procedure Preview1Click(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    private
    { Private declarations }

    protected
    { Protected declarations }

    function GetTxtTitRapport: string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTableTitle: string; override;
    function GetFmtTableHeader: string; override;
    function GetFmtTableBody: string; override;
    function FDOM(Date: TDateTime): TDateTime;
    function LDOM(Date: TDateTime): TDateTime;
    procedure AutoStart (Sender : TObject); override;
    public
     { Public declarations }


    procedure PrintHeader;override;
    procedure PrintSubTotal(QtyArticles   : Integer;
                            ValAmountVAT  : Currency);
    procedure PrintTotal(CounterInv : Integer;
                         TotQtyArticles : Integer;
                         TotValAmountVAT   : Currency);


    procedure PrintTableBody; override;
    procedure Execute; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
  end;

var
  FrmRptIntracomSales: TFrmRptIntracomSales;

//*****************************************************************************

implementation

uses
  DFpnTradeMatrix,
  DFpnUtils,
  smUtils,
  SmDBUtil_BDE,
  sfDialog,
  SfAutoRun;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const // Module-name
  CtTxtModuleName             = 'FRptIntracomSales';

const // PVCS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 1.5 $';
  CtTxtSrcDate                = '$Date: 2014/03/06 09:55:26 $';

//*****************************************************************************
// Implementation of TFrmRptIntracomSales
//*****************************************************************************

procedure TFrmRptIntracomSales.FormCreate(Sender: TObject);
begin   // of TFrmRptIntracomSales.FormCreate
  inherited;
  DtmPckLoadedFrom.Visible := False;
  DtmPckLoadedTo.Visible := False;
  RbtDateDay.Visible := False;
  RbtDateLoaded.Visible := False;
  SvcDBLblDateLoadedFrom.Visible := False;
  SvcDBLblDateLoadedTo.Visible := False;
  Panel1.Visible := False;
  FrmRptIntracomSales.Height := 260;
  FrmRptIntracomSales.Width := 477;
  FrmRptIntracomSales.Caption := CtTxtAppTitle;
  Application.Title := CtTxtAppTitle;                                    //Regression Fix (SM) R2011.2
end; // of TFrmRptIntracomSales.FormCreate

//=============================================================================
function TFrmRptIntracomSales.FDOM(Date: TDateTime): TDateTime;
  var
    Year, Month, Day: Word;
  begin  // of TFrmRptIntracomSales.FDOM
    DecodeDate(Date, Year, Month, Day);
    //Regression Fix(R2011.2) :: START
    if Month = 1 then begin
    dec(Year);
    Month:=12;
    Result := EncodeDate(Year, (Month), 1);
    end
    //Regression Fix(R2011.2) :: END
    else
    Result := EncodeDate(Year, (Month - 1), 1);
end;  // of TFrmRptIntracomSales.FDOM

//=============================================================================

function TFrmRptIntracomSales.LDOM(Date: TDateTime): TDateTime;
  var
    Year, Month, Day: Word;
  begin  // of TFrmRptIntracomSales.LDOM
    DecodeDate(Date, Year, Month, Day);
    //Regression Fix(R2011.2) :: START
   if Month = 1 then begin
    dec(Year);
    Month:=12;
    Result := EncodeDate(Year, Month, 31);
   end
   //Regression Fix(R2011.2) :: END
    else
    Result := EncodeDate(Year, Month, 1) - 1;
end;  // of TFrmRptIntracomSales.LDOM

//=============================================================================

procedure TFrmRptIntracomSales.PrintHeader;
var
  TxtHdr                      : string; // Text stream for the header
begin // of TFrmRptIntracomSales.PrintHeader
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'] + CRLF;

  TxtHdr := TxtHdr +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'] + CRLF +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip']+ CRLF +
             CtTxtDepot + DmdFpnUtils.IdtTradeMatrixAssort + CRLF ;


  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo(Logo);
end; // of TFrmRptIntracomSales.PrintHeader

//=============================================================================
function TFrmRptIntracomSales.GetTxtTitRapport: string ;
begin // of  TFrmRptIntracomSales.GetTxtTitRapport

    Result := CtTxtTitList
end; // of  TFrmRptIntracomSales.GetTxtTitRapport
//=============================================================================

function TFrmRptIntracomSales.GetFmtTableSubTotal : string;

begin  // of TFrmRptIntracomSales.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (12, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (9, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (9, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (23, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (28, False));

end;   // of TFrmRptIntracomSales.GetFmtTableSubTotal

//=============================================================================
function TFrmRptIntracomSales.GetTxtTableTitle: string;
begin // of  TFrmRptIntracomSales.GetTxtTableTitle

    Result := CtTxtDate + TxtSep +
      CtTxtFacture  + TxtSep +
      CtTxtTicket + TxtSep +
      CtTxtArticles + TxtSep +
      CtTxtCAHT + TxtSep +
      CtTxtStateNomclient + TxtSep +
      CtTxtStateNumTVA  + TxtSep +
      CtTxtMoyenpaiement


end; // of  TFrmRptIntracomSales.GetTxtTableTitle

//=============================================================================
function TFrmRptIntracomSales.GetFmtTableHeader: string;
begin // of  TFrmRptIntracomSales.GetFmtTableHeader

    Result := '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(23, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(28, False));


end; // of  TFrmRptIntracomSales.GetFmtTableHeader

//=============================================================================

function TFrmRptIntracomSales.GetFmtTableBody: string;
begin // of  TFrmRptIntracomSales.GetFmtTableHeader

    Result := '>' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '^' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^' + IntToStr(CalcWidthText(9 , False));
    Result := Result + TxtSep + '^' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '>' + IntToStr(CalcWidthText(9, False));
    Result := Result + TxtSep + '<' + IntToStr(CalcWidthText(23, False));
    Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(28, False));


end; // of  TFrmRptIntracomSales.GetFmtTableBody

//=============================================================================

procedure TFrmRptIntracomSales.PrintSubTotal (QtyArticles   : Integer;
                                              ValAmountVAT  : Currency);
  var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin  // of TFrmRptIntracomSales.PrintSubTotal
  VspPreview.StartTable;
  TxtLine :=
      CtTxtSubTot +  TxtSep + TxtSep + TxtSep +
      IntToStr(QtyArticles) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ValAmountVAT) + TxtSep +
      TxtSep + TxtSep;


  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
  //VspPreview.StartTable;


end;   // of TFrmRptIntracomSales.PrintSubTotal

//============================================================================

procedure TFrmRptIntracomSales.PrintTableBody;
var

  TxtLine          : string;           // Line to print
  QtyArticles      : integer;          // No of articles for a particular invoice
  ValAmountVAT     : currency;         // Value of price excl. VAT for a particular article
  InvoiceNum       : integer;          // Invoice Number
  CounterInv       : Integer;          // Counter for calculating the total number of invoices
  TotQtyArticles   : integer;          // Total No of articles
  TotValAmountVAT  : double;           // Total Value of price excl. VAT
  LineCount        : integer;          // Regression Fix R2011.2 (SM)


  begin  // of TFrmRptIntracomSales.PrintTableBody
  inherited;
  ValAmountVAT := 0.00;
  QtyArticles := 0;
  CounterInv := 0;
  TotQtyArticles := 0;
  TotValAmountVAT := 0;

  LineCount :=0;

  try

      VspPreview.TableBorder := tbBoxColumns;

      InvoiceNum := IntracomSalesSpr.FieldByName ('Idtinvoice').AsInteger;
      while not IntracomSalesSpr.Eof do begin

            if InvoiceNum<> IntracomSalesSpr.FieldByName ('Idtinvoice').AsInteger then begin
               PrintSubTotal (QtyArticles,ValAmountVAT);
               CounterInv := CounterInv + 1;
               TotQtyArticles := TotQtyArticles +  QtyArticles;
               TotValAmountVAT := TotValAmountVAT + ValAmountVAT;
               ValAmountVAT := IntracomSalesSpr.FieldByName ('ValExclVAT').AsFloat;
                {if IntracomSalesSpr.FieldByName('ValExclVAT').AsInteger < 0 then        // Regression Fix R2011.2 (SM) ::START   // Defect Fix 391 (SM) R2011.2 ::START
                QtyArticles := -1
                else
                QtyArticles := 1;}                                                                                                 // Defect Fix 391 (SM) R2011.2 ::END
                QtyArticles := IntracomSalesSpr.FieldByName ('Qtyreg').AsInteger;        // Defect Fix 391 (SM) R2011.2
                LineCount :=1;                                                          // Regression Fix R2011.2 (SM)
               InvoiceNum := IntracomSalesSpr.FieldByName ('Idtinvoice').AsInteger;
            end
            else begin
                  {if IntracomSalesSpr.FieldByName('ValExclVAT').AsInteger < 0 then begin      // Regression Fix R2011.2 (SM) ::START             // Defect Fix 391 (SM) R2011.2 ::START
                   if IntracomSalesSpr.FieldByName ('IdtArticle').AsString <> '' then begin
                   QtyArticles := QtyArticles -1
                   end;
                   end
                   else
                   if IntracomSalesSpr.FieldByName ('IdtArticle').AsString <> '' then begin
                   QtyArticles:= QtyArticles + 1 ;
                   end; }
                   LineCount:= LineCount + 1;                                            // Regression Fix R2011.2 (SM) :: END                    // Defect Fix 391 (SM) R2011.2 ::END
                   QtyArticles:= QtyArticles +  IntracomSalesSpr.FieldByName ('QtyReg').AsInteger;   // Defect Fix 391 (SM) R2011.2
                   ValAmountVAT := ValAmountVAT + IntracomSalesSpr.FieldByName ('ValExclVAT').AsFloat;
            end;

           
            VspPreview.StartTable;
           if LineCount > 1 then begin                                                  // Regression Fix R2011.2 (SM)
                     TxtLine := TxtSep + TxtSep + TxtSep +
                     IntracomSalesSpr.FieldByName ('IdtArticle').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('ValExclVAT').AsString
                     + TxtSep+ TxtSep+ TxtSep +IntracomSalesSpr.FieldByName ('TxtDescr').AsString  + TxtSep;

                VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,clWhite,False);
              end
              else begin
               TxtLine :=
                     IntracomSalesSpr.FieldByName ('DatTransBegin').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('IdtInvoice').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('IdtPostransaction').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('IdtArticle').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('ValExclVAT').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('TxtName').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('TxtNumVAT').AsString
                     + TxtSep + IntracomSalesSpr.FieldByName ('TxtDescr').AsString ;
                 VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,clWhite,False);
             end;

            VspPreview.EndTable;
          
           IntracomSalesSpr.Next;

         end;


          if(QtyArticles > 0) or (IntracomSalesSpr.FieldByName('ValExclVAT').AsInteger < 0) then begin    // Regression Fix R2011.2 (SM)
          PrintSubTotal (QtyArticles,ValAmountVAT);
          CounterInv := CounterInv + 1;
          TotQtyArticles := TotQtyArticles +  QtyArticles;
          TotValAmountVAT := TotValAmountVAT + ValAmountVAT;
          PrintTotal (CounterInv,TotQtyArticles,TotValAmountVAT);
          end


    finally
    DmdFpnUtils.CloseInfo;
  end;
end;  // of TFrmRptIntracomSales.PrintTableBody

                            
//=============================================================================

procedure TFrmRptIntracomSales.AutoStart(Sender: TObject);
begin // of TFrmRptIntracomSales.AutoStart
  inherited;
  DtmPckDayFrom.Date := (FDOM(NOW));
  DtmPckDayTo.Date := (LDOM(NOW));
end; // of TFrmRptIntracomSales.AutoStart

//=============================================================================
procedure TFrmRptIntracomSales.BtnPrintClick(Sender: TObject);
begin    // of TFrmRptIntracomSales.BtnPrintClick

  DtmPckDayTo.SetFocus;
  DtmPckDayFrom.SetFocus;
  // Check is DayFrom < DayTo
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := (FDOM(NOW));   
    DtmPckDayTo.Date := (LDOM(NOW));
    MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := (FDOM(NOW));
    DtmPckDayTo.Date := (LDOM(NOW));                                      //Regression Fix (SM) 2011.2
    MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayTo.Date := (LDOM(NOW));
    DtmPckDayFrom.Date := (FDOM(NOW));                                   //Regression Fix (SM) 2011.2
    MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays then begin
     DtmPckDayFrom.Date := (FDOM(NOW));   
     DtmPckDayTo.Date := (LDOM(NOW));
     Application.MessageBox(PChar(Format (CtTxtMaxDays,
                             [IntToStr(CtMaxNumDays)])),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
   FlgPreview := (Sender = BtnPreview);
   Execute;
  end;
end; // of TFrmRptIntracomSales.BtnPrintClick
//=============================================================================

procedure TFrmRptIntracomSales.Execute;
begin   // of TFrmRptIntracomSales.Execute

    IntracomSalesSpr.Active := False;
  IntracomSalesSpr.ParamByName ('@PrmDatFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  IntracomSalesSpr.ParamByName ('@PrmDatTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  IntracomSalesSpr.Active := True;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  If IntracomSalesSpr.RecordCount = 0 then
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
  FrmVSPreview.OnActivate(Self);

end;  // of TFrmRptIntracomSales.Execute
//=============================================================================
procedure TFrmRptIntracomSales.PrintTotal(CounterInv, TotQtyArticles: Integer;
  TotValAmountVAT: Currency);
var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin   // of TFrmRptIntracomSales.PrintTotal

  VspPreview.StartTable;
  TxtLine :=
       CtTxtTotal +  TxtSep + IntToStr(CounterInv) + TxtSep +  TxtSep +
      IntToStr(TotQtyArticles) + TxtSep +
      FormatFloat (CtTxtFrmNumber, TotValAmountVAT) + TxtSep +
      TxtSep + TxtSep;


  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
  //VspPreview.StartTable;

end; // of TFrmRptIntracomSales.PrintTotal
//=============================================================================
procedure TFrmRptIntracomSales.Preview1Click(Sender: TObject);
begin
  inherited;
  BtnPrintClick(BtnPreview);
end;
//=============================================================================
//R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM.Start
//=============================================================================
procedure TFrmRptIntracomSales.BtnExportClick(Sender: TObject);
var
 TxtTitles           : string;
  TxtWriteLine        : string;
  TxtDatFormat        : string;
  counter             : Integer;
  F                   : System.Text;
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  ClassString         : String;
  ExportExcel2DArray  : array of array of string;//2D array to collect and arrange data
  loopCntr1           : integer;                 // Array loop controls
  loopCntr2           : integer;                 //Array loop  controls
begin // of TFrmRptIntracomSales.BtnExportClick
  ExportExcel2DArray := nil;
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
  if DtmPckDayFrom.Date > DtmPckDayTo.Date then begin
    DtmPckDayFrom.Date := (FDOM(NOW));
    DtmPckDayTo.Date := (LDOM(NOW));
    MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
  end
  // Check if DayFrom is in the future
  else if DtmPckDayFrom.Date > Now then begin
    DtmPckDayFrom.Date := (FDOM(NOW));
    DtmPckDayTo.Date := (LDOM(NOW));
    MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
  end
  // Check if DayTo is in the future
  else if DtmPckDayTo.Date > Now then begin
    DtmPckDayTo.Date := (LDOM(NOW));
    DtmPckDayFrom.Date := (FDOM(NOW));                                   
    MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  else if DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays then begin
     DtmPckDayFrom.Date := (FDOM(NOW));
     DtmPckDayTo.Date := (LDOM(NOW));
     Application.MessageBox(PChar(Format (CtTxtMaxDays,
                             [IntToStr(CtMaxNumDays)])),
                             PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    ChrDecimalSep    := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    TxtWriteLine := '';
    Delete(ClassString,Length(ClassString),1);
    TxtWriteLine :=  TxtWriteLine + CtTxtTitList + CRLF;
    TxtWriteLine := TxtWriteLine + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtName'] + CRLF;

  TxtWriteLine := TxtWriteLine +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtStreet'] + CRLF +
             DmdFpnTradeMatrix.InfoTradeMatrix [
             DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip']+ CRLF +
             CtTxtDepot + DmdFpnUtils.IdtTradeMatrixAssort + CRLF ;
    TxtWriteLine := TxtWriteLine + Format (CtTxtReportDate,
                   [FormatDateTime (TxtDatFormat, DtmPckDayFrom.Date),
                     FormatDateTime (TxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
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
      IntracomSalesSpr.Active := False;
      IntracomSalesSpr.ParamByName ('@PrmDatFrom').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
      IntracomSalesSpr.ParamByName ('@PrmDatTo').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);

      IntracomSalesSpr.Active := True;
      
        IntracomSalesSpr.First;
      if IntracomSalesSpr.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else begin
        SetLength(ExportExcel2DArray, IntracomSalesSpr.RecordCount, 2);
        for loopCntr1 := 0 to (IntracomSalesSpr.RecordCount - 1) do begin
          ExportExcel2DArray[loopCntr1,0] := IntracomSalesSpr.FieldByName ('IdtInvoice').AsString;
          ExportExcel2DArray[loopCntr1,1] := IntracomSalesSpr.FieldByName ('TxtDescr').AsString;
          IntracomSalesSpr.next;
        end;
        loopCntr1 := 0;
        loopCntr2 := 0;
         try
           while loopCntr1 < (IntracomSalesSpr.RecordCount-1) do begin
             while loopCntr2 < (IntracomSalesSpr.RecordCount-1) do begin
               if ExportExcel2DArray[loopCntr1,0] = ExportExcel2DArray[loopCntr2+1,0] then begin
                 if ExportExcel2DArray[loopCntr1,1]= '' then
                   ExportExcel2DArray[loopCntr1,1] := ExportExcel2DArray[loopCntr2+1,1]
                 else
                  if ExportExcel2DArray[loopCntr2+1,1] = '' then
                   ExportExcel2DArray[loopCntr1,1] := ExportExcel2DArray[loopCntr1,1] 
                  else
                   ExportExcel2DArray[loopCntr1,1] := ExportExcel2DArray[loopCntr1,1] +','+ExportExcel2DArray[loopCntr2+1,1];
                 ExportExcel2DArray[loopCntr2+1,1] := '';
                 loopCntr2 := loopCntr2 + 1;
                 end
               else begin
                 loopCntr1 := loopCntr2 + 1;
                 loopCntr2 := loopCntr2 + 1;
               end
             end;
             if loopCntr2=(IntracomSalesSpr.RecordCount-1) then
             break;
           end;
         except
         on E: Exception do
           raise;
         end;
         IntracomSalesSpr.First;
         loopCntr1 :=0;
         while not IntracomSalesSpr.Eof do begin
           TxtWriteLine := '';
           TxtWriteLine := TxtWriteLine + IntracomSalesSpr.FieldByName ('DatTransBegin').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('IdtInvoice').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('IdtPostransaction').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('IdtArticle').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('ValExclVAT').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('TxtName').AsString
                     + ';' + IntracomSalesSpr.FieldByName ('TxtNumVAT').AsString
                     + ';' + ExportExcel2DArray[loopCntr1,1];
           loopCntr1 := loopCntr1 + 1;
           WriteLn(F, TxtWriteLine);
           IntracomSalesSpr.Next;
         end;
      end;
      System.Close(F);
    end;
    DecimalSeparator := ChrDecimalSep;
  end;
end; // of TFrmRptIntracomSales.BtnExportClick
//=============================================================================
//R2013.1.ID25080.Export.lexcel.Intracom.BDFR.TCS-SRM.End
//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent(CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
    CtTxtSrcDate);
end.  // of FRptIntracomSales



