//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : Development Flexpoint 2.0 CAstorama
// Unit   : fAutoInv.PAS : Form to AUTOmatic generate INVoice
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fAutoInv.pas,v 1.3 2009/09/30 10:07:38 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FAutoInv - CVS revision 1.16
//=============================================================================

unit fAutoInv;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, Db, DBTables, Variants;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtFiscalInfo     = '/VFisc=Print fiscal receipt info on invoice';
  CtTxtRussia         = '/VRu=Functionality for Russia';
  CtTxtNumDays        = '/VNDx=Select data for x number of days';
  
//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmAutoInv = class(TFrmAutoRun)
    StoredProc1: TStoredProc;
    procedure FormCreate(Sender: TObject);
  private
    FFlgFiscal: Boolean;
    FFlgItaly: Boolean;
    FFlgRussia: Boolean;
    FNumDays: integer;
    { Private declarations }
  protected
    IdtPosTransaction: Integer;           // IdtPosTransaction
    IdtCheckout: Integer;                 // IdtCheckOut
    CodTrans: Integer;                    // CodTrans
    DatTransBegin: String  ;              // DatTransBegin
    FlgSeperateCNNumber : boolean;          // Use seperate number or not
    procedure AutoStart (Sender : TObject); override;
    // Select data to check if a creditnote must be made
    function BuildStatement : string; virtual;
    function BuildStatementRussia : string; virtual;
    procedure ReadParams; virtual;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    procedure CreateAdditionalModules; override;
    procedure Execute; override;
    procedure ExecuteRussia; virtual;
  published
    property FlgFiscal: Boolean read FFlgFiscal
                               write FFlgFiscal;
    property FlgItaly: Boolean read FFlgItaly
                               write FFlgItaly;
    property FlgRussia: Boolean read FFlgRussia
                               write FFlgRussia;
    property NumDays: integer read FNumDays
                             write FNumDays;
  end;

var
  FrmAutoInv: TFrmAutoInv;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,

  DFpn,
  DFpnUtils,
  DFpnInvoice,
  DFpnPosTransaction,
  DFpnPosTransactionCA,  
  DFpnWorkStat,
  DMDummy,
  DFpnTradeMatrix,
  DFpnCustomer,
  DFpnAddress,

  SfVSPrinter7,
  IniFiles, 
  FVSRptInvoiceCA,
  SmDBUtil_BDE,
  DFpnInvoiceCA,
  DMDummyCA,
  DFpnCustomerCA,
  DFpnDepartment,
  DFpnWorkStatCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'fAutoInv';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fAutoInv.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/30 10:07:38 $';

//*****************************************************************************
// Implementation of TFrmAutoInv
//*****************************************************************************

procedure TFrmAutoInv.AutoStart (Sender : TObject);
begin  // of TFrmAutoInv.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;   // of TFrmAutoInv.AutoStart

//=============================================================================

procedure TFrmAutoInv.CreateAdditionalModules;
begin  // of TFrmAutoInv.CreateAdditionalModules
  if not Assigned (DmdFpn) then
    DmdFpn := TDmdFpn.Create (Application);
  if not Assigned (DmdFpnUtils) then
    DmdFpnUtils := TDmdFpnUtils.Create (Application);
  if not Assigned (DmdFpnPosTransaction) then
    DmdFpnPosTransaction := TDmdFpnPosTransaction.Create (Application);
  if not Assigned (DmdFpnWorkStat) then
    DmdFpnWorkStat := TDmdFpnWorkStat.Create (Application);
  if not Assigned (DmdMDummy) then
    DmdMDummy := TDmdMDummy.Create (Application);
  if not Assigned (DmdMDummyCA) then
    DmdMDummyCA := TDmdMDummyCA.Create (Application);
  if not Assigned (DmdFpnTradeMatrix) then
    DmdFpnTradeMatrix := TDmdFpnTradeMatrix.Create (Application);
  if not Assigned (DmdFpnCustomer) then
    DmdFpnCustomer := TDmdFpnCustomer.Create (Application);
  if not Assigned (DmdFpnCustomerCA) then
    DmdFpnCustomerCA := TDmdFpnCustomerCA.Create (Application);
  if not Assigned (DmdFpnAddress) then
    DmdFpnAddress := TDmdFpnAddress.Create (Application);
  if not Assigned (DmdFpnInvoice) then
    DmdFpnInvoice := TDmdFpnInvoice.Create (Application);
  if not Assigned (DmdFpnInvoiceCA) then
    DmdFpnInvoiceCA := TDmdFpnInvoiceCA.Create (Application);
end;   // of TFrmAutoInv.CreateAdditionalModules

//=============================================================================

procedure TFrmAutoInv.Execute;
var
  SprRTLstInvoice  : TStoredProc; // Spr get List Delivery notes
  IdtInvoice       : Integer;    // Invoice or creditnote number
  IdtDepartment    : String;
  TxtInvoiceField  : String;
begin  // of TFrmAutoInv.Execute
  if not Assigned (FrmVSRptInvoiceCA) then
    FrmVSRptInvoiceCA := TFrmVSRptInvoiceCA.Create (Self);
  FrmVSRptInvoiceCA.FlgFiscal := FlgFiscal;
  FrmVSRptInvoiceCA.FlgItaly := FlgItaly;
  FrmVSRptInvoiceCA.FlgRussia := FlgRussia;
  SprRTLstInvoice :=
    CopyStoredProc (Self, 'SprRTLstInvoice', DmdFpnInvoiceCA.SprLstInvoice,
                    ['@PrmTxtSearch=IdtPOSTransaction',
                     '@PrmTxtCondition=' +
                     'POSTransInvoice.IdtDelivNote IS NOT NULL ' +
                     'AND POSTransInvoice.IdtInvoice IS NULL']);

  SprRTLstInvoice.Active := True;
  try
    while not SprRTLstInvoice.Eof do begin
      FrmVSRptInvoiceCA.AddIdts
          (SprRTLstInvoice.FieldByName ('IdtPosTransaction').AsInteger,
           SprRTLstInvoice.FieldByName ('IdtCheckout').AsInteger,
           SprRTLstInvoice.FieldByName ('CodTrans').AsInteger,
           SprRTLstInvoice.FieldByName ('DatTransBegin').AsDateTime);
      IdtPosTransaction :=
                    SprRTLstInvoice.FieldByName ('IdtPosTransaction').AsInteger;
      IdtCheckOut := SprRTLstInvoice.FieldByName ('IdtCheckout').AsInteger;
      CodTrans := SprRTLstInvoice.FieldByName ('CodTrans').AsInteger;
      DatTransBegin := FormatDateTime(ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
      SprRTLstInvoice.FieldByName ('DatTransBegin').AsDateTime);
      ReadParams;
      TxtInvoiceField := CtTxtACInvoiceField;
      if DmdFpnDepartment.NumDepartments > 1 then begin
        IdtDepartment := DmdFpnWorkStatCA.InfoCheckout[ IdtCheckOut,
                                                       'IdtDepartment'];
        TxtInvoiceField := CtTxtACInvoiceField + IdtDepartment;
        FrmVSRptInvoiceCA.IdtDepartment := StrToInt(IdtDepartment);
      end
      else
        FrmVSRptInvoiceCA.IdtDepartment := 0;
      DmdFpnUtils.CloseInfo;
      DmdFpnUtils.QueryInfo(Buildstatement);
      DmdFpnUtils.QryInfo.First;
      while DmdFpnUtils.QryInfo.FieldByName ('CodAction').Asinteger <>
                                                                CtCodActTotal do
        DmdFpnUtils.QryInfo.Next;
      if (DmdFpnUtils.QryInfo.FieldByName ('ValInclVat').AsFloat < 0) and
      FlgSeperateCNNumber then
        IdtInvoice :=
          DmdFpnUtils.GetNextCounter(CtTxtACCredNoteIdtAC, CtTxtACCredNoteField)
      else
        IdtInvoice :=
          DmdFpnUtils.GetNextCounter (CtTxtACInvoiceIdtAC, TxtInvoiceField);
      DmdFpnUtils.QryInfo.First;
      DmdFpnUtils.CloseInfo;
      FrmVSRptInvoiceCA.CodKind := CodKindInvoice;
      FrmVSRptInvoiceCA.FlgDuplicate := False;
      DmdFpnInvoiceCA.SetInvoice
          (SprRTLstInvoice.FieldByName ('IdtPosTransaction').AsInteger,
           SprRTLstInvoice.FieldByName ('IdtCheckout').AsInteger,
           SprRTLstInvoice.FieldByName ('CodTrans').AsInteger,
           SprRTLstInvoice.FieldByName ('DatTransBegin').AsDateTime,
           IdtInvoice, Now,
           SprRTLstInvoice.FieldByName ('IdtCustomer').AsInteger, 0,
           CtCodInvOnSrvAutomatic,
           SprRTLstInvoice.FieldByName ('CodCreator').AsInteger);
      FrmVSRptInvoiceCA.ShowInvoices;
      FrmVSRptInvoiceCA.VspPreview.PrintDoc (False, null, null);
      SprRTLstInvoice.Next;
      DmdFpnUtils.CloseInfo;
    end;
  finally
    SprRTLstInvoice.Close;
    SprRTLstInvoice.Destroy;
    DmdFpnUtils.CloseInfo;
  end;
  if FlgRussia then
    ExecuteRussia;
end;   // of TFrmAutoInv.Execute

//=============================================================================

procedure TFrmAutoInv.ExecuteRussia;
var
  IdtInvoice       : Integer;    // Invoice or creditnote number
  IdtCustomer      : Integer;    // Customer number
  CodCreator       : Integer;    // CodCreator of customer
begin  // of TFrmAutoInv.ExecuteRussia
  if not Assigned (FrmVSRptInvoiceCA) then
    FrmVSRptInvoiceCA := TFrmVSRptInvoiceCA.Create (Self);
  FrmVSRptInvoiceCA.FlgFiscal := FlgFiscal;
  FrmVSRptInvoiceCA.FlgRussia := FlgRussia;
  FrmVSRptInvoiceCA.CodKind := CodKindInvoice;
  FrmVSRptInvoiceCA.FlgDuplicate := False;

  DmdFpnInvoiceCA.QryLstInvToCreate.Active := False;
  DmdFpnInvoiceCA.QryLstInvToCreate.SQL.Clear;
  DmdFpnInvoiceCA.QryLstInvToCreate.SQL.Add(BuildStatementRussia);
  DmdFpnInvoiceCA.QryLstInvToCreate.Active := True;
  DmdFpnInvoiceCA.QryLstInvToCreate.First;
  while not DmdFpnInvoiceCA.QryLstInvToCreate.Eof do begin
    FrmVSRptInvoiceCA.AddIdts (
       DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('IdtPosTransaction').
                                                                      AsInteger,
       DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('IdtCheckout').AsInteger,
       DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('CodTrans').AsInteger,
       DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('DatTransBegin').
                                                                    AsDateTime);
    IdtInvoice :=
        DmdFpnUtils.GetNextCounter (CtTxtACInvoiceIdtAC, CtTxtACInvoiceField);
    IdtCustomer :=  DmdFpnInvoiceCA.QryLstInvToCreate.
                                          FieldByName ('IdtCustomer').AsInteger;
    CodCreator := DmdFpnInvoiceCA.QryLstInvToCreate.
                                           FieldByName ('CodCreator').AsInteger;
    DmdFpnInvoiceCA.SetInvoice
        (DmdFpnInvoiceCA.QryLstInvToCreate.
                             FieldByName ('IdtPosTransaction').AsInteger,
         DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('IdtCheckout').AsInteger,
         DmdFpnInvoiceCA.QryLstInvToCreate.FieldByName ('CodTrans').AsInteger,
         DmdFpnInvoiceCA.QryLstInvToCreate.
                             FieldByName ('DatTransBegin').AsDateTime,
         IdtInvoice,
         Now,
         IdtCustomer,
         0,
         CtCodInvOnSrvAutomatic,
         CodCreator);
    FrmVSRptInvoiceCA.ShowInvoices;
    FrmVSRptInvoiceCA.VspPreview.PrintDoc (False, null, null);
    DmdFpnInvoiceCA.QryLstInvToCreate.Next;
  end;
end;   // of TFrmAutoInv.ExecuteRussia

//=============================================================================

function TFrmAutoInv.BuildStatement : string;
begin  // of TFrmAutoInv.BuildStatement
  Result :=
  #10'SELECT DISTINCT' +
  #10'  POSTransaction.IdtPOSTransaction,' +
  #10'  POSTransaction.IdtCheckOut,' +
  #10'  POSTransaction.CodTrans,' +
  #10'  POSTransInvoice.IdtCustomer,' +
  #10'  POSTransInvoice.CodCreator,' +
  #10'  POSTransInvoice.IdtInvoice, ' +
  #10'  POSTransInvoice.IdtDelivNote,' +
  #10'  POSTransInvoice.DatInvoice, ' +
  #10'  POSTransInvoice.DatDelivNote,' +
  #10'  POSTransDetail.NumLinePrint, ' +
  #10'  POSTransDetail.NumSeq,' +
  #10'  POSTransDetail.CodAction,' +
  #10'  POSTransDetail.NumLineReg,' +
  #10'  POSTransDetail.CodType,' +
  #10'  POSTransDetail.NUMPLU,' +
  #10'  POSTransDetail.IdtArticle,' +
  #10'  POSTransDetail.QtyLine,' +
  #10'  POSTransDetail.QtyReg,' +
  #10'  POSTransDetail.TxtDescr,' +
  #10'  POSTransDetail.IdtVATCode,' +
  #10'  POSTransDetail.PrcInclVAT,' +
  #10'  POSTransDetail.PrcExclVAT,' +
  #10'  POSTransDetail.PctVAT,' +
  #10'  POSTransDetail.ValInclVAT,' +
  #10'  POSTransDetail.ValExclVAT,' +
  #10'  POSTransDetail.IdtCurrency,' +
  #10'  POSTransDetail.ValExchange,' +
  #10'  POSTransDetail.FlgExchMultiply,' +
  #10'  POSTransDetail.PctDiscount,' +
  #10'  POSTransDetail.IdtClassification,' +
  #10'  Article.CodContents' +
  #10'  FROM POSTransaction' +
  #10'  LEFT JOIN POSTransDetail' +
  #10'    ON (POSTransaction.IdtPOSTransaction = POSTransDetail.IdtPOSTransaction' +
  #10'    AND POSTransaction.IdtCheckOut = POSTransDetail.IdtCheckOut' +
  #10'    AND POSTransaction.CodTrans = POSTransDetail.CodTrans' +
  #10'    AND POSTransaction.DatTransBegin = POSTransDetail.DatTransBegin)' +
  #10'  LEFT JOIN POSTRANSINVOICE' +
  #10'    ON (POSTransaction.IdtPOSTransaction = POSTransInvoice.IdtPOSTransaction' +
  #10'    AND POSTransaction.IdtCheckOut = POSTransInvoice.IdtCheckOut' +
  #10'    AND POSTransaction.CodTrans = POSTransInvoice.CodTrans' +
  #10'    AND POSTransaction.DatTransBegin = POSTransInvoice.DatTransBegin)' +
  #10'  LEFT JOIN ARTICLE' +
  #10'    ON (POSTransDetail.IdtArticle = Article.IdtArticle)' +
  #10' WHERE ' +
  #10'     POSTransaction.IdtPOSTransaction = ' + IntToStr(IdtPOSTransaction)+
  #10'     AND POSTransaction.IdtCheckOut = ' + IntToStr(IdtCheckOut) +
  #10'     AND POSTransaction.CodTrans = ' + IntToStr(CodTrans) +
  #10'     AND POSTransaction.DatTransBegin = ' + AnsiQuotedStr (DatTransBegin,
                                                                          '''');
end;   // of TFrmAutoInv.BuildStatement

//=============================================================================

function TFrmAutoInv.BuildStatementRussia : string;
begin  // of TFrmAutoInv.BuildStatementRussia
  Result :=
  #10'SELECT' +
  #10'  POSTransaction.IdtPOSTransaction,' +
  #10'  POSTransaction.IdtCheckOut,' +
  #10'  POSTransaction.CodTrans,' +
  #10'  POSTransaction.DatTransbegin,' +
  #10'  POSTransCust.IdtCustomer,' +
  #10'  POSTransCust.CodCreator,' +
  #10'  POSTransCust.TxtName,' +
  #10'  POSTransInvoice.IdtInvoice,' +
  #10'  POSTransCust.NumCard' +
  #10'FROM POSTransaction (NOLOCK)' +
  #10'LEFT OUTER JOIN POSTransCust (NOLOCK)' +
  #10'ON POSTransCust.IdtPOSTransaction = POSTransaction.IdtPOSTransaction' +
  #10'AND POSTransCust.IdtCheckOut = POSTransaction.IdtCheckOut' +
  #10'AND POSTransCust.CodTrans = POSTransaction.CodTrans' +
  #10'AND POSTransCust.DatTransBegin = POSTransaction.DatTransBegin' +
  #10'AND PosTransCust.NumCard in' +
  #10'    (SELECT Top 1 NumCard FROM PosTransCust (NOLOCK)' +
  #10'     WHERE PosTransCust.IdtPosTransaction = PosTransaction.IdtPosTransaction' +
  #10'     AND PosTransCust.IdtCheckout = PosTransaction.IdtCheckout' +
  #10'     AND PosTransCust.CodTrans = PosTransaction.CodTrans' +
  #10'     AND PosTransCust.DatTransBegin = PosTransaction.DatTransBegin' +
  #10'     ORDER BY PosTransCust.CodCustCard)' +
  #10'AND PosTransCust.IdtCustomer in' +
  #10'    (SELECT Top 1 IdtCustomer FROM PosTransCust P (NOLOCK)' +
  #10'     WHERE P.IdtPosTransaction = PosTransaction.IdtPosTransaction' +
  #10'     AND P.IdtCheckout = PosTransaction.IdtCheckout' +
  #10'     AND P.CodTrans = PosTransaction.CodTrans' +
  #10'     AND P.DatTransBegin = PosTransaction.DatTransBegin' +
  #10'     AND P.NumCard = PosTransCust.NumCard' +
  #10'     ORDER BY P.CodCustCard)' +
  #10'LEFT OUTER JOIN POSTransInvoice (NOLOCK)' +
  #10'ON POSTransInvoice.IdtPOSTransaction = POSTransaction.IdtPOSTransaction' +
  #10'AND POSTransInvoice.IdtCheckOut = POSTransaction.IdtCheckOut' +
  #10'AND POSTransInvoice.CodTrans = POSTransaction.CodTrans' +
  #10'AND POSTransInvoice.DatTransBegin = POSTransaction.DatTransBegin' +
  #10'WHERE EXISTS (SELECT * FROM POSTransdetail (NOLOCK)' +
  #10'              WHERE POSTransdetail.IdtPosTransaction = PosTransaction.IdtPosTransaction' +
  #10'              AND POSTransdetail.IdtCheckout = PosTransaction.IdtCheckout' +
  #10'              AND POSTransdetail.CodTrans = PosTransaction.CodTrans' +
  #10'              AND POSTransdetail.DatTransBegin = PosTransaction.DatTransBegin' +
  #10'              AND (POSTransdetail.CodAction = 145' +
  #10'                   OR POSTransdetail.CodAction = 25))' +
  #10'AND POSTransInvoice.IdtInvoice IS NULL' +
  #10'AND POSTransaction.IdtPosTransaction <> 0' +
  #10'AND POSTransaction.DatTransBegin BETWEEN' +
  #10'    DATEADD(dd, -' + IntToStr(NumDays) + ', CONVERT(VARCHAR(8),GETDATE(),112)) ' +
  #10'    AND GETDATE()';
end;   // of TFrmAutoInv.BuildStatementRussia

//=============================================================================

procedure TFrmAutoInv.ReadParams;
var
  IniFile          : TIniFile;         // IniObject to the INI-file
  TxtPath          : string;           // Path of the ini-file
  TxtSepNumb       : string;           // String with separate number
begin  // of TDmdFpnInvoiceCA.ReadParams
  TxtPath := ReplaceEnvVar ('%SycRoot%\FlexPos\Ini\FpsSyst.INI');
  IniFile := nil;
  OpenIniFile(TxtPath, IniFile);
  // Use seperate number for creditnotes
  TxtSepNumb := IniFile.ReadString('Common', 'SeperateNumberCreditNote', '');
  if Trim (TxtSepNumb) <> '' then
    FlgSeperateCNNumber :=  StrToBool(TxtSepNumb, 'T')
  else
    FlgSeperateCNNumber :=  False;
end;  // of TFrmAutoInv.ReadParams

//=============================================================================

procedure TFrmAutoInv.FormCreate(Sender: TObject);
begin
  inherited;

end;

//=============================================================================

procedure TFrmAutoInv.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin
  inherited;
  // param /VFisc toevoegen aan help
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';
  SplitString(CtTxtFiscalInfo, '=', TxtPartLeft , TxtPartRight);
  SplitString(CtTxtRussia, '=', TxtPartLeft , TxtPartRight);
  SplitString(CtTxtNumDays, '=', TxtPartLeft , TxtPartRight);  
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;

//=============================================================================

procedure TFrmAutoInv.CheckAppDependParams(TxtParam: string);
begin
  if Copy(TxtParam,3,4)= 'Fisc' then
    FlgFiscal := True
  else if Copy(TxtParam,3,2)= 'It' then
    FlgItaly := True
  else if Copy(TxtParam,3,2)= 'Ru' then
    FlgRussia := True
  else if Copy(TxtParam,3,2)= 'ND' then
    NumDays := StrToInt(Copy(TxtParam, 5, Length(TxtParam)-4))
  else
    inherited;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of fAutoInv
