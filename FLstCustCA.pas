//=========== Copyright 2011 (c) Kingfisher IT Services. All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer: Castorama
// Unit     : FLstCustCA.PAS : MainForm LIST CUSTOMER for Castorama
//--------------------------------------------------------------------------------------------------------------------------------------
// PVCS   :  $Header: /development/castorama/Flexpoint/Src/Flexpoint201/Develop/FLstCustCA.pas,v 1.0 2011/02/07 17:04:21 $
// History:
// Version                              Modified By                          Reason
// V 1.0                                V.K.R (TCS)                          R2011.1 - BDFR - Suppression Local Client
// V 1.1                                AJ    (TCS)                          R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
//=============================================================================

unit FLstCustCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, SfList_BDE_DBC,sflistoptions_BDE_DBC ;

//*****************************************************************************
// Class definitions
//*****************************************************************************

type
  TFrmLstCustCA = class(TFrmList)
    procedure MniOptionsClick(Sender: TObject);
    procedure DscListDataChange(Sender: TObject; Field: TField);
    //R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.Start
    procedure DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
    DataCol: Integer; Column: TColumn; State: TGridDrawState);
    //R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.End
  private
    { Private declarations }
    FlgFirstRow: Boolean;
  public
    { Public declarations }
  end;
const                                                                           //R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
  CtTxtSpecCustomer = '99999';                                                  //R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ
var
  FrmLstCustCA: TFrmLstCustCA;
 
//*****************************************************************************

implementation

uses
  FMntCustomerCA,
  DBCGrids,
  OvcDbPF,
  ScDBUtil_Ovc,
  ScTskMgr_BDE_DBC,
  SfDialog,
  SmUtils,
  SmDBUtil_BDE,
  SrStnCom;

{$R *.dfm}

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstCustCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstCustCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2011/02/07 17:04:21 $';


//*****************************************************************************
// Implementation of TFrmLstCustCA
//*****************************************************************************

procedure TFrmLstCustCA.DscListDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if FMntCustomerCA.FrmMntCustomerCA.FlgDelLocal = True then begin


             if (DscList.DataSet.FieldByName('CodCreator').AsString = '1') then  begin
             AllowedJobs := [CtCodJobRecNew,CtCodJobRecMod,CtCodJobRecCons,CtCodJobRecDel]
             end
             else begin
             AllowedJobs := [CtCodJobRecNew,CtCodJobRecMod,CtCodJobRecCons]
             end;

      end;

end;

//=============================================================================
//R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.Start
procedure TFrmLstCustCA.DBGrdListDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Grid : TDBGrid;
  CustomerNum : String;
begin
  inherited;
  Grid := sender as TDBGrid;
  CustomerNum := Grid.DataSource.DataSet.FieldByName('IdtCustomer').AsString;

  // Highlight
  if (FrmMntCustomerCA.FlgCustomerFromSAP) then begin
    if (gdSelected in State) then
    begin
      if  (CustomerNum = '9' + FrmMntCustomerCA.StoreNum) or (CustomerNum = CtTxtSpecCustomer)then
        begin
          BtnRecMod.Enabled:=True;
          BtnRecNew.Enabled:=False;
          BtnRecDel.Enabled:=False;
          MniRecMod.Enabled:=True;
          MniRecNew.Enabled:=False;
          MniRecDel.Enabled:=False;
        end
      else
        begin
          BtnRecMod.Enabled:=False;
          BtnRecNew.Enabled:=False;
          BtnRecDel.Enabled:=False;
          MniRecMod.Enabled:=False;
          MniRecNew.Enabled:=False;
          MniRecDel.Enabled:=False;
        end;
    end;
  end;
  Grid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
//R2013.2.HOTFIX(45040).BDFR.Customer-From-SAP.TCS-AJ.End
//=============================================================================

procedure TFrmLstCustCA.MniOptionsClick(Sender: TObject);
var
  FrmListOptions   : TFrmListOptions;  // Form  for ListOptions
begin  // of TFrmList.MniOptionsClick
  FrmListOptions := TFrmListOptions.CreateForTask (Self, SvcTskActive);
  try
    FrmListOptions.Height := 278;
    FrmListOptions.Caption := FrmListOptions.Caption + ' ' + Caption;
    RelativeRepositionForm (FrmListOptions, Self, rfpOptimal);
    SaveView;
    FrmListOptions.ShowModal;
    RestoreView;
  finally
    FrmListOptions.Release;
  end;
end;

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.    // of FLstCustCA
