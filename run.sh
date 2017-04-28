#!/bin/sh
if [ "${SWAP_SIZE_IN_GB}" != "**None**"  ]; then
    echo "=> Found swap size"

    echo "=> Creating ssh access"
    mkdir -p /user/.ssh
    chmod 700 /user/.ssh
    if [ ! -f /user/.ssh/id_rsa ]; then
        echo -e "\n\n\n" | ssh-keygen -Ndocker -f /user/.ssh/id_rsa
    fi
    echo "=> Updating Authorized Keys"
    touch /user/.ssh/authorized_keys
    chmod 600 /user/.ssh/authorized_keys
    cat /user/.ssh/id_rsa.pub >> /user/.ssh/authorized_keys
 
    DOCKER_HOST=$(/sbin/ip route|awk '/default/ { print $3  }')
    echo "=> Creating swap on ${DOCKER_HOST}"

    echo -e "\n\n\n" | ssh root@$DOCKER_HOST -i /user/.ssh/id_rsa fallocate -l ${SWAP_SIZE_IN_GB}G /swapfile
    echo -e "\n\n\n" | ssh root@$DOCKER_HOST -i /user/.ssh/id_rsa chmod 600 /swapfile
    echo -e "\n\n\n" | ssh root@$DOCKER_HOST -i /user/.ssh/id_rsa mkswap /swapfile
    echo -e "\n\n\n" | ssh root@$DOCKER_HOST -i /user/.ssh/id_rsa swapon /swapfile

    echo "=> Setting swappiness on ${DOCKER_HOST}"
    echo -e "\n\n\n" | ssh root@$DOCKER_HOST -i /user/.ssh/id_rsa ysctl vm.swappiness=${SWAPPINESS}
else
    echo "ERROR: No swap size found in \$SWAP_SIZE_IN_GB"
    exit 1
fi
