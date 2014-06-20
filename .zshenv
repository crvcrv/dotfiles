#
# ~/.zshenv
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#golang stuff
export GOPATH=$HOME/devel/go
export PATH=$PATH:$GOPATH/bin