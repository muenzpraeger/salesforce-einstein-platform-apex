#!/bin/bash
sfdx force:org:create -s -f config/project-scratch-def.json -a einstein-ai -d 30
sfdx force:source:push
# custom settings setup.  Modify for your username
sfdx force:user:permset:assign -n Einstein_Platform_Playground

sfdx force:org:open -p /one/one.app#/setup/CertificatesAndKeysManagement/home