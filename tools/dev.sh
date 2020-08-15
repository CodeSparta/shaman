#!/bin/bash -x
clear
#   --entrypoint bash \
sudo podman run -it --rm \
    --name shaman \
    --entrypoint bash \
    --workdir /root/deploy/terraform/shaman \
    --volume $(pwd):/root/deploy/terraform/shaman:z \
  docker.io/codesparta/konductor