#"""""""""""""""""""""""""""""""""""""
#""" Installing essential programs """
#"""""""""""""""""""""""""""""""""""""

#Install docker
sudo apt remove docker-desktop
sudo rm -r $HOME/.docker/desktop
sudo rm /usr/local/bin/com.docker.cli
sudo apt purge docker-desktop
sudo apt remove docker docker-engine docker.io containerd runc

sudo apt update

sudo mkdir -p /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo docker run hello-world

sudo groupadd docker
sudo usermod -aG docker $USER
sudo apt install -y docker-compose-plugin

#Installing Spotify

curl -sS https://download.spotify.com/debian/pubkey_5E3C45D7B312C643.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

sudo apt update
sudo apt install -y spotify-client

git clone https://github.com/abba23/spotify-adblock.git ~/.personal/spotify-adblock
cd ~/.personal/spotify-adblock
make
sudo make install

cd /usr/share/applications
touch SpotifyAdblock.desktop
echo "[Desktop Entry]
Type=Application
Name=Spotify (adblock)
GenericName=Music Player
Icon=spotify-client
TryExec=spotify
Exec=env LD_PRELOAD=/usr/local/lib/spotify-adblock.so spotify %U
Terminal=false
MimeType=x-scheme-handler/spotify;
Categories=Audio;Music;Player;AudioVideo;
StartupWMClass=spotify" >> SpotifyAdblock.desktop

cd ~

#Installing OBS
sudo add-apt-repository -y ppa:obsproject/obs-studio
sudo apt update
sudo apt install -y ffmpeg obs-studio

#Installing Flatpak Apps
sudo flatpak install -y flathub com.getpostman.Postman
sudo flatpak install -y flathub org.telegram.desktop
sudo flatpak install -y flathub com.slack.Slack
sudo flatpak install -y flathub com.github.IsmaelMartinez.teams_for_linux

#Installing VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

#Installing OnlyOffice
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /etc/apt/trusted.gpg.d/

echo 'deb https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

sudo apt-get update
sudo apt-get install -y onlyoffice-desktopeditors

#""""""""""""""""""""""""""""
#""" Installing deb files """
#""""""""""""""""""""""""""""
