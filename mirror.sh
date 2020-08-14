#!/bin/bash

# # collect jcio repos
# curl -s https://api.github.com/orgs/jamesclonk-io/repos | jq -r .[].html_url > jcio.txt

# # collect jamesclonk repos
# curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=1' | jq -r .[].html_url > jamesclonk.txt
# curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=2' | jq -r .[].html_url >> jamesclonk.txt
# curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=3' | jq -r .[].html_url >> jamesclonk.txt
# curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=4' | jq -r .[].html_url >> jamesclonk.txt
# curl -s 'https://api.github.com/users/JamesClonk/repos?per_page=100&page=5' | jq -r .[].html_url >> jamesclonk.txt

# clone jcio repos
for repo in $(cat jcio.txt); do
	echo "cloning ${repo} ..."
	echo "git clone ${repo}"
done
