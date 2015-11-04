//=Copyright 2004-2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : Castorama Development
// Unit   : FRptCash : Form Report Cash
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCash.pas,v 1.1 2006/12/18 11:33:07 JurgenBT Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FRptCash - CVS revision 1.17
//=============================================================================

unit FRptCash;

//*****************************************************************************

interface


//*****************************************************************************
// Global definitions
//*****************************************************************************

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE;

resourcestring               // of header
  CtTxtTitle                 = 'Payout drawers';
  CtTxtPrintDate             = 'Printed on %s at %s';

resourcestring               // of table header
  CtTxtHdrOper               = 'Operator No';
  CtTxtHdrOperName           = 'Operator name';
  CtTxtHdrCheckout           = 'Checkout No';
  CtTxtHdrAmount             = 'Amount';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TObjOperator = class
  protected
    FIdtOperator        : string;
    FTxtOperatorName    : string;
    FValCash            : Currency;
    FIdtCheckout        : Integer;
  public
    property IdtOperator : string read FIdtOperator write FIdtOperator;
    property TxtOperatorName : string read FTxtOperatorName write FTxtOperatorName;
    property ValCash : Currency read FValCash write FValCash;
    property IdtCheckout : Integer read FIdtCheckout write FIdtCheckout;
  end;

  TObjLastCount = class
  protected
    FIdtOperator        : string;
    FDatLastCount       : TDateTime;
  public
    property IdtOperator : string read FIdtOperator write FIdtOperator;
    property DatLastCount : TDateTime read FDatLastCount write FDatLastCount;
  end;

  TFrmRptCash = class(TFrmDetGeneralCA)
    procedure FormCreate(Sender: TObject);
  protected
    FValTndMaxCash : Currency;         // Maximum value for drawer
    FTxtMessage    : string;           // Message to send as netsend

    function GetValTndMaxCash : Currency;
    function GetTxtMessage :  string;

    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;           
    function GetTxtTableTitle : string; override;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport :  string; override;
  public
    ArrOperator : array of TObjOperator;
    ArrLastCount: array of TObjLastCount;

    procedure Execute; override;
    procedure AutoStart (Sender : TObject); override;
    procedure CreateAdditionalModules; override;
    procedure SendTxtMessage; virtual;

    //properties
    procedure PrintHeader; override;
    procedure PrintTableBody; override;

    property ValTndMaxCash : Currency read GetValTndMaxCash;
    property TxtMessage    : string read GetTxtMessage;
  end;

var
  FrmRptCash: TFrmRptCash;

//*****************************************************************************

implementation

{$R *.DFM}
uses
  SfDialog,
  SmUtils,

  DFpn,
  DFpnUtils,
  DFpnSafeTransaction,
  DFpnSafeTransactionCA,
  DFpnTenderGroup,
  DFpnTenderGroupCA,
  DFpnOperatorCA,
  DFpnApplicParam,
  DFpnOperator,
  DFpnTender,
  DFpnTenderCA,
  DFpnWorkstatCA,
  DFpnTradeMatrix;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptCash';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCash.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/18 11:33:07 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TFrmRptCash
//*****************************************************************************

procedure TFrmRptCash.AutoStart(Sender: TObject);
begin // of TFrmRptCash.AutoStart
  FTxtMessage := '';
  if Application.Terminated then
    Exit;

  inherited;
  if not ViFlgAutom then
    BtnSelectAllClick (Sender);
end;  // of TFrmRptCash.AutoStart

//=============================================================================

procedure TFrmRptCash.CreateAdditionalModules;
begin // of TFrmRptCash.CreateAdditionalModules
  inherited;
  DmdFpn := TDmdFpn.Create (Self);
  DmdFpnUtils := TDmdFpnUtils.Create (Self);
  DmdFpnOperatorCA := TDmdFpnOperatorCA.Create (Self);
  DmdFpnApplicParam := TDmdFpnApplicParam.Create (Self);
  DmdFpnSafeTransactionCA := TDmdFpnSafeTransactionCA.Create (Self);
  DmdFpnTenderGroupCA := TDmdFpnTenderGroupCA.Create (Self);
  DmdFpnTenderCA := TDmdFpnTenderCA.Create (Self);
  DmdFpnTradematrix := TDmdFpnTradeMatrix.Create (Self);
end;  // of TFrmRptCash.CreateAdditionalModules

//=============================================================================

procedure TFrmRptCash.Execute;
var
  IdtSafetransaction    : Integer;     // SafeTransaction number
  IdtOperator           : string;      //  Operator number
  QtyTotal              : Integer;     // Total amount for an operator
  ValTotal              : Currency;    // Total currency for an operator
  NumLength             : Integer;     // Length of operator array
  NumCount              : Integer;
begin // of TFrmRptCash.Execute
  ArrOperator := nil;
  ArrLastCount := nil;
  SetLength(ArrLastCount, 0);
  // Disable the ability to print
  FrmVSPreview.AllowPrintActions := false;
  FrmVSPreview.AllowPrintSetupActions := false;
  FrmVSPreview.ActPrintCustom.enabled := False;

  LstTenderGroup := TLstTenderGroup.Create;
  LstTenderClass := TLstTenderClass.Create;
  DmdFpnTenderGroupCA.BuildListTenderGroup (LsttenderGroup);
  DmdFpnTenderGroupCA.BuildListTenderClass (LstTenderClass);

  DmdFpnUtils.CloseInfo;
  try
    if DmdFpnUtils.QueryInfo ('SELECT Operator.IdtOperator,'#10#13 +
                              'min(PosTrans.DatTransBegin) as dattransbegin'#10#13 +
                              'FROM Operator (NOLOCK)'#10#13 +
                              ' LEFT JOIN PosTransaction PosTrans (NOLOCK) ON'#10#13 +
                              '   Operator.IdtPos = PosTrans.IdtOperator'#10#13 +
                              '   AND PosTrans.DatTransBegin >'#10#13 +
                              '      (SELECT CASE WHEN ISNULL (MAX (DatReg),0) <= DATEADD(dd,-5, GETDATE())'#10#13 +
                              '             then DATEADD(dd,-5, GETDATE()) else ISNULL (MAX (DatReg),0) end'#10#13 +
                              '       FROM safetransaction'#10#13 +
                              '       WHERE idtoperator = Operator.IdtOperator'#10#13 +
                              '       AND CodType =  931)'#10#13 +
                              'WHERE PosTrans.IdtOperator <> '''' '#10#13 +
                              'GROUP BY Operator.IdtOperator'#10#13) then begin
      DmdFpnUtils.QryInfo.open;
      while not DmdFpnUtils.QryInfo.Eof do begin
        NumLength := Length (ArrLastCount);
        SetLength (ArrLastCount, NumLength + 1);
        ArrLastCount [NumLength] := TObjLastCount.Create;
        ArrLastCount [NumLength].IdtOperator :=
          DmdFpnUtils.QryInfo.FieldByName ('IdtOperator').AsString;
        ArrLastCount [NumLength].DatLastCount :=
          DmdFpnUtils.QryInfo.FieldByName ('dattransbegin').AsDateTime;
        DmdFpnUtils.QryInfo.Next;
      end; // while
    end; // if dmdfpnutils
  finally
    DmdFpnUtils.CloseInfo;
  end;

  PgsBarExec.Max := Length (ArrLastCount);
  ProgressBarPosition := 0;
  Application.ProcessMessages;
  try
    for numCount := 0 to Length(ArrLastCount)-1 do begin
    //while not DmdFpnOperatorCA.SprLstOperator.EOF do begin
      ValTotal := 0.0;
      //IdtOperator := DmdFpnOperator.SprLstOperator.FieldByName ('IdtOperator').AsString;
      IdtOperator := ArrLastCount[numCount].IdtOperator;
      IdtSafeTransaction := DmdFpnSafeTransactionCA.RetrieveRunningSafeTransOperator (IdtOperator);
      LstSafetransaction := TLstSafetransactionCA.Create;
      try
        if IdtSafeTransaction > 0 then
          DmdFpnSafeTransactionCA.BuildListSafeTransactionAndDetail (LstSafeTransaction, IdtSafeTransaction);
          LstSafeTransaction.TotalTransDetailTheoreticForCount
                              (IdtSafetransaction, 1, True, QtyTotal, ValTotal);
        if ArrLastCount[numCount].DatLastCount <> 0 then begin
          DmdFpnUtils.CloseInfo;
          try
            if DmdFpnUtils.QueryInfo
                  ('SELECT -sum (CASE PosDetail.CodAction'#10#13 +
                   '            WHEN 66 THEN -PosDetail.ValInclVAT'#10#13 +
                   '            ELSE PosDetail.ValInclVAT'#10#13 +
                   '            END) AS Waarde'#10#13 +
                   'FROM PosTransaction PosTrans (nolock), PosTransDetail PosDetail (nolock)'#10#13 +
                   'WHERE PosTrans.DatTransBegin >= ' +
                     AnsiQuotedStr(FormatDateTime
                       ('yyyy-mm-dd hh:mm:ss', ArrLastCount[numCount].DatLastCount), '''') + #10#13 +
                   '  AND PosTrans.IdtOperator = ' + IntToStr(StrToInt(IdtOperator)) + #10#13 +
                   '  AND POSTrans.IdtPosTransaction > 0'#10#13 +
                   '  AND POSTrans.IdtPosTransaction = POSDetail.IdtPosTransaction'#10#13 +
                   '  AND POSTrans.IdtCheckOut = POSDetail.IdtCheckOut'#10#13 +
                   '  AND POSTrans.CodTrans = POSDetail.CodTrans'#10#13 +
                   '  AND POSTrans.DatTransBegin = POSDetail.DatTransBegin'#10#13 +
                   '  AND POSTrans.FlgTraining = 0'#10#13 +
                   '  AND POSTrans.CodState = 4'#10#13 +
                   '  AND POSTrans.CodReturn IS NULL'#10#13 +
                   '  AND POSDetail.IdtClassification = ''80.980.8000'''#10#13) then begin
              ValTotal := ValTotal + DmdFpnUtils.QryInfo.fieldByName ('Waarde').AsCurrency;
            end;
          finally
            DmdFpnUtils.CloseInfo;
          end;
        end;
        if ValTotal > ValTndMaxCash then begin
          if ViFlgAutom then begin
            SendTxtMessage;
            Break;
          end
          else begin
            NumLength := Length (ArrOperator);
            SetLength (ArrOperator, NumLength + 1);
            ArrOperator [NumLength] := TObjOperator.Create;
            ArrOperator [NumLength].IdtOperator := IdtOperator;
            ArrOperator [NumLength].ValCash := ValTotal;
            DmdFpnUtils.CloseInfo;
            try
              if DmdFpnUtils.QueryInfo ('SELECT IdtCheckout, TxtName FROM Operator WHERE IdtPos = ' + IdtOperator ) then begin
              ArrOperator[NumLength].IdtCheckout := DmdFpnUtils.QryInfo.FieldByName ('IdtCheckout').AsInteger;
                ArrOperator [NumLength].TxtOperatorName := DmdFpnUtils.QryInfo.FieldByName ('TxtName').AsString;
              end;
            finally
              DmdFpnUtils.CloseInfo;
            end;
          end;

        end;
      finally
        LstSafeTransaction.Free;
        LstSafeTransaction := nil;
      end;
      //DmdFpnOperatorCA.SprLstOperator.Next;
      ProgressBarPosition := ProgressBarPosition + 1;
      Application.ProcessMessages;
      if FlgInterrupted then
        Break;
    end;
  finally
    //DmdFpnOperatorCA.SprLstOperator.Active := False;
    LstTenderGroup.Free;
    LstTenderGroup := nil;
    LstTenderClass.Free;
    LstTenderClass := nil;
  end;
  if not ViFlgAutom and not FlgInterrupted then begin
    FlgPreview := True;
    inherited;
  end;
end;  // of TFrmRptCash.Execute

//=============================================================================

function TFrmRptCash.GetFmtTableBody: string;
begin  // of TFrmRptCash.GetFmtTableBody
  Result := '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmRptCash.GetFmtTableBody

//=============================================================================

function TFrmRptCash.GetFmtTableHeader: string;
begin  // of TFrmRptCash.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmRptCash.GetFmtTableHeader

//=============================================================================

function TFrmRptCash.GetTxtMessage: string;
begin  // of TFrmRptCash.GetTxtMessage
  if FTxtMessage = '' then
    FTxtMessage := DmdFpnApplicParam.InfoApplicParam ['TxtRptCashMessage',
                                                      'TxtParam'];
  Result := FTxtMessage;
end;   // of TFrmRptCash.GetTxtMessage

//=============================================================================

function TFrmRptCash.GetTxtRefRapport: string;
begin  // of TFrmRptCash.GetTxtRefRapport
  Result := 'REP0037';
end;   // of TFrmRptCash.GetTxtRefRapport

//=============================================================================

function TFrmRptCash.GetTxtTableTitle: string;
begin  // of TFrmRptCash.GetTxtTableTitle
  Result := CtTxtHdrOper + TxtSep +
            CtTxtHdrOperName + TxtSep +
            CtTxtHdrCheckout + TxtSep +
            CtTxtHdrAmount;

end;   // of TFrmRptCash.GetTxtTableTitle

//=============================================================================

function TFrmRptCash.GetTxtTitRapport: string;
begin  // of TFrmRptCash.GetTxtTitRapport
  Result := CtTxtTitle;
end;   // of TFrmRptCash.GetTxtTitRapport

//=============================================================================

function TFrmRptCash.GetValTndMaxCash: Currency;
begin  // of TFrmRptCash.GetValTndMaxCash
  if FValTndMaxCash = 0.0 then
    FValTndMaxCash := DmdFpnApplicParam.InfoApplicParam ['TndMaxCashValue',
                                                         'ValParam'];
  Result := FValTndMaxCash;
end;   // of TFrmRptCash.GetValTndMaxCash

//=============================================================================

procedure TFrmRptCash.PrintHeader;
var
  TxtHdr           : string;           // Text stream for the header
begin  // of TFrmRptCash.PrintHeader
  inherited;
  TxtHdr := TxtTitRapport + CRLF + CRLF;
  TxtHdr := TxtHdr + DmdFpnUtils.TradeMatrixName +
            CRLF + CRLF;

  TxtHdr := TxtHdr + DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'] + CRLF + CRLF;

  TxtHdr := TxtHdr + Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]) + CRLF;

  VspPreview.Header := TxtHdr;
  FrmVSPreview.DrawLogo (Logo);
end;   // of TFrmRptCash.PrintHeader

//=============================================================================

procedure TFrmRptCash.PrintTableBody;
var
  NumCounter       : Integer;          // Operator counter
  TxtLine          : string;           // Line to print
  IdtCheckout      : string;           // Checkout number
begin  // of TFrmRptCash.PrintTableBody;
  for NumCounter := 0 to Length (ArrOperator) - 1 do begin
    IdtCheckout := '';
    if ArrOperator[NumCounter].IdtCheckout <> 0 then
      IdtCheckout := IntToStr (ArrOperator[NumCounter].IdtCheckout);
    TxtLine := ArrOperator[NumCounter].IdtOperator +
                TxtSep +
                ArrOperator[NumCounter].TxtOperatorName +
                TxtSep +
                IdtCheckout +
                TxtSep +
                FormatFloat (CtTxtFrmNumber,
                             ArrOperator[NumCounter].ValCash);
    VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                         clWhite, False);
  end;
end;   // of TFrmRptCash.PrintTableBody;

//=============================================================================

procedure TFrmRptCash.SendTxtMessage ;
var
  TxtCompName      : string;           // ComputerName
  TxtCommand       : string;           // Command to execute
  TxtLMessage      : string;           // Local message
begin  // of TFrmRptCash.SendTxtMessage
  TxtLMessage := TxtMessage;
  DmdFpnUtils.CloseInfo;
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)' +
                              ' WHERE CodType >= '+IntToStr (CtCodWorkStatPC) +
                              ' AND CodType <= ' + IntToStr (CtCodWorkStatMasterPC)) then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do
      begin
        TxtCompName := DmdFpnUtils.QryInfo.FieldByName ('IdtWorkstat').AsString;
        if trim (TxtCompName) <> '' then begin
          TxtCommand := 'NET SEND ' + TxtCompName + ' ' + TxtLMessage + #0;
          WinExec (@TxtCommand[1], SW_HIDE);
        end;
        DmdFpnUtils.QryInfo.Next;
      end;
    end;
  finally
    DmdFpnUtils.CloseInfo;
  end;
end;   // of TFrmRptCash.SendTxtMessage

//=============================================================================

procedure TFrmRptCash.FormCreate(Sender: TObject);
begin  // of TFrmRptCash.FormCreate
  inherited;
  Caption := Application.Title;
end;  // of TFrmRptCash.FormCreate

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate, CtTxtSrcTag);
end.
