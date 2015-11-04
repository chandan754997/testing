//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FMntVATCode : MainForm MaiNTenance VATCODE
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntVatCodeCA.pas,v 1.2 2009/09/30 10:08:21 BEL\KDeconyn Exp $
// Version    Modified by  Reason
// 1.1        Chayanika(TCS)     //Regression Fix R2012.1 (Chayanika)
//=============================================================================

unit FMntVatCodeCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMntVATCode, ScTskMgr_BDE_DBC;

//=============================================================================
// TFrmMntVATCodeCA
//=============================================================================
resourcestring
  CtTxtTitle             = 'Maintenance VAT Code';                              //Regression Fix R2012.1 (Chayanika)

type
  TFrmMntVATCodeCA = class(TFrmMntVATCode)
    procedure FormActivate(Sender: TObject);                                    //Regression Fix R2012.1 (SRM)
    procedure SvcTskDetVATCodeCreateExecutor(Sender: TObject;
      var NewObject: TObject; var FlgCreated: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMntVATCodeCA: TFrmMntVATCodeCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  sfDialog,
  FDetVatCodeCA;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FMntVATCodeCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FMntVatCodeCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2012/06/25 10:08:21 $';

//*****************************************************************************
// Implementation of TFrmMntVATCodeCA
//*****************************************************************************
//Regression Fix R2012.1 (Chayanika):: Start
procedure TFrmMntVATCodeCA.FormActivate(Sender: TObject);
begin  // of TFrmMntVATCodeCA.FormActivate
  inherited;
    application.Title := CtTxtTitle;        
end;   // of TFrmMntVATCodeCA.FormActivate
//Regression Fix R2012.1 (Chayanika):: End
//=============================================================================
procedure TFrmMntVATCodeCA.SvcTskDetVATCodeCreateExecutor(Sender: TObject;
  var NewObject: TObject; var FlgCreated: Boolean);
begin
  inherited;
  NewObject := TFrmDetVATCodeCA.Create (Self);
  FlgCreated := True;
  TSvcFormTask(Sender).DynamicExecutor := False;
end;

//=============================================================================

initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
