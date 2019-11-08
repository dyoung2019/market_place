require 'pg'
require 'date'

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
  conn = PG::connect( ENV['DATABASE_URL'] || { dbname: "market-place-app-db" })
  records = conn.exec_params(sql, sql_params)
  conn.close
  return format_hash_arrays(records.to_a)
end

def convert_timestamp(timestamp)
  opening_time = Time.parse(timestamp)
  return {
    :date => opening_time.strftime("%F"),
    :time => opening_time.strftime("%H:%M")
  }
end 

def convert_date_time_array(date_time_array)
  return Time.parse(date_time_array.join(" "))
end 

def format_market_time(from, to)
  opening_time = Time.parse(from)
  closing_time = Time.parse(to)

  if opening_time.to_date() === closing_time.to_date()
    return "#{opening_time.strftime("%A %d %b %Y")} #{opening_time.strftime("%r")} - #{closing_time.strftime("%r")}"
  else 
    return "#{opening_time.strftime("%A %d %b %Y")} #{opening_time.strftime("%r")} - #{closing_time.strftime("%A %d %b %Y")} #{closing_time.strftime("%r")}"
  end
end 