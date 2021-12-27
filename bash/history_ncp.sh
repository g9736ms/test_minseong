#!/bin/bash

echo 'HISTTIMEFORMAT="%Y-%m-%d_%H:%M:%S `who am i |awk '"'"'{print $1,$5}'"'"'` "' >>  /etc/profile
echo 'export HISTTIMEFORMAT' >> /etc/profile
cat <<EOF > /etc/profile.d/history_collecter.sh
#!/bin/bash
my_test()
{
        history >> /var/log/history.log
}
	trap my_test EXIT
EOF
