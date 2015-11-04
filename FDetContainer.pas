//=Copyright 2004-2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : Form specific for printing Castorama report for container
// Unit   : FDetContainer.PAS : General Detailform to print CAstorama report for
//                              container
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetContainer.pas,v 1.1 2006/12/18 13:11:54 JurgenBT Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FDetContainer - CVS revision 1.13
// Version    Modified by    Reason
// 1.14		    TK  (TCS)		 R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques
//=============================================================================

unit FDetContainer;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, OvcBase, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE, OvcEF, OvcPB,
  OvcPF, ScUtils, Db, DBTables;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring //Global Report
  CtTxtTitle          = 'Check Container Bags';
  CtTxtPrintDate      = 'Printed on %s at %s';
  CtTxtSelCriteria    = 'Selected criteria: ';
  CtTxtDateCriteria   = 'from %s to %s';
  CtTxtNoContainer    = '<no container>';

resourcestring //Table titels
  CtTxtTtlContainer   = 'Container Bag';
  CtTxtTtlBag         = 'Sealed Bag';
  CtTxtContainer      = 'Number';
  CtTxtContDate       = 'Creation date';
  CtTxtContOper       = 'Operator ';
  CtTxtContAmount     = 'Amount ';
  CtTxtSealedBag      = 'Number';
  CtTxtBagDate        = 'Creation date';
  CtTxtBagAmount      = 'Amount';
  CtTxtBagCodType     = 'Type ';
  CtTxtBagTender      = 'Content';
  CtTxtBagOper        = 'Operator';
  CtTxtBagAuth        = 'Supervisor';
  CtTxtNumCheq        = 'Number of Cheques';                                    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

resourcestring        // of errormessages
  CtTxtStartEndDate   = 'Startdate is after enddate!';
  CtTxtStartFuture    = 'Startdate is in the future!';
  CtTxtEndFuture      = 'Enddate is in the future!';
  CtTxtEmptyContainer = 'Please fill in a container nr!';
  CtTxtEmptyBag       = 'Please fill in a bag nr!';

const
  CtNumWContainer    = 14;
  CtNumWContDate     = 12;
  CtNumWContOper     = 10;
  CtNumWContAmount   = 10;
  CtNumWSealedBag    = 14;
  CtNumWBagDate      = 12;
  CtNumWBagAmount    = 10;
  CtNumWBagCodType   = 10;
  CtNumWBagTender    = 16;
  CtNumWBagOper      = 10;
  CtNumWBagAuth      = 10;
  CtNumWCheques      = 10;                                                      //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmDetContainer = class(TFrmDetGeneralCA)
    RdbSelectDate: TRadioButton;
    RdbSelectContainer: TRadioButton;
    RdbSelectBag: TRadioButton;
    LblStartDate: TLabel;
    LblEndDate: TLabel;
    LblContainer: TLabel;
    LblBag: TLabel;
    SvcLFContainer: TSvcLocalField;
    SvcLFBag: TSvcLocalField;
    QryContainer: TQuery;
    QryBag: TQuery;
    OvcController1: TOvcController;
    procedure SvcLFContainerEnter(Sender: TObject);
    procedure SvcLFBagEnter(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure DtmPckDayFromEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ActStartExecExecute(Sender: TObject);
  protected
    IdtContainer     : string;           // Container
    DatContainer     : string;           // Container Date
    IdtOperator      : string;           // Operator

    procedure AutoStart (Sender : TObject); override;

    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;
    function GetTxtTableTitle : string; override;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport :  string; override;
    function CheckCriteria : boolean; virtual;

    procedure OpenContainerQuery; virtual;
    procedure OpenBagQuery (TxtContainer : string); virtual;
  public
    procedure PrintHeader; override;
    procedure PrintTableBody; override;
    procedure CreateAdditionalModules; override;
    procedure PrintTableHeader; override;
  end;

var
  FrmDetContainer: TFrmDetContainer;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,

  DFpn,
  DFpnTradematrix,
  DFpnTenderCA,
  DFpnTenderGroup,
  DFpnTenderGroupCA,
  DFpnSafeTransaction,
  DFpnUtils,
  RFpnTender,
  DFpnBagCA;                                                                    //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = '';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetContainer.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.14 $';
  CtTxtSrcDate    = '$Date: 2014/01/29 13:11:54 $';


//*****************************************************************************
// Implementation of TFrmDetContainer
//*****************************************************************************

procedure TFrmDetContainer.DtmPckDayFromEnter(Sender: TObject);
begin
  inherited;
  RdbSelectDate.Checked := True;
end;

//=============================================================================

procedure TFrmDetContainer.SvcLFContainerEnter(Sender: TObject);
begin  // of TFrmDetContainer.SvcLFContainerEnter
  inherited;
  RdbSelectContainer.checked := True;
end;   // of TFrmDetContainer.SvcLFContainerEnter

//=============================================================================

procedure TFrmDetContainer.SvcLFBagEnter(Sender: TObject);
begin  // of TFrmDetGeneralCA1.SvcLFBagEnter
  inherited;
  RdbSelectBag.Checked := True;
end;   // of TFrmDetGeneralCA1.SvcLFBagEnter

//=============================================================================

procedure TFrmDetContainer.AutoStart(Sender: TObject);
begin  // of TFrmDetContainer.AutoStart
  inherited;
  BtnSelectAll.Click;
  DtmPckDayFrom.DateTime := Now;
  DtmPckDayTo.DateTime := Now;
end;   // of TFrmDetContainer.AutoStart

//=============================================================================

procedure TFrmDetContainer.CreateAdditionalModules;
begin  // of TFrmDetContainer.CreateAdditionalModules
  inherited;
  DmdFpn := TDmdFpn.Create (Self);
  DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Self);
  DmdFpnUtils := TDmdFpnUtils.Create (Self);
  DmdFpnTenderGroupCA := TDmdFpnTenderGroupCA.Create (Self);
  DmdFpnTenderCA := TDmdFpnTenderCA.Create (Self);
end;   // of TFrmDetContainer.CreateAdditionalModules

//=============================================================================

function TFrmDetContainer.GetFmtTableBody: string;
begin  // of TFrmDetContainer.GetFmtTableBody
  Result := '>' + IntToStr (CalcWidthText (CtNumWContainer, False));  // Container
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWContDate, False));  // Date
  Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (CtNumWContOper, False));  // Operator
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (CtNumWContAmount, False));  // Amount
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (CtNumWSealedBag, False));  // Bag
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (CtNumWCheques,False)); // Number of cheques //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagDate, False));  // Date
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (CtNumWBagAmount, False));  // Amount
  Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (CtNumWBagCodType, False));  // CodType
  Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (CtNumWBagTender, False));  // Tender
  Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (CtNumWBagOper, False));  // Operator
end;   // of TFrmDetContainer.GetFmtTableBody

//=============================================================================

function TFrmDetContainer.GetFmtTableHeader: string;
begin  // of TFrmDetContainer.GetFmtTableHeader
  Result := '<' + IntToStr (CalcWidthText (CtNumWContainer, False));  // Container
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWContDate, False));  // Date
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWContOper, False));  // Operator
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWContAmount, False));  // Amount
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWSealedBag, False));  // Bag
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWCheques,False));     // Number of cheques //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagDate, False));  // Date
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagAmount, False));  // Amount
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagCodType, False));  // CodType
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagTender, False));  // Tender
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (CtNumWBagOper, False));  // Operator
end;   // of TFrmDetContainer.GetFmtTableHeader

//=============================================================================

function TFrmDetContainer.GetTxtRefRapport: string;
begin  // of TFrmDetContainer.GetTxtRefRapport
  Result := inherited GetTxtRefRapport + '0036';
end;   // of TFrmDetContainer.GetTxtRefRapport

//=============================================================================

function TFrmDetContainer.GetTxtTableTitle: string;
begin  // of TFrmDetContainer.GetTxtTableTitle
  Result :=  CtTxtContainer +
             TxtSep +
             CtTxtContDate +
             TxtSep +
             CtTxtContOper +
             TxtSep +
             CtTxtContAmount +
             TxtSep +
             CtTxtSealedBag +
             TxtSep +
             CtTxtNumCheq +                                                     //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
             TxtSep +
             CtTxtBagDate +
             TxtSep +
             CtTxtBagAmount +
             TxtSep +
             CtTxtBagCodType +
             TxtSep +
             CtTxtBagTender +
             TxtSep +
             CtTxtBagOper;
end;   // of TFrmDetContainer.GetTxtTableTitle

//=============================================================================

function TFrmDetContainer.GetTxtTitRapport: string;
begin  // of TFrmDetContainer.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmDetContainer.GetTxtTitRapport

//=============================================================================

function TFrmDetContainer.CheckCriteria: boolean;
begin  // of TFrmDetContainer.CheckDates
  result := true;
  // Check if the selected dates are valid
  if RdbSelectDate.Checked then begin
    // Check is DayFrom < DayTo
    if (DtmPckDayFrom.Date > DtmPckDayTo.Date) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtStartEndDate, mtWarning, [mbOK], 0);
      result := false;
    end
    // Check if DayFrom is in the future
    else if (DtmPckDayFrom.Date > Now) then begin
      DtmPckDayFrom.Date := Now;
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtStartFuture, mtWarning, [mbOK], 0);
      result := false;
    end
    // Check if DayTo is in the future
    else if (DtmPckDayTo.Date > Now) then begin
      DtmPckDayTo.Date := Now;
      MessageDlg (CtTxtEndFuture, mtWarning, [mbOK], 0);
      result := false;
    end;
  end
  // Check if a container nr is filled in
  else if RdbSelectContainer.Checked then begin
    if SvcLFContainer.Text = '' then begin
      MessageDlg (CtTxtEmptyContainer, mtWarning, [mbOK], 0);
      result := false;
    end
  end
  // Check if a bag nr is filled in
  else if RdbSelectBag.Checked then begin
    if SvcLFBag.Text = '' then begin
      MessageDlg (CtTxtEmptyBag, mtWarning, [mbOK], 0);
      result := false;
    end;
  end;
end;   // of TFrmDetContainer.CheckDates

//=============================================================================

procedure TFrmDetContainer.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmDetContainer.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF;

  TxtHdr := TxtHdr + CtTxtSelCriteria;
  if RdbSelectDate.Checked then
    TxtHdr := TxtHdr + Format (CtTxtDateCriteria,
              [FormatDateTime (CtTxtDatFormat, DtmPckDayFrom.DateTime),
              FormatDateTime (CtTxtDatFormat, DtmPckDayTo.DateTime)])
  else if RdbSelectBag.Checked then
    TxtHdr := TxtHdr + LblBag.Caption + ' ' + SvcLFBag.Text
  else if RdbSelectContainer.Checked then
    TxtHdr := TxtHdr + LblContainer.Caption + ' ' + SvcLFContainer.Text;
  TxtHdr := TxtHdr + CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmDetContainer.PrintHeader

//=============================================================================

procedure TFrmDetContainer.PrintTableBody;
var
  TxtLine          : string;           // Line to print
  ValAmount        : Currency;         // Total amount
  TxtValAmount     : string;           // Amount in text value
  TxtTenderGroup   : string;           // Tendergroup name
  ObjTenderGroup   : TObjTenderGroup;  // Tendergroup
  TxtExplanation   : string;           // Explanation
  TxtBagOperator   : string;           // Bag operator
  NumPos           : Integer;          // Number used for Positions operatorions
  i: integer;
  txtCopy: string;
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
  QtyTotalCheq     : Integer;          // Total number of cheques per bag
  ValTotalCheq     : Currency;         // Total amount for cheques per bag
  //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
begin  // of TFrmDetContainer.PrintTableBody
  try
    LstTenderGroup := TLstTenderGroup.Create;
    DmdFpnTenderGroupCA.BuildListTenderGroup (LstTenderGroup);
    OpenContainerQuery;
    PgsBarExec.Max := QryContainer.RecordCount;
    if RdbSelectDate.Checked then
      PgsBarExec.Max := PgsBarExec.Max + 1;
    ProgressBarPosition := 0;
    Application.ProcessMessages;
    while not QryContainer.EOF do begin
      TxtTenderGroup := '';
      IdtContainer := QryContainer.FieldByName ('IdtContainer').AsString;
      DatContainer := DateToStr (QryContainer.FieldByName ('DatContainer').AsDateTime);
      IdtOperator := QryContainer.FieldByName ('IdtOperator').AsString;
      OpenBagQuery (IdtContainer);
      ValAmount := 0.0;
      while not QryBag.Eof do begin
        ValAmount := ValAmount + QryBag.FieldByName ('ValAmount').AsCurrency;
        QryBag.Next;
      end;
      TxtValAmount := FormatFloat (CtTxtFrmNumber,ValAmount);
      QryBag.First;
      if not QryBag.EOF then begin
        ObjTenderGroup :=
          LstTenderGroup.FindIdtTenderGroup (QryBag.FieldByName ('IdtTenderGroup').AsInteger);
        if Assigned (ObjTenderGroup) then
          TxtTenderGroup := ObjTenderGroup.TxtPublDescr;
      end;
      while not QryBag.Eof do begin
      //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
        if TxtTenderGroup = CtTxtBankCheques then
        begin
          TxtLine := IdtContainer +
                     TxtSep +
                     DatContainer +
                     TxtSep +
                     IdtOperator +
                     TxtSep +
                     TxtValAmount +
                     TxtSep +
                     QryBag.FieldByName ('IdtPochette').AsString +
                     TxtSep +
                     IntToStr(QryBag.FieldByName ('QtyCheques').AsInteger) +
                     TxtSep +
                     DateToStr (QryBag.FieldByName ('DatReg').AsDateTime) +
                     TxtSep +
                     FormatFloat (CtTxtFrmNumber,
                                  QryBag.FieldByName ('ValAmount').AsCurrency);
        end
        else
          TxtLine := IdtContainer +
                     TxtSep +
                     DatContainer +
                     TxtSep +
                     IdtOperator +
                     TxtSep +
                     TxtValAmount +
                     TxtSep +
                     QryBag.FieldByName ('IdtPochette').AsString +
                     TxtSep +
                     '' +
                     TxtSep +
                     DateToStr (QryBag.FieldByName ('DatReg').AsDateTime) +
                     TxtSep +
                     FormatFloat (CtTxtFrmNumber,
                                  QryBag.FieldByName ('ValAmount').AsCurrency);
        //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
        TxtExplanation := '';
        if DmdFpnUtils.QueryInfo ('SELECT TxtExplanation ' +
                                   '  FROM SafeTransaction ' +
                                   ' WHERE IdtSafeTransaction = ' + QryBag.FieldByName ('IdtSafeTransaction').AsString +
                                   '   AND NumSeq = ' + QryBag.FieldByName ('NumSeq').AsString) then
          TxtExplanation := DmdFpnUtils.QryInfo.FieldByName ('TxtExplanation').AsString;
        DmdFpnUtils.CloseInfo;
        if QryBag.FieldByName ('FlgAccountancy').AsInteger = 1 then begin
          TxtLine := TxtLine + TxtSep + 'C';
        end
        else begin
          if AnsiPos ('CodType=921',TxtExplanation) > 0  then
            TxtLine := TxtLine + TxtSep + CtTxtPayOut
          else
            TxtLine := TxtLine + TxtSep + CtTxtFinalCount;
        end;
        TxtLine := TxtLine +
                   TxtSep +
                   TxtTenderGroup;
        TxtBagOperator := '';
        NumPos := AnsiPos ('Operator=', TxtExplanation);
        if NumPos > 0  then begin
          TxtBagOperator := Copy (txtExplanation,NumPos + 9,3);
          TxtBagOperator := '000' + TxtBagOperator;
          TxtCopy := '';
          for i := 1 to length (txtbagoperator) do begin
            if (Ord (TxtBagOperator[I]) > 47) and (Ord (TxtBagOperator[I]) < 58) then begin
              TxtCopy := TxtCopy + TxtBagOperator[I]
            end;
          end;
          TxtBagOperator := Copy (TxtCopy, Length (TxtCopy )-2, 3)
        end;
        TxtLine := TxtLine +
                   TxtSep +
                   TxtBagOperator;
        VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                             clWhite, False);
        IdtContainer := '';
        DatContainer := '';
        IdtOperator := '';
        TxtValAmount := '';
        QryBag.Next;
      end;
      QryContainer.Next;
      ProgressBarPosition := ProgressBarPosition + 1;
      Application.ProcessMessages;
      if FlgInterrupted then
        Break;
    end;
    if RdbSelectDate.Checked or RdbSelectBag.Checked then begin
      IdtContainer := CtTxtNoContainer;
      OpenBagQuery (IdtContainer);
      ValAmount := 0.0;
      while not QryBag.Eof do begin
        ValAmount := ValAmount + QryBag.FieldByName ('ValAmount').AsCurrency;
        QryBag.Next;
      end;
      TxtValAmount := FormatFloat (CtTxtFrmNumber,ValAmount);
      QryBag.First;
      while not QryBag.Eof do begin
        ObjTenderGroup :=
          LstTenderGroup.FindIdtTenderGroup (QryBag.FieldByName ('IdtTenderGroup').AsInteger);
        if Assigned (ObjTenderGroup) then
          TxtTenderGroup := ObjTenderGroup.TxtPublDescr;
        //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.Start
        if TxtTenderGroup = CtTxtBankCheques then
          TxtLine := IdtContainer +
                     TxtSep +
                     DatContainer +
                     TxtSep +
                     IdtOperator +
                     TxtSep +
                     TxtValAmount +
                     TxtSep +
                     QryBag.FieldByName ('IdtPochette').AsString +
                     TxtSep +
                     IntToStr(QryBag.FieldByName ('QtyCheques').AsInteger) +
                     TxtSep +
                     DateToStr (QryBag.FieldByName ('DatReg').AsDateTime) +
                     TxtSep +
                     FormatFloat (CtTxtFrmNumber,
                                  QryBag.FieldByName ('ValAmount').AsCurrency)
        else
          TxtLine := IdtContainer +
                     TxtSep +
                     DatContainer +
                     TxtSep +
                     IdtOperator +
                     TxtSep +
                     TxtValAmount +
                     TxtSep +
                     QryBag.FieldByName ('IdtPochette').AsString +
                     TxtSep +
                     '' +
                     TxtSep +
                     DateToStr (QryBag.FieldByName ('DatReg').AsDateTime) +
                     TxtSep +
                     FormatFloat (CtTxtFrmNumber,
                                  QryBag.FieldByName ('ValAmount').AsCurrency);
        //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK.End
        TxtExplanation := '';
        if DmdFpnUtils.QueryInfo ('SELECT TxtExplanation ' +
                                   '  FROM SafeTransaction ' +
                                   ' WHERE IdtSafeTransaction = ' + QryBag.FieldByName ('IdtSafeTransaction').AsString +
                                   '   AND NumSeq = ' + QryBag.FieldByName ('NumSeq').AsString) then
          TxtExplanation := DmdFpnUtils.QryInfo.FieldByName ('TxtExplanation').AsString;
        DmdFpnUtils.CloseInfo;
        if QryBag.FieldByName ('FlgAccountancy').AsInteger = 1 then begin
          TxtLine := TxtLine + TxtSep + 'C';
        end
        else begin
          if AnsiPos ('CodType=921',TxtExplanation) > 0  then
            TxtLine := TxtLine + TxtSep + CtTxtPayOut
          else
            TxtLine := TxtLine + TxtSep + CtTxtFinalCount;
        end;
        TxtLine := TxtLine +
                   TxtSep +
                   TxtTenderGroup;
        TxtBagOperator := '';
        NumPos := AnsiPos ('Operator=', TxtExplanation);
        if NumPos > 0  then begin
          TxtBagOperator := Copy (txtExplanation,NumPos + 9,3);
          TxtBagOperator := '000' + TxtBagOperator;
          TxtCopy := '';
          for i := 1 to length (txtbagoperator) do begin
            if (Ord (TxtBagOperator[I]) > 47) and (Ord (TxtBagOperator[I]) < 58) then begin
              TxtCopy := TxtCopy + TxtBagOperator[I]
            end;
          end;
          TxtBagOperator := Copy (TxtCopy, Length (TxtCopy )-2, 3)
        end;
        TxtLine := TxtLine +
                   TxtSep +
                   TxtBagOperator;
        VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                            clWhite, False);
        IdtContainer := '';
        DatContainer := '';
        IdtOperator := '';
        TxtValAmount := '';
        QryBag.Next;
      end;
      ProgressBarPosition := ProgressBarPosition + 1;
      Application.ProcessMessages;
    end;
    finally
    QryContainer.Active := False;
    LstTenderGroup.Free;
    LstTenderGroup := nil;
  end;
end;   // of TFrmDetContainer.PrintTableBody

//=============================================================================

procedure TFrmDetContainer.OpenContainerQuery;
begin  // of TFrmDetContainer.OpenContainerQuery
  QryContainer.Active := False;
  QryContainer.SQL.Text  := 'SELECT IdtContainer,'#13#10 +
                            '       DatContainer,'#13#10 +
                            '       IdtOperator'#13#10 +
                            '  FROM Container'#13#10;
  if RdbSelectBag.Checked then
    QryContainer.SQL.Text := QryContainer.SQL.Text +
                             ' WHERE IdtContainer IN (SELECT IdtContainer '#13#10 +
                             '                          FROM Pochette '#13#10 +
                             '                         WHERE IdtPochette LIKE ''%' + SvcLFBag.AsString + '%'')';

  if RdbSelectDate.Checked then
    QryContainer.SQL.Text := QryContainer.SQL.Text +
                             ' WHERE DatContainer BETWEEN ''' +
                             FormatDateTime (ViTxtDBDatFormat, DtmPckDayFrom.Date)
                             + ' 00:00:00' + ''' AND ''' +
                             FormatDateTime (ViTxtDBDatFormat, DtmPckDayTo.Date)
                             + ' 23:59:59' + '''';

  if RdbSelectContainer.Checked then
    QryContainer.SQL.Text := QryContainer.SQL.Text +
                             ' WHERE IdtContainer LIKE ''%' + SvcLfContainer.AsString + '%'''#13#10;
  QryContainer.Active := True;
end;   // of TFrmDetContainer.OpenContainerQuery

//=============================================================================

procedure TFrmDetContainer.OpenBagQuery (TxtContainer : string);
begin  // of TFrmDetContainer.OpenBagQuery
  QryBag.Active := False;
  QryBag.SQL.Text :=
        'SELECT S.IdtSafeTransaction,'#13#10 +
        '       S.NumSeq,'#13#10 +
        '       P.IdtPochette, '#13#10 +
        '       P.FlgTransfer AS FlgPochTransfer, '#13#10 +
        '       P.FlgAccountancy, '#13#10 +
        '       Sum (D.QtyUnit) QtyCheques, '#13#10 +                           //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
        '       SUM (D.ValUnit * D.QtyUnit) ValAmount, '#13#10 +
        '       S.IdtOperator, '#13#10 +
        '       S.DatReg, '#13#10 +
        '       S.CodType AS CodType, '#13#10 +
        '       D.IdtTenderGroup '#13#10 +
        '  FROM (SELECT MAX (T.IdtSafeTransaction) IdtSafeTrans, IdtPochette '#13#10 +
        '          FROM Pochette '#13#10 +
        '               JOIN SafeTransaction T '#13#10 +
        '                 ON T.IdtSafeTransaction = Pochette.IdtSafeTransaction '#13#10 +
        '                    AND T.IdtCheckout = 300 '#13#10;
    if (TxtContainer = CtTxtNoContainer) then
      QryBag.SQL.Text := QryBag.SQL.Text +
        '                    AND IdtContainer IS NULL'#13#10
    else
      QryBag.SQL.Text := QryBag.SQL.Text +
        '                    AND IdtContainer = ''' + TxtContainer + ''''#13#10;
    if (TxtContainer = CtTxtNoContainer) and RdbSelectDate.Checked then
      QryBag.SQL.Text := QryBag.SQL.Text +
        '                    AND T.DatReg BETWEEN ''' + FormatDateTime (
                             ViTxtDBDatFormat, DtmPckDayFrom.Date) +
                             ' 00:00:00' + ''' AND ''' + FormatDateTime (
                             ViTxtDBDatFormat, DtmPckDayTo.Date)
                             + ' 23:59:59' + '''';
    if (TxtContainer = CtTxtNoContainer) and RdbSelectBag.Checked then
      QryBag.SQL.Text := QryBag.SQL.Text +
        '          WHERE Pochette.IdtPochette LIKE ' + AnsiQuotedStr('%' +
                   SvcLFBag.AsString + '%', '''') + #13#10;
    QryBag.SQL.Text := QryBag.SQL.Text +
        '         GROUP BY IdtPochette) MaxSafetrans '#13#10 +
        '       JOIN Pochette P '#13#10 +
        '         ON P.IdtPochette = MaxSafeTrans.IdtPochette '#13#10 +
        '            AND P.IdtSafeTransaction = MaxSafeTrans.IdtSafeTrans '#13#10;
    if (TxtContainer = CtTxtNoContainer) then
      QryBag.SQL.Text := QryBag.SQL.Text +
                  '            AND P.FlgTransfer = 0 '#13#10;
    QryBag.SQL.Text := QryBag.SQL.Text +
        '       JOIN SafeTransDetail D '#13#10 +
        '         ON D.IdtSafeTransaction = MaxSafeTrans.IdtSafeTrans '#13#10 +
        '            AND D.NumSeq = P.NumSeq '#13#10 +
        '            AND D.IdtTenderGroup = P.IdtTenderGroup '#13#10 +
        '       JOIN SafeTransaction S '#13#10 +
        '         ON S.IdtSafeTransaction = MaxSafeTrans.IdtSafeTrans '#13#10 +
        '            AND S.NumSeq = D.NumSeq '#13#10 +
        '            AND S.IdtCheckout = 300 '#13#10 +
        'GROUP BY S.IdtSafeTransaction,S.NumSeq,P.IdtPochette, P.FlgTransfer, '+
        '         P.FlgAccountancy, S.IdtOperator, S.CodType, S.DatReg, ' +
        '         D.IdtTenderGroup '#13#10 +
        'ORDER BY P.IdtPochette ';
  QryBag.Active := True;
end;   // of TFrmDetContainer.OpenBagQuery

//=============================================================================

procedure TFrmDetContainer.PrintTableHeader;
var
  TxtFmtHeader     : string;
  TxtTitle         : string;
begin  // of TFrmDetContainer.PrintTableHeader
  TxtFmtHeader := '<' + IntToStr (CalcWidthText (CtNumWContainer + CtNumWContDate + CtNumWContOper + CtNumWContAmount , False)) +
                  TxtSep + '<' + IntToStr (CalcWidthText (CtNumWSealedBag + CtNumWCheques + CtNumWBagDate + CtNumWBagAmount + CtNumWBagCodType + CtNumWBagTender + CtNumWBagOper, False));      //R2014.1.Req41040.CAFR.Remove-Entry-Number-Envelope-for-cheques.TCS-TK
  TxtTitle := CtTxtTtlContainer +
             TxtSep +
             CtTxtTtlBag;
  VspPreview.AddTable (TxtFmtHeader, '',TxtTitle,
                       clWhite, clLTGray, False);
//  if QryContainer.Active then begin
//    IdtContainer := QryContainer.FieldByName ('IdtContainer').AsString;
//    DatContainer := DateToStr (QryContainer.FieldByName ('DatContainer').AsDateTime);
//    IdtOperator := QryContainer.FieldByName ('IdtOperator').AsString;
//  end;
  inherited;
end;   // of TFrmDetContainer.PrintTableHeader

//=============================================================================

procedure TFrmDetContainer.BtnPrintClick(Sender: TObject);
begin
  if CheckCriteria then
    inherited;
end;

//=============================================================================

procedure TFrmDetContainer.FormActivate(Sender: TObject);
begin
  inherited;
  if RdbSelectContainer.Checked then
    SvcLFContainer.SetFocus
  else if RdbSelectBag.Checked then
    SvcLFBag.SetFocus
  else
    DtmPckDayFrom.SetFocus;
end;

//=============================================================================

procedure TFrmDetContainer.ActStartExecExecute(Sender: TObject);
begin
  if CheckCriteria then
    inherited;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.  // of FDetContainer


