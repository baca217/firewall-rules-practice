#reset and setup basic rules
	source machineB-F_start_rules_NOT_E.sh
#------------------------------------------------------------------------------------------------------
#PART A: Unlike the other machines, the default outbound policy for Machine C should be deny.
	iptables -P OUTPUT DROP
#------------------------------------------------------------------------------------------------------
#PART B: Allow ftp connections only from 100.64.0.0/16. THIS IS HARD WAIT FOR IT
#-----------------------------------------------------------------------------------------------------
#PART C: Allow dns requests to 100.64.N.4 (chase)
	iptables -A OUTPUT -p udp --dport 53 -d 100.64.9.4 -j ACCEPT
#-----------------------------------------------------------------------------------------------------
#PART D: Allow outbound ftp, http, https, and ssh connections to any host.
	#seperate chain for ftp
	iptables -N ftp-chain
	iptables -A ftp-chain -p tcp --dport 20 -m conntrack --ctstate NEW -j ACCEPT
	iptables -A ftp-chain -p tcp --dport 21 -m conntrack --ctstate NEW -j ACCEPT
	iptables -A ftp-chain -p tcp --sport 20 -m conntrack --ctstate NEW -j ACCEPT
	iptables -A ftp-chain -p tcp --sport 21 -m conntrack --ctstate NEW -j ACCEPT
	#allowing related packets in and out
	iptables -I INPUT 2 -m conntrack --ctstate RELATED -j ACCEPT
	iptables -I OUTPUT 2 -m conntrack --ctstate RELATED -j ACCEPT
	#receiving ftp request from client
	iptables -A INPUT -p tcp -s 100.64.0.0/16 --dport 20:21 -j ftp-chain
	#iptables -A INPUT -p tcp -s 100.64.0.0/16 --sport 20:21 -j ftp-chain
	#iptables -A OUTPUT -p tcp -o ens192 --sport 20:21 -j ftp-chain
	iptables -A OUTPUT -p tcp -o ens192 --dport 20:21 -j ftp-chain


	#seperate chain for http-https-ssh-chain
	iptables -N http-https-ssh-chain	
	#ftp WAIT FOR THIS
	#http
	iptables -A http-https-ssh-chain -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
	#https
	iptables -A http-https-ssh-chain -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
	#ssh
	iptables -A http-https-ssh-chain -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
	iptables -A OUTPUT -p tcp --match multiport --dport 80,443,22 -j http-https-ssh-chain
#-----------------------------------------------------------------------------------------------------
#PART E:Allow outbound icmp traffic only for icmp-types echo-request, echo-reply (ping), time-exceeded 
#(traceroute), or destination-unreachable.
	#Echo-request
        #        iptables -A OUTPUT -p icmp --icmp-type echo-request -m conntrack --ctstate NEW -j ACCEPT
        #Echo-reply
        #        iptables -A OUTPUT -p icmp --icmp-type echo-reply -m conntrack --ctstate NEW -j ACCEPT
        #time-exceeded NOT SURE ON HOW TO TEST THIS, SEND TTL OF 1 MAYBE?
        #        iptables -A OUTPUT -p icmp --icmp-type time-exceeded -m conntrack --ctstate NEW,RELATED -j ACCEPT
        #destination-unreachable TEST ON DNS MACHINE, SHOULD BE UNREACHABLE WEBSITE
        #        iptables -A OUTPUT -p icmp --icmp-type destination-unreachable -m conntrack --ctstate NEW,RELATED -j ACCEPT
	
	iptables -A OUTPUT -p icmp -j icmp-chain
	iptables -A OUTPUT -p udp -j ACCEPT
#-----------------------------------------------------------------------------------------------------
#log stuff
	source log_fails.sh
