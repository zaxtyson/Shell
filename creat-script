# 自解压脚本生成脚本
# 版本:V1.0
# 作者:Z&T
# 时间:2016-07-26
# MyQQ:3034557307


# 计算引导脚本长度
length=$(wc -l $1 | awk '{print $1}')

# 下面是将提取文件的脚本写入ok.sh的代码
# 为了适应linux和android，所以这里没写#!/bin/bash或者#!/system/bin/sh

# 计算ok.sh自身的长度
echo "length_ok=\$(wc -l \$0 | awk '{print \$1}')">ok.sh

# 压缩包的数据长度 = ok.sh的长度 - 引导脚本的长度 - 文件提取脚本的长度 + 1 
# 由于使用tail命令的缘故，必须+1，否则将导致一行压缩文件的数据丢失，而使解压失败
echo "length_ok=\$((\$length_ok-$length-3+1))">>ok.sh

# 从总数据流中截取压缩文件的数据，然后将其解压
echo "tail -n \$length_ok \$0 | tar -zx">>ok.sh

# 打印帮助信息
echo "自解压脚本生成工具v1.0  by Z&T\n"
echo "用法：sh make.sh [引导脚本]"
echo "* 引导脚本就是你原本打算执行的脚本"
echo "* 引导脚本第一行不要写#!/bin/bash"
echo "* 引导脚本最后一行必须为exit"
echo "* 请将所需的文件放到当前路径下的data目录中"
echo -n "* 回车开始制作...  "
read input
if [ -z $input ];then
# 压缩data文件夹
tar -zcf data.tar.gz ./data
# 将引导脚本和压缩包写入ok.sh
cat $1 data.tar.gz>>ok.sh
# 删除刚才临时创建的压缩文件
rm data.tar.gz
echo "\n* 自解压脚本制作完成，名称为ok.sh"
else
echo "* 操作已取消！"
fi
