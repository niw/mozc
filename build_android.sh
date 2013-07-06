#!/bin/sh
set -e

PATH="/opt/android/android-sdk-linux/tools:$PATH"
PATH="/opt/android/android-sdk-linux/platform-tools:$PATH"
PATH="/opt/android/android-ndk-r8c:$PATH"
export PATH
export JAVA_HOME="/usr/lib/jvm/default-java"

help() {
  echo "Usage: $0 [options]"
  echo ""
  echo "Options:"
  echo "  -h  show this help message and exit"
  echo "  -f  force clean and build"
  echo "  -r  build Release_Android"
  exit
}

ANDROID_BUILD_MODE=Debug

while getopts fh OPTION; do
  case $OPTION in
  "h") help;;
  "f") FORCE=1;;
  "r") ANDROID_BUILD_MODE=Release;;
  esac
done

if [ ! -z $FORCE ]; then
  python checkout_externals.py -f unix
else
  python checkout_externals.py unix
fi

cd src

if [ ! -z $FORCE ]; then
  python build_mozc.py clean --target_platform=Android
fi

python build_mozc.py gyp --target_platform=Android --noqt
python build_mozc.py build_tools -c Release
python build_mozc.py build android/android.gyp:android_manifest

# Use ~/.android/debug.keystore to sign APK.
if [ ! -z $FORCE ]; then
  rm android/local.properties
  cat << EOF > android/local.properties
key.store=~/.android/debug.keystore
key.alias=androiddebugkey
key.store.password=android
key.alias.password=android
EOF
fi
android update project -s -p android --target android-17

python build_mozc.py build android/android.gyp:apk -c "${ANDROID_BUILD_MODE}_Android"
