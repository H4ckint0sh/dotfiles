# Git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an %ar%C(blue) %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

# Other
alias v='nvim'
alias lg="lazygit"
alias ls="eza --icons --group-directories-first -1 -T"
alias ll="eza --icons --group-directories-first -l -T"
alias c="clear"
alias kp="ps aux | fzf | awk '{print \$2}' | xargs kill"
alias delds="find . -name '.DS_Store' -type f -delete"
alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n} | less'


alias sal='ssh_agent_lazy'

