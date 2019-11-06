require_relative '../models/utility.rb'

get '/sellers/signup' do
  erb :'sellers/signup'
end

post '/sellers/signup' do
  seller = format_hash(params)

  create_new_seller(seller)

  redirect '/'
end

get '/sellers/login' do
  erb :'sellers/login'
end

def retry_user_login()
  @error_message = 'Cannot login with email / password combination' 
  erb :'sellers/login'
end

post '/sellers/login' do
  seller = find_seller_by_email(params[:email])

  if !seller
    retry_user_login()
  else
    password_digest = BCrypt::Password.create(params[:password])

    if password_digest == seller[:password_digest]
      session[:user_id] = seller[:seller_id]
      return '/'
    else
      retry_user_login()
    end
  end
end

get '/sellers/:seller_id' do
  @seller = get_one_seller(params[:seller_id])
  erb :'sellers/details'
end

get '/sellers/:seller_id/edit' do
  seller = get_current_seller()

  return "NOPE SELLER" unless !!seller

  if seller[:seller_id] != session[:user_id] 
    return "NOPE"
  end
  
  erb :'sellers/edit'
end
