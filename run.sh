#!/bin/sh
if [ "${SWAP_SIZE_IN_GB}" != "**None**"  ]; then
    echo "=> Found swap size"
    fallocate -l ${SWAP_SIZE_IN_GB}G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    sysctl vm.swappiness=${SWAPPINESS}
else
    echo "ERROR: No swap size found in \$SWAP_SIZE_IN_GB"
    exit 1
fi
