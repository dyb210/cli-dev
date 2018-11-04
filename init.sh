#!/bin/bash -
#===============================================================================
#        AUTHOR: prozhou 
#       CREATED: 2018/03/11 17时45分11秒
#      REVISION:  ---
#       vim tmux zsh for mac and linux develop env
#===============================================================================

set -o nounset    

source ./helper/system_info.sh
source "./helper/${sys_os}_dep.sh"
source "./helper/jdk.sh"

if [ $sys_os != "mac" ]; then
    apt-get install -y netcat iproute2
    #install proxy tool
    if   netcat -z `/sbin/ip route|awk '/default/ { print $3 }'` 8085 && [ ! -f /usr/local/bin/pxy ] ;then
        cp ./helper/pxy.sh /usr/local/bin/pxy && chmod u+x /usr/local/bin/pxy 
        curl http://`/sbin/ip route|awk '/default/ { print $3 }'`:8085/module/gae_proxy/control/download_cert | sudo tee  --append /etc/ssl/certs/ca-certificates.crt
    fi
fi

#install tmux
cd tmux
source "./${sys_os}_init.sh"
cd ..

#install zsh
cd zsh
source "./${sys_os}_init.sh"
cd ..

#install neovim
cd neovim
source "./${sys_os}_init.sh"
cd ..

#reload zsh
zsh
