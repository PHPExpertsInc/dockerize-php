#!/bin/bash
#####################################################################
#   The Dockerize PHP Project                                       #
#   https://github.com/PHPExpertsInc/docker-php                     #
#   License: MIT                                                    #
#                                                                   #
#   Copyright © 2024 PHP Experts, Inc. <sales@phpexperts.pro>       #
#       Author: Theodore R. Smith <theodore@phpexperts.pro>         #
#      PGP Sig: 4BF826131C3487ACD28F2AD8EB24A91DD6125690            #
#####################################################################

time for PHPV in 7.4 8.0 8.1 8.2 8.3-debug; do
    PHP_VERSION=$PHPV composer --version
    PHP_VERSION=$PHPV composer update
    PHPUNIT_V=''
    if [ $PHPV == '7.2' ]; then
        PHPUNIT_V='8'
    elif [ $PHPV == '7.3' ] || [ $PHPV == '7.4' ] || [ $PHPV == '8.0' ]; then
        PHPUNIT_V='9'
    else
        PHPUNIT_V='10'
    fi


    if [ $PHPV == '8.2' ]; then
        PHP_VERSION=$PHPV-debug phpunit -c phpunit.v${PHPUNIT_V}.xml
    else
        PHP_VERSION=$PHPV phpunit -c phpunit.v${PHPUNIT_V}.xml
    fi

    echo "Tested: PHP v$PHPV"
    sleep 2
done

