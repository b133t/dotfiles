# return if not running interactively
case $- in
	*i*) ;;
	*) return ;;
esac

# set SESSION_TYPE to `remote/ssh` if coming through ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	export SESSION_TYPE=remote/ssh
else
	case $(ps -o comm= -p $PPID) in
		sshd|*/sshd ) export SESSION_TYPE=remote/ssh ;;
	esac
fi

export GPG_TTY=$(tty)
export EDITOR=vim
export TERM_ITALICS=true

. $HOME/.bash/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
