#!/bin/bash

host=$1
wordlist="/home/ibrahim/wordlist/all.txt"
resolver="/home/ibrahim/resolvers.txt"

domain_enum(){
for domain in $(cat $host);
do


subfinder -d $domain >> /home/ibrahim/Arecon/all.txt
assetfinder -subs-only $domain >> /home/ibrahim/Arecon/all.txt
findomain -t $domain >> /home/ibrahim/Arecon/all.txt
amass enum -active -d $domain >> /home/ibrahim/Arecon/all.txt
curl -s "https://crt.sh/?q=%25.$domain&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> /home/ibrahim/Arecon/all.txt
curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> /home/ibrahim/Arecon/all.txt
curl -s https://dns.bufferover.run/dns?q=.$domain |jq -r .FDNS_A[]|cut -d',' -f2|sort -u >> /home/ibrahim/Arecon/all.txt
curl -s "https://jldc.me/anubis/subdomains/$domain" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> /home/ibrahim/Arecon/all.txt
sed -ne 's/^\( *\)Subject:/\1/p;/X509v3 Subject Alternative Name/{
N;s/^.*\n//;:a;s/^\( *\)\(.*\), /\1\2\n\1/;ta;p;q; }' < <(
openssl x509 -noout -text -in <(
openssl s_client -ign_eof 2>/dev/null <<<$'HEAD / HTTP/1.0\r\n\r' \
-connect $domain:443 ) ) | grep -Po '((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+' >> /home/ibrahim/Arecon/all.txt
cat /home/ibrahim/Arecon/all.txt > /home/ibrahim/Arecon/allsub.txt
cat /home/ibrahim/Arecon/allsub.txt  sort -u >> /home/ibrahim/Arecon/allsubsort.txt
done
}
domain_enum

