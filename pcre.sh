#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="10.42"
SRC_DIR="pcre2-${VERSION}"

makeDir "$INSTALL_DIR"
printBuildInfo "pcre2" ${VERSION}
removeMustBuildFiles "lib/libpcre2-8.so"
downloadSources "https://github.com/PCRE2Project/pcre2/releases/download/${SRC_DIR}/${SRC_DIR}.tar.gz" "$SRC_DIR"

cd $SRC_DIR

./configure --host=${HOST} --prefix=${INSTALL_DIR}

make -j4 && make install

cd ..

checkBuildedFiles "lib/libpcre2-8.so" "Failed build pcre"
printBuildSuccess "pcre"
