#!/bin/bash
mv book.pdf "$(git rev-parse HEAD).pdf"
git status
ls -la
cd $TRAVIS_BUILD_DIR/
ls -la
cd $HOME/	
ls -la
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request"
curl -H "Authorization: token ${GITHUB_TOKEN}" -X POST -d "{\"body\": \"Hello world\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
fi
