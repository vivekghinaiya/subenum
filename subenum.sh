#!/bin/bash

# 🎯 Color Functions
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
RESET="\e[0m"
BOLD="\e[1m"

# 🚫 Exit on no input
if [ -z "$1" ]; then
    echo -e "${RED}[!] Usage: $0 <domain.com>${RESET}"
    exit 1
fi

domain=$1
timestamp=$(date +"%Y%m%d-%H%M%S")
workdir="results_${domain}_${timestamp}"
mkdir -p "$workdir"
cd "$workdir" || exit

echo -e "${CYAN}${BOLD}🔍 Starting subdomain enumeration for: ${domain}${RESET}"
echo -e "${YELLOW}📁 Output directory: ${workdir}${RESET}"

# 🌐 Enumeration Function
subdomain_enum() {
    echo -e "${MAGENTA}[+] Running assetfinder...${RESET}"
    assetfinder --subs-only "$domain" | anew -q assetfinder.txt

    echo -e "${MAGENTA}[+] Running amass (passive)...${RESET}"
    amass enum -d "$domain" -passive -o amass.txt

    echo -e "${MAGENTA}[+] Running subfinder...${RESET}"
    subfinder -silent -d "$domain" -all -o subfinder.txt

    echo -e "${MAGENTA}[+] Running findomain...${RESET}"
    findomain -t "$domain" -u findomain.txt

    echo -e "${MAGENTA}[+] Querying crt.sh...${RESET}"
    curl -s "https://crt.sh/?q=%25.$domain&output=json" |
        jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > crtsh.txt

    echo -e "${MAGENTA}[+] Running github-subdomains...${RESET}"
    github-subdomains -d "$domain" -t /home/github-token -k -o github.txt
}

# 🏁 Run tools
subdomain_enum

# 🧹 Merge and deduplicate
echo -e "${YELLOW}[•] Merging & sorting results...${RESET}"
cat *.txt | sort -u | tee all_subdomains.txt > /dev/null

# 🔎 Probe with httpx
echo -e "${YELLOW}[•] Probing live domains with httpx...${RESET}"
cat all_subdomains.txt | httpx -silent | tee live_subdomains.txt > /dev/null

# 🧾 Results Summary
total=$(wc -l < all_subdomains.txt)
live=$(wc -l < live_subdomains.txt)

echo -e "\n${GREEN}${BOLD}🎉 Subdomain Enumeration Complete!${RESET}"
echo -e "${BLUE}----------------------------------------${RESET}"
echo -e "${CYAN}📌 Total Unique Subdomains: ${BOLD}${total}${RESET}"
echo -e "${CYAN}🔗 Live Subdomains Found:   ${BOLD}${live}${RESET}"
echo -e "${BLUE}----------------------------------------${RESET}"
echo -e "${GREEN}📂 Files saved in: ${workdir}${RESET}"
echo -e "${YELLOW}📄 Files: all_subdomains.txt | live_subdomains.txt${RESET}\n"
