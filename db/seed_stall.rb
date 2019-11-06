require_relative '../models/stalls.rb'

stall_info = { 
  market_date_id: 1,
  seller_id: 1,
  stall_name: "Donut Hut",
  stall_location: "Table B1",
  website: "www.donuthut.com.au",
  opening_time: "Sun 10 Nov 2019 12:00",
  closing_time: "Sun 10 Nov 2019 14:00"
}

create_new_stall(stall_info)