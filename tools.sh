#!/usr/bin/env bash
. ./build_helpers.sh

RESULT_FILES="bin/getimage bin/setconf bin/getflag bin/files-min-recorder"

printBuildInfo "tools" "1.0" 
removeMustBuildFiles ${RESULT_FILES}   

cd "anyka-v4l2rtspserver-main/libv4l2cpp"

rm -f getimage BINARY_PATH
rm -f setconf BINARY_PATH
rm -f getflag BINARY_PATH
rm -f files-min-recorder BINARY_PATH

${CC} ${CPPFLAGS} -DBUILD_GETIMAGE=1         -I"inc/" -o getimage src/GetImage.cpp src/SharedMemory.cpp         ${LDFLAGS}
${CC} ${CPPFLAGS} -DBUILD_SETCONF=1          -I"inc/" -o setconf  src/SetSharedConfig.cpp src/SharedMemory.cpp  ${LDFLAGS}
${CC} ${CPPFLAGS} -DBUILD_GETFLAG=1          -I"inc/" -o getflag  src/GetFlag.cpp src/SharedMemory.cpp          ${LDFLAGS}
${CC} ${CFLAGS} -std=c99 -DBUILD_GETRECORDEDFILES=1 -I"inc/" -o files-min-recorder src/GetRecordedFiles.c              ${LDFLAGS}

${STRIP} ./getimage
${STRIP} ./setconf 
${STRIP} ./getflag 
${STRIP} ./files-min-recorder 

mv ./getimage $BINARY_PATH
mv ./setconf $BINARY_PATH
mv ./getflag $BINARY_PATH
mv ./files-min-recorder $BINARY_PATH

cd ..
cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build tools"       
printBuildSuccess "tools"





