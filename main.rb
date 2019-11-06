     
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
  @sellers = get_all_sellers()
  @stalls = []
  @products = []

  erb :index
end

require_relative 'controllers/sellers.rb'
require_relative 'controllers/markets.rb'
require_relative 'controllers/products.rb'





