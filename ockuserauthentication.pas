unit OckUserAuthentication;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  JwaWindows,
  oslog,
  opsiclientkioskgui;

type

  { TFormUserAuthentication }

  TFormUserAuthentication = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    LabeledEditUser: TLabeledEdit;
    LabeledEditPassword: TLabeledEdit;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSid: PSid;
    FSidSize: LongWord;
    FUserToken: THandle;
    FisMember: LongBool;
    function GetLocalUserSidStr(const UserName: widestring): string;
    function GetLogonUser(const UserName: widestring; const password: widestring):boolean;
  public
    destructor Destroy;override;
  end;

var
  FormUserAuthentication: TFormUserAuthentication;


resourcestring
  rsWrongUserOrPassword = 'Wrong user or password. Access denied. Close Application.';

implementation

{$R *.lfm}

{ TFormUserAuthentication }


procedure TFormUserAuthentication.FormCreate(Sender: TObject);
begin
  if FormOpsiClientKiosk.UserAuthentication then Show
  else
    begin
      FormOpsiClientKiosk.Show;
      Close;
    end;
end;


function TFormUserAuthentication.GetLocalUserSidStr(const UserName: widestring): string;
var
  RefDomain: array [0..MAX_PATH - 1] of wchar;      // enough
  RefDomainSize: longword;
  Snu: SID_NAME_USE;
  StringSid: LPTSTR;
begin
  FSidSize := 0;
  RefDomainSize := SizeOf(RefDomain);
  FSid := nil;
  FillChar(RefDomain, SizeOf(RefDomain), 0);
  LookupAccountNameW(nil, PWChar(UserName), FSid, FSidSize, RefDomain,
    RefDomainSize, Snu);
  FSid := AllocMem(FSidSize);
  try
    RefDomainSize := SizeOf(RefDomain);
    if LookupAccountNameW(nil, PWChar(UserName), FSid, FSidSize, RefDomain,
      RefDomainSize, Snu) then
      begin
        ConvertSidToStringSid(FSid, StringSid);
        Result := StringSid;
      end;
  except
    FreeMem(FSid, FSidSize);
    FSid := nil;
    FSidSize := 0;
  end;
end;

function TFormUserAuthentication.GetLogonUser(const UserName: Widestring;
  const Password: Widestring): boolean;
begin
  Result := False;
  if LogonUserW(PWChar(UserName),nil,PWChar(Password),LOGON32_LOGON_NETWORK,LOGON32_PROVIDER_DEFAULT,FUserToken) then
  begin
    LogDatei.log('UserAuthentication: Log on successful', LLInfo);
    Result := True;
  end
  else
  begin
    ShowMessage(rsWrongUserOrPassword);
    LogDatei.log('UserAuthentication: Wrong user or password. Access denied.', LLError);
    FormOpsiClientKiosk.Close;
  end;
end;

procedure TFormUserAuthentication.ButtonCancelClick(Sender: TObject);
begin
  Close;
  FormOpsiClientKiosk.Close;
end;

procedure TFormUserAuthentication.ButtonOKClick(Sender: TObject);
var
  StringSid: string;
begin
  FisMember := False;
  StringSid := GetLocalUserSidStr(LabeledEditUser.Text);
  LogDatei.log('Local user SID: ' + StringSid, LLInfo);
  GetLogonUser(LabeledEditUser.Text, LabeledEditPassword.Text);
  if FUserToken <> 0 then
    if CheckTokenMembership(FUserToken, FSid, FisMember) then
      LogDatei.log('UserAuthentication: Local Sid in Token',LLInfo)
    else
      LogDatei.log('UserAuthentication: Local Sid NOT in Token',LLInfo);
  if FisMember then FormOpsiClientKiosk.Show
  else FormOPsiClientKiosk.Close;
  Close;
end;


destructor TFormUserAuthentication.Destroy;
begin
  try
    try
     if assigned(FSid) then FreeMem(FSid, FSidSize);
    except
      on e: Exception do
      begin
        logdatei.log('Exception TFormUserAuthentication', LLError);
        logdatei.log('Exception: ' + E.message, LLError);
        logdatei.log('Exception handled at: ' + getCallAddrStr, LLError);
        logdatei.log_exception(E, LLError);
      end;
    end;
  finally
    inherited Destroy;
  end;

end;

end.

