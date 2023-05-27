#!/usr/bin/env bash
. ./build_helpers.sh

VERSION="1.4.69"
SRC_DIR="lighttpd-${VERSION}"
RESULT_FILES="sbin/lighttpd"

makeDir "$INSTALL_DIR"
printBuildInfo "lighttpd" "${VERSION}" 
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "https://download.lighttpd.net/lighttpd/releases-1.4.x/${SRC_DIR}.tar.gz" "$SRC_DIR"

cd $SRC_DIR

./autogen.sh

LIGHTTPD_STATIC=yes CPPFLAGS=-DLIGHTTPD_STATIC ./configure --prefix=${INSTALL_DIR} --host=${HOST} --without-mysql --without-zlib --without-bzip2 --disable-ipv6 --without-pcre2 --enable-static --disable-shared --with-openssl -with-openssl-includes=${INSTALL_DIR}/include --with-openssl-libs=${INSTALL_DIR}/lib

echo "PLUGIN_INIT(mod_auth)" > src/plugin-static.h
echo "PLUGIN_INIT(mod_redirect)" >> src/plugin-static.h 
echo "PLUGIN_INIT(mod_alias)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_cgi)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_indexfile)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_staticfile)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_authn_file)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_openssl)" >> src/plugin-static.h
echo "PLUGIN_INIT(mod_dirlisting)" >> src/plugin-static.h

make -j4 && make install
cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build lighttpd"       
printBuildSuccess "lighttpd"





