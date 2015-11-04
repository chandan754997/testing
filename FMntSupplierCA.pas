//=========== Sycron Computers Belgium (c) 1997-1998 ==========================
// Packet : FlexPos Development
// Unit   : FMntSupplier.PAS : MainForm MaiNTenance SUPPLIER Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntSupplierCA.pas,v 1.2 2006/12/21 15:21:28 hofmansb Exp $
// History:
//
//=============================================================================

unit FMntSupplierCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FMntSupplier, Db, DBTables, ScTskMgr_BDE_DBC;

//=============================================================================

type
  TFrmMntSupplierCA = class(TFrmMntSupplier)
    procedure SvcTskDetSupplierCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
    procedure SvcTskDetAddressCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntSupplierCA: TFrmMntSupplierCA;

//*****************************************************************************

implementation

uses
  SfDialog,

  DFpnAddressCA,
  DFpnCustomerCA,
  DFpnMunicipalityCA,

  FDetSupplierCA,
  FDetAddressCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntSupplierCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntSupplierCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2006/12/21 15:21:28 $';

//*****************************************************************************
// Implementation of TFrmMntSupplierCA
//*****************************************************************************

procedure TFrmMntSupplierCA.SvcTskDetSupplierCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntSupplierCA.SvcTskDetSupplierCreateExecutor
  NewObject := TFrmDetSupplierCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntSupplierCA.SvcTskDetSupplierCreateExecutor

//=============================================================================

procedure TFrmMntSupplierCA.SvcTskDetAddressCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntSupplierCA.SvcTskDetAddressCreateExecutor
  NewObject := TFrmDetAddressCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntSupplierCA.SvcTskDetAddressCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.   // of FMntSupplierCA


