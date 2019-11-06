require 'bcrypt'

require_relative 'utility.rb'

def is_logged_in? 
  !!get_current_seller()
end

def get_current_user()
  return get_one_seller(session[:user_id])
end

def get_one_seller(seller_id)
  return nil unless !!seller_id

  conn = get_sql_connection()
  sql = "select * from sellers where seller_id = #{seller_id};"
  records = conn.exec(sql)
  conn.close()
  return format_hash(records.first)
end

#debug only
def get_all_sellers()
  conn = get_sql_connection()
  sql = "select * from sellers;"
  records = conn.exec(sql)
  conn.close()
  return format_hash_arrays(records.to_a)
end

def create_new_seller(seller)
  password_digest = BCrypt::Password.create(seller[:password])

  conn = get_sql_connection()
  sql = "INSERT INTO sellers (email, seller_name,password_digest, website) VALUES ($1::text, $2::text, $3::text, $4::text);"
  conn.exec_params(sql, [seller[:email], seller[:seller_name], password_digest, seller[:website]])
  conn.close()
end


def find_seller_by_email(email)
  return nil unless !!email
  conn = get_sql_connection()

  sql = "select * from sellers where email = $1::text;"
  records = conn.exec_params(sql, [email])
  conn.close()

  return format_hash(records.first)
end 



