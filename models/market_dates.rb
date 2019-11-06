require_relative 'utility'

def find_latest_market_date(market_id, current_date)
  conn = get_sql_connection()
  sql = "select * from market_dates where market_id = #{market_id} and closing_time >= '#{current_date}' order by opening_time asc, market_date_id asc fetch first 1 rows only;"
  records = conn.exec(sql)
  conn.close

  # return records.first
  return format_hash(records.first)
end