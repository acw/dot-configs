#!/bin/sh -e

pushd ${HOME}/.system/vim/pack/plugins/start
for d in `ls`; do
  if [ -d $d ]; then
    pushd $d
    git pull origin master
    popd
  fi
done
popd
