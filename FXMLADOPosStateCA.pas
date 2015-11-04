//=========== Sycron Computers Belgium (c) 2003 ===============================
// Packet : FlexPoint
// Unit   : FXMLADOPosStateCA : XML POSSTATECA = processes XML-string to DB for
//                                            POSState Castorama
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosStateCA.pas,v 1.1 2006/12/22 13:41:51 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOPosStateCA - CVS revision 1.5
//=============================================================================

unit FXMLADOPosStateCA;

//*****************************************************************************

interface

uses
  FXMLADOPosState, ADODB;

//*****************************************************************************
// TXMLADOPosStateCA
//*****************************************************************************

type
  TXMLADOPosStateCA = class (TXMLADOPosState)
  protected
    procedure ChangeState (IdtOperator : string;
                           IdtCheckout : Integer;
                           FlgLogOn    : Boolean); override;
  public
  end;  // of TXMLADOPosStateCA

var
  XMLADOPosStateCA: TXMLADOPosStateCA;

implementation

uses
  SfDialog,
  DFpnADOUtilsCA,
  SysUtils,
  mlogging;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOPosStateCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FXMLADOPosStateCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.1 $';
  CtTxtSrcDate    = '$Date: 2006/12/22 13:41:51 $';

//*****************************************************************************

//=============================================================================
// TXMLADOPosState.ChangeState :  Changes the state of an operator
//                                  -----
// INPUT  : IdtOperator = operator to logoff/logon
//          IdtCheckout = Checkout to applied to
//          FlgLogOn = Flag if a logon is occuring or not
//=============================================================================

procedure TXMLADOPosStateCA.ChangeState (IdtOperator : string;
                                         IdtCheckout : Integer;
                                         FlgLogOn    : Boolean);
var
  SavLockType      : TADOLockType;     // original locktype of ADOQuery                                         
begin  // of TXMLADOPosStateCA.ChangeState
  inherited;
  with DmdFpnADOUtilsCA.ADOQryInfo do begin
    SQL.Text := 'UPDATE Operator ';
    if FlgLogOn then
      SQL.Add ('SET IdtCheckout = ' + IntToStr (IdtCheckout))
    else
      SQL.Add ('SET IdtCheckout = NULL');
    SQL.Add ('WHERE IdtPos = ' + AnsiQuotedStr (IdtOperator, ''''));
    SavLockType := LockType;
    LockType := ltOptimistic;
    ExecSQL;
    LockType := SavLockType;
  end;
end;   // of TXMLADOPosStateCA.ChangeState

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
