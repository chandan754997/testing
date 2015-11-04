//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Form specific for printing Castorama Rapports
// Customer : Castorama
// Unit   : FDetAcomptesEtAvoirs.PAS : Detail form Acomptes Et Avoirs
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetAcomptesEtAvoirs.pas,v 1.6 2010/04/13 12:41:37 BEL\DVanpouc Exp $
// History :
// - Started from Castorama - FlexPoint 2.0 - FDetAcomptesEtAvoirs.pas - CVS revision 1.2
// Version    Modified by    Reason
// 1.7        TCS SMB        R2011.2 Applix 2175416
// 1.8        TCS SMB        R2011.2 Bugfix 26012 - exclude manual invoices
// 1.9        TCS SRM        R2012.1 Applix.2545217.TCS.SRM - Duplicate data removal
// 2.0        TCS SRM        R2012.1 HPQC DefctFix 370
// 2.1        TCS SRM        R2013.2.ID36060.Translation.BDES
// 2.2		    TCS SM		     R2013.2.Req(31010).CAFR.DocBO_Advance_Payment
// 2.3        TCS Teesta     R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.
// 2.4        TCS CP         R2014.1.Enhancement-51.CAFR
//=============================================================================

unit FDetAcomptesEtAvoirs;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, OvcBase, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE,
  SmVSPrinter7Lib_TLB, Db,DBTables, ExtDlgs;                                    //DBTables, ExtDlgs added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring     // for runparameters of the document.
  CtPrmRunGlobal   = '/VGlobal=Select the global rapport';
  CtTxtExport      = '/VEXP=EXP export to excel';                               //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CtTxtCAFROutD    = '/VOUTD=OUTD Outdated column add';                         //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta

resourcestring     // for table header of the document.
  CtTxtOperator      = 'Operator Number';
  CtTxtOperatorExp   = 'PC';                                                    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CtTxtDocNb         = 'Document Number';
  CtTxtDocType       = 'Type';
  CtTxtTransDate     = 'Transaction Date';
  CtTxtTicketNb      = 'Ticket Number';
  CtTxtAmountRec     = 'Amount Received';
  CtTxtAmountReturn  = 'Amount Returned';
  CtTxtExtraAdvance  = 'Extra Advance';
  CtTxtCancelAdvance = 'Cancel Advance';
  CtTxtOutDated      = 'Outdated';                                              //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  CtTxtModifAdvance     = 'Modification Advance';
  CtTxtSubTotCaissiere  = 'S/Total operator';
  CtTxtTotAcompte       = 'Total Advance';
  CtTxtTotAvoir      = 'Total Credit';
  CtTxtTotGlobal     = 'Total Global';
  CtTxtTotal         = 'Total';

resourcestring
  CtTxtTitlejour    = 'Advances and credits of the day';
  CtTxtTitleGlobal  = 'Global advances and credits';
  CtTxtAcompte      = 'Advance';
  CtTxtAvoir        = 'Credit';
  CtTxtReportDate   = 'Report from %s to %s';
  CtTxtPrintDate    = 'Printed on %s at %s';
  CtTxtStartEndDate = 'Startdate is after enddate!';
  CtTxtStartFuture  = 'Startdate is in the future!';
  CtTxtEndFuture    = 'Enddate is in the future!';
  CtTxtErrorHeader  = 'Incorrect Date';
  CtTxtFrmTitle     = 'Report Advances and Credits of the day';                 //R2013.2.ID36060.Translation.BDES

//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
resourcestring     // of export to excel parameters
  CtTxtPlace            = 'D:\sycron\transfertbo\excel';
  CtTxtExists           = 'File exists, Overwrite?';
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
const
  CtTxtFmtDat      = '%s-%s-%s';


//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TObjDocument = class
  protected
    QtyDocument    : Integer;          // Number of document
    ValAmountRec   : Double;           // Value Received
    ValAmountReturn: Double;           // Value Returned
    ValExtraAmount : Double;           // Value Extra Amount
    ValCanAmount   : Double;           // Value Canceled Amount
    ValExpAmount   : Double;           // Value Outdated Amount                 //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  public
    procedure Add (CodAction : Integer; Qty : Integer; Value : Double);
                                                     overload; virtual; abstract;
    procedure Add (ObjDoc : TObjDocument); overload; virtual;
    function BuildLine (DtsSet : TDataSet) : string; overload; virtual; abstract;
    procedure Clear;
  end; // of TObjDocument

  TObjDocAvoir = class (TObjDocument)
  public
    procedure Add (CodAction : Integer; Qty : Integer; Value : Double);
                                                             overload; override;
    function BuildLine (DtsSet : TDataSet) : string; override;
  end; // of TObjDocAvoir

  TObjDocAcompte = class (TObjDocument)
  public
    procedure Add (CodAction : Integer; Qty : Integer; Value : Double);
                                                             overload; override;
    function BuildLine (DtsSet : TDataSet) : string; override;
  end; // of TObjDocAcompte

  TObjDocGlobalAcompte = class (TObjDocument)
  public
    procedure Add (CodAction : Integer; Qty : Integer; Value : Double);
                                                             overload; override;
    function BuildLine (DtsSet : TDataSet) : string; override;
  end; // of TObjDocAcompte


type
  TFrmDetAcomptesEtAvoirs = class(TFrmDetGeneralCA)
    BtnExport: TSpeedButton;                                                    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    SavDlgExport: TSaveTextFileDialog;                                          //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    procedure BtnExportClick(Sender: TObject);                                  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    procedure FormCreate(Sender: TObject);					//R2013.2.ID36060.Translation.BDES
    procedure RbtDateDayClick(Sender: TObject);
  private
    { Private declarations }
    FFlgExport     : Boolean;                                                   //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    FFlgOutDate    : Boolean;                                                   //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  protected
    FlgGlobalRap   : Boolean;          // Select Global Rap.
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;

    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetFmtTableSubTotal : string; virtual;

    function GetTxtTableTitle : string; override;
    function GetTxtTableFooter : string; override;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport : string; override;
  public
    ObjDocAcompte  : TObjDocAcompte;   // Acompte ObjectDocument
    ObjDocAvoir    : TObjDocAvoir;     // Avoir ObjectDocument
    ObjDocGlobalAcompte : TObjDocGlobalAcompte;  // Global Acomptes Objectdoc
    ObjDocGlobal   : TObjDocument;     // Global ObjectDocument

    function BuildStatement : string;
    procedure PrintHeader; override;
    procedure PrintSubTotal (NumOperator   : Integer;
                             ObjDoc        : TObjDocument); virtual;
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;

    procedure Execute; override;
    property FmtTableSubTotal : string read GetFmtTableSubTotal;
    property FlgExport: boolean read FFlgExport write FFlgExport;               //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    property FlgOutDate: boolean read FFlgOutDate write FFlgOutDate;            //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  end;

  function CutNumToDateTime (TxtNum : string) : string;

var
  FrmDetAcomptesEtAvoirs: TFrmDetAcomptesEtAvoirs;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils, DFpnPosTransActionCA, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetAcomptesEtAvoirs.pas,v $';
  CtTxtSrcVersion = '$Revision: 2.3 $';
  CtTxtSrcDate    = '$Date: 2014/01/15 12:41:37 $';


function CutNumToDateTime (TxtNum : string) : string;
var
  TxtDay      : string;                // Day
  TxtMonth    : string;                // Month
  TxtYear     : string;                // Year
  TxtHour     : string;                // Hour
  TxtMin      : string;                // Min
  TxtSec      : string;                // Second
begin  // of CutNumToDateTime
  TxtYear  := Copy (TxtNum, 1, 4);
  TxtMonth := Copy (TxtNum, 5, 2);
  TxtDay   := Copy (TxtNum, 7, 2);
  TxtHour  := Copy (TxtNum, 9, 2);
  TxtMin   := Copy (TxtNum, 11, 2);
  TxtSec   := Copy (TxtNum, 13, 2);

  Result := Format (CtTxtFmtDat, [TxtDay, TxtMonth, TxtYear]);
end;   // of CutNumToDateTime

//*****************************************************************************
// Implementation of TObjDocument
//*****************************************************************************

procedure TObjDocument.Add (ObjDoc : TObjDocument);
begin  // of TObjDocument.Add
  QtyDocument    := QtyDocument + ObjDoc.QtyDocument;
  ValAmountRec   := ValAmountRec + ObjDoc.ValAmountRec;
  ValAmountReturn:= ValAmountReturn +  ObjDoc.ValAmountReturn;
  ValExtraAmount := ValExtraAmount + ObjDoc.ValExtraAmount;
  ValCanAmount   := ValCanAmount + ObjDoc.ValCanAmount;
  ValExpAmount   := ValExpAmount + ObjDoc.ValExpAmount;                         //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TObjDocument.Add

//=============================================================================

procedure TObjDocument.Clear;
begin  // of TObjDocument.Clear
  QtyDocument    := 0;
  ValAmountRec   := 0;
  ValAmountReturn:= 0;
  ValExtraAmount := 0;
  ValCanAmount   := 0;
  ValExpAmount   := 0;                                                          //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TObjDocument.Clear

//*****************************************************************************
// Implementation of TObjDocAcompte
//*****************************************************************************

procedure TObjDocAcompte.Add (CodAction : Integer;
                              Qty       : Integer;
                              Value     : Double);
begin  // of TObjDocAcompte.Add
  QtyDocument := QtyDocument + Qty;
  case CodAction of
    CtCodActPayAdvance : begin
      if Value < -CtValMinFloat then
        ValCanAmount := ValCanAmount + Value
      else
        ValAmountRec := ValAmountRec + Value;
    end;
    CtCodActChangeAdvance   : ValExtraAmount := ValExtraAmount + Value;
    CtCodActTakeBackAdvance : ValAmountReturn := ValAmountReturn + Value;
    CtCodActPayForfait      : ValAmountRec := ValAmountRec + Value;
    CtCodActTakeBackForfait : ValAmountReturn := ValAmountReturn + Value;
  end
end;   // of TObjDocAcompte.Add

//=============================================================================

function TObjDocAcompte.BuildLine (DtsSet: TDataSet): string;
begin  // of TObjDocAcompte.BuildLine
  Add (DtsSet.FieldByName ('CodAction').AsInteger, 1,
       DtsSet.FieldByName ('ValInclVAT').AsFloat);

  Result := DtsSet.FieldByName ('IdtOperator').AsString + TxtSep +
            DtsSet.FieldByName ('NbDoc').AsString + TxtSep +
            CtTxtAcompte + TxtSep +
            DtsSet.FieldByName ('DatTransBegin').AsString + TxtSep +
            DtsSet.FieldByName ('IdtPOSTransaction').AsString + TxtSep;

  case DtsSet.FieldByName ('CodAction').AsInteger of
   CtCodActPayAdvance : begin
     if DtsSet.FieldByName ('ValInclVAT').AsFloat <
         -CtValMinFloat then
       Result := Result + TxtSep + TxtSep + TxtSep;
     end;
   CtCodActChangeAdvance   : Result := Result + TxtSep + TxtSep;
   CtCodActTakeBackAdvance : Result := Result + TxtSep;
   //CtCodActPayForfait      : // Do Nothing;
   CtCodActTakeBackForfait : Result := Result + TxtSep;
  end;

  Result := Result +
          FormatFloat (CtTxtFrmNumber,
                       DtsSet.FieldByName ('ValInclVAT').AsFloat);
end;   // of TObjDocAcompte.BuildLine

//*****************************************************************************
// Implementation of TObjDocGlobalAcompte
//*****************************************************************************

procedure TObjDocGlobalAcompte.Add (CodAction, Qty: Integer; Value: Double);
begin  // of TObjDocGlobalAcompte.Add
  QtyDocument := QtyDocument + Qty;
  case CodAction of
    1 : ValAmountRec    := ValAmountRec    + Value;
    2 : ValAmountReturn := ValAmountReturn + Value;
  end
end;   // of TObjDocGlobalAcompte.Add

//=============================================================================

function TObjDocGlobalAcompte.BuildLine(DtsSet: TDataSet): string;
var
  TxtType          : string;
  TxtDate          : string;
begin  // of TObjDocGlobalAcompte.BuildLine
  // We must add the Verse and Respris is there's one line, that's the reason
  // why we just put 1 in the add of the first statement.
  Add (1, 1, DtsSet.FieldByName ('M_Acompte_Verse_Reel').AsFloat);
  Add (2, 0, DtsSet.FieldByName ('M_Acompte_Repris_Reel').AsFloat);

  if DtsSet.FieldByName ('TYPE').AsInteger = 1 then begin
    TxtType := CtTxtAcompte;
    TxtDate := CutNumToDateTime (DtsSet.FieldByName ('DCreation').AsString);
  end
  else begin
    TxtType := CtTxtAvoir;
    TxtDate := DtsSet.FieldByName ('NumDate').AsString;
  end;

  Result := DtsSet.FieldByName ('CVente').AsString + TxtSep +
            TxtType + TxtSep + TxtDate +
            TxtSep +
            FormatFloat (CtTxtFrmNumber,
                         DtsSet.FieldByName ('M_Acompte_Verse_Reel').AsFloat) +
            TxtSep +
            FormatFloat (CtTxtFrmNumber,
                         DtsSet.FieldByName ('M_Acompte_Repris_Reel').AsFloat);
end;   // of TObjDocGlobalAcompte.BuildLine

//*****************************************************************************
// Implementation of TObjDocAvoir
//*****************************************************************************

procedure TObjDocAvoir.Add (CodAction : Integer;
                            Qty       : Integer;
                            Value     : Double);
begin  // of TObjDocAvoir.Add
  QtyDocument := QtyDocument + Qty;
  case CodAction of
    CtCodActCredCoupCreate : ValAmountRec := ValAmountRec + Value;
	//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    CtCodActCredCoupAccept : begin                                              
      if DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger=97 then
         ValExpAmount :=  ValExpAmount + value
      else
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
        ValAmountReturn := ValAmountReturn + Value;
    end;                                                                        //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  end
end;   // of TObjDocAvoir.Add

//=============================================================================

function TObjDocAvoir.BuildLine (DtsSet: TDataSet): string;
begin  // of TObjDocAvoir.BuildLine
  Add (DtsSet.FieldByName ('CodAction').AsInteger, 1,
       DtsSet.FieldByName ('ValInclVAT').AsFloat);

  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if DtsSet.FieldByName ('CodTrans').AsInteger = 97 then
    Result := CtTxtOperatorExp + TxtSep +
              DtsSet.FieldByName ('NumPLU').AsString + TxtSep +
              CtTxtAvoir + TxtSep +
              DtsSet.FieldByName ('DatTransBegin').AsString + TxtSep +
              '' + TxtSep
  else
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    Result := DtsSet.FieldByName ('IdtOperator').AsString + TxtSep +
              DtsSet.FieldByName ('NumPLU').AsString + TxtSep +
              CtTxtAvoir + TxtSep +
              DtsSet.FieldByName ('DatTransBegin').AsString + TxtSep +
              DtsSet.FieldByName ('IdtPOSTransaction').AsString + TxtSep;

  if DtsSet.FieldByName ('CodAction').AsInteger = CtCodActCredCoupAccept then
    Result := Result + TxtSep;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if DtsSet.FieldByName ('CodTrans').AsInteger = 97 then
    Result := Result + TxtSep + TxtSep + TxtSep;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
  Result := Result +
          FormatFloat (CtTxtFrmNumber,
                       DtsSet.FieldByName ('ValInclVAT').AsFloat);
end;   // of TObjDocAvoir.BuildLine

//*****************************************************************************
// Implementation of TFrmDetAcomptesEtAvoirs
//*****************************************************************************

procedure TFrmDetAcomptesEtAvoirs.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmDetAcomptesEtAvoirs.BeforeCheckRunParams
  inherited;
  SplitString (CtPrmRunGlobal, '=', TxtPartLeft, TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  // add param /VEXP to help
  SplitString(CtTxtExport, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
  // add param /VOUTD to help
  SplitString(CtTxtCAFROutD, '=', TxtPartLeft, TxtPartRight);
  SfDialog.AddRunParams(TxtPartLeft, TxtPartRight);
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
end;   // of TFrmDetAcomptesEtAvoirs.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.CheckAppDependParams (TxtParam : string);
begin  // of TFrmDetAcomptesEtAvoirs.CheckAppDependParams
  if (Length (TxtParam) > 2) and (TxtParam[1] = '/') and
   (UpCase (TxtParam[2]) = 'V') then begin
    if AnsiUpperCase (Copy (TxtParam, 3, 6)) = 'GLOBAL' then
      FlgGlobalRap := True
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
    else if Copy(TxtParam, 3, 3)= 'EXP' then
      FlgExport := True
    else if Copy(TxtParam, 3, 4)= 'OUTD' then
      FlgOutDate := True
    //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    else
      inherited;
  end
  else
    inherited;
end;   // of TFrmDetAcomptesEtAvoirs.CheckAppDependParams

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetFmtTableHeader : string;
var
  CntFmt           : Integer;          // Loop for making the format.
begin  // of TFrmDetAcomptesEtAvoirs.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgOutDate then begin
    for CntFmt := 0 to 5 do begin                                                 
      Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
    end;
  end
  else begin
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    for CntFmt := 0 to 4 do begin
      Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
    end;
  end;                                                                          //End added for else, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TFrmDetAcomptesEtAvoirs.GetFmtTableHeader

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetFmtTableBody : string;
var
  CntFmt           : Integer;          // Loop for making the format.
begin  // of TFrmDetAcomptesEtAvoirs.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (10, False));
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgOutDate then begin
    for CntFmt := 0 to 5 do begin
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (10, False));
    end;
  end
  else begin
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    for CntFmt := 0 to 4 do begin
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (10, False));
    end;
  end;                                                                          //End added for else, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TFrmDetAcomptesEtAvoirs.GetFmtTableBody

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetFmtTableSubTotal : string;
var
  CntFmt           : Integer;          // Loop for making the format.
begin  // of TFrmDetAcomptesEtAvoirs.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (10, False));
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgOutDate then begin
    for CntFmt := 0 to 5 do begin
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (10, False));
    end;
  end
  else begin
  //CntFmt changed from 4 to 5, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    for CntFmt := 0 to 4 do begin
      Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (10, False));
    end;
  end;                                                                          //End added for else, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
end;   // of TFrmDetAcomptesEtAvoirs.GetFmtTableSubTotal

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetTxtTableTitle : string;
begin  // of TFrmDetAcomptesEtAvoirs.GetTxtTableTitle
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgOutDate then
    Result := CtTxtOperator      + TxtSep + CtTxtDocNb        + TxtSep +
              CtTxtDocType       + TxtSep + CtTxtTransDate    + TxtSep +
              CtTxtTicketNb      + TxtSep +
              CtTxtAmountRec     + TxtSep +
              CtTxtAmountReturn  + TxtSep + CtTxtExtraAdvance + TxtSep +
              CtTxtCancelAdvance + TxtSep + CtTxtOutDated + TxtSep +             //CtTxtOutDated added, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
              CtTxtModifAdvance                                                  //CtTxtModifAdvance is shifted in next line, R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  else
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    Result := CtTxtOperator      + TxtSep + CtTxtDocNb        + TxtSep +
              CtTxtDocType       + TxtSep + CtTxtTransDate    + TxtSep +
              CtTxtTicketNb      + TxtSep +
              CtTxtAmountRec     + TxtSep +
              CtTxtAmountReturn  + TxtSep + CtTxtExtraAdvance + TxtSep +
              CtTxtCancelAdvance + TxtSep + CtTxtModifAdvance;
end;   // of TFrmDetAcomptesEtAvoirs.GetTxtTableTitle

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetTxtTableFooter : string;
begin  // of TFrmDetAcomptesEtAvoirs.GetTxtTableFooter
end;   // of TFrmDetAcomptesEtAvoirs.GetTxtTableFooter

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetTxtTitRapport : string;
begin  // of TFrmDetAcomptesEtAvoirs.GetTxtTitRapport
  Result := CtTxtTitleJour;
end;   // of TFrmDetAcomptesEtAvoirs.GetTxtTitRapport

//=============================================================================

function TFrmDetAcomptesEtAvoirs.GetTxtRefRapport : string;
begin  // of TFrmDetAcomptesEtAvoirs.GetTxtRefRapport
  Result := inherited GetTxtRefRapport;
  Result := Result + '0007';
end;   // of TFrmDetAcomptesEtAvoirs.GetTxtRefRapport

//=============================================================================

function TFrmDetAcomptesEtAvoirs.BuildStatement : string;
var
  TxtDateToLoad    : string;           // Sting that contains the date to load
begin  // of TFrmDetAcomptesEtAvoirs.BuildStatement
  // if the 'acompte' payed > 'repris' then show record
  if RbtDateDay.Checked then begin
    TxtDateToLoad :=
      #10' AND Act.DatTransBegin BETWEEN ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
  end
  else if RbtDateLoaded.Checked then begin
    TxtDateToLoad :=
      #10' AND Act.DatLoaded BETWEEN ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''');
  end;

  Result :=
    #10'SELECT 1 TYPE, IdtOperator, Det1.TxtDescr Description,' +
    #10'       Det1.CodAction CodAction, Det1.NumPLU NumPLU, Null NbDoc,'+
    #10'       Det1.DatTransBegin DatTransBegin, ' +
    #10'       Det1.IdtPOSTransaction IdtPOSTransaction,'+
    #10'       Det1.ValInclVAT ValInclVAT,'+
    #10'       Det1.CodTrans CodTrans'+                                         //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    #10'  FROM POSTransDetail Det1'+
    #10' INNER JOIN POSTransaction Act'+
    #10'    ON Det1.IdtPOSTransaction = Act.IdtPOSTransaction'+
    #10'   AND Det1.IdtCheckOut = Act.IdtCheckOut'+
    #10'   AND Det1.CodTrans = Act.CodTrans'+
    #10'   AND Det1.DatTransBegin = Act.DatTransBegin'+
    #10' WHERE Det1.CodAction in (' + IntToStr (CtCodActCredCoupCreate) + ', ' +
                                      IntToStr (CtCodActCredCoupAccept) + ') ' +
    #10'   AND Act.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'   AND ISNULL (Act.CodReturn, 0) = 0' +
    #10'   AND Act.FlgTraining = 0' +
    #10'   AND (Det1.IdtPOSTransaction <> 0 OR Det1.IdtCheckOut <> 0)' +        // Bugfix.26012.TCS.SMB - exclude manual invoices
    TxtDateToLoad +
    //#10'UNION'+                                                       //R2011.2 TCS SMB Applix 2175416
    #10'UNION ALL'+                                                     //R2011.2 TCS SMB Applix 2175416
    #10'SELECT DISTINCT 0 TYPE, Act.IdtOperator, Det1.TxtDescr Description,'+   //R2013.2-APPLIX(2807896)-TCS-GG
    #10'       Det1.CodAction CodAction, Null NumPLU, Det2.IdtCVente NbDoc,'+
    #10'       Det1.DatTransBegin DatTransBegin,'+
    #10'       Det1.IdtPOSTransaction IdtPOSTransaction,'+
    #10'       Det1.ValInclVAT ValInclVAT,'+
    #10'       Det1.CodTrans CodTrans'+                                         //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    #10'  FROM POSTransDetail Det1'+
    #10'  INNER JOIN POSTransDetail Det2'+
    #10'     ON Det1.IdtPOSTransaction = Det2.IdtPOSTransaction'+
    #10'    AND Det1.IdtCheckOut = Det2.IdtCheckOut'+
    #10'    AND Det1.CodTrans = Det2.CodTrans'+
    #10'    AND Det1.DatTransBegin = Det2.DatTransBegin'+
    #10'    AND Det1.CodTypeVente = Det2.CodTypeVente'+
    #10'    AND Det1.IdtCVente = Det2.IdtCVente'+
    #10'    AND Det2.CodAction = ' + IntToStr (CtCodActDocBO) +
    //#10'    AND Det2.Codtype = 350 ' +                                          //R2012.1 Applix.2545217.TCS.SRM Commented out for HPQC DefectFix 370
    #10'  INNER JOIN POSTransaction Act'+
    #10'     ON Det1.IdtPOSTransaction = Act.IdtPOSTransaction'+
    #10'    AND Det1.IdtCheckOut = Act.IdtCheckOut'+
    #10'    AND Det1.CodTrans = Act.CodTrans'+
    #10'    AND Det1.DatTransBegin = Act.DatTransBegin'+
    #10' WHERE Det1.CodAction in (' + IntToStr (CtCodActPayAdvance)      + ' ,'
                                    + IntToStr (CtCodActChangeAdvance)   + ' ,'
                                    + IntToStr (CtCodActTakeBackAdvance) + ', '
                                    + IntToStr (CtCodActPayForfait)      + ', '
                                    + IntToStr (CtCodActTakeBackForfait) + ')' +
    #10'   AND Det1.CodAnnul IS NULL'+
    #10'   AND Det1.CodTypeVente IN (2,4)'+
    #10'   AND Act.IdtOperator IN (' + TxtLstOperID  + ')' +
    #10'   AND ISNULL (Act.CodReturn, 0) = 0' +
    #10'   AND (Det1.IdtPOSTransaction <> 0 OR Det1.IdtCheckOut <> 0)' + // Bugfix.26012.TCS.SMB - exclude manual invoices
    TxtDateToLoad +
    #10'   AND Act.FlgTraining = 0' +
    #10'   AND Det1.ValInclVAT <> 0' +                                          //R2013.2.Req(31010).CAFR.DocBO_Advance_Payment.TCS-SM
    //Defect 283 fixed GG(TCS) :: Start
    #10'UNION ALL' +
    #10'SELECT 1 TYPE, gdc.IdtOperator,''AVOIR '' + barcode Description,' +
    #10'       133, barcode NumPLU, Null NbDoc,' +
    #10'       gdc.DatTransBegin DatTransBegin,' +
    #10'       gdc.IdtPOSTransaction IdtPOSTransaction,' +
    #10'       -(gdc.ValAmount) ValInclVAT,' +
    #10'       gdc.CodTrans CodTrans'+                                          //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
    #10'  FROM globalcredcoup gdc (nolock)' +
    #10'  left outer JOIN Creditcoupon CC (nolock)' +
    #10'     ON CC.IdtCredCoup=gdc.IdtCredCoup' +
    #10' WHERE gdc.IdtPOSTransaction = 0' +
    #10' and gdc.IdtCheckout = 0' +
    #10' AND gdc.DatTransBegin BETWEEN ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr
             (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''')+
    //Defect 283 fixed GG(TCS) :: End
    #10'ORDER BY Act.IdtOperator, Type, IdtPOSTransaction';
end;   // of TFrmDetAcomptesEtAvoirs.BuildStatement

//==============================================================================

procedure TFrmDetAcomptesEtAvoirs.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetAcomptesEtAvoirs.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  If RbtDateDay.Checked then
    TxtHdr := TxtHdr + Format (CtTxtReportDate,
              [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.Date),
              FormatDateTime (CtTxtDatFormat, DtmPckDayTo.Date)]) + CRLF
  else
    TxtHdr := TxtHdr + Format (CtTxtReportDate,
              [FormatDateTime (CtTxtDatFormat, DtmPckLoadedFrom.Date),
              FormatDateTime (CtTxtDatFormat, DtmPckLoadedTo.Date)]) + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;
      
  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetAcomptesEtAvoirs.PrintHeader

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.PrintSubTotal (NumOperator   : Integer;
                                                 ObjDoc        : TObjDocument);
var
  TxtLine          : string;           // Line to print
  IdxRow           : Integer;          // Current Row index;
  IdxCol           : Integer;          // Current Col index;
begin  // of TFrmDetAcomptesEtAvoirs.PrintSubTotal
  if ObjDoc.QtyDocument = 0 then
    Exit;

  VspPreview.EndTable;
  VspPreview.StartTable;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
 // if DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger=97 then            //commented for //R2014.1.Enhancement-51.CAFR.TCS-CP
    TxtLine :=
      CtTxtSubTotCaissiere + ' ' + CtTxtOperatorExp + TxtSep +
      IntToStr (ObjDoc.QtyDocument) + TxtSep + TxtSep + TxtSep + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValAmountRec) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValAmountReturn) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValExtraAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValCanAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValExpAmount);
  //commented for //R2014.1.Enhancement-51.CAFR.TCS-CP.Start
 { else
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
    TxtLine :=
      CtTxtSubTotCaissiere + ' ' + IntToStr (NumOperator) + TxtSep +
      IntToStr (ObjDoc.QtyDocument) + TxtSep + TxtSep + TxtSep + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValAmountRec) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValAmountReturn) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValExtraAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDoc.ValCanAmount);     }
  //Commented for //R2014.1.Enhancement-51.CAFR.TCS-CP.End
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);

  IdxRow := VspPreview.TableCell [tcRows, 0,0,0,0];
  IdxCol := VspPreview.TableCell [tcCols, 0,0,0,0];
  VspPreview.TableCell [tcBackColor, IdxRow, 0, IdxRow, IdxCol] := clLtGray;
  VspPreview.EndTable;
  VspPreview.StartTable;

  ObjDoc.Clear;
end;   // of TFrmDetAcomptesEtAvoirs.PrintSubTotal

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  ObjAcompte       : TObjDocAcompte;   // all info of acompte for 1 operator
  ObjAvoir         : TObjDocAvoir;     // all info of avoir for 1 operator
begin  // of TFrmDetAcomptesEtAvoirs.PrintTableBody
  // Print a normal rapport generate by data of the 'POSTransaction'-table
  ObjAcompte := TObjDocAcompte.Create;
  ObjAvoir := TObjDocAvoir.Create;
  try
    if DmdFpnUtils.QueryInfo (BuildStatement) then begin
      VspPreview.StartTable;
      NumCurrentOper :=
          DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
      while not DmdFpnUtils.QryInfo.Eof do begin
        // Print all Acomptes for the current operator.
        while (NumCurrentOper =
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
            (DmdFpnUtils.QryInfo.FieldByName ('Type').AsInteger = 0) and
            (not DmdFpnUtils.QryInfo.Eof) do begin
          VspPreview.AddTable
              (FmtTableBody, '', ObjAcompte.BuildLine (DmdFpnUtils.QryInfo),
               clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end;
        ObjDocAcompte.Add (ObjAcompte);
        PrintSubTotal (NumCurrentOper, ObjAcompte);
        // Print all Avoirs for the current operator.
        while (NumCurrentOper =
           DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
           (DmdFpnUtils.QryInfo.FieldByName ('Type').AsInteger = 1 ) and
           (not DmdFpnUtils.QryInfo.Eof) do begin
          VspPreview.AddTable
              (FmtTableBody, '', ObjAvoir.BuildLine (DmdFpnUtils.QryInfo),
               clWhite, clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end;
        ObjDocAvoir.Add (ObjAvoir);
        PrintSubTotal (NumCurrentOper, ObjAvoir);
        NumCurrentOper :=
           DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
      end;
      VspPreview.EndTable;
    end;
  finally
    ObjAcompte.Free;
    ObjAvoir.Free;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetAcomptesEtAvoirs.PrintTableBody

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.PrintTableFooter;
var
  TxtLine          : string;           // Line to print
begin  // of TFrmDetAcomptesEtAvoirs.PrintTableFooter
  VspPreview.StartTable;
  TxtLine :=
      CtTxtTotAcompte + TxtSep + IntToStr (ObjDocAcompte.QtyDocument) + TxtSep +
      TxtSep + TxtSep + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAcompte.ValAmountRec) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAcompte.ValAmountReturn) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAcompte.ValExtraAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAcompte.ValCanAmount) + TxtSep +       //R2014.1.Enhancement-51.CAFR.TCS-CP
      FormatFloat (CtTxtFrmNumber, ObjDocAcompte.ValExpAmount);                 //R2014.1.Enhancement-51.CAFR.TCS-CP
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite,
                       clWhite, False);

  TxtLine :=
      CtTxtTotAvoir + TxtSep + IntToStr (ObjDocAvoir.QtyDocument) + TxtSep +
      TxtSep + TxtSep + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAvoir.ValAmountRec) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAvoir.ValAmountReturn) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAvoir.ValExtraAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAvoir.ValCanAmount) + TxtSep +
      FormatFloat (CtTxtFrmNumber, ObjDocAvoir.ValExpAmount);                   //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite,
                       clWhite, False);

  VspPreview.EndTable;
end;   // of TFrmDetAcomptesEtAvoirs.PrintTableFooter

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.Execute;
begin  // of TFrmDetAcomptesEtAvoirs.Execute
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
     (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate), PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    Application.MessageBox(PChar(CtTxtStartFuture), PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayTo is not in the future
  else if (DtmPckDayTo.Date > Now) or (DtmPckLoadedTo.Date > Now) then begin
    DtmPckDayto.Date := Now;
    DtmPckLoadedto.Date := Now;
    Application.MessageBox(PChar(CtTxtEndFuture), PChar(CtTxtErrorHeader), MB_OK);
  end
  else begin
    ObjDocAcompte := TObjDocAcompte.Create;
    ObjDocAvoir := TObjDocAvoir.Create;
    ObjDocGlobalAcompte := TObjDocGlobalAcompte.Create;
    ObjDocGlobal := TObjDocument.Create;
    try
      // Quick solution to change de Orientation of the rapport
      VspPreview.Orientation := orLandscape;
      VspPreview.StartDoc;
      PrintTableBody;
      PrintTableFooter;
      VspPreview.EndDoc;
      PrintPageNumbers;
      PrintReferences;
      if FlgPreview then
        FrmVSPreview.Show
      else
        VspPreview.PrintDoc (False, 1, VspPreview.PageCount);
    finally
      ObjDocAcompte.Free;
      ObjDocAvoir.Free;
      ObjDocGlobalAcompte.Free;
      ObjDocGlobal.Free;
      ObjDocAcompte := nil;
      ObjDocAvoir := nil;
      ObjDocGlobalAcompte := nil;
      ObjDocGlobal := nil;
    end;
  end;
end;   // of TFrmDetAcomptesEtAvoirs.Execute

//=============================================================================

procedure TFrmDetAcomptesEtAvoirs.RbtDateDayClick(Sender: TObject);
begin
  inherited;
  ChkLbxOperator.Enabled := RbtDateDay.Checked or RbtDateLoaded.Checked;
  BtnSelectAll.Enabled := RbtDateDay.Checked or RbtDateLoaded.Checked;
  BtnDeSelectAll.Enabled := RbtDateDay.Checked or RbtDateLoaded.Checked;
end;

//=============================================================================
//R2013.2.ID36060.Translation.BDES.TCS-SRM.start
procedure TFrmDetAcomptesEtAvoirs.FormCreate(Sender: TObject);
begin
  inherited;
  Application.Title := CtTxtFrmTitle;
  self.Caption := CtTxtFrmTitle;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
  if FlgExport then
    BtnExport.Visible := True;
  //R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End
end;
//R2013.2.ID36060.Translation.BDES.TCS-SRM.end
//=============================================================================

//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.Start
procedure TFrmDetAcomptesEtAvoirs.BtnExportClick(Sender: TObject);
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

begin // of TFrmDetAcomptesEtAvoirs.BtnExportClick
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;
  //set focus to other fields than on datefields
  QryHlp := TQuery.Create(self);
  try
    QryHlp.DatabaseName := 'DBFlexPoint';
    QryHlp.Active := False;
    QryHlp.SQL.Clear;
    QryHlp.SQL.Add('select * from ApplicParam' +
                   ' where IdtApplicParam = ' + QuotedStr('PathExcelStore'));
    QryHlp.Active := True;
    if QryHlp.RecordCount > 0 then
      TxtPath := QryHlp.FieldByName('TxtParam').AsString
    else
      TxtPath := CtTxtPlace;
  finally
    QryHlp.Active := False;
    QryHlp.Free;
  end;
  ChkLbxOperator.SetFocus;
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
        if DmdFpnUtils.QueryInfo(BuildStatement) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            if (DmdFpnUtils.QryInfo.FieldByName('CodAction').AsInteger = CtCodActCredCoupCreate)
                and (DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger <> 97) then begin
              TxtWriteLine :=
                DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsVariant + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString + ';' +
                CtTxtAvoir + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsString + ';';
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end   //end of if
            else if (DmdFpnUtils.QryInfo.FieldByName('CodAction').AsInteger = CtCodActCredCoupAccept)
                     and (DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger <> 97) then begin
              TxtWriteLine :=
                DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsVariant + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString + ';' +
                CtTxtAvoir + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString + ';' +
                '' + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsString + ';';
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end   //end of else if
            else if (DmdFpnUtils.QryInfo.FieldByName('CodAction').AsInteger = CtCodActCredCoupAccept)
                    and (DmdFpnUtils.QryInfo.FieldByName('CodTrans').AsInteger = 97) then begin
              TxtWriteLine :=
                CtTxtOperatorExp + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('NumPLU').AsString + ';' +
                CtTxtAvoir + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +
                '' + ';' + '' + ';' + '' + ';' + '' + ';' + '' + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsString + ';';
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end   //end of 2nd else if
            else begin
              TxtWriteLine :=
                DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsVariant + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('NbDoc').AsString + ';' +
                CtTxtAcompte + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsString + ';' +
                DmdFpnUtils.QryInfo.FieldByName ('IdtPosTransaction').AsString;

              case DmdFpnUtils.QryInfo.FieldByName ('CodAction').AsInteger of
                CtCodActPayAdvance : begin
                  if DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsFloat <
                     -CtValMinFloat then
                    TxtWriteLine := TxtWriteLine + '' + ';' + '' + ';' + '';
                  end;
                CtCodActChangeAdvance   : TxtWriteLine := TxtWriteLine + '' + ';' + '';
                CtCodActTakeBackAdvance : TxtWriteLine := TxtWriteLine + '';
                CtCodActTakeBackForfait : TxtWriteLine := TxtWriteLine + '';
              end;  //end of case

              TxtWriteLine := TxtWriteLine +
                              FormatFloat (CtTxtFrmNumber,
                                      DmdFpnUtils.QryInfo.FieldByName ('ValInclVAT').AsFloat) + ';';
              WriteLn(F, TxtWriteLine);
              DmdFpnUtils.QryInfo.Next;
            end;    // end of else
          end;   //end of while loop
        end
        else begin
          TxtWriteLine := '';
          WriteLn(F, TxtWriteLine);
        end;  // end of else part of if loop
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end;
//R2014.1.Req(31120).CAFR.Automatic_Recovery_Credit_Notes.TCS-Teesta.End

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetAcomptesEtAvoirs
