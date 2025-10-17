
# =========================================
# Final Project Database Build Script
# Author: [Your Name]
# Project: Effect of Pyrolysis Conditions on Biochar Properties
# =========================================

# Load libraries
library(DBI)
library(RSQLite)

# Create or connect to database file
con <- dbConnect(RSQLite::SQLite(), "biochar_project.db")

# Drop tables if they already exist (optional, for reruns)
dbExecute(con, "DROP TABLE IF EXISTS BiocharProperty;")
dbExecute(con, "DROP TABLE IF EXISTS PyrolysisCondition;")
dbExecute(con, "DROP TABLE IF EXISTS WoodSample;")

# Create tables
dbExecute(con, "
CREATE TABLE WoodSample (
  sample_id INTEGER PRIMARY KEY,
  wood_type TEXT,
  source TEXT
);
")

dbExecute(con, "
CREATE TABLE PyrolysisCondition (
  condition_id INTEGER PRIMARY KEY,
  sample_id INTEGER,
  residence_time TEXT,
  temperature INTEGER,
  date_run DATE,
  FOREIGN KEY (sample_id) REFERENCES WoodSample(sample_id)
);
")

dbExecute(con, "
CREATE TABLE BiocharProperty (
  property_id INTEGER PRIMARY KEY,
  condition_id INTEGER,
  carbon_content REAL,
  nitrogen_content REAL,
  cn_ratio REAL,
  density REAL,
  surface_area REAL,
  FOREIGN KEY (condition_id) REFERENCES PyrolysisCondition(condition_id)
);
")



dbExecute(con, "
INSERT INTO PyrolysisCondition (sample_id, residence_time, temperature, date_run) VALUES
(1, 'Fast', 450, '2025-10-10'),
(1, 'Fast', 525, '2025-10-11'),
(1, 'Slow', 600, '2025-10-12'),
(2, 'Slow', 525, '2025-10-13');
")

dbExecute(con, "
INSERT INTO BiocharProperty (condition_id, carbon_content, nitrogen_content, cn_ratio, density, surface_area) VALUES
(1, 75.4, 1.2, 62.8, 0.45, 210.5),
(2, 80.1, 1.1, 72.8, 0.48, 240.3),
(3, 82.5, 1.3, 63.5, 0.50, 260.2);
")

# Check tables created
print(dbListTables(con))
print(dbReadTable(con, "BiocharProperty"))

# Disconnect
dbDisconnect(con)

# =========================================
# End of Script
# =========================================
