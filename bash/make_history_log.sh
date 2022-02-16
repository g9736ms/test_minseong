#!/bin/bash
sudo touch /var/log/history.log
sudo chmod 777 /var/log/history.log
sudo echo "" > $HOME/.bash_history
sudo cat <<EOF > /etc/profile.d/history_collecter.sh
#!/bin/bash
HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S `who am i |awk '{print $1,$5}'` "
export HISTTIMEFORMAT
my_test()
{
        history >> /var/log/history.log
        history -c
}
trap my_test EXIT
EOF
