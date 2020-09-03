#log failed input/output packets 
        iptables -A INPUT -j LOG --log-prefix "INPUT FAIL: " 
        iptables -A OUTPUT -j LOG --log-prefix "OUTPUT FAIL: "
