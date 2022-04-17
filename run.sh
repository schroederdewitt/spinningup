#!/bin/bash
HASH=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)
GPU=$1
name=${USER}_spinningup_GPU_${GPU}_${HASH}

echo "Launching container named '${name}' on GPU '${GPU}'"
# Launches a docker container using our image, and runs the provided command

if hash nvidia-docker 2>/dev/null; then
  cmd=nvidia-docker
else
  cmd=docker
fi

container_id=$(NV_GPU="$GPU" ${cmd} run --detach \
    --gpus all \
    --name $name \
    --user $(id -u) \
    --env OMPI_MCA_btl_vader_single_copy_mechanism="none" \
    -v `pwd`:/spinningup \
    -v `pwd`/results:/results \
    -v `pwd`/runs:/runs \
    -t spinningup \
    ${@:2} &)

docker exec -it $container_id /bin/bash
