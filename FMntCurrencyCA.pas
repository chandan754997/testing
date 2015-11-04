//=== Copyright 2009 (c) Centric Retail Solutions NV. All rights reserved. ====
// Packet : FlexPoint Development
// Unit   : FMntCurrency : MainForm MaiNTenance CURRENCY
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCurrencyCA.pas,v 1.2 2010/02/12 12:55:42 BEL\KDeconyn Exp $
// Version    Modified by  Reason
// 1.1        Chayanika(TCS)     //Regression Fix R2012.1 (Chayanika)
//=============================================================================

unit FMntCurrencyCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntCurrency, ScTskMgr_BDE_DBC;

//=============================================================================
// TFrmMntCurrencyCA
//=============================================================================
resourcestring
  CtTxtTitle             = 'Maintenance Currency';                              //Regression Fix R2012.1 (Chayanika)
type
  TFrmMntCurrencyCA = class(TFrmMntCurrency)
    procedure FormActivate(Sender: TObject);                                    //Regression Fix R2012.1 (Chayanika)
    procedure SvcTskDetCurrencyCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntCurrencyCA: TFrmMntCurrencyCA;

//*****************************************************************************

implementation

uses FDetCurrencyCA, SfDialog;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntCurrencyCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntCurrencyCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2010/02/12 12:55:42 $';

//*****************************************************************************
// Implementation of TFrmMntCurrencyCA
//*****************************************************************************
//Regression Fix R2012.1 (Chayanika) Start
procedure TFrmMntCurrencyCA.FormActivate(Sender: TObject);
begin  // of TFrmMntCurrencyCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntCurrencyCA.FormActivate
//Regression Fix R2012.1 (Chayanika) End
//=============================================================================
procedure TFrmMntCurrencyCA.SvcTskDetCurrencyCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin  // of TFrmMntCurrencyCA.SvcTskDetCurrencyCreateExecutor
  NewObject := TFrmDetCurrencyCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;   // of TFrmMntCurrencyCA.SvcTskDetCurrencyCreateExecutor

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end. // of TFrmMntCurrencyCA
