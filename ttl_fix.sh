#!/bin/sh

for m in m{1..3}; do
	ip netns exec $m iptables -t mangle -A POSTROUTING -j TTL --ttl-set 255
done
