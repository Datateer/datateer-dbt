# Datateer dbt utils

Useful macros for dbt projects using postgres and redshift

Copyright 2020 Datateer. All rights reserved.

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
