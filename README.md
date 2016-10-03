# Dedenne

This project is to try `streamio-ffmpeg` out. This will transcode video to be hls format and upload to Amazon S3 bucket.

## Installation

Clone this repository and run

    $ bundle install

You need to export `AWS_KEY_ID` and `AWS_SECRET` if you need to upload to Amazon S3.

## Usage

You can transcode video from local terminal with this command

    $ bundle exec bin/dedenne <video_id> <chapter_id> <video_version>

You can also call via API url with `http://localhost:4567/transcode/course/:course_id/chapter/:chapter_id?version={:video_version}` if you have already video on S3 bucket.
