//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet : FlexPoint
// Unit   : FChkLstOperatorCA.PAS : Form CHecKLiST OPERATOR - Form to select
//                                 The Operator in a checklist for CAstorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkLstOperatorCA.pas,v 1.2 2007/01/03 15:07:24 NicoCV Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FChkLstOperatorCA - CVS revision 1.3
//=============================================================================

unit FChkLstOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FChkLstOperator, ImgList, ActnList, StdCtrls, Buttons, CheckLst;

type
  TFrmChkLstOperatorCA = class(TFrmChkLstOperator)
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure ActivateSelItems; override;
  public
    { Public declarations }
  end;

var
  FrmChkLstOperatorCA: TFrmChkLstOperatorCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  DFpnUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChkLstOperator';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkLstOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2007/01/03 15:07:24 $';

//*****************************************************************************
// Implementation of TFrmChkLstOperatorCA
//*****************************************************************************

//=============================================================================

procedure TFrmChkLstOperatorCA.ActivateSelItems;
var
  CntItem          : Integer;          // Used as index in loop
  TxtLeft          : string;           // Left side of string
  TxtRight         : string;           // Right side of string
begin
  for CntItem := 0 to Pred (ChkLbxOperator.Items.Count) do begin
    SplitString (ChkLbxOperator.Items[CntItem], ' - ', TxtLeft, TxtRight);
    TxtLeft := IntToStr(StrToInt(TxtLeft));
    ChkLbxOperator.Checked[CntItem] := (AnsiPos (AnsiQuotedStr (TxtLeft, ''''),
                                             SelectedItems) <> 0);
  end;
end;

//=============================================================================

procedure TFrmChkLstOperatorCA.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  CntItem          : Integer;          // Index in loops
  TxtLeft          : string;           // Left side of string
  TxtRight         : string;           // Right side of string
  TxtSep           : string;           // Separator (',' or ' ')
begin
  TxtSep := '';
  if ModalResult = mrOk then begin
    FSelectedItems := '';
    for CntItem := 0 to Pred (ChkLbxOperator.Items.Count) do
      if ChkLbxOperator.Checked[CntItem] then begin
        SplitString (ChkLbxOperator.Items[CntItem], ' - ', TxtLeft, TxtRight);
        TxtLeft := IntToStr(StrToInt(TxtLeft));
        FSelectedItems := FSelectedItems + TxtSep +
                          AnsiQuotedStr (TxtLeft, '''');
        TxtSep := ',';
      end;
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end. // of FChkLstOperatorCA
