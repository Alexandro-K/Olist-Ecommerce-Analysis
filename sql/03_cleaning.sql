-- 03_CLEANING
-- Query penanganan berdasarkan temuan di 02_EDA.sql
-- alasan lengkap ada di docs/decision_log.md

-- 1. Isi product_category_name kosong dengan label 'unknown'
-- (610 baris produk tanpa kategori, tapi product_id tetap valid 
-- dan mungkin terpakai di order_items — tidak dihapus)
-- Hasil: Berhasil diisi dengan unkown
-- Output(sample):
-- "product_id"	"product_category_name"	"product_name_lenght"	"product_description_lenght"	"product_photos_qty"	"product_weight_g"	"product_length_cm"	"product_height_cm"	"product_width_cm"
-- "0533c5ec3a042521493cfb6e12d6befd"	"unknown"				1550	38	4	23
-- "3f6f946481fd39f4eda986012f6e0447"	"unknown"				1600	38	28	40
UPDATE olist_products_dataset
SET product_category_name = 'unknown'
WHERE product_category_name IS NULL;

SELECT * FROM olist_products_dataset
WHERE product_category_name = 'unknown';

-- 2. review_id yang dipakai di beberapa order_id berbeda
-- TIDAK DIHAPUS dari tabel utama (datanya tetap valid per baris).
-- Dibuatkan VIEW terpisah untuk analisis yang butuh 1 review unik 
-- per review_id (misal hitung rata-rata rating per review_id)
-- Hasil: Berhasil membuat view untuk pengecekan
-- Output:
-- "review_id"	"order_id"	"review_score"	"review_comment_title"	"review_comment_message"	"review_creation_date"	"review_answer_timestamp"	"rn"
-- "0001239bc1de2e33cb583967c2ca4c67"	"fc046d7776171871436844218f817d7d"	5			"2018-03-20 00:00:00"	"2018-03-20 18:36:04"	1
-- "0001cc6860aeaf5b9017fe4131a52e62"	"d4665434b01caa9dc3e3e78b3eb3593e"	5			"2018-06-22 00:00:00"	"2018-06-26 13:51:29"	1
CREATE OR REPLACE VIEW olist_order_reviews_deduped AS
SELECT *
FROM (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY review_id 
      ORDER BY review_creation_date ASC
    ) AS rn
  FROM olist_order_reviews_dataset
) sub
WHERE rn = 1;

SELECT * FROM olist_order_reviews_deduped;

-- 3. payment_installments = 0 diperbaiki jadi 1
-- (pembayaran tetap valid, payment_value > 0, installment 0 
-- jelas salah input minimal)
-- Hasil: Berhasil mengubah installments menjadi 1
UPDATE olist_order_payments_dataset
SET payment_installments = 1
WHERE payment_installments = 0;

SELECT * FROM olist_order_payments_dataset
WHERE payment_installments = 0 AND payment_value > 0;

-- 4. product_weight_g = 0 diisi dengan median berat kategori yang sama
-- (4 baris, semua dari kategori 'cama_mesa_banho', dimensi lain normal)
-- Hasil: berat barang berhasil diubah
WITH median_weight AS (
   SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY product_weight_g) AS median_val
   FROM olist_products_dataset
   WHERE product_category_name = 'cama_mesa_banho'
     AND product_weight_g > 0
)
UPDATE olist_products_dataset
SET product_weight_g = (SELECT median_val FROM median_weight)
WHERE product_weight_g = 0
  AND product_category_name = 'cama_mesa_banho';

SELECT * FROM olist_products_dataset
WHERE product_category_name = 'cama_mesa_banho' AND product_weight_g = 0;

-- 6. Order delivered tapi tanpa delivered_customer_date (8 baris)
-- TIDAK DIHAPUS/DIISI TANGGAL PALSU. Ditandai lewat kolom flag 
-- baru supaya mudah di-exclude saat analisis butuh tanggal pengiriman.
-- Hasil: Flag berhasil diinput
-- Output:
-- "order_id"	"customer_id"	"order_status"	"order_purchase_timestamp"	"order_approved_at"	"order_delivered_carrier_date"	"order_delivered_customer_date"	"order_estimated_delivery_date"	"is_delivery_date_missing"
-- "2d1e2d5bf4dc7227b3bfebb81328c15f"	"ec05a6d8558c6455f0cbbd8a420ad34f"	"delivered"	"2017-11-28 17:44:07"	"2017-11-28 17:56:40"	"2017-11-30 18:12:23"		"2017-12-18 00:00:00"	true
-- "f5dd62b788049ad9fc0526e3ad11a097"	"5e89028e024b381dc84a13a3570decb4"	"delivered"	"2018-06-20 06:58:43"	"2018-06-20 07:19:05"	"2018-06-25 08:05:00"		"2018-07-16 00:00:00"	true
ALTER TABLE olist_orders_dataset 
ADD COLUMN IF NOT EXISTS is_delivery_date_missing BOOLEAN DEFAULT FALSE;

SELECT * FROM olist_orders_dataset;

UPDATE olist_orders_dataset
SET is_delivery_date_missing = TRUE
WHERE order_status = 'delivered' AND order_delivered_customer_date IS NULL;

SELECT * FROM olist_orders_dataset
WHERE is_delivery_date_missing = TRUE;










