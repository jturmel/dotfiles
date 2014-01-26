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

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git osx vi-mode keybindings)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/opt/local/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin

[[ -s $HOME/.pythonbrew/etc/bashrc ]] && source $HOME/.pythonbrew/etc/bashrc

source $HOME/.bashrc

source $HOME/.bash_profile

#bindkey "^[OA" up-line-or-search

# Appends every command to the history file once it is executed
setopt inc_append_history
# # Reloads the history whenever you use it
setopt share_history

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

if [[ -s "/Users/jturmel/.rvm/scripts/rvm"  ]] ; then source "/Users/jturmel/.rvm/scripts/rvm" ; fi

#source /usr/local/bin/powerline/powerline/bindings/zsh/powerline.zsh
#source /Users/jturmel/.pythonbrew/pythons/Python-2.7.3/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

rvm use 1.9.3 >> /dev/null

alias timestamp="date +%s"

alias cph="history | tail -n 1 | sed -E 's/^[0-9]+ +//' | tr -d '\n' | pbcopy"

#alias git=hub

export VIRTUAL_ENV_DISABLE_PROMPT=1

export PSALTY_USER=jturmel

eval "$(/Users/jturmel/Development/yv/bin/yv init -)"

GRADLE_HOME=/Users/jturmel/Development/gradle

export GRADLE_HOME
export PATH=$PATH:$GRADLE_HOME/bin

export PATH=$PATH:/Applications/Android\ Studio.app/sdk/tools:/Applications/Android\ Studio.app/sdk/platform-tools

# The next line updates PATH for the Google Cloud SDK.
export PATH=/Users/jturmel/google-cloud-sdk/bin:$PATH
