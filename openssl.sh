#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="3.1.0"
SRC_DIR="openssl-${VERSION}"
RESULT_FILES="lib/libcrypto.so lib/libssl.so"

makeDir "$INSTALL_DIR"
printBuildInfo "openssl" ${VERSION}
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "https://www.openssl.org/source/${SRC_DIR}.tar.gz" "$SRC_DIR"

cd $SRC_DIR
make clean
./Configure --prefix="${INSTALL_DIR}" linux-armv4 no-async
make -j4 && make install_sw

cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build openssl"       
printBuildSuccess "openssl"





