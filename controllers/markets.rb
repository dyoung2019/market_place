require 'time'

require_relative '../models/markets'
require_relative '../models/market_dates'

get '/markets' do
  @markets = get_all_markets()

  erb :'markets/all_markets'
end

get '/markets/:market_id' do

  market_id = params[:market_id]
  @market = find_one_market(market_id)

  # server_time
  server_time = Time.now()
  if !!params[:server_time]
    server_time = Time.parse(params[:server_time])
  end

  @market_date = find_latest_market_date(market_id, server_time)

  @stalls = []

  @products = []

  erb :'markets/market_date'
end
