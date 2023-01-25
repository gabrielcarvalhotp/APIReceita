unit APIReceita.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Vcl.StdCtrls, Vcl.ExtCtrls, REST.Types, System.JSON,
  Vcl.NumberBox;

type
  TForm1 = class(TForm)
    pnlContainer: TPanel;
    pnlHeader: TPanel;
    Shape1: TShape;
    btnDoItSerch: TButton;
    pnlInformations: TPanel;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    pnlLastUpdate: TPanel;
    pnlLastUpdateData: TPanel;
    pnlLastUpdateLine: TPanel;
    pnlLastUpdateText: TPanel;
    pnlReasonSituation: TPanel;
    Panel4: TPanel;
    pnlContact: TPanel;
    pnlAddressInformations: TPanel;
    pnlAddress: TPanel;
    pnlNatJuridica: TPanel;
    pnlName: TPanel;
    pnlNumberAndDate: TPanel;
    pnlNumber: TPanel;
    pnlDateOpen: TPanel;
    pnlCNPJText: TPanel;
    pnlCNPJLine: TPanel;
    PnlCNPJData: TPanel;
    pnlDateOpenText: TPanel;
    pnlDateOpenLine: TPanel;
    pnlDateOpenData: TPanel;
    pnlnameText: TPanel;
    pnlNameLine: TPanel;
    pnlNameData: TPanel;
    pnlNatJuridicaData: TPanel;
    pnlNatJuridicaLine: TPanel;
    pnlNatJuridicaText: TPanel;
    pnlComplet: TPanel;
    pnlAddressNumber: TPanel;
    pnlAddressStreet: TPanel;
    pnlAddressStreetData: TPanel;
    pnlAddressStreetLine: TPanel;
    pnlAddressStreetText: TPanel;
    pnlAddressNumberData: TPanel;
    pnlAddressNumberLine: TPanel;
    pnlAddressNumberText: TPanel;
    pnlCompletData: TPanel;
    pnlCompletLine: TPanel;
    pnlCompletText: TPanel;
    pnlUF: TPanel;
    pnlCity: TPanel;
    pnlBairro: TPanel;
    pnlCEP: TPanel;
    pnlCEPText: TPanel;
    pnlCEPLine: TPanel;
    pnlCEPData: TPanel;
    pnlBairroText: TPanel;
    pnlBairroline: TPanel;
    pnlBairroData: TPanel;
    pnlCityText: TPanel;
    pnlCityLine: TPanel;
    pnlCityData: TPanel;
    pnlUFText: TPanel;
    pnlUFLine: TPanel;
    pnlUFData: TPanel;
    pnlContactTelephone: TPanel;
    pnlContactEmail: TPanel;
    pnlContactEmailData: TPanel;
    pnlContactLine: TPanel;
    pnlContactEmailText: TPanel;
    pnlContactTelephoneData: TPanel;
    pnlContactTelephoneLine: TPanel;
    pnlContactTelephoneText: TPanel;
    pnlSituation: TPanel;
    pnlSituationData: TPanel;
    pnlSituationLine: TPanel;
    pnlSituationText: TPanel;
    pnlDateSituation: TPanel;
    pnlDateSituationData: TPanel;
    pnlDataSituationLine: TPanel;
    pnlDataSituationText: TPanel;
    pnlReasonSituationLine: TPanel;
    pnlReasonSituationText: TPanel;
    pnlReasonSituationData: TPanel;
    edCNPJ: TEdit;
    Panel1: TPanel;
    procedure btnDoItSerchClick(Sender: TObject);
  private const
    MesesArray: array of string = ['Janeiro', 'Fevereiro', 'Mar�o', 'Abril',
      'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro',
      'Dezembro'];
  public
    function isValidCNPJ(CNPJ: string): string;
    function CNPJCorrect(CNPJ: string): string;
  end;

var
  FrmAPIReceita: TForm1;

implementation

uses RegularExpressions;

{$R *.dfm}

function TForm1.isValidCNPJ(CNPJ: string): string;
const
  CNPJ_REGEX = '^\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}$';
begin
  if (TRegEx.IsMatch(CNPJ, CNPJ_REGEX)) then result := CNPJCorrect(CNPJ)
  else raise Exception.Create('CNJP Invalido');
end;

function TForm1.CNPJCorrect(CNPJ: string): string;
var
  I: Integer;
begin
  for I := 0 to Length(CNPJ) do
  begin
    if CNPJ[I] in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] then
      result := result + CNPJ[I];
  end;
end;

procedure TForm1.btnDoItSerchClick(Sender: TObject);
var
  jsonValue: TJSONValue;
  Dia, Mes, ano, hora, DateLastUpdate: string;
begin
  RESTClient1.BaseURL := 'https://receitaws.com.br/v1/cnpj/' + isValidCNPJ(edCNPJ.text);
  RESTRequest1.Execute;
  jsonValue := RESTRequest1.Response.jsonValue;

  if (jsonValue.GetValue<string>('status', '') = 'ERROR') then
    raise Exception.Create('Esse CNPJ n�o existe!');

  DateLastUpdate := jsonValue.GetValue<string>('ultima_atualizacao', '');

  ano := DateLastUpdate.Split(['-'])[0];
  Mes := DateLastUpdate.Split(['-'])[1];
  Dia := DateLastUpdate.Split(['-'])[2].Split(['T'])[0];
  hora := DateLastUpdate.Split(['-'])[2].Split(['T'])[1].Split(['.'])[0];
  pnlLastUpdateData.Caption := Dia + ' de ' + MesesArray[Mes.ToInteger] + ' de '
    + ano + ' �s ' + hora;

  PnlCNPJData.Caption := jsonValue.GetValue<string>('cnpj', '') + ' - ' +
    jsonValue.GetValue<string>('tipo', '');
  pnlDateOpenData.Caption := jsonValue.GetValue<string>('abertura', '');

  pnlNameData.Caption := jsonValue.GetValue<string>('nome', '');

  pnlNatJuridicaData.Caption := jsonValue.GetValue<string>('natureza_juridica', '');

  pnlAddressStreetData.Caption := jsonValue.GetValue<string>('logradouro', '');
  pnlAddressNumberData.Caption := jsonValue.GetValue<string>('numero', '');
  pnlCompletData.Caption := jsonValue.GetValue<string>('complemento', '');

  pnlCEPData.Caption := jsonValue.GetValue<string>('cep', '');
  pnlBairroData.Caption := jsonValue.GetValue<string>('bairro', '');
  pnlCityData.Caption := jsonValue.GetValue<string>('municipio', '');
  pnlUFData.Caption := jsonValue.GetValue<string>('uf', '');

  pnlContactEmailData.Caption := jsonValue.GetValue<string>('email', '');
  pnlContactTelephoneData.Caption := jsonValue.GetValue<string>('telefone', '');

  pnlSituationData.Caption := jsonValue.GetValue<string>('situacao', '');
  pnlDateSituationData.Caption := jsonValue.GetValue<string>('data_situacao', '');

  pnlReasonSituationData.Caption := '  ' + jsonValue.GetValue<string>('motivo_situacao', '');
end;

end.
