unit ucadastrocategoriasubcategoria;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DbCtrls, StdCtrls, DBGrids;

type

			{ TFormCadastroCategoriaSubcategoria }

      TFormCadastroCategoriaSubcategoria = class(TForm)
						DataSourceSubCategoria: TDataSource;
						DataSourceCategoria: TDataSource;
						DBEditDescSubCategoria: TDBEdit;
						DBEditDescCategoria: TDBEdit;
						DBGridSubCategoria: TDBGrid;
						DBGridCategoria: TDBGrid;
						DBNavigatorSubCategoria: TDBNavigator;
						DBNavigatorCategoria: TDBNavigator;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						procedure DataSourceCategoriaDataChange(Sender: TObject;
									Field: TField);
						procedure DBNavigatorCategoriaClick(Sender: TObject;
									Button: TDBNavButtonType);
						procedure DBNavigatorSubCategoriaClick(Sender: TObject;
									Button: TDBNavButtonType);
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure FormCreate(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormCadastroCategoriaSubcategoria: TFormCadastroCategoriaSubcategoria;

implementation

uses
  uPrincipal,uDataModuleDB;

{$R *.lfm}

{ TFormCadastroCategoriaSubcategoria }

procedure TFormCadastroCategoriaSubcategoria.DataSourceCategoriaDataChange(
			Sender: TObject; Field: TField);
begin
  if (DataModuleDB.SQLQueryCategoria.RecordCount >= 1) and (DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsString <> '') then
  begin
    DataModuleDB.SQLQuerySubCategoria.Close;
    DataModuleDB.SQLQuerySubCategoria.Filtered:= False;
    DataModuleDB.SQLQuerySubCategoria.Filter:= 'iID_CATEGORIA_SC = ' + DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsString;
    DataModuleDB.SQLQuerySubCategoria.Filtered:= True;
    DataModuleDB.SQLQuerySubCategoria.Open;
  end;
end;

procedure TFormCadastroCategoriaSubcategoria.DBNavigatorCategoriaClick(
			Sender: TObject; Button: TDBNavButtonType);
begin
  case Button of
    nbInsert: DBEditDescCategoria.ReadOnly:= False;
    nbEdit: DBEditDescCategoria.ReadOnly:= False;
    nbPost: DBEditDescCategoria.ReadOnly:= True;
    nbCancel: DBEditDescCategoria.ReadOnly:= True;
	end;
end;

procedure TFormCadastroCategoriaSubcategoria.DBNavigatorSubCategoriaClick(
			Sender: TObject; Button: TDBNavButtonType);
begin
  if Button = nbInsert then
  begin
    if DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsString = '' then
    begin
      ShowMessage('Escolha uma Categoria primeiro!');
      DataModuleDB.SQLQuerySubCategoria.Cancel;
      Exit;
		end;

    DataModuleDB.SQLQuerySubCategoria.FieldByName('iID_CATEGORIA_SC').AsInteger:= DataModuleDB.SQLQueryCategoria.FieldByName('iID_CA').AsInteger;
	end;

  case Button of
    nbInsert: DBEditDescSubCategoria.ReadOnly:= False;
    nbEdit: DBEditDescSubCategoria.ReadOnly:= False;
    nbPost: DBEditDescSubCategoria.ReadOnly:= True;
    nbCancel: DBEditDescSubCategoria.ReadOnly:= True;
	end;
end;

procedure TFormCadastroCategoriaSubcategoria.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryCategoria.Close;
  DataModuleDB.SQLQuerySubCategoria.Close;
  CloseAction:= caFree;
  FormCadastroCategoriaSubcategoria:= Nil;
end;

procedure TFormCadastroCategoriaSubcategoria.FormCreate(Sender: TObject);
begin
  DataModuleDB.SQLQueryCategoria.Open;
end;


end.

