#!/bin/bash

# PocketMine-MP dev environment tools script
# provides features to build binaries, fetch latest PocketMine release from API and download it,
# including server run environment and more utilities
# created in: 2021 by: @jarne
# updated in: 2023; changes: fetch latest release information automatically from API
# updated in: 2025; changes: also download binaries from API instead of compiling

# Settings

PMMP_REPO_ORG=pmmp
PMMP_REPO_NAME=PocketMine-MP
PMMP_GIT_REPO=https://github.com/$PMMP_REPO_ORG/$PMMP_REPO_NAME.git
PMMP_RELEASE_INFO_API=https://api.github.com/repos/$PMMP_REPO_ORG/$PMMP_REPO_NAME/releases/latest

DEVTOOLS_REPO_NAME=DevTools
DEVTOOLS_RELEASE_INFO_API=https://api.github.com/repos/$PMMP_REPO_ORG/$DEVTOOLS_REPO_NAME/releases/latest

BINARIES_REPO_NAME=PHP-Binaries
BINARIES_RELEASE_INFO_API=https://api.github.com/repos/$PMMP_REPO_ORG/$BINARIES_REPO_NAME/releases
BINARIES_TARGET_ARCH=Linux-x86_64
BINARIES_TAG=pm5-latest

PHP_BINARIES=bin/php7/bin/php
ENV_FILES=(composer.json composer.lock start.sh)

DEVTOOLS_FILE=DevTools.phar

COMPOSER_FILE=composer.phar
COMPOSER_DL_URL=https://getcomposer.org/composer-stable.phar

# Script

# Fetch infos for the latest PHP binaries release
binaries_release_info() {
    # Fetch release infos from API
    binReleaseInfos=$(curl -s $BINARIES_RELEASE_INFO_API)

    # Query for release binaries archive download URL and file name
    binDownloadUrl=$(echo $binReleaseInfos | jq -r ".[] | select(.tag_name == \"${BINARIES_TAG}\") | .assets[] | select(.name | test(\".*${BINARIES_TARGET_ARCH}-PM5.tar.gz\")) | .browser_download_url")
    binFileName=$(echo $binReleaseInfos | jq -r ".[] | select(.tag_name == \"${BINARIES_TAG}\") | .assets[] | select(.name | test(\".*${BINARIES_TARGET_ARCH}-PM5.tar.gz\")) | .name")

    # Query for binary symbols archive download URL and file name
    binSymbolsDownloadUrl=$(echo $binReleaseInfos | jq -r ".[] | select(.tag_name == \"${BINARIES_TAG}\") | .assets[] | select(.name | test(\".*${BINARIES_TARGET_ARCH}-PM5-debugging-symbols.tar.gz\")) | .browser_download_url")
    binSymbolsFileName=$(echo $binReleaseInfos | jq -r ".[] | select(.tag_name == \"${BINARIES_TAG}\") | .assets[] | select(.name | test(\".*${BINARIES_TARGET_ARCH}-PM5-debugging-symbols.tar.gz\")) | .name")

    echo "Binaries archive download url: ${binDownloadUrl} | symbols archive download url: ${binSymbolsDownloadUrl}"
}

# Fetch infos for the latest PocketMine release
pmmp_release_info() {
    # Fetch release infos from API
    pmReleaseInfos=$(curl -s $PMMP_RELEASE_INFO_API)

    # Query for release server file download URL
    pmDownloadUrl=$(echo $pmReleaseInfos | jq -r '.assets[] | select(.name == "PocketMine-MP.phar") | .browser_download_url')

    # Query for release commit hash
    commitHash=$(echo $pmReleaseInfos | jq -r '.target_commitish')

    echo "PMMP release download url: ${pmDownloadUrl} | commit hash: ${commitHash}"
}

# Fetch infos for the latest DevTools release
devtools_release_info() {
    # Fetch release infos from API
    devReleaseInfos=$(curl -s $DEVTOOLS_RELEASE_INFO_API)

    # Query for release plugin file download URL
    devDownloadUrl=$(echo $devReleaseInfos | jq -r '.assets[] | select(.name == "DevTools.phar") | .browser_download_url')

    echo "DevTools release download url: ${devDownloadUrl}"
}

# Download PHP binaries
binaries() {
    # Remove existing binaries and symbols
    rm -r bin bin-debug

    # Download binary dist and symbols
    curl -L -O $binDownloadUrl
    curl -L -O $binSymbolsDownloadUrl

    # Extract binary archive files
    tar -xzvf $binFileName
    tar -xzvf $binSymbolsFileName

    # Apply fix for PHP extensions path
    # source: https://doc.pmmp.io/en/rtfd/faq/installation/opcache.so.html
    EXTENSION_DIR=$(find "$(pwd)/bin" -name "*debug-zts*")
    grep -q '^extension_dir' bin/php7/bin/php.ini && sed -i'bak' "s{^extension_dir=.*{extension_dir=\"$EXTENSION_DIR\"{" bin/php7/bin/php.ini || echo "extension_dir=\"$EXTENSION_DIR\"" >> bin/php7/bin/php.ini

    # Remove downloaded archive files
    rm $binFileName $binSymbolsFileName
}

# Download PocketMine-MP server files
server() {
    # Download PHAR
    curl -L -O $pmDownloadUrl

    # Download Composer
    curl -o $COMPOSER_FILE $COMPOSER_DL_URL

    # Install dependencies with Composer
    $PHP_BINARIES $COMPOSER_FILE install

    # Delete Composer
    rm $COMPOSER_FILE
}

# Download PocketMine-MP environment files like starter script
pmenv() {
    # Clone from Git
    git clone --recursive $PMMP_GIT_REPO

    # Checkout given commit
    cd $PMMP_REPO_NAME
    git checkout $commitHash
    cd ..

    # Loop env files and replace them
    for file in ${ENV_FILES[@]}
    do
        # Remove old file
        rm $file

        # Copy new file from repo
        cp $PMMP_REPO_NAME/$file .
    done

    # Delete Git repo
    rm -rf $PMMP_REPO_NAME
}

# Download PocketMine-MP sources
sources() {
    # Clone from Git
    git clone --recursive $PMMP_GIT_REPO

    # Checkout given commit
    cd $PMMP_REPO_NAME
    git checkout $commitHash
    cd ..

    # Delete old sources
    rm -r src

    # Move sources folder
    mv $PMMP_REPO_NAME/src .

    # Delete Git repo
    rm -rf $PMMP_REPO_NAME
}

# Download DevTools plugin
devtools() {
    # Download PHAR
    curl -L -o $DEVTOOLS_FILE $devDownloadUrl

    # Delete old PHAR file
    rm plugins/$DEVTOOLS_FILE

    # Move into plugins folder
    mv $DEVTOOLS_FILE plugins/
}

# Select action
select ACTION in binaries server pmenv sources devtools quit
do
    case $ACTION in
        binaries)
            binaries_release_info
            binaries
            ;;
        server)
            pmmp_release_info
            server
            ;;
        pmenv)
            pmmp_release_info
            pmenv
            ;;
        sources)
            pmmp_release_info
            sources
            ;;
        devtools)
            devtools_release_info
            devtools
            ;;
        quit)
            break
            ;;
    esac
done
