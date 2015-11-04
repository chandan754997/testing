//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint for castorama
// Unit   : FXMLADODocumentBOCA = processes XML-string
//          to DB for DOCUMENTS BO for CAstorama (ADO)
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADODocumentBOCA.pas,v 1.4 2009/09/21 16:00:44 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADODocumentBOCA - CVS revision 1.8
//=============================================================================

unit FXMLADODocumentBOCA;

interface

//*****************************************************************************

uses
  Classes, FXMLADOGeneral, MSXML_TLB, DMADODummyCA, Windows;

//*****************************************************************************
// TXMLADODocumentBOCA
//*****************************************************************************

type
  TXMLADODocumentBOCA = class (TXMLADOGeneral)
  protected
    FFlgNoNocBO : Boolean;
    //NOC_BO_VENTE
    procedure ProcessDocumentBO (NdeDocBO   : IXMLDOMNode;
                                 CodActKind : Integer ); virtual;
    procedure ProcessDocumentBOFld (NdeXMLFld    : IXMLDOMNode;
                                    StrLstFields : TStringList); virtual;
    procedure ProcessDetailTablesFromXML (NdeXML     : IXMLDOMNode;
                                          CodActKind : Integer ); virtual;
    //NOC_BO_VENTE_LIGNE
    procedure ProcessDocBOLigne (NdeDocBOLigne : IXMLDOMNode;
                                 CodActKind    : Integer ); virtual;
    procedure ProcessDocBOLigneFld (NdeXMLFld    : IXMLDOMNode;
                                    StrLstFields : TStringList); virtual;
  public
    property FlgNoNocBO : Boolean read FFlgNoNocBO write FFlgNoNocBO;

    constructor Create; override;
    procedure ProcessXML (TxtXML: string); override;
  end;  // of TXMLADODocumentBOCA

var
  XMLADODocumentBOCA: TXMLADODocumentBOCA;

implementation

uses
  SysUtils,
  StStrW,
  SfDialog,
  DFpnADOUtilsCA,
  DFpnADOBODocumentCA,
  MLogging;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADODocumentBOCA';

const  // PVCS-keywords
  CtTxtSrcName    = '$Workfile:   FXMLADODocumentBOCA.pas  $';
  CtTxtSrcVersion = '$Revision: 1.4 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 16:00:44 $';

//*****************************************************************************
// Implementation of TXMLADODocumentBOCA
//*****************************************************************************

//=============================================================================
// TXMLADODocumentBOCA.ProcessDocumentBO : Processes the BO document that is
// included in the IXMLDOMNode
//                                  -----
// INPUT  : NdeDocBO = The node that contains the XML statement for a BO
//                     document
//          CodActKind = The kind of action
//=============================================================================

procedure TXMLADODocumentBOCA.ProcessDocumentBO (NdeDocBO   : IXMLDOMNode;
                                                 CodActKind : Integer );
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List with names and values of fields
  NumBODoc        : Comp;          // Document number
  CodType         : Byte;             // Type doc bo
begin  // of TXMLADODocumentBOCA.ProcessDocumentBO
  // process the Pos Transaction data to the Pos Transaction table
  StrLstFields := TStringList.Create;
  StrLstkeys.Clear;
  try
    for CntItem := 0 to Pred (NdeDocBO.childNodes.length) do
      ProcessDocumentBOFld (NdeDocBO.childNodes[CntItem], StrLstFields);
    StrLstKeys.Add ('ID_TRF=' + IntToStr (DmdFpnADOUtilsCA.
                                    GetNextCounter ('NOC_BO_VENTE', 'ID_TRF')));
    NumBODoc :=  StrToFloat(StrLstFields.Values ['CVENTE']);
    if not DmdFpnADOBODocumentCA.BODocExists (NumBODoc, CodType) then
      Exit;
    LogDebugMessage('after bodocexists');
    if CodActKind = CtCodActKindInsert then begin
      if not FlgNoNocBO then begin

        StrLstFields.AddStrings (StrLstKeys);
        LogDebugMessage('before insert');
        try
          DmdADODummyCA.InsertGlobal (StrLstFields, 'NOC_BO_VENTE');
        except
          on E: Exception do begin
            LogDebugMessage('in exception');
            E.Message := E.Message +
                         #10'on insert of record with key: ' +
                         #10' ID_TRF: ' +
                         StrLstFields.Values['ID_TRF'] +
                         #10' CVENTE: ' +
                         StrLstFields.Values['CVENTE'];
            LogDebugMessage(E.Message);
            raise;
          end;
        end;
        LogDebugMessage('after insert and after exception');
      end;

      if StrToInt (StrLstFields.Values['TYPE_VENTE']) in
                                                  [CtCodDocBV, CtCodDocLoc] then
        // Delete the document
        DmdFpnADOBODocumentCA.DeleteDocBO (StrToInt (StrLstFields.Values['CETAB']),
                                      StrToFloat (StrLstFields.Values['CVENTE']))
      else if StrToInt (StrLstFields.Values['TYPE_VENTE']) in
                                           [CtCodDocBC, CtCodDocSAV,
                                            CtCodDocZOR..CtCodDocCORES5] then begin
        // Change Document BO status (TSituation_C104)
        DmdFpnADOBODocumentCA.ChangeStatusDocBO (
                                      StrToFloat (StrLstFields.Values['CVENTE']),
                                      CtCodSitDocHandled);
        if (not FlgNoNocBO) and
           (StrToInt (StrLstFields.Values['TYPE_VENTE']) = CtCodDocBC) and
           (DmdFpnADOUtilsCA.FieldExists('NOC_BO_Vente', 'CTPV_TPV')) then
          DmdFpnADOBODocumentCA.ChangeNOC_BO_Vente (
                                 StrToFloat (StrLstFields.Values['CVENTE']),
                                 StrToInt (StrLstFields.Values['CHOTESSE_TPV']),
                                 StrToInt (StrLstFields.Values['CTPV_TPV']));
      end;
    end
    else
      raise EInvalidOperation.Create ('Invalid Action for table ' +
                                      AnsiQuotedStr ('NOC_BO_VENTE', ''''));

    if FlgNoNocBO then
      Exit;

    for CntItem := 0 to Pred (NdeDocBO.childNodes.length) do
      ProcessDetailTablesFromXML (NdeDocBO.ChildNodes[CntItem], CodActKind);
  finally
    StrLstFields.Free;
  end;
end;   // of TXMLADODocumentBOCA.ProcessDocumentBO

//=============================================================================
// TXMLADODocumentBOCA.ProcessDocumentBOFld : Processes one field of the
// NOC_BO_VENTE table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the value of
//                         the field that has to be added
//=============================================================================

procedure TXMLADODocumentBOCA.ProcessDocumentBOFld (NdeXMLFld    : IXMLDOMNode;
                                                 StrLstFields : TStringList);
begin  // of TXMLADODocumentBOCA.ProcessDocumentBOFld
  AddFieldToList (NdeXMLFld, StrLstFields, 'NOC_BO_VENTE', NdeXMLFld.Text);
end;   // of TXMLADODocumentBOCA.ProcessDocumentBOFld

//=============================================================================
// TXMLADODocumentBOCA.ProcessDetailTablesFromXML : Extracts the detail tables of
//    a BO Document
//                                  -----
// INPUT  : NdeXML = XML Node that contains a postransaction
//          CodActKind = The kind of action
//=============================================================================

procedure TXMLADODocumentBOCA.ProcessDetailTablesFromXML (NdeXML     : IXMLDOMNode;
                                                       CodActKind : Integer);
begin  // of TXMLADODocumentBOCA.ProcessDetailTablesFromXML
  if AnsiCompareText (NdeXML.nodeName, 'NOC_BO_VENTE_LIGNE') = 0 then
    ProcessDocBOLigne (NdeXML, CodActKind);
end;   // of TXMLADODocumentBOCA.ProcessDetailTablesFromXML

//=============================================================================
// TXMLADODocumentBOCA.ProcessDocBOLigne : Processes a line of the BO document that
// is included in the IXMLDOMNode
//                                  -----
// INPUT  : NdeDocBOLigne = The node that contains the XML statement for a BO
//                          document line
//          CodActKind = The kind of action
//=============================================================================

procedure TXMLADODocumentBOCA.ProcessDocBOLigne (NdeDocBOLigne : IXMLDOMNode;
                                              CodActKind    : Integer);
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List for fields and values
begin  // of TXMLADODocumentBOCA.ProcessDocBOLigne
  StrLstFields := TStringList.Create;
  try
    for CntItem := 0 to Pred (NdeDocBOLigne.childNodes.length) do
      ProcessDocBOLigneFld (NdeDocBOLigne.childNodes[CntItem], StrLstFields);
    StrLstKeys.Clear;
    StrLstKeys.Add ('ID_TRF=' + IntToStr (DmdFpnADOUtilsCA.
                              GetNextCounter ('NOC_BO_VENTE_LIGNE', 'ID_TRF')));
    StrLstFields.AddStrings (StrLstKeys);
    case CodActKind of
      CtCodActKindInsert: begin
        try
          DmdADODummyCA.InsertGlobal (StrLstFields, 'NOC_BO_VENTE_LIGNE');
        except
          on E: Exception do begin
            E.Message := E.Message +
                         #10'on insert of record with key: ' +
                         #10' ID_TRF: ' +
                         StrLstFields.Values['ID_TRF'] +
                         #10' CVENTE: ' +
                         StrLstFields.Values['CVENTE'];
          raise;
        end;
        end;
      end
      else
        raise EInvalidOperation.Create ('Invalid Action for table ' +
                                         AnsiQuotedStr ('NOC_BO_VENTE_LIGNE', ''''));
    end;
  finally
    StrLstFields.Free;
  end;
end;   // of TXMLADODocumentBOCA.ProcessDocBOLigne

//=============================================================================
// TXMLADODocumentBOCA.ProcessDocBOLigneFld : Processes one field of the
// NOC_BO_VENTE_LIGNE table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the value of
//                         the field that has to be added
//=============================================================================

procedure TXMLADODocumentBOCA.ProcessDocBOLigneFld (NdeXMLFld    : IXMLDOMNode;
                                                 StrLstFields : TStringList);
begin  // of TXMLADODocumentBOCA.ProcessDocBOLigne
  AddFieldToList (NdeXMLFld, StrLstFields, 'NOC_BO_VENTE_LIGNE',
                  NdeXMLFld.Text);
end;   // of TXMLADODocumentBOCA.ProcessDocBOLigne

//=============================================================================

constructor TXMLADODocumentBOCA.Create;
begin  // of TXMLADODocumentBOCA.Create
  inherited;

  try
    DmdFpnADOUtilsCA.QueryInfo ('SELECT ValParam FROM ApplicParam' +
      #10'WHERE IdtApplicParam = ' + AnsiQuotedStr('SrvMQPosTransNoNOCBO', ''''));
    If DmdFpnADOUtilsCA.ADOQryInfo.FieldByName('ValParam').AsInteger = 1 then
      FlgNoNocBO := True
    else
      FlgNoNocBO := False;
  finally
    DmdFpnADOUtilsCA.ClearQryInfo;
    DmdFpnADOUtilsCA.CloseInfo;
  end;
end;   // of TXMLADODocumentBOCA.Create

//=============================================================================

procedure TXMLADODocumentBOCA.ProcessXML (TxtXML: string);
begin // of TXMLADODocumentBOCA.ProcessXML
  ObjXMLDoc.loadXML (TxtXML);
  if ObjXMLDoc.childNodes.Length = 0 then
    raise EInvalidOperation.Create ('Invalid XML statement');
  ProcessDocumentBO (ObjXMLDoc.firstChild, GetCodeAction (ObjXMLDoc.firstChild));
end;  // of TXMLADODocumentBOCA.ProcessXML

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FXMLADODocumentBOCA
