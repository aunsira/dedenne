#!/bin/sh

BASE_URL=${1:-'.'}
qualities="480 720 1080"
for quality in $qualities
do
  openssl rand 16 > hls_$quality.key
  echo $BASE_URL/hls_$quality.key > hls_$quality.keyinfo
  echo hls_$quality.key >> hls_$quality.keyinfo
  echo $(openssl rand -hex 16) >> hls_$quality.keyinfo
done
