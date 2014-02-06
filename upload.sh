#!/bin/bash

# remove trailing slashes
targetdir=$(echo $PWD | sed 's/\/*$//g')

# get list of all changed files
changes=$(git status --porcelain 2>&1)

# exit if git status returned an error code
if [ $? -ne 0 ]
then
    echo
    echo "  $changes"
    echo
    exit 1
fi

# file length counters
maxfilelength=0
filelength=0

# extract added and modified files
files_modified=$(echo "$changes" | awk '{if($1~"A|M") print $2}')
if [ "$files_modified" == "" ]
then
    echo
    echo "Nothing to sync"
    echo
    exit 0
fi
echo "-- modified files --"
for file in $files_modified;
do
    echo "$file"
done
echo

servername="youversionapidev.com:/var/www/youversion.com/current"

# dry run
for file in $files_modified;
do
    cmd="scp -Cpr $file $servername/"
    echo "$cmd"
done

echo 
echo -n 'Do you want to continue (yes/no)?: '
read answer

# exit it "yes" or "y" not received
if [ "$answer" != "yes" ] && [ "$answer" != "y" ]
then
    echo
    exit 1
fi

echo

# copy files
for file in $files_modified;
do
    cmd="scp -Cpr $file $servername"
    echo "$cmd"
    output=$($cmd 2>&1)

    if [ $? -eq 0 ]
    then
        echo "ok"
    else
        echo "failed ($output)"
    fi
    echo
done

echo
