#lib/tasks/import_csv.rake
#import comma separated csv file with headers. Don't forget id and timestamps column
#to run: rake 'import_csv[path/to/csv_file.csv, ModelName]'
#need quotes to circumvent zsh bug
require 'csv'    

desc "Import csv file to db"
task :import_csv, [:filename, :model] => :environment do |task,args|
  csv_text = File.read(args[:filename])
  csv = CSV.parse(csv_text, :headers => true)
  csv.each do |row|
    args[:model].constantize.create!(row.to_hash)
  end
end
