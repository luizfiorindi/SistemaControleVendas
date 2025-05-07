unit ubuscaproduto;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DBGrids, StdCtrls, DbCtrls, Buttons;

type

			{ TFormBuscaProduto }

      TFormBuscaProduto = class(TForm)
						DataSourceCategoria: TDataSource;
						DataSourceSubCategoria: TDataSource;
						DataSourceProdutos: TDataSource;
						DBGridProdutos: TDBGrid;
						DBLookupComboBoxCategoria: TDBLookupComboBox;
						DBLookupComboBoxSubCategoria: TDBLookupComboBox;
						EditDescricao: TEdit;
						EditCodigo: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						Label5: TLabel;
						SpeedButtonPesquisar: TSpeedButton;
						procedure DBGridProdutosDblClick(Sender: TObject);
      procedure DBLookupComboBoxCategoriaChange(Sender: TObject);
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure FormCreate(Sender: TObject);
						procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormBuscaProduto: TFormBuscaProduto;

implementation

uses
  upedido, uDataModuleDB;

{$R *.lfm}

{ TFormBuscaProduto }

procedure TFormBuscaProduto.DBLookupComboBoxCategoriaChange(Sender: TObject);
begin
  if (DataModuleDB.SQLQueryCategoria.RecordCount >= 1) and (DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsString <> '') then
  begin
    DataModuleDB.SQLQuerySubCategoria.Close;
    DataModuleDB.SQLQuerySubCategoria.Filtered:= False;
    DataModuleDB.SQLQuerySubCategoria.Filter:= 'iID_CATEGORIA_SC = ' + IntToStr(DBLookupComboBoxCategoria.KeyValue);
    DataModuleDB.SQLQuerySubCategoria.Filtered:= True;
    DataModuleDB.SQLQuerySubCategoria.Open;
  end;
end;

procedure TFormBuscaProduto.DBGridProdutosDblClick(Sender: TObject);
begin
  if (DataModuleDB.SQLQueryProdutos.Active = True) and (DataModuleDB.SQLQueryProdutos.RecordCount > 0) then
  begin
    FormPedido.EditCodigoProduto.Text:= DataModuleDB.SQLQueryProdutos.FieldByName('iCODIGO_PR').AsString;
    FormPedido.EditDescricaoItem.Text:= DataModuleDB.SQLQueryProdutos.FieldByName('cDESCRICAO_PR').AsString;
    Close;
	end
  else
  begin
    ShowMessage('Nenhum registro selecionado!');
	end;
end;

procedure TFormBuscaProduto.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryProdutos.Close;
  DataModuleDB.SQLQueryCategoria.Close;
  DataModuleDB.SQLQuerySubCategoria.Close;
  CloseAction:= caFree;
  FormBuscaProduto:= Nil;
end;

procedure TFormBuscaProduto.FormCreate(Sender: TObject);
begin
  DataModuleDB.SQLQueryCategoria.Open;
end;

procedure TFormBuscaProduto.SpeedButtonPesquisarClick(Sender: TObject);
begin
  DataModuleDB.SQLQueryProdutos.Close;
  if EditCodigo.Text <> '' then
  begin
    DataModuleDB.SQLQueryProdutos.ServerFiltered:= False;
    DataModuleDB.SQLQueryProdutos.ServerFilter:= 'iCODIGO_PR = ' + EditCodigo.Text;
    DataModuleDB.SQLQueryProdutos.ServerFiltered:= True;
    DataModuleDB.SQLQueryProdutos.Open;
	end
  else
  begin
    if EditDescricao.Text <> '' then
    begin
      DataModuleDB.SQLQueryProdutos.ServerFiltered:= False;
      DataModuleDB.SQLQueryProdutos.ServerFilter:= 'cDESCRICAO_PR LIKE ' + '''' + '%' + EditDescricao.Text + '%' + '''';
      DataModuleDB.SQLQueryProdutos.ServerFiltered:= True;
      DataModuleDB.SQLQueryProdutos.Open;
		end
    else
    begin
      if (DBLookupComboBoxCategoria.KeyValue > 0) and (DBLookupComboBoxSubCategoria.KeyValue < 1) then
      begin
        DataModuleDB.SQLQueryProdutos.ServerFiltered:= False;
        DataModuleDB.SQLQueryProdutos.ServerFilter:= 'iID_CATEGORIA_PR = ' + IntToStr(DBLookupComboBoxCategoria.KeyValue);
        DataModuleDB.SQLQueryProdutos.ServerFiltered:= True;
        DataModuleDB.SQLQueryProdutos.Open;
			end
      else
      begin
        if DBLookupComboBoxSubCategoria.KeyValue > 0 then
        begin
          DataModuleDB.SQLQueryProdutos.ServerFiltered:= False;
          DataModuleDB.SQLQueryProdutos.ServerFilter:= 'iID_SUBCATEGORIA_PR = ' + IntToStr(DBLookupComboBoxSubCategoria.KeyValue);
          DataModuleDB.SQLQueryProdutos.ServerFiltered:= True;
          DataModuleDB.SQLQueryProdutos.Open;
				end
        else
        begin
          DataModuleDB.SQLQueryProdutos.ServerFiltered:= False;
          DataModuleDB.SQLQueryProdutos.Open;
				end;
			end;
		end;
	end;
end;

end.

