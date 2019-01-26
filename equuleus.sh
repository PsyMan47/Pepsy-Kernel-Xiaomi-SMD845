#!/bin/bash

KERNEL_DIR=$PWD
ANYKERNEL_DIR=$KERNEL_DIR/AnyKernel2
TOOLCHAINDIR=/pipeline/build/root/toolchain/aarch64-linux-android-4.9
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Pepsy"
DEVICE="-equuleus-"
VER="-v0.1"
TYPE="-AOSP"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE""$TYPE""$VER".zip

rm $ANYKERNEL_DIR/equuleus/Image.gz-dtb
rm $KERNEL_DIR/arch/arm64/boot/Image.gz $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb

export ARCH=arm64
export KBUILD_BUILD_USER="Psy_Man"
export KBUILD_BUILD_HOST="PsyBuntu"
export CC=/pipeline/build/root/toolchain/proprietary_vendor_qcom_sdclang-6.0_linux-x86_64/bin/clang
export CXX=/pipeline/build/root/toolchain/proprietary_vendor_qcom_sdclang-6.0_linux-x86_64/bin/clang++
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=$TOOLCHAINDIR/bin/aarch64-linux-android-

make clean && make mrproper
make equuleus_defconfig
make -j$( nproc --all )

{
cp $KERNEL_DIR/arch/arm64/boot/Image.gz-dtb $ANYKERNEL_DIR/equuleus
} || {
  if [ $? != 0 ]; then
    curl -s -X POST https://api.telegram.org/bot$BOT_API_KEY/sendMessage -d text="Build failed for equuleus :c" -d chat_id=@pepsykernel;
    exit
  fi
}

cd $ANYKERNEL_DIR/equuleus
zip -r9 $FINAL_ZIP * -x *.zip $FINAL_ZIP
curl -F chat_id="-1001152658251" -F document=@"$FINAL_ZIP" https://api.telegram.org/bot$BOT_API_KEY/sendDocument
mv $FINAL_ZIP /pipeline/output/$FINAL_ZIP

