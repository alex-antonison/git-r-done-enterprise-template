with

all_releases as (
    select
        "MPAA Rating" as mpaa_rating,
        "Major Genre" as major_genres,
        "Worldwide Gross" as worldwide_gross,
        cast(
            date_part('year', strptime("Release Date", '%b %d %Y')) as integer
        ) as release_year
    from {{ source('vega_datasets', 'movies') }}
)

select
    release_year,
    mpaa_rating,
    major_genres,
    sum(worldwide_gross) as total_worldwide_gross
from all_releases
group by
    release_year,
    mpaa_rating,
    major_genres
