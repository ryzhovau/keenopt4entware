#!/bin/sh

# Working dir should stay in feeds/keenopt4entware
SCRIPT_DIR=$(dirname $0)
ROOT_DIR=$SCRIPT_DIR/installer_root
BUILD_DIR=$SCRIPT_DIR/../../build_dir/target-mipsel_mips32r2_uClibc-*
INSTALLER=$SCRIPT_DIR/installer-entware.tar.gz

[ -d $ROOT_DIR ] && rm -fr $ROOT_DIR
mkdir $ROOT_DIR

# Adding toolchain libraries
cp -r $BUILD_DIR/toolchain/ipkg-mipselsf/libc/opt $ROOT_DIR
cp -r $BUILD_DIR/toolchain/ipkg-mipselsf/libgcc/opt $ROOT_DIR

# Adding busybox
cp -r $BUILD_DIR/busybox-*/ipkg-install/opt $ROOT_DIR

# Adding SSH keys to avoid dropbear post-install timeout
mkdir -p $ROOT_DIR/opt/etc/dropbear
cp $SCRIPT_DIR/dropbear_ecdsa_host_key $ROOT_DIR/opt/etc/dropbear
cp $SCRIPT_DIR/dropbear_rsa_host_key $ROOT_DIR/opt/etc/dropbear

# Adding install script
mkdir -p $ROOT_DIR/opt/etc/init.d
cp $SCRIPT_DIR/doinstall $ROOT_DIR/opt/etc/init.d
chmod +x $ROOT_DIR/opt/etc/init.d/doinstall

# Packing installer
[ -f $INSTALLER ] && rm $INSTALLER
tar -czf $INSTALLER -C $ROOT_DIR/opt bin etc lib sbin

# Removing temp folder
rm -fr $ROOT_DIR
