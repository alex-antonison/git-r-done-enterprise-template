# Welcome to Git-R-Done Enterprises

This is an example project to practice learning git concepts.

This project builds movie analytics data with dbt, then visualizes it with [dbt Charts](https://docs.getdbt.com/guides/dbt-charts).

## Python and dbt Setup

1. Run `.\build.ps1` from the project root (Windows), or `./build.sh` (macOS/Linux).
2. The script installs [uv](https://docs.astral.sh/uv/getting-started/installation/) if it isn't already on your machine, uses it to install Python 3.14 and create `.venv`, then installs dependencies (including dbt v2) into it. It also installs [dbt Charts](https://docs.getdbt.com/guides/dbt-charts) (`dct`) via `uv tool install`, in its own isolated tool environment separate from `.venv`.
3. Activate the environment using `.\.venv\Scripts\activate` (Windows) or `source .venv/bin/activate` (macOS/Linux).
4. Run `dbt --version` to make sure everything is working.
5. Run `dbt run` to build the models.
6. Run `dct serve` from the project root to preview the dashboard in your browser.

## Looking at data

- **`dbt show`** — preview a model's output straight from the CLI, no other tool needed (swap the model name for any other one, e.g. `sample_mart_revenue`):

   ```shell
   dbt show --select stg_movies --limit 10
   ```

- **DBeaver** (or another database client) — connect to `database/git_r_done_enterprises.duckdb`. Disconnect before running `dbt run` again — DuckDB only allows one writer at a time.

## Data model

- **Source** ([models/sources.yml](models/sources.yml)) — the raw movie dataset, pulled directly from the [Vega datasets](https://github.com/vega/vega-datasets) project's `movies.json`. Columns are exactly as published: spaced names like `"MPAA Rating"` and `"US Gross"`, and a couple of type quirks (a handful of numeric-looking titles like `"1984"` infer as JSON instead of plain text).
- **Staging** ([models/staging/stg_movies.sql](models/staging/stg_movies.sql)) — cleans the source up into a model you can actually build on: renames every column to snake_case, casts `Release Date` into a real `date` instead of a formatted string, and fixes the `Title` JSON quirk so it's always plain text.
- **Marts** ([models/marts/](models/marts/)) — business-facing models built from staging, not the raw source. [sample_mart_revenue.sql](models/marts/sample_mart_revenue.sql) is the example to copy.

## Exercise

1. Come up with an idea for doing some analytics with movie data - you can see the cleaned-up schema here: [models\staging\stg_movies.yml](models/staging/stg_movies.yml).
2. Write a GitHub issue describing the idea and what you would like to do with it.
3. Create a descriptive branch name (e.g., `analytics-movie-revenue`).
4. Add a dbt model under [models/marts/](models/marts/) similar to [models/marts/sample_mart_revenue.sql](models/marts/sample_mart_revenue.sql) that implements what you described in your GitHub Issue — reference `{{ ref('stg_movies') }}`, not the raw source.
5. Run `dbt run` and make sure everything is working.
6. Commit your changes and push them to GitHub.
7. Open a pull request against the main branch of this repository.
8. Once done, review your PR with someone else and get feedback.

## Extra

If you are interested, tinker with [charts/analytics.yml](charts/analytics.yml) — add a chart for your new model (or new chart types, filters, KPIs) and preview it with `dct serve`. Run `dct docs charts` for the full chart reference.
