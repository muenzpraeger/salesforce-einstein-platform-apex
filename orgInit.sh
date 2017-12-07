#!/bin/bash
sfdx force:org:create -s -f config/project-scratch-def.json -d 1
sfdx force:source:push
sfdx force:user:permset:assign -n Einstein_Platform_Playground
# sfdx force:user:create -f config/userDef/cloudy-user-def.json
# sfdx force:user:create -f config/userDef/codey-user-def.json

# sfdx msm:user:photo -f assets/cloudy_lightning.png -l Cloudy
# sfdx msm:user:photo -f assets/codey_lightning.png  -l CodeBear

# sfdx force:apex:execute -f SetupScripting/apexDeletions.cls
# sfdx force:data:tree:import -p data/masterImportPlan.json
# sfdx force:apex:execute -f SetupScripting/urlSetup.cls
sfdx force:org:open -p /one/one.app#/setup/home