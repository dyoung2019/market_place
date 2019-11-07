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

def create_new_market(market)
  lines_of_sql = ["INSERT INTO markets",
    "(",
      "market_name,",
      "market_description,",
      "market_location",
    ")",
    "VALUES (",
      "$1::text,",
      "$2::text,",
      "$3::text",
    ") RETURNING market_id;"
  ]
  return run_sql(lines_of_sql.join(" "), [
    market[:market_name],
    market[:market_description],
    market[:market_location]
  ])
end