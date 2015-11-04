//=========== Sycron Computers Belgium (c) 2001 ===============================
// Packet   : FlexPoint 2.0 Development
// Customer : Castorama
// Unit     : FCmmOrToFpn : Form CoMMunication ORacle replica tables TO FlexPoiNt
//-----------------------------------------------------------------------------
// PVCS   : $Header: /development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOCmmOrToFpnCa.pas,v 1.1 2006/12/20 08:16:40 smete Exp $
// History:
// - Started from Castorama - Flexpoint 2.0 - FADOCmmOrToFpnCA - CVS revision 1.7
// Version     Modified by     Reason
// 1.8         AS   (TCS)      R2013.2.Req35020.BDFR.Delete Invoice Address
//=============================================================================

unit FADOCmmOrToFpnCA;

//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SfAutoRun, StdCtrls, CheckLst, Menus, ImgList, ActnList, ExtCtrls,
  ScAppRun, ScEHdler, Buttons, ComCtrls, DBTables, ADODB, Variants;

//=============================================================================
// Global type definitions
//=============================================================================

const  // Codes for possible functionality (Arf = Application Run Function)
  CtCodArfNotSet           = 0;
  CtCodArfControleCashDesk = 1;
  CtCodArfLoadAll          = 2;
  CtCodArfLoadSel          = 3;

  CtCodArfHigh             = CtCodArfLoadSel;

const  // Runparameter /F for each possible function
  CiArrTxtFunc     : array [CtCodArfControleCashDesk..CtCodArfHigh] of string =
                     ('ControleCashDesk','LoadAll', 'LoadSel');

//=============================================================================
// type definition to store information of a replicated oracle table
//=============================================================================

type
  TImportItem = record
    TxtTableName   : string;           // the tablename eg PRS_FO_Structure
    TxtTitle       : string;           // title for table
    SprLoad        : TADOStoredProc;   // stored proc. to load the C-File
  end;

//*****************************************************************************
// Form-declaration.
//*****************************************************************************

type
  TFrmADOCmmOrToFpnCA = class(TFrmAutoRun)
    LstBxResult: TListBox;
    ChkLbxTable: TCheckListBox;
    TmrCheck: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TmrCheckTimer(Sender: TObject);
  private
    { Private declarations }
    FlgFillArrTable: Boolean;         // Flag indicating if the array is filled
    FlgLogStartMsg : Boolean;          // Flag indicating to log the 'started'-
                                       // message
    FlgLogEndMsg   : Boolean;          // Flag to log the 'end session'-message

    FDatControle   : TDateTime;        // Date Controle
    FlgInit        : Boolean;          // Inital load
    FFlgInvAddDel   : Boolean;         //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS

    FMsgRestart      : Cardinal;       // Registered windows message
    FlgRestart       : Boolean;        // Restart the application
    FMsgStop         : Cardinal;       // Registered windows message
    FlgStop          : Boolean;        // Stop the application after processing record
    FMsgStopWhenDone : Cardinal;       // Registered windows message
    FlgStopWhenDone  : Boolean;        // Stop the application after processing all records
  protected
    { Protected declarations }
    CodRunFunc     : Byte;             // Current function to run

    function GetAbortExecution : Boolean; virtual;

    procedure AutoStart (Sender : TObject); override;
    procedure AddItemToArray (var NumIndex : Word;
                                  TxtTable : string;
                                  TxtTitle : string;
                                  SprLoad  : TADOStoredProc); overload; virtual;
    procedure AddItemsToArrTable; virtual;
    procedure FillArrTable; virtual;
    procedure FillChkLbxTable; virtual;

    procedure FillCheckBoxState; virtual;
    function  CheckRequestedTables (TxtTableList : string) : Boolean; virtual;
    procedure MarkAllTables; virtual;

    procedure LogErrors (    Idt_Trf      : Integer;
                         var TxtErrMsg    : string;
                             TxtSprErrMsg : string); virtual;

    procedure OnMessage (var Msg : TMsg; var Handled : Boolean);

  public
    { Public declarations }
    ArrTable       : array of TImportItem;  // array to store the table-info
    NumItemArrTable: Integer;               // quantity items in array-table
    NumFirstItem   : Word;                  // Number of the first item


    procedure Loaded; override;

    procedure DefineStandardRunParams; override;
    procedure BeforeCheckRunParams; override;
    procedure CheckAppDependParams (TxtParam : string); override;
    procedure AfterCheckRunParams; override;

    procedure CreateAdditionalModules; override;
    procedure Execute; override;
    procedure ExecImport; virtual;
    procedure LoadSelectedTable (NumSelected       : Integer); virtual;
    procedure LoadTableGeneral (    TxtTitle          : string;
                                    TxtTableName      : string;
                                    SprLoad           : TADOStoredProc;
                                var QtyLoaded         : Integer;
                                var QtyNotLoaded      : Integer); virtual;
    function MakeTitleTable    (TxtTableName    : string;
                                TxtTitle        : string) : string; virtual;

    // properties
    property AbortExecution : Boolean read GetAbortExecution;
    property FlgInvAddDel : Boolean read FFlgInvAddDel write FFlgInvAddDel;  //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS
  end;

var
  FrmADOCmmOrToFpnCa: TFrmADOCmmOrToFpnCA;

//*****************************************************************************

implementation

uses
  SfDialog,
  SmUtils,
  StStrW,

  DFpnADOCmmOrToFpnCA,
  DFpnADOCA,
  DFpnADOCommonCA,
  DFpnADOUtilsCA,
  DFpnADOApplicParamCA;

{$R *.DFM}

//=============================================================================
// Source-identifiers
//=============================================================================

const  // Module-name
  CtTxtModuleName  = 'FADOCmmOrToFpnCA';

const  // PVCS-keywords
  CtTxtSrcName     = '$Source: E:/development/Castorama/Flexpoint/Src/Flexpoint201/Develop/FADOCmmOrToFpnCa.pas,v $';
  CtTxtSrcVersion  = '$Revision: 1.8 $';
  CtTxtSrcDate     = '$Date: 2013/11/12 08:16:40 $';

//=============================================================================
// Resourcestrings
//=============================================================================

resourcestring
  CtTxtControleCashDesk        = 'Controle CaskDesk';
  CtTxtImportSales             = 'Sales';
  CtTxtImportPersonnel         = 'Personnel';
  CtTxtImportStock             = 'Stock';
  CtTxtImportParameters        = 'Parameters';
  CtTxtImportStructure         = 'Structure';
  CtTxtImportInterfaceCashDesk = 'Interface CashDesk';
  CtTxtImportPubDocument       = 'Campaign';
  CtTxtImportArtPrice          = 'Price';
  CtTxtImportMunicipality      = 'Municipality';
  CtTxtImportCustomer          = 'Customer';
  CtTxtImportStart             = 'Import session started.';
  CtTxtImportEnd               = 'Import session end.';
  CtTxtImport                  = 'Import from : ';
  CtTxtNotImported             = 'Record NOT imported : %d';

  CtTxtExecutedPoint           = ' executed.';
  CtTxtStarted                 = ' started.';

  CtTxtCaptArfControleCashDesk = 'Communication oracle : controle cashdesk (%s)';
  CtTxtCaptArfLoadAll          = 'Communication oracle : import all tables';
  CtTxtCaptArfLoadSel          = 'Communication oracle : import of marked ' +
                                 'tables (selection)';
  CtTxtFLoadFilesAddHelp       = 'xxFileListxx';
  CtTxtRunParamFLoadFilesA     = '    (where xxFilelistxx is a semi-colon ' +
                                 'seperated list of C-files)';

  CtTxtRunParamFFileList       = 'possible items in xxFileListxx are:';
  CtTxtRunParamVINIT           = '/VINIT=Initial load';
  CtTxtInitalLoad              = '(Initial load)';
  CtTxtRestartMsgRcvd          = 'Received Restart Message';
  CtTxtStopMsgRcvd             = 'Received Stop Message';
  CtTxtStopWhenDoneMsgRcvd     = 'Received Stop-when-done Message';
  CtTxtOPCOname                = '/VBDFR=Invoice deletion for BDFR';   //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS

//*****************************************************************************
// Implementation of TFrmADOCmmOrToFpnCA
//*****************************************************************************

//=============================================================================
// Properties
//=============================================================================

function TFrmADOCmmOrToFpnCA.GetAbortExecution : Boolean;
begin  // of TFrmADOCmmOrToFpnCA.GetAbortExecution
  Result := FlgInterrupted or Application.Terminated;
end;   // of TFrmADOCmmOrToFpnCA.GetAbortExecution

//=============================================================================
// Methods
//=============================================================================

//=============================================================================
// TFrmADOCmmOrToFpnCA.AddItemToArray : add an item to the ArrTable array
//
//                                   ------
//
// INPUT : NumIndex : position in array where to add item
//         TxtTable : Tablename of oracle replica table
//         TxtTitle : Title to print on processing of table
//         SprLoad  : Stored Procedure to load table
// OUTPUT: NumIndex : 1 higher than input, so procedure is ready for the next
//                    call
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.AddItemToArray (var NumIndex   : Word;
                                               TxtTable   : string;
                                               TxtTitle   : string;
                                               SprLoad    : TADOStoredProc);
begin  // of TFrmADOCmmOrToFpnCA.AddItemToArray
  ArrTable[NumIndex].TxtTableName   := TxtTable;
  ArrTable[NumIndex].TxtTitle       := TxtTitle;
  ArrTable[NumIndex].SprLoad        := SprLoad;
  Inc (NumIndex);
end;   // of TFrmADOCmmOrToFpnCA.AddItemToArray

//=============================================================================

//=============================================================================
// TFrmADOCmmOrToFpnCA.AddItemsToArrTable : Adds all tables to array ArrTable
//
//                                   ------
//
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.AddItemsToArrTable;
var
  NumIndex         : Word;             // Index in the array
begin  // of TFrmADOCmmOrToFpnCA.AddItemsToArrTable
  NumIndex := NumFirstItem;
  if CodRunFunc = CtCodArfControleCashDesk then begin
    AddItemToArray (NumIndex,'TAR_FO_Controle_Caisse',CtTxtControleCashDesk,
                    DmdFpnADOCmmOrToFpnCA.ADOSprControleCaisse);
  end
  else begin
    AddItemToArray (NumIndex,'NOC_FO_Vente',CtTxtImportSales,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadNOCFOVente);
    AddItemToArray (NumIndex,'REPLICA_FO_PARAMETRE',CtTxtImportParameters,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadReplicaFoParametre);
    AddItemToArray (NumIndex,'PRS_FO_Structure',CtTxtImportStructure,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadPRSFOStructure);
    if FlgInit then
      AddItemToArray (NumIndex,'TAR_FO_Interface_Caisse',
                      CtTxtImportInterfaceCashDesk,
                     DmdFpnADOCmmOrToFpnCA.ADOSprLoadTARFOInterfaceCaisse_InitialLoad)
    else
      AddItemToArray (NumIndex,'TAR_FO_Interface_Caisse',
                      CtTxtImportInterfaceCashDesk,
                      DmdFpnADOCmmOrToFpnCA.ADOSprLoadTARFOInterfaceCaisse);
    AddItemToArray (NumIndex,'TAR_FO_Pub_Document',CtTxtImportPubDocument,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadTARFOPubDocument);
    if FlgInit then
      AddItemToArray (NumIndex,'TAR_FO_Art_Pub_Tarif_Vente',CtTxtImportArtPrice,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadTARFOArtPubTarifVente_InitialLoad)
    else
      AddItemToArray (NumIndex,'TAR_FO_Art_Pub_Tarif_Vente',CtTxtImportArtPrice,
                      DmdFpnADOCmmOrToFpnCA.ADOSprLoadTARFOArtPubTarifVente);
    AddItemToArray (NumIndex,'JDV_FO_Commune',CtTxtImportMunicipality,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadJDVFOCommune);
    AddItemToArray (NumIndex,'NOC_FO_CLIENTS',CtTxtImportCustomer,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadNOCFOCLIENTS);
    AddItemToArray (NumIndex, 'NOC_FO_SALARIE',CtTxtImportPersonnel,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadNOCFOSalarie);
    AddItemToArray (NumIndex, 'STG_FO_STOCK',CtTxtImportStock,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadSTGFOSTOCK);
    AddItemToArray (NumIndex,'NOC_FO_CLIENTS_MARKETING',CtTxtImportCustomer,
                    DmdFpnADOCmmOrToFpnCA.ADOSprLoadNOCFOCLIENTSMARKETING);
  end;
end;   // of TFrmADOCmmOrToFpnCA.AddItemsToArrTable

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.FillArrTable;
var
  CntArrTable      : Integer;          // Counter to loop arrtable
begin  // of TFrmADOCmmOrToFpnCA.FillArrTable
  SetLength (ArrTable, NumItemArrTable);
  if not Assigned (DmdFpnADOCmmOrToFpnCa) then
    Exit;
  AddItemsToArrTable;

  for CntArrTable := 0 to NumItemArrTable - 1 do begin
    SfDialog.AddRunParams ('/Ff','        ' +
                                 ArrTable[CntArrTable].TxtTableName);
  end;
end;   // of TFrmADOCmmOrToFpnCA.FillArrTable

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.FillChkLbxTable;
var
  Cnt              : Integer;          // counter
begin  // of TFrmADOCmmOrToFpnCA.FillChkLbxTable
  ChkLbxTable.Font.Color := clGrayText;
  ChkLbxTable.Items.Clear;
  for Cnt := 0 to Pred (NumItemArrTable) do begin
    ChkLbxTable.Items.Add (Trim (ArrTable[Cnt].TxtTitle) + ' (' +
      Trim (ArrTable[Cnt].TxtTableName) + ')');
  end;  // for Cnt := 0 to Pred (NumItemArrTable) do begin
end;   // of TFrmADOCmmOrToFpnCA.FillChkLbxTable

//=============================================================================

//=============================================================================
// TFrmADOCmmOrToFpnCA.FillCheckBoxState : Check on the runparameter to fill
// the checklistboxstate.
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.FillCheckBoxState;
begin  // of TFrmADOCmmOrToFpnCA.FillCheckBoxState
  if CodRunFunc in [CtCodArfLoadSel] then begin
    if not CheckRequestedTables (Copy (ViTxtFunction,
                                      Length (CiArrTxtFunc[CodRunFunc]) + 1,
                                      Length (ViTxtFunction))) then begin
      InvalidRunParam ('/F' + ViTxtFunction);
      Exit;
    end;
  end
  else if CodRunFunc in [CtCodArfLoadAll,CtCodArfControleCashDesk] then
    MarkAllTables;
end;   // of TFrmADOCmmOrToFpnCA.FillCheckBoxState

//=============================================================================

//=============================================================================
// TFrmADOCmmOrToFpnCA.CheckRequestedTables : checks the list of files requested to
// synchronize (or to load), and mark the items in the checklist.
//                                  -----
// INPUT   : TxtTableList = list of the tables to check.
//                                  -----
// OUTPUT : Result : True if the tablelist is OK;
//                   False if the tablelist contains unprovided tables.
//=============================================================================

function TFrmADOCmmOrToFpnCA.CheckRequestedTables (TxtTableList : string)
                                                                      : Boolean;
var
  TxtTable         : string;           // Table from TableList
  CntItem          : Integer;          // Item in checklist
begin  // of TFrmADOCmmOrToFpnCA.CheckRequestedTables
  Result := False;
  while TxtTableList <> '' do begin
    SplitString (TxtTableList, ';', TxtTable, TxtTableList);
    if TxtTable <> '' then begin
      for CntItem := 0 to High (ArrTable) do begin
        if AnsiCompareText (TxtTable, ArrTable[CntItem].TxtTableName) = 0 then begin
          ChkLbxTable.State[CntItem] := cbGrayed;
          Break;
        end;
      end;
      if CntItem > High (ArrTable) then
        Exit;
    end;
  end;
  Result := True;
end;   // of TFrmADOCmmOrToFpnCA.CheckRequestedTables

//=============================================================================

//=============================================================================
// TFrmADOCmmOrToFpnCA.MarkAllTables : marks items for all tables to synchronize
// in the checklist.
//                                  -----
// Restrictions :
// - this cann't be checked before the form is loaded, because the checklist
//   wherein the provided files must be checked (and marked) is not earlier
//   available.
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.MarkAllTables;
var
  CntItem          : Integer;          // Item in checklist
begin  // of TFrmADOCmmOrToFpnCA.MarkAllTables
  for CntItem := 0 to Pred (ChkLbxTable.Items.Count) do
    ChkLbxTable.State[CntItem] := cbGrayed;
end;   // of TFrmADOCmmOrToFpnCA.MarkAllTables

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.Loaded;
begin  // of TFrmADOCmmOrToFpnCA.Loaded
  if not (csLoading in ComponentState) then
    Exit;

  inherited;

  case CodRunFunc of
    CtCodArfControleCashDesk : Caption := Format(CtTxtCaptArfControleCashDesk,
                                   [FormatDateTime('dd-mm-yyyy',ViDtmExecute)]);
    CtCodArfLoadAll          : Caption := CtTxtCaptArfLoadAll;
    CtCodArfLoadSel          : Caption := CtTxtCaptArfLoadSel;
  end;

  if CodRunFunc in [CtCodArfLoadAll,CtCodArfLoadSel] then begin
    if FlgInit then
      Caption := Caption + ' ' + CtTxtInitalLoad;
  end;

  Application.Title := Caption;

  if (AnsiCompareText(CiTxtAppInstMutex,'Load') = 0) then begin
    SvcAppInstCheck.InstanceOption := aioNone;
  end;
end;   // of TFrmADOCmmOrToFpnCA.Loaded

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.DefineStandardRunParams;
begin  // of TFrmADOCmmOrToFpnCA.DefineStandardRunParams
  inherited;
  ViTxtRunPmAllow := ViTxtRunPmAllow + 'FVD';
end;   // of TFrmADOCmmOrToFpnCA.DefineStandardRunParams

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.BeforeCheckRunParams;
var
  TxtPartLeft      : string;           // Left part of a string
  TxtPartRight     : string;           // Right part of a string
begin  // of TFrmADOCmmOrToFpnCA.BeforeCheckRunParams
  FlgInit         := False;
  FlgRestart      := False;
  FlgStop         := False;
  FlgStopWhenDone := False;
  FlgInvAddDel    := False;      //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS

  // Controle CashDesk Function
  SfDialog.AddRunParams ('/Ff', '- f = '
                                     + CiArrTxtFunc[CtCodArfControleCashDesk] +
                                ': ' + CtTxtCaptArfControleCashDesk);

  // LoadAll-function
  SfDialog.AddRunParams ('/Ff', '- f = ' + CiArrTxtFunc[CtCodArfLoadAll] +
                                ': ' + CtTxtCaptArfLoadAll);
  // LoadxxFileListxx-function
  SfDialog.AddRunParams ('/Ff', '- f = ' + CiArrTxtFunc[CtCodArfLoadSel] +
                                CtTxtFLoadFilesAddHelp + ': ' +
                                CtTxtCaptArfLoadSel);
  SfDialog.AddRunParams ('/Ff', CtTxtRunParamFLoadFilesA);
  SfDialog.AddRunParams ('/Ff', CtTxtRunParamFFileList);

  SplitString (CtTxtRunParamVINIT,'=',TxtPartLeft,TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);

 //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS.Start
  SplitString (CtTxtOPCOname,'=',TxtPartLeft,TxtPartRight);
  AddRunParams (TxtPartLeft, TxtPartRight);
 //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS.end
end;   // of TFrmADOCmmOrToFpnCA.BeforeCheckRunParams

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.CheckAppDependParams (TxtParam : string);
begin  // of TFrmADOCmmOrToFpnCA.CheckAppDependParams
  if (AnsiCompareText(TxtParam,'/VINIT')=0) then
    FlgInit := True;
//R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS.Start
  try
    if copy(TxtParam,3,4) = 'BDFR' then
      FlgInvAddDel := True
//R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS.End
    else
      inherited;
  except
    
  end;
end;   // of TFrmADOCmmOrToFpnCA.CheckAppDependParams

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.AfterCheckRunParams;
var
  CodCheckFunc     : Integer;          // Code check installed function
begin  // of TFrmADOCmmOrToFpnCA.AfterCheckRunParams
  if Application.Terminated then
    Exit;

  // Investigate current functionality
  if (CodRunFunc = CtCodArfNotSet) and (ViTxtFunction <> '') then begin
    for CodCheckFunc := (CtCodArfNotSet + 1) to CtCodArfHigh do
      if AnsiCompareText (Copy(ViTxtFunction,1,Length (CiArrTxtFunc[CodCheckFunc])),
                      CiArrTxtFunc[CodCheckFunc]) = 0 then begin
        CodRunFunc := CodCheckFunc;
        Break;
      end;
      if CodRunFunc = CtCodArfNotSet then begin
        InvalidRunParam ('/F' + ViTxtFunction);
        Exit;
      end;
  end;
  if CodRunFunc = CtCodArfNotSet then begin
    MissingRunParam ('/F');
    Exit;
  end;

  // Keep only the datepart (throw timepart away)
  FDatControle := StrToDate(DateToStr(ViDtmExecute));
end;   // of TFrmADOCmmOrToFpnCA.AfterCheckRunParams

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.CreateAdditionalModules;
begin  // of TFrmADOCmmOrToFpnCA.CreateAdditionalModules
  try
    // Create datamodules for DB
    if not Assigned (DmdFpnADOCA) then
      DmdFpnADOCA := TDmdFpnADOCA.Create (Application);

    if not Assigned (DmdFpnADOCommonCA) then
      DmdFpnADOCommonCA := TDmdFpnADOCommonCA.Create (Application);

    if not Assigned (DmdFpnADOUtilsCA) then
      DmdFpnADOUtilsCA := TDmdFpnADOUtilsCA.Create (Application);

    if not Assigned (DmdFpnADOApplicParamCA) then
      DmdFpnADOApplicParamCA := TDmdFpnADOApplicParamCA.Create (Application);

    if not Assigned (DmdFpnADOCmmOrToFpnCA) then begin
      DmdFpnADOCmmOrToFpnCA := TDmdFpnADOCmmOrToFpnCA.Create (Application);
      DmdFpnADOCmmOrToFpnCA.DatControle := FDatControle;
      DmdFpnADOCmmOrToFpnCA.FlgInvAddDel := FlgInvAddDel;       //R2013.2.Req35020.BDFR.Delete Invoice Address.TCS-AS
    end;


  finally
    // Restore workingdir :
    // - initialization of DFpn has working dir changed to temp-dir
    // - creation of DmdFpn will restore the working dir
    // - if DataModule was not created (not needed, or due to an error,
    //   the working dir was not restored yet.
    ChDir (ViTxtWorkingDir);
  end;
end;   // of TFrmADOCmmOrToFpnCA.CreateAdditionalModules

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.AutoStart (Sender : TObject);
begin  // of TFrmADOCmmOrToFpnCA.AutoStart
  if Application.Terminated then
    Exit;

  inherited;

  // Start process
  if ViFlgAutom then begin
    FillArrTable;
    FillChkLbxTable;
    FillCheckBoxState;
    ActStartExecExecute (Self);

    if (CodRunFunc = CtCodArfControleCashDesk) then begin
      if StrToInt (Trim (LblCntError.Caption)) > 0 then
        ExitCode := CtNumExitCmmOrWithErrors;
      Application.Terminate;
      Application.ProcessMessages;
    end else begin
      TmrCheck.Enabled := True;
    end;
  end;
end;   // of TFrmADOCmmOrToFpnCA.AutoStart

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.Execute;
var
  Cnt              : Integer;       // counter
begin  // of TFrmADOCmmOrToFpnCA.Execute
  // set flags to log the 'Start session' & 'End session' -messages
  FlgLogStartMsg := True;
  FlgLogEndMsg := False;

  for Cnt := 0 to Pred (ChkLbxTable.Items.Count) do
    if ChkLbxTable.State[Cnt] = cbChecked then
      ChkLbxTable.State[Cnt] := cbGrayed;

  ChkLbxTable.Enabled := False;
  LstBxResult.Visible := True;
  LstBxResult.Items.Clear;
  InitOnStartExec ('');
  ShowLogCount := True;

  // disable triggers
  if FlgInit then begin
    // Set DB-options True
    DmdFpnADOCmmOrToFpnCA.SetDBOptions (True);

    DmdFpnADOCmmOrToFpnCA.DisableTrigger ('Article');
    DmdFpnADOCmmOrToFpnCA.DisableTrigger ('ArtAssort');
    DmdFpnADOCmmOrToFpnCA.DisableTrigger ('ArtPrice');
    DmdFpnADOCmmOrToFpnCA.DisableTrigger ('ArtPLU');
    DmdFpnADOCmmOrToFpnCA.DisableTrigger ('ArtSupplier');
  end;

  try
    ExecImport;
  finally
    // enable triggers
    if FlgInit then begin
      DmdFpnADOCmmOrToFpnCA.EnableTrigger ('Article');
      DmdFpnADOCmmOrToFpnCA.EnableTrigger ('ArtAssort');
      DmdFpnADOCmmOrToFpnCA.EnableTrigger ('ArtPrice');
      DmdFpnADOCmmOrToFpnCA.EnableTrigger ('ArtPLU');
      DmdFpnADOCmmOrToFpnCA.EnableTrigger ('ArtSupplier');
      // Set DB-options False
      DmdFpnADOCmmOrToFpnCA.SetDBOptions (False);
    end;

  end;

  ShowLogCount := True;
  InitOnStopExec ('');
  ChkLbxTable.Enabled := True;
  StsBarExec.Panels[1].Text := '';
end;   // of TFrmADOCmmOrToFpnCA.Execute

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.ExecImport;
var
  Cnt              : Integer;       // counter
begin  // of TFrmADOCmmOrToFpnCA.ExecImport
  if FlgRestart then begin
    SvcExceptHandler.LogMessage (CtChrLogInfo,
      SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtRestartMsgRcvd]));
    for Cnt := 0 to ChkLbxTable.Items.Count - 1 do begin
      if ChkLbxTable.State[Cnt] = cbChecked then
        ChkLbxTable.State[Cnt] := cbGrayed;
    end;
    LstBxResult.Items.Clear;
    FlgRestart := False;
  end;

  if FlgLogStartMsg then begin
    FlgLogStartMsg := False;
    FlgLogEndMsg := True;
    SvcExceptHandler.LogMessage (CtChrLogInfo,
      SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtImportStart]));
  end;  // if FlgLogStart

  for Cnt := 0 to Pred (ChkLbxTable.Items.Count) do begin
    StsBarExec.Panels[0].Text := CtTxtImport + ChkLbxTable.Items.Strings[Cnt];
    ChkLbxTable.ItemIndex := Cnt;
    if ChkLbxTable.State[Cnt] = cbGrayed then begin
      LoadSelectedTable (Cnt);
      if FlgInterrupted then begin
        Exit;
      end;  // if FlgInterrupted
      ChkLbxTable.State[Cnt] := cbChecked;
      if (FlgRestart or FlgStop) then
        Break;
    end;  // if ChkLbxTable.Checked[Cnt] ...
  end;  // for Cnt := 0 to ...

  if FlgRestart then
    ExecImport
  else
    if FlgLogEndMsg then
      SvcExceptHandler.LogMessage (CtChrLogInfo,
        SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtImportEnd]));
end;   // of TFrmADOCmmOrToFpnCA.ExecImport

//=============================================================================

//=============================================================================
// TFrmCmmHQToFpn.LoadSelectedTable : Process the selected Table
//
//                                   ------
//
// INPUT : NumSelected : the number of the Table to process
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.LoadSelectedTable (NumSelected : Integer);
var
  TxtTitle         : string;          // title to print
  TxtTableName     : string;          // tablename
  TxtLeft          : string;          // left part after splitstring
  TxtRight         : string;          // right part after splitstring
  NumLoaded        : Integer;         // number of records loaded
  NumNotLoaded     : Integer;         // number of records not loaded
begin  // of TFrmADOCmmOrToFpnCA.LoadSelectedTable
  TxtTableName := ArrTable[NumSelected].TxtTableName;
  TxtTitle := Trim (CtTxtImport) + Trim (TxtTableName);
  SvcExceptHandler.LogMessage (CtChrLogInfo,
  SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
                                    [TxtTitle + CtTxtStarted]));

  LoadTableGeneral (TxtTitle, TxtTableName, ArrTable[NumSelected].SprLoad,
                    NumLoaded,NumNotLoaded);

  // Log numloaded & numloaded and
  // add it to the listbox
  LstBxResult.Items.Add (Trim (SplitString(TxtTitle, ':', TxtLeft, TxtRight)) +
    ' : ' + IntToStr(NumLoaded) + '/' + IntToStr((NumLoaded + NumNotLoaded)));

  SvcExceptHandler.LogMessage (CtChrLogInfo,
   SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
    [TxtTitle + CtTxtExecutedPoint + ' (' + IntToStr (NumLoaded) +  '/' +
     IntToStr(NumLoaded + NumNotLoaded) + ')']));
end;   // of TFrmADOCmmOrToFpnCA.LoadSelectedTable

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.LoadTableGeneral
                                            (TxtTitle          : string;
                                             TxtTableName      : string;
                                             SprLoad           : TADOStoredProc;
                                             var QtyLoaded     : Integer;
                                             var QtyNotLoaded  : Integer);
var
  TxtLogTitle      : string;           // title to log
  TxtErrMsg        : string;           // Error message
  TxtSprErrMsg     : string;           // Error message got from stored proc.
  Idt_Trf          : Integer;          // Id of the next record to process.
begin  // of TFrmADOCmmOrToFpnCA.LoadTableGeneral
  // To show stop-button on automic run
  Application.ProcessMessages;

  TxtLogTitle := MakeTitleTable (TxtTableName, TxtTitle);

  // initialize progressbar
  PgsBarExec.Max := DmdFpnADOCmmOrToFpnCA.GetCount (TxtTableName);
  ProgressBarPosition := 0;

  // PDD -- set CommandTimeOut to 10 minutes, 30 seconds is sometimes not
  //        enough for loading PRS_FO_STRCTURE record
  TADODataSet(SprLoad).CommandTimeout := 600;

  // Initially we set the number 0, the stored procedure will return the
  // id processed.
  Idt_Trf := 0;

  repeat

    DmdFpnADOCmmOrToFpnCA.FillPrmsStoredProc (SprLoad, Idt_Trf);

    try
      TxtErrMsg := '';
      TxtSprErrMsg := '';
//      SprLoad.Prepare; (** PDW - BEGIN - 10.03.2003 not used in ADO **)

      SprLoad.ExecProc;
    except
      on E:Exception do begin
        SprLoad.Parameters.ParamByName ('@PrmNumLoaded').Value := 0;
        TxtErrMsg := 'procedure TFrmADOCmmOrToFpnCA.LoadTableGeneral : ' +
                     E.Message;
      end;
    end;  // try
    Application.ProcessMessages;

    TxtSprErrMsg :=
      Trim (VarToStr (SprLoad.Parameters.ParamByName ('@PrmTxtMessage').Value));

    Idt_Trf := SprLoad.Parameters.ParamByName('@PrmId_Trf').Value;

    // Check if record is loaded
    if ((SprLoad.Parameters.ParamByName ('@PrmNumLoaded').Value < 1) and
        (Idt_Trf <> -1)) or
       (TxtSprErrMsg <> '') then begin

      Inc (QtyNotLoaded);
      LogErrors (Idt_Trf, TxtErrMsg, TxtSprErrMsg);
    end
    else begin
      if (Idt_Trf <> -1) then
        Inc (QtyLoaded);
    end;  // if SprLoad.ParamByName ('@PrmNumLoaded').AsInteger ...


    // the stored procedure will return -1 when all records are processed
    if Idt_Trf <> -1 then begin
      inc(Idt_Trf);
      ProgressBarPosition := ProgressBarPosition + 1;
    end;
  until (Idt_Trf = -1) or FlgInterrupted or FlgRestart or FlgStop;
end;   // of TFrmADOCmmOrToFpnCA.LoadTableGeneral

//=============================================================================

function TFrmADOCmmOrToFpnCA.MakeTitleTable (TxtTableName    : string;
                                             TxtTitle        : string) : string;
begin  // of TFrmADOCmmOrToFpnCA.MakeTitleTable
  Result := TxtTitle + TxtTablename;
end;   // of TFrmADOCmmOrToFpnCA.MakeTitleTable

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.LogErrors (    Idt_Trf      : Integer;
                                         var TxtErrMsg    : string;
                                             TxtSprErrMsg : string);
begin  // of TFrmADOCmmOrToFpnCA.LogErrors
  if TxtErrMsg <> '' then begin
    TxtErrMsg := Format (CtTxtNotImported, [Idt_Trf]) + #13 + TxtErrMsg;
    SvcExceptHandler.LogMessage (CtChrLogError,
      SvcExceptHandler.BuildLogMessage (CtNumErrorMax, [TxtErrMsg]));
  end;  // if TxtErrMsg <> ''

  // process the stored procedure error-message
  if TxtSprErrMsg <> '' then
    SvcExceptHandler.LogMessage (CtChrLogError,
      SvcExceptHandler.BuildLogMessage (CtNumErrorMin, [TxtSprErrMsg]));
end;   // of TFrmADOCmmOrToFpnCA.LogErrors

//=============================================================================
// Events
//=============================================================================

procedure TFrmADOCmmOrToFpnCA.FormCreate(Sender: TObject);
begin  // of TFrmADOCmmOrToFpnCA.FormCreate
  try
    inherited;
    NumFirstItem    := 0;

    if CodRunFunc = CtCodArfControleCashDesk then begin
      NumItemArrTable := 1;
      SvcExhApp.FileNameLog := CtTxtLogPath + '\PcmmOrToFpnControleCashDesk.LOG';
    end else begin
      NumItemArrTable := 11;
      SvcExhApp.FileNameLog := CtTxtLogPath + '\PcmmOrToFpnLoad.LOG';
    end;

    FlgFillArrTable := False;

    FMsgRestart      := RegisterWindowMessage ('Sycron.RestartProcessing');
    FMsgStop         := RegisterWindowMessage ('Sycron.StopProcessing');
    FMsgStopWhenDone := RegisterWindowMessage ('Sycron.StopProcessingWhenDone');
    Application.OnMessage := OnMessage;
  except
    on E:Exception do begin
      if E is ESvcAppInstance then
        E.message := E.message + #10 +
                     Format (CtTxtEmScndInstSameComputer,
                             [AnsiQuotedStr (JustNameW (ParamStr (0)), '''')]);
      ProcessStartupError (E);
    end;
  end;
end;   // of TFrmADOCmmOrToFpnCA.FormCreate

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.FormActivate(Sender: TObject);
begin  // of TFrmADOCmmOrToFpnCA.FormActivate
  inherited;
  if not FlgFillArrTable then begin
    FillArrTable;
    FillChkLbxTable;
    FillCheckBoxState;
    FlgFillArrTable := True;
  end;
end;   // of TFrmADOCmmOrToFpnCA.FormActivate

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.OnMessage (var Msg : TMsg; var Handled : Boolean);
begin  // of TFrmADOCmmOrToFpnCA.OnMessage
  if Msg.message = FMsgRestart then begin
    if (CodRunFunc <> CtCodArfControleCashDesk) then
      FlgRestart := True;
  end
  else if Msg.message = FMsgStop then begin
    if (CodRunFunc <> CtCodArfControleCashDesk) then begin
      if not FlgStop then begin
        FlgStop := True;
        SvcExceptHandler.LogMessage (CtChrLogInfo,
          SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtStopMsgRcvd]));
      end;
    end;
  end
  else if Msg.message = FMsgStopWhenDone then begin
    if (CodRunFunc <> CtCodArfControleCashDesk) then begin
      if not FlgStopWhenDone then begin
        FlgStopWhenDone := True;
        SvcExceptHandler.LogMessage (CtChrLogInfo,
          SvcExceptHandler.BuildLogMessage (CtNumInfoMin,
                                            [CtTxtStopWhenDoneMsgRcvd]));
      end;
    end;
  end
  else
    inherited;
end;   // of TFrmADOCmmOrToFpnCA.OnMessage

//=============================================================================

procedure TFrmADOCmmOrToFpnCA.TmrCheckTimer(Sender: TObject);
begin  // of TFrmADOCmmOrToFpnCA.TmrCheckTimer
  inherited;
  if FlgRestart then begin
    TmrCheck.Enabled := False;
    SvcExceptHandler.LogMessage (CtChrLogInfo,
      SvcExceptHandler.BuildLogMessage (CtNumInfoMin, [CtTxtRestartMsgRcvd]));
    FlgRestart := False;
    if ViFlgAutom then begin
      AutoStart (Sender);
    end;
  end else if (FlgStop or FlgStopWhenDone) then begin
    TmrCheck.Enabled := False;
    Application.ProcessMessages;
    if StrToInt (Trim (LblCntError.Caption)) > 0 then
      ExitCode := CtNumExitCmmOrWithErrors;
    Application.Terminate;
    Application.ProcessMessages;
  end;
end;  // of TFrmADOCmmOrToFpnCA.TmrCheckTimer

//=============================================================================

var
  CntParam : Integer;
  TxtParam : string;

initialization
  // investigate runparameters to set mutex-name
  if ParamCount > 0 then begin
    for CntParam := 1 to ParamCount do begin
      TxtParam := ParamStr (CntParam);
      if AnsiUpperCase(Copy (TxtParam,1,2))='/F' then
        CiTxtAppInstMutex := Copy(TxtParam,3,length(TxtParam)-2);
        // LoadSel && LoadAll --> do not run together.
        if Copy(CiTxtAppInstMutex,1,4) = 'Load' then begin
          CiTxtAppInstMutex := 'Load'

        end
    end;
  end;

  // Add module to list for version control
  SfDialog.AddPVCSSourceIdent (CtTxtModuleName, CtTxtSrcName,
                               CtTxtSrcVersion, CtTxtSrcDate);
end.
