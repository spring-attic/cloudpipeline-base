#!/usr/bin/env sh

set -e

export pipelineBaseTag=0.7.0
echo -e "\n\nBUILDING THE IMAGE\n\n"
docker build -t cloudpipelines/pipeline-base . --no-cache
imageId="$( docker images cloudpipelines/pipeline-base | grep "${pipelineBaseTag}" | awk '{print $3}' )"
echo -e "\n\nFOUND THE IMAGE WITH ID [${imageId}]\n\n"
// find the proper image e.g. 95610717ba45
// pick proper version e.g. 0.7.0
docker tag "${imageId}" cloudpipelines/pipeline-base:"${pipelineBaseTag}"
docker tag "${imageId}" cloudpipelines/pipeline-base:latest
docker login
docker push cloudpipelines/pipeline-base
git tag v"${pipelineBaseTag}"
git push origin v"${pipelineBaseTag}"
