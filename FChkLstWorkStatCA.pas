//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : FlexPoint
// Unit   : FChkLstWorkstatCA.PAS : Form CHecKLiST WORKSTATIONS - Form to select
//                                  The workstations in a checklist
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkLstWorkStatCA.pas,v 1.7 2010/02/02 09:28:30 BEL\DVanpouc Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FChkLstWorkStatCA - CVS revision 1.1
//=============================================================================

unit FChkLstWorkStatCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FChkLstWorkstat, ImgList, ActnList, StdCtrls, Buttons, CheckLst, Db;

//*****************************************************************************

type
  TFrmChkLstWorkstatCA = class(TFrmChkLstWorkstat)
  private
    { Private declarations }
  protected
    function GetDstList: TDataSet; override;
  public
    { Public declarations }
    property DstList: TDataSet read GetDstList
                               write FDstList;
  end;

var
  FrmChkLstWorkstatCA: TFrmChkLstWorkstatCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog,
  SmDBUtil_BDE,
  DFpnUtils,
  DFpnWorkStatCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChkLstWorkstatCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChkLstWorkStatCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.7 $';
  CtTxtSrcDate    = '$Date: 2010/02/02 09:28:30 $';

//*****************************************************************************
// Implementation of TFrmChkLstWorkstatCA
//*****************************************************************************

//=============================================================================
// TFrmChkLstWorkstatCA - Methods for read/write properties
//=============================================================================

function TFrmChkLstWorkstatCA.GetDstList: TDataSet;
begin // of TFrmChkLstWorkstatCA.GetDstList
  if not Assigned (FDstList) then
    FDstList :=
      CopyStoredProc (Self, 'SprRTLstWorkstat',
                      DmdFpnUtils.SprLstFullJoin,
                      ['@PrmTxtTable=WorkStat',
                       '@PrmTxtArrFields=IdtCheckout;TxtPublDescr',
                       '@PrmTxtSequence=TxtSrcPubl',
                       '@PrmTxtCondition=CodType NOT IN (' +
                        IntToStr(CtCodWorkStatServer1) + ',' +
                        IntToStr(CtCodWorkStatServer2) + ')']);
  Result := FDstList;
end;  // of TFrmChkLstWorkstat.GetDstList

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.   // of FChkLstWorkStatCA
