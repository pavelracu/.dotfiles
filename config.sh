sudo apt install -y git vim maven zsh node snap 

sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap

#sudo snap install code --classic
#sudo snap install postman
#sudo snap install android-studio --classic
#sudo snap install intellij-idea-ultimate --classic

## install docker
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose
sudo usermod -aG docker $USER


sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Update the source listing
#sudo pacman -Syy

git config --global user.email "pavel.racu@gmail.com"
git config --global user.name "Pavel Racu"

git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

git config core.hooksPath ~/.dotfiles/hooks
