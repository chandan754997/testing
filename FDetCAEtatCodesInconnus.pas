//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet  : FlexPoint
// Customer: Castorama
// Unit    : FDetCAAuditCassiere.PAS : based on FDetGeneralCA (General
//                                      Detailform to print CAstorama rapports)
//------------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAEtatCodesInconnus.pas,v 1.8 2010/06/28 06:52:24 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetCAAuditCassiere.PAS - CVS revision 1.2
// Version          Date          Modifed By        Reason
// 1.9              12/07/2011    TCS(GG)           R2011.2 (BDES) Report on Price Modification Change
// 1.10             15/07/2011    SM(TCS)           TCS id 16 - Gratuits en caisse
// 1.11             15/07/2011    SM(TCS)           TCS id 16 - Gratuits en caisse Defect fix(63)
// 1.12             18/10/2011    SM(TCS)           TCS id 16 - Gratuits en caisse Defect fix(66)
// 1.13             15/11/2011    SM(TCS)           Defect fix 63
// 1.14             29/11/2011    SM(TCS)           Defect fix 222
// 1.15             08/12/2011    SM(TCS)           Defect fix 246
// 1.16             11/01/2012    SM(TCS)           Regression defect FIX
// 1.17             11/01/2012    GG(TCS)           Defect fix 400
// 1.18             06/03/2014    SMB (TCS)         R2013.2.ALM Defect Fix 164.All OPCO
// 1.19             13/06/2014    AJ (TCS)          R2014.2.Req(56010).BDES.Reason-correction-price

//==============================================================================

unit FDetCAEtatCodesInconnus;

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
  CtTxtTitle             = 'Report of free items,unknown codes and  price corrections';
  CtTxtTitleUnKownPrices = 'Report of unknown codes';
  CtTxtTitleCorrections  = 'Report of price corrections';
  CtTxtTitleFree         = 'Report of free items';                                 // R2011.2--BDES--Gratuits en Casse--SM(TCS)
  CtTxtTitleFR           = 'Report of unknown codes and  price corrections';                            // Defect fix 222 R2011.2

resourcestring     // of table header.
  CtTxtTest        = 'Selection Type';                                                  //Defect 246 Fix(SM)
  CtTxtCaissiere   = 'Operator Nr';
  CtTxtRayon       = 'Shelf/Sector';
  CtTxtTicket      = 'Ticket nr';
  CtTxtType        = 'Type';
  CtTxtCodeBarres  = 'Barcode';
  CtTxtQuantity    = 'Qty';                                            //Defect 66 Fix (S.M)
  CtTxtCode        = 'Internal code';
  CtTxtArtSaisi    = 'Description entered article';
  CtTxtArtFichier  = 'Description normal article';
  CtTxtPrixSaisi   = 'Entered price';
  CtTxtPrixFichier = 'Normal price';
  CtTxtEcart       = 'Difference';
  CtTxtReason      = 'Reason';                                                  //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
  CtTxtOperateur   = 'Operator';
  CtTxtNoData      = 'No data for this daterange';
  CtTxtPrintDate   = 'Printed on %s at %s';
  CtTxtReportDate  = 'Report from %s to %s';
  CtTxtForced      = 'Correction';
  CtTxtUnknown     = 'Unknown code';
  CtTxtStartEndDate= 'Startdate is after enddate!';
  CtTxtStartFuture = 'Startdate is in the future!';
  CtTxtEndFuture   = 'Enddate is in the future!';
  CtTxtMaxDays     = 'Selected daterange may not contain more then %s days';
  CtTxtAll         = 'All';
  CtTxtFree        = 'Free';                                                     // R2011.2--BDES--Gratuits en Casse--SM(TCS)
  CtTxtSupNo       = 'SupervisorNumber';  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
resourcestring // of table subtotals
  CtTxtSubtotal    = 'S/Total operator';

resourcestring // of run parameters
  CtTxtUOM         = '/VUOM=UOM notation of article code';
  CtTxtBRES        = '/VEXP=VEXP export to excel for Spain';

resourcestring // of export to excel parameters
  CtTxtPlace       = 'D:\sycron\transfertbo\excel';
  CtTxtExists      = 'File exists, Overwrite?';

//******************************************************************************
// Form-declaration.
//******************************************************************************

type
  TFrmDetCAEtatCodesInconnus = class(TFrmDetGeneralCA)
    SprCAEtatCodesInconnus: TStoredProc;
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    CmbAskSelection: TComboBox;
    SvcDBLblAskSelection: TSvcDBLabelLoaded;
    procedure BtnExportClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    ValPrixSaissi: Double; // Montant Prix Saisi
    ValPrixFichier: Double; // Montant Prix Fichier
    ValEcart: Double; // Ecart
    FFlgUOM: boolean; // OUM notation article code
    FFlgSpanje: boolean; // Executed in Spain
  protected
    // Formats of the rapport
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody   : string; override;
    function GetTxtTableTitle  : string; override;
    function GetTxtTitRapport  : string; override;
    function GetTxtRefRapport  : string; override;
    // Run params
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;

    procedure PrintSubTotalSpnje(QtyTickets   : Integer;                                 // R2011.2 - BDES - Gratuits en Caisse - SM(TCS)  //Defect Fix(222)R2011.2(SM)
                            QtyArticles  : Integer);
    procedure PrintSubTotal; virtual;       //Defect Fix(222)R2011.2(SM)
    procedure PrintTotal(TotQtyTickets: Integer;                                    // R2011.2 - BDES - Gratuits en Caisse - SM(TCS)
                         TotQtyArticles: Integer;
                         TotValSaissi:  double;
                         TotValFichier: double;
                         TotValEcart:   double);
    procedure ResetValues; virtual;
    procedure Execute; override;
    property FlgUOM : boolean read FFlgUOM write FFlgUOM;
    property FlgSpanje: boolean read FFlgSpanje write FFlgSpanje;
  end;

var
  FrmDetCAEtatCodesInconnus: TFrmDetCAEtatCodesInconnus;

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
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAEtatCodesInconnus.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.18 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 06:52:24 $';

//******************************************************************************
// Implementation of TFrmDetCAEtatCodesInconnus
//******************************************************************************

function TFrmDetCAEtatCodesInconnus.GetFmtTableHeader: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAEtatCodesInconnus.GetFmtTableHeader
if FlgSpanje then begin  //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::START
 //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ.Start
  if (CmbAskSelection.Text = CtTxtAll) or (CmbAskSelection.Text = CtTxtForced)
                                                                     then begin
    Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (5, False));           //Defect 66 Fix (S.M)
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (8, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  end
  else begin
      Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (11, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (18, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (5, False));           //Defect 66 Fix (S.M)
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (14, False));
  end;
 //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ.End
  for CntFmt := 0 to 2 do begin
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (11, False));        //Defect 66 Fix (S.M)
  end;
end
else begin  //R2011.2 Report on Price Modification Change TCS(GG) ::END
  Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (18, False));
  for CntFmt := 0 to 1 do begin
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  end;
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (18, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (14, False));
  for CntFmt := 0 to 2 do begin
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (13, False));
  end;
  end //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
end;   // of TFrmDetCAEtatCodesInconnus.GetFmtTableHeader

//==============================================================================

function TFrmDetCAEtatCodesInconnus.GetFmtTableBody: string;
var
  CntFmt           : integer;          // Loop for making the format.
begin  // of TFrmDetCAEtatCodesInconnus.GetFmtTableBody
  if FlgSpanje then begin  //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::START
  //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ.Start
  if (CmbAskSelection.Text = CtTxtAll) or (CmbAskSelection.Text = CtTxtForced)
                                                                     then begin
    Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (5, False));                 //Defect 66 Fix (S.M)
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (8, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (10, False));
  end
  else begin
      Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (16, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (11, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (18, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (5, False));                 //Defect 66 Fix (S.M)
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (14, False));
  end;
  //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ.End
  for CntFmt := 0 to 2 do begin
    Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (11, False));               //Defect 66 Fix (S.M)
  end;
  end
else begin  //R2011.2 Report on Price Modification Change TCS(GG) ::END
  Result := '<+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (18, False));
  for CntFmt := 0 to 1 do begin
    Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (15, False));
  end;
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (18, False));
  Result := Result + TxtSep + '<+' + IntToStr (CalcWidthText (14, False));
  for CntFmt := 0 to 2 do begin
    Result := Result + TxtSep + '>+' + IntToStr (CalcWidthText (13, False));
  end;
  end  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
end;   // of TFrmDetCAEtatCodesInconnus.GetFmtTableBody

//==============================================================================

function TFrmDetCAEtatCodesInconnus.GetTxtTableTitle : string;
begin  // of TFrmDetCAEtatCodesInconnus.GetTxtTableTitle
if FlgSpanje then begin  //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::START
Result :=   CtTxtCaissiere  + TxtSep +  CtTxtRayon  + TxtSep +  CtTxtTicket  +
              TxtSep + CtTxtType + TxtSep +CtTxtSupNo + TxtSep + CtTxtCodeBarres  + TxtSep +  CtTxtQuantity + TxtSep    //Defect 66 Fix (S.M)
              + CtTxtCode  + TxtSep + CtTxtPrixSaisi  + TxtSep + CtTxtPrixFichier
              + TxtSep + CtTxtEcart + TxtSep + CtTxtReason;                     //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
end
else begin  //R2011.2 Report on Price Modification Change TCS(GG) ::END
  Result :=   CtTxtCaissiere  + TxtSep +  CtTxtRayon  + TxtSep +  CtTxtTicket  +
              TxtSep +  CtTxtType + TxtSep +CtTxtCodeBarres  + TxtSep +
              CtTxtCode  + TxtSep + CtTxtPrixSaisi  + TxtSep + CtTxtPrixFichier
              + TxtSep + CtTxtEcart;
  end  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
end;   // of TFrmDetCAEtatCodesInconnus.GetTxtTableTitle)

//==============================================================================

function TFrmDetCAEtatCodesInconnus.GetTxtTitRapport : string;
begin  // of TFrmDetCAEtatCodesInconnus.GetTxtTitRapport
  Case CmbAskSelection.ItemIndex of
    0 : Result := CtTxtTitle;
    1 : Result := CtTxtTitleCorrections;
    2 : Result := CtTxtTitleUnKownPrices;
    3 : Result := CtTxtTitleFree;  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS)
  //Defect Fix(222)R2011.2(SM) ::START
  Else
   if FlgSpanje then
   Result := CtTxtTitle
   else
   Result := CtTxtTitleFR;
  end;
  //Defect Fix(222)R2011.2(SM) ::END
end;   // of TFrmDetCAEtatCodesInconnus.GetTxtTitRapport

//==============================================================================

function TFrmDetCAEtatCodesInconnus.GetTxtRefRapport : string;
begin  // of TFrmDetCAEtatCodesInconnus.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0005';
end;   // of TFrmDetCAEtatCodesInconnus.GetTxtRefRapport

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.Execute;
begin  // of TFrmDetCAEtatCodesInconnus.Execute
  ResetValues;

  SprCAEtatCodesInconnus.Active := False;
  SprCAEtatCodesInconnus.ParamByName ('@PrmDatFrom').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAEtatCodesInconnus.ParamByName ('@PrmDatTo').AsString :=
     FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
     FormatDateTime (ViTxtDBHouFormat, 0);
  SprCAEtatCodesInconnus.Active := True;
  if FlgSpanje then begin
    if CmbAskSelection.Text = CtTxtForced then begin
      SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 1';
      SprCAEtatCodesInconnus.Filtered := True
    end
    else if CmbAskSelection.Text = CtTxtUnknown then begin
      SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 2';
      SprCAEtatCodesInconnus.Filtered := True
      end
    // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
    else if (CmbAskSelection.Text = CtTxtFree) and FlgSpanje then begin  //Defect Fix(222)R2011.2(SM) 
      SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 3';
      SprCAEtatCodesInconnus.Filtered := True
    // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
    end
    else SprCAEtatCodesInconnus.Filtered := False;
  end;

  VspPreview.Orientation := orLandscape;
  VspPreview.StartDoc;

  If SprCAEtatCodesInconnus.RecordCount = 0 then
      VspPreview.AddTable (FmtTableBody, '', CtTxtNoData, clWhite,
                         clWhite, False)
  else
  PrintTableBody;
  VspPreview.EndDoc;

  PrintPageNumbers;
  PrintReferences;

  if FlgPreview then
    FrmVSPreview.Show
  else
    VspPreview.PrintDoc (False, 1, VspPreview.PageCount);

  FrmVSPreview.OnActivate(Self);
end;   // of TFrmDetCAEtatCodesInconnus.Execute

//==============================================================================
// TFrmDetCAEtatCodesInconnus.ResetValues : Clear all total values
//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.ResetValues;
begin  // of TFrmDetCAEtatCodesInconnus.ResetValues
  ValPrixSaissi  := 0;
  ValPrixFichier := 0;
  ValEcart       := 0;
end;   // of TFrmDetCAEtatCodesInconnus.ResetValues

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCAEtatCodesInconnus.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtReportDate,
            [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
            FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
 // Defect 246 Fix (SM) ::START
   if CmbAskSelection.Text = CtTxtForced then begin                                      
   TxtHdr := TxtHdr + CRLF + CtTxtTest + ':' + CtTxtForced;
   end
   else
   if CmbAskSelection.Text = CtTxtUnknown then begin
   TxtHdr := TxtHdr + CRLF + CtTxtTest + ':' + CtTxtUnknown;
   end
   else
   if CmbAskSelection.Text = CtTxtFree then begin
   TxtHdr := TxtHdr + CRLF + CtTxtTest + ':' + CtTxtFree;
   end
   else
   if CmbAskSelection.Text = CtTxtAll then begin
   TxtHdr := TxtHdr + CRLF + CtTxtTest + ':' + CtTxtAll;
   end;                                                                                   
 // Defect 246 Fix (SM) ::END
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetCAEtatCodesInconnus.PrintHeader

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.PrintTableBody;
var
  TxtPrintLine        : string;           // String to print
  StrCurrentOperator  : string;           // Current operator
  StrPreviousOperator : string;           // Previous operator   //Defect Fix(222)R2011.2(SM)
  Counter             : integer;                                 //Defect Fix 222( SM ) Regression Defect Fix
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
  QtyTickets          : integer;
  QtyArticles         : integer;
  TotQtyTickets       : integer;
  TotQtyArticles      : integer;
  TotValSaissi        : double;
  TotValFichier       : double;
  TotValEcart         : double;
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
  StrSupervisorNo     : string;           //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
  StrTickets          : string;           //R2011.2 (BDES)Report on Price Modification Change TCS(SM)
  StrOperatorChk      : string;           //R2011.2 (BDES)Report on Price Modification Change TCS(SM)
  StrMotif            : string;           //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
begin  // of TFrmDetCAEtatCodesInconnus.PrintTableBody
  inherited;
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
  QtyTickets  := 0;
  QtyArticles := 0;
  TotQtyTickets :=0;
  TotQtyArticles :=0;
  TotValSaissi := 0;
  TotValFichier := 0;
  TotValEcart := 0;
  Counter:=0;                                                                              //Defect Fix 222( SM ) Regression Defect Fix
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
  VspPreview.TableBorder := tbBoxColumns;
  
  If FlgSpanje then begin           //Defect Fix(222)R2011.2(SM) 
  //  VspPreview.StartTable;

    // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
    StrOperatorChk := '';                                                               // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)
    StrCurrentOperator :=
    SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString;
    StrTickets := SprCAEtatCodesInconnus.FieldByName ('IdtPostransaction').AsString;    // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)
    QtyTickets := 1;                                                                    // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)
    while not SprCAEtatCodesInconnus.Eof do begin
      If StrCurrentOperator<>
          SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString then begin
        PrintSubTotalSpnje (QtyTickets,QtyArticles);
        TotQtyTickets := TotQtytickets +  QtyTickets;
        TotQtyArticles := TotQtyArticles +  QtyArticles;
        TotValSaissi := TotValSaissi +  ValPrixSaissi;
        TotValFichier := TotValFichier +  ValPrixFichier;
        TotValEcart := TotValEcart +  ValEcart;
        QtyTickets := 1;
        QtyArticles := SprCAEtatCodesInconnus.FieldByName ('Quantity').AsInteger;      // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)
        ValPrixSaissi := SprCAEtatCodesInconnus.FieldByName ('PrixSaissi').AsFloat;
        ValPrixFichier := SprCAEtatCodesInconnus.FieldByName ('PrixFichier').AsFloat;
        ValEcart := SprCAEtatCodesInconnus.FieldByName ('Ecart').AsFloat;
        StrCurrentOperator :=
                   SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString;
        StrTickets :=  SprCAEtatCodesInconnus.FieldByName ('IdtPostransaction').AsString;     // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)
        StrMotif := SprCAEtatCodesInconnus.FieldByName ('MOTIF').AsString;                    //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
      end
      else begin
        If StrTickets <> SprCAEtatCodesInconnus.FieldByName ('IdtPostransaction').AsString    // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)::START
        then begin
          QtyTickets:= QtyTickets + 1;
          StrTickets :=  SprCAEtatCodesInconnus.FieldByName ('IdtPostransaction').AsString;
        end
        else begin
          StrTickets:= SprCAEtatCodesInconnus.FieldByName ('IdtPostransaction').AsString;
        end;                                                                                   // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)::END
        QtyArticles:= QtyArticles + SprCAEtatCodesInconnus.FieldByName ('Quantity').AsInteger ;
        ValPrixSaissi   := ValPrixSaissi +
           SprCAEtatCodesInconnus.FieldByName ('PrixSaissi').AsFloat;
        ValPrixFichier := ValPrixFichier +
           SprCAEtatCodesInconnus.FieldByName ('PrixFichier').AsFloat;
        ValEcart       := ValEcart +
           SprCAEtatCodesInconnus.FieldByName ('Ecart').AsFloat;
        StrMotif := SprCAEtatCodesInconnus.FieldByName ('MOTIF').AsString;                     //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
      end;
      StrSupervisorNo    :=
       SprCAEtatCodesInconnus.FieldByName ('SupervisorNo').AsString; // R2011.2 (BDES)Report on Price Modification Change TCS(GG)
      VspPreview.StartTable;
      if StrOperatorChk =  SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)::START
       then begin
         TxtPrintLine :='' + TxtSep + SprCAEtatCodesInconnus.FieldByName ('Rayon').AsString + TxtSep +
         SprCAEtatCodesInconnus.FieldByName ('IdtPosTransaction').AsString;
       end
      else
         TxtPrintLine := CtTxtOperateur + ' ' + StrCurrentOperator + TxtSep +
         SprCAEtatCodesInconnus.FieldByName ('Rayon').AsString + TxtSep +
         SprCAEtatCodesInconnus.FieldByName ('IdtPosTransaction').AsString;
      StrOperatorChk :=  SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString; // R2011.2 (BDES)-Gratuits en Caisse- TCS(SM)::END
      if SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString = '1' then begin
       TxtPrintLine := TxtPrintLine + TxtSep + CtTxtForced +TxtSep;
       if FlgSpanje then   //R2011.2 (BDES) Report on Price Modification Change TCS(GG)  ::START
            TxtPrintLine := TxtPrintLine + StrSupervisorNo +TxtSep;
      //R2011.2 Report on Price Modification Change TCS(GG)  ::END
      end
      else if
       SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString = '2' then begin
       TxtPrintLine := TxtPrintLine + TxtSep + CtTxtUnknown +TxtSep;
       if FlgSpanje then  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)  ::START
          TxtPrintLine := TxtPrintLine + StrSupervisorNo +TxtSep;
       //R2011.2 Report on Price Modification Change TCS(GG)  ::END
      end
      else begin
       TxtPrintLine := TxtPrintLine + TxtSep + CtTxtFree +TxtSep;
       if FlgSpanje then  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)  ::START
          TxtPrintLine := TxtPrintLine + StrSupervisorNo +TxtSep;
    //R2011.2 Report on Price Modification Change TCS(GG)  ::END
      end;
      // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
       TxtPrintLine := TxtPrintLine +
       SprCAEtatCodesInconnus.FieldByName ('NumPLU').AsString + TxtSep + SprCAEtatCodesInconnus.FieldByName ('Quantity').AsString + TxtSep;      //Defect 66 Fix (S.M)
      if FlgUOM then
       TxtPrintLine := TxtPrintLine +
       Copy(SprCAEtatCodesInconnus.FieldByName ('IdtArticle').AsString,1,7)
      else
       TxtPrintLine := TxtPrintLine +
      SprCAEtatCodesInconnus.FieldByName ('IdtArticle').AsString;
      TxtPrintLine := TxtPrintLine +
      TxtSep + FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('PrixSaissi').AsFloat) + TxtSep +
      FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('PrixFichier').AsFloat) + TxtSep +
      FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('Ecart').AsFloat)
         + TxtSep + SprCAEtatCodesInconnus.FieldByName ('MOTIF').AsString ;     //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
      VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                         clWhite, False);
     VspPreview.EndTable;

    SprCAEtatCodesInconnus.Next;
  end;
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
  PrintSubTotalSpnje(QtyTickets,QtyArticles);  //Defect Fix(222)R2011.2(SM)
  TotQtyTickets := TotQtyTickets +  QtyTickets;
  TotQtyArticles := TotQtyArticles +  QtyArticles;
  TotValSaissi := TotValSaissi +  ValPrixSaissi;
  TotValFichier := TotValFichier +  ValPrixFichier;
  TotValEcart := TotValEcart +  ValEcart;
  PrintTotal (TotQtyTickets,TotQtyArticles,TotValSaissi,TotValFichier,TotValEcart);
  // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End

  //VspPreview.EndTable;
  //Defect Fix(222)R2011.2(SM) ::START
  end       //Defect Fix(222)R2011.2(SM)
  else begin
  VspPreview.StartTable;

  while not SprCAEtatCodesInconnus.Eof do begin
  if (SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString = '1') or              //Defect Fix 222( SM ) Regression Defect Fix
    (SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString ='2') then begin
      StrCurrentOperator :=
       SprCAEtatCodesInconnus.FieldByName ('IdtOperator').AsString;
    If StrPreviousOperator = StrCurrentOperator then
       TxtPrintLine := ' ' + TxtSep
    else begin
       If not SprCAEtatCodesInconnus.Bof then begin
              if Counter <> 0 then                                                           //Defect Fix 222( SM ) Regression Defect Fix
                 PrintSubTotal;
              ResetValues;
       End;
       TxtPrintLine :=  CtTxtOperateur + ' ' + StrCurrentOperator + TxtSep
    End; //if StrPreviousOperator = StrCurrentOperator
    StrPreviousOperator := StrCurrentOperator;
    TxtPrintLine := TxtPrintLine +
      SprCAEtatCodesInconnus.FieldByName ('Rayon').AsString + TxtSep +
      SprCAEtatCodesInconnus.FieldByName ('IdtPosTransaction').AsString;
    if SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString = '1' then
      TxtPrintLine := TxtPrintLine + TxtSep + CtTxtForced +TxtSep
    else if SprCAEtatCodesInconnus.FieldByName ('CodTypeAction').AsString = '2' then          //Defect Fix 222( SM ) Regression Defect Fix
      TxtPrintLine := TxtPrintLine + TxtSep + CtTxtUnknown +TxtSep;
    TxtPrintLine := TxtPrintLine +
      SprCAEtatCodesInconnus.FieldByName ('NumPLU').AsString + TxtSep;
    if FlgUOM then
      TxtPrintLine := TxtPrintLine +
        Copy(SprCAEtatCodesInconnus.FieldByName ('IdtArticle').AsString,1,7)
    else
      TxtPrintLine := TxtPrintLine +
        SprCAEtatCodesInconnus.FieldByName ('IdtArticle').AsString;
    TxtPrintLine := TxtPrintLine +
      TxtSep + FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('PrixSaissi').AsFloat) + TxtSep +
      FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('PrixFichier').AsFloat) + TxtSep +
      FormatFloat(CtTxtFrmNumber,
      SprCAEtatCodesInconnus.FieldByName ('Ecart').AsFloat);
    VspPreview.AddTable (FmtTableBody, '', TxtPrintLine, clWhite,
                         clWhite, False);

    ValPrixSaissi   := ValPrixSaissi +
       SprCAEtatCodesInconnus.FieldByName ('PrixSaissi').AsFloat;
    ValPrixFichier := ValPrixFichier +
       SprCAEtatCodesInconnus.FieldByName ('PrixFichier').AsFloat;
    ValEcart       := ValEcart +
       SprCAEtatCodesInconnus.FieldByName ('Ecart').AsFloat;
    end;                                                                                     //Defect Fix 222( SM ) Regression Defect Fix
    Counter:=Counter + 1;                                                                    //Defect Fix 222( SM ) Regression Defect Fix
    SprCAEtatCodesInconnus.Next;
  end;
  PrintSubTotal;

  VspPreview.EndTable;
  end;
  

end;   // of TFrmDetCAEtatCodesInconnus.PrintTableBody
//Defect Fix(222)R2011.2(SM) ::END
//==============================================================================
//Defect Fix(222)R2011.2(SM) ::START
procedure TFrmDetCAEtatCodesInconnus.PrintSubTotal;
var
  TxtSubTotal      : string;
begin  // of TFrmDetCAEtatCodesInconnus.PrintSubTotal
  TxtSubTotal := CtTxtSubtotal + TxtSep + '' + TxtSep +  '' + TxtSep + '' +
              TxtSep + '' + TxtSep + '' + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixSaissi) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixFichier) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValEcart);
  VspPreview.EndTable;
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtSubTotal, clWhite,
                       clWhite, False);
  VspPreview.EndTable;
  VspPreview.StartTable;
  ValPrixSaissi    := 0;
  ValPrixFichier   := 0;
  ValEcart         := 0;
end;   // of TFrmDetCAEtatCodesInconnus.PrintSubTotal
//Defect Fix(222)R2011.2(SM) ::END
//==============================================================================
//==============================================================================
// TFrmDetCAEtatCodesInconnus : Print total values
//==============================================================================
//Defect Fix(222)R2011.2(SM) ::START
procedure TFrmDetCAEtatCodesInconnus.PrintSubTotalSpnje(QtyTickets :Integer;
                                                   QtyArticles :Integer);
var
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
  TxtSubTotal      : string;
begin  // of TFrmDetCAEtatCodesInconnus.PrintSubTotal
  if  FlgSpanje then  //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::START
   TxtSubTotal := CtTxtSubtotal + TxtSep + '' + TxtSep +  IntToStr(QtyTickets) +
              TxtSep + '' + TxtSep + '' +         // R2011.2 - BDES - Gratuits en Caisse - SM(TCS)
              TxtSep + '' + TxtSep + IntToStr(QtyArticles) + TxtSep + '' +  TxtSep +       //Defect 66 Fix (S.M)
              FormatFloat (CtTxtFrmNumber, ValPrixSaissi) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixFichier) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValEcart)
  else      //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::END
    TxtSubTotal := CtTxtSubtotal + TxtSep + '' + TxtSep +  '' + TxtSep + '' +
              TxtSep + '' + TxtSep + '' + TxtSep +
			  FormatFloat (CtTxtFrmNumber, ValPrixSaissi) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValPrixFichier) + TxtSep +
              FormatFloat (CtTxtFrmNumber, ValEcart);
  VspPreview.StartTable;
  VspPreview.AddTable (FmtTableBody, '', TxtSubTotal, clWhite,
                       clWhite, False);
  If FlgSpanje then begin 					   
  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  end;
  VspPreview.EndTable;
If not FlgSpanje then begin
  VspPreview.StartTable;
  ValPrixSaissi    := 0;
  ValPrixFichier   := 0;
  ValEcart         := 0;
End;
end;   // of TFrmDetCAEtatCodesInconnus.PrintSubTotal
//Defect Fix(222)R2011.2(SM) ::END
//==============================================================================
// TFrmDetCAEtatCodesInconnus : Print total values
// Added for R2011.2 - BDES - Gratuits en Caisse - SM(TCS)
//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.PrintTotal(TotQtyTickets: Integer;
                                              TotQtyArticles: Integer;
                                              TotValSaissi:  double;
                                              TotValFichier: double;
                                              TotValEcart:   double);

var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin   // of TFrmDetCAEtatCodesInconnus.PrintTotal

  VspPreview.StartTable;
 if  FlgSpanje then  //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::START
  TxtLine :=
       CtTxtTotal +  TxtSep + '' + TxtSep +  IntToStr(TotQtyTickets) +  TxtSep + '' +
       TxtSep + ''+ TxtSep + '' + TxtSep + IntToStr(TotQtyArticles) + TxtSep + '' + TxtSep +          //Defect 66 Fix (S.M)
       FormatFloat (CtTxtFrmNumber, TotValSaissi) + TxtSep +
       FormatFloat (CtTxtFrmNumber, TotValFichier) + TxtSep +
       FormatFloat (CtTxtFrmNumber, TotValEcart)
 else      //R2011.2 (BDES) Report on Price Modification Change TCS(GG) ::END
    TxtLine :=
       CtTxtTotal +  TxtSep + '' + TxtSep +  IntToStr(TotQtyTickets) +  TxtSep + '' +
       TxtSep + '' + TxtSep + IntToStr(TotQtyArticles) + TxtSep + '' + TxtSep +                        //Defect 66 Fix (S.M)
       FormatFloat (CtTxtFrmNumber, TotValSaissi) + TxtSep +
       FormatFloat (CtTxtFrmNumber, TotValFichier) + TxtSep +
       FormatFloat (CtTxtFrmNumber, TotValEcart);
  VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;

end;

//==============================================================================

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.FormPaint(Sender: TObject);
begin  // of TFrmDetCAEtatCodesInconnus.FormPaint
  inherited;
    BtnSelectAllClick(Self)
end;   // of TFrmDetCAEtatCodesInconnus.FormPaint

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.BtnPrintClick(Sender: TObject);
begin  // of TFrmDetCAEtatCodesInconnus.BtnPrintClick
  RbtDateDay.SetFocus;
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
end;  // of TFrmDetCAEtatCodesInconnus.BtnPrintClick

//=============================================================================

procedure TFrmDetCAEtatCodesInconnus.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmDetCAEtatCodesInconnus.BeforeCheckRunParams
  inherited;
  // add param /VBQC to help
  SplitString(CtTxtUOM, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
  SplitString(CtTxtBRES, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
end; // of TFrmDetCAEtatCodesInconnus.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCAEtatCodesInconnus.CheckAppDependParams(TxtParam: string);
begin // of TFrmDetCAEtatCodesInconnus.CheckAppDependParams
  if Copy(TxtParam, 3, 3) = 'UOM' then
    FlgUOM := True
  else if Copy(TxtParam, 3, 3) = 'EXP' then
    FlgSpanje := True
  else
    inherited;
end; // of TFrmDetCAEtatCodesInconnus.CheckAppDependParams

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.FormCreate(Sender: TObject);
var
  TxtParam               : string;
begin
  inherited;
  Self.Caption := CtTxtTitle;
  TxtParam := FindRunParam(TxtParam);
  if FlgSpanje then begin
    BtnExport.Visible := True;
    CmbAskSelection.Items.Clear;
    CmbAskSelection.Items.Add(CtTxtAll);
    CmbAskSelection.Items.Add(CtTxtForced);
    CmbAskSelection.Items.Add(CtTxtUnknown);
    CmbAskSelection.Items.Add(CtTxtFree); // R2011.2 - BDES - Gratuits en Caisse - SM(TCS)
    CmbAskSelection.Visible := True;
    CmbAskSelection.ItemIndex := 0;
    SvcDBLblAskSelection.Visible := True;
  end;
end;

//==============================================================================

procedure TFrmDetCAEtatCodesInconnus.BtnExportClick(Sender: TObject);
var
  TxtTitles              : string;
  TxtWriteLine           : string;
  counter                : integer;
  F                      : System.Text;
  StrCurrentOperator     : string; // Current operator
  StrPreviousOperator    : string; // Previous operator
  ChrDecimalSep          : char;
  Btnselect              : integer;
  FlgOK                  : Boolean;
  TxtPath                : String;
  QryHlp                 : TQuery;
begin // of TFrmDetCAEtatCodesInconnus.BtnExportClick
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
  else if (DtmPckDayTo.Date - DtmPckDayFrom.Date > CtMaxNumDays) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayto.Date := Now;
    MessageDlg(Format(CtTxtMaxDays,
      [IntToStr(CtMaxNumDays)]), mtWarning, [mbOK], 0);
  end
  else begin
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
      ResetValues;
      SprCAEtatCodesInconnus.Active := False;
      SprCAEtatCodesInconnus.ParamByName('@PrmDatFrom').AsString :=
        FormatDateTime(ViTxtDBDatFormat, DtmPckDayFrom.Date) + ' ' +
        FormatDateTime(ViTxtDBHouFormat, 0);
      SprCAEtatCodesInconnus.ParamByName('@PrmDatTo').AsString :=
        FormatDateTime(ViTxtDBDatFormat, DtmPckDayTo.Date + 1) + ' ' +
        FormatDateTime(ViTxtDBHouFormat, 0);
      SprCAEtatCodesInconnus.Active := True;
      SprCAEtatCodesInconnus.First;
      if FlgSpanje then begin
        if CmbAskSelection.Text = CtTxtForced then begin
          SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 1';
          SprCAEtatCodesInconnus.Filtered := True
        end
        else if CmbAskSelection.Text = CtTxtUnknown then begin
          SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 2';
          SprCAEtatCodesInconnus.Filtered := True
        end
        // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
        else if (CmbAskSelection.Text = CtTxtFree) and FlgSpanje then begin  //Defect Fix(222)R2011.2(SM)
          SprCAEtatCodesInconnus.Filter := 'CodTypeAction = 3';
          SprCAEtatCodesInconnus.Filtered := True
          // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
          end
        else SprCAEtatCodesInconnus.Filtered := False;
      end;
      if SprCAEtatCodesInconnus.RecordCount = 0 then begin
        TxtWriteLine := CtTxtNoData;
        WriteLn(F, TxtWriteLine);
      end
      else
        while not SprCAEtatCodesInconnus.Eof do begin
          TxtWriteLine := '';
          StrCurrentOperator :=
            SprCAEtatCodesInconnus.FieldByName('IdtOperator').AsString;
          if StrPreviousOperator = StrCurrentOperator then
            TxtWriteLine := ' ' + ';'
          else begin
            TxtWriteLine := CtTxtOperateur + ' ' + StrCurrentOperator + ';'
          end; //if StrPreviousOperator = StrCurrentOperator
          StrPreviousOperator := StrCurrentOperator;
          TxtWriteLine := TxtWriteLine +
            SprCAEtatCodesInconnus.FieldByName('Rayon').AsString + ';' +
            SprCAEtatCodesInconnus.FieldByName('IdtPosTransaction').AsString;
          // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - Start
          if SprCAEtatCodesInconnus.FieldByName('CodTypeAction').AsString = '1'
          then begin
            TxtWriteLine := TxtWriteLine + ';' + CtTxtForced + ';'
          end
          else if
           SprCAEtatCodesInconnus.FieldByName('CodTypeAction').AsString = '2' then begin
            TxtWriteLine := TxtWriteLine + ';' + CtTxtUnknown + ';'
          end
          else
            TxtWriteLine := TxtWriteLine + ';' + CtTxtFree + ';';
          // R2011.2 - BDES - Gratuits en Caisse - SM(TCS) - End
          //TxtWriteLine := TxtWriteLine + ';' + CtTxtUnknown + ';';  //Defect 63 fix SM
          TxtWriteLine := TxtWriteLine +  //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
          SprCAEtatCodesInconnus.FieldByName('SupervisorNo').AsString  + ';' ; //R2011.2 (BDES) Report on Price Modification Change TCS(GG)
          TxtWriteLine := TxtWriteLine + '="" & "' +                            //forces excel to recognize as string
            SprCAEtatCodesInconnus.FieldByName('NumPLU').AsString + '";'+SprCAEtatCodesInconnus.FieldByName('Quantity').AsString + ';';       //forces excel to recognize as string     //Defect 66 Fix  //Defect 63 Fix 2011.2 Phase 4     //Defect 400 Fix 2011.2 Phase8
          if FlgUOM then
            TxtWriteLine := TxtWriteLine +
              Copy(SprCAEtatCodesInconnus.FieldByName('IdtArticle').AsString, 1, 7)
          else
            TxtWriteLine := TxtWriteLine +
              SprCAEtatCodesInconnus.FieldByName('IdtArticle').AsString;
            TxtWriteLine := TxtWriteLine +
            ';' + FormatFloat('0.00',
            SprCAEtatCodesInconnus.FieldByName('PrixSaissi').AsFloat) + ';' +
            FormatFloat('0.00',
            SprCAEtatCodesInconnus.FieldByName('PrixFichier').AsFloat) + ';' +
            FormatFloat('0.00',
            SprCAEtatCodesInconnus.FieldByName('Ecart').AsFloat) + ';' +        //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
            SprCAEtatCodesInconnus.FieldByName('MOTIF').AsString;               //R2014.2.Req(56010).BDES.Reason_correction_price.TCS-AJ
          WriteLn(F, TxtWriteLine);
          SprCAEtatCodesInconnus.Next;
        end;
      System.Close(F);
    end;
    DecimalSeparator := ChrDecimalSep;
  end;
end; // of TFrmDetCAEtatCodesInconnus.BtnExportClick

//==============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of SfAutoRun