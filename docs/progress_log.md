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