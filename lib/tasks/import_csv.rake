#import comma separated csv file with headers
#to run: rake import_csv[path/to/csv_file.csv, ModelName]
require 'csv'    

desc "Import csv file to db"
task :import_csv, :filename, :model, :needs => :environment do |task,args|
  csv_text = File.read(args[:filename])
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    args[:model].create!(row.to_hash)
  end
end

#csv_text = File.read(args[:filename])
#csv = CSV.parse(csv_text, :headers => true)
#csv.each do |row|
  #args[:model].create!(row.to_hash)
#end
