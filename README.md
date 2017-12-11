# CurateND
[![Build Status](https://travis-ci.org/ndlib/curate_nd.svg?branch=master)](https://travis-ci.org/ndlib/curate_nd)
[![Stories in Ready](https://badge.waffle.io/ndlib/curate_nd.png?label=ready&title=Ready)](https://waffle.io/ndlib/curate_nd)

This application will be deployed to [curate.nd.edu](http://curate.nd.edu).

Its primary function is to be a self-deposit interface for our institutional digital repository.

## Installation Notes

Installing the clamav gem on OS X is a trying process. It can be safely excluded
from your development environment

```console
$ bundle install --without headless
```

## Testing

You can run `bundle exec rake` to execute the test suite.

You can also boot up jetty (e.g. `bundle exec rake curatend:jetty:start`) and run individual specs via `bundle exec rspec spec/path/to/file_spec.rb`

### Testing of Specific Curation Concern Types

The deposit page shows only the curation concern types that you are authorized to create. These options are generated from /config/work_type_policy_rules.yml.

Certain curation concern types are never created interactively:
* ETDs are now created via Sipity. If they are authorized through the work_type_policy_rules, they still cannot be added because they require Degree options to exist in the database (EtdVocabulary table) which map to the degrees in /config/etd_degree_map.yml. No routes exist to add new etd_vocabularies, however there is an etd_vocabularies_controller which could be used.
* OSF Archives are imported via an option on the deposit menu.


## Running the application

Before you start the web-server you'll need to make sure Fedora and SOLR are running. Use the following command:

```console
$ bundle exec rake curatend:jetty:start
```

You may also need to make sure that mySQL is running as well:

```console
$ mysql.server start
```

### Getting Your Rails Application Running

In most cases, you won't need SSL, so use the following command:

```console
$ bundle exec rails server
```

If you do need SSL, use this command:

```console
$ bundle exec thin start -p 3000 --ssl --ssl-key-file dev_server_keys/server.key --ssl-cert-file dev_server_keys/server.crt
```

## Release Documentation

See the [release documentation](https://docs.google.com/a/nd.edu/document/d/16weRctSzt8Iw2y55nwOKPBSgGDO_4lgti3CxaW3P2pc/edit?usp=sharing) for building a release.
