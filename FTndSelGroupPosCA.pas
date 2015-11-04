//=Copyright 2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet   : Castorama Flexpos Development
// Customer : Castorama
// Unit     : FTndSelGroupPosCA = Form TeNDer to SELect a tenderGROUP for POS of
// CAstorama
//-----------------------------------------------------------------------------
// PVCS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FTndSelGroupPosCA.pas,v 1.1 2006/12/22 14:43:34 NicoCV Exp $
// History :
// - Started from Castorama - FlexPoint 2.0 - FTndSelGroupPosCA - CVS revision 1.2
//=============================================================================

unit FTndSelGroupPosCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfCommon, StdCtrls, Buttons, DFpnTenderGroupPosCA, DFpnTenderPosCA;

type
  TFrmTndSelGroup = class(TFrmCommon)
    LblTenderGroup: TLabel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    LbxTenderGroup: TListBox;
    procedure FormActivate(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure LbxTenderGroupDblClick(Sender: TObject);
  protected
    // Data fields
    FIdtTenderGroup     : Integer;     // To select the tendergroups
    FCodRunFunc         : Integer;     // Run function to select tendergroups

    function TenderGroupAllowed (ObjTenderGroup : TObjTenderGroup) : Boolean;
                                                                        virtual;
  published
    property IdtTenderGroup : Integer read  FIdtTenderGroup
                                      write FIdtTenderGroup;
    property CodRunFunc : Integer read  FCodRunFunc
                                  write FCodRunFunc;
  end;

var
  FrmTndSelGroup: TFrmTndSelGroup;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FTndSelGroupPosCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FTndSelGroupPosCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 14:43:34 $';

//*****************************************************************************
// Implementation of FrmTndSelGroup
//*****************************************************************************

function TFrmTndSelGroup.TenderGroupAllowed (ObjTenderGroup: TObjTenderGroup)
                                                                      : Boolean;
begin  // of TFrmTndSelGroup.TenderGroupAllowed
  Result := False;
  if CodRunFunc in [CtCodFuncPayin] then
    Result := ObjTenderGroup.FlgPayin
  else if CodRunFunc in [CtCodFuncPayinC] then
    Result := ObjTenderGroup.FlgPayInCM or ObjTenderGroup.FlgPayInCC
  else if CodRunFunc in [CtCodFuncPayOut] then
    Result := ObjTenderGroup.FlgPayout
  else if CodRunFunc in [CtCodFuncPayOutC] then
    Result := ObjTenderGroup.FlgPayOutCM or ObjTenderGroup.FlgPayOutCC;
(** PDW - begin - 13-03-03 - old version **)
// // SVE Parameters
//   Result := ((CodRunFunc in [CtCodFuncPayin, CtCodFuncPayinC])
//             and ObjTenderGroup.FlgPayin) or
//             ((CodRunFunc in [CtCodFuncPayout, CtCodFuncPayoutC])
//             and ObjTenderGroup.FlgPayout);
(** PDW - end **)
end;   // of TFrmTndSelGroup.TenderGroupAllowed

//=============================================================================

procedure TFrmTndSelGroup.FormActivate(Sender: TObject);
var
  CntIndex         : Integer;          // Index of items
  ObjTenderGroup   : TObjTenderGroup;  // Tendergroup object to select/add
  NumIndex         : Integer;          // Index of item
begin  // of TFrmTndSelGroup.FormActivate
  inherited;

  LbxTenderGroup.Clear;
  if not Assigned (LstTenderGroup) then
    LstTenderGroup := TLstTenderGroup.Create;
  if LstTenderGroup.Count = 0 then
    DmdFpnTenderGroup.BuildListTenderGroup (LstTenderGroup);
  for CntIndex := 0 to Pred (LstTenderGroup.Count) do begin
    ObjTenderGroup := LstTenderGroup.TenderGroup [CntIndex];
    if TenderGroupAllowed (ObjTenderGroup) then begin
      NumIndex := LbxTenderGroup.Items.
                    AddObject (IntToStr (LbxTenderGroup.Items.Count + 1) + ' - '
                               + ObjTenderGroup.TxtPublDescr, ObjTenderGroup);
      if ObjTenderGroup.IdtTenderGroup = IdtTenderGroup then
        LbxTenderGroup.ItemIndex := Numindex;
    end;
  end;
  LbxTenderGroup.SetFocus;
end;  // of TFrmTndSelGroup.FormActivate

//=============================================================================

procedure TFrmTndSelGroup.BtnOKClick(Sender: TObject);
begin  // of TFrmTndSelGroup.BtnOKClick
  inherited;
  IdtTenderGroup :=
    TObjTenderGroup (LbxTenderGroup.Items.Objects[LbxTenderGroup.ItemIndex])
                                                                .IdtTenderGroup;
end;   // of TFrmTndSelGroup.BtnOKClick

//=============================================================================

procedure TFrmTndSelGroup.LbxTenderGroupDblClick(Sender: TObject);
begin  // of TFrmTndSelGroup.LbxTenderGroupDblClick
  inherited;
  if LbxTenderGroup.ItemIndex > -1 then
    BtnOk.Click;
end;   // of TFrmTndSelGroup.LbxTenderGroupDblClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FTndSelGroupPosCA
  