# return if not running interactively
case $- in
	*i*) ;;
	*) return;;
esac

# don't like wsl defaults
umask 002

if [ "-f $HOME/.bash/bashrc" ]; then
	. $HOME/.bash/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# vcxsrv, also see https://github.com/Microsoft/WSL/issues/892
#export DISPLAY=:0
export DISPLAY=localhost:0.0

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/bin/anaconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/bin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/bin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/bin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

