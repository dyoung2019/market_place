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

get '/market_dates/:market_date_id/login' do
  @form_action_path = "/market_dates/#{params[:market_date_id]}/login"
  erb :'sellers/login'
end

post '/market_dates/:market_date_id/login' do
  begin
    if seller_now_logged_in?(params[:email], params[:password])
      redirect "/market_dates/#{params[:market_date_id]}/seller"
    else
      @error_message = 'Cannot login with email / password combination' 
      erb :'sellers/login'
    end
  rescue => exception
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'
  end
end

get '/market_dates/:market_date_id/seller' do
  seller = get_current_seller()

  if !!seller
    @seller = seller
    erb :'sellers/details'
  else
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'    
  end 
end

delete '/market_dates/:market_date_id/login' do
  if logged_in?
    log_out_of_session()
  end
  redirect = "/market_dates/#{params[:market_date_id]}"
end