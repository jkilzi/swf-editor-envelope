#!/bin/bash

set -eu

# These are specified in the Dockerfile, uncomment if you need to test this script.
ASSETS_REPO_URL="https://github.com/apache/incubator-kie-kogito-online.git"
ASSETS_BRANCH_NAME="gh-pages"
ASSETS_VER="0.32.0"
FILE_SERVER_VER="@0.221.0"
FILE_SERVER_PORT="8080"

# shellcheck disable=SC2120
fetch_assets () {
    arg__assets_branch_name=${1:-$ASSETS_BRANCH_NAME}
    arg__assets_repo_url=${2:-$ASSETS_REPO_URL}
    arg__assets_ver=${3:-$ASSETS_VER}

    mkdir -p assets
    cd assets
    git init --initial-branch main

    # Add the repository tracking only the specific branch
    git remote add --track "${arg__assets_branch_name}" --no-master origin "${arg__assets_repo_url}"

    # Enable sparse-checkout
    git config core.sparseCheckout true

    # Specify the directory you want to include
    echo "swf-chrome-extension/${arg__assets_ver}" >> .git/info/sparse-checkout

    # Pull the specific branch
    git pull --depth=1 origin "${arg__assets_branch_name}"

    # Clean up after fetching since the .git stuff is not necessary
    rm -rf .git

    cd -
}

# shellcheck disable=SC2120
serve () {
    arg__assets_ver=${1:-$ASSETS_VER}
    arg__file_server_port=${2:-$FILE_SERVER_PORT}
    
    file_server "assets/swf-chrome-extension/${arg__assets_ver}/" \
        --port "${arg__file_server_port}" \
        --cors \
        --no-dir-listing \
        --no-dotfiles \
        --verbose
}

# shellcheck disable=SC2120
install_file_server () {
    arg__file_server_ver=${1:-$FILE_SERVER_VER}

    deno install \
        --force \
        --global \
        --allow-all \
        "https://deno.land/std${arg__file_server_ver}/http/file_server.ts"
}

install_deps() {
    [ -z "$(command -v git)" ] && apt update && apt install -y git
    install_file_server
}

clean() {
    rm -rf assets
}

"$@"
