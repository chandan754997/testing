//=Copyright 2007 (c) Centric Retail Solutions NV -  All rights reserved.======
// Packet   : FlexPoint
// Customer : Castorama
// Unit     : FDetCAPOSTransSelect.PAS : Form DETail CAstorama POS Transaction
//            selection.  Allows a user to select a single POS transaction from
//            a list.
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FDetCAPOSTransSelect.pas,v 1.1 2007/04/10 12:37:59 JurgenBT Exp $
//=============================================================================

unit FDetCAPOSTransSelect;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfCommon, DB, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

//*****************************************************************************
// Global definitions
//*****************************************************************************

type
  TFrmDetCAPOSTransSelect = class(TFrmCommon)
    PnlBottom: TPanel;
    PnlBottomRight: TPanel;
    BtnOK: TBitBtn;
    BtnCancel: TBitBtn;
    PnlBtnAdd: TPanel;
    PnlInfo: TPanel;
    PnlBody: TPanel;
    DBGrdTicket: TDBGrid;
    DscPOSTrans: TDataSource;
    procedure DBGrdTicketDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDetCAPOSTransSelect: TFrmDetCAPOSTransSelect;

//*****************************************************************************

implementation

uses sfdialog;

{$R *.dfm}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FDetCAPOSTransSelect';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: ';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2007/04/10 12:37:59 $';

//*****************************************************************************
// Implementation of FDetCAPOSTransSelect
//*****************************************************************************

//=============================================================================
// TFrmDetCAPOSTransSelect.DBGrdTicketDblClick: 
//=============================================================================

procedure TFrmDetCAPOSTransSelect.DBGrdTicketDblClick(Sender: TObject);
begin  // of TFrmDetCAPOSTransSelect.DBGrdTicketDblClick
  inherited;

  BtnOK.Click;
end;   // of TFrmDetCAPOSTransSelect.DBGrdTicketDblClick

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                               CtTxtSrcDate);
end.   // of FDetCAPOSTransSelect

