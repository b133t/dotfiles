
if [ -f "$HOME/.bash/profile" ]; then
	. $HOME/.bash/profile
fi
if [ -f "$HOME/.bashrc" ]; then
	. $HOME/.bashrc
fi

if [ -f "$HOME/.bash_env" ]; then
	# overrides
	source "$HOME/.bash_env"
fi
