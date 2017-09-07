#!/bin/sh

# Disable IPv6
sysctl -p /etc/sysctl-ipv6.conf

# Attempt to assign a static IP address
IPADDRESS=`hvkvp -key IpAddress`
RESULT=$?

if [ $RESULT -eq 0 ] && [ ! -z "$IPADDRESS" ]; then
  echo "Set static IP: $IPADDRESS"
  ip a add $IPADDRESS/24 dev eth0
  ip route add default via ${IPADDRESS%.*}.1 dev eth0
  echo "nameserver 8.8.8.8" > /etc/resolv.conf
fi

