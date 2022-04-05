#/bin/bash
echo "Generating locale..."
nano /etc/locale.gen
locale-gen
nano /etc/locale.conf
nano /etc/vconsole.conf
export EDITOR=nano
read -p "Insert the zoneinfo city (for example Europe/Rome): " zone
ln -s /usr/share/zoneinfo/$zone /etc/localtime
hwclock --systohc --utc
read -p "Insert the hostname of your machine: " hostname
echo "$hostname" > /etc/hostname
pacman -S net-tools dhcpcd netctl iwd wpa_supplicant wireless_tools dialog iw networkmanager
systemctl enable dhcpcd
systemctl enable iwd
systemctl enable NetworkManager.service
echo "Insert the root password"
passwd
read -p "Insert the name of your normal user: " user
useradd -m -G wheel -s /bin/bash "$user"
echo "And now insert the password"
passwd "$user"
visudo
echo "Installing the grub..."
pacman -S grub efibootmgr os-prober
grub-install
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S cups neofetch vim htop cmatrix git
systemctl enable cups
pacman -S flatpak
read -p "Insert the video driver to install: " driver
pacman -S $driver
echo "Installation completed"
pacman -S xorg xorg-server xorg-xinit
pacman -S gnome ttf-dejavu alacarte gnome-tweaks
systemctl enable gdm.service
