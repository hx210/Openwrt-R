# Set default theme to luci-theme-argon
uci set luci.main.mediaurlbase='/luci-static/argon'

uci set network.lan.ipaddr='10.0.0.1'                                    # IPv4 地址(openwrt后台地址)
uci set network.lan.netmask='255.255.255.0'                                 # IPv4 子网掩码
#uci set network.lan.gateway='10.0.0.1'                                   # IPv4 网关
#uci set network.lan.broadcast='10.0.0.255'                               # IPv4 广播
uci set network.lan.dns='10.0.0.1'                         # DNS(多个DNS要用空格分开)
#uci set network.lan.delegate='0'                                            # 去掉LAN口使用内置的 IPv6 管理
                                                        # 不要删除跟注释,除非上面全部删除或注释掉了
#uci set dhcp.lan.ignore='1'                                                 # 关闭DHCP功能
uci set system.@system[0].hostname='OpenWrt-R'

#网络加速 启用bbr和fullnat
uci set turboacc.config.sfe_flow='0'
uci set turboacc.config.hw_flow='0'
uci set turboacc.config.fullcone_nat='1'
uci set turboacc.config.bbr_cca='1'
uci set turboacc.config.sw_flow='0'



#分别对应最大分配数量网络分配起始基址  租用地址的到期时间
uci set dhcp.lan.limit='180'
uci set dhcp.lan.start='70'
uci set dhcp.lan.leasetime='200h'
#禁用dhcp日志 启用删掉即可
uci set dhcp.@dnsmasq[0].quietdhcp='1'
#启用upnp
uci set upnpd.config.enabled='1'
#关闭kms
uci set vlmcsd.config.enabled='0'

#开启uhttpd的外网访问
uci set uhttpd.main.rfc1918_filter='0'
# /etc/init.d/uhttpd restart

# 设置时区和ntp服务器
uci set system.@system[0].zonename='Asia/Shanghai'
uci set system.@system[0].timezone='CST-8'

uci del system.ntp.server
uci add_list system.ntp.server='cn.ntp.org.cn'
uci add_list system.ntp.server='time.pool.aliyun.com'
uci add_list system.ntp.server='cn.pool.ntp.org'
uci add_list system.ntp.server='time.apple.com'


uci commit

# Disable opkg signature check
sed -i 's/option check_signature/# option check_signature/g' /etc/opkg.conf

# Disable autostart by default for some packages
cd /etc/rc.d
rm -f S98udptools || true

exit 0
