# AUI Club, Event & Facility Management System

CSC 3326 database project (PostgreSQL)

Files:
- Aui_schema_pg.sql - creates the tables and adds some starting data
- Aui_sample_data_pg.sql - more sample data (empties the tables first)
- Aui_queries_pg.sql - our queries
- AUI_Club_Event_Facility_Management_Project_Description-1.pdf - project description

To run (in order):

```
psql -v ON_ERROR_STOP=1 -a -f Aui_schema_pg.sql -U <user>
psql -v ON_ERROR_STOP=1 -a -f Aui_sample_data_pg.sql -U <user>
psql -v ON_ERROR_STOP=1 -a -f Aui_queries_pg.sql -U <user>
```
