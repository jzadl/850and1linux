#!/bin/bash

FILE="Distribuciones_Linux_851.txt"
BOLD="\033[1m"
CYAN="\033[36m"
YELLOW="\033[33m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

if [[ ! -f "$FILE" ]]; then
    echo -e "${RED}No encuentro $FILE, corre el script desde la raiz del repo.${RESET}"
    exit 1
fi

show_menu() {
    echo -e "${CYAN}"
    echo "  ╔══════════════════════════════╗"
    echo "  ║       850and1linux 🐧        ║"
    echo "  ╚══════════════════════════════╝"
    echo -e "${RESET}"
    echo -e "  ${BOLD}1.${RESET} Distro aleatoria"
    echo -e "  ${BOLD}2.${RESET} Buscar distro"
    echo -e "  ${BOLD}3.${RESET} Cuantas hay en total"
    echo -e "  ${BOLD}4.${RESET} Cuantas empiezan con una letra"
    echo -e "  ${BOLD}5.${RESET} Top 5 letras con mas distros"
    echo -e "  ${BOLD}6.${RESET} Distro aleatoria en bucle (presiona Ctrl+C para parar)"
    echo -e "  ${BOLD}7.${RESET} Salir"
    echo ""
}

random_distro() {
    distro=$(shuf -n 1 "$FILE")
    echo -e "\n  🎲 Tu distro del dia: ${YELLOW}${BOLD}$distro${RESET}\n"
}

buscar_distro() {
    echo -ne "\n  Buscar: "
    read query
    results=$(grep -i "$query" "$FILE")
    count=$(echo "$results" | grep -c .)
    if [[ -z "$results" ]]; then
        echo -e "  ${RED}No se encontro nada.${RESET}\n"
    else
        echo -e "\n  ${GREEN}$count resultado(s):${RESET}"
        echo "$results" | while read -r line; do
            echo "    - $line"
        done
        echo ""
    fi
}

contar_total() {
    total=$(wc -l < "$FILE")
    echo -e "\n  📦 Total de distros: ${YELLOW}${BOLD}$total${RESET}\n"
}

contar_letra() {
    echo -ne "\n  Letra: "
    read letra
    letra=$(echo "$letra" | tr '[:lower:]' '[:upper:]')
    count=$(grep -i "^$letra" "$FILE" | wc -l)
    echo -e "\n  Distros que empiezan con ${BOLD}$letra${RESET}: ${YELLOW}$count${RESET}\n"
}

top_letras() {
    echo -e "\n  ${BOLD}Top 5 letras con mas distros:${RESET}\n"
    grep -o '^.' "$FILE" | tr '[:lower:]' '[:upper:]' | sort | uniq -c | sort -rn | head -5 | while read count letra; do
        echo "    ${YELLOW}$letra${RESET}  $count distros"
    done
    echo ""
}

bucle_random() {
    echo -e "\n  Modo ruleta activado. ${RED}Ctrl+C para parar.${RESET}\n"
    while true; do
        distro=$(shuf -n 1 "$FILE")
        echo -e "  🐧 ${YELLOW}$distro${RESET}"
        sleep 1
    done
}

while true; do
    show_menu
    echo -ne "  Opcion: "
    read op
    echo ""
    case $op in
        1) random_distro ;;
        2) buscar_distro ;;
        3) contar_total ;;
        4) contar_letra ;;
        5) top_letras ;;
        6) bucle_random ;;
        7) echo -e "  ${CYAN}Bye 🐧${RESET}\n"; exit 0 ;;
        *) echo -e "  ${RED}Opcion invalida.${RESET}\n" ;;
    esac
done
