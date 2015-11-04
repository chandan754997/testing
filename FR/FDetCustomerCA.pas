//= Copyright 2009 (c) Real Software NV - Retail Division. All rights reserved =
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FMntCustomerCA.PAS : MainForm DETail CUSTOMER for Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCustomerCA.pas,v 1.16 2010/06/30 06:54:40 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FDetCustomerCA - CVS revision 1.17
// Version                              Modified By                          Reason
// V 1.18                                KB. (TCS)                          R2011.1 - BDFR - Siret No.
// V 1.19                                KB. (TCS)                          R2011.1 - Defect Fix 945,946
// V 1.20                                PM. (TCS)                          R2011.1 - Defect Fix 945
// V 1.21                                PM. (TCS)                          R2011.1 - Defect Fix 947
// V 1.22                                TT. (TCS)                          R2011.2 - BRES - Ficha Cliente
// V 1.23                                AM. (TCS)                          R2011.2 - BDES - Creation Of Client Management of Post Code
// V 1.24                                TT. (TCS)                          R2011.2 - BRES - Ficha Cliente - Post integration Defect Fix
// V 1.25                                TT. (TCS)                          R2011.2 - BRES - Ficha Cliente - Known Issue Fix
// V 1.26                                AM. (TCS)                          Bug Fix for Defect ID-38(R2011.2 Creation Of Client)-End
// V 1.27                                TT. (TCS)                          R2011.2 - BRES - Ficha Cliente - Enhancement related to defect# 31
// V 1.28                                TT. (TCS)                          R2011.2 - BRES - Defect fix 173
// V 1.29           					 TT. (TCS)             				R2011.2 - BRES - Defect fix 299
// V 1.30                                AM(TCS)                            Internal defect fix
// V 1.31                                SM  (TCS)                          R2012.1 - BDFR - Address De Facturation
// V 1.32                                SR. (TCS)                          R2011.2 - CAFR - Frozen Bug 11 & 09
// V 1.33                                SC  (TCS)                          R2012.1-5401-BRFR-Flux_des_clients_en_compte
//=============================================================================

unit FDetCustomerCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfDetail_BDE_DBC, Db, ComCtrls, StdCtrls, Buttons, ExtCtrls, OvcBase, OvcEF,
  OvcPB, OvcPF, OvcDbPF, ScDBUtil_BDE, Grids, DBGrids, DBCtrls, Mask, DbTables,
  ScUtils, Menus, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDBEdit, ScDBUtil_Dx, ScDBUtil_Ovc, ScUtils_Dx;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring
  CtTxtErrVATNumeric       = 'The VAT number has to be numeric.';
  CtTxtErrVATAlphaNumeric  = 'The VAT number has to be alphanumeric.';
  CtTxtErrVATInvalid       = 'The VAT number is invalid.';
  CtTxtErrVATFormatInvalid = 'The format of the CIF is invalid';
  //SRai FB 11 START
  CtTxtErrDelBonPassage    = 'Impossible to delete customer because few ' +
                             '“bon passage” were created today.';
(*  CtTxtErrDelBonPassage    = 'Delete not allowed, there are bons de passage ' +
                             'present for this customer';
*)
  //SRai FB 11 END
  CtTxtErrSiretNO         = 'SiretNO should be of 14 digits';         //Siret No, Modified by TCS(KB), R2011.1
  CtTxtCustTitle              = 'Maintenance Customer';   // R2011.1 - Defect Fix 947, Modified by TCS(PM)
 //R2011.2 - BDES - Creation Of Client Management of Post Code-Start
  CtTxtStreet              = 'Required Street';
  CtTxtPostCode            = 'Required Post Code';
  CtTxtProvince            = 'Required Province';
  CtTxtCustDataSheet       = 'Customer Sheet';
  CtTxtMunicipalityMessage = 'Required Municipality';     //Bug Fix for Defect ID-38(R2011.2 Creation Of Client)
  CtTxtFrmCaption          = 'Customer';                                          // Defect fix 173, TT.(TCS), R2011.2 - BRES
  CtTxtGenAddCaption       = 'General Address';                                   //R2012.1 Address De Facturation (SM)
//R2011.2 - BDES - Creation Of Client Management of Post Code-End
//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmDetCustomerCA = class(TFrmDetail)
    DscCustomer: TDataSource;
    DscCustCard: TDataSource;
    DscLstCustCard: TDataSource;
    DscAddress: TDataSource;
    TabShtCommon: TTabSheet;
    SvcDBLblIdtCustomer: TSvcDBLabelLoaded;
    SvcDBLblTxtPublName: TSvcDBLabelLoaded;
    SvcDBLFIdtCustomer: TSvcDBLocalField;
    GbxFlgCreditLim: TGroupBox;
    SvcDBLblFlgCreditLim: TSvcDBLabelLoaded;
    SvcDBLblValCreditLim: TSvcDBLabelLoaded;
    LblIdtCurrency: TLabel;
    DBCbxFlgCreditLim: TDBCheckBox;
    GbxFlgActive: TGroupBox;
    SvcDBLblCodVATSystem: TSvcDBLabelLoaded;
    SvcDBLblQtyCopyInv: TSvcDBLabelLoaded;
    DBLkpCbxCodVATSystem: TDBLookupComboBox;
    SvcDBLFQtyCopyInv: TSvcDBLocalField;
    SvcDBLblTxtNumVAT: TSvcDBLabelLoaded;
    GbxFlgAddress: TGroupBox;
    SvcDBLblTxtStreet: TSvcDBLabelLoaded;
    SvcDBLblTxtTitle: TSvcDBLabelLoaded;
    SvcDBLblTxtCountry: TSvcDBLabelLoaded;
    SvcDBLblTxtCodPost: TSvcDBLabelLoaded;
    SvcDBLblTxtNameMunicipality: TSvcDBLabelLoaded;
    DBLkpCbxIdtMunicipality: TDBLookupComboBox;
    BtnSelectMunicipality: TBitBtn;
    btnReprint: TBitBtn;
    btnBonPassage: TBitBtn;
    SvcDBLFValCreditLim: TSvcDBLocalField;
    SvcDBLblTxtProvince: TSvcDBLabelLoaded;
    GbxFlgRussia: TGroupBox;
    SvcDBLblTxtInn: TSvcDBLabelLoaded;
    SvcDBLblTxtKPP: TSvcDBLabelLoaded;
    SvcDBLblTxtOKPO: TSvcDBLabelLoaded;
    SvcDBLblTxtTypeCompany: TSvcDBLabelLoaded;
    SvcDBLblNumInvExpDays: TSvcDBLabelLoaded;
    SvcDBLFNumInvExpDays: TSvcDBLocalField;
    SvcDBMETxtPublName: TSvcDBMaskEdit;
    SvcDBMETxtTitle: TSvcDBMaskEdit;
    SvcDBMETxtStreet: TSvcDBMaskEdit;
    SvcDBMEMunicipalityTxtCodPost: TSvcDBMaskEdit;
    SvcDBMETxtProvince: TSvcDBMaskEdit;
    SvcDBMETxtCountry: TSvcDBMaskEdit;
    SvcDBMETxtINN: TSvcDBMaskEdit;
    SvcDBMETxtKPP: TSvcDBMaskEdit;
    SvcDBMETxtOKPO: TSvcDBMaskEdit;
    SvcDBMETxtTypeCompany: TSvcDBMaskEdit;
    SvcDBMETxtNumVAT: TSvcDBMaskEdit;
    TabShtCustCard: TTabSheet;
    SbxCustCard: TScrollBox;
    DBGrdCustCard: TDBGrid;
    PnlBtnCustCard: TPanel;
    BtnNewCustCard: TBitBtn;
    BtnEditCustCard: TBitBtn;
    BtnRemoveCustCard: TBitBtn;
    BtnConsultCustCard: TBitBtn;
    GbxValSale: TGroupBox;
    SvcDBLabelLoaded2: TSvcDBLabelLoaded;
    LblIdtCurrencyValSale: TLabel;
    SvcDBLFValSale: TSvcDBLocalField;
    GbxIdtCustPrcCat: TGroupBox;
    SvcDBLblIdtCustPrcCat: TSvcDBLabelLoaded;
    SvcMECustPrcCatTxtExplanation: TSvcMaskEdit;
    BtnSelectCustPrcCat: TBitBtn;
    SvcDBLFIdtCustPrcCat: TSvcDBLocalField;
    SvcDBMEtxtSiretNo: TSvcDBMaskEdit;                                 // Siret No, Modified by TCS(KB), R2011.1
    SvcDBLblSiretNo: TSvcDBLabelLoaded;
    BtnCustomerSheet: TBitBtn;
	BDFRGroupBox: TGroupBox;
    SvcDBLabelLoaded1: TSvcDBLabelLoaded;
    SvcDBLabelLoaded3: TSvcDBLabelLoaded;
    SvcDBLabelLoaded4: TSvcDBLabelLoaded;
    SvcDBLabelLoaded5: TSvcDBLabelLoaded;
    SvcDBLabelLoaded6: TSvcDBLabelLoaded;
    SvcDBLabelLoaded7: TSvcDBLabelLoaded;
    DBLookupComboBox1: TDBLookupComboBox;
    BitBtn1: TBitBtn;
    SvcDBMaskEdit1: TSvcDBMaskEdit;
    SvcDBMaskEdit2: TSvcDBMaskEdit;
    SvcDBMaskEdit3: TSvcDBMaskEdit;
    SvcDBMaskEdit4: TSvcDBMaskEdit;
    SvcDBMaskEdit5: TSvcDBMaskEdit;
    DscAddInvoice: TDataSource;                                         //R2011.2 - BDES - Creation Of Client Management of Post Code
    //BitBtn1: TBitBtn;
    DscGetCountry: TDataSource;                                                 //R2011.2 - BDES - Creation Of Client Management of Post Code
    DscMunicipalityFilter: TDataSource;                                         //R2011.2 - BDES - Creation Of Client Management of Post Code
    procedure BtnCustomerSheetClick(Sender: TObject);                           //Ficha Cliente, TT, R2011.2
    procedure DscCustomerDataChange(Sender: TObject; Field: TField);            //Ficha Cliente, TT, R2011.2
    procedure BtnCancelClick(Sender: TObject);
    procedure SvcDBMEtxtSiretNoExit(Sender: TObject);                                //Siret No, Modified by TCS(KB), R2011.1
    procedure SvcDBLFIdtCustPrcCatUserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure BtnSelectCustPrcCatClick(Sender: TObject);
    procedure PgeCtlDetailChange(Sender: TObject);
    procedure SvcDBMEMunicipalityTxtCodPostPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnSelectMunicipalityClick(Sender: TObject);
    procedure btnBonPassageClick(Sender: TObject);
    procedure BtnAddOnClick(Sender: TObject);
    procedure DBCbxFlgCreditLimClick(Sender: TObject);
    procedure InCloseQueryCanDelete; override;
    procedure btnReprintClick(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure DBLkpCbxIdtMunicipalityEnter(Sender: TObject);
    procedure BtnCustCardClick(Sender: TObject);
    procedure DBGrdCustCardDblClick(Sender: TObject);
    procedure DBGrdCustCardTitleClick(Column: TColumn);
    procedure ModifyCaption; override;     // Added as part of R2011.1 - Defect Fix 947, Modified by TCS(PM)
    procedure SvcDBMEMunicipalityTxtCodPostExit(Sender: TObject);               //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
    procedure DBLkpCbxIdtMunicipalityCloseUp(Sender: TObject);                  //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  private
    { Private declarations }
    IdtCustomer            : string;     // Identification customer
    TxtName                : string;     // Name of the customer
    TxtTitle               : string;     // Title of the customer               //Ficha Cliente, TT, R2011.2
    TxtAddress             : string;     // Address of the customer
    TxtPostalCode          : string;     // Postal Code of the customer
    TxtMunicipality        : string;     // Municipality of the customer
    TxtNameCountry         : string;     // Country of the customer             //Ficha Cliente, TT, R2011.2
    TxtProvince            : string;     // Province of the customer            //Ficha Cliente, TT, R2011.2
    FFlgCreditLim          : Boolean;    // Credit limit is available or not    //Ficha Cliente, TT, R2011.2
    ValAmount              : string;     // Maximum amount of the customer
    IdtCurrency            : string;     // Currency                            //Ficha Cliente, TT, R2011.2
    TxtNumVAT              : string;     // VAT number of customer              //Ficha Cliente, TT, R2011.2
    TxtPublDescr           : string;     // Code VAT of the customer            //Ficha Cliente, TT, R2011.2
    QtyCopyInv             : string;     // Number of invoice copy              //Ficha Cliente, TT, R2011.2
    DatCreate              : TDateTime;  // Date of creation                    //Ficha Cliente, TT, R2011.2
    DatModify              : TDateTime;  // Date of modification                //Ficha Cliente, TT, R2011.2
    TxtCodCreator          : string;     // Extra Idt for customer
    TxtVATNumber           : string;     // VAT number to check
    TxtVATNumberToSave     : string;     // VAT number to save
    FFlgCheckVAT           : Boolean;    // Check VAT number?
    FFlgVatRequired        : Boolean;    // VAT number required?
    FFlgDisableBonPassage  : Boolean;
    FFlgRussia             : Boolean;    // Show russian fields?
    FFlgBDFR               : Boolean;    //R2012.1 Address De Facturation
    FFlgDisableCredit      : Boolean;    // Show russian fields?
    FFlgInvExp             : Boolean;    // Show number of day before expiry
    FFlgCustCard           : Boolean;    // Show customer cards
    FFlgDelayDel           : Boolean;    // Use FlgDelete for deleting
    FFlagSiretNo: Boolean;    // Siret No, Modified by TCS(KB), R2011.1
    FFlgCustomerSheet      : Boolean;    // CustomerSheet Button,               //Ficha Cliente, TT, R2011.2
    FFlgMandatory          : Boolean;    //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
    FFlgDisableTVAFrmSap   : Boolean;    //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
  protected
    // Methods for read/write properties
    function GetIdentForSel : string; virtual;
    function GetFldIdtTable : TField; virtual;
    function GetTxtMainTableName : string; virtual;
    // Overriden methods
    procedure SetDataSetReferences; override;
    procedure CheckIdtCustomerBeforeSave; virtual;
    procedure CheckNameBeforeSave; virtual;
    procedure CheckNumVATBeforeSave; virtual;
    procedure CheckSiretBeforeSave; virtual;    //Siret No, Modified by TCS(KB), R2011.1
    procedure PerformChecksFlgVATRequired; virtual;
    procedure PerformChecksFlgCheckVAT; virtual;
    function CheckFormatVAT : Boolean; virtual;
    function  GetRecName : string; override;                                    //R2011.2 - BRES - Defect fix 299
    procedure FillFields; virtual;
    procedure StatusValCreditLim; virtual;
    procedure StatusClientMarketing; virtual;
    procedure AdjustBtnsCustCard; virtual;
    procedure StatusSiretNo; virtual;   //Siret No, Modified by TCS(KB), R2011.1
  public
    { Public declarations }
    // Methods
    procedure FillQuery (QryToFill : TQuery); override;
    procedure FillStoredProc (SprToFill : TStoredProc); override;
    procedure PrepareFormDependJob; override;
    procedure PrepareDataDependJob; override;
    procedure AdjustDataBeforeSave; override;
    procedure AdjustLookupMunicipality (TxtCodPost : string); virtual;
    function IsDataChanged : Boolean; override;

    procedure AdjustDependCurrency (QtyDecim : Integer); virtual;
    procedure CheckVatAlphaNum(VatNumber: String);
    procedure CheckVatNum(VatNumber: String);
  published
    property TxtIdentForSel        : string  read GetIdentForSel;
    property FldIdtTable           : TField  read GetFldIdtTable;
    property TxtMainTableName      : string  read GetTxtMainTableName;
    property Customer              : string  read Idtcustomer
                                             write IdtCustomer;
    property Name                  : string  read TxtName
                                             write TxtName;
    property Title                 : string  read TxtTitle                      //Ficha Cliente, TT, R2011.2
                                             write TxtTitle;                    //Ficha Cliente, TT, R2011.2
    property Address               : string  read TxtAddress
                                             write TxtAddress;
    property PostalCode            : string  read TxtPostalCode
                                             write TxtPostalCode;
    property Municipality          : string  read TxtMunicipality
                                             write TxtMunicipality;
    property Country               : string  read TxtNameCountry                //Ficha Cliente, TT, R2011.2
                                             write TxtNameCountry;              //Ficha Cliente, TT, R2011.2
    property Province              : string  read TxtProvince                   //Ficha Cliente, TT, R2011.2
                                             write TxtProvince;                 //Ficha Cliente, TT, R2011.2
    property Amount                : string  read ValAmount
                                             write ValAmount;
    property FlgCreditLim          : Boolean read FFlgCreditLim                 //Ficha Cliente, TT, R2011.2
                                             write FFlgCreditLim;               //Ficha Cliente, TT, R2011.2
    //Ficha Cliente, TT, R2011.2 - Start
    property Currencycust          : string  read IdtCurrency
                                             write IdtCurrency;
    property VATNum                : string  read TxtNumVAT
                                             write TxtNumVAT;
    property CodeVAT               : string  read TxtPublDescr
                                             write TxtPublDescr;
    property InvoiceNum            : string  read QtyCopyInv
                                             write QtyCopyInv;
    //Ficha Cliente, TT, R2011.2 - End
    property CodCreator            : string  read TxtCodCreator
                                             write TxtCodCreator;
    property DateCreate            : TDateTime  read DatCreate                  //Ficha Cliente, TT, R2011.2
                                             write DatCreate;                   //Ficha Cliente, TT, R2011.2
    property DateModify            : TDateTime  read DatModify                  //Ficha Cliente, TT, R2011.2
                                             write DatModify;                   //Ficha Cliente, TT, R2011.2
    property FlgCheckVAT           : Boolean read FFlgCheckVAT
                                             write FFlgCheckVAT;
    property FlgVATRequired        : Boolean read FFlgVATRequired
                                             write FFlgVatRequired;
    property FlgDisableBonPassage  : Boolean read FFlgDisableBonPassage
                                             write FFlgDisableBonPassage;
    property FlgRussia             : Boolean read FFlgRussia
                                             write FFlgRussia;
    property FlgBDFR               : Boolean read FFlgBDFR                        //R2012.1 Address De Facturation
                                             write FFlgBDFR;
    property FlgDisableCredit      : Boolean read FFlgDisableCredit
                                             write FFlgDisableCredit;
    property FlgInvExp             : Boolean read FFlgInvExp
                                             write FFlgInvExp;
    property FlgCustCard           : Boolean read FFlgCustCard
                                             write FFlgCustCard;
    property FlgDelayDel           : Boolean read FFlgDelayDel
                                             write FFlgDelayDel;
    property FlgSiretNo            : Boolean read FFlagSiretNo                  //Siret No, Modified by TCS(KB), R2011.1
                                             write FFlagSiretNo;                //Siret No, Modified by TCS(KB), R2011.1
    property FlgCustomerSheet      : Boolean read FFlgCustomerSheet             //Ficha Cliente, TT, R2011.2
                                             write FFlgCustomerSheet;           //Ficha Cliente, TT, R2011.2
    property FlgMandatory          : Boolean read FFlgMandatory
                                             write FFlgMandatory;  //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)

    property FlgDisableTVAFrmSap          : Boolean read FFlgDisableTVAFrmSap
                                             write FFlgDisableTVAFrmSap;       //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
  end;   // of TFrmDetCustomerCA

  const                                                                         //Ficha Cliente, TT, R2011.2
  CtValModFormWidth = 668;               //Formwidth of the modified form       //Ficha Cliente, TT, R2011.2


var
  FrmDetCustomerCA: TFrmDetCustomerCA;
  DefaultCtryFlag : Boolean;                                                    //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
  EnterMunicipality :Boolean;                                                   //Internal defect fix (AM)

//*****************************************************************************

implementation

{$R *.DFM}

uses
  OvcData,
  StStrW,

  ScTskMgr_BDE_DBC,
  SfDialog,
  SmDbUtil_BDE,
  SmUtils,
  SrStnCom,

  RFpnCom,
  DFpnUtils,
  DFpnAddress,
  DFpnAddressCA,
  DFpnBonPassage,
  DFpnCustomer,
  DFpnCurrency,
  DFpnCustomerCA,
  DFpnMunicipality,
  DFpnMunicipalityCA,
  FBonPassageCA;
  // The change is commented as the flag is set from the maintenance file.
  //FMntCustomerCA; //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCustomerCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: $';
  CtTxtSrcVersion = '$Revision: 1.33 $';
  CtTxtSrcDate    = '$Date: 2012/02/15 13:10:40 $';

//*****************************************************************************
// Implementation of TFrmDetCustomerCA
//*****************************************************************************


function TFrmDetCustomerCA.GetIdentForSel : string;
begin  // of TFrmDetCustomerCA.GetIdentForSel
  Result := TxtRecName + ' ' +
            DscCustomer.DataSet.FieldByName ('IdtCustomer').Text + ' - ' +
            DscCustomer.DataSet.FieldByName ('TxtPublName').AsString;
end;   // of TFrmDetCustomerCA.GetIdentForSel

//=============================================================================

function TFrmDetCustomerCA.GetFldIdtTable : TField;
begin  // of TFrmDetCustomerCA.GetFldIdtTable
  Result := DscCustomer.DataSet.FieldByName ('IdtCustomer');
end;   // of TFrmDetCustomerCA.GetFldIdtTable

//=============================================================================

function TFrmDetCustomerCA.GetTxtMainTableName : string;
begin  // of TFrmDetCustomerCA.GetTxtMainTableName
  Result := 'Customer';
end;   // of TFrmDetCustomerCA.GetTxtMainTableName

//=============================================================================

procedure TFrmDetCustomerCA.SetDataSetReferences;
begin  // of TFrmDetCustomerCA.SetDataSetReferences
  inherited;
  DscCustomer.DataSet := DmdFpnCustomerCA.QryDetCustomer;
  DscAddress.DataSet := DmdFpnCustomerCA.QryDetCustAddress;
  DscAddInvoice.DataSet:= DmdFpnAddressCA.QryDetInvoice;                             //R2012.1 Address De Facturation (Test)
//R2011.2 - BDES - Creation Of Client Management of Post Code-Start
// If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin              //R2011.2 - BDES - Creation Of Client Management of Post Code-Start
If  FlgMandatory = True then begin              //R2011.2 - BDES - Creation Of Client Management of Post Code-Start
  DscMunicipalityFilter.DataSet := DmdFpnMunicipality.QryDetMunicipality;
 end;                                                                            
//R2011.2 - BDES - Creation Of Client Management of Post Code-End 
end;   // of TFrmDetCustomerCA.SetDataSetReferences
//=============================================================================
// TFrmDetCustomerCA.CheckIdtCustomerBeforeSave : checks if, when creating new
// customer, the customer not already exists.
//                                   ----
// Restrictions:
// - if the customer already exists, the appropriate field is focussed and
//   an exception is raised.
// - is called from AdjustDataBeforeSave, is provided as a separate virtual
//   method just to improve inheritance.
//=============================================================================

procedure TFrmDetCustomerCA.CheckIdtCustomerBeforeSave;
begin  // of TFrmDetCustomerCA.CheckIdtCustomerBeforeSave
  if (CodJob = CtCodJobRecNew) and (SvcDBLFIdtCustomer.AsString <> '') and
     (not FlgCurrentApplied) then begin
    if DmdFpnCustomerCA.CustomerExists (SvcDBLFIdtCustomer.AsInteger,
       DscCustomer.DataSet.FieldByName ('CodCreator').AsInteger) then begin
      if not SvcDBLFIdtCustomer.CanFocus then
        SvcDBLFIdtCustomer.Show;
      SvcDBLFIdtCustomer.SetFocus;
      raise Exception.Create (TrimTrailColon (SvcDBLblIdtCustomer.Caption) +
                              ' ' + Trim (SvcDBLFIdtCustomer.AsString) + ' ' +
                              CtTxtAlreadyExist);
    end;
  end;
end;   // of TFrmDetCustomerCA.CheckIdtCustomerBeforeSave

//=============================================================================
// TFrmDetCustomerCA.CheckNameBeforeSave : warn user when trying to save a
// nameless customer.
//                                   ----
// Restrictions:
// - if the name is empty, the appropriate field is focussed and
//   an exception is raised.
// - is called from AdjustDataBeforeSave, is provided as a separate virtual
//   method just to improve inheritance.
//=============================================================================

procedure TFrmDetCustomerCA.CheckNameBeforeSave;
begin  // of TFrmDetCustomerCA.CheckNameBeforeSave
  if not SvcDBMETxtPublName.Enabled then
    exit;

  if DscCustomer.DataSet.FieldByName ('TxtPublName').AsString = '' then begin
    if not SvcDBMETxtPublName.CanFocus then
      SvcDBMETxtPublName.Show;
    SvcDBMETxtPublName.SetFocus;
    raise Exception.Create
      (TrimTrailColon (SvcDBLblTxtPublName.Caption) + ' ' + CtTxtRequired);
  end;
//R2011.2 - BDES - Creation Of Client Management of Post Code-Start
//  if  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
if FlgMandatory = True then begin
  if  CodJob = CtCodJobRecNew then //If OK button is clicked
   begin
     If SvcDBMETxtStreet.TrimText = '' then                           //Internal defect fix (AM)-Start
    begin
       SvcDBMETxtStreet.SetFocus;
       raise Exception.Create(CtTxtStreet);
    end
    else if SvcDBMEMunicipalityTxtCodPost.TrimText = '' then
      begin
        SvcDBMEMunicipalityTxtCodPost.SetFocus;
        raise Exception.Create(CtTxtPostCode);
      end                                                             //Internal defect fix (AM)-End
    else If SvcDBMETxtProvince.TrimText = '' then begin
       SvcDBMETxtProvince.SetFocus;
       raise Exception.Create(CtTxtProvince);
     end
  else if (DBLkpCbxIdtMunicipality.Text= '')  then begin     //Bug Fix for Defect ID-38(R2011.2 Creation Of Client)-Start
      raise Exception.Create(CtTxtMunicipalityMessage);      //Internal defect fix (AM)
     AdjustLookupMunicipality (SvcDBMEMunicipalityTxtCodPost.TrimText);
   if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                       LookupDataSet).RecordCount > 1 then begin
     DBLkpCbxIdtMunicipality.DropDown;
   end;

   end                                                    //Bug Fix for Defect ID-38(R2011.2 Creation Of Client)-End
   else if EnterMunicipality  and (DBLkpCbxIdtMunicipality.Text<> '') and (TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                    LookupDataSet).RecordCount > 0 ) then begin            //Internal defect fix (AM)-Start
     EnterMunicipality := False;
    if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                       LookupDataSet).RecordCount > 1 then begin
     DBLkpCbxIdtMunicipality.DropDown;
     raise Exception.Create(CtTxtMunicipalityMessage);
    end;
   end;                                                                   //Internal defect fix (AM)-End
  end; // end of CodJob
 end;
//R2011.2 - BDES - Creation Of Client Management of Post Code-End 
end;   // of TFrmDetCustomerCA.CheckNameBeforeSave

//=============================================================================
// TFrmDetCustomerCA.CheckNumVATBeforeSave : checks if TxtNumVAT unique.
// If it is not, warn the user and allow changes.
//                                   ----
// Restrictions:
// - if the TxtNumVAT already exists, the user is only warned, can choose to
//   keep the duplicate NumVAT.
// - the TxtNumVAT is obligated and is validated with an algorithm (for italy)
// - is called from AdjustDataBeforeSave, is provided as a separate virtual
//   method just to improve inheritance.
//=============================================================================

procedure TFrmDetCustomerCA.CheckNumVATBeforeSave;
var
  IdtCustWithVAT   : Integer;          // IdtCustomer found for TxtNumVAT
  CodCreatorWithVAT: Integer;          // CodCreator found for TxtNumVAT
begin  // of TFrmDetCustomerCA.CheckNumVATBeforeSave
  IdtCustWithVAT    := DscCustomer.DataSet.FieldByName ('IdtCustomer').AsInteger;
  CodCreatorWithVAT := DscCustomer.DataSet.FieldByName ('CodCreator').AsInteger;
  if not SvcDBMETxtNumVAT.Enabled then
    exit;
  if (DscCustomer.DataSet.FieldByName ('TxtNumVAT').AsString <> '' )  //R2012.1 TCS SRAI FB 09
  and
  (DmdFpnCustomerCA.TxtNumVATExists (IdtCustWithVAT, CodCreatorWithVAT,
      DscCustomer.DataSet.FieldByName ('TxtNumVAT').AsString)) and
     (MessageDlg (TrimTrailColon (SvcDBLblTxtNumVAT.Caption) + ' ' +
      SvcDBMETxtNumVAT.Text + ' ' + CtTxtAlreadyExist + ' (' + TrimTrailColon
     (SvcDBLblIdtCustomer.Caption) + ' ' + IntToStr (IdtCustWithVAT) + ' - ' +
      DmdFpnCustomerCA.InfoCustomer[IdtCustWithVAT, CodCreatorWithVAT ,
      'TxtPublName'] + ')' + #10 + CtTxtConfirmDubiousChanges, mtInformation,
     [mbYes, mbNo], 0) <> mrYes) then begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    SvcDBMETxtNumVAT.SetFocus;
    raise EAbort.Create ('');
  end; // of if (DmdFpnCustomerCA.TxtNumVATExists (IdtCustWithVAT,...
  if FlgVatRequired then
    PerformChecksFlgVATRequired;
  if (CodJob in [CtCodJobRecNew, CtCodJobRecMod]) and FlgCheckVAT then
    PerformChecksFlgCheckVAT;
end;   // of TFrmDetCustomerCA.CheckNumVATBeforeSave

//=============================================================================

procedure TFrmDetCustomerCA.PerformChecksFlgVATRequired;
begin  // of TFrmDetCustomerCA.PerformChecksFlgVATRequired
  if length(SvcDBMETxtNumVAT.TrimText) = 16 then
    CheckVatAlphaNum(SvcDBMETxtNumVAT.Text)
  else if length(SvcDBMETxtNumVAT.TrimText) = 11 then
    CheckVatNum(SvcDBMETxtNumVAT.Text)
  else if length(SvcDBMETxtNumVAT.TrimText) = 0 then begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create
           (TrimTrailColon (SvcDBLblTxtNumVAT.Caption) + ' ' + CtTxtRequired);
  end // of else if length(SvcDBMETxtNumVAT.TrimText) = 0 s
  else begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create
            (TrimTrailColon (SvcDBLblTxtNumVAT.Caption) + ' ' + CtTxtInvalid);
  end; // of else begin
end;   // of TFrmDetCustomerCA.PerformChecksFlgVATRequired

//=============================================================================

procedure TFrmDetCustomerCA.PerformChecksFlgCheckVAT;
begin  // of TFrmDetCustomerCA.PerformChecksFlgCheckVAT
  TxtVATNumberToSave := '';
  TxtVATNumber := AnsiUpperCase(SvcDBMETxtNumVAT.Text);
//  if TxtVATNumber <> '' then begin
    if (Length (TxtVATNumber) > 1) then begin
      if (SameText (TxtVATNumber[1], 'N')) and (SameText (TxtVATNumber[2], 'E'))
      then
        TxtVATNumberToSave := Copy (TxtVATNumber, 3, Length (TxtVATNumber))
      else begin
        if not CheckFormatVAT then begin
          if not SvcDBMETxtNumVAT.CanFocus then
            SvcDBMETxtNumVAT.Show;
          ActiveControl := SvcDBMETxtNumVAT;
          raise Exception.Create (CtTxtErrVATFormatInvalid);
        end // of if not CheckFormatVAT (VATNumber)
        else
          TxtVATNumberToSave := TxtVATNumber;
      end; // of else begin
    end // of if (Length (TxtVATNumber) > 1)
    else begin
      if not SvcDBMETxtNumVAT.CanFocus then
        SvcDBMETxtNumVAT.Show;
       ActiveControl := SvcDBMETxtNumVAT;
       raise Exception.Create (CtTxtErrVATFormatInvalid);
    end; // of else begin
 // end; // of if TxtVATNumber <> ''
end; // of TFrmDetCustomerCA.PerformChecksFlgCheckVAT

//=============================================================================

function TFrmDetCustomerCA.CheckFormatVAT : Boolean;
var
  NumCount         : Integer;          // Integer for loop
  CountLetter      : Integer;          // Count letters in VAT number
  CountNumber      : Integer;          // Count numbers in VAT number
begin  // of TFrmDetCustomerCA.PerformChecksFlgCheckVAT
  Result      := False;
  CountNumber := 0;
  CountLetter := 0;
  if (Length (TxtVATNumber) = 9) then begin
    if (TxtVATNumber[1] in ['A'..'Z'])  then
      CountLetter := CountLetter + 1;
    if (TxtVATNumber[Length (TxtVATNumber)] in ['A'..'Z']) then
      CountLetter := CountLetter + 1;
    for NumCount := 1 to Length (TxtVATNumber) do begin
      if TxtVATNumber[NumCount] in ['0'..'9'] then
        CountNumber := CountNumber + 1;
    end;
  end;
  if ((CountLetter = 1) and (CountNumber = 8)) or
     ((CountLetter = 2) and (CountNumber = 7)) then
    Result := True;
end;   // of TFrmDetCustomerCA.PerformChecksFlgCheckVAT

//=============================================================================
// TFrmDetCustomerCA.FillFields : make sure that all fields that may not be
// Null have a valid value
//=============================================================================

procedure TFrmDetCustomerCA.FillFields;
begin  // of TFrmDetCustomerCA.FillFields
   DscCustomer.DataSet.FieldByName('CodClaus').Text := '1';
   DscCustomer.Dataset.Post;
   DscAddress.DataSet.FieldByName('IdtCustomer').Text :=
               DscCustomer.DataSet.FieldByName('IdtCustomer').Text;
   DscAddress.DataSet.FieldByName('CodCreator').Text :=
               DscCustomer.DataSet.FieldByName('CodCreator').Text;
   DscAddress.DataSet.FieldByName('TxtName').Text := SvcDBMETxtPublName.Text;
   DscAddress.DataSet.FieldByName('IdtLanguage').Text :=
                                             DmdFpnUtils.IdtLanguageTradeMatrix;
   DscAddress.DataSet.FieldByName('IdtAddress').Text :=
                 IntToStr(DmdFpnUtils.GetNextCounter ('Address', 'IdtAddress'));
   DscAddress.DataSet.Post;
end;    // of TFrmDetCustomerCA.FillFields

//=============================================================================
// TFrmDetCustomerCA.StatusValCreditLim : Enable fields when checkbox is
// checked, disable when unchecked.
//=============================================================================

procedure TFrmDetCustomerCA.StatusValCreditLim;
begin  // of TFrmDetCustomerCA.StatusValCreditLim
  if FlgDisableCredit then begin
    SvcDBLblValCreditLim.Enabled := False;
    LblIdtCurrency.Enabled := False;
    SvcDBLFValCreditLim.Enabled := False;
    DBCbxFlgCreditLim.Enabled := False;
  end
  else begin
    If not DBCbxFlgCreditLim.Checked then begin
      SvcDBLblValCreditLim.Enabled := False;
      LblIdtCurrency.Enabled := False;
      SvcDBLFValCreditLim.Enabled := False;
    end
    else begin
      SvcDBLblValCreditLim.Enabled := True;
      LblIdtCurrency.Enabled := True;
      SvcDBLFValCreditLim.Enabled := True;
    end;
  end;
end;    // of TFrmDetCustomerCA.StatusValCreditLim

//=============================================================================
// TFrmDetCustomerCA.StatusClientMarketing : Enable/Disable fields depending
// on client marketing flag.
//=============================================================================

procedure TFrmDetCustomerCA.StatusClientMarketing;
var
  CntControl       : integer;          // Counter for controls
begin  // of TFrmDetCustomerCA.StatusClientMarketing
  if DmdFpnCustomerCA.FlgClientMarketing then begin
    for CntControl := 0 to GbxFlgAddress.ControlCount - 1 do
      DisableControl (GbxFlgAddress.Controls[CntControl]);
    for CntControl := 0 to GbxFlgActive.ControlCount - 1 do
      DisableControl (GbxFlgActive.Controls[CntControl]);
    for CntControl := 0 to PnlInfo.ControlCount - 1 do
      DisableControl (PnlInfo.Controls[CntControl]);
  end;
end;    // of TFrmDetCustomerCA.StatusClientMarketing

//=============================================================================
// TFrmDetCustomerCA.AdjustBtnsCustCard : Enables/Disables CustCard-buttons
// according to the started job, current active row in DBGrdCustCard, ...
//=============================================================================

procedure TFrmDetCustomerCA.AdjustBtnsCustCard;
begin  // of TFrmDetCustomerCA.AdjustBtnsCustCard
  ChangeCtlForDBGrid (DBGrdCustCard, CtCodJobRecNew, BtnNewCustCard);
  ChangeCtlForDBGrid (DBGrdCustCard, CtCodJobRecMod, BtnEditCustCard);
  ChangeCtlForDBGrid (DBGrdCustCard, CtCodJobRecDel, BtnRemoveCustCard);
  ChangeCtlForDBGrid (DBGrdCustCard, CtCodJobRecCons, BtnConsultCustCard);
end;   // of TFrmDetCustomerCA.AdjustBtnsCustCard

//=============================================================================
// TFrmDetCustomerCA - Overriding methods
//=============================================================================

procedure TFrmDetCustomerCA.AdjustDataBeforeSave;
begin  // of TFrmDetCustomerCA.AdjustDataBeforeSave
  inherited;
  CheckIdtCustomerBeforeSave;
  CheckNameBeforeSave;
  CheckNumVATBeforeSave;
  if FlgSiretNo = True then                                                     //Siret No, Modified by TCS(KB), R2011.1
  CheckSiretBeforeSave;                                                         //Siret No, Modified by TCS(KB), R2011.1
  if CodJob = CtCodJobRecNew then
    FillFields
  else if (CodJob = CtCodJobRecMod) and
          (length(DscAddress.DataSet.FieldByName('IdtCustomer').Text) = 0) then
  begin
    DscAddress.DataSet.Edit;
    DscAddress.DataSet.FieldByName('IdtCustomer').Text :=
               DscCustomer.DataSet.FieldByName('IdtCustomer').Text;
    DscAddress.DataSet.FieldByName('CodCreator').Text :=
               DscCustomer.DataSet.FieldByName('CodCreator').Text;
    DscAddress.DataSet.FieldByName('TxtName').Text := SvcDBMETxtPublName.Text;
    DscAddress.DataSet.FieldByName('IdtLanguage').Text :=
                                             DmdFpnUtils.IdtLanguageTradeMatrix;
    DscAddress.DataSet.FieldByName('IdtAddress').Text :=
                 IntToStr(DmdFpnUtils.GetNextCounter ('Address', 'IdtAddress'));
    DscAddress.DataSet.Post;
  end // of else if (CodJob = CtCodJobRecMod)
  else if (CodJob = CtCodJobRecMod) and
          (length(DscAddress.DataSet.FieldByName('IdtCustomer').Text) > 0) then
  begin
    DscAddress.DataSet.Edit;
    DscAddress.DataSet.FieldByName('TxtName').Text := SvcDBMETxtPublName.Text;
    DscAddress.DataSet.Post;
  end; // of else if (CodJob = CtCodJobRecMod)
  if FlgVatRequired then begin
    DscCustomer.DataSet.Edit;
    DscCustomer.DataSet.FieldByName('TxtNumVat').Text :=
               AnsiUpperCase(DscCustomer.DataSet.FieldByName('TxtNumVat').Text);
    DscCustomer.DataSet.Post;
  end; // of if FlgVatRequired
end;   // of TFrmDetCustomerCA.AdjustDataBeforeSave

//=============================================================================
// TFrmDetCustomerCA.IsDataChanged : overriden to adjust the local currency and
// currency-values to the main currency BEFORE inherited IsDataChanged is
// called. We need to do this to avoid getting a message concerning changed
// data, if we did no other changes than changing the main currency and
// currency-values to the local currency.
//=============================================================================

function TFrmDetCustomerCA.IsDataChanged : Boolean;
var
  ValCreditLim     : Currency;         // Save ValCredLim
begin  // of TFrmDetCustomerCA.IsDataChanged
  if DmdFpnUtils.EuroFaseIsEuroToLocal and
     (AnsiCompareText (DscCustomer.DataSet.FieldByName ('IdtCurrency').AsString,
                   DmdFpnUtils.IdtCurrencyLocal) = 0) then
     begin
    ValCreditLim := DscCustomer.DataSet.FieldByName ('ValCreditLim').AsCurrency;
    try
      // Convert to main currency
      DscCustomer.DataSet.Edit;
      DscCustomer.DataSet.FieldByName ('IdtCurrency').AsString :=
        DmdFpnUtils.IdtCurrencyMain;
      DscCustomer.DataSet.FieldByName ('ValCreditLim').AsCurrency :=
        DmdFpnUtils.CalcCurrLocalToMain (ValCreditLim);

      Result := inherited IsDataChanged;
    finally
      // Restore local currency
      DscCustomer.DataSet.Edit;
      DscCustomer.DataSet.FieldByName ('IdtCurrency').AsString :=
        DmdFpnUtils.IdtCurrencyLocal;
      DscCustomer.DataSet.FieldByName ('ValCreditLim').AsCurrency :=
        ValCreditLim;
      DscCustomer.DataSet.Post;
    end;
  end
  else
    Result := inherited IsDataChanged;
end;   // of TFrmDetCustomerCA.IsDataChanged

//=============================================================================
// TFrmDetCustomerCA.AdjustLookupMunicipality: Makes some components
// visible or invisible depending on the level of classification.
//=============================================================================

procedure TFrmDetCustomerCA.AdjustLookupMunicipality (TxtCodPost : string);
begin  // of TFrmDetCustomerCA.AdjustLookupMunicipality
 if FlgMandatory = True then                          //Internal defect fix (AM)
  DBLkpCbxIdtMunicipality.CloseUp(true);              //Internal defect fix (AM)

  if Trim (TxtCodPost) <> '' then begin
    TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                  LookupDataSet).Active := False;

    TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                  LookupDataSet).ParamByName ('@PrmTxtSequence').Text :=
      'TxtCodPost';
    TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                  LookupDataSet).ParamByName ('@PrmTxtFrom').Text := TxtCodPost;

    TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                  LookupDataSet).ParamByName ('@PrmTxtTo').Text := TxtCodPost;

    TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                  LookupDataSet).Active := True;
  end;

  if (not (CodJob in [CtCodJobRecCons, CtCodJobRecDel])) and
     (Trim (TxtCodPost) <> '') then
    EnableControl (DBLkpCbxIdtMunicipality)
  else
    DisableControl (DBLkpCbxIdtMunicipality);
  if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                    LookupDataSet).RecordCount < 2 then
    DisableControl (DBLkpCbxIdtMunicipality);
end;   // of TFrmDetCustomerCA.AdjustLookupMunicipality

//=============================================================================

procedure TFrmDetCustomerCA.FillQuery (QryToFill : TQuery);
begin  // of TFrmDetCustomerCA.FillQuery
  if QryToFill = DscCustomer.DataSet then begin
    if CodJob = CtCodJobRecNew then begin
      QryToFill.ParamByName ('PrmIdtCustomer').Clear;
      QryToFill.ParamByName ('PrmCodCreator').Clear;
    end
    else begin
      QryToFill.ParamByName ('PrmIdtCustomer').Text :=
        StrLstIdtValues.Values['IdtCustomer'];
      QryToFill.ParamByName ('PrmCodCreator').Text :=
        StrLstIdtValues.Values['CodCreator'];
    end;
  end
end;   // of TFrmDetCustomerCA.FillQuery

//=============================================================================

procedure TFrmDetCustomerCA.FillStoredProc (SprToFill : TStoredProc);
begin  // of TFrmDetCustomerCA.FillStoredProc
  if (SprToFill = DscAddress.DataSet) or
     (SprToFill = DscLstCustCard.DataSet) then begin
    SprToFill.ParamByName ('@PrmTxtFrom').Text :=
      DscCustomer.DataSet.FieldByName ('IdtCustomer').Text;
    SprToFill.ParamByName ('@PrmTxtTo').Text :=
      DscCustomer.DataSet.FieldByName ('IdtCustomer').Text;
    SprToFill.ParamByName ('@PrmTxtCondition').Text :=
      'CodCreator = ' + DscCustomer.DataSet.FieldByName ('CodCreator').Text;
  end;
end;   // of TFrmDetCustomerCA.FillStoredProc

//=============================================================================

procedure TFrmDetCustomerCA.PrepareFormDependJob;
begin  // of TFrmDetCustomerCA.PrepareFormDependJob
  try
    inherited;
    // Give focus to a control according to the started job
    if not (CodJob in [CtCodJobRecDel, CtCodJobRecCons]) then
      if CodJob = CtCodJobRecNew then
        ActiveControl := SvcDBLFIdtCustomer
      else
        ActiveControl := SvcDBMETxtPublName;
    if CodJob = CtCodJobRecMod then
      DisableControl (SvcDBLFIdtCustomer);
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCustomerCA.PrepareFormDependJob

//=============================================================================

procedure TFrmDetCustomerCA.PrepareDataDependJob;
begin  // of TFrmDetCustomerCA.PrepareDataDependJob
  try
    inherited;
    // Show currency abbreviation
    LblIdtCurrency.Caption :=
      DscCustomer.DataSet.FieldByName ('IdtCurrency').AsString;
    LblIdtCurrencyValSale.Caption := LblIdtCurrency.Caption;
    AdjustDependCurrency (DmdFpnCurrency.InfoCurrAssort
                            [LblIdtCurrency.Caption,
                             DmdFpnUtils.IdtTradeMatrixAssort, 'QtyDecim']);
    // Show related information, fetched together with the main info
    SvcMECustPrcCatTxtExplanation.TrimText :=
      DscCustomer.DataSet.FieldByName ('CustPrcCatTxtExplanation').Text;
    if CodJob = CtCodJobRecNew then
      DscCustomer.DataSet.FieldByName('CodCreator').AsInteger := CtCodCreatorFO;
    // Enable/disable Bon de Passage buttons
    if ((CodJob = CtCodJobRecCons) or (CodJob = CtCodJobRecMod)) and
       (not FlgDisableBonPassage) then begin
       btnBonPassage.Visible := True;
       btnReprint.Visible := True;
    end
    else begin
       BtnBonPassage.Visible := False;
       BtnReprint.Visible := False;
    end;
    if CodJob <> CtCodJobRecNew then begin
       // Link Address with Customer
       DmdFpnCustomerCA.QryDetCustAddress.Active := False;
       DmdFpnCustomerCA.QryDetCustAddress.ParamByName('PrmIdtAddress').AsString :=
         DscCustomer.DataSet.FieldByName('AddressIdtAddress').AsString;
       DmdFpnCustomerCA.QryDetCustAddress.Active := True;
       DscAddress.DataSet := DmdFpnCustomerCA.QryDetCustAddress;
       ActivateDataSet(DscAddress.dataset);
       //R2012.1 Address De Facturation (SM) ::START
       DmdFpnAddressCA.QryDetInvoice.Active := False;
       DmdFpnAddressCA.QryDetInvoice.ParamByName('PrmIdtAddressSM').AsString :=
         DscCustomer.DataSet.FieldByName('AddressIdtAddress').AsString;
       DmdFpnAddressCA.QryDetInvoice.ParamByName('PrmIdtCustomer').AsString :=
         DscCustomer.DataSet.FieldByName('IdtCustomer').AsString;
       DmdFpnAddressCA.QryDetInvoice.Active := True;
       ActivateDataSet(DscAddInvoice.dataset);
       //R2012.1 Address De Facturation (SM) ::END
    end
    else begin
       // Activate Address
       DmdFpnCustomerCA.QryDetCustAddress.Active := True;
       DmdFpnCustomerCA.QryDetCustAddress.Insert;
       DmdFpnAddressCA.QryDetInvoice.Active:= False;                                  //R2012.1 Address De Facturation (SM)
       DscAddress.DataSet := DmdFpnCustomerCA.QryDetCustAddress;
       ActivateDataSet(DscAddress.dataset);
    end;
    if CodJob = CtCodJobRecNew then
      SvcDBLFQtyCopyInv.Text := '1';
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;
end;   // of TFrmDetCustomerCA.PrepareDataDependJob

//=============================================================================
// TFrmDetCustomerCA.AdjustDependCurrency : Adjust the currency fields format's
// to the given number of decimals.
//                                   ----
// INPUT   : QtyDecim = Number of decimals to build format.
//=============================================================================

procedure TFrmDetCustomerCA.AdjustDependCurrency (QtyDecim : Integer);
begin  // of TFrmDetCustomerCA.AdjustCurrencyFields
   SvcDBLFValCreditLim.FloatDecimals := QtyDecim;
end;   // of TFrmDetCustomerCA.AdjustDependCurrency

//=============================================================================
// TFrmDetCustomerCA - Event Handlers
//=============================================================================

procedure TFrmDetCustomerCA.FormCreate(Sender: TObject);
begin  // of TFrmDetCustomerCA.FormCreate
  try
    inherited;
    //Added for Defect Fix 173 - Teesta(TCS) - Start
    //self.Caption := CtTxtFrmCaption;
    //Added for Defect Fix 173 - Teesta(TCS) - End
    LstDstStartUp.Add (DscCustomer.DataSet);
    LstDstStartUp.Add (DscAddInvoice.DataSet);                                   //R2012.1 Address De Facturation (SM)

    // Set button 'select municipality' invisible if ListTask is disabled
    BtnSelectMunicipality.Visible :=
      SvcTaskMgr.IsTaskEnabled ('ListMunicipalityForAddress');

    // Copy stored procedure - list CustCard
    DscLstCustCard.DataSet :=
      CopyStoredProc (Self, 'SprRTLstCustCard', DmdFpnUtils.SprLstTable,
                      ['@PrmTxtTable=CustCard',
                       '@PrmTxtArrFields=NumCard;CodCustCardAsTxtShort;' +
                       'DatExpire',
                       '@PrmTxtSequence=IdtCustomer =;TxtSrcNumCard']);
    AdjustColorDBGrdTitle (DBGrdCustCard, ['NumCard']);

//    If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then                //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
      If  FlgMandatory = True then                //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)
      LstDstStartUp.Add (DscMunicipalityFilter.DataSet);                        //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)

except
     DisableParentChildCtls (Self);
     EnableControl (BtnCancel);
     raise;
end;   // of try ... except block

end;   // of TFrmDetCustomerCA.FormCreate

//=============================================================================

procedure TFrmDetCustomerCA.FormActivate(Sender: TObject);
var
 FlgCustInfFromSAP :Boolean;                          //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte
begin  // of TFrmDetCustomerCA.FormActivate
  try
    inherited;
    BtnCustomerSheet.Caption := CtTxtCustDataSheet;
    if FlgInvExp then begin
      SvcDBLblNumInvExpDays.Visible := True;
      SvcDBLFNumInvExpDays.Visible := True;
    end;
    AdjustDBLkpCbxDDR (DBLkpCbxCodVATSystem);
    StatusValCreditLim;
    StatusSiretNo;                                                      // Siret No, Modified by TCS(KB), R2011.1

    //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte--start
    //This section is added to disable NumVat feild when customer data comes from SAP
    if FlgDisableTVAFrmSap then begin
     if (DscCustomer.DataSet.FieldByName('CodCreator').AsInteger) = 4 then
      FlgCustInfFromSAP := True;
     if FlgCustInfFromSAP then begin
      SvcDBMETxtNumVAT.Enabled  := False ;
      SvcDBMEtxtSiretNo.Enabled := False ;
     end;
    end;

    //TCS Modification-R2012.1-5401-BRFR-Flux_des_clients_en_compte--end

    // Enanble/disable LookupComboboxMunicipality
    if not (CodJob in [CtCodJobRecCons, CtCodJobRecDel]) then begin
      EnableControl (DBLkpCbxIdtMunicipality);
      if DBCbxFlgCreditLim.Checked and not FlgDisableCredit then begin
        SvcDBLblValCreditLim.Enabled := True;
        LblIdtCurrency.Enabled := True;
        SvcDBLFValCreditLim.Enabled := True;
      end;
    end
    else begin
      DisableControl (DBLkpCbxIdtMunicipality);
      SvcDBLFValCreditLim.Enabled := False;
    end;
    if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                      LookupDataSet).RecordCount < 2 then
      DisableControl (DBLkpCbxIdtMunicipality);
    if CodJob in [CtCodJobRecCons, CtCodJobRecDel, CtCodJobRecMod] then
      AdjustLookupMunicipality(SvcDBMEMunicipalityTxtCodPost.Text);
    if FlgRussia then
      GbxFlgRussia.Visible := True
    else
      GbxFlgRussia.Hide;
    //Ficha Cliente, TT, R2011.2 - Start
    if FlgCustomerSheet then
    begin
      BtnCustomerSheet.Visible := True;
      if (CodJob in [CtCodJobRecNew]) then
        DisableControl (BtnCustomerSheet);
      if (CodJob in [CtCodJobRecMod]) then
        EnableControl (BtnCustomerSheet);
      if (CodJob in [CtCodJobRecCons]) then
        EnableControl (BtnCustomerSheet);
    end
    else
      width := CtValModFormWidth;
    //Ficha Cliente, TT, R2011.2 - End
    //R2012.1 Address De Facturation (SM) ::START
    if FlgBDFR then
     GbxFlgAddress.Caption:=CtTxtGenAddCaption
    else
     BDFRGroupBox.Visible :=False;
     //R2012.1 Address De Facturation (SM) :: END
    StatusClientMarketing;
    TabShtCustCard.TabVisible := FFlgCustCard;
    GbxValSale.Visible := FFlgCustCard;
    GbxIdtCustPrcCat.Visible := FFlgCustCard;
    SvcDBMETxtPublName.SelectAll;
    if not FlgDelayDel then begin
      DfpncustomerCA.DmdFpnCustomerCA.UpdSQLCustomer.DeleteSQL.Text :=
      'delete from Customer ' +
      'where' +
      '  IdtCustomer = :OLD_IdtCustomer and' +
      '  CodCreator = :OLD_CodCreator ';

    end;
  except
    DisableParentChildCtls (Self);
    EnableControl (BtnCancel);
    raise;
  end;   // of try ... except block
end;   // of TFrmDetCustomerCA.FormActivate

//=============================================================================

procedure TFrmDetCustomerCA.BtnAddOnClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.BtnAddOnClick
  // Info fields
  StrLstRelatedInfo.Clear;
  StrLstRelatedInfo.Add
    ('Info=' + DscCustomer.DataSet.FieldByName ('TxtPublName').AsString);
  inherited;
end;   // of TFrmDetCustomerCA.BtnAddOnClick

//=============================================================================

procedure TFrmDetCustomerCA.BtnSelectMunicipalityClick(Sender: TObject);
begin  // begin of TFrmDetCustomerCA.BtnSelectMunicipalityClick
  DefaultCtryFlag := True;  //R2011.2 - BDES - Creation Of Client Management of Post Code(AM)


  inherited;
  StrLstRelatedIdt.Clear;
  StrLstRelatedInfo.Clear;
  StrLstRelatedIdt.Add ('IdtMunicipality=');
  if not DscAddress.DataSet.FieldByName ('IdtMunicipality').IsNull then
    BuildStrLstFldValues (StrLstRelatedIdt, DscAddress.DataSet);
  if SvcTaskMgr.LaunchTask ('ListMunicipalityForAddress') then begin
    DscAddress.Dataset.Edit;
    DscAddress.DataSet.FieldByName ('IdtMunicipality').Text :=
      StrLstRelatedIdt.Values['IdtMunicipality'];
    SvcDBMEMunicipalityTxtCodPost.Text := StrLstRelatedInfo.Values['TxtCodPost'];
    SvcDBMETxtCountry.Text :=
      StrLstRelatedInfo.Values['TxtNameCountry'];
    AdjustLookupMunicipality (StrLstRelatedInfo.Values['TxtCodPost']);
    DmdFpnCustomerCA.QryDetCustAddress.FieldByName('MunicipalityTxtCodPost').
      AsString := SvcDBMEMunicipalityTxtCodPost.Text;
    DmdFpnCustomerCA.QryDetCustAddress.FieldByName('CountryTxtName').AsString :=
                                            SvcDBMETxtCountry.Text;
  end;
end;   // of TFrmDetCustomerCA.BtnSelectMunicipalityClick

//=============================================================================

procedure TFrmDetCustomerCA.btnBonPassageClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.btnBonPassageClick
  inherited;
    Customer     := SvcDBLFIdtCustomer.Text;
    Name         := SvcDBMETxtPublName.Text;
    Address      := SvcDBMETxtStreet.Text;
    PostalCode   := SvcDBMEMunicipalityTxtCodPost.Text;
    Municipality := DBLkpCbxIdtMunicipality.Text;
    Amount       := SvcDBLFValCreditLim.Text;
    CodCreator   := DscCustomer.DataSet.FieldByName ('CodCreator').Text;
    SvcTaskMgr.LaunchTask ('BonPassage');
end;   // of TFrmDetCustomerCA.btnBonPassageClick

//=============================================================================

procedure TFrmDetCustomerCA.btnReprintClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.btnReprintClick
  inherited;
    Customer     := SvcDBLFIdtCustomer.Text;
    Name         := SvcDBMETxtPublName.Text;
    Address      := SvcDBMETxtStreet.Text;
    PostalCode   := SvcDBMEMunicipalityTxtCodPost.Text;
    Municipality := DBLkpCbxIdtMunicipality.Text;
    Amount       := SvcDBLFValCreditLim.Text;
    SvcTaskMgr.LaunchTask ('ReprintBonPassage');
end;   // of TFrmDetCustomerCA.btnReprintClick

//=============================================================================

procedure TFrmDetCustomerCA.DBCbxFlgCreditLimClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.DBCbxFlgCreditLimClick
  inherited;
  StatusValCreditLim;
end;   // of TFrmDetCustomerCA.DBCbxFlgCreditLimClick

//=============================================================================

procedure TFrmDetCustomerCA.InCloseQueryCanDelete;
begin  // of TFrmDetCustomerCA.InCloseQueryCanDelete
  // Check if no BonPassage items exist for the client
  //Commented Srai FB 11 Start
 (*
  DmdFpnBonPassage.QryDetBonPassage.Active := False;
   DmdFpnBonPassage.QryDetBonPassage.ParamByName('PrmIdtCustomer').Text :=
     SvcDBLFIdtCustomer.Text;
   DmdFpnBonPassage.QryDetBonPassage.Active := True;
   if DmdFpnBonPassage.QryDetBonPassage.RecordCount <> 0 then begin
     MessageDlg (CtTxtErrDelBonPassage, mtInformation, [mbOK], 0);
     ModalResult := mrCancel;
     Exit;
   end;
   *)
  //Commented Srai FB 11 End
 //Srai FB 11 Start
   DmdFpnBonPassage.QryExpBonPassage.Active := False;
   DmdFpnBonPassage.QryExpBonPassage.ParamByName('IdtCustomer').Text :=
     SvcDBLFIdtCustomer.Text;
   try
   DmdFpnBonPassage.QryExpBonPassage.open;
   DmdFpnBonPassage.QryExpBonPassage.Active := True;
   except
   on e : exception do
   begin
        ShowMessage(e.Message);
   end;
   end;
   if DmdFpnBonPassage.QryExpBonPassage.RecordCount <> 0 then begin
     MessageDlg (CtTxtErrDelBonPassage, mtInformation, [mbOK], 0);
     ModalResult := mrCancel;
     Exit;
   end
   else
   begin


   end;
   //Srai FB 11 End

end;   // of TFrmDetRunningTextDK.InCloseQueryCanDelete

//=============================================================================

procedure TFrmDetCustomerCA.BtnApplyClick(Sender: TObject);
begin
  inherited;
  if not FlgDisableBonPassage then begin
    btnBonPassage.Visible := True;
    btnReprint.Visible := True;
  end;
  if FlgCustomerSheet then                                                      //Ficha Cliente, TT, R2011.2
    BtnCustomerSheet.Enabled:=True;                                             //Ficha Cliente, TT, R2011.2
end;

//=============================================================================
// Function to check VAT number (alphanumeric).
//=============================================================================

procedure TFrmDetCustomerCA.CheckVatAlphaNum(VatNumber: String);
const
  SetDisp : array [0..25] of Integer = (1, 0, 5, 7, 9, 13, 15, 17, 19, 21, 2, 4,
                                        18, 20, 11, 3, 6, 8, 12, 14, 16, 10, 22,
                                        25, 24, 23);
var
  i, n, s : Integer;
  VatNum2 : string;
begin  // of TFrmDetCustomerCA.CheckVatAlphaNum
  VatNum2 := AnsiUpperCase(VatNumber);
  for I:=1 to 16 do if not(((VatNum2[I]>='0')and(VatNum2[I]<='9'))or
          ((VatNum2[I]>='A')and(VatNum2[I]<='Z'))) then begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create (CtTxtErrVatAlphaNumeric);
    Exit;
  end;

  s := 0;
  for I:=2 to 14 do if not Odd(I) then begin
    n := Ord(VatNum2[I]);
    if ((VatNum2[I]>='0')And(VatNum2[I]<='9'))then
      s := s + n - Ord('0')
    else
      s := s + n - Ord('A');
  end;

  for I:=1 to 15 do If Odd(I) then begin
     n := Ord(VatNum2[I]);
     if ((VatNum2[I]>='0')and(VatNum2[I]<='9')) then
       n := n - Ord('0') + Ord('A');
     s := s + SetDisp[n-Ord('A')];
  end;

  n := (s Mod 26) + Ord('A');

  if Chr(n)<>VatNum2[16] then begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create (CtTxtErrVatInvalid);
    Exit;
  end;
end;   // of TFrmDetCustomerCA.CheckVatAlphaNum

//=============================================================================

procedure TFrmDetCustomerCA.CheckVatNum(VatNumber: String);
var
  i, c, s          : Integer;
begin  // of TFrmDetCustomerCA.CheckVatNum
  for I:=1 to 11 do if (VatNumber[i]<'0')or(VatNumber[i]>'9') then begin
    if not SvcDBMETxtNumVAT.CanFocus then
          SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create (CtTxtErrVatNumeric);
    Exit;
  end;

  s:=0;
  for I:=1 to 10 do
    if Odd(I) then s:=s+StrToInt(VatNumber[I]);

  for I:=1 to 10 do if not Odd(I) then begin
     c:=2*StrToInt(VatNumber[I]);
     if c>9 then c:=c-9;
     s:=s+c;
  end;

  c:=s Mod 10;
  c:=(10-c) Mod 10;

  if StrToInt(VatNumber[11])<>c then begin
    if not SvcDBMETxtNumVAT.CanFocus then
      SvcDBMETxtNumVAT.Show;
    ActiveControl := SvcDBMETxtNumVAT;
    raise Exception.Create (CtTxtErrVatInvalid);
    Exit;
  end;
end;   // of TFrmDetCustomerCA.CheckVatNum

//=============================================================================

procedure TFrmDetCustomerCA.DBLkpCbxIdtMunicipalityEnter(Sender: TObject);
begin // of TFrmDetCustomerCA.DBLkpCbxIdtMunicipalityEnter
  inherited;
  if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                    LookupDataSet).RecordCount > 1 then
    DBLkpCbxIdtMunicipality.DropDown;
end; // of TFrmDetCustomerCA.DBLkpCbxIdtMunicipalityEnter

//=============================================================================

procedure TFrmDetCustomerCA.BtnCustCardClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.BtnCustCardClick
  inherited;

  // Idt-fields
  StrLstRelatedIdt.Clear;
  StrLstRelatedIdt.Add
    ('NumCard=' + DscLstCustCard.DataSet.FieldByName ('NumCard').Text);

  // Code Job
  if Sender = BtnNewCustCard then
    CodJobRelatedForm := CtCodJobRecNew
  else if Sender = BtnEditCustCard then
    CodJobRelatedForm := CtCodJobRecMod
  else if Sender = BtnConsultCustCard then
    CodJobRelatedForm := CtCodJobRecCons
  else if Sender = BtnRemoveCustCard then
    CodJobRelatedForm := CtCodJobRecDel;

  // Info fields
  StrLstRelatedInfo.Clear;
  StrLstRelatedInfo.Add ('IdtCustomer=');
  StrLstRelatedInfo.Add ('CodCreator=');
  StrLstRelatedInfo.Add ('TxtPublName=');
  BuildStrLstFldValues (StrLstRelatedInfo, DscCustomer.DataSet);

  // Launch Task
  if SvcTaskMgr.LaunchTask ('DetailCustCard') then begin
    if Sender = BtnNewCustCard then begin
      RefreshDBGrid (DBGrdCustCard, ['']);
      if StrLstRelatedIdt.Values['NumCard'] <> '' then
        DscLstCustCard.DataSet.Locate
          ('NumCard', StrLstRelatedIdt.Values['NumCard'], []);
    end
    else if Sender = BtnEditCustCard then
      RefreshDBGrid (DBGrdCustCard, ['NumCard'])
    else if Sender = BtnRemoveCustCard then begin;
      // Reposition
      DscLstCustCard.DataSet.Next;
      if DscLstCustCard.DataSet.EOF then
        DscLstCustCard.DataSet.Prior;
    end;
    // Refresh
    RefreshDBGrid (DBGrdCustCard, ['NumCard']);
    AdjustBtnsCustCard;
  end;
end;   // of TFrmDetCustomerCA.BtnCustCardClick

//=============================================================================

procedure TFrmDetCustomerCA.DBGrdCustCardDblClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.DBGrdCustCardDblClick
  inherited;
  ExecCmpClick ([BtnEditCustCard, BtnConsultCustCard]);
end;   // of TFrmDetCustomerCA.DBGrdCustCardDblClick

//=============================================================================

procedure TFrmDetCustomerCA.DBGrdCustCardTitleClick(Column: TColumn);
begin  // of TFrmDetCustomerCA.DBGrdCustCardTitleClick
  inherited;

  if DscLstCustCard.DataSet.IsEmpty then
    Exit;

  if Column.FieldName = 'NumCard' then begin
    TStoredProc(DscLstCustCard.DataSet).ParamByName ('@PrmTxtSequence').Text :=
      'IdtCustomer ;NumCard';
  end
  else if Column.FieldName = 'CodCustCardAsTxtChcShort' then begin
    TStoredProc(DscLstCustCard.DataSet).ParamByName ('@PrmTxtSequence').Text :=
      'IdtCustomer =;CodCustCard';
  end
  else if Column.FieldName = 'DatExpire' then begin
    TStoredProc(DscLstCustCard.DataSet).ParamByName ('@PrmTxtSequence').Text :=
      'IdtCustomer =;DatExpire';
  end
  else
    Exit;

  RefreshDBGrid (DBGrdCustCard, ['NumCard']);
  AdjustColorDBGrdTitle (DBGrdCustCard, [Column.FieldName]);
end;   // of TFrmDetCustomerCA.DBGrdCustCardTitleClick

//=============================================================================

procedure TFrmDetCustomerCA.SvcDBMEMunicipalityTxtCodPostPropertiesValidate(
  Sender: TObject; var DisplayValue: Variant; var ErrorText: TCaption;
  var Error: Boolean);
begin // of TFrmDetCustomerCA.SvcDBMEMunicipalityTxtCodPostPropertiesValidate
  inherited;
  try
    inherited;
    DscAddress.Edit;
    if SvcDBMEMunicipalityTxtCodPost.EditModified then begin
      //DscAddress.DataSet.FieldByName ('IdtMunicipality').Clear;
      AdjustLookupMunicipality (SvcDBMEMunicipalityTxtCodPost.Text);
        if SvcDBMEMunicipalityTxtCodPost.TrimText <> '' then
          SvcDBMETxtCountry.Text :=
            DmdFpnMunicipalityCA.InfoCodPost[SvcDBMEMunicipalityTxtCodPost.Text,
                                           'TxtNameCountry']
        else
          SvcDBMETxtCountry.Clear;
    end;
    DmdFpnCustomerCA.QryDetCustAddress.FieldByName('MunicipalityTxtCodPost').AsString :=
                                            SvcDBMEMunicipalityTxtCodPost.Text;
    DmdFpnCustomerCA.QryDetCustAddress.FieldByName('CountryTxtName').AsString :=
                                            SvcDBMETxtCountry.Text;
  except
    on E:Exception do begin
      SvcDBMETxtCountry.Clear;
      //ErrorCode := oeCustomError;
      Error := True;
      ErrorText :=
        TrimTrailColon (SvcDBLblTxtCodPost.Caption) + ' ' + CtTxtInvalid;
      if (not (E is ESvcNotFound)) and (E.Message <> '') then
        ErrorText := ErrorText + ' (' +
          E.Message + ')';
      if FlgMandatory = True then begin          //Internal defect fix (AM) -start
        SvcDBMEMunicipalityTxtCodPost.clear;
        if DBLkpCbxIdtMunicipality.Text = '' then
          EnterMunicipality := True;
      end;                                       //Internal defect fix (AM) -End
    end;
  end;
end;   // of TFrmDetCustomerCA.SvcDBMEMunicipalityTxtCodPostPropertiesValidate

//=============================================================================

procedure TFrmDetCustomerCA.PgeCtlDetailChange(Sender: TObject);
begin  // of TFrmDetCustomerCA.PgeCtlDetailChange
  inherited;
  if (PgeCtlDetail.ActivePage = TabShtCustCard) then begin
    if (not DscLstCustCard.DataSet.Active) and
       ((CodJob <> CtCodJobRecNew) or FlgCurrentApplied) then
      ActivateDataSet (DscLstCustCard.DataSet);
    AdjustBtnsCustCard;
  end    // of ActivePage = TabShtCustCard
end;  // of TFrmDetCustomerCA.PgeCtlDetailChange

//=============================================================================

procedure TFrmDetCustomerCA.BtnSelectCustPrcCatClick(Sender: TObject);
begin  // of TFrmDetCustomerCA.BtnSelectCustPrcCatClick
  inherited;

  StrLstRelatedIdt.Clear;
  StrLstRelatedIdt.Add ('IdtCustPrcCat=');

  BuildStrLstFldValues (StrLstRelatedIdt, DscCustomer.DataSet);

  if SvcTaskMgr.LaunchTask ('ListCustPrcCatForCustomer') then begin
    DscCustomer.DataSet.FieldByName ('IdtCustPrcCat').Text :=
      StrLstRelatedIdt.Values['IdtCustPrcCat'];

    // Show explanation CustPrcCat
    SvcMECustPrcCatTxtExplanation.TrimText :=
      StrLstRelatedInfo.Values['TxtExplanation'];
  end;  // of if SvcTaskMgr.LaunchTask ('ListClassificationForArticle') then ...
end;   // of TFrmDetCustomerCA.BtnSelectCustPrcCatClick

//=============================================================================

procedure TFrmDetCustomerCA.SvcDBLFIdtCustPrcCatUserValidation(
  Sender: TObject; var ErrorCode: Word);
begin  // of TFrmDetCustomerCA.SvcDBLFIdtCustPrcCatUserValidation
  try
    inherited;

    if SvcDBLFIdtCustPrcCat.Modified then begin
      if SvcDBLFIdtCustPrcCat.AsInteger <> 0 then
        SvcMECustPrcCatTxtExplanation.TrimText :=
          DmdFpnCustomer.InfoCustPrcCat [SvcDBLFIdtCustPrcCat.AsInteger,
                                         'TxtExplanation']
      else
        SvcMECustPrcCatTxtExplanation.TrimText := '';
    end;
  except
    on E:Exception do begin
      SvcMECustPrcCatTxtExplanation.TrimText := '';
      ErrorCode := oeCustomError;
      SvcDBLFIdtCustPrcCat.Controller.ErrorText :=
        TrimTrailColon (SvcDBLblIdtCustPrcCat.Caption) + ' ' + CtTxtInvalid;
      if (not (E is ESvcNotFound)) and (E.Message <> '') then
        SvcDBLFIdtCustPrcCat.Controller.ErrorText :=
          SvcDBLFIdtCustPrcCat.Controller.ErrorText + ' (' + E.Message + ')';
    end;
  end;
end;   // of TFrmDetCustomerCA.SvcDBLFIdtCustPrcCatUserValidation

//=============================================================================
//Siret No, Modified by TCS(KB), R2011.1

procedure TFrmDetCustomerCA.StatusSiretNo;
begin
  if FlgSiretNo = True then
  begin
    SvcDBLblSiretNo.Visible := True;
    SvcDBMEtxtSiretNo.Visible := True;
  end
  else
  begin
    SvcDBLblSiretNo.Visible := False;
    SvcDBMEtxtSiretNo.Visible := False;
  end;
end;

// End of Modification

//Siret No, Modified by TCS(KB), R2011.1

procedure TFrmDetCustomerCA.CheckSiretBeforeSave;
begin
  if not SvcDBMEtxtSiretNo.Enabled then
    exit;
  // R2011.1 - PM(TCS) - QA DefectFix 945 -- This part is commented to remove the validation of sirent number mandetory when VAT number is present
  {
  if Length(SvcDBMETxtNumVAT.text) <> 0 then
  begin
    if Length(Trim(SvcDBMEtxtSiretNo.text)) = 0 then
    begin
      if not SvcDBMEtxtSiretNo.CanFocus then
        SvcDBMEtxtSiretNo.Show;
        ActiveControl := SvcDBMEtxtSiretNo;
      raise Exception.Create
           (TrimTrailColon (SvcDBLblSiretNo.Caption) + ' ' + CtTxtRequired);
    end;
    if (Length(Trim(SvcDBMEtxtSiretNo.text)) < 14) or (Length(Trim(SvcDBMEtxtSiretNo.text)) > 14) then
    begin
    if not SvcDBMEtxtSiretNo.CanFocus then
        SvcDBMEtxtSiretNo.Show;
        ActiveControl := SvcDBMEtxtSiretNo;
      raise Exception.Create
           (CtTxtErrSiretNO);
    end; 
  end
  else
   begin
   }
   // R2011.1 - Defect fix 945, 946 - KB(TCS) - Start
    if Length(Trim(SvcDBMEtxtSiretNo.text)) <> 0 then
    begin
   // R2011.1 - Defect fix 945, 946 - KB(TCS) - End
      if (Length(Trim(SvcDBMEtxtSiretNo.text)) < 14) or (Length(Trim(SvcDBMEtxtSiretNo.text)) > 14) then
      begin
      if not SvcDBMEtxtSiretNo.CanFocus then
          SvcDBMEtxtSiretNo.Show;
          ActiveControl := SvcDBMEtxtSiretNo;
        raise Exception.Create
             (CtTxtErrSiretNO);
      end;
    end;
   end;
//end; // R2011.1 - Defect fix 945, 946 - KB(TCS)
 // End of Modification

//R2011.1 - Defect fix 945, 946 - KB(TCS)

procedure TFrmDetCustomerCA.SvcDBMEtxtSiretNoExit(Sender: TObject);
begin
  inherited;
 if SvcDBMEtxtSiretNo.Text = '' then
  exit;
   CheckSiretBeforeSave;
end;

procedure TFrmDetCustomerCA.BtnCancelClick(Sender: TObject);
begin
  inherited;
// showmessage('Cancel');
end;
// End of Modification

// ** Added as part of R2011.1 - Defect Fix 947, Modified by TCS(PM) - Start
procedure TFrmDetCustomerCA.ModifyCaption;
begin
  //inherited;
  case CodJob of
    CtCodJobRecNew  : Caption := DeleteAmpersand (CtTxtBtnCreate);
    CtCodJobRecMod  : Caption := DeleteAmpersand (CtTxtBtnModify);
    CtCodJobRecDel  : Caption := DeleteAmpersand (CtTxtBtnDelete);
    CtCodJobRecCons : Caption := DeleteAmpersand (CtTxtBtnConsult);
    else
      Caption := '';
  end;   // of case CodJob of
  //Caption := Application.Title + ' - ' + Caption + ' ' + TxtRecName;
  Caption := CtTxtCustTitle + ' - ' + Caption + ' ' + CtTxtFrmCaption; //TxtRecName;    // Defect fix 173, TT.(TCS), R2011.2 - BRES
end;
// ** Added as part of R2011.1 - Defect Fix 947, Modified by TCS(PM) - End

//=============================================================================
//Ficha Cliente, TT, R2011.2 - Start
//=============================================================================
procedure TFrmDetCustomerCA.BtnCustomerSheetClick(Sender: TObject);
var
  DateCompare      :     TDateTime;                                             //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
  IdtAddress       :     String;                                                //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
begin
  inherited;
    Customer     := Trim(SvcDBLFIdtCustomer.Text);
    CodCreator   := IntToStr(DscCustomer.DataSet.FieldByName('CodCreator').AsInteger); //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
    IdtAddress   := IntToStr(DscAddress.DataSet.FieldByName('IdtAddress').AsInteger);  //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
    if (CodJob in [CtCodJobRecNew,CtCodJobRecMod]) then
    begin
      DscCustomer.DataSet.Active := False;
      DmdFpnCustomerCA.QryDetCustomer.ParamByName ('PrmIdtCustomer').Text :=
                                                                       Customer;
      DmdFpnCustomerCA.QryDetCustomer.ParamByName ('PrmCodCreator').Text :=     //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
                                                       CodCreator;              //Ficha Cliente - Post integration Defect Fix, TT, R2011.2
      DscCustomer.DataSet := DmdFpnCustomerCA.QryDetCustomer;
      DscCustomer.DataSet.Active := True;
      DscCustomer.DataSet.Edit;
      //Ficha Cliente - Post integration Defect Fix, TT, R2011.2 - start
     // DscAddress.DataSet.Active := False;                                     //Commented out - Ficha Cliente - Known Issue Fix, TT, R2011.2
      DmdFpnCustomerCA.QryDetCustAddress.ParamByName('PrmIdtAddress').Text :=
                                                                     IdtAddress;
      //Ficha Cliente - Known Issue Fix, TT, R2011.2 - start
      if (CodJob = CtCodJobRecMod) then begin
        DscAddress.DataSet.Active := False;
      end;
      //Ficha Cliente - Known Issue Fix, TT, R2011.2 - end
      DscAddress.DataSet := DmdFpnCustomerCA.QryDetCustAddress;
      DscAddress.DataSet.Active := True;
      DscAddress.DataSet.Edit;
      //Ficha Cliente - Post integration Defect Fix, TT, R2011.2 - end
    end;
    Name         := SvcDBMETxtPublName.Text;
    Title        := SvcDBMETxtTitle.Text;
    Address      := SvcDBMETxtStreet.Text;
    PostalCode   := SvcDBMEMunicipalityTxtCodPost.Text;
    Municipality := DBLkpCbxIdtMunicipality.Text;
    Country      := SvcDBMETxtCountry.Text;
    Province     := SvcDBMETxtProvince.Text;
    FlgCreditLim := DBCbxFlgCreditLim.Checked;
    // Ficha Cliente - Enhancement related to defect# 31, TT, R2011.2 - Start
    if FlgCreditLim then
    begin
      Amount      := Trim(SvcDBLFValCreditLim.Text);
      Currencycust := DscCustomer.DataSet.FieldByName('IdtCurrency').AsString;
    end
    else
    begin
      Amount      := ' ';
      Currencycust := ' ';
    end;
    // Ficha Cliente - Enhancement related to defect# 31, TT, R2011.2 - End
    VATNum       := SvcDBMETxtNumVAT.Text;
    CodeVAT      := DBLkpCbxCodVATSystem.Text;
    InvoiceNum   := SvcDBLFQtyCopyInv.Text;
    DateCreate   := DscCustomer.DataSet.FieldByName('DatCreate').AsDateTime;
    // DateModify   := DscCustomer.DataSet.FieldByName('DatModify').AsDateTime; //Commented out - Ficha Cliente - Post integration Defect Fix, TT, R2011.2
    //Ficha Cliente - Post integration Defect Fix, TT, R2011.2 - start
    DateCompare  := DscAddress.DataSet.FieldByName('DatModify').AsDateTime;
    DateModify   := DscCustomer.DataSet.FieldByName('DatModify').AsDateTime;
    if DateCompare > DateModify then    // to reflect changes in either address or customer
      DateModify   := DateCompare;
    //Ficha Cliente - Post integration Defect Fix, TT, R2011.2 - end
    SvcTaskMgr.LaunchTask ('CustomerSheetReport');
end;
//Ficha Cliente, TT, R2011.2 - End
//=============================================================================

//=============================================================================
//Ficha Cliente, TT, R2011.2 - Start
//=============================================================================

procedure TFrmDetCustomerCA.DscCustomerDataChange(Sender: TObject; Field: TField);
begin  // of TFrmDetail.DscCommonDataChange
  inherited;
  DscCommonDataChange (Sender, Field);
  if FlgCustomerSheet and FlgDataChanged then
    DisableControl (BtnCustomerSheet);
end;   // of TFrmDetail.DscCommonDataChange

//Ficha Cliente, TT, R2011.2 - End
//=============================================================================
//R2011.2 - BRES - Defect fix 299 - Start
function TFrmDetCustomerCA.GetRecName : string;
begin  // of TFrmDetCustomerCA.GetRecName
  Result := CtTxtFrmCaption;
  
end;   // of TFrmDetCustomerCA.GetRecName
// R2011.2 - BRES - Defect fix 299 - End
//=============================================================================
//R2011.2 - BDES - Creation Of Client Management of Post Code - Start
//=============================================================================
procedure TFrmDetCustomerCA.SvcDBMEMunicipalityTxtCodPostExit(Sender: TObject);
begin   // of TFrmDetCustomerCA.SvcDBMEMunicipalityTxtCodPostExit
  inherited;
// If FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
   If FlgMandatory = True then begin
    if SvcDBMEMunicipalityTxtCodPost.ModifiedAfterEnter and (SvcDBMEMunicipalityTxtCodPost.TrimText <> '') then begin
       AdjustLookupMunicipality (SvcDBMEMunicipalityTxtCodPost.TrimText);
       if TStoredProc(DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').
                       LookupDataSet).RecordCount > 1 then begin
           DBLkpCbxIdtMunicipality.DropDown;
       end
       else
        if not DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').LookupDataSet.IsEmpty then begin
           DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').LookupDataSet.First;
           DscAddress.DataSet.FieldByName ('IdtMunicipality').AsInteger := DscAddress.DataSet.FieldByName ('LkpIdtMunicipalityTxtName').LookupDataSet.FieldByName('IdtMunicipality').AsInteger;
        end;
      end;
 end;
end;
//=============================================================================
procedure TFrmDetCustomerCA.DBLkpCbxIdtMunicipalityCloseUp(Sender: TObject);
var returnCtry : string;
  procedure FilterLkpCtyForMunicipality (IdtMunicipality : string);
  begin
   //If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
   If  FlgMandatory = True then begin
     if Trim (IdtMunicipality) <> '' then begin
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).Active := False;
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtTable').Text := 'Municipality';
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtJoinTable').Text := 'Country';
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtArrFields').Text := 'Municipality.IdtCountry;Municipality.IdtMunicipality;Municipality.TxtCodPost;TxtNameMunicipality=Municipality.txtname;TxtNameCountry=Country.TxtName;Country.TxtCodCountry';
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtSequence').Text := 'IdtMunicipality';
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtFrom').Text := IdtMunicipality;
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').
                      LookupDataSet).ParamByName ('@PrmTxtTo').Text := IdtMunicipality;
      TStoredProc(DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').LookupDataSet).Active := True;
     end;
   end;
  end;
begin
  inherited;
  try
    If  FlgMandatory = True then begin
//    If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
      if (DBLkpCbxIdtMunicipality.Text<>'') then begin
        StrLstRelatedIdt.Clear;
        StrLstRelatedIdt.Add ('IdtMunicipality=');
        if not DscAddress.DataSet.FieldByName ('IdtMunicipality').IsNull then
          BuildStrLstFldValues (StrLstRelatedIdt, DscAddress.DataSet);
          FilterLkpCtyForMunicipality(StrLstRelatedIdt.Values['IdtMunicipality']);
          if not DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').LookupDataSet.IsEmpty then begin
            //DscMunicipalityFilter.DataSet.edit;
            SvcDBMETxtCountry.Text := DscMunicipalityFilter.DataSet.FieldByName ('LkpIdtCountryTxtName').LookupDataSet.FieldByName('TxtNameCountry').AsString;
          end;
        end;
      end;
  except

  end;
end;

//=============================================================================
//R2011.2 - BDES - Creation Of Client Management of Post Code - End
//=============================================================================
Initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FDetCustomerCA
