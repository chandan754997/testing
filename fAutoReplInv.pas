//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Unit   : FAutoReplInv.PAS : Autorun form to fill TDV_BO_FACTURES
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fAutoReplInv.pas,v 1.6 2009/09/30 10:07:38 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FAutoReplInv - CVS revision 1.11
// Version      Modified By       Reason
// 1.7	        TK	  (TCS)       R2012.1 - Defect Fix 355 - Russian Invoice
//=============================================================================

unit fAutoReplInv;

//*****************************************************************************

interface

//*****************************************************************************

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, Menus, ImgList, ActnList, ExtCtrls, ScAppRun, ScEHdler,
  StdCtrls, Buttons, ComCtrls, Db, MMntInvoice, FVSRptInvoiceCA;

//=============================================================================
// Constants
//=============================================================================

const

  CtNumTenregTicket     = 1;           //Ticket
  CtNumTenregCustomer   = 2;           //Customer
  CtNumTenregArticle    = 3;           //Detail of article
  CtNumTenregPayment    = 4;           //Detail of payment

  CtCodCustNormal  = 1;                //Normal client
  CtCodCustCredit  = 2;                //With bon de passage
  CtCodCustBankTrf = 3;                //'Bank transfer' for russia

  CtFlgTypeSales   = 1;                //Sale or Return
  CtFlgTypeVers    = 2;                //Versement d'acompte
  CtFlgTypeEmis    = 3;                //Avoir émis

resourcestring
  CtTxtRussia         = '/VRu=Russia';

//=============================================================================

type
  TObjTicket       = class
  private
    FNumTenreg     : integer;          //Type of record = 1
    FDatTicket     : string;           //Date of ticket
    FDatInvoice    : string;           //Date of invoice
    FCodInvoice    : string;           //Code of invoice (1-5)
    FCodCustomer   : string;           //Code of customer (1-3)
    FValTotInvoice : string;           //Total amount of invoice
    FCodTrans      : integer;          //CodTrans
    FIdtPosTransActOrig: integer;      //Original idtpostransaction
    FIdtCheckoutOrig: integer;         //Original checkout number
  public
    property NumTenreg: integer read FNumTenreg write FNumTenreg;
    property DatTicket: string read FDatTicket write FDatTicket;
    property DatInvoice: string read FDatInvoice write FDatInvoice;
    property CodInvoice: string read FCodInvoice write FCodInvoice;
    property CodCustomer: string read FCodCustomer write FCodCustomer;
    property ValTotInvoice: string read FValTotInvoice write FValTotInvoice;
    property CodTrans: integer read FCodTrans write FCodTrans;
    property IdtPosTransActOrig: integer read FIdtPosTransActOrig
                                        write FIdtPosTransActOrig;
    property IdtCheckoutOrig: integer read FIdtCheckoutOrig
                                        write FIdtCheckoutOrig;

    procedure Fill(Dataset: TDataset);
    procedure PrepareInsertStatement(var strLstInsert: TStringList);
  end;

  TObjCustomer     = class
  private
    FNumTenreg     : integer;          //Type of record = 2
    FTxtName       : string;           //Name
    FTxtAddress    : string;           //Street + housenumber
    FTxtCodPost    : string;           //Code Postal
    FTxtMunicip    : string;           //City
    FNumTVA        : string;           //Number TVA
    FNumNIF        : string;           //Num NIF (Spain)
    FNumKPP        : string;
    FNumOKPO       : string;
    FNumINN        : string;
    FTxtCompanyType: string;
    FIdtCustomer   : string;
    FNumBankTransfer: string;
  public
    property NumTenreg: integer read FNumTenreg write FNumTenreg;
    property IdtCustomer: string read FIdtCustomer write FIdtCustomer;
    property TxtName: string read FTxtName write FTxtName;
    property TxtAddress: string read FTxtAddress write FTxtAddress;
    property TxtCodPost: string read FTxtCodPost write FTxtCodPost;
    property TxtMunicip: string read FTxtMunicip write FTxtMunicip;
    property NumTVA: string read FNumTVA write FNumTVA;
    property NumNIF: string read FNumNIF write FNumNIF;
    property NumKPP: string read FNumKPP write FNumKPP;
    property NumOKPO: string read FNumOKPO write FNumOKPO;
    property NumINN: string read FNumINN write FNumINN;
    property TxtCompanyType: string read FTxtCompanyType write FTxtCompanyType;
    property NumBankTransfer: string read FNumBankTransfer
                                    write FNumBankTransfer;

    procedure Fill(Dataset: TDataset);
    procedure PrepareInsertStatement(var strLstInsert: TStringList);
  end;


  TObjInvoice      = class
  private
    FCetab         : integer;          //Shop number
    FIdtInvoice    : integer;          //Invoice number
    FIdtPosTrans   : integer;          //Ticket number
    FIdtCheckout   : integer;          //Checkout number
    FIdtOperator   : integer;          //Operator number
    FObjTicket     : TObjTicket;       //Ticket information
    FObjCustomer   : TObjCustomer;     //Customer information
    FLstArticle    : TList;            //List of articles
    FLstPayment    : TList;            //List of payments
    FObjTransTicket: TObjTransTicketCA;
  public
    //Properties of TObjInvoice
    property Cetab: integer read FCetab write FCetab;
    property IdtInvoice: integer read FIdtInvoice write FIdtInvoice;
    property IdtPosTrans: integer read FIdtPosTrans write FIdtPosTrans;
    property IdtCheckout: integer read FIdtCheckout write FIdtCheckout;
    property IdtOperator: integer read FIdtOperator write FIdtOperator;
    property ObjTicket: TObjTicket read FObjTicket write FObjTicket;
    property ObjCustomer: TObjCustomer read FObjCustomer write FObjCustomer;
    property ObjTransTicket: TObjTransTicketCA read FObjTransTicket
                                               write FObjTransTicket;
    property LstArticle: TList read FLstArticle write FLstArticle;
    property LstPayment: TList read FLstPayment write FLstPayment;

    //Procedures and functions
    procedure PrepareInsertStatement(var strLstInsert: TStringList);
    procedure PrepareLstInsArticle(ObjCurrTrans    : TObjTransactionCA;
                                   var strLstInsert: TStringList      );
    procedure PrepareLstInsPayment(ObjCurrTrans    : TObjTransactionCA;
                                   var strLstInsert: TStringList      );
    procedure SaveInvoice;
    procedure SaveTransaction(objCurrTrans: TObjTransactionCA);
  end; // of TObjInvoice


  TFrmAutoReplInv = class(TFrmAutoRun)
  private
    { Private declarations }
    FLstInvoices   : TList;
    FDstLstInvoices: TDataset;
    FDstDetInvoice : TDataset;
    FFlgRussia: Boolean;
  protected
    procedure AutoStart (Sender : TObject); override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
  public
    { Public declarations }
    property LstInvoices: TList read FLstInvoices write FLstInvoices;
    property DstLstInvoices: TDataset read FDstLstInvoices
                                      write FDstLstInvoices;
    property DstDetInvoice: TDataset read FDstDetInvoice write FDstDetInvoice;

    procedure Execute; override;
    procedure BuildInvoices;
    procedure InsertInvoices;
    procedure CreateAdditionalModules; override;
    property FlgRussia: Boolean read FFlgRussia write FFlgRussia;
  end;

var
  FrmAutoReplInv: TFrmAutoReplInv;

implementation

{$R *.DFM}

Uses
  DFpnPosTransactionCA,
  DFpnInvoiceCA,
  SfDialog,
  DFpnInvoice,
  DFpnUtils,
  DFpnPosTransaction,
  DFpnCustomer,
  SmDBUtil_BDE,
  DFpn,
  DFpnWorkStat,
  DMDummy,
  DFpnTradeMatrix,
  DFpnAddress,
  DFpnOperator,
  SmUtils,
  DFpnCustomerCA,
  DMDummyCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FAutoReplInv';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/fAutoReplInv.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2012/03/04 10:07:38 $';

//*****************************************************************************
// Implementation of TFrmAutoReplInv
//*****************************************************************************

//=============================================================================
// TFrmAutoReplInv.BuildInvoices : Fill objects ObjInvoice
//=============================================================================

procedure TFrmAutoReplInv.AutoStart(Sender: TObject);
begin
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    ActStartExecExecute (Self);
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;

//=============================================================================

procedure TFrmAutoReplInv.BeforeCheckRunParams;
var
  TxtPartLeft      : string;
  TxtPartRight     : string;
begin
  SmUtils.ViTxtRunPmAllow := SmUtils.ViTxtRunPmAllow + 'V';

  SplitString(CtTxtRussia, '=', TxtPartLeft , TxtPartRight);
  SfDialog.AddRunParams (TxtPartLeft, TxtPartRight);
end;

//=============================================================================

procedure TFrmAutoReplInv.BuildInvoices;
var
  ObjInvoice       : TObjInvoice;      //Invoice object
  NumLine          : integer;          //Previous numlinereg
  ObjCurrTrans     : TObjTransaction;  // Current object of transdetail
  NumSubTot        : integer;          // Indicates a subtotal in a ticket.
  FlgFound         : Boolean;          // Is a equal Transdetail found?
  CntTransDetail   : Integer;           // Loop all Transdetails
begin  // of TFrmAutoReplInv.BuildInvoices
  //Vertrekken van PosTransInvoice waarvan FlgSend = 0 en
  //andere gegevens halen uit PosTransaction, PosTransDetail en Customer
  FrmVSRptInvoiceCA := TFrmVSRptInvoiceCA.Create(Self);
  try
    LstInvoices := TList.Create;

    DstLstInvoices := DmdFpnInvoiceCA.QryPOSTransInvoice;
    DstLstInvoices.Active := True;
    DstLstInvoices.First;

    while not DstLstInvoices.Eof do begin
      ObjInvoice := TObjInvoice.Create;
      //General info
      with ObjInvoice do begin
        Cetab := StrToInt(DmdFpnUtils.IdtTradeMatrixAssort);
        IdtInvoice  := DstLstInvoices.FieldByName('IdtInvoice').AsInteger;
        IdtPosTrans := DstLstInvoices.FieldByName('IdtPosTransaction'). AsInteger;
        IdtCheckout := DstLstInvoices.FieldByName('IdtCheckout').AsInteger;

        IdtOperator := StrToIntDef(DstLstInvoices.FieldByName('IdtOperator').AsString, 0);
        ObjTicket   := TObjTicket.Create;
        ObjTicket.Fill(dstLstInvoices);
        ObjCustomer := TObjCustomer.Create;
        ObjCustomer.Fill(dstLstInvoices);
        //Opvullen TicketObject
        DmdFpnInvoiceCA.BuildPOSTransDetail(DmdFpnInvoice.QryPOSTransDetail,
                                          IdtPosTrans,
                                          IdtCheckout,
                                          ObjTicket.CodTrans,
                                          SysUtils.StrToDateTime(ObjTicket.DatTicket));
        DstDetInvoice := DmdFpnInvoice.QryPOSTransDetail;
        DstDetInvoice.Active := True;
        DstDetInvoice.First;
        ObjTransTicket := TObjTransTicketCA.Create;
        ObjTransTicket.FillObj (DstDetInvoice);
        NumLine := DstDetInvoice.FieldByName ('NumLineReg').AsInteger;
        NumSubTot := 0;
        repeat
          // Put all POSTransDetail information of one NumLine into one object.
          ObjCurrTrans := TObjTransactionCA.Create;
          while (not DstDetInvoice.Eof)
            and (NumLine =
                DstDetInvoice.FieldByName ('NumLineReg').AsInteger)
                do begin
            ObjCurrTrans.FillObj (DstDetInvoice);
            DstDetInvoice.Next;
          end;
          NumLine := DstDetInvoice.FieldByName ('NumLineReg').AsInteger;

          // Find all equal POSTransDetails and cummulate them.
          // Start's from the last Subtotal-line
          FlgFound := False;
          for CntTransDetail := NumSubTot to
                           Pred (ObjTransTicket.StrLstObjTransaction.Count) do begin
            if TObjTransactionCA(ObjTransTicket.StrLstObjTransaction.
                                 Objects[CntTransDetail]).Evaluate(ObjCurrTrans)
                                                                          then begin
              TObjTransactionCA(ObjTransTicket.StrLstObjTransaction.
                                Objects[CntTransDetail]).Count (ObjCurrTrans);
              ObjCurrTrans.Free;
              FlgFound := True;
              Break;
            end
          end;
          if not FlgFound then
            ObjTransTicket.StrLstObjTransaction.AddObject ('', ObjCurrTrans);

          // In case of a subtotal.
          if DstDetInvoice.FieldByName ('CodAction').AsInteger =
              CtCodActSubTotal then
            NumSubTot := ObjTransTicket.StrLstObjTransaction.Count;
        until DstDetInvoice.Eof;
      end;
      LstInvoices.Add(ObjInvoice);
      DstLstInvoices.Next;
    end; // of while not eof
  finally
    FrmVSRptInvoiceCA.Free;
    FrmVSRptInvoiceCA := nil;
  end;
end;   // of TFrmAutoReplInv.BuildInvoices

//=============================================================================

procedure TFrmAutoReplInv.CheckAppDependParams(TxtParam: string);
begin // of TFrmAutoReplInv.CheckAppDependParams
  if Copy(TxtParam,3,2)= 'Ru' then
    FlgRussia := True
  else
    inherited;
end; // of TFrmAutoReplInv.CheckAppDependParams

//=============================================================================

procedure TFrmAutoReplInv.CreateAdditionalModules;
begin  // of TFrmAutoReplInv.CreateAdditionalModules
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
  if not Assigned (DmdFpnOperator) then
    DmdFpnOperator := TDmdFpnOperator.Create (Application);
  if not Assigned (DmdFpnPosTransaction) then
    DmdFpnPosTransaction := TDmdFpnPosTransaction.Create (Application);
  if not Assigned (DmdFpnPosTransactionCA) then
    DmdFpnPosTransactionCA := TDmdFpnPosTransactionCA.Create (Application);
end;   // of TFrmAutoReplInv.CreateAdditionalModules

//=============================================================================

procedure TFrmAutoReplInv.Execute;
begin  // of TFrmAutoReplInv.Execute
  BuildInvoices;
  InsertInvoices;
end;   // of TFrmAutoReplInv.Execute

//=============================================================================

procedure TFrmAutoReplInv.InsertInvoices;
var
  numCount         : integer;
  objInvoice       : TObjInvoice;
begin  // of TFrmAutoReplInv.InsertInvoices
  for numCount := 0 to lstInvoices.Count - 1 do begin
    objInvoice := TObjInvoice(lstInvoices[numCount]);
    objInvoice.SaveInvoice;
  end;
end;   // of TFrmAutoReplInv.InsertInvoices

//=============================================================================

//*****************************************************************************
// Implementation of TObjInvoice
//*****************************************************************************

//=============================================================================
// TObjInvoice.PrepareInsertStatement : Prepare stringlist to insert
//=============================================================================

procedure TObjInvoice.PrepareInsertStatement(var strLstInsert: TStringList);
begin  // of TObjInvoice.PrepareInsertStatement
  strLstInsert.Add('FLG_TRF=0');
  strLstInsert.Add('DAT_TRF=' + AnsiQuotedStr(FormatDateTime('YYYYMMDDHHMMSS', now()), ''''));
  strLstInsert.Add('CETAB=' + IntToStr(Cetab));
  strLstInsert.Add('NFACTURE=' + IntToStr(IdtInvoice));
  strLstInsert.Add('CTICKET_TPV=' + IntToStr(IdtPosTrans));
  strLstInsert.Add('CTPV_TPV=' + IntToStr(IdtCheckout));
  strLstInsert.Add('CHOTESSE_TPV=' + IntToStr(IdtOperator));
end;   // of TObjInvoice.PrepareInsertStatement

//=============================================================================
// TObjInvoice.SaveInvoice : Go through object and save it in TDV_BO_FACTURES
//=============================================================================

procedure TObjInvoice.PrepareLstInsArticle(ObjCurrTrans    : TObjTransactionCA;
                                           var strLstInsert: TStringList      );
var
  flagType         : string;
  valVAT           : double;
  chrTempDecSep    : char;
begin  // of TObjInvoice.PrepareLstInsArticle
  chrTempDecSep := DecimalSeparator;
  DecimalSeparator := '.';
  strLstInsert.Add('ID_TRF=' +
               IntToStr(DmdFpnUtils.GetNextCounter('TDV_BO_FACTURES','ID_TRF')));
  strLstInsert.Add('Tenreg=' + IntToStr(CtNumTenregArticle));
  //flagtype bepalen adhv codaction?
  if (ObjCurrTrans.CodMainAction in [CtCodActPLUNum, CtCodActPLUKey,
                                     CtCodActClassNum, CtCodActClassKey]) or
                     (ObjCurrTrans.CodActTakeBack = CtCodActTakeBack) then begin
   flagType := '1';
  end
  else if ObjCurrTrans.CodMainAction in [CtCodActPayAdvance,
          CtCodActChangeAdvance, CtCodActPayGuarantee, CtCodActPayForfait] then
          begin
    flagType := '2';
  end
  else if ObjCurrTrans.CodMainAction = CtCodActCredCoupCreate then begin
    flagType := '3';
  end;

  strLstInsert.Add('Col1=' + AnsiQuotedStr(flagType, ''''));
  strLstInsert.Add('Col2=' + AnsiQuotedStr(IntToStr(ObjCurrTrans.NumLineReg), ''''));

  if ((flagtype = '1') and not(ObjCurrTrans.CodActTurnOver IN
                       [CtCodActCredCoupCreate, CtCodActPayAdvance])) then begin
    if ObjCurrTrans.IdtArticle <> '' then
      strLstInsert.Add('Col3=' + AnsiQuotedStr(ObjCurrTrans.IdtArticle, ''''))
    else
      strLstInsert.Add('Col3=' + AnsiQuotedStr(ObjCurrTrans.NumPLU, ''''));
    strLstInsert.Add('Col4=' + AnsiQuotedStr(FormatFloat('0.0###', ObjCurrTrans.QtyArt), ''''));
  end
  else begin
    strLstInsert.Add('Col4=' + AnsiQuotedStr('0', ''''));
  end;
  if ObjCurrTrans.PrcPromInclVAT <> 0 then begin
    ObjCurrTrans.PrcExclVAT := ObjCurrTrans.PrcPromExclVAT;
    ObjCurrTrans.PrcInclVAT := ObjCurrTrans.PrcPromInclVAT;
    ObjCurrTrans.ValInclVAT := ObjCurrTrans.ValPromInclVAT;
    ObjCurrTrans.ValExclVAT := ObjCurrTrans.ValPromExclVAT;
  end;
  if ((flagtype = '1') and (ObjCurrTrans.CodActTurnOver IN
                        [CtCodActCredCoupCreate, CtCodActPayAdvance])) or
     (flagtype = '2') or (flagtype = '3') then begin
    strLstInsert.Add('Col5=' + AnsiQuotedStr(FormatFloat('0.0###', -ObjCurrTrans.ValInclVAT), ''''));
  end
  else begin
    strLstInsert.Add('Col5=' + AnsiQuotedStr(FormatFloat('0.0###', ObjCurrTrans.PrcExclVAT), ''''));

  end;
  if ((flagType = '1') and not(ObjCurrTrans.CodActTurnOver IN
                       [CtCodActCredCoupCreate, CtCodActPayAdvance])) then begin
    valVat := Round (((ObjCurrTrans.ValInclVAT-Abs(ObjCurrTrans.ValDiscInclVAT)) -
             ((ObjCurrTrans.ValInclVAT-Abs(ObjCurrTrans.ValDiscInclVAT)) / ((ObjCurrTrans.PctVATCode/100.00)+1))) * 100) / 100;
    strLstInsert.Add('Col6=' + AnsiQuotedStr(FormatFloat('0.0###', valVat), ''''));
    strLstInsert.Add('Col7=' + AnsiQuotedStr(FormatFloat('0.0###', ObjCurrTrans.ValInclVAT-Abs(ObjCurrTrans.ValDiscInclVAT)), ''''));
    strLstInsert.Add('Col8=' + AnsiQuotedStr(IntToStr(ObjCurrTrans.IdtVATCode), ''''));
  end;
  if FrmAutoReplInv.FlgRussia then begin
    strLstInsert.Add('Col9 =' + AnsiQuotedStr(ObjCurrTrans.NumGTD, ''''));
    strLstInsert.Add('Col10= ' + AnsiQuotedStr(ObjCurrTrans.TxtISOCountry, ''''));
  end;
  DecimalSeparator := chrTempDecSep;
end;   // of TObjInvoice.PrepareLstInsArticle

//=============================================================================

procedure TObjInvoice.PrepareLstInsPayment(ObjCurrTrans    : TObjTransactionCA;
                                           var strLstInsert: TStringList      );
var
  chrTempDecSep    : char;
begin  // of TObjInvoice.PrepareLstInsPayment
  chrTempDecSep := DecimalSeparator;
  DecimalSeparator := '.';
  strLstInsert.Add('ID_TRF=' +
               IntToStr(DmdFpnUtils.GetNextCounter('TDV_BO_FACTURES','ID_TRF')));
  strLstInsert.Add('Tenreg=' + IntToStr(CtNumTenregPayment));
  strLstInsert.Add('Col1=' + AnsiQuotedStr(ObjCurrTrans.IdtAdmClassi, ''''));
  if ObjCurrTrans.CodActAdm = CtCodActReturn then begin
    ObjCurrTrans.CodActAdm := CtCodActCash;
    ObjCurrTrans.ValAdmInclVAT := -ObjCurrTrans.ValAdmInclVAT;
  end;
  strLstInsert.Add('Col2=' + AnsiQuotedStr(IntToStr(ObjCurrTrans.CodActAdm), ''''));
  strLstInsert.Add('Col3=' + AnsiQuotedStr(IntToStr(ObjCurrTrans.CodType), ''''));
  strLstInsert.Add('Col4=' + AnsiQuotedStr(FormatFloat('0.0###', -ObjCurrTrans.ValAdmInclVAT), ''''));
  if ObjCurrTrans.CodActAdm = CtCodActEFT then
    strLstInsert.Add('Col5=' + AnsiQuotedStr(ObjCurrTrans.NumCard, ''''));
  if ObjCurrTrans.CodActAdm = CtCodActDocBO then
    strLstInsert.Add('Col6=' + AnsiQuotedStr(ObjCurrTrans.TxtDescrAdm, ''''))
  else if ObjCurrTrans.CodActAdm = CtCodActCredCoupAccept then
    strLstInsert.Add('Col6=' + AnsiQuotedStr(ObjCurrTrans.NumPlu, ''''))
  else if ObjCurrTrans.CodActAdm = CtCodActTakeBackAdvance then
    strLstInsert.Add('Col6=' + AnsiQuotedStr(FormatFloat('#', ObjCurrTrans.NumDocBO), ''''));
  DecimalSeparator := chrTempDecSep;
end;   // of TObjInvoice.PrepareLstInsPayment

//=============================================================================

procedure TObjInvoice.SaveInvoice;
var
  numCount         : integer;
  strLstInsTicket  : TStringList;
  strLstInsCust    : TStringList;
  FlgTransStarted  : Boolean;          // Database-Transaction started ?
  ObjCurrentTrans  : TObjTransactionCA;
begin  // of TObjInvoice.SaveInvoice
  //transactie starten
  if not DmdFpnInvoiceCA.DbsUpdate.Connected then
    DmdFpnInvoiceCA.DbsUpdate.Connected := True;
  FlgTransStarted := not DmdFpnInvoiceCA.DbsUpdate.InTransaction;
  if FlgTransStarted then
    DmdFpnInvoiceCA.DbsUpdate.StartTransaction;
  try
    //TENREG 1
    strLstInsTicket := TStringList.Create;
    PrepareInsertStatement(strLstInsTicket);
    ObjTicket.PrepareInsertStatement(strLstInsTicket);
    DmdFpnInvoiceCA.InsertTdvBoFactures(strLstInsTicket);
    //TENREG 2
    strLstInsCust := TStringList.Create;
    PrepareInsertStatement(strLstInsCust);
    ObjCustomer.PrepareInsertStatement(strLstInsCust);
    DmdFpnInvoiceCA.InsertTdvBoFactures(strLstInsCust);
    //TENREG 3 & 4
    for numCount := 0 to objTransTicket.StrLstObjTransaction.Count - 1 do begin
     //afhankelijk van codaction (tenreg 3 of 4) passende insert-statement
     //voorbereidene en uitvoeren
      objCurrentTrans := TObjTransactionCA(objTransTicket.StrLstObjTransaction.Objects[numCount]);
      SaveTransaction(objCurrentTrans);
    end;
    //Update FlgSend en DatSend in PosTransInvoice
    DmdFpnInvoiceCA.qryUpdPosTransInvoice.SQL.Text :=
      'UPDATE PosTransInvoice SET ' +
      'FlgSend = 1, ' +
      'DatSend = getdate() ' +
      'WHERE IdtPosTransaction = ' + IntToStr(IdtPosTrans) + ' ' +
      'AND DatTransBegin = ' +
         AnsiQuotedStr(FormatDateTime (ViTxtDBDatFormat + ' ' + ViTxtDBHouFormat,
                 SysUtils.StrToDateTime(ObjTicket.DatTicket)), '''') +
      'AND CodTrans = ' + IntToStr(ObjTicket.CodTrans) +
      'AND IdtCheckout = ' + IntToStr(IdtCheckout);
    DmdFpnInvoiceCA.qryUpdPosTransInvoice.ExecSql;

    DmdFpnInvoiceCA.DbsUpdate.Commit;
  except
    DmdFpnInvoiceCA.DbsUpdate.Rollback;
  end;
  //transactie stoppen
end;   // of TObjInvoice.SaveInvoice

//*****************************************************************************
// Implementation of TObjTicket
//*****************************************************************************

procedure TObjTicket.Fill(Dataset: TDataset);
var
  chrTempDecSep    : char;
begin  // of TObjTicket.Fill
  NumTenreg := CtNumTenregTicket;
  DatTicket := Dataset.FieldByName('DatTransBegin').AsString;
  DatInvoice := Dataset.FieldByName('DatInvoice').AsString;
  CodInvoice := Dataset.FieldByName('CodInvoice').AsString;
  CodCustomer := Dataset.FieldByName('CodClient').AsString;
  CodTrans := Dataset.FieldByName('CodTrans').AsInteger;
  IdtPosTransActOrig := Dataset.FieldByName('IdtPosTransactionOrig').AsInteger;
  IdtCheckoutOrig := Dataset.FieldByName('IdtCheckoutOrig').AsInteger;
  if DmdFpnUtils.QueryInfo(
      'SELECT TOP 1 ValInclVAT FROM PosTransDetail ' +
      'WHERE DatTransBegin = ' +
                 AnsiQuotedStr(FormatDateTime (ViTxtDBDatFormat + ' ' +
                                               ViTxtDBHouFormat,
                 Dataset.FieldByName('DatTransBegin').AsDateTime), '''') +
      ' AND IdtPosTransaction = ' +
                 Dataset.FieldByName('IdtPosTransaction').AsString +
      ' AND IdtCheckout = ' +
                 Dataset.FieldByName('IdtCheckout').AsString +
      ' AND CodTrans = ' + Dataset.FieldByName('CodTrans').AsString +
      ' AND CodType = ' + IntToStr(CtCodPdtInfo) +
      ' AND CodAction = ' + IntToStr(CtCodActTotal) +
      ' ORDER BY NumLineReg DESC') then begin
    ChrTempDecSep := DecimalSeparator;
    DecimalSeparator := '.';
    ValTotInvoice := FormatFloat('0.0###',
                      DmdFpnUtils.QryInfo.FieldByName('ValInclVAT').AsFloat);
    DecimalSeparator := chrTempDecSep;
  end;
  DmdFpnUtils.CloseInfo;
end;   // of TObjTicket.Fill

//=============================================================================

procedure TObjTicket.PrepareInsertStatement(var strLstInsert: TStringList);
var
  TxtDatTicket     : string;
  TxtDatInvoice    : string;
begin  // of TObjTicket.PrepareInsertStatement
  strLstInsert.Add('ID_TRF=' +
               IntToStr(DmdFpnUtils.GetNextCounter('TDV_BO_FACTURES','ID_TRF')));
  strLstInsert.Add('Tenreg=' + IntToStr(NumTenreg));
  TxtDatTicket := FormatDateTime(ViTxtFormatDateCasto + ViTxtFormatTimeCasto,
                                           SysUtils.StrToDateTime(DatTicket));
  strLstInsert.Add('Col1=' + AnsiQuotedStr(TxtDatTicket, ''''));
  TxtDatInvoice := FormatDateTime(ViTxtFormatDateCasto + ViTxtFormatTimeCasto,
                                           SysUtils.StrToDateTime(DatInvoice));
  strLstInsert.Add('Col2=' + AnsiQuotedStr(TxtDatInvoice, ''''));
  strLstInsert.Add('Col3=' + AnsiQuotedStr(CodInvoice, ''''));
  strLstInsert.Add('Col4=' + AnsiQuotedStr(CodCustomer, ''''));
  strLstInsert.Add('Col5=' + AnsiQuotedStr(ValTotInvoice, ''''));
  if FrmAutoReplInv.FlgRussia then begin
    strLstInsert.Add('Col6=' + IntToStr(IdtPosTransActOrig));
    strLstInsert.Add('Col7=' + IntToStr(IdtCheckoutOrig));
  end;
end;   // of TObjTicket.PrepareInsertStatement

//*****************************************************************************
// Implementation of TObjCustomer
//*****************************************************************************

procedure TObjCustomer.Fill(Dataset: TDataset);
var
  IdtCust          : integer;
  CodCreator       : integer;
begin
  IdtCust := Dataset.FieldByName('IdtCustomer').AsInteger;
  CodCreator := Dataset.FieldByName('CodCreator').AsInteger;
  NumTenreg := CtNumTenregCustomer;
  try
    IdtCustomer := IntToStr(IdtCust);
    TxtName := DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator,'TxtPublName'];
    TxtAddress :=
      DmdFpnCustomerCA.InfoCustomerAddress[IdtCust, CodCreator, 202, 'TxtStreet'] +
      ' ' + DmdFpnCustomerCA.InfoCustomerAddress[IdtCust, CodCreator, 202, 'TxtNumHouse'];
    TxtCodPost := DmdFpnCustomerCA.InfoCustomerAddress[IdtCust, CodCreator, 202, 'TxtCodPost'];
    TxtMunicip := DmdFpnCustomerCA.InfoCustomerAddress[IdtCust, CodCreator, 202, 'TxtMunicip'];
    NumTVA :=  DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator, 'TxtNumVat'];
    if FrmAutoReplInv.FlgRussia then begin
      if Dataset.FieldByName('CodClient').AsInteger = 3 then begin
        try
          if DmdFpnUtils.QueryInfo(
              'SELECT TOP 1 TxtDescr FROM PosTransDetail ' +
              'WHERE DatTransBegin = ' +
                         AnsiQuotedStr(FormatDateTime (ViTxtDBDatFormat + ' ' +
                                                       ViTxtDBHouFormat,
                         Dataset.FieldByName('DatTransBegin').AsDateTime), '''') +
              ' AND IdtPosTransaction = ' +
                         Dataset.FieldByName('IdtPosTransaction').AsString +
              ' AND IdtCheckout = ' +
                         Dataset.FieldByName('IdtCheckout').AsString +
              ' AND CodTrans = ' + Dataset.FieldByName('CodTrans').AsString +
              ' AND CodType = ' + IntToStr(CtCodPdtCommentBankTransfer) +
              ' AND CodAction = ' + IntToStr(CtCodActComment)) then begin
            NumBankTransfer := DmdFpnUtils.QryInfo.FieldByName('TxtDescr').AsString;
          end;
        finally
          DmdFpnUtils.CloseInfo;
        end;
      end;
      NumINN := DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator, 'TxtINN'];
      NumKPP := DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator, 'TxtKPP'];
      NumOKPO := DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator, 'TxtOKPO'];
      TxtCompanyType := DmdFpnCustomerCA.InfoCustomer[IdtCust, CodCreator,
                                                      'TxtCompanyType'];
    end;
  except
  end;
end;

//=============================================================================

procedure TObjCustomer.PrepareInsertStatement(var strLstInsert: TStringList);
begin
  strLstInsert.Add('ID_TRF=' +
               IntToStr(DmdFpnUtils.GetNextCounter('TDV_BO_FACTURES','ID_TRF')));
  strLstInsert.Add('Tenreg=' + IntToStr(NumTenreg));
  strLstInsert.Add('Col1=' + AnsiQuotedStr(TxtName, ''''));
  strLstInsert.Add('Col2=' + AnsiQuotedStr(TxtAddress, ''''));
  strLstInsert.Add('Col3=' + AnsiQuotedStr(TxtCodPost, ''''));
  strLstInsert.Add('Col4=' + AnsiQuotedStr(TxtMunicip, ''''));
  strLstInsert.Add('Col5=' + AnsiQuotedStr(NumTVA, ''''));
  if FrmAutoReplInv.FlgRussia then begin
    strLstInsert.Add('Col6=' + AnsiQuotedStr(NumKPP, ''''));
    strLstInsert.Add('Col7=' + AnsiQuotedStr(NumOKPO, ''''));
    if Trim(NumBankTransfer) <> '' then
      strLstInsert.Add('Col8=' + AnsiQuotedStr(NumBankTransfer, ''''))
    else
      strLstInsert.Add('Col8=' + AnsiQuotedStr(IdtCustomer, ''''));
    strLstInsert.Add('Col9=' + AnsiQuotedStr(TxtCompanyType, ''''));
    strLstInsert.Add('Col10=' + AnsiQuotedStr(NumINN, ''''));
  end
  else begin
    strLstInsert.Add('Col8=' + AnsiQuotedStr(IdtCustomer, ''''));
  end;
end;

//=============================================================================

procedure TObjInvoice.SaveTransaction(objCurrTrans: TObjTransactionCA);
var
  flgInsertTrans   : Boolean;
  strLstInsTrans   : TStringList;
begin
  flgInsertTrans := True;
  strLstInsTrans := TStringList.Create;
  strLstInsTrans.Clear;
  PrepareInsertStatement(strLstInsTrans);

  case objCurrTrans.CodMainAction of
    CtCodActPLUKey, CtCodActPLUNum, CtCodActClassNum, CtCodActClassKey: begin
      if not (ObjCurrTrans.QtyArt = 0) then begin
        PrepareLstInsArticle(objCurrTrans, strLstInsTrans);
      end
      else begin
        flgInsertTrans := false;
      end;
    end;
    CtCodActDiscArtPct, CtCodActCredCoupCreate, CtCodActPayAdvance,
    CtCodActChangeAdvance, CtCodActPayGuarantee,
    CtCodActPayForfait : begin
      PrepareLstInsArticle(objCurrTrans, strLstInsTrans);
    end;
    CtCodActDiscCoup, CtCodActCoupExternal, CtCodActDePCharge,
    CtCodActDepTakeBack, CtCodActDepCoupAccept, CtCodActCash, CtCodActCheque,
    CtCodActCheque2, CtCodActEFT, CtCodActEFT2, CtCodActEFT3, CtCodActEFT4,
    CtCodActForCurr, CtCodActForCurr2, CtCodActForCurr3, CtCodActCreditAllow,
    CtCodActCreditCust, CtCodActCreditRepay, CtCodActVarious,
    CtCodActCoupInternal, CtCodActReturn, CtCodActMinitel, CtCodActDiscPers,
    CtCodActCredCoupAccept, CtCodActTakeBackForfait,
    CtCodActTakeBackAdvance, CtCodActBankTransfer, CtCodRoundTick: begin		// R2012.1 - Defect Fix 355 - Russian Invoice - TCS(TK)
      PrepareLstInsPayment(objCurrTrans, strLstInsTrans);
    end;
  else
    if objCurrTrans.CodActTakeBack = CtCodActTakeBack then begin
      PrepareLstInsArticle(objCurrTrans, strLstInsTrans);
    end
    else begin
      FlgInsertTrans := False;
    end;
  end;
  If FlgInsertTrans then
    DmdFpnInvoiceCA.InsertTdvBoFactures(strLstInsTrans);
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
