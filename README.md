# Humanitarian Programme Data Analysis

A SQL project analysing humanitarian programme data across partner organisations, villages and districts.

## Overview

This project uses a relational database, `humanitarian_program`, to analyse beneficiary reach by partner organisation (World Vision, CARE and IRC) and by location. It covers database setup, data loading, analytical queries (Tasks 1 to 7), and two summary outputs.

## Database Structure

| Table | Description |
|---|---|
| `beneficiary_partner_data` | Beneficiary records linked to each partner organisation |
| `village_locations` | Villages and their location details |
| `jurisdiction_hierarchy` | Administrative hierarchy linking villages to districts |

## Contents of the SQL File

The script is a single file, run top to bottom:

1. Database and table creation
2. Data insertion
3. Tasks 1 to 7: analytical queries
4. `Partner_summary`: summary of results per partner
5. `District_summary`: summary of results per district

## How to Run

1. Install MySQL (or your preferred SQL engine) and open MySQL Workbench, DBeaver or the command line.
2. Clone the repository:
   ```
   git clone https://github.com/your-username/humanitarian-programme-sql.git
   ```
3. Run the script on a fresh database:
   ```
   mysql -u root -p < humanitarian_program.sql
   ```
   Alternatively, open the file in your SQL client and execute the whole script.
4. Confirm the database was created:
   ```sql
   USE humanitarian_program;
   SHOW TABLES;
   ```

## Tools Used

- SQL (MySQL)
- MySQL Workbench / DBeaver
- Git and GitHub

## Author

Abigail Kimani
Zindua School
