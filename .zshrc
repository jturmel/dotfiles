# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git ruby brew cp)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/git/bin:$PATH"
# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='vim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Reloads the history whenever you use it
setopt share_history

export PYTHONPATH=/lib/python2.7/site-packages:$PYTHONPATH
export PYENV_VERSION=2.7.10

# Setting up the VirtualEnv
export WORKON_HOME=$HOME/.virtualenvs
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python
export VIRTUALENVWRAPPER_PYTHON=/Users/jturmel/.pyenv/shims/python
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
source /bin/virtualenvwrapper.sh

export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

export PATH=$PATH:/usr/local/sbin/

source ~/.tmuxinator.zsh

export PATH=$PATH:/Applications/Android\ Studio.app/sdk/tools/:/Applications/Android\ Studio.app/sdk/platform-tools/

source $HOME/.nvm/nvm.sh
nvm use default

export GAE_SDK_ROOT=/Users/jturmel/google-cloud-sdk/platform/google_appengine

export PATH=$PATH:~/Library/android-sdk-macosx/platform-tools
export PATH=$PATH:~/Library/android-sdk-macosx/tools

export ANDROID_HOME=~/Library/android-sdk-macosx/tools

export PYTHONPATH=$PYTHONPATH:$GAE_SDK_ROOT

# The next line updates PATH for the Google Cloud SDK.
source '/Users/jturmel/google-cloud-sdk/path.zsh.inc'

# The next line enables zsh completion for gcloud.
source '/Users/jturmel/google-cloud-sdk/completion.zsh.inc'


eval "$(rbenv init -)"

eval "$(docker-machine env tt)"

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

