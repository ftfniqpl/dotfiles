#!/bin/bash

sudo add-apt-repository ppa:fkrull/deadsnakes
sudo apt-get update

sudo apt-get istnall python3.5 -y
sudo apt-get install python3.5-dev libpython3.5-dev -y

sudo add-apt-repository ppa:pi-rho/dev
sudo apt-get update

sudo apt-get install vim vim-gnome -y

sudo apt-get install vim-python-jedi -y

USER_HOME=`echo $HOME`
CURR_HOME=`echo $PWD`



prepare ()
{
    rm -rf $USER_HOME/.vimrc
    rm -rf $USER_HOME/.vim
    rm -rf $USER_HOME/.tmux.conf

    if [ "$COLORTERM" = "gnome-terminal" ]; then
        #write to $USER_HOME/.bashrc file
        #$ENV='TERM=gnome-256color'
        #env $ENV
        eval TEMC=\"TERM=gnome-256color\"
        export $TEMC
        #declare -x TERM="gnome-256color"
        #echo -e "\nexport TERM=gnome-256color" >> $USER_HOME/.bashrc
    fi

    if [ ! -d "~/.ssh/config" ]; then
        mkdir ~/.ssh -p
        echo "SendEnv TERM=gnome-256color" > ~/.ssh/config
    fi

}

add()
{
    ln -s $CURR_HOME/.vimrc $USER_HOME/.vimrc
    ln -s $CURR_HOME/.vim $USER_HOME/.vim
    ln -s $CURR_HOME/.tmux.conf $USER_HOME/.tmux.conf
}

remove()
{
    rm -rf $USER_HOME/.vimrc
    rm -rf $USER_HOME/.vim
    rm -rf $USER_HOME/.tmux.conf

}

if [ ! -n "$1" ]; then
    echo "must be params on [add/remove]"
    exit 1
elif [ $1 = 'add' ]; then
    prepare
    add
else
    remove
fi

echo "finished"
exec $SHELL

