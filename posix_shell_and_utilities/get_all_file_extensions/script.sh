#!/bin/bash

# first argument is a dir, '.' by default
dir='.'
if [[ $# > 0 ]];
then
    dir=$1
fi

files=($(ls -p "${dir}" | grep -v /))

if [[ ${#files[@]} == 0 ]];
then
    echo no files: ${dir}
else
    declare -a exts
    for f in ${files[@]}
    do
        if [[ $f == *.* ]]; then
            exts+="${f#*.} "
        fi
    done
    echo $(echo ${exts[@]} | tr ' ' '\n' | sort -u)
fi

