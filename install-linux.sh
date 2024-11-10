set -e

if [ -f /etc/os-release ]; then
	source /etc/os-release
fi

PACKAGES="awesome fzf keepassxc kitty neovim noto-fonts picom starship syncthing ttc-iosevka ttf-nerd-fonts-symbols-mono xclip xorg-server xorg-setxkbmap xorg-xinit xscreensaver"
# TODO: Add back an alternative to light

if [ "$NAME" = "Arch Linux" ]; then
  sudo pacman --needed -S $PACKAGES
else
  echo "Install the following programs and files:"
  echo $PACKAGES | sed 's/ /\n/g' | cat
  exit 1
fi

echo "Installing nerd font..."
sudo ln -fs /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/
sudo sed -i 's/Symbols Nerd Font/Symbols Nerd Font Mono/' /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf
fc-cache

echo "Setting up xinit and bash_profile..."
cp xinitrc ~/.xinitrc
cp Xresources ~/.Xresources
cp bash_profile ~/.bash_profile
source ~/.bash_profile

echo "Configuring keyboard..."
localectl set-x11-keymap us,ir pc104 "" grp:rwin_toggle,ctrl:nocaps

echo "Enabling syncthing..."
sudo systemctl enable syncthing@phin.service
sudo systemctl start syncthing@phin.service

echo "Configuring git..."
git submodule update --init
git config --global user.email "phin@zayda.net"
git config --global user.name "Phineas Jensen"

echo "Setting up Neovim..."
cp -r nvim $XDG_CONFIG_HOME/nvim/
# Install vim-plug https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim .vim-plug-note +PlugInstall

echo "Setting up Kitty..."
cp -r kitty $XDG_CONFIG_HOME

echo "Setting up Awesome..."
cp -r awesome $XDG_CONFIG_HOME
# TODO: Make prompts to edit awesome RC

echo "Setting up font config..."
cp -r fontconfig $XDG_CONFIG_HOME

echo "Setting wallpaper..."
cp -r wallpapers ~

echo "Configuring tmux..."
cp tmux.conf ~/.tmux.conf

echo "Configuring picom..."
cp picom.conf $XDG_CONFIG_HOME

echo "Configuring bash..."
cp bashrc ~/.bashrc
cat bash_profile_startx >> ~/.bash_profile
echo "You should be all set up. Log out and log back in to finalize changes."
