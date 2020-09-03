#erase and setup basic rules
	source machineB-F_start_rules_NOT_E.sh
#PART A:Allow inbound http and https requests from any source IP
	iptables -N http-https-chain
	#http
		iptables -A http-https-chain -p tcp -s 0/0  -m conntrack --ctstate NEW --dport 80 -j ACCEPT
	#https
		iptables -A http-https-chain -p tcp -s 0/0  -m conntrack --ctstate NEW --dport 443 -j ACCEPT
	iptables -A INPUT -p tcp --match multiport --dports 80,443 -j http-https-chain
#log fails
	source log_fails.sh
#show me the goods
	iptables -L -v
