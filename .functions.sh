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
    ## TODO: instead of defining the repos in this array, go to the default docker root, list all the folders and add them as a repo list.

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

generate_tocken() {
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

get_migration_number() {
    ## Fetch all branches from origin and add them to a list/array
    ## Check what's the latest migration file on master (or should it be the dev???) and add the number as the inicial migration number

    ## As the user if he is sure that that the migration number should be pushed to the branch
}
