select
    "US Gross" as us_gross,
    "Worldwide Gross" as worldwide_gross,
    "US DVD Sales" as us_dvd_sales,
    "Production Budget" as production_budget,
    "MPAA Rating" as mpaa_rating,
    "Running Time min" as running_time_min,
    distributor,
    source,
    "Major Genre" as major_genres,
    "Creative Type" as creative_type,
    director,
    "Rotten Tomatoes Rating" as rotten_tomatoes_rating,
    "IMDB Rating" as imdb_rating,
    "IMDB Votes" as imdb_votes,
    row_number() over () as movie_id,
    json_extract_string(title, '$') as title,
    cast(strptime("Release Date", '%b %d %Y') as date) as release_date
from {{ source('vega_datasets', 'movies') }}
