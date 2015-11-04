//= Copyright 2009 (c) Centric Retail Solutions. All rights reserved ==========
// Packet : FlexPoint
// Unit   : FXMLADOGeneral : XML General = processes XML-string to DB for
//                           general use
// Customer : Castorama
//-----------------------------------------------------------------------------
// CVS    : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOGeneral.pas,v 1.3 2009/09/21 16:00:44 BEL\KDeconyn Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FXMLADOGeneral - CVS revision 1.4
//=============================================================================

unit FXMLADOGeneral;

//*****************************************************************************

interface

uses
  Classes, ComObj, DB, DBTables, ADODB, SysUtils, MSXML_TLB, MFpnDBUtil_ADO,
  SmUtils, DMADODummy, DFpnADOCA, Dialogs, Windows;

//=============================================================================
// Constants
//=============================================================================

const // Kind of record processing
  CtCodActKindInsert = 1;
  CtCodActKindUpdate = CtCodActKindInsert + 1;
  CtCodActKindDelete = CtCodActKindupdate + 1;
  CtCodActKindUpdateOrInsert = CtCodActKindDelete + 1;

const // Maximum of action kind
  CtCodActKindMAX    = CtCodActKindUpdateOrInsert;

//=============================================================================
// Initialized variables
//=============================================================================

var // Date & Time formats
  ViTxtISODateFormat : string = 'YYYY-MM-DD';
  ViTxtISOTimeFormat : string = 'HH:MM:SS';

//*****************************************************************************
// TXMLADOGeneral
//*****************************************************************************

type
  TXMLADOGeneral = class (TObject)
  protected
    ObjXMLDoc           : IXMLDOMDocument;
    StrLstFieldType     : TStringList; // List with known fieldtypes
    StrLstKeys          : TStringList; // Listh with keys of table
    QryFieldInfo        : TADOQuery;   // Query to retrieve the field info
    TxtTableNameSav     : string;      // Last table name used for field info
    procedure ProcessGeneral (NdeXML     : IXMLDOMNode;
                              CodActKind : Integer); virtual;
    procedure ProcessGeneralFld (NdeXMLFld    : IXMLDOMNode;
                                 StrLstFields : TStringList;
                                 TxtTableName : string); virtual;
    procedure AddFieldToList (NdeXMLFld    : IXMLDOMNode;
                              StrLstFields : TStringList;
                              TxtTableName : string;
                              FieldValue   : string); overload; virtual;
    procedure AddFieldToList (FieldName    : string;
                              StrLstFields : TStringList;
                              TxtTableName : string;
                              FieldValue   : string); overload; virtual;
    function GetFieldType (TxtTableName   : string;
                           TxtFieldName   : string): TFieldType; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure ProcessXML (TxtXML: string); virtual;
    function GetCodeAction (XMLNode : IXMLDOMNode): Integer; virtual;
  end;  // of TXMLADOGeneral

var
  XMLADOGeneral: TXMLADOGeneral;

//*****************************************************************************

implementation

uses
  SfDialog;

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FXMLADOGeneral';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FXMLADOGeneral.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.3 $';
  CtTxtSrcDate    = '$Date: 2009/09/21 16:00:44 $';

//*****************************************************************************
// Implementation of TXMLADOGeneral
//*****************************************************************************

//=============================================================================
// TXMLADOGeneral.Create : Constructor of TXMLADOGeneral object
//=============================================================================

constructor TXMLADOGeneral.Create;
begin  // of TXMLADOGeneral.Create
  inherited Create;
  StrLstFieldType := TStringList.Create;
  StrLstFieldType.Sorted := True;
  StrLstKeys      := TStringList.Create;
  ObjXMLDoc := CreateComObject(CLASS_DOMDocument) as IXMLDOMDocument;
  QryFieldInfo := TADOQuery.Create (nil);
  QryFieldInfo.Connection := DmdFpnADOCA.ADOConFlexpoint;
  QryFieldInfo.CursorLocation := clUseClient;
  QryFieldInfo.CursorType := ctKeyset;
  QryFieldInfo.LockType := ltReadOnly;
  QryFieldInfo.MarshalOptions := moMarshalModifiedOnly;
  TADODataSet(QryFieldInfo).CommandTimeout := 1200;
end;  // of TXMLADOGeneral.Create

//=============================================================================
// TXMLADOGeneral.Destroy : Destructor of TXMLADOGeneral object
//=============================================================================

destructor TXMLADOGeneral.Destroy;
begin // of TXMLADOGeneral.Destroy
  inherited;
  ObjXMLDoc := nil;
  if Assigned (StrLstFieldType) then
    StrLstFieldType.Free;
  if Assigned (StrLstKeys) then
    StrLstKeys.Free;
  if Assigned (QryFieldInfo) then
    QryFieldInfo.Free;
end;  // of TXMLADOGeneral.Destroy

//=============================================================================
// TXMLADOGeneral.ProcessGeneral : Processes the record that is included in the
// IXMLDOMNode
//                                  -----
// INPUT  : NdeXML = The node that contains the XML statement with the record
//=============================================================================

procedure TXMLADOGeneral.ProcessGeneral (NdeXML     : IXMLDOMNode;
                                         CodActKind : Integer);
var
  CntItem         : Integer;          // Index for loop
  StrLstFields    : TStringList;      // List with names and values of fields
  TxtTableName   : string;           // Name of the table
begin // of TXMLADOGeneral.ProcessGeneral
  StrLstFields := TStringList.Create;
  try
    TxtTableName := NdeXML.nodeName;
    for CntItem := 0 to Pred (NdeXML.ChildNodes.Length) do
      ProcessGeneralFld (NdeXML.ChildNodes[CntItem], StrLstFields,
                             TxtTableName);
    if CodActKind = CtCodActKindInsert then
      DmdADODummy.InsertGlobal (StrLstFields, TxtTableName)
    else
      raise EInvalidOperation.Create ('Invalid Action');
  finally
    StrLstFields.Free;
  end;
end;  // of TXMLADOGeneral.ProcessGeneral

//=============================================================================
// TXMLADOGeneral.ProcessGeneralFld : Processes one field of a table
//                                  -----
// INPUT  : NdeXMLFld = XML node with the properties of the field
//          StrLstFields = The stringlist to which the name and the
//                         value of the field that has to be added
//          TxtTableName = Tablename of the field
//=============================================================================

procedure TXMLADOGeneral.ProcessGeneralFld (NdeXMLFld    : IXMLDOMNode;
                                            StrLstFields : TStringList;
                                            TxtTableName : string);
begin // of TXMLADOGeneral.ProcessGeneralFld
  AddFieldToList (NdeXMLFld, StrLstFields, TxtTableName, NdeXMLFld.Text);
end;  // of TXMLADOGeneral.ProcessGeneralFld

//=============================================================================
// TXMLADOGeneral.AddFieldToList : Adds the field to a stringlist
//                                  -----
// INPUT  : NdeXML       = XML Node with field properties
//          StrLstfields = Stringlist to which the field has to be added
//          TxtTableName = Tablename of the field
//          FieldValue   = The value of the field.  Is given seperataly so that
//                         another value can be passed then the value in the
//                         XML node.
//=============================================================================

procedure TXMLADOGeneral.AddFieldToList (NdeXMLFld     : IXMLDOMNode;
                                         StrLstFields  : TStringList;
                                         TxtTableName  : string;
                                         FieldValue    : string);
var
  FldType          : TFieldType;       // Type of the field to add
  TxtFieldName     : string;           // Name of the field to add
  TxtFieldValue    : string;           // Value of the field to add
  TxtDate          : string;           // Date part of a date-time value
  TxtTime          : string;           // Time part of a date-time value
begin // of TXMLADOGeneral.AddFieldToList
  FldType := GetFieldType (TxtTableName, NdeXMLFld.nodeName);
  if FldType <> ftUnknown then begin
    TxtFieldName := NdeXMLFld.nodeName;
    case Fldtype of
      ftString, ftMemo, ftFixedChar:
          TxtFieldValue :=  AnsiQuotedStr(FieldValue, '''');
      ftSmallInt: begin
        if AnsiCompareText (FieldValue, 'True') = 0 then
          TxtFieldValue := '1'
        else if AnsiCompareText (FieldValue, 'False') = 0 then
          TxtFieldValue := '0'
        else
          TxtFieldValue := FieldValue;
      end;
      ftDateTime: begin
        SplitString (FieldValue, ' ', TxtDate, TxtTime);
        if TxtDate > '' then
          TxtDate := ReformatTxtStDate (TxtDate, ViTxtISODateFormat,
                                        ViTxtDBDatFormat);
        if TxtTime > '' then
          TxtTime := ReformatTxtStTime (TxtTime, ViTxtISOTimeFormat,
                                        ViTxtDBHouFormat);
        TxtFieldValue := AnsiQuotedStr (Trim (TxtDate + ' ' + TxtTime), '''');
      end;
      else
        TxtFieldValue := FieldValue;
    end;
    if TxtFieldValue <> '' then
      StrLstFields.Add (TxtFieldName + '=' + TxtFieldValue);
  end;
end;  // of TXMLADOGeneral.AddFieldToList

//=============================================================================
// TXMLADOGeneral.GetFieldType : Returns the type of given field in the given table
//                                  -----
// INPUT  : TxtTableName = The table that contains the field
//          TxtFieldName = The Fieldname of the field
//=============================================================================

function TXMLADOGeneral.GetFieldType (TxtTableName   : string;
                                      TxtFieldName   : string): TFieldType;
var
  NumIndex         : Integer;          // Index of item in StrLstFieldType
  CntIndex         : Integer;          // Counter of index
begin // of TXMLADOGeneral.GetFieldType
  NumIndex := StrLstFieldType.IndexOf(Format ('%s.%s', [TxtTableName,
                                                        TxtFieldName]));
  if NumIndex <> -1 then
    Result := TFieldType (StrLstFieldType.Objects[NumIndex])
  else begin
    Result := ftUnknown;
    if TxtTableName <> TxtTableNameSav then begin
      TxtTableNameSav := TxtTableName;
      QryFieldInfo.SQL.Text := 'Select TOP 1 * From ' + TxtTableName + ' (NOLOCK)';
      // Open Query
      QryFieldInfo.Open;
//    QryFieldInfo.FieldDefs.Update;
    end;
    for CntIndex := 0 to Pred (QryFieldInfo.FieldDefs.Count) do begin
      StrLstFieldType.AddObject (
          Format ('%s.%s',[TxtTableName,QryFieldInfo.FieldDefs[CntIndex].Name]),
          TObject(QryFieldInfo.FieldDefs[CntIndex].DataType));
      if AnsiCompareText (QryFieldInfo.FieldDefs[CntIndex].Name,
                      TxtFieldName) = 0 then
        Result := QryFieldInfo.FieldDefs[CntIndex].DataType;
    end;
    if Result = ftUnknown then
      StrLstFieldType.AddObject (
        Format ('%s.%s',[TxtTableName,TxtFieldName]),TObject(ftUnknown));
    // Close query
    if QryFieldInfo.Active then
      QryFieldInfo.Close;
  end;
end;  // of TXMLADOGeneral.GetFieldType

//=============================================================================
// TXMLADOGeneral.ProcessXML : Process the XML that is given as a string
//                                  -----
// INPUT  : TxtXML = Contains the XML string to proces
//=============================================================================

procedure TXMLADOGeneral.ProcessXML (TxtXML: string);
begin // of TXMLADOGeneral.ProcessXML
  ObjXMLDoc.loadXML (TxtXML);
  if ObjXMLDoc.childNodes.Length = 0 then
    raise EInvalidOperation.Create ('Invalid XML statement');
  ProcessGeneral (ObjXMLDoc.firstChild, GetCodeAction (ObjXMLDoc.firstChild));
end;  // of TXMLADOGeneral.ProcessXML

//=============================================================================
// TXMLADOGeneral.GetCodeAction : Extracts the action code description from the
// XMLNode and returns the constant that represents the action
//                                  -----
// INPUT  : XMLNode = Node of which the action code has to be extracted from
//                                  -----
// FUNCRES : Action code
//=============================================================================

function TXMLADOGeneral.GetCodeAction (XMLNode : IXMLDOMNode): Integer;
var
  TxtAction        : string;          // Action to do on table
begin // of TXMLADOGeneral.GetCodeAction
  Result := 0;
  if XMLNode.attributes.getNamedItem ('Action') <> nil then begin
    TxtAction := XMLNode.attributes.getNamedItem ('Action').Text;
    if TxtAction = 'I' then
      Result := CtCodActKindInsert
    else if TxtAction = 'D' then
      Result := CtCodActKindDelete
    else if TxtAction = 'U' then
      Result := CtCodActKindUpdate
    else if TxtAction = 'UI' then
      Result := CtCodActKindUpdateOrInsert
  end;
end;  // of TXMLADOGeneral.GetCodeAction

//=============================================================================

procedure TXMLADOGeneral.AddFieldToList(FieldName: string;
  StrLstFields: TStringList; TxtTableName, FieldValue: string);
var
  FldType          : TFieldType;       // Type of the field to add
  TxtFieldName     : string;           // Name of the field to add
  TxtFieldValue    : string;           // Value of the field to add
  TxtDate          : string;           // Date part of a date-time value
  TxtTime          : string;           // Time part of a date-time value
begin // of TXMLADOGeneral.AddFieldToList
  FldType := GetFieldType (TxtTableName, FieldName);
  if FldType <> ftUnknown then begin
    TxtFieldName := FieldName;
    case Fldtype of
      ftString, ftMemo, ftFixedChar:
          TxtFieldValue :=  AnsiQuotedStr(FieldValue, '''');
      ftSmallInt: begin
        if AnsiCompareText (FieldValue, 'True') = 0 then
          TxtFieldValue := '1'
        else if AnsiCompareText (FieldValue, 'False') = 0 then
          TxtFieldValue := '0'
        else
          TxtFieldValue := FieldValue;
      end;
      ftDateTime: begin
        SplitString (FieldValue, ' ', TxtDate, TxtTime);
        if TxtDate > '' then
          TxtDate := ReformatTxtStDate (TxtDate, ViTxtISODateFormat,
                                        ViTxtDBDatFormat);
        if TxtTime > '' then
          TxtTime := ReformatTxtStTime (TxtTime, ViTxtISOTimeFormat,
                                        ViTxtDBHouFormat);
        TxtFieldValue := AnsiQuotedStr (Trim (TxtDate + ' ' + TxtTime), '''');
      end;
      else
        TxtFieldValue := FieldValue;
    end;
    if TxtFieldValue <> '' then
      StrLstFields.Add (TxtFieldName + '=' + TxtFieldValue);
  end;
end;

//=============================================================================

initialization
  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.  // of FXMLADOGeneral
