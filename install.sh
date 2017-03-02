#!/usr/bin/env zsh

# Check Vim and Zsh
VIM_CHECK=`echo "$(vim --version | egrep -o 'Vi IMproved [0-9]+[.][0-9]+' | cut -d' ' -f3) >= 7.4" | bc`
ZSH_CHECK=`which zsh`    
if [ ! $VIM_CHECK ]; then
    echo '[WARNING] Cannot find Vim of version >= 7.4'
elif [ ! $ZSH_CHECK ]; then
    echo '[ERROR] Cannot find Zsh.'
    exit
elif [ ! `which curl` ]; then
    echo '[ERROR] curl is required for installing vim.plug.'
    exit
fi
# Note: it doesn't check git here, the environment should have git if this script already downloaded.

# Back to home
cd ~
 
# Get FZF
`git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf`
~/.fzf/install

# Get vim.plug and oh-my-zsh
`curl -fLo ~/.my_settings/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
`git clone https://github.com/robbyrussell/oh-my-zsh .my_settings/.oh-my-zsh`


# Create symbolic links for dot-files
ln -fs .my_settings/.zshrc
ln -fs .my_settings/.oh-my-zsh
ln -fs .my_settings/.vim
ln -fs .my_settings/.vimrc
ln -fs .my_settings/.inputrc
ln -fs .my_settings/.jupyter
ln -fs .my_settings/.ipython
ln -fs .my_settings/.tmux.conf
ln -fs .my_settings/.pylintrc

mkdir .ssh 2> /dev/null
ln -fs ~/.my_settings/.ssh/config ~/.ssh/config

if [ "$1" = "--use-nvim" ]; then
    # Neovim
    mkdir .config 2> /dev/null
    ln -fs ~/.my_settings/.vim ~/.config/nvim
    ln -fs ~/.my_settings/.vimrc ~/.config/nvim/init.vim

    # Install vim plugins for nvim
    nvim +PlugInstall +qall
else
    # Install vim plugins
    vim +PlugInstall +qall
fi

## (optional)
#`ln -fs .my_settings/.pudb-theme.py`
#`ln -fs .my_settings/.Xmodmap`
#`ln -fs .my_settings/.spyder2-py3`
#`ln -fs .my_settings/.spyder2`

# Update zsh
source .zshrc
