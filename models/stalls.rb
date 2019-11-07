require_relative 'utility'

def stall_changes_allowed?(stall_id)
  stall = find_one_stall_by_id(stall_id)
  update_allowed = !!stall && seller_logged_in?(stall[:seller_id])
  return update_allowed
end

def find_all_stalls_on_market_date(market_date_id)
  return nil unless !!market_date_id
  sql = "select * from stalls where market_date_id = $1::int;"
  return run_sql(sql, [market_date_id])
end

def find_all_stalls_by_seller(seller_id)
  return nil unless !!seller_id
  sql = "select * from stalls where seller_id = $1::int;"
  return run_sql(sql, [seller_id])
end

def find_one_stall_by_id(stall_id) 
  return nil unless !!stall_id
  sql = "select * from stalls where stall_id = $1::int;"
  return run_sql(sql, [stall_id]).first
end

def get_all_stalls() 
  sql = "select * from stalls;"
  return run_sql(sql, [])
end

def create_new_stall(stall_info)
  lines_of_sql = ["insert into stalls (",
    " market_date_id,",
    " seller_id,",
    " stall_name,",
    " stall_location,",
    " website,",
    " opening_time,",
    " closing_time)",
  " VALUES (",
    " $1::int,",
    " $2::int,",
    " $3::text,",
    " $4::text,",
    " $5::text,",
    " $6::timestamp,",
    " $7::timestamp",
  ") RETURNING stall_id;"
  ]

  return run_sql(lines_of_sql.join(), [
    stall_info[:market_date_id],
    stall_info[:seller_id],
    stall_info[:stall_name],
    stall_info[:stall_location],
    stall_info[:website],
    stall_info[:opening_time],
    stall_info[:closing_time]
  ])
end

def update_stall(stall_info)
  lines_of_sql = ["update stalls",
    "SET",
      "stall_name = $2::text,",
      "stall_location = $3::text,",
      "website = $4::text,",
      "opening_time = $5::timestamp,",
      "closing_time = $6::timestamp",
    "where stall_id = $1::int;" 
  ]

  run_sql(lines_of_sql.join(" "), [
    stall_info[:stall_id],
    stall_info[:stall_name],
    stall_info[:stall_location],
    stall_info[:website],
    stall_info[:opening_time],
    stall_info[:closing_time]
  ])
end

def delete_stall(stall_id) 
  run_sql("delete from stalls where stall_id = $1::int;", [stall_id])
end