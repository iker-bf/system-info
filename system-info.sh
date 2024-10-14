#!/bin/bash

verde="\e[0;32m"
rojo="\e[0;31m"
morado="\e[1;35m"
azul="\e[0;34m"
cian="\e[0;36m"
bold="\e[1m"
reset="\e[0;39m"

function ctrl_c() {

echo -e "\n ${blanco} [>] ${rojo}Finalizando script... \n ${reset}"
rm system_info.txt
exit 1
}

trap ctrl_c INT

function banner_ayuda() {

echo -e "${azul}   _______  _____________________  ___   _____   ____________ "
echo -e "${azul}  / ___/\ \/ / ___/_  __/ ____/  |/  /  /  _/ | / / ____/ __ \\"
echo -e "${azul}  \__ \  \  /\__ \ / / / __/ / /|_/ /   / //  |/ / /_  / / / /"
echo -e "${azul} ___/ /  / /___/ // / / /___/ /  / /  _/ // /|  / __/ / /_/ / "
echo -e "${azul}/____/  /_//____//_/ /_____/_/  /_/  /___/_/ |_/_/    \____/  ${reset}"
echo
echo -e "${blanco} [>] ${azul}Uso: ${verde}sudo $0 ${reset}"
exit 1

}

if [[ $# -ge 1 ]];then

banner_ayuda

fi


if ! [ $(id -u) -eq 0 ];then
echo -e "\n ${blanco} [>] ${rojo}Debes ejecutar el script con el usuario root o con sudo. \n ${reset}"
exit 1
fi


function check_ttl() {
echo -e "\n ${blanco} [>] ${verde}Comprobando tu sistema operativo...\n ${reset}" | tee system_info.txt
resultado=$(ping -c 1 localhost | grep -oE 'ttl=[0-9]+' | awk -F "ttl=" '{print $2}')
sleep 2s
if [ $resultado -le 64 ]; then
echo -e "Tu sistema operativo es Linux \n ${reset}" | tee -a system_info.txt
fi
if [ $resultado -ge 128 ]; then
echo -e "Tu sistema operativo es Windows \n ${reset}" | tee -a system_info.txt
fi
}

check_ttl

function check_kernel() {

echo -e "\n ${blanco} [>] ${verde}Comprobando el kernel del sistema operativo...\n ${reset}"
sleep 2s
uname -rsnm | tee -a system_info.txt
}

check_kernel

function check_memory_in_use() {
echo -e "\n ${blanco} [>] ${verde}Comprobando la memoria RAM libre y usada en el sistema...\n ${reset}"
sleep 2s
free -h | tee -a system_info.txt
}

check_memory_in_use

function check_storage() {
echo -e "\n ${blanco} [>] ${verde}Comprobando almacenamiento disponible...\n ${reset}" | tee -a system_info.txt
sleep 2s
df -h | tee -a system_info.txt
}

check_storage

function check_machine_ips {

if ! command ss -V &>/dev/null;then
apt install iproute2 &>/dev/null
fi
echo -e "\n ${blanco} [>] ${verde}Comprobando las direcciones IPS disponibles...\n ${reset}" | tee -a system_info.txt
sleep 2s
ip addr | tee -a system_info.txt

}

check_machine_ips

function check_machine_tcp_udp_ports {
echo -e "\n ${blanco} [>] ${verde}Comprobando puertos TCP abiertos\n ${reset}" | tee -a system_info.txt
sleep 2s
ss -tlpan | tee -a system_info.txt
echo -e "\n ${blanco} [>] ${verde}Comprobando puertos UDP abiertos\n ${reset}" | tee -a system_info.txt
sleep 2s
ss -ulpan | tee -a system_info.txt
}

check_machine_tcp_udp_ports

function check_internet_conectivity() {
echo -e "\n ${blanco} [>] ${verde}Comprobando conectividad a internet mediante IP...\n ${reset}"
sleep 2s
ping -c 5 8.8.8.8 | tee -a system_info.txt

echo -e "\n ${blanco} [>] ${verde}Comprobando conectividad a internet mediante DNS...\n ${reset}"
sleep 2s
ping -c 5 google.es | tee -a system_info.txt
}
check_internet_conectivity

sleep 2s

clear
echo -e "\n ${blanco} [>] ${verde}Se ha completado el escaneo del sistema correctamente, se acaba de generar el archivo system_info.txt \n ${reset}"
exit 0
