#!/bin/bash

mkdir -p ./vendor/bin
#if [ ! -f ./vendor/bin/composer ]; then
echo "Downloading phpexperts/dockerize's php CLI launcher..."
curl https://raw.githubusercontent.com/PHPExpertsInc/dockerize/v10.0/bin/composer -o vendor/bin/composer
echo "Downloading phpexperts/dockerize's composer CLI launcher..."
curl https://raw.githubusercontent.com/PHPExpertsInc/dockerize/v10.0/bin/php -o vendor/bin/php
#cp -v /code/dockerize/bin/php vendor/bin/php
chmod 0755 ./vendor/bin/composer ./vendor/bin/php
#fi
hash -r

# @see https://linuxize.com/post/how-to-check-if-string-contains-substring-in-bash/
# @see https://github.com/composer/composer/issues/10389
SUB="/vendor/"
if [[ "$0" == *"$SUB"* ]]; then
  ROOT="$(readlink -f /proc/$PPID/cwd)"
else
  ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
fi

if ! echo $PATH | grep -q ./vendor/bin; then
    echo 'You do not have ./vendor/bin in your $PATH.'
    echo 'Modern PHP apps and phpexperts/dockerize require this.'

    if [ ! -f ${HOME}/.bashrc ]; then
        echo "ERROR: It doesn't look like you are using bash (no ~/.bashrc file)."
        echo "       Please add ./vendor/bin to the PATH manually."
        exit 1
    fi

    echo ''
    echo -n 'May I add it to the front of your $PATH? (y/n) '
    read YES_OR_NO
    echo ''

    if [ $YES_OR_NO == 'y' ]; then
        echo 'Adding ./vendor/bin to your $PATH'
        echo '# Added by phpexperts/dockerize' >> ~/.bashrc
        echo 'PATH=./vendor/bin:$PATH' >> ~/.bashrc

        echo 'Your $PATH has been updated. You need you start a new shell now.'
        exit 2
    else
        echo "You can run Dockerized PHP manually:"
        echo ""
        echo "     ./vendor/bin/php"
        echo "     ./vendor/bin/composer"
    fi
fi

ORIG_PHP_VERSION=$PHP_VERSION
if [ -f "${ROOT}/.env" ]; then
    source "${ROOT}/.env"
    if [ ! -z "$ORIG_PHP_VERSION" ]; then
        PHP_VERSION="$ORIG_PHP_VERSION"
    fi
fi

if [ -z "$PHP_VERSION" ]; then
    PHP_VERSION="8.1"
fi

#echo "PHP Version: $PHP_VERSION"
vendor/bin/composer show phpexperts/dockerize > /dev/null 2>&1 || vendor/bin/composer require --ignore-platform-reqs --dev phpexperts/dockerize

export PHP_VERSION=8.3
#cp -v /code/dockerize/bin/php vendor/bin/php

vendor/bin/php --version

#cp -v /code/dockerize/install.php vendor/phpexperts/dockerize/install.php

if [ ! -f docker-compose.yml ]; then
    vendor/bin/php dockerize
fi

#script -qc "/usr/bin/php vendor/phpexperts/dockerize/install.php" typescript
