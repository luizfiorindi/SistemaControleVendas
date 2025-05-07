unit ualterasenha;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TFormAlteraSenha }

      TFormAlteraSenha = class(TForm)
						ButtonAlterar: TButton;
						EditUsuario: TEdit;
						EditNovaSenha: TEdit;
						EditSenhaAtual: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						procedure ButtonAlterarClick(Sender: TObject);
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormAlteraSenha: TFormAlteraSenha;

implementation

 uses
  uDataModuleDB;
{$R *.lfm}

{ TFormAlteraSenha }

procedure TFormAlteraSenha.ButtonAlterarClick(Sender: TObject);
begin
  if (EditUsuario.Text = '') or (EditSenhaAtual.Text = '') or ( EditNovaSenha.Text = '') then
  begin
    ShowMessage('Todos os campos são obrigatórios!');
    Exit;
	end;

  DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= ' SELECT 1';
  DataModuleDB.SQLQueryExec.SQL.Add(   '   FROM TB_USUARIOS');
  DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE cLOGIN_US = ' + '''' + EditUsuario.Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '    AND cSENHA_US = ' + '''' + EditSenhaAtual.Text + '''');
  DataModuleDB.SQLQueryExec.Active:= True;

  if DataModuleDB.SQLQueryExec.RecordCount < 1 then
  begin
    ShowMessage('Usuário ou senha inválidos!');
    Exit;
	end;

  DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_USUARIOS';
  DataModuleDB.SQLQueryExec.SQL.Add(   '    SET cSENHA_US = ' + '''' + EditNovaSenha.Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE cLOGIN_US = ' + '''' + EditUsuario.Text + '''');
  DataModuleDB.SQLQueryExec.ExecSQL;

  ShowMessage('Senha alterada com sucesso!');
  Close;
end;

procedure TFormAlteraSenha.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryExec.Active:= False;
  CloseAction:= caFree;
  FormAlteraSenha:= Nil;
end;

end.

