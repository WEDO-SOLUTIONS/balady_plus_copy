#!/bin/bash

# if any command inside script returns error, exit and return that error
set -euo pipefail

# add common functions to PATH, so we can use them in this script
export PATH="$PATH":"$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/common_functions"

# Enable color output
export TERM=xterm-256color

# go to project root
cd $(git rev-parse --show-toplevel)

# show warning on cool linux distros.
if [[ $(uname) != "Darwin" ]]; then
    echo "Script is mainly developed for Macos, investigate script in case of problems"
    echo "Script located at:"
    print_style 'bold' 'yellow' "$0"
    print_style '' 'yellow' 'press ^C to abort (3 sec left)'
    sleep 3
    echo 'continue...'
    echo
fi

# install brew if needed
if command -v brew &> /dev/null; then
    print_style '' 'yellow' "brew is available, continue..."
else
    echo "brew is not available"
    print_style '' 'yellow' "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    print_style '' 'yellow' "Brew installed"
fi

echo
print_style 'italic' 'yellow' 'Install required programms...'
echo

# install `fvm` if not available
brew_install fvm leoafarias/fvm
brew_install localazy localazy/tools
brew_install just
brew_install lefthook

# remove cocoapods from gem and install them from brew
# gem provide very old cocoapods
echo 
print_style 'bold' 'yellow' 'remove cocoapods from gem! Take into account this!'
gem uninstall cocoapods
if which pod | grep -q 'homebrew'; then
    print_style '' 'yellow' 'cocoapods from brew  already installed!'
else
    brew_install cocoapods
fi

# set up fvm version
echo
print_style '' 'yellow' '> setup flutter fvm env...'
{ yes || :; } | fvm use 3.44.5
print_style '' 'yellow' '< fvm env ready!'

# configure lefthook
echo
print_style '' 'yellow' '> setup lefthook...'
lefthook install
print_style '' 'yellow' '< lefthook ready!'

# configure pods
echo
print_style '' 'yellow' '> setup ios...'
fvm flutter pub get
fvm flutter precache --ios
cd ios
if pod install; then
    print_style '' 'yellow' 'Pods installed successfully!'
else
    print_style '' 'yellow' 'Pods installation failed. Updating pod repo and trying again...'
    pod repo update
    pod update
    pod install
fi
cd $(git rev-parse --show-toplevel)
print_style '' 'yellow' '< ios ready!'


# goodbye
print_style 'bold' 'green' "Dev environment is ready! 🚀"
echo
echo
print_style '' 'green' 'Run this command to generate all required things in project:'
print_style 'bold' 'cyan' 'just prebuild'
