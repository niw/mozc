#!/bin/sh
rm -rf src/protobuf/files; svn checkout http://protobuf.googlecode.com/svn/trunk@375 src/protobuf/files
rm -rf src/third_party/gmock; svn checkout http://googlemock.googlecode.com/svn/trunk@403 src/third_party/gmock
rm -rf src/third_party/gtest; svn checkout http://googletest.googlecode.com/svn/trunk@614 src/third_party/gtest
rm -rf src/third_party/gyp; svn checkout http://gyp.googlecode.com/svn/trunk@1251 src/third_party/gyp
rm -rf src/third_party/jsoncpp; svn checkout http://jsoncpp.svn.sourceforge.net/svnroot/jsoncpp/trunk/jsoncpp@249 src/third_party/jsoncpp
rm -rf src/third_party/zinnia/v0_04; svn checkout https://zinnia.svn.sourceforge.net/svnroot/zinnia/zinnia@16 src/third_party/zinnia/v0_04
