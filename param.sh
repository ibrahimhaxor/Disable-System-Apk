#!/bin/bash

for i in `cat $1`; do

python3 ParamSpider/paramspider.py -d $i --exclude woff,css,js,png,svg,jpg

done;


cat /home/ibrahim/output/https:/*.txt | tee /home/ibrahim/0Recon/paramspider.txt

cat /home/ibrahim/output/http:/*.txt | tee /home/ibrahim/0Recon/paramspider.txt

rm -rf /home/ibrahim/output/https:/*.txt 

rm -rf /home/ibrahim/output/http:/*.txt 
