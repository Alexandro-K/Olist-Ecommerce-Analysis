# Progress Log

## 2026-10-18

### Dikerjakan
- Merancang ERD awal untuk 9 tabel dataset Olist menggunakan dbdiagram.io
- Setup database PostgreSQL lokal (`Olist Ecommerce Database`) via pgAdmin
- Menulis ulang schema SQL secara manual (`sql/01_schema.sql`) setelah 
  beberapa kali gagal export otomatis dari dbdiagram.io
- Import 9 file CSV ke PostgreSQL, urutan disesuaikan dengan dependensi 
  foreign key (tabel induk lebih dulu)
- Validasi jumlah baris CSV vs PostgreSQL menggunakan script Python 
  (`utils/compare_counts.py`) — hasil: semua 9 tabel match (lihat 
  `validation_result.csv`)

### Kendala & Perbaikan
- Tipe data tidak konsisten antara `seller_zip_code_prefix` (float) dan 
  `geolocation_zip_code_prefix` (varchar) → diseragamkan jadi varchar
- `geolocation_zip_code_prefix` ternyata tidak unik di data asli → PK 
  dihapus dari kolom tersebut
- FK dari `customers`/`sellers` ke `geolocation` tidak bisa dipertahankan 
  karena kolom tujuan tidak unik → FK dihapus, relasi tetap dipakai lewat 
  JOIN manual saat analisis nanti
- Beberapa kolom `product_category_name` dkk memiliki nilai NULL di data 
  asli → constraint NOT NULL yang terlalu ketat dilonggarkan
- Keputusan pindah dari schema hasil export dbdiagram.io ke schema SQL 
  yang ditulis & dikelola manual (lihat `decision_log.md` untuk detail 
  lengkap tiap keputusan di atas)

### Referensi detail
Lihat `docs/decision_log.md` untuk alasan teknis lengkap tiap keputusan.

### Status akhir hari ini
Tahap 3 (Setup database & import CSV) selesai. Tahap 4 (Data cleaning) 
baru dimulai dengan validasi jumlah baris.

## 2026-10-19

### Dikerjakan
- Menyelesaikan seluruh audit EDA & validasi di `sql/02_EDA.sql`:
  - Section 1: Missing values (9 tabel, seluruh kolom)
  - Section 2: Duplikasi (9 tabel, seluruh kolom)
  - Section 3: Distribusi data & deteksi outlier (metode IQR)
  - Section 4: Validasi logika bisnis (konsistensi antar kolom/tanggal)
- Investigasi mendalam anomali `review_id` di `olist_order_reviews_dataset` 
  — ditemukan 2 pola berbeda: review_id sama untuk order berbeda (indikasi 
  bug sistem sumber), dan 1 order dengan beberapa review berbeda (perilaku 
  pelanggan yang valid)
- Konfirmasi 610 baris `olist_products_dataset` dengan data kosong berasal 
  dari baris yang sama persis (bukan 4 masalah terpisah)

### Temuan Utama
- Tidak ditemukan technical duplicate (baris 100% identik) di tabel manapun
- Outlier (metode IQR) ditemukan wajar pada `price`, `freight_value`, 
  `payment_value`, `product_weight_g` — karakteristik alami data e-commerce, 
  bukan error
- Anomali domain yang perlu ditindaklanjuti di tahap cleaning:
  - 2 baris `payment_installments = 0` (cicilan 0x tidak logis)
  - 4 baris `product_weight_g = 0` (berat 0 gram tidak mungkin untuk 
    barang fisik), semuanya dari kategori `cama_mesa_banho`
  - 8 order berstatus `delivered` tapi tanpa `order_delivered_customer_date`
  - 1,359 order dengan `order_delivered_carrier_date` lebih awal dari 
    `order_approved_at` — belum diputuskan sebagai error, kemungkinan 
    perilaku sistem yang valid (seller kirim batch sebelum approval resmi)

### Referensi detail
Lihat `sql/02_EDA.sql` untuk seluruh query dan hasil lengkap per section.

### Status akhir hari ini
Tahap 4 bagian EDA/Validation selesai. Siap lanjut ke `03_cleaning.sql` 
untuk menentukan dan mengeksekusi penanganan tiap temuan di atas.

## 2026-10-19 (lanjutan)

### Dikerjakan
- Memulai Tahap 6: Analisis lanjutan dengan Python
- Membangun RFM Analysis (`notebooks/01_rfm_analysis.ipynb`):
  - Ekstraksi data transaksi delivered dari PostgreSQL ke pandas
  - Hitung Recency, Frequency, Monetary per customer_unique_id
  - Skoring R/F/M dengan metode kuartil (qcut)
  - Segmentasi pelanggan ke 4 kelompok, juga dengan metode kuartil 
    supaya konsisten dan proporsional (~23,339 pelanggan per segmen)

### Temuan Utama
- Lebih dari 75% pelanggan Olist hanya pernah belanja 1 kali — 
  karakteristik marketplace dengan tingkat repeat purchase rendah
- Segmentasi akhir: Pelanggan Terbaik, Potensial, Biasa, dan 
  Berisiko Hilang, masing-masing proporsinya seimbang

### Status akhir hari ini
RFM Analysis selesai dengan insight terdokumentasi. Cohort retention 
analysis (bagian lain dari Tahap 6) belum dimulai.

## 2026-10-19 (lanjutan 2)

### Dikerjakan
- Menyelesaikan Cohort Retention Analysis (`notebooks/02_cohort_retention_analysis.ipynb`):
  - Kelompokkan pelanggan berdasarkan bulan transaksi pertama (cohort_month)
  - Hitung cohort_index (jarak bulan sejak transaksi pertama)
  - Bangun tabel cohort & tabel retensi dalam persentase

### Temuan Utama
- Retensi bulan ke-1 konsisten sangat rendah di seluruh cohort 
  (0.18% - 0.72%), terus menurun di bulan-bulan berikutnya
- Temuan ini selaras dan memperkuat hasil RFM sebelumnya: mayoritas 
  pelanggan Olist hanya bertransaksi satu kali

### Status akhir hari ini
Tahap 6 (Analisis Python: RFM + Cohort Retention) selesai sepenuhnya. 
Siap lanjut ke Tahap 7 (Dashboard).

## 2026-10-20

### Dikerjakan
- Memulai Tahap 7: Dashboard (Power BI)
- Berhasil koneksi Power BI Desktop ke PostgreSQL lokal
- Menyiapkan export CSV dari notebook untuk data RFM dan cohort 
  retention (`data/processed/rfm_result.csv`, `data/processed/retention_table.csv`)
- Membangun Halaman 1 (Overview):
  - Visual "Tren Revenue Bulanan" (line chart) selesai, termasuk 
    pembuatan kolom DAX `OrderYearMonth` dan filter exclude 3 bulan 
    anomali data
  - Visual "Revenue per Wilayah" (bar chart) baru dimulai, belum selesai

### Catatan Teknis
- Kolom `OrderYearMonth` dibuat via DAX: 
  `FORMAT('olist_orders_dataset'[order_purchase_timestamp], "YYYY-MM")`
  — diperlukan karena hierarki tanggal bawaan Power BI (Month saja) 
  menggabungkan semua tahun jadi satu siklus 12 bulan
- Filter rentang tanggal pada `order_purchase_timestamp` memakai 
  Advanced Filtering (is after 12/31/2016, is before 9/1/2018) untuk 
  exclude bulan dengan data sangat minim

### Status akhir hari ini
Tahap 7 sedang berjalan. Halaman 1 (Overview) baru 1 dari 4 visual 
selesai. Halaman 2 dan 3 belum dimulai.

## 2026-10-20 (lanjutan)

### Dikerjakan
- Melanjutkan Tahap 7: Dashboard (Power BI)
- Menyelesaikan Halaman 2 (Customer Loyalty):
  - Import CSV hasil RFM dan Cohort Retention dari notebook Python
  - Visual "Distribusi Segmen Pelanggan (RFM)" (donut chart)
  - Card "Jumlah Pelanggan Berisiko Hilang"
  - Matrix heatmap "Tingkat Retensi Antar Cohort"
  - Scatter plot "Revenue vs Rating per Kategori Produk"

### Kendala & Perbaikan Teknis
- Import CSV retention_table: kolom tidak terbaca sebagai header 
  (muncul Column1, Column2, dst) → diperbaiki dengan "Use First Row 
  as Headers" di Power Query
- Angka retention salah baca locale (100.0 terbaca jadi 1000) → 
  diperbaiki dengan re-import dan set locale eksplisit ke Decimal Number
- Matrix cohort salah susun: cohort_month otomatis pecah jadi hierarki 
  Year/Quarter/Month/Day → diperbaiki dengan menghapus hierarki, 
  sisakan cohort_month saja di Rows
- Scatter plot rating per kategori menunjukkan nilai seragam (4.09 
  di semua kategori) → diinvestigasi lewat Show as Table, ditemukan 
  relasi antar tabel (order_items - orders - order_reviews_deduped) 
  memakai cross filter direction "Single", sehingga filter kategori 
  produk tidak bisa menjalar ke tabel review. Diperbaiki dengan 
  mengubah cross filter direction jadi "Both" pada relasi 
  order_items-orders

### Status akhir hari ini
Halaman 1 (Overview) dan Halaman 2 (Customer Loyalty) selesai. 
Halaman 3 (Masalah & Rekomendasi Operasional) belum dimulai.

## 2026-10-23

### Dikerjakan
- Menyelesaikan Halaman 3 (Operational Issues):
  - Kolom DAX `Status Pengiriman` (Tepat Waktu/Terlambat/Belum Sampai)
  - Chart "Rata-rata Rating berdasarkan Status Pengiriman"
  - Measure `Jumlah Order per Seller`, `Jumlah Telat per Seller`
  - Chart "Top 10 Seller dengan Keterlambatan Tertinggi"
  - Measure `Estimasi Baru (1.5x)` dan Multi-row card perbandingan 
    waktu pengiriman aktual vs estimasi lama vs estimasi baru

### Status akhir hari ini
Tahap 7 (Dashboard Power BI) selesai sepenuhnya — 3 halaman lengkap: 
Overview, Customer Loyalty, Operational Issues. Siap lanjut ke Tahap 8 
(dokumentasi final & publikasi GitHub).