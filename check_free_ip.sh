#!/bin/bash

CIDR="10.0.91.0/24"
TIMEOUT=0.2  # Timeout mỗi lần ping (giây)

ip2long() {
    IFS=. read -r o1 o2 o3 o4 <<< "$1"
    echo $(( (o1 << 24) + (o2 << 16) + (o3 << 8) + o4 ))
}

long2ip() {
    local ip dec=$1
    for e in {1..4}; do
        ip=$((dec & 255)).$ip
        dec=$((dec >> 8))
    done
    echo "${ip%.}"
}

IFS=/ read -r IP MASK <<< "$CIDR"
IP_START=$(ip2long "$IP")
HOSTS=$((2 ** (32 - MASK)))
IP_END=$((IP_START + HOSTS - 1))

echo "Scanning range: $(long2ip $((IP_START+1))) -> $(long2ip $((IP_END-1)))"

for ((i = IP_START + 1; i < IP_END; i++)); do
    current_ip=$(long2ip "$i")
    timeout $TIMEOUT ping -c 1 "$current_ip" &> /dev/null
    if [ $? -ne 0 ]; then
        echo "$current_ip is free"
    fi
done
