
export DEV_HOME="$HOME/work/maestro-project"

show_images() {
    docker inspect --format='{{.Id}} {{.Parent}}' $(docker images -a -q)
}

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
        docker-compose down --remove-orphans
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
    for image ($(docker images -a | grep "<none>" | awk '{print $3}')); do
        docker rmi $image;
    done
}

docker_clean() {
    docker_stop
    docker_rm_processes
    docker_rm_volumes_dangling
}

generate_migration_script() {
    simulated_mode=true
    case "$1" in
        -s) simulated_mode=true;;
        -w) simulated_mode=false;;
        *) echo -e "Usage: generate_migration_script -<option> \nOptions for environment: -s (simulated mode), -w (write mode)"; return 1
    esac

    RED='\033[0;31m'
    GREEN='\033[32m'
    NC='\033[0m' # No Color
    initial_path=$PWD

    if [[ "$simulated_mode" = true ]]; then
        echo "${GREEN}Runing in simulated mode.${NC}"
    else
        echo "${RED}RUNNING IN WRITE MODE!!!${NC}"
    fi

    cd_migration
    git fetch --all

    current_migration_file=$(ls | sort -V | tail -n 1)
    current_migration_number=${current_migration_file%%_*}

    echo -e "\nCurent migration number: $current_migration_number\n"

    ## Check the latest migration script name for all local branches
    echo "\t...Checking latest migration files on local branches"
    for branch in $(git branch)
    do
        ## Will ignore the "*" indicating the current branch
        if [[ "X$branch" == "X*" ]]; then
            continue
        fi
        lastest_migration_file_on_local=$(git ls-tree $branch --name-only | tail -1)
        ## As seen on http://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion
        lastest_migration_number_on_local=${lastest_migration_file_on_local%%_*}

        #echo "\t...Checking latest migration file on local $branch --> $lastest_migration_number_on_local"

        if [[ "$current_migration_number" -le "$lastest_migration_number_on_local" ]]; then
            current_migration_number=$(($lastest_migration_number_on_local + 1))
            echo "...Changing the current migration number to: $current_migration_number"
        fi
    done

    echo -e "\t************************************************"

    ## Check the latest migration script name for all remote branches
    echo "\t...Checking latest migration file for remote branches"
    for branch in $(git branch -r)
    do
        ## Will ignore the "->"
        if [[ "X$branch" == "X->" ]]; then
            continue
        fi
        lastest_migration_file_on_remote=$(git ls-tree -r $branch --name-only | tail -1)
        ## As seen on http://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion
        lastest_migration_number_on_remote=${lastest_migration_file_on_remote%%_*}

        if [[ "$current_migration_number" -le "$lastest_migration_number_on_remote" ]]; then
            current_migration_number=$(($lastest_migration_number_on_remote + 1))
            echo "Changing the current migration number to: $current_migration_number"
        fi

        ##echo "\t...Checking latest migration file on remote $branch --> $lastest_migration_number_on_remote"
    done

    echo "\nNext migration number: ${GREEN}$current_migration_number${NC}"

    current_branch=$(git symbolic-ref --short -q HEAD)
    if [[ "$current_branch" == "master" ]] || [[ "$current_branch" == "dev" ]]; then
        echo "You are not allowed to use the script in ${RED}$current_branch${NC} branch".
        return 1
    fi

    echo -e "\nPlease input the migration script name (without the extention and the migration number)"
    read migration_script_name
    echo "Will create the script ${current_migration_number}_${migration_script_name}.sql"

    migration_script_full_name=${current_migration_number}_${migration_script_name}.sql

    if [[ "$PWD" == "$migration_folder" ]]; then

        if [[ "$simulated_mode" = true ]]; then
            echo "${GREEN}Program runned in simulated mode. Will exit now.${NC}"
            cd $initial_path
            return 1
        fi

        touch ${current_migration_number}_${migration_script_name}.sql
        current_migration_number=0
        echo "-- migrate:up" > $migration_script_full_name
        echo "-- migrate:down" >> $migration_script_full_name
        echo "Ready to ${RED}ADD${NC}, ${RED}COMMIT${NC} and ${RED}PUSH${NC} the file $migration_script_full_name to ${RED}$current_branch${NC} branch.\nWant to proceed? (y/N)."
        read answer
        case $answer in
            [Yy]* ) git add $migration_script_full_name; git commit -m"Added $migration_script_full_name migration file"; git push origin $(git symbolic-ref --short -q HEAD);;
            [Nn]* ) echo "Nothing added to git staging. Will revert the changes"; git clean -f $migration_script_full_name;;
        esac
    fi
    cd $initial_path
}





