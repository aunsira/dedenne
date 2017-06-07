# Dedenne
![dedenne](http://cdn.bulbagarden.net/upload/thumb/c/c9/702Dedenne.png/500px-702Dedenne.png)

This project is to try `streamio-ffmpeg` out. This will transcode video to be hls format and upload to Amazon S3 bucket.

## Installation

Clone this repository and run

    $ bundle install

You also need to export `AWS_S3_ACCESS_KEY_ID`, `AWS_S3_SECRET_ACCESS_KEY` and `REDIS_PASSWORD`.

## Usage

This app only provides `GET` endpoint for transcoding video and pushing to S3. For example

    $ curl http://localhost:4567/transcode/course/2/chapter/4?version=1&app_name=skilllane

## Run tests

    $ bundle exec rspec

## Docker stuff

    $ cd redis/
    $ docker build -t foo/redis .
    $ docker run --name redis -p 6379:6379 -d foo/redis
    $ cd ..
    $ docker build -t dedenne .
    $ docker run -d -t -p 4567:4567 -e AWS_S3_ACCESS_KEY_ID=<AWS_KEY> -e AWS_S3_SECRET_ACCESS_KEY=<AWS_SECRET_KEY> --name dedenne_local --link redis:redis dedenne

A bit more easier with `docker-compose`

`export` AWS bucket access rights at terminal (`AWS_S3_ACCESS_KEY_ID`, `AWS_S3_SECRET_ACCESS_KEY`) and Redis's password (`REDIS_PASSWORD`)

    $ docker-compose build
    $ docker-compose up -d
