get '/admin' do
  @sellers = get_all_sellers()
  @stalls = []
  @products = []

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
    erb :'sellers/details'
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
    @form_action_path = '/admin/seller/edit'
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
