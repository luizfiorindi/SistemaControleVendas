unit ucadastrocliente;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DbCtrls, DBGrids, StdCtrls, Buttons;

type

			{ TFormCadastroCliente }

      TFormCadastroCliente = class(TForm)
						DataSourceClientes: TDataSource;
						DBEditCEP: TDBEdit;
						DBEditUF: TDBEdit;
						DBEditCidade: TDBEdit;
						DBEditBairro: TDBEdit;
						DBEditComplemento: TDBEdit;
						DBEditNumero: TDBEdit;
						DBEditEndereco: TDBEdit;
						DBEditRazao: TDBEdit;
						DBEditCGC: TDBEdit;
						DBGridClientes: TDBGrid;
						DBNavigatorClientes: TDBNavigator;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						Label5: TLabel;
						Label6: TLabel;
						Label7: TLabel;
						Label8: TLabel;
						Label9: TLabel;
						SpeedButtonBuscar: TSpeedButton;
						procedure DBEditCGCExit(Sender: TObject);
      procedure DBNavigatorClientesClick(Sender: TObject;
									Button: TDBNavButtonType);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure FormShow(Sender: TObject);
            procedure HabilitaCampos(cHabilita: boolean);
						procedure SpeedButtonBuscarClick(Sender: TObject);
            procedure ValidaCGC();
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormCadastroCliente: TFormCadastroCliente;

implementation

uses
  uPrincipal, uDataModuleDB;

{$R *.lfm}

{ TFormCadastroCliente }

procedure TFormCadastroCliente.HabilitaCampos(cHabilita: boolean);
begin
  DBEditBairro.ReadOnly:= not cHabilita;
  DBEditCEP.ReadOnly:= not cHabilita;
  DBEditCGC.ReadOnly:= not cHabilita;
  DBEditCidade.ReadOnly:= not cHabilita;
  DBEditComplemento.ReadOnly:= not cHabilita;
  DBEditEndereco.ReadOnly:= not cHabilita;
  DBEditNumero.ReadOnly:= not cHabilita;
  DBEditRazao.ReadOnly:= not cHabilita;
  DBEditUF.ReadOnly:= not cHabilita;
  SpeedButtonBuscar.Enabled:= not cHabilita;
end;

procedure TFormCadastroCliente.ValidaCGC();
var
  cont: boolean;
begin
  cont:= True;

  if DBEditCGC.Text = '' then
  begin
    ShowMessage('Campo CNPJ/CPF não pode ser em branco!');
    DBEditCGC.SetFocus;
    cont:= False;
	end;

  if cont then
  begin
    try
      StrToFloat(DBEditCGC.Text);
	  except
      ShowMessage('Digite apenas números para o campo CNPJ/CPF!');
      DBEditCGC.SetFocus;
      cont:= False;
	  end;
	end;

  if (cont) and (Length(DBEditCGC.Text) <> 11) and (Length(DBEditCGC.Text) <> 14) then
  begin
    ShowMessage('CNPJ/CPF inválido!');
    DBEditCGC.SetFocus;
    cont:= False;
	end;
end;

procedure TFormCadastroCliente.SpeedButtonBuscarClick(Sender: TObject);
var
  cFiltro: String;
begin
  if InputQuery('Consulta Cliente','Digite o CNPJ/CPF ou Nome/Razão para consulta:',cFiltro) then
  begin
    if DataModuleDB.SQLQueryClientes.Locate('nCGC_CL',cFiltro,[loCaseInsensitive,loPartialKey]) then
    begin
      Exit;
		end;

    if not DataModuleDB.SQLQueryClientes.Locate('cRAZAO_CL',cFiltro,[loCaseInsensitive,loPartialKey]) then
    begin
      ShowMessage('Registro não encontrado');
		end;
	end;
end;

procedure TFormCadastroCliente.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryClientes.Close;
  CloseAction:= caFree;
  FormCadastroCliente:= nil;
end;

procedure TFormCadastroCliente.DBNavigatorClientesClick(Sender: TObject;
			Button: TDBNavButtonType);
var
  cHabilita: boolean;
begin
  cHabilita:= False;
  case Button of
    nbInsert: cHabilita:= True;
    nbEdit: cHabilita:= True;
    nbPost: cHabilita:= False;
    nbCancel: cHabilita:= False;
	end;
  HabilitaCampos(cHabilita);
end;

procedure TFormCadastroCliente.DBEditCGCExit(Sender: TObject);
begin
  if DBEditCGC.ReadOnly = False then
  begin
    ValidaCGC();
	end;
end;

procedure TFormCadastroCliente.FormShow(Sender: TObject);
begin
  DataModuleDB.SQLQueryClientes.Open;
end;

end.

