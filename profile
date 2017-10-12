# Git Aware Prompt
# from https://github.com/jimeh/git-aware-prompt/blob/master/prompt.sh
_find_git() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  local status=$(git status --porcelain 2> /dev/null)
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ $branch == "HEAD" ]]; then
      branch='detached*'
    fi
    if [[ "$status" != "" ]]; then
      git_bg=43
      git_fg=33
      git_prefix="▚"
      git_branch=" $branch "
    else
      git_bg=46
      git_fg=36
      git_prefix="▚"
      git_branch=" $branch "
    fi
  else
    git_color=0
    git_prefix=""
    git_branch=""
  fi
}

PROMPT_COMMAND="_find_git; $PROMPT_COMMAND"

# Pointer to installed binaries
export PATH=/usr/local/bin:${PATH}
export PATH=/usr/local/sbin:${PATH}

# Generative Colours
usernameoffset=$(hostname | od | tr ' ' '\n' | awk '{total = total + $1}END{print (total % 6)}')
usernamebackground=$((101 + usernameoffset))
usernameforeground=$((91 + usernameoffset))
hostnameoffset=$(hostname | od | tr ' ' '\n' | awk '{total = total + $1}END{print (total % 6)}')
hostnamebackground=$((41 + hostnameoffset))
hostnameforeground=$((31 + hostnameoffset))

# Colours for Prompt
# export PS1="\n\[$(tput setaf 7)\]\w\[$(tput setaf 12)\]\$git_branch\$machine \n\[$(tput setaf ${hostnameoffset})\]\h\[$(tput setaf 12)\] · \[$(tput setaf ${usernameoffset})\]\u\[$(tput setaf 12)\] ▸ \[$(tput sgr0)\]"

# \$git_prefix\$git_branch
pathsegment="\e[0;30;47m \w \e[m\e[0;\$git_fg;47m\$git_prefix\e[m\e[0;30;\${git_bg}m\$git_branch\e[m"
hostsegment="\e[30;${usernamebackground}m \u \e[m\e[0;${hostnameforeground};${usernamebackground}m▚\e[m\e[0;30;${hostnamebackground}m \h \e[m"
promptsegment="\e[${hostnameforeground}m▚\e[m"
export PS1="\n${hostsegment}\n${pathsegment}\n"

# Python
export PIP_REQUIRE_VIRTUALENV=true
gpip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}


# ALIASES

# Share to shared.swarm.is
share() { rsync -rz $1 web-share:/var/zpanel/hostdata/zadmin/public_html/shared_swarm_is/$2 && say 'the magic is done, sire'; }

# Transfer to transfer.sh
transfer() { curl --progress-bar --upload-file $1 https://transfer.sh/$1 | pbcopy && pbpaste && say 'the magic is done, sire'; }

# Count Lines of Code
alias count="find . -name '*.js' | grep -v 'constants\|config' | xargs wc -l"

# Recursive grep
grr() { defaultPath=.; grep -r $1 ${2-$defaultPath}; }

# List
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls="exa --group-directories-first"
alias ll="ls -la"
alias l="ls -1"
alias lg="ls -lGa"

# Node and NPM Aliases
alias nr="npm run -s"
alias ni="npm install"
alias nu="npm uninstall"

# Git Aliases
alias gs="git status -s"
alias ga="git add"
alias gc="git commit -m"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset %C(bold blue)<%an>%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset %<(50,trunc)%s' --abbrev-commit"
alias gp="git push --follow-tags"
alias gd="git diff"

# Start Z
if hash brew 2>/dev/null; then
  . `brew --prefix`/etc/profile.d/z.sh
fi

# Start X
if [ -z "$DISPLAY" -a $XDG_VTNR -eq 1 ]
then
  startx
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
