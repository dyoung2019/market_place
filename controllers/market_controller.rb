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

def populate_seller_info(market_id, seller)
  @seller = seller
  @stalls = find_all_stalls_by_seller(seller[:seller_id])

  server_time = Time.now
  market_date = find_latest_market_date(market_id, server_time)
  @register_stall_allowed = !!market_date
end

get '/markets/:market_id/seller' do
  seller = get_current_seller()

  if !!seller
    market_id = params[:market_id]
    populate_seller_info(market_id, seller)
    erb :'markets/seller'
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

get '/markets/:market_id/seller/stalls/new' do
  seller = get_current_seller()

  market_id = params[:market_id]
  # login data records
  redirect "/markets/#{market_id}/login" unless !!seller

  server_time = Time.now
  market_date = find_latest_market_date(market_id, server_time)
  if !!market_date 
    @market_date = market_date
    # binding.pry

    @opening_time = convert_timestamp(market_date[:opening_time])
    @closing_time = convert_timestamp(market_date[:closing_time])

    @seller = seller

    erb :'stalls/new'
  else
    # no market date -> redirect
    populate_seller_info(market_id, seller)

    erb :'markets/seller'
  end
end

def format_stall_info(stall_info) 
  stall = format_hash(params)
  stall[:opening_time] = convert_date_time_array(params[:opening_time])
  stall[:closing_time] = convert_date_time_array(params[:closing_time])
  return stall
end 

post '/markets/:market_id/seller/stalls/new' do
  seller = get_current_seller()

  market_id = params[:market_id]
  # login data records
  redirect "/markets/#{market_id}/login" unless !!seller

  # REPLACE VALUES
  stall = format_stall_info(params)
  create_new_stall(stall)

  # REDIRECT
  redirect '/markets/:market_id/seller'
end

get '/markets/:market_id/stalls/:stall_id' do
  stall_id = params[:stall_id]

  update_allowed = stall_changes_allowed?(stall_id)
  redirect "/markets/#{params[:market_id]}" unless update_allowed

  @stall = find_one_stall_by_id(stall_id)
  
  @edit_link_allowed = !!@stall && seller_logged_in?(@stall[:seller_id])

  # binding.pry
  erb :'stalls/view'
end 

get '/markets/:market_id/stalls/:stall_id/edit' do
  update_allowed = stall_changes_allowed?(params[:stall_id])
  redirect "/markets/#{params[:market_id]}" unless update_allowed

  stall_id = params[:stall_id]
  @stall = find_one_stall_by_id(stall_id)

  @form_action_path = "/markets/#{params[:market_id]}/stalls/#{params[:stall_id]}/edit"
  @opening_time = convert_timestamp(@stall[:opening_time])
  @closing_time = convert_timestamp(@stall[:closing_time])

  # binding.pry
  erb :'stalls/edit'
end 

patch '/markets/:market_id/stalls/:stall_id/edit' do
  # return 'PATCH'

  stall_id = params[:stall_id]
  @stall = find_one_stall_by_id(stall_id)

  update_allowed = stall_changes_allowed?(stall_id)
  redirect "/markets/#{params[:market_id]}" unless update_allowed
  
  stall_info = format_stall_info(params)
  update_stall(stall_info)

  # binding.pry
  # redirect on success 
  redirect "/markets/#{params[:market_id]}/stalls/#{params[:stall_id]}"
end

delete '/markets/:market_id/stalls/:stall_id' do
  stall_id = params[:stall_id]

  update_allowed = stall_changes_allowed?(stall_id)
  redirect "/markets/#{params[:market_id]}" unless update_allowed

  
  delete_stall(stall_id)

  redirect "/markets/#{params[:market_id]}/seller"
end