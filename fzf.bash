# Setup fzf
# ---------
if [[ -d /usr/local/opt/fzf/bin ]]; then
	if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
		export PATH="$PATH:/usr/local/opt/fzf/bin"
	fi
fi


# Auto-completion
# ---------------
if [[ $- == *i* ]]; then
	[[ -f "/usr/local/opt/fzf/shell/completion.bash" ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null
	[[ -f "/etc/bash_completion.d/fzf" ]] && source "/etc/bash_completion.d/fzf" 2> /dev/null
fi

# Key bindings
# ------------
[[ -f "/usr/local/opt/fzf/shell/key-bindings.bash" ]] && source "/usr/local/opt/fzf/shell/key-bindings.bash"
[[ -f "/usr/share/fzf/shell/key-bindings.bash" ]] && source "/usr/share/fzf/shell/key-bindings.bash"
