#!/bin/bash
# 一键安装on-my-zsh
set -e
set -x

uninstall(){
	rm -rf $HOME/.zsh*
	rm -rf $HOME/zsh*
	rm -rf .oh-my-zsh
}

install_autojump_by_git(){
        # sudo yum install autojump -y
        git clone http://gh.biejieshi.com/https://github.com/joelthelion/autojump.git /tmp/.autojump && cd /tmp/.autojump &&
        python3 ./install.py &&     # fix error: python not in env
	cd /tmp &&
        rm -rf /tmp/.autojump
        # add for you self into .zshrc
        # [[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh
}

install_ubuntu(){
        # get this script, you may need to run:
        # apt-get update && apt-get install curl -y
        # curl raw URL > thinkycx-zsh.sh
        # bash thinkycx-zsh.sh

        # apt-get install sudo -y
        sudo apt-get update -y
        sudo apt-get install tmux -y
        sudo apt-get install git -y
        sudo apt-get install git -y # for not install strange bug 20180831
        sudo apt-get install curl -y
        sudo apt-get install zsh -y

        #optional
        #sudo apt-get install terminator -y
        #sudo apt-get install vim -y
        #sudo apt-get install python-pip -y
        # https://github.com/robbyrussell/oh-my-zsh
        # git config --global --unset http.proxy
        # git config --global --unset https.proxy

        #sudo apt-get install autojump -y
        #echo "[!] need to add autojump in ~/.zshrc plugin and logoff manually!"
}


install_centos(){
        # get this script, you may need to run:
        # yum update && yum install curl -y
        # curl raw URL > thinkycx-zsh.sh
        # bash thinkycx-zsh.sh

        # yum install sudo -y
        sudo yum update -y &&
        sudo yum install tmux -y &&
        sudo yum install git -y &&
        sudo yum install git -y && # for not install strange bug 20180831
        sudo yum install curl -y &&
        sudo yum install zsh -y &&

        #optional
        #sudo yum install terminator -y
        sudo yum install vim -y &&
        # sudo yum install python-pip -y # centos 8.1 not have
        # https://github.com/robbyrussell/oh-my-zsh
        # git config --global --unset http.proxy
        # git config --global --unset https.proxy

        install_autojump_by_git
}


install_macOS(){
        # 20190917
        # install brew 20200622
        brew -v >/dev/null
        if [[ $? -ne 0 ]]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
        echo "[+] brew install some dependencies..."

        # brew update && brew upgrade
        su - $USER -c brew install git
        su - $USER -c brew install curl
        su - $USER -c brew install zsh
        su - $USER -c brew install tmux

        #optional
        # brew install vim  | brew upgrade vim
        # https://github.com/robbyrussell/oh-my-zsh
        # git config --global --unset http.proxy
        # git config --global --unset https.proxy

        su - $USER -c brew install autojump | su - $USER -c brew upgrade autojump
        # install_autojump_by_git

}


install_dependencies(){
        if [[ "$OSTYPE" == "linux-gnu" ]]; then
            source /etc/os-release
            echo "OS: ", $ID
                # linux
            if [ $ID == "centos" ]; then
              install_centos
            elif [ $ID == "ubuntu" ]; then
              install_ubuntu
            else
              echo "[!] cannot support your OS. (not centos or ubuntu)"
              exit
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            echo "OS: macOS"
            install_macOS
        else
            echo "[!] cannot support your OS. (not linux or macOS)"
            exit
        fi

}


# 终端配置（弃用）
# http://www.cnblogs.com/yangshiyu/p/6941555.html
# preferences font ubuntu mono13
# local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT='${ret_status}%{$fg[cyan]%}%~%{$reset_color%}$(git_prompt_info)%{$fg[green]%}$ %{$fg[white]%}'

# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# need to exit manually
install_zsh(){
        echo "[!] ENTER exit manually!"
        sh -c "$(curl -fsSL http://gh.biejieshi.com/https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}


config_zshrc(){
        bash_aliases=$(cat ~/.zshrc | grep "~/.bash_aliases")
        if [ -z "$bash_aliases" ];then
          echo "[*] add ~/.bash_aliases in ~/.zshrc"
cat <<EOF  >>~/.zshrc

# add ~/.bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF
        else
          echo "[*] ~/.bash_aliases exists in ~/.zshrc"
        fi
}


config_dircolors(){
        # only supported for linux
        if [[ "$OSTYPE" == "darwin"* ]]; then
            return
        fi
        # use dircolors
        echo "[*] add ~/.dircolors in ~/.zshrc"
        dircolors -p > ~/.dircolors
cat <<EOF  >>~/.zshrc

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
EOF
}


install_zsh_plugins(){
        # install zsh-autosuggestions
        if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
          git clone http://gh.biejieshi.com/https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
          echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
        else
          echo "[*] ~/.zsh/zsh-autosuggestions exists..."
        fi

        # install zsh-syntax-highlighting
        if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
          git clone http://gh.biejieshi.com/https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
          echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
        else
          echo "[*] ~/.zsh/zsh-syntax-highlighting exists...."
        fi

}

install_tmux_plugins(){
        # tmux plugins
        mkdir ~/.tmux
        git clone http://gh.biejieshi.com/https://github.com/tmux-plugins/tmux-resurrect.git ~/.tmux/
        git clone http://gh.biejieshi.com/https://github.com/tmux-plugins/tmux-continuum.git ~/.tmux/
cat <<EOF >>~/.tmux.conf

run-shell ~/.tmux/tmux-resurrect/resurrect.tmux
run-shell ~/.tmux/tmux-continuum/continuum.tmux

EOF
        tmux &

        tmux source-file ~/.tmux.conf

}

change_zsh_bash_history(){
cat <<EOF >>~/.zshrc
HISTFILE="\$HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
EOF
}

config_change_default_shell(){
        # change zsh to default shell
        sudo chsh -s /bin/zsh
}

install_done(){
        echo "[!] need to add autojump in ~/.zshrc plugin and logoff manually!"
        echo "[*] ENJOY!"
        /bin/zsh
}

install_dependencies || exit 1
install_zsh || exit 2
config_zshrc || exit 3
config_dircolors || exit 4
install_zsh_plugins || exit 5
install_tmux_plugins || exit 6
change_zsh_bash_history || exit 7
config_change_default_shell || exit 8
install_done || exit 7

# uninstall
# rm -rf ~/.oh-my-zsh