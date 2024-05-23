#!/bin/bash

# Step 1: Enable IP forwarding on the host
echo "Enabling IP forwarding on the host..."
sudo sysctl -w net.ipv4.ip_forward=1

# Step 2: Set up NAT with iptables on the host
echo "Setting up NAT with iptables on the host..."
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

# Step 3: Add Google DNS server to the container's resolv.conf
echo "Adding Google DNS server to the container's resolv.conf..."
docker exec -it openwrt sh -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"

# Step 4: Bring up the network interface and request IP via DHCP in the container
echo "Configuring network interface in the container..."
docker exec -it openwrt sh -c "ifconfig eth0 up"
docker exec -it openwrt sh -c "udhcpc -i eth0"

# Test connectivity
echo "Testing connectivity..."
docker exec -it openwrt sh -c "ping -c 4 www.google.com"

echo "Configuration completed."
