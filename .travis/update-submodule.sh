#!/bin/bash

cd gitignore
git pull origin master
cd ..

pwd
if [[ `git status --porcelain` ]]; then
  echo "status: Updating templates"
  git add .
  git commit -m "Upading templates from https://github.com/dvcs/gitignore"
  git push origin master
else
  echo "status: No updates"
fi
