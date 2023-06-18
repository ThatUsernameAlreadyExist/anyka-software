#!/usr/bin/env bash
. ./build_helpers.sh


SRC_DIR="anyka-v4l2rtspserver-main"
RESULT_FILES="bin/v4l2rtspserver"

makeDir "$LIBRARY_PATH"
printBuildInfo "anyka-v4l2rtspserver" "main" 
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "https://github.com/ThatUsernameAlreadyExist/anyka-v4l2rtspserver/archive/refs/heads/main.zip" "$SRC_DIR" "zip"

cd $SRC_DIR

rm CMakeCache.txt
rm -r CMakeFiles

TFILE="anyka.toolchain"

echo "SET(CMAKE_SYSTEM_NAME Linux)" > $TFILE
echo "SET(CMAKE_SYSTEM_PROCESSOR arm)" >> $TFILE
echo "set(THREADS_PTHREAD_ARG \"2\" CACHE STRING \"Forcibly set by CMakeLists.txt.\" FORCE)" >> $TFILE
echo "set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> $TFILE
echo "set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> $TFILE
echo "set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> $TFILE
echo "SET(CMAKE_CXX_COMPILER ${CC} -DNO_OPENSSL=1 -std=c++11)" >> $TFILE
echo "add_definitions(-DHAVE_ALSA)" >> $TFILE

export LDFLAGS="${LDFLAGS} -L${LIBRARY_PATH} -lak_mt -lakaudiocodec -lakaudiofilter -lakispsdk -lakmedialib -lakuio -lakv_encode -lmpi_aenc -lmpi_md -lmpi_osd -lmpi_venc -lplat_ai -lplat_ao -lplat_common -lplat_ipcsrv -lplat_thread -lplat_venc_cb -lplat_vi -lplat_vpss -lstdc++"

cp -a -r "libs/." "${LIBRARY_PATH}"

cmake -DWITH_SSL=OFF -DCMAKE_TOOLCHAIN_FILE="${TFILE}" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
    -DCMAKE_INSTALL_LIBDIR="${INSTALL_DIR}/lib" -DCMAKE_INSTALL_INCLUDEDIR="${INSTALL_DIR}/include"
make -j4 && cp -f v4l2rtspserver "${INSTALL_DIR}/bin/v4l2rtspserver"

cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build v4lrtspserver"       
printBuildSuccess "v4lrtspserver"





