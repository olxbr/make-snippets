# EXPORTS git related variables

# Default git branch
GIT_BRANCH?=origin/master

# points to a commit hash 
COMMIT_HASH=$(shell git rev-parse --short=7 HEAD)

# prepends a commit count to the commit hash 
VERSION?=$(shell git show --format=%cd --date=format:'%y%m%d.%H%M' $(COMMIT_HASH) | head -n 1)-$(COMMIT_HASH)
