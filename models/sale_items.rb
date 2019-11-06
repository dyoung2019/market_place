require_relative 'utility'

def find_all_sale_items_on_market_date(market_date_id)
  sql = "SELECT i.*, s.stall_name, p.product_name  from sale_items i inner join stalls s on s.stall_id = i.stall_id inner join products p on p.product_id = i.product_id where s.market_date_id = $1::int;"
  return run_sql(sql, [market_date_id])
end