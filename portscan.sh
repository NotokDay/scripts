#!/bin/bash


RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'


if [ $# -ne 1 ]; then
    echo "Usage: $0 <targets.txt>"
    exit 1
fi

if [ -f "$1" ]; then
        TARGETS=../$1
else 
        echo "Usage: $0 <targets.txt>"
        exit 1
fi

if [ -d nmap ]; then
        cd nmap
else
        echo -e "${YELLOW}[*] Creating a directory for nmap...${NC}"
        mkdir nmap && cd nmap
fi


scan_ip()
{
 local ip=$1
 local outfile=$ip 
 
 echo -e "${YELLOW}[*] Scanning all ports for $ip...${NC}"
 nmap -p- --min-rate 2000 -Pn $ip 2>&1 | tee temp
 echo -e "${GREEN}[+] Port scan finished.${NC}"
 
 echo -e "${YELLOW}[*] Scanning open ports for services and versions for $ip...${NC}"
 #modify the output so that it could be sent to nmap again
 cat temp | grep "open" | grep -v "filtered" | cut -d "/" -f 1 | xargs | sort -u | tr " " "," |

 #take the output of the long scan and run a thorough scan on open ports only
 while read line
 do
       nmap -sC -sV -T4 -A -Pn $ip -p $line 2>&1 | tee $outfile
 done
 echo -e "${GREEN}[+] All ports scanned. To see \"cat nmap/$ip\"${NC}"

}

for ip in $(cat $TARGETS);
do
        scan_ip $ip
done
