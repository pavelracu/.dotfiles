sudo pacman -S -y git vim maven zsh powerline fonts-powerline

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Update the source listing
sudo pacman -Syy
#apt-get update Ensure that you have the binaries needed to fetch repo listing
sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
# Fetch the repository listing from docker's site & add it
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
# Update source listing now that we've added Docker's repo
sudo pacman -Syy
sudo pacman -S docker-ce=18.06.2~ce~3-0~ubuntu
sudo usermod -aG docker $USER

git config --global user.email "pavel.racu@gmail.com"
git config --global user.name "Pavel Racu"
