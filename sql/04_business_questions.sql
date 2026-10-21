-- 04_business_questions
-- Memahami dan membuktikan pertanyaan business yang dimiliki
-- melihat apakah pertanyaan tersebut dapat dijawab dan dijelaskan

-- Business Question 1: Kategori produk mana yang paling menguntungkan 
-- dan paling banyak dikeluhkan?
-- Insight: cama_mesa_banho masuk top-3 kategori dengan revenue tertinggi 
-- (R$ 1,036,988), namun juga kategori dengan jumlah rating rendah 
-- terbanyak (2,069 review ≤2 bintang). Kategori ini perlu investigasi 
-- lanjutan (kualitas produk/packaging), sementara beleza_saude sebagai 
-- revenue tertinggi justru punya rating sehat (4.14).

-- Bagian A: Revenue per kategori produk
-- Hasil: Ditampilkan 10 product dengan revenue tertinggi
-- Output: 
-- "beleza_saude"	8836	1258681.3399999682	130.16
-- "relogios_presentes"	5624	1205005.6799999995	201.14
-- "cama_mesa_banho"	9417	1036988.6800000712	93.30
-- "esporte_lazer"	7720	988048.9700000401	114.34
-- "informatica_acessorios"	6689	911954.3200000388	116.51
-- "moveis_decoracao"	6449	729762.4900000411	87.56
-- "cool_stuff"	3632	635290.8500000009	167.36
-- "utilidades_domesticas"	5884	632248.6600000213	90.79
-- "automotivo"	3897	592720.1100000107	139.96
-- "ferramentas_jardim"	3518	485256.46000001475	111.63
SELECT 
  p.product_category_name,
  COUNT(DISTINCT oi.order_id) AS jumlah_order,
  SUM(oi.price) AS total_revenue,
  ROUND(AVG(oi.price)::numeric, 2) AS rata2_harga
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Bagian B: Rating rata-rata per kategori produk
-- Hasil: product "casa_mesa_banho" memiliki rating rendah terbanyak
-- Output:
-- "cama_mesa_banho"	10971	3.90	2069
-- "moveis_decoracao"	8208	3.91	1579
-- "informatica_acessorios"	7754	3.94	1427
-- "beleza_saude"	9570	4.14	1312
-- "esporte_lazer"	8553	4.11	1245
-- "utilidades_domesticas"	6919	4.06	1080
-- "relogios_presentes"	5938	4.02	965
-- "telefonia"	4511	3.95	759
-- "ferramentas_jardim"	4315	4.05	690
-- "automotivo"	4185	4.06	638
SELECT 
  p.product_category_name,
  COUNT(r.review_id) AS jumlah_review,
  ROUND(AVG(r.review_score)::numeric, 2) AS rata2_rating,
  COUNT(*) FILTER (WHERE r.review_score <= 2) AS jumlah_rating_rendah
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p ON oi.product_id = p.product_id
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
JOIN olist_order_reviews_deduped r ON o.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY jumlah_rating_rendah DESC
LIMIT 10;

-- Business Question 2: Apakah keterlambatan pengiriman berkorelasi 
-- dengan rating rendah?
-- Insight: Terbukti ada korelasi kuat dan hampir linear. Order tepat 
-- waktu rata-rata rating 4.30 (9.18% rating rendah), order terlambat 
-- turun ke 2.57 (53.98% rating rendah), dan order tidak sampai sama 
-- sekali terendah di 1.74 (78.18% rating rendah). Perbaikan akurasi 
-- estimasi & kecepatan pengiriman berpotensi berdampak langsung ke 
-- kepuasan pelanggan.

SELECT 
  CASE 
    WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date 
      THEN 'Terlambat'
    WHEN o.order_delivered_customer_date IS NULL 
      THEN 'Belum/Tidak Sampai'
    ELSE 'Tepat Waktu'
  END AS status_pengiriman,
  COUNT(DISTINCT o.order_id) AS jumlah_order,
  ROUND(AVG(r.review_score)::numeric, 2) AS rata2_rating,
  COUNT(*) FILTER (WHERE r.review_score <= 2) AS jumlah_rating_rendah,
  ROUND(
    (COUNT(*) FILTER (WHERE r.review_score <= 2))::numeric 
    / COUNT(*)::numeric * 100, 2
  ) AS persen_rating_rendah
FROM olist_orders_dataset o
JOIN olist_order_reviews_deduped r ON o.order_id = r.order_id
GROUP BY status_pengiriman
ORDER BY rata2_rating ASC;

-- Business Question 3: Bagaimana tren penjualan bulanan, dan wilayah 
-- (state) mana penyumbang revenue terbesar?
-- Insight: Tren penjualan bulanan meningkat konsisten dari akhir 2016 
-- hingga pertengahan 2018, dengan lonjakan tajam di November 2017 
-- (kemungkinan terkait Black Friday). 3 bulan dengan data sangat minim 
-- (2016-09, 2016-12, 2018-09) adalah artefak batas periode pengumpulan 
-- data, bukan tren asli — perlu di-exclude saat visualisasi dashboard. 
-- Untuk wilayah, Sao Paulo (SP) mendominasi dengan revenue 2,8x lipat 
-- dari runner-up (RJ), diikuti MG — 3 provinsi ini menyumbang porsi 
-- dominan revenue nasional, relevan untuk strategi logistik regional.

-- Bagian A: Tren penjualan bulanan
-- Hasil: Terdapat peningkatan penjualan yang konsisten dari awal tahun hingga akhir tahun.
-- Namun, terdapat data bulan penjualan yang aneh, yang hanya memiliki 1 penjualan dalam 1 bulannya
-- Output:
-- "2016-09-01 00:00:00"	3	267.36
-- "2016-10-01 00:00:00"	308	49507.66
-- "2016-12-01 00:00:00"	1	10.90
-- "2017-01-01 00:00:00"	789	120312.87
-- "2017-02-01 00:00:00"	1733	247303.02
-- "2017-03-01 00:00:00"	2641	374344.30
-- "2017-04-01 00:00:00"	2391	359927.23
-- "2017-05-01 00:00:00"	3660	506071.14
-- "2017-06-01 00:00:00"	3217	433038.60
-- "2017-07-01 00:00:00"	3969	498031.48
-- "2017-08-01 00:00:00"	4293	573971.68
-- "2017-09-01 00:00:00"	4243	624401.69
-- "2017-10-01 00:00:00"	4568	664219.43
-- "2017-11-01 00:00:00"	7451	1010271.37
-- "2017-12-01 00:00:00"	5624	743914.17
-- "2018-01-01 00:00:00"	7220	950030.36
-- "2018-02-01 00:00:00"	6694	844178.71
-- "2018-03-01 00:00:00"	7188	983213.44
-- "2018-04-01 00:00:00"	6934	996647.75
-- "2018-05-01 00:00:00"	6853	996517.68
-- "2018-06-01 00:00:00"	6160	865124.31
-- "2018-07-01 00:00:00"	6273	895507.22
-- "2018-08-01 00:00:00"	6452	854686.33
-- "2018-09-01 00:00:00"	1	145.00
SELECT 
  DATE_TRUNC('month', o.order_purchase_timestamp) AS bulan,
  COUNT(DISTINCT o.order_id) AS jumlah_order,
  ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
GROUP BY bulan
ORDER BY bulan ASC;

-- Bagian B: Revenue per wilayah (state) pelanggan
-- Hasil: terdapat beberapa wilayah (state) yang memiliki jumlah order yang tinggi
-- dan menghasilkan revenue yang tinggi juga
-- Output:
-- "SP"	41375	5202955.05
-- "RJ"	12762	1824092.67
-- "MG"	11544	1585308.03
-- "RS"	5432	750304.02
-- "PR"	4998	683083.76
-- "SC"	3612	520553.34
-- "BA"	3358	511349.99
-- "DF"	2125	302603.94
-- "GO"	2007	294591.95
-- "ES"	2025	275037.31
SELECT 
  c.customer_state,
  COUNT(DISTINCT o.order_id) AS jumlah_order,
  ROUND(SUM(oi.price)::numeric, 2) AS total_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Business Question 4: Metode pembayaran apa yang paling sering dipakai, 
-- apakah ada perbedaan pola antar wilayah?
-- Insight: credit_card mendominasi (73.92% transaksi), diikuti boleto 
-- (19.04%) yang merupakan metode pembayaran khas Brasil untuk masyarakat 
-- tanpa kartu kredit. Pola pembayaran di 5 provinsi dengan revenue 
-- tertinggi konsisten linear dengan skala wilayahnya masing-masing — 
-- tidak ditemukan perbedaan preferensi pembayaran yang signifikan antar 
-- wilayah, credit_card tetap dominan (~70-75%) di semua provinsi besar. 
-- Ditemukan 3 transaksi dengan payment_type 'not_defined' bernilai R$0, 
-- kemungkinan transaksi gagal/dibatalkan, dampaknya diabaikan karena 
-- nilainya sangat kecil.

-- Bagian A: Distribusi metode pembayaran secara keseluruhan
-- Hasil: Pembayaran paling besar dilakukan menggunakan credit_card dan boleto.
-- Terdapat jenis pembayaran not_defined juga berjumlah 3 transaksi
-- Output:
-- "credit_card"	76795	12542084.19	73.92
-- "boleto"	19784	2869361.27	19.04
-- "voucher"	5775	379436.87	5.56
-- "debit_card"	1529	217989.79	1.47
-- "not_defined"	3	0.00	0.00
SELECT 
  payment_type,
  COUNT(*) AS jumlah_transaksi,
  ROUND(SUM(payment_value)::numeric, 2) AS total_nilai,
  ROUND(
    COUNT(*)::numeric / SUM(COUNT(*)) OVER () * 100, 2
  ) AS persen_dari_total
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY jumlah_transaksi DESC;

-- Bagian B: Metode pembayaran terpopuler per wilayah (top 5 state 
-- dengan revenue tertinggi dari BQ3 sebelumnya)
-- Hasil: Metode pembayaran yang dilakukan linear dengan data sebelumnya
-- Output:
-- "MG"	"credit_card"	9070
-- "MG"	"boleto"	2304
-- "MG"	"voucher"	589
-- "MG"	"debit_card"	139
-- "PR"	"credit_card"	3786
-- "PR"	"boleto"	1118
-- "PR"	"voucher"	283
-- "PR"	"debit_card"	75
-- "RJ"	"credit_card"	10288
-- "RJ"	"boleto"	2163
-- "RJ"	"voucher"	891
-- "RJ"	"debit_card"	185
-- "RS"	"credit_card"	3985
-- "RS"	"boleto"	1359
-- "RS"	"voucher"	248
-- "RS"	"debit_card"	76
-- "SP"	"credit_card"	32168
-- "SP"	"boleto"	8205
-- "SP"	"voucher"	2487
-- "SP"	"debit_card"	759
-- "SP"	"not_defined"	3
SELECT 
  c.customer_state,
  p.payment_type,
  COUNT(*) AS jumlah_transaksi
FROM olist_order_payments_dataset p
JOIN olist_orders_dataset o ON p.order_id = o.order_id
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE c.customer_state IN ('SP', 'RJ', 'MG', 'RS', 'PR')
GROUP BY c.customer_state, p.payment_type
ORDER BY c.customer_state, jumlah_transaksi DESC;

-- Business Question 5: Berapa rata-rata waktu pengiriman vs estimasi, 
-- dan seller mana yang paling sering telat?
-- Insight: Pengiriman aktual (12.56 hari) jauh lebih cepat dari estimasi 
-- (23.74 hari), menunjukkan platform memberi buffer waktu yang sangat 
-- longgar (under-promise, over-deliver) — berpotensi jadi peluang 
-- optimasi ekspektasi pelanggan. Ditemukan beberapa seller dengan volume 
-- order tinggi namun tingkat keterlambatan signifikan (hingga 214 order 
-- telat dari 1,949 order, ~11%), menjadikan mereka kandidat prioritas 
-- untuk audit kualitas logistik.

-- Bagian A: Rata-rata waktu pengiriman aktual vs estimasi (dalam hari)
-- Hasil: Rata-rata waktu pengirimiman aktual 2x lebih cepat daripada estimasi:
-- Output:
-- "rata2_hari_pengiriman_aktual"	"rata2_hari_estimasi"
-- 12.56	23.74
SELECT 
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
  )::numeric, 2) AS rata2_hari_pengiriman_aktual,
  ROUND(AVG(
    EXTRACT(EPOCH FROM (order_estimated_delivery_date - order_purchase_timestamp)) / 86400
  )::numeric, 2) AS rata2_hari_estimasi
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

-- Bagian B: Top 10 seller dengan jumlah keterlambatan terbanyak
-- Hasil: Keterlambahatan beberapa seller cukup tinggi hingga mencapai angka 100-200an
-- Output:
-- "4a3ca9315b744ce9f8e9374361493884"	1949	214	10.98
-- "1f50f920176fa81dab994f9023523100"	1926	182	9.45
-- "4869f7a5dfa277a7dca6462dcf3b52b2"	1148	133	11.59
-- "1025f0e2d44d7041d6cf58b6550e0bfa"	1420	131	9.23
-- "7c67e1448b00f6e969d365cea6b010ab"	1355	130	9.59
-- "6560211a19b47992c3666cc44a7e94c0"	1996	124	6.21
-- "ea8482cd71df3c1969d7b9473ff13abc"	1188	123	10.35
-- "955fee9216a65b617aa5c0531780ce60"	1472	119	8.08
-- "da8622b14eb17ae2831f4ac5b9dab84a"	1548	113	7.30
-- "8b321bb669392f5163d04c59e235e066"	1005	103	10.25
SELECT 
  oi.seller_id,
  COUNT(*) AS jumlah_order,
  COUNT(*) FILTER (
    WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
  ) AS jumlah_telat,
  ROUND(
    COUNT(*) FILTER (
      WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    )::numeric / COUNT(*)::numeric * 100, 2
  ) AS persen_telat
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o ON oi.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY oi.seller_id
HAVING COUNT(*) >= 20  -- hanya seller dengan cukup banyak order, supaya persentase bermakna
ORDER BY jumlah_telat DESC
LIMIT 10;

-- Business Question 6: Bagaimana rata-rata tingkat kepuasan 
-- (rating) pelanggan di tiap wilayah (state)?
-- Insight: wilayah dengan rating terendah didominasi provinsi di luar Sao Paulo/Minas Gerais (pusat ekonomi Brasil) 
-- seperti RR, MA, AL, SE, PA berada di 5 terbawah, semuanya provinsi yang secara geografis lebih jauh dari pusat logistik utama (SP). 
-- Sebaliknya, provinsi dengan rating tertinggi (AP, SP, PR, AM, MG) sebagian besar berada di kelompok ekonomi besar/dekat pusat distribusi.
-- Output(sample):
-- "customer_state"	"jumlah_review"	"rata2_rating"	"jumlah_rating_rendah"	"persen_rating_rendah"
-- "RR"	46	3.61	11	23.91
-- "MA"	738	3.75	162	21.95
SELECT 
  c.customer_state,
  COUNT(r.review_id) AS jumlah_review,
  ROUND(AVG(r.review_score)::numeric, 2) AS rata2_rating,
  COUNT(*) FILTER (WHERE r.review_score <= 2) AS jumlah_rating_rendah,
  ROUND(
    COUNT(*) FILTER (WHERE r.review_score <= 2)::numeric 
    / COUNT(*)::numeric * 100, 2
  ) AS persen_rating_rendah
FROM olist_orders_dataset o
JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
JOIN olist_order_reviews_deduped r ON o.order_id = r.order_id
GROUP BY c.customer_state
ORDER BY rata2_rating ASC;