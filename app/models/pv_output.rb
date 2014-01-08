class PvOutput
  require 'uri'
  require 'open-uri'
  
  #search pvoutput via GET request. Query must be 'string'
  #http://pvoutput.org/help.html#search
  #returns array of systems [{name: 'some_name', size: 'size,...}, {...}]
  def self.search(query)# <<<
    params = { 'q'        => query,
               'country'  => 'Australia' }
    response = self.request('search', params)
    case response.status[0][0]
      when '2', '3' 
        results = Array.new
        keys = [ 'name', 'size', 'postcode', 'orientation', 'outputs', 'last_output', 'system_id', 'panel', 'inverter', 'distance', 'latitude', 'longitude' ]
        response.split("\n").each do |system_string|
          #merges keys and system data to hash
          results << Hash[keys.zip system_string.split(/,/)]
        end
        return results
      else
        return 'error'
    end
  end# >>>
  #send GET request to get info about system that contributes to pvoutput
  #returns hash of system info
  def self.get_system# <<<
    response = self.request('getsystem')
    case response.status[0][0]
      when '2', '3' 
        keys = [ 'system_watts', 'panel_count', 'panel_watts', 'bearing', 'tilt', 'shade', 'sec_panel_count', 'sec_panel_watts', 'sec_bearing', 'sec_tilt' ]
        results_array = response.split(/,/)
        results_array.values_at(3, 4, 9, 10, 11, 16, 17, 18, 19)
        #merges keys and system info to hash
        results = Hash[keys.zip results_array]
        return results
      else
        return 'error'
    end
  end# >>>
  #make request to pvoutput api and return response
  def self.request(uri, params = {})# <<<
    uri = URI.parse('http://pvoutput.org/service/r2/' + uri + '.jsp')
    auth_params = { 'key' => Rails.application.secrets.pv_output_api_key,
                    'sid' => Rails.application.secrets.pv_output_system_id }
    
    uri.query = URI.encode_www_form( auth_params.merge(params) ) #add params to uri
    return uri.read
  end# >>>
end
