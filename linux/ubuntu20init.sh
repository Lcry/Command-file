#!/bin/bash
# 食用方法: bash ubuntu20init.sh
# Ubuntu20.x生产环境优化脚本:
# 设置hostname
# 设置sshd修改默认端口
# 优化内核参数
# 设置时区为 Asia/Shanghai
# 切换阿里源
# 关闭防火墙和Selinux
# 关闭swap
# 设置 alias
# 安装 docker
# 安装 docker compose
# 处理dns
# by lcry @ https://github.com/lcry

# 检查是否为root用户，脚本必须在root权限下运行
if [ "$(whoami)" != "root" ]; then
    echo "please run this script as root !" >&2
    exit 1
fi

echo -e "\033[31m The script only Support Ubuntu20.X.86_64 \033[0m"
echo -e "\033[31m System initialization script, Please Seriously. Press Ctrl+C to cancel \033[0m"

# 检查是否为64位系统，这个脚本只支持64位脚本
platform=`uname -i`
if [ $platform != "x86_64" ];then
    echo "this script is only for 64bit Operating System !"
    exit 1
fi

# 开始初始化
cat << EOF
+---------------------------------------+
|   Your system is $(lsb_release -i --short)$(lsb_release -r --short) $(uname -m)   |
|           start optimizing            |
+---------------------------------------+
EOF
sleep 1

# 设置主机名
set_hostname(){
echo "1. 设置hostname"
currentHostname=$(hostname)
echo "当前hostname：$currentHostname"
read -p "请输入hostname(直接回车不修改)：" hostname
if [ -z "${hostname}" ];then
    hostname=$currentHostname
fi
hostnamectl set-hostname $hostname
}

# 设置sshd免密登录 修改默认端口为22122
set_sshd(){
echo "2. 设置sshd"
## 若不存在则先备份一下
if [ ! -f "/etc/ssh/sshd_config.backup" ]; then
  cp -ra /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
fi
ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
sed -i -e 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' \
-e 's/PasswordAuthentication yes/PasswordAuthentication yes/' \
-e 's/#Port 22/Port 22122/' \
-e 's/#ClientAliveInterval 0/ClientAliveInterval 60/' \
-e 's/#ClientAliveCountMax 3/ClientAliveCountMax 30/' /etc/ssh/sshd_config
service sshd restart
read -p "请输入免密登录公钥：" pubkey
cat > ~/.ssh/authorized_keys <<EOF
$pubkey
EOF
}

# 安装必要支持工具及软件工具
apt_tools(){
apt install -y git nmap zip unzip wget vim lsof net-tools ntpdate policycoreutils subversion lrzsz curl
}

# 设置时区
set_timezone(){
timedatectl set-timezone Asia/Shanghai
/usr/sbin/ntpdate 0.cn.pool.ntp.org > /dev/null 2>&1
/usr/sbin/hwclock --systohc
/usr/sbin/hwclock -w
cat > /var/spool/cron/root << EOF
10 0 * * * /usr/sbin/ntpdate 0.cn.pool.ntp.org > /dev/null 2>&1
* * * * */1 /usr/sbin/hwclock -w > /dev/null 2>&1
EOF
chmod 600 /var/spool/cron/root
/etc/init.d/cron restart
sleep 1
}

# 修改资源限制
linux_optimize1(){
mv /etc/security/limits.conf /etc/security/limits.conf.bak
cat >/etc/security/limits.conf<<EOF
#其他账户的资源软限制和硬限制
*       soft        core        unlimited
*       hard        core        unlimited
*       soft        nproc       1000000
*       hard        nproc       1000000
*       soft        nofile      1000000
*       hard        nofile      1000000
*       soft        memlock     32000
*       hard        memlock     32000
*       soft        msgqueue    8192000
#root账户的资源软限制和硬限制
root       soft        core        unlimited
root       hard        core        unlimited
root       soft        nproc       1000000
root       hard        nproc       1000000
root       soft        nofile      1000000
root       hard        nofile      1000000
root       soft        memlock     32000
root       hard        memlock     32000
root       soft        msgqueue    8192000
EOF

}

# 内核参数 各大参数参考:https://help.aliyun.com/document_detail/41334.html
linux_optimize2(){
mv /etc/sysctl.conf /etc/sysctl.conf.backup
cat >/etc/sysctl.conf<<EOF

# Controls source route verification
net.ipv4.conf.default.rp_filter = 1
net.ipv4.ip_nonlocal_bind = 1
net.ipv4.ip_forward = 1

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0

# Controls the System Request debugging functionality ofthe kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1

# Disable netfilter on bridges.
#net.bridge.bridge-nf-call-ip6tables = 0
#net.bridge.bridge-nf-call-iptables = 0
#net.bridge.bridge-nf-call-arptables = 0

# Controls the default maxmimum size of a mesage queue
kernel.msgmnb = 65536

# # Controls the maximum size of a message, in bytes
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# # Controls the maximum number of shared memory segments,in pages
kernel.shmall = 4294967296

# TCP kernel paramater
net.ipv4.tcp_mem = 786432 1048576 1572864
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1

# socket buffer
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 20480
net.core.optmem_max = 81920

# TCP conn
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15

# tcp conn reuse
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tw_reuse = 0
#Linux 从4.12内核版本开始移除了 tcp_tw_recycle 配置
#net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_max_tw_buckets = 20000
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syncookies = 1

# keepalive conn
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.ip_local_port_range = 10001 65000
EOF

}

# 修改镜像源
update_mirror(){
cp -ra /etc/apt/sources.list /etc/apt/sources.list.backup
sed -i -e 's#http://cn.archive.ubuntu.com/ubuntu#http://mirrors.aliyun.com/ubuntu#' \
-e 's#http://mirrors.tencentyun.com/ubuntu#http://mirrors.aliyun.com/ubuntu#' \
-e 's#http://repo.huaweicloud.com/ubuntu#http://mirrors.aliyun.com/ubuntu#' \
-e 's#http://mirrors.tuna.tsinghua.edu.cn/ubuntu#http://mirrors.aliyun.com/ubuntu#' \
/etc/apt/sources.list
apt-get update -y
apt-get upgrade -y
}

# 设置防火墙
set_firewalld_selinux(){
ufw disable
ufw status
sestatus -v
}

# 关闭swap
close_swap(){
swapoff -a
sed -ri 's/.*swap.*/#&/' /etc/fstab
}

# 设置常用配置信息
set_user_profile(){
echo "diy: setting user profile ,example: on-my-zsh "
}

# 设置编码UTF-8
lang_config(){
echo "LANG=\"en_US.UTF-8\"">/etc/default/locale
source /etc/default/locale
}

# 安装docker
install_docker(){
 apt-get remove docker docker-engine docker.io containerd runc
 apt-get update
 apt-get install -y \
    net-tools \
    unzip \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    conntrack
 curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
 add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
 apt-get update
 apt-get install -y docker-ce docker-ce-cli containerd.io
 mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "500m"
    },
    "registry-mirrors":[
        "https://dj94z8xi.mirror.aliyuncs.com",
        "http://f1361db2.m.daocloud.io",
        "https://docker.mirrors.ustc.edu.cn"
    ]
}
EOF
 systemctl daemon-reload
 systemctl restart docker
 systemctl enable docker
}

# 安装docker-compose ## 参考地址：http://get.daocloud.io/#install-compose
install_docker_compose(){
curl -L https://get.daocloud.io/docker/compose/releases/download/v2.3.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version
}

#处理dns
set_dns(){
  sed -i 's/#DNS=/DNS=114.114.114.114/' /etc/systemd/resolved.conf
  service systemd-resolved restart
  systemctl enable systemd-resolved
  mv /etc/resolv.conf /etc/resolv.conf.bak
  ln -s /run/systemd/resolve/resolv.conf /etc/
}

ok(){
cat << EOF
+-------------------------------------------------+
|               optimizer is done                 |
|             Please restart this server!         |
+-------------------------------------------------+
EOF
}

# 入口
main(){
    set_hostname
    set_sshd
    apt_tools
    set_timezone
    update_mirror
    linux_optimize1
    linux_optimize2
    set_firewalld_selinux
    close_swap
    set_user_profile
    install_docker
    install_docker_compose
    set_dns
    ok
}
main