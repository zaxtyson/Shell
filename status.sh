#!/system/bin/sh

# 此脚本是按照一台安卓2.3.6，可同时打开WIFI和AP热点的古董机设计的，用于WiFi中继(ಥ_ಥ)
# 不保证任何手机都能执行
# 虚拟硬件信息请按照自己的手机手动修改
# 一般去/sys/class/power_supply/下面找
# 脚本目前支持显示硬件信息、电池状态、网络情况、AP热点连接、ADB调试等等
# 还要什么功能，自己写吧

# 设置变量
dc='/sys/class/power_supply/battery'
line="===================="

## 以下为函数库 ##
title(){
echo ""
echo $line
echo -e "\e[1;45;37m$1\e[0m"
echo $line
}
getBattery(){
echo "$1$(cat $dc/$2)$3"
}
getValue(){
value=$(($(cat $dc/$2)/$3))
printf "%s%.1f%s\n" "$1" "$value" "$4"
}
getStatu(){
getprop | grep $2 | sed "s/\[//g;s/\]//g;s/$2/$1/;s/running/$3/;s/stopped/$4/"
}
getWlan0(){
echo -n "$1"
ifconfig wlan0 | grep -E "$2" | sed 's/(//g;s/)//g' | awk '{ print $'$3',"'$4'"}'
}


### 程序主体 ###

clear

title "    设备硬件信息    "
getStatu 设备名 ro.build.id  
getStatu 安卓版本 ro.build.version.release  
getStatu 序列号 ro.serialno  
getStatu LCD密度 ro.sf.lcd_density  
getStatu 屏幕分辨率 persist.sys.screen.size  

title "    电池状态信息    "
getBattery 电池状态： status
getBattery 电池技术： technology
getBattery 健康状况： health
getBattery 电池电量： capacity %
getValue 电池温度： batt_temp 10 ℃
getBattery 电池电压： batt_vol mV
getBattery 充电电压： ChargerVoltage mV
getBattery 充电电流： BatteryAverageCurrent mA

title "    网络连接信息   "
getStatu WiFi网卡 wifi.interface
getStatu WiFi状态 init.svc.wpa_supplicant WiFi已打开 WiFi已关闭
getStatu 网络连接 init.svc.dhcpcd_wlan0 已连接到互联网 无可用WiFi网络
getWlan0 下载流量： "RX bytes" 3 MB
getWlan0 上传流量： "TX bytes" 7 MB

if [ $(getprop init.svc.dhcpcd_wlan0) == "running" ];then

# 网络延迟测试（ping baidu）
echo -n "网络延迟："
ping -c 3 www.baidu.com | grep 'round-trip' | awk -F '/' '{print $4,"ms"}'

# 网速测试模块
date1=$(date +%s)
wget http://c.jouyo.cn/MT2.0.2.apk -P /sdcard/ >> /dev/null 2>&1
date2=$(date +%s)
time=$(($date2-$date1))
speed=$((3406/$time))
echo "当前网速：$speed kb/s"
rm /sdcard/MT2.0.2.apk

# 以tree的方式显示arp结果
users=$(arp | grep -v '192.168.0.1' | wc -l)
arp | grep -v '192.168.0.1' | sed 's/(//g;s/)//g;s/at/==>/g;s/\[.*//g' > /sdcard/a.xml
echo "WiFi中继：已启动"
echo "用户数量：$users"
echo "连接详情：+-----用户IP地址------用户MAC地址------、"
sum=0
cat /sdcard/a.xml | while read line
do
sum=$((sum+1))
if [ $sum -eq $users ];then
   echo $line | sed 's/?/          \`-/'
   break
fi
echo $line | sed 's/?/          \|-/'
done
rm /sdcard/a.xml

getStatu "网卡PID " dhcp.wlan0.pid
getWlan0 "MAC地址 ：" HWaddr 5
getStatu "IP地址  " dhcp.wlan0.ipaddress
getWlan0 IPv6地址： inet6 3
getStatu 网关地址 dhcp.wlan0.gateway
getStatu 子网掩码 dhcp.wlan0.mask
getStatu "DNS1    " net.dns1
getStatu "DNS2    " net.dns2
fi

getStatu "ADB状态 " init.svc.adbd 远程ADB已启动 ADB进程未启动
getStatu "ADB端口 " service.adb.tcp.port
