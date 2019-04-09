# ufw-spamhaus
Download Spamhaus DROP and EDROP Lists and block access with UFW

# crontab
If you want to run this script through `crontab -e`, you must copy and paste your system path from `/etc/crontab` file. For example:

```
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# run the script every day at 7am
0 7 * * * /root/ufw-spamhaus.sh
```
