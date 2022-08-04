unit upedido;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			Buttons, ComCtrls, StdCtrls, DBGrids, Menus;

type

			{ TFormPedido }

      TFormPedido = class(TForm)
						DataSourcePedidos: TDataSource;
						DataSourceItensPedido: TDataSource;
						DBGridItensPedido: TDBGrid;
						EditCodigoProduto: TEdit;
						EditDescricaoItem: TEdit;
						EditQuantidadeItem: TEdit;
						EditCEP: TEdit;
						EditCidade: TEdit;
						EditUF: TEdit;
						EditBairro: TEdit;
						EditComplemento: TEdit;
						EditNumero: TEdit;
						EditEndereco: TEdit;
						EditRazao: TEdit;
						EditCodigoCliente: TEdit;
						EditCodigoPedido: TEdit;
						Label1: TLabel;
						Label10: TLabel;
						Label11: TLabel;
						Label12: TLabel;
						Label13: TLabel;
						Label14: TLabel;
						LabelValorTotal: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						Label5: TLabel;
						Label6: TLabel;
						Label7: TLabel;
						Label8: TLabel;
						Label9: TLabel;
						MenuItemExcluir: TMenuItem;
						PageControlPedido: TPageControl;
						PopupMenuItensPedido: TPopupMenu;
						SpeedButtonSalvarPedido: TSpeedButton;
						SpeedButtonConscluirPedido: TSpeedButton;
						SpeedButtonAddItem: TSpeedButton;
						SpeedButtonPesquisaItens: TSpeedButton;
						SpeedButtonPesquisaCliente: TSpeedButton;
						SpeedButtonNovo: TSpeedButton;
						TabSheetPedido: TTabSheet;
						TabSheetItensPedido: TTabSheet;
						procedure EditCodigoClienteExit(Sender: TObject);
						procedure EditCodigoProdutoExit(Sender: TObject);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
			procedure FormShow(Sender: TObject);
			procedure MenuItemExcluirClick(Sender: TObject);
            procedure SelecionaPedido(iCodigo: Integer);
            procedure BuscaCliente(iCodigo: Integer);
						procedure SpeedButtonAddItemClick(Sender: TObject);
						procedure SpeedButtonConscluirPedidoClick(Sender: TObject);
						procedure SpeedButtonNovoClick(Sender: TObject);
						procedure SpeedButtonPesquisaClienteClick(Sender: TObject);
            procedure BuscaProduto(iCodigo: Integer);
						procedure SpeedButtonPesquisaItensClick(Sender: TObject);
						procedure SpeedButtonSalvarPedidoClick(Sender: TObject);
      private
            { private declarations }
      public
        var
          iCodigoPedido: Integer;
          cStatus: String;
            { public declarations }
      end;

var
      FormPedido: TFormPedido;

implementation

uses
  uPrincipal, uDataModuleDB, ubuscacliente, ubuscaproduto;
{$R *.lfm}

{ TFormPedido }
procedure TFormPedido.SelecionaPedido(iCodigo: Integer);
begin
  EditCodigoPedido.Text:= IntToStr(iCodigo);
  EditCodigoCliente.ReadOnly:= True;
  DataModuleDB.SQLQueryPedidos.Active:= False;
  DataModuleDB.SQLQueryPedidos.Active:= True;
  DataModuleDB.SQLQueryPedidos.Locate('iID_PE',iCodigo,[loCaseInsensitive]);
  DataModuleDB.SQLQueryItensPedido.Active:= False;
  DataModuleDB.SQLQueryItensPedido.ParamByName('iID_PEDIDO_IP').AsInteger:= iCodigo;
  DataModuleDB.SQLQueryItensPedido.Active:= True;
  if DataModuleDB.SQLQueryItensPedido.RecordCount > 0 then
  begin
    DataModuleDB.SQLQueryExec.Active:= False;
    DataModuleDB.SQLQueryExec.SQL.Text:= ' SELECT SUM(nVALOR_PRODUTO_IP * iQTDE_PRODUTO_IP)';
    DataModuleDB.SQLQueryExec.SQL.Add(   '   FROM TB_ITENS_PEDIDO');
    DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iID_PEDIDO_IP = ' + EditCodigoPedido.Text + ';');
    DataModuleDB.SQLQueryExec.Active:= True;
    LabelValorTotal.Caption:= DataModuleDB.SQLQueryExec.Fields.Fields[0].AsString;
    DataModuleDB.SQLQueryExec.Active:= False;
	end;
	EditCodigoCliente.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('iID_CLIENTE_PE').AsString;
  EditRazao.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cRAZAO_PE').AsString;
  EditEndereco.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cENDERECO_PE').AsString;
  EditNumero.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cNUMERO_PE').AsString;
  EditComplemento.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cCOMPLEMENTO_PE').AsString;
  EditBairro.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cBAIRRO_PE').AsString;
  EditCidade.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cCIDADE_PE').AsString;
  EditUF.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('cUF_PE').AsString;
  EditCEP.Text:= DataModuleDB.SQLQueryPedidos.FieldByName('nCEP_PE').AsString;
end;

procedure TFormPedido.BuscaCliente(iCodigo: Integer);
begin
  DataModuleDB.SQLQueryClientes.Close;
  DataModuleDB.SQLQueryClientes.Open;

  if DataModuleDB.SQLQueryClientes.Locate('iID_CL',iCodigo,[loCaseInsensitive]) then
  begin
    EditRazao.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cRAZAO_CL').AsString;
    EditEndereco.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cENDERECO_CL').AsString;
    EditNumero.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cNUMERO_CL').AsString;
    EditComplemento.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCOMPLEMENTO_CL').AsString;
    EditBairro.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cBAIRRO_CL').AsString;
    EditCidade.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCIDADE_CL').AsString;
    EditUF.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cUF_CL').AsString;
    EditCEP.Text:= DataModuleDB.SQLQueryClientes.FieldByName('cCEP_CL').AsString;
	end
  else
  begin
    EditRazao.Text:= '';
    EditEndereco.Text:= '';
    EditNumero.Text:= '';
    EditComplemento.Text:= '';
    EditBairro.Text:= '';
    EditCidade.Text:= '';
    EditUF.Text:= '';
    EditCEP.Text:= '';
	end;
end;

procedure TFormPedido.SpeedButtonAddItemClick(Sender: TObject);
var
  iCodPE: Integer;
  nValor: Double;
begin
  if EditCodigoPedido.Text = '' then
  begin
    ShowMessage('Salve a venda primeiro antes de inlcuir um produto!');
    Exit;
	end;

  if EditCodigoProduto.Text = '' then
  begin
    ShowMessage('Nenhum produto selecionado, verifique se o código do produto está preenchido!');
    Exit;
	end;

  if (EditQuantidadeItem.Text = '') or (EditQuantidadeItem.Text = '0') then
  begin
    ShowMessage('Informe a quantidade do produto!');
    Exit;
	end;

  if (DataModuleDB.SQLQueryItensPedido.Active = True) and (DataModuleDB.SQLQueryItensPedido.RecordCount > 0) then
  begin
    if DataModuleDB.SQLQueryItensPedido.Locate('iID_PRODUTO_IP',EditCodigoProduto.Text,[loCaseInsensitive]) then
    begin
      ShowMessage('Produto já foi adicionado!');
      Exit;
    end;
	end;

	iCodPE:= StrToInt(EditCodigoPedido.Text);

  DataModuleDB.SQLQueryProdutos.Close;
  DataModuleDB.SQLQueryProdutos.Open;
  DataModuleDB.SQLQueryProdutos.Locate('iCODIGO_PR',EditCodigoProduto.Text,[loCaseInsensitive]);
  nValor:= DataModuleDB.SQLQueryProdutos.FieldByName('nVALOR_PR').AsFloat;
  DataModuleDB.SQLQueryProdutos.Close;

  DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= ' INSERT INTO TB_ITENS_PEDIDO ( iID_PEDIDO_IP';
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             , iID_PRODUTO_IP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             , nVALOR_PRODUTO_IP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             , iQTDE_PRODUTO_IP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             , dDATA_IP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             , cLOGIN_USUARIO_IP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '                             )');
  DataModuleDB.SQLQueryExec.SQL.Add(   ' VALUES (' + IntToStr(iCodPE));
  DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + EditCodigoProduto.Text);
  DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + StringReplace(FloatToStr(nValor),',','.',[rfReplaceAll]));
  DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + EditQuantidadeItem.Text);
  DataModuleDB.SQLQueryExec.SQL.Add(   '        ,datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
  DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '        );');
  DataModuleDB.SQLTransaction.Active:= True;
  try
    DataModuleDB.SQLQueryExec.ExecSQL;
    DataModuleDB.SQLTransaction.Commit;
    ShowMessage('Produto adicionado com sucesso!');
    SelecionaPedido(iCodPE);
	except
    DataModuleDB.SQLTransaction.Rollback;
    ShowMessage('Erro ao adicionar produto!');
	end;
end;

procedure TFormPedido.SpeedButtonConscluirPedidoClick(Sender: TObject);
var
  cCodigoProd: String;
  cQuantidade: String;
begin
  if EditCodigoPedido.Text = '' then
  begin
    ShowMessage('Salve a venda antes de finalizar!');
    Exit;
	end;

  if (cStatus = 'F') or (cStatus = 'C') then
  begin
    ShowMessage('Venda não pode ser alterada!');
    Exit;
	end;

  if (DataModuleDB.SQLQueryItensPedido.Active = False) or (DataModuleDB.SQLQueryItensPedido.RecordCount < 1) then
  begin
    ShowMessage('Venda sem produtos!');
    Exit;
	end;

  if MessageDlg('Finalizar Venda','Deseja realmente finalizar essa venda?',mtConfirmation,mbYesNo,'') = mrYes then
  begin
    DataModuleDB.SQLQueryItensPedido.First;
    DataModuleDB.SQLTransaction.Active:= True;
    while not DataModuleDB.SQLQueryItensPedido.EOF do
    begin
      cCodigoProd:= DataModuleDB.SQLQueryItensPedido.FieldByName('iID_PRODUTO_IP').AsString;
      cQuantidade:= DataModuleDB.SQLQueryItensPedido.FieldByName('iQTDE_PRODUTO_IP').AsString;
      DataModuleDB.SQLQueryEstoqueProdutos.Close;
      DataModuleDB.SQLQueryEstoqueProdutos.Open;
      if DataModuleDB.SQLQueryEstoqueProdutos.Locate('iCOD_PRODUTO_EP',cCodigoProd,[loCaseInsensitive]) then
      begin
        if DataModuleDB.SQLQueryEstoqueProdutos.FieldByName('iSALDO_EP').AsInteger < StrToInt(cQuantidade) then
        begin
          DataModuleDB.SQLTransaction.Rollback;
          ShowMessage('Saldo insuficiente para o produto Código: ' + cCodigoProd + '!');
          SelecionaPedido(StrToInt(EditCodigoPedido.Text));
          Exit;
			  end;
        DataModuleDB.SQLQueryExec.Active:= False;
        DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_ESTOQUE_PRODUTOS';
        DataModuleDB.SQLQueryExec.SQL.Add(   '    SET iSALDO_EP = iSALDO_EP - ' + cQuantidade);
        DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iCOD_PRODUTO_EP = ' + cCodigoProd);
        DataModuleDB.SQLQueryExec.ExecSQL;
		  end
      else
      begin
        DataModuleDB.SQLTransaction.Rollback;
        ShowMessage('Saldo insuficiente para o produto Código: ' + cCodigoProd + '!');
        SelecionaPedido(StrToInt(EditCodigoPedido.Text));
        Exit;
			end;
			DataModuleDB.SQLQueryItensPedido.Next;
	  end;
    DataModuleDB.SQLQueryExec.Active:= False;
    DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_PEDIDOS';
    DataModuleDB.SQLQueryExec.SQL.Add(   '    SET cSTATUS_PE = ' + '''' + 'F' + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_PE = datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
    DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_PE = ' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
    DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iID_PE = ' + EditCodigoPedido.Text);
    DataModuleDB.SQLQueryExec.ExecSQL;
    DataModuleDB.SQLTransaction.Commit;
    ShowMessage('Venda finalizada com sucesso!');
    SpeedButtonNovo.Click;
	end;
end;

procedure TFormPedido.BuscaProduto(iCodigo: Integer);
begin
  DataModuleDB.SQLQueryProdutos.Close;
  DataModuleDB.SQLQueryProdutos.Open;
  if DataModuleDB.SQLQueryProdutos.Locate('iCODIGO_PR',iCodigo,[loCaseInsensitive]) then
  begin
    EditDescricaoItem.Text:= DataModuleDB.SQLQueryProdutos.FieldByName('cDESCRICAO_PR').AsString;
	end
  else
  begin
    EditDescricaoItem.Text:= '';
	end;
end;

procedure TFormPedido.SpeedButtonPesquisaItensClick(Sender: TObject);
begin
  FormBuscaProduto:= TFormBuscaProduto.Create(Application);
  FormBuscaProduto.ShowModal;
end;

procedure TFormPedido.SpeedButtonSalvarPedidoClick(Sender: TObject);
var
  iCodPE: Integer;
begin
  EditCodigoCliente.SetFocus;
  EditRazao.SetFocus;

  if (cStatus = 'F') or (cStatus = 'C') then
  begin
    ShowMessage('Venda não pode ser alterada!');
    Exit;
	end;

	if EditCodigoPedido.Text = '' then
  begin
    try
      DataModuleDB.SQLQueryExec.Active:= False;
      DataModuleDB.SQLQueryExec.SQL.Text:= ' INSERT INTO TB_PEDIDOS ( iID_CLIENTE_PE';
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cRAZAO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cENDERECO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cNUMERO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cCOMPLEMENTO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cBAIRRO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cCIDADE_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cUF_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , nCEP_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , dDATA_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cLOGIN_USUARIO_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        , cSTATUS_PE');
      DataModuleDB.SQLQueryExec.SQL.Add(   '                        )');
      DataModuleDB.SQLQueryExec.SQL.Add(   ' VALUES (' + EditCodigoCliente.Text);
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditRazao.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditEndereco.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditNumero.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditComplemento.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditBairro.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditCidade.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + EditUF.Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + EditCEP.Text);
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        ,' + '''' + 'P' + '''');
      DataModuleDB.SQLQueryExec.SQL.Add(   '        );');
      DataModuleDB.SQLTransaction.Active:= True;
      DataModuleDB.SQLQueryExec.ExecSQL;
      DataModuleDB.SQLTransaction.Commit;
      DataModuleDB.SQLQueryExec.Active:= False;
      DataModuleDB.SQLQueryExec.SQL.Text:= ' SELECT max(iID_PE) FROM TB_PEDIDOS';
      DataModuleDB.SQLQueryExec.Active:= True;
      iCodPE:= DataModuleDB.SQLQueryExec.Fields.Fields[0].AsInteger;
      DataModuleDB.SQLQueryExec.Active:= False;
      SelecionaPedido(iCodPE);
      ShowMessage('Venda Nº ' + IntToStr(iCodPE) + ' salva com sucesso!');
		except
      DataModuleDB.SQLTransaction.Rollback;
      ShowMessage('Erro ao salvar venda, verifique se os dados do cliente estão corretos!');
		end;
	end
  else
  begin
    iCodPE:= StrToInt(EditCodigoPedido.Text);
      try
		    DataModuleDB.SQLQueryExec.Active:= False;
        DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_PEDIDOS';
        DataModuleDB.SQLQueryExec.SQL.Add(   '    SET iID_CLIENTE_PE = ' + EditCodigoCliente.Text);
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cRAZAO_PE = ' + '''' + EditRazao.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cENDERECO_PE = ' + '''' + EditEndereco.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cNUMERO_PE = ' + '''' + EditNumero.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cCOMPLEMENTO_PE = ' + '''' + EditComplemento.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cBAIRRO_PE = ' + '''' + EditBairro.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cCIDADE_PE = ' + '''' + EditCidade.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cUF_PE = ' + '''' + EditUF.Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , nCEP_PE = ' + EditCEP.Text);
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_PE = datetime('+''''+'now'+''''+','+''''+'localtime'+''''+')');
        DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_PE = ' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
        DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iID_PE = ' + IntToStr(iCodPE) + ';');
        DataModuleDB.SQLTransaction.Active:= True;
        DataModuleDB.SQLQueryExec.ExecSQL;
        DataModuleDB.SQLTransaction.Commit;
        SelecionaPedido(iCodPE);
        ShowMessage('Venda Nº ' + IntToStr(iCodPE) + ' salva com sucesso!');
			except
        DataModuleDB.SQLTransaction.Rollback;
        ShowMessage('Erro ao salvar venda, verifique se os dados do cliente estão corretos!');
			end;
	end;
end;

procedure TFormPedido.SpeedButtonNovoClick(Sender: TObject);
begin
  EditCodigoCliente.Text:= '';
  EditRazao.Text:= '';
  EditEndereco.Text:= '';
  EditNumero.Text:= '';
  EditComplemento.Text:= '';
  EditBairro.Text:= '';
  EditCidade.Text:= '';
  EditUF.Text:= '';
  EditCEP.Text:= '';
  EditCodigoPedido.Text:= '';
  EditCodigoProduto.Text:= '';
  EditDescricaoItem.Text:= '';
  EditQuantidadeItem.Text:= '';
  DataModuleDB.SQLQueryItensPedido.Active:= False;
  PageControlPedido.TabIndex:= 0;
  LabelValorTotal.Caption:= '0,00';
end;

procedure TFormPedido.SpeedButtonPesquisaClienteClick(Sender: TObject);
begin
  FormBuscaCliente:= TFormBuscaCliente.Create(Application);
  FormBuscaCliente.ShowModal;
end;

procedure TFormPedido.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryPedidos.Active:= False;
  DataModuleDB.SQLQueryItensPedido.Active:= False;
  DataModuleDB.SQLQueryClientes.Close;
  CloseAction:= caFree;
  FormPedido:= Nil;
end;

procedure TFormPedido.FormShow(Sender: TObject);
begin
  if iCodigoPedido > 0 then
  begin
    SelecionaPedido(iCodigoPedido);
	end;
end;

procedure TFormPedido.MenuItemExcluirClick(Sender: TObject);
begin
  if MessageDlg('Excluir Produto','Confirma a exclusão do produto?',mtConfirmation,mbYesNo,'') <> mrYes then
  begin
    Exit;
	end;

	if (DataModuleDB.SQLQueryItensPedido.Active = True) and (DataModuleDB.SQLQueryItensPedido.RecordCount > 0) then
  begin
    DataModuleDB.SQLQueryExec.Active:= False;
    DataModuleDB.SQLQueryExec.SQL.Text:= ' DELETE';
    DataModuleDB.SQLQueryExec.SQL.Add(   '   FROM TB_ITENS_PEDIDO');
    DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iID_IP = ' + DataModuleDB.SQLQueryItensPedido.FieldByName('iID_IP').AsString + ';');
    DataModuleDB.SQLTransaction.Active:= True;
    try
      DataModuleDB.SQLQueryExec.ExecSQL;
      DataModuleDB.SQLTransaction.Commit;
      SelecionaPedido(StrToInt(EditCodigoPedido.Text));
		except
      DataModuleDB.SQLTransaction.Rollback;
      ShowMessage('Erro ao excluir produto!');
		end;
	end;
end;

procedure TFormPedido.EditCodigoClienteExit(Sender: TObject);
begin
  if (EditCodigoPedido.Text = '') and (EditCodigoCliente.Text <> '') then
  begin
    BuscaCliente(StrToInt(EditCodigoCliente.Text));
	end;

  if (EditCodigoPedido.Text = '') and (EditCodigoCliente.Text = '') then
  begin
    BuscaCliente(StrToInt('0'));
  end;
end;

procedure TFormPedido.EditCodigoProdutoExit(Sender: TObject);
begin
  if EditCodigoProduto.Text <> '' then
  begin
    BuscaProduto(StrToInt(EditCodigoProduto.Text));
	end
  else
  begin
    EditDescricaoItem.Text:= '';
	end;
end;

end.

