#!/bin/bash
# Created by Francois Fonteyn on 02/02/2014

# Colors and styles
NORMAL="\\033[0m"
BOLD="\\033[1m"
RED="\\033[31m"
GREEN="\\033[32m"
BLUE="\\033[34m"
CYAN="\\033[36m"
LIGHT_RED="\\033[91m"

version="3.3"

dir=$(echo "$0"|awk -F "/" '{F=""; for(A=1; A<NF; ++A) {F=F$A"/";} print(F);}')
cd "$dir"

# ask user if good directory
echo -e "${BOLD}${LIGHT_RED}Are you sure you want to setup the project here (${PWD}) ?${NORMAL}"
select r in "Yes" "No"; do
    case $r in
        Yes )
            echo -e "${BOLD}${CYAN}Nice, going on...${NORMAL}"
            break;;
        No )
            echo -e "${BOLD}${CYAN}Please go to the right directory and try again${NORMAL}"
            exit 0
            break;;
    esac
done

# brew
echo -e "${BOLD}${LIGHT_RED}Brewing stuff...${NORMAL}"
brew doctor
brew install cmake
brew install boost --with-c++11
echo -e "${BOLD}${CYAN}Brewing done.${NORMAL}"

# create directory structure
echo -e "${BOLD}${LIGHT_RED}Creating directory structure...${NORMAL}"
if [ -d llvm ];          then rm -r llvm;          fi
if [ -d gtest ];         then rm -r gtest;         fi
if [ -d gtest-debug ];   then rm -r gtest-debug;   fi
if [ -d mozart2-build ]; then rm -r mozart2-build; fi
if [ -d llvm-build ];    then rm -r llvm-build;    fi
mkdir gtest-debug
mkdir mozart2-build
mkdir llvm-build
echo -e "${BOLD}${CYAN}Directory structure successfully created.${NORMAL}"

# downloading gtest
echo -e "${BOLD}${LIGHT_RED}Downloading gtest...${NORMAL}"
svn co http://googletest.googlecode.com/svn/trunk gtest
echo -e "${BOLD}${CYAN}gtest successfully downloaded.${NORMAL}"

# preparing gtest
cd gtest-debug
echo -e "${BOLD}${LIGHT_RED}Preparing make gtest (cmake)...${NORMAL}"
cmake -DCMAKE_BUILD_TYPE=Debug ../gtest
echo -e "${BOLD}${CYAN}gtest successfully prepared (cmake).${NORMAL}"

# make gtest
echo -e "${BOLD}${LIGHT_RED}Compiling gtest (make)...${NORMAL}"
make -j `sysctl -n hw.ncpu`
echo -e "${BOLD}${CYAN}gtest successfully compiled (make).${NORMAL}"

# downloading llvm
cd ..
echo -e "${BOLD}${LIGHT_RED}Downloading llvm...${NORMAL}"
curl -O http://llvm.org/releases/"$version"/llvm-"$version".src.tar.gz
tar xvfz llvm-"$version".src.tar.gz
mv llvm-"$version".src llvm
rm llvm-"$version".src.tar.gz
echo -e "${BOLD}${CYAN}llvm successfully downloaded.${NORMAL}"

# downloading clang
cd llvm/tools/
echo -e "${BOLD}${LIGHT_RED}Downloading clang...${NORMAL}"
curl -O http://llvm.org/releases/"$version"/cfe-"$version".src.tar.gz
tar xvfz cfe-"$version".src.tar.gz
mv cfe-"$version".src clang
rm cfe-"$version".src.tar.gz
echo -e "${BOLD}${CYAN}clang successfully downloaded.${NORMAL}"

# preparing llvm
cd ../../llvm-build
echo -e "${BOLD}${LIGHT_RED}Preparing make llvm (cmake)...${NORMAL}"
cmake -DCMAKE_BUILD_TYPE=Release ../llvm
echo -e "${BOLD}${CYAN}llvm successfully prepared (cmake).${NORMAL}"

# make llvm
echo -e "${BOLD}${LIGHT_RED}Compiling llvm (make)...${NORMAL}"
make -j `sysctl -n hw.ncpu`
echo -e "${BOLD}${CYAN}llvm successfully compiled (make).${NORMAL}"

# end
echo -e "${BOLD}${GREEN}Congrats, you can now use build.sh to compile mozart2.${NORMAL}"
