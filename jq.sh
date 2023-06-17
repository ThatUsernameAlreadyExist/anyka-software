#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="1.6"
SRC_DIR="jq-${VERSION}"

makeDir "$INSTALL_DIR"
printBuildInfo "jq" ${VERSION}
removeMustBuildFiles "bin/jq"
downloadSources "https://github.com/jqlang/jq/releases/download/${SRC_DIR}/${SRC_DIR}.tar.gz" "$SRC_DIR"

cd $SRC_DIR

autoreconf -fi
./configure --host=${HOST} --with-oniguruma=builtin --disable-maintainer-mode --prefix=${INSTALL_DIR}

make -j4 && make install

cd ..

checkBuildedFiles "bin/jq" "Failed build jq"
printBuildSuccess "jq"
