#clearing all rules and setting default policy to deny for INPUT, FORWARD, and OUTPUT
	iptables -F 
	iptables -X
	iptables -P INPUT DROP
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
#allow estbalished connections in and out without checking
	iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#------------------------------------------------------------------------------------
#FOR VM USE ONLY
#allow ssh connections from anywhere to us
#	iptables -A INPUT -p tcp -s 0/0 --dport 22 -j ACCEPT
#allow us to make ssh connection to anywhere
#	iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
