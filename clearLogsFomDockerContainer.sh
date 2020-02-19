#!/bin/bash
# clear logs from backend container 
declare -a dockerBackendContainers
# edit to add more backend containers
dockerBackendContainers=( accpharmace pharma_hr tickting );
# delete old logs from each container 
for container in "${dockerBackendContainers[@]}"
do  docker exec -it $container find  ./logs -mtime +7 -exec rm {} \;
echo "Deleted files from $container"
done