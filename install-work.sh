#Installing Angular
sudo npm install -g @angular/cli

#Installing Rider
wget -O Rider.tar.gz https://download.jetbrains.com/rider/JetBrains.Rider-2022.1.2.tar.gz
sudo tar -xzf Rider.tar.gz -C /opt

rm -f Rider.tar.gz

cd /opt/'JetBrains Rider-2022.1.2'/bin
sh ./rider.sh


