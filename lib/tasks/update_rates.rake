namespace :money do
  desc "Rake task to update money exchange rates"
  task :update_rates => :environment do
    eu_bank = EuCentralBank.new
    cache = Rails.root.join('db', 'eu_bank_exchange_rates.xml')
    eu_bank.save_rates(cache)
    eu_bank.update_rates(cache)
  end
end