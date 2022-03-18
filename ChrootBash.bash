#/bin/bash
echo "Generating locale..."
nano /etc/locale.gen
locale-gen
echo LANG=it_IT.UTF-8 > /etc/locale.conf
export LANG=it_IT.UTF-8
read -p "Insert the keymap to add: " keymap
read -p "Insert the editor to add: " editor
echo KEYMAP=$keymap > /etc/vconsole.conf
echo EDITOR=$editor > /etc/vconsole.conf
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
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.tmp
echo "Installing the grub..."
pacman -S grub efibootmgr os-prober
grub-install
grub-mkconfig -o /boot/grub/grub.cfg
pacman -S cups neofetch vim htop cmatrix
sudo systemctl start org.cups.cupsd