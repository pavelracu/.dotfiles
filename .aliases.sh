
alias cl='clear'
alias ltr='ls -lthr'

## Custom git aliases
alias gs='git status'
alias gbv='git branch --format="%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(color:blue)%(authorname)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset))"'
alias pull='git pull origin `git rev-parse --abbrev-ref HEAD`'
alias push='git push origin `git rev-parse --abbrev-ref HEAD`'

# DOCKER related aliases
alias dbuild='$(docker_build)'
alias drebuild='$(docker_rebuild)'
alias dclean='$(docker_clean)'
alias ddebug='docker-compose -f docker-compose.yml -f docker-compose.local.debug.yml up --build'
alias ddown='docker-compose down --remove-orphans'
alias drm='docker rm $(docker ps -a -q)'
alias dvls='docker volume ls'

# Container restart
alias cr='docker-compose up -d --no-deps --build '

## Custom cd to dev directories
alias cdb='cd $DEV_HOME/district-backend'
alias cda='cd $DEV_HOME/district-architecture'
alias cdp='cd $DEV_HOME/district-proxy-router'
alias cdm='cd $DEV_HOME/district-meeting-room-manager'

## Pull all repos
alias git-pull-all="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"
