//================= Kingfisher IT Services (c) 2011 ==================
// Packet : Packet designed from Castorama CAQMFlash
// Unit   : FRptCAQMFlash
//-----------------------------------------------------------------------------
// History:
//  - Started from TCS - Flexpoint 2.0 - FRptCAQMFlash - CVS revision 1.0
// Version       Modified by        Reason
// 1.0           PM    (TCS)        Created for R2011.2 - BDFR - Pending Customer
// 1.1           CP    (TCS)        Regression Fix R2012.1
// 1.2           SC    (TCS)        Double Digit Cashdesh Problem Fix
// 1.3           SRM   (TCS)        R2013.2.Req(35050).Customer_Queue_Alert
//=============================================================================

unit FRptCAQMFlash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, ExtCtrls, StdCtrls, ScDBUtil, Buttons, Mask, DBCtrls, DBCGrids,
  TeEngine, Series, TeeProcs, Chart, DBChart, OvcDbPF, OvcBase, OvcEF,
  OvcPB, OvcPF, ScUtils, Db, OvcRLbl, OvcDbDLb, OvcPLb, OvcDbPLb, Printers,
  ScEHdler, ComCtrls, ScDBUtil_BDE, IniFiles, MfpnUtils;

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtDateTime          = 'Date : %s at %s';
  CtTxtDate              = 'Date : %s';
  CtNumClient            = 'Number of Clients : %d';
  CtAVGCaddy             = 'Average Caddy : %f';
  CtTxtEmInvalidPrmFlash = 'Invalid parameter(s) found : %s';
  CtTxtWarningMsg        =  'Threshold Value Exceeded' +
                             #13 + #13 + 'Please use Queue Boosting or open'  +
                             #13 + 'additional cash registers';
  CtTxtWarningMsgWithoutQB =  'Threshold Value Exceeded' +
                              #13 + #13 + 'Open additional cash registers';


  CtTxtBtnClose   = 'Close';
  CtTxtNoData     = 'No Data Exists';
  CtTxtReport     = 'Report';                                                   // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  CtTxtTitle      = 'Report Flash';                                             // Regression Fix R2012.1(Chayanika)
  CtTxtPrintDate  = 'Printed on %s at %s';                                      // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  CtTxtDatFormat  = 'dd-mm-yyyy';                                               // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM

const
  TxtFlashParamRate      = '/VRate';
  TxtFlashParamDate      = '/VDate';
  TxtFlashParamLog       = '/VLog';
  TxtFlashParamGroup     = '/VGroup';
  TxtFlashParamStatusBar = '/VStatusBar';
  TxtFlashParamIniFile   = '/IFpssyst.ini';
  TxtFlashParamWithQB    = '/VWithQB';
  TxtFlashParamWithoutQB = '/VWithoutQB';
  TxtFlashParamQMBDFR    = '/VQMBDFR';                                          // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  CtValDefaultRate       = 1;
  CtValSecondsPerMinute  = 60;
  CtTxtIniFileName       = 'Fpssyst.ini';
  //CtTxtIniPath         = 'D:\SYCRON\FlexPos\';
  //CtTxtIniPath         = '\FlexPos\Ini\FpsSyst.INI';

//=============================================================================
// TFrmRptCAQMFlash
//=============================================================================

type
  TFrmRptCAQMFlash = class(TFrmCommon)
    PnlGraphic: TPanel;
    Splitter1: TSplitter;
    SvcDBLblChiffre: TSvcDBLabelLoaded;
    SvcDBLblAVGAmount: TSvcDBLabelLoaded;
    SvcDBLblDate: TSvcDBLabelLoaded;
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
    StsBarInfo: TStatusBar;
    Series2: TFastLineSeries;
    grpWarnMsg: TGroupBox;
    lblWarnMsg: TLabel;
    btnOK: TButton;
    Timer1: TTimer;
    SvcDBLabelLoadedReport: TSvcDBLabelLoaded;                                  // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
    SvcDBLabelLoadedStoreDetail: TSvcDBLabelLoaded;                             // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
    SvcDBLabelLoadedPrintedOn: TSvcDBLabelLoaded;                               // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
    procedure FormActivate(Sender: TObject);                                    // Regression Fix R2012.1(Chayanika)
    procedure Timer1Timer(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
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
    FlgCustQBDFR   : Boolean;                                                   // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
    RefreshRateMin : Cardinal;  // Refresh Rate for the Timer (default =
                                // 60000 = 1 minute)
                                // can be overriden by run param /Rate=xx
                                // is expressed in minutes e.g. /Rate=30
                                // means refresh after 30 minutes.
    procedure BuildChart;

  end;

function GetPrgRoot (TxtFN : string) : string;

var
  FrmRptCAQMFlash: TFrmRptCAQMFlash;
  IntMargin : Integer;
  CtTxtIniPath  : String  = '\FlexPos\Ini\FpsSyst.INI';

  implementation

uses
  DFpnCAQMFlash,
  SfDialog,
  SmUtils,
  StDateSt,
  StDate,
  SmWinApi,																		// R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  DFpnUtils,																	// R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  DFpnTradeMatrix;																// R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmRptCAQMFlash';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCAQMFlash.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2013/10/15 15:24:18 $';

//=============================================================================

var
  CntLoopDebug          : Integer = 1;      // debug counter loop procedure

//*****************************************************************************
// Implementation of TFrmRptCAQMFlash
//*****************************************************************************

procedure TFrmRptCAQMFlash.FormCreate(Sender: TObject);
begin  // of TFrmRptCAQMFlash.FormCreate
  FrmRptCAQMFlash.Constraints.MinHeight := FrmRptCAQMFlash.Height;
  FrmRptCAQMFlash.Constraints.MinWidth := FrmRptCAQMFlash.Width;
  inherited;
  lblWarnMsg.Caption := CtTxtWarningMsg;
  BtnClose.Caption := CtTxtBtnClose;

  grpWarnMsg.Visible := False; // Hide the warning message at this stage
  FlgFirstRun := True;
  ReadCustomParams;
  SetRefreshRate;
  SvcLFRefreshRate.Text :=  inttostr(RefreshRateMin);
  TmrRefreshRateTimer (TmrRefreshRate);
end;   // of TFrmRptCAQMFlash.FormCreate

//=============================================================================

procedure TFrmRptCAQMFlash.FormDestroy(Sender: TObject);
begin // of TFrmRptCAQMFlash.FormDestroy
  inherited;
  if DmdFpnCAQMFlash.FlgLogToFile then
    CloseFile (DmdFpnCAQMFlash.FtxLogFile);
end;  // of TFrmRptCAQMFlash.FormDestroy

//=============================================================================
// TFrmRptCAQMFlash.TmrRefreshRateTimer : Calculate all the data and put it on
// the form after ALL the data is calculated.
//=============================================================================

procedure TFrmRptCAQMFlash.TmrRefreshRateTimer(Sender: TObject);
var
  NumTotClient     : Integer;          // Total number of clients
  NumTotAmount     : Double;           // Total amount
  NumTotClass      : Double;           // Total classifications
begin  // of TFrmRptCAQMFlash.TmrRefreshRateTimer
  inherited;
  LockWindowUpdate (Self.Handle);
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
      FlgFirstRun := False;
    end;

    FlgCurrentDate := DatTransBeginStartOrig = Date;
    // Make the refresh rate invisible for QC Defect Fix - Start
    //SvcDBLblRefreshRate.Visible := FlgCurrentDate;
    //SvcLFRefreshRate.Visible := FlgCurrentDate;
    SvcDBLblRefreshRate.Visible := False;
    SvcLFRefreshRate.Visible := False;
    // Make the refresh rate invisible for QC Defect Fix - End

    if FlgCurrentDate then
      DatTransBeginFinish := Now;


    if StsBarInfo.Visible then
      UpdateStatusBar;
    NumTotAmount := DmdFpnCAQMFlash.GetResultAmount;
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
     SvcDBLblDate.Caption := Format(CtTxtDate,[DateToStr(date)]);

    SvcDBLblChiffre.Caption := Format (CtNumClient, [NumTotClient]);

    if NumTotClient <> 0 then
      SvcDBLblAVGAmount.Caption := Format (CtAVGCaddy,
                                           [NumTotClass / NumTotClient])
    else
      SvcDBLblAVGAmount.Caption := Format (CtAVGCaddy, [0.0]);
    BuildChart;
  finally      
    TmrRefreshRate.Enabled := True;
    LockWindowUpdate (0);
  end;
end;   // of TFrmRptCAQMFlash.TmrRefreshRateTimer

//=============================================================================

procedure TFrmRptCAQMFlash.SvcLFRefreshRateAfterExit(Sender: TObject);
begin  // of TFrmRptCAQMFlash.SvcLFRefreshRateAfterExit
  inherited;    
  if SvcLFRefreshRate.AsInteger > 0 then begin
    RefreshRateMin := SvcLFRefreshRate.AsInteger;
    SetRefreshRate;
  end;
end;   // of TFrmRptCAQMFlash.SvcLFRefreshRateAfterExit

//=============================================================================

procedure TFrmRptCAQMFlash.BtnRapportClick(Sender: TObject);
var
  BmpFormAsBitMap  : TBitmap;
  FrmWithCanvas    : TForm;
  LblCaption       : TLabel;
  PnlTop           : TPanel;
  PnlBottom        : TPanel;
  ImgPrintScreen   : TImage;
begin  // of TFrmRptCAQMFlash.BtnRapportClick
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
  BmpFormAsBitMap := FrmRptCAQMFlash.GetFormImage;
  ImgPrintScreen.Picture.Graphic := BmpFormAsBitMap;
  Printer.Orientation := poLandscape;
  FrmWithCanvas.Print;

end;   // of TFrmRptCAQMFlash.BtnRapportClick

//=============================================================================

procedure TFrmRptCAQMFlash.BuildChart;
var
  NumColor        : Integer;  // Number that indicaties the color of the bar.
  FlgMarginHigh   : Boolean; // Flag to check if all cash desks are above margin.
  CashDeskName    : string;
  StrLstCashDesks : TStringList;
  IniFilCashDesks : TIniFile;
  TempStr         : string ;
  IntFlag         : integer ;
  TxtPath         : string;
  StrLstTemp      : TStringList;
  PrimaryCount    : integer ;
  UpdatedMargin   : integer ;
  IndexOfStrLst   : integer;    //Double Digit Cashdesh Problem Fix
begin  // of TFrmRptCAQMFlash.BuildChart
  IntFlag :=0;
  Series1.Clear;
  FlgMarginHigh := True;
  StrLstCashDesks :=  TStringList.Create;
  StrLstCashDesks.Clear;
  StrLstTemp :=  TStringList.Create;
  StrLstTemp.Clear;
  PrimaryCount := 0;
  IniFilCashDesks := nil;
  TxtPath := GetPrgRoot(CtTxtIniPath);
  OpenIniFile (TxtPath, IniFilCashDesks);
  UpdatedMargin :=  IniFilCashDesks.ReadInteger('AskQManagement', 'NumClientAsk', 0);

  if DmdFpnCAQMFlash.QryAmount.RecordCount = 0 then begin
     grpWarnMsg.Visible := False;
     EXIT;
  end
  else
  if not IniFilCashDesks.SectionExists ('QCashDesk') then  begin
    grpWarnMsg.Visible := False;
    EXIT;
  end;
  IniFilCashDesks.ReadSectionValues ('QCashDesk', StrLstTemp);                  //Double Digit Cashdesh Problem Fix
  //Double Digit Cashdesh Problem Fix--start
  for IndexOfStrLst := 0 to (StrLstTemp.Count - 1) do begin
    StrLstCashDesks.Add(StrLstTemp.Names[IndexOfStrLst]);
  end;
  //Double Digit Cashdesh Problem Fix--end
  DmdFpnCAQMFlash.QryAmount.First;
  NumColor := (DmdFpnCAQMFlash.QryAmount.FieldByName ('CashRegNum').AsInteger);
  Series2.Clear;
  Series2.AddXY(0,UpdatedMargin, '', NumColor);
  while not DmdFpnCAQMFlash.QryAmount.Eof do begin
    CashDeskName := 'CashDesk'+DmdFpnCAQMFlash.QryAmount.FieldByName ('CashRegNum').AsString;
    PrimaryCount := 0; //reset the counter
    While not (PrimaryCount >= StrLstCashDesks.Count) do begin //loop through the string list
     TempStr := StrLstCashDesks[PrimaryCount];  //Double Digit Cashdesh Problem Fix 
      if(TempStr = CashDeskName) then  begin
        IntFlag := 1;
        Series1.AddBar
          (DmdFpnCAQMFlash.QryAmount.FieldByName ('CustomerNumber').AsFloat,
           DmdFpnCAQMFlash.QryAmount.FieldByName ('CashRegNum').AsString,
           NumColor);
        NumColor := (NumColor * (NumColor + 99)) *
                DmdFpnCAQMFlash.QryAmount.FieldByName ('CashRegNum').AsInteger;


        if DmdFpnCAQMFlash.QryAmount.FieldByName ('CustomerNumber').AsFloat <= UpdatedMargin then
          FlgMarginHigh := False;
      end;  //End of if(TempStr = CashDeskName)
      PrimaryCount := PrimaryCount + 1;
    end; //End of  PrimaryCount >= StrLstCashDesks.Count
    DmdFpnCAQMFlash.QryAmount.Next;  
  end;

  DmdFpnCAQMFlash.QryAmount.Last;
  Series2.AddXY(DmdFpnCAQMFlash.QryAmount.FieldByName ('CashRegNum').AsFloat,UpdatedMargin, '', NumColor);

  DmdFpnCAQMFlash.QryAmount.First;
  DBChtStatus.Foot.Text.Clear;
  DBChtStatus.Foot.Text.Add
    (FormatDateTime ('dd/mm/yyyy', DatTransBeginStart) + ' ' +
     FormatDateTime ('hh:mm:ss', DatTransBeginStart));
 if(IntFlag = 0) then
    FlgMarginHigh := False;
 If FlgMarginHigh = True then begin
    grpWarnMsg.Visible := True;
    FlgMarginHigh := False;
 end
 else
   grpWarnMsg.Visible := False;
 IniFilCashDesks.Free;  
 FreeAndNil(StrLstTemp);
 FreeAndNil(StrLstCashDesks);   
end;   // of TFrmRptCAQMFlash.BuildChart

//=============================================================================
// TFrmRptCAQMFlash.FormResize : When resizing the form, it's needed to
// recalculated the panelheight of the DBCtrlGrids.
//=============================================================================

procedure TFrmRptCAQMFlash.FormResize(Sender: TObject);
begin
  inherited;
end;

//=============================================================================
// TFrmRptCAQMFlash.ReadCustomParams : reads the run parameters to the proper
// properties.
// Possible parameters are :
//        --> /Rate=xx where xx is the refresh rate in minutes of
//            the timer.
//            If parameter is omitted then refresh rate is 1 minute.
//        --> /Date=dd/mm/yyyy : data will be fetched for the given date
//                               if parameter is omitted the Date=now
//=============================================================================

procedure TFrmRptCAQMFlash.ReadCustomParams;
var
  TxtSplitRight    : string;           // Right part of a split
  TxtSplitLeft     : string;           // Left part of a split
  CntParam         : Integer;          // Loop-variable number of params
  TxtParam         : string;           // Parameter to check
  TxtMessage       : string;           // errormessage
  TxtFNIni         : string;           // Filename ini-file
  IniCfg           : TIniFile;         // Ini-object to read configuration
  TxtPath          : string;           // Application path
  TxtStoreName     : string;           // Store Name							// R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
begin // of TFrmRptCAQMFlash.ReadCustomParams
  // Setting default parameters
  RefreshRateMin := CtValDefaultRate;
  DatTransBeginStart := 0;
  DmdFpnCAQMFlash.FlgLogToFile := False;
  SvcDBLabelLoadedReport.Visible := False;                                      // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  SvcDBLabelLoadedStoreDetail.Visible := False;                                 // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
  SvcDBLabelLoadedPrintedOn.Visible := False;                                   // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM
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
        DmdFpnCAQMFlash.FlgLogToFile := True;
        AssignFile (DmdFpnCAQMFlash.FtxLogFile, CtTxtLogFNname);
        Rewrite (DmdFpnCAQMFlash.FtxLogFile);
      end
      else if (AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamStatusBar)),
          TxtFlashParamStatusBar) = 0) then begin
        StsBarInfo.Visible := True;
      end
      else if (AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamGroup)),
          TxtFlashParamGroup) = 0) then begin
          DmdFpnCAQMFlash.FlgGroup := True;
      end
      else if (AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamIniFile)),
          TxtFlashParamIniFile) = 0) then begin
          TxtPath := GetPrgRoot(CtTxtIniPath);
          TxtFNIni := ReplaceEnvVar (TxtPath);
          IniCfg := nil;
          OpenIniFile (TxtFNIni, IniCfg);
          IntMargin :=  IniCfg.ReadInteger('AskQManagement', 'NumClientAsk', 0);
      end
      else if(AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamWithQB)),
          TxtFlashParamWithQB) = 0) then begin
          lblWarnMsg.Caption := CtTxtWarningMsg;
      end
      else if(AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamWithoutQB)),
          TxtFlashParamWithoutQB) = 0) then begin
          lblWarnMsg.Caption := CtTxtWarningMsgWithoutQB;
      end
      // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM.start
      else if(AnsiCompareText (Copy ( TxtParam, 0, Length (TxtFlashParamQMBDFR)),
          TxtFlashParamQMBDFR) = 0) then begin
          BtnRapport.Visible := True;             
          FlgCustQBDFR := True;
          SvcDBLblDate.Visible := False;
          SvcDBLabelLoadedReport.Visible := True;                              
          SvcDBLabelLoadedStoreDetail.Visible := True;
          SvcDBLabelLoadedPrintedOn.Visible := True;                         
          SvcDBLabelLoadedReport.caption := CtTxtReport +' : ' + CtTxtTitle;
          if not Assigned (DmdFpnTradeMatrix) then
             DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Application);
          if not Assigned (DmdFpnUtils) then
             DmdFpnUtils := TDmdFpnUtils.Create (Application);
          TxtStoreName := Trim(DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtCodPost'] + '  ' +
               DmdFpnTradeMatrix.InfoTradeMatrix [
               DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip']);
          SvcDBLabelLoadedStoreDetail.caption :=   TxtStoreName;
          SvcDBLabelLoadedPrintedOn.Caption :=
               Format (CtTxtPrintDate,[FormatDateTime (CtTxtDatFormat, Now),
               FormatDateTime (CtTxtHouFormat, Now)]);
      end
      // R2013.2.Req(35050).Customer_Queue_Alert.TCS-SRM.end
      else begin
        TxtMessage := Format (CtTxtEmInvalidPrmFlash, [TxtParam]);
        MessageDlg (TxtMessage, mtError, [mbOK], 0);
        Application.Terminate;
        Application.ProcessMessages;
      end;
    end;
  end;
  IniCfg.Free;
end;  // of TFrmRptCAQMFlash.ReadCustomParams

//=============================================================================
// TFrmRptCAQMFlash.ConvertDatParamToDateTime : converts two strings (date + time)
// to a valid DateTime value regardless of the date separator.
//                                  -----
// INPUT   : TxtDate = string in a format of dd-mm-yyyy or dd/mm/yyyy
//           TxtTime = string in a format of hh:mm:ss
//                                  -----
// OUTPUT  : Variable = comment
//=============================================================================

function TFrmRptCAQMFlash.ConvertDatParamToDateTime (TxtDate : string ;
                                                   TxtTime : string): TDateTime;
var
  StDatTemp        : TStDate;           // temporary for StDate variable
  StTmTemp         : TStTime;           // temporary for StTime variable
begin // of TFrmRptCAQMFlash.ConvertDatParamToDateTime
  try
    StDatTemp := DateStringToStDate (SmUtils.CtTxtDatFormat, TxtDate,
                                     SmUtils.CtValEpoch);
    StTmTemp  := TimeStringToStTime (SmUtils.CtTxtHouFormat,
                                       TxtTime);
    Result := StDateAndTimeToDateTime (StDatTemp, StTmTemp);
  finally
  end;
end;  // of TFrmRptCAQMFlash.ConvertDatParamToDateTime

//=============================================================================
// TFrmRptCAQMFlash.UpdateStatusBar : puts info in statusbar concerning choosen
// periods.
//=============================================================================

procedure TFrmRptCAQMFlash.UpdateStatusBar;

begin // of TFrmRptCAQMFlash.UpdateStatusBar  
  StsBarInfo.Panels[1].Text :=  TimeToStr(Now);
  Inc (CntLoopDebug);
end;  // of TFrmRptCAQMFlash.UpdateStatusBar

//=============================================================================
// TFrmRptCAQMFlash.SetRefreshRate : sets the interval of the timer
//=============================================================================

procedure TFrmRptCAQMFlash.SetRefreshRate;
begin // of TFrmRptCAQMFlash.SetRefreshRate
  TmrRefreshRate.Interval := RefreshRateMin * 1000;
end;  // of TFrmRptCAQMFlash.SetRefreshRate

//=============================================================================
// TFrmRptCAQMFlash.GetPrgRoot : gets the envioronment variable PrgROOT
//                               to get the path of the file TxtFN
//=============================================================================
function GetPrgRoot (TxtFN : string) : string;
var
  TxtS             : string;
begin  // of GetPrgRoot
  TxtS := ReplaceEnvVar ('%PrgROOT%');
  if TxtS <> '' then
    Result := TxtS + TxtFN
  else
    Result := AddStartDirToFN (TxtFN);
end;   // of GetPrgRoot
//=============================================================================

procedure TFrmRptCAQMFlash.btnOKClick(Sender: TObject);
begin
  inherited;
  grpWarnMsg.Visible := False;
end;

procedure TFrmRptCAQMFlash.Timer1Timer(Sender: TObject);
begin
  inherited;
  
  StsBarInfo.Panels[0].Text := TimeToStr(Now);
end;
//============================================================================
// Regression Fix R2012.1(Chayanika):: Start
procedure TFrmRptCAQMFlash.FormActivate(Sender: TObject);
begin
  inherited;
  Application.Title := CtTxtTitle;
  FrmRptCAQMFlash.Caption := CtTxtTitle;
end;
// Regression Fix R2012.1(Chayanika):: End

//============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of TFrmRptCAQMFlash
