#!/bin/bash -x
clear
#   --entrypoint bash \
sudo podman run -it --rm \
    --name devkit-vpc \
    --entrypoint bash \
    --workdir /root/deploy/terraform/devkit-vpc \
    --volume $(pwd):/root/deploy/terraform/devkit-vpc:z \
  docker.io/codesparta/konductor