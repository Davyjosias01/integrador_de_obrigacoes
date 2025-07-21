require 'httparty'
require 'dotenv/load'


class Integrador
  include HTTParty 
  base_uri 'https://app.razonet.com.br'

  def initialize(token)
    @headers = {
      "Authorization" => token,
      "Content-Type" => "application/json"
    }
  end

  def buscar_empresas
    query = {
      obligation: "zeramento_de_balancos", 
      date_start: "01/01/2025", 
      date_end: "01/01/2026", 
      integrated_at: "false",
      obligation_finished: "true",
      fields: "cnpj,ie,dominio_code,fantasy_name,has_variables,has_pro_labore" 
    }

    self.class.get("/integration/v1/companies/index", headers: @headers, query: query)
  end

  def integrar_obrigacoes(dados)
    query = {
      obligation: "zeramento_de_balancos", 
      date_start: "01/01/2025", 
      date_end: "01/01/2026", 
      cnpj: dados[:cnpj],
      note: dados[:note]
    }

    self.class.post("/integration/v1/companies/set_as_integrated", headers: @headers, query: query)
  end

end

if __FILE__ == $0
  api = Integrador.new(ENV["RAZONET_TOKEN"])
  response = api.integrar_obrigacoes(cnpj: "32265701000149", note: "finalizado por script")
  
  if response.success?
    puts response
  else
    puts response
  end

end