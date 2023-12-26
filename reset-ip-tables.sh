#!/bin/bash
#Reset
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X



#reset
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -F
ip6tables -X

#save

if [ -f /etc/iptables/rules.v4 ]; then
	iptables-save > /etc/iptables/rules.v4
fi

if [ -f /etc/iptables/rules.v6 ]; then
	ip6tables-save > /etc/iptables/rules.v6
fi

if [ -f /etc/sysconfig/iptables ]; then
	iptables-save > /etc/sysconfig/iptables
fi

if [ -f /etc/sysconfig/ip6tables ]; then
	ip6tables-save > /etc/sysconfig/ip6tables
fi
