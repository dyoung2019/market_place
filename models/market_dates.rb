require_relative 'utility'

def find_latest_market_date(market_id, current_date)
  sql = "select * from market_dates where market_id = $1::int and closing_time >= $2::timestamp order by opening_time asc, market_date_id asc fetch first 1 rows only;"
  # return records.first
  return run_sql(records, [market_id, current_date]).first;
end