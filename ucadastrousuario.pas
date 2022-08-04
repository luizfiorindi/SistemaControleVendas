unit uCadastroUsuario;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics,
			Dialogs, DbCtrls, StdCtrls, DBGrids, ButtonPanel, Buttons;

type

			{ TFormCadastroUsuarios }

      TFormCadastroUsuarios = class(TForm)
						BitBtnInsert: TBitBtn;
						BitBtnDelete: TBitBtn;
						BitBtnEdit: TBitBtn;
						BitBtnPost: TBitBtn;
						BitBtnCancel: TBitBtn;
						DataSourceUsuario: TDataSource;
						DBCheckBoxAdmin: TDBCheckBox;
						DBCheckBoxStatus: TDBCheckBox;
						DBEditNome: TDBEdit;
						DBEditLogin: TDBEdit;
						DBEditSenha: TDBEdit;
						DBGridUsuarios: TDBGrid;
						EditEstado: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Senha: TLabel;
			procedure BitBtnCancelClick(Sender: TObject);
   procedure BitBtnDeleteClick(Sender: TObject);
			procedure BitBtnEditClick(Sender: TObject);
   procedure BitBtnInsertClick(Sender: TObject);
	 procedure BitBtnPostClick(Sender: TObject);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure FormShow(Sender: TObject);
            procedure HabilitaCampos(cHabilita: boolean);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormCadastroUsuarios: TFormCadastroUsuarios;

implementation

uses
  uDataModuleDB,uPrincipal;

{$R *.lfm}

{ TFormCadastroUsuarios }
procedure TFormCadastroUsuarios.HabilitaCampos(cHabilita: boolean);
begin
  DBEditNome.ReadOnly := not cHabilita;
  DBEditLogin.ReadOnly:= not cHabilita;
  DBEditSenha.ReadOnly:= not cHabilita;
  DBCheckBoxAdmin.ReadOnly:= not cHabilita;
  DBCheckBoxStatus.ReadOnly:= not cHabilita;
  BitBtnCancel.Enabled:= cHabilita;
  BitBtnPost.Enabled:= cHabilita;
  BitBtnDelete.Enabled:= not cHabilita;
  BitBtnEdit.Enabled:= not cHabilita;
  BitBtnInsert.Enabled:= not cHabilita;
end;

procedure TFormCadastroUsuarios.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryUsuarios.Close;
  CloseAction:= caFree;
  FormCadastroUsuarios:= nil;
end;

procedure TFormCadastroUsuarios.BitBtnInsertClick(Sender: TObject);
begin
  DataModuleDB.SQLQueryUsuarios.Append;
  HabilitaCampos(True);
  DBCheckBoxAdmin.Checked:= False;
  DBCheckBoxStatus.Checked:= True;
  EditEstado.Text:= 'I';
end;

procedure TFormCadastroUsuarios.BitBtnPostClick(Sender: TObject);
var
  cPermissao: String;
  cStatus: String;
begin
  if EditEstado.Text = 'I'then
  begin
    DataModuleDB.SQLQueryUsuarios.Post;
    HabilitaCampos(False);
    EditEstado.Text:= '';
    DataModuleDB.SQLQueryUsuarios.Close;
    DataModuleDB.SQLQueryUsuarios.Open;
	end;

  if EditEstado.Text = 'E' then
  begin
    if DBCheckBoxAdmin.Checked then
    begin
      cPermissao:= 'A';
		end
    else
    begin
      cPermissao:= 'U';
		end;

    if DBCheckBoxStatus.Checked then
    begin
      cStatus:= '1';
		end
    else
    begin
      cStatus:= '0';
		end;
		DataModuleDB.SQLQueryExec.Active:= False;
    DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_USUARIOS';
    DataModuleDB.SQLQueryExec.SQL.Add(   '    SET cNOME_US = ' + '''' + DBEditNome.Text + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , cSENHA_US = ' + '''' + DBEditSenha.Text + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , cPERMISSAO_US = ' + '''' + cPermissao + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , cSTATUS_US = ' + '''' + cStatus + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE cLOGIN_US = ' + '''' + DataModuleDB.SQLQueryUsuarios.FieldByName('cLOGIN_US').AsString + '''');
    DataModuleDB.SQLQueryExec.ExecSQL;
    DataModuleDB.SQLTransaction.Active:= True;
    DataModuleDB.SQLTransaction.CommitRetaining;
    DataModuleDB.SQLQueryUsuarios.Close;
    DataModuleDB.SQLQueryUsuarios.Open;
    EditEstado.Text:= '';
    HabilitaCampos(False);
	end;
end;

procedure TFormCadastroUsuarios.BitBtnDeleteClick(Sender: TObject);
begin
  if DataModuleDB.SQLQueryUsuarios.RecordCount < 1 then
  begin
    Exit;
	end;

	if MessageDlg('Excluir usuário','Confirma a exclusão desse usuário?',mtConfirmation,mbYesNo,'') = mrYes then
  begin
    DataModuleDB.SQLQueryUsuarios.Delete;
    DataModuleDB.SQLQueryUsuarios.Close;
    DataModuleDB.SQLQueryUsuarios.Open;
	end;
end;

procedure TFormCadastroUsuarios.BitBtnCancelClick(Sender: TObject);
begin
  DataModuleDB.SQLQueryUsuarios.Cancel;
  HabilitaCampos(False);
  EditEstado.Text:= '';
end;

procedure TFormCadastroUsuarios.BitBtnEditClick(Sender: TObject);
begin
  HabilitaCampos(True);
  DBEditLogin.ReadOnly:= True;
  EditEstado.Text:= 'E';
end;

procedure TFormCadastroUsuarios.FormShow(Sender: TObject);
begin
  DataModuleDB.SQLQueryUsuarios.Open;
end;

end.

