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

echo "Copy Mozc.app to /Library/Input Methods..."
rm -rf /Library/Input\ Methods/Mozc.app
cp -Rp ${SRC_DIR}/out_mac/${BUILD_MODE}/Mozc.app /Library/Input\ Methods/
chown -R root:admin /Library/Input\ Methods/Mozc.app

echo "Copy org.mozc.inputmethod.Japanese.*.plist to /Library/LaunchAgents..."
rm -f /Library/LaunchAgents/org.mozc.inputmethod.Japanese.*.plist
cp -Rp ${SRC_DIR}/out_mac/DerivedSources/${BUILD_MODE}/mac/org.mozc.inputmethod.Japanese.*.plist /Library/LaunchAgents/
chown -R root:admin /Library/LaunchAgents/org.mozc.inputmethod.Japanese.*.plist

echo "Load org.mozc.inputmethod.Japanese.*.plist..."
for plist in /Library/LaunchAgents/org.mozc.inputmethod.Japanese.*.plist; do
  launchctl load $plist
done

echo "Kill all Mozc processes..."
pkill Mozc
