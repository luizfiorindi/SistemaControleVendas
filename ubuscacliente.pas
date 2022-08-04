unit ubuscacliente;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DBGrids, StdCtrls, Buttons;

type

			{ TFormBuscaCliente }

      TFormBuscaCliente = class(TForm)
						DataSourceClientes: TDataSource;
						DBGridClientes: TDBGrid;
						EditCGC: TEdit;
						EditRazao: TEdit;
						EditCodigo: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						SpeedButtonPesquisar: TSpeedButton;
						procedure DBGridClientesDblClick(Sender: TObject);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormBuscaCliente: TFormBuscaCliente;

implementation

uses
  upedido, uDataModuleDB;

{$R *.lfm}

{ TFormBuscaCliente }

procedure TFormBuscaCliente.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryClientes.Close;
  CloseAction:= caFree;
  FormBuscaCliente:= Nil;
end;

procedure TFormBuscaCliente.DBGridClientesDblClick(Sender: TObject);
begin
  if (DataModuleDB.SQLQueryClientes.Active = True) and (DataModuleDB.SQLQueryClientes.RecordCount > 0) then
  begin
    FormPedido.EditRazao.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cRAZAO_CL').AsString;
    FormPedido.EditEndereco.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cENDERECO_CL').AsString;
    FormPedido.EditNumero.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cNUMERO_CL').AsString;
    FormPedido.EditComplemento.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCOMPLEMENTO_CL').AsString;
    FormPedido.EditBairro.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cBAIRRO_CL').AsString;
    FormPedido.EditCidade.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCIDADE_CL').AsString;
    FormPedido.EditUF.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cUF_CL').AsString;
    FormPedido.EditCEP.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCEP_CL').AsString;
    FormPedido.EditCodigoCliente.Text:= DataModuleDB.SQLQueryClientes.FieldByName('iID_CL').AsString;
    Close;
	end
  else
  begin
    ShowMessage('Nenhum registro selecionado!');
	end;
end;

procedure TFormBuscaCliente.SpeedButtonPesquisarClick(Sender: TObject);
begin
  DataModuleDB.SQLQueryClientes.Close;


  if EditCodigo.Text <> '' then
  begin
    DataModuleDB.SQLQueryClientes.ServerFiltered:= False;
    DataModuleDB.SQLQueryClientes.ServerFilter:= 'iID_CL = ' + EditCodigo.Text;
    DataModuleDB.SQLQueryClientes.ServerFiltered:= True;
    DataModuleDB.SQLQueryClientes.Open;
	end
  else
  begin
    if EditCGC.Text <> '' then
    begin
      DataModuleDB.SQLQueryClientes.ServerFiltered:= False;
      DataModuleDB.SQLQueryClientes.ServerFilter:= 'nCGC_CL = ' + '''' + EditCGC.Text + '''';
      DataModuleDB.SQLQueryClientes.ServerFiltered:= True;
      DataModuleDB.SQLQueryClientes.Open;
		end
    else
    begin
      if EditRazao.Text <> '' then
      begin
        DataModuleDB.SQLQueryClientes.ServerFiltered:= False;
        DataModuleDB.SQLQueryClientes.ServerFilter:= 'cRAZAO_CL LIKE ' + '''' + '%' + EditRazao.Text + '%' + '''';
        DataModuleDB.SQLQueryClientes.ServerFiltered:= True;
        DataModuleDB.SQLQueryClientes.Open;
		  end
      else
      begin
        DataModuleDB.SQLQueryClientes.ServerFiltered:= False;
        DataModuleDB.SQLQueryClientes.Open;
			end;
		end;
	end;
end;

end.

