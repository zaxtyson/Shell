#!/system/bin/sh

# 以tree的方式显示arp结果，自个手机用用
# 其他用途请使用专业的nmap扫描器

# 得到用户数量，排除路由器
users=$(arp | grep -v '192.168.0.1' | wc -l)

# 格式化输出结果到a.xml
arp | grep -v '192.168.0.1' | sed 's/(//g;s/)//g;s/at/==>/g;s/\[.*//g' > /sdcard/a.xml

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
