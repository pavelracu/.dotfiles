
export DEV_HOME="$HOME/work/maestro-project"

git config --global user.name "Pavel Racu"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config core.hooksPath ~/.dotfiles/hooks

docker_stop() {
    runing=$(docker container ls -aq)
    echo -e "...Atempting to stop the containers"
    if [ X$runing = 'X' ]; then
        echo -e "No existing docker containters...will skip"
    else
        echo "Stopping docker containers"
        docker stop $(docker container ls -aq)
    fi
}

docker_rm_processes() {
    running=$(docker ps -a -q)
    echo -e "...Atempting to remove docker processes"
    if [ X$running = 'X' ]; then
        echo -e "No existing docker processes...will skip"
    else
        docker rm $(docker ps -a -q)
        docker-compose -f docker-compose.yml down --remove-orphans
    fi
}

docker_rm_volumes_dangling() {
    dangling=$(docker volume ls -qf dangling=true)
    echo -e "...Atempting to remove docker volumes (dangling=true)"
    if [ X$dangling = 'X' ]; then
        echo -e "No existing docker volumes...will skip"
    else
        docker volume rm $(docker volume ls -qf dangling=true)
    fi
}

docker_rm_unused_img() {
    docker image prune
}

docker_clean() {
    docker_stop
    docker_rm_processes
    docker_rm_unused_img
}

helpFunction() {
  echo ""
  echo "Usage: $0 "
  #exit 100 # Exit script after printing help
}