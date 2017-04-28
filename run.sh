#!/bin/sh
if [ "${SWAP_SIZE_IN_GB}" != "**None**"  ]; then
    echo "=> Found swap size"

    echo "=> Creating ssh access"
    mkdir -p /user/.ssh
    chmod 700 /user/.ssh
    if [ ! -f /user/.ssh/id_docker ]; then
        echo -e "\n\n\n" | ssh-keygen -f /user/.ssh/id_docker
        echo "=> Updating Authorized Keys"
        touch /user/.ssh/authorized_keys
        chmod 600 /user/.ssh/authorized_keys
        cat /user/.ssh/id_docker.pub >> /user/.ssh/authorized_keys
    fi
    
    DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3  }')
    echo "=> Creating swap on ${DOCKER_HOST}"

    ssh root@$DOCKER_HOST -o "StrictHostKeyChecking=no" -i /user/.ssh/id_docker fallocate -l ${SWAP_SIZE_IN_GB}G /swapfile
    ssh root@$DOCKER_HOST -o "StrictHostKeyChecking=no" -i /user/.ssh/id_docker chmod 600 /swapfile
    ssh root@$DOCKER_HOST -o "StrictHostKeyChecking=no" -i /user/.ssh/id_docker mkswap /swapfile
    ssh root@$DOCKER_HOST -o "StrictHostKeyChecking=no" -i /user/.ssh/id_docker swapon /swapfile

    echo "=> Setting swappiness on ${DOCKER_HOST}"
    ssh root@$DOCKER_HOST -o "StrictHostKeyChecking=no" -i /user/.ssh/id_docker ysctl vm.swappiness=${SWAPPINESS}
else
    echo "ERROR: No swap size found in \$SWAP_SIZE_IN_GB"
    exit 1
fi
