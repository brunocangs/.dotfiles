#!/bin/bash
eval "$(fzf --zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="/usr/local/opt/ruby/bin:$PATH"
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH:$HOME/.mint/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

bp () {
    nvim ~/.zshrc
}


pm() {
    cd $(git rev-parse --show-toplevel) &> /dev/null
    MANAGER="pnpm"
    if [ -f yarn.lock ]; then
        MANAGER="yarn"
    elif [ -f pnpm-lock.yaml ]; then
        MANAGER="pnpm"
    elif [ -f package-lock.json ]; then
        MANAGER="npm"
    elif [ -f pnpm-lock.yaml ]; then
        MANAGER="pnpm"
    fi
    cd - &> /dev/null
    $MANAGER "$@"
}

dpm() {
    cd $(git rev-parse --show-toplevel) &> /dev/null
    MANAGER="pnpm"
    if [ -f yarn.lock ]; then
        MANAGER="yarn"
    elif [ -f pnpm-lock.yaml ]; then
        MANAGER="pnpm"
    elif [ -f package-lock.json ]; then
        MANAGER="npm"
    elif [ -f pnpm-lock.yaml ]; then
        MANAGER="pnpm"
    fi
    cd - &> /dev/null
    doppler run -- $MANAGER "$@"
}

cd_git_root () {
    cd $(git rev-parse --show-toplevel) > /dev/null
}
alias gr="cd_git_root"

vimc () {
    cd ~/.config/nvim
    nvim .
}

v () {
    nvim .
}

cdp () {
    selected=$(find ~/Projects ~/Study -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    [[ -z $selected ]] && return
    cd $selected
}

vp () {
    selected=$(find ~/Projects ~/Study -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    [[ -z $selected ]] && return
    cd $selected
    nvim .
}

dcup () {
    selected=$(find -L ~/ProjectsDocker -mindepth 1 -maxdepth 1 -not \( -name volumes -o -name \.git \) -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    [[ -z $selected ]] && return
    cd $selected
    docker-compose up
}

shad() {
    pnpm dlx shadcn-ui@latest "$@";
}

docs() {
    selected=$(find ~/Documents -mindepth 1 -maxdepth 1 -type d | fzf --preview 'ls {}' --query "$1" --print0 --select-1)
    [[ -z $selected ]] && return
    open $selected
}

llm() {
    ollama run mistral
}

# vimdiff() {
#     [[ $# -lt 1 ]] && echo "Usage: vimdiff <branch>" && return
#     for file in $(git diff --name-only $1); do
#         nvim -c "Gdiffsplit $1" $file;
#     done
# }

alias ggraph="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
# Set the base directory for Chrome profiles
CHROME_PROFILES_DIR=~/Library/Application\ Support/Google/Chrome

# This took way, way too long. At least it works
# Define a function to find and print Chrome profile names using fuzzy matching
chrome() {
    # Use find to locate directories starting with 'Profile' under the given base directory
    # print0 will use null character as delimiter instead of spaces or line breaks
    PROFILES=$(find "$CHROME_PROFILES_DIR" -type d \( -name "Profile*" -o -name "Default*" \) -mindepth 1 -maxdepth 1 -print0)
    # echo -n $PROFILES \
    #     | xargs -r -0 -I {} basename "{}"
    # -r will skip the initial empty line, or something like that. Will avoid 1 empty result
    # -0 will make it work with -print0
    # -I will replace {} in the string with the current parameter
    # will run fzf, split the string on the : character, and print the second part, which will not include :
    # Will split in the :, and return the first part. In this case it's the profile folder we need
    PROFILE=$(echo -n $PROFILES \
        | xargs -r -0 -I {} bash -c 'echo "$(basename "{}")":"$(jq -r ".profile.name" "{}"/Preferences)"' \
        | fzf --with-nth=2 --delimiter=":" --query "$1" --select-1\
        | awk -F: '{print $1}')

  # if no profile selected, exit
  if [ -z "$PROFILE" ]; then
      return
  fi
  open -n -a "Google Chrome" --args --profile-directory="$PROFILE"
} 

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export DEFAULT_USER="$(whoami)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/brunocangussu/google-cloud-sdk/path.zsh.inc'; fi

alias vim=nvim

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

PATH=~/.console-ninja/.bin:$PATH

. /opt/homebrew/opt/asdf/libexec/asdf.sh
