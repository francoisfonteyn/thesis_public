#!/bin/bash

# Colors and styles
NORMAL="\\033[0m"
BOLD="\\033[1m"
DIM="\\033[2m"
UNDERLINE="\\033[4m"
BLINK="\\033[5m"
INVERTED="\\033[7m"
HIDDEN="\\033[8m"
BLACK="\\033[30m"
RED="\\033[31m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
CYAN="\\033[36m"
LIGHT_GRAY="\\033[37m"
DARK_GRAY="\\033[90m"
LIGHT_RED="\\033[91m"
LIGHT_GREEN="\\033[92m"
LIGHT_YELLOW="\\033[93m"
LIGHT_BLUE="\\033[94m"
LIGHT_MAGENTA="\\033[95m"
LIGHT_CYAN="\\033[96m"
WHITE="\\033[97m"
BACK_BLACK="\\033[40m"
BG_RED="\\033[41m"
BG_GREEN="\\033[42m"
BG_YELLOW="\\033[43m"
BG_BLUE="\\033[44m"
BG_MAGENTA="\\033[45m"
BG_CYAN="\\033[46m"
BG_LIGHT_GRAY="\\033[47m"
BG_DARK_GRAY="\\033[100m"
BG_LIGHT_RED="\\033[101m"
BG_LIGHT_GREEN="\\033[102m"
BG_LIGHT_YELLOW="\\033[103m"
BG_LIGHT_BLUE="\\033[104m"
BG_LIGHT_MAGENTA="\\033[105m"
BG_LIGHT_CYAN="\\033[106m"
BG_WHITE="\\033[107m"

dir=$(echo "$0"|awk -F "/" '{F=""; for(A=1; A<NF; ++A) {F=F$A"/";} print(F);}')
cd "$dir"
to="/Users/fou/thesis/Code/mozart2/"

echo -e "${LIGHT_RED}${BOLD}---------------------------------------
- Francois Fonteyn, 2014              -
- This script comes with no warranty. -
---------------------------------------${NORMAL}"

# usage
usage() {
    echo -e "${GREEN}Usage: ${0} [-hcp]
    -h: Display this help
    -c: Make the changes
    -p: Specify the path of mozart2 sources, default is ${to}${NORMAL}"
    exit 0
}

cp_diff() {
    lim=36
    printf "${NORMAL}${CYAN}%-${lim}s${RED}" "${1}..."
    trgt="$2"
    last=$(echo ${trgt:(-1)})
    if [ $last == "/" ]; then trgt="${trgt}${1}"; fi
    if [ -e "$trgt" ]; then
        d=$(diff "$1" "$trgt")
        if [ ${#d} == 0 ]; then
            echo -e "${CYAN} Nothing to do.${RED}"
        else
            cp "$1" "$trgt"
            echo -e "${CYAN} Done.${RED}"
        fi
    else
        cp "$1" "$trgt"
        echo -e "${CYAN} Done.${RED}"
    fi
}

# make_changes
make_changes() {
    echo -ne "${RED}${BOLD}"
    cp_diff CheckTupleSyntax.oz "${to}lib/compiler/"
    cp_diff CMakeLists_lib.txt "${to}lib/CMakeLists.txt"
    cp_diff CMakeLists_platform-test.txt "${to}platform-test/CMakeLists.txt"
    cp_diff ListComprehension.oz "${to}lib/compiler/"
    cp_diff Lexer.oz "${to}lib/compiler/"
    cp_diff Macro.oz "${to}lib/compiler/"
    cp_diff Parser.oz "${to}lib/compiler/"
    cp_diff RecordComprehension.oz "${to}lib/compiler/"
    cp_diff RunTime.oz "${to}lib/compiler/"
    cp_diff TupleSyntax.oz "${to}lib/compiler/"
    cp_diff Unnester.oz "${to}lib/compiler/"
    cp_diff listComprehension-test.oz "${to}platform-test/base/listComprehension.oz"
    cp_diff recordComprehension-test.oz "${to}platform-test/base/recordComprehension.oz"
    cp oz.el "${to}opi/emacs/"
    echo -ne "${NORMAL}"
}

doit=0

# Check syntax
args=`getopt hcp:`
# Parse arguments
for((i=1;i<=$#;i++))
do
    case "${!i}" in
        -h)
            usage
            ;;
        -c)
            doit=1
            ;;
        -p)
            i=`expr $i + 1`
            to="${!i}"
            last="${to:(-1)}"
            if [ ! $last == "/" ]; then
                to="${to}/"
            fi
            ;;
    esac
done

if [ $doit == 1 ]; then
    make_changes
    exit 0
fi

usage

echo -ne "${NORMAL}"
