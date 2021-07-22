program Universe;

uses
  Forms,
  Vcl.Themes,
  Vcl.Styles,
  Manager in 'Manager.pas' {ManagerForm},
  AboutManager in 'AboutManager.pas' {AboutManagerForm},
  ModuleInfo in 'ModuleInfo.pas' {ModuleInfoForm},
  Notify in 'Notify.pas' {NotifyForm},
  Options in 'Options.pas' {OptionsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Space Rangers Universe (Community)';
  Application.CreateForm(TManagerForm, ManagerForm);
  Application.CreateForm(TAboutManagerForm, AboutManagerForm);
  Application.CreateForm(TModuleInfoForm, ModuleInfoForm);
  Application.CreateForm(TNotifyForm, NotifyForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.Run;
end.
