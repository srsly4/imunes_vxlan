#!/bin/bash

set -e

if [ "$(id -un)" != "root" ]; then
    echo "Need root - sudoing..."
    exec sudo "$0" "$@"
fi

echo "Select your site identifier: "
read SITE_ID
if [[ -n ${SITE_ID//[0-9]/} ]]; then
    echo "Invalid site identifier"
    exit
fi

currd=$(pwd)

echo "Select a network interface:"
cd /sys/class/net && select SEL_IF in *; do
break
done;

echo "selected $SEL_IF"
mac_sufix=$(printf "%02d" $SITE_ID)
vx_if_name="vxl$SITE_ID"

cd $currd

envsubst > "vxlan_site_$SITE_ID.imn" <<EOL
node n0 {
    type router
    model quagga
    network-config {
	hostname router1
	!
	interface eth0
	 ip address 5.5.5.$SITE_ID/24
	 mac address 42:00:aa:00:ac:$mac_sufix
	!
	interface lo0
	 type lo
	 ip address 127.0.0.1/8
	 ipv6 address ::1/128
	!
	router rip
	 redistribute static
	 redistribute connected
	 redistribute ospf
	 network 0.0.0.0/0
	!
	router ripng
	 redistribute static
	 redistribute connected
	 redistribute ospf6
	 network ::/0
	!
    }
    canvas c0
    iconcoords {240 120}
    labelcoords {240 145}
    interface-peer {eth0 n1}
}

node n1 {
    type rj45
    network-config {
	hostname $vx_if_name
	!
    }
    canvas c0
    iconcoords {432 120}
    labelcoords {432 149}
    interface-peer {0 n0}
    customIcon img_0
}

link l0 {
    nodes {n0 n1}
}

canvas c0 {
    name {Canvas0}
}

option show {
    interface_names yes
    ip_addresses yes
    ipv6_addresses yes
    node_labels yes
    link_labels yes
    background_images no
    annotations yes
    hostsAutoAssign no
    grid yes
    iconSize normal
    zoom 1.0
}

image img_0 {
    referencedBy {n1}
    type {customIcon}
    file {/usr/lib/imunes/icons/normal/cloud.gif}
    data {R0lGODlhLgAcAPekAJSkrZGkq4ecpoufqZOjrI6hqoqepoSZo4WapIeapoicpoiepouep/j5+Yeb
          pf7+/v39/ZSlrpSmrYmfp4GYoqGyuvL09ZWlrvn6+/n6+pGiq5WqtK68w9vh5JGlrYyfqKa2v4yg
          qvb4+MTP1ZyuucPO06e3vbK/xbC9xL7Gy42hq3yUn9ng49vg4rvIzfDx8fb3+MTP05astdDW2dXb
          3P///+rt7/z8/YWdpYaZpff4+JKkq+3v8dje4aKzutXb34ueqefq7Pj5+sHL0ISZpebo6pOlrLbD
          yfv7/KKyusPM0MLN0sLO1PP09dHY2uLm6d7k5+Dk5qq5wJmstdfd4au3v8vS1ZOnru7w8Zirt9zi
          5Ka2vJOmr4GZpNfd4JapsLTBx5CjrOTo6qy7wff4+ZOiraW1urfEyIueqJSpsr7JzvDz9I2gqZ+v
          uM/Y3Km4vbbCyO7w8LLBxo2iq6Szu5Smr5Gjqt/j5cHN0ZeosIKXodLb39/k55WkrJ6xuZyuuIOa
          pMbO04+irNrg4vHy842irJyttdTZ3dfc3sfP1IOYopGlqoidp/r7+5qstZSnr8vS1peosZGiray6
          wt3j5Yifp56vt9Ta3bfCyJ+zucDN09zg5Ojr7Ku3voiep8bO0rnFzI2gq5OkrZKjrP///wAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
          AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAEAAKQALAAAAAAuABwA
          AAj/AEkJHEiwYEEkUGKcAeEHBBw8WjAYnEix4kALQ+ooUmCgQJgCDAQgKOQCi8WTFVkUEBAgAgBR
          okbBBACAgIEElx6gnIhhjxwfU0hwoDLDQQAAo5IqXToKQAAgHJhocvOk0c4fkhwMCBBzgIAVMZmK
          XSoghAoGB+aoaVDxgRKjEcLKBBBhrN2kMGcaUZDnBUVEB+TeHTwYABtDNwxCeGSHsGPCfQ7cMRgn
          geDHmJVeQLDJoBcKlzNjLnAFAkE+ligsCC2asKgCaHoMpHGgAM3WuEUFQOAkAw8EMnELVyogEBgD
          SIcLl7AgzZ8dBJQvT1BhDIPk0jMTGGCCUxHQ2UUHyhBERqAVQAHKhMe8gJDAGoeIaIi+frCoBDYI
          bvnAuv5SRk0QFIUe2PknVihJ6ERQCjk0JVZ/uAFwQAsGPQCJAgoEwJVuATAQQHiiGNCJaROtkUgF
          HnhSiQeO0KFAgY6JUhMBBMA0QRtsnZQBDCIIIdAnDizykmsAfLDAAEiihYkOO03UwRcJhHCUjABI
          QJMoF2gwAAJmLCFFFW+UEESTFTXQAQpcdCHABAYYMMECAuAQyRFikEhmkxYMAsokWWywgQyZnDAC
          JTmiFBAAOw==}
}
EOL

ip link add "$vx_if_name" type vxlan \
id 100 \
dstport 4789 \
group 239.1.1.1 \
dev "$SEL_IF" \
ttl 5

ip link set up dev "$vx_if_name"

echo "VXLAN enabled, IMUNES template is ready"