unit ucadastroproduto;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DbCtrls, DBGrids, StdCtrls, Buttons;

type

			{ TFormCadastroProduto }

      TFormCadastroProduto = class(TForm)
						DataSourceCategoria: TDataSource;
						DataSourceSubCategoria: TDataSource;
						DataSourceProduto: TDataSource;
						DBEditValor: TDBEdit;
						DBEditDescricao: TDBEdit;
						DBGridProduto: TDBGrid;
						DBLookupComboBoxSubCategoria: TDBLookupComboBox;
						DBLookupComboBoxCategoria: TDBLookupComboBox;
						DBNavigatorProduto: TDBNavigator;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						SpeedButtonPesquisar: TSpeedButton;
      procedure DBLookupComboBoxCategoriaChange(Sender: TObject);
      procedure DBNavigatorProdutoClick(Sender: TObject;
									Button: TDBNavButtonType);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      procedure FormCreate(Sender: TObject);
      procedure HabilitaCampos(cHabilita: boolean);
      procedure FiltraSubCategoria(iCodCategoria: integer);
			procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormCadastroProduto: TFormCadastroProduto;

implementation

uses
  uDataModuleDB;

{$R *.lfm}

{ TFormCadastroProduto }

procedure TFormCadastroProduto.HabilitaCampos(cHabilita: boolean);
begin
  DBEditDescricao.ReadOnly:= not cHabilita;
  DBEditValor.ReadOnly:= not cHabilita;
  DBLookupComboBoxCategoria.Enabled:= cHabilita;
  DBLookupComboBoxSubCategoria.Enabled:= cHabilita;
end;

procedure TFormCadastroProduto.FiltraSubCategoria(iCodCategoria: integer);
begin
  if (DataModuleDB.SQLQueryCategoria.RecordCount >= 1) and (DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsString <> '') then
  begin
    DataModuleDB.SQLQuerySubCategoria.Close;
    DataModuleDB.SQLQuerySubCategoria.Filtered:= False;
    DataModuleDB.SQLQuerySubCategoria.Filter:= 'iID_CATEGORIA_SC = ' + IntToStr(iCodCategoria);
    DataModuleDB.SQLQuerySubCategoria.Filtered:= True;
    DataModuleDB.SQLQuerySubCategoria.Open;
  end;
end;

procedure TFormCadastroProduto.SpeedButtonPesquisarClick(Sender: TObject);
var
  cDados: String;
begin
  if InputQuery('Pesquisar Produto','Digite a descrição do produto',cDados) then
  begin
    DataModuleDB.SQLQueryProdutos.Locate('cDESCRICAO_PR',cDados,[loPartialKey,loCaseInsensitive]);
	end;
end;

procedure TFormCadastroProduto.FormCreate(Sender: TObject);
begin
  DataModuleDB.SQLQueryProdutos.Open;
  DataModuleDB.SQLQueryCategoria.Open;
  DataModuleDB.SQLQuerySubCategoria.Open;
end;

procedure TFormCadastroProduto.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryProdutos.Close;
  DataModuleDB.SQLQueryCategoria.Close;
  DataModuleDB.SQLQuerySubCategoria.Close;
  CloseAction:= caFree;
  FormCadastroProduto:= Nil;
end;

procedure TFormCadastroProduto.DBNavigatorProdutoClick(Sender: TObject;
			Button: TDBNavButtonType);
begin
  case Button of
    nbEdit: HabilitaCampos(True);
    nbInsert: HabilitaCampos(True);
    nbPost: HabilitaCampos(False);
    nbCancel: HabilitaCampos(False);
	end;
end;

procedure TFormCadastroProduto.DBLookupComboBoxCategoriaChange(Sender: TObject);
begin
  FiltraSubCategoria(DBLookupComboBoxCategoria.KeyValue);
end;

end.

