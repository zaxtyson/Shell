#！/system/bin/sh
# 本脚本用于魅族MX4Pro
# 本脚本需要ROOT权限
# CPU和GPU满频时会很烫，慎重使用

########### 环境变量设置 ###########
# CPU频率设置
# A7包括了0-3号四个Cortex-A7 CPU 频率0.5-1.5GHz
# A15包括4-7号四个Cortex-A15 CPU 频率0.8-2.0GHz
# 频率以KHz为单位，1Ghz=1000000
A7_MAX="/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq"
A7_MIN="/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq"
A15_MAX="/sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq"
A15_MIN="/sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq"

# A15四核设置
# 0表示开启   1表示关闭
HPS="/sys/power/hps_enabled"

# 电源模式
# low normal high
POWER="/sys/power/power_mode"

# CPU锁频模式
# 0表示开启  1表示关闭
A7_LOCK="/sys/devices/system/cpu/cpu0/cpufreq/interactive/enforced_mode"
A15_LOCK="/sys/devices/system/cpu/cpu4/cpufreq/interactive/enforced_mode"
 
# GPU频率设置
# 型号:Mali-T628   频率:0-600MHz
# 频率以MHz为单位
GPU_MAX="/sys/devices/14ac0000.mali/dvfs_max_lock"
GPU_MIN="/sys/devices/14ac0000.mali/dvfs_min_lock"

# GPU频率模式
# 0为默认   1为静态(锁定频率)   2为自动超频
GPU_MOD="/sys/devices/14ac0000.mali/dvfs_governor"
 
# 当前模式记录
LOG="/system/cpu.log"
########### 环境变量结束 ###########


########### 函数模块开始 ##########
echoo(){
echo -e ">\e[1;32m $1\e[0m"
sleep 0.5
}

# gpu 频率模式 最低频率 最高频率
# 频率模式 0为默认  1为静态(锁定频率)   2为动态(自动调整) 频率范围0-600(MHz)
gpu(){
echo $1 > $GPU_MOD
echo $3 > $GPU_MAX
echo $2 > $GPU_MIN
}

# 锁频模式 最低频率 最高频率
# 锁频模式: 0表示开启  1表示关闭
# 频率范围:500000-1500000(KHz)
a7_cpu(){
echo $1 > $A7_LOCK
echo $3 > $A7_MAX
echo $2 > $A7_MIN
}

# A15CPU总开关
# 0表示开启  1表示关闭
a15_switch(){
if [ $1 -eq 0 ];then
echo "normal" >$POWER
echo "0">$HPS
else
echo "low" >$POWER
echo "1" >$HPS
fi
}

# 锁频模式 最低频率 最高频率
# 锁频模式: 0表示开启  1表示关闭
# 频率范围:800000-2000000(KHz)
a15_cpu(){
echo $1 > $A15_LOCK
echo $3 > $A15_MAX
echo $2 > $A15_MIN
}

only4cpu(){
echoo "启动四核模式..."
echo "四核模式" >$LOG
echoo "Mali T-628: 0-420MHz"
gpu 0 0 420
echoo "Cortex A7 : 0.5-1.5GHz"
a7_cpu 1 500000 1500000
echoo "Cortex A15: 停止运行"
a15_switch 1
}

start8cpu(){
echoo "启动性能模式..."
echo "性能模式" >$LOG
echoo "Mali T-628: 0-600MHz..."
gpu 2 0 600
echoo "Cortex A7: 0.5-1.5GHz"
a7_cpu 1 500000 1500000
echoo "Cortex A15: 0.8-2.0GHz"
a15_switch 0
echo "high" >$POWER
a15_cpu 1 800000 2000000
}

fly(){
echoo "启动狂热模式..."
echo "狂热模式">$LOG
echoo "Mali T-628: 锁定600MHz"
gpu 1 600 600
echoo "Cortex A7 : 锁定1.5GHz"
a7_cpu 0 1500000 1500000
echoo "Cortex A15: 锁定2.0GHz"
a15_switch 0
echo "high" >$POWER
a15_cpu 0 2000000 2000000
}

save_power(){
echoo "启动极限省电模式..."
echo "极限省电">$LOG
echoo "Mali T-628: 0-300MHz"
gpu 0 0 300
echoo "Cortex A7 : 锁定0.5GHz"
a7_cpu 0 500000 500000
echoo "Cortex A15: 停止运行"
a15_switch 1
}

########### 函数模块结束 ###########

if [ ! -w $HPS ];then
echoo "请切换至ROOT用户"
exit
fi
mount -o remount,rw /system
if [ ! -f  $LOG ]
then
touch $LOG
echo "未设置模式"  >$LOG
fi

while [ 1 ]
do
 clear
	echo -e "\t#########################"
	echo -e "\t#  魅族MX4 Pro超频脚本  #"
	echo -e "\t#########################\n"
	echo -e "\t[1]极限省电\t[2]四核模式\n\t[3]性能模式\t[4]狂热模式\n"
	echo -n "当前模式 "
	echoo "$(cat $LOG)"
	echo -n "选择功能:"
	read -n 1 x
	echo ""
	case $x in
	1)save_power
;;
2)only4cpu
;;
3)start8cpu
;;
4)fly
;;
q)exit 0
;;
*)echo -e ">\e[1;31m 输入错误！按q退出\e[0m";sleep 1
;;
esac
done
