import pandas as pd
import numpy as  np
import sqlite3
from pathlib import Path 
folder=Path(r"C:\Users\samar\Downloads\archive")
conn=sqlite3.connect("olist_analytics.db")
files={
    "customers":r"C:\Users\samar\Downloads\archive\olist_customers_dataset.csv",
    "orders_data":r"C:\Users\samar\Downloads\archive\olist_orders_dataset.csv",
    "order_items":r"C:\Users\samar\Downloads\archive\olist_order_items_dataset.csv",
    "payments":r"C:\Users\samar\Downloads\archive\olist_order_payments_dataset.csv",
    "reviews":r"C:\Users\samar\Downloads\archive\olist_order_reviews_dataset.csv",
    "product": r"C:\Users\samar\Downloads\archive\olist_products_dataset.csv",
    "seller":r"C:\Users\samar\Downloads\archive\olist_sellers_dataset.csv",
    "category_translaction":r"C:\Users\samar\Downloads\archive\product_category_name_translation.csv",
}


for table_name, file_path in files.items():
  df = pd.read_csv(file_path)
  df=df.fillna("unknown")
  df.to_sql(
        table_name,
        conn,
        if_exists="replace",
        index=False)

print(f"{table_name} loaded: {df.shape}")

conn.close()

print("All data successfully loaded into the database!")