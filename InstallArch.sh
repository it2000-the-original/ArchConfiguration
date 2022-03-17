#/bin/sh

if nc -zw1 google.com 443; then  
    echo "we have connectivity"
    clear
    echo "Welcome to the arch linux installation script!"
    echo                      -`
    echo                     .o+`
    echo                    `ooo/
    echo                   `+oooo:
    echo                  `+oooooo:
    echo                  -+oooooo+:
    echo                `/:-:++oooo+:
    echo               `/++++/+++++++:
    echo              `/++++++++++++++:
    echo             `/+++ooooooooooooo/`
    echo            ./ooosssso++osssssso+`
    echo           .oossssso-````/ossssss+`
    echo          -osssssso.      :ssssssso.
    echo         :osssssss/        osssso+++.
    echo        /ossssssss/        +ssssooo/-
    echo      `/ossssso+/:-        -:/+osssso+-
    echo     `+sso+:-`                 `.-/+oso:
    echo     `++:.                           `-/+/
    echo    .`                                 `

    # Mappatura del disco!!!!

    read -p "press any key to continue..." as
    cfdisk
    echo "This is the actual disks list!!"
    fdisk -l

    read -p "Insert the root partition: " rootpart
    read -p "Insert the efi partition: " efipart
    read -p "Insert the swap partition: " swappart

    echo "The partitions exists!!!"
    echo "Formatting partitions..."
    mkfs.vfat -F32 $efipart
    mkfs.ext4 $rootpart
    mkswap $swappart
    echo "Mounting partitions..."
    mount $rootpart /mnt
    mkdir -np /mnt/boot/efi
    mount $efipart /mnt/boot/efi
    swapon $swappart
    echo "Generating mirrors..."
    read -p "Insert the reflector country: " reflecountry
    reflector --verbose --country $reflecountry --sort rate --save /etc/pacman.d/mirrorlist
    echo "Installing the base system..."
    pacstrap /mnt base base-devel linux linux-firmware nano
    echo "Generating fstab..."
    genfstab -U -p /mnt > /mnt/etc/fstab
    echo "Executing chroot..."
    arch-chroot /mnt /bin/bash <<EOF
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
    EOF

else
    echo "Error: we are non connected"
fi
