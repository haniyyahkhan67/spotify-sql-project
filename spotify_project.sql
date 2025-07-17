-- Create database if not exists
CREATE DATABASE IF NOT EXISTS spotify;

-- Use the created database
USE spotify;

-- Create the music_data table
CREATE TABLE music_data (
    Artist VARCHAR(100),
    Track VARCHAR(200),
    Album VARCHAR(200),
    Album_type VARCHAR(50),
    Danceability FLOAT,
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(300),
    Channel VARCHAR(150),
    Views BIGINT,
    Likes BIGINT,
    Comments BIGINT,
    Licensed VARCHAR(5),
    official_video VARCHAR(5),
    Stream VARCHAR(100),
    EnergyLiveness FLOAT,
    most_playedon VARCHAR(100)
);

-- Enable local file loading
SET GLOBAL local_infile = 1;

-- Optional: Bypass strict SQL mode
SET sql_mode = '';

-- Load data from CSV file (adjust the path accordingly)
LOAD DATA LOCAL INFILE 'C:/your_path/clean_file.csv'
INTO TABLE music_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify secure file path (optional)
SHOW VARIABLES LIKE 'secure_file_priv';

-- View entire table
SELECT * FROM music_data;

-- Count total records
SELECT COUNT(*) AS total_records FROM music_data;

-- Retrieve track names with more than 1 billion streams
SELECT Track, Stream 
FROM music_data
WHERE Stream > 1000000000;

-- List all albums and their respective artists
SELECT DISTINCT Artist, Album 
FROM music_data;

-- Total number of comments for tracks where licensed = TRUE
SELECT SUM(Comments) AS total_comments
FROM music_data
WHERE Licensed = 'TRUE';

-- Tracks from albums of type 'single'
SELECT DISTINCT Track, Album_type 
FROM music_data
WHERE Album_type = 'single';

-- Total number of tracks by each artist
SELECT Artist, COUNT(*) AS total_tracks 
FROM music_data
GROUP BY Artist;

-- Average danceability per album
SELECT Album, AVG(Danceability) AS avg_danceability
FROM music_data
GROUP BY Album;

-- Top 5 tracks with highest energy
SELECT Track, Energy 
FROM music_data
ORDER BY Energy DESC
LIMIT 5;

-- Tracks with official music video
SELECT Track, Likes, Comments, official_video 
FROM music_data
WHERE official_video = 'true';

-- Total views per album
SELECT Album, SUM(Views) AS total_views 
FROM music_data
GROUP BY Album;

-- Tracks streamed more on Spotify than viewed on YouTube
SELECT Track, most_playedon 
FROM music_data
WHERE Stream > Views
ORDER BY Track ASC;

-- Total number of views per artist using window function
SELECT 
    Artist, 
    Track, 
    Views,
    SUM(Views) OVER (PARTITION BY Artist) AS total_views
FROM music_data;

-- Average likes per album using window function
SELECT 
    Album, 
    Likes,
    AVG(Likes) OVER (PARTITION BY Album) AS avg_likes
FROM music_data;

-- Rank tracks by views within each album
SELECT 
    Album, 
    Track, 
    Views,
    RANK() OVER (PARTITION BY Album ORDER BY Views DESC) AS view_rank_in_album
FROM music_data;

-- Top 3 tracks per artist by views
SELECT Artist, Track, Views, rank_track
FROM (
    SELECT 
        Artist, 
        Track, 
        Views,
        RANK() OVER (PARTITION BY Artist ORDER BY Views DESC) AS rank_track
    FROM music_data
) AS ranked
WHERE rank_track <= 3;

-- Running total of views per artist
SELECT 
    Artist, 
    Views,
    SUM(Views) OVER (PARTITION BY Artist ORDER BY Track) AS running_total_views
FROM music_data;

-- Percentile rank of tracks within albums based on likes
SELECT 
    Album, 
    Track, 
    Likes,
    PERCENT_RANK() OVER (PARTITION BY Album ORDER BY Likes DESC) AS like_percentile
FROM music_data
WHERE Likes IS NOT NULL;

-- Average, max, and min views per album
SELECT 
    Views, 
    Album,
    AVG(Views) OVER (PARTITION BY Album) AS avg_views,
    MAX(Views) OVER (PARTITION BY Album) AS max_views,
    MIN(Views) OVER (PARTITION BY Album) AS min_views
FROM music_data;

-- Change in loudness between consecutive tracks in the same album
SELECT 
    Album,
    Track,
    Loudness,
    Loudness - LAG(Loudness, 1, 0) OVER (PARTITION BY Album ORDER BY Track) AS loudness_diff
FROM music_data;
