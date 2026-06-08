#!/bin/bash

set -e

FRP_VERSION=$(cat ../../version.txt)

unset GO111MODULE
unset GOMOD

if [[ -d libfrp ]]; then
  rm -rf libfrp
fi

if [[ -f libfrp.aar ]]; then
  rm -v libfrp.aar
fi

if [[ -f libfrp-sources.jar ]]; then
  rm -v libfrp-sources.jar
fi

if [ ! -d "${ANDROID_HOME}/ndk-bundle" ] && [ ! -d "${ANDROID_NDK_HOME}" ]; then
  if [ "Darwin" == "$(uname)" ]; then
    ANDROID_NDK_HOME="${HOME}/Library/Android/sdk/ndk/23.2.8568313"
  else
    exit
  fi
fi

go env -w GO111MODULE=auto
go install golang.org/x/mobile/cmd/gomobile@latest
gomobile init
gomobile bind -v -o libfrp.aar -target=android .

unzip -d libfrp libfrp.aar

if [[ ! -z $FRP_VERSION ]]; then
  cp -v -rf libfrp/jni libfrp/jniV
  mv libfrp/jniV/arm64-v8a/libgojni.so libfrp/jniV/arm64-v8a/libgojni.${FRP_VERSION}.so
  mv libfrp/jniV/armeabi-v7a/libgojni.so libfrp/jniV/armeabi-v7a/libgojni.${FRP_VERSION}.so
  mv libfrp/jniV/x86/libgojni.so libfrp/jniV/x86/libgojni.${FRP_VERSION}.so
  mv libfrp/jniV/x86_64/libgojni.so libfrp/jniV/x86_64/libgojni.${FRP_VERSION}.so
fi
