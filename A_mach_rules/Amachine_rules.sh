#clear and set default rules for machine A
	source machineA_start_rules.sh
#-----------------------------------------------------------------------------------------------------
#PART A: Allow the appropriate DHCP traffic to/from 100.64.9.0/24
	iptables -A INPUT -p udp -s 100.64.9.0/24 --dport 67:68 -j ACCEPT
	iptables -A INPUT -p udp -s 10.21.32.0/24 --dport 67:68 -j ACCEPT
	#below rule is necessary when machines don't have IP address right?
		iptables -A INPUT -p udp -s 0/0 --dport 67:68 -j ACCEPT
#-----------------------------------------------------------------------------------------------------
#PART B: Deny your users access to Facebook from any machine on your network
	iptables -N blocked-chain
	iptables -A blocked-chain -d 157.240.28.35 -j DROP
#-----------------------------------------------------------------------------------------------------
#PART C: Deny your users access to icanhas.cheezburger.com and cheezburger.com
	iptables -A blocked-chain -d 216.176.186.210 -j DROP
	iptables -I OUTPUT 2 -j blocked-chain
	iptables -A FORWARD -j blocked-chain
#-----------------------------------------------------------------------------------------------------
#PART D: Only forward packets to/from machines behind the router, based on the intended purpose of that specific machine
#this is where it will be best to make tables for each machine
	iptables -P FORWARD DROP
	iptables -I FORWARD 1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -A FORWARD -p icmp -j icmp-chain
	iptables -A FORWARD -p tcp --dport 22 -d 10.21.32.2 -j DROP
	iptables -A FORWARD -p tcp --dport 22 -j ssh-chain
	#traceroute rule
	iptables -A FORWARD -p udp -s 100.64.9.0/24 -j ACCEPT
	iptables -A FORWARD -p udp -s 10.21.32.0/24 -j ACCEPT
	#MACHINE B/F FORWARD RULES
	iptables -A FORWARD -p tcp -d 100.64.9.2 --match multiport --dport 80,443 -j ACCEPT
	iptables -A FORWARD -p tcp -d 100.64.9.5 --match multiport --dport 80,443 -j ACCEPT
	#MACHINE C FORWARD RULES
	iptables -A FORWARD -p tcp -s 100.64.0.0/16 --match multiport --dport 20:21 -j ACCEPT
	iptables -A FORWARD -p tcp -s 100.64.9.3 --match multiport --dport 20,21,22,80,443 -j ACCEPT
	iptables -A FORWARD -p icmp -s 100.64.9.3 -j icmp-chain
	#MACHINE D FORWARD RULES
	iptables -A FORWARD -p udp -s 100.64.9.4 --dport 53 -j ACCEPT
	iptables -A FORWARD -p udp -s 0/0 -d 100.64.9.4 --dport 53 -j ACCEPT
	#MACHINES B,D,E,F allowed to send whatever they want
	iptables -A FORWARD -s 100.64.9.2 -j ACCEPT
	iptables -A FORWARD -s 100.64.9.4 -j ACCEPT
	iptables -A FORWARD -s 10.21.32.2 -j ACCEPT
	iptables -A FORWARD -s 100.64.9.5 -j ACCEPT
#log failures
	source log_fails.sh
#------------------------------------------------------------------------------------------------------
