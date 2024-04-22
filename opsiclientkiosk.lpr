program opsiclientkiosk;

{$mode delphi}{$H+}

uses
  {$IFDEF UNIX}//{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}//{$ENDIF}
  {$IFDEF WINDOWS}
  OckWindows,
  {$ENDIF WINDOWS}
  {$IFDEF LINUX}
  OckLinux, OckPasswordQuery,
  {$ENDIF LINUX}
  {$IFDEF DARWIN}
  OckMacOS, OckPasswordQuery, osfuncmac,
  {$ENDIF DARWIN}
  Interfaces, // this includes the LCL widgetset
  Classes, SysUtils, Forms, lazcontrols, lcltranslator, inifiles,
  opsiclientkioskgui, installdlg, datadb, progresswindow, oslog,
  osRunCommandElevated, lazproginfo, osprocesses, opsiconnection,
  helpinfo, OckImagestoDepot, OckPathsUtils, OckUserAuthentication

  {add more units if nedded};


{$R *.res}

begin
  //Application.Scaled:=True;
  RequireDerivedFormResource := True;
  Application.Initialize;
  {$IFDEF Windows}
  Application.ShowMainForm := False;
  {$ENDIF Windows}
  Application.Title:='opsi-client-kiosk';
  Application.CreateForm(TFormOpsiClientKiosk, FormOpsiClientKiosk);
  Application.CreateForm(TFormProgressWindow, FormProgressWindow);
  Application.CreateForm(TFInstalldlg, FInstalldlg);
  Application.CreateForm(TFormHelpInfo, FormHelpInfo);
  Application.CreateForm(TFormSaveImagesOnDepot, FormSaveImagesOnDepot);
  {$IFDEF UNIX}
  Application.CreateForm(TFormPasswordQuery, FormPasswordQuery);
  {$ENDIF UNIX}
  {$IFDEF Windows}
  Application.CreateForm(TFormUserAuthentication, FormUserAuthentication);
  {$ENDIF Windows}

  Application.Run;
  Application.Free;
end.

