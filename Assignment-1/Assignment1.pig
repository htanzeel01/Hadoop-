steamcsv = LOAD '/user/maria_dev/steam/Steam_games-features.csv' USING PigStorage(',') AS (
    QueryId: chararray,
    ResponseId: chararray,
    QueryName: chararray,
    ResponseName: chararray,
    ReleaseDate: chararray
);

-- Filter out rows with missing or null ReleaseDate values
filtered_data = FILTER steamcsv BY ReleaseDate IS NOT NULL;

-- Extract the year from the ReleaseDate field
year_data = FOREACH filtered_data GENERATE SUBSTRING((chararray)ReleaseDate, 7, 11) AS ReleaseYear;

-- Filter out empty or invalid ReleaseYear values
filtered_year_data = FILTER year_data BY ReleaseYear MATCHES '\\d{4}';

-- Group by ReleaseYear and count the number of games released in each year
game_count = GROUP filtered_year_data BY ReleaseYear;
game_count_result = FOREACH game_count GENERATE group AS ReleaseYear, COUNT(filtered_year_data) AS NumGamesReleased;

-- Display the number of games released in each year
ordered_game_count_result = ORDER game_count_result BY ReleaseYear ASC;
DUMP ordered_game_count_result;
