#!/bin/bash

#"""""""""""""""""""""""""""""""""""""
#""" Installing essential programs """
#"""""""""""""""""""""""""""""""""""""

#Install docker
sudo dnf -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine-selinux \
                  docker-engine

sudo dnf -y install dnf-plugins-core

sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo systemctl start docker

sudo docker run hello-world

sudo groupadd docker
sudo usermod -aG docker $USER

#Installing Flatpak Apps
sudo flatpak install -y flathub com.getpostman.Postman
sudo flatpak install -y flathub org.telegram.desktop
sudo flatpak install -y flathub com.slack.Slack
sudo flatpak install -y flathub com.obsproject.Studio
sudo flatpak install -y flathub com.spotify.Client
sudo flatpak install -y flathub org.onlyoffice.desktopeditors

#Installing Spotify
git clone https://github.com/abba23/spotify-adblock.git ~/.personal/spotify-adblock
cd ~/.personal/spotify-adblock
make
sudo make install

sudo mkdir -p ~/.spotify-adblock && cp target/release/libspotifyadblock.so ~/.spotify-adblock/spotify-adblock.so
sudo mkdir -p ~/.config/spotify-adblock && cp config.toml ~/.config/spotify-adblock
sudo flatpak override --user --filesystem="~/.spotify-adblock/spotify-adblock.so" --filesystem="~/.config/spotify-adblock/config.toml" com.spotify.Client

cd /usr/share/applications
touch SpotifyAdblock.desktop
echo "[Desktop Entry]
Type=Application
Name=Spotify (adblock)
GenericName=Music Player
Icon=com.spotify.Client
Exec=flatpak run --file-forwarding --command=sh com.spotify.Client -c 'eval "$(sed s#LD_PRELOAD=#LD_PRELOAD=$HOME/.spotify-adblock/spotify-adblock.so:#g /app/bin/spotify)"' @@u %U @@
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=spotify" >> SpotifyAdblock.desktop

cd ~

#Installing VSCode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf check-update
sudo dnf -y install code

sudo echo "fs.inotify.max_user_watches=524288" > /etc/sysctl.conf
sudo sysctl -p
