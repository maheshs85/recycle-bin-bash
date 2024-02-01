#!/bin/bash

readonly JUNK_DIR=~/.junk

function help {
cat <<EOF
Usage: `basename $0` [-hlp] [list of files]
  -h: Display help.
  -l: List junked files.
  -p: Purge all files.
  [list of files] with no other arguments to junk those files.
EOF
}

function create_junk_dir {
  if [ ! -d $JUNK_DIR ]; then
    mkdir $JUNK_DIR
  fi
}

function list_junk_dir {
  create_junk_dir;
  ls -lAF $JUNK_DIR;
}

function purge_junk_dir {
  rm -rf $JUNK_DIR/{..?*,.[!.]*,*};
}

function add_junk_dir {
  create_junk_dir
  mv "$1" $JUNK_DIR;
}

if [ $# -eq 0 ]
then
  help
  exit 1
fi

FLAGS=''
while getopts ":hlp" opt
do
  case $opt in
    h) FLAGS+='h' ;;
    l) FLAGS+='l' ;;
    p) FLAGS+='p' ;;
    *) echo "Error: Unknown option '-$OPTARG'."; help; exit 1;;
    ?) help; exit 1;; 
  esac
done

if [[ "$FLAGS" = "h" ]]; then
  help; exit 0;
elif [[ "$FLAGS" = "l" ]]; then
  list_junk_dir; exit 0;
elif [[ "$FLAGS" = "p" ]]; then
  purge_junk_dir; exit 0;
elif [[ "$FLAGS" != "" ]]; then
  echo "Error: Too many options enabled."
  help; exit 1;
fi

for file in "$@"
  do
    if [ ! -e "$file" ]; then
        echo "Warning: '"$file"' not found."
    else
        add_junk_dir "$file"
    fi
  done