#!/usr/bin/env bash

VERSION="4.1"
echo "Swift $VERSION Continuous Integration";

# Determine OS
UNAME=`uname`;
if [[ $UNAME == "Darwin" ]];
then
    OS="macos";
else
    if [[ $UNAME == "Linux" ]];
    then
        UBUNTU_RELEASE=`lsb_release -a 2>/dev/null`;
        if [[ $UBUNTU_RELEASE == *"16.04"* ]];
        then
            OS="ubuntu1604";
        else
            OS="ubuntu1404";
        fi
    else
        echo "Unsupported Operating System: $UNAME";
    fi
fi
echo "🖥 Operating System: $OS";

if [[ $OS != "macos" ]];
then
    echo "📚 Installing Dependencies"
    sudo apt-get install -y clang libicu-dev uuid-dev

    echo "🐦 Installing Swift";
    if [[ $OS == "ubuntu1604" ]];
    then
        SWIFTFILE="swift-$VERSION-RELEASE-ubuntu16.04";
    else
        SWIFTFILE="swift-$VERSION-RELEASE-ubuntu14.04";
    fi
    wget https://swift.org/builds/swift-$VERSION-release/$OS/swift-$VERSION-RELEASE/$SWIFTFILE.tar.gz
    tar -zxf $SWIFTFILE.tar.gz
    export PATH=$PWD/$SWIFTFILE/usr/bin:"${PATH}"
fi

echo "📅 Version: `swift --version`";

echo "🚀 Building";
swift build
if [[ $? != 0 ]]; 
then 
    echo "❌  Build failed";
    exit 1; 
fi

echo "💼 Building Release";
swift build -c release
if [[ $? != 0 ]]; 
then 
    echo "❌  Build for release failed";
    exit 1; 
fi

echo "🔎 Testing";

swift test
if [[ $? != 0 ]]; 
then 
    echo "❌ Tests failed";
    exit 1; 
fi

echo "✅ Done"
