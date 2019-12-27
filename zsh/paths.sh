# Setup PATH
PATH=$HOME/bin:$HOME/.local/bin:$PATH 
PATH=$HOME/dotfiles/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH

# Setup GOPATH
if [ $+commands[go] ]; then
    export GOPATH=$HOME/code/go
    export GOBIN=$GOPATH/bin
    export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
fi
