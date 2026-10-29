# Postgres Tools

This repository contains a number of tools useful to a full-stack web application developer
that uses the PostgreSQL relational database (often shortened to Postgres).
While coding and testing, it is handy to have a local Postgres database running.

This project was designed for a Mac user that uses the Postgres.app as the installed Postgres
database. The Postgres.app can be found at [this link](https://postgresapp.com/). A specific
version of Postgres can be downloaded or a release that contains all currently supported
versions.

The scripts and configuration for this package are mainly wrappers around the existing CLI
that Postgres provides, but make it easy to:
- set the current database configuration
- create an empty database
- export the schema and data from a running engine (useful to share data amongst other developers)
- import that data into a fresh, empty instance
- clean up temporary files after importing
- run a vacuum / analyze on the data
- execute the **psql** tool to run SQL

The scripts are all named with the pgt_ prefix similar to the CLI commands for Postgres;
*pgt_* stands for "Postgres Tools".

## Installing Postgres.app
- todo

## Building and Installing Postgres Tools
- todo

## Running Postgres Tools

## TODO
- Have setup either prompt for the database name or read from a list of favorite names.
- Add support for Postgres to run locally in a Docker image.
- Export from Postgres.app and import into the Docker image.