require_relative "../models/sellers"
require_relative "../models/stalls"
require_relative "../models/market_dates"
require_relative "../models/utility"

get '/admin' do
  @sellers = get_all_sellers()
  @stalls = get_all_stalls()
  @products = []
  @markets = get_all_markets()

  erb :'admin/index'
end

get '/admin/login' do
  @form_action_path = '/admin/login'
  erb :'sellers/login'
end

post '/admin/login' do
  begin
    if seller_now_logged_in?(params[:email], params[:password])
      redirect '/admin/seller'
    else
      @error_message = 'Cannot login with email / password combination' 
      erb :'sellers/login'
    end
  rescue => exception
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'
  end
end

get '/admin/seller' do
  seller = get_current_seller()

  if !!seller
    @seller = seller
    @edit_action_path = "/admin/seller/edit"
    erb :'admin/seller'
  else
    @error_message = 'Cannot login with email / password combination' 
    erb :'sellers/login'    
  end 
end

delete '/admin/login' do
  if logged_in?
    log_out_of_session()
  end
  redirect '/admin'
end

get '/admin/seller/edit' do
  seller = get_current_seller()

  if !!seller
    @seller = seller
    @edit_action_path = '/admin/seller/edit'
    @back_anchor_link = '/admin/seller'
    erb :'sellers/edit'
  else 
    redirect '/admin/login'    
  end 
end

patch '/admin/seller/edit' do
  logged_user = get_current_seller()

  if logged_in? && !!params[:seller_id] && params[:seller_id] == logged_user[:seller_id]
    update_seller(params)
    redirect '/admin/seller'
  else 
    redirect '/admin/login'
  end
end

get '/admin/markets/new' do
  @back_anchor_link = '/admin'
  @form_action_path = '/admin/markets/new'
  erb :'markets/new'
end

post '/admin/markets/new' do
  # no validation on server
  create_new_market(params)

  redirect '/admin'
end

get '/admin/market_dates/new' do
  @back_anchor_link = '/admin'
  @form_action_path = '/admin/market_dates/new'
  erb :'market_dates/new'
end

post '/admin/market_dates/new' do
  market_date = format_hash(params)

  market_date[:opening_time] = convert_date_time_array(params[:opening_time])
  market_date[:closing_time] = convert_date_time_array(params[:closing_time])
  
  create_new_market_date(market_date)
  redirect '/admin'
end