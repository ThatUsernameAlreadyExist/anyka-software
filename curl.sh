#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="8.1.2"
SRC_DIR="curl-${VERSION}"

makeDir "$INSTALL_DIR"
printBuildInfo "curl" ${VERSION}
removeMustBuildFiles "bin/curl"     
downloadSources "https://curl.se/download/${SRC_DIR}.tar.gz" "$SRC_DIR"

cd $SRC_DIR

./configure --host=${HOST} --with-openssl=${INSTALL_DIR} --prefix=${INSTALL_DIR}

make -j4 && make install

cd ..

checkBuildedFiles "bin/curl" "Failed build curl"       
printBuildSuccess "curl"





