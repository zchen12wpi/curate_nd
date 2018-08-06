# CurateND
[![Build Status](https://travis-ci.org/ndlib/curate_nd.svg?branch=master)](https://travis-ci.org/ndlib/curate_nd)
[![Stories in Ready](https://badge.waffle.io/ndlib/curate_nd.png?label=ready&title=Ready)](https://waffle.io/ndlib/curate_nd)

This application will be deployed to [curate.nd.edu](http://curate.nd.edu).

Its primary function is to be a self-deposit interface for our institutional digital repository.

Note: If using Docker, see [README_DOCKER.md](./README_DOCKER.md) for instructions.

## Installation Notes
Installing the clamav gem on OS X is a trying process. It can be safely excluded
from your development environment

```console
bundle install --without headless
```

## Testing

### 1. Start dependencies
```console
bundle exec rake curatend:jetty:start
```

### 2. Run specs
To execute the full test suite, run
```console
bundle exec rake
```
To run individual specs, run

```console
bundle exec rspec spec/path/to/file_spec.rb
```

### Testing of Specific Curation Concern Types

The deposit page shows only the curation concern types that you are authorized to create. These options are generated from /config/work_type_policy_rules.yml.

Certain curation concern types are never created interactively:
* ETDs are now created via Sipity. If they are authorized through the work_type_policy_rules, they still cannot be added because they require Degree options to exist in the database (EtdVocabulary table) which map to the degrees in /config/etd_degree_map.yml. No routes exist to add new etd_vocabularies, however there is an etd_vocabularies_controller which could be used.
* OSF Archives are imported via an option on the deposit menu.


## Running the application

### 1. Start dependencies
Before you start the web-server you'll need to make sure Fedora and SOLR are running.

Start Fedora and SOLR via jetty:

```console
bundle exec rake curatend:jetty:start
```

Start MySQL:

```console
mysql.server start
```

### 2. Initialize the database
Load the database schema into MySQL:
```console
bundle exec rake db:schema:load
```

To seed database with test data:
```console
bundle exec rake db:seed:dev
```

### 3. Start Rails

In most cases, you will need SSL, so use this command:

```console
bundle exec thin start -p 3000 --ssl --ssl-key-file dev_server_keys/server.key --ssl-cert-file dev_server_keys/server.crt
```

If you don't need SSL, use the following command:

```console
bundle exec rails server
```

## Release Documentation

See the [release documentation](https://docs.google.com/a/nd.edu/document/d/16weRctSzt8Iw2y55nwOKPBSgGDO_4lgti3CxaW3P2pc/edit?usp=sharing) for building a release.
