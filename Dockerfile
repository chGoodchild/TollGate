FROM scratch

# Add the OpenWRT root filesystem
ADD rootfs.tar.gz /

# Create necessary directories
# RUN sudo mkdir -p /var/lock

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

