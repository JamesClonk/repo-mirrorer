#!/bin/bash
set -e

if [ -z "${GITHUB_TOKEN}" ]; then
	echo "GITHUB_TOKEN is missing"
	exit 1
fi
if [ -z "${GITLAB_TOKEN}" ]; then
	echo "GITLAB_TOKEN is missing"
	exit 1
fi

# wait a bit
sleep 33

# collect jcio repos
echo "collecting [jamesclonk-io] repos ..."
rm -f /tmp/jcio.txt || true
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/orgs/jamesclonk-io/repos' | jq -r '.[].html_url' > /tmp/jcio.txt
echo "$(cat /tmp/jcio.txt | wc -l) repos found."

# clone jcio repos
mkdir -p /tmp/jcio || true
pushd /tmp/jcio
for repo in $(cat /tmp/jcio.txt); do
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

# collect jamesclonk repos
echo "collecting [JamesClonk] repos ..."
rm -f /tmp/jamesclonk.txt || true
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/user/repos?per_page=100&page=1&visibility=all&affiliation=owner' | jq -r '.[].html_url' > /tmp/jamesclonk.txt
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/user/repos?per_page=100&page=2&visibility=all&affiliation=owner' | jq -r '.[].html_url' >> /tmp/jamesclonk.txt
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/user/repos?per_page=100&page=3&visibility=all&affiliation=owner' | jq -r '.[].html_url' >> /tmp/jamesclonk.txt
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/user/repos?per_page=100&page=4&visibility=all&affiliation=owner' | jq -r '.[].html_url' >> /tmp/jamesclonk.txt
curl -H 'Accept: application/vnd.github.v3+json' -s -H "Authorization: token ${GITHUB_TOKEN}" \
	'https://api.github.com/user/repos?per_page=100&page=5&visibility=all&affiliation=owner' | jq -r '.[].html_url' >> /tmp/jamesclonk.txt
echo "$(cat /tmp/jamesclonk.txt | wc -l) repos found."

# clone jamesclonk repos
mkdir -p /tmp/jamesclonk || true
pushd /tmp/jamesclonk
for repo in $(cat /tmp/jamesclonk.txt); do
	rm -rf repo || true
	echo "cloning ${repo} ..."
	GITHUB_URL=$(echo "${repo}" | sed "s/github.com/JamesClonk:${GITHUB_TOKEN}@github.com/g")
	git clone ${GITHUB_URL} repo
	pushd repo
		GITLAB_URL=$(echo "${repo}" | sed "s/github.com/oauth2:${GITLAB_TOKEN}@gitlab.com/g") # https://oauth2:TOKEN@gitlab.com/${repo_org}/${repo_name}.git
		git remote add gitlab "${GITLAB_URL}.git" || git remote set-url gitlab "${GITLAB_URL}.git"
		echo "pushing to gitlab ..."
		git push -f gitlab
	popd
done
popd
