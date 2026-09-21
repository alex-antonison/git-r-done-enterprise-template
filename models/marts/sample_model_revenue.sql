WITH

all_releases AS (
    SELECT
        cast(
            date_part('year', strptime("Release Date", '%b %d %Y')) AS INTEGER
        ) AS release_year,
        "MPAA Rating" AS mpaa_rating,
        "Major Genre" AS major_genres,
        "Worldwide Gross" AS worldwide_gross
    FROM {{ source('vega_datasets', 'movies') }}
)

SELECT
    release_year,
    mpaa_rating,
    major_genres,
    sum(worldwide_gross) AS total_worldwide_gross
FROM all_releases
GROUP BY
    release_year,
    mpaa_rating,
    major_genres
