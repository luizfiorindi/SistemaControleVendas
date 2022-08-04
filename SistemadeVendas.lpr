program SistemadeVendas;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazdbexport, laz_fpspreadsheet, uPrincipal, uDataModuleDB,
	uCadastroUsuario, ucadastrocliente, ucadastrocategoriasubcategoria,
	ucadastroproduto, uestoqueproduto, upedido, ubuscacliente, ubuscaproduto,
	uconsultapedido, uetiqueta, urelatorioestoque, urelpedidos, ulogin, 
ualterasenha
  { you can add units after this };

{$R *.res}

begin
			Application.Title:='Sistema de Vendas';
  RequireDerivedFormResource:=True;
  Application.Initialize;
	Application.CreateForm(TFormPrincipal, FormPrincipal);
	Application.CreateForm(TDataModuleDB, DataModuleDB);
	Application.CreateForm(TFormLogin, FormLogin);
  Application.Run;
end.

