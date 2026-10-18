DROP TABLE IF EXISTS olist_order_reviews_dataset, olist_order_payments_dataset, 
  olist_order_items_dataset, olist_orders_dataset, olist_customers_dataset, 
  olist_sellers_dataset, olist_products_dataset, product_category_name_translation, 
  olist_geolocation_dataset CASCADE;

CREATE TABLE olist_geolocation_dataset (
  geolocation_zip_code_prefix varchar,
  geolocation_lat float,
  geolocation_lng float,
  geolocation_city varchar,
  geolocation_state varchar
);

CREATE TABLE product_category_name_translation (
  product_category_name varchar PRIMARY KEY,
  product_category_name_english varchar
);

CREATE TABLE olist_products_dataset (
  product_id varchar PRIMARY KEY,
  product_category_name varchar,
  product_name_lenght int,
  product_description_lenght int,
  product_photos_qty int,
  product_weight_g float,
  product_length_cm float,
  product_height_cm float,
  product_width_cm float
);

CREATE TABLE olist_sellers_dataset (
  seller_id varchar PRIMARY KEY,
  seller_zip_code_prefix varchar,
  seller_city varchar,
  seller_state varchar
);

CREATE TABLE olist_customers_dataset (
  customer_id varchar PRIMARY KEY,
  customer_unique_id varchar,
  customer_zip_code_prefix varchar,
  customer_city varchar,
  customer_state varchar
);

CREATE TABLE olist_orders_dataset (
  order_id varchar PRIMARY KEY,
  customer_id varchar REFERENCES olist_customers_dataset(customer_id),
  order_status varchar,
  order_purchase_timestamp timestamp,
  order_approved_at timestamp,
  order_delivered_carrier_date timestamp,
  order_delivered_customer_date timestamp,
  order_estimated_delivery_date timestamp
);

CREATE TABLE olist_order_items_dataset (
  order_id varchar REFERENCES olist_orders_dataset(order_id),
  order_item_id int,
  product_id varchar REFERENCES olist_products_dataset(product_id),
  seller_id varchar REFERENCES olist_sellers_dataset(seller_id),
  shipping_limit_date timestamp,
  price float,
  freight_value float
);

CREATE TABLE olist_order_payments_dataset (
  order_id varchar REFERENCES olist_orders_dataset(order_id),
  payment_sequential int,
  payment_type varchar,
  payment_installments int,
  payment_value float
);

CREATE TABLE olist_order_reviews_dataset (
  review_id varchar,
  order_id varchar REFERENCES olist_orders_dataset(order_id),
  review_score int,
  review_comment_title varchar,
  review_comment_message text,
  review_creation_date timestamp,
  review_answer_timestamp timestamp
);