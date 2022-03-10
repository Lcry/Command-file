#!/bin/bash
# 一键安装oh-my-zsh并下载powerlevel10k主题，需要自己输入命令配置 ` p10k configure `

export proxy="http://gh.biejieshi.com/"

rm -rf $HOME/.zsh*
rm -rf $HOME/zsh*
rm -rf .oh-my-zsh

sh -c "$(wget ${proxy}https://gist.githubusercontent.com/Lcry/c31e46ceecd9f4fc0afd1420fd079601/raw/a3c0ebaceb7148ffe15245952cf307794fe05fef/ohmyzsh-proxy-install.sh -O -)"
git clone ${proxy}https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone ${proxy}https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
sed -i 's/^plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/g' ~/.zshrc
git clone --depth=1 ${proxy}https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
zsh