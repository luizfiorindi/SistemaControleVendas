unit urelpedidos;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DBGrids, MaskEdit, StdCtrls, Buttons;

type

			{ TFormRelatorioPedidos }

      TFormRelatorioPedidos = class(TForm)
						CheckBoxComItens: TCheckBox;
						DataSourceRelPedidos: TDataSource;
						DBGridRelPedidos: TDBGrid;
						Label1: TLabel;
						Label2: TLabel;
						MaskEditDataIni: TMaskEdit;
						MaskEditDataFim: TMaskEdit;
						SaveDialog1: TSaveDialog;
						SpeedButtonExportarXLS: TSpeedButton;
						SpeedButtonPesquisar: TSpeedButton;
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure SpeedButtonExportarXLSClick(Sender: TObject);
						procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormRelatorioPedidos: TFormRelatorioPedidos;

implementation

uses
  uPrincipal, uDataModuleDB;

{$R *.lfm}

{ TFormRelatorioPedidos }

procedure TFormRelatorioPedidos.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryRelPedidos.Active:= False;
  CloseAction:= caFree;
  FormRelatorioPedidos:= Nil;
end;

procedure TFormRelatorioPedidos.SpeedButtonExportarXLSClick(Sender: TObject);
var
  FileName: String;
begin
  if (DataModuleDB.SQLQueryRelPedidos.Active = False) or (DataModuleDB.SQLQueryRelPedidos.RecordCount < 1) then
  begin
    ShowMessage('Sem registros para exportar!');
    Exit;
	end;

  if SaveDialog1.Execute then
  begin
     FileName:= ChangeFileExt(SaveDialog1.FileName,'.xls');
     FormPrincipal.ExportaXLS(FileName,DataModuleDB.SQLQueryRelPedidos);
	end;
end;

procedure TFormRelatorioPedidos.SpeedButtonPesquisarClick(Sender: TObject);
var
  cData: String;
begin
  if CheckBoxComItens.Checked then
  begin
    DataModuleDB.SQLQueryRelPedidos.Active:= False;
    DataModuleDB.SQLQueryRelPedidos.SQL.Text:= ' SELECT iID_PE AS COD_VENDA';
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cRAZAO_PE AS DESTINATARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cENDERECO_PE AS ENDERECO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cNUMERO_PE AS NUMERO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cCOMPLEMENTO_PE AS COMPLEMENTO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cBAIRRO_PE AS BAIRRO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cCIDADE_PE AS CIDADE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cUF_PE AS UF');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , nCEP_PE AS CEP');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , dDATA_PE AS DATA');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cLOGIN_USUARIO_PE AS USUARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cSTATUS_PE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , iID_PRODUTO_IP AS COD_PRODUTO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cDESCRICAO_PR AS DESCRICAO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , nVALOR_PRODUTO_IP AS VALOR_UNITARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , iQTDE_PRODUTO_IP AS QUANTIDADE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '   FROM TB_PEDIDOS');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '        INNER JOIN TB_ITENS_PEDIDO ON TB_ITENS_PEDIDO.iID_PEDIDO_IP = TB_PEDIDOS.iID_PE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '        INNER JOIN TB_PRODUTOS ON TB_ITENS_PEDIDO.iID_PRODUTO_IP = TB_PRODUTOS.iCODIGO_PR');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '  WHERE 1=1');

    if MaskEditDataIni.Text <> '' then
    begin
      cData:= Copy(MaskEditDataIni.Text,5,4) + '-' + Copy(MaskEditDataIni.Text,3,2) + '-' + Copy(MaskEditDataIni.Text,1,2);
      DataModuleDB.SQLQueryRelPedidos.SQL.Add( ' AND dDATA_PE >= ' + '''' + cData + '''');
		end;

    if MaskEditDataFim.Text <> '' then
    begin
      cData:= Copy(MaskEditDataFim.Text,5,4) + '-' + Copy(MaskEditDataFim.Text,3,2) + '-' + Copy(MaskEditDataFim.Text,1,2) + ' 23:59:59';
      DataModuleDB.SQLQueryRelPedidos.SQL.Add( ' AND dDATA_PE <= ' + '''' + cData + '''');
		end;

    DataModuleDB.SQLQueryRelPedidos.Active:= True;
	end
  else
  begin
    DataModuleDB.SQLQueryRelPedidos.Active:= False;
    DataModuleDB.SQLQueryRelPedidos.SQL.Text:= ' SELECT iID_PE AS COD_VENDA';
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cRAZAO_PE AS DESTINATARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cENDERECO_PE AS ENDERECO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cNUMERO_PE AS NUMERO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cCOMPLEMENTO_PE AS COMPLEMENTO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cBAIRRO_PE AS BAIRRO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cCIDADE_PE AS CIDADE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cUF_PE AS UF');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , nCEP_PE AS CEP');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , dDATA_PE AS DATA');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cLOGIN_USUARIO_PE AS USUARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cSTATUS_PE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , iID_PRODUTO_IP AS COD_PRODUTO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , cDESCRICAO_PR AS DESCRICAO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , nVALOR_PRODUTO_IP AS VALOR_UNITARIO');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '      , iQTDE_PRODUTO_IP AS QUANTIDADE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '   FROM TB_PEDIDOS');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '        LEFT JOIN TB_ITENS_PEDIDO ON TB_ITENS_PEDIDO.iID_PEDIDO_IP = TB_PEDIDOS.iID_PE');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '        LEFT JOIN TB_PRODUTOS ON TB_ITENS_PEDIDO.iID_PRODUTO_IP = TB_PRODUTOS.iCODIGO_PR');
    DataModuleDB.SQLQueryRelPedidos.SQL.Add(   '  WHERE 1=1');

    if MaskEditDataIni.Text <> '' then
    begin
      cData:= Copy(MaskEditDataIni.Text,5,4) + '-' + Copy(MaskEditDataIni.Text,3,2) + '-' + Copy(MaskEditDataIni.Text,1,2);
      DataModuleDB.SQLQueryRelPedidos.SQL.Add( ' AND dDATA_PE >= ' + '''' + cData + '''');
		end;

    if MaskEditDataFim.Text <> '' then
    begin
      cData:= Copy(MaskEditDataFim.Text,5,4) + '-' + Copy(MaskEditDataFim.Text,3,2) + '-' + Copy(MaskEditDataFim.Text,1,2) + ' 23:59:59';
      DataModuleDB.SQLQueryRelPedidos.SQL.Add( ' AND dDATA_PE <= ' + '''' + cData + '''');
		end;

		DataModuleDB.SQLQueryRelPedidos.Active:= True;
	end;
end;

end.

