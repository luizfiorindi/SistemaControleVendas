unit uconsultapedido;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs,
			DBGrids, Buttons, ExtCtrls, StdCtrls, MaskEdit, Menus;

type

			{ TFormConsultaPedidos }

      TFormConsultaPedidos = class(TForm)
						DataSourceConsultaPedido: TDataSource;
						DBGrid1: TDBGrid;
						EditCodigoPedido: TEdit;
						EditCodigoCliente: TEdit;
						Label1: TLabel;
						Label2: TLabel;
						Label3: TLabel;
						Label4: TLabel;
						MaskEditDataFim: TMaskEdit;
						MaskEditDataIni: TMaskEdit;
						MenuItemAbrir: TMenuItem;
						MenuItemCancelar: TMenuItem;
						MenuItemEtiqueta: TMenuItem;
						PopupMenuConsultaPedido: TPopupMenu;
						RadioGroupFiltroStatus: TRadioGroup;
						SpeedButtonPesquisar: TSpeedButton;
						procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure MenuItemAbrirClick(Sender: TObject);
						procedure MenuItemCancelarClick(Sender: TObject);
						procedure MenuItemEtiquetaClick(Sender: TObject);
						procedure SpeedButtonPesquisarClick(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
      end;

var
      FormConsultaPedidos: TFormConsultaPedidos;

implementation

uses
  uDataModuleDB, upedido, uPrincipal, uetiqueta;

{$R *.lfm}

{ TFormConsultaPedidos }

procedure TFormConsultaPedidos.FormClose(Sender: TObject;
			var CloseAction: TCloseAction);
begin
  DataModuleDB.SQLQueryConsultaPedido.Active:= False;
  DataModuleDB.SQLQueryExec.Active:= False;
  CloseAction:= caFree;
  FormConsultaPedidos:= Nil;
end;

procedure TFormConsultaPedidos.MenuItemAbrirClick(Sender: TObject);
begin
  if (DataModuleDB.SQLQueryConsultaPedido.Active = False) or (DataModuleDB.SQLQueryConsultaPedido.RecordCount < 1) then
  begin
    Exit;
	end;
	FormPedido:= TFormPedido.Create(Application);
  FormPedido.iCodigoPedido:= DataModuleDB.SQLQueryConsultaPedido.FieldByName('iID_PE').AsInteger;
  FormPedido.cStatus:= DataModuleDB.SQLQueryConsultaPedido.FieldByName('cSTATUS_PE').AsString;
  FormPedido.ShowModal;
end;

procedure TFormConsultaPedidos.MenuItemCancelarClick(Sender: TObject);
begin
  if (DataModuleDB.SQLQueryConsultaPedido.Active = False) or (DataModuleDB.SQLQueryConsultaPedido.RecordCount < 1) then
  begin
    Exit;
	end;

  if    (DataModuleDB.SQLQueryConsultaPedido.FieldByName('cSTATUS_PE').AsString = 'F')
     or (DataModuleDB.SQLQueryConsultaPedido.FieldByName('cSTATUS_PE').AsString = 'C') then
  begin
    ShowMessage('Venda não pode ser cancelada!');
    Exit;
	end;

  if MessageDlg('Cancelar Venda','Confirma o cancelamento dessa venda?',mtConfirmation,mbYesNo,'') <> mrYes then
  begin
    Exit;
	end;

	DataModuleDB.SQLQueryExec.Active:= False;
  DataModuleDB.SQLQueryExec.SQL.Text:= ' UPDATE TB_PEDIDOS';
  DataModuleDB.SQLQueryExec.SQL.Add(   '    SET cSTATUS_PE = ' + '''' + 'C' + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , dDATA_PE = datetime(' + '''' + 'now' + '''' + ',' + '''' + 'localtime' + '''' + ')');
  DataModuleDB.SQLQueryExec.SQL.Add(   '      , cLOGIN_USUARIO_PE = ' + '''' + FormPrincipal.StatusBar1.Panels[1].Text + '''');
  DataModuleDB.SQLQueryExec.SQL.Add(   '  WHERE iID_PE = ' + DataModuleDB.SQLQueryConsultaPedido.FieldByName('iID_PE').AsString);
  try
    DataModuleDB.SQLTransaction.Active:= True;
    DataModuleDB.SQLQueryExec.ExecSQL;
    DataModuleDB.SQLTransaction.Commit;
    ShowMessage('Venda cancelada com sucesso!');
	except
    DataModuleDB.SQLTransaction.Rollback;
    ShowMessage('Erro ao cancelar venda!');
	end;

  SpeedButtonPesquisar.Click;
end;

procedure TFormConsultaPedidos.MenuItemEtiquetaClick(Sender: TObject);
begin
  FormEtiqueta:= TFormEtiqueta.Create(Application);
  FormEtiqueta.iCodigoPE:= DataModuleDB.SQLQueryConsultaPedido.FieldByName('iID_PE').AsInteger;
  FormEtiqueta.ShowModal;
end;

procedure TFormConsultaPedidos.SpeedButtonPesquisarClick(Sender: TObject);
var
  cData: String;
begin
  DataModuleDB.SQLQueryConsultaPedido.Active:= False;
  DataModuleDB.SQLQueryConsultaPedido.SQL.Text := ' SELECT iID_PE';
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , cRAZAO_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , cCIDADE_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , cUF_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , dDATA_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , cLOGIN_USUARIO_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '      , cSTATUS_PE');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '   FROM TB_PEDIDOS');
  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(    '  WHERE 1 = 1');

  if EditCodigoPedido.Text <> '' then
  begin
    DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND iID_PE = ' + EditCodigoPedido.Text);
	end;

  if EditCodigoCliente.Text <> '' then
  begin
    DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND iID_CLIENTE_PE = ' + EditCodigoCliente.Text);
	end;

  if MaskEditDataIni.Text <> '' then
  begin
    cData:= Copy(MaskEditDataIni.Text,5,4) + '-' + Copy(MaskEditDataIni.Text,3,2) + '-' + Copy(MaskEditDataIni.Text,1,2);
    DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND dDATA_PE >= ' + '''' + cData + '''');
	end;

  if MaskEditDataFim.Text <> '' then
  begin
    cData:= Copy(MaskEditDataFim.Text,5,4) + '-' + Copy(MaskEditDataFim.Text,3,2) + '-' + Copy(MaskEditDataFim.Text,1,2) + ' 23:59:59';
    DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND dDATA_PE <= ' + '''' + cData + '''');
	end;

  case  RadioGroupFiltroStatus.ItemIndex of
    1: DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND cSTATUS_PE = ' + '''' + 'P' + '''');
    2: DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND cSTATUS_PE = ' + '''' + 'F' + '''');
    3: DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' AND cSTATUS_PE = ' + '''' + 'C' + '''');
	end;

  DataModuleDB.SQLQueryConsultaPedido.SQL.Add(' ORDER BY iID_PE');
  DataModuleDB.SQLQueryConsultaPedido.Active:= True;
end;

end.

