# Datateer dbt utils

Useful macros for dbt projects using postgres and redshift

Copyright 2020 Datateer. All rights reserved.

## Run Date Macros

Macros for filtering data by run date. Pass variables via `--vars` or in `dbt_project.yml`.

### Variables

- **run_date_start** – Explicit date string (e.g. `'2025-03-01'`). Takes precedence over `run_date_start_days_ago`.
- **run_date_start_days_ago** – Integer; start date = today minus N days (e.g. `7` → 7 days ago).
- **run_date_end** – Explicit date string for the end bound (used by `run_date_end()` and `between_run_dates`).

### Resolution precedence (run_date_start)

1. If `run_date_start` is set → use that date.
2. Else if `run_date_start_days_ago` is set → use `current_date - N`.
3. Else → use `current_date - 1` (default).

### Usage examples

```bash
# Explicit date
dbt run --vars '{run_date_start: "2025-02-01"}'

# Days ago (e.g. last 7 days)
dbt run --vars '{run_date_start_days_ago: 7}'

# Default (yesterday)
dbt run
```

Note: `between_run_dates` reads `run_date_start` and `run_date_end` directly and does not support `run_date_start_days_ago`. Use `run_date_start()` in models for days-ago support.

## Seeds

### Dates

Generated from https://docs.google.com/spreadsheets/d/1K3RLajStpzOUXDIV-HPYcAw4vle5LuMYKfFXL9zTgqM/edit#gid=0

The dates seed populates the following columns:

- date_id: an integer YYYYMMDD
- day: the name of the day of week e.g. Monday, Tuesday, etc
- day_of_month: numeric day of the month
- day_of_week: numeric day of week, with Sunday = 1 and Saturday = 7
- day_of_year: numeric day of year
- full_date: date as YYYY-MM_DD
- month: the name of the month
- month_of_year: numeric month of year, with Jan = 1 and Dec = 12
- quarter of year: numeric quarter of year, with Q1 = 1 and Q4 = 4
- week: name of the week, e.g. Week 1 through Week 53. The first and last weeks may be fewer than 7 days. Weeks start on Sunday
- week_of_year: numeric week of year, 1 through 53
- year: numeric year, YYYY
- is_weekend: true if Saturday or Sunday, false otherwise


## Testing
1. `python -m venv venv && source bin/venv/activate && pip install -r requirements.txt`
1. Create a file `.env` and populated it with `DBT_PROFILES_DIR="./"` and the variables needed by `profiles.yml`

`dbt run-operation test_generate_schema_name --args '{custom_schema_name: "my_test"}' -t test-bigquery-prod`