require 'bcrypt'

require_relative 'utility'

def logged_in? 
  !!get_current_seller()
end

def seller_logged_in?(seller_id)
  session[:user_id] === seller_id
end

def get_current_seller()
  return get_one_seller(session[:user_id])
end

def log_out_of_session()
  session[:user_id] = nil
end 

def get_one_seller(seller_id)
  return nil unless !!seller_id

  sql = "select * from sellers where seller_id = $1::int;"
  return run_sql(sql, [seller_id]).first
end

#debug only
def get_all_sellers()
  sql = "select * from sellers;"
  return run_sql(sql, [])
end

def create_new_seller(seller)
  password_digest = BCrypt::Password.create(seller[:password])

  sql = "INSERT INTO sellers (email, seller_name, password_digest, website) VALUES ($1::text, $2::text, $3::text, $4::text);"

  run_sql(sql, [seller[:email], seller[:seller_name], password_digest, seller[:website]])
end


def find_seller_by_email(email)
  return nil unless !!email
  sql = "select * from sellers where email = $1::text;"
  return run_sql(sql, [email]).first
end 

def seller_now_logged_in?(email, password)
  db_record = find_seller_by_email(email)

  # bcrypt on db password 
  password_accepted = !!db_record && BCrypt::Password.new(db_record[:password_digest]) == password

  result = {:password_accepted => password_accepted}

  if password_accepted 
    session[:user_id] = db_record[:seller_id]
  end   

  return password_accepted
end

def update_seller(seller) 
  lines_of_sql = ["UPDATE sellers",
    "SET",
    "seller_name = $2::text,",
    "website = $3::text",
    "WHERE seller_id = $1::int;"
  ]
  run_sql(lines_of_sql.join(" "), [seller[:seller_id],
   seller[:seller_name],
   seller[:website]
  ])
end 


