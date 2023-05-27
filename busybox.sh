#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="1.35.0"
SRC_DIR="busybox-${VERSION}"

makeDir "$INSTALL_DIR"
printBuildInfo "busybox" ${VERSION}
removeMustBuildFiles "bin/busybox"     
downloadSources "https://www.busybox.net/downloads/${SRC_DIR}.tar.bz2" "$SRC_DIR"

cd $SRC_DIR

make ARCH=arm CROSS_COMPILE=$CROSS_COMPILE clean
make ARCH=arm CROSS_COMPILE=$CROSS_COMPILE defconfig

#Remove some packages that doesn't compile
sed -e 's/CONFIG_FALLOCATE=y/CONFIG_FALLOCATE=n/' -i .config
sed -e 's/CONFIG_NSENTER=y/CONFIG_NSENTER=n/' -i .config
sed -e 's/CONFIG_FSYNC=y/CONFIG_FSYNC=n/' -i .config
sed -e 's/CONFIG_SYNC=y/CONFIG_SYNC=n/' -i .config

# Enable some features (note the /c which changes the entire line)
sed -e '/CONFIG_FLASH_LOCK/c\CONFIG_FLASH_LOCK=y' -i .config
sed -e '/CONFIG_FLASH_UNLOCK/c\CONFIG_FLASH_UNLOCK=y' -i .config
sed -e '/CONFIG_FLASH_ERASEALL/c\CONFIG_FLASH_ERASEALL=y' -i .config


make -j4 ARCH=arm CROSS_COMPILE=$CROSS_COMPILE && \
    make ARCH=arm CROSS_COMPILE=$CROSS_COMPILE CONFIG_INSTALL_APPLET_DONT=y CONFIG_INSTALL_APPLET_SYMLINKS=n CONFIG_PREFIX=${INSTALL_DIR} install

cd ..

checkBuildedFiles "bin/busybox" "Failed build busybox"       
printBuildSuccess "busybox"





