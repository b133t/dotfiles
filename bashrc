# return if not running interactively
case $- in
	*i*) ;;
	*) return;;
esac

[ -f ~/.bash/bashrc ] && . ~/.bash/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
