#!/bin/bash

# 设置临时文件夹，需要提前手动创建
export TMPDIR="/Users/henhuang/Documents/icatch/build_ffmpeg/tmp"

# ndk path
NDK=/Users/henhuang/Documents/icatch/build_ffmpeg/android-ndk-r17c

API=14

SYSROOT=$NDK/platforms/android-$API/arch-arm

PLATFORM=arm-linux-androideabi

TOOLCHAIN=$NDK/toolchains/$PLATFORM-4.9/prebuilt/darwin-x86_64

ISYSROOT=$NDK/sysroot

ASM=$ISYSROOT/usr/include/$PLATFORM

# ouput folder
export PREFIX=$(pwd)/android/arm



# toolchain，version is 4.9

#-D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -D__thumb__ -mthumb 
function build_one
{
./configure \
    --prefix=$PREFIX \
    --disable-asm \
    --disable-yasm \
    --enable-cross-compile \
    --enable-static \
    --disable-shared \
    --disable-doc \
    --disable-stripping \
    --disable-debug \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-avformat \
    --disable-postproc \
    --disable-avfilter \
    --disable-swscale-alpha \
    --disable-symver \
    --disable-network \
    --disable-mmx \
    --disable-swresample \
    --disable-everything \
    --enable-parser=h264 \
    --enable-parser=hevc \
    --enable-decoder=h264 \
    --enable-decoder=hevc \
    --enable-swscale \
    --enable-pic \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=android \
    --arch=arm \
    --sysroot=$SYSROOT \
    --extra-cflags="-I$ASM -isysroot $ISYSROOT  -Os -fPIC -DANDROID -D__ANDROID_API__=$API -U_FILE_OFFSET_BITS -Wfatal-errors -Wno-deprecated -mfloat-abi=softfp" \
    --extra-ldflags="-marm"


$ADDITIONAL_CONFIGURE_FLAG
make clean
make -j4 # make with 4 threads
make install
}


build_one
