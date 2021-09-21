
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
    echo -e "\trtools netdata: 安装实时监控netdata\n"    

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
    
elif [[ $1 = "netdata" ]]; then
    echo -e "${Green_font_prefix}\n安装netdata...\n${Font_color_suffix}"
    docker run -d --name=netdata \
  -p 29999:19999 \
  -v netdataconfig:/etc/netdata \
  -v netdatalib:/var/lib/netdata \
  -v netdatacache:/var/cache/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata
    echo -e "${Green_font_prefix}\n安装成功请从ip:29999访问...\n${Font_color_suffix}"
    
# elif [[ $1 = "clean" ]]; then
#     echo -e "${Green_font_prefix}\nRemove mwan3 modules...\n${Font_color_suffix}"
#     opkg remove mwan3 luci-app-mwan3 luci-app-mwan3helper luci-app-syncdial
#     echo -e "${Green_font_prefix}Mwan3 modules remove successfully.\n${Font_color_suffix}"
    
#     RebootConfirm
    
fi

exit 0
