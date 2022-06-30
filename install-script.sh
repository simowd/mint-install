#Create personal folder
mkdir ~/.personal

#Update System
sudo apt update
sudo apt upgrade -y

#Install zsh and oh-my-zsh
sudo apt install -y curl wget zsh git vim unzip
sudo chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

#Install important software
sudo apt install -y krita filezilla gpick steam vlc build-essential gcc g++ make cmake ca-certificates gpg gnupg lsb-release

#Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

#Install Python
sudo apt install -y python3 python3-pip libssl-dev libffi-dev python3-venv

#Install Haxe
sudo add-apt-repository ppa:haxe/releases -y
sudo apt-get update
sudo apt-get install haxe -y
mkdir ~/.personal/haxelib && haxelib setup ~/.personal/haxelib

sudo apt-get -y install libpng-dev libturbojpeg-dev libvorbis-dev libopenal-dev libsdl2-dev libmbedtls-dev libuv1-dev libsqlite3-dev

cd /opt
sudo wget -O hashlink.tar.gz https://github.com/HaxeFoundation/hashlink/archive/refs/tags/1.12.tar.gz
tar xzf hashlink.tar.gz
cd hashlink-1.12
sudo make
sudo make install

sudo ldconfig

cd ~

#Install Nodejs
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo npm install npm -g

#Install Yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | sudo tee /usr/share/keyrings/yarnkey.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

#Installing Java
sudo apt install -y default-jdk default-jre maven

#Installing Dotnet
wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

#Installing Dotnet SDK
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-6.0

#Installing Dotnet Runtime
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-6.0

#Fonts
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt-get install -y ttf-mscorefonts-installer

sudo apt install -y fonts-firacode
cd /usr/share/fonts/truetype
sudo mkdir firacode-nerd
cd firacode-nerd
sudo curl -fLo "Fira Code Regular Nerd Font Complete.ttf" https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf

cd /usr/share/fonts/truetype
sudo mkdir cascadia
sudo wget -O Cascadia.zip https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
sudo unzip -qq Cascadia.zip "ttf/*"
sudo mv ttf Cascadia
sudo rm -f Cascadia.zip

sudo fc-cache -f -v
