#!/bin/bash
# 
# Forked from https://stackoverflow.com/questions/46102041/git-get-worktree-for-every-branch-in-seperate-folders-bash
set -e

# Check if the ref directory already exists
if [[ -d ./branches/ref/ ]]; then
	echo "Seems like the ref directory is already checked out"
	pushd ./branches/ref/

	echo "git fetch to get the latest from origin"
	git fetch
	popd 
else
	echo "Seems like we haven't checked out the ref yet"
	mkdir -p ./branches/
	
	echo "Check out the ref directory"
	git clone git@github.com:smossber/git-branch-ensure-checkout.git ./branches/ref/
fi
	


#git clone --bare user@git-server:/your-repo.git && cd your-repo.git

echo "Moving in to ref branch" 
pushd ./branches/ref/

git for-each-ref --format='%(refname)' refs/heads/ | while read branchRef; do
  echo ""
  branchName=${branchRef#refs/heads/}

  echo "Creating Branch: ${branchName}"
  cp -rf ./ ../${branchName}
  pushd ../${branchName}
  git checkout -B ${branchName} origin/${branchName} -f
  popd

  #git clone git@github.com:smossber/git-branch-ensure-checkout.git ../../branches/${branchName}
  #git archive --format=tar --prefix="$branchName/" "$branchRef" | tar -C/var/www/html -x
done
