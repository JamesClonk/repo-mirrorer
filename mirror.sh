#!/bin/bash
set -e

if [ -z "${GITLAB_TOKEN}" ]; then
	echo "GITLAB_TOKEN is missing"
	exit 1
fi

# collect jcio repos
curl -s https://api.github.com/orgs/jamesclonk-io/repos | jq -r .[].html_url > jcio.txt

# collect jamesclonk repos
curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=1' | jq -r .[].html_url > jamesclonk.txt
curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=2' | jq -r .[].html_url >> jamesclonk.txt
curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=3' | jq -r .[].html_url >> jamesclonk.txt
curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=4' | jq -r .[].html_url >> jamesclonk.txt
curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=5' | jq -r .[].html_url >> jamesclonk.txt

# clone jcio repos
mkdir -p jcio || true
pushd jcio
for repo in $(cat ../jcio.txt); do
	rm -rf repo || true
	echo "cloning ${repo} ..."
	git clone ${repo} repo
	pushd repo
		GITLAB_URL=$(git remote get-url origin | sed "s/github.com/oauth2:${GITLAB_TOKEN}@gitlab.com/g") # https://oauth2:TOKEN@gitlab.com/${repo_org}/${repo_name}.git
		git remote add gitlab "${GITLAB_URL}.git" || git remote set-url gitlab "${GITLAB_URL}.git"
		echo "pushing to gitlab ..."
		git push -f gitlab
	popd
done
popd

# clone jamesclonk repos
mkdir -p jamesclonk || true
pushd jamesclonk
for repo in $(cat ../jamesclonk.txt); do
	rm -rf repo || true
	echo "cloning ${repo} ..."
	git clone ${repo} repo
	pushd repo
		GITLAB_URL=$(git remote get-url origin | sed "s/github.com/oauth2:${GITLAB_TOKEN}@gitlab.com/g") # https://oauth2:TOKEN@gitlab.com/${repo_org}/${repo_name}.git
		git remote add gitlab "${GITLAB_URL}.git" || git remote set-url gitlab "${GITLAB_URL}.git"
		echo "pushing to gitlab ..."
		git push -f gitlab
	popd
done
popd
