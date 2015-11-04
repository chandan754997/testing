//=========== Copyright 2011 (c) Kingfisher IT Services. All rights reserved. ==============
// Packet   : FlexPoint Development
// Customer:  Castorama
// Unit     : FLstMunicipality.PAS
//--------------------------------------------------------------------------------------------------------------------------------------
// PVCS   :  $Header: /development/castorama/Flexpoint/Src/Flexpoint201/Develop/FLstMunicipality.pas,v 1.0 2011/07/25 17:04:21 $
// History:
// Version                              Modified By                          Reason
// V 1.0                               AM (TCS)                          R2011.2 - BDES - Creation Of Client Management of Post Code
// V1.1                                AM (TCS)                          Internal defect fix
// V1.2                                AM (TCS)                          Defect fix(346)
//=============================================================================

unit FLstMunicipality;

//*****************************************************************************

interface

uses
  {Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfList_BDE_DBC, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids,DBTables,SrStnCom, FMTBcd, SqlExpr;}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls, DB, DBTables, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, SfList_BDE_DBC,sflistoptions_BDE_DBC ;

//*****************************************************************************
// Class definitions
//*****************************************************************************
type
  TFrmListMunicipality = class(TFrmList)
    Panel1: TPanel;
    Label1: TLabel;
    SvcMELimitCtry: TComboBox;
    DscGetCountry: TDataSource;
    procedure MniSeqRefreshClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

 private
   //DefalutVal : String;
   DefalutSym : String;
    { Private declarations }
    procedure DoTheRefresh; override;
  public
    { Public declarations }

  end;
  
var
  FrmListMunicipalityCA: TFrmListMunicipality;


//*****************************************************************************

implementation

uses
  FMntCustomerCA,
  FDetCustomerCA,
  DFpnMunicipalityCA;

{$R *.dfm}

//=============================================================================
// Source-identifiers - declared in interface to allow adding them to
// version-stringlist from the preview form.
//=============================================================================

const  // Module-name
  CtTxtModuleName = 'FLstMunicipality';

const  // PVCS-keywords
  CtTxtSrcName    = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FLstMunicipality.pas,v $';
  CtTxtSrcVersion = '$Revision: 1.2 $';
  CtTxtSrcDate    = '$Date: 2012/02/17 17:04:21 $';


//*****************************************************************************
// Implementation of TFrmListMunicipality
//*****************************************************************************
procedure TFrmListMunicipality.DoTheRefresh;
begin
  If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
   if Assigned (MniSeqRefresh.OnClick) then
    MniSeqRefresh.OnClick (Self)
   else
    MniSeqRefreshClick (Self);
  end;
end;
//=============================================================================
procedure TFrmListMunicipality.FormActivate(Sender: TObject);
 var CtryName,CtrySym,LCtrySym: String;
    ChkDupCtry : TStringList;
    RecCntr,TargetPosi : Integer;
    IdCountry : Integer; //Defect fix-346 (AM)

 procedure ExecuteQuery(Qry : string);
  begin  // of TFrmDetCustomerCA.AdjustLookupCountry
    If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
     try
      if DmdFpnMunicipalityCA.QryGetCountry.Active then
        DmdFpnMunicipalityCA.QryGetCountry.Active := false;
      DmdFpnMunicipalityCA.QryGetCountry.Close;
      DmdFpnMunicipalityCA.QryGetCountry.SQL.Clear;
      DmdFpnMunicipalityCA.QryGetCountry.SQL.Add(Qry);
      DmdFpnMunicipalityCA.QryGetCountry.Open;
     except
     end;
    end;
   end;
begin
 If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
  RecCntr :=1;
  TargetPosi :=0;
  DefalutSym :='';
  try

    ChkDupCtry := TStringList.Create;
    try
      ExecuteQuery('SELECT * FROM COUNTRY');
      SvcMELimitCtry.Items.Clear;
      SvcMELimitCtry.Items.add(' ');
      while not DmdFpnMunicipalityCA.QryGetCountry.eof do begin
          CtryName :='';
          CtrySym :='';
          LCtrySym :='';
          CtryName := DmdFpnMunicipalityCA.QryGetCountry.FieldByName('TxtName').AsString;
          CtrySym  := DmdFpnMunicipalityCA.QryGetCountry.FieldByName('TxtCodCountry').AsString;
          LCtrySym :=CtrySym;
          IdCountry := DmdFpnMunicipalityCA.QryGetCountry.FieldByName('IdtCountry').AsInteger;    //Defect fix-346 (AM)
          if (ChkDupCtry.IndexOf(UpperCase(CtrySym+ ' ' + CtryName))=-1) then
          begin
            if (Length(Trim(LCtrySym))=1) then begin
               if UpperCase(Trim(LCtrySym))='I' then
                 LCtrySym := LCtrySym + '          ' + '|  '
               else
                 LCtrySym := LCtrySym + '        ' + '|  '
            end
            else if (Length(Trim(LCtrySym))=2) then
              LCtrySym := LCtrySym + '      ' + '|  '
            else
              LCtrySym := LCtrySym +'     ' + '|  ';

            {if ((UpperCase(CtryName) ='ESPAGNE') OR (UpperCase(CtryName)='ESPAGNA') OR
            (UpperCase(CtryName)='ESPANA') OR (UpperCase(CtryName)='ESPANA'))}
            if IdCountry = 7 then begin     //Defect fix-346 (AM)
                TargetPosi :=RecCntr;
                DefalutSym := Trim(CtrySym);
            end;
             //Get Entry in Country ComboBox
            SvcMELimitCtry.Items.add(LCtrySym+ ' ' + CtryName);

            //Check to ignore duplicate Entry
            ChkDupCtry.Add(UpperCase(CtrySym+ ' ' + CtryName));
          end;
          RecCntr := RecCntr +1;
          DmdFpnMunicipalityCA.QryGetCountry.Next;
      end;
      SvcMELimitCtry.ItemIndex := TargetPosi;
    except
       {  }
    end;
  finally
    ChkDupCtry.Free;
  end;
  inherited;
 end;
end;
//=============================================================================
procedure TFrmListMunicipality.MniSeqRefreshClick(Sender: TObject);
var
  TargetStr,Str : string;
  Cnt,BarPosi : Integer;
begin
 If  FMntCustomerCA.FrmMntCustomerCA.FlgMandatory = True then begin
  try
    Str := Trim(SvcMELimitCtry.Text);
    BarPosi := Pos('|',Str);
    TargetStr := Trim(Copy(Str,1,BarPosi-2));

    if DscList.DataSet is TStoredProc then
      if (DefaultCtryFlag) then begin
        TStoredProc(DscList.DataSet).ParamByName('@PrmTxtCodCountry').Text := DefalutSym;
        DefaultCtryFlag := False;
      end
      else
        TStoredProc(DscList.DataSet).ParamByName('@PrmTxtCodCountry').Text := Trim(TargetStr);
  except

  end;
   inherited;
 end;
end;
end.
//*****************************************************************************
initialization
  // Add module to list for version control
  AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName, CtTxtSrcVersion,
                      CtTxtSrcDate);
end.    // of FLstMunicipality


