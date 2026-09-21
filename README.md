# Welcome to Git-R-Done Enterprises

This is an example project to practice learning git concepts.

This project builds movie analytics data with dbt, then visualizes it with [dbt Charts](https://docs.getdbt.com/guides/dbt-charts).

## Python and dbt Setup

1. Run `.\build.ps1` from the project root (Windows), or `./build.sh` (macOS/Linux).
2. The script installs [uv](https://docs.astral.sh/uv/getting-started/installation/) if it isn't already on your machine, uses it to install Python 3.13 and create `.venv`, then installs dependencies (including dbt v2) into it.
3. Activate the environment using `.\.venv\Scripts\activate` (Windows) or `source .venv/bin/activate` (macOS/Linux).
4. Run `dbt --version` to make sure everything is working.
5. Run `dbt run` to build the models.

## dbt Charts Setup

dbt Charts runs in its own isolated tool environment, separate from the `.venv` above. `uv` is already available after the setup step above.

1. Install dbt Charts with the DuckDB adapter it needs to read `profiles.yml`: `uv tool install dbt-charts --with dbt-duckdb`.
2. Run `dct serve` from the project root to preview the dashboard in your browser.

## Looking at data

Use a database client such as DBeaver to connect to the DuckDB database file located at `database/dev/git_r_done_enterprises.duckdb`, or view it through the dbt Charts dashboard (`dct serve`).

## Exercise

1. Come up with an idea for doing some analytics with movie data - you can see the raw source schema here: [models\sources.yml](models/sources.yml).
2. Write a GitHub issue describing the idea and what you would like to do with it.
3. Create a descriptive branch name (e.g., `analytics-movie-revenue`).
4. Add a dbt model under [models/marts/](models/marts/) similar to [models\marts\sample_model_revenue.sql](models\marts\sample_model_revenue.sql) that implements what you described in your GitHub Issue.
5. Run `dbt run` and make sure everything is working.
6. Add a chart for your new model to [charts/analytics.yml](charts/analytics.yml) (or a new file under `charts/`) and preview it with `dct serve`.
7. Commit your changes and push them to GitHub.
8. Open a pull request against the main branch of this repository.
9. Once done, review your PR with someone else and get feedback.

## Extra

If you are interested, tinker with [charts/analytics.yml](charts/analytics.yml) — add new chart types, filters, or KPIs. Run `dct docs charts` for the full chart reference.
