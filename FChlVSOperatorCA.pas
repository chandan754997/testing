//================ Sycron Computers Belgium (c) 1998 ==========================
// Packet : FlexPoint Development
// Unit   : FChlVSOperatorCA.PAS : MainForm Choice List VSview Operator for
//          Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChlVSOperatorCA.pas,v 1.1 2006/12/21 13:30:06 hofmansb Exp $
// History:
// - Started from Flexpoint 1.6 - revision 1.2
// Version    Modified by              Reason
// 1.1        Chayanika(TCS)     Regression Fix R2012.1 (Chayanika)
//=============================================================================

unit FChlVSOperatorCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, ExtCtrls, FFpnVSChl, FChlVSOperator, ScTskMgr_BDE_DBC;

//=============================================================================
resourcestring
 CtTxtTitle = 'Choice list Operator';             //Regression Fix R2012.1 (Chayanika)

//=============================================================================
type
  TFrmChlOperatorCA = class(TFrmChlOperator)
    procedure FormActivate(Sender: TObject);      //Regression Fix R2012.1 (Chayanika)
    procedure SvcTskChlOperatorGetRptValueCodSecurity(Sender: TObject;
      RptFld: TRptFldItem; var TxtFieldValue: String);
  private
    { Private declarations }
  protected
    procedure AssignEventsToRptFields; override;
  public
    { Public declarations }
  end;

var
  FrmChlOperatorCA: TFrmChlOperatorCA;

implementation

{$R *.DFM}

uses
  SfDialog,

  DFpnUtils,
  DFpnOperator;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FChlVSOperatorCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FChlVSOperatorCA.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/21 13:30:06 $';

//*****************************************************************************
// Implementation of TFrmChlOperator
//*****************************************************************************

procedure TFrmChlOperatorCA.AssignEventsToRptFields;
begin  // of TFrmChlOperatorCA.AssignEventsToRptFields
  with SvcTskChlOperator do begin
    AssignEventOnGetRptValue ('CodSecurity',
                              SvcTskChlOperatorGetRptValueCodSecurity);
    AssignEventOnGetRptValue ('FlgTenderCount', SvcTskRptGetRptValueYesNo);
  end;
end;   // of TFrmChlOperatorCA.AssignEventsToRptFields

//=============================================================================

procedure TFrmChlOperatorCA.SvcTskChlOperatorGetRptValueCodSecurity(
  Sender: TObject; RptFld: TRptFldItem; var TxtFieldValue: String);
begin  // of TFrmChlOperatorCA.SvcTskChlOperatorGetRptValueCodSecurity
  DmdFpnOperator.SprLkpCodSecurity.Active := True;
  if DmdFpnOperator.SprLkpCodSecurity.Locate ('TxtFldCode',
                                              TxtFieldValue, []) then
    TxtFieldValue :=
      DmdFpnOperator.SprLkpCodSecurity.FieldByName('TxtChcLong').AsString;
end;   // of TFrmChlOperatorCA.SvcTskChlOperatorGetRptValueCodSecurity

//=============================================================================
//Regression Fix R2012.1 (Chayanika) ::start
procedure TFrmChlOperatorCA.FormActivate(Sender: TObject);
begin
  inherited;
Application.Title:= CtTxtTitle;
end;
//Regression Fix R2012.1 (Chayanika) ::end

//=============================================================================
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.   // of FChlVSOperatorCA

