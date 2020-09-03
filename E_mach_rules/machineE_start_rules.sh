#resetting everything
	source essential_rules.sh

#*****************************************************************************************************
#MACHINE A REQRUIRMENT PART B: Deny your users access to Facebook from any machine on your network
        iptables -N blocked-chain
        iptables -A blocked-chain -d 157.240.28.35 -j DROP
#-----------------------------------------------------------------------------------------------------
#MACHINE A REQRUIRMENT PART C: Deny your users access to icanhas.cheezburger.com and cheezburger.com
        iptables -A blocked-chain -d 216.176.186.210 -j DROP
        iptables -A OUTPUT -j blocked-chain
#*****************************************************************************************************

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
#PART C: ssh rules. MACHINE E HAS DIFFERENT SSH RULES. Defined in Emachine_rules.sh
#----------------------------------------------------------------------------------------------------
#PART D: All machines should implement a default deny policy for inbound traffic.
	iptables -P INPUT DROP
#----------------------------------------------------------------------------------------------------
#PART E: remove forwarding from machines B-F
	#setting a persistent off setting for ipv4 and ipv6 forwarding
		if grep -q "net.ipv4.ip_forward = 0" "/etc/sysctl.conf";
		then
			echo "ipv4 forwarding is set to be off, check to reboot"
		else
			echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
			echo "ipv4 forwarding is set to be off, reboot when possible"
		fi
		if grep -q "net.ipv6.ip_forward = 0" "/etc/sysctl.conf";
		then
			echo "ipv6 forwarding is set to be off, check to reboot"
		else
			echo "net.ipv6.ip_forward = 0" >> /etc/sysctl.conf
			echo "ipv6 forwarding is set to be off, reboot when possible"
		fi	
	#dropping all forward packets
		iptables -P FORWARD DROP
#----------------------------------------------------------------------------------------------------
