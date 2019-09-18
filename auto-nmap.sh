#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#echo "${red}red text ${green}green text${reset}"
sudo apt-get install ccze -y
read -p "${red}Enter the Project Name : " name
read -p "${red}Enter IP Address/ IP Range : " iprange ${reset}
mkdir $name-nmap-reports && cd $name-nmap-reports
wget https://raw.githubusercontent.com/honze-net/nmap-bootstrap-xsl/master/nmap-bootstrap.xsl
git clone https://github.com/ralphbean/ansi2html.git && cd ansi2html && chmod +x setup.py && ./setup.py install && cd ..
read -p "Start Scanning ? y/n " ss
if [[ $ss = "y" ]]; then 
	echo "${green}Scanning Started"
	nmap  -oA $name --stylesheet nmap-bootstrap.xsl $iprange | ccze -A | ansi2html > $name.html
	echo "${green}Main Scan Done"
	echo "${green}Logging Live Hosts"
	nmap -oG  $name-grepable.txt $iprange
	cat $name-grepable.txt | grep Up | cut -d ' ' -f 2 | sort -u > $name-livehost.txt
	echo "${green}Logging Live Host Done"
	echo "${green}Scanning for vulnerabilities in live host"
	#nmap -oA $name-vuln -iL $name-livehost.txt --script vuln --stylesheet nmap-bootstrap.xsl | ccze -A | ansi2html > $name-vuln.html
	#echo "Vulnerability Scanning Done"

fi
	exit 0
