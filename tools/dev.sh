#!/bin/bash -x
clear
sudo podman run -it --rm \
    --name shaman -h shaman--entrypoint bash \
    --volume $(pwd):/root/platform/iac/shaman:z \
    --workdir /root/platform/iac/shaman \
  docker.io/codesparta/konductor
