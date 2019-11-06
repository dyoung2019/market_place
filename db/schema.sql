CREATE TABLE markets (
  market_id serial primary key,
  market_name text,
  market_description text,
  market_location text
);

CREATE TABLE market_dates (
  market_date_id SERIAL primary key,
  market_id integer,
  date_name TEXT,
  date_description TEXT,
  date_location TEXT,
  opening_time timestamp,
  closing_time timestamp
);

CREATE TABLE sellers (
  seller_id SERIAL primary key,
  email_address TEXT,
  seller_name text,
  password_digest TEXT,
  website text
);

CREATE TABLE products (
  product_id SERIAL primary key,
  seller_id INTEGER,
  product_name TEXT,
  product_description TEXT
);

CREATE TABLE stalls (
  id SERIAL primary key,
  market_date_id INTEGER,
  seller_id INTEGER,
  stall_name text,
  stall_location text,
  website text,
  opening_time timestamp,
  closing_time timestamp,
);

CREATE TABLE inventory (
  id SERIAL primary key,
  product_id INTEGER,
  quantity INTEGER,
  notes TEXT,
  is_available BOOLEAN
);

INSERT INTO markets (market_name, market_description, market_location) VALUES ('Melbourne Farmers Market', 'Local markets hosted every Sunday', 'Federation Square.');

INSERT INTO market_dates (market_id, date_name, date_description, date_location, opening_time, closing_time) VALUES(1, 'Mid-November Market', 'Celebrating Spring!', 'Along river-side on Fed. Square', 'Sun 10 Nov 08:30:00 2019 AEST', 'Sun 10 Nov 16:30:00 2019 AEST');

DO $$
DECLARE 
  market_id INTEGER := 1;
BEGIN
  market_id = 3;

  select market_id = count(*) from 

  RAISE NOTICE '%', market_id;
END $$;