unit FlexUtils;

interface
uses
IniFiles,SmUtils,Sysutils,Windows,dialogs;

const  //possible error codes
  ERROR_ALREADY_ASSIGNED    = 85;
  //These err codes might be required later hence retained. 
  {ERROR_BAD_NET_NAME        = 67;
  ERROR_BAD_USERNAME        = 2202;
  ERROR_CANNOT_OPEN_PROFILE = 1205;
  ERROR_DEVICE_IN_USE       = 2404;
  }
  ERROR_SESSION_CREDENTIAL_CONFLICT = 1219;  

var
 TxtDllNotFound   : string = 'FlexUtils.dll not found.' +
                             #13 + 'Remote connection will not be possible.';
 TxtStorenumNotFound: string = 'Store number not found in FpsSyst.ini file';           
 TxtDllPathNotFound : string = 'Path of the dll file not found in FpsSyst.ini';

type
// Initialisation
{  TAddRemoteConnection = function (lpNetWrkResource: PWideChar;
                        lpUserName: PWideChar;lpPassword: PWideChar) :integer; stdcall;
  TCancelRemoteConnection = function (lpNetWrkResource: PWideChar): integer; stdcall;}
  TAddRemoteConnection = function (lpNetWrkResource: PWideChar;
                        lpUserName: PWideChar;lpPassword: PWideChar) :boolean; stdcall;
  TCancelRemoteConnection = function (lpNetWrkResource: PWideChar): boolean; stdcall;
  TGetLastErrorNo = function (): DWORD; stdcall;
  TGetLastErrorMessage = procedure (szErrorMessage: PWideChar;
                        BufLength: Cardinal); stdcall;

var
  AddRemoteConnection: TAddRemoteConnection;
  CancelRemoteConnection:   TCancelRemoteConnection;
  GetLastErrorNo:   TGetLastErrorNo;
  GetLastErrorMessage: TGetLastErrorMessage;

var
  TxtFlexUtilDllName      : string; // Path of the FlexUtil dll
  TxtStoreNum             : string; // Store Num variable  as text
 // Default FlexPOS INI-File
  ViTxtFNIniSystemFps     : string = '\FlexPos\Ini\FpsSyst.INI';

procedure SetDllFunctions;
procedure RetriveFlexDllPath;
function GetPrgRoot (TxtFN : string) : string;

var
CIHandle         : THandle = Low (THandle);


implementation      


//=============================================================================
// GetPrgRoot : Determines the program root
//=============================================================================
function GetPrgRoot (TxtFN : string) : string;
var
  TxtS             : string;
begin  // of GetPrgRoot
  TxtS := ReplaceEnvVar ('%PrgROOT%');
  if TxtS <> '' then
    Result := TxtS + TxtFN
  else
    Result := AddStartDirToFN (TxtFN);
end;   // of GetPrgRoot
//=============================================================================
// ReadDLLFuncAddress : This function reads the address of various functions
// available in FlexUtils.dll
// INPUT        : Name of the function
// RETURN VALUE : The address of the method name passed as argument.
//=============================================================================

function ReadDLLFuncAddress ( S : string) : TFarProc;
var
  DLLProcAdres     : TFarProc;
  PCh              : PChar;
begin  // of ReadDLLFuncAddress
  PCh := StrAlloc (256);
  StrPCopy (PCh, S);
  DLLProcAdres := GetProcAddress (CIHandle, PCh);
  if not Assigned (DLLProcAdres) then begin
{    LogError (Format ('Unable to load function %s from %s',
    [S, TxtFlexUtilDllName]), GetLastError);}

  end;
  StrDispose (PCh);
  Result := DLLProcAdres;
end;   // of ReadDLLFuncAddress
//=============================================================================
// SetDllFunctions : This procedure sets the various functions of the dll
//=============================================================================
procedure SetDllFunctions;
var
 PCh              : PChar;
begin
  PCh := StrAlloc (256);
  StrPCopy (PCh, TxtFlexUtilDllName);
  CIHandle := LoadLibrary (PCh);
  if (CIHandle = 0) then begin
   Showmessage(TxtDllNotFound);
  end;
  @AddRemoteConnection := ReadDLLFuncAddress('AddRemoteConnection');
  @CancelRemoteConnection := ReadDLLFuncAddress('CancelRemoteConnection');
  @GetLastErrorNo:= ReadDLLFuncAddress('GetLastErrorNo');
  @GetLastErrorMessage:= ReadDLLFuncAddress('GetLastErrorMessage');
  StrDispose (PCh);  
end;
//=============================================================================
// RetriveFlexDllPath : This procedure is used to retrieve the path of the dll
//=============================================================================
procedure RetriveFlexDllPath;
var
 IniFilFpsSyst       : TIniFile;    // IniObject for FilFpsSyst.Ini
begin
 IniFilFpsSyst := TIniFile.Create (ViTxtFNIniSystemFps);
 TxtStoreNum := Trim(IniFilFpsSyst.ReadString('Common','STOREID',''));
 TxtStoreNum := Copy(TxtStoreNum,5,4);

 //if store num not found FADOMenuCA.CreaConnectCashDesk  will fail to create
 //remote connection with the tills
 if TxtStoreNum = '' then
  showmessage(TxtStorenumNotFound);

 TxtFlexUtilDllName:=IniFilFpsSyst.ReadString('Common','ToolDLL','');
 //if the path of the dll file is not found in the ini file, then the dll file
 //will not be loaded and FADOMenuCA.CreaConnectCashDesk  will fail to create
 //remote connection with the tills
 if TxtFlexUtilDllName = '' then
  showmessage(TxtDllPathNotFound);

end;
//=============================================================================

initialization
  ViTxtFNIniSystemFps := GetPrgRoot (ViTxtFNIniSystemFps);
  RetriveFlexDllPath;
  SetDllFunctions;   
end.
