# spotify-sql-project
Spotify Music Data Analysis
This project explores a dataset containing music information from Spotify and YouTube using SQL. The analysis includes track-level metadata, audio features, engagement metrics, and platform performance comparisons.

Dataset Overview
The dataset is loaded into a MySQL table named music_data. It includes the following types of information:

General Metadata: Artist, Track, Album, Album Type

Audio Features: Danceability, Energy, Loudness, Speechiness, Acousticness, Instrumentalness, Liveness, Valence, Tempo, Duration

Engagement Metrics: Views, Likes, Comments, Stream

Additional Info: Licensed, Official Video status, Most Played Platform

How to Use
1. Create and Use the Database
sql
Copy
Edit
CREATE DATABASE IF NOT EXISTS spotify;
USE spotify;
2. Create the Table
Use the provided table creation script to define the music_data structure.

3. Load the Data from CSV
Update the file path to match your system:

sql
Copy
Edit
LOAD DATA LOCAL INFILE 'C:/your_path/clean_file.csv'
INTO TABLE music_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
Tip: You may need to enable local_infile in MySQL with:

sql
Copy
Edit
SET GLOBAL local_infile = 1;
What This Project Includes
Basic Queries
Count total records

List all unique albums and artists

Find tracks with over 1 billion streams

Get all tracks from albums marked as singles

Aggregated Stats
Total comments for licensed tracks

Number of tracks per artist

Average danceability per album

Total views per album

Top Tracks Analysis
Top 5 tracks by energy

Top 3 tracks by views for each artist

Tracks streamed more on Spotify than viewed on YouTube

Window Functions
Total views per artist using SUM() OVER

Average likes per album using AVG() OVER

Rank tracks by views within albums using RANK()

Percentile ranking of tracks based on likes with PERCENT_RANK()

Running totals and differences using LAG()

Project Purpose
This project is designed to:

Practice writing and using advanced SQL queries

Explore real-world music performance data

Gain insights into track popularity and platform trends

Notes
Ensure your MySQL server supports LOAD DATA LOCAL INFILE

Data cleaning may be required if types like Stream are stored as strings
