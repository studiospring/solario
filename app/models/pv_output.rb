class PvOutput
  require 'uri'
  require 'open-uri'
  attr_accessor
    :id,
    :system_watts,
    :postcode,
    :orientation,
    :tilt,
    :shade,
    :total_output,
    :efficiency,
    :entries,
    :date_from,
    :date_to
    #:significance

  def initialize(get_system_hash)# <<<
    @id = get_system_hash[:id]
    @system_watts = get_system_hash[:system_watts]
    @postcode = get_system_hash[:postcode]
    @orientation = get_system_hash[:bearing]
    @tilt = get_system_hash[:tilt]
    @shade = get_system_hash[:shade]
    stats = self.class.get_statistic({sid1: @id})
    @total_output = stats[:total_output]
    @efficiency = stats[:efficiency]
    @entries = stats[:entries]
    @date_from = stats[:date_from]
    @date_to = stats[:date_to]
    #express "statistical significance" of pvo values (0 to 1)
    #@significance = 0
  end# >>>
  #return actual average annual output (kWh)
  #TODO: does not check for missing data
  def actual_output_pa# <<<
    date_from = Date.parse(self.date_from)
    date_to = Date.parse(self.date_to)
    recorded_period = (date_to - date_from).to_i
    if recorded_period >= 1.year
      #find date exactly n years before date_to
      year_count = (recorded_period / 365).to_i
      start_date = (date_to - year_count.years).strftime('%Y%m%d')

      query_params = { sid1: self.id, date_from: start_date, date_to: self.date_to }
      year_stats = self.get_statistic(query_params)
      avg_output_pa = year_stats[:total_output] / year_count
      return (avg_output_pa / 1000).round
    else
      return nil
    end
  end# >>>
  #return get_system hash of most similar and statistically reliable system
  def self.similar_system(pvo_search_params)# <<<
    results = self.search(pvo_search_params)
    #order by number of entries
    results.sort! { |a, b| a[:entries] <=> b[:entries]}
    results.each do |system|
      if system[:entries] >= 100
        similar_system = self.get_system(system[:id])
        if similar_system[:shade] == 'No'
          return similar_system
        end
      else
        return nil
      end
    end
    return nil
  end# >>>
  #http://pvoutput.org/help.html#search
  #use pv_query.pvo_search_params to generate query argument
  #update postcode.urban attr depending on results count
  #returns array of systems [{name: 'some_name', size: 'size,...}, {...}]
  #or empty array
  def self.search(query)# <<<
    params = { 'q'        => query,
               'country'  => 'Australia' }
    response = self.request('search', params)
    results = Array.new
    keys = [ 'name', 'size', 'postcode', 'orientation', 'entries', 'last_entry', 'id', 'panel', 'inverter', 'distance', 'latitude', 'longitude' ]
    response.split("\n").each do |system_string|
      #merges keys and system data to hash
      results << Hash[keys.zip system_string.split(/,/)]
    end
    postcode = Postcode.find_by pcode: query.split(' ')[0].to_i
    postcode.update_urban?(results)
    return results
  end# >>>
  #returns hash of system info data
  #TODO: query by system id after donating
  def self.get_system(id)# <<<
    response = self.request('getsystem', {sid1: id})
    keys = [ 'system_watts', 'panel_count', 'panel_watts', 'bearing', 'tilt', 'shade', 'install_date', 'sec_panel_count', 'sec_panel_watts', 'sec_bearing', 'sec_tilt' ]
    results_array = response.split(/,/)
    results_array.values_at(3, 4, 9, 10, 11, 12, 16, 17, 18, 19)
    #merges keys and system info to hash
    results = Hash[keys.zip results_array]
    results[:id] = id
    return results
  end# >>>
  #return array of hashes of daily output of system
  #use to compare with theoretical daily output
  #query_params include: 'df' (date from), 'dt' (date to), 'sid1'
  #TODO: untested, unfinished. Query by system id and date after donating
  def get_output(query_params = {})# <<<
    response = self.request('getoutput', query_params)
    keys = [ 'date', 'output' ] #output is in watt hours
    results = Array.new
    response.split(/;/).each do |daily_output|
      results << Hash[keys.zip daily_output.values_at(0, 1)]
    end
    return results
  end# >>>
  #return hash of system data
  #keep as class method for flexibility
  #TODO: untested, unfinished. Query by system id and dates after donating
  def self.get_statistic(query_params = {})# <<<
    response = self.request('getstatistic', query_params)
    #total_output is in watt hours
    keys = [ 'total_output', 'efficiency', 'entries', 'date_from', 'date_to' ]
    results_array = response.split(/,/)
    results_array.values_at(0, 5, 6, 7, 8)
    results = Hash[keys.zip results_array]
    return results
  end# >>>
  private
    #make GET request to pvoutput api and return response
    def self.request(uri, params = {})# <<<
      uri = URI.parse('http://pvoutput.org/service/r2/' + uri + '.jsp')
      auth_params = { 'key' => Rails.application.secrets.pvo_api_key,
                      'sid' => Rails.application.secrets.pvo_system_id }
      #merge params params and add to uri
      uri.query = URI.encode_www_form( auth_params.merge(params) )
      begin
        response = uri.read
      rescue
        return '' #fails silently
      else
        case response.status[0][0]
          when '2', '3' 
          return response
        else
          return '' #fails silently
        end
      end
    end# >>>
end
