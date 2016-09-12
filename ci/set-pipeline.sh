#!/bin/sh
echo y | fly -t main sp -p alpine-java-docker-bash-git -c pipeline.yml -l credentials.yml
