#!/usr/bin/env bash
. ./build_helpers.sh

RESULT_FILES="bin/getimage bin/setconf bin/getflag bin/files-min-recorder bin/rwconf"

printBuildInfo "tools" "1.0" 
removeMustBuildFiles ${RESULT_FILES}   

cd "anyka-v4l2rtspserver-main/libv4l2cpp"

rm -f getimage
rm -f setconf
rm -f getflag
rm -f files-min-recorder
rm -f rwconf

CPPLDFLAGS="${LDFLAGS} -lstdc++"
CPPCOMPFLAGS="${CPPFLAGS} -std=c++11"

${CC} ${CPPCOMPFLAGS} -DBUILD_GETIMAGE=1         -I"inc/" -o getimage src/GetImage.cpp src/SharedMemory.cpp         ${CPPLDFLAGS}
${CC} ${CPPCOMPFLAGS} -DBUILD_SETCONF=1          -I"inc/" -o setconf  src/SetSharedConfig.cpp src/SharedMemory.cpp  ${CPPLDFLAGS}
${CC} ${CPPCOMPFLAGS} -DBUILD_GETFLAG=1          -I"inc/" -o getflag  src/GetFlag.cpp src/SharedMemory.cpp          ${CPPLDFLAGS}
${CC} ${CPPCOMPFLAGS} -DBUILD_RWCONFIG=1         -I"inc/" -o rwconf  src/ReadWriteConfig.cpp src/ConfigFile.cpp     ${CPPLDFLAGS}
${CC} ${CFLAGS} -std=c99 -DBUILD_GETRECORDEDFILES=1 -I"inc/" -o files-min-recorder src/GetRecordedFiles.c       ${LDFLAGS}

${STRIP} ./getimage
${STRIP} ./setconf 
${STRIP} ./getflag 
${STRIP} ./files-min-recorder 
${STRIP} ./rwconf 

mv ./getimage $BINARY_PATH
mv ./setconf $BINARY_PATH
mv ./getflag $BINARY_PATH
mv ./files-min-recorder $BINARY_PATH
mv ./rwconf $BINARY_PATH

cd ..
cd ..

checkBuildedFiles "${RESULT_FILES}" "Failed build tools"       
printBuildSuccess "tools"





