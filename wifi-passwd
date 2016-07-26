#!/system/bin/sh

# WiFi密码查看脚本
# 脚本：wifi.sh
# 版本：V1.2.1
# 作者：Z&T
# 时间：2016-01-05
# MyQQ：3034557307


# 函数库
function ech(){
echo -n "\n * $1"
sleep 0.3
}

# 清屏，程序开始
clear
echo -e " \e[1;44m== WIFI数据解析脚本 ==\e[0m"
echo ""

# 判断当前用户是否拥有root权限(不一定是root用户)
ls /data >/dev/null 2>&1
if [ "$?" -eq "1" ];then
echo " ********************"
echo -e " \e[1;37;41m  请切换至ROOT用户！\e[0m"
echo " ********************"
echo ""
exit 0
fi

# 定义变量
wifi_info="/sdcard/WiFi信息.txt"
wifi_old="/data/misc/wifi/wpa_supplicant.conf"
wifi_new="/sdcard/wifi.xml"
date=`date "+%Y-%m-%d %H:%M"`

# 复制wifi数据文件
cat $wifi_old > $wifi_new

# 打印版权信息
echo "====== WiFi数据解析脚本 ======\n\n作者：Z&T\nMyQQ：3034557307\n时间：$date\n如有异常，请联系我\n\n====== WiFi解析结果如下 ======\n\n" > $wifi_info

# 数据信息格式化
sed 's/[[:blank:]]//g' < $wifi_new | grep -E '^ssid|^psk|^key_mgmt|}' | sed 's/ssid=/================================\n网络名称：/;s/psk=/连接密码：/;s/key_mgmt=/加密方式：/;s/NONE/开放网络/;s/"//g;s/}/================================\n/g' >> $wifi_info

# 删除临时文件
rm $wifi_new

# 打印wifi信息
ech "开始解析WiFi信息..."
ech "数据解析已完成"
ech "文件保存在SD卡根目录下"
ech "文件名为\"WiFi信息.txt\""
ech "你可以使用文件管理器查看"
ech "按回车键在屏幕上打印WiFi信息"

read input
if [ -z $input ]
then
clear
cat $wifi_info
else
echo 已取消操作
fi
