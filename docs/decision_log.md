## 2026-10-18
- Keputusan: Hapus relasi FK antara customers/sellers dengan 
  geolocation (zip code prefix) menyebabkan adanya 2 ERD utama (bagian original dan bagian yang digunakan)
- Alasan: geolocation_zip_code_prefix tidak unik di data asli, 
  sehingga tidak bisa jadi target foreign key secara teknis
- Dampak: hubungan customers/sellers ke geolocation tetap bisa 
  dipakai lewat JOIN manual saat query analisis, tapi tidak lagi 
  dijaga otomatis oleh constraint database

## 2026-10-18
- Keputusan: Pindah dari schema hasil export dbdiagram.io ke schema 
  SQL yang ditulis & dikelola manual
- Alasan: proses export-import berulang kali gagal karena constraint 
  terlalu ketat dibanding kondisi data asli; dbdiagram tetap dipakai 
  untuk dokumentasi visual ERD, bukan sumber schema produksi