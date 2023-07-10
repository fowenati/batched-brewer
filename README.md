# Batched Brewer

This repository contains a shell script (`setup.sh`) and a configuration file (`config.txt`) that automate the installation of your MacOS environment.

## Pre-requisites

- MacOS system
- Administrator access

## Setup Instructions

1. Clone this repository or download the `setup.sh` and `config.txt` files.
   
```bash
git clone https://github.com/your-repo/mac-setup.git
cd mac-setup
```


2. Open the `config.txt` file and replace `your_username` with your MacOS username.

```plaintext
MAC_USER=your_username
FORMULAE="formula1 formula2 formula3 ..."
CASKS="cask1 cask2 cask3 ..."
```
The `FORMULAE` line should be a space-separated list of brew formulae you want to install. Similarly, `CASKS` should be a space-separated list of brew casks you want to install.

3. Run the `setup.sh` script. You may need to set it as executable first.

```bash
chmod +x setup.sh
./setup.sh
```

Upon execution, the script will:

- Prompt for your administrator password
- Install Homebrew if it is not installed
- Update Homebrew
- Install Oh-My-Zsh and Powerlevel10k theme
- Install the plugins defined in `setup.sh`
- Install the formulae and casks defined in `config.txt`
- Cleanup any outdated versions from Homebrew

You can also run the script without using the `config.txt` file. In this case, it will fetch the list of formulae and casks from `https://formulae.brew.sh/`, allowing you to select which ones to install.

Enjoy your customized MacOS environment!
