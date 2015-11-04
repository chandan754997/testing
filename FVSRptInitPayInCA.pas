//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : Flexpoint
// Unit   : FVSRptInitPayInCA = Form VideoSoft RePorT INITial PAYIN CAstorama
// Customer : CASTORAMA
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptInitPayInCA.pas,v 1.2 2006/12/22 13:39:45 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FVSRptInitPayInCA - CVS revision 1.
//=============================================================================

unit FVSRptInitPayInCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, Menus, OleCtrls, SmVSPrinter7Lib_TLB,
  Buttons, ComCtrls, ToolWin, ExtCtrls, SfVSPrinter7;

//=============================================================================
// Global definitions
//=============================================================================

resourcestring
  CtTxtInitPayIn        = 'Initial Pay In';
  CtTxtDateRegistration = 'Date of registration : %s on %s';
  CtTxtDateIntoEffect   = 'Coming into effect : %s';

resourcestring
  CtTxtIdtOperator = 'Operator Nr';
  CtTxtName        = 'Name';
  CtTxtAmountPayIn = 'Amount Initial PayIN';
  CtTxtAmountGlobal= 'Global Amount';
  CtTxtSignature   = 'Signature';
  CtTxtTokenSignature = '............................................';

var
  ViValRptWidthIdtOper  : Integer = 12;
  ViValRptWidthName     : Integer = 35;
  ViValRptWidthAmount   : Integer = 15;
  ViValRptWidthSignature: Integer = 29;

//=============================================================================
// CUSTOM OBJECT
//=============================================================================

type
  TObjOperator = class
  private
    FIdtOperator   : string;          // Ident. of the operator
    FTxtOperator   : string;           // Name of the operator
    FFlgPayIn      : Boolean;          // Is there a PayIn value?
    FValPayIn      : Double;           // Value just initialised.
    FValTotPayIn   : Double;           // Total Initial Value already init.
    FNumSeq        : Integer;          // Number of the sequence
  public
    property IdtOperator : string read  FIdtOperator
                                   write FIdtOperator;
    property TxtOperator : string read  FTxtOperator
                                  write FTxtOperator;
    property FlgPayIn    : Boolean read FFlgPayIn
                                   write FFlgPayIn;
    property ValPayIn    : Double read  FValPayIn
                                  write FValPayIn;
    property ValTotPayIn : Double read  FValTotPayIn
                                  write FValTotPayIn;
    property NumSeq      : Integer read  FNumSeq
                                   write FNumSeq;
  end;  // of TObjOperator

//=============================================================================

type
  TFrmVSRptInitPayInCA = class(TFrmVSPreview)
    procedure VspPreviewNewPage(Sender: TObject);
  private
    { Private declarations }
    FLstOperators       : TList;       // List with Operators
    FDatReg             : TDate;       // Date of registration
  protected
    FNumRef             : string;      // Report reference
    FTxtFNLogo          : string;      // Filename Logo
    FPicLogo            : TImage;      // Logo

    // Formats and headers
    TxtTableFmt         : string;      // Format for Table on report
    TxtTableHdr         : string;      // Header for Table on report

    // Save default settings of VspPreview
    ValOrigMarginTop    : Double;      // Original MarginTop

    // Methods for Read/Write properties
    procedure SetTxtFNLogo (Value : string); virtual;

    procedure AppentFmrAndHdrIdtOperator (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrName (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrValAmount (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrTxtCur (TxtHdr : string); virtual;
    procedure AppendFmtAndHdrSign (TxtHdr : string); virtual;
    procedure BuildTableBodyFmtAndHdr; virtual;

    procedure PrintHeader; virtual;
    procedure MakeOverLay; virtual;
    procedure PrintReport; virtual;
    procedure PrintRef; virtual;
  public
    // Constructor & destructor
    constructor Create (AOwner : TComponent); override;
    destructor Destroy; override;

    procedure DrawLogo (ImgLogo : TImage); override;
    procedure GenerateReport; virtual;

    property TxtFNLogo : string read  FTxtFNLogo
                                write SetTxtFNLogo;
    property PicLogo : TImage read  FPicLogo
                              write FPicLogo;
    property NumRef : string read  FNumRef
                             write FNumRef;
  published
    property LstOperators : TList read  FLstOperators
                                  write FLstOperators;
    property DatReg : TDate read  FDatReg
                            write FDatReg;
  end;

var
  FrmVSRptInitPayInCA: TFrmVSRptInitPayInCA;

implementation

uses
  StStrW,
  SfDialog,
  SmUtils,
  DFpnUtils;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FrmVSRptInitPayInCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FVSRptInitPayInCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:39:45 $';

//*****************************************************************************
// Implementation of TFrmVSRptInitPayInCA
//*****************************************************************************

procedure TFrmVSRptInitPayInCA.SetTxtFNLogo (Value : string);
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
end;   // of TFrmVSRptInitPayInCA.SetTxtFNLogo

//=============================================================================

procedure TFrmVSRptInitPayInCA.AppentFmrAndHdrIdtOperator (TxtHdr : string);
begin  // of TFrmVSRptInitPayInCA.AppentFmrAndHdrIdtOperator
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatNoWrap + FormatAlignLeft,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthIdtOper))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptInitPayInCA.AppentFmrAndHdrIdtOperator

//=============================================================================

procedure TFrmVSRptInitPayInCA.AppendFmtAndHdrName (TxtHdr : string);
begin  // of TFrmVSRptInitPayInCA.AppendFmtAndHdrName
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatNoWrap + FormatAlignLeft,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthName))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptInitPayInCA.AppendFmtAndHdrName

//=============================================================================

procedure TFrmVSRptInitPayInCA.AppendFmtAndHdrValAmount (TxtHdr : string);
begin  // of TFrmVSRptInitPayInCA.AppendFmtAndHdrValAmount
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthAmount))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptInitPayInCA.AppendFmtAndHdrValAmount

//=============================================================================

procedure TFrmVSRptInitPayInCA.AppendFmtAndHdrTxtCur (TxtHdr : string);
begin  // of TFrmVSRptInitPayInCA.AppendFmtAndHdrTxtCur
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthAmount))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptInitPayInCA.AppendFmtAndHdrTxtCur

//=============================================================================

procedure TFrmVSRptInitPayInCA.AppendFmtAndHdrSign (TxtHdr : string);
begin  // of TFrmVSRptInitPayInCA.AppendFmtAndHdrSign
  if TxtTableFmt <> '' then begin
    TxtTableFmt := TxtTableFmt + SepCol;
    TxtTableHdr := TxtTableHdr + SepCol;
  end;
  TxtTableFmt := TxtTableFmt +
                 Format ('%s%d',
                         [FormatAlignRight,
                          ColumnWidthInTwips(CharStrW('0',
                                                      ViValRptWidthSignature))]);
  TxtTableHdr := TxtTableHdr + TxtHdr;
end;   // of TFrmVSRptInitPayInCA.AppendFmtAndHdrSign

//=============================================================================

procedure TFrmVSRptInitPayInCA.BuildTableBodyFmtAndHdr;
begin  // of TFrmVSRptInitPayInCA.BuildTableBodyFmtAndHdr
  TxtTableFmt := '';
  TxtTableHdr := '';
  AppentFmrAndHdrIdtOperator (CtTxtIdtOperator);
  AppendFmtAndHdrName (CtTxtName);
  AppendFmtAndHdrValAmount (CtTxtAmountPayIn);
  AppendFmtAndHdrValAmount (CtTxtAmountGlobal);
  AppendFmtAndHdrSign (CtTxtSignature);
end;   // of TFrmVSRptInitPayInCA.BuildTableBodyFmtAndHdr

//=============================================================================

procedure TFrmVSRptInitPayInCA.PrintHeader;
begin  // of TFrmVSRptInitPayInCA.PrintHeader
  DrawLogo (PicLogo);

  VspPreview.Font.Style := VspPreview.Font.Style + [fsBold];
  VspPreview.Font.Size := VspPreview.Font.Size + 10;
  VspPreview.Text := CtTxtInitPayIn + #10;
  VspPreview.Font.Style := VspPreview.Font.Style - [fsBold];
  VspPreview.Font.Size := VspPreview.Font.Size - 10;
  VspPreview.Font.Size := VspPreview.Font.Size + 5;

  VspPreview.Text := Format (CtTxtDateRegistration,
                             [FormatDateTime('dd/mm/yyyy', Now),
                              FormatDateTime('hh:mm', Now)]) +#10;
  VspPreview.Text := Format (CtTxtDateIntoEffect,
                             [FormatDateTime('dd/mm/yyyy', FDatReg)]) +#10#10;
  VspPreview.Font.Size := VspPreview.Font.Size - 5;
  VspPreview.AddTable (TxtTableFmt, '', TxtTableHdr, 0, clLtGray, True);
end;   // of TFrmVSRptInitPayInCA.PrintHeader

//=============================================================================

procedure TFrmVSRptInitPayInCA.MakeOverLay;
var
  CntPage          : Integer;          // Counter pages
  TxtPage          : string;           // Pagenumber as string
begin  // of TFrmVSRptInitPayInCA.MakeOverLay
  if VspPreview.PageCount > 0 then begin
    for CntPage := 1 to VspPreview.PageCount do begin
      VspPreview.StartOverlay (CntPage, False);
      try
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
end;   // of TFrmVSRptInitPayInCA.MakeOverLay

//=============================================================================

procedure TFrmVSRptInitPayInCA.PrintReport;
var
  CntOperators     : Integer;          // Loop all operators
  TxtLine          : string;           // Line to print
  ObjCurOperator   : TObjOperator;     // Current Operator
begin  // of TFrmVSRptInitPayInCA.PrintReport
  NumRef := 'REP0023';

  BuildTableBodyFmtAndHdr;
  VspPreview.StartDoc;
  VspPreview.TableBorder := tbNone;
  for CntOperators := 0 to Pred (LstOperators.Count) do begin
    if ((TObjOperator (LstOperators [CntOperators]).FlgPayIn) and
        (Abs (TObjOperator (LstOperators [CntOperators]).ValPayIn) >=
                                                             CtValMinFloat)) or
       (Abs (TObjOperator (LstOperators [CntOperators]).ValTotPayIn) >=
                                                       CtValMinFloat) then begin
      ObjCurOperator := TObjOperator (LstOperators [CntOperators]);
      TxtLine := ObjCurOperator.IdtOperator + SepCol +
                 ObjCurOperator.TxtOperator + SepCol +
                 CurrToStrF (ObjCurOperator.ValPayIn, ffFixed,
                             DmdFpnUtils.QtyDecsPrice) + SepCol +
                 CurrToStrF (ObjCurOperator.ValTotPayIn +
                             ObjCurOperator.ValPayIn,
                             ffFixed,
                             DmdFpnUtils.QtyDecsPrice)
                 + SepCol;
      if TObjOperator (LstOperators [CntOperators]).FlgPayIn then
        TxtLine := TxtLine + CtTxtTokenSignature;

      VspPreview.AddTable (TxtTableFmt, '', ' ', 0, 0, True);
      VspPreview.AddTable (TxtTableFmt, '', TxtLine, 0, 0, True);
    end;
  end;
  VspPreview.EndDoc;
  MakeOverLay;
  PrintRef;
end;   // of TFrmVSRptInitPayInCA.PrintReport

//=============================================================================

procedure TFrmVSRptInitPayInCA.PrintRef;
var
  CntPageNb        : Integer;          // Temp Pagenumber
begin  // of TFrmVSRptInitPayInCA.PrintRef
  for CntPageNb := 1 to VspPreview.PageCount do begin
    with VspPreview do begin
      StartOverlay (CntPageNb, True);
      CurrentX := PageWidth - MarginRight - TextWidth [NumRef] - 1;
      CurrentY := PageHeight - MarginBottom + TextHeight ['X'] - 250;
      Text := NumRef;
      EndOverlay;
    end;
  end;
end;   // of TFrmVSRptInitPayInCA.PrintRef

//=============================================================================

constructor TFrmVSRptInitPayInCA.Create (AOwner : TComponent);
begin  // of TFrmVSRptInitPayInCA.Create
  inherited;
  // Set defaults
  TxtFNLogo := CtTxtEnvVarStartDir + '\Image\FlexPoint.Report.BMP';
  ValOrigMarginTop      := VspPreview.MarginTop;
end;   // of TFrmVSRptInitPayInCA.Create

//=============================================================================

destructor TFrmVSRptInitPayInCA.Destroy;
begin  // of TFrmVSRptInitPayInCA.Destroy
  FPicLogo.Free;

  inherited;
end;   // of TFrmVSRptInitPayInCA.Destroy

//=============================================================================

procedure TFrmVSRptInitPayInCA.DrawLogo (ImgLogo : TImage);
var
  ValSaveMargin    : Double;           // Save current MarginTop
begin  // of TFrmVSRptInitPayInCA.DrawLogo
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
end;   // of TFrmVSRptInitPayInCA.DrawLogo

//=============================================================================

procedure TFrmVSRptInitPayInCA.GenerateReport;
var
  CntOperators     : Integer;          // Loop all operators
  FlgPrint         : Boolean;          // Are there values to print
begin  // of TFrmVSRptInitPayInCA.GenerateReport
  FlgPrint := False;
  for CntOperators := 0 to Pred (LstOperators.Count) do begin
    if TObjOperator (LstOperators [CntOperators]).FlgPayIn or
      (TObjOperator (LstOperators [CntOperators]).ValTotPayIn > 0) then begin
      FlgPrint := True;
      break;
    end;
  end;
  if FlgPrint then
    PrintReport;
end;   // of TFrmVSRptInitPayInCA.GenerateReport

//=============================================================================

procedure TFrmVSRptInitPayInCA.VspPreviewNewPage(Sender: TObject);
begin  // of TFrmVSRptInitPayInCA.VspPreviewNewPage
  inherited;
  PrintHeader;
end;   // of TFrmVSRptInitPayInCA.VspPreviewNewPage

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FVSRptInitPayInCA
