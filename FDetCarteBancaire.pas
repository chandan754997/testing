//======Copyright 2009 (c) Centric Retail Solutions. All rights reserved.======
// Packet   : Form specific for printing Castorama Rapports
// Unit     : FDetGeneralCA.PAS : General Detailform to print CAstorama rapports
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCarteBancaire.pas,v 1.7 2010/06/28 06:53:03 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetGeneralCA.PAS - CVS revision 1.5
// Version ModifiedBy Reason
// 1.8     PRG. (TCS) R2011.1 - CAFR - Castorama Card
// 1.9     SMB (TCS)  R2013.2.ALM Defect Fix 164.All OPCO
//=============================================================================

unit FDetCarteBancaire;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,DB, ExtDlgs,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE,DBTables, 
  SmVSPrinter7Lib_TLB;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring               // of header
  CtTxtTitle                 = 'Report of bank cards';
  CtTxtPrintDate             = 'Printed on %s at %s';
  CtTxtReportDate            = 'Report from %s to %s';

resourcestring               // of table header
  CtTxtCaissiere             = 'Operator Nr';
  CtTxtNbCashDesk            = 'Nr of Cash register';
  CtTxtDate                  = 'Date';
  CtTxtNbTicket              = 'Ticket Nr';
  CtTxtCartType              = 'Card Type';
  CtTxtAmountCart            = 'Amount Card';
  CtTxtNbCarte               = 'Card Number';
  CtTxtSubTotCaissiere       = 'S/Total operator';
  CtTxtGlobalTotCaissiere    = 'Global operator';
  CtTxtGlobalTotGlobal       = 'Global Total';

resourcestring          // of date errors
  CtTxtStartEndDate          = 'Startdate is after enddate!';
  CtTxtStartFuture           = 'Startdate is in the future!';
  CtTxtEndFuture             = 'Enddate is in the future!';
  CtTxtErrorHeader           = 'Incorrect Date';

resourcestring // for runtime parameters
  CtTxtRunParamIT            = 'IT=Executed in Italian shop';
  CtTxtBRES              = '/VEXP=VEXP export to excel for Spain';

resourcestring // of export to excel parameters
  CtTxtPlace             = 'D:\sycron\transfertbo\excel';
  CtTxtExists            = 'File exists, Overwrite?';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

//=============================================================================
//
//  The information below is sended by Castorama and explains how to dectect
//  a card type carte castorama normal, carte castorama personnel and
//  carte castorama entreprise
//  - carte castorama normal dont le code bin commence par :    504526014xxxxxxxxxx
//  - carte castorama personnel dont le code bin commence par : 504526015xxxxxxxxxx
//  - carte castorama entreprise dont le code bin commence par :504526016xxxxxxxxxx
//
//=============================================================================

type
  TObjPayType = class
    TxtPayType     : string;           // Name of the pay type
    QtyPayType     : Integer;          // Quantity of this type
    ValPayType     : Double;           // Value of the pay type
  public
    procedure Add (TxtType : string; Value : Double; QtyValue : Integer);
  end;   // of TObjPayType

type
  TFrmDetCarteBancaire = class(TFrmDetGeneralCA)
    BtnExport: TSpeedButton;
    SavDlgExport: TSaveTextFileDialog;
    procedure FormCreate(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
  private
    { Private declarations }
    FlgItaly: Boolean; // Executed in Italian shop
    FFlgSpanje: boolean; // Executed in Spain
  protected
    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;
    function GetFmtTableSubTotal : string;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport :  string; override;
    function BuildSQLStatement : string;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    StrLstGlbPay   : TStringList;      // Global list with pay information

    property FmtTableSubTotal : string read GetFmtTableSubTotal;

    procedure PutObjInList (StrLst     : TStringList;
                            ObjPayType : TObjPayType);
    procedure PrintSubTotal (NumOperator   : Integer;
                             StrLstPayType : TStringList); virtual;
    procedure PrintHeader; override;                             
    procedure PrintTableBody; override;
    procedure PrintTableFooter; override;
    property FlgSpanje: boolean read FFlgSpanje write FFlgSpanje;
    procedure Execute; override;
  end;

var
  FrmDetCarteBancaire: TFrmDetCarteBancaire;

implementation

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnUtils,

  DFpnPosTransaction,
  DFpnPosTransactionCA, DFpnTradeMatrix;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCarteBancaire.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.9 $';
  CtTxtSrcDate    = '$Date: 2014/03/06 10:10:13 $';


//*****************************************************************************
// Implementation of TObjPayType
//*****************************************************************************

//=============================================================================

procedure TObjPayType.Add (TxtType  : string;
                           Value    : Double;
                           QtyValue : Integer);

begin  // of TObjPayType.Add
  TxtPayType := TxtType;
  ValPayType := ValPayType + Value;
  QtyPayType := QtyPayType + QtyValue;
end;   // of TObjPayType.Add

//*****************************************************************************
// Implementation of TFrmDetCarteBancaire
//*****************************************************************************

function TFrmDetCarteBancaire.GetFmtTableHeader : string;
begin  // of TFrmDetCarteBancaire.GetFmtTableHeader
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  if not FlgItaly then
    Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmDetCarteBancaire.GetFmtTableHeader

//=============================================================================

function TFrmDetCarteBancaire.GetFmtTableBody : string;
begin  // of TFrmDetCarteBancaire.GetFmtTableBody
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
  if not FlgItaly then
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmDetCarteBancaire.GetFmtTableBody

//=============================================================================

function TFrmDetCarteBancaire.GetTxtTableTitle : string;
begin  // of TFrmDetCarteBancaire.GetTxtTableTitle
  Result := CtTxtCaissiere  + TxtSep +
            CtTxtNbCashDesk + TxtSep +
            CtTxtDate       + TxtSep +
            CtTxtNbTicket   + TxtSep +
            CtTxtCartType   + TxtSep +
            CtTxtAmountCart;
  if not FlgItaly then
    Result := Result + TxtSep + CtTxtNbCarte;
end;   // of TFrmDetCarteBancaire.GetTxtTableTitle

//=============================================================================

function TFrmDetCarteBancaire.GetFmtTableSubTotal : string;
begin  // of TFrmDetCarteBancaire.GetFmtTableSubTotal
  Result := '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20 , False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (15, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText ( 8, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (12, False));
  if not FlgItaly then
    Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmDetCarteBancaire.GetFmtTableSubTotal

//=============================================================================

function TFrmDetCarteBancaire.GetTxtTitRapport : string;
begin  // of TFrmDetCarteBancaire.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetCarteBancaire.GetTxtTitRapport

//=============================================================================

function TFrmDetCarteBancaire.GetTxtRefRapport : string;
begin  // of TFrmDetCarteBancaire.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0010';
end;   // of TFrmDetCarteBancaire.GetTxtRefRapport

//=============================================================================

function TFrmDetCarteBancaire.BuildSQLStatement : string;
begin  // of TFrmDetCarteBancaire.BuildSQLStatement
  Result :=
      #10'SELECT Act.IdtOperator, Act.IdtCheckOut,'+
      #10'       Act.DatTransBegin, Act.IdtPOSTransaction,'+
      #10'       Det.TxtDescr, Det.PrcInclVAT, Det2.TxtDescr as CardNumber'+
      #10'  FROM POSTransaction as Act'+
      #10' INNER JOIN POSTransDetail as Det'+
      #10'    on Det.IdtPOSTransaction = Act.IdtPOSTransaction'+
      #10'   AND Det.IdtCheckOut = Act.IdtCheckOut'+
      #10'   AND Det.CodTrans = Act.CodTrans'+
      #10'   AND Det.DatTransBegin = Act.DatTransBegin'+
      #10'   AND Det.CodAction in (30, 31, 32, 34, 156)' +
      #10' INNER JOIN POSTransDetail as Det2' +
      #10'    on Det.IdtPOSTransaction = Det2.IdtPOSTransaction' +
      #10'   AND Det.IdtCheckOut = Det2.IdtCheckOut' +
      #10'   AND Det.DatTransBegin = Det2.DatTransBegin' +
      #10'   AND Det.NumLineReg = Det2.NumLineReg' +
      #10'   AND Det2.CodType = ' + IntToStr (CtCodPdtInfoEFTNumCard);

  if RbtDateDay.Checked then begin
    Result := Result +
      #10' WHERE Act.DatTransBegin BETWEEN ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           'Act.CodReturn IS NULL ' +
           'AND  Act.FlgTraining = 0';
  end
  else if RbtDateLoaded.Checked then begin
    Result := Result +
      #10' WHERE Act.DatLoaded BETWEEN ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedFrom.Date) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           AnsiQuotedStr (FormatDateTime (ViTxtDBDatFormat, DtmPckLoadedTo.Date + 1) +
                      ' ' + FormatDateTime (ViTxtDBHouFormat, 0), '''') + ' AND ' +
           'Act.CodReturn IS NULL ' +
           'AND  Act.FlgTraining = 0';
  end;
  Result := Result +
      #10'   AND Act.IdtOperator IN (' + TxtLstOperID  + ')' +
      #10' ORDER BY Act.IdtOperator, Act.IdtCheckOut, Act.DatTransBegin';
end;   // of TFrmDetCarteBancaire.BuildSQLStatement

//=============================================================================

procedure TFrmDetCarteBancaire.BeforeCheckRunParams;
var
  TxtPartLeft            : string;
  TxtPartRight           : string;
begin // of TFrmDetCarteBancaire.BeforeCheckRunParams
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  AddRunParams('/VIT', CtTxtRunParamIT);
  // add param /VEXP to help
  SplitString(CtTxtBRES, '=', TxtPartLeft, TxtPartRight);
  AddRunParams(TxtPartLeft, TxtPartRight);
end; // of TFrmDetCarteBancaire.BeforeCheckRunParams

//=============================================================================

procedure TFrmDetCarteBancaire.CheckAppDependParams(TxtParam: string);
begin // of TFrmDetCarteBancaire.CheckAppDependParams
  FlgItaly := False;
  if AnsiCompareText(Copy(TxtParam, 3, 2), 'IT') = 0 then
    FlgItaly := True
  else if Copy(TxtParam, 3, 3) = 'EXP' then
    FlgSpanje := True
end; // of TFrmDetCarteBancaire.CheckAppDependParams

//=============================================================================

procedure TFrmDetCarteBancaire.PutObjInList (StrLst     : TStringList;
                                             ObjPayType : TObjPayType);
var
  IdxType          : Integer;          // Index in the list.
begin  // of TFrmDetCarteBancaire.PutObjInList
  if StrLst.Find (ObjPayType.TxtPayType, IdxType) then begin
    TObjPayType (StrLst.Objects [IdxType]).Add (ObjPayType.TxtPayType,
                                                ObjPayType.ValPayType,
                                                ObjPayType.QtyPayType);
    ObjPayType.Free;
  end
  else
    StrLst.AddObject (ObjPayType.TxtPayType, ObjPayType);
end;   // of TFrmDetCarteBancaire.PutObjInList

//=============================================================================

procedure TFrmDetCarteBancaire.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetCarteBancaire.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  if RbtDateDay.Checked then
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
end;   // of TFrmDetCarteBancaire.PrintHeader

//=============================================================================

procedure TFrmDetCarteBancaire.PrintSubTotal (NumOperator   : Integer;
                                              StrLstPayType : TStringList);
var
  CntPayType       : Integer;          // Loop all PayTypes
  TxtLine          : string;           // Line to print
  TxtTemp          : string;           // Temp string of subtotal caissiere X
  ValAmountOperator: Double;           // Total payments for 1 operator
  QtyOperator      : Integer;          // Number of payments
begin  // of TFrmDetCarteBancaire.PrintSubTotal
  VspPreview.EndTable;

  ValAmountOperator:= 0;
  QtyOperator      := 0;

  // to print a subtotal stop the current table en makes a new table to provide
  // another color.
  VspPreview.StartTable;
  TxtTemp := CtTxtSubTotCaissiere + ' ' + IntToStr (NumOperator);
  StrLstGlbPay.Sorted := True;
  for CntPayType := 0 to Pred (StrLstPayType.Count) do begin
    QtyOperator := QtyOperator +
                   TObjPayType (StrLstPayType.Objects[CntPayType]).QtyPayType;
    ValAmountOperator := ValAmountOperator +
                   TObjPayType (StrLstPayType.Objects[CntPayType]).ValPayType;

    TxtLine := TxtTemp + TxtSep + TxtSep + TxtSep + TxtSep +
      StrLstPayType[CntPayType] + TxtSep +
      IntToStr (TObjPayType (StrLstPayType.Objects[CntPayType]).QtyPayType) +
      TxtSep +
      FormatFloat (CtTxtFrmNumber,
                   TObjPayType (StrLstPayType.Objects[CntPayType]).ValPayType);

    VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite,
                         clLtGray, False);
    PutObjInList (StrLstGlbPay, TObjPayType(StrLstPayType.Objects[CntPayType]));
    TxtTemp := '';
  end;
  // print a extra line with the totals.
  TxtLine := TxtTemp + TxtSep + TxtSep + TxtSep + TxtSep + 'Total :' + TxtSep +
             IntToStr (QtyOperator) + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValAmountOperator);
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clLtGray, False);
  VspPreview.EndTable;

  VspPreview.StartTable;
end;   // of TFrmDetCarteBancaire.PrintSubTotal

//=============================================================================

procedure TFrmDetCarteBancaire.PrintTableBody;
var
  NumCurrentOper   : Integer;          // Number of current operator to process
  TxtLine          : string;           // Line to print

  StrLstObj        : TStringList;      // List with ObjPayTypes
  ObjPayType       : TObjPayType;      // Object PayType;
begin  // of TFrmDetCarteBancaire.PrintTableBody
  StrLstObj := TStringList.Create;
  StrLstObj.Sorted := True;

  try
    if DmdFpnUtils.QueryInfo (BuildSQLStatement) then begin
      VspPreview.TableBorder := tbBoxColumns;
      VspPreview.StartTable;
      while not DmdFpnUtils.QryInfo.Eof do begin
        NumCurrentOper :=
          DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger;
        StrLstObj.Clear;
        while (NumCurrentOper =
               DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsInteger) and
              not DmdFpnUtils.QryInfo.Eof do begin
          ObjPayType := TObjPayType.Create;
          ObjPayType.Add
              (DmdFpnUtils.QryInfo.FieldByName ('TxtDescr').AsString,
               DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat, 1);
          PutObjInList (StrLstObj, ObjPayType);

          TxtLine :=
            DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString + TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtCheckOut').AsString + TxtSep +
            FormatDateTime
                ('dd-mm-yyyy hh:mm:ss',
                 DmdFpnUtils.QryInfo.FieldByName ('DatTransBegin').AsDateTime) +
            TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('IdtPOSTransaction').AsString +
            TxtSep +
            DmdFpnUtils.QryInfo.FieldByName ('TxtDescr').AsString +
            TxtSep +
            FormatFloat (CtTxtFrmNumber,
                         DmdFpnUtils.QryInfo.FieldByName ('PrcInclVAT').AsFloat);
          if not FlgItaly then
            TxtLine := TxtLine + TxtSep +
                       DmdFpnUtils.QryInfo.FieldByName ('CardNumber').AsString;
          VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                               clWhite, False);
          DmdFpnUtils.QryInfo.Next;
        end;
        PrintSubTotal (NumCurrentOper, StrLstObj);
      end;
      VspPreview.EndTable;
    end;
  finally
    StrLstObj.Free;
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmDetCarteBancaire.PrintTableBody

//=============================================================================

procedure TFrmDetCarteBancaire.PrintTableFooter;
var
  CntPayType       : Integer;          // Loop all PayTypes
  ValTotal         : Double;           // Amount of all paytypes and operators
  QtyTotal         : Integer;          // Total of payments
  TxtLine          : string;           // Line to print
  TxtTemp          : string;           // Temp string of subtotal caissiere X
begin  // of TFrmDetCarteBancaire.PrintTableFooter
  ValTotal := 0;
  QtyTotal := 0;
  VspPreview.Text := CRLF;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  TxtTemp := CtTxtGlobalTotCaissiere;
  for CntPayType := 0 to Pred (StrLstGlbPay.Count) do begin
    TxtLine := TxtTemp + TxtSep + TxtSep + TxtSep + TxtSep +
      StrLstGlbPay[CntPayType] + TxtSep +
      IntToStr (TObjPayType (StrLstGlbPay.Objects[CntPayType]).QtyPayType) +
      TxtSep +
      FormatFloat (CtTxtFrmNumber,
                   TObjPayType (StrLstGlbPay.Objects[CntPayType]).ValPayType);

    VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite,
                         clWhite, False);
    ValTotal := ValTotal +
                TObjPayType (StrLstGlbPay.Objects[CntPayType]).ValPayType;
    QtyTotal := QtyTotal +
                TObjPayType (StrLstGlbPay.Objects[CntPayType]).QtyPayType;
    TxtTemp := '';
  end;
  VspPreview.EndTable;

  VspPreview.Text := CRLF;
  VspPreview.TableBorder := tbBoxColumns;
  VspPreview.StartTable;
  TxtLine := CtTxtGlobalTotGlobal + TxtSep + TxtSep + TxtSep + TxtSep + TxtSep +
             IntToStr (QtyTotal) + TxtSep +
             FormatFloat (CtTxtFrmNumber, ValTotal);
  VspPreview.AddTable (FmtTableSubTotal, '', TxtLine, clWhite, clWhite, False);
  VspPreview.EndTable;
end;   // of TFrmDetCarteBancaire.PrintTableFooter

//=============================================================================

procedure TFrmDetCarteBancaire.Execute;
var
  CntStrLst        : Integer;          // Looping all items in global stringlist
begin  // of TFrmDetCarteBancaire.Execute
  StrLstGlbPay := TStringList.Create;
  try
    inherited;
  finally
    for CntStrLst := 0 to Pred (StrLstGlbPay.Count) do
      TObjPayType (StrLstGlbPay.Objects [CntStrLst]).Free;
    StrLstGlbPay.Free;
  end;
end;   // of TFrmDetCarteBancaire.Execute

//=============================================================================

procedure TFrmDetCarteBancaire.BtnPrintClick(Sender: TObject);
begin
  // Check is DayFrom < DayTo
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
       inherited;
  end;
end;

//=============================================================================

procedure TFrmDetCarteBancaire.BtnExportClick(Sender: TObject);
var
  TxtTitles              : string;
  TxtWriteLine           : string;
  counter                : integer;
  F                      : System.Text;
  ChrDecimalSep          : char;
  Btnselect              : integer;
  FlgOK                  : Boolean;
  TxtPath                : String;
  QryHlp                 : TQuery;
begin // of TFrmDetCarteBancaire.BtnExportClick
  if not ItemsSelected then begin
    MessageDlg (CtTxtNoSelection, mtWarning, [mbOK], 0);
    Exit;
  end;

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
  if (DtmPckDayFrom.Date > DtmPckDayTo.Date) or
    (DtmPckLoadedFrom.Date > DtmPckLoadedTo.Date) then begin
    DtmPckDayFrom.Date := Now;
    DtmPckDayTo.Date := Now;
    DtmPckLoadedFrom.Date := Now;
    DtmPckLoadedTo.Date := Now;
    Application.MessageBox(PChar(CtTxtStartEndDate),
      PChar(CtTxtErrorHeader), MB_OK);
  end
  // Check if DayFrom is not in the future
  else if (DtmPckDayFrom.Date > Now) or (DtmPckLoadedFrom.Date > Now) then begin
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
      try
        System.Assign(F, SavDlgExport.FileName);
        Rewrite(F);
        WriteLn(F, TxtWriteLine);
        if DmdFpnUtils.QueryInfo(BuildSQLStatement) then begin
          while not DmdFpnUtils.QryInfo.Eof do begin
            TxtWriteLine :=
              DmdFpnUtils.QryInfo.FieldByName('IdtOperator').AsString + ';' +
              DmdFpnUtils.QryInfo.FieldByName('IdtCheckOut').AsString + ';' +
              FormatDateTime
              ('dd-mm-yyyy hh:mm:ss',
              DmdFpnUtils.QryInfo.FieldByName('DatTransBegin').AsDateTime) +
              ';' +
              DmdFpnUtils.QryInfo.FieldByName('IdtPOSTransaction').AsString +
              ';' +
              DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString +
              ';' +
              FormatFloat(CtTxtFrmNumber,
              DmdFpnUtils.QryInfo.FieldByName('PrcInclVAT').AsFloat);
            if not FlgItaly then
              TxtWriteLine := TxtWriteLine + ';' +
                DmdFpnUtils.QryInfo.FieldByName('CardNumber').AsString;
            WriteLn(F, TxtWriteLine);
            DmdFpnUtils.QryInfo.Next;
          end;
        end;
      finally
        DmdFpnUtils.CloseInfo;
        System.Close(F);
        DecimalSeparator := ChrDecimalSep;
      end;
    end;
  end;
end; // of TFrmDetCarteBancaire.BtnExportClick

//=============================================================================

procedure TFrmDetCarteBancaire.FormCreate(Sender: TObject);
begin // of TFrmDetCarteBancaire.FormCreate
  inherited;
  Panel1.Height := Self.Height - 130;
  if FlgSpanje then
    BtnExport.Visible := True;

end; // of TFrmDetCarteBancaire.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of TFrmDetCarteBancaire
