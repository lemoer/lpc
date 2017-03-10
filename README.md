# lpc - large packet collider

## general stuff

- we use network namespaces (```m1```, ```m2```, ```m3```)

## commands

**install lpc:**

``` shell
./lpc.sh
```

**start tcpdump:**

``` shell
ip netns exec m2 tcpdump -n -i veth1 icmp
```

**start a single ping:**

``` shell
ip netns exec m2 ping -c 1 8.8.8.8
```

**cleanup:**

``` shell
./lpc.sh cleanup
```

## step 1 - without ttlfix

```
root@orange /h/lemoer# ip netns exec m2 tcpdump -n -i veth1 icmp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on veth1, link-type EN10MB (Ethernet), capture size 262144 bytes
18:24:29.462053 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 15984, seq 109, length 64
18:24:29.462071 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 0, seq 109, length 64
18:24:29.462078 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 1, seq 109, length 64
18:24:29.462085 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 2, seq 109, length 64
18:24:29.462091 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 3, seq 109, length 64
18:24:29.462097 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 4, seq 109, length 64
18:24:29.462104 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 5, seq 109, length 64
18:24:29.462112 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 6, seq 109, length 64
18:24:29.462120 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 7, seq 109, length 64
18:24:29.462127 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 8, seq 109, length 64
18:24:29.462134 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 9, seq 109, length 64
18:24:29.462141 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 10, seq 109, length 64
18:24:29.462159 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 12, seq 109, length 64
18:24:29.462166 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 13, seq 109, length 64
18:24:29.462173 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 14, seq 109, length 64
18:24:29.462181 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 15, seq 109, length 64
18:24:29.462188 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 16, seq 109, length 64
18:24:29.462195 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 17, seq 109, length 64
18:24:29.462202 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 18, seq 109, length 64
18:24:29.462209 IP 10.101.102.1 > 8.8.8.8: ICMP echo request, id 19, seq 109, length 64
18:24:29.462237 IP 10.102.103.3 > 10.101.102.1: ICMP time exceeded in-transit, length 92
```
