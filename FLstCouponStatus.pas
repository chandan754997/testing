unit FLstCouponStatus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SfList_BDE_DBC, Menus, ExtCtrls, DB, ovcbase, ComCtrls, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, ScUtils_Dx, ovcef, ovcpb, ovcpf,
  ScUtils, StdCtrls, Buttons, Grids, DBGrids, SmUtils;

resourcestring                                                                    //Internal defect_383 fix, teesta, BDES
CtTxtAppTitle = 'Maintenance CouponStatus';                                       //Internal defect_383 fix, teesta, BDES

type
  TFrmLstCouponStatus = class(TFrmList)
    procedure FormCreate(Sender: TObject);                       // Internal defect_383 fix, teesta, BDES
    procedure DscListDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
    FFlgChangeState : boolean;
  protected
    SavRecModEnabled    : Boolean;     // Orig. value of Btn/MniRecMod.Enabled

    // Property getters and setters
    procedure SetAllowedJobs (Value : TSetListJobs); override;
    procedure SetActiveJobs (Value : TSetListJobs); override;
  public
    { Public declarations }
    property FlgChangeState: Boolean read FFlgChangeState
                                    write FFlgChangeState;
  end;

var
  FrmLstCouponStatus: TFrmLstCouponStatus;

implementation

{$R *.dfm}

procedure TFrmLstCouponStatus.DscListDataChange(Sender: TObject; Field: TField);
var
  FldStatus        : TField;           // Status of this coupon
begin
  inherited;
  FldStatus := DscList.DataSet.FieldByName ('CodState');
  BtnRecMod.Enabled :=
    SavRecModEnabled and (((FldStatus.AsInteger = 0) and FlgChangeState) or
                          not FlgChangeState) ;
  MniRecMod.Enabled := BtnRecMod.Enabled;
end;

procedure TFrmLstCouponStatus.SetAllowedJobs(Value: TSetListJobs);
begin
  inherited;
  SavRecModEnabled := MniRecMod.Enabled;
end;

procedure TFrmLstCouponStatus.SetActiveJobs(Value: TSetListJobs);
begin
  inherited;
  SavRecModEnabled := MniRecMod.Enabled;
end;

//Internal defect_383 fix, teesta, BDES - Start
procedure TFrmLstCouponStatus.FormCreate(Sender: TObject);
begin
  inherited;
   Application.Title := CtTxtAppTitle;
end;
//Internal defect_383 fix, teesta, BDES - End

end.
