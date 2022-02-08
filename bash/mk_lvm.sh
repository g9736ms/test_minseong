stdout_check(){
if [ $? != 0 ]; then
        echo "fdisk fail [ $job ]"
        exit 1
fi
}

mv_home(){

echo -e "n\np\n1\n\n\nt\n8e\nw" | sudo fdisk /dev/vdb &>/dev/null
job='fdisk'
stdout_check

sudo pvcreate /dev/vdb1 &>/dev/null
job='pvcreate'
stdout_check


sudo vgcreate HomeVG /dev/vdb1 &>/dev/null
job='vgcreate'
stdout_check

sudo lvcreate -l 100%free -n home HomeVG -y &>/dev/null
job='lvcreate'
stdout_check

sudo mkfs.xfs -f /dev/HomeVG/home &>/dev/null
job='mkfs'
stdout_check


sudo chmod 777 /etc/fstab
sudo su -c "echo '/dev/HomeVG/home  /home/  xfs   defaults   0 0' >> /etc/fstab"
job='fstab'
stdout_check
sudo chmod 644 /etc/fstab

sudo mount -a &>/dev/null
job='mount'
stdout_check

sleep 1

cd /
sudo tar -zxvf /didim365/home.tar -C / &>/dev/null
job='tar -zxvf'
stdout_check


sudo chown -R  ubuntu /home/ubuntu
sudo chgrp -R  ubuntu /home/ubuntu
}

mv_home
