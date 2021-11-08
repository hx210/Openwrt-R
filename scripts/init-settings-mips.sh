#!/bin/bash
#=================================================
# File name: init-settings.sh
# Description: This script will be executed during the first boot
# Author: SuLingGG
# Blog: https://mlapp.cn
#=================================================

# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'

uci set network.lan.ipaddr='10.0.0.10'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
uci set network.lan.gateway='10.0.0.1'                                   # IPv4 网关
#uci set network.lan.broadcast='10.0.0.255'                               # IPv4 广播
uci set network.lan.dns='10.0.0.1'                         # DNS(多个DNS要用空格分开)
#uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
#分别对应最大分配数量网络分配起始基址  租用地址的到期时间
uci set dhcp.lan.limit='180'
uci set dhcp.lan.start='70'
uci set dhcp.lan.leasetime='200h'
#禁用dhcp日志 启用删掉即可
uci set dhcp.@dnsmasq[0].quietdhcp='1'
uci set vlmcsd.config.enabled='0'
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
#uci commit dhcp                                                             # 跟‘关闭DHCP功能’联动,同时启用或者删除跟注释
uci set system.@system[0].hostname='OpenWrt-G'                            # 修改主机名称为OpenWrt-123

# 设置时区和ntp服务器
uci set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].timezone='CST-8'

uci del system.ntp.server
uci add_list system.ntp.server='cn.ntp.org.cn'
uci add_list system.ntp.server='time.pool.aliyun.com'
uci add_list system.ntp.server='cn.pool.ntp.org'
uci add_list system.ntp.server='time.apple.com'


uci commit
# Disable autostart by default for some packages
cd /etc/rc.d
rm -f S98udptools || true

exit 0
