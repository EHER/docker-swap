# docker-swap

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/)

Enable swap on you docker host.

## Usage

    docker run -v /swapfile:/swapfile -e SWAP_SIZE_IN_GB=4 -e SWAPPINESS=10 eher/docker-swap
