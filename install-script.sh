#!/bin/bash

#Create default template
cd ~/Templates
touch "Empty document"

#Create personal folder
mkdir ~/.personal

#Change hostname
sudo hostnamectl set-hostname fedora

#Change DNF settings
echo "
fastestmirror=true
deltarpm=true
defaultyes=True
keepcache=True
max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf

#Update System
sudo dnf -y update

#Installing rpm fusion
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

#Install media codecs
sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf -y groupupdate sound-and-video

#Adding flathub repository
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

#Installing GNOME addons
sudo dnf -y install gnome-extensions-app.x86_64 gnome-tweaks.noarch

#Install zsh and oh-my-zsh
sudo dnf -y install curl wget zsh git vim unzip
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

sudo dnf -y install libpng-devel turbojpeg-devel libvorbis-devel openal-soft-devel SDL2-devel mesa-libGLU-devel mbedtls-devel libuv-devel sqlite-devel pcre-devel

cd /opt
sudo wget -O hashlink.tar.gz https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.12.tar.gz
tar xzf hashlink.tar.gz
cd hashlink-1.12
sudo make
sudo make install

sudo ldconfig

cd

#Install Nodejs
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo dnf -y install nodejs

sudo npm install npm -g

#Install Yarn
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo dnf -y install yarn

#Installing Java
sudo dnf -y install java-11-openjdk.x86_64
sudo dnf -y group install "Java Development"

#Installing Dotnet
sudo dnf -y install dotnet-sdk-6.0
sudo dnf -y install aspnetcore-runtime-6.0

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
