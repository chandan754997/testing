//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet   : FlexPoint
// Unit     : FVSRptTndGlobalCountCA = Form VideoSoft RePorT TeNDer GLOBAL COUNT
//                                     for CAstorama
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndGlobalCountSelect.pas,v 1.3 2009/09/22 10:30:42 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - FlexPoint 2.0 - PRptGlobalCount - CVS revision 1.10
//=============================================================================

unit FVSRptTndGlobalCountSelect;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FVSRptTndGlobalCountCA, ActnList, ImgList, Menus, ExtCtrls, Buttons,
  ComCtrls, OleCtrls, SmVSPrinter7Lib_TLB;

//=============================================================================
// Resource strings
//=============================================================================

resourcestring     // for printing the header of the final count.
  CtTxtHdrDat             = 'Summary of counts made between %s and %s';
  CtTxtHdrNbOperator      = 'Operator Number';
  CtTxtHdrNameOperator    = 'Cashdesk Rapport of';

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmVSRptTndGlobalCountSelect = class(TFrmVSRptTndGlobalCountCA)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure PrintPageHeader; override;
  public
    { Public declarations }
  end;

var
  FrmVSRptTndGlobalCountSelect: TFrmVSRptTndGlobalCountSelect;

//*****************************************************************************

implementation

{$R *.dfm}

uses
  SfDialog,

  FDetTndReprintCA,
  DFpnTenderCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FVSRptTndGlobalCountSelect';

const  // CVS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FVSRptTndGlobalCountSelect.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/22 10:30:42 $';

//=============================================================================

procedure TFrmVSRptTndGlobalCountSelect.PrintPageHeader;
begin  // of TFrmVSRptTndGlobalCountSelect.PrintPageHeader
  // This header is only applied to the summary final count.
  VspPreview.FontBold := True;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.CurrentY := ValOrigMarginTop;
  VspPreview.Text     := CtTxtHdrGlobalReport;
  VspPreview.FontBold := False;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text     := CtTxtHdrNbOperator + ' ' + IdtRegFor;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  If not FlgNoName then
    VspPreview.Text := CtTxtHdrNameOperator + ' ' + TxtNameRegFor;
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
  VspPreview.Text     := Format(CtTxtHdrDat,[DateToStr(
                         FrmDetTndReprintCA.DtmPckDayStart.Date),DateToStr(
                         FrmDetTndReprintCA.DtmPckDayEnd.Date)]);
  VspPreview.CurrentY := VspPreview.CurrentY + 2 * CalcTextHei;
  VspPreview.CurrentX := VspPreview.Marginleft;
end;   // of TFrmVSRptTndGlobalCountSelect.PrintPageHeader

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FVSRptTndGlobalCountSelect
