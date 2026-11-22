# AUI Club, Event & Facility Management System

CSC 3326 database project (PostgreSQL).

## Files

| File | Purpose |
|---|---|
| `Aui_schema_pg.sql` | Creates all tables (DDL) and loads a small starter data set |
| `Aui_sample_data_pg.sql` | Empties the tables and loads a larger sample data set |
| `Aui_queries_pg.sql` | Example queries: joins, ORDER BY, UNION, INTERSECT, EXCEPT, outer joins, subqueries, division |
| `AUI_Club_Event_Facility_Management_Project_Description-1.pdf` | Project description |

## How to run

```sh
psql -v ON_ERROR_STOP=1 -a -f Aui_schema_pg.sql      -U <your_user>
psql -v ON_ERROR_STOP=1 -a -f Aui_sample_data_pg.sql -U <your_user>   # optional, larger data set
psql -v ON_ERROR_STOP=1 -a -f Aui_queries_pg.sql     -U <your_user>
```

## Tables

`student`, `club`, `membership`, `officer`, `event`, `event_club`, `registration`,
`administrator`, `venue`, `equipment`, `request`

## Contributing

1. Clone the repo: `git clone <repo-url>`
2. Make your changes and commit them.
3. Push (if you were added as a collaborator) or open a pull request.
