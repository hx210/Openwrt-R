#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Add luci-app-ssr-plus
# pushd package/lean
# git clone --depth=1 https://github.com/fw876/helloworld
# popd

# Clone community packages to package/community
mkdir package/community
pushd package/community
mkdir need
git clone --depth=1 https://github.com/kiddin9/openwrt-packages

cp -rf openwrt-packages/aria2/ need/
cp -rf openwrt-packages/luci-app-aria2/ need/

cp -rf openwrt-packages/gowebdav/ need/
cp -rf openwrt-packages/luci-app-gowebdav/ need/

#添加edge主题
cp -rf openwrt-packages/luci-theme-edge/ need/
#Add Pushbot
cp -rf openwrt-packages/luci-app-pushbot/ need/

# Add OpenClash
git clone --depth=1 -b master https://github.com/vernesong/OpenClash

git clone --depth=1 https://github.com/hx210/luci-app-netdata




# cp -rf openwrt-packages/luci-app-openclash/ need/

# Add luci-app-passwall
# git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall



rm -rf openwrt-packages/
popd

# Mod zzz-default-settings
# pushd package/lean/default-settings/files
# sed -i '/http/d' zzz-default-settings
# sed -i '/18.06/d' zzz-default-settings
# export orig_version=$(cat "zzz-default-settings" | grep DISTRIB_REVISION= | awk -F "'" '{print $2}')
# export date_version=$(date -d "$(rdate -n -4 -p ntp.aliyun.com)" +'%Y-%m-%d')
# sed -i "s/${orig_version}/${orig_version} (${date_version})/g" zzz-default-settings
# sed -i "s/OpenWrt /R @ OpenWrt /g" zzz-default-settings
#        # 增加个性名字${Author}默认为你的github账号

# sed -i '/CYXluq4wUazHjmCDBCqXF/d' zzz-default-settings                                                            # 设置密码为空

# popd



# Use snapshots' syncthing package
pushd feeds/packages/utils
rm -rf syncthing
svn co https://github.com/openwrt/packages/trunk/utils/syncthing
popd



