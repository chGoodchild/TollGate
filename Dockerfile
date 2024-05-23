FROM alpine:latest

# Download the OpenWRT root filesystem
RUN wget https://downloads.openwrt.org/releases/22.03.4/targets/armvirt/64/openwrt-22.03.4-armvirt-64-default-rootfs.tar.gz -O /tmp/rootfs.tar.gz

# Switch to the OpenWRT root filesystem
ADD /tmp/rootfs.tar.gz /

# Create necessary directories
RUN mkdir -p /var/lock

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
