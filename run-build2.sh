#!/bin/bash
set -e

num_workflows=10
# sleep_duration=120 # 2 minutes
sleep_duration=300 # 5 minutes
workflow_name="build2.yml"

batch_id=$(date +%s)

for i in $(seq 1 $num_workflows); do
  echo "Starting workflow build$i"
  gh workflow run "$workflow_name" --ref main -f batch_identifier=$batch_id -f workflow_identifier=build$i -f sleep_duration=$sleep_duration
done

sleep 3

gh run list --workflow "$workflow_name" --limit $num_workflows
# gh run list --workflow "$workflow_name" --limit $num_workflows --json databaseId,headBranch,headSha,runNumber,status,conclusion,createdAt,updatedAt,event,workflowName --jq '.[] | {runNumber, status, conclusion, createdAt, updatedAt, event, workflowName}' | tee runs.json