#!/bin/bash
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request build. Start uploading pdf build artifact..."
pushd
git_hash=$(git rev-parse HEAD)
mv book.pdf "$(git rev-parse HEAD).pdf"
#git status
#ls -la
#cd $TRAVIS_BUILD_DIR/
#ls -la
#cd $HOME/	
#ls -la
popd
curl -H "Authorization: token ${1}" -X POST -d "{\"body\": \"[See build preview here](https://github.com/Necktschnagge/recipes/blob/artifacts/artifacts/${git_hash}.pdf)\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
else 
echo "This is no pull request build. Skipping artifact upload."
fi
