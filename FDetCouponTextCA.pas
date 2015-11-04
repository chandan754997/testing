unit FDetCouponTextCA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FDetCoupText, DB, ovcbase, ComCtrls, Grids, DBGrids, cxMaskEdit,
  ScUtils_Dx, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit, cxDBEdit,
  ScDBUtil_Dx, DBCtrls, Buttons, ovcef, ovcpb, ovcpf, ScUtils, ScDBUtil_BDE,
  ExtCtrls;

type
  TFrmDetCoupTextCA = class(TFrmDetCoupText)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure SetDataSetReferences; override;
  public
    { Public declarations }
  end;

var
  FrmDetCoupTextCA: TFrmDetCoupTextCA;

implementation

uses FDetDescr, DFpnCouponCA;

{$R *.dfm}

{ TFrmDetCoupTextCA }

procedure TFrmDetCoupTextCA.SetDataSetReferences;
begin
  inherited;
  DscDetDescr.DataSet := DmdFpnCouponCA.QryLstCoupTextCoupon;
  DscListDescr.DataSet := DmdFpnCouponCA.QryLstCoupText;
end;

end.
