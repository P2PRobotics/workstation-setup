#!/bin/bash -e
mkdir -p ${HOME}/P2PRobotics

## TODO
# git bash prompt sugar
# divvy config
# iterm config
# caffeine config


BREW='sudo -Hiu admin brew'

# bash
[[ ! -f ${HOME}/.bash_profile ]] && touch ${HOME}/.bash_profile

function addToBashProfile() {
  grep -q -F "${1}" ${HOME}/.bash_profile || ( echo "${1}" >> ${HOME}/.bash_profile)
}

addToBashProfile '[ -r "$HOME"/.bashrc ] && source "$HOME"/.bashrc'
addToBashProfile "alias ll='ls -laG'"
addToBashProfile "alias gs='git status'"
addToBashProfile '[ "$USER" != "admin" ] && alias brew="sudo -Hiu admin brew"'
addToBashProfile '[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion'
addToBashProfile 'LSCOLORS=gxfxcxdxbxegedabagacad; export LSCOLORS'

## Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock workspaces-swoosh-animation-off -bool true
defaults write com.apple.dock tilesize -int 20
killall Dock


# Enable sound effects when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1

# Disable sounds effects for user interface changes
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# Don't show Siri in the menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false



## Finder
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder AppleShowAllFiles -bool false

## Keyboard
defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms)

## Homebrew
[ -x /usr/local/bin/brew ] || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
function _brew {
    if ${BREW} ls --versions "$1" >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 ${BREW} upgrade "$1" || :
    else
        HOMEBREW_NO_AUTO_UPDATE=1 ${BREW} install "$1"
    fi
}

function _brew_cask {
    if ${BREW} cask ls --versions "$1" >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 ${BREW} cask upgrade "$1" || :
    else
        HOMEBREW_NO_AUTO_UPDATE=1 ${BREW} cask install "$1"
    fi
}

_brew bash
_brew openssl
_brew curl
_brew wget
_brew git
_brew bash-completion
_brew ripgrep
_brew gdub
_brew_cask java
_brew_cask sublime-text
_brew_cask iterm2
_brew_cask android-platform-tools
_brew_cask caffeine
_brew_cask flux

${BREW} doctor

# git config
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global credential.helper ""
git config --global --unset user.name
git config --global --unset user.email
git config --global user.email p2proboticsftc@gmail.com
git config --global user.name "Puma Robotics"
