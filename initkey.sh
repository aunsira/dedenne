#!/bin/sh

BASE_URL=${1:-'.'}
qualities="480 720 1080"
_p="p_"
for quality in $qualities
do
  openssl rand 16 > hls_$quality$_p.key
  echo $BASE_URL/hls_$quality$_p.key > hls_$quality$_p.keyinfo
  echo hls_$quality$_p.key >> hls_$quality$_p.keyinfo
  echo $(openssl rand -hex 16) >> hls_$quality$_p.keyinfo
done
