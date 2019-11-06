require 'pg'

def get_sql_connection()
  return PG::connect(dbname: "market-place-app-db")
end

def format_hash(record)
  return nil unless !!record
  return record.map { |k, v| [k.downcase.to_sym, v ] }.to_h
end 

def format_hash_arrays(records)
  return records.map do |record| 
    format_hash(record)
  end
end