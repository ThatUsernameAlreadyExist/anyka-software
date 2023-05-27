#!/bin/bash

START_DIR=$PWD
WORK_DIR=$PWD
INSTALL_DIR="${START_DIR}/INSTALL"
TOOLCHAIN=$(pwd)/arm-anykav200-crosstool/usr/bin
HOST="arm-anykav200-linux-uclibcgnueabi"
CROSS_COMPILE=$TOOLCHAIN/${HOST}-
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}ld
export AR=${CROSS_COMPILE}ar
export STRIP=${CROSS_COMPILE}strip
export CFLAGS="-muclibc -O3"
export CPPFLAGS="-muclibc -O3 -std=c++11"
export LDFLAGS="-muclibc -O3 -lrt -lstdc++ -lpthread -ldl"
export LIBRARY_PATH="${INSTALL_DIR}/lib"
export BINARY_PATH="${INSTALL_DIR}/bin"


exitWithERROR()
{
    printf "\n\n            ------ERROR------ \n\n"
    printf "$1\n\n"
    
    cd "$START_DIR"
    exit 1
}

printInfo()
{
    # $1 - info message

    WINDOW_TITLE="--=[  $1  ]=--"
    
    printf "\n"
    printf "         $WINDOW_TITLE"
    printf "\n"
    
    echo -e '\033]2;'$WINDOW_TITLE'\007'
}

printBuildInfo()
{
    # $1 - library name 
    # $2 - library version

   printInfo "Build $1 v$2"
}

printBuildSuccess()
{
    # $1 - library name 
    
    printf "\n"
    echo "S U C C E S S build $1"
    printf "\n"
}

makeDir()
{
    # $1 - dir path
    
    mkdir -p "$1"

    if [ ! -d "$1" ]; then
        exitWithERROR "Can't make dir: $1"
    fi
}

checkBuildedFilesExists()
{
    for FILE_NAME in $1; do
        if ! [ -f "$INSTALL_DIR/$FILE_NAME" ]; then
            echo "       ###  File not exists: $FILE_NAME   ###"
            return 1
        fi
    done
}

checkBuildedFiles()
{
    # $1 - files list
    checkBuildedFilesExists "$1"
    
    if [ $? -ne 0 ]; then
        exitWithERROR "$2"
    fi
}

downloadSources()
{
    # $1 - URL for download 
    # $2 - source dir path
    # $3 - archive is ZIP
    # $4 - keep src dir

    FILE_NAME=$(basename -- "$1")
    FILE_EXT="${FILE_NAME##*.}"
    ARCHIVE_NAME="$2.$FILE_EXT"

    echo "Prepare $ARCHIVE_NAME"
    ARCHIVE_PATH="${WORK_DIR}/${ARCHIVE_NAME}"
    
    # Download sources archive if not exists
    if [ ! -f $ARCHIVE_PATH ]; then
        wget -P "$WORK_DIR" --no-check-certificate -O "$ARCHIVE_NAME" $1

        if [ $? -ne 0 ]; then
            exitWithERROR "Can't download sources: $1"
        fi
    fi
    
    # Remove extracted sources if exists
    if [ -d $2 ] && ([ -z $4 ] || [ "$4" != "true" ]); then
        rm -rf $2
    fi
    
    # Extract sources
    if [ ! -d $2 ] || ([ -z $4 ] || [ "$4" != "true" ]); then
        if [ "$3" = "zip" ]; then
            unzip -q "$ARCHIVE_PATH"
        else
            tar xf "$ARCHIVE_PATH"
        fi
        
        if [ $? -ne 0 ]; then
            rm -rf $2
            exitWithERROR "Can't extract archive: $ARCHIVE_PATH"
        fi
    fi
}

removeMustBuildFiles()
{
    # $1 - files names list
    
    for FILE_NAME in $1; do
        FILE_PATH="$INSTALL_DIR/$FILE_NAME"
        
        if [ -f $FILE_PATH ]; then
            rm -rf $FILE_PATH
            
            if [ $? -ne 0 ]; then
                exitWithERROR "Can't remove existed file: $FILE_PATH"
            fi
        fi
    done
}

