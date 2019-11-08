require_relative '../models/stalls.rb'
require_relative '../models/sale_items.rb'
require_relative '../models/market_dates.rb'

get '/market_dates/:market_date_id' do
  market_date_id = params[:market_date_id]
  market_date = find_one_market_date(market_date_id)
  insert_stalls_and_sale_items(market_date)

  @seller_account_path = "/market_dates/#{market_date_id}/seller"
  @seller_log_out_path = "/market_dates/#{market_date_id}/login"
  # @seller_sign_up_path = '/seller/signup'
  @seller_log_in_path = "/market_dates/#{market_date_id}/login"
  
  @market_date = market_date
  @view_stall_base_path = "/market_dates/#{market_date_id}/stalls"
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

get '/market_dates/:market_date_id/stalls/:stall_id' do
  stall_id = params[:stall_id]

  update_allowed = stall_changes_allowed?(stall_id)
  redirect "/market_dates/#{params[:market_date_id]}/" unless update_allowed

  @stall = find_one_stall_by_id(stall_id)
  
  @edit_link_allowed = !!@stall && seller_logged_in?(@stall[:seller_id])
  @delete_action_path = "/market_dates/#{params[:market_date_id]}/stalls/#{stall_id}"
  @edit_action_path = "/market_dates/#{params[:market_date_id]}/stalls/#{stall_id}/edit"

  # binding.pry
  erb :'stalls/view'
end 

delete '/market_dates/:market_date_id/stalls/:stall_id' do
  stall_id = params[:stall_id]

  update_allowed = stall_changes_allowed?(stall_id)
  if update_allowed
    delete_stall(stall_id)

    redirect "/market_dates/#{params[:market_date_id]}/seller"
  else 
    redirect "/market_dates/#{params[:market_date_id]}"
  end
end

get '/market_dates/:market_date_id/stalls/:stall_id/edit' do
  stall_id = params[:stall_id]
  update_allowed = stall_changes_allowed?(stall_id)

  if update_allowed 
    @stall = find_one_stall_by_id(stall_id)

    @form_action_path = "/market_dates/#{params[:market_date_id]}/stalls/#{stall_id}/edit"
    @opening_time = convert_timestamp(@stall[:opening_time])
    @closing_time = convert_timestamp(@stall[:closing_time])

    # binding.pry
    erb :'stalls/edit'  
  else
    redirect "/market_dates/#{params[:market_date_id]}" 
  end
end 

patch '/market_dates/:market_date_id/stalls/:stall_id/edit' do
  # return 'PATCH'

  stall_id = params[:stall_id]
  @stall = find_one_stall_by_id(stall_id)

  update_allowed = stall_changes_allowed?(stall_id)
  redirect "/market_dates/#{params[:market_date_id]}" unless update_allowed
  
  stall_info = format_stall_info(params)
  update_stall(stall_info)

  # binding.pry
  # redirect on success 
  redirect "/market_dates/#{params[:market_date_id]}/stalls/#{params[:stall_id]}"
end