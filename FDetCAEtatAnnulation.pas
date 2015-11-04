//============== Copyright 2010 (c) KITS -  All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer : Brico Depot
// Unit     : FDetCAEtatAnnulation.PAS :  Annulation Ticket sans(3801)-R2012
//-----------------------------------------------------------------------------
// PVCS   : $Header: $
// Version     Modified by     Reason
// 1.0         AKS  (TCS)      Initial version created for Annulation Ticket sans(3801)-R2012
// 1.1         SM   (TCS)      Defect Fix 72
// 1.2         CP   (TCS)      R2012.1 Defect fix 193
// 1.3         SM   (TCS)      R2012.1 Defect fix 187
// 1.4         CP   (TCS)      R2012.1 Defect fix 187
// 1.5         SC   (TCS)      R2013-Req26100-BDES-TicketCancellation
// 1.6         AS   (TCS)      R2013.1- Internal DefectFix(705)
// 1.7         SC   (TCS)      R2013.1- Internal DefectFix(761,763)
// 1.8         SC   (TCS)      R2013.1- Internal DefectFix(827)
// 1.9         SC   (TCS)      R2013.1- Internal DefectFix(838)
// 2.0         SC   (TCS)      R2013.1- HPQC defectfix (16,17)
// 2.1         CP   (TCS)      R2013.1- HPQC defectfix (66)
// 2.2         SMB  (TCS)      R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================


unit FDetCAEtatAnnulation;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  FDetGeneralCA, ExtDlgs, DB, DBTables, ScAppRun, ScEHdler, Buttons, ComCtrls,
  ScUtils,SfVSPrinter7, SmVSPrinter7Lib_TLB,IniFiles, ScDBUtil_BDE;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring          // of header
  CtTxtCanceTicket      = 'Annulation Ticket';
  CtTxtNoData           = 'No data for this daterange';
  CtTxtGlobal           = 'Global Report' ;
  CtTxtDetail           = 'Detail Report'  ;
  CtTxtMotif            = 'Report';
  CtTxtAll              = 'All';
  CtTxtReason           = 'Reason';
resourcestring          // of table header.

  CtTxtPrintDateCAFR    = 'Printed on %s ';                                     //R2013.1-defect 838-Fix(sc)
  CtTxtPrintDateBDES    = 'Printed on %s at %s';                                //R2013.1-defect 838-Fix(sc)
  CtTxtReportDate       = 'Report from %s to %s';
  CtTxtStartEndDate     = 'Startdate is after enddate!';
  CtTxtStartFuture      = 'Startdate is in the future!';
  CtTxtEndFuture        = 'Enddate is in the future!';
  CtTxtErrorHeader      = 'Incorrect Date';
  CtTxtPeriod           = 'Period';

  CtTxtDate             = 'Date';
  CtTxtNumOper          = 'Operator';
  CtTxtNumCashDesk      = 'CashRegister';
  CtTxtNumAnnul         = 'Number of Cancelation';
  CtTxtSuperVisor       = 'Authorisation';                                      //R2013-Req26100-BDES-TicketCancellation-TCS-SC
  CtTxtAmount           = 'Amount';
  CtTxtHour             = 'Hour';
  CtTxtMotive           = 'Motive';
  CtTxtNumTicket        = 'Ticket No';
  CtTxtNoReason         = 'No Reason Selected';
  CtTxtTotalPeriod      = 'Total Period';
  CtTxtNoCancelation    = 'No Cancelation for operator %s for this period';
  CtTxtQuantity         = 'Qty';
resourcestring          //of Total
  CtTxtSubTot           = 'SubTotal';
  CtTxtTotal            = 'Total';


resourcestring          // of run parameters
  CtTxtOPCOName         = '/VBDES=VBDES Ticket cancellation report for BDES';    //R2013-Req26100-BDES-TicketCancellation-TCS-SC

resourcestring          // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?'    ;

var
  CiAnnulation : string = 'Commannulation';                                     //R2013-Req26100-BDES-TicketCancellation-TCS-SC


//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
    TFrmDetCAEtatAnnulation = class(TFrmDetGeneralCA)
    CAEtatAnnulation: TStoredProc;
    SavDlgExport: TSaveTextFileDialog;
    RdBtnGlobal: TRadioButton;
    RdBtnDetail: TRadioButton;
    RdBtnMotive: TRadioButton;
    CmbAskSelection: TComboBox;
    ChkLBxReason: TCheckListBox;
    procedure BtnExportClick(Sender: TObject);
    procedure RdBtnGlobalClick(Sender: TObject);
    procedure RdBtnDetailClick(Sender: TObject);
    procedure RdBtnMotiveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
    CntTot         : Integer;
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;
    function GetTxtTitRapport : string; override;
    function GetTxtTableTitle: string; override;

    //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
    // Run params
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end

  public
    function GetTxtHeader: string;                        //For Getting the header text
    function GetTxtRpt4 (CallerId :Integer ) : string;    //For getting texts of dynamic motive report
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure PrintTableHeader;override;
    procedure PrintSubTotal (OperatorNum     : String;
                             SubTotAmount    : Currency;
                             SubTotNumAnnul  : integer);
    procedure PrintTotal (TotalAmount    : Currency;
                          TotalNumAnnul  : integer);
    procedure Execute; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    procedure SetGeneralSettings; override;

 end;

var
  FrmDetCAEtatAnnulation: TFrmDetCAEtatAnnulation;
  // Application parameters
  StrLstReasonList        : TStringList;
  flgExport               : Boolean  ;
  NoOfReason              : integer;   //No of reasons in INI file
  ReasonString            : string ;   //reasons selected by user
  ReportType              : Integer;
  NumOper                 : Integer;                                            //R2012.1 Defect Fix 72(SM)
  FlgBDES                 : Boolean = False;                                    //R2013-Req26100-BDES-TicketCancellation-TCS-SC
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

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAEtatAnnulation';

const  // CVS-keywords
  CtTxtSrcName                = '$';
  CtTxtSrcVersion             = '$Revision: 2.2 $';
  CtTxtSrcDate                = '$Date: 2014/03/06 09:55:26 $';

//*****************************************************************************
// Implementation of TFrmDetCAEtatAnnulation
//*****************************************************************************

procedure TFrmDetCAEtatAnnulation.SetGeneralSettings;
begin  // of TFrmDetGeneralCA.SetGeneralSettings
  VspPreview.MarginHeader := 500;
  if RdBtnMotive.Checked then
  VspPreview.MarginTop := 3200
  else
  VspPreview.MarginTop := 3200;

  FNLogo := ReplaceEnvVar (CtTxtEnvVarStartDir) + '\Image\' + CtTxtLogoName;
end;   // of TFrmDetGeneralCA.SetGeneralSettings

//=============================================================================

function TFrmDetCAEtatAnnulation.GetFmtTableHeader: string;
begin   //TFrmDetCAEtatAnnulation.GetFmtTableHeader
   // Modifed for defect fix 115 SC(TCS) - Start
    if ReportType=4 then
    Result :=GetTxtRpt4(1)
    else
    if RdBtnDetail.Checked then
    begin
      Result := '^+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(9, False));          //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(16, False));
      if FlgBDES then                                                           //R2013-Req26100-BDES-TicketCancellation-TCS-SC
        Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(12, False));  //R2013-Req26100-BDES-TicketCancellation-TCS-SC       //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(12, False));      //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(9, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));
    end
    else
    begin
      Result := '^+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(12 , False));   
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(16, False));
      if FlgBDES then                                                           //R2013-Req26100-BDES-TicketCancellation-TCS-SC
        Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));  //R2013-Req26100-BDES-TicketCancellation-TCS-SC
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(11, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));
    end
end;   // of TFrmDetCAEtatAnnulation.GetFmtTableHeader

//==============================================================================

function TFrmDetCAEtatAnnulation.GetFmtTableBody: string;
begin // of  TFrmDetCAEtatAnnulation.GetFmtTableBody
      if ReportType=4 then
    Result :=GetTxtRpt4(2)
    else
     if RdBtnDetail.Checked then
    begin
      Result := '^+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep +'^+' + IntToStr(CalcWidthText(9, False));        //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));      //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      if FlgBDES then                                                           //R2013-Req26100-BDES-TicketCancellation-TCS-SC
        Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));  //R2013-Req26100-BDES-TicketCancellation-TCS-SC      //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(9, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));
    end
    else
    begin
      Result := '^+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(16, False));
    if FlgBDES then                                                             //R2013-Req26100-BDES-TicketCancellation-TCS-SC
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));    //R2013-Req26100-BDES-TicketCancellation-TCS-SC
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    end
end;   // of TFrmDetCAEtatAnnulation.GetFmtTableBody

//=============================================================================

function TFrmDetCAEtatAnnulation.GetFmtTableSubTotal: string;
 begin // of  TFrmDetCAEtatAnnulation.GetFmtTableSubTotal
    if RdBtnDetail.Checked then
    begin
    Result := '^+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep +'^+' + IntToStr(CalcWidthText(9, False));         //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(16, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));      //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      if FlgBDES then                                                           //R2013-Req26100-BDES-TicketCancellation-TCS-SC
        Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));  //R2013-Req26100-BDES-TicketCancellation-TCS-SC       //R2013.1- HPQC defectfix 66 (CP) - Size reduced
      Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(9, False));
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(10, False));
      Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(8, False));
      Result := Result + TxtSep + '<+' + IntToStr(CalcWidthText(15, False));
    end
    else
    begin
    Result := '^+' + IntToStr(CalcWidthText(8, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(12, False));
    Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(16, False));
    Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));
    if FlgBDES then                                                             //R2013-Req26100-BDES-TicketCancellation-TCS-SC
      Result := Result + TxtSep + '^+' + IntToStr(CalcWidthText(15, False));    //R2013-Req26100-BDES-TicketCancellation-TCS-SC
    Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(11, False));
    Result := Result + TxtSep + '>+' + IntToStr(CalcWidthText(15, False));      
    end
end;  // of TFrmDetCAEtatAnnulation.GetFmtTableSubTotal

//=============================================================================

function TFrmDetCAEtatAnnulation.GetTxtTitRapport : string;
begin  // of  TFrmDetCAEtatAnnulation.GetTxtTitRapport
 Result := CtTxtTitle;
end;  // of  TFrmDetCAEtatAnnulation.GetTxtTitRapport

//=============================================================================

function TFrmDetCAEtatAnnulation.GetTxtTableTitle: string;
begin // of  TFrmDetCAEtatAnnulation.GetTxtTableTitle
   if ReportType=4 then
    Result :=GetTxtRpt4(3)
    else
     if RdBtnDetail.Checked then begin             
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
       if FlgBDES then
         Result :=  ' '                + TxtSep +
                    CtTxtNumOper       + TxtSep +
                    CtTxtDate          + TxtSep +
                    CtTxtNumCashDesk   + TxtSep +
                    CtTxtSuperVisor    + TxtSep +                               
                    CtTxtNumTicket     + TxtSep +
                    CtTxtHour          + TxtSep +
                    CtTxtAmount        + TxtSep +
                    CtTxtMotive
       else
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
         Result :=  ' '                + TxtSep +                               //for implimenting dynamic column for multiple reason
                    CtTxtNumOper       + TxtSep +
                    CtTxtDate          + TxtSep +
                    CtTxtNumCashDesk   + TxtSep +
                    CtTxtNumTicket     + TxtSep +
                    CtTxtHour          + TxtSep +
                    CtTxtAmount        + TxtSep +
                    CtTxtMotive
     end
     else begin
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
       if FlgBDES then                                                          
         Result :=  ' '                + TxtSep +
                    CtTxtNumOper       + TxtSep +
                    CtTxtDate          + TxtSep +
                    CtTxtNumCashDesk   + TxtSep +
                    CtTxtSuperVisor    + TxtSep +
                    CtTxtNumAnnul      + TxtSep +
                    CtTxtAmount
       else
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
         Result :=  ' '                + TxtSep +
                    CtTxtNumOper       + TxtSep +
                    CtTxtDate          + TxtSep +
                    CtTxtNumCashDesk   + TxtSep +
                    CtTxtNumAnnul      + TxtSep +
                    CtTxtAmount
     end;

end; // of  TFrmDetCAEtatAnnulation.GetTxtTableTitle

//=============================================================================

procedure TFrmDetCAEtatAnnulation.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
  TxtDatFormat     : string;           //R2013.1-defect 838-Fix(sc)
begin  // of TFrmDetCAEtatAnnulation.PrintHeader
 VspPreview.FontSize :=10;
 VspPreview.CurrentX := VspPreview.MarginHeader;
 VspPreview.CurrentY := VspPreview.MarginHeader;
 TxtHdr :=' '+ DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;
  if RdBtnDetail.Checked then
  begin
     TxtHdr := TxtHdr +CtTxtDetail+':'+CtTxtCanceTicket + CRLF + CRLF;
     VspPreview.Text :=TxtHdr;
  end
  else
  if RdBtnGlobal.Checked then
  begin
     TxtHdr := TxtHdr +CtTxtGlobal+':'+CtTxtCanceTicket + CRLF + CRLF ;
      VspPreview.Text :=TxtHdr;
  end
  else
  if RdBtnMotive.Checked then
  begin
     TxtHdr := TxtHdr +CtTxtMotif+':'+CtTxtCanceTicket + CRLF ;
     TxtHdr := TxtHdr+CtTxtReason+':' ;
     VspPreview.Text :=TxtHdr;
     VspPreview.Font.Style:= VspPreview.Font.Style + [fsBold];
     if   NoOfReason=StrLstReasonList.Count then
     VspPreview.Text :=CtTxtAll+CRLF + CRLF
     else                                                                       
     VspPreview.Text :=GetTxtRpt4(8)+CRLF + CRLF ;
      VspPreview.Font.Style:= VspPreview.Font.Style - [fsBold];
  end;
  TxtHdr := CRLF+ DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF ;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF+ CRLF;

  //R2013.1-defect 838-Fix(sc)--Start
  if FlgBDES then
    TxtHdr := TxtHdr + Format (CtTxtPrintDateBDES,
              [FormatDateTime ('dd-mm-yyyy', Date),
              FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF
  else
  //R2013.1-defect 838-Fix(sc)--End
    TxtHdr := TxtHdr + Format (CtTxtPrintDateCAFR,
              [FormatDateTime (CtTxtDatFormat, Now)]) + CRLF+ CRLF;
  VspPreview.Text :=TxtHdr;
  VspPreview.FontSize :=8;

  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAEtatAnnulation.PrintHeader

//=============================================================================

procedure TFrmDetCAEtatAnnulation.PrintTableBody;
var

  TxtLine          : string;           // Line to print
  PrevDate         : string;
  PrevOperator     : string;
  SubTotAmount     : Currency;
  SubTotNumAnnul   : integer;
  TotalAmount      : Currency;
  TotalNumAnnul    : integer;
begin  // of TFrmDetCAEtatAnnulation.PrintTableBody
  inherited;
  SubTotAmount     :=0.00;
  SubTotNumAnnul   :=0;
  TotalAmount      :=0.00;
  TotalNumAnnul    :=0;

  VspPreview.TableBorder := tbBoxColumns;
 if ReportType<>4 then
  begin
  PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString  ;
  PrevDate     := FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime);   //R2013.1- HPQC defectfix 66 (CP)
  end;
 while not CAEtatAnnulation.Eof do begin

  VspPreview.StartTable;
  if RdBtnDetail.Checked then
  begin
  if  PrevOperator <> CAEtatAnnulation.FieldByName ('idtoperator').AsString then
   begin
       PrintSubTotal (PrevOperator,SubTotAmount,SubTotNumAnnul);
       PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString ;
       TotalAmount  :=    TotalAmount +  SubTotAmount;
       TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
       SubTotNumAnnul:=0;
       SubTotAmount :=0;
   end ;
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
  if FlgBDES then
    if CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime=0 then         //R2013.1- HPQC defectfix 66 (CP)
     TxtLine := ' '+ TxtSep +                                                   //R2013.1- HPQC defectfix 66 (CP)
                CAEtatAnnulation.FieldByName ('idtoperator').AsString + TxtSep +
                ''  + TxtSep +
                CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
                CAEtatAnnulation.FieldByName ('Approverid').AsString        + TxtSep +
                CAEtatAnnulation.FieldByName ('IdtPostransaction').AsString + TxtSep +
                CAEtatAnnulation.FieldByName ('HrMin').AsString             + TxtSep +
                  FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat)+ TxtSep +
                CAEtatAnnulation.FieldByName ('Motive').AsString
    else

      TxtLine := ' '+ TxtSep +
                CAEtatAnnulation.FieldByName ('idtoperator').AsString + TxtSep +
                FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + TxtSep +   //R2013.1- HPQC defectfix 66 (CP)                                                       //R2013.1- HPQC defectfix 66 (CP)
                CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
                CAEtatAnnulation.FieldByName ('Approverid').AsString        + TxtSep +
                CAEtatAnnulation.FieldByName ('IdtPostransaction').AsString + TxtSep +
                CAEtatAnnulation.FieldByName ('HrMin').AsString             + TxtSep +
                  FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat)+ TxtSep +
                CAEtatAnnulation.FieldByName ('Motive').AsString
  else
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
  TxtLine :=   ' '+ TxtSep +
               CAEtatAnnulation.FieldByName ('idtoperator').AsString       + TxtSep +
               FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + TxtSep +   //R2013.1- HPQC defectfix 66 (CP)
               CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('IdtPostransaction').AsString + TxtSep +
               CAEtatAnnulation.FieldByName ('HrMin').AsString             + TxtSep +
               FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat)+ TxtSep +
               CAEtatAnnulation.FieldByName ('Motive').AsString  ;
  SubTotAmount :=    SubTotAmount + CAEtatAnnulation.FieldByName ('Amount').AsCurrency  ;
  SubTotNumAnnul :=  SubTotNumAnnul +1;
 end
 else
  if ReportType=4 then
  begin
    TxtLine:=GetTxtRpt4(4);
  end
 else begin      //If other report
  //R2013.1-defect 765-Fix(sc)--Start
  if FlgBDES then begin
    if (PrevOperator <> CAEtatAnnulation.FieldByName ('idtoperator').AsString)  then begin
      PrintSubTotal (PrevOperator,SubTotAmount,SubTotNumAnnul);
      PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString ;
      TotalAmount  :=    TotalAmount +  SubTotAmount;
      TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
      SubTotNumAnnul:=0;
      SubTotAmount :=0;
    end  
  end
  else begin
  //R2013.1-defect 765-Fix(sc)--End
    if  (PrevDate <> FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime))  then begin       //R2013.1- HPQC defectfix 66 (CP)
      PrintSubTotal (PrevOperator,SubTotAmount,SubTotNumAnnul);
      PrevDate     := FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) ;            //R2013.1- HPQC defectfix 66 (CP)
      TotalAmount  :=    TotalAmount +  SubTotAmount;
      TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
      SubTotNumAnnul:=0;
      SubTotAmount :=0;
    end  ;
  end;                                                                          //R2013.1-defect 765-Fix(sc)
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
  if FlgBDES then
     if CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime= 0 then       //R2013.1- HPQC defectfix 66 (CP)
       TxtLine := ' '                                                         + TxtSep +
               CAEtatAnnulation.FieldByName ('idtoperator').AsString       + TxtSep +
               '' + TxtSep +                                                    //R2013.1- HPQC defectfix 66 (CP)
               CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('Approverid').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('NumAnnul').AsString          + TxtSep +
               FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat)
     else
       TxtLine := ' '                                                         + TxtSep +
               CAEtatAnnulation.FieldByName ('idtoperator').AsString       + TxtSep +
               FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + TxtSep +  //R2013.1- HPQC defectfix 66 (CP)
               CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('Approverid').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('NumAnnul').AsString          + TxtSep +
               FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat)
  else
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
    TxtLine := ' '                                                         + TxtSep +
               CAEtatAnnulation.FieldByName ('idtoperator').AsString       + TxtSep +
               FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + TxtSep +   //R2013.1- HPQC defectfix 66 (CP)
               CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + TxtSep +
               CAEtatAnnulation.FieldByName ('NumAnnul').AsString          + TxtSep +
               FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Amount').AsFloat);
  SubTotAmount :=    SubTotAmount + CAEtatAnnulation.FieldByName ('Amount').AsCurrency  ;
  SubTotNumAnnul :=  SubTotNumAnnul + CAEtatAnnulation.FieldByName ('NumAnnul').AsInteger ;
  end;

   if ReportType=4 then
   begin
  if(FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('period').AsDateTime)='31-12-2999') then        //R2013.1- HPQC defectfix 66 (CP)
     begin
      VspPreview.Text := CRLF;
      VspPreview.AddTable (GetTxtRpt4(7), '', TxtLine, clWhite,clLtGray,False);
      VspPreview.Font.Style:= VspPreview.Font.Style + [fsBold];
      VspPreview.TableCell [tcFontBold, VspPreview.TableCell [tcCols, 0,0,0,0], 0, VspPreview.TableCell [tcCols, 0,0,0,0], VspPreview.TableCell [tcCols, 0,0,0,0]] := True;    //defect fix
      VspPreview.Font.Style:= VspPreview.Font.Style - [fsBold];
     end
   else
     VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,clWhite,False);
   end
   else
     VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,clWhite,False);
  VspPreview.EndTable;

  CAEtatAnnulation.Next;

  end;  //End of while

  if ReportType<>4 then
 begin
  PrintSubTotal (PrevOperator,SubTotAmount,SubTotNumAnnul);

  TotalAmount  :=    TotalAmount +  SubTotAmount;
  TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
  PrintTotal (TotalAmount,TotalNumAnnul);
  end;
end;   // of TFrmDetCAEtatAnnulation.PrintTableBody

//==============================================================================

procedure TFrmDetCAEtatAnnulation.PrintSubTotal (OperatorNum     : String;
                                                 SubTotAmount    : Currency;
                                                 SubTotNumAnnul  : integer);
  var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin  // of TFrmDetCAEtatAnnulation.PrintSubTotal
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
  if FlgBDES then begin
    if RdBtnDetail.Checked then
      TxtLine :=  CtTxtSubTot                                   +  TxtSep
                + OperatorNum                                   +  TxtSep
                                                                //+  TxtSep
                + IntToStr(SubTotNumAnnul)                      +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                + FormatFloat (CtTxtFrmNumber,  SubTotAmount)
                                                                + TxtSep
                                                                +  TxtSep
    else
      TxtLine :=  CtTxtSubTot                                   +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                + IntToStr(SubTotNumAnnul)
                                                                + TxtSep
                + FormatFloat (CtTxtFrmNumber,  SubTotAmount)
                                                                + TxtSep;
  end
  else begin
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end

    if RdBtnDetail.Checked then
      TxtLine := CtTxtSubTot                                  +  TxtSep
             + OperatorNum                                    +  TxtSep
             + IntToStr(SubTotNumAnnul)                       +  TxtSep
                                                              +  TxtSep
                                                              +  TxtSep
                                                              +  TxtSep
             + FormatFloat (CtTxtFrmNumber,  SubTotAmount)    +  TxtSep
                                                              +  TxtSep
    else
      TxtLine := CtTxtSubTot                                  +  TxtSep
                                                              +  TxtSep
                                                              +  TxtSep
                                                              +  TxtSep
              + IntToStr(SubTotNumAnnul)                      +  TxtSep
              + FormatFloat (CtTxtFrmNumber,  SubTotAmount)   +  TxtSep;
  end;                                                                          

  VspPreview.StartTable;

  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clWhite;
  VspPreview.TableCell [tcFontBold, IdxRow, 0, IdxRow, IdxCol] := True;

  VspPreview.EndTable;
  //VspPreview.StartTable;
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.Execute;
var
  CntIx     : Integer;
  OprString,tempstr : string ;
  Strposi :Integer;
begin  // of TFrmDetCAEtatAnnulation.Execute
  CntTot:=0;
   NoOfReason:=0;
   NumOper:=0;
   SetGeneralSettings;  //This is required so that the table top can be inicialised dynamically

  for CntIx := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    if ChkLbxOperator.Checked [CntIx] then begin
      tempstr:='';
      tempstr := ChkLbxOperator.Items[CntIx];
      Strposi := pos(':',tempstr);
      Delete(tempstr,Strposi-1,Length(tempstr)-Strposi + 2);
      OprString:=OprString+ tempstr +',';
      NumOper:= NumOper+1;
      // Change checkbox
      ChkLbxOperator.State [CntIx] := cbGrayed;                                 //R2012.1 Defect fix 193(CP)
    end;
  end;
      Delete(OprString,Length(OprString),1);
 //--

 ReasonString :='';

 for CntIx := 0 to Pred (StrLstReasonList.Count) do begin
    if ChkLbxReason.Checked [CntIx]  then begin

      tempstr:='';
      tempstr := StrLstReasonList [CntIx];
      Strposi := pos('=',tempstr);
      Delete(tempstr,Strposi,Length(tempstr)-Strposi + 2);
      ReasonString:=ReasonString+ tempstr +',';
   end;
 end;
   //Warning message if no reason selected need to change the reason string
   if RdBtnMotive.Checked then begin
     if  (Length(ReasonString))<3 then begin
       MessageDlg (CtTxtNoReason, mtWarning, [mbOK], 0);
       Exit;
     end;
   end;
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
  if RdBtnMotive.Checked then
  begin
   for CntIx := 0 to Pred (StrLstReasonList.Count) do begin
      if ChkLbxReason.Checked [CntIx]=true then
        begin
          NoOfReason:=NoOfReason+1;
        end;
      end ;
   end;
    CAEtatAnnulation.Active := False;
    CAEtatAnnulation.ParamByName ('@DatFrom').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAEtatAnnulation.ParamByName ('@DatTo').AsString :=
       FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
       FormatDateTime (ViTxtDBHouFormat, 0);
    CAEtatAnnulation.ParamByName ('@OperatorSequence').AsString :=
        OprString;

    //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
    if FlgBDES then
      CAEtatAnnulation.ParamByName ('@OPCOName').AsString := 'BDES'
    else
      CAEtatAnnulation.ParamByName ('@OPCOName').AsString := 'CAFR';
    //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end

    if RdBtnGlobal.Checked then
    begin
      CAEtatAnnulation.ParamByName ('@ReportType').AsInteger :=1  ;
      ReportType:=1;
    end
    else
    if RdBtnDetail.Checked then
    begin
      CAEtatAnnulation.ParamByName ('@ReportType').AsInteger :=2 ;
      ReportType:=2;
    end
    else
    if RdBtnMotive.Checked then
    begin
    if  (Length(ReasonString))=3 then
        begin
          CAEtatAnnulation.ParamByName ('@ReportType').AsInteger :=3 ;
          ReportType:=3;
        end
    else
        begin
          CAEtatAnnulation.ParamByName ('@ReportType').AsInteger :=4;  
          ReportType:=4;
        end;
    CAEtatAnnulation.ParamByName ('@Reasons').AsString :=ReasonString
    end;
    CAEtatAnnulation.Active := True;
    if (ReportType=2) then begin
       if  NumOper=1 then begin
         if (CAEtatAnnulation.RecordCount = 0 )and (not FlgBDES) then           //R2013.1- defect705-fix(AS)
         begin
           MessageDlg (Format(CtTxtNoCancelation,[OprString]),
                       mtWarning, [mbOK], 0);
           Exit;
         end;
       end;
    end;                        
    if not flgExport then
    begin
      if not FlgBDES then                                                       //R2013-Req26100-BDES-TicketCancellation-TCS-SC
        VspPreview.Orientation := orLandscape
        
      //R2013-Req26100-BDES-TicketCancellation-TCS-SC--Start
      else begin
        case ReportType of
          1 : VspPreview.Orientation := orPortrait ;
          2 : VspPreview.Orientation := orPortrait ;
          3 : VspPreview.Orientation := orPortrait ;
          4 : VspPreview.Orientation := orLandscape ;
        end;
      end;
      //R2013-Req26100-BDES-TicketCancellation-TCS-SC--End

      VspPreview.StartDoc;
      //---

      if CAEtatAnnulation.RecordCount = 0 then
        //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
        if FlgBDES then
          VspPreview.AddTable (FmtTableBody, '', ' ', clWhite,          //R2013.1-defect 827-Fix(SC)
                           clWhite, False)
        else                   
        //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
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
  end;
end;   // of TFrmDetCAEtatAnnulation.Execute

//=============================================================================

procedure TFrmDetCAEtatAnnulation.PrintTotal (TotalAmount    : Currency;
                                              TotalNumAnnul  : integer);

var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin   // of TFrmDetCAEtatAnnulation.PrintTotal

  VspPreview.StartTable;
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
  if FlgBDES then begin
    if RdBtnDetail.Checked then
      TxtLine :=  CtTxtTotal                                    +  TxtSep
                                                                +  TxtSep
               + IntToStr(TotalNumAnnul  )                      +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
               + FormatFloat (CtTxtFrmNumber,   TotalAmount)    +  TxtSep
                                                                +  TxtSep
    else
      TxtLine :=  CtTxtTotal                                    +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
               + IntToStr( TotalNumAnnul )                      +  TxtSep
               + FormatFloat (CtTxtFrmNumber,  TotalAmount)     +  TxtSep

  end
  else begin
  //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
    if RdBtnDetail.Checked then
      TxtLine :=  CtTxtTotal                                    +  TxtSep
                                                                +  TxtSep
             + IntToStr(TotalNumAnnul)                          +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
             + FormatFloat (CtTxtFrmNumber,   TotalAmount)      +  TxtSep
                                                                +  TxtSep
    else
      TxtLine :=  CtTxtTotal                                    +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
                                                                +  TxtSep
             + IntToStr( TotalNumAnnul )                        +  TxtSep
             + FormatFloat (CtTxtFrmNumber,  TotalAmount)       +  TxtSep;
  end; //R2013-Req26100-BDES-TicketCancellation-TCS-SC
  VspPreview.Text := CRLF;
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.TableCell [tcFontBold, IdxRow, 0, IdxRow, IdxCol] := True;                        
  VspPreview.EndTable;
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.FormCreate(Sender: TObject);
var

   TxtSection       : string;
   IniFileInst      : TIniFile;
   TxtSystemPath    : string;
   LoopCounter      : integer;
   ReasonsIniPath   : string;
   Txtlang          : array[0..3] of Char;
begin
  inherited;
  self.Caption := CtTxtCanceTicket;
  Application.Title := CtTxtCanceTicket;             
  LoopCounter :=0;
  IniFileInst:= nil; //initialisatiion over
  TxtSystemPath:= ReplaceEnvVar ('%SycRoot%');
  ReasonsIniPath  := '\FlexPos\Ini\psales.ini';
  IniFileInst:= TIniFile.Create(TxtSystemPath+ReasonsIniPath);
  TxtSection := CiAnnulation;
  if GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SABBREVLANGNAME,
                    @Txtlang, SizeOf (Txtlang)) <> 0 then  begin
    TxtSection := CiAnnulation + copy(Txtlang,1,2);
    if not (IniFileInst.SectionExists (TxtSection)) then
      TxtSection := CiAnnulation;
  end;
  try
    OpenIniFile(TxtSystemPath+ReasonsIniPath,IniFileInst);
    StrLstReasonList:=  TStringList.Create;
    StrLstReasonList.Clear;
    try
      IniFileInst.ReadSectionValues (TxtSection , StrLstReasonList);

      while LoopCounter <> StrLstReasonList.Count  do begin
        ChkLBxReason.Items.Add(StrLstReasonList[LoopCounter]);
        LoopCounter := LoopCounter + 1;
      end;

    except
        on E:Exception do
        raise ESvcLocalScope.Create ('ERROR ' + ReasonsIniPath + ': ' + E.Message);
    end;
  finally
    FreeAndNil(IniFileInst);
  end;
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.RdBtnMotiveClick(Sender: TObject);
begin
  inherited;
  if RdBtnMotive.Checked then
    ChkLBxReason.Visible:=True
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.RdBtnDetailClick(Sender: TObject);
begin
  inherited;
  if RdBtnDetail.Checked then
    ChkLBxReason.Visible:=False
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.RdBtnGlobalClick(Sender: TObject);
begin
  inherited;
  if RdBtnGlobal.Checked then
    ChkLBxReason.Visible:=False
end;

//===========================================================================
//R2013-Req26100-BDES-TicketCancellation-TCS-SC--start
//===========================================================================

procedure TFrmDetCAEtatAnnulation.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCAEtatAnnulation.BeforeCheckRunParams
  inherited;     
  SplitString(CtTxtOPCOName, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end; // of TFrmDetCAEtatAnnulation.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCAEtatAnnulation.CheckAppDependParams(TxtParam: string);
begin // of TFrmDetCAEtatAnnulation.CheckAppDependParams
  if Copy(TxtParam, 3, 4) = 'BDES' then
    FlgBDES := True
  else
    inherited;
end; // of TFrmDetCAEtatAnnulation.CheckAppDependParams

//===========================================================================
//R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
//===========================================================================

procedure TFrmDetCAEtatAnnulation.BtnExportClick(Sender: TObject);
var
  TxtTitles        : string;
  TxtWriteLine     : string;
  LoopCounter      : integer;                                                   
  F                : System.Text;
  ChrDecimalSep    : char;
  Btnselect        : integer;
  FlgOK            : Boolean;
  TxtPath          : String;
  QryHlp           : TQuery;
  PrevDate         : string;
  PrevOperator     : string;
  SubTotAmount     : Currency;
  SubTotNumAnnul   : integer;
  TotalAmount      : Currency;
  TotalNumAnnul    : integer;
begin
inherited;
  SubTotAmount     :=0.00;
  SubTotNumAnnul   :=0;
  TotalAmount      :=0.00;
  TotalNumAnnul    :=0;
  flgExport        :=True;
  QryHlp              := TQuery.Create(self);
  QryHlp.DatabaseName := 'DBFlexPoint';
  QryHlp.Active       := False;
  QryHlp.SQL.Clear;
  QryHlp.SQL.Add('select * from ApplicParam' +
                ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));

   if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;

  FlgPreview := (Sender = BtnPreview);

  ActStartExec.Execute;
   if RdBtnMotive.Checked then begin
      if  (Length(ReasonString))<3 then begin
      flgExport :=False;
    Exit;
    end;
    end;
  //R2012.1 Defect Fix 72(SM) :: START
    if (ReportType=2) then begin      
       if  NumOper=1 then begin
            If CAEtatAnnulation.RecordCount = 0 then
            begin
            Exit;
            end;
       end;
    end;                              
 //R2012.1 Defect Fix 72(SM)  :: End
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
   ChrDecimalSep := DecimalSeparator;
    DecimalSeparator := ',';
    if not DirectoryExists(TxtPath) then
      ForceDirectories(TxtPath);
    SavDlgExport.InitialDir := TxtPath;
    if(ReportType<>4 )then
     TxtTitles := GetTxtTableTitle()
    else begin                                                                  //R2012.1 Defect fix 187(CP)
     TxtTitles := GetTxtRpt4(3);                           
     if(copy(trimleft(TxtTitles),1,1) = '|') then                               //R2012.1 Defect fix 187(CP)
     TxtTitles := ';'+ copy(trimleft(TxtTitles),2,length(TxtTitles)-1);         //R2012.1 Defect fix 187(CP)
    end;                                                                        //R2012.1 Defect fix 187(CP)
    TxtWriteLine := '';
      TxtWriteLine:=GetTxtHeader();

    for LoopCounter := 1 to Length(TxtTitles) do
  //R2012.1 Defect Fix 187 ::START(SM)
     if  (reporttype = 1) or (reporttype = 2)  then begin
       if TxtTitles[LoopCounter] = '|' then TxtWriteLine := TxtWriteLine + ';'  //R2012.1 Defect fix 187(SM)
       else TxtWriteLine := TxtWriteLine + TxtTitles[LoopCounter];
     end
     else begin
       if TxtTitles[LoopCounter] = '|' then begin
         if (reporttype = 3) then                                               //R2013.1 Defect fix 19(SC)
           TxtWriteLine := TxtWriteLine + ';'         //R2012.1 Defect fix 187(SM)
         else
           TxtWriteLine := TxtWriteLine + ';' + ';'   //R2012.1 Defect fix 187(SM)  //R2013.1 Defect fix 19(SC)
       end  
       else
         TxtWriteLine := TxtWriteLine + TxtTitles[LoopCounter];
     end;
  //R2012.1 Defect Fix 187  ::END(SM)
    TxtTitles := GetTxtRpt4(6);
    TxtWriteLine := TxtWriteLine +CRLF;
    if(ReportType=4 )then
    begin
     for LoopCounter := 1 to Length(TxtTitles) do
      if TxtTitles[LoopCounter] = '|' then TxtWriteLine := TxtWriteLine + ';'   //R2012.1 Defect Fix 187 (SM)
      else TxtWriteLine := TxtWriteLine + TxtTitles[LoopCounter];
    end;                                  
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
     try
      CAEtatAnnulation.Active := True;
      CAEtatAnnulation.First;
     if CAEtatAnnulation.RecordCount = 0 then begin
        //R2013.1-defect 827-Fix(SC)--Start
        if FlgBDES then
          TxtWriteLine := ' '
        else
        //R2013.1-defect 827-Fix(SC)--end
          TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
  if ReportType<>4 then
  begin
    PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString  ;
    PrevDate     :=FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) ;          //R2013.1- HPQC defectfix 66 (CP)
  end;
 while not CAEtatAnnulation.Eof do begin


   if RdBtnDetail.Checked then    //Checking Type of report
   begin
     if  PrevOperator <> CAEtatAnnulation.FieldByName ('idtoperator').AsString then begin
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--Start
       if FlgBDES then begin
         TxtWriteLine := CtTxtSubTot                                      +  ';'
                         + PrevOperator                                   +  ';'
                                                                          //+  ';' Commented out for R2013.1 HPQC defectfix 16
                         + IntToStr(SubTotNumAnnul)                       +  ';'
                                                                          +  ';' //R2013.1 HPQC defectfix 16
                                                                          +  ';'
                                                                          +  ';'
                                                                          +  ';'
                         + FormatFloat (CtTxtFrmNumber,  SubTotAmount)    +  ';'
                                                                          +  ';';
       end
       else
       //R2013-Req26100-BDES-TicketCancellation-TCS-SC--End
         TxtWriteLine := CtTxtSubTot                                      +  ';'
                         + PrevOperator                                   +  ';'//CAEtatAnnulation.FieldByName ('idtoperator').AsString//R2012.1 Defect fix 187(SM)
                         + IntToStr(SubTotNumAnnul)                       +  ';'
                                                                          +  ';'
                                                                          +  ';'
                                                                          +  ';'
                         + FormatFloat (CtTxtFrmNumber,  SubTotAmount)    +  ';'
                                                                          +  ';';
       WriteLn(F, TxtWriteLine);
       PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString ;
       TotalAmount  :=    TotalAmount +  SubTotAmount;
       TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
       SubTotNumAnnul:=0;
       SubTotAmount :=0;
     end ;
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--Start
     if FlgBDES then
     TxtWriteLine :='  ;'+CAEtatAnnulation.FieldByName ('idtoperator').AsString       + ';' +
                    FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime)     + ';' + //R2013.1- HPQC defectfix 66 (CP)
                    CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + ';' +
                    CAEtatAnnulation.FieldByName ('Approverid').AsString + ';' +
                    CAEtatAnnulation.FieldByName ('IdtPostransaction').AsString + ';' +
                    CAEtatAnnulation.FieldByName ('HrMin').AsString             + ';' +
                    CAEtatAnnulation.FieldByName ('Amount').AsString            + ';' +
                    CAEtatAnnulation.FieldByName ('Motive').AsString
     else
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--End
       TxtWriteLine :='  ;'+CAEtatAnnulation.FieldByName ('idtoperator').AsString       + ';' +
                    FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime)     + ';' + //R2013.1- HPQC defectfix 66 (CP)
                    CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + ';' +
                    CAEtatAnnulation.FieldByName ('IdtPostransaction').AsString + ';' +
                    CAEtatAnnulation.FieldByName ('HrMin').AsString             + ';' +
                    CAEtatAnnulation.FieldByName ('Amount').AsString            + ';' +
                    CAEtatAnnulation.FieldByName ('Motive').AsString;

     SubTotAmount :=    SubTotAmount + CAEtatAnnulation.FieldByName ('Amount').AsCurrency  ;
     SubTotNumAnnul :=  SubTotNumAnnul +1;
   end

   else if ReportType=4 then begin
     TxtWriteLine:=GetTxtRpt4(10);
   end

   else begin     //If other report
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--Start
     if FlgBDES and (PrevOperator <> CAEtatAnnulation.FieldByName ('idtoperator').AsString) then begin
       TxtWriteLine  := CtTxtSubTot                        +  ';'
                                                           +  ';'
                                                           +  ';'
                                                           +  ';'
                                                           +  ';'               
                        + IntToStr(SubTotNumAnnul)         +  ';'
                        + FormatFloat (CtTxtFrmNumber,  SubTotAmount)
                                                           +  ';';
        WriteLn(F, TxtWriteLine);
        PrevDate     := FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime);         //R2013.1- HPQC defectfix 66 (CP)
        PrevOperator := CAEtatAnnulation.FieldByName ('idtoperator').AsString;  //R2013.1 Defect fix 16(SC)
        TotalAmount  :=    TotalAmount +  SubTotAmount;
        TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
        SubTotNumAnnul:=0;
        SubTotAmount :=0;
     end
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--End
     else if  (not FlgBDES) and (PrevDate <> FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime)) then begin       //1st clause added for //R2013.1 Defect fix 16(SC)    //2nd clause modifed for R2013.1- HPQC defectfix 66 (CP)
       TxtWriteLine  := CtTxtSubTot                        +  ';'
                                                           +  ';'
                                                           +  ';'
                                                           +  ';' 
                        + IntToStr(SubTotNumAnnul)         +  ';'
                        + FormatFloat (CtTxtFrmNumber,  SubTotAmount)
                                                           +  ';';
        WriteLn(F, TxtWriteLine);
        PrevDate     := FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime);      //R2013.1- HPQC defectfix 66 (CP)
        TotalAmount  :=    TotalAmount +  SubTotAmount;
        TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
        SubTotNumAnnul:=0;
        SubTotAmount :=0;
     end  ;
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--Start
     if FLgBDES then
       TxtWriteLine :='  ;'+CAEtatAnnulation.FieldByName ('idtoperator').AsString  + ';' +
                       FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + ';' +  //R2013.1- HPQC defectfix 66 (CP)
                       CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + ';' +
                       CAEtatAnnulation.FieldByName ('Approverid').AsString        + ';' + 
                       CAEtatAnnulation.FieldByName ('NumAnnul').AsString          + ';' +
                       CAEtatAnnulation.FieldByName ('Amount').AsString
     //R2013-Req26100-BDES-TicketCancellation-TCS-SC--end
     else
   TxtWriteLine :='  ;'+CAEtatAnnulation.FieldByName ('idtoperator').AsString + ';' +        
                  FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('Dattransbegin').AsDateTime) + ';' +    //R2013.1- HPQC defectfix 66 (CP)
                  CAEtatAnnulation.FieldByName ('IdtCheckout').AsString       + ';' +
                  CAEtatAnnulation.FieldByName ('NumAnnul').AsString          + ';' +
                  CAEtatAnnulation.FieldByName ('Amount').AsString  ;
  SubTotAmount :=    SubTotAmount + CAEtatAnnulation.FieldByName ('Amount').AsCurrency  ;
  SubTotNumAnnul :=  SubTotNumAnnul + CAEtatAnnulation.FieldByName ('NumAnnul').AsInteger ;
 end;

   WriteLn(F, TxtWriteLine);
  CAEtatAnnulation.Next;

  end;  //End of while
  if ReportType<>4 then
  begin
   if RdBtnDetail.Checked then
     //R2013.1 Defect fix 16(SC)--Start
     if FlgBDES then
       TxtWriteLine := CtTxtSubTot                                      +  ';'
               + CAEtatAnnulation.FieldByName ('idtoperator').AsString  +  ';'
               + IntToStr(SubTotNumAnnul)                               +  ';'
                                                                        +  ';'
                                                                        +  ';'
                                                                        +  ';'
                                                                        +  ';'
               + FormatFloat (CtTxtFrmNumber,  SubTotAmount)            +  ';'
                                                                        +  ';'
     else
     //R2013.1 Defect fix 16(SC)--end
       TxtWriteLine := CtTxtSubTot                                      +  ';'
             + CAEtatAnnulation.FieldByName ('idtoperator').AsString  +  ';'
             + IntToStr(SubTotNumAnnul)                               +  ';'
                                                                      +  ';'
                                                                      +  ';'
                                                                      +  ';'
             + FormatFloat (CtTxtFrmNumber,  SubTotAmount)            +  ';'
                                                                      +  ';'
   else
     //R2013.1 Defect fix 16(SC)--Start
     if FlgBDES then
       TxtWriteLine  := CtTxtSubTot                                     +  ';'
                                                                        +  ';'
                                                                        +  ';'
                                                                        +  ';'  
                                                                        +  ';'
                + IntToStr(SubTotNumAnnul)                              +  ';'
                + FormatFloat (CtTxtFrmNumber,  SubTotAmount)           +  ';'
     else
     //R2013.1 Defect fix 16(SC)--end
       TxtWriteLine  := CtTxtSubTot                                   +  ';'
                                                                      +  ';'
                                                                      +  ';'
                                                                      +  ';'
              + IntToStr(SubTotNumAnnul)                              +  ';'
              + FormatFloat (CtTxtFrmNumber,  SubTotAmount)           +  ';';
    WriteLn(F, TxtWriteLine);
  TotalAmount  :=    TotalAmount +  SubTotAmount;
       TotalNumAnnul  :=  TotalNumAnnul + SubTotNumAnnul;
   if RdBtnDetail.Checked then
     //R2013.1 Defect fix 16(SC)--Start
     if FlgBDES then
       TxtWriteLine := CtTxtTotal                                  +  ';'
                                                                   +  ';' 
               + IntToStr(TotalNumAnnul)                           +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'
               + FormatFloat (CtTxtFrmNumber,  TotalAmount)        +  ';'
                                                                   +  ';'
     else
     //R2013.1 Defect fix 16(SC)--End
       TxtWriteLine := CtTxtTotal                                  +  ';'
               +  ';' //CAEtatAnnulation.FieldByName ('idtoperator').AsString       //R2012.1 Defect fix 187(SM)
               //+  ';'                                                             //R2012.1 Defect Fix 187 (SM)
               + IntToStr(TotalNumAnnul)                           +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'
               + FormatFloat (CtTxtFrmNumber,  TotalAmount)        +  ';'
                                                                   +  ';'
   else
     //R2013.1 Defect fix 16(SC)--Start
     if FlgBDES then
       TxtWriteLine  := CtTxtTotal                                 +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'           //R2013.1 Defect fix 16(SC)
                + IntToStr(TotalNumAnnul)                          +  ';'
                + FormatFloat (CtTxtFrmNumber,  TotalAmount)       +  ';'
     else
     //R2013.1 Defect fix 16(SC)--End
       TxtWriteLine  := CtTxtTotal                                 +  ';'
                                                                   +  ';'
                                                                   +  ';'
                                                                   +  ';'  
                + IntToStr(TotalNumAnnul)                          +  ';'
                + FormatFloat (CtTxtFrmNumber,  TotalAmount)       +  ';';
      WriteLn(F, TxtWriteLine);
  end;
    finally
      DmdFpnUtils.CloseInfo;
      System.Close(F);
      CAEtatAnnulation.Active := False;
      DecimalSeparator := ChrDecimalSep;
     end;
    end;

  flgExport :=False;

end;

//===========================================================================

function TFrmDetCAEtatAnnulation.GetTxtHeader():string;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAEtatAnnulation.GetTxtHeader
  inherited;
  //NoOfReason:=0;
  TxtHdr := DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;
  if RdBtnDetail.Checked then
     TxtHdr := TxtHdr +CtTxtDetail+':'+CtTxtCanceTicket + CRLF + CRLF
  else
  if RdBtnGlobal.Checked then
     TxtHdr := TxtHdr +CtTxtGlobal+':'+CtTxtCanceTicket + CRLF + CRLF
  else
  if RdBtnMotive.Checked then
  begin
     TxtHdr := TxtHdr +CtTxtMotif+':'+CtTxtCanceTicket + CRLF ;
     TxtHdr := TxtHdr+CtTxtReason+':'+GetTxtRpt4(8)+CRLF + CRLF
  end;
  TxtHdr := TxtHdr +CRLF+ DmdFpnTradeMatrix.InfoTradeMatrix [
            DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF ;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF+ CRLF;

  //TxtHdr := TxtHdr + Format (CtTxtPrintDate,                  //commented for //R2013.1 Defect fix 16(SC)
  //          [FormatDateTime (CtTxtDatFormat, Now)]) + CRLF;   //commented for //R2013.1 Defect fix 16(SC)

  //R2013.1 Defect fix 16(SC)--Start
  if FlgBDES then
    TxtHdr := TxtHdr + Format (CtTxtPrintDateBDES,
              [FormatDateTime ('dd-mm-yyyy', Date),
              FormatDateTime (CtTxtHouFormat, Now)]) + CRLF + CRLF
  else
  //R2013.1 Defect fix 16(SC)--End
    TxtHdr := TxtHdr + Format (CtTxtPrintDateCAFR,
              [FormatDateTime (CtTxtDatFormat, Now)]) + CRLF+ CRLF;

  Result := TxtHdr;
end;

//=============================================================================

procedure TFrmDetCAEtatAnnulation.PrintTableHeader;
begin  // of TFrmDetCAEtatAnnulation.PrintTableHeader
  VspPreview.TableBorder := tbBoxColumns;
  //VspPreview.StartTable;
  VspPreview.AddTable (FmtTableHeader, '', TxtTableTitle,
                       clWhite, clLTGray, False);
  if ReportType=4 then
   VspPreview.AddTable (GetTxtRpt4(5), '', GetTxtRpt4(6),
                       clWhite, clLTGray, False);
end;   // of TFrmDetCAEtatAnnulation.PrintTableHeader

//=============================================================================

function TFrmDetCAEtatAnnulation.GetTxtRpt4 (CallerId :Integer ) : string;
var
  FmtTableHeader   : string;
  FmtTableHeader2  : string;
  FmtTableBody     : string;
  FmtTableTotal    : string;
  TxtTableTitle2   : string;
  TxtTableTitle    : string;
  TxtTableBody     : string;
  TxtTotal         : string;
  tempStr1         : string;
  tempstr2         : string;
  CntIx            : Integer;
  TxtReason        : string;
  TxtExportBody    :string;
  TxtExportTitle2  :string;
  FlgAllReasonSelected : Boolean;  //R2013.1 Defect fix 16(SC)
begin
  FlgAllReasonSelected := False;//R2013.1 Defect fix 16(SC)
  FmtTableHeader   :='^+' + IntToStr(CalcWidthText(10, False));
  FmtTableHeader2  :='^+' + IntToStr(CalcWidthText(10, False));
  FmtTableBody     :='^+' + IntToStr(CalcWidthText(10, False));
  FmtTableTotal    :='<+' + IntToStr(CalcWidthText(10, False));
  TxtTableTitle    :=' '  ;
  TxtReason        :=''  ;
  TxtTableTitle2   :=CtTxtPeriod  ;
  TxtExportTitle2 :=  CtTxtPeriod;
  if(  ReportType=4) then
  begin
    if(FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('period').AsDateTime)='31-12-2999') then      //R2013.1- HPQC defectfix 66 (CP)
    begin
      TxtTableBody     := CtTxtTotal ;
      TxtExportBody    := CtTxtTotal  ;
    end
    else begin
      TxtTableBody     :=FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('period').AsDateTime);     //R2013.1- HPQC defectfix 66 (CP)
      TxtExportBody   :=FormatDateTime('dd-mm-yyyy',CAEtatAnnulation.FieldByName ('period').AsDateTime);      //R2013.1- HPQC defectfix 66 (CP)
    end;
  end;
  TxtTotal         :=CtTxtTotal   +TxtSep;

  //R2013.1 Defect fix 16(SC)--Start
  NoOfReason := 0;
  for CntIx := 0 to Pred (StrLstReasonList.Count) do begin
      if ChkLbxReason.Checked [CntIx]=true then begin
          NoOfReason:=NoOfReason+1;
      end;
  end;
  if (NoOfReason = StrLstReasonList.Count) then
    FlgAllReasonSelected := True;   
  //R2013.1 Defect fix 16(SC)--end

  for CntIx := 0 to Pred (StrLstReasonList.Count) do begin
     if ChkLbxReason.Checked [CntIx]  then begin
       tempstr1 :='';
       tempstr1 := copy(StrLstReasonList [CntIx],4,Length(StrLstReasonList [CntIx]));
       tempstr2 := copy(StrLstReasonList [CntIx],1,2);
       FmtTableHeader :=FmtTableHeader +TxtSep  +'^+' + IntToStr(CalcWidthText(17, False));    //R2013.1-defect 763-Fix(SC)
       FmtTableHeader2 :=FmtTableHeader2 +TxtSep+'^+' + IntToStr(CalcWidthText(7, False));     //R2013.1-defect 763-Fix(SC)
       FmtTableHeader2 :=FmtTableHeader2 +TxtSep+'^+' + IntToStr(CalcWidthText(10, False));
       FmtTableBody     :=FmtTableBody+TxtSep   +'>+' + IntToStr(CalcWidthText(7, False));     //R2013.1-defect 763-Fix(SC)
       FmtTableBody     :=FmtTableBody+TxtSep   +'>+' + IntToStr(CalcWidthText(10, False));
       TxtTableTitle2   :=TxtTableTitle2+TxtSep+CtTxtQuantity+TxtSep+CtTxtAmount;
       TxtExportTitle2  :=TxtExportTitle2+';'+CtTxtQuantity+';'+CtTxtAmount;
       FmtTableTotal    :=FmtTableTotal +TxtSep +'>+' + IntToStr(CalcWidthText(7, False));     //R2013.1-defect 763-Fix(SC)
       FmtTableTotal    :=FmtTableTotal+TxtSep  +'>+' + IntToStr(CalcWidthText(10, False));
       if(  ReportType=4) then
       begin
        TxtTableBody     :=TxtTableBody+TxtSep+CAEtatAnnulation.FieldByName ('Qty'+tempstr2).AsString
                                      +TxtSep+FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Price'+tempstr2).AsFloat);
       TxtExportBody    :=TxtExportBody+';'+CAEtatAnnulation.FieldByName ('Qty'+tempstr2).AsString
                                       +';'+FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('Price'+tempstr2).AsFloat);
       end;

       TxtTableTitle    :=TxtTableTitle +TxtSep+tempstr1;

       if not (FlgBDES and FlgAllReasonSelected) then   //R2013.1 Defect fix 16(SC)
         TxtReason        :=TxtReason+tempstr1+',';

   end;
  end;

       FmtTableHeader   :=FmtTableHeader +TxtSep +'^+' + IntToStr(CalcWidthText(17, False));   //R2013.1-defect 763-Fix(SC)
       FmtTableHeader2  :=FmtTableHeader2 +TxtSep+'^+' + IntToStr(CalcWidthText(7, False));    //R2013.1-defect 763-Fix(SC)
       FmtTableHeader2  :=FmtTableHeader2 +TxtSep+'^+' + IntToStr(CalcWidthText(10, False));
       FmtTableBody     :=FmtTableBody+TxtSep    +'>+' + IntToStr(CalcWidthText(7, False));    //R2013.1-defect 763-Fix(SC)
       FmtTableBody     :=FmtTableBody+TxtSep    +'>+' + IntToStr(CalcWidthText(10, False));
       FmtTableTotal    :=FmtTableTotal +TxtSep  +'>+' + IntToStr(CalcWidthText(7, False));    //R2013.1-defect 763-Fix(SC)
       FmtTableTotal    :=FmtTableTotal+TxtSep   +'>+' + IntToStr(CalcWidthText(10, False));
       TxtTableTitle2   :=TxtTableTitle2+TxtSep+CtTxtQuantity+TxtSep+CtTxtAmount;
       TxtExportTitle2  :=TxtExportTitle2+';'+CtTxtQuantity+';'+CtTxtAmount;
       if(  ReportType=4) then
       begin
       TxtTableBody     :=TxtTableBody+TxtSep+CAEtatAnnulation.FieldByName ('totQty').AsString
                                      +TxtSep+FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('totPrice').AsFloat);
       TxtExportBody    :=TxtExportBody+';'+CAEtatAnnulation.FieldByName ('totQty').AsString
                                       +';'+FormatFloat (CtTxtFrmNumber,CAEtatAnnulation.FieldByName ('totPrice').AsFloat);
       end;                  
       TxtTableTitle    :=TxtTableTitle +TxtSep+CtTxtTotalPeriod;

       //R2013.1 Defect fix 16(SC)--Start
       if FlgBDES and FlgAllReasonSelected then   
         TxtReason := CtTxtAll;  
       if not (FlgBDES and FlgAllReasonSelected) then                           
       //R2013.1 Defect fix 16(SC)--end
         Delete(TxtReason,Length(TxtReason),Length(TxtReason));

     if CallerId=1 then
      Result:=FmtTableHeader
     else
     if CallerId=2 then
      Result:=FmtTableBody
     else
     if CallerId=3 then
      Result:=TxtTableTitle
     else
     if CallerId=4 then
      Result:=TxtTableBody
     else
     if CallerId=5 then
      Result:=FmtTableHeader2
     else
     if CallerId=6 then
      Result:=TxtTableTitle2
     else
     if CallerId=7 then
      Result:=FmtTableTotal
     else
     if CallerId=8 then
      Result:=TxtReason
     else
     if CallerId=9 then
      Result:=TxtExportTitle2
     else
     if CallerId=10 then
      Result:=TxtExportBody;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun

