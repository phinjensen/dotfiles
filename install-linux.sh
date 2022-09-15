if [ -f /etc/os-release ]; then
	. /etc/os-release
fi

git submodule update --init
git config --global user.email "phin@zayda.net"
git config --global user.name "Phineas Jensen"

## NeoVim
echo "Setting up Neovim..."
cp -r nvim $XDG_CONFIG_HOME
# Install vim-plug https://github.com/junegunn/vim-plug
if [ "$NAME" -eq "Arch Linux" ]; then
  sudo pacman -S fzf xclip
else
  echo "Remember to isntall fzf and xclip (for proper clipboard handling)"
fi
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim .vim-plug-note +PlugInstall

echo "Setting up Kitty & Bash"
## Kitty
if [ "$NAME" -eq "Arch Linux" ]; then
  sudo pacman -S ttf-iosevka-nerd starship
  echo 'eval "$(starship init bash)"' >> ~/.bashrc
else
  echo "Remember to install the Iosveka Nerd fonts"
fi
cp -r kitty $XDG_CONFIG_HOME

echo "Setting up Awesome"
## Awesome
# TODO: Make prompts to edit awesome RC
cp -r awesome $XDG_CONFIG_HOME
