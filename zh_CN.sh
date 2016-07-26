#!/bin/bash
# linux中文包安装脚本
# 版本:V1.0
# 作者:Z&T
# 时间:2016-03-13
# MyQQ:3034557307


line(){
echo "============================="
}
line
echo "Chinese Language Script by Z&T"

locale-gen zh_CN.UTF-8
locale-gen zh_CN.GB18030
locale-gen zh_CN.GB2312

echo '# Change by ZT\nLANG="zh_CN.UTF-8″\nLANGUAGE="zh_CN:zh:en_US:en"' > /etc/environment

echo "# Change by ZT\nzh_CN.UTF-8 UTF-8\nen_US.UTF-8 UTF-8\nzh_CN.GBK GBK" > /var/lib/locales/supported.d/local

echo '# Change by ZT\nLANG="zh_CN.UTF-8″\nLANGUAGE="zh_CN:zh"' > /etc/default/locale

echo "Change is OK!"

locale-gen

line
echo "* 如果仍然无法显示中文,请安装中文语言包"
echo "* apt-get install language-pack-zh"
echo "* 若脚本报错请联系我："
echo "* QQ：3034557307"
line
reboot
