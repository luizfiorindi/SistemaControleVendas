unit uetiqueta;

{$mode objfpc}{$H+}

interface

uses
      Classes, SysUtils, db, FileUtil, LR_Class, LR_Desgn, LR_DBSet, Forms,
			Controls, Graphics, Dialogs, StdCtrls;

type

			{ TFormEtiqueta }

      TFormEtiqueta = class(TForm)
						ButtonPreview: TButton;
						frDesignerEtiqueta: TfrDesigner;
						frReportEtiqueta: TfrReport;
						procedure ButtonEditarClick(Sender: TObject);
      procedure ButtonPreviewClick(Sender: TObject);
			procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
						procedure FormShow(Sender: TObject);
      private
            { private declarations }
      public
            { public declarations }
            iCodigoPE: Integer;
      end;

var
      FormEtiqueta: TFormEtiqueta;

implementation
uses
  uDataModuleDB;

{$R *.lfm}

{ TFormEtiqueta }

procedure TFormEtiqueta.ButtonPreviewClick(Sender: TObject);
begin
  frReportEtiqueta.LoadFromFile('etiqueta.lrf');
  frReportEtiqueta.ShowReport;
end;

procedure TFormEtiqueta.FormClose(Sender: TObject; var CloseAction: TCloseAction
			);
begin
  DataModuleDB.SQLQueryPedidos.Filtered:= False;
  DataModuleDB.SQLQueryPedidos.Close;
  CloseAction:= caFree;
  FormEtiqueta:= Nil;
end;

procedure TFormEtiqueta.ButtonEditarClick(Sender: TObject);
begin
  frReportEtiqueta.LoadFromFile('etiqueta.lrf');
  frReportEtiqueta.DesignReport;
end;

procedure TFormEtiqueta.FormShow(Sender: TObject);
begin
  if iCodigoPE > 0 then
  begin
    DataModuleDB.SQLQueryPedidos.Close;
    DataModuleDB.SQLQueryPedidos.Filtered:= False;
    DataModuleDB.SQLQueryPedidos.Filter:= 'iID_PE = ' + IntToStr(iCodigoPE);
    DataModuleDB.SQLQueryPedidos.Filtered:= True;
    DataModuleDB.SQLQueryPedidos.Open;
  end;
end;

end.

