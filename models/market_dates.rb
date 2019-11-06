require_relative 'utility'
require_relative 'stalls'

def insert_stalls_and_sale_items(market_date)
  
  # binding.pry
  
  if !!market_date 
    market_date_id = market_date[:market_date_id]
    
    stalls = find_all_stalls_on_market_date(market_date_id)
    sale_items = find_all_sale_items_on_market_date(market_date_id)
    
    # binding.pry

    market_date[:stalls] = stalls
    market_date[:sale_items] = sale_items
  end


end  

def find_all_market_dates_by_market(market_id)
  sql = "select * from market_dates where market_id = $1::int;"
  return run_sql(sql, [market_id]);
end

def find_one_market_date(market_date_id)
  sql = "select * from market_dates where market_date_id = $1::int;"
  market_date = run_sql(sql, [market_date_id]).first;
end

def find_latest_market_date(market_id, current_date)
  sql = "select * from market_dates where market_id = $1::int and closing_time >= $2::timestamp order by opening_time asc, market_date_id asc fetch first 1 rows only;"
  # return records.first
  return run_sql(sql, [market_id, current_date]).first;
end