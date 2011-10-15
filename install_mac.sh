#!/bin/sh
if [ -z "$BUILD_MODE" ]; then
  BUILD_MODE=Debug
fi
if [ -z "$SRC_DIR" ]; then
  SRC_DIR=`pwd`
fi
if [ ! -e "${SRC_DIR}/out_mac" ]; then
  echo "Couldn't find out out_mac, please specify SRC_DIR or cd to the src directory."
  exit 1;
fi

echo "Copy ${BUILD_MODE}/Mozc.app to /Library/Input Methods..."
rm -rf /Library/Input\ Methods/Mozc.app
cp -Rp ${SRC_DIR}/out_mac/${BUILD_MODE}/Mozc.app /Library/Input\ Methods/

echo "Copy ${BUILD_MODE}/mac/org.mozc.inputmethod.Japanese.*.plist to /Library/LaunchAgents..."
rm -f /Library/LaunchAgents/org.mozc.inputmethod.Japanese.*.plist
cp -Rp ${SRC_DIR}/out_mac/DerivedSources/${BUILD_MODE}/mac/org.mozc.inputmethod.Japanese.*.plist /Library/LaunchAgents/

echo "Kill all Mozc.app processes..."
pids=$(ps auxww|grep [M]ozc.app|awk '{print $2}')
for i in $pids; do
	kill $i
done
