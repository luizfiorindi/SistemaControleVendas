unit uestoqueproduto;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls, Graphics,
			Dialogs, DBGrids, StdCtrls, DbCtrls, Buttons;

type

			{ TFormEstoqueProduto }

      TFormEstoqueProduto = class(TForm)
						DataSourceCategoria: TDataSource;
						DataSourceSubCategoria: TDataSource;
						DataSourceConsultaEstoque: TDataSource;
						DataSourceEstoqueProduto: TDataSource;
						DBGridConsultaEstoque: TDBGrid;
						DBLookupComboBoxCategoria: TDBLookupComboBox;
						DBLookupComboBoxSubCategoria: TDBLookupComboBox;
						EditDescricao: TEdit;
						EditCodigo: TEdit;
						GroupBoxPesquisa: TGroupBox;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						SpeedButtonAdd: TSpeedButton;
						SpeedButtonMinor: TSpeedButton;
						SpeedButtonLimpar: TSpeedButton;
						SpeedButtonPesquisar: TSpeedButton;
						SQLQueryConsultaEstoque: TSQLQuery;
			procedure DBLookupComboBoxCategoriaChange(Sender: TObject);
			procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
			procedure FormCreate(Sender: TObject);
			procedure SpeedButtonAddClick(Sender: TObject);
      procedure SpeedButtonLimparClick(Sender: TObject);
			procedure SpeedButtonMinorClick(Sender: TObject);
			procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormEstoqueProduto: TFormEstoqueProduto;

implementation

uses
  uPrincipal, uDataModuleDB;
{$R *.lfm}

{ TFormEstoqueProduto }

procedure TFormEstoqueProduto.SpeedButtonLimparClick(Sender: TObject);
begin
  EditCodigo.Text:= '';
  EditDescricao.Text:= '';
  DBLookupComboBoxCategoria.KeyValue:= Null;
  DBLookupComboBoxSubCategoria.KeyValue:= Null;
end;

procedure TFormEstoqueProduto.SpeedButtonMinorClick(Sender: TObject);
var
  iSaldo: Integer;
  cSaldoSub: String;
begin
  if (SQLQueryConsultaEstoque.RecordCount < 1) or (SQLQueryConsultaEstoque.FieldByName('iCODIGO_PR').AsString = '') then
  begin
    ShowMessage('Nenhum registro selecionado!');
    Exit;
	end;

  iSaldo:= SQLQueryConsultaEstoque.FieldByName('iSALDO_EP').AsInteger;

  if InputQuery('Subtrair Saldo','Digite a quantidade que deseja subtrair',cSaldoSub) then
  begin
    iSaldo:= iSaldo - StrToInt(cSaldoSub);
    if iSaldo < 0 then
    begin
      ShowMessage('Saldo insuficiente para a subtração solicitada!');
      Exit;
		end;

    DataModuleDB.SQLQueryExec.Active:= False;
    DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_ESTOQUE_PRODUTOS';
    DataModuleDB.SQLQueryExec.SQL.Add(   '    SET iSALDO_EP = ' + IntToStr(iSaldo));
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_ALTERA_EP = datetime(' + '''' + 'now' + '''' + ',' + '''' + 'localtime' + '''' + ')');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_EP = ' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iCOD_PRODUTO_EP = ' + SQLQueryConsultaEstoque.FieldByName('iCODIGO_PR').AsString);
    try
      DataModuleDB.SQLTransaction.Active:= True;
      DataModuleDB.SQLQueryExec.ExecSQL;
      DataModuleDB.SQLTransaction.Commit;
      ShowMessage('Saldo alterado com sucesso!');
      SQLQueryConsultaEstoque.Active:= False;
      SQLQueryConsultaEstoque.Active:= True;
		except
      DataModuleDB.SQLTransaction.Rollback;
      ShowMessage('Erro ao tentar alterar registro!');
		end;
	end;
end;

procedure TFormEstoqueProduto.SpeedButtonPesquisarClick(Sender: TObject);
var
  cSQL: String;
  cFiltros: String;
begin
  cSQL:= ' SELECT TB_PRODUTOS.iCODIGO_PR'
       + '      , TB_PRODUTOS.cDESCRICAO_PR'
       + '      , IFNULL(TB_ESTOQUE_PRODUTOS.iSALDO_EP,0) AS iSALDO_EP'
       + '      , TB_ESTOQUE_PRODUTOS.dDATA_ALTERA_EP'
       + '      , TB_ESTOQUE_PRODUTOS.cLOGIN_USUARIO_EP'
       + '   FROM TB_PRODUTOS'
       + '        LEFT JOIN TB_ESTOQUE_PRODUTOS ON TB_ESTOQUE_PRODUTOS.iCOD_PRODUTO_EP = TB_PRODUTOS.iCODIGO_PR'
       + '  WHERE 1=1';

  if EditCodigo.Text <> '' then
  begin
    cFiltros:= ' AND TB_PRODUTOS.iCODIGO_PR = ' + EditCodigo.Text;
	end;

  if EditDescricao.Text <> '' then
  begin
    cFiltros:= cFiltros + ' AND TB_PRODUTOS.cDESCRICAO_PR LIKE ' + '''' + '%' + EditDescricao.Text + '%' + '''';
	end;

  if DBLookupComboBoxCategoria.KeyValue <> Null then
  begin
    cFiltros:= cFiltros + ' AND TB_PRODUTOS.iID_CATEGORIA_PR = ' + IntToStr(DBLookupComboBoxCategoria.KeyValue);
	end;

  if DBLookupComboBoxSubCategoria.KeyValue <> Null then
  begin
    cFiltros:= cFiltros + ' AND TB_PRODUTOS.iID_SUBCATEGORIA_PR = ' + IntToStr(DBLookupComboBoxSubCategoria.KeyValue);
	end;

  if cFiltros <> '' then
  begin
    cSQL:= cSQL + cFiltros;
	end;

  SQLQueryConsultaEstoque.Active:= False;
  SQLQueryConsultaEstoque.SQL.Text:= cSQL;
  SQLQueryConsultaEstoque.Active:= True;

end;

procedure TFormEstoqueProduto.DBLookupComboBoxCategoriaChange(Sender: TObject);
begin
    DataModuleDB.SQLQuerySubCategoria.Close;
    DataModuleDB.SQLQuerySubCategoria.Filtered:= False;
    DataModuleDB.SQLQuerySubCategoria.Filter:= 'iID_CATEGORIA_SC = ' + IntToStr(DBLookupComboBoxCategoria.KeyValue);
    DataModuleDB.SQLQuerySubCategoria.Filtered:= True;
    DataModuleDB.SQLQuerySubCategoria.Open;
end;

procedure TFormEstoqueProduto.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryCategoria.Close;
  DataModuleDB.SQLQuerySubCategoria.Close;
  DataModuleDB.SQLQueryEstoqueProdutos.Close;
  SQLQueryConsultaEstoque.Close;
  CloseAction:= caFree;
  FormEstoqueProduto:= Nil;
end;

procedure TFormEstoqueProduto.FormCreate(Sender: TObject);
begin
  DataModuleDB.SQLQueryCategoria.Open;
end;

procedure TFormEstoqueProduto.SpeedButtonAddClick(Sender: TObject);
var
  iSaldo: Integer;
  cSaldoAdd: String;
begin
  if (SQLQueryConsultaEstoque.RecordCount < 1) or (SQLQueryConsultaEstoque.FieldByName('iCODIGO_PR').AsString = '') then
  begin
    ShowMessage('Nenhum registro selecionado!');
    Exit;
	end;

  iSaldo:= SQLQueryConsultaEstoque.FieldByName('iSALDO_EP').AsInteger;

  if InputQuery('Adicionar Saldo','Informe a quantidade que deve ser adicionada ao produto',cSaldoAdd) then
  begin
    iSaldo:= iSaldo + StrToInt(cSaldoAdd);

    if SQLQueryConsultaEstoque.FieldByName('dDATA_ALTERA_EP').AsString = '' then
    begin
      DataModuleDB.SQLQueryExec.Active:= False;
      DataModuleDB.SQLQueryExec.SQL.Text := ' INSERT INTO TB_ESTOQUE_PRODUTOS ( iCOD_PRODUTO_EP';
      DataModuleDB.SQLQueryExec.SQL.Add(    '                                 , iSALDO_EP');
      DataModuleDB.SQLQueryExec.SQL.Add(    '                                 , dDATA_ALTERA_EP');
      DataModuleDB.SQLQueryExec.SQL.Add(    '                                 , cLOGIN_USUARIO_EP');
      DataModuleDB.SQLQueryExec.SQL.Add(    '                                 )');
      DataModuleDB.SQLQueryExec.SQL.Add(    ' VALUES (' + SQLQueryConsultaEstoque.FieldByName('iCODIGO_PR').AsString);
      DataModuleDB.SQLQueryExec.SQL.Add(    '        ,' + IntToStr(iSaldo));
      DataModuleDB.SQLQueryExec.SQL.Add(    '        ,datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
      DataModuleDB.SQLQueryExec.SQL.Add(    '        ,' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(    '        );');
      try
        DataModuleDB.SQLTransaction.Active:= True;
        DataModuleDB.SQLQueryExec.ExecSQL;
        DataModuleDB.SQLTransaction.Commit;
        ShowMessage('Quantidade adicionada com sucesso!');
        SQLQueryConsultaEstoque.Active:= False;
        SQLQueryConsultaEstoque.Active:= True;
			except
        DataModuleDB.SQLTransaction.Rollback;
        ShowMessage('Erro ao tentar salvar dados!');
			end;
		end
    else
    begin
      DataModuleDB.SQLQueryExec.Active:= False;
      DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_ESTOQUE_PRODUTOS';
      DataModuleDB.SQLQueryExec.SQL.Add(   '    SET iSALDO_EP = ' + IntToStr(iSaldo));
      DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_ALTERA_EP = datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
      DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_EP = ' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iCOD_PRODUTO_EP = ' + SQLQueryConsultaEstoque.FieldByName('iCODIGO_PR').AsString);
      try
        DataModuleDB.SQLTransaction.Active:= True;
        DataModuleDB.SQLQueryExec.ExecSQL;
        DataModuleDB.SQLTransaction.Commit;
        ShowMessage('Quantidade adicionada com sucesso!');
        SQLQueryConsultaEstoque.Active:= False;
        SQLQueryConsultaEstoque.Active:= True;
			except
        DataModuleDB.SQLTransaction.Rollback;
        ShowMessage('Erro ao tentar salvar dados!');
			end;
		end;
	end;
end;

end.

