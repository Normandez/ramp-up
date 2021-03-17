#!/bin/bash

function show_help()
{
    echo "Usage:"
    echo "  ${0} -C <dir>"
    echo "  ${0} -X <file>"
}

if [ "$1" == "-C" ]
then
    if [ -z "$2" ]
    then
        echo "error: project dir does not exist"
        show_help
        exit 1
    else
        file_name="$(basename "$2")_$(date "+%y-%m-%d_%H-%M-%S").tar.gz"
        tar -czf "$file_name" "$2"
    fi
elif [ "$1" == "-X" ]
then
    if [ -z "$2" ] 
    then
        echo "error: backup file does not exist"
        show_help
        exit 1
    else
        tar -xzf "$2"
    fi
else
    show_help
fi

