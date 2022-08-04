unit ulogin;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TFormLogin }

      TFormLogin = class(TForm)
						ButtonAlterarSenha: TButton;
						ButtonLogar: TButton;
						EditSenha: TEdit;
						EditUsuario: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						procedure ButtonAlterarSenhaClick(Sender: TObject);
      procedure ButtonLogarClick(Sender: TObject);
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      procedure FormCreate(Sender: TObject);
      private
            { private declarations }
      var
        cAcesso: String;
      public
            { public declarations }
      end;

var
      FormLogin: TFormLogin;

implementation

uses
  uPrincipal, uDataModuleDB, ualterasenha;
{$R *.lfm}

{ TFormLogin }

procedure TFormLogin.FormCreate(Sender: TObject);
begin

end;

procedure TFormLogin.ButtonLogarClick(Sender: TObject);
begin
  if EditUsuario.Text = '' then
  begin
    ShowMessage('Digite o usuário!');
    Exit;
	end;

  if EditSenha.Text = '' then
  begin
    ShowMessage('Digite a senha!');
    Exit;
	end;

  DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= 'SELECT cLOGIN_US';
  DataModuleDB.SQLQueryExec.SQL.Add(   '     , cPERMISSAO_US');
  DataModuleDB.SQLQueryExec.SQL.Add(   '  FROM TB_USUARIOS');
  DataModuleDB.SQLQueryExec.SQL.Add(   ' WHERE cLOGIN_US = ' + '''' + EditUsuario.Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '   AND cSENHA_US = ' + '''' + EditSenha.Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '   AND cSTATUS_US = ' + '''' + '1' + '''');
  DataModuleDB.SQLQueryExec.Active:= True;

  if DataModuleDB.SQLQueryExec.RecordCount < 1 then
  begin
    ShowMessage('Usuário ou Senha inválidos!');
    Exit;
	end;

  cAcesso:= '1';
  FormPrincipal.StatusBar1.Panels[1].Text:= DataModuleDB.SQLQueryExec.FieldByName('cLOGIN_US').AsString;
  FormPrincipal.cPermissao:= DataModuleDB.SQLQueryExec.FieldByName('cPERMISSAO_US').AsString;
  if FormPrincipal.cPermissao = 'U' then
  begin
    FormPrincipal.MenuItemUsuarios.Enabled:= False;
	end;
	Close;
end;

procedure TFormLogin.ButtonAlterarSenhaClick(Sender: TObject);
begin
  FormAlteraSenha:= TFormAlteraSenha.Create(Application);
  FormAlteraSenha.ShowModal;
end;

procedure TFormLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if cAcesso <> '1' then
  begin
    FormPrincipal.Close;
	end;

	DataModuleDB.SQLQueryExec.Active:= False;
  CloseAction:= caFree;
  FormLogin:= Nil;
end;

end.

