//=========== Sycron Computers Belgium (c) 2002 ===============================
// Packet : FlexPoint
// Unit   : FXMLADOPOSState : XML POSSTATE = processes XML-string to DB for
//                                        POSState
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosState.pas,v 1.1 2006/12/22 13:41:51 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOPosState - CVS revision 1.2
//=============================================================================

unit FXMLADOPosState;

//*****************************************************************************

interface

uses
  FXMLADOGeneral, ADODB,
  MSXML_TLB;

//*****************************************************************************
// TXMLADOPosState
//*****************************************************************************

type
  TXMLADOPosState = class (TXMLADOGeneral)
  protected
    procedure ChangeState (IdtOperator : string;
                           IdtCheckout : Integer;
                           FlgLogOn    : Boolean); virtual;
   procedure ProcessGeneral (NdeXML     : IXMLDOMNode;
                             CodActKind : Integer); override;
  public
  end;  // of TXMLADOPosState

var
  XMLADOPosState: TXMLADOPosState;

implementation

uses
  SfDialog,
  DFpnADOPosTransaction,
  DFpnADOUtilsCA,
  SysUtils;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOPOSState';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOPosState.pas,v $';
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

procedure TXMLADOPosState.ChangeState (IdtOperator : string;
                                       IdtCheckout : Integer;
                                       FlgLogOn    : Boolean);
begin  // of TXMLADOPosState.ChangeState
  DmdFpnADOUtilsCA.ADOQryInfo.SQL.Text := 'UPDATE Workstat ';
  if FlgLogOn then
    DmdFpnADOUtilsCA.ADOQryInfo.SQL.Add ('SET IdtOperator = ' +
                                           AnsiQuotedStr (IdtOperator, ''''))
  else
    DmdFpnADOUtilsCA.ADOQryInfo.SQL.Add ('SET IdtOperator = NULL');
  DmdFpnADOUtilsCA.ADOQryInfo.SQL.Add ('WHERE IdtCheckout = ' +
                               IntToStr (IdtCheckout));
  DmdFpnADOUtilsCA.ADOQryInfo.LockType := ltOptimistic;
  DmdFpnADOUtilsCA.ADOQryInfo.ExecSQL;
  DmdFpnADOUtilsCA.ADOQryInfo.LockType := ltReadOnly;
end;   // of TXMLADOPosState.ChangeState

//=============================================================================

procedure TXMLADOPosState.ProcessGeneral (NdeXML     : IXMLDOMNode;
                                       CodActKind : Integer);
begin  // of TXMLADOPosState.ProcessGeneral
  case NdeXML.selectSingleNode ('CodState').nodeTypedValue of
    CtCodPtsReady:
      ChangeState (NdeXML.SelectSingleNode ('IdtOperator').nodeTypedValue,
                   NdeXML.SelectSingleNode ('IdtCheckout').nodeTypedValue,
                   True);
    CtCodPtsLogoff:
      ChangeState (NdeXML.SelectSingleNode ('IdtOperator').nodeTypedValue,
                   NdeXML.SelectSingleNode ('IdtCheckout').nodeTypedValue,
                   False);
  end;
  inherited;
end;   // of TXMLADOPosState.ProcessGeneral

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
