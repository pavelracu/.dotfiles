
source=~/.env
alias cl='clear'
alias ltr='ls -lthAr'

## Custom git aliases
alias gs='git status'
alias gbv='git branch --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(color:blue)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))"'
alias pull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias push='git push origin `git rev-parse --abbrev-ref HEAD`'

# DOCKER related aliases
alias dbuild='$(docker_build)'
alias drebuild='$(docker_rebuild)'
alias dclean='$(docker_clean)'
alias ddown='docker-compose down --remove-orphans'
alias drm='docker rm $(docker ps -a -q)'
alias dvls='docker volume ls'


## Pull all repos
alias gua="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} remote update"
alias gcma="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} checkout master"
alias gpa="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"

alias lobsterssh='ssh -p 36558 pavel@173.212.200.181'

alias reload='source ~/.zshrc'