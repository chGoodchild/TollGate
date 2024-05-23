#!/bin/bash

# Step 1: Ensure the container is connected only to the test-bridge network
docker network disconnect bridge openwrt || true
docker network disconnect macnet openwrt || true
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
docker exec -it openwrt sh -c "ping -c 4 192.168.8.1"  # Adjust to your actual gateway IP if different

echo "Configuration and testing completed."
