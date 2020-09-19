#!/bin/bash
if [ "$TRAVIS_PULL_REQUEST" != "false" ] ; then # it is a pull request build.
echo "This is a pull request build: https://github.com/${TRAVIS_REPO_SLUG}/pull/${TRAVIS_PULL_REQUEST}"
echo "Check labels of pull request ${TRAVIS_PULL_REQUEST}:"
labels=$(curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X GET "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/labels")
echo $labels
[[ $labels =~ ^.*2352840377.*$ ]] && echo "Found ID (2352840377) of label >disable-preview<. Abort preview deployment." && exit 0
echo "Start uploading pdf build artifact..."
pushd .
git_hash=$(git rev-parse HEAD^2) # travis merges the current commit into something different. Therefore on CI there is always one commit more. -> use ^2 for merge ancestor (see https://medium.com/@gabicle/git-ancestry-references-explained-bd3a84a0b821)
cd $HOME/
mkdir artifact-upload
cd artifact-upload
git clone "https://github.com/${TRAVIS_REPO_SLUG}.git" .
git checkout artifacts
echo ">>>>> git merge origin/master"
git merge origin/master # this is possible concurrent to other commits
cd artifacts
mv $TRAVIS_BUILD_DIR/src/book.pdf "${git_hash}.pdf" # if the file is already present, mv overwrites the old one.
git status
echo ">>>>> git add -f ./${git_hash}.pdf"
git add -f "./${git_hash}.pdf"
echo ">>>>> git commit -m \"Automatic upload of preview pdf\""
git commit -m "Automatic upload of preview pdf" # this is possible concurrent to other commits
echo ">>>>> git status"
git status
echo ">>>>> git push" #this may fail after concurrent commits:
git push https://${TRAVIS_USERNAME}:${TRAVIS_PASSWORD}@github.com/Necktschnagge/recipes HEAD
iwantthis to be an error ---- here check if push not successful.
"{
	git branch my-local-artifacts #new pointer to our own stuff.
	git fetch
	git merge origin/artifacts # is the fetch before unnecessary?
	// check for merge conflict.
	no conflict -> try push again. countdown a tries-left counter
	if merge conflict -> seems to be a pathological case. rerun? / fail build?		
}"
echo "Uploading pdf build artifact... DONE"
popd
if [[ $labels =~ ^.*2352896968.*$ ]] ; then
echo "Found ID (2352896968) of label >skip-preview-link<. Skip posting a comment to the pull request linking to the preview PDF."
exit 0
fi
echo "Posting comment into pull request..."
curl -H "Authorization: token ${GH_TRAVIS_TOKEN}" -X POST -d "{\"body\": \"See build preview here: [${git_hash}.pdf](https://github.com/Necktschnagge/recipes/blob/artifacts/artifacts/${git_hash}.pdf)\"}" "https://api.github.com/repos/${TRAVIS_REPO_SLUG}/issues/${TRAVIS_PULL_REQUEST}/comments"
else 
echo "This is no pull request build. Skipping artifact upload."
fi
