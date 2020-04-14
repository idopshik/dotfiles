# Setup fzf
# ---------
if [[ ! "$PATH" == */home/st/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/st/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/st/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/st/.fzf/shell/key-bindings.bash"
