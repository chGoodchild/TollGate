FROM ghcr.io/hurt/openwrt-rpi:21.02.1
# FROM openwrt/rootfs:21.02.1

# Create necessary directories
RUN mkdir -p /var/lock /etc

# Ensure /etc/firewall.user exists and add custom iptables rule
RUN touch /etc/firewall.user && \
    echo "iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM --checksum-fill" >> /etc/firewall.user

# Modify /etc/rc.local
RUN touch /etc/rc.local && \
    sed -i '/^exit 0/i cat \/tmp\/resolv.conf > \/etc\/resolv.conf' /etc/rc.local

# Set metadata
ARG ts
ARG version
LABEL org.opencontainers.image.created=$ts
LABEL org.opencontainers.image.version=$version
LABEL org.opencontainers.image.source=https://github.com/oofnikj/docker-openwrt

# Command to run the container
CMD [ "/sbin/init" ]

