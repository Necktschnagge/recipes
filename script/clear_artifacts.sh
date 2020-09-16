#!/bin/bash
go_back=$(git branch --show-current)
pushd .
cd ..
git checkout master
git branch --delete --force artifacts
git push origin --delete artifacts
git branch artifacts
git checkout artifacts
mkdir artifacts
cd artifacts
touch dummy
git add -f ./dummy
git commit -m "add dummy file"
git push --set-upstream origin artifacts
popd
git checkout $go_back