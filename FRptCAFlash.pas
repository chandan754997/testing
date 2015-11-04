//================= Real Software - Retail Division (c) 2006 ==================
// Packet : Packet designed from Castorama CAFlash
// Unit   : FRptCAFlash
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCAFlash.pas,v 1.6 2007/10/24 15:24:18 smete Exp $
// History:
//  - Started from Castorama - Flexpoint 2.0 - FRptCAFlash - CVS revision 1.4
// Version        ModifiedBy     Reason
// 1.1            TK   (TCS)     R2012.1 Applix 2463806 All OPCO PCAFlash Refresh Issue
//=============================================================================
// Information : PDW - 30/01/03 :
// Added : 2 parameters
//  1) /VRate=xx : Overrides the default refresh rate (=1 minute) of the timer
//                 expressed in minutes.
//  2) /VDate : Overrides the current date (can be called from other
//              application)
// Changed the way of retrieving the data :
// it used to delete and recreate the #CAFlash temporary SQL-table each time the
// timer was trigger'd.  Now it creates the table ONCE and then simply adds new
// found data.  This is made possible by storing the previous end-datetime
// incremented with one second and use it as the begindate in the next fetch.

unit FRptCAFlash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, ExtCtrls, StdCtrls, ScDBUtil, Buttons, Mask, DBCtrls, DBCGrids,
  TeEngine, Series, TeeProcs, Chart, DBChart, OvcDbPF, OvcBase, OvcEF,
  OvcPB, OvcPF, ScUtils, Db, OvcRLbl, OvcDbDLb, OvcPLb, OvcDbPLb, Printers,
  ScEHdler, ComCtrls, ScDBUtil_BDE;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtDateTime          = 'Date : %s at %s';
  CtTxtDate              = 'Date : %s';
  CtNumClient            = 'Number of Clients : %d';
  CtAVGCaddy             = 'Average Caddy : %f';
  CtTxtEmInvalidPrmFlash = 'Invalid parameter(s) found : %s';

const
  TxtFlashParamRate      = '/VRate';
  TxtFlashParamDate      = '/VDate';
  TxtFlashParamLog       = '/VLog';
  TxtFlashParamGroup     = '/VGroup';
  TxtFlashParamStatusBar = '/VStatusBar';
  CtValDefaultRate       = 1;
  CtValSecondsPerMinute  = 60;

//=============================================================================
// TFrmRptCAFlash
//=============================================================================

type
  TFrmRptCAFlash = class(TFrmCommon)
    PnlCipher: TPanel;
    PnlGraphic: TPanel;
    Splitter1: TSplitter;
    SvcDBLblChiffre: TSvcDBLabelLoaded;
    SvcDBLblAVGAmount: TSvcDBLabelLoaded;
    SvcDBLblDate: TSvcDBLabelLoaded;
    OvcController1: TOvcController;
    TmrRefreshRate: TTimer;
    dsrClassifications: TDataSource;
    dsrAmounts: TDataSource;
    DBChtStatus: TChart;
    Series1: TBarSeries;
    PnlButton: TPanel;
    BtnClose: TBitBtn;
    BtnRapport: TBitBtn;
    SvcDBLblRefreshRate: TSvcDBLabelLoaded;
    SvcLFRefreshRate: TSvcLocalField;
    Panel1: TPanel;
    SvcDBLFAmountTotAmount: TSvcLocalField;
    DBCtlGrdAmount: TDBCtrlGrid;
    Shape1: TShape;
    Splitter2: TSplitter;
    Panel2: TPanel;
    DBCtlGrdClassification: TDBCtrlGrid;
    Shape2: TShape;
    SvcDBLFClassTotAmount: TSvcLocalField;
    StsBarInfo: TStatusBar;
    DBTxtClassifQtyArt: TDBText;
    DBTxtClassifValue: TDBText;
    DBTxtClassifTxtPublDescr: TDBText;
    DBTxtClassifIdtMember: TDBText;
    DBText8: TDBText;
    DBTxtAmountsTxtPublDescr: TDBText;
    DBTxtAmountQtyArt: TDBText;
    DBTxtAmountsValue: TDBText;
    procedure TmrRefreshRateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SvcLFRefreshRateAfterExit(Sender: TObject);
    procedure BtnRapportClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  protected
    { Protected declarations }
    procedure ReadCustomParams;
    procedure UpdateStatusBar;
    procedure SetRefreshRate;
    function ConvertDatParamToDateTime (TxtDate : string ;
                                        TxtTime : string): TDatetime;
  public
    { Public declarations }
    FlgFirstRun            : Boolean;
    DatTransBeginStartOrig : TDateTime;
    DatTransBeginStart     : TDateTime;
    DatTransBeginFinish    : TDateTime;
    DatLoadedStart         : TDateTime; // to save the time to where the
                                        // previous fetch came.  This datetime
                                        // is used as a starting point for the
                                        // DatLoaded in the next fetch.
    FlgCurrentDate : Boolean;         // if the date being viewed is not the
                                      // current date then the Refresh rate
                                      // should not be shown (new tickets can
                                      // never be made in the past)
                                      // also the rate can be set to zero
                                      // because there won't be any new data
                                      // coming from the server for a date in
                                      // the past.
    RefreshRateMin : Cardinal;  // Refresh Rate for the Timer (default =
                                // 60000 = 1 minute)
                                // can be overriden by run param /Rate=xx
                                // is expressed in minutes e.g. /Rate=30
                                // means refresh after 30 minutes.
    procedure BuildChart;
  end;

var
  FrmRptCAFlash: TFrmRptCAFlash;

implementation

uses
  DFpnCAFlash,
  SfDialog,
  SmUtils,
  StDateSt,
  StDate,
  SmWinApi;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmRptCAFlash';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCAFlash.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/10/01 15:24:18 $';

//=============================================================================

var
  CntLoopDebug          : Integer = 1;      // debug counter loop procedure

//*****************************************************************************
// Implementation of TFrmRptCAFlash
//*****************************************************************************

procedure TFrmRptCAFlash.FormCreate(Sender: TObject);
begin  // of TFrmRptCAFlash.FormCreate
  FrmRptCAFlash.Constraints.MinHeight := FrmRptCAFlash.Height;
  FrmRptCAFlash.Constraints.MinWidth := FrmRptCAFlash.Width;
  inherited;
  FlgFirstRun := True;
  ReadCustomParams;
  SetRefreshRate;
  // due to some kind of bug in Delphi the following properties must be set
  // in runtime.  Behaviour in designtime: after save of form these controls
  // will move to the utmost right position and disappears from the grid.
  DBTxtAmountQtyArt.Anchors  := [akTop, akRight];
  DBTxtAmountsValue.Anchors  := [akTop, akRight];
  DBTxtAmountQtyArt.Left     := 202;
  DBTxtAmountsValue.Left     := 276;
  DBTxtClassifQtyArt.Anchors := [akTop, akRight];
  DBTxtClassifValue.Anchors  := [akTop, akRight];
  DBTxtClassifQtyArt.Left    := 202;
  DBTxtClassifValue.Left     := 276;
  DmdFpnCAFlash.CreateTempTable;
  TmrRefreshRateTimer (TmrRefreshRate);
end;   // of TFrmRptCAFlash.FormCreate

//=============================================================================

procedure TFrmRptCAFlash.FormDestroy(Sender: TObject);
begin // of TFrmRptCAFlash.FormDestroy
  inherited;
  if DmdFpnCAFlash.FlgLogToFile then
    CloseFile (DmdFpnCAFlash.FtxLogFile);
end;  // of TFrmRptCAFlash.FormDestroy

//=============================================================================
// TFrmRptCAFlash.TmrRefreshRateTimer : Calculate all the data and put it on
// the form after ALL the data is calculated.
//=============================================================================

procedure TFrmRptCAFlash.TmrRefreshRateTimer(Sender: TObject);
var
  NumTotClient     : Integer;          // Total number of clients
  NumTotAmount     : Double;           // Total amount
  NumTotClass      : Double;           // Total classifications
  FlgFirstTime     : Boolean;          // First Time that procedure is run ?
begin  // of TFrmRptCAFlash.TmrRefreshRateTimer
  inherited;
  LockWindowUpdate (Self.Handle);
  FlgFirstTime := False;
  try

    // Check to see if DatTransBeginStart is already filled with a run parameter
    // coming from /VDate=dd/mm/yyyy
    if DatTransBeginStart = 0 then begin
      DatTransBeginStart := Date;
      DatTransBeginFinish := Now;
    end;

    If FlgFirstRun then begin
      // Save original date settings
      DatTransBeginStartOrig := DatTransBeginStart;
      DatLoadedStart := DatTransBeginStart;
      FlgFirstTime := True;
      // Fill the temporary table
      DmdFpnCAFlash.ClearTempTable;
      FlgFirstRun := False;
    end
//R2012.1 Applix 2463806 All OPCO PCAFlash Refresh Issue TCS-TK START
    else
      DmdFpnCAFlash.ClearTempTable;
//R2012.1 Applix 2463806 All OPCO PCAFlash Refresh Issue TCS-TK END
    FlgCurrentDate := DatTransBeginStartOrig = Date;
    SvcDBLblRefreshRate.Visible := FlgCurrentDate;
    SvcLFRefreshRate.Visible := FlgCurrentDate;

    if FlgCurrentDate then
      DatTransBeginFinish := Now;

    DmdFpnCAFlash.FillTempTable (DatTransBeginStart, DatTransBeginFinish,
                             DatLoadedStart, FlgFirstTime);
    if StsBarInfo.Visible then
      UpdateStatusBar;
    // Get the information of the temporary table.
    NumTotClient := DmdFpnCAFlash.GetTotalClients (DatTransBeginStart,
                      DatTransBeginFinish);
    NumTotAmount := DmdFpnCAFlash.GetResultAmount;
    NumTotClass  := DmdFpnCAFlash.GetResultClass;

    SvcDBLFAmountTotAmount.AsExtended := NumTotAmount;
    SvcDBLFClassTotAmount.AsExtended  := NumTotClass;

    if FlgCurrentDate then begin
      DatLoadedStart := DatTransBeginFinish;
      DatTransBeginStart := DatLoadedStart;
      // When a date is shown older than the current date then there is no need
      // to show the time on which the last data was fetched.  Therefore only
      // the date is shown.
      SvcDBLblDate.Caption := Format (CtTxtDateTime,
         [DateToStr(DatTransBeginFinish), TimeToStr(DatTransBeginFinish)]);
    end
    else
     SvcDBLblDate.Caption := Format(CtTxtDate,[DateToStr(DatTransBeginFinish)]);

    SvcDBLblChiffre.Caption := Format (CtNumClient, [NumTotClient]);

    if NumTotClient <> 0 then
      SvcDBLblAVGAmount.Caption := Format (CtAVGCaddy,
                                           [NumTotClass / NumTotClient])
    else
      SvcDBLblAVGAmount.Caption := Format (CtAVGCaddy, [0.0]);
    BuildChart;
  finally
    TmrRefreshRate.Enabled := FlgCurrentDate;
    LockWindowUpdate (0);
  end;
end;   // of TFrmRptCAFlash.TmrRefreshRateTimer

//=============================================================================

procedure TFrmRptCAFlash.SvcLFRefreshRateAfterExit(Sender: TObject);
begin  // of TFrmRptCAFlash.SvcLFRefreshRateAfterExit
  inherited;
  TmrRefreshRate.Interval := SvcLFRefreshRate.AsInteger * CtValSecondsPerMinute
                             * 1000;
end;   // of TFrmRptCAFlash.SvcLFRefreshRateAfterExit

//=============================================================================

procedure TFrmRptCAFlash.BtnRapportClick(Sender: TObject);
var
  BmpFormAsBitMap  : TBitmap;
  FrmWithCanvas    : TForm;
  LblCaption       : TLabel;
  PnlTop           : TPanel;
  PnlBottom        : TPanel;
  ImgPrintScreen   : TImage;
begin  // of TFrmRptCAFlash.BtnRapportClick
  inherited;
  FrmWithCanvas := TForm.Create (Self);
  FrmWithCanvas.Width := Self.Width;
  FrmWithCanvas.Height := Self.Height;

  PnlTop := TPanel.Create (FrmWithCanvas);
  PnlBottom := TPanel.Create (FrmWithCanvas);
  PnlTop.Parent := FrmWithCanvas;
  PnlBottom.Parent := FrmWithCanvas;
  PnlTop.AutoSize := True;
  PnlTop.Align := alTop;
  PnlTop.BevelInner := bvNone;
  PnlTop.BevelOuter := bvNone;
  PnlBottom.AutoSize := True;
  PnlBottom.Align := alClient;
  PnlBottom.BevelInner := bvNone;
  PnlBottom.BevelOuter := bvNone;
  LblCaption := TLabel.Create (FrmWithCanvas);
  LblCaption.Parent := PnlTop;
  FrmWithCanvas.Height := FrmWithCanvas.Height + PnlTop.Height;
  LblCaption.Caption := GetVersionInfoKey (ParamStr (0), 'ApplicationTitle');
  LblCaption.Font.Size := 25;
  LblCaption.Font.Style := LblCaption.Font.Style + [fsBold];

  ImgPrintScreen := TImage.Create (FrmWithCanvas);
  ImgPrintScreen.Parent := PnlBottom;
  ImgPrintScreen.Align := alClient;
  ImgPrintScreen.Stretch := True;
  BmpFormAsBitMap := FrmRptCAFlash.GetFormImage;
  ImgPrintScreen.Picture.Graphic := BmpFormAsBitMap;
  Printer.Orientation := poLandscape;
  FrmWithCanvas.Print;

(** PDW - begin - old version dd. 21-03-03 - **)
//   Printer.Orientation := poLandscape;
//   FrmRptCAFlash.Print;
(** PDW - end **)
end;   // of TFrmRptCAFlash.BtnRapportClick

//=============================================================================

procedure TFrmRptCAFlash.BuildChart;
var
  NumColor         : Integer;          // Number that indicaties the color of
                                       // the bar.
begin  // of TFrmRptCAFlash.BuildChart
  Series1.Clear;
  dsrClassifications.DataSet.First;
  NumColor := (dsrClassifications.DataSet.FieldByName ('IdtMember').AsInteger);
  while not dsrClassifications.DataSet.Eof do begin
    Series1.AddBar
      (dsrClassifications.DataSet.FieldByName ('Waarde').AsFloat,
       dsrClassifications.DataSet.FieldByName ('TxtPublDescr').AsString,
       NumColor);
    dsrClassifications.DataSet.Next;
    NumColor := (NumColor * (NumColor + 99)) *
                dsrClassifications.DataSet.FieldByName ('IdtMember').AsInteger;
  end;
  dsrClassifications.DataSet.First;
  DBChtStatus.Foot.Text.Clear;
  DBChtStatus.Foot.Text.Add
    (FormatDateTime ('dd/mm/yyyy', DatTransBeginStart) + ' ' +
     FormatDateTime ('hh:mm:ss', DatTransBeginStart));
end;   // of TFrmRptCAFlash.BuildChart

//=============================================================================
// TFrmRptCAFlash.FormResize : When resizing the form, it's needed to
// recalculated the panelheight of the DBCtrlGrids.
//=============================================================================

procedure TFrmRptCAFlash.FormResize(Sender: TObject);
var
  NumDisponible    : Integer;
begin
  inherited;
  NumDisponible := Shape1.Top - DBCtlGrdAmount.Top;
  DBCtlGrdAmount.RowCount := NumDisponible div 20;
  DBCtlGrdAmount.PanelHeight := 20;

  NumDisponible := Shape2.Top - DBCtlGrdClassification.Top;
  DBCtlGrdClassification.RowCount := NumDisponible div 20;
  DBCtlGrdClassification.PanelHeight := 20;
end;

//=============================================================================
// TFrmRptCAFlash.ReadCustomParams : reads the run parameters to the proper
// properties.
// Possible parameters are :
//        --> /Rate=xx where xx is the refresh rate in minutes of
//            the timer.
//            If parameter is omitted then refresh rate is 1 minute.
//        --> /Date=dd/mm/yyyy : data will be fetched for the given date
//                               if parameter is omitted the Date=now
//=============================================================================

procedure TFrmRptCAFlash.ReadCustomParams;
var
  TxtSplitRight    : string;           // Right part of a split
  TxtSplitLeft     : string;           // Left part of a split
  CntParam         : Integer;          // Loop-variable number of params
  TxtParam         : string;           // Parameter to check
  TxtMessage       : string;           // errormessage
begin // of TFrmRptCAFlash.ReadCustomParams
  // Setting default parameters
  RefreshRateMin := CtValDefaultRate;
  DatTransBeginStart := 0;
  DmdFpnCAFlash.FlgLogToFile := False;
  if ParamCount > 0 then begin
    for cntParam := 1 to Paramcount do begin
      TxtParam := ParamStr (CntParam);
      // Handle Refresh Rate parameter
      if (Length (TxtParam) > Length (TxtFlashParamRate)) and
         (AnsiCompareText (Copy (TxtParam, 0, Length (TxtFlashParamRate)),
          TxtFlashParamRate) = 0) then begin
        SplitString (TxtParam, '=', TxtSplitLeft, TxtSplitRight);
        try
          RefreshRateMin := StrToInt (TxtSplitRight);
        except
          on EConvertError do begin
            TxtMessage := Format (CtTxtEmInvalidPrmFlash, [TxtParam]);
            MessageDlg (TxtMessage, mtError, [mbOK], 0);
            Application.Terminate;
            Application.ProcessMessages;            
          end;
        end;
      end
      // Handle Date parameter
      else if (Length (TxtParam) = Length (TxtFlashParamDate) + 11) and
              (AnsiCompareText (Copy (TxtParam, 0, Length (TxtFlashParamDate)),
               TxtFlashParamDate) = 0) then begin
        SplitString (TxtParam, '=', TxtSplitLeft, TxtSplitRight);
        try
          DatTransBeginStart :=
                          ConvertDatParamToDateTime (TxtSplitRight, '00:00:00');
          DatTransBeginFinish :=
                          ConvertDatParamToDateTime (TxtSplitRight, '23:59:59');
        except
          on E:Exception do begin
            TxtMessage := Format (CtTxtEmInvalidPrmFlash, [TxtParam]);
            MessageDlg (TxtMessage, mtError, [mbOK], 0);
            Application.Terminate;
            Application.ProcessMessages;
          end;
        end;
      end
      // Handle Log parameter
      else if (AnsiCompareText (Copy (TxtParam, 0, Length (TxtFlashParamLog)),
          TxtFlashParamLog) = 0) then begin
        DmdFpnCAFlash.FlgLogToFile := True;
        AssignFile (DmdFpnCAFlash.FtxLogFile, CtTxtLogFNname);
        Rewrite (DmdFpnCAFlash.FtxLogFile);
      end
      else if (AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamStatusBar)),
          TxtFlashParamStatusBar) = 0) then begin
        StsBarInfo.Visible := True;
      end
      else if (AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamGroup)),
          TxtFlashParamGroup) = 0) then begin
          DmdFpnCAFlash.FlgGroup := True;
      end
      else begin
        TxtMessage := Format (CtTxtEmInvalidPrmFlash, [TxtParam]);
        MessageDlg (TxtMessage, mtError, [mbOK], 0);
        Application.Terminate;
        Application.ProcessMessages;
      end;
    end;
  end;
end;  // of TFrmRptCAFlash.ReadCustomParams

//=============================================================================
// TFrmRptCAFlash.ConvertDatParamToDateTime : converts two strings (date + time)
// to a valid DateTime value regardless of the date separator.
//                                  -----
// INPUT   : TxtDate = string in a format of dd-mm-yyyy or dd/mm/yyyy
//           TxtTime = string in a format of hh:mm:ss
//                                  -----
// OUTPUT  : Variable = comment
//=============================================================================

function TFrmRptCAFlash.ConvertDatParamToDateTime (TxtDate : string ;
                                                   TxtTime : string): TDateTime;
var
  StDatTemp        : TStDate;           // temporary for StDate variable
  StTmTemp         : TStTime;           // temporary for StTime variable
begin // of TFrmRptCAFlash.ConvertDatParamToDateTime
  try
    StDatTemp := DateStringToStDate (SmUtils.CtTxtDatFormat, TxtDate,
                                     SmUtils.CtValEpoch);
    StTmTemp  := TimeStringToStTime (SmUtils.CtTxtHouFormat,
                                       TxtTime);
    Result := StDateAndTimeToDateTime (StDatTemp, StTmTemp);
  finally
  end;
end;  // of TFrmRptCAFlash.ConvertDatParamToDateTime

//=============================================================================
// TFrmRptCAFlash.UpdateStatusBar : puts info in statusbar concerning choosen
// periods.
//=============================================================================

procedure TFrmRptCAFlash.UpdateStatusBar;
var
  TxtTotalRec      : string;           // total recs in CAFlash file
begin // of TFrmRptCAFlash.UpdateStatusBar
  TxtTotalRec := Format('%d', [DmdFpnCAFlash.GetTotalRecords]);
  StsBarInfo.Panels[0].Text :=
    FormatDateTime ('dd/mm/yy 00:00:00 ', DatTransBeginStart) +
    '- ' + FormatDateTime ('dd/mm/yy hh:mm:ss', DatTransBeginFinish);
  StsBarInfo.Panels[1].Text :=
    FormatDateTime ('dd/mm/yy hh:mm:ss ', DatLoadedStart) +
    '- ' + FormatDateTime ('dd/mm/yy hh:mm:ss', DatTransBeginFinish);
  StsBarInfo.Panels[2].Text := 'Current Date: ' + BoolToStr (FlgCurrentDate, 'Y') +
        ' - TriggerCount: ' + IntToStr (CntLoopDebug) +
        ' - Records: ' + TxtTotalRec;
  Inc (CntLoopDebug);
end;  // of TFrmRptCAFlash.UpdateStatusBar

//=============================================================================
// TFrmRptCAFlash.SetRefreshRate : sets the interval of the timer
//=============================================================================

procedure TFrmRptCAFlash.SetRefreshRate;
begin // of TFrmRptCAFlash.SetRefreshRate
  TmrRefreshRate.Interval := RefreshRateMin * CtValSecondsPerMinute * 1000;
  SvcLFRefreshRate.AsInteger := RefreshRateMin;
end;  // of TFrmRptCAFlash.SetRefreshRate

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of TFrmRptCAFlash
