#!/usr/bin/env bash

# based off the following script
# https://github.com/cowgill/spamhaus

# path to UFW
UFW="/usr/sbin/ufw";

# list of known spammers
URL1="http://www.spamhaus.org/drop/drop.lasso";
URL2="http://www.spamhaus.org/drop/edrop.lasso";

# save local copy here
FILE1="/tmp/drop.lasso";
FILE2="/tmp/edrop.lasso";
COMBINED="/tmp/drop-edrop.combined"

# unban old entries
if [ -f $COMBINED ]; then
    for IP in $( cat $COMBINED ); do
        ufw delete deny from $IP to any
    done
fi

# get a copy of the spam lists
wget -qc $URL1 -O $FILE1
if [ $? -ne 0 ]; then
    exit 1
fi
wget -qc $URL2 -O $FILE2
if [ $? -ne 0 ]; then
    exit 1
fi

# combine files and filter
cat $FILE1 <(echo -n) $FILE2 | egrep -v '^;' | awk '{ print $1}' > $COMBINED

# remove the spam lists
unlink $FILE1
unlink $FILE2

# ban new entries
for IP in $( cat $COMBINED ); do
    ufw insert 1 deny from $IP to any
done
