#!/bin/bash
exec >~/git-glider-install.log 2>&1

echo ">>>>> Installing Git Glider..."

# Check if curl, wget, or fetch is installed
if command -v curl >/dev/null 2>&1; then
  download_command="curl -fsSL"
elif command -v wget >/dev/null 2>&1; then
  download_command="wget -qO-"
elif command -v fetch >/dev/null 2>&1; then
  download_command="fetch -qo -"
else
  echo "Neither curl, wget nor fetch could be found. Please install one of them and try again."
  exit 1
fi

# Use the download command to download the script files
$download_command "https://raw.githubusercontent.com/krystalcampioni/git-glider/main/git-commands.sh?$(date +%s)" > ~/git-commands.sh
$download_command "https://raw.githubusercontent.com/krystalcampioni/git-glider/main/text-styles.sh?$(date +%s)" > ~/text-styles.sh

# Source the text-styles.sh and git-commands.sh scripts
. ~/text-styles.sh
. ~/git-commands.sh

# Check if the current shell is Bash or Zsh
if [ -n "$BASH_VERSION" ]; then
  shell="bash"
elif [ -n "$ZSH_VERSION" ]; then
  shell="zsh"
else
  colorPrint yellow $shell
  colorPrint red "❌ Unsupported shell. Please use Bash or Zsh."
  exit 1
fi

# Get the current shell
shell=$(basename "$SHELL")

# Determine the correct shell configuration file
if [ "$shell" = "zsh" ]; then
  config_file=~/.zshrc
elif [ "$shell" = "bash" ]; then
  if [ "$OSTYPE" = "darwin"* ]; then
    # MacOS uses .bash_profile
    config_file=~/.bash_profile
  else
    config_file=~/.bashrc
  fi
fi

colorPrint brightCyan "$shell $(colorPrint blue 'detected, modifying') $(colorPrint brightCyan $config_file)"

# Add a line to source the script files, if it's not already there
if ! grep -q "\. ~/git-commands.sh" "$config_file"; then
  echo ". ~/git-commands.sh" >> "$config_file"
fi
if ! grep -q "\. ~/text-styles.sh" "$config_file"; then
  echo ". ~/text-styles.sh" >> "$config_file"
fi

echo
colorPrint green "Git Glider has been installed successfully!  ✅"
colorPrint green "New terminal windows will now have access to it."
echo
colorPrint green "If you want to start using it straight away, please run the following command to start using Git Glider:"
colorPrint brightGreen ". ~/text-styles.sh && . ~/git-commands.sh"
echo 
echo 
colorPrint white "This project loves Oh My Zsh, a delightful community-driven framework for managing your Zsh configuration. Some of the aliases used in this project are defined in Oh My Zsh. If you haven't installed it yet, we highly recommend checking it out to enhance your terminal experience. Visit https://ohmyz.sh to learn more. ❤️"
