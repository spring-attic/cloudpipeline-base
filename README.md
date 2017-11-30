# Pipeline-base

[![](https://images.microbadger.com/badges/image/springcloud/pipeline-base-git.svg)](https://microbadger.com/images/springcloud/pipeline-base "Get your own image badge on microbadger.com")

Alpine docker image with openjdk and git and bash, ruby and other libraries required
for the opinionated pipeline.

## How to do it

Follow the instructions starting from [https://docs.docker.com/engine/getstarted/step_four/](here)

```
$ docker build -t pipeline-base . --no-cache
$ docker images
// find the proper image e.g. 95610717ba45
// pick proper version e.g. 0.6.0
$ docker tag 95610717ba45 springcloud/pipeline-base:0.6.0
$ docker tag 95610717ba45 springcloud/pipeline-base:latest
$ docker login
$ docker push springcloud/pipeline-base
```
