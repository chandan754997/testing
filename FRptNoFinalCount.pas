//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : Castorama Development
// Unit     : FRptNoFinalCount : Form Report operators sold without doing a
//                               final count
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptNoFinalCount.pas,v 1.7 2010/04/12 13:17:40 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FRptCash - CVS revision 1.17
// Version      ModifiedBy        Reason
// 1.1         TCS-TK            R2012.1 Applix 2388401 BDES Defect_id: 241 (FROZEN BUGS 2011.2)
// 1.2         Teesta (TCS)      R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta
//=============================================================================

unit FRptNoFinalCount;

//*****************************************************************************

interface

//*****************************************************************************
// Global definitions                                                     
//*****************************************************************************

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FDetGeneralCA, Menus, ImgList, ActnList, ExtCtrls, ScAppRun,
  ScEHdler, StdCtrls, Buttons, CheckLst, ComCtrls, ScDBUtil_BDE,
  SmVSPrinter7Lib_TLB;

resourcestring               // of header
  CtTxtTitle                 = 'Count Status';
  CtTxtPrintDate             = 'Printed on %s at %s';
  CtTxtTitleCAFR             = 'List Count Status';                             //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta : Addition
  CtTxtCAFR                  = '/VLIST=LIST Report title for CAFR';             //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta : Addition

resourcestring               // of table header
  CtTxtHdrOper               = 'Operator No';
  CtTxtHdrOperName           = 'Operator name';
  CtTxtHdrCheckout           = 'Date last final count';
  CtTxtHdrAmount             = 'Date last sale';

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

  TFrmNoFinalCount = class(TFrmDetGeneralCA)
    procedure BtnPrintClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.Start : Addition
  private
    { Private declarations }
    FFlgTitle      : boolean;
  //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.End : Addition

  protected
    FValTndMaxCash : Currency;         // Maximum value for drawer
    FTxtMessage    : string;           // Message to send as netsend

    function GetFmtTableHeader : string; override;
    function GetFmtTableBody : string; override;           
    function GetTxtTableTitle : string; override;

    function GetTxtTitRapport : string; override;
    function GetTxtRefRapport :  string; override;

    //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.Start : Addition
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.End : Addition
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
    property FlgTitle: boolean read FFlgTitle write FFlgTitle;                  //R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta : Addition

  end;

var
  FrmNoFinalCount: TFrmNoFinalCount;

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
  DFpnTradeMatrix, SfAutoRun;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptNoFinalCount';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptNoFinalCount.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2013/01/16 13:17:40 $';
  CtTxtSrcTag     = '$Name:  $';

//*****************************************************************************
// Implementation of TFrmNoFinalCount
//*****************************************************************************

procedure TFrmNoFinalCount.AutoStart(Sender: TObject);
begin // of TFrmNoFinalCount.AutoStart
  FTxtMessage := '';
  if Application.Terminated then
    Exit;
  inherited;
  if not ViFlgAutom then
    BtnSelectAllClick (Sender);
  // BtnPrintClick(Sender);
end;  // of TFrmNoFinalCount.AutoStart

//=============================================================================

procedure TFrmNoFinalCount.CreateAdditionalModules;
begin // of TFrmNoFinalCount.CreateAdditionalModules
  inherited;
  DmdFpn := TDmdFpn.Create (Self);
  DmdFpnUtils := TDmdFpnUtils.Create (Self);
  DmdFpnOperatorCA := TDmdFpnOperatorCA.Create (Self);
  DmdFpnApplicParam := TDmdFpnApplicParam.Create (Self);
  DmdFpnTradematrix := TDmdFpnTradeMatrix.Create (Self);
end;  // of TFrmNoFinalCount.CreateAdditionalModules

//=============================================================================

procedure TFrmNoFinalCount.Execute;
begin // of TFrmNoFinalCount.Execute
  ArrOperator := nil;
  ArrLastCount := nil;
  SetLength(ArrLastCount, 0);
  // Disable the ability to print
  FrmVSPreview.AllowPrintActions := True;
  FrmVSPreview.AllowPrintSetupActions := True;
  FrmVSPreview.ActPrintCustom.enabled := True;
  PgsBarExec.Max := Length (ArrLastCount);
  ProgressBarPosition := 0;
  Application.ProcessMessages;
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
end;  // of TFrmNoFinalCount.Execute

//=============================================================================

function TFrmNoFinalCount.GetFmtTableBody: string;
begin  // of TFrmNoFinalCount.GetFmtTableBody
  Result := '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '<' + IntToStr (CalcWidthText (25, False));
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmNoFinalCount.GetFmtTableBody

//=============================================================================

function TFrmNoFinalCount.GetFmtTableHeader: string;
begin  // of TFrmNoFinalCount.GetFmtTableHeader
  Result := '^+' + IntToStr (CalcWidthText (10, False));
  Result := Result + TxtSep + '^' + IntToStr (CalcWidthText (25, False)); //R2012.1 Applix 2388401 BDES Defect_id: 241 (FROZEN BUGS 2011.2) TCS-TK
  Result := Result + TxtSep + '^+' + IntToStr (CalcWidthText (20, False));
  Result := Result + TxtSep + '>' + IntToStr (CalcWidthText (20, False));
end;   // of TFrmNoFinalCount.GetFmtTableHeader

//=============================================================================

function TFrmNoFinalCount.GetTxtRefRapport: string;
begin  // of TFrmNoFinalCount.GetTxtRefRapport
  Result := 'REP0040';
end;   // of TFrmNoFinalCount.GetTxtRefRapport

//=============================================================================

function TFrmNoFinalCount.GetTxtTableTitle: string;
begin  // of TFrmNoFinalCount.GetTxtTableTitle
  Result := CtTxtHdrOper + TxtSep +
            CtTxtHdrOperName + TxtSep +
            CtTxtHdrCheckout + TxtSep +
            CtTxtHdrAmount;
end;   // of TFrmNoFinalCount.GetTxtTableTitle

//=============================================================================

function TFrmNoFinalCount.GetTxtTitRapport: string;
begin  // of TFrmNoFinalCount.GetTxtTitRapport
//R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.Start : Addition
  if FlgTitle then
    Result := CtTxtTitleCAFR
  else
//R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.End : Addition
    Result := CtTxtTitle;
end;   // of TFrmNoFinalCount.GetTxtTitRapport

//=============================================================================

procedure TFrmNoFinalCount.PrintHeader;
begin  // of TFrmNoFinalCount.PrintHeader
  VspPreview.FontBold := True;
  VspPreview.CalcParagraph := 'X';
  VspPreview.CurrentY := 500;
  VspPreview.Text := TxtTitRapport;
  VspPreview.FontBold := False;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * VspPreview.TextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CalcParagraph := 'X';
  VspPreview.Text := DmdFpnUtils.TradeMatrixName;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * VspPreview.TextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CalcParagraph := 'X';
  VspPreview.Text := DmdFpnTradeMatrix.InfoTradeMatrix [
      DmdFpnUtils.IdtTradeMatrixAssort, 'TxtMunicip'];
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * VspPreview.TextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := Format (CtTxtPrintDate,
            [FormatDateTime (CtTxtDatFormat, Now),
            FormatDateTime (CtTxtHouFormat, Now)]);
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * VspPreview.TextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
end;   // of TFrmNoFinalCount.PrintHeader

//=============================================================================

procedure TFrmNoFinalCount.PrintTableBody;
var
  TxtLine          : string;           // Line to print
begin  // of TFrmNoFinalCount.PrintTableBody;
    DmdFpnOperatorCA.SprLstLastCount.Active := True;
    DmdFpnOperatorCA.SprLstLastCount.First;
    while (not DmdFpnOperatorCA.SprLstLastCount.EOF) do begin
      TxtLine := DmdFpnOperatorCA.SprLstLastCount.FieldByName('IdtOperator').
                 AsString + TxtSep + DmdFpnOperatorCA.SprLstLastCount.
                 FieldByName('NameOperator').AsString + TxtSep +
                 DmdFpnOperatorCA.SprLstLastCount.FieldByName('DatLastCount').
                 AsString + TxtSep + DmdFpnOperatorCA.SprLstLastCount.
                 FieldByName('DatLastSale').AsString;
    if ((Length(DmdFpnOperatorCA.SprLstLastCount.FieldByName('DatLastCount').
         AsString) > 0) or (Length(DmdFpnOperatorCA.SprLstLastCount.
         FieldByName('DatLastSale').AsString) > 0)) and
         (DmdFpnOperatorCA.SprLstLastCount.FieldByName('DatLastSale').Value >
         DmdFpnOperatorCA.SprLstLastCount.FieldByName('DatLastCount').Value) then
      VspPreview.AddTable (FmtTableBody, '', TxtLine, clWhite,
                         clWhite, False);
    DmdFpnOperatorCA.SprLstLastCount.Next;
  end;
end;   // of TFrmNoFinalCount.PrintTableBody;

//=============================================================================

procedure TFrmNoFinalCount.SendTxtMessage ;
var
  TxtCompName      : string;           // ComputerName
  TxtCommand       : string;           // Command to execute
  TxtLMessage      : string;           // Local message
begin  // of TFrmNoFinalCount.SendTxtMessage
  DmdFpnUtils.CloseInfo;
  try
    if DmdFpnUtils.QueryInfo ('SELECT IdtWorkStat FROM WORKSTAT (NOLOCK)' +
                              ' WHERE CodType >= '+IntToStr (CtCodWorkStatPC) +
                              ' AND CodType <= ' + IntToStr (CtCodWorkStatMasterPC))
    then begin
      DmdFpnUtils.QryInfo.First;
      while not DmdFpnUtils.QryInfo.Eof do begin
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
end;   // of TFrmNoFinalCount.SendTxtMessage

//=============================================================================

procedure TFrmNoFinalCount.FormCreate(Sender: TObject);
begin  // of TFrmNoFinalCount.FormCreate
  inherited;
  Caption := Application.Title;
end;  // of TFrmNoFinalCount.FormCreate

//=============================================================================

procedure TFrmNoFinalCount.BtnPrintClick(Sender: TObject);
begin // of TFrmNoFinalCount.BtnPrintClick
  inherited;
  Caption := Application.Title;
end; // of TFrmNoFinalCount.BtnPrintClick

//=============================================================================

//R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.Start : Addition
procedure TFrmNoFinalCount.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin  // of TFrmNoFinalCount.BeforeCheckRunParams
  inherited;
  // add param /VLIST to help
  SplitString(CtTxtCAFR, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;   // of TFrmNoFinalCount.BeforeCheckRunParams

//=============================================================================

procedure TFrmNoFinalCount.CheckAppDependParams(TxtParam: string);
begin  // of TFrmNoFinalCount.CheckAppDependParams
  if Copy(TxtParam,3,4)= 'LIST' then
    FlgTitle := True
  else
    inherited;
end; // of TFrmNoFinalCount.CheckAppDependParams
//R2013.1.ID21040.Operatorwithoutcashcount.CAFR.TCS-Teesta.End : Addition

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate, CtTxtSrcTag);
end.
