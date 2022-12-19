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
echo -e ${CP}"         This Script Will Install Apk On Your Device             #"                                           
echo -e ${BLUE}"           https://facebook.com/ibraheem_haxor                   #"  
echo -e ${YELLOW}"              Coded By: ibrahim Haxor                            #"
echo -e ${CG}"              https://github.com/ibrahimhaxor                    #"
echo -e ${RED}"################################################################## \n "



echo -e ${CP}"[*] Tab "OK" on "Allow USB debugging" on Phone";

adb devices
adb install 1.apk
adb shell dpm set-device-owner com.pdp.deviceowner/.receivers.AdminReceiver





