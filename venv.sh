#!/bin/bash

VIRTUALENV_PATH=~/.python/virtualenv.py
VIRTUALENVS_DIR=~/.virtualenvs

function venv {

   thecmd=$1;

    aliases=( "c:create" "a:activate" "e:export" )
    for alias_dict in ${aliases[@]}
    do
        alias=$(echo $alias_dict|awk -F ':' '{print $1}');
        if [ "$thecmd" == "$alias" ]; then
            cmd=$(echo $alias_dict|awk -F ':' '{print $2}');
        fi
    done 

    if [ -z "$cmd" ]; then
        cmd="$thecmd";
    fi

    if [ "$cmd" == "create" ]; then
        if [ -n "$2" ]; then
            name=$2
        else
            echo "Please enter name of the new env";
            return 1;
        fi
            
        _virtualenv $VIRTUALENVS_DIR/$name --no-site-packages;
        return 0;
    fi

    if [ "$cmd" == "activate" ]; then
        if [ -n "$2" ]; then
            name=$2
        else
            echo "Please enter name of the env which wants to activate";
            return 1;
        fi
            
        source $VIRTUALENVS_DIR/$name/bin/activate;
        return 0;
    fi

    if [ "$cmd" == "export" ]; then
        if [ -n "$2" ]; then
            name=$2
        else
            echo "Please enter name of the env which wants to export";
            return 1;
        fi
            
        pip freeze -E $VIRTUALENVS_DIR/$name >  $name-requirements.txt;
        return 0;
    fi

    if [ "$cmd" == "ls" ]; then
        find $VIRTUALENVS_DIR/ -maxdepth 1 -mindepth 1 -type d -exec basename {} \;
        return 0;
    fi

    _virtualenv;
    return 0;

}

function _virtualenv {
    python $VIRTUALENV_PATH $@
}
