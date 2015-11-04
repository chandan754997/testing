{$A1,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
//=== Copyright 2007 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet   : FlexPoint                                                                      
// Unit     : FADOMQWSInterfaces: ADO Message Queue for WebSphere INTERFACES.
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOMQWSInterfaces.pas,v 1.40 2007/12/07 07:53:18 smete Exp $
// History :
//=============================================================================

unit FADOMQWSInterfaces;

//*****************************************************************************

interface

uses
  Windows, Classes, SysUtils, ScEHdler, MSXML_TLB, DB, MMQI, MWebsphereMQ;

const
  CtTxtFrmNumber        = '#####0.00';       // How to format a number.
  CtTxtFrmNumberExt     = '#####0.0000';       // How to format a number.

resourcestring
  CtTxtBeginTrans       = 'BeginTrans failed: ';
  CtTxtRollbackTrans    = 'RollbackTrans failed: ';
  CtTxtCommitTrans      = 'CommitTrans failed: ';
  CtTxtInvalidMsgBody   = 'Invalid message body: ';
  CtTxtErrorPOSTrans    = 'Error during processing POS transactions: ';
  CtTxtErrorSafeTrans   = 'Error during processing Safe transactions: ';
  CtTxtProcessNtStarted = 'Failed to start high priority DTS for IdtMsg ';
  CtTxtProcessFailed    = 'DTS failed for IdtMsg ';

//*****************************************************************************
// TXMLADOAssync
//*****************************************************************************

type

  TObjCommPOSTrans       = class
  private
    FDatTransBegin       : tdatetime;        //Date of transaction
    FIdtPOSTransaction   : integer;          //Transaction id
    FIdtCheckout         : integer;          //Checkout id
    FCodTrans            : integer;          //Transaction code
    FIdtTradematrix      : string;           //Unique shop number
  public
    //Properties
    property DatTransBegin: tdatetime read FDatTransBegin write FDatTransBegin;
    property IdtPOSTransaction: integer read FIdtPOSTransaction write FIdtPOSTransaction;
    property IdtCheckOut: integer read FIdtCheckout write FIdtCheckout;
    property CodTrans: integer read FCodTrans write FCodTrans;
    property IdtTradematrix: string read FIdtTradematrix write FIdtTradematrix;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TObjLstCommSafeTrans       = class
  private
    FIdtSafeTransaction  : integer;          //Safe transaction id
  public
    //Properties
    property IdtSafeTransaction: integer read FIdtSafeTransaction write FIdtSafeTransaction;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TObjDetCommSafeTrans       = class
  private
    FIdtSafeTransaction  : integer;          //Safe transaction id
    FIdtClassification   : string;           //Classification id
    FIdtCurrency         : string;           //Currency id
    FValDiff             : double;           //Counting difference
  public
    //Properties
    property IdtSafeTransaction: integer read FIdtSafeTransaction write FIdtSafeTransaction;
    property IdtClassification: string read FIdtClassification write FIdtClassification;
    property IdtCurrency: string read FIdtCurrency write FIdtCurrency;
    property ValDiff: double read FValDiff write FValDiff;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TObjCOOffline              = class
  private
    FWERKS               : string;
    FVBELN               : string;
    FZDATE1              : string;
    FZCARDNUM            : string;
    FZCARDID             : string;
    FZCHANNEL            : string;
    FZDISCO              : string;
    FZPHONE              : string;
    FZAREA               : string;
    FZNAME               : string;
    FZADDRESS            : string;
    FPSTYV               : string;
    FZDATE2              : string;
    FZPICK               : string;
    FZMARKH              : string;
    FPOSTRXN             : string;
    FNETWR2              : string;
    FZTILLNUM            : string;
    FZTRANSDATE          : string;
  public
    property WERKS : string read FWERKS write FWERKS;
    property VBELN : string read FVBELN write FVBELN;
    property ZDATE1 : string read FZDATE1 write FZDATE1;
    property ZCARDNUM : string read FZCARDNUM write FZCARDNUM;
    property ZCARDID : string read FZCARDID write FZCARDID;
    property ZCHANNEL : string read FZCHANNEL write FZCHANNEL;
    property ZDISCO : string read FZDISCO write FZDISCO;
    property ZPHONE : string read FZPHONE write FZPHONE;
    property ZAREA : string read FZAREA write FZAREA;
    property ZNAME : string read FZNAME write FZNAME;
    property ZADDRESS : string read FZADDRESS write FZADDRESS;
    property PSTYV : string read FPSTYV write FPSTYV;
    property ZDATE2 : string read FZDATE2 write FZDATE2;
    property ZPICK : string read FZPICK write FZPICK;
    property ZMARKH : string read FZMARKH write FZMARKH;
    property POSTRXN : string read FPOSTRXN write FPOSTRXN;
    property NETWR2 : string read FNETWR2 write FNETWR2;
    property ZTILLNUM : string read FZTILLNUM write FZTILLNUM;
    property ZTRANSDATE : string read FZTRANSDATE write FZTRANSDATE;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TObjCOOfflineDet           = class
  private
    FPOSNR               : string;
    FMATNR               : string;
    FMENGE               : string;
    FNETPR               : string;
    FZMARKI              : string;
    FEAN11               : string;
  public
    property POSNR : string read FPOSNR write FPOSNR;
    property MATNR : string read FMATNR write FMATNR;
    property MENGE : string read FMENGE write FMENGE;
    property NETPR : string read FNETPR write FNETPR;
    property ZMARKI : string read FZMARKI write FZMARKI;
    property EAN11 : string read FEAN11 write FEAN11;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TObjCumuls       = class
  private
    FIdtClassification  : string;
    FIdtCurrency        : string;
    FValInclVAT         : Double;
  public
    //Properties
    property IdtClassification: string read FIdtClassification write FIdtClassification;
    property IdtCurrency: string read FIdtCurrency write FIdtCurrency;
    property ValInclVAT: Double read FValInclVAT write FValInclVAT;
  end;

  TObjPOSTransaction     = class
  private
    FIdtTradematrix      : string;           //Unique shop number
    FDatTransBegin       : TDateTime;        //Date of transaction
    FIdtPOSTransaction   : integer;          //Transaction id
    FIdtCheckout         : integer;          //Checkout id
    FCodTrans            : integer;          //Transaction code
    FIdtOperator         : integer;
    FIdtPersonnel        : string;
    FTxtNamePers         : string;
    FIdtPOStransResume   : integer;
    FIdtCheckOutResume   : integer;
    FDatTransBeginResume : TDateTime;
    FCodType             : integer;
    FCodAction           : integer;
    FIdtArticle          : string;
    FNumPLU              : string;
    FTxtDescr            : string;
    FIdtClassification   : string;
    FQtyReg              : double;
    FPrcExclVAT          : double;
    FPrcInclVAT          : double;
    FValInclVAT          : double;
    FIdtCurrency         : string;
    FIdtVATCode          : integer;
    FPctVAT              : double;
    FIdtCVente           : double;
    FCodTypeVente        : integer;
    FCodTypeArticle      : integer;
    FDatTransBeginOrig   : TDateTime;
    FIdtPosTransOrig     : integer;
    FIdtCheckOutOrig     : integer;
    FCodTransOrig        : integer;
    FIdtTradeMatrixOrig  : string;
    FIdtCustomer         : integer;
    FTxtSrcNumCard       : string;
    FTxtName             : string;
    FCodCustCard         : integer;
    FQtyReturned         : double;
  public
    //Properties
    property IdtTradematrix: string read FIdtTradematrix write FIdtTradematrix;
    property DatTransBegin: tdatetime read FDatTransBegin write FDatTransBegin;
    property IdtPOSTransaction: integer read FIdtPOSTransaction write FIdtPOSTransaction;
    property IdtCheckOut: integer read FIdtCheckout write FIdtCheckout;
    property CodTrans: integer read FCodTrans write FCodTrans;
    property IdtOperator: integer read FIdtOperator write FIdtOperator;
    property IdtPersonnel: string read FIdtPersonnel write FIdtPersonnel;
    property TxtNamePers: string read FTxtNamePers write FTxtNamePers;
    property IdtPOStransResume: integer read FIdtPOStransResume write FIdtPOStransResume;
    property IdtCheckOutResume: integer read FIdtCheckOutResume write FIdtCheckOutResume;
    property DatTransBeginResume: TDateTime read FDatTransBeginResume write FDatTransBeginResume;
    property CodType: integer read FCodType write FCodType;
    property CodAction: integer read FCodAction write FCodAction;
    property IdtArticle: string read FIdtArticle write FIdtArticle;
    property NumPLU: string read FNumPLU write FNumPLU;
    property TxtDescr: string read FTxtDescr write FTxtDescr;
    property IdtClassification: string read FIdtClassification write FIdtClassification;
    property QtyReg: double read FQtyReg write FQtyReg;
    property PrcExclVAT: double read FPrcExclVAT write FPrcExclVAT;
    property PrcInclVAT: double read FPrcInclVAT write FPrcInclVAT;
    property ValInclVAT: double read FValInclVAT write FValInclVAT;
    property IdtCurrency: string read FIdtCurrency write FIdtCurrency;
    property IdtVATCode: integer read FIdtVATCode write FIdtVATCode;
    property PctVAT: double read FPctVAT write FPctVAT;
    property IdtCVente: double read FIdtCVente write FIdtCVente;
    property CodTypeVente: integer read FCodTypeVente write FCodTypeVente;
    property CodTypeArticle: integer read FCodTypeArticle write FCodTypeArticle;
    property DatTransBeginOrig: TDateTime read FDatTransBeginOrig write FDatTransBeginOrig;
    property IdtPosTransOrig: integer read FIdtPosTransOrig write FIdtPosTransOrig;
    property IdtCheckOutOrig: integer read FIdtCheckOutOrig write FIdtCheckOutOrig;
    property CodTransOrig: integer read FCodTransOrig write FCodTransOrig;
    property IdtTradeMatrixOrig: string read FIdtTradeMatrixOrig write FIdtTradeMatrixOrig;
    property IdtCustomer: integer read FIdtCustomer write FIdtCustomer;
    property TxtSrcNumCard: string read FTxtSrcNumCard write FTxtSrcNumCard;
    property TxtName: string read FTxtName write FTxtName;
    property CodCustCard: integer read FCodCustCard write FCodCustCard;
    property QtyReturned: double read FQtyReturned write FQtyReturned;
    //Procedures
    procedure Fill(Dataset: TDataset);
  end;

  TADOMQWSInterfaces = class (TObject)
  private
    //Assynchronous outgoing & Synchronous incoming
    FDstLstCommPOSTrans    : TDataset;
    FDstLstCommSafeTrans   : TDataset;
    FDstLstPOSTransactions : TDataset;
    FDstLstVente           : TDataset;
    FDstLstVente_Ligne     : TDataset;
    FTxtMsgOutBody         : string;
    FTxtMsgOutFormat       : string;
    FFlgCOOffline          : boolean;          // Customer order offline
    FIdtCVente             : double;           // Customer order offline
    FlgSavingCard      : boolean;              // Charge/Withdraw saving card
  protected
    //Assynchronous incoming
    FlgTickNegative        : boolean;
    procedure ProcessAssyncInFld (TxtMsgBodyLine : string;
                                  TxtMsgFormat :  string;
                                  IdtMsg : integer;
                                  FlgPrior : boolean); virtual;
    procedure SetLastIdtMsg (IdtMsg : integer); virtual;

    //Assynchronous outgoing & Synchronous incoming
    property DstLstCommPOSTrans: TDataset read FDstLstCommPOSTrans
                                         write FDstLstCommPOSTrans;
    property DstLstCommSafeTrans: TDataset read FDstLstCommSafeTrans
                                          write FDstLstCommSafeTrans;
    property DstLstPOSTransactions: TDataset read FDstLstPOSTransactions
                                            write FDstLstPOSTransactions;
    property DstLstVente : TDataset read FDstLstVente
                                   write FDstLstVente;
    property DstLstVente_Ligne : TDataset read FDstLstVente_Ligne
                                         write FDstLstVente_Ligne;
    property FlgCOOffline: boolean read FFlgCOOffline write FFlgCOOffline;
    property IdtCVente : double read FIdtCVente write FIdtCVente;
    procedure CheckCommPOSTrans(LstCommPOSTrans : TList); virtual;
    procedure CheckCommSafeTrans(LstCommSafeTrans : TList); virtual;
    procedure ProcessCommPOSTrans(LstCommPOSTrans : TList;
                                  MQ : TWebSphereMQ); overload;
    procedure ProcessCOOffline(ObjXMLDoc : IXMLDOMDocument); virtual;
    procedure ProcessCommPOSTrans(LstCommPOSTrans : TList); overload;
    procedure ProcessCommSafeTrans(LstCommSafeTrans : TList;
                                   MQ : TWebSphereMQ); virtual;
    procedure CreateAssyncOutMsgPOS (LstPOSTransactions : TList;
                                     ObjXMLDoc    : IXMLDOMDocument;
                                     FlgSync : boolean); virtual;
    procedure ConstructEmptyMsg (ObjXMLDoc    : IXMLDOMDocument;
                                 LstCommPOSTrans : TList); virtual;
    procedure AddArticles (LstPOSTransactions : TList;
                           ObjXMLTicket    : IXMLDOMNode;
                           ObjXMLDoc    : IXMLDOMDocument;
                           FlgSync : boolean); virtual;
    procedure AddDeposit (LstPOSTransactions : TList;
                          ObjXMLTicket    : IXMLDOMNode;
                          ObjXMLDoc    : IXMLDOMDocument); virtual;
    procedure AddCustomer (LstPOSTransactions : TList;
                           ObjXMLTicket    : IXMLDOMNode;
                           ObjXMLDoc    : IXMLDOMDocument); virtual;
    procedure AddPayment (LstPOSTransactions : TList;
                          ObjXMLTicket    : IXMLDOMNode;
                          ObjXMLDoc    : IXMLDOMDocument); virtual;
    procedure CreateAssyncOutMsgSafe (LstSafeTransactions : TList;
                                      ObjXMLDoc    : IXMLDOMDocument); virtual;
    procedure RetrieveCumulPaymethods (LstCumuls : TList); virtual;
    function CheckOffline (IdtCVente : double): boolean; virtual;
  public
    //Assynchronous incoming
    procedure ProcessAssyncIn (StrLstMsgBody : TStringList;
                            TxtMsgFormat :  string;
                            FlgPrior : boolean); virtual;

    //Assynchronous outgoing
    procedure ProcessAssyncOut(MQ : TWebSphereMQ); virtual;

    //Synchronous incoming
    property TxtMsgOutBody: string read FTxtMsgOutBody write FTxtMsgOutBody;
    property TxtMsgOutFormat: string read FTxtMsgOutFormat write FTxtMsgOutFormat;
    procedure ProcessSyncIn(TxtMsgInBody :  string); virtual;

    //General
    procedure ExceptionHandler (Sender : TObject;
                                E      : Exception); virtual;
    function GetSleeptime : integer; virtual;
    procedure ReplaceString (var TxtS      : string;
                             OldSubStr : string;
                             NewSubStr : string);
  end;  // of TADOAssync

var
  ADOMQWSInterfaces: TADOMQWSInterfaces;

implementation

uses
  SfDialog,
  StStrW,
  SmUtils,
  SmWinApi,
  Dialogs,
  Variants,
  DMADODummy,
  DFpnADOCA,
  DFpnADOUtilsCA,
  DFpnADOMQWSPosTransAction,
  DFpnADOMQWSSafeTransAction,
  DFpnADOPosTransAction,
  DFpnADOPosTransActionCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FTADOMQWSInterfaces';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOMQWSInterfaces.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.40 $';
  CtTxtSrcDate    = '$Date: 2007/12/07 07:53:18 $';

//*****************************************************************************
// Implementation of TObjCommPOSTrans
//*****************************************************************************

procedure TObjCommPOSTrans.Fill(Dataset: TDataset);
begin  // of TObjCommPOSTrans.Fill
  DatTransBegin := DataSet.FieldByName('DatTransBegin').AsDateTime;
  IdtPOSTransaction := DataSet.FieldByName('IdtPOSTransaction').AsInteger;
  IdtCheckOut := DataSet.FieldByName('IdtCheckOut').AsInteger;
  CodTrans := DataSet.FieldByName('CodTrans').AsInteger;
  IdtTradematrix := DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
end;   // of TObjCommPOSTrans.Fill

//*****************************************************************************
// Implementation of TObjLstCommSafeTrans
//*****************************************************************************

procedure TObjLstCommSafeTrans.Fill(Dataset: TDataset);
begin  // of TObjCommPOSTrans.Fill
  IdtSafeTransaction := DataSet.FieldByName('IdtSafeTransaction').AsInteger;
end;   // of TObjLstCommSafeTrans.Fill

//*****************************************************************************
// Implementation of TObjDetCommSafeTrans
//*****************************************************************************

procedure TObjDetCommSafeTrans.Fill(Dataset: TDataset);
begin  // of TObjDetCommSafeTrans.Fill
  IdtSafeTransaction := DataSet.FieldByName('IdtSafeTransaction').AsInteger;
  IdtClassification := DataSet.FieldByName('IdtClassification').AsString;
  IdtCurrency := DataSet.FieldByName('IdtCurrency').AsString;
  ValDiff := DataSet.FieldByName('ValDiff').AsFloat;
end;   // of TObjDetCommSafeTrans.Fill

//*****************************************************************************
// Implementation of TObjCOOffline
//*****************************************************************************

procedure TObjCOOffline.Fill(Dataset: TDataset);
begin  // of TObjCOOffline.Fill
  WERKS := DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
  VBELN := DataSet.FieldByName('CVENTE').AsString;
  ZDATE1 := DataSet.FieldByName('DCREATION').AsString;
  ZCARDNUM := DataSet.FieldByName('IdtCustomer').AsString;
  ZCARDID := DataSet.FieldByName('NUMCARD').AsString;
  ZCHANNEL := DataSet.FieldByName('TxtChannel').AsString;
  ZDISCO := DataSet.FieldByName('PctDiscount').AsString;
  ZPHONE := DataSet.FieldByName('TxtNumPhone').AsString;
  ZAREA := DataSet.FieldByName('TxtDelivArea').AsString;
  ZNAME := DataSet.FieldByName('TxtNameCust').AsString;
  ZADDRESS := DataSet.FieldByName('TxtDelivAddress').AsString;
  PSTYV := DataSet.FieldByName('TxtCategory').AsString;
  ZDATE2 := DataSet.FieldByName('DatDelivery').AsString;
  ZPICK := DataSet.FieldByName('TYPE_DELIVERY').AsString;
  ZMARKH := DataSet.FieldByName('TxtNote').AsString;
  POSTRXN := DataSet.FieldByName('IdtPOSTransaction').AsString;
  NETWR2 := DataSet.FieldByName('M_ACOMPTE_VERSE_PREVU').AsString;
  ZTILLNUM := DataSet.FieldByName('IdtCheckout').AsString;
  ZTRANSDATE := FormatDateTime('yyyymmdd hh:mm:ss', DataSet.
                FieldByName('DatTransBegin').AsDatetime);
end;   // of TObjCOOffline.Fill

//*****************************************************************************
// Implementation of TObjCOOffline
//*****************************************************************************

procedure TObjCOOfflineDet.Fill(Dataset: TDataset);
begin  // of TObjCOOfflineDet.Fill
  POSNR := DataSet.FieldByName('CVENTE_LIGNE').AsString;
  MATNR := DataSet.FieldByName('CESCLAVE').AsString;
  MENGE := DataSet.FieldByName('QTE_SAISI').AsString;
  NETPR := DataSet.FieldByName('M_PV_SAISI').AsString;
  ZMARKI := DataSet.FieldByName('TxtNote').AsString;
  EAN11 := DataSet.FieldByName('NumPlu').AsString;
end;   // of TObjCOOfflineDet.Fill

//*****************************************************************************
// Implementation of TObjPOSTransaction
//*****************************************************************************

procedure TObjPOSTransaction.Fill(Dataset: TDataset);
begin  // of TObjPOSTransaction
  IdtTradematrix := DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
  DatTransBegin := DataSet.FieldByName('DatTransBegin').AsDateTime;
  IdtPOSTransaction := DataSet.FieldByName('IdtPOSTransaction').AsInteger;
  IdtCheckOut := DataSet.FieldByName('IdtCheckOut').AsInteger;
  CodTrans := DataSet.FieldByName('CodTrans').AsInteger;
  IdtOperator := DataSet.FieldByName('IdtOperator').AsInteger;
  IdtPersonnel := DataSet.FieldByName('IdtPersonnel').AsString;
  TxtNamePers := DataSet.FieldByName('TxtNamePers').AsString;
  IdtPOStransResume := DataSet.FieldByName('IdtPOStransResume').AsInteger;
  IdtCheckOutResume := DataSet.FieldByName('IdtCheckOutResume').AsInteger;
  DatTransBeginResume := DataSet.FieldByName('DatTransBeginResume').AsDateTime;
  CodType := DataSet.FieldByName('CodType').AsInteger;
  CodAction := DataSet.FieldByName('CodAction').AsInteger;
  IdtArticle := DataSet.FieldByName('IdtArticle').AsString;
  NumPLU := DataSet.FieldByName('NumPLU').AsString;
  TxtDescr := DataSet.FieldByName('TxtDescr').AsString;
  IdtClassification := DataSet.FieldByName('IdtClassification').AsString;
  QtyReg := DataSet.FieldByName('QtyReg').AsFloat;
  PrcExclVAT := DataSet.FieldByName('PrcExclVAT').AsFloat;
  PrcInclVAT := DataSet.FieldByName('PrcInclVAT').AsFloat;
  ValInclVAT := DataSet.FieldByName('ValInclVAT').AsFloat;
  IdtCurrency := DataSet.FieldByName('IdtCurrency').AsString;
  IdtVATCode := DataSet.FieldByName('IdtVATCode').AsInteger;
  PctVAT := DataSet.FieldByName('PctVAT').AsFloat;
  IdtCVente := DataSet.FieldByName('IdtCVente').AsFloat;
  CodTypeVente := DataSet.FieldByName('CodTypeVente').AsInteger;
  CodTypeArticle := Dataset.FieldByName('CodTypeArticle').AsInteger;
  DatTransBeginOrig := DataSet.FieldByName('DatTransBeginOrig').AsDateTime;
  IdtPosTransOrig := DataSet.FieldByName('IdtPosTransOrig').AsInteger;
  IdtCheckOutOrig := DataSet.FieldByName('IdtCheckOutOrig').AsInteger;
  CodTransOrig := DataSet.FieldByName('CodTransOrig').AsInteger;
  IdtTradeMatrixOrig := DataSet.FieldByName('IdtTradeMatrixOrig').AsString;
  IdtCustomer := DataSet.FieldByName('IdtCustomer').AsInteger;
  TxtSrcNumCard := DataSet.FieldByName('TxtSrcNumCard').AsString;
  TxtName := DataSet.FieldByName('TxtName').AsString;
  CodCustCard := DataSet.FieldByName('CodCustCard').AsInteger;
  QtyReturned := DataSet.FieldByName('QtyReturned').AsFloat;
end;   // of TObjPOSTransaction

//*****************************************************************************
// Implementation of TADOMQWSInterfaces
//*****************************************************************************

procedure TADOMQWSInterfaces.ProcessAssyncIn (StrLstMsgBody : TStringList;
                                              TxtMsgFormat :  string;
                                               FlgPrior : boolean);
var
  CntItem         : Integer;          // Index for loop
  IdtMsg          : integer;          // IdtMsg used for record
  proc_info       : TProcessInformation;
  startinfo       : TStartupInfo;
  ExitCode        : longword;
  TxtPathCommand  : String;           // Path of the batchfile
  TxtParams       : String;           // Commandline parameters
  TxtPathError    : String;           // Path of the errorfile
  TxtSrvDB        : String;
  TxtDB           : String;
  TxtDTSRoot      : String;
begin  // of TADOMQWSInterfaces.ProcessAssyncIn
  try
    DmdFpnADOCA.ADOConFlexpoint.Open;
    try
      DmdFpnADOCA.ADOConFlexpoint.BeginTrans;
    except
        on E: Exception do
          raise E.Create(CtTxtBeginTrans + E.Message);
    end;
    IdtMsg := 0;
    for CntItem := 0 to Pred (StrLstMsgBody.Count) do begin
      try
        try
          if FlgPrior then begin
            if IdtMsg = 0 then
              IdtMsg := DmdFpnADOUtilsCA.GetNextCounterBig('CommMsgHigh','IdtMsg');
          end
          else
            IdtMsg := DmdFpnADOUtilsCA.GetNextCounterBig('CommMsgLow','IdtMsg');
          ProcessAssyncInFld (StrLstMsgBody.Strings[CntItem], TxtMsgFormat,
                             IdtMsg, FlgPrior);
        except
          on E: Exception do
            raise Exception.CreateFmt(E.Message + #10'%s', [StrLstMsgBody.Text]);
        end;
      except
        on E: Exception do begin
          try
            if DmdFpnADOCA.ADOConFlexpoint.InTransaction then
              DmdFpnADOCA.ADOConFlexpoint.RollbackTrans;
          except
              on E: Exception do
                raise E.Create(CtTxtRollbackTrans + E.Message);
          end;
          ExceptionHandler(Self, E);
        end;
      end;
    end;
    try
      if DmdFpnADOCA.ADOConFlexpoint.InTransaction then
        DmdFpnADOCA.ADOConFlexpoint.CommitTrans;
    except
        on E: Exception do
          raise E.Create(CtTxtCommitTrans + E.Message);
    end;
    if FlgPrior then begin
      TxtPathCommand := 'DTSRun';
      TxtSrvDB := ReplaceEnvVar ('%COMPUTERNAME%');
      TxtDB := 'FlexPoint';
      TxtDTSRoot := ReplaceEnvVar ('%DTSROOT%');
      TxtParams := ReplaceEnvVar ('/F ' + TxtDTSRoot + '\DTS\ProcessCommMsgHigh.dts '+
                                  '/A PrmTxtServerName:8="' + TxtSrvDB + '" /A '+
                                  'PrmTxtDBName:8="' + TxtDB + '" /A PrmIdtMsg:14="'+
                                  IntToStr(IdtMsg) + '" /A '+
                                  'PrmTxtFNError:8="D:\Sycron\Bat\ProcessHigh.txt"');
      TxtPathError := ReplaceEnvVar ('%SycRoot%\bat\errorfile.txt');
      // Attempts to create the process
      startinfo.cb := SizeOf(startinfo);
      startinfo.dwFlags := STARTF_USESHOWWINDOW;
      startinfo.wShowWindow := SW_HIDE;
      if CreateProcess(nil, PChar(TxtPathcommand + ' ' + TxtParams), nil,
      nil, false, NORMAL_PRIORITY_CLASS, nil, nil, startinfo, proc_info) <> False
      then begin
        // The process has been successfully created
        // No let's wait till it ends...
        WaitForSingleObject(proc_info.hProcess, INFINITE);
        // Process has finished. Now we should close it.
        GetExitCodeProcess(proc_info.hProcess, ExitCode);  // Optional
        CloseHandle(proc_info.hThread);
        CloseHandle(proc_info.hProcess);
        if FileExists(TxtPathError) then begin
          raise Exception.Create(CtTxtProcessFailed + IntToStr(IdtMsg));
          DeleteFile(TxtPathError);
        end;
      end
      else begin
        // Failure creating the process
        raise Exception.Create(CtTxtProcessNtStarted + IntToStr(IdtMsg));
      end;//if
    end;
  finally
    DmdFpnADOCA.ADOConFlexpoint.Close;
  end;
end;   // of TADOMQWSInterfaces.ProcessAssyncIn

//=============================================================================

procedure TADOMQWSInterfaces.ProcessAssyncInFld (TxtMsgBodyLine : string;
                                                 TxtMsgFormat :  string;
                                                 IdtMsg : integer;
                                                 FlgPrior : boolean);
var
  StrLstFields    : TStringList;      // List for fields and values
  TxtRight        : string;           // Variable to store right value in
  TxtLeft         : string;           // Variable to store left value in
  CntItem         : Integer;          // Index for loop
  FlgError        : boolean;          // Error in format of body
begin // of TADOMQWSInterfaces.ProcessAssyncInFld
  StrLstFields :=  TStringList.Create;
  FlgError := False;
  if (Copy(TxtMsgBodyLine, 1, 1) <> '"') or (Copy(TxtMsgBodyLine,
     length(TxtMsgBodyLine), length(TxtMsgBodyLine)) <> '"') then begin
    StrLstFields.Add ('CodTreated=' + QuotedStr('2'));
    FlgError := True;
    if Copy(TxtMsgBodyLine, 1, 1) <> '"' then
      TxtMsgBodyLine := Copy(TxtMsgBodyLine, 1, length(TxtMsgBodyLine) - 1)
    else
      TxtMsgBodyLine := Copy(TxtMsgBodyLine, 2, length(TxtMsgBodyLine) - 1);
  end
  else
    TxtMsgBodyLine := Copy(TxtMsgBodyLine, 2, length(TxtMsgBodyLine) - 2);
  CntItem := 1;
  StrLstFields.Add ('IdtMsg=' + QuotedStr(IntToStr(IdtMsg)));
  StrLstFields.Add ('NumSeq=' + QuotedStr('-1'));
  StrLstFields.Add ('TxtType=' + QuotedStr(Trim(TxtMsgFormat)));
  repeat
    SplitString (TxtMsgBodyLine, '","', TxtLeft, TxtRight);
    StrLstFields.Add ('TxtMsg' + IntToStr(CntItem) + '=' + QuotedStr(TxtLeft));
    TxtMsgBodyLine := TxtRight;
    Inc(CntItem);
  until TxtRight = '';
  if FlgPrior then                                                              
    DmdADODummy.InsertHighPrior (StrLstFields)
  else begin
    DmdADODummy.InsertLowPrior (StrLstFields);
    SetLastIdtMsg(IdtMsg);
  end;
  if FlgError then
    raise Exception.Create(CtTxtInvalidMsgBody);
end;  // of TADOMQWSInterfaces.ProcessAssyncInFld

//=============================================================================

procedure TADOMQWSInterfaces.SetLastIdtMsg;
begin  // of TADOMQWSInterfaces.SetLastIdtMsg
  DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text :=
                            ('IF EXISTS (SELECT * FROM ApplicCounter' +
                          #10'           WHERE IdtApplicCounter = ' +
                                               QuotedStr('CommMsgLow') +
                          #10'           AND TxtField = ' +
                                               QuotedStr('IdtMsgLast') + ')' +
                          #10'  UPDATE ApplicCounter' +
                          #10'  SET NumCounterBig = ' + IntToStr(IdtMsg) +
                          #10'  WHERE IdtApplicCounter = ' +
                                               QuotedStr('CommMsgLow') +
                          #10'  AND TxtField = ' +
                                               QuotedStr('IdtMsgLast') +
                          #10'ELSE' +
                          #10'  INSERT INTO ApplicCounter ' +
                          #10'              (IdtApplicCounter, TxtField, ' +
                          #10'              NumCounterBig)' +
                          #10'  VALUES (' + QuotedStr('CommMsgLow') + ', ' +
                                            QuotedStr('IdtMsgLast') + ', ' +
                                            IntToStr(IdtMsg) + ')');

  DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
  DmdFpnADOUtilsCA.CloseInfo;
end;  // of TADOMQWSInterfaces.SetLastIdtMsg

//=============================================================================

procedure TADOMQWSInterfaces.ProcessAssyncOut(MQ : TWebSphereMQ);
var
  LstCommPOSTrans  : TList;                 // List of new POS transactions
  LstCommSafeTrans : TList;                 // List of new safe transactions
  TxtMessageOutBody: string;
  TxtMessageOutFormat: string;
begin  // of TADOMQWSInterfaces.ProcessAssyncOut
  LstCommPOSTrans := nil;
  LstCommSafeTrans := nil;
  try
    try
      DmdFpnADOCA.ADOConFlexpoint.Open;
      try
        DmdFpnADOCA.ADOConFlexpoint.BeginTrans;
      except
          on E: Exception do
            raise E.Create(CtTxtBeginTrans + E.Message);
      end;
      try
        if assigned(LstCommPOSTrans) then begin
          LstCommPOSTrans.Free;
          LstCommPOSTrans := nil;
        end;
        LstCommPOSTrans := TList.Create;
        CheckCommPOSTrans(LstCommPOSTrans);
        if LstCommPOSTrans.Count > 0 then begin
          FlgCOOffline := False;
          ProcessCommPOSTrans(LstCommPOSTrans, MQ);
        end;
      except
        on E: Exception do
          raise Exception.Create(CtTxtErrorPOSTrans + E.Message);
      end;
      try
        LstCommSafeTrans := TList.Create;
        CheckCommSafeTrans(LstCommSafeTrans);
        if LstCommSafeTrans.Count > 0 then begin
          ProcessCommSafeTrans(LstCommSafeTrans, MQ);
        end;
      except
        on E: Exception do
          raise Exception.Create(CtTxtErrorSafeTrans + E.Message);
      end;
    except
      on E: Exception do begin
        try
          if DmdFpnADOCA.ADOConFlexpoint.InTransaction then begin
            DmdFpnADOCA.ADOConFlexpoint.RollbackTrans;
          end;
        except
          on E: Exception do
          raise E.Create(CtTxtRollbackTrans + E.Message);
        end;
        ExceptionHandler(Self, E);
      end;
    end;
    try
      if DmdFpnADOCA.ADOConFlexpoint.InTransaction then begin
        DmdFpnADOCA.ADOConFlexpoint.CommitTrans;
      end;
    except
      on E: Exception do
      raise E.Create(CtTxtCommitTrans + E.Message);
    end;
  finally
    DmdFpnADOCA.ADOConFlexpoint.Close;
  end;
end;   // of TADOMQWSInterfaces.ProcessAssyncOut

//=============================================================================

procedure TADOMQWSInterfaces.ProcessSyncIn(TxtMsgInBody :  string);
  var
    ObjXMLDoc: IXMLDOMDocument;
    ObjXMLElement: IXMLDOMElement;
    ObjXMLList: IXMLDOMNodeList;
    IdtPosTransaction, IdtCheckout: integer;
    DatTransbegin: TDatetime;
    StrDate, StrTime, StrDateTime: string;
    ObjCommPOSTrans : TObjCommPOSTrans;
    LstCommPOSTrans : TList;
begin  // of TADOMQWSInterfaces.ProcessSyncIn
  try
    LstCommPOSTrans := nil;
    try
      DmdFpnADOCA.ADOConFlexpoint.Open;
      try
        DmdFpnADOCA.ADOConFlexpoint.BeginTrans;
      except
          on E: Exception do
            raise E.Create(CtTxtBeginTrans + E.Message);
      end;
      try
        ObjXMLDoc := CoDOMDocument.Create;
        ObjXMLDoc.loadXML(TxtMsgInBody);
        if ObjXMLDoc.parseError.reason <> '' then begin
          raise Exception.Create('Parse error -' + ObjXMLDoc.parseError.reason);
        end;
        ObjXMLElement := ObjXMLDoc.documentElement;
        ObjCommPOSTrans := TObjCommPOSTrans.Create;
        if assigned(LstCommPOSTrans) then begin
          LstCommPOSTrans.Free;
          LstCommPOSTrans := nil;
        end;
        LstCommPOSTrans := TList.Create;
        ObjCommPOSTrans.IdtPOSTransaction := StrToInt(ObjXMLElement.childNodes.item[0].Text);
        ObjCommPOSTrans.IdtCheckout := StrToInt(ObjXMLElement.childNodes.item[1].Text);
        StrDateTime := ObjXMLElement.childNodes.item[2].Text;
        StrDate := Copy(StrDateTime,1,4) + '-' + Copy(StrDateTime,5,2) + '-' +
                   Copy(StrDateTime,7,2);
        StrTime:= Copy(StrDateTime,10,8);
        StrDateTime := StrDate + ' ' + StrTime;
        ObjCommPOSTrans.DatTransBegin := StrToDateTime(StrDateTime, 'YYYY-MM-DD', 'hh:mm:ss');
        ObjCommPOSTrans.IdtTradematrix := ObjXMLElement.childNodes.item[3].Text;
        ObjCommPOSTrans.CodTrans := 1;
        LstCommPOSTrans.Add(ObjCommPOSTrans);
        ProcessCommPOSTrans(LstCommPOSTrans);
      except
        on E: Exception do
          raise Exception.Create(CtTxtErrorPOSTrans + E.Message);
      end;
    except
      on E: Exception do begin
        try
          if DmdFpnADOCA.ADOConFlexpoint.InTransaction then begin
            DmdFpnADOCA.ADOConFlexpoint.RollbackTrans;
          end;
        except
          on E: Exception do
          raise E.Create(CtTxtRollbackTrans + E.Message);
        end;
        ExceptionHandler(Self, E);
      end;
    end;
    try
      if DmdFpnADOCA.ADOConFlexpoint.InTransaction then begin
        DmdFpnADOCA.ADOConFlexpoint.CommitTrans;
      end;
    except
      on E: Exception do
      raise E.Create(CtTxtCommitTrans + E.Message);
    end;
  finally
    DmdFpnADOCA.ADOConFlexpoint.Close;
  end;
end;   // of TADOMQWSInterfaces.ProcessSyncIn

//=============================================================================
// TADOMQWSInterfaces.CheckCommPOSTrans : Check CommPOSTrans table for
//                                              new transactions
//=============================================================================

procedure TADOMQWSInterfaces.CheckCommPOSTrans (LstCommPOSTrans : TList);
var
  ObjCommPOSTrans   : TObjCommPOSTrans;      //CommPOSTrans object
begin  // of TADOMQWSInterfaces.CheckCommPOSTrans
  try
    try
      DstLstCommPOSTrans := DmdFpnADOMQWSPOSTransaction.ADOQryCommPOSTrans;
      DstLstCommPOSTrans.Active := True;
      DstLstCommPOSTrans.First;
      while not DstLstCommPOSTrans.Eof do begin
        ObjCommPOSTrans := TObjCommPOSTrans.Create;
        ObjCommPOSTrans.Fill(DstLstCommPOSTrans);
        LstCommPOSTrans.Add(ObjCommPOSTrans);
        DstLstCommPOSTrans.Next;
      end;
    except
      on E: Exception do
        ExceptionHandler(Self, E);
    end;
  finally
    DstLstCommPOSTrans.Close;
  end;
end;   // of TADOMQWSInterfaces.CheckCommPOSTrans

//=============================================================================
// TADOMQWSInterfaces.CheckCommSafeTrans : Check CommSafeTrans table for
//                                              new transactions
//=============================================================================

procedure TADOMQWSInterfaces.CheckCommSafeTrans (LstCommSafeTrans : TList);
var
  ObjLstCommSafeTrans   : TObjLstCommSafeTrans;      //LstCommSafeTrans object
begin  // of TADOMQWSInterfaces.CheckCommSafeTrans
  try
    try
      DstLstCommSafeTrans := DmdFpnADOMQWSSafeTransaction.ADOQryLstCommSafeTrans;
      DstLstCommSafeTrans.Active := True;
      DstLstCommSafeTrans.First;
      while not DstLstCommSafeTrans.Eof do begin
        ObjLstCommSafeTrans := TObjLStCommSafeTrans.Create;
        ObjLstCommSafeTrans.Fill(DstLstCommSafeTrans);
        LstCommSafeTrans.Add(ObjLstCommSafeTrans);
        DstLstCommSafeTrans.Next;
      end;
    except
      on E: Exception do
        ExceptionHandler(Self, E);
    end;
  finally
    DstLstCommSafeTrans.Close;
  end;
end;   // of TADOMQWSInterfaces.CheckCommSafeTrans

//=============================================================================
// TADOMQWSInterfaces.ProcessCommPOSTrans : Process new records in
//                                                CommPOSTrans table
//=============================================================================

procedure TADOMQWSInterfaces.ProcessCommPOSTrans (LstCommPOSTrans : TList;
                                                  MQ : TWebSphereMQ);
var
  ObjXMLDoc          : IXMLDOMDocument;       // XMLDocument for transactions
  ObjPOSTransaction  : TObjPOSTransaction;    //CommPOSTrans object
  LstPOSTransactions : TList;                 //List of POS transactions to send
  NumCount           : integer;               //Counter
  StrXMLText         : string;                //String containing XML message
  XMLFile            : Textfile;              //XML file for test purposes
begin  // of TADOMQWSInterfaces.ProcessCommPOSTrans
  LstPOSTransactions := nil;
  ObjXMLDoc := nil;
  try
    for NumCount := 0 to LstCommPOSTrans.Count - 1 do begin
      if assigned(LstPOSTransactions) then begin
        LstPOSTransactions.Free;
        LstPOSTransactions := nil;
      end;
      LstPOSTransactions := TList.Create;
      with DmdFpnADOMQWSPOSTransaction.ADOSprPOSTransactions.Parameters do begin
        ParamByName('@PrmDatTransBegin').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).DatTransBegin;
        ParamByName('@PrmIdtPOSTransaction').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtPOSTransaction;
        ParamByName('@PrmIdtCheckout').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtCheckOut ;
        ParamByName('@PrmCodTrans').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).CodTrans;
        ParamByName('@PrmIdtTradematrix').Value :=
               DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
      end;
      try
        DstLstPOSTransactions := DmdFpnADOMQWSPOSTransaction.ADOSprPOSTransactions;
        DstLstPOSTransactions.Active := True;
        DstLstPOSTransactions.First;
        while not DstLstPOSTransactions.Eof do begin
          ObjPOSTransaction := TObjPOSTransaction.Create;
          ObjPOSTransaction.Fill(DstLstPOSTransactions);
          LstPOSTransactions.Add(ObjPOSTransaction);
          DstLstPOSTransactions.Next;
        end;
      finally
        DstLstPOSTransactions.Close;
      end;
      ObjXMLDoc := CoDOMDocument.Create;
      try
        if LstPOSTransactions.Count > 0 then begin
          CreateAssyncOutMsgPOS(LstPOSTransactions, ObjXMLDoc, False);
          StrXMLText := '<?xml version="1.0" encoding="UTF-8"?>' +
                     #10'<!DOCTYPE I02_P>' + #10 + ObjXMLDoc.xml;

          MQ.SendMessage(StrXMLText, 'I02');

          (* Can be used for test purposes *)(*
          AssignFile(XMLFile, 'c:\JVL' + IntToStr(TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtPOSTransaction) + '.XML');
          ReWrite(XMLFile);
          WriteLn(XMLFile, '<?xml version="1.0" encoding="UTF-8"?>');
          WriteLn(XMLFile, '<!DOCTYPE I02_P>');
          WriteLn(XMLFile, ObjXMLDoc.xml);
          CloseFile(XMLFile);                *)

          with DmdFpnADOMQWSPOSTransaction.ADOQryUpdCommPOSTrans.Parameters do begin
            ParamByName('@PrmDatTransBegin').Value :=
                   TObjCommPOSTrans(LstCommPOSTrans[NumCount]).DatTransBegin;
            ParamByName('@PrmIdtPOSTransaction').Value :=
                   TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtPOSTransaction;
            ParamByName('@PrmIdtCheckout').Value :=
                   TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtCheckOut ;
            ParamByName('@PrmCodTrans').Value :=
                   TObjCommPOSTrans(LstCommPOSTrans[NumCount]).CodTrans;
          end;
        DmdFpnADOMQWSPOSTransaction.ADOQryUpdCommPOSTrans.ExecSQL;
        end;
      finally
        ObjXMLDoc := nil;
      end;
      if FlgCOOffline then begin
        try
          ObjXMLDoc := CoDOMDocument.Create;
          ProcessCOOffline(ObjXMLDoc);
          StrXMLText := '<?xml version="1.0" encoding="UTF-8"?>' +
                     #10'<!DOCTYPE I20_1_PS>' + #10 + ObjXMLDoc.xml;
          MQ.SendMessage(StrXMLText, 'I20_1');
          (* Can be used for test purposes *)(*
          AssignFile(XMLFile, 'c:\JVL' + floatToStr(IdtCVente) + '.XML');
          ReWrite(XMLFile);
          WriteLn(XMLFile, '<?xml version="1.0" encoding="UTF-8"?>');
          WriteLn(XMLFile, '<!DOCTYPE I20_1>');
          WriteLn(XMLFile, ObjXMLDoc.xml);
          CloseFile(XMLFile);                *)
        finally
          ObjXMLDoc := nil
        end;
      end;
    end;
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.ProcessCommPOSTrans

//=============================================================================
// TADOMQWSInterfaces.ProcessCOOffline : Process offline customer orders
//=============================================================================

procedure TADOMQWSInterfaces.ProcessCOOffline (ObjXMLDoc : IXMLDOMDocument);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLRoot         : IXMLDOMNode;           // Root node of XML message
  ObjXMLHeader,
  ObjXMLBody,
  ObjXMLReq,
  ObjXMLCustOrd,
  ObjArticle         : IXMLDOMNode;           // Objects for XML nodes
  ObjCOOffline       : TObjCOOffline;         // Object for Vente record
  ObjCOOfflineDet    : TObjCOOfflineDet;      // Object for Vente_Ligne record
  LstCOOfflineDet    : TList;                 // List voor ObjCOOfflineDet
  NumCount           : integer;               // Counter
begin  // of TADOMQWSInterfaces.ProcessCOOffline
  DmdFpnADOMQWSPOSTransaction.ADOQryVente.Parameters.ParamByName('@PrmIdtCVente').
                                                             Value := IdtCVente;
  try
    DstLstVente := DmdFpnADOMQWSPOSTransaction.ADOQryVente;
    DstLstVente.Active := True;
    DstLstVente.First;
    ObjCOOffline := TObjCOOffline.Create;
    ObjCOOffline.Fill(DstLstVente);
  finally
    DstLstVente.Close;
  end;
  DmdFpnADOMQWSPOSTransaction.ADOQryVente_Ligne.Parameters.
                                ParamByName('@PrmIdtCVente').Value := IdtCVente;
  try
    DstLstVente_Ligne := DmdFpnADOMQWSPOSTransaction.ADOQryVente_Ligne;
    DstLstVente_Ligne.Active := True;
    DstLstVente_Ligne.First;
    LstCOOfflineDet := nil;
    LstCOOfflineDet := TList.Create;
    while not DstLstVente_Ligne.Eof do begin
      ObjCOOfflineDet := TObjCOOfflineDet.Create;
      ObjCOOfflineDet.Fill(DstLstVente_Ligne);
      LstCOOfflineDet.Add(ObjCOOfflineDet);
      DstLstVente_Ligne.Next;
    end;
  finally
    DstLstVente.Close;
  end;
  try
    // Create root tag
    ObjXMLRoot := ObjXMLDoc.createElement('BNQ_EAI');
    ObjXMLDoc.appendChild(ObjXMLRoot);
    ObjXMLHeader := ObjXMLDoc.createElement('Header');
    ObjXMLHeader.appendChild (CreateElement ('StoreId',
                              DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    ObjXMLHeader.appendChild (CreateElement ('ResCode', ''));
    ObjXMLHeader.appendChild (CreateElement ('ResDesc', ''));
    ObjXMLHeader.appendChild (CreateElement ('A1', ''));
    ObjXMLHeader.appendChild (CreateElement ('A2', ''));
    ObjXMLHeader.appendChild (CreateElement ('A3', ''));
    ObjXMLHeader.appendChild (CreateElement ('A4', ''));
    ObjXMLHeader.appendChild (CreateElement ('A5', ''));
    ObjXmlRoot.appendChild(ObjXMLHeader);
    ObjXMLBody := ObjXMLDoc.createElement('Body');
    ObjXmlRoot.appendChild(ObjXMLBody);
    ObjXMLReq := ObjXMLDoc.createElement('Req');
    ObjXMLBody.appendChild(ObjXMLReq);
    ObjXMLCustOrd := ObjXMLDoc.CreateElement('Customer_Order');
    ObjXmlReq.AppendChild(ObjXMLCustOrd);
    ObjXMLCustOrd.appendChild (CreateElement ('IdtTradematrix',
                                           ObjCOOffline.WERKS));
    ObjXMLCustOrd.appendChild (CreateElement ('CVENTE',
                                           ObjCOOffline.VBELN));
    ObjXMLCustOrd.appendChild (CreateElement ('DCREATION',
                                           ObjCOOffline.ZDATE1));
    ObjXMLCustOrd.appendChild (CreateElement ('CCLIENT',
                                           ObjCOOffline.ZCARDNUM));
    ObjXMLCustOrd.appendChild (CreateElement ('NumCard',
                                           ObjCOOffline.ZCARDID));
    ObjXMLCustOrd.appendChild (CreateElement ('IdtChannel',
                                           ObjCOOffline.ZCHANNEL));
    ObjXMLCustOrd.appendChild (CreateElement ('PctDiscount',
                                           ObjCOOffline.ZDISCO));
    ObjXMLCustOrd.appendChild (CreateElement ('TxtNumPhone',
                                           ObjCOOffline.ZPHONE));
    ObjXMLCustOrd.appendChild (CreateElement ('TxdDeliveryArea',
                                           ObjCOOffline.ZAREA));
    ObjXMLCustOrd.appendChild (CreateElement ('TxtName',
                                           ObjCOOffline.ZNAME));
    ObjXMLCustOrd.appendChild (CreateElement ('TxtDeliveryAddress',
                                           ObjCOOffline.ZADDRESS));
    ObjXMLCustOrd.appendChild (CreateElement ('IdtCategory',
                                           ObjCOOffline.PSTYV));
    ObjXMLCustOrd.appendChild (CreateElement ('DatDelivery',
                                           ObjCOOffline.ZDATE2));
    ObjXMLCustOrd.appendChild (CreateElement ('Type_Vente',
                                           ObjCOOffline.ZPICK));
    ObjXMLCustOrd.appendChild (CreateElement ('TxtNotes',
                                           ObjCOOffline.ZMARKH));
    ObjXMLCustOrd.appendChild (CreateElement ('IdtPOSTransaction',
                                           ObjCOOffline.POSTRXN));
    ObjXMLCustOrd.appendChild (CreateElement ('M_ACOMPTE_VERSE_REEL',
                                           ObjCOOffline.NETWR2));
    ObjXMLCustOrd.appendChild (CreateElement ('IdtCheckout',
                                           ObjCOOffline.ZTILLNUM));
    ObjXMLCustOrd.appendChild (CreateElement ('DatTransBegin',
                                           ObjCOOffline.ZTRANSDATE));
    for NumCount := 0 to LstCOOfflineDet.Count - 1 do begin
      // Create Article Child
      ObjArticle := ObjXMLDoc.createElement('Customer_Order_Item');
      ObjArticle.appendChild (CreateElement ('NumSeq',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).POSNR));
      ObjArticle.appendChild (CreateElement ('IdtArticle',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).MATNR));
      ObjArticle.appendChild (CreateElement ('QtySales',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).MENGE));
      ObjArticle.appendChild (CreateElement ('PrcInclVat',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).NETPR));
      ObjArticle.appendChild (CreateElement ('TxtNotes',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).ZMARKI));
      ObjArticle.appendChild (CreateElement ('NumPLU',
                           TObjCOOfflineDet(LstCOOfflineDet[NumCount]).EAN11));
      ObjXMLCustOrd.appendChild(ObjArticle);
      ObjArticle := nil;
    end;
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.ProcessCOOffline

//=============================================================================
// TADOMQWSInterfaces.ProcessCommPOSTrans : Process new records in
//                                                CommPOSTrans table
//=============================================================================

procedure TADOMQWSInterfaces.ProcessCommPOSTrans (LstCommPOSTrans : TList);
var
  ObjXMLDoc          : IXMLDOMDocument;       // XMLDocument for transactions
  ObjPOSTransaction  : TObjPOSTransaction;    //CommPOSTrans object
  LstPOSTransactions : TList;                 //List of POS transactions to send
  NumCount           : integer;               //Counter
  StrXMLText         : string;                //String containing XML message
  XMLFile            : Textfile;              //XML file for test purposes
begin  // of TADOMQWSInterfaces.ProcessCommPOSTrans
  LstPOSTransactions := nil;
  ObjXMLDoc := nil;
  try
    for NumCount := 0 to LstCommPOSTrans.Count - 1 do begin
      if assigned(LstPOSTransactions) then begin
        LstPOSTransactions.Free;
        LstPOSTransactions := nil;
      end;
      LstPOSTransactions := TList.Create;
      with DmdFpnADOMQWSPOSTransaction.ADOSprPOSTransactions.Parameters do begin
        ParamByName('@PrmDatTransBegin').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).DatTransBegin;
        ParamByName('@PrmIdtPOSTransaction').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtPOSTransaction;
        ParamByName('@PrmIdtCheckout').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).IdtCheckOut ;
        ParamByName('@PrmCodTrans').Value :=
               TObjCommPOSTrans(LstCommPOSTrans[NumCount]).CodTrans;
        ParamByName('@PrmIdtTradematrix').Value :=
               DmdFpnADOUtilsCA.IdtTradeMatrixAssort;
      end;
      try
        DstLstPOSTransactions := DmdFpnADOMQWSPOSTransaction.ADOSprPOSTransactions;
        DstLstPOSTransactions.Active := True;
        DstLstPOSTransactions.First;
        while not DstLstPOSTransactions.Eof do begin
          ObjPOSTransaction := TObjPOSTransaction.Create;
          ObjPOSTransaction.Fill(DstLstPOSTransactions);
          LstPOSTransactions.Add(ObjPOSTransaction);
          DstLstPOSTransactions.Next;
        end;
      finally
        DstLstPOSTransactions.Close;
      end;
      ObjXMLDoc := CoDOMDocument.Create;
      try
        if LstPOSTransactions.Count > 0 then
          CreateAssyncOutMsgPOS(LstPOSTransactions, ObjXMLDoc, True)
        else
          ConstructEmptyMsg (ObjXMLDoc, LstCommPOSTrans);
        TxtMsgOutBody := '<?xml version="1.0" encoding="UTF-8"?>' +
                   #10'<!DOCTYPE I15_02_SP>' + #10 + ObjXMLDoc.xml;
        TxtMsgOutFormat := 'I15_02C';
      finally
        ObjXMLDoc := nil;
      end;
    end;
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.ProcessCommPOSTrans

//=============================================================================
// TADOMQWSInterfaces.ProcessCommPOSTrans : Process new records in
//                                                CommPOSTrans table
//=============================================================================

procedure TADOMQWSInterfaces.ProcessCommSafeTrans (LstCommSafeTrans : TList;
                                                   MQ : TWebSphereMQ);
var
  ObjXMLDoc           : IXMLDOMDocument;       //XMLDocument for transactions
  ObjDetCommSafeTrans : TObjDetCommSafeTrans;  //CommSafeTrans object
  LstSafeTransactions : TList;                 //List of POS transactions to send
  NumCount            : integer;               //Counter
  StrXMLText         : string;                 //String containing XML message
  XMLFile            : Textfile;               //XML file for test purposes
begin  // of TADOMQWSInterfaces.ProcessCommSafeTrans
  LstSafeTransactions := nil;
  ObjXMLDoc := nil;
  try
    for NumCount := 0 to LstCommSafeTrans.Count - 1 do begin
      if assigned(LstSafeTransactions) then begin
        LstSafeTransactions.Free;
        LstSafeTransactions := nil;
      end;
      LstSafeTransactions := TList.Create;
      DmdFpnADOMQWSSafeTransaction.ADOQryDetCommSafeTrans.Parameters.
            ParamByName('@PrmIdtSafeTransaction').Value :=
            TObjLstCommSafeTrans(LstCommSafeTrans[NumCount]).IdtSafeTransaction;
      try
        DstLstCommSafeTrans := DmdFpnADOMQWSSafeTransaction.ADOQryDetCommSafeTrans;
        DstLstCommSafeTrans.Active := True;
        DstLstCommSafeTrans.First;
        while not DstLstCommSafeTrans.Eof do begin
          ObjDetCommSafeTrans := TObjDetCommSafeTrans.Create;
          ObjDetCommSafeTrans.Fill(DstLstCommSafeTrans);
          LstSafeTransactions.Add(ObjDetCommSafeTrans);
          DstLstCommSafeTrans.Next;
        end;
      finally
        DstLstCommSafeTrans.Close;
      end;
      ObjXMLDoc := CoDOMDocument.Create;
      try
        CreateAssyncOutMsgSafe(LstSafeTransactions, ObjXMLDoc);
        StrXMLText := '<?xml version="1.0" encoding="UTF-8"?>' +
                   #10'<!DOCTYPE I02_P>' + #10 + ObjXMLDoc.xml;
        MQ.SendMessage(StrXMLText, 'I04');
        (* Can be used for test purposes *)(*
        AssignFile(XMLFile, 'c:\JVL' + IntToStr(TObjLstCommSafeTrans(LstCommSafeTrans[NumCount]).IdtSafeTransaction) + '.XML');
        ReWrite(XMLFile);
        WriteLn(XMLFile, '<?xml version="1.0" encoding="UTF-8"?>');
        WriteLn(XMLFile, '<!DOCTYPE I02_P>');
        WriteLn(XMLFile, ObjXMLDoc.xml);
        CloseFile(XMLFile);                *)

        with DmdFpnADOMQWSSafeTransaction.ADOQryUpdCommSafeTrans.Parameters do begin
          ParamByName('@PrmIdtSafeTransaction').Value :=
                 TObjLstCommSafeTrans(LstCommSafeTrans[NumCount]).IdtSafeTransaction;
        end;
        DmdFpnADOMQWSSafeTransaction.ADOQryUpdCommSafeTrans.ExecSQL;
      finally
        ObjXMLDoc := nil;
      end;
    end;
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.ProcessCommSafeTrans

//=============================================================================
// TADOMQWSInterfaces.CreateAssyncOutMsgPOS : Create XML msg for POS transaction
//                                  -----
// INPUT : LstPOSTransactions = Recordset of POS transactions
//         ObjXMLDoc = XML document object
//=============================================================================

procedure TADOMQWSInterfaces.ConstructEmptyMsg
                                           (ObjXMLDoc    : IXMLDOMDocument;
                                           LstCommPOSTrans : TList);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLRoot: IXMLDOMNode;                    // Root node of XML message
  ObjXMLHeader,
  ObjXMLBody,
  ObjXMLReq,
  ObjXMLRes,
  ObjXMLResKey,
  ObjXMLTicket       : IXMLDOMNode;           // Objects for XML nodes
  NumCount           : integer;               // Counter
begin  // of TADOMQWSInterfaces.ConstructEmptyMsg
  try
    // Create root tag
    ObjXMLRoot := ObjXMLDoc.createElement('BNQ_EAI');
    ObjXMLDoc.appendChild(ObjXMLRoot);
    ObjXMLHeader := ObjXMLDoc.createElement('Header');
    ObjXMLHeader.appendChild (CreateElement ('StoreId',
                              DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    ObjXMLHeader.appendChild (CreateElement ('ResCode', ''));
    ObjXMLHeader.appendChild (CreateElement ('ResDesc', ''));
    ObjXMLHeader.appendChild (CreateElement ('A1', ''));
    ObjXMLHeader.appendChild (CreateElement ('A2', ''));
    ObjXMLHeader.appendChild (CreateElement ('A3', ''));
    ObjXMLHeader.appendChild (CreateElement ('A4', ''));
    ObjXMLHeader.appendChild (CreateElement ('A5', ''));
    ObjXmlRoot.appendChild(ObjXMLHeader);
    ObjXMLBody := ObjXMLDoc.createElement('Body');
    ObjXmlRoot.appendChild(ObjXMLBody);
    ObjXMLReq := ObjXMLDoc.createElement('Req');
    ObjXMLBody.appendChild(ObjXMLReq);
    ObjXMLResKey := ObjXMLDoc.createElement('In_Stock_Delivery');
    ObjXMLResKey.appendChild (CreateElement ('IdtPosTransaction',
                       TObjCommPOSTrans(LstCommPOSTrans[0]).IdtPOSTransaction));
    ObjXMLResKey.appendChild (CreateElement ('IdtCheckout',
                       TObjCommPOSTrans(LstCommPOSTrans[0]).IdtCheckOut));
    ObjXMLResKey.appendChild (CreateElement ('DatTransbegin',
                       TObjCommPOSTrans(LstCommPOSTrans[0]).DatTransBegin));
    ObjXMLResKey.appendChild (CreateElement ('IdtTradematrix',
                       TObjCommPOSTrans(LstCommPOSTrans[0]).IdtTradematrix));
    ObjXMLReq.appendChild(ObjXMLResKey);
    ObjXMLRes := ObjXMLDoc.createElement('Res');
    ObjXMLBody.appendChild(ObjXMLRes);
    ObjXMLTicket := ObjXMLDoc.createElement('In_Stock_Delivery');
    // Create Ticket tag
    ObjXMLTicket.appendChild (CreateElement ('CodType', ''));
    ObjXMLTicket.appendChild (CreateElement ('IdtPosTransaction', ''));
    ObjXMLTicket.appendChild (CreateElement ('IdtTradematrix', ''));
    ObjXMLTicket.appendChild (CreateElement ('IdtCheckout', ''));
    ObjXMLTicket.appendChild (CreateElement ('DatTransbegin', ''));
    ObjXMLTicket.appendChild (CreateElement ('IdtOperator', ''));
    ObjXMLRes.appendChild(ObjXMLTicket)
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.ConstructEmptyMsg

//=============================================================================
// TADOMQWSInterfaces.CreateAssyncOutMsgPOS : Create XML msg for POS transaction
//                                  -----
// INPUT : LstPOSTransactions = Recordset of POS transactions
//         ObjXMLDoc = XML document object
//=============================================================================

procedure TADOMQWSInterfaces.CreateAssyncOutMsgPOS
                                           (LstPOSTransactions : TList;
                                            ObjXMLDoc    : IXMLDOMDocument;
                                            FlgSync : boolean);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLRoot: IXMLDOMNode;                    // Root node of XML message
  ObjXMLHeader,
  ObjXMLBody,
  ObjXMLReq,
  ObjXMLRes,
  ObjXMLResKey,
  ObjXMLTicket       : IXMLDOMNode;           // Objects for XML nodes
  NumCount           : integer;               // Counter
begin  // of TADOMQWSInterfaces.CreateAssyncOutMsg
  try
    // Create root tag
    ObjXMLRoot := ObjXMLDoc.createElement('BNQ_EAI');
    ObjXMLDoc.appendChild(ObjXMLRoot);
    ObjXMLHeader := ObjXMLDoc.createElement('Header');
    ObjXMLHeader.appendChild (CreateElement ('StoreId',
                              DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    ObjXMLHeader.appendChild (CreateElement ('ResCode', ''));
    ObjXMLHeader.appendChild (CreateElement ('ResDesc', ''));
    ObjXMLHeader.appendChild (CreateElement ('A1', ''));
    ObjXMLHeader.appendChild (CreateElement ('A2', ''));
    ObjXMLHeader.appendChild (CreateElement ('A3', ''));
    ObjXMLHeader.appendChild (CreateElement ('A4', ''));
    ObjXMLHeader.appendChild (CreateElement ('A5', ''));
    ObjXmlRoot.appendChild(ObjXMLHeader);
    ObjXMLBody := ObjXMLDoc.createElement('Body');
    ObjXmlRoot.appendChild(ObjXMLBody);
    if FlgSync then begin
      ObjXMLReq := ObjXMLDoc.createElement('Req');
      ObjXMLBody.appendChild(ObjXMLReq);
      ObjXMLResKey := ObjXMLDoc.createElement('In_Stock_Delivery');
      ObjXMLResKey.appendChild (CreateElement ('IdtPosTransaction',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtPOSTransaction));
      ObjXMLResKey.appendChild (CreateElement ('IdtCheckout',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckout));
      ObjXMLResKey.appendChild (CreateElement ('DatTransbegin',
                    FormatDateTime('yyyymmdd hh:mm:ss',
                    TObjPOSTransaction(LstPOSTransactions[0]).DatTransbegin)));
      ObjXMLResKey.appendChild (CreateElement ('IdtTradematrix',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtTradematrix));
      ObjXMLReq.appendChild(ObjXMLResKey);
      ObjXMLRes := ObjXMLDoc.createElement('Res');
      ObjXMLBody.appendChild(ObjXMLRes);
      ObjXMLTicket := ObjXMLDoc.createElement('In_Stock_Delivery');
    end
    else begin
      ObjXMLReq := ObjXMLDoc.createElement('Req');
      ObjXMLBody.appendChild(ObjXMLReq);
      ObjXMLTicket := ObjXMLDoc.createElement('Ticket');
    end;
    // Create Ticket tag
    LstPOSTransactions.First;
    FlgSavingCard := False;
    for NumCount := 0 to LstPOSTransactions.Count - 1 do
      if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction =
      CtCodActChargeSavingCard) or (TObjPOSTransaction(LstPOSTransactions[NumCount]).
      CodAction = CtCodActWithdrawSavingCard) then
        FlgSavingCard := True;

    FlgTickNegative := False;
// SVE: Check if ticket is negative
    for NumCount := 0 to LstPOSTransactions.Count - 1 do
      if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActTotal) 
         and (TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVat < 0) then
        FlgTickNegative  := True;


    if FlgSavingCard then
      ObjXMLTicket.appendChild (CreateElement ('CodType', '2'))
    else if TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 99 then
      ObjXMLTicket.appendChild (CreateElement ('CodType', '5'))
    else if TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 6 then begin
      ObjXMLTicket.appendChild (CreateElement ('CodType', '4'));
      with DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.Parameters do begin
        ParamByName('@PrmIdtPOSTransAction').Value :=
             TObjPOSTransaction(LstPOSTransactions[0]).IdtPOSTransaction;
        ParamByName('@PrmIdtCheckOut').Value :=
             TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckOut;
        ParamByName('@PrmDatTransBegin').Value :=
             TObjPOSTransaction(LstPOSTransactions[0]).DatTransBegin;
      end;
      try
        DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.Active := true;
        DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.ExecSQL;
        if DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.RecordCount > 0 then begin
          TObjPOSTransaction(LstPOSTransactions[0]).IdtPOStransResume :=
                      DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.
                      FieldByName('IdtPOSTransaction').AsInteger;
          TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckOutResume :=
                      DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.
                      FieldByName('IdtCheckOut').AsInteger;
          TObjPOSTransaction(LstPOSTransactions[0]).DatTransBeginResume :=
                      DmdFpnADOMQWSPOSTransaction.ADOQryCancelTicket.
                      FieldByName('DatTransBegin').AsDateTime;
        end;
      finally
        DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.Close;
      end;
    end
    else
      ObjXMLTicket.appendChild (CreateElement ('CodType', '1'));
    ObjXMLTicket.appendChild (CreateElement ('IdtPosTransaction',
                  TObjPOSTransaction(LstPOSTransactions[0]).IdtPOSTransaction));
    ObjXMLTicket.appendChild (CreateElement ('IdtTradematrix',
                  TObjPOSTransaction(LstPOSTransactions[0]).IdtTradematrix));
    ObjXMLTicket.appendChild (CreateElement ('IdtCheckout',
                  TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckout));
    ObjXMLTicket.appendChild (CreateElement ('DatTransbegin',
                  FormatDateTime('yyyymmdd hh:mm:ss',
                  TObjPOSTransaction(LstPOSTransactions[0]).DatTransbegin)));
    ObjXMLTicket.appendChild (CreateElement ('IdtOperator',
                  TObjPOSTransaction(LstPOSTransactions[0]).IdtOperator));
    if TObjPOSTransaction(LstPOSTransactions[0]).IdtPersonnel <> '' then
      ObjXMLTicket.appendChild (CreateElement ('IdtPersonnel',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtPersonnel));
    if TObjPOSTransaction(LstPOSTransactions[0]).TxtNamePers <> '' then
      ObjXMLTicket.appendChild (CreateElement ('TxtNamePers',
                    TObjPOSTransaction(LstPOSTransactions[0]).TxtNamePers));
    if (TObjPOSTransaction(LstPOSTransactions[0]).IdtPOStransResume > 0) and
    (TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 6) then
      ObjXMLTicket.appendChild (CreateElement ('IdtPosTransOriginal',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtPOStransResume));
    if (TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckOutResume > 0) and
    (TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 6) then
      ObjXMLTicket.appendChild (CreateElement ('IdtCheckoutOriginal',
                    TObjPOSTransaction(LstPOSTransactions[0]).IdtCheckOutResume));
    if (TObjPOSTransaction(LstPOSTransactions[0]).DatTransBeginResume > 0) and
    (TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 6) then
      ObjXMLTicket.appendChild (CreateElement ('IdtDateTimeOriginal',
                    FormatDateTime('yyyymmdd hh:mm:ss',
                    TObjPOSTransaction(LstPOSTransactions[0]).DatTransBeginResume)));
    if (TObjPOSTransaction(LstPOSTransactions[0]).IdtPOStransResume > 0) and
    (TObjPOSTransaction(LstPOSTransactions[0]).CodTrans = 6) then
      ObjXMLTicket.appendChild (CreateElement ('IdtTradematrixOriginal',
                    DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    if FlgSync then
      ObjXMLRes.appendChild(ObjXMLTicket)
    else
      ObjXMLReq.appendChild(ObjXMLTicket);

    AddArticles(LstPOSTransactions, ObjXMLTicket, ObjXMLDoc, FlgSync);
    AddDeposit(LstPOSTransactions, ObjXMLTicket, ObjXMLDoc);
    AddCustomer(LstPOSTransactions, ObjXMLTicket, ObjXMLDoc);
    if not flgSync then
      AddPayment(LstPOSTransactions, ObjXMLTicket, ObjXMLDoc);
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.CreateAssyncOutMsgPOS

//=============================================================================

procedure TADOMQWSInterfaces.AddArticles (LstPOSTransactions : TList;
                                          ObjXMLTicket    : IXMLDOMNode;
                                          ObjXMLDoc    : IXMLDOMDocument;
                                          FlgSync      : boolean);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLArticle,
  ObjXMLDiscount     : IXMLDOMNode;           // Object for XML node
  NumCount           : integer;               // Counter
  FlgArtDisc         : boolean;               // Article Discount
  ValFloat           : string;                // Float value
  IdtCVente          : string;                // BO document number
begin  // of TADOMQWSInterfaces.AddArticles
  for NumCount := 0 to LstPOSTransactions.Count - 1 do begin
  if TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActDocBO then
    IdtCVente := FloatToStr(TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCVente);
  if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType = CtCodPdtTurnOver) or
    ((TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActComment) and
    (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType = CtCodPdtCommentArtInfoCustOrder)) then begin
      FlgArtDisc := False;
      if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActDiscArtVal) and
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActFree) and
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActPrcCampaign) and
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActDiscCust) and
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActPrcOverwrite) and
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction <> CtCodActPayAdvance) then begin
        // Create Article Child
        if (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction <> CtCodActCorrection) then begin
          ObjXMLArticle := ObjXMLDoc.createElement('article');
          ObjXMLArticle.appendChild (CreateElement ('IdtArticle',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtArticle));
          ObjXMLArticle.appendChild (CreateElement ('NumPLU',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).NumPLU));
          ObjXMLArticle.appendChild (CreateElement ('TxtDescr',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).TxtDescr));
          ObjXMLArticle.appendChild (CreateElement ('IdtClassification',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtClassification));
          ObjXMLArticle.appendChild (CreateElement ('CodTypeArticle',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).CodTypeArticle));
          if FlgSync then begin
            ValFloat := FormatFloat (CtTxtFrmNumberExt,
                                     TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                     TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned);
            ReplaceString(ValFloat, ',', '.');
            ObjXMLArticle.appendChild (CreateElement ('QtySales', ValFloat));

          end
          else begin
            ValFloat := FormatFloat (CtTxtFrmNumberExt,
                                     TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg);
            ReplaceString(ValFloat, ',', '.');
            ObjXMLArticle.appendChild (CreateElement ('QtySales', ValFloat));
          end;
          if (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActDiscArtVal) or
          (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActFree) or
          (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActPrcCampaign) or
          (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActDiscCust) or
          (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActPrcOverwrite) then begin
            FlgArtDisc := True;
            // Create Discount Child
            ObjXMLDiscount := ObjXMLDoc.createElement('discount');
            ObjXMLDiscount.appendChild (CreateElement ('IdtDiscount',
                        TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction));
            if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActDiscArtVal then begin
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc',ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                             (- TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT *
                               (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)) /
                             TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber, -
                            TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLDiscount.appendChild (CreateElement ('ValDiscount',ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber,
                          (TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                          TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT)/
                          TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                            ( ( TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                                TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT) *
                              (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)) /
                             TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                            TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                            TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('ValInclVAT', ValFloat));
            end
            else if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActPrcOverwrite then begin
              ValFloat := FormatFloat (CtTxtFrmNumber,
                          TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT -
                          TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc',ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT *
                                          (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                           TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)) /
                                         TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLDiscount.appendChild (CreateElement ('ValDiscount', ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         (TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT *
                                          (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                           TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)) /
                                         TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg);
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('ValInclVAT', ValFloat));
            end
            else if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActPrcCampaign then begin
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                            ((TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT -
                              TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT) *
                             (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                              TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                            ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                             TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT -
                            TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLDiscount.appendChild (CreateElement ('ValDiscount',ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT *
                                           (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                            TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                                          ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg
                                         );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('ValInclVAT',ValFloat));
            end
            else if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActDiscCust then begin
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         ( -TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT *
                                         (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                          TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                                         ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                             -TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);

              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLDiscount.appendChild (CreateElement ('ValDiscount',ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber, (TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                          TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT)/
                          TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                                         ((TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                                         TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT) *
                                         (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                          TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                                         ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg  );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT +
                            TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('ValInclVAT',ValFloat));
            end
            else begin
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc',ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              if FlgSync then begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                            ( (TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT -
                               TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT)*
                              (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                               TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                            ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber,
                             TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT -
                            TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLDiscount.appendChild (CreateElement ('ValDiscount',ValFloat));
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).PrcInclVAT);
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
              if FlgSync then begin
                ValFloat := FormatFloat
                            (CtTxtFrmNumber,
                               (TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT *
                                (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)) /
                                TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
              end
              else begin
                ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount+1]).ValInclVAT);
              end;
              ReplaceString(ValFloat, ',', '.');
              ObjXMLArticle.appendChild (CreateElement ('ValInclVAT',ValFloat));
            end;
          end
          else begin
            ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
            ReplaceString(ValFloat, ',', '.');
            ObjXMLArticle.appendChild (CreateElement ('PrcExclDisc',ValFloat));
            ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).PrcInclVAT);
            ReplaceString(ValFloat, ',', '.');
            ObjXMLArticle.appendChild (CreateElement ('PrcInclDisc', ValFloat));
            if FlgSync then begin
              ValFloat := FormatFloat
                            (CtTxtFrmNumber,
                             ( TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT *
                               (TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg -
                                TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReturned)
                             ) / TObjPOSTransaction(LstPOSTransactions[NumCount]).QtyReg );
            end
            else begin
              ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT);
            end;
            ReplaceString(ValFloat, ',', '.');
            ObjXMLArticle.appendChild (CreateElement ('ValInclVAT',ValFloat));
          end;
          ObjXMLArticle.appendChild (CreateElement ('IdtCurrency',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCurrency));
          if TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtArticle <> '' then begin
            with DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.Parameters do begin
              ParamByName('@PrmIdtArticle').Value :=
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtArticle;
              ParamByName('@PrmDatTrans').Value :=
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).DatTransBegin;
            end;
            try
              DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.Active := true;
              DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.ExecSQL;
              if DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.RecordCount > 0 then
                ObjXMLArticle.appendChild (CreateElement ('IdtCampaign',
                            DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.
                            FieldByName('IdtCampaign').AsString));
            finally
              DmdFpnADOMQWSPOSTransaction.ADOQryCampaign.Close;
            end;
          end;
          if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActComment) and
          (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType = CtCodPdtCommentArtInfoCustOrder) then
            ObjXMLArticle.appendChild (CreateElement ('IdtCVente',IdtCVente));
          ObjXMLArticle.appendChild (CreateElement ('IdtVAT',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtVATCode));
          ObjXMLArticle.appendChild (CreateElement ('PctVAT',
                      TObjPOSTransaction(LstPOSTransactions[NumCount]).PctVAT));
          if NumCount > 0 then begin
            if TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtPosTransOrig > 0 then
              ObjXMLArticle.appendChild (CreateElement ('IdtPosTransOriginal',
                            TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtPosTransOrig));
            if TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtCheckOutOrig > 0 then
              ObjXMLArticle.appendChild (CreateElement ('IdtCheckoutOriginal',
                            TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtCheckOutOrig));
            if TObjPOSTransaction(LstPOSTransactions[NumCount-1]).DatTransBeginOrig > 0 then
              ObjXMLArticle.appendChild (CreateElement ('IdtDateTimeOriginal',
                            FormatDateTime('yyyymmdd hh:mm:ss',
                            TObjPOSTransaction(LstPOSTransactions[NumCount-1]).DatTransBeginOrig)));
            if TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtTradeMatrixOrig <> '' then
              ObjXMLArticle.appendChild (CreateElement ('IdtTradematrixOriginal',
                            TObjPOSTransaction(LstPOSTransactions[NumCount-1]).IdtTradeMatrixOrig));
          end;
          if FlgArtDisc then
            ObjXMLArticle.appendChild(ObjXMLDiscount);
          ObjXMLTicket.appendChild(ObjXMLArticle);
        end;
      end;
    end
  end;
  ObjXMLArticle := nil;
end;   // of TADOMQWSInterfaces.AddArticles

//=============================================================================

procedure TADOMQWSInterfaces.AddDeposit (LstPOSTransactions : TList;
                                         ObjXMLTicket    : IXMLDOMNode;
                                         ObjXMLDoc    : IXMLDOMDocument);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLDeposit      : IXMLDOMNode;           // Object for XML node
  NumCount           : integer;               // Counter
  ValFloat           : string;                // Float value
begin  // of TADOMQWSInterfaces.AddDeposit
  for NumCount := 0 to LstPOSTransactions.Count - 1 do begin
    if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType =
    CtCodPdtTurnOver) and (TObjPOSTransaction(LstPOSTransactions[NumCount]).
    IdtCVente > 0) and (TObjPOSTransaction(LstPOSTransactions[NumCount]).
    CodAction = CtCodActPayAdvance) then begin
      // Create Deposit Child
      ObjXMLDeposit := ObjXMLDoc.createElement('deposit');
      ObjXMLDeposit.appendChild (CreateElement ('IdtCVente',
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCVente));
      FlgCOOffline := CheckOffline(TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCVente);
      IdtCVente := TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCVente;
      ObjXMLDeposit.appendChild (CreateElement ('CodTypeVente',
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).CodTypeVente));
      ValFloat := FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT);
      ReplaceString(ValFloat, ',', '.');
      ObjXMLDeposit.appendChild (CreateElement ('ValSales', ValFloat));
      ObjXMLDeposit.appendChild (CreateElement ('IdtCurrency',
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCurrency));
      ObjXMLTicket.appendChild(ObjXMlDeposit);
    end;
  end;
  ObjXMLDeposit := nil;
end;   // of TADOMQWSInterfaces.AddDeposit

//=============================================================================

procedure TADOMQWSInterfaces.AddCustomer (LstPOSTransactions : TList;
                                          ObjXMLTicket    : IXMLDOMNode;
                                          ObjXMLDoc    : IXMLDOMDocument);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLCustomer     : IXMLDOMNode;           // Object for XML node
  NumCount           : integer;               // Counter
  FlgCustomer        : boolean;               // Customer already found?
  StrNumPLU          : string;                // PLU number
begin  // of TADOMQWSInterfaces.AddCustomer
  FlgCustomer := False;
  for NumCount := 0 to LstPOSTransactions.Count - 1 do begin
    if (TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCustomer > 0) and
    not FlgCustomer then begin
      FlgCustomer := True;
      // Create Customer Child
      ObjXMLCustomer := ObjXMLDoc.createElement('customer');
      ObjXMLCustomer.appendChild (CreateElement ('IdtCustomer',
                 TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCustomer));
      StrNumPLU :=
                 TObjPOSTransaction(LstPOSTransactions[NumCount]).TxtSrcNumCard;
      // Copy last 12 characters
      StrNumPLU := CopyRightW(StrNumPLU, (Length (StrNumPLU) - 12) + 1);
      ObjXMLCustomer.appendChild (CreateElement ('TxtSrcNumCard', StrNumPLU));
      ObjXMLCustomer.appendChild (CreateElement ('TxtName',
                 TObjPOSTransaction(LstPOSTransactions[NumCount]).TxtName));
      (*
      ObjXMLCustomer.appendChild (CreateElement ('QtyPoint', 0));
      *)
      ObjXMLCustomer.appendChild (CreateElement ('CodCustCard',
                 TObjPOSTransaction(LstPOSTransactions[NumCount]).CodCustCard));
      ObjXMLTicket.appendChild(ObjXMLCustomer);
    end;
  end;
  ObjXMLCustomer := nil;
end;   // of TADOMQWSInterfaces.AddCustomer

//=============================================================================

procedure TADOMQWSInterfaces.AddPayment (LstPOSTransactions : TList;
                                         ObjXMLTicket    : IXMLDOMNode;
                                         ObjXMLDoc    : IXMLDOMDocument);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLPayment      : IXMLDOMNode;           // Object for XML node
  NumCount           : integer;               // Counter
  NumCount2          : integer;               // Counter
  FlgCoupon          : boolean;               // Coupon payment
  FlgSaving          : boolean;               // Saving card
  StrSavingCard      : string;                // Saving card number
  StrFlgOffline      : string;                // Offline
  ValInclVAT         : Currency;              // Value incl. VAT
  StrNumPLU          : string;                // PLU number
  ValFloat           : string;                // Float value
  LstCumuls          : TList;                 // Stringlist with payment methods
                                              // to cumulate
  FlgCumul           : boolean;
begin  // of TADOMQWSInterfaces.AddPayment
  if not FlgSavingCard then begin
    LstCumuls := TList.Create;
    RetrieveCumulPaymethods(LstCumuls);
    for NumCount := 0 to LstPOSTransactions.Count - 1 do begin
      for NumCount2 := 0 to LstCumuls.Count -1 do begin
        if Trim(TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtClassification) =
        Trim(TObjCumuls(LstCumuls[NumCount2]).IdtClassification) then begin
          TObjCumuls(LstCumuls[NumCount2]).IdtCurrency :=
                     TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCurrency;
          if TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActReturn then
            TObjCumuls(LstCumuls[NumCount2]).ValInclVAT :=
                   TObjCumuls(LstCumuls[NumCount2]).ValInclVAT +
                   TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT
          else
            TObjCumuls(LstCumuls[NumCount2]).ValInclVAT :=
                   TObjCumuls(LstCumuls[NumCount2]).ValInclVAT +
                   (-TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT);
        end;
      end;
    end;
    for NumCount2 := 0 to LstCumuls.Count -1 do begin
      if TObjCumuls(LstCumuls[NumCount2]).ValInclVAT <> 0 then begin
        ValInclVat := TObjCumuls(LstCumuls[NumCount2]).ValInclVat;
        if FlgTickNegative then begin
          if ValInclVat > 0 then begin
            if (NumCount2 + 1) <= LstCumuls.Count - 1 then begin
              TObjCumuls(LstCumuls[NumCount2 + 1]).ValInclVat :=
                         TObjCumuls(LstCumuls[NumCount2 + 1]).ValInclVat +
                         ValInclVat;
              ValInclVat := 0;
            end;
            end;
          end
        else
          if ValInclVat < 0 then begin
            if (NumCount2 + 1) <= LstCumuls.Count - 1 then begin
              TObjCumuls(LstCumuls[NumCount2 + 1]).ValInclVat :=
                         TObjCumuls(LstCumuls[NumCount2 + 1]).ValInclVat +
                         ValInclVat;
              ValInclVat := 0;
          end;
        end;
        if ValInclVat <> 0 then begin
          ObjXMLPayment := ObjXMLDoc.createElement('payment');
          ObjXMLPayment.appendChild (CreateElement ('IdtCurrency',
                               TObjCumuls(LstCumuls[NumCount2]).IdtCurrency));
          ObjXMLPayment.appendChild (CreateElement ('IdtClassification',
                               TObjCumuls(LstCumuls[NumCount2]).IdtClassification));
          ValFloat := FormatFloat (CtTxtFrmNumber, ValInclVat);
          ReplaceString(ValFloat, ',', '.');
          ObjXMLPayment.appendChild (CreateElement ('ValInclVAT',ValFloat));
          ObjXMLTicket.appendChild(ObjXMLPayment);
        end;
      end;
    end;
  end;              
  for NumCount := 0 to LstPOSTransactions.Count - 1 do begin
    FlgCumul := False;
    if not FlgSavingCard then
      for NumCount2 := 0 to LstCumuls.Count -1 do
        if Trim(TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtClassification) =
             Trim(TObjCumuls(LstCumuls[NumCount2]).IdtClassification) then
          FlgCumul := True;
    if ((TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType = CtCodPdtTender) or
    (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodType = CtCodPdtAdmin)) and
    (TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT <> 0) and
    not FlgCumul then begin
      FlgSaving := False;
      if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActChargeSavingCard) or
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActWithdrawSavingCard) or
      (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActSavingCard) then begin
        StrSavingCard := Copy ('000000000000' + TObjPOSTransaction(LstPOSTransactions[NumCount]).NumPLU,Length ('000000000000' + TObjPOSTransaction(LstPOSTransactions[NumCount]).NumPLU) -11, 12);
        FlgSaving := True;
      end;
      FlgCoupon := False;
      if ((TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActCoupPayment) or
          (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActDiscCoup)) then begin
        if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActComment then begin
          StrNumPLU := TObjPOSTransaction(LstPOSTransactions[NumCount+1]).TxtDescr;
          FlgCoupon := True;
        end;
      end;
      if TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActCoupPayment then begin
        for NumCount2 := (NumCount + 1) to LstPOSTransactions.Count - 1 do begin
          if (TObjPOSTransaction(LstPOSTransactions[NumCount2]).CodType = CtCodPdtCommentCouponDeactivation) and
             (AnsiSameText (TObjPOSTransaction(LstPOSTransactions[NumCount2]).TxtDescr,
                            StrNumPLU)) then begin
            if Copy(FormatFloat (CtTxtFrmNumber, TObjPOSTransaction(LstPOSTransactions[NumCount2]).ValInclVAT), 1, 1) = '1' then
              StrFlgOffline := '0'
            else
              StrFlgOffline := '1';
          end;
        end;
      end;
      if not (FlgSaving and FlgSavingCard) then begin
        ObjXMLPayment := ObjXMLDoc.createElement('payment');
        ObjXMLPayment.appendChild (CreateElement ('IdtCurrency',
                    TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtCurrency));
        ObjXMLPayment.appendChild (CreateElement ('IdtClassification',
                    TObjPOSTransaction(LstPOSTransactions[NumCount]).IdtClassification));
        ValInclVAT := -TObjPOSTransaction(LstPOSTransactions[NumCount]).ValInclVAT;
        if TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction =
             CtCodActReturn then
          ValInclVAT := ValInclVAT * -1;
        ValFloat := FormatFloat (CtTxtFrmNumber, ValInclVAT);
        ReplaceString(ValFloat, ',', '.');
        ObjXMLPayment.appendChild (CreateElement ('ValInclVAT',ValFloat));
        if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActInstalment) or
        (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActEFT) then begin
          if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActComment then
            ObjXMLPayment.appendChild (CreateElement ('TxtCreditCard',
                      TObjPOSTransaction(LstPOSTransactions[NumCount+1]).TxtDescr));
        end;
        if (TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActCheque) then begin
          if TObjPOSTransaction(LstPOSTransactions[NumCount+1]).CodAction = CtCodActComment then
            ObjXMLPayment.appendChild (CreateElement ('TxtChequeNumber',
                      TObjPOSTransaction(LstPOSTransactions[NumCount+1]).TxtDescr));
        end;
        if FlgCoupon then
          ObjXMLPayment.appendChild (CreateElement ('NumPLU', StrNumPLU));
        if TObjPOSTransaction(LstPOSTransactions[NumCount]).CodAction = CtCodActInstalment then begin
          if TObjPOSTransaction(LstPOSTransactions[NumCount+4]).CodAction = CtCodActComment then
            ObjXMLPayment.appendChild (CreateElement ('TxtLoanType',
                        TObjPOSTransaction(LstPOSTransactions[NumCount+4]).TxtDescr));
          if TObjPOSTransaction(LstPOSTransactions[NumCount+2]).CodAction = CtCodActComment then
            ObjXMLPayment.appendChild (CreateElement ('TxtLoanID',
                        TObjPOSTransaction(LstPOSTransactions[NumCount+2]).TxtDescr));
          if TObjPOSTransaction(LstPOSTransactions[NumCount+3]).CodAction = CtCodActComment then
            ObjXMLPayment.appendChild (CreateElement ('TxtLoanPeriod',
                        TObjPOSTransaction(LstPOSTransactions[NumCount+3]).TxtDescr));
        end;
        if FlgSaving or FlgSavingCard then
          ObjXMLPayment.appendChild (CreateElement ('TxtSavingCard', StrSavingCard));
        FlgSaving := False;
        if FlgCoupon then
          ObjXMLPayment.appendChild (CreateElement ('FlgOffline', StrFlgOffline));
        FlgCoupon := False;
        ObjXMLTicket.appendChild(ObjXMLPayment);
      end;
    end;
  end;
  ObjXMLPayment := nil;
end;   // of TADOMQWSInterfaces.AddPayment

//=============================================================================

procedure TADOMQWSInterfaces.RetrieveCumulPaymethods (LstCumuls : TList);
var
  ObjCumul : TObjCumuls;
begin  // of TADOMQWSInterfaces.RetrieveCumulPaymethods
  try
    if DmdFpnADOUtilsCA.QueryInfo('SELECT IdtClassification FROM ApplicParam' +
                               #10'INNER JOIN Classification' +
                               #10'ON TxtParam = IdtMember' +
                               #10'WHERE IdtApplicParam LIKE ' +
                                   QuotedStr('CumulPayment%') +
                               #10'ORDER BY IdtApplicParam') then begin
      DmdFpnADOUtilsCA.ADOQryInfo.First;
      while not DmdFpnADOUtilsCA.ADOQryInfo.Eof do begin
        ObjCumul := TObjCumuls.Create;
        ObjCumul.IdtClassification :=
          DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('IdtClassification').AsString;
        LstCumuls.Add(ObjCumul);
        DmdFpnADOUtilsCA.ADOQryInfo.Next;
      end;
    end;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TADOMQWSInterfaces.RetrieveCumulPaymethods

//=============================================================================
// TADOMQWSInterfaces.CreateAssyncOutMsgSafe : Create XML msg for Safe transaction
//                                  -----
// INPUT : LstPOSTransactions = Recordset of Safe transactions
//         ObjXMLDoc = XML document object
//=============================================================================

procedure TADOMQWSInterfaces.CreateAssyncOutMsgSafe
                                           (LstSafeTransactions : TList;
                                            ObjXMLDoc    : IXMLDOMDocument);
  function CreateElement (TxtTagname   : string;
                          VarValue     : variant) : IXMLDomNode;
  begin
    Result := ObjXMLDoc.createElement (TxtTagname);
    Result.Text := VarToStr (VarValue);
  end;
var
  ObjXMLRoot         : IXMLDOMNode;           // Root node of XML message
  ObjXMLHeader,
  ObjXMLBody,
  ObjXMLReq,
  ObjXMLTicket,
  ObjPayment         : IXMLDOMNode;           // Objects for XML nodes
  NumCount           : integer;               // Counter
  ValDiff            : string;                // Value of difference
begin  // of TADOMQWSInterfaces.CreateAssyncOutMsgSafe
  try
    // Create root tag
    ObjXMLRoot := ObjXMLDoc.createElement('BNQ_EAI');
    ObjXMLDoc.appendChild(ObjXMLRoot);
    ObjXMLHeader := ObjXMLDoc.createElement('Header');
    ObjXMLHeader.appendChild (CreateElement ('StoreId',
                              DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    ObjXMLHeader.appendChild (CreateElement ('ResCode', ''));
    ObjXMLHeader.appendChild (CreateElement ('ResDesc', ''));
    ObjXMLHeader.appendChild (CreateElement ('A1', ''));
    ObjXMLHeader.appendChild (CreateElement ('A2', ''));
    ObjXMLHeader.appendChild (CreateElement ('A3', ''));
    ObjXMLHeader.appendChild (CreateElement ('A4', ''));
    ObjXMLHeader.appendChild (CreateElement ('A5', ''));
    ObjXmlRoot.appendChild(ObjXMLHeader);
    ObjXMLBody := ObjXMLDoc.createElement('Body');
    ObjXmlRoot.appendChild(ObjXMLBody);
    ObjXMLReq := ObjXMLDoc.createElement('Req');
    ObjXMLBody.appendChild(ObjXMLReq);
    // Create ticket tag
    ObjXMLTicket := ObjXMLDoc.createElement('Ticket');
    ObjXMLTicket.appendChild (CreateElement ('CodType',
                                           '3'));
    ObjXMLTicket.appendChild (CreateElement ('IdtPosTransaction',
                  TObjDetCommSafeTrans(LstSafeTransactions[0]).IdtSafeTransaction));
    ObjXMLTicket.appendChild (CreateElement ('IdtTradematrix',
                  DmdFpnADOUtilsCA.IdtTradeMatrixAssort));
    ObjXMLTicket.appendChild (CreateElement ('IdtCheckout', 0));
    ObjXMLTicket.appendChild (CreateElement ('DatTransbegin',
                  FormatDateTime('yyyymmdd hh:mm:ss',
                  DmdFpnADOMQWSSafeTransaction.
                  GetDatReg(TObjDetCommSafeTrans(LstSafeTransactions[0]).
                  IdtSafeTransaction))));
    ObjXMLTicket.appendChild (CreateElement ('IdtOperator',
                  DmdFpnADOMQWSSafeTransaction.
                  GetIdtOperator(TObjDetCommSafeTrans(LstSafeTransactions[0]).
                  IdtSafeTransaction)));
    ObjXMLReq.appendChild(ObjXMLTicket);
    for NumCount := 0 to LstSafeTransactions.Count - 1 do begin
      // Create Payment Child
      ObjPayment := ObjXMLDoc.createElement('payment');
      ObjPayment.appendChild (CreateElement ('IdtCurrency',
                    TObjDetCommSafeTrans(LstSafeTransactions[NumCount]).IdtCurrency));
      ObjPayment.appendChild (CreateElement ('IdtClassification',
                    TObjDetCommSafeTrans(LstSafeTransactions[NumCount]).IdtClassification));
      ValDiff := FormatFloat (CtTxtFrmNumber, TObjDetCommSafeTrans(LstSafeTransactions[NumCount]).ValDiff);
      ReplaceString(ValDiff, ',', '.');
      ObjPayment.appendChild (CreateElement ('ValInclVAT', ValDiff));
      ObjXMLTicket.appendChild(ObjPayment);
      ObjPayment := nil;
    end;
  except
    on E: Exception do
      ExceptionHandler(Self, E);
  end;
end;   // of TADOMQWSInterfaces.CreateAssyncOutMsgSafe

//=============================================================================

function TADOMQWSInterfaces.CheckOffline(IdtCVente : double) : boolean;
begin  // of TADOMQWSInterfaces.CheckOffline
  try
    if DmdFpnADOUtilsCA.QueryInfo('SELECT * FROM Vente' +
                               #10'WHERE CVENTE = ' + FloatToStr(IdtCVente) +
                               #10'AND FlgOffline = 1') then
      Result := True
    else
      Result := False;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TADOMQWSInterfaces.CheckOffline

//=============================================================================

function TADOMQWSInterfaces.GetSleeptime : integer;
begin  // of TADOMQWSInterfaces.ProcessAssyncFld
  try
    if DmdFpnADOUtilsCA.QueryInfo('SELECT ValParam ' +
                                  'FROM ApplicParam ' +
                                  'where idtapplicparam = ' +
                                  QuotedStr('ValSleeptime')) then
      Result := DmdFpnADOUtilsCA.ADOQryInfo.FieldByName ('ValParam').AsInteger
    else
      Result := 5000;
  finally
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TADOMQWSInterfaces.ProcessAssyncFld

//=============================================================================

procedure TADOMQWSInterfaces.ReplaceString (var TxtS      : string;
                             OldSubStr : string;
                             NewSubStr : string);
var
  Len              : Integer;
  P                : Integer;
begin  // of TADOMQWSInterfaces.ReplaceString
  Len := Length (OldSubStr);
  P := AnsiPos (OldSubStr, TxtS);
  while P > 0 do begin
    Delete (TxtS, P, Len);
    Insert (NewSubStr, TxtS, P);
    P := AnsiPos (OldSubStr, TxtS);
  end;
end;   // of TADOMQWSInterfaces.ReplaceString

//=============================================================================
// TADOMQWSInterfaces.ExceptionHandler : Procedure called to log exception
//                                  -----
// INPUT  : Sender = The sender that has raised the error
//          E = The exception that occurred
//=============================================================================

procedure TADOMQWSInterfaces.ExceptionHandler (Sender : TObject;
                                             E      : Exception);
var
  ItmExcept        : TExceptItem;      // Found item in DefinedExceptions
begin  // of TADOAssync.ExceptionHandler
  ItmExcept := SvcExceptHandler.DefinedExceptions.FindException (E);
  if Assigned (ItmExcept) or SvcExceptHandler.HandleUndefined then
    SvcExceptHandler.ProcessException (Sender, E, ItmExcept);
end;   // of TADOMQWSInterfaces.ExceptionHandler

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end. // of TADOMQWSInterfaces
