#!/bin/bash

#Create default template
cd ~/Templates
touch "Empty document"

#Create personal folder
mkdir ~/.personal

#Change hostname
sudo hostnamectl set-hostname fedora

#Fix time on dual-boot systems
sudo timedatectl set-local-rtc '0'

#Change DNF settings
echo "
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=1
deltarpm=true
keepcache=True
max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf

#Update System
sudo dnf -y update

#Installing rpm fusion
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Update App-stream metadata
sudo dnf -y groupupdate core

#Install media codecs
sudo dnf -y groupupdate 'core' 'multimedia' 'sound-and-video' --setopt='install_weak_deps=False' --exclude='PackageKit-gstreamer-plugin' --allowerasing && sync
sudo dnf -y swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf -y install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel ffmpeg gstreamer-ffmpeg
sudo dnf -y install lame\* --exclude=lame-devel
sudo dnf -y group upgrade --with-optional Multimedia

#Hardware video acceleration
sudo dnf -y install ffmpeg ffmpeg-libs libva libva-utils
sudo dnf -y swap libva-intel-media-driver intel-media-driver --allowerasing

#OpenH264 for Firefox
sudo dnf -y config-manager --set-enabled fedora-cisco-openh264
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264

#Adding flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Installing GNOME addons
sudo dnf -y install gnome-extensions-app.x86_64 gnome-tweaks.noarch

#Installing PopOS shell
sudo dnf install -y gnome-shell-extension-pop-shell xprop

#Install zsh and oh-my-zsh
sudo dnf -y install curl wget zsh git neovim unzip
sudo chsh -s $(which zsh) $CUSTOM_USER

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#Install important software
sudo dnf -y group install "C Development Tools and Libraries"
sudo dnf -y install krita filezilla gcolor3 steam vlc gcc g++ make cmake ca-certificates gpg gnupg redhat-lsb-core

#Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

#Install Python
sudo dnf -y group install "Python Classroom"

#Install Haxe
sudo dnf -y install haxe
mkdir ~/.personal/haxelib && haxelib setup ~/.personal/haxelib

#Uncomment everything below this when Hashlink fixed GCC 14.1 compatibility

#sudo dnf -y install libpng* turbo* libvorbis* openal* SDL2* mbedtls* uv* libuv* libsdl2* GL*
#sudo dnf -y install libpng-devel turbojpeg-devel libvorbis-devel openal-soft-devel SDL2-devel mesa-libGLU-devel mbedtls-devel libuv-devel  sqlite-devel libpcap-devel

#cd /opt
#sudo wget -O hashlink.tar.gz https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.14.tar.gz
#tar xzf hashlink.tar.gz
#cd hashlink-1.14
#sudo make
#sudo make install

sudo ldconfig

cd ~

#Install Nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

nvm install --lts

#Install Yarn
corepack enable

#Installing Java
sudo dnf -y install java-11-openjdk.x86_64
sudo dnf -y group install "Java Development"

#Installing Dotnet
wget -O dotnet5.tar.gz https://download.visualstudio.microsoft.com/download/pr/904da7d0-ff02-49db-bd6b-5ea615cbdfc5/966690e36643662dcc65e3ca2423041e/dotnet-sdk-5.0.408-linux-x64.tar.gz
sudo mkdir -p /usr/lib64/dotnet
sudo tar zxf dotnet5.tar.gz -C /usr/lib64/dotnet

sudo dnf -y install dotnet-sdk-8.0 dotnet-sdk-6.0
sudo dnf -y install aspnetcore-runtime-8.0 aspnetcore-runtime-6.0

sudo dnf -y install compat-openssl10

#Fonts
sudo dnf -y install mscore-fonts

sudo dnf -y install fira-code-fonts
cd /usr/share/fonts
sudo mkdir firacode-nerd
cd firacode-nerd
sudo curl -fLo "Fira Code Regular Nerd Font Complete.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf

cd /usr/share/fonts
sudo mkdir cascadia
sudo wget -O Cascadia.zip https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
sudo unzip -qq Cascadia.zip "ttf/*"
sudo mv ttf Cascadia
sudo rm -f Cascadia.zip

sudo fc-cache -f -v

curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash

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
sudo usermod -aG docker $CUSTOM_USER

#Installing Flatpak Apps
sudo flatpak install -y flathub com.getpostman.Postman
sudo flatpak install -y flathub org.telegram.desktop
sudo flatpak install -y flathub com.slack.Slack
sudo flatpak install -y flathub com.obsproject.Studio
sudo flatpak install -y flathub com.spotify.Client
sudo flatpak install -y flathub org.onlyoffice.desktopeditors
sudo flatpak install -y flathub io.dbeaver.DBeaverCommunity
sudo flatpak install -y flathub org.godotengine.Godot
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
echo -n "[Desktop Entry]
Type=Application
Name=Spotify (adblock)
GenericName=Music Player
Icon=com.spotify.Client
Exec=flatpak run --file-forwarding --command=sh com.spotify.Client -c 'eval \"$" >> SpotifyAdblock.desktop

echo -n "(sed s#LD_PRELOAD=#LD_PRELOAD=$HOME/.spotify-adblock/spotify-adblock.so:#g /app/bin/spotify)\"' @@u %U @@
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

#Installing Angular and Nx
npm add --global nx@latest
npm install -g @angular/cli

#Installing JetBrains Toolbox
sudo dnf -y install libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin tar dbus-user-session
sudo mkdir -p /opt/jetbrains-toolbox
cd /opt/jetbrains-toolbox
wget -O toolbox.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-2.3.2.31487.tar.gz
sudo tar -xzf toolbox.tar.gz

#Installing wkhtmltopdf
sudo dnf -y install wkhtmltopdf

