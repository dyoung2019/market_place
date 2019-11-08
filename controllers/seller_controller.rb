require_relative '../models/utility.rb'

get '/sellers/signup' do
  erb :'sellers/signup'
end

post '/sellers/signup' do
  seller = format_hash(params)

  create_new_seller(seller)

  redirect '/admin'
end

# get '/sellers/login' do
#   erb :'sellers/login'
# end

# post '/sellers/login' do
#   db_record = find_seller_by_email(params[:email])

#   # bcrypt on db password 
#   password_accepted = !!db_record && BCrypt::Password.new(db_record[:password_digest]) == params[:password]

#   if password_accepted 
#     session[:user_id] = db_record[:seller_id]
#     redirect '/'
#     # return 'password YES'
#   else
#     @error_message = 'Cannot login with email / password combination' 
#     erb :'sellers/login'
#     # return 'password NOPE'
#   end 
# end

# delete '/sellers/login' do
#   if logged_in?
#     session[:user_id] = nil
#   end
#   redirect '/sellers/login'
# end

get '/sellers/:seller_id' do
  @seller = get_one_seller(params[:seller_id])
  erb :'sellers/details'
end

# get '/sellers/:seller_id/edit' do
#   seller = get_current_seller()

#   return "NOPE SELLER" unless !!seller

#   if seller[:seller_id] != session[:user_id] 
#     return "NOPE"
#   end
  
#   erb :'sellers/edit'
# end
