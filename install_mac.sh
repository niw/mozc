#!/bin/sh
BUILD_MODE=Debug
SRC_DIR=`pwd`

echo "Copy Mozc.app to /Library/Input Methods..."
rm -rf /Library/Input\ Methods/Mozc.app
cp -Rp ${SRC_DIR}/out_mac/${BUILD_MODE}/Mozc.app /Library/Input\ Methods/

echo "Copy org.mozc.inputmethod.Japanese.*.plist to /Library/LaunchAgents..."
rm -f /Library/LaunchAgents/org.mozc.inputmethod.Japanese.*.plist
cp -Rp ${SRC_DIR}/out_mac/DerivedSources/${BUILD_MODE}/mac/org.mozc.inputmethod.Japanese.*.plist /Library/LaunchAgents/

echo "Kill all Mozc.app processes..."
pids=$(ps auxww|grep [M]ozc.app|awk '{print $2}')
for i in $pids; do
	kill $i
done
