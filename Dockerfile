# Base image is Alpine Linux
# docker build -t gkweb76/dhcp:4.3.5 -t gkweb76/dhcp:latest -t gkweb76/dhcp:4.3.5-r0 .
FROM alpine:3.7
LABEL maintainer="Guillaume Kaddouch"
LABEL twitter="@gkweb76"

# Install dhcp
RUN apk add --update --no-cache dhcp=4.3.5-r0 && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Healtcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 CMD [ `pgrep dhcpd` -eq 1 ] && echo PID_dhcp_OK || exit 1

# Port available
EXPOSE 67/udp

# Start DHCP daemon based on /etc/dhcp/dhcpd.conf
VOLUME ["/etc/dhcp", "/var/lib/dhcp"]

# DHCP leases are kept in this file, let's create it
RUN touch /var/lib/dhcp/dhcpd.leases

# Environnement variables
ENV DHCP_VERSION dhcp:4.3.5-r0

# Start dhcpd daemon : -cf = conf file, -d = log to stderr and do not daemonize
CMD ["/usr/sbin/dhcpd", "-4", "-d", "-cf", "/etc/dhcp/dhcpd.conf", "eth0"]
