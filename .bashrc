 # alias vi='vim -u NORC'
alias vi="vim -u ~/.vim_runtime/vimrcs/noplugins_vimrc"
alias covid="curl https://trackercli.com/russia"
alias mongostart="sudo mongod --fork --logpath /data/db/log.log"

alias python='/usr/bin/python3.7'
alias ipython='ipython3'

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/go/bin

export GOPATH=~/go
export GOBIN=~/go/bin


# http://bashrcgenerator.com/
GREEN="\001$(tput setaf 2)\002"
GREY="\001$(tput setaf 244)\002"
RED="\001$(tput setaf 1)\002"
YELLOW="\001$(tput setaf 3)\002"
CYAN="\001$(tput setaf 6)\002"
WHITE="\001$(tput setaf 7)\002"
OCHRE="\001$(tput setaf 214)\002"

vim_prompt() {
  if [ -n "$VIMRUNTIME" ]; then
    echo "${RED}vim ";
    else 
       echo "\u@\h:";
  fi
} 


# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}


# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
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
PS1+="${CYAN}[\w]"
# PS1+="${GREEN}\$(git_branch)"
PS1+="${GREEN}\$(parse_git_branch)"
PS1+="${WHITE}$ "
export PS1


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
