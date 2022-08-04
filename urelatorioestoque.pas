unit urelatorioestoque;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, fpdataexporter, Forms, Controls,
			Graphics, Dialogs, DBGrids, StdCtrls, MaskEdit, ExtCtrls, Buttons, fpsexport;

type

			{ TFormRelatorioEstoque }

      TFormRelatorioEstoque = class(TForm)
						DataSourceEstoque: TDataSource;
						DBGridEstoque: TDBGrid;
						Label1: TLabel;
						Label2: TLabel;
						MaskEditDataIni: TMaskEdit;
						MaskEditDataFim: TMaskEdit;
						RadioGroupComSaldo: TRadioGroup;
						SaveDialog1: TSaveDialog;
						SpeedButtonExportar: TSpeedButton;
						SpeedButtonPesquisar: TSpeedButton;
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      procedure SpeedButtonExportarClick(Sender: TObject);
      procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormRelatorioEstoque: TFormRelatorioEstoque;

implementation
uses
  uDataModuleDB, uPrincipal;

{$R *.lfm}

{ TFormRelatorioEstoque }

procedure TFormRelatorioEstoque.SpeedButtonPesquisarClick(Sender: TObject);
var
  cData: String;
begin
  DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= ' SELECT iCOD_PRODUTO_EP AS CODIGO';
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , cDESCRICAO_PR AS DESCRICAO');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , iSALDO_EP AS SALDO');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , cDESCRICAO_CA AS CATEGORIA');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , cDESCRICAO_SC AS SUB_CATEGORIA');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_ALTERA_EP AS DATA_ALTERA');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_EP AS USUARIO');
  DataModuleDB.SQLQueryExec.SQL.Add(   '   FROM TB_ESTOQUE_PRODUTOS');
  DataModuleDB.SQLQueryExec.SQL.Add(   '        INNER JOIN TB_PRODUTOS ON TB_PRODUTOS.iCODIGO_PR = TB_ESTOQUE_PRODUTOS.iCOD_PRODUTO_EP');
  DataModuleDB.SQLQueryExec.SQL.Add(   '        INNER JOIN TB_CATEGORIA ON TB_CATEGORIA.iID_CA = TB_PRODUTOS.iID_CATEGORIA_PR');
  DataModuleDB.SQLQueryExec.SQL.Add(   '        INNER JOIN TB_SUBCATEGORIA ON TB_SUBCATEGORIA.iID_SC = TB_PRODUTOS.iID_SUBCATEGORIA_PR');
  DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE 1=1');

  if MaskEditDataIni.Text <> '' then
  begin
    cData:= Copy(MaskEditDataIni.Text,5,4) + '-' + Copy(MaskEditDataIni.Text,3,2) + '-' + Copy(MaskEditDataIni.Text,1,2);
    DataModuleDB.SQLQueryExec.SQL.Add(' AND dDATA_ALTERA_EP >= ' + '''' + cData + '''');
	end;

  if MaskEditDataFim.Text <> '' then
  begin
    cData:= Copy(MaskEditDataFim.Text,5,4) + '-' + Copy(MaskEditDataFim.Text,3,2) + '-' + Copy(MaskEditDataFim.Text,1,2) + ' 23:59:59';
    DataModuleDB.SQLQueryExec.SQL.Add(' AND dDATA_ALTERA_EP <= ' + '''' + cData + '''');
	end;

  case RadioGroupComSaldo.ItemIndex of
    1: DataModuleDB.SQLQueryExec.SQL.Add(' AND iSALDO_EP > 0');
    2: DataModuleDB.SQLQueryExec.SQL.Add(' AND iSALDO_EP = 0');
	end;

  DataModuleDB.SQLQueryExec.Active:= True;
end;

procedure TFormRelatorioEstoque.SpeedButtonExportarClick(Sender: TObject);
var
  FileName: String;
begin
  if (DataModuleDB.SQLQueryExec.Active = False) or (DataModuleDB.SQLQueryExec.RecordCount < 1) then
  begin
    ShowMessage('Sem dados para exportar!');
    Exit;
	end;
	if SaveDialog1.Execute then
  begin
    FileName:= ChangeFileExt(SaveDialog1.FileName,'.xls');
	end
  else
  begin
    Exit;
	end;

  FormPrincipal.ExportaXLS(FileName,DataModuleDB.SQLQueryExec);

end;

procedure TFormRelatorioEstoque.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryExec.Active:= False;
  CloseAction:= caFree;
  FormRelatorioEstoque:= Nil;
end;

end.

