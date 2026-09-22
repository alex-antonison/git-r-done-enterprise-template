with

all_releases as (
    select
        mpaa_rating,
        major_genres,
        worldwide_gross,
        date_part('year', release_date) as release_year
    from {{ ref('stg_movies') }}
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
