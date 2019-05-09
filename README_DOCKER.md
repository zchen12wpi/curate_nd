# Developing CurateND with Docker

## Installation Notes
Install Docker: https://www.docker.com/

Install docker-sync: http://docker-sync.io/

## Starting services
### Dependencies only
If you want to run the dependencies without running rails, such as when running rails on your host machine, just run the base compose:
```console
docker-compose up
```
Then load the database schema:
```console
bundle exec rake db:schema:load
```

### Dependencies + Rails
If you want to run all services, including the rails application:
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml up
```

### Developing rails on OSX
If you're going to be developing the application inside of the container on OSX, you'll need to use docker-sync to copy files from the local file system into the container volume. To start the stack, which will start all of the dependencies along with the rails container, run the following:
```console
docker-sync-stack start
```

## Interacting with the running rails container
### Testing
To execute the full test suite, run
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  exec rails bundle exec rake
```
To run individual specs, run
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  exec rails bundle exec rspec spec/path/to/file_spec.rb
```

### Debugging the application
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  exec rails bundle exec byebug --remote localhost:9876
```

### Interacting with Rails Command Line
If you need to open a rails console, run seed scripts, or any of the normal rails activities that you used to do on your terminal, you'll need to first open a shell inside the running rails container:
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  exec rails bash
```

### Rebuilding rails Docker image
Do this when you change Gemfile or Gemfile.lock or anything that Rails won't hotload.
```console
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  build rails
docker-compose -f docker-compose.yml -f docker-compose-rails.yml \
  restart rails
```

## Dockerhub image maintenance
### Rebuilding curate-jetty Docker image
To rebuild the Docker image for running jetty, use the following command:
```console
docker build . -t ndlib/curate-jetty -f docker/Dockerfile.jetty
```

To push your image to Dockerhub:
```console
docker login
docker push ndlib/curate-jetty
```

### Rebuilding curate-jetty with seed data
To rebuild the image with pre-generated seed data:
```console
# First reset to the base image
docker stop curate-jetty && docker rm curate-jetty
docker run -p 8983:8983 -d --name curate-jetty -t ndlib/curate-jetty
# Run seed scripts from the project root directory
bundle exec rake db:schema:load db:seed:dev
# Commit these changes to your image
docker commit curate-jetty ndlib/curate-jetty-devseed
# Push it up as the dev seed image
docker login
docker push ndlib/curate-jetty-devseed
```
