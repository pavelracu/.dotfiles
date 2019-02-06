
export DEV_HOME='/Users/macbook1/district/docker_build'

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

fetch_all() {
    if [ ! -d "${DEV_DIR}" ]; then
        echo "Docker root directory not defined. Execute the command export DEV_DIR=/path/to/your/docker_dir"
        return 1;
    fi

    if [ "$PWD" != "$DEV_DIR" ]; then
        echo -e "\tcd $DEV_DIR"
        cd $DEV_DIR
    fi

    echo -e "Found \n$(ls $DEV_DIR)"
    for item in $(ls $DEV_DIR)
    do
        if [[ (-d "$DEV_DIR/$item") && (-d "$DEV_DIR/$item/.git") ]]; then
        echo -e " \tcd $DEV_DIR/$item"
        cd $DEV_DIR/$item
        echo -e "\n\tExecuting git fetch --all in $DEV_DIR/$item"
        git fetch --all
        fi
    done
}

generate_token() {
    case "$1" in
        -l) url='http://localhost/oauth/v2/token';;
        -s) url='https://staging-api.district-tech.com/oauth/v2/token';;
        -p) url='https://api.district-tech.com/oauth/v2/token';;
        *) echo -e "Usage: generate_tocken <env> -u <username> -p <password> \nOptions for environment: -l (localhost), -s (staging), -p (production)"; return 1
    esac

    if [ "$2" = "-u" ]; then
        username=$3
    else
        echo -e "...Username not defined...Use -u user@example.com"
        return 1
    fi

    if [ "$4" = "-p" ]; then
        password=$5
    else
        echo -e "...Password not defined...Use -p password"
        return 1
    fi

    echo "...url:      $url"
    echo "...user:     $username"
    echo "...password: $password"
    curl -v \
        --silent \
        --request POST \
        --header "Content-type: application/json" \
        --data '{"username": "'$username'", "password": "'$password'", "grant_type": "password", "client_id": "SeedClient", "scope": "user_identity"}' \
    $url 2>&1 | grep -o '"access_token": *"[^"]*"\|"refresh_token": *"[^"]*"' --color

}

cd_migration() {
    if [[ ! -d $DEV_HOME ]]; then
        echo -e "\tDEV_HOME not defined. Please use export DEV_HOME=/path/to/your/docker_dir"
    else
        if [[ ! -d $DEV_HOME/district-architecture ]]; then
            echo -e "Could not find district-architecture folder in DEV_HOME"
            return 1
        fi
        #echo -e "...cd $DEV_HOME/district-architecture"
        cd $DEV_HOME/district-architecture
    fi

    if [[ ! -d $DEV_HOME/district-architecture/sql/db/migrations ]]; then
        echo -e "...Could not find $DEV_HOME/district-architecture/sql/db/migrations folder"
        return 1
    fi

    #echo -e "\t...cd $DEV_HOME/district-architecture/sql/db/migrations"
    migrationFolder="$DEV_HOME/district-architecture/sql/db/migrations"
    cd $migrationFolder
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
    initialPath=$PWD

    if [[ "$simulated_mode" = true ]]; then
        echo "${GREEN}Runing in simulated mode.${NC}"
    else
        echo "${RED}RUNNING IN WRITE MODE!!!${NC}"
    fi

    cd_migration
    git fetch --all

    currentMigrationFile=$(ls | sort -V | tail -n 1)
    currentMigrationNumber=${currentMigrationFile%%_*}

    echo -e "\nCurent migration number: $currentMigrationNumber\n"

    ## Check the latest migration script name for all local branches
    echo "\t...Checking latest migration files on local branches"
    for branch in $(git branch)
    do
        ## Will ignore the "*" indicating the current branch
        if [[ "X$branch" == "X*" ]]; then
            continue
        fi
        lastestMigrationFileOnLocal=$(git ls-tree $branch --name-only | tail -1)
        ## As seen on http://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion
        lastestMigrationNumberOnLocal=${lastestMigrationFileOnLocal%%_*}

        #echo "\t...Checking latest migration file on local $branch --> $lastestMigrationNumberOnLocal"

        if [[ "$currentMigrationNumber" -le "$lastestMigrationNumberOnLocal" ]]; then
            currentMigrationNumber=$(($lastestMigrationNumberOnLocal + 1))
            echo "...Changing the current migration number to: $currentMigrationNumber"
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
        lastestMigrationFileOnRemote=$(git ls-tree -r $branch --name-only | tail -1)
        ## As seen on http://mywiki.wooledge.org/BashGuide/Parameters#Parameter_Expansion
        lastestMigrationNumberOnRemote=${lastestMigrationFileOnRemote%%_*}

        if [[ "$currentMigrationNumber" -le "$lastestMigrationNumberOnRemote" ]]; then
            currentMigrationNumber=$(($lastestMigrationNumberOnRemote + 1))
            echo "Changing the current migration number to: $currentMigrationNumber"
        fi

        ##echo "\t...Checking latest migration file on remote $branch --> $lastestMigrationNumberOnRemote"
    done

    echo "\nNext migration number: ${GREEN}$currentMigrationNumber${NC}"

    current_branch=$(git symbolic-ref --short -q HEAD)
    if [[ "$current_branch" == "master" ]] || [[ "$current_branch" == "dev" ]]; then
        echo "You are not allowed to use the script in ${RED}$current_branch${NC} branch".
        return 1
    fi

    echo -e "\nPlease input the migration script name (without the extention and the migration number)"
    read migrationScriptName
    echo "Will create the script ${currentMigrationNumber}_${migrationScriptName}.sql"

    migrationScriptFullName=${currentMigrationNumber}_${migrationScriptName}.sql

    if [[ "$PWD" == "$migrationFolder" ]]; then

        if [[ "$simulated_mode" = true ]]; then
            echo "${GREEN}Program runned in simulated mode. Will exit now.${NC}"
            cd $initialPath
            return 1
        fi

        touch ${currentMigrationNumber}_${migrationScriptName}.sql
        currentMigrationNumber=0
        echo "-- migrate:up" > $migrationScriptFullName
        echo "-- migrate:down" >> $migrationScriptFullName
        echo "Ready to ${RED}ADD${NC}, ${RED}COMMIT${NC} and ${RED}PUSH${NC} the file $migrationScriptFullName to ${RED}$current_branch${NC} branch.\nWant to proceed? (y/N)."
        read answer
        case $answer in
            [Yy]* ) git add $migrationScriptFullName; git commit -m"Added $migrationScriptFullName migration file"; git push origin $(git symbolic-ref --short -q HEAD);;
            [Nn]* ) echo "Nothing added to git staging. Will revert the changes"; git clean -f $migrationScriptFullName;;
        esac
    fi
    cd $initialPath
}





