import pandas as pd
import psycopg2
from sqlalchemy import create_engine, text

# =====================================================
# POSTGRES CONNECTION
# =====================================================

pg_conn = psycopg2.connect(
    host="pg-1b745e53-fordiscord2099-bea5.j.aivencloud.com",
    port=11903,
    database="defaultdb",
    user="avnadmin",
    password="REDACTED"
)

# =====================================================
# SNOWFLAKE ENGINE
# =====================================================

sf_engine = create_engine(
    "snowflake://SPIDER:Sivakarreddy2004@QTVTQSV-TR64580/HEALTHCARE/RAW?warehouse=COMPUTE_WH&role=ACCOUNTADMIN"
)

# =====================================================
# TABLES TO MIGRATE
# =====================================================

schema_name = "public" 

tables_query = f"""
    SELECT table_name 
    FROM information_schema.tables
    WHERE table_schema = '{schema_name}'
      AND table_type = 'BASE TABLE'
    ORDER BY table_name
"""

tables_df = pd.read_sql(tables_query, pg_conn)
tables = tables_df["table_name"].tolist()

print(f"Found {len(tables)} tables in schema '{schema_name}': {tables}")

# =====================================================
# LOAD TABLES
# =====================================================

for table in tables:

    print(f"\nLoading table: {table}")

    # Read from Postgres
    query = f"SELECT * FROM public.{table}"

    df = pd.read_sql(query, pg_conn)

    print(f"Rows fetched: {len(df)}")

    # Snowflake target table
    target_table = f"RAW_{table.upper()}"

    # =================================================
    # TRUNCATE EXISTING TABLE
    # =================================================

    with sf_engine.connect() as conn:

        conn.execute(
            text(f"TRUNCATE TABLE {target_table}")
        )

        conn.commit()

    print(f"RAW_{target_table} truncated")

    # =================================================
    # LOAD DATA INTO SNOWFLAKE
    # =================================================

    df.to_sql(
        name=target_table,
        con=sf_engine,
        if_exists="append",
        index=False,
        method="multi"
    )

    print(f"{target_table} loaded successfully!")

# =====================================================
# CLOSE CONNECTIONS
# =====================================================

pg_conn.close()

print("\nMigration completed successfully!")