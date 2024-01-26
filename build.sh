#!/bin/bash

case "$1" in
    cl)
        make -j12 clean
        ;;
    mk)
        make -j12 all
        ;;
    re)
        make -j12 clean
        make -j12 all
        ;;
    "")
        make -j12 all
        ;;
    *)
        ;;
esac