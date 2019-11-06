require_relative '../models/stalls.rb'
require_relative '../models/sale_items.rb'
require_relative '../models/market_dates.rb'

get '/market_dates/:market_date_id' do
  market_date_id = params[:market_date_id]
  market_date = find_one_market_date(market_date_id)
  insert_stalls_and_sale_items(market_date)

  @market_date = market_date

  # binding.pry 
  
  erb :'market_dates/view'
end