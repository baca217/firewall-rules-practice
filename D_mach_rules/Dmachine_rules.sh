#reset and set basic rules
	source machineB-F_start_rules_NOT_E.sh
#---------------------------------------------------------------------------------------------------
#PART A: Allow DNS queries from any source.
	iptables -A INPUT -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
#---------------------------------------------------------------------------------------------------
#log fails
	source log_fails.sh
#---------------------------------------------------------------------------------------------------
