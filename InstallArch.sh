#/bin/sh
if nc -zw1 google.com 443; then  
    clear
    echo "we have connectivity"
    echo "Welcome to the arch linux installation script!"

    # Mappatura del disco!!!!

    read -p "press any key to continue..." as
    echo "This is the actual disks list!!"
    fdisk -l

    read -p "Insert the root partition: " rootpart
    read -p "Insert the efi partition: " efipart
    read -p "Insert the swap partition: " swappart

    echo "Formatting partitions..."
    mkfs.vfat -F32 $efipart
    mkfs.ext4 $rootpart
    mkswap $swappart
    echo "Mounting partitions..."
    mount $rootpart /mnt
    mkdir -p /mnt/boot/efi
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
    cp -f ChrootBash.bash /mnt
    arch-chroot /mnt ./ChrootBash.bash
    cp fonts/* /mnt/usr/share/fonts
    echo "Installation completed!"
    read -p "Press enter to reboot..." nw
    rm -rf /mnt/ChrootBash.bash
    reboot

else
    echo "Error: we are non connected"
fi
