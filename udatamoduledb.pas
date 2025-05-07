unit uDataModuleDB;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, sqlite3conn, FileUtil, sqlscript, db;

type

  { TDataModuleDB }

  TDataModuleDB = class(TDataModule)
    SQLite3Connection: TSQLite3Connection;
		SQLQueryRelPedidos: TSQLQuery;
		SQLQueryConsultaPedido: TSQLQuery;
		SQLQueryConsultaPedidocCIDADE_PE1: TStringField;
		SQLQueryConsultaPedidocLOGIN_USUARIO_PE1: TStringField;
		SQLQueryConsultaPedidocRAZAO_PE1: TStringField;
		SQLQueryConsultaPedidocSTATUS_PE1: TStringField;
		SQLQueryConsultaPedidocUF_PE1: TStringField;
		SQLQueryConsultaPedidodDATA_PE1: TDateTimeField;
		SQLQueryConsultaPedidoiID_PE1: TLongintField;
		SQLQueryConsultaPedidoSTATUS_PE1: TStringField;
		SQLQueryItensPedidocDESCRICAO_PR1: TStringField;
		SQLQueryItensPedidocLOGIN_USUARIO_IP1: TStringField;
		SQLQueryItensPedidodDATA_IP1: TDateTimeField;
		SQLQueryItensPedidoiID_IP1: TLongintField;
		SQLQueryItensPedidoiID_PEDIDO_IP1: TLongintField;
		SQLQueryItensPedidoiID_PRODUTO_IP1: TLongintField;
		SQLQueryItensPedidoiQTDE_PRODUTO_IP1: TLongintField;
		SQLQueryItensPedidonVALOR_PRODUTO_IP1: TFloatField;
		SQLQueryPedidos: TSQLQuery;
		SQLQueryItensPedido: TSQLQuery;
		SQLQueryExec: TSQLQuery;
		SQLQueryEstoqueProdutos: TSQLQuery;
		SQLQueryEstoqueProdutoscLOGIN_USUARIO_EP1: TStringField;
		SQLQueryEstoqueProdutosdDATA_ALTERA_EP1: TDateTimeField;
		SQLQueryEstoqueProdutosiCOD_PRODUTO_EP1: TLongintField;
		SQLQueryEstoqueProdutosiSALDO_EP1: TLongintField;
		SQLQueryPedidoscBAIRRO_PE1: TStringField;
		SQLQueryPedidoscCIDADE_PE1: TStringField;
		SQLQueryPedidoscCOMPLEMENTO_PE1: TStringField;
		SQLQueryPedidoscENDERECO_PE1: TStringField;
		SQLQueryPedidoscLOGIN_USUARIO_PE1: TStringField;
		SQLQueryPedidoscNUMERO_PE1: TStringField;
		SQLQueryPedidoscRAZAO_PE1: TStringField;
		SQLQueryPedidoscSTATUS_PE1: TStringField;
		SQLQueryPedidoscUF_PE1: TStringField;
		SQLQueryPedidosdDATA_PE1: TDateTimeField;
		SQLQueryPedidosiID_CLIENTE_PE1: TLongintField;
		SQLQueryPedidosiID_PE1: TLongintField;
		SQLQueryPedidosnCEP_PE1: TFloatField;
		SQLQueryProdutos: TSQLQuery;
		SQLQueryProdutoscDESCRICAO_PR1: TStringField;
		SQLQueryProdutosiCODIGO_PR1: TLongintField;
		SQLQueryProdutosiID_CATEGORIA_PR1: TLongintField;
		SQLQueryProdutosiID_SUBCATEGORIA_PR1: TLongintField;
		SQLQueryProdutosnVALOR_PR1: TFloatField;
		SQLQueryRelPedidoscBAIRRO_PE1: TStringField;
		SQLQueryRelPedidoscCIDADE_PE1: TStringField;
		SQLQueryRelPedidoscCOMPLEMENTO_PE1: TStringField;
		SQLQueryRelPedidoscDESCRICAO_PR1: TStringField;
		SQLQueryRelPedidoscENDERECO_PE1: TStringField;
		SQLQueryRelPedidoscLOGIN_USUARIO_PE1: TStringField;
		SQLQueryRelPedidoscNUMERO_PE1: TStringField;
		SQLQueryRelPedidoscRAZAO_PE1: TStringField;
		SQLQueryRelPedidoscSTATUS_PE1: TStringField;
		SQLQueryRelPedidoscUF_PE1: TStringField;
		SQLQueryRelPedidosdDATA_PE1: TDateTimeField;
		SQLQueryRelPedidosiID_PE1: TLongintField;
		SQLQueryRelPedidosiID_PRODUTO_IP1: TLongintField;
		SQLQueryRelPedidosiQTDE_PRODUTO_IP1: TLongintField;
		SQLQueryRelPedidosnCEP_PE1: TFloatField;
		SQLQueryRelPedidosnVALOR_PRODUTO_IP1: TFloatField;
		SQLQueryRelPedidosSTATUS1: TStringField;
		SQLQuerySubCategoria: TSQLQuery;
		SQLQueryCategoria: TSQLQuery;
		SQLQueryCategoriacDESCRICAO_CA1: TStringField;
		SQLQueryCategoriaiID_CA1: TLongintField;
		SQLQueryClientes: TSQLQuery;
		SQLQueryClientescBAIRRO_CL1: TStringField;
		SQLQueryClientescCEP_CL1: TStringField;
		SQLQueryClientescCIDADE_CL1: TStringField;
		SQLQueryClientescCOMPLEMENTO_CL1: TStringField;
		SQLQueryClientescENDERECO_CL1: TStringField;
		SQLQueryClientescNUMERO_CL1: TStringField;
		SQLQueryClientescRAZAO_CL1: TStringField;
		SQLQueryClientescUF_CL1: TStringField;
		SQLQueryClientesiID_CL1: TLongintField;
		SQLQueryClientesnCGC_CL1: TStringField;
		SQLQuerySubCategoriacDESCRICAO_SC1: TStringField;
		SQLQuerySubCategoriaiID_CATEGORIA_SC1: TLongintField;
		SQLQuerySubCategoriaiID_SC1: TLongintField;
		SQLQueryUsuarios: TSQLQuery;
		SQLQueryUsuarioscLOGIN_US1: TStringField;
		SQLQueryUsuarioscNOME_US1: TStringField;
		SQLQueryUsuarioscPERMISSAO_US1: TStringField;
		SQLQueryUsuarioscSENHA_US1: TStringField;
		SQLQueryUsuarioscSTATUS_US1: TStringField;
    SQLScriptTabelas: TSQLScript;
    SQLTransaction: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
		procedure SQLQueryCategoriaAfterDelete(DataSet: TDataSet);
		procedure SQLQueryCategoriaAfterPost(DataSet: TDataSet);
		procedure SQLQueryClientesAfterDelete(DataSet: TDataSet);
		procedure SQLQueryClientesAfterPost(DataSet: TDataSet);
		procedure SQLQueryConsultaPedidoCalcFields(DataSet: TDataSet);
		procedure SQLQueryProdutosAfterDelete(DataSet: TDataSet);
		procedure SQLQueryProdutosAfterPost(DataSet: TDataSet);
		procedure SQLQueryRelPedidosCalcFields(DataSet: TDataSet);
		procedure SQLQuerySubCategoriaAfterDelete(DataSet: TDataSet);
		procedure SQLQuerySubCategoriaAfterPost(DataSet: TDataSet);
		procedure SQLQueryUsuariosAfterDelete(DataSet: TDataSet);
		procedure SQLQueryUsuariosAfterPost(DataSet: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DataModuleDB: TDataModuleDB;

implementation

{$R *.lfm}

{ TDataModuleDB }

procedure TDataModuleDB.DataModuleCreate(Sender: TObject);
var
  cCaminhoSQLite: String;
begin
  cCaminhoSQLite:= 'banco.db';
  if not FileExists(cCaminhoSQLite) then
  begin
    SQLite3Connection.DatabaseName:= cCaminhoSQLite;
    SQLite3Connection.Connected:= True;
    try
      SQLScriptTabelas.ExecuteScript;
      SQLTransaction.Commit;
    except
      SQLTransaction.Rollback;
    end;
  end
  else
  begin
    SQLite3Connection.DatabaseName:= cCaminhoSQLite;
  end;
end;

procedure TDataModuleDB.SQLQueryCategoriaAfterDelete(DataSet: TDataSet);
var posicao: TBookMark;
begin
  try
    posicao:= SQLQueryCategoria.GetBookmark;
    SQLQueryCategoria.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryCategoria.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryCategoriaAfterPost(DataSet: TDataSet);
var posicao: TBookMark;
begin
  try
    posicao:= SQLQueryCategoria.GetBookmark;
    SQLQueryCategoria.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryCategoria.GotoBookmark(posicao);
      SQLQueryCategoria.Refresh;
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryClientesAfterDelete(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryClientes.GetBookmark;
    SQLQueryClientes.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryClientes.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;

end;

procedure TDataModuleDB.SQLQueryClientesAfterPost(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryClientes.GetBookmark;
    SQLQueryClientes.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryClientes.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;

end;

procedure TDataModuleDB.SQLQueryConsultaPedidoCalcFields(DataSet: TDataSet);
begin
  if DataSet.FieldByName('cSTATUS_PE').AsString = 'F' then
  begin
    DataSet.FieldByName('STATUS_PE').Value:= 'Finalizada';
	end
  else
  begin
    if DataSet.FieldByName('cSTATUS_PE').AsString = 'P' then
    begin
      DataSet.FieldByName('STATUS_PE').Value:= 'Pendente';
		end
    else
    begin
      if DataSet.FieldByName('cSTATUS_PE').AsString = 'C' then
      begin
        DataSet.FieldByName('STATUS_PE').Value:= 'Cancelada';
			end;
		end;
	end;
end;

procedure TDataModuleDB.SQLQueryProdutosAfterDelete(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryProdutos.GetBookmark;
    SQLQueryProdutos.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryProdutos.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryProdutosAfterPost(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryProdutos.GetBookmark;
    SQLQueryProdutos.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryProdutos.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryRelPedidosCalcFields(DataSet: TDataSet);
begin
  if DataSet.FieldByName('cSTATUS_PE').AsString = 'P' then
  begin
    DataSet.FieldByName('STATUS').Value:= 'Pendente';
	end
  else
  begin
    if DataSet.FieldByName('cSTATUS_PE').AsString = 'F' then
    begin
      DataSet.FieldByName('STATUS').Value:= 'Finalizado';
		end
    else
    begin
      if DataSet.FieldByName('cSTATUS_PE').AsString = 'C' then
      begin
        DataSet.FieldByName('STATUS').Value:= 'Cancelado';
			end;
    end;
	end;
end;

procedure TDataModuleDB.SQLQuerySubCategoriaAfterDelete(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQuerySubCategoria.GetBookmark;
    SQLQuerySubCategoria.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQuerySubCategoria.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQuerySubCategoriaAfterPost(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQuerySubCategoria.GetBookmark;
    SQLQuerySubCategoria.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQuerySubCategoria.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryUsuariosAfterDelete(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryUsuarios.GetBookmark;
    SQLQueryUsuarios.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryUsuarios.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

procedure TDataModuleDB.SQLQueryUsuariosAfterPost(DataSet: TDataSet);
var
  posicao: TBookMark;
begin
  try
    posicao:= SQLQueryUsuarios.GetBookmark;
		SQLQueryUsuarios.ApplyUpdates;
    if SQLTransaction.Active then
    begin
      SQLTransaction.CommitRetaining;
      SQLQueryUsuarios.GotoBookmark(posicao);
		end;
	except
    SQLTransaction.Rollback;
	end;
end;

end.

