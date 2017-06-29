#! /bin/bash

#echo -n "Copying binaries to ${BINARIES}..."
#cp /AD-Capital/Processor/build/libs/processor.war ${BINARIES}
#cp /AD-Capital/Portal/build/libs/portal.war ${BINARIES}
#cp /AD-Capital/Rest/build/libs/Rest.war ${BINARIES}
#cp /AD-Capital/Verification/build/libs/Verification.jar ${BINARIES}
#cp /AD-Capital/QueueReader/build/libs/QueueReader.jar ${BINARIES}
#echo "done"

cp -r /AD-Capital ${BINARIES}

#mkdir ${BINARIES}/AD-Capital
#cp /AD-Capital/build.gradle ${BINARIES}/AD-Capital/
#cp /AD-Capital/database.properties ${BINARIES}/AD-Capital/
#cp /AD-Capital/schema.sql ${BINARIES}/AD-Capital/

echo "Database ready - container will now exit"
