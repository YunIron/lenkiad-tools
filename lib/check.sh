#!/bin/bash

source color.sh

checkcontrol() {
    listFile=(EKSIKDOSYA) # exp, "check.sh"
    listModule=(EKSIKPACKAGE) # exp, "aircrack-ng"
    notInstalledFile=() # Empty
    notinstalledModule=() # Empty
    echo -e "$blue==========FILE CHECK==========$normal\n"
    for ((i=0;i<${#listFile[@]};i++)); do
        name=${listFile[$i]}
        if [ -e $name ]; then
            echo -e "$green[+] $name yuklu.$normal"
        else
            echo -e "$red[-] $name yuklu degil.$normal"
            notInstalledFile+=($name)
        fi
    done
    if [[ ${#notInstalledFile[@]} -gt 0 ]]; then
        echo -e "$red[!] ${notInstalledFile} adli modul/moduller bulunmadi tekrar yukleyiniz."
        exit 1
    fi
    echo -e "\n$blue==========PACKAGE CHECK==========$normal\n"
    for ((i=0;i<${#listModule[@]};i++)); do
        name=${listModule[$i]}
        if [[ $(apt list --installed|grep -e $name) ]] > /dev/null 2>&1; then
            if [[ $? -eq 0 ]]; then
                echo -e "$green[+] $name yuklu.$normal"
            fi
        else
            echo -e "$red[-] $name yuklu degil.$normal"
            notInstalledModule+=($name)
        fi
    done
 
    if [[ ${#notInstalledModule[@]} -gt 0 ]]; then
        echo -e "$cyan\n[!] Eksik paketler yukleniyor$normal"
        notInstalledModuleCount=0
        for ((i=0;i<${#notInstalledModule[@]};i++)); do
            name=${notInstalledModule[$i]}
            apt install "$name" -y &> /dev/null
            if [[ $? -eq 100 ]]; then
                echo -e "$yellow[!] $name adli paket yuklenemiyor.$normal"
            else
                echo -e "$green[+] $name yuklendi.$normal"
                ((counter++))
            fi
        done
        if [[ $notInstalledModuleCount> 0 ]];then
            echo "Yuklenemeyen dosyalar oldugundan cikis yapiliyor..."
            exit 1
        fi
    fi
}
