//=Copyright 1998-2006 (c) Real Software NV - Retail Division. All rights reserved.=
// Packet : FlexPoint Development
// Customer: Castorama
// Unit   : FChlVSArticleCA.PAS : MainForm CHoice List VSview ARTICLE
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChlVSArticleCA.pas,v 1.1 2006/12/20 14:34:56 JurgenBT Exp $
// - Started from Castorama - FlexPoint 2.0 - PROJECTNAME - CVS revision 1.2
// Version    Modified by                Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1
//=============================================================================

unit FChlVSArticleCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FChlVSArticle, Db, DBTables, ScTskMgr_BDE_DBC;

//=============================================================================

resourcestring
CtTxtTitle = 'Choice list Article';     //Regression Fix R2012.1 (Chayanika)

//=============================================================================
type
  TFrmChlArticleCA = class(TFrmChlArticle)
  procedure FormActivate(Sender: TObject);       //Regression Fix R2012.1 (Chayanika)
  private
    { Private declarations }
  public
    { Public declarations }
  end;   // of TFrmChlArticleCA

var
  FrmChlArticleCA: TFrmChlArticleCA;

//*****************************************************************************

implementation

{$R *.DFM}

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChlVSArticleCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChlVSArticleCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/20 14:34:56 $';

//=============================================================================

//Regression Fix R2012.1 (Chayanika)  ::start
procedure TFrmChlArticleCA.FormActivate(Sender: TObject);
begin
  inherited;
Application.Title:= CtTxtTitle;
end;
//Regression Fix R2012.1 (Chayanika)  :: end
//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);

end.
