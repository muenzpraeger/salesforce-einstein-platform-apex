#!/bin/bash

# Simple shell script to automatically set up Einstein Platform

USERNAME="$1"
FILE="$2"
DEFAULTORG=""
if [ "$#" -eq 3 ]; then
  DEFAULTORG="-u $3"
fi

_APEX_OUTPUT="apex.output"

echo "Einstein Platform User: $USERNAME" 
echo "Einstein Platform File: $FILE"
echo ""
echo "Creating Apex file"

echo "Einstein_Settings__c setting = new Einstein_Settings__c(Einstein_Email__c='$USERNAME');" > $_APEX_OUTPUT
echo "insert setting;" >> $_APEX_OUTPUT
echo "public String key = '';" >> $_APEX_OUTPUT

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "key = key + '$line\n';" >> $_APEX_OUTPUT;
done < "$FILE"

echo "ContentVersion cont = new ContentVersion();" >> $_APEX_OUTPUT
echo "cont.Title = 'einstein_platform';" >> $_APEX_OUTPUT
echo "cont.PathOnClient = 'einstein_platform.pem';" >> $_APEX_OUTPUT
echo "cont.VersionData = Blob.valueOf(key);" >> $_APEX_OUTPUT
echo "insert cont;" >> $_APEX_OUTPUT

echo ""
echo "Executing anonymous Apex via sfdx CLI"

sfdx force:apex:execute -f $_APEX_OUTPUT $DEFAULTORG

echo "Apex executed"

rm -f $_APEX_OUTPUT

echo "Done!"