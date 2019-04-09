#!/usr/bin/env bash

# based off the following script
# https://github.com/cowgill/spamhaus
# https://github.com/dajul/ufw-spamhaus
# https://joshtronic.com/2015/09/06/error-invalid-position-1/

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

# list of known spammers v6
URL3="https://www.spamhaus.org/drop/dropv6.txt";
# save local copy here
FILE3="/tmp/dropv6.lasso";

# unban old entries v6
if [ -f $FILE3 ]; then
    for IP in $( cat $FILE3 ); do
        ufw delete deny from $IP to any
    done
fi

# get a copy of the spam lists v6
wget -qc $URL3 -O $FILE3
if [ $? -ne 0 ]; then
    exit 1
fi

# ban new entries
# check first position of first v6 entry
v6ruleid=$(ufw status numbered | grep "(v6)" | grep -o "\\[[0-9]*\\]" | grep -o "[0-9]*" | head -n 1)
for IP in $( cat $FILE3 ); do
    ufw insert $v6ruleid deny from $IP to any
done
