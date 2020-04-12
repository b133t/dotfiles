# return if not running interactively
case $- in
	*i*) ;;
	*) return ;;
esac

# fix unfortunate WSL defaults
umask 002

# set SESSION_TYPE to `remote/ssh` if coming through ssh
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	export SESSION_TYPE=remote/ssh
else
	case $(ps -o comm= -p $PPID) in
		sshd|*/sshd ) export SESSION_TYPE=remote/ssh ;;
	esac
fi

if [ "-f $HOME/.bash/bashrc" ]; then
	. $HOME/.bash/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
