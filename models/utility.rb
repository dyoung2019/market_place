require 'pg'

def format_hash(record)
  return nil unless !!record
  return record.map { |k, v| [k.downcase.to_sym, v ] }.to_h
end 

def format_hash_arrays(records)
  return records.map do |record| 
    format_hash(record)
  end
end

def run_sql(sql, sql_params)
  conn = PG::connect(dbname: "market-place-app-db")
  records = conn.exec_params(sql, sql_params)
  conn.close
  return format_hash_arrays(records.to_a)
end