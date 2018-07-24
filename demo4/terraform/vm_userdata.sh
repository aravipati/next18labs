#!/bin/bash -xe

# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

apt-get update
apt-get install -y tcpdump

echo 1 > /proc/sys/net/ipv4/ip_forward
export E0_IP=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
export E2_IP=$(ip -o -4 addr list eth2 | awk '{print $4}' | cut -d/ -f1)
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A PREROUTING -i eth0 -p tcp -d $E0_IP --dport 80 -j DNAT --to 10.0.2.7:9000
iptables -t nat -A POSTROUTING -o eth2 -p tcp -d 10.0.2.7 --dport 9000 -j SNAT --to $E2_IP
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp -d $E0_IP --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -s 169.254.169.254 -j ACCEPT
iptables -A FORWARD -i eth+ -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -p tcp -m multiport --dports 80,443,9000 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -p tcp -m multiport --dports 80,443,9000 -d 10.0.2.7 -j ACCEPT
iptables -A FORWARD -i eth+ -p icmp -j ACCEPT
