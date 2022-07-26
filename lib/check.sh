#!/bin/bash
source color.sh

checkcontrol() {
    listcheck=(EKSIKDOSYA) # exp, "check.sh"
    listmodul=(EKSIKPACKAGE)
    listnot=() # bos olacak
    listnotmodul=() # bos olacak
    echo -e "$blue==========FILE CHECK==========$normal\n"
    for ((i=0;i<${#listcheck[@]};i++)); do
        name=${listcheck[$i]}
        if [ -e $name ]; then
            echo -e "$green[+] $name yuklu.$normal"
        else
            echo -e "$red[-] $name yuklu degil.$normal"
            listnot+=($name)
        fi
    done
    if [[ ${#listnot[@]} -gt 0 ]]; then
        echo -e "$red[!] ${listnot} adli modul/moduller bulunmadi tekrar yukleyiniz."
        exit 1
    fi
    echo -e "\n$blue==========PACKAGE CHECK==========$normal\n"
    for ((i=0;i<${#listmodul[@]};i++)); do
        name=${listmodul[$i]}
        if [[ $(apt list --installed|grep -e $name) ]] > /dev/null 2>&1; then
            if [[ $? -eq 0 ]]; then
                echo -e "$green[+] $name yuklu.$normal"
            fi
        else
            echo -e "$red[-] $name yuklu degil.$normal"
            listnotmodul+=($name)
        fi
    done
 
    if [[ ${#listnotmodul[@]} -gt 0 ]]; then
        echo -e "$cyan\n[!] Eksik paketler yukleniyor$normal"
        notinstalled=0
        for ((i=0;i<${#listnotmodul[@]};i++)); do
            name=${listnotmodul[$i]}
            apt install "$name" -y &> /dev/null
            if [[ $? -eq 100 ]]; then
                echo -e "$yellow[!] $name adli paket yuklenemiyor.$normal"
            else
                echo -e "$green[+] $name yuklendi.$normal"
                ((counter++))
            fi
        done
        if [[ $notinstalled > 0 ]];then
            echo "Yuklenemeyen dosyalar oldugundan cikis yapiliyor..."
            exit 1
        fi
    fi
}
