#!/bin/sh
if [ "${SWAP_SIZE_IN_GB}" != "**None**"  ]; then
    echo "=> Found swap size"
    fallocate -l ${SWAP_SIZE_IN_GB}G /var/swap/${SWAP_SIZE_IN_GB}G
    chmod 600 /var/swap/${SWAP_SIZE_IN_GB}G
    mkswap /var/swap/${SWAP_SIZE_IN_GB}G
    swapon /var/swap/${SWAP_SIZE_IN_GB}G
    sysctl vm.swappiness=${SWAPPINESS}
else
    echo "ERROR: No swap size found in \$SWAP_SIZE_IN_GB"
    exit 1
fi
