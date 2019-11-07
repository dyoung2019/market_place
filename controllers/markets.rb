require 'time'

require_relative '../models/markets'
require_relative '../models/market_dates'

get '/markets' do
  @markets = get_all_markets()

  @markets.each do | market |
    market_id = market[:market_id]

    market_dates = find_all_market_dates_by_market(market_id)
    
    market[:market_dates] = market_dates
  end

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
  insert_stalls_and_sale_items(@market_date)
  
  erb :'markets/view' do
    erb :'market_dates/show'
  end
end

get '/markets/:market_id/login' do
  @form_action_path = "/markets/#{params[:market_id]}/login"
  erb :'sellers/login'
end

post '/markets/:market_id/login' do
  begin
    if seller_now_logged_in?(params[:email], params[:password])
      redirect "/markets/#{params[:market_id]}/seller"
    else
      @error_message = 'Cannot login with email / password combination' 
      erb :'sellers/login'
    end
  rescue => exception
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'
  end
end

get '/markets/:market_id/seller' do
  seller = get_current_seller()

  if !!seller
    @seller = seller
    erb :'sellers/details'
  else
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'    
  end 
end

delete '/markets/:market_id/login' do
  if logged_in?
    log_out_of_session()
  end
  redirect "/markets/#{params[:market_id]}"
end