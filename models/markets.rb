require_relative 'utility'

def get_all_markets() 
  sql = "SELECT * from markets;"
  return run_sql(sql, [])
end

def find_one_market(market_id)
  sql = "SELECT * from markets where market_id = $1::int;"
  records = run_sql(sql, [market_id])
  return records.first
end

