#!/usr/bin/env bash
. ./build_helpers.sh


SRC_DIR="FFmpeg-min-recorder-master"
RESULT_FILES="bin/ffmpeg"

makeDir "$INSTALL_DIR"
printBuildInfo "ffmpeg-min-recorder" "master" 
removeMustBuildFiles ${RESULT_FILES}   
downloadSources "https://github.com/ThatUsernameAlreadyExist/FFmpeg-min-recorder/archive/refs/heads/master.zip" "$SRC_DIR" "zip"

cd $SRC_DIR
make clean
./configure \
    --prefix="${INSTALL_DIR}" \
    --arch=arm \
    --disable-yasm \
    --target-os=linux \
    --enable-cross-compile \
    --cross-prefix=$CROSS_COMPILE \
    --extra-ldflags="-muclibc -static" \
    --extra-cflags="-muclibc" \
    --disable-runtime-cpudetect \
    --enable-small \
    --disable-everything \
    --disable-iconv \
    --disable-protocols \
    --disable-doc \
    --disable-ffserver \
    --disable-ffplay \
    --disable-ffprobe \
    --enable-static \
    --enable-memalign-hack \
    --enable-muxer=matroska \
    --enable-muxer=extsegment \
    --disable-shared \
    --enable-demuxer=sdp \
    --enable-demuxer=rtsp \
    --enable-demuxer=rtp \
    --enable-protocol=rtmp \
    --enable-protocol=rtp \
    --enable-protocol=tcp \
    --disable-safe-bitstream-reader \
    --enable-demuxer=h264 \
    --enable-parser=h264 \
    --enable-decoder=h264 \
    --enable-protocol=file

make -j4 && make install
cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build ffmpeg-min-recorder"       
printBuildSuccess "ffmpeg-min-recorder"





