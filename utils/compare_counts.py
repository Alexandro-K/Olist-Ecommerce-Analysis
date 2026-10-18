import pandas as pd
import psycopg2
import os

# --- Konfigurasi koneksi database (sesuaikan) ---
conn = psycopg2.connect(
    host="localhost",
    dbname="Olist Ecommerce Database",
    user="postgres",
    password="admin123",
    port=5432
)

# --- Daftar tabel & file CSV terkait ---
folder_path = r"C:\Alex\Projects\Project 5 - Olist Ecommerce Analysis\data\raw"
dataset_files = {
    "olist_customers_dataset": "olist_customers_dataset.csv",
    "olist_geolocation_dataset": "olist_geolocation_dataset.csv",
    "olist_order_items_dataset": "olist_order_items_dataset.csv",
    "olist_order_payments_dataset": "olist_order_payments_dataset.csv",
    "olist_order_reviews_dataset": "olist_order_reviews_dataset.csv",
    "olist_orders_dataset": "olist_orders_dataset.csv",
    "olist_products_dataset": "olist_products_dataset.csv",
    "olist_sellers_dataset": "olist_sellers_dataset.csv",
    "product_category_name_translation": "product_category_name_translation.csv",
}

results = []
cur = conn.cursor()

for table_name, file_name in dataset_files.items():
    # Hitung baris CSV
    file_path = os.path.join(folder_path, file_name)
    csv_count = len(pd.read_csv(file_path))

    # Hitung baris di PostgreSQL
    cur.execute(f'SELECT COUNT(*) FROM "{table_name}"')
    db_count = cur.fetchone()[0]

    results.append({
        "table_name": table_name,
        "csv_count": csv_count,
        "db_count": db_count,
        "match": csv_count == db_count
    })

cur.close()
conn.close()

result_df = pd.DataFrame(results)
print(result_df)

# Simpan hasil validasi sebagai bukti dokumentasi
result_df.to_csv("validation_result.csv", index=False)