# return if not running interactively
case $- in
	*i*) ;;
	*) return;;
esac

if [ "-f $HOME/.bash/bashrc" ]; then
	. $HOME/.bash/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
