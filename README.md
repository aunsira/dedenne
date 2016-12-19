# Dedenne

This project is to try `streamio-ffmpeg` out. This will transcode video to be hls format and upload to Amazon S3 bucket.

## Installation

Clone this repository and run

    $ bundle install

You need to export `AWS_S3_ACCESS_KEY_ID` and `AWS_S3_SECRET_ACCESS_KEY` if you need to upload to Amazon S3.

## Usage

You can transcode video from local terminal with this command

    $ bundle exec bin/dedenne <video_id> <chapter_id> <video_version> <host>

You can also call via API url with `http://localhost:4567/transcode/course/:course_id/chapter/:chapter_id?version={:video_version}` if you have already video on S3 bucket.

## Docker stuff

    $ cd redis/
    $ docker build -t foo/redis .
    $ docker run --name redis -p 6379:6379 -d foo/redis
    $ cd ..
    $ docker build -t dedenne .
    $ docker run -d -t -p 4567:4567 -e AWS_S3_ACCESS_KEY_ID=<AWS_KEY> -e AWS_S3_SECRET_ACCESS_KEY=<AWS_SECRET_KEY> --name dedenne_local --link redis:redis dedenne

A bit more easier with `docker-compose`

`export` AWS bucket access rights at terminal (`AWS_S3_ACCESS_KEY_ID`, `AWS_S3_SECRET_ACCESS_KEY`)

    $ docker-compose pull
    $ docker-compose build
    $ docker-compose up -d
