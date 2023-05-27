#!/usr/bin/env bash
. ./build_helpers.sh


VERSION="0.3.7"
SRC_DIR="v4l2rtspserver-${VERSION}"
RESULT_FILES="bin/v4l2rtspserver"

makeDir "$LIBRARY_PATH"
printBuildInfo "v4l2rtspserver" "${VERSION}" 
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "https://github.com/mpromonet/v4l2rtspserver/archive/refs/tags/v${VERSION}.tar.gz" "$SRC_DIR"

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
echo "SET(CMAKE_CXX_COMPILER ${CC} -DNO_OPENSSL=1)" >> $TFILE
echo "add_definitions(-DHAVE_ALSA)" >> $TFILE

export LDFLAGS="${LDFLAGS} -L${LIBRARY_PATH} -lak_mt -lakaudiocodec -lakaudiofilter -lakispsdk -lakmedialib -lakuio -lakv_encode -lmpi_aenc -lmpi_md -lmpi_osd -lmpi_venc -lplat_ai -lplat_ao -lplat_common -lplat_ipcsrv -lplat_thread -lplat_venc_cb -lplat_vi -lplat_vpss"

#temp remove find openssl (no WITH_SSL in current project version)
sed -e '/find_package(OpenSSL QUIET)/c\#find_package(OpenSSL QUIET)' -i CMakeLists.txt

rm -rf "./libv4l2cpp"
cp -r "../Anyka/anyka_libv4l2cpp" "./libv4l2cpp"
cp -f "../Anyka/anyka_libv4l2cpp/audio/ALSACapture.cpp" "src/ALSACapture.cpp"
cp -f "../Anyka/anyka_libv4l2cpp/audio/ALSACapture.h" "inc/ALSACapture.h"
cp -a -r "../Anyka/anyka_libs/." "${LIBRARY_PATH}"

cmake -DWITH_SSL=OFF -DCMAKE_TOOLCHAIN_FILE="${TFILE}" -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
    -DCMAKE_INSTALL_LIBDIR="${INSTALL_DIR}/lib" -DCMAKE_INSTALL_INCLUDEDIR="${INSTALL_DIR}/include"
make -j4 && cp -f v4l2rtspserver "${INSTALL_DIR}/bin/v4l2rtspserver"

cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build v4lrtspserver"       
printBuildSuccess "v4lrtspserver"





