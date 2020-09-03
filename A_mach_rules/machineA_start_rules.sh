#resetting everything
	source essential_rules.sh
#------------------------------------------------------------------------------------------------------
#PART A: Allow all traffic on loopback interface
	iptables -N loopback-chain
	iptables -A loopback-chain -i lo -j ACCEPT
	iptables -A loopback-chain -o lo -j ACCEPT
#adding chain to main chains
	iptables -A INPUT -i lo -j loopback-chain
	iptables -A OUTPUT -o lo -j loopback-chain
#------------------------------------------------------------------------------------------------------
#PART B: ICMP traffic
	iptables -N icmp-chain
	#Echo-request
		iptables -A icmp-chain -p icmp --icmp-type echo-request -j ACCEPT
	#Echo-reply
		iptables -A icmp-chain -p icmp --icmp-type echo-reply -j ACCEPT
	#time-exceeded
		iptables -A icmp-chain -p icmp --icmp-type time-exceeded -m conntrack --ctstate NEW,RELATED -j ACCEPT
	#destination-unreachable
		iptables -A icmp-chain -p icmp --icmp-type destination-unreachable -m conntrack --ctstate NEW,RELATED -j ACCEPT
#adding chain to main chains
	iptables -A INPUT -p icmp -j icmp-chain	
#-----------------------------------------------------------------------------------------------------
#PART C: ssh rules
	iptables -N ssh-chain
	#100.64.0.0/16 subnet
		iptables -A ssh-chain -p tcp -s 100.64.0.0/16 --dport 22 -m conntrack --ctstate NEW -j ACCEPT
	#10.21.32.0/24 subnet
		iptables -A ssh-chain -p tcp -s 10.21.32.0/24 --dport 22 -m conntrack --ctstate NEW -j ACCEPT
	#198.18.0.0/16 subnet
		iptables -A ssh-chain -p tcp -s 198.18.0.0/16 --dport 22 -m conntrack --ctstate NEW -j ACCEPT
#adding to main chains
	iptables -A INPUT -p tcp --dport 22 -j ssh-chain
#----------------------------------------------------------------------------------------------------
#PART D: All machines should implement a default deny policy for inbound traffic.
	iptables -P INPUT DROP
#----------------------------------------------------------------------------------------------------
#PART E: remove forwarding from machines B-F. MACHINE A CAN FORWARD PACKETS. SET IN essential_rules.sh
#----------------------------------------------------------------------------------------------------
