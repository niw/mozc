#!/bin/sh
rm -rf src/protobuf/files; svn checkout http://protobuf.googlecode.com/svn/trunk@375 src/protobuf/files
rm -rf src/third_party/gtest; svn checkout http://googletest.googlecode.com/svn/trunk@484 src/third_party/gtest
rm -rf src/third_party/gyp; svn checkout http://gyp.googlecode.com/svn/trunk@1034 src/third_party/gyp
rm -rf src/third_party/japanese_usage_dictionary; svn checkout http://japanese-usage-dictionary.googlecode.com/svn/trunk@3 src/third_party/japanese_usage_dictionary
rm -rf src/third_party/zinnia/v0_04; svn checkout https://zinnia.svn.sourceforge.net/svnroot/zinnia/zinnia@16 src/third_party/zinnia/v0_04
