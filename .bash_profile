function gitrm() {
    git diff --diff-filter=D --name-only -z | xargs -0 git rm
}

# Open all files from git status in vim
function gitvim() {
    vim $(git status --porcelain | cut -c 4-)
}

# Purge file from git repo, all history, forever
function gitpurge() {
    git filter-branch --index-filter 'git rm --cached --ignore-unmatch $1' --prune-empty --tag-name-filter cat -- --all 
}
