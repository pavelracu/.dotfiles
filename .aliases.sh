
alias cl='clear'
alias ltr='ls -lthr'

## Custom git aliases
alias gs='git status'
alias gbv='git branch -v'
alias push='git push origin $1'
alias pull='git pull origin $1'

# DOCKER related aliases
alias dbuild='$(docker_build)'
alias drebuild='$(docker_rebuild)'
alias dclean='$(docker_clean)'
alias ddebug='docker-compose -f docker-compose.yml -f docker-compose.local.debug.yml up --build'
alias ddown='docker-compose down --remove-orphans'
alias drm='docker rm $(docker ps -a -q)'
alias dvls='docker volume ls'

## Custom cd to dev directories
alias cdb='cd $DEV_HOME/district-backend'
alias cda='cd $DEV_HOME/district-architecture'
alias cdp='cd $DEV_HOME/district-proxy-router'
alias cdm='cd $DEV_HOME/district-meeting-room-manager'
