CREATE TABLE "olist_customers_dataset" (
  "customer_id" varchar PRIMARY KEY,
  "customer_unique_id" varchar,
  "customer_zip_code_prefix" varchar NOT NULL,
  "customer_city" varchar,
  "customer_state" varchar
);

CREATE TABLE "olist_geolocation_dataset" (
  "geolocation_zip_code_prefix" varchar,
  "geolocation_lat" float,
  "geolocation_lng" float,
  "geolocation_city" varchar,
  "geolocation_state" varchar
);

CREATE TABLE "olist_order_items_dataset" (
  "order_id" varchar NOT NULL,
  "order_item_id" int,
  "product_id" varchar NOT NULL,
  "seller_id" varchar NOT NULL,
  "shipping_limit_date" timestamp,
  "price" float,
  "freight_value" float
);

CREATE TABLE "olist_order_payments_dataset" (
  "order_id" varchar NOT NULL,
  "payment_sequential" int,
  "payment_type" varchar,
  "payment_installments" int,
  "payment_value" float
);

CREATE TABLE "olist_order_reviews_dataset" (
  "review_id" varchar PRIMARY KEY,
  "order_id" varchar NOT NULL,
  "review_score" int,
  "review_comment_title" varchar,
  "review_comment_message" varchar,
  "review_creation_date" timestamp,
  "review_answer_timestamp" timestamp
);

CREATE TABLE "olist_orders_dataset" (
  "order_id" varchar PRIMARY KEY,
  "customer_id" varchar NOT NULL,
  "order_status" varchar,
  "order_purchase_timestamp" timestamp,
  "order_approved_at" timestamp,
  "order_delivered_carrier_date" timestamp,
  "order_delivered_customer_date" timestamp,
  "order_estimated_delivery_date" timestamp
);

CREATE TABLE "olist_products_dataset" (
  "product_id" varchar PRIMARY KEY,
  "product_category_name" varchar NOT NULL,
  "product_name_lenght" int,
  "product_description_lenght" int,
  "product_photos_qty" int,
  "product_weight_g" float,
  "product_length_cm" float,
  "product_height_cm" float,
  "product_width_cm" float
);

CREATE TABLE "olist_sellers_dataset" (
  "seller_id" varchar PRIMARY KEY,
  "seller_zip_code_prefix" varchar NOT NULL,
  "seller_city" varchar,
  "seller_state" varchar
);

CREATE TABLE "product_category_name_translation" (
  "product_category_name" varchar PRIMARY KEY,
  "product_category_name_english" varchar
);

ALTER TABLE "olist_orders_dataset" ADD FOREIGN KEY ("customer_id") REFERENCES "olist_customers_dataset" ("customer_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_order_items_dataset" ADD FOREIGN KEY ("order_id") REFERENCES "olist_orders_dataset" ("order_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_order_items_dataset" ADD FOREIGN KEY ("product_id") REFERENCES "olist_products_dataset" ("product_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_order_items_dataset" ADD FOREIGN KEY ("seller_id") REFERENCES "olist_sellers_dataset" ("seller_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_order_payments_dataset" ADD FOREIGN KEY ("order_id") REFERENCES "olist_orders_dataset" ("order_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_order_reviews_dataset" ADD FOREIGN KEY ("order_id") REFERENCES "olist_orders_dataset" ("order_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "olist_products_dataset" ADD FOREIGN KEY ("product_category_name") REFERENCES "product_category_name_translation" ("product_category_name") DEFERRABLE INITIALLY IMMEDIATE;
