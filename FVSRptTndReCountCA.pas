//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : FlexPoint
// Unit   : FVSRptTndReCountCA = Form VideoSoft RePorT TeNDer RECOUNT CAstorama
// Customer   :  Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndReCountCA.pas,v 1.1 2006/12/22 15:28:52 NicoCV Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - FVSRptTndReCountCA - CVS revision 1.5
//=============================================================================

unit FVSRptTndReCountCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FVSRptTndCountCA, ActnList, ImgList, Menus, OleCtrls,
  SmVSPrinter7Lib_TLB, Buttons, ComCtrls, ToolWin, ExtCtrls;

//=============================================================================
// Global definitions
//=============================================================================

//-----------------------------------------------------------------------------

resourcestring     // for printing the header of the final count.
  CtTxtHdrReCount       = 'Recount';

//*****************************************************************************
// TFrmVSRptTndReCount
//*****************************************************************************

type
  TFrmVSRptTndReCountCA = class(TFrmVSRptTndCountCA)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FIdtTenderGroupReCnt: Integer;
    FNumBagToRecount    : string;      // Number of Bag to recount;
  public
    { Public declarations }
    procedure GenerateReport; override;
  protected
    procedure PrintPageHeader; override;
    procedure GenerateTableBagBody; override;
  published
    property NumBagToRecount : string read FNumBagToRecount
                                      write FNumBagToRecount;
    property IdtTenderGroupReCount : Integer read FIdtTenderGroupReCnt
                                             write FIdtTenderGroupReCnt;
  end; // of TFrmVSRptTndReCountCA

var
  FrmVSRptTndReCountCA: TFrmVSRptTndReCountCA;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,

  DFpnBagCA,
  DFpnSafeTransaction,
  DFpnSafeTransactionCA,
  DFpnTender,
  DFpnTenderCA,
  DFpnTenderGroup,
  FVSRptTndCount,
  RFpnTender;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndReCountCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndReCountCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 15:28:52 $';

//*****************************************************************************
// Implementation of TFrmVSRptTndReCountCA
//*****************************************************************************

procedure TFrmVSRptTndReCountCA.GenerateReport;
begin  // of TFrmVSRptTndReCountCA.GenerateReport
  Visible := True;
  Visible := False;

  InitializeBeforeGenerateReport;
  ValTotalTheorPrint := 0;
  SetLength (ArrPages, 1);
  ArrPages [Length (ArrPages) - 1] := 1;

  VspPreview.StartDoc;
  try
    GenerateTableBagBody;
    SetLength (ArrPages, Length (ArrPages) + 1);
    ArrPages [Length (ArrPages) - 1] := VspPreview.PageCount + 1;
  finally
    VspPreview.EndDoc;
  end;
  AddFooterToPages;
  PrintRef;
  if FlgSaveDocument and (DmdFpnTenderCA.QtySplRptCount > 0) then
    SaveDocument;
end;   // of TFrmVSRptTndReCountCA.GenerateReport

//=============================================================================

procedure TFrmVSRptTndReCountCA.PrintPageHeader;
var
  ViValFontSave  : Variant;            // Save original FontSize
  TxtHeader      : string;             // Build header string to print
begin  // of TFrmVSRptTndReCountCA.PrintPageHeader
  if not CodRunFunc in [CtCodFuncPayOut, CtCodFuncPayIn] then begin
    inherited;
    exit;
  end;

  ViValFontSave := VspPreview.FontSize;
  try
    // Header report count
    VspPreview.CurrentX := VspPreview.Marginleft;
    VspPreview.CurrentY := ValOrigMarginTop;
    VspPreview.FontSize := ViValFontHeader;
    VspPreview.FontBold := True;

    TxtHeader := CtTxtHdrReCount;

    TxtHeader := TxtHeader + ' : ' + NumBagToRecount;
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
end;   // of TFrmVSRptTndReCountCA.PrintPageHeader

//=============================================================================

procedure TFrmVSRptTndReCountCA.GenerateTableBagBody;
var
  LstBagPrint      : TLstBagCA;        // Bag list
  CntLine          : Integer;          // Line counter
  ObjTenderGroup   : TObjTenderGroup;  // Object of tendergroup
begin  // of TFrmVSRptTndReCountCA.GenerateTableBagBody
  FlgPrintNullLine := True;
  LstBagPrint := TLstSafeTransactionCA(LstSafeTransaction).LstBag;

  try
    if LstBagPrint.Count > 0 then begin
      for CntLine := 0 to Pred (LstBagPrint.Count) do begin
        VspPreview.Text := Format (CtTxtHdrBagNumber,
                                   [LstBagPrint.Bag [CntLine].IdtBag]) + #10#10;
        ObjTenderGroup := LstTenderGroup.FindIdtTenderGroup (
                                     LstBagPrint.Bag [CntLine].IdtTenderGroup);

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
      end;
    end;
  finally
  end;

//  VspPreview.TableCell [tcAlign, 0, 1, 0, 1] := taLeftMiddle;
//  VspPreview.TableCell
//      [tcAlign, 0, 2, 0,
//       VspPreview.TableCell [tcCols, 0, 0, 0, 0]] := taCenterMiddle;
end;   // of TFrmVSRptTndReCountCA.GenerateTableBagBody

//=============================================================================

procedure TFrmVSRptTndReCountCA.FormCreate(Sender: TObject);
begin
  inherited;
  RefNum := '0032';
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FVSRptTndReCountCA
