//====== Copyright 2010 (c) Centric Retail Solutions. All rights reserved =====
// Packet  : Standard Development
// Customer: Castorama
// Unit    : FDetCAActiviteHoraire.PAS : based on FDetGeneralCA (General
//                                       Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAActiviteHoraire.pas,v 1.9 2010/02/23 14:48:09 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCAActiviteHoraire - CVS revision 1.14
// Version   Modified By     Reason
// 2.0       AM    (TCS)     R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
// 2.1       AM    (TCS)     Bug Fix for DefectID-65(BDES–Rapport_Activity_schedule_report-AM(TCS))
// 2.2       SRM   (TCS)     R2013.2.Req(32030).Hourly-activity-report
// 2.3       SMB   (TCS)     R2013.2.ALM Defect Fix 164.All OPCO
// 2.4       SPN   (TCS)     R2014.1.Req(42010).Detailed hourly activity 2424
// 2.5       SRM   (TCS)     R2014.1.Req(42010).Detailed hourly activity 2424
// 2.6       RC    (TCS)     R2014.1.ALM Defect Fix 178.All OPCO
// 2.7   	 RC    (TCS)     R2014.1.Enhancement 184
//==============================================================================

unit FDetCAActiviteHoraire;

//******************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, ScDBUtil_BDE, ScUtils,
  SfVSPrinter7, SmVSPrinter7Lib_TLB, Db, DBTables, FDetGeneralCA,DFpnUtils,
  DBCtrls, ExtDlgs,IniFiles;                                                             // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)//Shibashish

//******************************************************************************
// Global definitions
//******************************************************************************
const              // general to the form												// R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM
  TxtSepExp           = ';';              // Seperator character						// R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM
resourcestring      // of header
  CtTxtTitle          = 'Activity timetable';
  CtTxtTitleCaReport  = 'Hourly turnover per day';

resourcestring      // of table
  CtTxtLibSecteurs    = 'Labeled sectors';
  CtTxtTimeSlice      = 'Time slice';
  CtTxtTotal          = 'Total Incl. taxes';
  CtTxtNoData         = 'No data for this daterange';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtReportDate     = 'Report from %s to %s';
  CtTxtGrandTotal     = 'Daily total';
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtNumDays        = 'It is only allowed to select %s days!';
  CtTxtHour           = 'Hour';
  CtTxtTurnover       = 'Turnover / hour';
  CtTxtSumTurnover    = 'Sum turnover';
  CtTxtRatio          = 'Ratio turnover';
  CtTxtClients        = 'Nr clients';
  CtTxtSumClients     = 'Sum nr clients';
  CtTxtAverage        = 'Turnover / basket';
  CtTxtArticles       = 'Nr articles';
  CtTxtSumArticles    = 'Sum nr articles';
  CtTxtBasket         = 'Articles / basket';
  CtTxtDepartment     = 'Best department';
  CtTxtHourExt        = 'h';
  CtTxtOveralTotal    = 'Total';
  CtTxtNumPassage     = 'Number of passage';                                    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  CtTxtAvgTrolley     = 'Average trolley';                                      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)

resourcestring  // for runtime parameters
  CtTxtRunParamHourlyCA   = '/VHCA=Hourly CA';
  CtTxtRunParamSalesClass = '/VSC=Sales per classification';
  CtTxtRunParamNumDays    = '/VNDx=Maximum days to select';
  CtTxtRunParamAvgTotal   = '/VEXP=Number of passage and Average Total';        // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  CtTxtRunDetCarteCadeau  = '/VInformatif=Informatif details of'+               // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
                             #10'the classification table';                     // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End

resourcestring // of export to excel parameters                                 // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  CtTxtExists           = 'File exists, Overwrite?';                            // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)

const
  CtTxtPlace        = 'D:\sycron\transferto\excel';                             // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  CtInformatif      = '90.990';                                                 // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
  CtCarteCadeau     = '90.990.3404';                                            // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  // Create type for storing totals
  TRcdTotals =  class                 // Record to store tendergrouptotals
       TxtDate         : string;      // Date in dd-mm-yyyy format
       ValTotal        : currency;    // Value for a certain day
       TxtSort         : string;      // Value to sort on
       passageTotal    : Integer;     // No of passage for a certain day        // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
       TotPassageCount : Integer;     // Total No of passage                    // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
  end;

  TFrmDetCAActiviteHoraire = class(TFrmDetGeneralCA)
    SprCAActiviteHoraire: TStoredProc;
    SprCAHoraire: TStoredProc;
    CbxTimeSlice: TComboBox;
    ChxClassification: TCheckBox;
    SvcDBLblTimeSlice: TSvcDBLabelLoaded;
    BtnExport: TSpeedButton;                                                    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    SavDlgExport: TSaveTextFileDialog;                                          // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    procedure BtnExportClick(Sender: TObject);                                  // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
    FFlgHourlyCA   : Boolean;
    FFlgSalesClass : Boolean;
    FFlgHour       : Boolean;                                                   // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    FFlgInformatif : Boolean;                                                   // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
    FNumDays       : Integer;
    TxtValuesMinut : string;
  protected
    // Totals
    LstTotals          : TList;          // List to store all totals records
    RcdTotals          : TRcdTotals;     // Record for handling totals
    ValSumTurnover     : double;         // Sum turnover column
    NumSumClients      : integer;        // Sum clients column
    NumSumArticles     : integer;        // Sum articles column
    ValDTotAverage     : double;         // Daily Total of the averages
    NumDTotAverage     : integer;        // Daily number of averages
    ValDTotBaskets     : double;         // Daily total of the baskets
    ValSumGTotTurnover : double;         // Grand total turnover
    NumSumGTotClients  : integer;        // Sum clients column
    NumSumGTotArticles : integer;        // Sum articles column
    NumDTotBaskets     : integer;        // Daily number of baskets
    ValGTotAverage     : double;         // Grand total of the averages
    NumGTotAverage     : integer;        // Grand number of averages
    ValGTotBaskets     : double;         // Grand total of the baskets
    NumGTotBaskets     : integer;        // Grand number of baskets
    // Formats of the rapport
    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport :  string; override;
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    property FlgHourlyCA : Boolean read FFlgHourlyCA write FFlgHourlyCA;
    property FlgSalesClass : Boolean read FFlgSalesClass write FFlgSalesClass;
    property NumDays: integer read FNumDays write FNumDays;
    procedure CreateAdditionalModules; override;
    procedure PrintTableBody; override;
    procedure PrintTableBodyCAReport; virtual;
    procedure PrintHeader; override;
    procedure Execute; override;
    procedure PrintActHorReport; virtual;
    procedure PrintHourlyCAReport; virtual;
    procedure CalculateTotals (datDate : TDatetime ; valValue : Real; valPassage:Integer;TotPassage:Integer);  virtual;  // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    procedure PrintTotals; virtual;
    procedure PrintTotalsCAReport; virtual;
    procedure PrintGrandTotalsCAReport; virtual;
    function BuildSQLClassInformatif (Informatif : string): string;             // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
  end;

var
  FrmDetCAActiviteHoraire: TFrmDetCAActiviteHoraire;
  function CompareString(Item1, Item2: Pointer): Integer;

//******************************************************************************  

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnTradeMatrix,                                                              
  UFpsSyst;                                                                     //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN

{$R *.DFM}

//==============================================================================
// Source-identifiers
//==============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAActiviteHoraire.PAS';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAActiviteHoraire.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.4 $';
  CtTxtSrcDate    = '$Date: 2014/04/08 10:56:00 $';

//******************************************************************************
// Implementation of TFrmDetCAActiviteHoraire
//******************************************************************************

procedure TFrmDetCAActiviteHoraire.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCAActiviteHoraire.BeforeCheckRunParams
  inherited;
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString(CtTxtRunParamHourlyCA, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtRunParamNumDays, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtRunParamSalesClass, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtRunParamAvgTotal, '=', TxtPartLeft , TxtPartRight);          // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);                            // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  SplitString(CtTxtRunDetCarteCadeau, '=', TxtPartLeft , TxtPartRight);         // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);                            // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
end;   // of TFrmDetCAActiviteHoraire.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCAActiviteHoraire.CheckAppDependParams(TxtParam: string);
begin  // of TFrmDetCAActiviteHoraire.CheckAppDependParams
  NumDays := 0;
  if AnsiCompareText (copy(TxtParam, 3, 3), 'HCA') = 0 then
    FlgHourlyCA := True
  else if AnsiCompareText (copy(TxtParam, 3, 2), 'ND') = 0 then
    NumDays := StrToInt(copy(TxtParam, 5, length(TxtParam)-4))
  else if AnsiCompareText (copy(TxtParam, 3, 2), 'SC') = 0 then
    FlgSalesClass := True
  else if AnsiCompareText (copy(TxtParam, 3, 3), 'EXP') = 0 then                // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    FFlgHour := True                                                            // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  else if AnsiCompareText (copy(TxtParam, 3, 10), 'Informatif') = 0 then        // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
    FFlgInformatif := True;                                                     // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
end;   // of TFrmDetCAActiviteHoraire.CheckAppDependParams

//=============================================================================

function TFrmDetCAActiviteHoraire.GetFmtTableHeader : string;
var
  NumCounter         : integer;        // counter
begin  // of TFrmDetCAActiviteHoraire.GetFmtTableHeader
  if FlgHourlyCA then begin
    Result := '<+' + IntToStr (CalcWidthText (10, False));
    for NumCounter := 0 to 1 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (14, False));
    for NumCounter := 0 to 2 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (10, False));
    Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (14, False));
    for NumCounter := 0 to 2 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (10, False));
    Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (27, False));
  end
  else begin
    if ChxClassification.Checked then begin
      Result := '<+' + IntToStr (CalcWidthText (30, False));                      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (22, False));    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (23, False));     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - start
      if FFlgHour then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (13, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False))
      end
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - end
    end
    else begin
      Result := '<+' + IntToStr (CalcWidthText (25, False));                      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (25, False));     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - start
      if FFlgHour then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
      end
     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - end
    end;
  end;
end;   // of TFrmDetCAActiviteHoraire.GetFmtTableHeader

//=============================================================================

function TFrmDetCAActiviteHoraire.GetFmtTableBody : string;
var
  NumCounter         : integer;        // counter
begin  // of TFrmDetCAActiviteHoraire.GetFmtTableBody
  if FlgHourlyCA then begin
    Result := '<+' + IntToStr (CalcWidthText (10, False));
    for NumCounter := 0 to 1 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (14, False));
    for NumCounter := 0 to 2 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (10, False));
    Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (14, False));
    for NumCounter := 0 to 2 do
      Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (10, False));
    Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (27, False));
  end
  else begin
    if ChxClassification.Checked then begin
      Result := '<' + IntToStr (CalcWidthText (30, False));                     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (22, False));   // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (23, False));   // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - start
      if FFlgHour then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (13, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False))
      end
     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - end
    end
    Else begin
      Result := '<' + IntToStr (CalcWidthText (25, False));
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (25, False));
       // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - start
      if FFlgHour then begin
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
       Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
      end
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - end
    end
  end;
end;   // of TFrmDetCAActiviteHoraire.GetFmtTableBody

//=============================================================================

function TFrmDetCAActiviteHoraire.GetTxtTableTitle : string;
begin  // of TFrmDetCAActiviteHoraire.GetTxtTableTitle
  if FlgHourlyCA then
    Result := CtTxtHour + TxtSep + CtTxtTurnover + TxtSep + CtTxtSumTurnover +
               TxtSep + CtTxtRatio + TxtSep + CtTxtClients + TxtSep +
               CtTxtSumClients + TxtSep + CtTxtAverage + TxtSep + CtTxtArticles  +
               TxtSep + CtTxtSumArticles + TxtSep + CtTxtBasket + TxtSep +
               CtTxtDepartment
  else begin
      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - start
      if FFlgHour then begin
       if ChxClassification.Checked then
         Result := CtTxtLibSecteurs + TxtSep + CtTxtTimeSlice + TxtSep + CtTxtTotal
                + TxtSep + CtTxtNumPassage + TxtSep + CtTxtAvgTrolley
        else
         Result := CtTxtTimeSlice + TxtSep + CtTxtTotal + TxtSep + CtTxtNumPassage
                + TxtSep + CtTxtAvgTrolley;
       end

  else
     if ChxClassification.Checked then  begin
      Result := CtTxtLibSecteurs + TxtSep + CtTxtTimeSlice + TxtSep + CtTxtTotal;
     end
    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - end
    else
       Result := CtTxtTimeSlice + TxtSep + CtTxtTotal ;

  end;
end;   // of TFrmDetCAActiviteHoraire.GetTxtTableTitle

//=============================================================================

function TFrmDetCAActiviteHoraire.GetTxtTitRapport : string;
begin  // of TFrmDetCAActiviteHoraire.GetTxtTitRapport
  if FlgHourlyCA then
    Result := CtTxtTitleCAReport
  else
    Result := CtTxtTitle;
end;   // of TFrmDetCAActiviteHoraire.GetTxtTitRapport

//==============================================================================

function TFrmDetCAActiviteHoraire.GetTxtRefRapport : string;
begin  // of TFrmDetCarteBancaire.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0034';
end;   // of TFrmDetCAActiviteHoraire.GetTxtRefRapport

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAActiviteHoraire.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
              DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtReportDate,
              [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
              FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;
  TxtHdr := TxtHdr + Format (CtTxtPrintDate, [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAActiviteHoraire.PrintHeader

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintTableBody;
var
  StrCurrentClass    : string;         // Current classification
  StrPreviousClass   : string;         // Current classification
  StrDetailClsCurrent: string;         // Detail Classification                 // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
  StrDetailClsPrev   : string;         // Detail Classification                 // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
  TxtDescription     : string;         // Description of classification
  TxtDescInformatif  : string;         // Description od the Informatif         // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
  DatDateFrom        : TDatetime;      // Date from
  DatDateTo          : TDateTime;      // Date to
  NumClassValSale    : Double;         // Sale value
  TxtPrintLine       : string;         // String to print
  NumPrinted         : Integer;        // Number of lines printed
  NumPassage         : Integer;        // Number of Passage genrated at cash desk         // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  TotalNumPassage    : Integer;        // Total Number of Passage genrated at cash desk  // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
  FlgCarteCadeau     : Boolean;        // Total Number of Passage genrated at cash desk  // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM

begin  // of TFrmDetCAActiviteHoraire.PrintTableBody
  inherited;
  LstTotals       := TList.Create;   // Create list to store totals
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  NumPrinted := 0;
  TxtDescInformatif := '';                                                      // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
  try
    DmdFpnUtils.ClearQryInfo;
    if DmdFpnUtils.QueryInfo(BuildSQLClassInformatif (CtCarteCadeau)) then
    TxtDescInformatif :=DmdFpnUtils.QryInfo.FieldByName('TxtPublDescr').AsString;
  finally
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.ClearQryInfo;
  end;                                                                          // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
  while not SprCAActiviteHoraire.Eof do begin
    FlgCarteCadeau  := False;
    StrCurrentClass  :=
            SprCAActiviteHoraire.FieldByName ('IdtClassification').AsString;
    StrDetailClsCurrent  :=                                                     // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
          SprCAActiviteHoraire.FieldByName ('IdtDetailClassification').AsString;// R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
    TxtDescription   :=
            SprCAActiviteHoraire.FieldByName ('TxtPublDescr').AsString;
    DatDateFrom      := SprCAActiviteHoraire.FieldByName ('DatFrom').AsDateTime;
    DatDateTo        := SprCAActiviteHoraire.FieldByName ('DatTo').AsDateTime ;
    NumClassValSale  := SprCAActiviteHoraire.FieldByName ('ValSale').AsFloat;
    if FFlgHour then                                                            // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
      NumPassage     :=
      SprCAActiviteHoraire.FieldByName ('PassageCount').AsInteger;              // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
     // TotalNumPassage:= SprCAActiviteHoraire.FieldByName ('TotalPassage').AsInteger;     // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS)   // Bug Fix for Defect ID - 178(All-opco)-RC(TCS).commented
       TotalNumPassage  := TotalNumPassage + NumPassage;                        // Bug Fix for Defect ID - 178(All-opco)-RC(TCS)
    if FFlgHour then  begin                                                     // Bug Fix for Defect ID - 61 (BDES – Rapport Activity schedule report-AM(TCS)) -start
      if NumPassage <> 0.0 then begin
         NumPrinted := NumPrinted + 1;
            if ChxClassification.Checked then begin
              // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
              if StrDetailClsCurrent = CtCarteCadeau then begin
                  FlgCarteCadeau  := True;
                  if StrDetailClsPrev = StrDetailClsCurrent then begin
                    TxtPrintLine :=' ' + TxtSep +
                                    FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                                    ' - ' + FormatDateTime('hh:mm' , DatDateTo)+ TxtSep +
                                    FormatFloat (CtTxtFrmNumber, NumClassValSale)+ TxtSep +
                                    IntToStr (NumPassage)+TxtSep+
                                    FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage);
                  end
                  else
                    TxtPrintLine := StrDetailClsCurrent + ': ' + TxtDescInformatif + TxtSep +
                                    FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                                    ' - ' + FormatDateTime('hh:mm' , DatDateTo) + TxtSep +
                                    FormatFloat (CtTxtFrmNumber, NumClassValSale)+ TxtSep +
                                    IntToStr (NumPassage)+TxtSep+
                                    FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage);
                StrDetailClsPrev := StrDetailClsCurrent;                        
              end   // of StrDetailClsCurrent = CtTxtCarteCadeau (true)
              else begin // of of StrDetailClsCurrent = CtTxtCarteCadeau (false)
              if not (StrCurrentClass = CtInformatif) then
              // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
                if StrPreviousClass = StrCurrentClass then
                  // Print following lines of a sector (without sectorlabel)
                  TxtPrintLine :=' ' + TxtSep + FormatDateTime('dd-mm-yyyy hh:mm',
                                  DatDateFrom) + ' - ' + FormatDateTime('hh:mm',
                                  DatDateTo) + TxtSep + FormatFloat (CtTxtFrmNumber,
                                  NumClassValSale)+ TxtSep + IntToStr (NumPassage)+ TxtSep
                                  + FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage)
                else
                  // Print first line of a sector (with sectorlabel)
                  TxtPrintLine := StrCurrentClass + ': ' + TxtDescription + TxtSep +
                                  FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                                  ' - ' + FormatDateTime('hh:mm' , DatDateTo) + TxtSep +
                                  FormatFloat (CtTxtFrmNumber, NumClassValSale)+ TxtSep +
                                  IntToStr (NumPassage)+TxtSep+
                                  FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage)
              end
            end //of ChxClassification.Checked (true)
            else begin   // of ChxClassification.Checked (false)                // R2013.2.Req(32030)-Hourly-activity-report.TCS-SRM.Start
           // if not (StrCurrentClass = CtInformatif) then
              TxtPrintLine := FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                              ' - ' + FormatDateTime('hh:mm' , DatDateTo) + TxtSep +
                              FormatFloat (CtTxtFrmNumber, NumClassValSale)+ TxtSep
                              + IntToStr (NumPassage )+
                              TxtSep+ FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage );
            end;  // of ChxClassification.Checked (false)
            // printing both (ChxClassification.Checked or not checked)
              VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                                  clWhite, False);                              // R2013.2-Req(32030).Hourly-activity-report.TCS-SRM.End

            StrPreviousClass := StrCurrentClass;
            // count total for both(ChxClassification.Checked or not checked)
              CalculateTotals(DatDateFrom,NumClassValSale,NumPassage,TotalNumPassage)
      end; //end of NumPassage <> 0.0 (true) condition
    end; //end of FFlgHour (true)
    if not FFlgHour then                                                        // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))-end
      if NumClassValSale <> 0.0 then begin
       NumPrinted := NumPrinted + 1;
        if ChxClassification.Checked then begin
          if StrPreviousClass = StrCurrentClass then
          TxtPrintLine := ' ' + TxtSep + FormatDateTime('dd-mm-yyyy hh:mm',
                            DatDateFrom) + ' - ' + FormatDateTime('hh:mm',
                            DatDateTo) + TxtSep + FormatFloat (CtTxtFrmNumber,
                            NumClassValSale)
          else
           TxtPrintLine := StrCurrentClass + ': ' + TxtDescription + TxtSep +
                            FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                            ' - ' + FormatDateTime('hh:mm' , DatDateTo) + TxtSep +
                            FormatFloat (CtTxtFrmNumber, NumClassValSale);
           end
        else
         TxtPrintLine := FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                          ' - ' + FormatDateTime('hh:mm' , DatDateTo) + TxtSep +
                          FormatFloat (CtTxtFrmNumber, NumClassValSale);
        VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                            clWhite, False);
        StrPreviousClass := StrCurrentClass;
         CalculateTotals(DatDateFrom,NumClassValSale,NumPassage,TotalNumPassage);
    end; //End of (not FFlgHour)
    SprCAActiviteHoraire.Next;
  end;  //End of while
  if Assigned(LstTotals) then
    PrintTotals;
  if NumPrinted = 0 then
    VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite, clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetCAActiviteHoraire.PrintTableBody

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintTableBodyCAReport;
var
  TxtPrintLine       : string;         // String to print
  NumCounter         : Integer;        // Counter
  TxtHour            : string;         // Hour column
  ValTotTurnover     : double;         // Total turnover
  ValTurnover        : double;         // Turnover column
  ValRatio           : double;         // Ratio Column
  NumClients         : integer;        // Clients column
  ValAverage         : double;         // Average column
  NumArticles        : integer;        // Articles column
  ValBasket          : double;         // Basket column
  TxtClassification  : string;         // Classification column
  DatDateFrom        : TDatetime;     // Date from
  DatDateTo          : TDateTime;      // Date to
  //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN.Start
  StartTime          : integer;
  EndTime            : integer;
  //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN.End
  TxtIni             : TIniFile;    //R2014.1.Enhancement 184.TCS-RC
begin  // of TFrmDetCAActiviteHoraire.PrintTableBodyCAReport
  inherited;
  //R2014.1.Enhancement 184.TCS-RC.start
   TxtIni  := TIniFile.Create(ViTxtFNIniSystemFps);
   StartTime  := StrToInt(TxtIni.ReadString('HourlyReport_ES','StratTime','0'));
   EndTime    := StrToInt(TxtIni.ReadString('HourlyReport_ES','EndTime','0'));
   //R2014.1.Enhancement 184.TCS-RC.end
  //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN.Start
  if ViFlg24X7 then begin
    StartTime := 0;
    EndTime   := 23;
  end
  else if  (StartTime = 0 )  and  (EndTime = 0) then begin   //R2014.1.Enhancement 184.TCS-RC
 // else begin                      //R2014.1.Enhancement 184.TCS-RC.commented
    StartTime := 8;
    EndTime   := 22;
  end;
  //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN.End
  DatDateFrom := DtmPckDayFrom.Date;
  DatDateTo   := DtmPckDayTo.Date;
  ValSumGTotTurnover := 0;
  NumSumGTotClients  := 0;
  NumSumGTotArticles := 0;
  ValGTotAverage := 0;
  NumGTotAverage := 0;
  ValGTotBaskets := 0;
  NumGTotBaskets := 0;
  while DatDateFrom <= DatDateTo do begin
    ValTotTurnover := 0;
    ValSumTurnover := 0;
    NumSumClients  := 0;
    NumSumArticles := 0;
    ValDTotAverage := 0;
    NumDTotAverage := 0;
    ValDTotBaskets := 0;
    NumDTotBaskets := 0;
    NumCounter     := 0;
    SprCAHoraire.First;
    while not SprCAHoraire.Eof do begin
      if FormatDateTime (ViTxtDBDatFormat, DatDateFrom) = FormatDateTime
      (ViTxtDBDatFormat, SprCAHoraire.FieldByName ('DatBegin').AsDateTime) then
        ValTotTurnover := ValTotTurnover + SprCAHoraire.FieldByName
                           ('ValInclVAT').AsFloat;
      SprCAHoraire.Next;
    end; // of while not SprCAHoraire.Eof
    SprCAHoraire.First;
    while (not SprCAHoraire.Eof) and (NumCounter <= EndTime) do begin           //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      TxtPrintLine := FormatDateTime (CtTxtDatFormat, DatDateFrom) + TxtSep +
                      '' + TxtSep + '' + TxtSep + '' + TxtSep + '' + TxtSep +
                      '' + TxtSep + '' + TxtSep + '' + TxtSep + '' + TxtSep +
                      '' + TxtSep + '';
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clSilver, False);
      for NumCounter := StartTime to EndTime do begin                           //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN
        SprCAHoraire.First;
        ValTurnover := 0;
        ValRatio    := 0;
        NumClients  := 0;
        ValAverage  := 0;
        NumArticles := 0;
        ValBasket   := 0;
        TxtClassification := '';
        TxtHour := IntToStr(NumCounter) + CtTxtHourExt + '-' +
                   IntToStr(NumCounter + 1) + CtTxtHourExt;
        while not SprCAHoraire.Eof do begin
          if (NumCounter = SprCAHoraire.FieldByName ('NumHour').AsInteger) and
          (FormatDateTime (ViTxtDBDatFormat, DatDateFrom) = FormatDateTime
          (ViTxtDBDatFormat, SprCAHoraire.FieldByName ('DatBegin').AsDateTime))
          then begin
            ValTurnover    := SprCAHoraire.FieldByName ('ValInclVAT').AsFloat;
            NumArticles    := SprCAHoraire.FieldByName ('QtySale').AsInteger;
            TxtClassification := SprCAHoraire.FieldByName ('TxtPublDescr').AsString;
            NumClients     := SprCAHoraire.FieldByName ('QtyCustomer').AsInteger;
            ValSumTurnover := ValSumTurnover + ValTurnover;
            ValRatio       := ValTurnover/ValTotTurnover*100;
            NumSumClients  := NumSumClients + NumClients;
            ValAverage     := ValTurnover/NumClients;
            ValDTotAverage := ValDTotAverage + ValAverage;
            NumDTotAverage := NumDTotAverage + 1;
            NumSumArticles := NumSumArticles + NumArticles;
            ValBasket      := NumArticles/NumClients;
            ValDTotBaskets := ValDTotBaskets + ValBasket;
            NumDTotBaskets := NumDTotBaskets + 1;
          end; // of if (NumCounter = SprCAHoraire.FieldByName ('NumHour').AsInteger)
          SprCAHoraire.Next;
        end; // of while not SprCAHoraire.Eof
        TxtPrintLine := TxtHour + TxtSep + FormatFloat('0.00', ValTurnover) +
                        ' ' + DmdFpnUtils.IdtCurrencyMain + TxtSep +
                        FormatFloat('0.00', ValSumTurnover) + ' ' +
                        DmdFpnUtils.IdtCurrencyMain + TxtSep +
                        FormatFloat('0.00', ValRatio) + '%' + TxtSep +
                        IntToStr(NumClients) + TxtSep + IntToStr(NumSumClients) +
                        TxtSep + FormatFloat('0.00',  ValAverage) + ' ' +
                        DmdFpnUtils.IdtCurrencyMain + TxtSep +
                        IntToStr(NumArticles) + TxtSep + IntToStr(NumSumArticles) +
                        TxtSep + FormatFloat('0.00',  ValBasket) + TxtSep +
                        TxtClassification;
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clWhite, False);
      end; // of for NumCounter := 8 to 22
      NumCounter := 0;
      VspPreview.TableCell[tcFontBold, 1, 1, 1, 1] := True;
    end; // of while (not SprCAHoraire.Eof) and (NumCounter <= 22)
    if SprCAHoraire.RecordCount = 0 then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      TxtPrintLine := FormatDateTime (CtTxtDatFormat, DatDateFrom) + TxtSep +
                      '' + TxtSep + '' + TxtSep + '' + TxtSep + '' + TxtSep +
                      '' + TxtSep + '' + TxtSep + '' + TxtSep + '' + TxtSep +
                      '' + TxtSep + '';
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clSilver, False);
      for NumCounter := StartTime to EndTime do begin                           //R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SPN.Start
        TxtHour := IntToStr(NumCounter) + CtTxtHourExt + '-' +
                   IntToStr(NumCounter + 1) + CtTxtHourExt;
        TxtPrintLine := TxtHour + TxtSep + FormatFloat('0.00', 0) + ' ' +
                        DmdFpnUtils.IdtCurrencyMain + TxtSep + FormatFloat
                        ('0.00', 0) + ' ' + DmdFpnUtils.IdtCurrencyMain + TxtSep +
                        FormatFloat('0.00', 0) + '%' + TxtSep + '0' + TxtSep +
                        '0' + TxtSep + FormatFloat('0.00',  0) + ' ' +
                        DmdFpnUtils.IdtCurrencyMain + TxtSep + '0' + TxtSep +
                        '0' + TxtSep + FormatFloat('0.00',  0) + TxtSep + '';
        VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite, clWhite, False);
      end; // of for NumCounter := 8 to 22
      VspPreview.TableCell[tcFontBold, 1, 1, 1, 1] := True;
    end; // of if SprCAHoraire.RecordCount = 0
    PrintTotalsCAReport;
    VspPreview.EndTable;
    DatDateFrom := DatDateFrom + 1;
  end; // of while DatDateFrom <= DatDateTo
  PrintGrandTotalsCAReport;
  VspPreview.EndTable;
end;   // of TFrmDetCAActiviteHoraire.PrintTableBodyCAReport

//==============================================================================
// TFrmDetCAPerformanceCaissiere.CalculateValues : Calculate total value per day
//                                  -----
// INPUT   : datDate : date of sale
//           valValue : value of sale
//==============================================================================

procedure TFrmDetCAActiviteHoraire.CalculateTotals (datDate : TDatetime;
                                                    valValue : Real;
                                                    valPassage:Integer;         // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
                                                    TotPassage:Integer);        // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
var
  CntItem          : Integer;           // Counter
  FldExists        : Boolean;           // Check if date already exists

  begin  // of TFrmDetCAActiviteHoraire.CalculateTotals
  // Initialize flgexists
  FldExists := False;
  // Check if new values already exist
  // Loop the already found totals
  for CntItem := 0 to LstTotals.Count-1 do begin
     if LstTotals.Count <> 0 then begin
        RcdTotals := TRcdTotals(LstTotals.Items[CntItem]);
        // Update an existing tendergroup
        if RcdTotals.TxtDate = FormatDateTime('dd-mm-yyyy' , DatDate) then begin
           FldExists := True;
           RcdTotals.ValTotal := RcdTotals.ValTotal + valValue;
           RcdTotals.PassageTotal := RcdTotals.PassageTotal + valPassage ;      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
           RcdTotals.TotPassageCount := TotPassage ;                            // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
        end;
     end;
  end;
  // Store item if it doesn't already exist
  if not fldExists then begin
     RcdTotals := TRcdTotals.Create;
     RcdTotals.TxtDate := FormatDateTime('dd-mm-yyyy' , DatDate);
     RcdTotals.ValTotal := valValue;
     RcdTotals.PassageTotal := valPassage;                                      // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
     RcdTotals.TotPassageCount := TotPassage ;                                  // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
     RcdTotals.TxtSort := FormatDateTime('yyyy-mm-dd' , DatDate);
     LstTotals.Add(RcdTotals);
  end;
end;    // of TFrmDetCAActiviteHoraire.CalculateTotals

//==============================================================================
// CompareString : Function to sort totals per date
//==============================================================================

function CompareString(Item1, Item2: Pointer): Integer;
begin // of CompareString
  if TRcdTotals(Item1).TxtSort < TRcdTotals(Item2).TxtSort then
    Result := -1
  else if TRcdTotals(Item1).TxtSort = TRcdTotals(Item2).TxtSort then
    Result := 0
  else
    Result := 1;
end;  // of CompareString

//==============================================================================
// TFrmDetCAPerformanceCaissiere.PrintTotals : Print totals below report
//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintTotals;
var
  CntItem          : Integer;           // Counter
  TxtPrintLine     : string;            // Line to print
begin  // of TFrmDetCAActiviteHoraire.PrintTotals
  VspPreview.EndTable;
  VspPreview.StartTable;
  LstTotals.Sort(CompareString);
  if LstTotals.Count > 0 then begin
    TxtPrintLine  := CtTxtGrandTotal + ':' + #10;
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                         clSilver, False);
  end;
  for CntItem := 0 to LstTotals.Count-1 do begin
    RcdTotals := TRcdTotals(LstTotals.Items[CntItem]);
    if ChxClassification.Checked then
      TxtPrintLine := TxtSep + RcdTotals.TxtDate + TxtSep +
                      FormatFloat (CtTxtFrmNumber, RcdTotals.ValTotal)
                      + TxtSep +                                                                   // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
                      //Inttostr (RcdTotals.PassageTotal)+ TxtSep                                    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
                      //+ FormatFloat (CtTxtFrmNumber, RcdTotals.ValTotal/RcdTotals.PassageTotal)    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
                      Inttostr (RcdTotals.TotPassageCount)+ TxtSep                                 // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
                      + FormatFloat (CtTxtFrmNumber, RcdTotals.ValTotal/RcdTotals.TotPassageCount) // Bug Fix for Defect ID - 65 (BDES – Rapport Activity schedule report-AM(TCS))
    else
      TxtPrintLine := RcdTotals.TxtDate + TxtSep +
                      FormatFloat (CtTxtFrmNumber, RcdTotals.ValTotal)+ TxtSep +
                      Inttostr (RcdTotals.PassageTotal)+ TxtSep                                    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
                      + FormatFloat (CtTxtFrmNumber, RcdTotals.ValTotal/RcdTotals.PassageTotal);   // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                         clSilver, False);
  end;
end;    // of TFrmDetCAActiviteHoraire.PrintTotals

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintTotalsCAReport;
var
  TxtPrintLine     : string;            // Line to print
begin  // of TFrmDetCAActiviteHoraire.PrintTotalsCAReport
  VspPreview.EndTable;
  VspPreview.StartTable;
  if ValSumTurnover <> 0 then
    TxtPrintLine := CtTxtGrandTotal + TxtSep + FormatFloat('0.00', ValSumTurnover) +
                    ' ' +  DmdFpnUtils.IdtCurrencyMain + TxtSep + '' + TxtSep +
                    '' + TxtSep + IntToStr(NumSumClients) + TxtSep + '' +
                    TxtSep + FormatFloat('0.00', ValDTotAverage/NumDTotAverage) +
                    ' ' +  DmdFpnUtils.IdtCurrencyMain + TxtSep + IntToStr(
                    NumSumArticles) + TxtSep + '' + TxtSep + FormatFloat('0.00',
                    ValDTotBaskets/NumDTotBaskets) + TxtSep + ''
  else
    TxtPrintLine := CtTxtGrandTotal + TxtSep + FormatFloat('0.00', ValSumTurnover) +
                    ' ' +  DmdFpnUtils.IdtCurrencyMain + TxtSep + '' + TxtSep +
                    '' + TxtSep + IntToStr(NumSumClients) + TxtSep + '' + TxtSep +
                    FormatFloat('0.00', 0) + ' ' +  DmdFpnUtils.IdtCurrencyMain +
                    TxtSep + IntToStr(NumSumArticles) + TxtSep + '' + TxtSep +
                    FormatFloat('0.00', 0) + TxtSep + '';
  ValGTotAverage := ValGTotAverage + ValDTotAverage;
  NumGTotAverage := NumGTotAverage + NumDTotAverage;
  ValGTotBaskets := ValGTotBaskets + ValDTotBaskets;
  NumGTotBaskets := NumGTotBaskets + NumDTotBaskets;
  ValSumGTotTurnover := ValSumGTotTurnover + ValSumTurnover;
  NumSumGTotClients := NumSumGTotClients + NumSumClients;
  NumSumGTotArticles := NumSumGTotArticles + NumSumArticles;
  VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                       clSilver, False);
end;    // of TFrmDetCAActiviteHoraire.PrintTotalsCAReport

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintGrandTotalsCAReport;
var
  TxtPrintLine     : string;            // Line to print
begin  // of TFrmDetCAActiviteHoraire.PrintGrandTotalsCAReport
  VspPreview.StartTable;
  if ValSumGTotTurnover <> 0 then
    TxtPrintLine := CtTxtOveralTotal + TxtSep + FormatFloat('0.00',
                    ValSumGTotTurnover) + ' ' +  DmdFpnUtils.IdtCurrencyMain +
                    TxtSep + '' + TxtSep + '' + TxtSep + IntToStr
                    (NumSumGTotClients) + TxtSep + '' + TxtSep + FormatFloat
                    ('0.00', ValGTotAverage/NumGTotAverage) + ' ' +
                    DmdFpnUtils.IdtCurrencyMain + TxtSep + IntToStr
                    (NumSumGTotArticles) + TxtSep + '' + TxtSep + FormatFloat
                    ('0.00', ValGTotBaskets/NumGTotBaskets) + TxtSep + ''
  else
    TxtPrintLine := CtTxtOveralTotal + TxtSep + FormatFloat('0.00',
                    ValSumGTotTurnover) + ' ' +  DmdFpnUtils.IdtCurrencyMain +
                    TxtSep + '' + TxtSep + '' + TxtSep + IntToStr
                    (NumSumGTotClients) + TxtSep + '' + TxtSep + FormatFloat
                    ('0.00', 0) + ' ' + DmdFpnUtils.IdtCurrencyMain + TxtSep +
                    IntToStr(NumSumGTotArticles) + TxtSep + '' + TxtSep +
                    FormatFloat('0.00', 0) + TxtSep + '';
  VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                       clSilver, False);
  VspPreview.TableCell[tcFontBold, 1, 1, 1, 11] := True;
end;    // of TFrmDetCAActiviteHoraire.PrintGrandTotalsCAReport

//==============================================================================

procedure TFrmDetCAActiviteHoraire.Execute;
begin  // of TFrmDetCAActiviteHoraire.Execute
  if FlgHourlyCA then
    PrintHourlyCAReport
  else
    PrintActHorReport;
end;   // of TFrmDetCAActiviteHoraire.Execute

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintHourlyCAReport;
begin  // of TFrmDetCAActiviteHoraire.PrintHourlyCAReport
  SprCAHoraire.Active := False;
  SprCAHoraire.ParamByName ('@PrmDatFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAHoraire.ParamByName ('@PrmDatTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date) + ' ' +
     '23:59:59';
  SprCAHoraire.Active := True;
  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;
  PrintTableBodyCAReport;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  FrmVSPreview.OnActivate(Self);
  LstTotals.Free;
end;   // of TFrmDetCAActiviteHoraire.PrintHourlyCAReport

//==============================================================================

procedure TFrmDetCAActiviteHoraire.PrintActHorReport;
Var
  TxtLeft          : string;           // Leftside of string after splitstring
  TxtRight         : string;           // Rightside of string after splitstring
  TxtTime          : string;
  CntItem          : integer;
begin  // of TFrmDetCAActiviteHoraire.PrintActHorReport
  // Activate stored procedure
  TxtRight := TxtValuesMinut;
  CntItem := 0;
  repeat
    SplitString (TxtRight, ';', TxtLeft, TxtRight);
    CntItem := CntItem + 1;
  until CntItem > CbxTimeSlice.ItemIndex;
  if StrToInt(TxtLeft) >= 60 then
    TxtTime := '0' + IntToStr(Round(StrToInt(TxtLeft)/60)) + ':00:00:000'
  else
    TxtTime := '00:' + TxtLeft + ':00:000';
  SprCAActiviteHoraire.Active := False;
  SprCAActiviteHoraire.ParamByName ('@PrmDatFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAActiviteHoraire.ParamByName ('@PrmDatTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAActiviteHoraire.ParamByName ('@PrmTimPart').AsString := TxtTime;
  SprCAActiviteHoraire.ParamByName ('@PrmFlgShowClass').AsBoolean :=
    ChxClassification.Checked;
  SprCAActiviteHoraire.Active := True;
  VspPreview.Orientation := orPortrait;
  VspPreview.StartDoc;
  PrintTableBody;
  VspPreview.EndDoc;
  PrintPageNumbers;
  PrintReferences;
  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
  FrmVSPreview.OnActivate(Self);
  LstTotals.Free;
end;   // of TFrmDetCAActiviteHoraire.PrintActHorReport

//==============================================================================

procedure TFrmDetCAActiviteHoraire.FormPaint(Sender: TObject);
begin // of TFrmDetCAActiviteHoraire.FormPaint
  inherited;
  BtnSelectAllClick(Self);
end; // of TFrmDetCAActiviteHoraire.FormPaint

//==============================================================================

procedure TFrmDetCAActiviteHoraire.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetCAActiviteHoraire.BtnPrintClick
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
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  // Check number of selected days
  else if FlgHourlyCA and ((DtmPckDayTo.Date - DtmPckDayFrom.Date) >= NumDays)
  then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (Format (CtTxtNumDays, [IntToStr(NumDays)]), mtWarning, [mbOK], 0);
  end
  else begin
    FlgPreview := (Sender = BtnPreview);
    Execute;
  end;
end;  // of TFrmDetCAActiviteHoraire.BtnPrintClick

//=============================================================================

procedure TFrmDetCAActiviteHoraire.CreateAdditionalModules;
begin  // of TFrmDetCAActiviteHoraire.CreateAdditionalModules
  try
    if not Assigned (DmdFpn) then
      DmdFpn := TDmdFpn.Create (Application);
    if not Assigned (DmdFpnUtils) then
      DmdFpnUtils := TDmdFpnUtils.Create (Application);
    if not Assigned (DmdFpnTradeMatrix) then
      DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Application);
  finally
    ChDir (ViTxtWorkingDir);
  end;
  CbxTimeSlice.Items.Clear;
  DmdFpnUtils.SprCnvCodes.Active := False;
  DmdFpnUtils.SprCnvCodes.Params.ParamByName('@PrmTxtTable').Value :='Activity';
  DmdFpnUtils.SprCnvCodes.Params.ParamByName('@PrmTxtField').Value :=
                                                                 'CodTimeslice';
  DmdFpnUtils.SprCnvCodes.Active := True;
  BuildStrLstCodes (CbxTimeSlice.Items, DmdFpnUtils.SprCnvCodes,
                    'TxtChcLong', 'TxtFldCode');
  CbxTimeSlice.ItemIndex := 0;
  try
    if DmdFpnUtils.QueryInfo
        ('select * from applicParam where IdtApplicParam = '
        + AnsiQuotedStr('PrmTimeslice','''')) then begin
      DmdFpnUtils.QryInfo.First;
      TxtValuesMinut := DmdFpnUtils.QryInfo.FieldByName ('TxtParam').AsString ;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCAActiviteHoraire.CreateAdditionalModules

//==============================================================================

procedure TFrmDetCAActiviteHoraire.FormActivate(Sender: TObject);
begin // of TFrmDetCAActiviteHoraire.FormActivate
  inherited;
  if FlgHourlyCA then begin
    CbxTimeSlice.Visible := False;
    ChxClassification.Visible:= False;
    SvcDBLblTimeSlice.Visible:= False;
  end ;                                                                            // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
  if FFlgHour then begin                                                           // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    Btnexport.Visible := True;                                                     // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    CbxTimeSlice.Visible := True;                                                  // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    ChxClassification.Visible:= True;                                              // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    SvcDBLblTimeSlice.Visible:= True;
   end
  else begin
    Btnexport.Visible := False;                                                    // R2011.2- BDES – Rapport Activity schedule report-AM(TCS)
    CbxTimeSlice.Visible := True;
    ChxClassification.Visible:= True;
    SvcDBLblTimeSlice.Visible:= True;
  end
end; // of TFrmDetCAActiviteHoraire.FormActivate

//==============================================================================

procedure TFrmDetCAActiviteHoraire.FormCreate(Sender: TObject);
begin // of TFrmDetCAActiviteHoraire.FormCreate
  inherited;
  if FlgSalesClass then
    ChxClassification.Checked := True;
end; // of TFrmDetCAActiviteHoraire.FormCreate

//==============================================================================
// R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - START
procedure TFrmDetCAActiviteHoraire.BtnExportClick(Sender: TObject);
var
  TxtTitles           : string;
  TxtWriteLine        : string;
  counter             : Integer;
  F                   : System.Text;
  StrCurrentClass     : string;         // Current classification
  StrPreviousClass    : string;         // Current classification
  StrDetailClsCurrent : string;         // Curr Detail Classification           // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
  StrDetailClsPrev    : string;         // Prev Detail Classification
  FlgCarteCadeau      : Boolean;        // Carte cadeau flag                    // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
  NumPrinted          : Integer;        // Number of lines printed
  NumPassage          : Integer;        // Number of Passage genrated at cash desk
  TxtDescription      : string;         // Description of classification
  TxtDescInformatif   : string;         // Description od the Informatif        // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
  DatDateFrom         : TDatetime;      // Date from
  DatDateTo           : TDateTime;      // Date to
  NumClassValSale     : Double;         // Sale value
  ChrDecimalSep       : Char;
  Btnselect           : Integer;
  FlgOK               : Boolean;
  TxtPath             : string;
  QryHlp              : TQuery;
  TxtTime             : string;
  TxtLeft             : string;         // Leftside of string after splitstring
  TxtRight            : string;         // Rightside of string after splitstring
  CntItem             : integer;
  // R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM.Start
  TxtHour             : string;         // Hour column
  ValTotTurnover      : double;         // Total turnover
  ValTurnover         : double;         // Turnover column
  ValRatio            : double;         // Ratio Column
  NumClients          : integer;        // Clients column
  ValAverage          : double;         // Average column
  NumArticles         : integer;        // Articles column
  ValBasket           : double;         // Basket column
  TxtClassification   : string;         // Classification column
  StartTime           : integer;
  EndTime             : integer;
  NumCounter          : integer;
  // R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM.End

begin  // of TFrmDetCAActiviteHoraire.BtnExportClick
  if ViFlg24X7 then begin
    StartTime := 0;
    EndTime   := 23;
  end
  else begin
    StartTime := 8;
    EndTime   := 22;
  end;
  DatDateFrom := DtmPckDayFrom.Date;
  DatDateTo   := DtmPckDayTo.Date;
  ValSumGTotTurnover := 0;
  NumSumGTotClients  := 0;
  NumSumGTotArticles := 0;
  ValGTotAverage := 0;
  NumGTotAverage := 0;
  ValGTotBaskets := 0;
  NumGTotBaskets := 0;
    QryHlp := TQuery.Create(self);
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active       := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
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
  // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
  try
    DmdFpnUtils.ClearQryInfo;
       if DmdFpnUtils.QueryInfo (BuildSQLClassInformatif (CtCarteCadeau)) then
      TxtDescInformatif :=DmdFpnUtils.QryInfo.FieldByName('TxtPublDescr').AsString;
  finally
    DmdFpnUtils.CloseInfo;
    DmdFpnUtils.ClearQryInfo;
  end;
  // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
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
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
  end
  // Check number of selected days
  else if FlgHourlyCA and ((DtmPckDayTo.Date - DtmPckDayFrom.Date) >= NumDays)
  then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    MessageDlg (Format (CtTxtNumDays, [IntToStr(NumDays)]), mtWarning, [mbOK], 0);
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

     TxtRight := TxtValuesMinut;
     CntItem := 0;
     repeat
       SplitString (TxtRight, ';', TxtLeft, TxtRight);
       CntItem := CntItem + 1;
     until CntItem > CbxTimeSlice.ItemIndex;

      if StrToInt(TxtLeft) >= 60 then
        TxtTime := '0' + IntToStr(Round(StrToInt(TxtLeft)/60)) + ':00:00:000'
      else
        TxtTime := '00:' + TxtLeft + ':00:000';
        if not FlgHourlyCA then begin
          sprCAActiviteHoraire.Active := False;
          SprCAActiviteHoraire.ParamByName ('@PrmDatFrom').AsString :=
           FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
           FormatDateTime (ViTxtDBHouFormat, 0);
          SprCAActiviteHoraire.ParamByName ('@PrmDatTo').AsString :=
           FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
           FormatDateTime (ViTxtDBHouFormat, 0);
          SprCAActiviteHoraire.ParamByName ('@PrmTimPart').AsString := TxtTime;
          SprCAActiviteHoraire.ParamByName ('@PrmFlgShowClass').AsBoolean :=
           ChxClassification.Checked;
          SprCAActiviteHoraire.Active := True;
          SprCAActiviteHoraire.First;
          if SprCAActiviteHoraire.RecordCount = 0 then begin
              TxtWriteLine := CtTxtNoData;
              WriteLn(F, TxtWriteLine);
          end
          else
          while not SprCAActiviteHoraire.Eof do begin
              FlgCarteCadeau  := False;                                         // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM
              StrCurrentClass  :=
                SprCAActiviteHoraire.FieldByName ('IdtClassification').AsString;
              StrDetailClsCurrent  :=                                           // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
              SprCAActiviteHoraire.FieldByName ('IdtDetailClassification').AsString;// R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.End
              TxtDescription   :=
                SprCAActiviteHoraire.FieldByName ('TxtPublDescr').AsString;
              DatDateFrom      := SprCAActiviteHoraire.FieldByName ('DatFrom').AsDateTime;
              DatDateTo        := SprCAActiviteHoraire.FieldByName ('DatTo').AsDateTime ;
              NumClassValSale  := SprCAActiviteHoraire.FieldByName ('ValSale').AsFloat;
              NumPassage       := SprCAActiviteHoraire.FieldByName ('PassageCount').AsInteger;
              if NumClassValSale <> 0.0 then begin
                NumPrinted := NumPrinted + 1;
                if ChxClassification.Checked then begin
                 // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.Start
                 if StrDetailClsCurrent = CtCarteCadeau then begin
                   FlgCarteCadeau  := True;
                   if StrDetailClsPrev = StrDetailClsCurrent then begin
                     TxtWriteLine :='  ' + ';'+
                        FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom)+
                        ' - ' + FormatDateTime('hh:mm' , DatDateTo) +';'+
                        FormatFloat (CtTxtFrmNumber, NumClassValSale)+';'+
                        IntToStr (NumPassage)+';'+
                        FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage);
                   end
                   else
                     TxtWriteLine := StrDetailClsCurrent+ ': '+ TxtDescInformatif
                         +';'+FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                        ' - ' + FormatDateTime('hh:mm' , DatDateTo) +';'+
                        FormatFloat (CtTxtFrmNumber, NumClassValSale)+';'+
                        IntToStr (NumPassage)+';'+
                        FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage);
                    StrDetailClsPrev := StrDetailClsCurrent;
                 end  // of StrDetailClsCurrent = CtTxtCarteCadeau (true)
                 else begin // of StrDetailClsCurrent = CtTxtCarteCadeau (false)
                   if not (StrCurrentClass = CtInformatif) then
                      // R2013.2.Req(32030).Hourly-activity-report.TCS-SRM.end
                     if StrPreviousClass = StrCurrentClass then
                      // Print following lines of a sector (without sectorlabel)
                       TxtWriteLine :=' ' + ';' +
                         FormatDateTime('dd-mm-yyyy hh:mm',
                         DatDateFrom) + ' - ' + FormatDateTime('hh:mm',
                         DatDateTo) + ';' + FormatFloat (CtTxtFrmNumber,
                         NumClassValSale)+ ';' + IntToStr (NumPassage)+ ';'
                         + FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage)
                      else
                       // Print first line of a sector (with sectorlabel)
                       TxtWriteLine := StrCurrentClass + ': ' + TxtDescription +';'+
                         FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom)+
                         ' - ' + FormatDateTime('hh:mm' , DatDateTo) +';'+
                         FormatFloat (CtTxtFrmNumber, NumClassValSale)+';'+
                         IntToStr (NumPassage)+';'+
                         FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage)
                 end  // of StrDetailClsCurrent = CtTxtCarteCadeau (false)
                end // of ChxClassification.Checked (true)
                else begin  // of ChxClassification.Checked (false)
                  TxtWriteLine := FormatDateTime('dd-mm-yyyy hh:mm' , DatDateFrom) +
                         ' - ' + FormatDateTime('hh:mm' , DatDateTo) + ';' +
                         FormatFloat (CtTxtFrmNumber, NumClassValSale)+ ';'+
                         IntToStr (NumPassage )+';'+
                         FormatFloat (CtTxtFrmNumber,NumClassValSale/NumPassage );
                end ; //of ChxClassification.Checked (false)
                StrPreviousClass := StrCurrentClass;
                WriteLn(F, TxtWriteLine);
              end; // End of NumClassValSale <> 0.0 (true) condition
            SprCAActiviteHoraire.Next;
          end; // End of While
         end  // End of if not FlgHourlyCA...
         // R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM.Start
         else begin // of  FlgHourlyCA else part
          SprCAHoraire.Active := False;
          SprCAHoraire.ParamByName ('@PrmDatFrom').AsString :=
             FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
             FormatDateTime (ViTxtDBHouFormat, 0);
          SprCAHoraire.ParamByName ('@PrmDatTo').AsString :=
             FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date) + ' ' +
             '23:59:59';
          SprCAHoraire.Active := True;
          SprCAHoraire.First;
          while DatDateFrom <= DatDateTo do begin
            ValTotTurnover := 0;
            ValSumTurnover := 0;
            NumSumClients  := 0;
            NumSumArticles := 0;
            ValDTotAverage := 0;
            NumDTotAverage := 0;
            ValDTotBaskets := 0;
            NumDTotBaskets := 0;
            NumCounter     := 0;
            TxtWriteLine   := '';
            SprCAHoraire.First;
            while not SprCAHoraire.Eof do begin
              if FormatDateTime (ViTxtDBDatFormat, DatDateFrom) = FormatDateTime
              (ViTxtDBDatFormat, SprCAHoraire.FieldByName ('DatBegin').AsDateTime) then
                ValTotTurnover := ValTotTurnover + SprCAHoraire.FieldByName
                                   ('ValInclVAT').AsFloat;
              SprCAHoraire.Next;
            end; // of while not SprCAHoraire.Eof
            SprCAHoraire.First;
            while (not SprCAHoraire.Eof) and (NumCounter <= EndTime) do begin
              TxtWriteLine := TxtWriteLine +
                FormatDateTime (CtTxtDatFormat, DatDateFrom)    + TxtSepExp +
                           '' + TxtSepExp + '' + TxtSepExp + '' + TxtSepExp +
                           '' + TxtSepExp +''  + TxtSepExp + '' + TxtSepExp +
                           '' + TxtSepExp + '' + TxtSepExp + '' + TxtSepExp +'';
               WriteLn(F, TxtWriteLine);
              for NumCounter := StartTime to EndTime do begin
                SprCAHoraire.First;
                ValTurnover := 0;
                ValRatio    := 0;
                NumClients  := 0;
                ValAverage  := 0;
                NumArticles := 0;
                ValBasket   := 0;
                TxtClassification := '';
                TxtHour := IntToStr(NumCounter) + CtTxtHourExt + '-' +
                           IntToStr(NumCounter + 1) + CtTxtHourExt;
                while not SprCAHoraire.Eof do begin
                  if (NumCounter = SprCAHoraire.FieldByName ('NumHour').AsInteger) and
                  (FormatDateTime (ViTxtDBDatFormat, DatDateFrom) = FormatDateTime
                  (ViTxtDBDatFormat, SprCAHoraire.FieldByName ('DatBegin').AsDateTime))
                  then begin
                    ValTurnover    := SprCAHoraire.
                                             FieldByName ('ValInclVAT').AsFloat;
                    NumArticles    := SprCAHoraire.
                                              FieldByName ('QtySale').AsInteger;
                    TxtClassification := SprCAHoraire.
                                          FieldByName ('TxtPublDescr').AsString;
                    NumClients     := SprCAHoraire.
                                          FieldByName ('QtyCustomer').AsInteger;
                    ValSumTurnover := ValSumTurnover + ValTurnover;
                    ValRatio       := ValTurnover/ValTotTurnover*100;
                    NumSumClients  := NumSumClients + NumClients;
                    ValAverage     := ValTurnover/NumClients;
                    ValDTotAverage := ValDTotAverage + ValAverage;
                    NumDTotAverage := NumDTotAverage + 1;
                    NumSumArticles := NumSumArticles + NumArticles;
                    ValBasket      := NumArticles/NumClients;
                    ValDTotBaskets := ValDTotBaskets + ValBasket;
                    NumDTotBaskets := NumDTotBaskets + 1;
                  end; // of if (NumCounter = SprCAHoraire.FieldByName...
                  SprCAHoraire.Next;
                end; // of while not SprCAHoraire.Eof
                TxtWriteLine := TxtHour + TxtSepExp +
                                FormatFloat('0.00', ValTurnover) +' ' +
                                DmdFpnUtils.IdtCurrencyMain        + TxtSepExp +
                                FormatFloat('0.00', ValSumTurnover) + ' ' +
                                DmdFpnUtils.IdtCurrencyMain        + TxtSepExp +
                                FormatFloat('0.00', ValRatio) + '%'+ TxtSepExp +
                                IntToStr(NumClients)               + TxtSepExp +
                                IntToStr(NumSumClients)             +TxtSepExp +
                                FormatFloat('0.00',  ValAverage) + ' ' +
                                DmdFpnUtils.IdtCurrencyMain        + TxtSepExp +
                                IntToStr(NumArticles)              + TxtSepExp +
                                IntToStr(NumSumArticles)           + TxtSepExp +
                                FormatFloat('0.00',  ValBasket)    + TxtSepExp +
                                TxtClassification;
              WriteLn(F, TxtWriteLine);
              end; // of NumCounter := StartTime to EndTime
              NumCounter := 0;
            end; // of while (not SprCAHoraire.Eof) and (NumCounter <= EndTime)
            if SprCAHoraire.RecordCount = 0 then begin
              VspPreview.TableBorder := tbBoxColumns;
              VspPreview.StartTable;
              TxtWriteLine :=
               FormatDateTime (CtTxtDatFormat, DatDateFrom) + TxtSepExp + '' +
                           TxtSepExp + '' + TxtSepExp + ''  + TxtSepExp + '' +
                           TxtSepExp + '' + TxtSepExp + ''  + TxtSepExp + '' +
                           TxtSepExp + '' + TxtSepExp +'' + TxtSepExp   + '';
              WriteLn(F, TxtWriteLine);
              for NumCounter := StartTime to EndTime do begin
                TxtHour := IntToStr(NumCounter) + CtTxtHourExt + '-' +
                           IntToStr(NumCounter + 1) + CtTxtHourExt;
                 TxtWriteLine :=
                 TxtHour + TxtSepExp + FormatFloat('0.00', 0)+ ' ' +
                 DmdFpnUtils.IdtCurrencyMain + TxtSepExp + FormatFloat('0.00',0)
                 + ' ' + DmdFpnUtils.IdtCurrencyMain + TxtSepExp +
                 FormatFloat('0.00', 0) + '%' + TxtSepExp + '0' + TxtSepExp +
                 '0' + TxtSepExp + FormatFloat('0.00',  0) + ' ' +
                 DmdFpnUtils.IdtCurrencyMain + TxtSepExp + '0' + TxtSepExp +
                 '0' + TxtSepExp + FormatFloat('0.00',  0) + TxtSepExp + '';
                WriteLn(F, TxtWriteLine);
              end; // of for NumCounter := StartTime to EndTime
            end; // of if SprCAHoraire.RecordCount = 0
              DatDateFrom := DatDateFrom + 1;
          end  // of while DatDateFrom <= DatDateTo
         end;  // of  FlgHourlyCA else part
        // R2014.1.Req(42010).Detailed hourly activity 2424.TCS-SRM.End
      System.Close(F);
    end;  //  end of FlgOK
     DecimalSeparator := ChrDecimalSep;
  end;  // of else part of (number of selected days)
end;
// R2011.2- BDES – Rapport Activity schedule report-AM(TCS) - END
//==============================================================================
// R2013.2-Req(32030).Hourly-activity-report.TCS-SRM.Start
//==============================================================================
// Name        : TFrmDetCAActiviteHoraire.BuildSQLClassInformatif
// Purpose     : To build the query string for finding idtclassification
// Input/Output: Classification/Details w.r.t idtclassification
//==============================================================================
function TFrmDetCAActiviteHoraire.BuildSQLClassInformatif (Informatif : string): string;
begin  //of TFrmDetCAActiviteHoraire.BuildSQLClassInformatif
  Result :='Select * from Classification where idtClassification = '+ QuotedStr(Informatif);
end;    //of TFrmDetCAActiviteHoraire.BuildSQLClassInformatif

// R2013.2-Req(32030).Hourly-activity-report.TCS-SRM.End
//==============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FDetCAActiviteHoraire
