
def find_all_stalls_by_market_date(market_date_id)
  return nil unless !!market_date_id
  sql = "select * from stalls where market_date_id = $1::int;"
  return run_sql(sql, [market_date_id])
end

def find_all_stalls_by_seller(seller_id)
  return nil unless !!seller_id
  sql = "select * from stalls where seller_id = $1::int;"
  return run_sql(sql, [seller_id])
end

def get_all_stalls() 
  sql = "select * from stalls;"
  return run_sql(sql, [])
end