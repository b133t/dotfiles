# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/bin/.fzf/bin* ]]; then
	export PATH="$PATH:$HOME/bin/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/bin/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOME/bin/.fzf/shell/key-bindings.bash"
