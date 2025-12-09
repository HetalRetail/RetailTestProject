namespace :inventory_changes do
  desc "Import inventory changes from inventory_changes.csv located in the app root"
  task import: :environment do
    path = Rails.root.join("inventory_changes.csv")

    unless File.exist?(path)
      puts "ERROR: File not found:"
      puts "  #{path}"
      puts ""
      puts "Place inventory_changes.csv in the top-level directory of the Rails app."
      exit 1
    end

    puts "Importing inventory changes from #{path}..."

    InventoryChanges::CsvImporter.new(path).call

    puts "Done."
  end
end
