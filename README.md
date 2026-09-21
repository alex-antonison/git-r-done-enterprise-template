# Welcome to Git-R-Done Enterprises

This is an example project to practice learning git concepts.

This project deploys a streamlit app at [to be added].

## Pre-run Setup

1. Install Python
2. Setup `.streamlit/secrets.toml`
   1. Copy the [.streamlit/secrets-example.toml](.streamlit/secrets-example.toml) and save it as `secrets.toml`

### Python and dbt Setup

1. Run `.\build.ps1` from the project root (Windows), or `just build` (macOS/Linux).
2. The script will create `.venv` and install dependencies, including dbt v2.
3. Python 3.12, 3.13, and 3.14 are supported by the script.
4. On Windows, if no compatible Python version is installed, the script will attempt to install Python 3.13 via `winget`.
5. Activate the environment using `.\.venv\Scripts\activate` (Windows) or `source .venv/bin/activate` (macOS/Linux)
6. Run `dbt --version` to make sure everything is working.

## Looking at data

Use a database client such as DBeaver to connect to the DuckDB database file located at `database/dev/git_r_done_enterprises.duckdb`.

## Exercise 

1. Come up with an idea for doing some analytics with movie data - you can see the raw source schema here: [models\marts\sources.yml](models/marts/sources.yml).
2. Write a GitHub issue describing the idea and what you would like to do with it.
3. Create a descriptive branch name (e.g., `analytics-movie-revenue`).
4. Add a dbt model under [models/marts/](models/marts/) similar to [models\marts\sample_model_revenue.sql](models\marts\sample_model_revenue.sql) that implements what you described in your GitHub Issue.
5. Run `dbt run` and make sure everything is working.
6. Commit your changes and push them to GitHub.
7. Open a pull request against the main branch of this repository.
8. Once done, review your PR with someone else and get feedback.

## Extra

If you are interested, you can tinker with the `streamlit_app.py` script and add some visualizations or other features to it.

To run it, do `streamlit run streamlit_app.py`.