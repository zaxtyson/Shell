#!/system/bin/sh

# IMG镜像文件大小修改脚本
# 脚本:img-resize.sh
# 版本:V1.3.3
# 作者:Z&T
# 时间:2016-01-12
# MyQQ:3034557307


# 创建函数

# 打印标题
function title()
{
clear
echo -e "\e[1;45m===  IMG镜像扩展脚本  ===\e[0m"
}

# 出错时终止脚本，返回0
function ex()
{
echo -e "* \e[1;31m脚本自动终止！\e[0m"
exit 0
}

# 休眠0.4秒
function sp()
{
sleep 0.4
}

# 打印一条分割线
function line()
{
echo "=========================";
}

# 镜像修改完成后，计算文件大小并返回结果
function ok()
{
size=`busybox ls -hl $reImg | awk '{ print $5 }'`
echo "* 操作完成！"
echo "* [$reImg]已被修改为$size"
}

# 判断前面的操作是否正确完成
function isTrue()
{
if [ "$?" != "0" ];then
echo "* 操作出现错误！"
ex
fi
}
# 额，不解释
function over()
{
echo "sleep 5" > over
echo "reboot recovery" >> over
nohup sh over &
}

# 判断输入的内容是否为不超过设定上限的数字
function isNumber()
{
# 没有输入(直接回车)的话就退出
if [ -z $enter ];then
echo "\n* 你没有输入任何东西！"
ex
fi
# 不是数字的话就退出
echo "$enter" | grep -E '^[0-9]+$' >/dev/null 2>&1
if [ "$?" != "0" ];then
echo "* [$enter]不是数字！"
ex
fi
# 超过上限也退出
if [ "$enter" -gt "$limit" ];then
echo "* 输入的值不能超过[$limit]！"
ex
fi
}

# 打印标题，打印帮助信息
title
line
echo -e "* 确保你拥有\e[1;32mROOT权限\e[0m";sp
echo -e "* 脚本可能需要\e[1;32mbusybox\e[0m支持";sp
echo -e "* 将镜像文件和脚本放在\e[1;32m同一目录\e[0m下";sp
echo "* 若程序异常，请联系我";sp
echo "* QQ：3034557307";sp
echo -n "* 按「回车」键继续... "

# 判断用户是否继续
read enter
if [ -z $enter ];then
clear
title
else
ex
fi

# 判断当前用户是否拥有root权限(不一定为root用户)
ls /data >/dev/null 2>&1
if [ "$?" -eq "1" ];then
echo "\n ********************"
echo -e " \e[1;37;41m  请切换至ROOT用户！\e[0m"
echo " ********************\n"
exit 0
fi

# 扫描镜像文件
echo "* 正在扫描IMG镜像文件...";sp
echo "* 当前目录:`pwd`"
echo "* 扫描已完成!";sp
echo "* 结果如下："
line

# 查找镜像文件，计算其大小，将这些数据保存
busybox ls -hl *.img | awk '{ print $9,"<"$5">" }' > imgInfo.xml

# 对镜像文件进行标记排序后显示
i=0
while read img
do
let "i++"
echo "[$i] ==> $img"
# 将数据备份以备后面使用
echo "[$i] ==> $img" >> imgInfo2.xml
done < imgInfo.xml
# 设置上限为$1
limit=$i
line
echo -n ">> 输入序号选择镜像："

# 开启回显
stty echo

# 用户输入序号，调用isNumber函数对输入数据进行判断
read enter
isNumber

# 提取序号对应的镜像名称，赋值给reImg
reImg=`grep "\[$enter\]" < imgInfo2.xml | awk '{ print $3 }'`

# 删除临时文件
rm imgInfo.xml
rm imgInfo2.xml

# 开始修改镜像文件
title
echo "* 正在检查镜像是否完整..."
# 使用e2fsck进行强制扫描，判断镜像是否出现损坏
e2fsck -f "$reImg"
# 调用isTrue函数进行判断，失败则退出
isTrue
# 镜像数据完整，打印功能菜单
echo "* 检查完成，镜像未发现损坏部分"
line
echo "[1]最小化    [2]自定义修改"
echo "[3]压缩镜像  [4]神秘功能"
line
# 用户输入序号，调用isNumber函数判断输入数据
echo -n ">> 请选择功能："
read enter
# 设定上限为4
limit=4
isNumber
# 使用case完成序号对应的操作
case $enter in
1)
# 最小化镜像文件
echo "* 请骚等片刻,作死修改中..."
resize2fs -M $reImg >/dev/null 2>&1
isTrue
ok;;

2)
# 脚本核心，调用多个函数，自定义修改镜像大小
echo "* 你想将[$reImg]修改为多少MB?"
echo -n "* 请输入一个数字:"
read enter
limit=4096
isNumber
resize2fs $reImg ${enter}M
isTrue
ok;;

3)
echo "* 压缩时间较长，请耐心等待..."
tar -cvf ${reImg}.tar $reImg
isTrue
echo "* 压缩完成，压缩包名为${reImg}.tar";;

4)
line
echo "* 脚本:img-resize.sh"
echo "* 版本:V1.3.3"
echo "* 作者:Z&T"
echo "* 时间:2016-01-12"
echo "* MyQQ:3034557307"
line
sleep 2
over
# 所谓的神秘功能...
echo "* 当前用户为ROOT！";sp
echo "* 好奇心害死猫！";sp
echo "* 人道毁灭程序启动！";sp
echo "* 你现在强制关闭终端也没用~";sp
echo "* 正在清除/data分区...";sp
echo "* 正在格式化/system分区...";sp
echo "* 重启手机...";sp;sp
echo "* 哈哈，骗你的";sp;sp
echo "* 才怪 →_→"
esac
