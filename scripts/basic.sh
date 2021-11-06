#!/bin/bash
#clear

### 基础部分 ###
# 使用 O3 级别的优化
#sed -i 's/Os/O3 -funsafe-math-optimizations -funroll-loops -ffunction-sections -fdata-sections -Wl,--gc-sections/g' include/target.mk

# 默认开启 Irqbalance
#sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# 更换 Nodejs 版本
# rm -rf ./feeds/packages/lang/node
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node feeds/packages/lang/node
# sed -i '\/bin\/node/a\\t$(STAGING_DIR_HOST)/bin/upx --lzma --best $(1)/usr/bin/node' feeds/packages/lang/node/Makefile
# rm -rf ./feeds/packages/lang/node-arduino-firmata
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-arduino-firmata feeds/packages/lang/node-arduino-firmata
# rm -rf ./feeds/packages/lang/node-cylon
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-cylon feeds/packages/lang/node-cylon
# rm -rf ./feeds/packages/lang/node-hid
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-hid feeds/packages/lang/node-hid
# rm -rf ./feeds/packages/lang/node-homebridge
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-homebridge feeds/packages/lang/node-homebridge
# rm -rf ./feeds/packages/lang/node-serialport
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport feeds/packages/lang/node-serialport
# rm -rf ./feeds/packages/lang/node-serialport-bindings
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-serialport-bindings feeds/packages/lang/node-serialport-bindings
# rm -rf ./feeds/packages/lang/node-yarn
# svn co https://github.com/nxhack/openwrt-node-packages/trunk/node-yarn feeds/packages/lang/node-yarn
# ln -sf ../../../feeds/packages/lang/node-yarn ./package/feeds/packages/node-yarn

# 最大连接数
# sed -i 's/16384/65535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

# 生成默认配置及缓存
rm -rf .config
