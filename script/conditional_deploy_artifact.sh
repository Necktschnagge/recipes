#!/bin/bash
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request build: https://github.com/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}"
echo "Check labels of pull request ${TRAVIS_PULL_REQUEST}"
labels=$(curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X GET "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/labels")
echo $labels
[[ $labels =~ ^.*2352840377.*$ ]] && echo "Found ID (2352840377) of label >disable-preview<. Abort preview deployment." && exit 0
echo "Start uploading pdf build artifact..."
pushd .
git_hash=$(git rev-parse HEAD)
cd $HOME/
mkdir artifact-upload
cd artifact-upload
git clone "https://github.com/${TRAVIS_REPO_SLUG}.git" .
git checkout artifacts
echo ">>>>> git merge origin/master"
git merge origin/master
cd artifacts
mv $TRAVIS_BUILD_DIR/src/book.pdf "${git_hash}.pdf"
git status
echo ">>>>> git add -f ./${git_hash}.pdf"
git add -f "./${git_hash}.pdf"
echo ">>>>> git commit -m \"Automatic upload of preview pdf\""
git commit -m "[skip travis] Automatic upload of preview pdf"
echo ">>>>> git status"
git status
echo ">>>>> git push"
git push https://${TRAVIS_USERNAME}:${TRAVIS_PASSWORD}@github.com/Necktschnagge/recipes HEAD
echo "Uploading pdf build artifact... DONE"
popd
if [[ $labels =~ ^.*2352896968.*$ ]] ; then
echo "Found ID (2352896968) of label >disable-preview<. Skip posting a comment to the pull request."
exit 0
fi
echo "Posting comment into pull request..."
curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X POST -d "{\"body\": \"See build preview here: [${git_hash}.pdf](https://github.com/Necktschnagge/recipes/blob/artifacts/artifacts/${git_hash}.pdf)\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
else 
echo "This is no pull request build. Skipping artifact upload."
fi
