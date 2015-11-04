//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : Castorama Flexpos Development
// Unit   : FVSRptTndCountPosCA = Form VideoSoft RePorT TeNDer COUNT for POS
//          of CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountPosCA.pas,v 1.1 2006/12/22 14:43:34 NicoCV Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FVSRptTndCountPosCA - CVS revision 1.1.1.1
// 1.1     AJ (TCS)  R2014.1 - Req(32080) - CARU - PayOut Process
//=============================================================================

unit FVSRptTndCountPosCA;

(*$WARN SYMBOL_PLATFORM OFF*)

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, ExtCtrls, DFpnSafeTransactionPosCA,
  DFpnTenderGroupPosCA, SfVSPrinter7;

//=============================================================================
// Global definitions
//=============================================================================

var    // Margins
  ViValMarginLeft  : Integer =  900;   // MarginLeft for VspPreview
  ViValMarginHeader: Integer = 1300;   // Adjust MarginTop to leave room for hdr

var    // Colors
  ViColHeader      : TColor = clSilver;// HeaderShade for tables
  ViColBody        : TColor = clWhite; // BodyShade for tables

var    // Fontsizes
  ViValFontHeader  : Integer = 16;     // FontSize header
  ViValFontSubTitle: Integer = 11;     // FontSize SubTitle

var    // Positions and white space
  ViValPosXAddress : Integer = 7000;   // X-position for address
  ViValSpaceBetween: Integer =  200;   // White space between tables

var    // Column-width (in number of characters)
  ViValRptWidthDescr         : Integer = 30; // Width columns description
  ViValRptWidthQty           : Integer = 10; // Width columns quantity
  ViValRptWidthVal           : Integer = 11; // Width columns amount
  ViValRptWidthValPayout     : Integer = 12; // Width columns amount in Payout
                                             //Report                           //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
  ViValRptWidthBag           : Integer = 13; // Width columns bag
const  // Prefix for reference report
  CtTxtRep              = 'REP';

//*****************************************************************************
// TFrmVSRptTndCount
//                                  -----
// REMARKS :
// - assumes :
//   * IdtSafeTransaction and NumSeqSafeTrans are the key-identifiers for the
//     SafeTransaction to process.
//     IdtSafeTransaction MUST be set before generating the report. If
//     NumSeqSafeTrans is not set, the first NumSeq is searched according to
//     the CodRunFunc.
//   * the global LstSafeTransaction contains all SafeTransactions
//     to process for the given CodRunFunc.
//   * the global LstTenderGroup contains all TenderGroups.
//                                  -----
// PROPERTIES :
// - TxtDescrRegFor, IdtRegFor, TxtNameRegFor = description, Idt and name
//   for which the count-report is processed (count reports can be for an
//   operator, a cashdesk,..).
// - IdtOperReg, TxtNameOperReg = Idt and name of the operator who registered
//   the count.
//*****************************************************************************

type
  TFrmVSRptTndCount = class(TFrmVSPreview)
    procedure FormCreate(Sender: TObject);
    procedure VspPreviewBeforeHeader(Sender: TObject);
  private
    { Private declarations }
  protected
    // Datafields for properties
    FTxtFNLogo          : string;      // Filename Logo
    FPicLogo            : TImage;      // Logo
    FCodRunFunc         : Integer;     // Functionality to execute
    FTxtDescrRegFor     : string;      // Description count-report for (..)
    FIdtRegFor          : string;      // Idt count-report for (oper, cashd,..)
    FTxtNameRegFor      : string;      // Name count for (operator, cashdesk)
    FIdtOperReg         : string;      // IdtOperator registering
    FTxtNameOperReg     : string;      // Name operator registering
    FIdtSafeTransaction : Integer;     // IdtSafeTransaction to process
    FNumSeqSafeTrans    : Integer;     // NumSeq SafeTransaction to process
    FFlgExportToFile    : Boolean;     // Export report to exportfile
    FTxtFNExport        : string;      // Filename export file
    FTxtSepColExport    : string;      // Column separator for exportfile
    FTxtSepRowExport    : string;      // Row separator for exportfile
    FIdtOperTrTo        : string;      // IdtOperator to transfer to
    FTxtNameOperTrTo    : string;      // Name operator to transfer to
    FNumRef             : string;      // Report number
    // Save default settings of VspPreview
    ValOrigMarginTop    : Double;      // Original MarginTop
    // Internal used datafields for current Table on report
    QtyLinesPrinted     : Integer;     // Number of lines printed in table
    ValTotalDrawer      : Currency;    // Total in drawer
    ValTotalPayIn       : Currency;    // Total PayIn
    ValTotalPayOut      : Currency;    // Total PayOut
    ValTotalTheor       : Currency;    // Total theoretic
    ValTotalCount       : Currency;    // Total amount count
    QtyTotalCount       : Integer;     // Total number count
    TxtTableFmt         : string;      // Format for current Table on report
    TxtTableHdr         : string;      // Header for current Table on report
    // Internal used datafields for export to file
    TxtFNFullQualExport : string;      // Fully qualified filename exportfile
    MemStmExport        : TMemoryStream;// Memory stream to build exportfile
    // Methods for Read/Write properties
    procedure SetTxtFNLogo (Value : string); virtual;
    function GetCurrentSafeTransaction : TObjSafeTransaction; virtual;
    // Universal Methods
    function ConvertFileName (TxtFN : string) : string; overload; virtual;
    function CalcTextHei : Double; virtual;
    function FormatQuantity (QtyFormat : Integer) : string; virtual;
    function FormatValue (ValFormat : Currency) : string; virtual;
    function TransDetailTenderGroup (ObjTenderGroup : TObjTenderGroup) :
                                                       TObjTransDetail; virtual;
    function AllowTenderGroup (ObjTenderGroup : TObjTenderGroup) : Boolean;
                                                              overload; virtual;
    function AllowTenderGroup (CodFunc        : Integer;
                               ObjTenderGroup : TObjTenderGroup) : Boolean;
                                                              overload; virtual;
    procedure AppendFmtAndHdrQuantity (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrAmount (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrAmountPayOut (TxtHdr : string); virtual;           //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
    procedure AppendFmtAndHdrBagNumber (TxtHdr : string); virtual;
    procedure PrintPageHeader; virtual;
    procedure PrintAddress; virtual;
    procedure PrintExplanation; virtual;
    procedure PrintConclusion; virtual;
    procedure PrintTableLine (TxtLine : string); virtual;
    procedure AppendToMemStmExport (CodLine : Integer;
                                    TxtLine : string ); overload; virtual;
    procedure AppendToMemStmExport (CodLine        : Integer;
                                    TxtLine        : string;
                                    IdtTenderGroup : Integer); overload;virtual;
    procedure AppendHeaderExport; overload; virtual;
    procedure AppendFooterExport; overload; virtual;
    procedure PrepareExportFileName; overload; virtual;
    procedure PrepareExportFile; overload; virtual;
    procedure SaveExportFile; overload; virtual;
    procedure InitializeBeforeGenerateReport; virtual;
    procedure InitializeBeforeStartTable; virtual;
    procedure ConfigTableTotal; virtual;
    // Table Cash and Countable
    procedure BuildTableCountFmtAndHdr; virtual;
    procedure BuildTablePayOutFmtAndHdr; virtual;                               //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
    procedure BuildLineCount (    ObjTenderGroup : TObjTenderGroup;
                              var TxtLine        : string;
                              var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineCount (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableCountBody; virtual;
    procedure GenerateTablePayOutBody; virtual;                                 //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
    procedure GenerateTableCountTotal; virtual;
    procedure GenerateTableCount; virtual;
    procedure GenerateTablePayOut; virtual;                                     //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
    // Table Not countable
    procedure BuildTableNotCountFmtAndHdr; virtual;
    procedure BuildLineNotCount (    ObjTenderGroup : TObjTenderGroup;
                                 var TxtLine        : string;
                                 var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineNotCount (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableNotCountBody; virtual;
    procedure GenerateTableNotCountTotal; virtual;
    procedure GenerateTableNotCount; virtual;
    // Table Change
    procedure BuildTableChangeFmtAndHdr; virtual;
    procedure BuildLineChange (    ObjTenderGroup : TObjTenderGroup;
                               var TxtLine        : string;
                               var FlgHasData     : Boolean        ); virtual;
    procedure PrintLineChange (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableChangeBody; virtual;
    procedure GenerateTableChangeTotal; virtual;
    procedure GenerateTableChange; virtual;
    // General Table Detail
    procedure BuildTableDetailFmtAndHdr (ObjTenderGroup : TObjTenderGroup);
                                                                        virtual;
    procedure BuildLineDetail (    ObjTransDetail : TObjTransDetail;
                               var TxtLine        : string         ); virtual;
    procedure PrintLineDetail (ObjTransDetail : TObjTransDetail); virtual;
    procedure GenerateTableDetailBody (ObjTenderGroup: TObjTenderGroup);virtual;
    procedure GenerateTableDetailTotal(ObjTenderGroup: TObjTenderGroup);virtual;
    procedure GenerateTableDetailTenderGroup (ObjTenderGroup : TObjTenderGroup);
                                                                        virtual;
    procedure GenerateTableDetail; virtual;
    // General Table with summary of Foreign currencies
    procedure BuildTableSummaryCurrFmtAndHdr; virtual;
    procedure BuildLineSummaryCurr (    ObjTenderGroup : TObjTenderGroup;
                                    var TxtLine        : string;
                                    var FlgHasData     : Boolean     ); virtual;
    procedure PrintLineSummaryCurr (ObjTenderGroup : TObjTenderGroup); virtual;
    procedure GenerateTableSummaryCurrBody; virtual;
    procedure GenerateTableSummaryCurrTotal; virtual;
    procedure GenerateTableSummaryCurr; virtual;
    // Finishing report
    procedure AddFooterToPages; virtual;
    procedure RenameExistingDocuments (TxtFNDoc : string;
                                       QtyDoc   : Integer); virtual;
    procedure SaveDocument; overload; virtual;
    function GetNumRef : string; virtual;
  public
    { Public declarations }
    // Datafields which are set to default values, but could be adjusted after
    // creating the form.
    FlgPrintNullLine    : Boolean;     // Print lines with all 0-columns (Def=Y)
    FlgSaveDocument     : Boolean;     // Save the generated document (Def=Y)
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;
    // Overriden methods
    procedure DrawLogo (ImgLogo : TImage); override;
    // Methods
    procedure GenerateReport; virtual;
    procedure PrintRef; virtual;
    // Properties
    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
    property CurrentSafeTransaction : TObjSafeTransaction
                                                 read GetCurrentSafeTransaction;
    property FlgExportToFile : Boolean read  FFlgExportToFile
                                       write FFlgExportToFile;
    property TxtFNExport : string read  FTxtFNExport
                                  write FTxtFNExport;
    property TxtSepColExport : string read  FTxtSepColExport
                                      write FTxtSepColExport;
    property TxtSepRowExport : string read  FTxtSepRowExport
                                      write FTxtSepRowExport;
    property NumRef : string read  GetNumRef
                             write FNumRef;
  published
    // Properties
    property CodRunFunc : Integer read  FCodRunFunc
                                  write FCodRunFunc;
    property TxtDescrRegFor : string read  FTxtDescrRegFor
                                     write FTxtDescrRegFor;
    property IdtRegFor : string read  FIdtRegFor
                                write FIdtRegFor;
    property TxtNameRegFor : string read  FTxtNameRegFor
                                    write FTxtNameRegFor;
    property IdtOperReg : string read  FIdtOperReg
                                 write FIdtOperReg;
    property TxtNameOperReg : string read  FTxtNameOperReg
                                     write FTxtNameOperReg;
    property IdtSafeTransaction : Integer read  FIdtSafeTransaction
                                          write FIdtSafeTransaction;
    property NumSeqSafeTrans : Integer read  FNumSeqSafeTrans
                                       write FNumSeqSafeTrans;
    property IdtOperTrTo : string read  FIdtOperTrTo
                                  write FIdtOperTrTo;
    property TxtNameOperTrTo : string read  FTxtNameOperTrTo
                                      write FTxtNameOperTrTo;
  end;  // of TFrmVSRptTndCount

var
  FrmVSRptTndCount: TFrmVSRptTndCount;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  Variants,

  StStrW,

  SfDialog,
  SmUtils,
  SrStnCom,

  DFpnTenderPosCA,

  RFpnCom,
  RFpnTenderCA,
  FSelectDrawer,                                                                //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
  FFpsTndRegCountPosCA,                                                         //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS
  MRptCDTndCountposCA;                                                          //R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndCountPosCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndCountPosCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 14:43:34 $';


//=============================================================================
// RetrieveLengthCodeInMask : retrieves the length of the first occurence of a
// given code in a given string. Assumes the code to retrieve the length for,
// is proceeded by '<', optional followed by an integer indicating the length
// of the code in the mask, and followed by '>'. If the code is found between
// '<' and '>', without a valid length specifier, the default length is
// returned.
// Examples:
// - ChrCode = D, TxtMask = Abc<D>, ValDefLength = 2 : Result = 2
// - ChrCode = D, TxtMask = Abc<D3>, ValDefLength = 2 : Result = 3
// - ChrCode = D, TxtMask = Abc<D3xy<ze>, ValDefLength = 2 : Result = 2
// - ChrCode = D, TxtMask = Abc<D27, ValDefLength = 2 : Result = 0
//                                  -----
// INPUT   : ChrFind = Character (code) to search the length for.
//           TxtMask = string to search the code in.
//           ValDefLength = default length if no valid length could be found.
//                                  -----
// FUNCRES : found length for the code, 0 if the code was not found.
//                                  -----
// REMARK :
// - this function can have common good, and should be part of DevStand.
//   Is temparary only provided as implemented function, ready to move to
//   SmUtils. MKS - 31.08.2002.
//=============================================================================

function RetrieveLengthCodeInMask (ChrFind      : Char;
                                   TxtMask      : string;
                                   ValDefLength : Integer ) : Integer;
var
  ValPosBegin      : Integer;          // Begin position
  ValPosEnd        : Integer;          // End position
begin  // of RetrieveLengthCodeInMask
  Result := 0;

  ValPosBegin := AnsiPos ('<' + ChrFind, TxtMask);
  if ValPosBegin > 0 then begin
    TxtMask := Copy (TxtMask, ValPosBegin + 2,
                     Length (TxtMask) - ValPosBegin - 1);
    ValPosEnd := AnsiPos ('>', TxtMask);
    if ValPosEnd > 0 then begin
      if ValPosEnd > 1 then
        ValPosEnd := ValPosEnd - 1;
      Result := StrToIntDef (Copy (TxtMask, 1, ValPosEnd), ValDefLength);
    end;
  end;
end;   // of RetrieveLengthCodeInMask

//=============================================================================
// ReplaceCodeInMask : replaces the first occurence of a given code in a given
// string. Assuming the code to replace is proceeded by '<' and followed by '>',
// all characters starting from '<' up to and including '>' are replaced by
// the string to insert.
// Examples:
// - ChrCode = D, TxtIn = Abc<D>, TxtInsert = Replace : Result = AbcReplace
// - ChrCode = D, TxtIn = Abc<D3>, TxtInsert = Replace : Result = AbcReplace
// - ChrCode = D, TxtIn = Abc<Dxy<ze>, TxtInsert = Replace : Result = AbcReplace
// - ChrCode = D, TxtIn = Abc<D27, TxtInsert = Replace : Result = Abc<D27
//                                  -----
// INPUT   : ChrFind = character to search for replacement.
//           TxtMask = original string.
//           TxtReplace = replacement string.
//                                  -----
// FUNCRES : Replaced string.
//                                  -----
// REMARK :
// - this function can have common good, and should be part of DevStand.
//   Is temparary only provided as implemented function, ready to move to
//   SmUtils. MKS - 31.08.2002.
//=============================================================================

function ReplaceCodeInMask (ChrCode    : Char;
                            TxtMask    : string;
                            TxtReplace : string) : string;
var
  ValPosBegin      : Integer;          // Begin position
  ValPosEnd        : Integer;          // End position
begin  // of ReplaceCodeInMask
  Result := TxtMask;

  ValPosBegin := AnsiPos ('<' + ChrCode, TxtMask);
  if ValPosBegin > 0 then begin
    TxtMask := Copy (TxtMask, ValPosBegin + 2,
                     Length (TxtMask) - ValPosBegin - 1);
    ValPosEnd := AnsiPos ('>', TxtMask);
    if ValPosEnd > 0 then begin
      Delete (Result, ValPosBegin, ValPosEnd + 2);
      Insert (TxtReplace, Result, ValPosBegin);
    end;
  end;
end;   // of ReplaceCodeInMask

//*****************************************************************************
// Implementation of TFrmVSRptTndCount
//*****************************************************************************

constructor TFrmVSRptTndCount.Create (AOwner : TComponent);
begin  // of TFrmVSRptTndCount.Create
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';
  FlgPrintNullLine := True;
  FlgSaveDocument  := True;
  TxtSepColExport  := #9;
  TxtSepRowExport  := #13#10;

  // Overrule default properties for VspPreview.
  VspPreview.MarginLeft := ViValMarginLeft;
  // Leave room for header
  ValOrigMarginTop      := VspPreview.MarginTop;
  VspPreview.MarginTop  := ValOrigMarginTop + ViValMarginHeader;

  // Sets an empty header to make sure OnBeforeHeader is fired.
  VspPreview.Header := ' ';
end;   // of TFrmVSRptTndCount.Create

//=============================================================================

destructor TFrmVSRptTndCount.Destroy;
begin  // of TFrmVSRptTndCount.Destroy
  FPicLogo.Free;

  inherited;
end;   // of TFrmVSRptTndCount.Destroy

//=============================================================================
// TFrmVSRptTndCount - Methods for read/write properties
//=============================================================================

procedure TFrmVSRptTndCount.SetTxtFNLogo (Value : string);
begin  // of TFrmVSRptTndCount.SetTxtFNLogo
  FTxtFNLogo := ReplaceEnvVar (Value);
  if (TxtFNLogo <> '') and FileExists (TxtFNLogo) then begin
    if not Assigned (PicLogo) then begin
      PicLogo := TImage.Create (Self);
      PicLogo.AutoSize := True;
    end;
    try
      PicLogo.Picture.LoadFromFile (TxtFNLogo);
    except
    end;
  end;
end;   // of TFrmVSRptTndCount.SetTxtFNLogo

//=============================================================================

function TFrmVSRptTndCount.GetCurrentSafeTransaction : TObjSafeTransaction;
begin  // of TFrmVSRptTndCount.GetCurrentSafeTransaction
  Result := LstSafeTransaction.SafeTransaction
              [LstSafeTransaction.IndexOfIdtAndSeq (IdtSafeTransaction,
                                                    NumSeqSafeTrans)];
end;   // of TFrmVSRptTndCount.GetCurrentSafeTransaction

//=============================================================================
// TFrmVSRptTndCount - Protected methods
//=============================================================================

//=============================================================================
// TFrmVSRptTndCount.ConvertFileName : converts a given filename by replacing
// code-parameters with the value of the codes.
//                                  -----
// INPUT   : TxtFN = filename to convert.
//                                  -----
// FUNCRES : converted filename.
//=============================================================================

function TFrmVSRptTndCount.ConvertFileName (TxtFN : string) : string;
var
  ValLenReplace    : Integer;          // Length to replace in FN
  ValCounter       : Integer;          // Get next counter for FN
  TxtReplace       : string;           // Value counter as string to replace
begin  // of TFrmVSRptTndCount.ConvertFileName
  Result := TxtFN;

  // Replace <T*> by IdtTradeMatrix
(** sve ** )
  repeat
    ValLenReplace := RetrieveLengthCodeInMask ('T', Result, 6);
    if ValLenReplace > 0 then
      Result :=
        ReplaceCodeInMask ('T', Result,
                           LeftPadChL (IdtTradeMatrixAssort, '0',
                                       ValLenReplace));
  until ValLenReplace = 0;
(** sve **)

  // Replace <C*> by Counter
  ValCounter := 0;
  repeat
    ValLenReplace := RetrieveLengthCodeInMask ('C', Result, 3);
    if ValLenReplace > 0 then begin
(** sve ** )
      if ValCounter = 0 then
        ValCounter := DmdFpnUtils.GetNextCounter (CtTxtACTenderIdtAC,
                                                  CtTxtACExpRptCount);
(** sve **)

      TxtReplace := IntToStr (ValCounter);
      if Length (TxtReplace) > ValLenReplace then
        TxtReplace := Copy (TxtReplace, Length (TxtReplace) - ValLenReplace + 1,
                            Length (TxtReplace));
      Result :=
        ReplaceCodeInMask ('C', Result,
                           LeftPadStringCh (TxtReplace, '0', ValLenReplace));
    end;
  until ValLenReplace = 0;
end;   // of TFrmVSRptTndCount.ConvertFileName

//=============================================================================
// TFrmVSRptTndCount.CalcTextHei : calculates VspPreview.TextHei for a single
// line in the current font.
//                                  -----
// FUNCRES : calculated TextHei.
//=============================================================================

function TFrmVSRptTndCount.CalcTextHei : Double;
begin  // of TFrmVSRptTndCount.CalcTextHei
  VspPreview.X1 := 0;
  VspPreview.Y1 := 0;
  VspPreview.X2 := 0;
  VspPreview.Y2 := 0;

  VspPreview.CalcParagraph := 'X';
  Result := VspPreview.TextHei;
end;   // of TFrmVSRptTndCount.CalcTextHei

//=============================================================================
// TFrmVSRptTndCount.FormatQuantity : converts a quantity to a string ready to
// print.
//                                  -----
// INPUT   : QtyFormat = quantity to format.
//                                  -----
// FUNCRES : QtyFormat converted to string.
//=============================================================================

function TFrmVSRptTndCount.FormatQuantity (QtyFormat : Integer) : string;
begin  // of TFrmVSRptTndCount.FormatQuantity
  if QtyFormat = 0 then
    Result := '-'
  else
    Result := IntToStr (QtyFormat);
end;   // of TFrmVSRptTndCount.FormatQuantity

//=============================================================================
// TFrmVSRptTndCount.FormatValue : converts a value to a string ready to print.
//                                  -----
// INPUT   : ValFormat = value to format.
//                                  -----
// FUNCRES : ValFormat converted to string.
//=============================================================================

function TFrmVSRptTndCount.FormatValue (ValFormat : Currency) : string;
begin  // of TFrmVSRptTndCount.FormatValue
  if ValFormat = 0 then
    Result := '-'
  else
    Result := CurrToStrF (ValFormat, ffFixed, 2);
end;   // of TFrmVSRptTndCount.FormatValue

//=============================================================================
// TFrmVSRptTndCount.TransDetailTenderGroup : retrieves the first
// SafeTransDetail of the current SafeTransaction and the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to retrieve TransDetail for.
//                                  -----
// FUNCRES : First TransDetail in the current SafeTransaction for the given
//           TenderGroup; nil if there is no TransDetail for the TenderGroup.
//=============================================================================

function TFrmVSRptTndCount.TransDetailTenderGroup
                           (ObjTenderGroup : TObjTenderGroup) : TObjTransDetail;
var
  NumTransDetail   : Integer;          // Itemnumber start searching TransDetail
begin  // of TFrmVSRptTndCount.TransDetailTenderGroup
  NumTransDetail := -1;
  Result := LstSafeTransaction.NextTransDetail (IdtSafeTransaction,
                                                NumSeqSafeTrans,
                                                ObjTenderGroup.IdtTenderGroup,
                                                NumTransDetail);
end;   // of TFrmVSRptTndCount.TransDetailTenderGroup

//=============================================================================
// TFrmVSRptTndCount.AllowTenderGroup : checks if a TenderGroup is allowed for
// the current functionality.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to check for.
//                                  -----
// FUNCRES : True if TenderGroup is allowed;
//           False if TenderGroup is not allowed.
//=============================================================================

function TFrmVSRptTndCount.AllowTenderGroup (ObjTenderGroup : TObjTenderGroup) :
                                                                        Boolean;
begin  // of TFrmVSRptTndCount.AllowTenderGroup
  Result := (ObjTenderGroup.CodType = CtCodTgtCash) or
            (ObjTenderGroup.CodType = CtCodTgtCountable) or
            (ObjTenderGroup.CodType = CtCodTgtNotCountable) or
            (ObjTenderGroup.CodType = CtCodTgtInformative);
end;   // of TFrmVSRptTndCount.AllowTenderGroup

//=============================================================================
// TFrmVSRptTndCount.AllowTenderGroup : checks if a TenderGroup is allowed for
// the passed function.
//                                  -----
// INPUT   : CodFunc = function to check for.
//           ObjTenderGroup = TenderGroup to check for.
//                                  -----
// FUNCRES : True if TenderGroup is allowed;
//           False if TenderGroup is not allowed.
//=============================================================================

function TFrmVSRptTndCount.AllowTenderGroup (CodFunc        : Integer;
                                             ObjTenderGroup : TObjTenderGroup) :
                                                                        Boolean;
begin  // of TFrmVSRptTndCount.AllowTenderGroup
  Result := (ObjTenderGroup.CodType = CtCodTgtCash) or
            (ObjTenderGroup.CodType = CtCodTgtCountable);
  if not Result then
    Exit;

  Result := ((CodFunc in [CtCodFuncPayOut, CtCodFuncPayoutC])
              and ObjTenderGroup.FlgPayOut);
end;   // of TFrmVSRptTndCount.AllowTenderGroup

//=============================================================================
// TFrmVSRptTndCount.AppendFmtAndHdrQuantity : appends the format and header
// for a quantity-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptTndCount.AppendFmtAndHdrQuantity (TxtHdr : string);
begin  // of TFrmVSRptTndCount.AppendFmtAndHdrQuantity
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthQty))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptTndCount.AppendFmtAndHdrQuantity

//=============================================================================
// TFrmVSRptTndCount.AppendFmtAndHdrBagNumber : appends the format and header
// for a bag number-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptTndCount.AppendFmtAndHdrBagNumber (TxtHdr : string);
begin  // of TFrmVSRptTndCount.AppendFmtAndHdrBagNumber
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthBag))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptTndCount.AppendFmtAndHdrBagNumber

//=============================================================================
// TFrmVSRptTndCount.AppendFmtAndHdrAmount : appends the format and header
// for an amount-column to TxtTableFmt and TxtTableHdr.
//                                  -----
// INPUT   : TxtHdr = header-string to add to TxtTableHdr.
//=============================================================================

procedure TFrmVSRptTndCount.AppendFmtAndHdrAmount (TxtHdr : string);
begin  // of TFrmVSRptTndCount.AppendFmtAndHdrAmount
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthVal))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptTndCount.AppendFmtAndHdrAmount

//=============================================================================
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
procedure TFrmVSRptTndCount.AppendFmtAndHdrAmountPayout (TxtHdr : string);
begin  // of TFrmVSRptTndCount.AppendFmtAndHdrAmountPayout
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0', ViValRptWidthValPayout))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptTndCount.AppendFmtAndHdrAmountPayout
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================
// TFrmVSRptTndCount.PrintPageHeader : prints the header of the report.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptTndCount.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
  TxtHeader      : string;             // Build header string to print
begin  // of TFrmVSRptTndCount.PrintPageHeader
  ViValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;
    case CodRunFunc of
      CtCodFuncPayIn    : TxtHeader := CtTxtPayIn;
      CtCodFuncPayOut   : TxtHeader := CtTxtPayOut;
      CtCodFuncRetPayIn : TxtHeader := CtTxtRetPayIn;
      CtCodFuncTransfer : TxtHeader := CtTxtTransfer;
      CtCodFuncTransferCM : TxtHeader := CtTxtTransferCM;
      CtCodFuncPayoutC  : TxtHeader := CtTxtPayoutC;
      CtCodFuncPayinC   : TxtHeader := CtTxtPayinC; 
    end;
    if IdtSafeTransaction > 0 then
      TxtHeader := TxtHeader + ' : ' + IntToStr (IdtSafeTransaction);
    VspPreview.Text := CtTxtHdrRptCount + ' ' + TxtHeader;

    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;

    // Header Idt count for...
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.FontSize := ViValFontSubTitle;
    TxtHeader := TxtDescrRegFor;
    if IdtRegFor <> '' then
      TxtHeader := TxtHeader + ' ' + IdtRegFor;
    if TxtNameRegFor <> '' then
      TxtHeader := TxtHeader + ' : ' + TxtNameRegFor;
    VspPreview.Text := TxtHeader;
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;

    // Header executed by...
    if (IdtOperReg <> '') or (TxtNameOperReg <> '') then begin
      VspPreview.CurrentX := VspPreview.MarginLeft;
      TxtHeader := CtTxtHdrExecBy;
      if IdtOperReg <> '' then
        TxtHeader := TxtHeader + ' ' + IdtOperReg;
      if TxtNameOperReg <> '' then
        TxtHeader := TxtHeader + ' : ' + TxtNameOperReg;
      VspPreview.Text := TxtHeader;
      VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    end;

    // Header date registration
    VspPreview.CurrentX := VspPreview.MarginLeft;
    VspPreview.Text := CtTxtHdrDatReg + ' ' +
                       DateTimeToStr (CurrentSafeTransaction.DatReg);
    VspPreview.CurrentY := VspPreview.CurrentY + CalcTextHei;
    VspPreview.CurrentX := VspPreview.MarginLeft;
  finally
    VspPreview.Fontsize := ViValFontSave;
    VspPreview.FontBold := False;
  end;
end;   // of TFrmVSRptTndCount.PrintPageHeader

//=============================================================================
// TFrmVSRptTndCount.PrintAddress : prints the address of the TradeMatrix.
//                                  -----
// Restrictions :
// - is called from VspPreview.OnBeforeHeader; provided as virtual method to
//   improve inheritance.
//=============================================================================

procedure TFrmVSRptTndCount.PrintAddress;
begin  // of TFrmVSRptTndCount.PrintAddress
end;   // of TFrmVSRptTndCount.PrintAddress

//=============================================================================
// TFrmVSRptTndCount.PrintExplanation : prints an explanation on the
// document.
//=============================================================================

procedure TFrmVSRptTndCount.PrintExplanation;
var
  CntLine          : Integer;          // Counter line in StringList
  StrLstExplPrint  : TStringList;      // Stringlist explanation to print
begin  // of TFrmVSRptTndCount.PrintExplanation
//SVE Check why?  if ((CodRunFunc in [CtCodFuncPayOut, CtCodFuncPayoutC]) and
//      (CurrentSafeTransaction.CodType = CtCodSttPayOutCount)) then begin
  StrLstExplPrint := LstSafeTransaction.GetExplanationForKeyWord
                       (CurrentSafeTransaction, CtTxtFmtExplDiff);
  try
    if StrLstExplPrint.Count > 0 then begin
      for CntLine := 0 to Pred (StrLstExplPrint.Count) do begin
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.Paragraph := StrLstExplPrint[CntLine];
      end;
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
    end;
  finally
    StrLstExplPrint.Free;
  end;
//  end;
end;   // of TFrmVSRptTndCount.PrintExplanation

//=============================================================================
// TFrmVSRptTndCount.PrintConclusion : prints the conclusion of the document.
//=============================================================================

procedure TFrmVSRptTndCount.PrintConclusion;
begin  // of TFrmVSRptTndCount.PrintConclusion
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text := CtTxtAgreeOperator;
  VspPreview.CurrentX := VspPreview.Marginleft + (ReportWidthInTwips div 2);
  VspPreview.Text := CtTxtAgreeManager;
end;   // of TFrmVSRptTndCount.PrintConclusion

//=============================================================================
// TFrmVSRptTndCount.PrintTableLine : adds the line to the current Table.
//                                  -----
// INPUT   : TxtLine = line to add to the Table.
//=============================================================================

procedure TFrmVSRptTndCount.PrintTableLine (TxtLine : string);
begin  // of TFrmVSRptTndCount.PrintTableLine
  VspPreview.AddTable (TxtTableFmt, TxtTableHdr, TxtLine,
                       ViColHeader, ViColBody, null);
  Inc (QtyLinesPrinted);
end;   // of TFrmVSRptTndCount.PrintTableLine

//=============================================================================
// TFrmVSRptTndCount.AppendToMemStmExport : appends the passed line, preceeded
// with a linecode, to the memory stream for the exportfile.
//                                  -----
// INPUT   : CodLine = code to include in the line.
//           TxtLine = line to append.
//=============================================================================

procedure TFrmVSRptTndCount.AppendToMemStmExport (CodLine : Integer;
                                                  TxtLine : string);
begin  // of TFrmVSRptTndCount.AppendToMemStmExport
  TxtLine := IntToStr (CodLine) + SepCol + TxtLine;
  TxtLine := StringReplace (TxtLine, SepCol, TxtSepColExport, [rfReplaceAll]) +
             TxtSepRowExport;
  MemStmExport.Write (Pointer(TxtLine)^, Length (TxtLine));
end;   // of TFrmVSRptTndCount.AppendToMemStmExport

//=============================================================================
// TFrmVSRptTndCount.AppendToMemStmExport : appends the passed line preceeded
// by code and IdtTendergroup to the memory stream for the exportfile.
//                                  -----
// INPUT   : CodLine = code to include in the line.
//           TxtLine = line to append.
//           IdtTenderGroup = idt of TenderGroup to include in the line.
//=============================================================================

procedure TFrmVSRptTndCount.AppendToMemStmExport (CodLine        : Integer;
                                                  TxtLine        : string;
                                                  IdtTenderGroup : Integer);
begin  // of TFrmVSRptTndCount.AppendToMemStmExport
  AppendToMemStmExport (CodLine, IntToStr (IdtTenderGroup) + SepCol + TxtLine);
end;   // of TFrmVSRptTndCount.AppendToMemStmExport

//=============================================================================
// TFrmVSRptTndCount.AppendHeaderExport : builds and appends the header-line(s)
// to the memory stream for the exportfile.
//=============================================================================

procedure TFrmVSRptTndCount.AppendHeaderExport;
var
  TxtLine          : string;           // Build line to append
begin  // of TFrmVSRptTndCount.AppendHeaderExport
(** sve ** )
  TxtLine := DmdFpnUtils.IdtTradeMatrixAssort + TxtSepColExport +
             IntToStr (IdtSafeTransaction);
(** sve **)
  TxtLine := TxtSepColExport + IntToStr (IdtSafeTransaction);
(** sve **)
(** sve ** )
  if CurrentSafeTransaction.NumReport > 0 then
    TxtLine := TxtLine + '(' + IntToStr (CurrentSafeTransaction.NumReport)+ ')';
(** sve **)
  TxtLine := TxtLine + TxtSepColExport +
             IntToStr (DmdFpnTender.CodCountType) + TxtSepColExport +
             IdtRegFor + TxtSepColExport +
             IdtOperTrTo + TxtSepColExport +
             IdtOperReg + TxtSepColExport +
             FormatDateTime ('ddmmyyyy', CurrentSafeTransaction.DatReg) +
             TxtSepColExport +
             FormatDateTime ('hhmmss', CurrentSafeTransaction.DatReg);
  AppendToMemStmExport (10, TxtLine);
end;   // of TFrmVSRptTndCount.AppendHeaderExport

//=============================================================================
// TFrmVSRptTndCount.AppendFooterExport : builds and appends the footer-line(s)
// to the memory stream for the exportfile.
//                                  -----
// Restrictions :
// - provided as placeholder for inherited forms.
//=============================================================================

procedure TFrmVSRptTndCount.AppendFooterExport;
begin  // of TFrmVSRptTndCount.AppendHeaderExport
end;   // of TFrmVSRptTndCount.AppendFooterExport

//=============================================================================
// TFrmVSRptTndCount.PrepareExportFileName : prepares the filename to use for
// the export file.
//=============================================================================

procedure TFrmVSRptTndCount.PrepareExportFileName;
begin  // of TFrmVSRptTndCount.PrepareExportFileName
  TxtFNFullQualExport := ReplaceEnvVar (TxtFNExport);
  if AnsiPos ('\', TxtFNFullQualExport) = 0 then
    TxtFNFullQualExport :=
      ExtractFilePath (ExtractFileDir (Application.ExeName)) +
                       'SPOOL\' + TxtFNExport;
  if TxtFNFullQualExport[Length (TxtFNFullQualExport)] = '\' then
    TxtFNFullQualExport := TxtFNFullQualExport + 'TC<T6>.<C3>';

  TxtFNFullQualExport := ConvertFileName (TxtFNFullQualExport);
end;   // of TFrmVSRptTndCount.PrepareExportFileName

//=============================================================================
// TFrmVSRptTndCount.PrepareExportFile : prepares for export to file.
//=============================================================================

procedure TFrmVSRptTndCount.PrepareExportFile;
begin  // of TFrmVSRptTndCount.PrepareExportFile
  PrepareExportFileName;
  MemStmExport := TMemoryStream.Create;
  AppendHeaderExport;
end;   // of TFrmVSRptTndCount.PrepareExportFile

//=============================================================================
// TFrmVSRptTndCount.SaveExportFile : saves the report to the exportfile.
//=============================================================================

procedure TFrmVSRptTndCount.SaveExportFile;
begin  // of TFrmVSRptTndCount.SaveExportFile
  AppendFooterExport;
  CreatePathDirs (TxtFNFullQualExport);
  MemStmExport.SaveToFile (TxtFNFullQualExport);
end;   // of TFrmVSRptTndCount.SaveExportFile

//=============================================================================
// TFrmVSRptTndCount.InitializeBeforeGenerateReport : performs some
// initializations before generating the report.
//                                  -----
// Restrictions :
// - an exception is raised if initialization fails (due to incompatible
//   settings,..)
//=============================================================================

procedure TFrmVSRptTndCount.InitializeBeforeGenerateReport;
var
  CodTypeSafeTrans : Integer;          // Check CodType SafeTransaction
  NumSafeTrans     : Integer;          // Found number SafeTransaction
  TxtMsg           : string;           // Part(s) of message
begin  // of TFrmVSRptTndCount.InitializeBeforeGenerateReport
  CodTypeSafeTrans := -1;

  case CodRunFunc of
    CtCodFuncPayIn    : TxtMsg := CtTxtPayIn;
    CtCodFuncPayOut   : TxtMsg := CtTxtPayOut;
    CtCodFuncRetPayIn : TxtMsg := CtTxtRetPayIn;
    CtCodFuncTransfer : TxtMsg := CtTxtTransfer;
    CtCodFuncTransferCM : TxtMsg := CtTxtTransferCM;
    CtCodFuncPayoutC  : TxtMsg := CtTxtPayoutC;
    CtCodFuncPayInC   : TxtMsg := CtTxtPayInc;
    else
      raise Exception.Create (CtTxtEmGenerateReport + #10 +
                              Format (CtTxtEmPropMissing, ['CodRunFunc']));
  end;

  if NumSeqSafeTrans = 0 then begin
    // Find NumSeq
    case CodRunFunc of
      CtCodFuncPayIn    : CodTypeSafeTrans := CtCodSttPayInTender;
      CtCodFuncPayOut   : CodTypeSafeTrans := CtCodSttPayOutCount;
      CtCodFuncRetPayIn : CodTypeSafeTrans := CtCodSttPayOutCount;
      CtCodFuncTransfer, CtCodFuncTransferCM :
                          CodTypeSafeTrans := CtCodSttPayOutTransfer;
      CtCodFuncPayOutC  : CodTypeSafeTrans := CtCodSttPayOutCount;
      CtCodFuncPayInC   : CodTypeSafeTrans := CtCodSttPayInTender;
    end;
    NumSafeTrans := LstSafeTransaction.IndexOfIdtAndType (IdtSafeTransaction,
                                                          CodTypeSafeTrans);
    if (NumSafeTrans < 0) and (CodRunFunc in [CtCodFuncPayOut,
                                              CtCodFuncPayoutC]) then
      NumSafeTrans := LstSafeTransaction.IndexOfIdtAndType
                        (IdtSafeTransaction, CtCodSttPayOutTender);
    if NumSafeTrans < 0 then
      raise Exception.Create (CtTxtEmGenerateReport + #10 +
                              Format (CtTxtEmNoSafeTransType, [TxtMsg]));

    NumSeqSafeTrans := LstSafeTransaction.SafeTransaction[NumSafeTrans].NumSeq;
  end;

  if not Assigned (CurrentSafeTransaction) then
    raise Exception.Create (CtTxtEmGenerateReport + #10 +
                            Format (CtTxtEmPropMissing,
                                    [CtTxtIdtSafeTransaction]));
end;   // of TFrmVSRptTndCount.InitializeBeforeGenerateReport

//=============================================================================
// TFrmVSRptTndCount.InitializeBeforeStartTable : initialization before
// starting a new table.
//=============================================================================

procedure TFrmVSRptTndCount.InitializeBeforeStartTable;
begin  // of TFrmVSRptTndCount.InitializeBeforeStartTable
  QtyLinesPrinted := 0;

  ValTotalDrawer := 0;
  ValTotalPayIn  := 0;
  ValTotalPayOut := 0;
  ValTotalTheor  := 0;
  ValTotalCount  := 0;
  QtyTotalCount  := 0;
end;   // of TFrmVSRptTndCount.InitializeBeforeStartTable

//=============================================================================
// TFrmVSRptTndCount.BuildTableCountFmtAndHdr : builds the Format and Header
// for the table with the counted results.
//=============================================================================

procedure TFrmVSRptTndCount.BuildTableCountFmtAndHdr;
begin  // of TFrmVSRptTndCount.BuildTableCountFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrMeansOfPay;
  AppendFmtAndHdrAmount (CtTxtHdrValAmount)
end;   // of TFrmVSRptTndCount.BuildTableCountFmtAndHdr
//============================================================================
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
procedure TFrmVSRptTndCount.BuildTablePayOutFmtAndHdr;
begin  // of TFrmVSRptTndCount.BuildTableCountFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrCountable;
  AppendFmtAndHdrAmountPayout(CtTxtPayOutTitle);
  AppendFmtAndHdrAmountPayout(CtTxtDrawer);
  AppendFmtAndHdrAmountPayout(CtTxtRptTotal)
end;   // of TFrmVSRptTndCount.BuildTableCountFmtAndHdr
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================
// TFrmVSRptTndCount.ConfigTableTotal : configures the total-line of a table.
//=============================================================================

procedure TFrmVSRptTndCount.ConfigTableTotal;
var
  QtyRows          : Integer;          // Number of rows in table
  QtyCols          : Integer;          // Number of columns in table
begin  // of TFrmVSRptTndCount.ConfigTableTotal
  // Retrieve number of rows and columns
  QtyRows := VspPreview.TableCell[tcRows, Null, Null, Null, Null];
  QtyCols := VspPreview.TableCell[tcCols, Null, Null, Null, Null];

  // Set last line (= total line) bold
  VspPreview.TableCell[tcFontBold, QtyRows, 1, QtyRows, QtyCols] := True;
  // Prevent page break before total-line
  VspPreview.TableCell[tcRowKeepWithNext, QtyRows - 1, 1,
                                          QtyRows - 1, QtyCols] := True;
end;   // of TFrmVSRptTndCount.ConfigTableTotal

//=============================================================================
// TFrmVSRptTndCount.BuildLineCount : builds the body-line of the table
// with the counted results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCount.BuildLineCount
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTheor         : Currency;         // Total theoretic
begin  // of TFrmVSRptTndCount.BuildLineCount
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;
  ValTheor   := 0;

  if CurrentSafeTransaction.CodType = CtCodSttPayOutCount then begin
    // Retrieve total theoretic PayOut
    LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                                CtCodSttPayOutCashdesk,
                                                ObjTenderGroup.IdtTenderGroup,
                                                True, QtyTrans, ValTheor);
    ValTotalTheor := ValTotalTheor + ValTheor;
    FlgHasData := FlgHasData or (ValTheor <> 0);
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor);
  end;

  // Retrieve total count
  LstSafeTransaction.TotalTransDetail (IdtSafeTransaction,
                                       NumSeqSafeTrans,
                                       ObjTenderGroup.IdtTenderGroup,
                                       True, QtyTrans, ValTrans);
  ValTotalCount := ValTotalCount + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Append difference
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor - ValTrans);
end;   // of TFrmVSRptTndCount.BuildLineCount

//=============================================================================
// TFrmVSRptTndCount.PrintLineCount : generates the body-line of the table
// with the counted results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCount.PrintLineCount (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCount.PrintLineCount
  BuildLineCount (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or (FlgPrintNullLine and
                    AllowTenderGroup (CodRunFunc, ObjTenderGroup)) then begin
    PrintTableLine (TxtLine);
    if FlgExportToFile then
      AppendToMemStmExport (20, TxtLine, ObjTenderGroup.IdtTenderGroup);
  end;
end;   // of TFrmVSRptTndCount.PrintLineCount

//=============================================================================
// TFrmVSRptTndCount.GenerateTableCountBody : generates the body of the table
// with the counted results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableCountBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCount.GenerateTableCountBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if (LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
        CtCodTgtCash) or
       (LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
        CtCodTgtCountable) then
      PrintLineCount (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCount.GenerateTableCountBody
//=============================================================================
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
procedure TFrmVSRptTndCount.GenerateTablePayOutBody;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCountCA.GenerateTablePayOutBody
  TxtLine := CtTxtCash;
  TxtLine := TxtLine +
             SepCol +  FormatValue(PayInPayOutAmt-PayOutAmt) +
             SepCol +  FormatValue(DrawerAmtToPrint-PayInPayOutAmt+PayInAmt) +
             SepCol +  FormatValue(DrawerAmtToPrint-PayInPayOutAmt+(PayInPayOutAmt-PayOutAmt)+PayInAmt) ;
  PrintTableLine (TxtLine);
end;   // of TFrmVSRptTndCountCA.GenerateTablePayOutBody
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================
// TFrmVSRptTndCount.GenerateTableCountTotal : generates the table with the
// totals of the counted results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableCountTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCount.GenerateTableCountTotal
  TxtLine := CtTxtRptTotal;

  if CodRunFunc <> CtCodFuncCount then begin
    if CurrentSafeTransaction.CodType = CtCodSttPayOutCount then
      TxtLine := TxtLine + SepCol + FormatValue (ValTotalTheor);
    TxtLine := TxtLine + SepCol + FormatValue (ValTotalCount);
    if CurrentSafeTransaction.CodType = CtCodSttPayOutCount then
      TxtLine := TxtLine + SepCol +
                 FormatValue (ValTotalTheor - ValTotalCount);
  end;
  PrintTableLine (TxtLine);
  ConfigTableTotal;
end;   // of TFrmVSRptTndCount.GenerateTableCountTotal

//=============================================================================
// TFrmVSRptTndCount.GenerateTableCount : generates the table with the counted
// results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableCount;
begin  // of TFrmVSRptTndCount.GenerateTableCount
  InitializeBeforeStartTable;
  BuildTableCountFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableCountBody;
    if QtyLinesPrinted > 1 then
      GenerateTableCountTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCount.GenerateTableCount
//=============================================================================
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.Start
procedure TFrmVSRptTndCount.GenerateTablePayOut;
begin  // of TFrmVSRptTndCount.GenerateTablePayOut
  InitializeBeforeStartTable;
  BuildTablePayOutFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTablePayOutBody;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCount.GenerateTablePayOut
//R2014.1-Req(32080)-CARU-PayOut_Process.AJ-TCS.End
//=============================================================================
// TFrmVSRptTndCount.BuildTableNotCountFmtAndHdr : builds the Format and Header
// for the table with the not countable results.
//=============================================================================

procedure TFrmVSRptTndCount.BuildTableNotCountFmtAndHdr;
begin  // of TFrmVSRptTndCount.BuildTableNotCountFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrNotCountable;

  AppendFmtAndHdrAmount (CtTxtHdrTotalDrawer);
end;   // of TFrmVSRptTndCount.BuildTableNotCountFmtAndHdr

//=============================================================================
// TFrmVSRptTndCount.BuildLineNotCount : builds the body-line of the table
// with the not countable results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCount.BuildLineNotCount
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
begin  // of TFrmVSRptTndCount.BuildLineNotCount
end;   // of TFrmVSRptTndCount.BuildLineNotCount

//=============================================================================
// TFrmVSRptTndCount.PrintLineNotCount : generates the body-line of the table
// with the not countable results for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCount.PrintLineNotCount (ObjTenderGroup: TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCount.PrintLineNotCount
  BuildLineNotCount (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or FlgPrintNullLine then begin
    PrintTableLine (TxtLine);
    if FlgExportToFile then
      AppendToMemStmExport (21, TxtLine, ObjTenderGroup.IdtTenderGroup);
  end;
end;   // of TFrmVSRptTndCount.PrintLineNotCount

//=============================================================================
// TFrmVSRptTndCount.GenerateTableNotCountBody : generates the body of the
// table with the not countable results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableNotCountBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCount.GenerateTableNotCountBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
       CtCodTgtNotCountable then
      PrintLineNotCount (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCount.GenerateTableNotCountBody

//=============================================================================
// TFrmVSRptTndCount.GenerateTableNotCountTotal : generates the table with
// the totals of not countable results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableNotCountTotal;
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCount.GenerateTableNotCountTotal
  TxtLine := CtTxtRptTotal + SepCol + FormatValue (ValTotalTheor);

  PrintTableLine (TxtLine);
  ConfigTableTotal;
end;   // of TFrmVSRptTndCount.GenerateTableNotCountTotal

//=============================================================================
// TFrmVSRptTndCount.GenerateTableNotCount : generates the table with the
// not countable results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableNotCount;
begin  // of TFrmVSRptTndCount.GenerateTableNotCount
  InitializeBeforeStartTable;
  BuildTableNotCountFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableNotCountBody;
    if QtyLinesPrinted > 1 then
      GenerateTableNotCountTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCount.GenerateTableNotCount

//=============================================================================
// TFrmVSRptTndCount.BuildTableChangeFmtAndHdr : builds the Format and Header
// for the table with the results for Change money.
//=============================================================================

procedure TFrmVSRptTndCount.BuildTableChangeFmtAndHdr;
begin  // of TFrmVSRptTndCount.BuildTableChangeFmtAndHdr
end;   // of TFrmVSRptTndCount.BuildTableChangeFmtAndHdr

//=============================================================================
// TFrmVSRptTndCount.BuildLineChange : builds the body-line of the table
// with the Change money for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCount.BuildLineChange
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ObjTransDetail   : TObjTransDetail;  // Found TransDetail to get Currency
begin  // of TFrmVSRptTndCount.BuildLineChange
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;

  // Retrieve Currency for TransDetail
  ObjTransDetail := TransDetailTenderGroup (ObjTenderGroup);
  if Assigned (ObjTransDetail) then
    TxtLine := TxtLine + SepCol + ObjTransDetail.IdtCurrency
  else
    TxtLine := TxtLine + SepCol + ObjTenderGroup.IdtCurrency;

  // Total ChangeOnStart
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttChangeOnStart,
                                              ObjTenderGroup.IdtTenderGroup,
                                              False, QtyTrans, ValTrans);
  ValTotalPayIn := ValTotalPayIn + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  // Total ChangeForNext
  LstSafeTransaction.TotalTransDetailForType (IdtSafeTransaction,
                                              CtCodSttChangeForNext,
                                              ObjTenderGroup.IdtTenderGroup,
                                              False, QtyTrans, ValTrans);
  ValTotalCount := ValTotalCount + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);
end;   // of TFrmVSRptTndCount.BuildLineChange

//=============================================================================
// TFrmVSRptTndCount.PrintLineChange : generates the body-line of the table
// with the Change money for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCount.PrintLineChange (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCount.PrintLineChange
  BuildLineChange (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or
     (FlgPrintNullLine and AllowTenderGroup (CtCodFuncPayIn, ObjTenderGroup))
     then begin
    PrintTableLine (TxtLine);
    if FlgExportToFile then
      AppendToMemStmExport (22, TxtLine, ObjTenderGroup.IdtTenderGroup);
  end;
end;   // of TFrmVSRptTndCount.PrintLineChange

//=============================================================================
// TFrmVSRptTndCount.GenerateTableChangeBody : generates the body of the table
// with the Change Money.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableChangeBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCount.GenerateTableChangeBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if (LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCash) or
       (LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCountable)
       then
      PrintLineChange (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCount.GenerateTableChangeBody

//=============================================================================
// TFrmVSRptTndCount.GenerateTableChangeTotal : generates the table with the
// totals of Change Money.
//                                  -----
// Restrictions
// - is provided as placeholder for inherited forms which might have to
//   generate a total of Change Money. In this version, totals of Change Money
//   are not processed since they can be expressed in different currencies.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableChangeTotal;
begin  // of TFrmVSRptTndCount.GenerateTableChangeTotal
end;   // of TFrmVSRptTndCount.GenerateTableChangeTotal

//=============================================================================
// TFrmVSRptTndCount.GenerateTableChange : generates the table with the
// results for Change money.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableChange;
begin  // of TFrmVSRptTndCount.GenerateTableChange
  InitializeBeforeStartTable;
  BuildTableChangeFmtAndHdr;
  VspPreview.StartTable;
  try
    GenerateTableChangeBody;
    if QtyLinesPrinted > 1 then
      GenerateTableChangeTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCount.GenerateTableChange

//=============================================================================
// TFrmVSRptTndCount.BuildTableDetailFmtAndHdr : builds the Format and
// Header for a table with details of counted results for a TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to process.
//                                  -----
// Restrictions :
// - to include the currency of the registrated data in the header, we have
//   to use the currency of the SafeTransDetail. We CANNOT use the currency of
//   the TenderGroup, since the currency of the TenderGroup could be changed
//   after registration and we want to be able to re-print reports of
//   previous registrations.
//=============================================================================

procedure TFrmVSRptTndCount.BuildTableDetailFmtAndHdr
                                             (ObjTenderGroup : TObjTenderGroup);
var
  TxtCurrInHdr     : string;           // IdtCurrency for header if needed
  ObjTransDetail   : TObjTransDetail;  // Get TransDetail to check Currency
begin  // of TFrmVSRptTndCount.BuildTableDetailFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrDetail + ' ' + ObjTenderGroup.TxtPublDescr;

  TxtCurrInHdr := '';
  if ObjTenderGroup.CodType = CtCodTgtCash then begin
    ObjTransDetail := TransDetailTenderGroup (ObjTenderGroup);
    if Assigned (ObjTransDetail) then
      TxtCurrInHdr :=  ' ' + ObjTransDetail.IdtCurrency;
  end
  else
    ObjTransDetail := nil;

  AppendFmtAndHdrQuantity (CtTxtHdrQtyUnit);
  AppendFmtAndHdrAmount (CtTxtHdrValUnit + TxtCurrInHdr);

  AppendFmtAndHdrAmount (CtTxtHdrTotalCount + TxtCurrInHdr);

  // Column for count-result in currency of SafeTransaction
  if Assigned (ObjTransDetail) and
     (ObjTransDetail.IdtCurrency <> CurrentSafeTransaction.IdtCurrency) then
    AppendFmtAndHdrAmount (CtTxtHdrTotalCount + ' ' +
                           CurrentSafeTransaction.IdtCurrency);
end;   // of TFrmVSRptTndCount.BuildTableDetailFmtAndHdr

//=============================================================================
// TFrmVSRptTndCount.BuildLineDetail : builds the body-line of a table
// with details of the counted results for a SafeTransDetail.
//                                  -----
// INPUT   : ObjTransDetail = SafeTransDetail to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCount.BuildLineDetail (    ObjTransDetail:TObjTransDetail;
                                             var TxtLine       :string        );
var
  ValTrans         : Currency;         // Value of current TransDetail
begin  // of TFrmVSRptTndCount.BuildLineDetail
  ValTrans := ObjTransDetail.QtyUnit * ObjTransDetail.ValUnit;
  ValTotalCount := ValTotalCount + ValTrans;
  TxtLine := ObjTransDetail.TxtDescr +
             SepCol + FormatQuantity (ObjTransDetail.QtyUnit) +
             SepCol + FormatValue (ObjTransDetail.ValUnit);

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Empty column for theoretic
    TxtLine := TxtLine + SepCol;

  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Empty column for difference
    TxtLine := TxtLine + SepCol;

  if ObjTransDetail.IdtCurrency <> CurrentSafeTransaction.IdtCurrency then
    TxtLine := TxtLine + SepCol +
               FormatValue (ExchangeCurr
                              (ValTrans,
                               ObjTransDetail.ValExchange,
                               ObjTransDetail.FlgExchMultiply,
                               CurrentSafeTransaction.ValExchange,
                               CurrentSafeTransaction.FlgExchMultiply));
end;   // of TFrmVSRptTndCount.BuildLineDetail

//=============================================================================
// TFrmVSRptTndCount.PrintLineDetail : generates the body-line of a table
// with details of counted results for a SafeTransDetail.
//                                  -----
// INPUT   : ObjTransDetail = SafeTransDetail to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCount.PrintLineDetail (ObjTransDetail : TObjTransDetail);
var
  TxtLine          : string;           // Build line to print
begin  // of TFrmVSRptTndCount.PrintLineDetail
  BuildLineDetail (ObjTransDetail, TxtLine);

  PrintTableLine (TxtLine);
  if FlgExportToFile then
    AppendToMemStmExport (24, TxtLine, ObjTransDetail.IdtTenderGroup);
end;   // of TFrmVSRptTndCount.PrintLineDetail

//=============================================================================
// TFrmVSRptTndCount.GenerateTableDetailBody : generates the body of a table
// with details of counted results for a TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to process.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableDetailBody
                                             (ObjTenderGroup : TObjTenderGroup);
var
  NumTransDetail   : Integer;          // Number fount item in TransDetail
  ObjTransDetail   : TObjTransDetail;       // Found TransDetail
begin  // of TFrmVSRptTndCount.GenerateTableDetailBody
  NumTransDetail := -1;
  repeat
    ObjTransDetail := LstSafeTransaction.NextTransDetail
                        (IdtSafeTransaction, NumSeqSafeTrans,
                         ObjTenderGroup.IdtTenderGroup, NumTransDetail);
    if Assigned (ObjTransDetail) then
      PrintLineDetail (ObjTransDetail);
  until not Assigned (ObjTransDetail);
end;   // of TFrmVSRptTndCount.GenerateTableDetailBody

//=============================================================================
// TFrmVSRptTndCount.GenerateTableDetailTotal : generates the table with the
// totals of the detail of counted results for a TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to process.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableDetailTotal
                                             (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  QtyTheor         : Integer;          // Total theoretic Quantity TenderGroup
  ValTheor         : Currency;         // Total theoretic Amount TenderGroup
  ObjTransDetail   : TObjTransDetail;  // Get TransDetail to check Currency
begin  // of TFrmVSRptTndCount.GenerateTableDetailTotal
  TxtLine := CtTxtRptTotal + SepCol + SepCol;

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then begin
    // Get theoretic results
    LstSafeTransaction.TotalTransDetailForType
      (IdtSafeTransaction, CtCodSttPayOutCashdesk,
       ObjTenderGroup.IdtTenderGroup, False, QtyTheor, ValTheor);
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor);
  end;

  TxtLine := TxtLine + SepCol + FormatValue (ValTotalCount);

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    // Append difference
    TxtLine := TxtLine +
               SepCol + FormatValue (ValTheor - ValTotalCount);

  // Append count-result in currency of SafeTransaction
  if ObjTenderGroup.CodType = CtCodTgtCash then begin
    ObjTransDetail := TransDetailTenderGroup (ObjTenderGroup);
    if Assigned (ObjTransDetail) and
       (ObjTransDetail.IdtCurrency <> CurrentSafeTransaction.IdtCurrency) then
      TxtLine := TxtLine + SepCol +
                 FormatValue (ExchangeCurr
                                (ValTotalCount,
                                 ObjTransDetail.ValExchange,
                                 ObjTransDetail.FlgExchMultiply,
                                 CurrentSafeTransaction.ValExchange,
                                 CurrentSafeTransaction.FlgExchMultiply));
  end;

  PrintTableLine (TxtLine);
  ConfigTableTotal;
end;   // of TFrmVSRptTndCount.GenerateTableDetailTotal

//=============================================================================
// TFrmVSRptTndCount.GenerateTableDetailTenderGroup : generates a table
// with details for a TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to process.
//                                  -----
// Restrictions :
// - in contradistinction to other tables, as soon as a table for details has
//   a line, totals has ALWAYS to be printed, since this is the only way we
//   to get the theoretic results and the differences.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableDetailTenderGroup
                                             (ObjTenderGroup : TObjTenderGroup);
begin  // of TFrmVSRptTndCount.GenerateTableDetailTenderGroup
  InitializeBeforeStartTable;

  BuildTableDetailFmtAndHdr (ObjTenderGroup);
  VspPreview.StartTable;
  try
    GenerateTableDetailBody (ObjTenderGroup);
    if QtyLinesPrinted > 0 then
      GenerateTableDetailTotal (ObjTenderGroup);
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
  end;
end;   // of TFrmVSRptTndCount.GenerateTableDetailTenderGroup

//=============================================================================
// TFrmVSRptTndCount.GenerateTableDetail : generates tables with the details
// of counted results.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableDetail;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup             
begin  // of TFrmVSRptTndCount.GenerateTableDetail
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if ((LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCash) or
        (LstTenderGroup.TenderGroup[CntTenderGroup].CodType =
          CtCodTgtCountable)) and
       LstTenderGroup.TenderGroup[CntTenderGroup].FlgDetailPrint then
      GenerateTableDetailTenderGroup
        (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCount.GenerateTableDetail

//=============================================================================
// TFrmVSRptTndCount.BuildTableSummaryCurrFmtAndHdr : builds the Format and
// Header for the table with the summary of foreign currencies.
//=============================================================================

procedure TFrmVSRptTndCount.BuildTableSummaryCurrFmtAndHdr;
begin  // of TFrmVSRptTndCount.BuildTableSummaryCurrFmtAndHdr
  TxtTableFmt := Format ('%s%d', [FormatAlignLeft,
                                  ColumnWidthInTwips (ViValRptWidthDescr)]);
  TxtTableHdr := CtTxtHdrSummaryCurr;

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    AppendFmtAndHdrAmount (CtTxtHdrTotalTheor);

  AppendFmtAndHdrAmount (CtTxtHdrTotalCount);

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
    AppendFmtAndHdrAmount (CtTxtHdrDifference);

  // Column for count-result in currency of SafeTransaction
  AppendFmtAndHdrAmount (CtTxtHdrTotalCount + ' ' +
                         CurrentSafeTransaction.IdtCurrency);
end;   // of TFrmVSRptTndCount.BuildTableSummaryCurrFmtAndHdr

//=============================================================================
// TFrmVSRptTndCount.BuildLineSummaryCurr : builds the body-line of the table
// with the summary of forreign currencies for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to build the line for.
//                                  -----
// OUTPUT  : TxtLine = builded line.
//           FlgHasData = True if the line contains non-zero data;
//                        False if all numeric data on the line is zero.
//=============================================================================

procedure TFrmVSRptTndCount.BuildLineSummaryCurr
                                         (    ObjTenderGroup : TObjTenderGroup;
                                          var TxtLine        : string;
                                          var FlgHasData     : Boolean        );
var
  QtyTrans         : Integer;          // Total Quantity TenderGroup
  ValTrans         : Currency;         // Total Amount TenderGroup
  ValTheor         : Currency;         // Total theoretic
  ObjTransDetail   : TObjTransDetail;  // Get TransDetail for currency-props.
begin  // of TFrmVSRptTndCount.BuildLineSummaryCurr
  FlgHasData := False;
  TxtLine    := ObjTenderGroup.TxtPublDescr;
  ValTheor   := 0;

  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then begin
    // Retrieve total theoretic
    LstSafeTransaction.TotalTransDetailForType
      (IdtSafeTransaction, CtCodSttPayOutCashdesk,
       ObjTenderGroup.IdtTenderGroup, False, QtyTrans, ValTheor);
    FlgHasData := FlgHasData or (ValTheor <> 0);
    ValTotalTheor := ValTotalTheor + ValTheor;
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor);
  end;

  // Retrieve total count
  LstSafeTransaction.TotalTransDetail (IdtSafeTransaction,
                                       NumSeqSafeTrans,
                                       ObjTenderGroup.IdtTenderGroup,
                                       False, QtyTrans, ValTrans);
  ValTotalCount := ValTotalCount + ValTrans;
  FlgHasData := FlgHasData or (ValTrans <> 0);
  TxtLine := TxtLine + SepCol + FormatValue (ValTrans);


  if (CurrentSafeTransaction.CodType = CtCodSttPayOutCount) then
     // Append difference
    TxtLine := TxtLine + SepCol + FormatValue (ValTheor - ValTrans);

  // Append total count in currency of SafeTransaction
  ObjTransDetail := TransDetailTenderGroup (ObjTenderGroup);
  if Assigned (ObjTransDetail) then
    TxtLine := TxtLine + SepCol +
               FormatValue (ExchangeCurr
                              (ValTrans,
                               ObjTransDetail.ValExchange,
                               ObjTransDetail.FlgExchMultiply,
                               CurrentSafeTransaction.ValExchange,
                               CurrentSafeTransaction.FlgExchMultiply))
  else
    TxtLine := TxtLine + SepCol + FormatValue (0);
end;   // of TFrmVSRptTndCount.BuildLineSummaryCurr

//=============================================================================
// TFrmVSRptTndCount.PrintLineSummaryCurr : generates the body-line of the
// table with the summary of foreign currency for the given TenderGroup.
//                                  -----
// INPUT   : ObjTenderGroup = TenderGroup to generate the line for.
//=============================================================================

procedure TFrmVSRptTndCount.PrintLineSummaryCurr
                                             (ObjTenderGroup : TObjTenderGroup);
var
  TxtLine          : string;           // Build line to print
  FlgHasData       : Boolean;          // True if line contains non-0 data
begin  // of TFrmVSRptTndCount.PrintLineSummaryCurr
  BuildLineSummaryCurr (ObjTenderGroup, TxtLine, FlgHasData);

  if FlgHasData or (FlgPrintNullLine and
                    AllowTenderGroup (CodRunFunc, ObjTenderGroup)) then begin
    PrintTableLine (TxtLine);
    if FlgExportToFile then
      AppendToMemStmExport (25, TxtLine, ObjTenderGroup.IdtTenderGroup);
  end;
end;   // of TFrmVSRptTndCount.PrintLine

//=============================================================================
// TFrmVSRptTndCount.GenerateTableSummaryCurrBody : generates the body of the
// table with the summary of foreign currencies.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableSummaryCurrBody;
var
  CntTenderGroup   : Integer;          // Counter TenderGroup
begin  // of TFrmVSRptTndCount.GenerateTableSummaryCurrBody
  for CntTenderGroup := 0 to Pred (LstTenderGroup.Count) do begin
    if (LstTenderGroup.TenderGroup[CntTenderGroup].CodType = CtCodTgtCash) and
       (not LstTenderGroup.TenderGroup[CntTenderGroup].FlgDetailPrint) then
      PrintLineSummaryCurr (LstTenderGroup.TenderGroup[CntTenderGroup]);
  end;
end;   // of TFrmVSRptTndCount.GenerateTableSummaryCurrBody

//=============================================================================
// TFrmVSRptTndCount.GenerateTableSummaryCurrTotal : generates the table with
// the totals of the summaray of foreign currencies.
//                                  -----
// Restrictions
// - is provided as placeholder for inherited forms which might have to
//   generate a total of foreign currencies. In this version, totals of
//   foreign currencies are not processed, since the are expressed in different
//   currencies.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableSummaryCurrTotal;
begin  // of TFrmVSRptTndCount.GenerateTableSummaryCurrTotal
end;   // of TFrmVSRptTndCount.GenerateTableSummaryCurrTotal

//=============================================================================
// TFrmVSRptTndCount.GenerateTableSummaryCurr : generates the table with the
// counted results of foreign currencies in the foreign currency.
//=============================================================================

procedure TFrmVSRptTndCount.GenerateTableSummaryCurr;
var
  FlgSavPrintNull  : Boolean;          // Save FlgPrintNullLine
begin  // of TFrmVSRptTndCount.GenerateTableSummaryCurr
  FlgSavPrintNull := FlgPrintNullLine;
  InitializeBeforeStartTable;
  BuildTableSummaryCurrFmtAndHdr;
  VspPreview.StartTable;
  try
    FlgPrintNullLine := False;
    GenerateTableSummaryCurrBody;
    if QtyLinesPrinted > 1 then
      GenerateTableSummaryCurrTotal;
  finally
    VspPreview.EndTable;
    if QtyLinesPrinted > 0 then
      VspPreview.CurrentY := VspPreview.CurrentY + ViValSpaceBetween;
    FlgPrintNullLine := FlgSavPrintNull;
  end;
end;   // of TFrmVSRptTndCount.GenerateTableSummaryCurr

//=============================================================================
// TFrmVSRptTndCount.AddFooterToPages : adds a footer to each page with
// date and pagenumber.
//=============================================================================

procedure TFrmVSRptTndCount.AddFooterToPages;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
begin  // of TFrmVSRptTndCount.AddFooterToPages
  // Add page number and date to report
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
        VspPreview.CurrentX := VspPreview.MarginLeft;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := CtTxtPrintDate + ' ' + DateToStr (Now);
        TxtPage := Format ('P.%d/%d', [CntPage, VspPreview.PageCount]);
        VspPreview.CurrentX := VspPreview.PageWidth - VspPreview.MarginRight -
                               VspPreview.TextWidth [TxtPage] - 1;
        VspPreview.CurrentY := VspPreview.PageHeight - VspPreview.MarginBottom +
                               VspPreview.TextHeight ['X'];
        VspPreview.Text := TxtPage;
      finally
        VspPreview.EndOverlay;
      end;
    end;  // of for CntPage := 1 to VspPreview.PageCount
  end;  // of VspPreview.PageCount > 0
end;   // of TFrmVSRptTndCount.AddFooterToPages

//=============================================================================
// TFrmVSRptTndCount.RenameExistingDocuments : renames the existing documents
// to enable the new document to be saved with serial number 1, and keep
// only a maximum number of older documents.
//                                  -----
// INPUT   : TxtFNDoc = filename of documents to rename.
//           QtyDoc = number of documents to keep.
//=============================================================================

procedure TFrmVSRptTndCount.RenameExistingDocuments (TxtFNDoc : string;
                                                     QtyDoc   : Integer);
var
  NumRenameDoc     : Byte;             // Extension-number to rename document
  TxtReplMask      : string;           // Mask replace serial number in filename
  TxtFNMask        : string;           // Mask filename (to replace serial num)
  QtyPosKeep       : Integer;          // Number of positions filename to keep
  TxtFNSearch      : string;           // FileName to search for
  TxtFNOldDoc      : string;           // Filename old document (rename)
  TxtFNNewDoc      : string;           // Filenmae new document (rename)
  RecFile          : TSearchRec;       // SearchRec for FindFirst, FindNext
  NumError         : Integer;          // Result of FindFirst, FindNext
begin  // of TFrmVSRptTndCount.RenameExistingDocuments
  if QtyDoc > 999 then
    QtyDoc := 999;
  TxtReplMask := '%-s.VS';
  TxtFNMask   := TxtFNDoc + '_???-' + TxtReplMask;
  QtyPosKeep  := Length (TxtFNDoc + '_???-');

  // Remove saved document with highest number
  TxtFNSearch :=
    Format (TxtFNMask, [LeftPadStringCh (IntToStr (QtyDoc), '0', 3)]);
  NumError := FindFirst (TxtFNSearch, faAnyFile, RecFile);
  try
    if (NumError = 0) and ((RecFile.Attr and faDirectory) <= 0) and
       ((RecFile.Attr and faDirectory) <= 0) then
      DeleteFile (ExtractFileDir (TxtFNDoc) + '\' + RecFile.Name);
  finally
    FindClose (RecFile);
  end;

  // Increment serial number for existing documents
  for NumRenameDoc := QtyDoc - 1 downto 1 do begin
    TxtFNSearch := Format (TxtFNMask,
                           [LeftPadStringCh (IntToStr (NumRenameDoc), '0', 3)]);
    NumError := FindFirst (TxtFNSearch, faAnyFile, RecFile);
    try
      if (NumError = 0) and ((RecFile.Attr and faDirectory) <= 0) and
         ((RecFile.Attr and faDirectory) <= 0) then begin
        TxtFNOldDoc := ExtractFileDir (TxtFNDoc) + '\' + RecFile.Name;
        TxtFNNewDoc := Copy (TxtFNOldDoc, 1, QtyPosKeep) + TxtReplMask;
        TxtFNNewDoc :=
          Format (TxtFNNewDoc,
                  [LeftPadStringCh (IntToStr(NumReNameDoc+1), '0', 3)]);
        RenameFile (TxtFNOldDoc, TxtFNNewDoc);
    end;
    finally
      FindClose (RecFile);
    end;
  end;
end;   // of TFrmVSRptTndCount.RenameExistingDocuments

//=============================================================================
// TFrmVSRptTndCount.SaveDocument : saves the document considering the
// maximum number of documents to keep.
//=============================================================================

procedure TFrmVSRptTndCount.SaveDocument;
var
  TxtFNNew         : string;           // FileName to create
begin  // of TFrmVSRptTndCount.SaveDocument
  try
    CreatePathDirs (DmdFpnTender.TxtFNSplRptCount);
    RenameExistingDocuments (DmdFpnTender.TxtFNSplRptCount,
                             DmdFpnTender.QtySplRptCount);
    TxtFNNew := DmdFpnTender.TxtFNSplRptCount + '_' +
      LeftPadStringCh (IntToStr (IdtSafeTransaction mod 1000), '0', 3) +
                       '-001.VS';
    SaveDocument (TxtFNNew);
  except
    on E:Exception do begin
      E.Message := CtTxtEmSaveReport + ' : ' + E.Message;
      Application.HandleException (Self);
    end;
  end;
end;   // of TFrmVSRptTndCount.SaveDocument

//=============================================================================

function TFrmVSRptTndCount.GetNumRef : string;
begin  // of TFrmVSRptTndCount.GetNumRef
  Result := CtTxtRep + FNumRef;
end;   // of TFrmVSRptTndCount.GetNumRef

//=============================================================================
// TFrmVSRptTndCount - Public methods
//=============================================================================

procedure TFrmVSRptTndCount.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptTndCount.DrawLogo
  if (TxtFNLogo <> '') and (Assigned (ImgLogo)) then begin
    // Assure logo is printed on top of page
    ValSaveMargin := VspPreview.MarginTop;
    VspPreview.MarginTop := ValOrigMarginTop;
    try
      inherited;
    finally
      VspPreview.MarginTop := ValSaveMargin;
    end;
  end;
end;   // of TFrmVSRptTndCount.DrawLogo

//=============================================================================
// TFrmVSRptTndCount.GenerateReport : generates the report.
//                                  -----
// Restrictions :
// - document must be generated in preview mode, because after generating, we
//   have to overlay all pages to add the pagenumber to each page.
//   But, even when creating in Preview mode, VspPreview must have been visible
//   at least one time (otherwise VspPreview remains empty!).
//=============================================================================

procedure TFrmVSRptTndCount.GenerateReport;
begin  // of TFrmVSRptTndCount.GenerateReport
  inherited;
  Visible := True;
  Visible := False;

  InitializeBeforeGenerateReport;

  VspPreview.StartDoc;
  try
    if FlgExportToFile then
      PrepareExportFile;
    GenerateTableCount;
    GenerateTableDetail;
    GenerateTableSummaryCurr;
    PrintExplanation;
    PrintConclusion;
    if FlgExportToFile then
      SaveExportFile;
  finally
    MemStmExport.Free;
    MemStmExport := nil;
    VspPreview.EndDoc;
  end;

  AddFooterToPages;
  PrintRef;
  if FlgSaveDocument and (DmdFpnTender.QtySplRptCount > 0) then
    SaveDocument;
end;   // of TFrmVSRptTndCount.GenerateReport

//=============================================================================

procedure TFrmVSRptTndCount.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptTndCount.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptTndCount.PrintRef

//=============================================================================
// TFrmVSRptTndCount - Event Handlers
//=============================================================================

procedure TFrmVSRptTndCount.FormCreate(Sender: TObject);
begin  // of TFrmVSRptTndCount.FormCreate
  inherited;
  AllowOpenActions := False;
end;   // of TFrmVSRptTndCount.FormCreate

//=============================================================================

procedure TFrmVSRptTndCount.VspPreviewBeforeHeader(Sender: TObject);
var
  ValPosYEndHdr  : Double;             // Y-position at end of header
begin  // of TFrmVSRptTndCount.VspPreviewBeforeHeader
  inherited;

  DrawLogo (PicLogo);
  PrintPageHeader;
  // Save Y-position at end of header
  ValPosYEndHdr := VspPreview.CurrentY;
  // Calculate Y-position for Address to align it with bottom of header
  VspPreview.CurrentY := ValPosYEndHdr - (4 * CalcTextHei);
  if VspPreview.CurrentY < ValOrigMarginTop then
    VspPreview.CurrentY := ValOrigMarginTop;
  // Print Address TradeMatrix
  PrintAddress;

  // Calculate Y-position to start report
  if VspPreview.CurrentY < ValPosYEndHdr then
    VspPreview.CurrentY := ValPosYEndHdr;
end;   // of TFrmVSRptTndCount.VspPreviewBeforeHeader

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FVSRptTndCount
