#!/bin/bash

#(c) iliban 19.01.2023

ip_address=$1

rm -rf nmap
mkdir nmap
cd nmap

#do a fast scan first
sudo nmap -F -Pn $ip_address > fast
echo "[+] Fast scan finished. To see \"cat nmap/fast\""
#scan all ports and save the result to a file
echo "[-] Scanning first 10000 ports..."
sudo nmap -p0-10000 -Pn -T5 $ip_address > long
echo "[+] Scanning first 10000 ports done."

echo "[-] Scanning ports 10000-20000..."
sudo nmap -p10001-20000 -T5 -Pn $ip_address >> long
echo "[+] Scanning ports 10000-20000 done."

echo "[-] Scanning ports 20000-30000..."
sudo nmap -p20001-30000 -T5 -Pn $ip_address >> long
echo "[+] Scanning ports 20000-30000 done."

echo "[-] Scanning ports 30000-40000..."
sudo nmap -p30001-40000 -T5 -Pn $ip_address >> long
echo "[+] Scanning ports 30000-40000 done."

echo "[-] Scanning ports 40000-50000..."
sudo nmap -p40001-50000 -T5 -Pn $ip_address >> long
echo "[+] Scanning ports 40000-50000 done."

echo "[-] Scanning remaining ports..."
sudo nmap -p50001- -T5 -Pn $ip_address >> long
echo "[+] Scanning remaining ports done."

echo "[-] Scanning open ports thoroughly..."
#modify the output so that it could be sent to nmap again
cat long | grep "open" | grep -v "filtered" | cut -d "/" -f 1 | xargs | sort -u | tr " " "," |

#take the output of the long scan and run a thorough scan on open ports only
while read line
do
	sudo nmap -sC -sV -T4 -A -Pn $ip_address -p $line > full
done
echo "[+] All ports scanned. To see \"cat nmap/full\""
