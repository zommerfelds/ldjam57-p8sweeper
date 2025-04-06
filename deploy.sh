#!/usr/bin/env sh
set -e

mkdir deploy

/c/Program\ Files\ \(x86\)/PICO-8/pico8.exe -export deploy/index.html p8sweeper.p8

cd deploy

git init
git add .
git commit -m 'deploy'

git push -f https://github.com/zommerfelds/ldjam57-p8sweeper.git main:gh-pages

cd -
rm -rf deploy