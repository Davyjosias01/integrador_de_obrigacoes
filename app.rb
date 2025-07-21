require 'sinatra'
require 'json'
require 'dotenv/load'
require_relative 'lib/integrador'

enable :method_override

get '/' do 
  integrador = Integrador.new(ENV['RAZONET_TOKEN'])
  resposta = integrador.buscar_empresas

  if resposta.code == 200
    @empresas = resposta.parsed_response["companies"] || []
  
  else
    @empresas = []
  
  end

  erb :index
end

post '/integrar' do 
  integrador = Integrador.new(ENV['RAZONET_TOKEN'])
  
  dados = {
    cnpj: params[:cnpj],
    note: params[:note]
  }

  resposta = integrador.integrar_obrigacoes(dados)

  redirect "/?status=#{resposta.code}"
end