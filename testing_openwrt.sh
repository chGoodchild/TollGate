#!/bin/bash

# Step 1: Ensure the container is connected to the bridge network
docker network connect test-bridge openwrt || true

# Step 2: Restart the container
docker restart openwrt

# Step 3: Configure network interface inside the container
docker exec -it openwrt sh -c "ifconfig eth0 up"
docker exec -it openwrt sh -c "udhcpc -i eth0"
docker exec -it openwrt sh -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

# Step 4: Verify network configuration
docker exec -it openwrt sh -c "ifconfig"
docker exec -it openwrt sh -c "route -n"
docker exec -it openwrt sh -c "cat /etc/resolv.conf"

# Step 5: Test connectivity
docker exec -it openwrt sh -c "ping -c 4 www.google.com"
docker exec -it openwrt sh -c "ping -c 4 10.0.0.1"

echo "Configuration and testing completed."
