sudo pacman -S -y git vim maven zsh snapd

sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

sudo snap install code --classic
sudo snap install postman teams-for-linux
sudo snap install android-studio --classic
sudo snap install intellij-idea-ultimate --classic

sudo pacman -S docker -y
sudo systemctl start docker
sudo systemctl enable docker

sudo usermod -aG docker $USER

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Update the source listing
sudo pacman -Syy

git config --global user.email "pavel.racu@gmail.com"
git config --global user.name "Pavel Racu"
