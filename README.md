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

For ease in development, when a database is created, its name and the name of the owner/user
are both set to the same value. The owner password is requested when the database is created.

## Installing Postgres.app
The simple steps to install Postgres.app are on the home page, repeated here.
Check out the **Details** below for more information to choose which download to use.

1. [Download the Postgres.app](https://postgresapp.com/downloads.html) and open the .dmg
2. Move it to the Applications folder
3. Double Click to start the manager
4. Click *Initialize* to create a new server
5. Configure your $PATH to get access to the command line tools

### Details
The main download link is for the lastest release. There are also links to previous major versions
of Postgres. Finally, there is a link to a packaged bundle of all the currently supported major
versions. This may be useful if you are migrating from one version of Postgres to another.

The easiest way to make sure the CLI tools are available on your $PATH is to execute this:

```
sudo mkdir -p /etc/paths.d &&
echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp
```
Note that you can replace the string *latest* with a specific version if you want,
and you can always edit the **postgresapp** file later if you need to switch versions.

An alternative to the **/etc/paths.d** method is to manually edit
your **~/.bash_profile**, **~/.bashrc** or **~/.zshrc** file and set the PATH variable
to the version you want.  Define one or more exported variables, uncomment the version
you want and restart the Terminal.

```
#export PG_BIN="/Applications/Postgres.app/Contents/Versions/16/bin"
export PG_BIN="/Applications/Postgres.app/Contents/Versions/17/bin"
#export PG_BIN="/Applications/Postgres.app/Contents/Versions/latest/bin"
...
export PATH="$PG_BIN:$PATH"
```

## Building and Installing Postgres Tools
- todo

## Running Postgres Tools

## TODO
- Allow the database owner / user name to be different than the database name.
- Add support for Postgres to run locally in a Docker image.
- Export from Postgres.app and import into the Docker image.