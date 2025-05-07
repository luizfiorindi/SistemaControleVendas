unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, fpdataexporter, Forms, Controls, Graphics,
	Dialogs, Menus, ComCtrls, fpsexport, uDataModuleDB, db;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
				FPDataExporter1: TFPDataExporter;
				FPSExport1: TFPSExport;
				MainMenuSistemadeVendas: TMainMenu;
				MenuItemRelatorioVendas: TMenuItem;
				MenuItemRelatorioEstoque: TMenuItem;
				MenuItemRelatorio: TMenuItem;
				MenuItemVendaConsulta: TMenuItem;
				MenuItemPedidoNovo: TMenuItem;
				MenuItemPedido: TMenuItem;
				MenuItemEstoqueProdutos: TMenuItem;
				MenuItemEstoque: TMenuItem;
				MenuItemProduto: TMenuItem;
				MenuItemSair: TMenuItem;
				MenuItemCadastroCategoria: TMenuItem;
				MenuItemClientes: TMenuItem;
				MenuItemUsuarios: TMenuItem;
				MenuItemCadastro: TMenuItem;
				StatusBar1: TStatusBar;
		procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
		procedure FormCreate(Sender: TObject);
		procedure FormShow(Sender: TObject);
		procedure MenuItemCadastroCategoriaClick(Sender: TObject);
		procedure MenuItemClientesClick(Sender: TObject);
		procedure MenuItemPedidoNovoClick(Sender: TObject);
		procedure MenuItemProdutoClick(Sender: TObject);
		procedure MenuItemEstoqueProdutosClick(Sender: TObject);
		procedure MenuItemRelatorioEstoqueClick(Sender: TObject);
		procedure MenuItemRelatorioVendasClick(Sender: TObject);
		procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemUsuariosClick(Sender: TObject);
		procedure MenuItemVendaConsultaClick(Sender: TObject);
    procedure ExportaXLS(FileName: String ; Consulta: TDataSet);
  private
    { private declarations }
  public
    { public declarations }
    var
      cPermissao: String;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

uses
  uCadastroUsuario, ucadastrocliente, ucadastrocategoriasubcategoria, ucadastroproduto,
  uestoqueproduto, upedido, uconsultapedido, urelatorioestoque, urelpedidos, ulogin;
{$R *.lfm}

{ TFormPrincipal }

procedure TFormPrincipal.ExportaXLS(FileName: String ; Consulta: TDataSet);
var
  Exporter: TFPSExport;
  ExporterSettings: TFPSExportFormatSettings;
begin
  try
  	Exporter:= TFPSExport.Create(Nil);
    ExporterSettings:= TFPSExportFormatSettings.Create(True);
    ExporterSettings.HeaderRow:= True;
    ExporterSettings.ExportFormat:= efXLS;
    Exporter.FormatSettings:= ExporterSettings;
    Exporter.Dataset:= Consulta;
    Exporter.FileName:= FileName;
    Exporter.Execute;
	finally
    Exporter.Free;
    ExporterSettings.Free;
	end;
  ShowMessage('Arquivo exportado com sucesso!');
end;

procedure TFormPrincipal.MenuItemUsuariosClick(Sender: TObject);
begin
  FormCadastroUsuarios := TFormCadastroUsuarios.Create(Application);
  FormCadastroUsuarios.ShowModal;
end;

procedure TFormPrincipal.MenuItemVendaConsultaClick(Sender: TObject);
begin
  FormConsultaPedidos:= TFormConsultaPedidos.Create(Application);
  FormConsultaPedidos.ShowModal;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  CloseAction:= caFree;
  FormPrincipal:= nil;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin

end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  FormLogin.ShowModal;
end;

procedure TFormPrincipal.MenuItemCadastroCategoriaClick(Sender: TObject);
begin
  FormCadastroCategoriaSubcategoria:= TFormCadastroCategoriaSubcategoria.Create(Application);
  FormCadastroCategoriaSubcategoria.ShowModal;
end;

procedure TFormPrincipal.MenuItemClientesClick(Sender: TObject);
begin
  FormCadastroCliente := TFormCadastroCliente.Create(Application);
  FormCadastroCliente.ShowModal;
end;

procedure TFormPrincipal.MenuItemPedidoNovoClick(Sender: TObject);
begin
  FormPedido:= TFormPedido.Create(Application);
  FormPedido.ShowModal;
end;

procedure TFormPrincipal.MenuItemProdutoClick(Sender: TObject);
begin
  FormCadastroProduto := TFormCadastroProduto.Create(Application);
  FormCadastroProduto.ShowModal;
end;

procedure TFormPrincipal.MenuItemEstoqueProdutosClick(Sender: TObject);
begin
  FormEstoqueProduto:= TFormEstoqueProduto.Create(Application);
  FormEstoqueProduto.ShowModal;
end;

procedure TFormPrincipal.MenuItemRelatorioEstoqueClick(Sender: TObject);
begin
  FormRelatorioEstoque:= TFormRelatorioEstoque.Create(Application);
  FormRelatorioEstoque.ShowModal;
end;

procedure TFormPrincipal.MenuItemRelatorioVendasClick(Sender: TObject);
begin
  FormRelatorioPedidos:= TFormRelatorioPedidos.Create(Application);
  FormRelatorioPedidos.ShowModal;
end;

procedure TFormPrincipal.MenuItemSairClick(Sender: TObject);
begin
  Close;
end;

end.

