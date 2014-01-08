class PvOutput
  require 'net/http'
  require 'uri'
  require 'open-uri'
  
  #search pvoutput via POST request. Query must be 'string'
  #http://pvoutput.org/help.html#search
  #returns array of systems [{name: 'some_name', size: 'size,...}, {...}]
  def self.search(query)# <<<
    uri = URI.parse('http://pvoutput.org/service/r2/search.jsp')
    params = { 'key' => Rails.application.secrets.pv_output_api_key,
               'sid' => Rails.application.secrets.pv_output_system_id,
               'q'        => query,
               'country'  => 'Australia' }
    uri.query = URI.encode_www_form( params ) #add params to uri
    response = uri.read
    case response.status[0][0]
      when '2', '3' 
        return response
      else
        return 'error'
    end

    #uri = URI('http://pvoutput.org/service/r2/search.jsp')
    #req = Net::HTTP::Post.new(uri)
    ##set headers
    #req['X-Pvoutput-Apikey'] = 'a0ac0021b1351c9658e4ff80c2bc5944405af134'
    #req['X-Pvoutput-SystemId'] = '26011'
    #params = { 'q'        => query,
               #'country'  => 'Australia' }
    #req.set_form_data(params)

    #response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      #http.request(req)
    #end
    #case response
      #when Net::HTTPSuccess, Net::HTTPRedirection
        #results = Array.new
        #keys = [ 'name', 'size', 'postcode', 'orientation', 'outputs', 'last_output', 'system_id', 'panel', 'inverter', 'distance', 'latitude', 'longitude' ]
        #response.body.split("\n").each do |system_string|
          ##merges keys and system data to hash
          #results << Hash[keys.zip system_string.split(/,/)]
        #end
        #return results
      #else
        #return 'error'
    #end
  end# >>>
  #send GET request to get info about system that contributes to pvoutput
  def self.get_system# <<<
    uri = URI.parse('http://pvoutput.org/service/r2/getsystem.jsp')
    params = { 'key' => Rails.application.secrets.pv_output_api_key,
               'sid' => Rails.application.secrets.pv_output_system_id }
    uri.query = URI.encode_www_form( params ) #add params to uri
    response = uri.read
    case response.status[0][0]
      when '2', '3' 
        return response
      else
        return 'error'
    end
  end# >>>
end
