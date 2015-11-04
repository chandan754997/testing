//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint 2.0.1
// Customer : Castorama
// Unit     : FTransPaymentCA : Form TRANSfer PAYMENTs after deliveries for
//            CAstorama
//---------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FCustOrdOfflineCA.pas,v 1.6 2009/09/28 15:32:01 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FTransPaymentCA - CVS rev 1.6
//=============================================================================

unit FCustOrdOfflineCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, ComCtrls, StdCtrls, ExtCtrls, Buttons, IniFiles,
  MCustOrdOfflinePanelCA, cxControls, cxContainer, cxEdit, cxTextEdit,
  cxMaskEdit, ScUtils_Dx, DateUtils, ovcbase, ovcef, ovcpb, ovcpf, ScUtils, StrUtils;

//*****************************************************************************
// Global definitions
//*****************************************************************************

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtOperReg     = 'Registrating operator';
  CtTxtAmountNOK   = 'Paied amount doesn''t match amount to transfer!';
  CtTxtNoData      = 'No data found!';
  CtTxtCardEmpty = 'Customer card may not be empty';
  CtTxtNameEmpty = 'Customer name may not be empty';
  CtTxtChannelEmpty = 'Channel may not be empty';
  CtTxtPhoneEmpty = 'Phone number may not be empty';
  CtTxtAddressEmpty = 'Address may not be empty';
  CtTxtCategoryEmpty = 'Category may not be empty';
  CtTxtDelivTypEmpty = 'Delivery type may not be empty';
  CtTxtDelivDateEmpty = 'Delivery date may not be empty';

//=============================================================================
// Panels on statusbar
//=============================================================================

var
  ViNumPnlMsg      : Integer = 0;      // Pnl for user messages
  ViNumPnlOperReg  : Integer = 2;      // Pnl show registrating operator

//=============================================================================
// Position variables
//=============================================================================

var
  ViValTicket     : Integer = 65;      // Width of 'No Ticket' column
  ViValOrder      : Integer = 65;      // Width of 'No Order' column
  ViValCashdesk   : Integer = 70;      // Width of 'No Cashdesk' column
  ViValOperator   : Integer = 70;      // Width of 'No Operator' column
  ViValDate       : Integer = 75;      // Width of 'Ticketdate' column
  ViValAmount     : Integer = 75;      // Width of 'Amount to transfer' column
  ViValCount      : Integer = 75;      // Width of 'Count processed?' column
  ViValProcess    : Integer = 30;      // Width of 'Process button'

//=============================================================================
// Position variables
//=============================================================================

const
  CtTopMargin      : Integer = 0;
  CtLeftMargin     : Integer = 5;
  CtNumberPanels   : Integer = 20;

type
  TFrmCustOrdOfflineCA = class(TFrmCommon)
    StsBarInfo: TStatusBar;
    ScrlbxGrid: TScrollBox;
    PnlTitle: TPanel;
    PnlBottom: TPanel;
    PnlBottomRight: TPanel;
    PnlBottomLeft: TPanel;
    BtnCancel: TBitBtn;
    BtnValidate: TBitBtn;
    PnlBottomTop: TPanel;
    GrbCustInfo: TGroupBox;
    GrbDeliverInfo: TGroupBox;
    GrbAddInfo: TGroupBox;
    SvcCardNumber: TSvcMaskEdit;
    Label2: TLabel;
    Label1: TLabel;
    SvcName: TSvcMaskEdit;
    Label3: TLabel;
    SvcTelephone: TSvcMaskEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    SvcDeliveryArea: TSvcMaskEdit;
    SvcDeliveryAddress: TSvcMaskEdit;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox1: TGroupBox;
    Label12: TLabel;
    SvcDiscount: TSvcLocalField;
    Label20: TLabel;
    SvcDeposit: TSvcLocalField;
    SvcValTotal: TSvcLocalField;
    SvcCategory: TComboBox;
    SvcChannel: TComboBox;
    SvcTypeDelivery: TComboBox;
    SvcDatDelivery: TDateTimePicker;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    LblCustNum: TLabel;
    SvcMskEdtCustNum: TSvcMaskEdit;
    SvcMskEdtNotes: TSvcMaskEdit;
    procedure BtnCancelClick(Sender: TObject);
    procedure SvcDiscountChange(Sender: TObject);
    procedure BtnValidateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FPnlCustOrdOffline : array of         // Panels with payment data
                          TPnlCustOrdOffline;
    FIdtCVente          : double;
  protected
    SavAppOnIdle        : TIdleEvent;      // Save original OnIdle evt hndlr
    FFlgEverActivated   : Boolean;         // Indicates first time activated
    FIdtOperReg         : string;          // IdtOperator registrating
    FTxtNameOperReg     : string;          // Name operator
    IdtTradematrix      : string;
    procedure BuildGrid; virtual;
    procedure SaveData; virtual;
    procedure PanelOnChange (ObjSelf:tobject);
    property IdtCVente : double read FIdtCVente write FIdtCVente;
  public
    { Public declarations }
    property FlgEverActivated : Boolean read FFlgEverActivated;
  published
end;  // of TFrmTransPaymentCA

var
  FrmCustOrdOfflineCA: TFrmCustOrdOfflineCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  smutils,
  ScTskMgr_BDE_DBC,

  DFpnUtils,

  FVSRptCOOffline;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FTransPaymentCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FCustOrdOfflineCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.6 $';
  CtTxtSrcDate    = '$Date: 2009/09/28 15:32:01 $';


//*****************************************************************************
// Implementation of TFrmTransPaymentCA
//*****************************************************************************

procedure TFrmCustOrdOfflineCA.FormCreate(Sender: TObject);
begin // of TFrmCustOrdOfflineCA.FormCreate
  inherited;
  PnlTitle.Visible    := True;
  PnlBottom.Visible   := True;
  SvcDatDelivery.Date := Today;
  BuildGrid;
end; // of TFrmCustOrdOfflineCA.FormCreate

//=============================================================================

procedure TFrmCustOrdOfflineCA.BtnValidateClick(Sender: TObject);
begin // of TFrmCustOrdOfflineCA.BtnValidateClick
  inherited;
  if trim (SvcName.Text) = '' then begin
    ShowMessage ( CtTxtNameEmpty);
    SvcName.SetFocus;
  end
  else if trim (SvcChannel.Text) = '' then begin
    ShowMessage ( CtTxtChannelEmpty);
    SvcChannel.SetFocus;
  end
  else if trim (SvcTelephone.Text) = '' then begin
    ShowMessage (CtTxtPhoneEmpty);
    SvcTelephone.SetFocus;
  end
  else if trim (SvcDeliveryAddress.Text) = '' then begin
    ShowMessage ( CtTxtAddressEmpty);
    SvcDeliveryAddress.SetFocus;
  end
  else if trim (SvcCategory.Text) = '' then begin
    ShowMessage ( CtTxtCategoryEmpty);
    SvcCategory.SetFocus;
  end
  else if trim (SvcTypeDelivery.Text) = '' then begin
    ShowMessage (CtTxtDelivTypEmpty);
    SvcTypeDelivery.SetFocus;
  end
  else begin
    SaveData;
    if not Assigned (FrmVSRptCOOffline) then
      FrmVSRptCOOffline := TFrmVSRptCOOffline.Create (Self);
    FrmVSRptCOOffline.IdtCVente := IdtCVente;
    FrmVSRptCOOffline.TxtDelivery := SvcTypeDelivery.Text;
    FrmVSRptCOOffline.GenerateReport;
    Close;
  end;
end; // of TFrmCustOrdOfflineCA.BtnValidateClick

//=============================================================================
// TFrmTransPaymentCA.BuildGrid : Build grid based on data in database
//=============================================================================

procedure TFrmCustOrdOfflineCA.BuildGrid;
var
  CntPanels      : Integer;          // Loop all payment-methodes
begin  // of TFrmTransPaymentCA.BuildGrid
  SetLength(FPnlCustOrdOffline, CtNumberPanels);
  for CntPanels := 0 to Length (FPnlCustOrdOffline) - 1 do begin
    FPnlCustOrdOffline[CntPanels] := TPnlCustOrdOffline.Create(Self);
    FPnlCustOrdOffline[CntPanels].Parent := ScrlbxGrid;
    FPnlCustOrdOffline[CntPanels].Width := ScrlbxGrid.Width;
    if CntPanels = 0 then
      FPnlCustOrdOffline[CntPanels].Top := CtTopMargin
    else
      FPnlCustOrdOffline[CntPanels].Top :=
                                FPnlCustOrdOffline[CntPanels-1].Top +
                                FPnlCustOrdOffline[CntPanels-1].Height;
    FPnlCustOrdOffline[CntPanels].Left := CtLeftMargin;
    FPnlCustOrdOffline[CntPanels].OnChange := PanelOnChange;
  end;
end;   // of TFrmTransPaymentCA.BuildGrid

//=============================================================================

procedure TFrmCustOrdOfflineCA.SaveData;
var
  PrmTypeVente       : string;
  PrmDCREATION       : string;
  PrmCCLIENT         : string;
  PrmTSITUATION_C104 : string;
  PrmM_TOTAL_VENTE   : string;
  PrmM_ACOMPTE_VERSE_PREVU : string;
  PrmNB_LIGNE        : string;
  PrmNUMCARD         : string;
  PrmTYPE_DELIVERY   : string;
  PrmTxtNameCust     : string;
  PrmTxtChannel      : string;
  PrmTxtNumPhone     : string;
  PrmTxtDelivArea    : string;
  PrmTxtDelivAddress : string;
  PrmTxtCategory     : string;
  PrmDatDelivery     : string;
  PrmPctDiscount     : string;
  PrmTxtNote         : String;
  CntPanels          : Integer;
  Counter            : Integer;
begin // of TFrmCustOrdOfflineCA.SaveData;
  IdtCVente := StrToFloat('9' + Format ('%.9d',[DmdFpnUtils.GetNextCounter
               ('VENTE','CVenteOffline')]));
  PrmTypeVente := '10';
  PrmDCREATION := FormatDateTime( 'YYYMMDDHHNNSS',Today);
  PrmCCLIENT := '0';
  PrmTSITUATION_C104 := '2';
  PrmM_TOTAL_VENTE := StringReplace(Trim(SvcValTotal.Text),',','.',[]);
  PrmM_ACOMPTE_VERSE_PREVU := StringReplace(Trim(SvcDeposit.Text),',','.',[]);
  PrmNUMCARD := SvcCardNumber.Text;
  PrmTYPE_DELIVERY := IntToStr (SvcTypeDelivery.ItemIndex + 1);
  PrmTxtNameCust := SvcName.Text;
  PrmTxtChannel := IntToStr(SvcChannel.ItemIndex + 1);
  PrmTxtNumPhone := SvcTelephone.Text;
  PrmTxtDelivArea := SvcDeliveryArea.Text;
  PrmTxtDelivAddress := SvcDeliveryAddress.Text;
  PrmTxtCategory := LeftStr (SvcCategory.Text, 3);
  PrmDatDelivery  := FormatDateTime( 'YYYMMDDHHNNSS', SvcDatDelivery.Date);
  PrmPctDiscount := StringReplace(Trim(SvcDiscount.Text),',','.',[]);
  PrmTxtNote := SvcMskEdtNotes.Text;
  Counter := 0;
  for CntPanels := 0 to Length (FPnlCustOrdOffline) - 1 do
    if (FPnlCustOrdOffline[CntPanels].FEdtArticle.TrimText > '') and
       (FPnlCustOrdOffline[CntPanels].FEdtQty.AsFloat > 0)  then
      Inc (Counter);
  PrmNB_ligne := IntToStr (Counter);
  DmdFpnUtils.QryInfo.SQL.Text := 'INSERT INTO VENTE (CETAB, CVENTE, TYPE_VENTE, DCREATION, CCLIENT, TSITUATION_C104, M_TOTAL_VENTE, M_ACOMPTE_VERSE_PREVU, NB_LIGNE, NUMCARD, TYPE_DELIVERY,'+
                        'TxtNameCust,TxtChannel, TxtNumPhone, TxtDelivArea, TxtDelivAddress, TxtCategory, DatDelivery, PctDiscount, TxtNote, IdtCustomer, FlgOffLine) ' +
                         'VALUES(''' + DmdFpnUtils.IdtTradeMatrixAssort + ''',''' +
                                 FloatToStr(IdtCVente) + ''',''' +
                                 PrmTYPEVENTE + ''',''' +
                                 PrmDCREATION + ''',''' +
                                 PrmCCLIENT + ''',''' +
                                 PrmTSITUATION_C104 + ''',''' +
                                 PrmM_TOTAL_VENTE + ''',''' +
                                 PrmM_ACOMPTE_VERSE_PREVU + ''',''' +
                                 PrmNB_LIGNE + ''',''' +
                                 PrmNUMCARD + ''',''' +
                                 PrmTYPE_DELIVERY + ''',''' +
                                 PrmTxtNameCust + ''',''' +
                                 PrmTxtChannel + ''',''' +
                                 PrmTxtNumPhone + ''',''' +
                                 PrmTxtDelivArea + ''',''' +
                                 PrmTxtDelivAddress + ''',''' +
                                 PrmTxtCategory + ''',''' +
                                 PrmDatDelivery + ''',''' +
                                 PrmPctDiscount + ''',''' +
                                 PrmTxtNote + ''',''' +
                                 SvcMskEdtCustNum.Text + ''',' +
                                 '1)';
  DmdFpnUtils.QryInfo.ExecSQL;

  Counter := 0;
  for CntPanels := 0 to Length (FPnlCustOrdOffline) - 1 do begin
    if (FPnlCustOrdOffline[CntPanels].FEdtArticle.TrimText > '') and
       (FPnlCustOrdOffline[CntPanels].FEdtQty.AsFloat > 0)  then begin
      DmdFpnUtils.QryInfo.SQL.Text :=
          'INSERT INTO VENTE_LIGNE (CETAB, CVENTE, CVENTE_LIGNE, DCREATION, '+
                                   'TYPE_VENTE, CESCLAVE, LIB_ESCLAVE, NB_COLIS,'+
                                   'QDIM1_SAISI, QTE_SAISI, CTVA, M_PV_FICHIER,'+
                                   'M_PV_SAISI, TSITUATION_C104, TxtNote, ' +
                                   'TxtSalesUnit) ' +
          'VALUES ('''+
                   DmdFpnUtils.IdtTradeMatrixAssort+''','''+
                   FloatToStr(IdtCVente) + ''',''' +
                   IntToStr (Counter + 1) + ''',''' +
                   PrmDCREATION  + ''',''' +
                   PrmTypeVente + ''',''' +

                   Trim (FPnlCustOrdOffline[CntPanels].FEdtArticle.Text) + ''',''' +
                   Trim (FPnlCustOrdOffline[CntPanels].FEdtDescr.Text) + ''',''' +
                   '1' + ''',''' +
                   StringReplace(Trim(FPnlCustOrdOffline[CntPanels].FEdtQty.Text),',','.',[]) + ''',''' +
                   StringReplace(Trim(FPnlCustOrdOffline[CntPanels].FEdtQty.Text),',','.',[]) + ''',''' +
                   '0' + ''',''' +
                   StringReplace(Trim(FPnlCustOrdOffline[CntPanels].FEdtPrice.Text),',','.',[]) + ''',''' +
                   StringReplace(Trim(FPnlCustOrdOffline[CntPanels].FEdtPrice.Text),',','.',[]) + ''',''' +
                   '2'  + ''',''' +
                   Trim (FPnlCustOrdOffline[CntPanels].TxtNotes) + ''',''' +
                   Trim (FPnlCustOrdOffline[CntPanels].FEdtUnit.Text) + ''')';
      DmdFpnUtils.QryInfo.ExecSQL;
      Inc (Counter);
    end;
  end;
end;  // of TFrmCustOrdOfflineCA.SaveData;

//=============================================================================

procedure TFrmCustOrdOfflineCA.SvcDiscountChange(Sender: TObject);
var
  CntList : integer;
begin // of TFrmCustOrdOfflineCA.SvcDiscountChange
  inherited;
  for CntList := 0 to Length (FPnlCustOrdOffline) - 1 do begin
    FPnlCustOrdOffline[CntList].PctDiscount := SvcDiscount.AsFloat / 100;
    FPnlCustOrdOffline[CntList].RecalculateLine;
  end;
end; // of TFrmCustOrdOfflineCA.SvcDiscountChange

//=============================================================================

procedure TFrmCustOrdOfflineCA.PanelOnChange(objSelf: tobject);
var
  CntList : integer;
  ValTotal : real;
begin // of TFrmCustOrdOfflineCA.PanelOnChange
  ValTotal := 0;
  for CntList := 0 to Length (FPnlCustOrdOffline) - 1 do
    ValTotal := ValTotal + FPnlCustOrdOffline[CntList].FEdtAmountAftDisc.AsFloat;
  SvcValTotal.AsFloat := ValTotal;
  SvcDeposit.AsFloat := SvcValTotal.AsFloat;
end; // of TFrmCustOrdOfflineCA.PanelOnChange

//=============================================================================

procedure TFrmCustOrdOfflineCA.BtnCancelClick(Sender: TObject);
begin // of TFrmCustOrdOfflineCA.BtnCancelClick
  inherited;
  Close;
end; // of TFrmCustOrdOfflineCA.BtnCancelClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);

end.
