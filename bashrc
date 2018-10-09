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

# tabtab source for serverless package
TABTAB=$HOME/.npm-packages/lib/node_modules/serverless/node_modules/tabtab
if [ -f "$TABTAB/.completions/serverless.bash" ]; then
	. $TABTAB/.completions/serverless.bash
fi
# tabtab source for sls package
if [ -f "$TABTAB/.completions/sls.bash" ]; then
	. $TABTAB/.completions/sls.bash
fi
