
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
    echo -e "\trtools docker: 一键配置docker 配置保存在opt下载保存在opt1\n"    
    echo -e "\trtools uhttpssl: 将证书放在/etc/ssl/ 分别命名为 Rssl. crt/key \n"    

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
    
elif [[ $1 = "docker" ]]; then
    echo -e "${Green_font_prefix}\n正在安装netdata...\n${Font_color_suffix}"
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
  -e TZ=Asia/Shanghai \
  --restart unless-stopped \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata:stable
    echo -e "${Green_font_prefix}\n正在配置自动更新镜像...\n${Font_color_suffix}"    
    docker run -d \
        --name watchtower \
        --restart unless-stopped  \
        -e TZ=Asia/Shanghai \
        -v /var/run/docker.sock:/var/run/docker.sock \
        containrrr/watchtower \
        --cleanup \
        -s "0 0 2 * * *"   
    echo -e "${Green_font_prefix}\n正在配置在线网盘...\n${Font_color_suffix}" 
    cat <<EOF > /etc/systemd/system/docker.service.d/clear_mount_propagation_flags.conf
[Service]
MountFlags=shared
EOF
    mount --make-shared /opt1
    sed -i '3i mount --make-shared /opt1' /etc/rc.local        
    docker run -d \
        --name clouddrive \
        --restart unless-stopped \
        --env FuseUID=0 --env FuseGID=0\
        -v /opt1/CloudNAS:/CloudNAS:shared \
        -v /opt/data/docker/CloudNAS:/Config \
        -p 9798:9798 \
        --privileged \
        --device /dev/fuse:/dev/fuse \
        -e TZ=Asia/Shanghai \  
        cloudnas/clouddrive    
    echo -e "${Green_font_prefix}\n安装成功请从netdata从ip:29999访问 在线网盘从9798\n${Font_color_suffix}"

elif [[ $1 = "uhttpssl" ]]; then
    uci set uhttpd.main.cert='/etc/ssl/Rssl.crt'
    uci set uhttpd.main.key='/etc/ssl/Rssl.key'
    /etc/init.d/uhttpd restart
    echo -e "${Green_font_prefix}ssl配置成功.\n${Font_color_suffix}"
    
    
fi

exit 0
