-- 1. Data Counts
-- Disini data dihitung per tabel dengan menggabungkannya menjadi 1 tabel saja
-- menggunakan UNION ALL
-- Hasil: semua tabel memiliki jumlah data yang sesuai
-- Output:
-- "table_name"	"count"
-- "product_category_name_translation"	71
-- "olist_sellers_dataset"	3095
-- "olist_products_dataset"	32951
-- "olist_order_payments_dataset"	103886
-- "olist_customers_dataset"	99441
-- "olist_orders_dataset"	99441
-- "olist_geolocation_dataset"	1000163
-- "olist_order_items_dataset"	112650
-- "olist_order_reviews_dataset"	99224
SELECT 'olist_customers_dataset' AS table_name, COUNT(*) FROM olist_customers_dataset
UNION ALL 
SELECT 'olist_orders_dataset', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'olist_order_items_dataset', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'olist_order_payments_dataset', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'olist_order_reviews_dataset', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'olist_products_dataset', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'olist_sellers_dataset', COUNT(*) FROM olist_sellers_dataset
UNION ALL
SELECT 'olist_geolocation_dataset', COUNT(*) FROM olist_geolocation_dataset
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) FROM product_category_name_translation;

-- 2. Missing Values
-- Mengecek setiap baris dalam table dan menghitung jumlah baris yang kosong / NULL.
-- Proses ini dilakukan terhadap setiap baris dari masing masing kolom dari masing-masing tabel.

-- Tabel olist_customers_dataset
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_customer_id"	"missing_customer_unique_id"	"missing_zip_code_prefix"	"missing_city"	"missing_state"
-- 99441	0	0	0	0	0
SELECT * FROM olist_customers_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
  COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS missing_customer_unique_id,
  COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS missing_zip_code_prefix,
  COUNT(*) FILTER (WHERE customer_city IS NULL) AS missing_city,
  COUNT(*) FILTER (WHERE customer_state IS NULL) AS missing_state
FROM olist_customers_dataset;

-- Tabel olist_geolocation_dataset
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_zip"	"missing_lat"	"missing_lng"	"missing_city"	"missing_state"
-- 1000163	0	0	0	0	0
SELECT * FROM olist_geolocation_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE geolocation_zip_code_prefix IS NULL) AS missing_zip,
  COUNT(*) FILTER (WHERE geolocation_lat IS NULL) AS missing_lat,
  COUNT(*) FILTER (WHERE geolocation_lng IS NULL) AS missing_lng,
  COUNT(*) FILTER (WHERE geolocation_city IS NULL) AS missing_city,
  COUNT(*) FILTER (WHERE geolocation_state IS NULL) AS missing_state
FROM olist_geolocation_dataset;
	
-- Tabel olist_order_items_dataset
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_order_id"	"missing_order_item_id"	"missing_product_id"	"missing_seller_id"	"missing_shipping_limit_date"	"missing_price"	"missing_freight_value"
-- 112650	0	0	0	0	0	0	0
SELECT * FROM olist_order_items_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
  COUNT(*) FILTER (WHERE order_item_id IS NULL) AS missing_order_item_id,
  COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
  COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_id,
  COUNT(*) FILTER (WHERE shipping_limit_date IS NULL) AS missing_shipping_limit_date,
  COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
  COUNT(*) FILTER (WHERE freight_value IS NULL) AS missing_freight_value
FROM olist_order_items_dataset;

-- Tabel olist_order_payments_dataset
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_order_id"	"missing_payment_sequential"	"missing_payment_type"	"missing_payment_installments"	"missing_payment_value"
-- 103886	0	0	0	0	0
SELECT * FROM olist_order_payments_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
  COUNT(*) FILTER (WHERE payment_sequential IS NULL) AS missing_payment_sequential,
  COUNT(*) FILTER (WHERE payment_type IS NULL) AS missing_payment_type,
  COUNT(*) FILTER (WHERE payment_installments IS NULL) AS missing_payment_installments,
  COUNT(*) FILTER (WHERE payment_value IS NULL) AS missing_payment_value
FROM olist_order_payments_dataset;

-- Tabel olist_order_reviews_dataset
-- Hasil: Banyak kolom comment_title dan comment_message yang kosong dikarenakan banyak
-- pembeli yang meninggalkan rating dalam bentuk star saja, tanpa mengisi komentarnya.
-- Output:
-- "total_rows"	"missing_review_id"	"missing_order_id"	"missing_review_score"	"missing_comment_title"	"missing_comment_message"	"missing_creation_date"	"missing_answer_timestamp"
-- 99224	0	0	0	87656	58247	0	0
SELECT * FROM olist_order_reviews_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE review_id IS NULL) AS missing_review_id,
  COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
  COUNT(*) FILTER (WHERE review_score IS NULL) AS missing_review_score,
  COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS missing_comment_title,
  COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS missing_comment_message,
  COUNT(*) FILTER (WHERE review_creation_date IS NULL) AS missing_creation_date,
  COUNT(*) FILTER (WHERE review_answer_timestamp IS NULL) AS missing_answer_timestamp
FROM olist_order_reviews_dataset;

-- Tabel olist_orders_dataset
-- Hasil: terdapat beberapa null value di kolom missing_approved_at, dan banyak null values di kolom missing_delivered_carrier dan missing_delivered_customer
-- Output:
-- "total_rows"	"missing_order_id"	"missing_customer_id"	"missing_order_status"	"missing_purchase_timestamp"	"missing_approved_at"	"missing_delivered_carrier"	"missing_delivered_customer"	"missing_estimated_delivery"
-- 99441	0	0	0	0	160	1783	2965	0
SELECT * FROM olist_orders_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
  COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
  COUNT(*) FILTER (WHERE order_status IS NULL) AS missing_order_status,
  COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS missing_purchase_timestamp,
  COUNT(*) FILTER (WHERE order_approved_at IS NULL) AS missing_approved_at,
  COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL) AS missing_delivered_carrier,
  COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS missing_delivered_customer,
  COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL) AS missing_estimated_delivery
FROM olist_orders_dataset;

-- Tabel olist_products_dataset
-- Hasil: Terdapat sejumlah missing values yang ada di setiap kolom, yang sepertinya saling 
-- berkaitan dengan produk tertentu
-- Output:
-- "total_rows"	"missing_product_id"	"missing_category"	"missing_name_lenght"	"missing_description_lenght"	"missing_photos_qty"	"missing_weight"	"missing_length"	"missing_height"	"missing_width"
-- 32951	0	610	610	610	610	2	2	2	2
SELECT * FROM olist_products_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
  COUNT(*) FILTER (WHERE product_category_name IS NULL) AS missing_category,
  COUNT(*) FILTER (WHERE product_name_lenght IS NULL) AS missing_name_lenght,
  COUNT(*) FILTER (WHERE product_description_lenght IS NULL) AS missing_description_lenght,
  COUNT(*) FILTER (WHERE product_photos_qty IS NULL) AS missing_photos_qty,
  COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS missing_weight,
  COUNT(*) FILTER (WHERE product_length_cm IS NULL) AS missing_length,
  COUNT(*) FILTER (WHERE product_height_cm IS NULL) AS missing_height,
  COUNT(*) FILTER (WHERE product_width_cm IS NULL) AS missing_width
FROM olist_products_dataset;

-- Tabel olist_sellers_dataset
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_seller_id"	"missing_zip"	"missing_city"	"missing_state"
-- 3095	0	0	0	0
SELECT * FROM olist_sellers_dataset;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_id,
  COUNT(*) FILTER (WHERE seller_zip_code_prefix IS NULL) AS missing_zip,
  COUNT(*) FILTER (WHERE seller_city IS NULL) AS missing_city,
  COUNT(*) FILTER (WHERE seller_state IS NULL) AS missing_state
FROM olist_sellers_dataset;

-- Tabel product_category_name_translation
-- Hasil: Tidak ditemukan missing values di kolom manapun
-- Output:
-- "total_rows"	"missing_category_name"	"missing_category_name_english"
-- 71	0	0
SELECT * FROM product_category_name_translation;
SELECT
  COUNT(*) AS total_rows,
  COUNT(*) FILTER (WHERE product_category_name IS NULL) AS missing_category_name,
  COUNT(*) FILTER (WHERE product_category_name_english IS NULL) AS missing_category_name_english
FROM product_category_name_translation;

-- 3. Duplikasi
-- Mengecek duplikasi di SEMUA tabel. Untuk tabel dengan primary key, 
-- duplikasi di kolom PK itu sendiri sudah mustahil terjadi (dicegah 
-- otomatis oleh database), sehingga yang dicek adalah duplikasi pada 
-- kombinasi kolom lain. Untuk tabel tanpa primary key, dicek duplikasi 
-- pada seluruh kolom sekaligus.

-- Tabel olist_customers_dataset (PK: customer_id)
-- Cek apakah ada baris dengan semua kolom NON-PK identik
-- Hasil: Interpretasi wajar karena setiap user pasti pernah order lebih dari 1 kali
-- Output(sample):
-- "customer_unique_id"	"customer_zip_code_prefix"	"customer_city"	"customer_state"	"jumlah"
-- "8d50f5eadf50201ccdcedfb9e2ac8455"	"04045"	"sao paulo"	"SP"	17
-- "ca77025e7201e3b30c44b472ff346268"	"51021"	"recife"	"PE"	7
-- Total rows: 2770
SELECT customer_unique_id, customer_zip_code_prefix, customer_city, customer_state, 
COUNT(*) AS jumlah
FROM olist_customers_dataset
GROUP BY customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- Table olist_geolocation_dataset (tanpa PK)
-- Cek duplikasi seluruh kolom
-- Hasil: Terdapat banyak duplikasi yang mengindikasikan bahwa memang terdapat banyak lokasi 
-- yang sama yang digunakan oleh seller ataupun pembeli
-- output(sample):
-- "geolocation_zip_code_prefix"	"geolocation_lat"	"geolocation_lng"	"geolocation_city"	"geolocation_state"	"jumlah"
-- "88220"	-27.102098999999946	-48.62961349999995	"itapema"	"SC"	314
-- "06414"	-23.495901469908656	-46.87468669635919	"barueri"	"SP"	189
-- Total rows: 128174
SELECT geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, 
       geolocation_city, geolocation_state, 
COUNT(*) AS jumlah
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, 
         geolocation_city, geolocation_state
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- Tabel olist_order_items_dataset (tanpa PK tunggal, identifier gabungan order_id + order_item_id)
-- Hasil: Tidak ditemukan duplikat
SELECT order_id, order_item_id, 
COUNT(*) AS jumlah
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- olist_order_payments_dataset (tanpa PK, identifier gabungan order_id + payment_sequential)
-- Hasil: Tidak ditemukan duplikat
SELECT order_id, payment_sequential, 
COUNT(*) AS jumlah
FROM olist_order_payments_dataset
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- Tabel olist_order_reviews_dataset (belum ada PK aktif, review_id seharusnya unik)
-- Hasil: terdapat sejumlah data duplikat yang mengindikasikan terdapat beberapa review redundant
-- Output(sample):
-- "review_id"	"jumlah"
-- "1fb4ddc969e6bea80e38deec00393a6f"	3
-- "38821b5c496b678cf91acc34892805ad"	3
-- Total rows: 789
SELECT review_id, 
COUNT(*) AS jumlah
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- Tabel olist_order_reviews_dataset
-- Tambahan: cek 1 order dengan lebih dari 1 review (relevan ke diskusi one-to-many kita)
-- Hasil: Terbukti bahwa 1 order bisa memiliki beberapa review
-- Output(sample):
-- "order_id"	"jumlah_review"
-- "8e17072ec97ce29f0e1f111e598b0c85"	3
-- "df56136b8031ecd28e200bb18e6ddb2e"	3
-- Total rows: 547
SELECT order_id, 
COUNT(*) AS jumlah_review
FROM olist_order_reviews_dataset
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY jumlah_review DESC;

-- Tabel olist_orders_dataset (PK: order_id)
-- Cek apakah ada baris dengan semua kolom non-PK identik (jarang terjadi, tapi tetap dicek)
-- Hasil: Tidak ada data duplikat
SELECT customer_id, order_status, order_purchase_timestamp, order_approved_at,
       order_delivered_carrier_date, order_delivered_customer_date, 
       order_estimated_delivery_date, COUNT(*) AS jumlah
FROM olist_orders_dataset
GROUP BY customer_id, order_status, order_purchase_timestamp, order_approved_at,
         order_delivered_carrier_date, order_delivered_customer_date, 
         order_estimated_delivery_date
HAVING COUNT(*) > 1;

-- Tabel olist_products_dataset (PK: product_id)
-- Mengecek apakah 610 baris missing tadi adalah baris yang sama
-- Hasil: Benar, baris missing berasal dari data yang sama.
-- Output:
-- "jumlah_baris_semua_kosong"
-- 610
SELECT COUNT(*) AS jumlah_baris_semua_kosong
FROM olist_products_dataset
WHERE product_category_name IS NULL
  AND product_name_lenght IS NULL
  AND product_description_lenght IS NULL
  AND product_photos_qty IS NULL;
  
-- Tabel olist_products_dataset
-- Cek duplikasi kolom non-PK
-- Hasil: terdapat sejumlah data yang memiliki duplikat baik itu dengan banyak data null maupun tidak
-- Output(sample):
-- "product_category_name"	"product_name_lenght"	"product_description_lenght"	"product_photos_qty"	"product_weight_g"	"product_length_cm"	"product_height_cm"	"product_width_cm"	"jumlah"
-- [null] [null] [null] [null] 200	16	2	11	46
-- "fashion_calcados"	57	404	4	1400	22	12	33	17
-- Total rows: 463
SELECT product_category_name, product_name_lenght, product_description_lenght,
       product_photos_qty, product_weight_g, product_length_cm, 
       product_height_cm, product_width_cm, 
COUNT(*) AS jumlah
FROM olist_products_dataset
GROUP BY product_category_name, product_name_lenght, product_description_lenght,
         product_photos_qty, product_weight_g, product_length_cm, 
         product_height_cm, product_width_cm
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- Tabel olist_sellers_dataset (PK: seller_id)
-- Hasil: Terdapat sejumlah duplikat, hal ini wajar karena banyak seller yang tinggal di tempat yang sama
-- Output(sample):
-- "seller_zip_code_prefix"	"seller_city"	"seller_state"	"jumlah"
-- "14940"	"ibitinga"	"SP"	49
-- "13660"	"porto ferreira"	"SP"	9
-- Total rows: 511
SELECT seller_zip_code_prefix, seller_city, seller_state, COUNT(*) AS jumlah
FROM olist_sellers_dataset
GROUP BY seller_zip_code_prefix, seller_city, seller_state
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- product_category_name_translation (PK: product_category_name)
-- Tidak relevan dicek lebih lanjut, karena hanya 2 kolom dan salah 
-- satunya sudah PK — duplikasi di luar PK berarti duplikasi di kolom 
-- translation itu sendiri, sudah cukup dicek lewat COUNT biasa
-- Hasil: tidak ada duplikat
SELECT product_category_name_english, COUNT(*) AS jumlah
FROM product_category_name_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;

-- 3.1 Investigasi lebih lanjut untuk review_id
-- Lihat isi lengkap salah satu review_id yang duplikat, untuk tahu 
-- apakah barisnya benar-benar identik atau cuma review_id-nya yang sama
-- Hasil: Terdapat beberapa review yang "sama" di beberapa order yang berbeda, menunjukkan 
-- adanya potensi duplikasi data pada order order lain
-- Output:
-- "review_id"	"order_id"	"review_score"	"review_comment_title"	"review_comment_message"	"review_creation_date"	"review_answer_timestamp"
-- "1fb4ddc969e6bea80e38deec00393a6f"	"d6dde74bdeb424af6b660214881b4845"	5			"2017-08-11 00:00:00"	"2017-08-12 14:35:35"
-- "1fb4ddc969e6bea80e38deec00393a6f"	"afed4265a8b956d840bc032e54dfccd1"	5			"2017-08-11 00:00:00"	"2017-08-12 14:35:35"
-- "1fb4ddc969e6bea80e38deec00393a6f"	"3c1098cb17277b62cfc709c7a9b500f5"	5			"2017-08-11 00:00:00"	"2017-08-12 14:35:35"
SELECT *
FROM olist_order_reviews_dataset
WHERE review_id = '1fb4ddc969e6bea80e38deec00393a6f'
ORDER BY review_creation_date;

-- Cek juga salah satu order_id yang punya banyak review, lihat isi lengkapnya
-- Hasil: order_id sama dengan review_id yang berbeda (beberapa review di order yang sama?)
-- Output:
-- "review_id"	"order_id"	"review_score"	"review_comment_title"	"review_comment_message"	"review_creation_date"	"review_answer_timestamp"
-- "67c2557eb0bd72e3ece1e03477c9dff5"	"8e17072ec97ce29f0e1f111e598b0c85"	1		"Entregou o produto errado."	"2018-04-07 00:00:00"	"2018-04-08 22:48:27"
-- "2d6ac45f859465b5c185274a1c929637"	"8e17072ec97ce29f0e1f111e598b0c85"	1		"Comprei 3 unidades do produto vieram 2 unidades que não corresponde com o que comprei. Devido a minha opinião é negativa com relação a esse vendedor pois não não cumpriu com o prometido na venda."	"2018-04-07 00:00:00"	"2018-04-07 21:13:05"
-- "6e4c4086d9611ae4cc0cc65a262751fe"	"8e17072ec97ce29f0e1f111e598b0c85"	1		"Embora tenha entregue dentro do prazo, não enviou o produto que comprei."	"2018-04-14 00:00:00"	"2018-04-16 11:37:31"
SELECT *
FROM olist_order_reviews_dataset
WHERE order_id = '8e17072ec97ce29f0e1f111e598b0c85'
ORDER BY review_creation_date;

-- Hitung berapa banyak dari 789 baris duplikat review_id itu yang 
-- SELURUH kolomnya identik (true duplicate) vs yang cuma review_id-nya 
-- sama tapi isi lain beda (data anomali, bukan true duplicate)
-- Hasil: Tidak ada duplikat
SELECT review_id, order_id, review_score, review_comment_message, review_creation_date, 
COUNT(*) AS jumlah
FROM olist_order_reviews_dataset
GROUP BY review_id, order_id, review_score, review_comment_message, review_creation_date
HAVING COUNT(*) > 1
ORDER BY jumlah DESC;

-- 4. Distrubisi Data
-- Dilakukan pengecekan distribusi nilai pada kolom numerik untuk menemukan
-- nilai ekstrem yang berpotensi mendistorsi hasil analisis 
-- misal (harga 0, harga sangat tinggi, berat 0, rating diluar rentang 1-5 dsb.)

-- Tabel olist_order_items_dataset: price
-- Hasil: Harga berada pada rentang yang normal
-- Output: 
-- "harga_min"	"harga_max"	"harga_rata2"	"harga_median"	"jumlah_harga_nol"
-- 0.85	6735	120.65373901477311	74.99	0
SELECT 
  MIN(price) AS harga_min,
  MAX(price) AS harga_max,
  AVG(price) AS harga_rata2,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price) AS harga_median,
  COUNT(*) FILTER (WHERE price = 0) AS jumlah_harga_nol
FROM olist_order_items_dataset;

-- Tabel olist_order_items_dataset: freight_value
-- Hasil: terdapat beberapa harga di angka 0, hal ini wajar karena 
-- freight_value hanya ada ketika terdapat harga item yang terpisah
-- Output:
-- "freight_min"	"freight_max"	"freight_rata2"	"freight_median"	"jumlah_freight_nol"
-- 0	409.68	19.99031992898562	16.26	383
SELECT 
  MIN(freight_value) AS freight_min,
  MAX(freight_value) AS freight_max,
  AVG(freight_value) AS freight_rata2,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY freight_value) AS freight_median,
  COUNT(*) FILTER (WHERE freight_value = 0) AS jumlah_freight_nol
FROM olist_order_items_dataset;

-- Tabel olist_order_payments_dataset: payment_value
-- Hasil: Terdapat beberapa payment_value yang nilainya 0, bisa disebabkan beberapa hal
-- misal diskon hingga harga mencapai 0
-- Output:
-- "payment_min"	"payment_max"	"payment_rata2"	"payment_median"	"jumlah_payment_nol"
-- 0	13664.08	154.10038041698365	100	9
SELECT 
  MIN(payment_value) AS payment_min,
  MAX(payment_value) AS payment_max,
  AVG(payment_value) AS payment_rata2,
  PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY payment_value) AS payment_median,
  COUNT(*) FILTER (WHERE payment_value = 0) AS jumlah_payment_nol
FROM olist_order_payments_dataset;

-- Tabel olist_order_payments_dataset: payment_installments
-- Hasil: Terdapat nilai 0 yang mengindikasikan terdapat kesalahan pendataan,
-- karena installments harusnya memiliki berapa kali jumlah cicilan dilakukan (>1)
-- Output:
-- "installments_min"	"installments_max"	"installments_rata2"	"jumlah_installments_nol"
-- 0	24	2.8533488631769440	2
SELECT 
  MIN(payment_installments) AS installments_min,
  MAX(payment_installments) AS installments_max,
  AVG(payment_installments) AS installments_rata2,
  COUNT(*) FILTER (WHERE payment_installments = 0) AS jumlah_installments_nol
FROM olist_order_payments_dataset;

-- Tabel olist_products_dataset: product_weight_g
-- Hasil: teradapat berat maksimum 40k gram = 40kg dan terdapat berat min 0,
-- berat min 0 bisa saja terjadi jika "mungkin" berat item dibawah 1 kg
-- Output:
-- "berat_min"	"berat_max"	"berat_rata2"	"jumlah_berat_nol"
-- 0	40425	2276.4724877841513	4
SELECT 
  MIN(product_weight_g) AS berat_min,
  MAX(product_weight_g) AS berat_max,
  AVG(product_weight_g) AS berat_rata2,
  COUNT(*) FILTER (WHERE product_weight_g = 0) AS jumlah_berat_nol
FROM olist_products_dataset;

-- Tabel olist_products_dataset: dimensi (length, height, width)
-- Hasil: Distribusi panjang masih masuk akal
-- Output:
-- "length_min"	"length_max"	"height_min"	"height_max"	"width_min"	"width_max"
-- 7	105	2	105	6	118
SELECT 
  MIN(product_length_cm) AS length_min, MAX(product_length_cm) AS length_max,
  MIN(product_height_cm) AS height_min, MAX(product_height_cm) AS height_max,
  MIN(product_width_cm) AS width_min, MAX(product_width_cm) AS width_max
FROM olist_products_dataset;

-- olist_order_reviews_dataset: review_score (validasi range, seharusnya 1-5)
-- Hasil: Semua hasil berada di range yang sesuai
-- Output:
-- "score_min"	"score_max"	"score_di_luar_range"
-- 1	5	0
SELECT 
  MIN(review_score) AS score_min,
  MAX(review_score) AS score_max,
  COUNT(*) FILTER (WHERE review_score NOT BETWEEN 1 AND 5) AS score_di_luar_range
FROM olist_order_reviews_dataset;

-- 5. Outlier
-- Mendeteksi outlier menggunakan metode IQR (Interquartile Range).
-- Nilai dianggap outlier jika berada di luar rentang:
-- [Q1 - 1.5*IQR, Q3 + 1.5*IQR]

-- Tabel olist_order_items_dataset: price
-- Hasil: Terdapat sejumlah outlier
-- Output:
-- "lower_bound"	"upper_bound"	"jumlah_outlier"	"total_rows"
-- -102.6	277.4	8427	112650
WITH stats AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY price) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY price) AS q3
  FROM olist_order_items_dataset
),
bounds AS (
  SELECT 
    q1 - 1.5 * (q3 - q1) AS lower_bound,
    q3 + 1.5 * (q3 - q1) AS upper_bound
  FROM stats
)
SELECT 
  MAX(b.lower_bound) AS lower_bound, 
  MAX(b.upper_bound) AS upper_bound,
  COUNT(*) FILTER (WHERE price < b.lower_bound OR price > b.upper_bound) AS jumlah_outlier,
  COUNT(*) AS total_rows
FROM olist_order_items_dataset, bounds b;

-- Tabel olist_order_items_dataset: freight_value
-- Hasil: Terdapat sejumlah outlier
-- Output:
-- "lower_bound"	"upper_bound"	"jumlah_outlier"	"total_rows"
-- 0.9750000000000032	33.254999999999995	12134	112650
WITH stats AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY freight_value) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY freight_value) AS q3
  FROM olist_order_items_dataset
),
bounds AS (
  SELECT 
    q1 - 1.5 * (q3 - q1) AS lower_bound,
    q3 + 1.5 * (q3 - q1) AS upper_bound
  FROM stats
)
SELECT 
  MAX(b.lower_bound) AS lower_bound, 
  MAX(b.upper_bound) AS upper_bound,
  COUNT(*) FILTER (WHERE freight_value < b.lower_bound OR freight_value > b.upper_bound) AS jumlah_outlier,
  COUNT(*) AS total_rows
FROM olist_order_items_dataset, bounds b;

-- olist_order_payments_dataset: payment_value
-- Hasil: Terdapat sejumlah outlier
-- Output:
-- "lower_bound"	"upper_bound"	"jumlah_outlier"	"total_rows"
-- -115.78125000000003	344.40875000000005	7981	103886
WITH stats AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment_value) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment_value) AS q3
  FROM olist_order_payments_dataset
),
bounds AS (
  SELECT 
    q1 - 1.5 * (q3 - q1) AS lower_bound,
    q3 + 1.5 * (q3 - q1) AS upper_bound
  FROM stats
)
SELECT 
  MAX(b.lower_bound) AS lower_bound, 
  MAX(b.upper_bound) AS upper_bound,
  COUNT(*) FILTER (WHERE payment_value < b.lower_bound OR payment_value > b.upper_bound) AS jumlah_outlier,
  COUNT(*) AS total_rows
FROM olist_order_payments_dataset, bounds b;

-- olist_products_dataset: product_weight_g
-- Hasil: Terdapat sejumlah outlier
-- Output:
-- "lower_bound"	"upper_bound"	"jumlah_outlier"	"total_rows"
-- -2100	4300	4551	32951
WITH stats AS (
  SELECT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY product_weight_g) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY product_weight_g) AS q3
  FROM olist_products_dataset
),
bounds AS (
  SELECT 
    q1 - 1.5 * (q3 - q1) AS lower_bound,
    q3 + 1.5 * (q3 - q1) AS upper_bound
  FROM stats
)
SELECT 
  MAX(b.lower_bound) AS lower_bound, 
  MAX(b.upper_bound) AS upper_bound,
  COUNT(*) FILTER (WHERE product_weight_g < b.lower_bound OR product_weight_g > b.upper_bound) AS jumlah_outlier,
  COUNT(*) AS total_rows
FROM olist_products_dataset, bounds b;

-- 6. Validasi Logika Bisnis
-- Mengecek konsistensi antar kolom dalam 1 baris yang sama, untuk 
-- menemukan kombinasi nilai yang secara logis tidak mungkin terjadi.

-- Tabel olist_orders_dataset: order yang "sampai ke customer" lebih 
-- awal dari "dibeli" (seharusnya mustahil)
-- Hasil: Tidak ditemukan data yang tidak sesuai
SELECT COUNT(*) AS jumlah_anomali
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp;

-- Tabel olist_orders_dataset: status 'delivered' tapi tidak ada 
-- tanggal order_delivered_customer_date (seharusnya tidak mungkin 
-- jika benar-benar sudah delivered)
-- Hasil: Terdapat 8 data yang tercatat dengan temuan ini
-- Output:
-- "jumlah_anomali"
-- 8
SELECT COUNT(*) AS jumlah_anomali
FROM olist_orders_dataset
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;

-- Tabel olist_orders_dataset: order dikirim ke kurir lebih awal dari 
-- order disetujui (approved)
-- Hasil: Ditemukan 1359 data, Krusial dan tidak bisa sembarangan dihilangkan
-- bisa saja sistem memang fleksibel yang memperbolehkan pengiriman barang dulu 
-- sebelum order di approved, mungkin juga karena seller ingin mengirimkan barang
-- dengan banyak secara sekaligus sehingga order yang belum di approved ikut dikirimkan juga
-- Output:
-- "jumlah_anomali"
-- 1359
SELECT COUNT(*) AS jumlah_anomali
FROM olist_orders_dataset
WHERE order_delivered_carrier_date < order_approved_at;

-- Tabel olist_order_payments_dataset: anomali payment_installments = 0
-- Hasil: Terdapat 2 data anomali
-- Output:
-- "order_id"	"payment_sequential"	"payment_type"	"payment_installments"	"payment_value"
-- "744bade1fcf9ff3f31d860ace076d422"	2	"credit_card"	0	58.69
-- "1a57108394169c0b47d8f876acc9ba2d"	2	"credit_card"	0	129.94
SELECT *
FROM olist_order_payments_dataset
WHERE payment_installments = 0;

-- Tabel olist_products_dataset: anomali product_weight_g = 0
-- Hasil: Anomali data berasal dari semua barang yang sama
-- Output:
-- "product_id"	"product_category_name"	"product_name_lenght"	"product_description_lenght"	"product_photos_qty"	"product_weight_g"	"product_length_cm"	"product_height_cm"	"product_width_cm"
-- "81781c0fed9fe1ad6e8c81fca1e1cb08"	"cama_mesa_banho"	51	529	1	0	30	25	30
-- "8038040ee2a71048d4bdbbdc985b69ab"	"cama_mesa_banho"	48	528	1	0	30	25	30
-- "36ba42dd187055e1fbe943b2d11430ca"	"cama_mesa_banho"	53	528	1	0	30	25	30
-- "e673e90efa65a5409ff4196c038bb5af"	"cama_mesa_banho"	53	528	1	0	30	25	30
SELECT *
FROM olist_products_dataset
WHERE product_weight_g = 0;