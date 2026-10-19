## 18-10-2026
- Keputusan: Hapus relasi FK antara customers/sellers dengan 
  geolocation (zip code prefix) menyebabkan adanya 2 ERD utama (bagian original dan bagian yang digunakan)
- Alasan: geolocation_zip_code_prefix tidak unik di data asli, 
  sehingga tidak bisa jadi target foreign key secara teknis
- Dampak: hubungan customers/sellers ke geolocation tetap bisa 
  dipakai lewat JOIN manual saat query analisis, tapi tidak lagi 
  dijaga otomatis oleh constraint database

## 18-10-2026
- Keputusan: Pindah dari schema hasil export dbdiagram.io ke schema 
  SQL yang ditulis & dikelola manual
- Alasan: proses export-import berulang kali gagal karena constraint 
  terlalu ketat dibanding kondisi data asli; dbdiagram tetap dipakai 
  untuk dokumentasi visual ERD, bukan sumber schema produksi

## 19-10-2026
- Temuan: review_id tidak sepenuhnya unik — ditemukan 2 pola anomali:
  (1) review_id sama dipakai di beberapa order_id berbeda dengan data 
  identik (indikasi bug sistem sumber data), 
  (2) 1 order_id punya beberapa review_id berbeda dengan isi berbeda (pelanggan menulis 
  ulang komplain). Tidak ditemukan baris duplikat murni (semua kolom 
  identik). Keputusan penanganan akan ditentukan di tahap cleaning.