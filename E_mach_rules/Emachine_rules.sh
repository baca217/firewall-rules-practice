#reset rules
	source machineE_start_rules.sh
#-------------------------------------------------------------------------------------------
#PART A: Restrict connections to the file sharing services (CIFS and SMB) from the 10.21.32.0/24 
#network only.  CIFS and SMB use port numbers:
	iptables -N cifs-smb-chain
	#135/tcp
	iptables -A cifs-smb-chain -p tcp --dport 135 -s 10.21.32.0/24 -m conntrack --ctstate NEW,RELATED -j ACCEPT
	#137-139/udp
	iptables -A cifs-smb-chain -p udp --match multiport --dport 137:139 -s 10.21.32.0/24 -m conntrack --ctstate NEW,RELATED -j ACCEPT
	#445/tcp
	iptables -A cifs-smb-chain -p tcp --dport 445 -s 10.21.32.0/24 -m conntrack --ctstate NEW,RELATED -j ACCEPT
	iptables -A INPUT -p tcp --match multiport --dports 135,445 -j cifs-smb-chain
	iptables -A INPUT -p udp --dport 137:139 -j cifs-smb-chain
#-------------------------------------------------------------------------------------------
#PART B: Allow SSH connections only from hosts in the 10.21.32.0/24 subnet.
	iptables -A INPUT -p tcp --dport 22 -s 10.21.32.0/24 -m conntrack --ctstate NEW -j ACCEPT
#-------------------------------------------------------------------------------------------
#log fails
	source log_fails.sh
