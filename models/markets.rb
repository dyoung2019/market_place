require_relative 'utility'


def get_all_markets() 
  conn = get_sql_connection()
  sql = "SELECT * from markets"
  records = conn.exec(sql)
  conn.close()
  markets = format_hash_arrays(records.to_a)

  # binding.pry
  return markets
end

def find_one_market(market_id)
  conn = get_sql_connection()
  sql = "SELECT * from markets where market_id = #{market_id}"
  records = conn.exec(sql)
  conn.close()
  market = format_hash(records.first)
  return market
end

