//========Copyright 2011 (c) Tata Consultancy Services. All rights reserved.====
// Packet   : FlexPoint
// Unit     : FLoginTenderCA = Form LOGIN in TENDER CAstorama
// Customer :  Castorama
//-----------------------------------------------------------------------------
// CVS     : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FTndCountMessage.pas,v 1.0 2011/09/14 19:10:59 TCS\SMB Exp $
// History :
// - Started from Castorama - Flexpoint 2.0 - FTndCountMessage - CVS revision 1.0
//=============================================================================
unit FTndCountMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFrmTndCountMessage = class(TForm)
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmTndCountMessage: TFrmTndCountMessage;

implementation

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FTndCountMessage';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FTndCountMessage.pas  $';
  CtTxtSrcVersion = '$Revision: 1.0 $';
  CtTxtSrcDate    = '$Date: 2011/09/14 19:10:59 $';

procedure TFrmTndCountMessage.FormShow(Sender: TObject);
begin
     ClientHeight := 75;
     ClientWidth := 900;
end;

end.
