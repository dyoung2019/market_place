require_relative '..models/sellers.rb'

get '/stalls/:stall_id' do
  return 'NO_ID' unless !!params[:stall_id]
end