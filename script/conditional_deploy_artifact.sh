#!/bin/bash
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request build. Start uploading pdf build artifact..."
pushd .
git_hash=$(git rev-parse HEAD)
cd $HOME/
mkdir artifact-upload
cd artifact-upload
git clone "https://github.com/${TRAVIS_REPO_SLUG}.git" .
git checkout artifacts
cd artifacts
mv $TRAVIS_BUILD_DIR/src/book.pdf "${git_hash}.pdf"
ls -la
cat .git/config
git status
git add -f "./${git_hash}.pdf"
git status
git commit -m "Automatic upload of preview pdf"
git status
git push https://${TRAVIS_USERNAME}:${TRAVIS_PASSWORD}@github.com/Necktschnagge/recipes HEAD
popd
curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X GET -d "{\"body\": \"[See build preview here: ${git_hash}.pdf](https://github.com/Necktschnagge/recipes/blob/artifacts/art"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/labels"

curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X POST -d "{\"body\": \"[See build preview here: ${git_hash}.pdf](https://github.com/Necktschnagge/recipes/blob/artifacts/artifacts/${git_hash}.pdf)\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
else 
echo "This is no pull request build. Skipping artifact upload."
fi
