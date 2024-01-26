#!/bin/bash

case "$1" in
    cl)
        bash mk.sh clean
        ;;
    mk)
        bash mk.sh all
        ;;
    re)
        bash mk.sh clean
        bash mk.sh all
        ;;
    "")
        bash mk.sh all
        ;;
    *)
        ;;
esac