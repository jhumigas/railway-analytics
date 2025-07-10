# Fully Local Data Transformation with dbt and DuckDB

A demonstration of local data transformation and reverse ETL pipelines using DuckDB and dbt with the dbt-duckdb adapter. This project showcases how to build a complete data pipeline that processes Dutch railway services and geographic data into a structured data mart.

> 📖 **Based on**: [Fully Local Data Transformation with dbt and DuckDB](https://duckdb.org/2025/04/04/dbt-duckdb.html) - DuckDB Blog Post

## 🚀 Features

- **Fully Local Processing**: No cloud dependencies - all data transformation happens locally
- **Spatial Data Integration**: Combines railway data with geographic information using DuckDB's spatial extensions
- **Modern Data Stack**: Uses dbt for transformation
- **Multiple Export Options**: Export to files (CSV, JSON, Parquet) or directly to PostgreSQL
- **Dimensional Modeling**: Implements a star schema with fact and dimension tables
- **Incremental Processing**: Supports both full refresh and incremental data loads
- **Data visualization**: Add metabase for adhoc analysis 

## 📊 Data Model

The project creates a dimensional model with:

- **`dim_nl_provinces`** - Dutch provinces dimension table
- **`dim_nl_municipalities`** - Dutch municipalities dimension table (linked to provinces)
- **`dim_nl_train_stations`** - Train stations dimension table (linked to municipalities)
- **`fact_services`** - Train services fact table (linked to stations)

## 🛠 Tech Stack

- **[DuckDB](https://duckdb.org/)** - In-process analytical database
- **[dbt](https://www.getdbt.com/)** - Data transformation framework
- **[dbt-duckdb](https://github.com/duckdb/dbt-duckdb)** - DuckDB adapter for dbt
- **[Metabase](https://www.metabase.com/)** - Business intelligence tool
- **Spatial Extensions** - For geographic data processing
- **PostgreSQL** - Optional target for reverse ETL

## 📋 Prerequisites

Make sure you have:

- [uv](https://docs.astral.sh/uv/): Python package and project manager ([instructions](https://docs.astral.sh/uv/getting-started/installation/))
- [Docker](https://www.docker.com/get-started/) or a docker container manager (use [colima](https://github.com/abiosoft/colima#installation) for macOS)
- [dbeaver](https://dbeaver.io/) optional database tool to manage your database or pgadmin

## 🚀 Quick Start

### 1. Install Dependencies

```bash
make install
```

### 2. Run the Pipeline

```bash
# Run all models
dbt run

# Run with tests
dbt run && dbt test

# Run specific model groups
dbt run --select "+transformation"
dbt run --select "+reverse_etl"
dbt run --select "+exports "
```

## 📁 Project Structure

```text
.
├── docker
├── example.env
├── Makefile
├── pyproject.toml
├── railway_analytics
│   ├── analyses
│   ├── data
│   │   ├── exports
│   │   └── railway_analytics.duckdb
│   ├── dbt_project.yml
│   ├── macros
│   ├── models
│   │   ├── exports
│   │   ├── reverse_etl
│   │   ├── sources.yml
│   │   └── transformation
│   ├── package-lock.yml
│   ├── packages.yml
│   ├── profiles.yml
│   ├── README.md
│   ├── seeds
│   ├── snapshots
│   └── tests
├── README.md
└── uv.lock
```

## 🔧 Configuration

### Data Sources

The project uses multiple data sources:

- **External DuckDB Database**: Railway services data hosted on Cloudflare
- **Remote GeoJSON**: Dutch provinces data from cartomap
- **Local GeoJSON**: Dutch municipalities data included in the project

### Materialization Options

- **`table`**: Full refresh replacement
- **`incremental`**: Append or delete+insert strategies
- **`external`**: Export to external files (CSV, JSON, Parquet)
- **`view`**: Creates database views

### Example Model Configuration

```sql
-- Full refresh table
{{ config(materialized='table') }}

-- Incremental model
{{ config(
    materialized='incremental',
    incremental_strategy='delete+insert',
    unique_key='service_date, station_sk'
) }}

-- External file export
{{ config(
    materialized='external',
    location='data/exports/output',
    options={
        "partition_by": "year, month",
        "overwrite": True
    }
) }}
```

## 🐘 PostgreSQL Integration

To enable reverse ETL to PostgreSQL:

1. Add PostgreSQL extension to your profile:

```yaml
extensions:
  - spatial
  - httpfs
  - postgres
```

2. Configure database attachment:

```yaml
attach:
  - path: "postgresql://user:password@localhost:5432/dbname"
    type: postgres
    alias: postgres_db
```

3. Run reverse ETL models:

```bash
dbt run --models +reverse_etl
```

## 🧪 Testing

The project includes comprehensive data quality tests:

```bash
# Run all tests
dbt test

# Run tests for specific models
dbt test --models dim_nl_provinces

```

## 📈 Performance

Performance characteristics on a MacBook Pro (12GB RAM):

- **Total execution time**: 40-45 seconds
- **Data processed**: 400MB+ from external sources
- **Models**: 10 transformation models
- **Tests**: 20 data quality tests
- **Processing**: ~30 seconds for main transformations
- **PostgreSQL export**: ~4 seconds

## 🎯 Use Cases

This project demonstrates:

- Local data lake/warehouse creation
- Spatial data processing and analysis
- Modern data transformation patterns
- Multi-format data export capabilities
- Reverse ETL to operational databases
- Data quality testing and validation.
