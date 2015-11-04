unit FDetArtPLUCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetArtPLU, DB, ovcbase, ComCtrls, StdCtrls, DBCtrls, Buttons, ovcef,
  ovcpb, ovcpf, ovcdbpf, ScDBUtil_Ovc, cxMaskEdit, ScUtils_Dx, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxDBEdit, ScDBUtil_Dx, ScDBUtil_BDE, ExtCtrls;

type
  TFrmDetArtPLUCA = class(TFrmDetArtPLU)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDetArtPLUCA: TFrmDetArtPLUCA;

implementation

uses DFpnUtils;

{$R *.dfm}

end.
