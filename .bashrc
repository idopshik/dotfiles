# alias vi='vim -u NORC'
alias vi="vim -u ~/.vim_runtime/vimrcs/basic.vim"
alias mongostart="sudo mongod --fork --logpath /data/db/log.log"
alias fzfh="rg --hidden -l \"\" | fzf"
alias tvd="/home/st/Dropbox/Linux_or_Vim_related/scripts/total_video_duration.sh"
alias tmux-dev="/home/st/Dropbox/Linux_or_Vim_related/scripts/tmux-dev.sh"

alias python='/usr/bin/python3.10'
alias ipython='ipython3'

#normal mode in bash
set -o vi

export CC=/usr/bin/gcc-10

export NODE_PATH=/usr/local/lib/node_modules

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/go/bin

export CUSTOMPYTHON=/home/st/Documents/TkinterOne/venv/bin/python3

export GOPATH=~/go
export GOBIN=~/go/bin
# http://bashrcgenerator.com/

RED="\\[$(tput setaf 1)\\]"
CYAN="\\[$(tput setaf 6)\\]"
LIGHTGRAY="\\[$(tput setaf 7)\\]"
YELLOW="\\[$(tput setaf 3)\\]"

vim_prompt() {
  if [ -n "$VIMRUNTIME" ]; then
    echo "${RED} vim ";
    else 
       echo "\\u@\\h:";
  fi
} 

# get current branch in git repo
function parse_git_branch() { BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=$(parse_git_dirty)
        echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}


# new line if long
#TODO why it's not working?
function conditional_length() {

    local pwdmaxlen=30

    if [[ ${#PWD} -gt $pwdmaxlen ]]; then
        echo "\n $ "
	else
        echo " $ "
	fi
}

function levelcolorize {

  # Set color based on clean/staged/dirty.
  if [[ $SHLVL -gt 1 ]]; then
      #VIOLET
     PATHCOLOR="\\[$(tput setaf 12)\\]"
  else
      #CYAN
      PATHCOLOR="\\[$(tput setaf 6)\\]"
  fi
}
function colorize {
  # Capture the output of the "git status" command.
  git_status="$(git status 2> /dev/null)"

  # Set color based on clean/staged/dirty.
  if [[ ${git_status} =~ "working tree clean" ]]; then
      #GREEN
     GITCOLOR="\\[$(tput setaf 2)\\]"
  elif [[ ${git_status} =~ "branch is ahead" ]]; then
      #YELLOW
      GITCOLOR="\\[$(tput setaf 3)\\]"
  else
      #OCHRE
      GITCOLOR="\\[$(tput setaf 208)\\]"
  fi
}

# get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?")
	untracked=$(echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?")
	ahead=$(echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?")
	newfile=$(echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?")
	renamed=$(echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?")
	deleted=$(echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?")
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

PS1="$(vim_prompt)"
levelcolorize
PS1+=${PATHCOLOR}
PS1+="[\\w]"
colorize
PS1+=${GITCOLOR}
PS1+="\$(parse_git_branch)"
PS1+="${LIGHTGRAY}"
PS1+="$(conditional_length)"
# PS1+="${LIGHTGRAY}$ "

export PS1

function nest {
    terminology &
}

function unnest {
    kill  -1 $(ps | sed 1d | awk '{print $1}')
    terminology
}

# Really doubt if I need it and will to get used to it.
# quit ranger and let the shell sync the directory back from ranger.

function ranger {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map Q chain shell echo %d > "$tempfile"; quitall"
    )

    "${ranger_cmd[@]}" "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$PWD" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}




# include hidden by default 
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'

# alternative (to respect .gitignore)
# let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fdfind --type f'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# note taking function and command completion
# just hit "n" and <CR> in your terminal to call fzf
note_dir=/home/st/Dropbox/.vim_cloud/vimwiki

_n() {
  local lis cur
  lis=$(find "${note_dir}" -name "*.wiki" | \
    sed -e "s|${note_dir}/||" | \
    sed -e 's/\.wiki$//')
  cur=${comp_words[comp_cword]}
  compreply=( $(compgen -w "$lis" -- "$cur") )
}
n() {
  : "${note_dir:?'note_dir env var not set'}"
  if [ $# -eq 0 ]; then
    local file
    file=$(find "${note_dir}" -name "*.wiki" | \
      sed -e "s|${note_dir}/||" | \
      sed -e 's/\.wiki$//' | \
      fzf \
        --multi \
        --select-1 \
        --exit-0 \
        --preview="cat ${note_dir}/{}.wiki" \
        --preview-window=right:70%:wrap)
    [[ -n $file ]] && \
      ${editor:-vim} "${note_dir}/${file}.wiki"
  else
    case "$1" in
      "-d")
        rm "${note_dir}"/"$2".wiki
        ;;
      *)
        ${editor:-vim} "${note_dir}"/"$*".wiki
        ;;
    esac
  fi
}
complete -f _n n



#man less
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}
