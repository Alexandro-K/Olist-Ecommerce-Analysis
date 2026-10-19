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