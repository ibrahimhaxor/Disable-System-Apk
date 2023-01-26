#!/bin/bash

host=$1
wordlist="/home/ibrahim/wordlist/all.txt"
resolver="/home/ibrahim/resolvers.txt"

domain_enum(){
for domain in $(cat $host);
do
mkdir -p /home/ibrahim/Arecon/$domain/subdomain /home/ibrahim/Arecon/$domain/Subomain-Takeover /home/ibrahim/Arecon/$domain/scan /home/ibrahim/Arecon/$domain/url /home/ibrahim/Arecon/$domain/gf /home/ibrahim/Arecon/$domain/xss /home/ibrahim/Arecon/$domain/js_url /home/ibrahim/Arecon/$domain/git_dork /home/ibrahim/Arecon/$domain/SQL

subfinder -d $domain -o /home/ibrahim/Arecon/$domain/subdomain/subfinder.txt
assetfinder -subs-only $domain | tee /home/ibrahim/Arecon/$domain/subdomain/assetfinder.txt 
findomain -t $domain | tee /home/ibrahim/Arecon/$domain/subdomain/findomain.txt
amass enum -active -d $domain -o /home/ibrahim/Arecon/$domain/subdomain/amass_sub.txt
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee /home/ibrahim/Arecon/$domain/subdomain/crtsub.txt
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee /home/ibrahim/Arecon/$domain/subdomain/riddlersub.txt
curl -s https://dns.bufferover.run/dns?q=.$domain |jq -r .FDNS_A[]|cut -d',' -f2|sort -u | tee /home/ibrahim/Arecon/$domain/subdomain/bufferoversub.txt
curl -s "https://jldc.me/anubis/subdomains/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee /home/ibrahim/Arecon/$domain/subdomain/jldcsub.txt
sed -ne 's/^\( *\)Subject:/\1/p;/X509v3 Subject Alternative Name/{
N;s/^.*\n//;:a;s/^\( *\)\(.*\), /\1\2\n\1/;ta;p;q; }' < <(
openssl x509 -noout -text -in <(
openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' \
-connect $domain:443 ) ) | grep -Po '((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+' | tee /home/ibrahim/Arecon/$domain/subdomain/altnamesub.txt
cat /home/ibrahim/Arecon/$domain/subdomain/*.txt > /home/ibrahim/Arecon/$domain/subdomain/allsub.txt
cat /home/ibrahim/Arecon/$domain/subdomain/allsub.txt | anew -q /home/ibrahim/Arecon/$domain/subdomain/all_srot_sub.txt
done
}
domain_enum

resolving_domains(){
for domain in $(cat $host);
do
massdns -r $resolver -t A -o S -w /home/ibrahim/Arecon/$domain/subdomain/massdns.txt /home/ibrahim/Arecon/$domain/subdomain/all_srot_sub.txt
cat /home/ibrahim/Arecon/$domain/subdomain/massdns.txt | sed 's/A.*//; s/CN.*// ; s/\..$//' | tee > /home/ibrahim/Arecon/$domain/subdomain/final_sub.txt
done
}
resolving_domains

domain_ip(){
for domain in $(cat $host);
do
gf ip /home/ibrahim/Arecon/$domain/subdomain/massdns.txt | sed 's/.*://' > /home/ibrahim/Arecon/$domain/subdomain/ip_sub.txt
done
}
domain_ip

http_prob(){
for domain in $(cat $host);
do
cat /home/ibrahim/Arecon/$domain/subdomain/final_sub.txt | httpx -threads 200 -o /home/ibrahim/Arecon/$domain/subdomain/active_subdomain.txt 
done
}
