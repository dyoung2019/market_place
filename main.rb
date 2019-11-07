     
require 'sinatra'

if settings.development? 
  require 'sinatra/reloader'
  require 'pry'

  also_reload('controllers/*', 'models/*')
end

# routes 

enable :sessions # a table for server to write who is who

require_relative 'models/sellers.rb'
require_relative 'models/stalls.rb'
require_relative 'models/products.rb'

get '/' do
  erb :index
end

require_relative 'controllers/admin_controller.rb'
require_relative 'controllers/seller_controller.rb'
require_relative 'controllers/market_controller.rb'
require_relative 'controllers/product_controller.rb'
require_relative 'controllers/market_date_controller.rb'





