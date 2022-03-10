#! /bin/bash
#==============================================================#
#在原作者Teddysun进行修改下载地址2018年12月7日
#==============================================================#
cur_dir=/opt/unixbench

# Check System
[[ $EUID -ne 0 ]] && echo 'Error: This script must be run as root!' && exit 1
[[ -f /etc/redhat-release ]] && os='centos'
[[ ! -z "`egrep -i debian /etc/issue`" ]] && os='debian'
[[ ! -z "`egrep -i ubuntu /etc/issue`" ]] && os='ubuntu'
[[ "$os" == '' ]] && echo 'Error: Your system is not supported to run it!' && exit 1

# Install necessary libaries
if [ "$os" == 'centos' ]; then
    yum -y install make automake gcc autoconf gcc-c++ time perl-Time-HiRes
else
    apt-get -y update
    apt-get -y install make automake gcc autoconf time perl
fi

# Create new soft download dir
mkdir -p ${cur_dir}
cd ${cur_dir}

# Download UnixBench5.1.3
if [ -s UnixBench5.1.3.tgz ]; then
    echo "UnixBench5.1.3.tgz [found]"
else
    echo "UnixBench5.1.3.tgz not found!!!download now..."
    if ! wget -c https://raw.githubusercontent.com/Lcry/Command-file/master/src/UnixBench5.1.3.tgz; then
        echo "Failed to download UnixBench5.1.3.tgz, please download it to ${cur_dir} directory manually and try again."
        exit 1
    fi
fi
tar -zxvf UnixBench5.1.3.tgz && rm -f UnixBench5.1.3.tgz
cd UnixBench/

#Run unixbench
make
./Run

echo
echo
echo "======= Script description and score comparison completed! ======= "
echo
echo