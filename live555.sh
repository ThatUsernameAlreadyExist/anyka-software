#!/usr/bin/env bash
. ./build_helpers.sh

SRC_DIR="live"
RESULT_FILES="lib/libliveMedia.so lib/libBasicUsageEnvironment.so lib/libgroupsock.so lib/libUsageEnvironment.so"


makeDir "$INSTALL_DIR"
printBuildInfo "live555" "latest"
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "http://www.live555.com/liveMedia/public/live555-latest.tar.gz" "$SRC_DIR"

cd $SRC_DIR
CONFIG_FILE="config.anyka"

echo "CROSS_COMPILE=${CROSS_COMPILE}" > $CONFIG_FILE
echo "COMPILE_OPTS=\$(INCLUDES) -I. -O3 -DNO_STD_LIB=1 -DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -DXLOCALE_NOT_USED=1 -DLOCALE_NOT_USED -fPIC -DNO_OPENSSL=1" >> $CONFIG_FILE
echo "C=c" >> $CONFIG_FILE
echo "C_COMPILER=\$(CROSS_COMPILE)gcc" >> $CONFIG_FILE
echo "CFLAGS+=\$(COMPILE_OPTS)" >> $CONFIG_FILE
echo "C_FLAGS=\$(CFLAGS)" >> $CONFIG_FILE
echo "CPP=cpp" >> $CONFIG_FILE
echo "CPLUSPLUS_COMPILER=\$(CROSS_COMPILE)g++" >> $CONFIG_FILE
echo "CPLUSPLUS_FLAGS=\$(COMPILE_OPTS) -Wall -DBSD=1" >> $CONFIG_FILE
echo "CPLUSPLUS_FLAGS+=\$(CPPFLAGS) -std=c++11 -fexceptions" >> $CONFIG_FILE
echo "OBJ=o" >> $CONFIG_FILE
echo "LINK=\$(CROSS_COMPILE)g++ -o" >> $CONFIG_FILE
echo "LINK_OPTS=-L. \$(LDFLAGS) -lstdc++" >> $CONFIG_FILE
echo "CONSOLE_LINK_OPTS=\$(LINK_OPTS)" >> $CONFIG_FILE
echo "LIBRARY_LINK=\$(CROSS_COMPILE)gcc -o" >> $CONFIG_FILE
echo "SHORT_LIB_SUFFIX=so" >> $CONFIG_FILE
echo "LIB_SUFFIX=\$(SHORT_LIB_SUFFIX)" >> $CONFIG_FILE
echo "LIBRARY_LINK_OPTS=-shared -Wl,-soname,\$(NAME).\$(SHORT_LIB_SUFFIX) \$(LDFLAGS)" >> $CONFIG_FILE
echo "LIBS_FOR_CONSOLE_APPLICATION=\$(CXXLIBS)" >> $CONFIG_FILE
echo "LIBS_FOR_GUI_APPLICATION=$(LIBS_FOR_CONSOLE_APPLICATION)" >> $CONFIG_FILE
echo "EXE=" >> $CONFIG_FILE
echo "PREFIX=" >> $CONFIG_FILE 
echo "DESTDIR=${INSTALL_DIR}"  >> $CONFIG_FILE 


./genMakefiles anyka
make clean
make -j4 && make install 

cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build live555"       
printBuildSuccess "live555"





