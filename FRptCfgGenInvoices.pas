//=Copyright 2009 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FRptCfgGenInvoices : general form for B&Q invoice/VAT reports//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FRptCfgGenInvoices.pas,v 1.7 2009/09/28 13:16:16 BEL\KDeconyn Exp $
//=============================================================================

unit FRptCfgGenInvoices;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfCommon, StdCtrls, Grids, DBGrids, ComCtrls, ovcbase, ovcef, ovcpb,
  ovcpf, ScUtils, Buttons, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, ScUtils_Dx, DBCtrls, ExtCtrls, DB, dxmdaset, cxDBEdit, ScDBUtil_Dx;

//*****************************************************************************
// Global definitions
//*****************************************************************************

resourcestring
  CtTxtEmCustNotFound        = 'Customer not found.';
  CtTxtEmNoTicketsFound      = 'No usable tickets found using the entered values.';
  CtTxtEmSelectReportType    = 'Select a report type for printing.';
  CtTxtEmEnterVATFields      = 'Please fill out the VAT fields.';
  CtTxtEmTicketAlreadyInList = 'The selected ticket is already in the list.';
  CtTxtEmEnterTickData       = 'Please enter a ticket number or checkout number.';
  CtTxtEmFillOUtGeneralDescr = 'Please enter a general description.';
  CtTxtQPrintingOK           = 'Did the report print correctly?';

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TInvReportType = (rtNone, rtInvoice, rtVATListing);

type
  TFrmRptCfgGenInvoices = class(TFrmCommon)
    PnlTop: TPanel;
    LblTaxCodCompany: TLabel;
    LblNumVATInvoice: TLabel;
    LblCustAddress: TLabel;
    LbLCustName: TLabel;
    LblNumCust: TLabel;
    LblVATInvoiceCode: TLabel;
    DBTxtTxtPublName: TDBText;
    DBTxtTxtStreet: TDBText;
    SvcMETxtNumVATInvoice: TSvcMaskEdit;
    BtnSelectCust: TBitBtn;
    SvcLFNumCustCard: TSvcLocalField;
    SvcMETxtCodVATInvoice: TSvcMaskEdit;
    PnlAddTicket: TPanel;
    LblIdtPOSTransaction: TLabel;
    LblNumCheckout: TLabel;
    LblDate: TLabel;
    SvcLFIdtPOSTransaction: TSvcLocalField;
    SvcLFIdtCheckout: TSvcLocalField;
    DtmPckTickDate: TDateTimePicker;
    BtnAddTicket: TBitBtn;
    PnlTicketList: TPanel;
    DBGrdTicket: TDBGrid;
    BtnDelTicket: TBitBtn;
    PnlPrintOptions: TPanel;
    LblNumTickets: TLabel;
    LblTotalAmount: TLabel;
    LblNumTicketsData: TLabel;
    LblTotalAmountData: TLabel;
    LblGenDescr: TLabel;
    LblReportType: TLabel;
    ChxPrintGenDescr: TCheckBox;
    SvcMETxtGeneralDescr: TSvcMaskEdit;
    CbxReportType: TComboBox;
    DxMDTicket: TdxMemData;
    NumTicket: TLargeintField;
    NumCashD: TLargeintField;
    DatTicket: TDateTimeField;
    QtyAmount: TFloatField;
    DscCustomer: TDataSource;
    DscPOSTransactionCA: TDataSource;
    DscTicket: TDataSource;
    CodTrans: TSmallintField;
    BtnPrintPreview: TBitBtn;
    BtnRemoveAll: TBitBtn;
    DscAddress: TDataSource;
    DBTxtTxtMunicipality: TDBText;
    OvcController1: TOvcController;
    SvcMETxtVATCodCustomer: TSvcMaskEdit;
    DxMDTicketFlgRefundTickets: TBooleanField;
    DxMDTicketTxtRefundTickets: TStringField;
    procedure SvcLFNumCustCardExit(Sender: TObject);
    procedure DxMDTicketFlgRefundTicketsChange(Sender: TField);
    procedure BtnRemoveAllClick(Sender: TObject);
    procedure CbxReportTypeChange(Sender: TObject);
    procedure BtnPrintPreviewClick(Sender: TObject);
    procedure DxMDTicketAfterDelete(DataSet: TDataSet);
    procedure DxMDTicketAfterPost(DataSet: TDataSet);
    procedure FormActivate(Sender: TObject);
    procedure BtnSelectCustClick(Sender: TObject);
    procedure BtnDelTicketClick(Sender: TObject);
    procedure BtnAddTicketClick(Sender: TObject);
  protected

    FlgCurrOperLoaded : boolean; // Has current operator info been retreived?
    FTxtCurrOpername  : string;
    FIdtCustomer      : integer; // Selected customer

    procedure InitFormControls; virtual;

    procedure UpdatePrintButtonState; virtual;
    procedure UpdateTicketInfo; virtual;
    procedure UpdateGeneralInfoState; virtual;
    procedure UpdateVATFieldState; virtual;

    procedure ClearTickets; virtual;

    function GetCurrOperName  : string; virtual;
    function GetCompanyName   : string;
    function GetCompanyVATCode: string;
    function SelectedReport: TInvReportType;

    function  LookupCustomer: Boolean; virtual;
    procedure LookupTicket; virtual;
    procedure ShowReportPreview; virtual;
    procedure DeleteSelectedTicket; virtual;
    procedure FlagTicketsAsInvoiced (IdtInvoice : Integer;
                                     IdtCustomer: Integer;
                                     CodInvoice : Integer;
                                     TxtTaxCode : string); virtual;

    function CheckRefundTickets(IdtPOSTransaction: Integer;
                                IdtCheckout: Integer;
                                CodTrans: Integer;
                                DatTransBegin: TDatetime): Boolean; virtual;

  public
    { Public declarations }

    property TxtCurrOperName  : string read GetCurrOperName;
    property TxtCompanyName   : string read GetCompanyName;
    property TxtVATCodCompany : string read GetCompanyVATCode;
    property IdtCustomer      : integer read FIdtCustomer write FIdtCustomer;

    procedure AddTicketData(IdtPOSTransaction : Integer;
                            IdtCheckout       : Integer;
                            CodTrans          : Integer;
                            DatTransBegin     : TDatetime;
                            ValInclVAT        : Double;
                            FlgRefundTickets  : Boolean); virtual;
  end;  // of TFrmRptCfgGenInvoices

var
  FrmRptCfgGenInvoices: TFrmRptCfgGenInvoices;

//*****************************************************************************

implementation

uses
  DateUtils,
  DBTables,
  StrUtils,

  SfDialog,
  SmUtils,

  DFpnUtils,
  DFpnCustomerCA,
  DFpnPOSTransaction,
  DFpnPOSTransactionCA,
  DFpnOperatorCA,
  DFpnTradeMatrixCA,
  DFpnInvoiceCA,

  FDetCAPOsTransSelect,
  FVSRptGenInvoices,
  FVSRptGenInvInvoice,
  FVSRptGenInvVATLst;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FRptCfgGenInvoices';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 13:16:16 $';

//=============================================================================
// Global variables
//=============================================================================

var
  ViTxtIniFile : string = '\FlexPoint\Ini\PGenInvoices.ini';

//*****************************************************************************
// Implementation of TFrmRptCfgGenInvoices
//*****************************************************************************

//=============================================================================
// TFrmRptCfgGenInvoices.AddTicketData : add ticket data to list of tickets
//    to be printed.
//                                     ---
// INPUT  : IdtPOSTransaction = IdtPOSTransaction of ticket.
//          IdtCheckout       = IdtCheckout of ticket.
//          CodTrans          = CodTrans of ticket.
//          DatTransBegin     = Begin date and time of ticket.
//          ValInclVAT        = Total value incl VAT of ticket.
//=============================================================================

procedure TFrmRptCfgGenInvoices.AddTicketData (IdtPOSTransaction : Integer;
                                               IdtCheckout       : Integer;
                                               CodTrans          : Integer;
                                               DatTransBegin     : TDatetime;
                                               ValInclVAT        : Double;
                                               FlgRefundTickets  : Boolean);
begin  // of TFrmRptCfgGenInvoices.AddTicketData
  DxMDTicket.Active := True;
  DxMDTicket.DisableControls;

  // Insert new record
  if not DxMDTicket.Locate('IdtPOSTransaction;IdtCheckout;CodTrans;DatTransBegin',
        VarArrayOf ([IdtPOSTransaction, IdtCheckout, CodTrans, DatTransBegin]),
        [loPartialKey]) then begin
    DxMDTicket.Append;
    DxMDTicket.FieldByName('IdtPOSTransaction').AsInteger := IdtPOSTransaction;
    DxMDTicket.FieldByName('IdtCheckout').AsInteger := IdtCheckout;
    DxMDTicket.FieldByName('CodTrans').AsInteger := CodTrans;
    DxMDTicket.FieldByName('DatTransBegin').AsDateTime := DatTransBegin;
    DxMDTicket.FieldByName('ValInclVAT').AsFloat := ValInclVAT;
    DxMDTicket.FieldByName('FlgRefundTickets').AsBoolean := FlgRefundTickets;
    DxMDTicket.Post;
  end
  else
    MessageDlg(CtTxtEmTicketAlreadyInList, mtInformation, [mbOK], 0);

  DxMDTicket.EnableControls;
end;   // of TFrmRptCfgGenInvoices.AddTicketData

//=============================================================================
// TFrmRptCfgGenInvoices.UpdateTicketInfo: update ticket total and count in
//   text labels.
//=============================================================================

procedure TFrmRptCfgGenInvoices.UpdateTicketInfo;
var
  NumTickets         : Integer;
  QtyAmount          : Double;
begin  // of TFrmRptCfgGenInvoices.UpdateTicketInfo
  NumTickets := 0;
  QtyAmount  := 0;
  if DxMDTicket.State <> dsInactive then begin
    NumTickets := DxMDTicket.RecordCount;
    DxMDTicket.First;
    while not DxMDTicket.Eof do begin
      QtyAmount := QtyAmount + DxMDTicket.FieldByName('ValInclVAT').AsFloat;
      DxMDTicket.Next;
    end;
  end;
  LblNumTicketsData.Caption  := IntToStr (NumTickets);
  LblTotalAmountData.Caption := FloatToStr(QtyAmount);
end;   // of TFrmRptCfgGenInvoices.UpdateTicketInfo

//=============================================================================
// TFrmRptCfgGenInvoices.LookupCustomer: lookup customer and address data in
//    the database using the entered customer ID.
//=============================================================================

function TFrmRptCfgGenInvoices.LookupCustomer: Boolean;
var
  txtSql           : string;
  CodCreator       : integer;
begin  // of TFrmRptCfgGenInvoices.LookupCustomer
  IdtCustomer := 0;
  CodCreator := 0;
  TxtSql :=    'Select codcreator, idtcustomer ' +
            #10'from CustCard (NOLOCK) ' +
            #10'where NumCard LIKE ' +
                AnsiQuotedStr(Trim(SvcLFNumCustCard.AsString), '''');
  if DmdFpnUtils.QueryInfo(TxtSql) then begin
    IdtCustomer := DmdFpnUtils.QryInfo.FieldByName('IdtCustomer').AsInteger;
    CodCreator  := DmdFpnUtils.QryInfo.FieldByName('CodCreator').AsInteger;
  end;
  DmdFpnUtils.CloseInfo;
  DmdFpnCustomerCA.QryDetCustomer.Active := False;
  DmdFpnCustomerCA.QryDetCustomer.ParamByName('PrmIdtCustomer').AsInteger :=
    IdtCustomer;
  DmdFpnCustomerCA.QryDetCustomer.ParamByName('PrmCodCreator').AsInteger :=
    CodCreator;
  DmdFpnCustomerCA.QryDetCustomer.Active := True;
  // Lookup customer address
  DmdFpnCustomerCA.QryDetCustAddress.Active := False;
  DmdFpnCustomerCA.QryDetCustAddress.ParamByName('PrmIdtAddress').AsString :=
    DscCustomer.DataSet.FieldByName('AddressIdtAddress').AsString;
  DmdFpnCustomerCA.QryDetCustAddress.Active := True;

  SvcMETxtVATCodCustomer.Text :=
    DscCustomer.DataSet.FieldByName ('TxtNumVAT').AsString;
  SvcMETxtVATCodCustomer.Enabled := DscCustomer.DataSet.IsEmpty;
  if DscCustomer.DataSet.IsEmpty then
    Result := False
  else
    Result := True
end;  // of TFrmRptCfgGenInvoices.LookupCustomer

//=============================================================================
// TFrmRptCfgGenInvoices.LookupTicket: lookup a ticket in the database using
//   entered values in the form fields.
//=============================================================================

procedure TFrmRptCfgGenInvoices.LookupTicket;
var
  DatTickFrom      : TDateTime;
  DatTickTo        : TDateTime;
  IdtCheckout      : Integer;
  IdtPOSTransaction: Integer;
  FlgAdd           : Boolean;
  CodTrans         : Integer;
  DatTransBegin    : TDateTime;
  ValInclVAT       : Double;
  FlgRefundTickets : Boolean;
begin  // of TFrmRptCfgGenInvoices.LookupTicket
  DatTickFrom := DtmPckTickDate.Date;
  // Set to date to from date + 1
  DatTickTo := IncDay (DatTickFrom, 1);

  IdtPOSTransaction := StrToIntDef (Trim (SvcLFIdtPOSTransaction.Text), 0);
  IdtCheckout       := StrToIntDef (Trim (SvcLFIdtCheckout.Text), 0);

  if (IdtPOSTransaction = 0) and (IdtCheckout = 0)  then
    MessageDlg (CtTxtEmEnterTickData, mtError, [mbOK], 0)
  else begin

    DscPOSTransactionCA.DataSet := DmdFpnPosTransactionCA.QryLstPosTransaction;
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
    DmdFpnPosTransactionCA.QryLstPosTransaction.SQL.Text :=
      DmdFpnPosTransactionCA.BuildSQLInvoiceTicketCheck (
        IdtPOSTransaction, IdtCheckout, DatTickFrom, DatTickTo);
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := True;

    FlgAdd := False;
    if DscPOSTransactionCA.DataSet.RecordCount = 0 then
      ShowMessage (CtTxtEmNoTicketsFound)
    else begin
      if DscPOSTransactionCA.DataSet.RecordCount > 1 then begin
        FrmDetCAPOSTransSelect.DscPOSTrans.DataSet := DscPOSTransactionCA.DataSet;
        if (FrmDetCAPOSTransSelect.ShowModal = mrOk) then
          FlgAdd := True;
      end
      else
        FlgAdd := True;
    end;

    if FlgAdd then begin
      with DscPOSTransactionCA.DataSet do begin
        IdtPosTransaction := FieldByName('IdtPOSTransaction').AsInteger;
        IdtCheckout       := FieldByName('IdtCheckout').AsInteger;
        CodTrans          := FieldByName('CodTrans').AsInteger;
        DatTransBegin     := FieldByName('DatTransBegin').AsDateTime;
        ValInclVAT        := FieldByName('ValInclVAT').AsFloat;
      end;
      DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
      FlgRefundTickets := CheckRefundTickets (IdtPosTransaction, IdtCheckout,
                                              CodTrans, DatTransBegin);
      AddTicketData(IdtPosTransaction, IdtCheckout, CodTrans, DatTransBegin,
                    ValInclVAT, FlgRefundTickets);
    end
    else
      DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
  end;
end;   // of TFrmRptCfgGenInvoices.LookupTicket

//=============================================================================
// TFrmRptCfgGenInvoices.LoadRefundTicketData : load refund tickets from the
//   database for the given ticket if they exists.
//=============================================================================

function TFrmRptCfgGenInvoices.CheckRefundTickets(
                                      IdtPOSTransaction,
                                      IdtCheckout,
                                      CodTrans      : Integer;
                                      DatTransBegin : TDatetime): Boolean;
begin  // of TFrmRptCfgGenInvoices.CheckRefundTickets
  DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
  DmdFpnPosTransactionCA.QryLstPosTransaction.SQL.Text :=
    DmdFpnPosTransactionCA.BuildSQLForRefundTickets (
      DmdFpnUtils.IdtTradeMatrixAssort, IdtPOSTransaction, IdtCheckout,
      CodTrans, DatTransBegin);
  try
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := True;
    Result := DmdFpnPosTransactionCA.QryLstPosTransaction.RecordCount <> 0;
  finally
    DmdFpnPosTransactionCA.QryLstPosTransaction.Active := False;
  end
end;   // of TFrmRptCfgGenInvoices.CheckRefundTickets

//=============================================================================
// TFrmRptCfgGenInvoices.ShowReportPreview: create report forms and have the
//   preview generated for the requested report.
//=============================================================================

procedure TFrmRptCfgGenInvoices.ShowReportPreview;
var
  FrmVS            : TFrmVSRptGenInvoices;
  IdtInvoice       : Integer;
  CodInvoice       : Integer;
  TxtTaxCode       : string;
begin  // of TFrmRptCfgGenInvoices.ShowReportPreview
  IdtInvoice := 0;
  CodInvoice := 0;
  if (SelectedReport <> rtNone) then begin
    FrmVS := nil;
    if SelectedReport = rtInvoice then begin
      // Create invoicing report
      IdtInvoice := 0;
      CodInvoice := CtCodInvBOInvoiceList;
      TxtTaxCode := '';
      FrmVS := TFrmVSRptGenInvInvoice.Create(Self);
      FrmVS.InitFromIni(ViTxtIniFile, 'Invoice');
      if ChxPrintGenDescr.Checked then begin
        if SvcMETxtGeneralDescr.Text <> '' then
          TFrmVSRptGenInvInvoice(FrmVS).TxtGeneralDescription :=
            SvcMETxtGeneralDescr.Text
        else begin
          FreeAndNil (FrmVS);
          raise Exception.Create (CtTxtEmFillOUtGeneralDescr);
        end;
      end;
    end
    else begin
      if (SvcMETxtNumVATInvoice.TrimText = '') or
         (SvcMETxtCodVATInvoice.TrimText = '') then
        MessageDlg (CtTxtEmEnterVATFields, mtError, [mbOK], 0)
      else begin
        CodInvoice := CtConInvBOVATList;
        IdtInvoice := StrToInt (SvcMETxtNumVATInvoice.TrimText);
        TxtTaxCode := SvcMETxtCodVATInvoice.TrimText;
        // Create VAT listing report
        FrmVS := TFrmVSRptGenInvVATLst.Create(Self);
        FrmVS.InitFromIni(ViTxtIniFile, 'VATListing');
        TFrmVSRptGenInvVATLst(FrmVS).TxtNumVATInvoice :=
          SvcMETxtNumVATInvoice.TrimText;
        TFrmVSRptGenInvVATLst(FrmVS).TxtCodVATInvoice := TxtTaxCode;
        TFrmVSRptGenInvVATLst(FrmVS).TxtVATCodCustomer :=
          SvcMETxtVATCodCustomer.TrimText;
        TFrmVSRptGenInvVATLst(FrmVS).TxtVATCodCompany := TxtVATCodCompany;
      end;
    end;
    if FrmVS <> nil then begin
      FrmVS.TxtUsername := TxtCurrOperName;
      FrmVS.TxtCompanyName := TxtCompanyName;
      FrmVS.TxtCustName := DscCustomer.DataSet.FieldByName('TxtPublName').AsString;
      FrmVS.TxtCustAddress := DscAddress.DataSet.FieldByName ('TxtStreet').AsString;
      FrmVS.ActPrinterSetupExecute(Self);
      try
        // Set dataset with tickets to print report for
        FrmVS.DscTicket.DataSet := DscTicket.DataSet;
        FrmVS.PrepareReport();
        FrmVS.ShowModal;
        if MessageDlg (CtTxtQPrintingOK, mtConfirmation,
                        [mbYes, mbNo], 0) = mrYes then begin
          FlagTicketsAsInvoiced (IdtInvoice, IdtCustomer, CodInvoice, TxtTaxCode);
          ClearTickets;
        end;
      finally
        FreeAndNil(FrmVS);
      end;
    end;
  end
  else
    MessageDlg(CtTxtEmSelectReportType, mtWarning, [mbOK], 0);
end;   // of TFrmRptCfgGenInvoices.ShowReportPreview

//=============================================================================
// TFrmRptCfgGenInvoices.DeleteSelectedTicket: remove the currently selected
//   ticket from the list of tickets to print.
//=============================================================================

procedure TFrmRptCfgGenInvoices.DeleteSelectedTicket;
begin  // of TFrmRptCfgGenInvoices.DeleteSelectedTicket
  if DscTicket.DataSet.RecordCount <> 0 then begin
    DscTicket.DataSet.Delete;
  end;
end;   // of TFrmRptCfgGenInvoices.DeleteSelectedTicket

//=============================================================================
// TFrmRptCfgGenInvoices.InitFormControls: initialise the form's controls.
//=============================================================================

procedure TFrmRptCfgGenInvoices.InitFormControls;
begin  // of TFrmRptCfgGenInvoices.InitFormControls
  DtmPckTickDate.DateTime := Now();
  TFloatField(DxMDTicket.FieldByName('ValInclVAT')).DisplayFormat :=
    StringOfChar('#', DmdFpnUtils.QtyDigsValue) + '.' +
    StringOfChar('0', DmdFpnUtils.QtyDecsValue);
  UpdateTicketInfo;
  UpdatePrintButtonState;
  UpdateGeneralInfoState;
  UpdateVATFieldState;
end;   // of TFrmRptCfgGenInvoices.InitFormControls

//=============================================================================
// TFrmRptCfgGenInvoices.UpdatePrintButtonState: enabled or disables print
//   button depending on the data entered in the form.
//=============================================================================

procedure TFrmRptCfgGenInvoices.UpdatePrintButtonState;
var
  FlgEnabled       : Boolean;
begin  // of TFrmRptCfgGenInvoices.UpdatePrintButtonState
  FlgEnabled := False;
  if DscTicket.DataSet.State <> dsInactive then begin
    FlgEnabled := (DscTicket.DataSet.RecordCount <> 0) and
                  (SelectedReport <> rtNone);
  end;
  BtnPrintPreview.Enabled := FlgEnabled;
end;   // of TFrmRptCfgGenInvoices.UpdatePrintButtonState

//=============================================================================
// TFrmRptCfgGenInvoices.UpdateGeneralInfoState
//=============================================================================

procedure TFrmRptCfgGenInvoices.UpdateGeneralInfoState;
begin  // of TFrmRptCfgGenInvoices.UpdateGeneralInfoState
  ChxPrintGenDescr.Enabled     := (SelectedReport = rtInvoice);
  SvcMETxtGeneralDescr.Enabled := (SelectedReport = rtInvoice);
end;   // of TFrmRptCfgGenInvoices.UpdateGeneralInfoState

//=============================================================================
// TFrmRptCfgGenInvoices.UpdateVATFieldState
//=============================================================================

procedure TFrmRptCfgGenInvoices.UpdateVATFieldState;
begin  // of TFrmRptCfgGenInvoices.UpdateVATFieldState
  SvcMETxtNumVATInvoice.Enabled := (SelectedReport = rtVATListing);
  SvcMETxtCodVATInvoice.Enabled := (SelectedReport = rtVATListing);
end;   // of TFrmRptCfgGenInvoices.UpdateVATFieldState

//=============================================================================
// TFrmRptCfgGenInvoices.FlagTicketsAsInvoiced: vlags the printed tickets as
//   "invoiced".
//=============================================================================

procedure TFrmRptCfgGenInvoices.FlagTicketsAsInvoiced (IdtInvoice : Integer;
                                                       IdtCustomer: Integer;
                                                       CodInvoice : Integer;
                                                       TxtTaxCode : string);
begin  // of TFrmRptCfgGenInvoices.FlagTicketsAsInvoiced
  DscTicket.DataSet.First;
  while not DscTicket.DataSet.Eof do begin
    with DscTicket.DataSet do begin
      DmdFpnInvoiceCA.SetInvoice (FieldByName ('IdtPOSTransaction').AsInteger,
                                  FieldByName ('IdtCheckout').AsInteger,
                                  FieldByName ('CodTrans').AsInteger,
                                  FieldByName ('DatTransBegin').AsDateTime,
                                  IdtInvoice, Now, IdtCustomer, 0,
                                  CodInvoice, CtCodCreatorBO, TxtTaxCode);
    end;
    DscTicket.DataSet.Next;
  end;
end;   // of TFrmRptCfgGenInvoices.FlagTicketsAsInvoiced

//=============================================================================
// TFrmRptCfgGenInvoices.ClearTickets: clears the dataset with ticket info.
//=============================================================================

procedure TFrmRptCfgGenInvoices.ClearTickets;
begin  // of TFrmRptCfgGenInvoices.ClearTickets
  DscTicket.DataSet.Last;
  while not DscTicket.DataSet.Bof do begin
    DscTicket.DataSet.Delete;
  end;
end;   // of TFrmRptCfgGenInvoices.ClearTickets

//=============================================================================
// TFrmRptCfgGenInvoices.GetCurrOperName: returns the systems current operator's
//   name using, as stored by the main menu.
//=============================================================================

function TFrmRptCfgGenInvoices.GetCurrOperName: string;
begin  // of TFrmRptCfgGenInvoices.GetCurrOperName
  if not FlgCurrOperLoaded then begin
    DmdFpnOperatorCA.QryDetOperator.Active := False;
    DmdFpnOperatorCA.QryDetOperator.ParamByName('PrmIdtOperator').AsString :=
      DmdFpnUtils.IdtOperatorCurrentOperator;
    DmdFpnOperatorCA.QryDetOperator.Active := True;
    FTxtCurrOpername :=
      DmdFpnOperatorCA.QryDetOperator.FieldByName('TxtName').AsString;
    DmdFpnOperatorCA.QryDetOperator.Active := False;
    FlgCurrOperLoaded := True;
  end;
  Result := FTxtCurrOpername;
end;   // of TFrmRptCfgGenInvoices.GetCurrOperName

//=============================================================================
// TFrmRptCfgGenInvoices.GetCompanyName: returns the company name from the
//   the tradematrix info.
//=============================================================================

function TFrmRptCfgGenInvoices.GetCompanyName: string;
begin  // of TFrmRptCfgGenInvoices.GetCompanyName
  Result :=
    DmdFpnTradeMatrixCA.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtName'];
end;   // of TFrmRptCfgGenInvoices.GetCompanyName

//=============================================================================
// TFrmRptCfgGenInvoices.GetCompanyVATCode: returns the company VAT code
//   from the the tradematrix info.
//=============================================================================

function TFrmRptCfgGenInvoices.GetCompanyVATCode: string;
begin  // of TFrmRptCfgGenInvoices.GetCompanyVATCode
  Result := AnsiLeftStr (
    DmdFpnTradeMatrixCA.InfoTradeMatrix [DmdFpnUtils.IdtTradeMatrixAssort,
                                         'TxtMemo'], 20);
end;  // of TFrmRptCfgGenInvoices.GetCompanyVATCode

//=============================================================================
// TFrmRptCfgGenInvoices.SelectedReport
//=============================================================================

function TFrmRptCfgGenInvoices.SelectedReport: TInvReportType;
begin  // of TFrmRptCfgGenInvoices.SelectedReport
  case CbxReportType.ItemIndex of
    0 : Result := rtInvoice;
    1 : Result := rtVATListing;
    else
      Result := rtNone;
  end;
end;   // of TFrmRptCfgGenInvoices.SelectedReport

//=============================================================================
// FORM EVENTS
//=============================================================================

//=============================================================================
// TFrmRptCfgGenInvoices.BtnAddTicketClick:
//=============================================================================

procedure TFrmRptCfgGenInvoices.BtnAddTicketClick(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.BtnAddTicketClick
  inherited;
  LookupTicket;
end;   // of TFrmRptCfgGenInvoices.BtnAddTicketClick

//=============================================================================

procedure TFrmRptCfgGenInvoices.BtnDelTicketClick(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.BtnDelTicketClick
  inherited;
  DeleteSelectedTicket;
end;   // of TFrmRptCfgGenInvoices.BtnDelTicketClick

//=============================================================================

procedure TFrmRptCfgGenInvoices.BtnSelectCustClick(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.BtnSelectCustClick
  inherited;
  if not LookupCustomer then
    ShowMessage (CtTxtEmCustNotFound);
end;   // of TFrmRptCfgGenInvoices.BtnSelectCustClick

//=============================================================================

procedure TFrmRptCfgGenInvoices.FormActivate(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.FormActivate
  inherited;
  ViTxtIniFile := AddStartDirToFN (ViTxtIniFile);
  InitFormControls;
end;   // of TFrmRptCfgGenInvoices.FormActivate

//=============================================================================

procedure TFrmRptCfgGenInvoices.DxMDTicketAfterPost(DataSet: TDataSet);
begin  // of TFrmRptCfgGenInvoices.DxMDTicketAfterPost
  UpdateTicketInfo;
  UpdatePrintButtonState
end;   // of TFrmRptCfgGenInvoices.DxMDTicketAfterPost

//=============================================================================

procedure TFrmRptCfgGenInvoices.DxMDTicketAfterDelete(DataSet: TDataSet);
begin  // of TFrmRptCfgGenInvoices.DxMDTicketAfterDelete
  UpdateTicketInfo;
  UpdatePrintButtonState
end;  // of TFrmRptCfgGenInvoices.DxMDTicketAfterDelete

//=============================================================================

procedure TFrmRptCfgGenInvoices.BtnPrintPreviewClick(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.BtnPrintPreviewClick
  ShowReportPreview;
end;  // of TFrmRptCfgGenInvoices.BtnPrintPreviewClick

//=============================================================================

procedure TFrmRptCfgGenInvoices.CbxReportTypeChange(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.CbxReportTypeChange
  UpdatePrintButtonState;
  UpdateGeneralInfoState;
  UpdateVATFieldState;
end;   // of TFrmRptCfgGenInvoices.CbxReportTypeChange

//=============================================================================

procedure TFrmRptCfgGenInvoices.BtnRemoveAllClick(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.BtnRemoveAllClick
  ClearTickets;
end;   // of TFrmRptCfgGenInvoices.BtnRemoveAllClick

//=============================================================================

procedure TFrmRptCfgGenInvoices.DxMDTicketFlgRefundTicketsChange(
  Sender: TField);
begin  // of TFrmRptCfgGenInvoices.DxMDTicketFlgRefundTicketsChange
  inherited;

  if Sender.Value then
    DxMDTicketTxtRefundTickets.Value := '*';
end;   // of TFrmRptCfgGenInvoices.DxMDTicketFlgRefundTicketsChange

//=============================================================================

procedure TFrmRptCfgGenInvoices.SvcLFNumCustCardExit(Sender: TObject);
begin  // of TFrmRptCfgGenInvoices.SvcLFNumCustCardExit
  inherited;
  if (Trim(SvcLFNumCustCard.AsString) <> '') and (not LookupCustomer) then
    ShowMessage (CtTxtEmCustNotFound);
end;   // of TFrmRptCfgGenInvoices.SvcLFNumCustCardExit

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                               CtTxtSrcDate);
end.   // of FRptCfgGenInvoices
