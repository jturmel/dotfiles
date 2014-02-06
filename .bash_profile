function setvmip() {
    echo "Setting youversionapidev.com domains to $1"
    cat /etc/hosts|sed -E "/youversionapidev/ s/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/$1/" | sudo tee /etc/hosts > /dev/null;
    cat /etc/hosts|sed -E "/yvdev.com/ s/([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/$1/" | sudo tee /etc/hosts > /dev/null;
    echo "Clearing out any .ssh/known_hosts entries for youversionapidev.com"
    ssh-keygen -R youversionapidev.com &> /dev/null;
    ssh-keygen -R yvdev.com &> /dev/null;
    echo "Flushing local DNS cache"
    # OS X 10.5 & 10.6
    dscacheutil -flushcache
    # OS X 10.7 & 10.8
    sudo killall -HUP mDNSResponder
}

function gitrm() {
    git diff --diff-filter=D --name-only -z | xargs -0 git rm
}

function updatectags() {
    cd $1
    exec ctags -f $1/.ctags \
        -h \".php\" -R \
        --exclude=\"\.git\" \
        --totals=yes \
        --tag-relative=yes \
        --PHP-kinds=+cf \
        --regex-PHP='/abstract class ([^ ]*)/\1/c/' \
        --regex-PHP='/interface ([^ ]*)/\1/c/' \
        --regex-PHP='/(public |static |abstract |protected |private )+function ([^ (]*)/\2/f/''])'
}

# Open all files from git status in vim
function gitvim() {
    vim $(git status --porcelain | cut -c 4-)
}

# Purge file from git repo, all history, forever
function gitpurge() {
    git filter-branch --index-filter 'git rm --cached --ignore-unmatch $1' --prune-empty --tag-name-filter cat -- --all 
}


# The next line updates PATH for the Google Cloud SDK.
export PATH=/Users/jturmel/google-cloud-sdk/bin:$PATH
