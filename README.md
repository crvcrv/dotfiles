# dotfiles

## Setup

```
$ mkdir .dotfiles-shadow-copy
ln .zshrc .dotfiles-shadow-copy/
ln .vimrc .dotfiles-shadow-copy/
ln .tmux.conf .dotfiles-shadow-copy/
```

## scripts

#### dotfiles-commit

```
#!/usr/bin/env bash

cd /Users/v/.dotfiles-shadow-copy/
dirty="$(git status --short | wc -l)"
date=$(date +"%Y/%m/%d %T %z")
# https://stackoverflow.com/questions/8943693/can-git-operate-in-silent-mode
quiet_git() {
    stdout=$(mktemp $TMPDIR/dotfiles-commit.XXXXXXXXXXXXXXXXXXXXXXX)
    stderr=$(mktemp $TMPDIR/dotfiles-commit.XXXXXXXXXXXXXXXXXXXXXXX)

    if ! git "$@" </dev/null >$stdout 2>$stderr; then
        cat $stderr >&2
        rm -f $stdout $stderr
        exit 1
    fi

    rm -f $stdout $stderr
}

if [ $dirty -ne 0 ];then
    quiet_git add . 
    quiet_git commit -m"updated by automation™ ${date}" 
    quiet_git push --force 
fi
cd $OLDPWD
```

#### dotfiles-watch

```
#!/usr/bin/env bash

FSWATCH=$(which fswatch)
DIR=/Users/v

$FSWATCH -0 -o -e ".*" -i "\\.zshrc$" -i "\\.vimrc$" ${DIR} | xargs -0 -n1 -I{} dotfiles-commit >> /dev/null
```
