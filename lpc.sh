#!/bin/sh

if [ "$1" = "cleanup" ]; then
	# counterparts should be deleted also
	ip netns exec m1 ip link del veth0
	ip netns exec m2 ip link del veth2
	ip netns exec m3 ip link del veth4

	echo m1 m2 m3 | xargs -n 1 ip netns del
fi

echo m1 m2 m3 | xargs -n 1 ip netns add

ip link add type veth
ip link add type veth
ip link add type veth

# TODO: this is stupid, if we already had veth devices before
ip link set netns m1 veth0
ip link set netns m2 veth1
ip link set netns m2 veth2
ip link set netns m3 veth3
ip link set netns m3 veth4
ip link set netns m1 veth5

# install forwarding
for i in veth{0..5}; do
	sysctl net.ipv4.conf.$i.forwarding=1
done

# Link IP Adresses:
#
# (m1,veth0) 10.101.102.1/24 <--> 10.101.102.2/24 (m2,veth1)
# (m2,veth2) 10.102.103.2/24 <--> 10.102.103.3/24 (m3,veth3)
# (m3,veth4) 10.103.101.3/24 <--> 10.101.102.1/24 (m1,veth5)

ip netns exec m1 sh <<EOF
ip a a 10.101.102.1/24 dev veth0
ip a a 10.103.101.1/24 dev veth5
ip link set veth0 up
ip link set veth5 up
ip link set lo up

# add nat
for iface in \$(ls /sys/class/net/ | grep -v lo); do
	iptables -t nat -A POSTROUTING -o \$iface -j MASQUERADE
done

# add default route
ip route add default via 10.101.102.2 dev veth0
EOF

ip netns exec m2 sh <<EOF
ip a a 10.101.102.2/24 dev veth1
ip a a 10.102.103.2/24 dev veth2
ip link set veth1 up
ip link set veth2 up
ip link set lo up

# add nat
for iface in \$(ls /sys/class/net/ | grep -v lo); do
	iptables -t nat -A POSTROUTING -o \$iface -j MASQUERADE
done

# add default route
ip route add default via 10.102.103.3 dev veth2
EOF

ip netns exec m3 sh <<EOF
ip a a 10.102.103.3/24 dev veth3
ip a a 10.103.101.3/24 dev veth4
ip link set veth3 up
ip link set veth4 up
ip link set lo up

# add nat
for iface in \$(ls /sys/class/net/ | grep -v lo); do
	iptables -t nat -A POSTROUTING -o \$iface -j MASQUERADE
done

# add default route
ip route add default via 10.103.101.1 dev veth4
EOF
