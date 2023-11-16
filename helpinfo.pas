unit helpinfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, lazproginfo,
  lcltranslator, Buttons, lclintf, ExtCtrls, oslog;

type

  { TFormHelpInfo }

  TFormHelpInfo = class(TForm)
    ButtonClose: TButton;
    CheckBoxExpertMode: TCheckBox;
    GroupBoxInfo: TGroupBox;
    ImageLogo: TImage;
    LabeCopy: TLabel;
    LabelCopyRight: TLabel;
    LabelModeInfo: TLabel;
    LabelMode: TLabel;
    LabelCredits: TLabel;
    LabelCreditsTo: TLabel;
    LabelLang: TLabel;
    LabelLanguage: TLabel;
    LabelName: TLabel;
    LabelOpsiWeb: TLabel;
    LabelUibWeb: TLabel;
    LabelVers: TLabel;
    LabelVersion: TLabel;
    PanelCopyRight: TPanel;
    PanelWeb: TPanel;
    PanelMode: TPanel;
    PanelDescriptions: TPanel;
    PanelInfo: TPanel;
    PanelLanguage: TPanel;
    PanelTop: TPanel;
    PanelCredits: TPanel;
    PanelBottom: TPanel;
    PanelVersion: TPanel;
    SpeedButtonManual: TSpeedButton;
    procedure ButtonCloseClick(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabelOpsiWebClick(Sender: TObject);
    procedure LabelOpsiWebMouseEnter(Sender: TObject);
    procedure LabelOpsiWebMouseLeave(Sender: TObject);
    procedure LabelUibWebClick(Sender: TObject);
    procedure LabelUibWebMouseEnter(Sender: TObject);
    procedure LabelUibWebMouseLeave(Sender: TObject);
    procedure SpeedButtonManualClick(Sender: TObject);
  private
    procedure MouseEnterLink(Sender: TObject);
    procedure MouseLeaveLink(Sender: TObject);

  public

  end;

var
  FormHelpInfo: TFormHelpInfo;


implementation

{$R *.lfm}

{ TFormHelpInfo }

procedure TFormHelpInfo.FormShow(Sender: TObject);
begin
  LabelVersion.Caption := ProgramInfo.Version;
  LabelLanguage.Caption := SetDefaultLang('');
  LabelCopyRight.Caption:= 'uib gmbh under AGPLv3';
  LabelUibWeb.Caption := 'https://uib.de';
  LabelOpsiWeb.Caption:= 'https://opsi.org';
  LabelCredits.Caption:= 'Lazarus/FPC, synapse, sqllite';
end;

procedure TFormHelpInfo.LabelOpsiWebClick(Sender: TObject);
begin
  LogDatei.log('Open URL https://opsi.org' ,LLNotice);
  OpenUrl('https://opsi.org');
end;

procedure TFormHelpInfo.LabelOpsiWebMouseEnter(Sender: TObject);
begin
  MouseEnterLink(Sender);
end;

procedure TFormHelpInfo.LabelOpsiWebMouseLeave(Sender: TObject);
begin
  MouseLeaveLink(Sender);
end;

procedure TFormHelpInfo.LabelUibWebClick(Sender: TObject);
begin
  LogDatei.log('Open URL https://uib.de' ,LLNotice);
  OpenUrl('https://uib.de');
end;

procedure TFormHelpInfo.LabelUibWebMouseEnter(Sender: TObject);
begin
  MouseEnterLink(Sender);
end;

procedure TFormHelpInfo.LabelUibWebMouseLeave(Sender: TObject);
begin
  MouseLeaveLink(Sender);
end;

procedure TFormHelpInfo.SpeedButtonManualClick(Sender: TObject);
var
  languageNotFound:boolean;
  Language: String;
const
  URL_MANUAL_EN = 'https://docs.opsi.org/opsi-docs-en/4.3/opsi-modules/' +
    'software-on-demand.html?q=+Verwendung#software-on-demand_opsi-client-kiosk';
  URL_MANUAL_DE = 'https://docs.opsi.org/opsi-docs-de/4.3/opsi-modules/' +
    'software-on-demand.html?q=+Verwendung#software-on-demand_opsi-client-kiosk';
begin
  Language := SetDefaultLang('');
  LogDatei.log('Open manual for language ' + Language ,LLNotice);
  if Language = 'de' then
  begin
    OpenUrl(URL_MANUAL_DE);
    LogDatei.log('URL: '+ URL_MANUAL_DE, LLInfo);
  end
  else
  begin
    OpenUrl(URL_MANUAL_EN);
    LogDatei.log('URL: '+ URL_MANUAL_EN, LLInfo);
  end;
end;

procedure TFormHelpInfo.MouseEnterLink(Sender: TObject);
begin
  Screen.Cursor := crHandPoint;
  (Sender as TControl).Font.Style := [fsUnderline];
end;

procedure TFormHelpInfo.MouseLeaveLink(Sender: TObject);
begin
  Screen.Cursor := crDefault;
  (Sender as TControl).Font.Style := [];
end;


procedure TFormHelpInfo.ButtonCloseClick(Sender: TObject);
begin
  Close;
end;

end.

