class PvOutput
  require 'net/http' #for api call to pvoutput.org
  
  #search pvoutput. Query is string
  #http://pvoutput.org/help.html#search
  def self.search(query)# <<<
    uri = URI('http://pvoutput.org/service/r2/search.jsp')
    req = Net::HTTP::Post.new(uri)
    #set headers
    req['X-Pvoutput-Apikey'] = 'a0ac0021b1351c9658e4ff80c2bc5944405af134'
    req['X-Pvoutput-SystemId'] = '26011'
    params = { 'q'        => query,
               'country'  => 'Australia' }
    req.set_form_data(params)

    results = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    return results.body
  end# >>>
end
