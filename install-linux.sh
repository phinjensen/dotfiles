set -e

if [ -f /etc/os-release ]; then
	source /etc/os-release
fi

PACKAGES="awesome fzf keepassxc light neovim starship syncthing ttc-iosevka ttf-nerd-fonts-symbols-2048-em-mono xclip xorg-server xorg-xinit xscreensaver"

if [ "$NAME" = "Arch Linux" ]; then
  sudo pacman --needed -S $PACKAGES
else
  echo "Install the following programs and files:"
  echo $PACKAGES | sed 's/ /\n/g' | cat
  exit 1
fi

# Set up nerd font
sudo ln -fs /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/
sudo sed -i 's/Symbols Nerd Font/Symbols Nerd Font Mono/' /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf
fc-cache

# Add user to video group for light
sudo usermod -aG video phin

# Set up xinit and bash_profile
cp xinitrc ~/.xinitrc
cp Xresources ~/.Xresources
cp bash_profile ~/.bash_profile
source ~/.bash_profile

# Enable Syncthing
sudo systemctl enable syncthing@phin.service
sudo systemctl start syncthing@phin.service

## Configure Git
git submodule update --init
git config --global user.email "phin@zayda.net"
git config --global user.name "Phineas Jensen"

## Set upNeoVim
echo "Setting up Neovim..."
cp -r nvim $XDG_CONFIG_HOME
# Install vim-plug https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim .vim-plug-note +PlugInstall

## Kitty
echo "Setting up Kitty & Bash"
cp -r kitty $XDG_CONFIG_HOME

## Awesome
echo "Setting up Awesome"
cp -r awesome $XDG_CONFIG_HOME
# TODO: Make prompts to edit awesome RC

## Fonts
cp -r fontconfig $XDG_CONFIG_HOME

## Wallpapers
cp -r wallpapers ~

cp bashrc ~/.bashrc
cat bash_profile_startx >> ~/.bash_profile
echo "You should be all set up. Log out and log back in to finalize changes."
