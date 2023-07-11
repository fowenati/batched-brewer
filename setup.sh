#!/bin/bash

# Define some colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Ask for the administrator password upfront
sudo -v

# Define default plugins
declare -a plugins=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions" "fzf")

# Check for Homebrew, Install if we don't have it
if test ! $(which brew); then
    printf "${GREEN}Homebrew is not installed. Installing homebrew now...${NC}\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Append brew to PATH
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    printf "${GREEN}Homebrew is already installed.${NC}\n"
fi

# Make sure we’re using the latest Homebrew.
printf "${GREEN}Updating Homebrew...${NC}\n"
brew update

# Upgrade any already-installed formulae.
printf "${GREEN}Upgrading any already-installed formulae...${NC}\n"
brew upgrade

# Installing oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    printf "${GREEN}Installing oh-my-zsh...${NC}\n"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    printf "${GREEN}oh-my-zsh is already installed.${NC}\n"
fi

# Installing powerlevel10k theme for oh-my-zsh
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    printf "${GREEN}Installing powerlevel10k theme for oh-my-zsh...${NC}\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i.bak 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k/powerlevel10k"/g' ~/.zshrc
else
    printf "${GREEN}powerlevel10k is already installed.${NC}\n"
fi

# Installing plugins
for plugin in "${plugins[@]}"
do
    if brew list $plugin; then
        printf "${GREEN}$plugin is already installed${NC}\n"
    else
        printf "${GREEN}Installing $plugin${NC}\n"
        brew install $plugin
    fi
    if ! grep -q "/usr/local/share/$plugin" /Users/$MAC_USER/.zprofile; then
        echo "source /usr/local/share/$plugin/$plugin.zsh" >> ~/.zprofile
    fi
done

# Decide whether to use config file or manual entry
echo "Do you want to use the configuration file (config.txt) for the packages to install? (y/n)"
read use_config

if [[ "$use_config" == "y" ]]; then
    # Source the configuration file
    if [ -f "config.txt" ]; then
        source config.txt
    else
        printf "${RED}Error: config.txt not found.${NC}\n"
        exit 1
    fi
else
    # Get the packages to install
    echo "Please enter the packages to install, separated by space:"
    read -a PACKAGES
    echo "Please enter the casks to install, separated by space:"
    read -a CASKS
fi

# Iterate through each package in PACKAGES and install if it's not already installed
for package in "${PACKAGES[@]}"; do
    if brew list $package; then
        printf "${GREEN}$package is already installed${NC}\n"
    else
        printf "${GREEN}Installing $package${NC}\n"
        brew install $package
    fi
done

# Iterate through each cask in CASKS and install if it's not already installed
for cask in "${CASKS[@]}"; do
    if brew list --cask $cask; then
        printf "${GREEN}$cask is already installed${NC}\n"
    else
        printf "${GREEN}Installing $cask${NC}\n"
        brew install --cask $cask
    fi
done

# Remove outdated versions from the cellar.
printf "${GREEN}Cleaning up...${NC}\n"
brew cleanup

printf "${GREEN}Installation complete!${NC}\n"
