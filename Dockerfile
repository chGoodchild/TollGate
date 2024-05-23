FROM ubuntu:latest

# Install necessary tools
RUN apt-get update && apt-get install -y \
    opkg \
    wget

# Download and add the OpenWRT root filesystem
RUN wget https://downloads.openwrt.org/releases/22.03.4/targets/armvirt/64/openwrt-22.03.4-armvirt-64-default-rootfs.tar.gz -O rootfs.tar.gz
ADD rootfs.tar.gz /

# Create necessary directories
RUN mkdir -p /var/lock

# Remove unnecessary packages
RUN opkg remove --force-depends dnsmasq* wpad* iw* && \
    opkg update && \
    opkg install luci wpad-wolfssl iw-full ip-full kmod-mac80211 dnsmasq-full iptables-mod-checksum

# Upgrade all packages
RUN opkg list-upgradable | awk '{print $1}' | xargs opkg upgrade || true

# Add custom iptables rule
RUN echo "iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill" >> /etc/firewall.user

# Modify /etc/rc.local
RUN sed -i '/^exit 0/i cat \/tmp\/resolv.conf > \/etc\/resolv.conf' /etc/rc.local

# Set metadata
ARG ts
ARG version
LABEL org.opencontainers.image.created=$ts
LABEL org.opencontainers.image.version=$version
LABEL org.opencontainers.image.source=https://github.com/oofnikj/docker-openwrt

# Command to run the container
CMD [ "/sbin/init" ]
