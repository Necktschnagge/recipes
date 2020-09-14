#!/bin/bash
#params
	#1: ${GH_TRAVIS_TOKEN}
	#2: ${TRAVIS_REPO_SLUG}
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request build. Start uploading pdf build artifact..."
pushd .
git_hash=$(git rev-parse HEAD)
cd $HOME/
mkdir artifact-upload
cd artifact-upload
git clone "https://github.com/${2}.git" .
git checkout artifacts
cd artifacts
mv $TRAVIS_BUILD_DIR/src/book.pdf "${git_hash}.pdf"
ls -la
git commit -m "Automatic upload of preview pdf" '${git_hash}.pdf'
git push
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
