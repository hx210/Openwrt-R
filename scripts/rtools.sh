
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"
INFO="[${Green_font_prefix}INFO${Font_color_suffix}]"
ERROR="[${Red_font_prefix}ERROR${Font_color_suffix}]"

Welcome(){
    echo -e "${Green_font_prefix}\n此工具将帮你完成基本配置.\n${Font_color_suffix}"
    echo -e "Example:"
    echo -e "\trtools uhttpd: 切换为uhttpd"
    echo -e "\trtools nginx: 切换为nginx\n"
    echo -e "\trtools ipv6wanstart: 启用ipv6\n"
    echo -e "\trtools ipv6wanstop: 关闭ipv6\n"

    # echo -e "Optional Usage:"
    # echo -e "\trtools server: "
    # echo -e "\trtools relay: "
    # echo -e "\trtools hybird: "
    # echo -e "\trtools clean: Remove mwan3 modules\n"
}

RebootConfirm(){
    echo -n -e "${Green_font_prefix}需要重启 立刻 [y/N] (default N)? ${Font_color_suffix}" 
    read answer
        case $answer in
            Y | y)
            echo -e "重启中...\n" && reboot;;
            *)
            echo -e "bye.\n";;
        esac
}
        
Applychanges(){
    uci commit
    echo -e "${Green_font_prefix}应用成功.\n${Font_color_suffix}"

       
}

Shaodeng(){

    echo -e "${Green_font_prefix}\n稍等片刻.\n${Green_font_prefix}"

}

if [ $# == 0 ];then
    Welcome

elif [[ $1 = "uhttpd" ]]; then
    /etc/init.d/nginx stop
    /etc/init.d/nginx disable
    /etc/init.d/uhttpd enable
    /etc/init.d/uhttpd start
    echo -e "${Green_font_prefix}\n配置uhttpd成功\n${Font_color_suffix}"

    

    
elif [[ $1 = "nginx" ]]; then
    Shaodeng
    
    /etc/init.d/uhttpd stop
    /etc/init.d/uhttpd disable
    /etc/init.d/nginx enable
    /etc/init.d/nginx start
    
    echo -e "${Green_font_prefix}配置nginx成功.\n${Font_color_suffix}"
    

    
elif [[ $1 = "ipv6wanstart" ]]; then
    Shaodeng
    
    # 限制接口为wan和lan且wan为拨号
    uci set network.wan.ipv6='auto'
    uci set dhcp.lan.ra='server'
    uci set dhcp.lan.dhcpv6='server'
    uci set dhcp.lan.ra_management='1'
    uci set dhcp.lan.ra_default='1'
        
    Applychanges
    
elif [[ $1 = "ipv6wanstop" ]]; then
    Shaodeng
    
    uci set network.wan.ipv6='0'
    uci delete dhcp.lan.ra
    uci delete dhcp.lan.dhcpv6
    uci delete dhcp.lan.ra_management
    uci delete dhcp.lan.ra_default
    
  
    Applychanges
    
# elif [[ $1 = "remove" ]]; then
#     echo -e "${Green_font_prefix}\nRemove IPV6 modules...\n${Font_color_suffix}"
#     opkg remove --force-removal-of-dependent-packages ipv6helper kmod-sit odhcp6c luci-proto-ipv6 ip6tables kmod-ipt-nat6 odhcpd-ipv6only kmod-ip6tables-extra
#     echo -e "${Green_font_prefix}\nIPV6 modules remove successfully.\n${Font_color_suffix}"
#     echo -e "${Green_font_prefix}Revert IPV6 configurations...\n${Font_color_suffix}"
    
#     # Remove wan6 dhcp configurations
#     uci delete dhcp.wan6.ra
#     uci delete dhcp.wan6.dhcpv6
#     uci delete dhcp.wan6.ndp
    
#     # Remove lan dhcp configurations
#     uci delete dhcp.lan.dhcpv6
#     uci delete dhcp.lan.ndp
#     uci delete dhcp.lan.ra
#     uci delete dhcp.lan.ra_management
#     uci delete dhcp.lan.ra_default
    
#     # Enable IPV6 ula prefix
#     sed -i 's/#.*\toption ula/\toption ula/g' /etc/config/network
    
#     # Disable IPV6 dns resolution
#     uci set dhcp.@dnsmasq[0].filter_aaaa=1
    
#     # Restore mwan3 balance strategy
#     uci set mwan3.balanced.last_resort=unreachable
    
#     # Commit changes
#     uci commit
    
#     # Restore mwan3 ip6tables rules
#     rm /lib/mwan3/mwan3.sh
#     cp /lib/mwan3/mwan3.sh.orig /lib/mwan3/mwan3.sh
    
#     rm -f /etc/opkg/ipv6-installed
    
#     echo -e "${Green_font_prefix}IPV6 remove successfully.\n${Font_color_suffix}"
    
#     RebootConfirm
    
# elif [[ $1 = "clean" ]]; then
#     echo -e "${Green_font_prefix}\nRemove mwan3 modules...\n${Font_color_suffix}"
#     opkg remove mwan3 luci-app-mwan3 luci-app-mwan3helper luci-app-syncdial
#     echo -e "${Green_font_prefix}Mwan3 modules remove successfully.\n${Font_color_suffix}"
    
#     RebootConfirm
    
fi

exit 0
