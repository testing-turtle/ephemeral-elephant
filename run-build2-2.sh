#!/bin/bash
set -e

num_workflows_per_group=5
num_workflow_groups=3
group_interval=60 # seconds

# sleep_duration=120 # 2 minutes
sleep_duration=300 # 5 minutes
workflow_name="build2.yml"

batch_id=$(date +%s)

echo "Starting batch ID: $batch_id"

for group in $(seq 1 $num_workflow_groups); do
  echo "Starting workflow group $group"
  for i in $(seq 1 $num_workflows_per_group); do
    echo "Starting workflow run$i"
    gh workflow run "$workflow_name" --ref main -f batch_identifier=$batch_id -f workflow_identifier=run$i -f sleep_duration=$sleep_duration
  done
  if [ $group -lt $num_workflow_groups ]; then
    echo "Waiting $group_interval seconds before starting next group"
    sleep $group_interval
  fi
done

sleep 3

gh run list --workflow "$workflow_name" --limit $((num_workflows_per_group * num_workflow_groups))
  
# gh run list --workflow "$workflow_name" --limit $num_workflows --json databaseId,headBranch,headSha,runNumber,status,conclusion,createdAt,updatedAt,event,workflowName --jq '.[] | {runNumber, status, conclusion, createdAt, updatedAt, event, workflowName}' | tee runs.json