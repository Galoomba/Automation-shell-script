#!/bin/bash
read -p "Gitlab url : " gitlabUrl
read -p "Gitlab token : " token
read -p "Project Name : " projectName
read -p "Project type [ 1:backend, 2:frontend ] : " projectType

# vars
stagingTag="stag"
productionTag="prod"
buildTag="build"

# check project type if backend
if [ $projectType == 1 ]
then
 # register in staging machine
 ssh -i ~/.ssh/id_rsa novell@35.202.213.35 sudo gitlab-runner register \
  --non-interactive \
  --url "$gitlabUrl" \
  --registration-token "$token" \
  --executor "shell" \
  --tag-list "$stagingTag"\
  --description  "$projectName staging" \

 # register in production machine
 ssh -i ~/.ssh/id_rsa novell@34.69.189.152 sudo gitlab-runner register \
  --non-interactive \
  --url "$gitlabUrl" \
  --registration-token "$token" \
  --executor "shell" \
  --tag-list "$productionTag"\
  --description  "$projectName production" \

elif [ $projectType == 2 ]
then
  # register in staging machine
 ssh -i ~/.ssh/id_rsa novell@35.202.213.35 sudo gitlab-runner register \
  --non-interactive \
  --url "$gitlabUrl" \
  --registration-token "$token" \
  --executor "shell" \
  --tag-list "$stagingTag"\
  --description  "$projectName staging" \

 # register in production machine
 ssh -i ~/.ssh/id_rsa novell@34.69.189.152 sudo gitlab-runner register \
  --non-interactive \
  --url "$gitlabUrl" \
  --registration-token "$token" \
  --executor "shell" \
  --tag-list "$productionTag"\
  --description  "$projectName production" \

 # register in build machine
  ssh -i ~/.ssh/id_rsa novell@35.188.148.221 sudo gitlab-runner register \
  --non-interactive \
  --url "$gitlabUrl" \
  --registration-token "$token" \
  --executor "shell" \
  --tag-list "$buildTag"\
  --description  "$projectName production" \

else
 echo wrong choose
fi

