#!/bin/bash
set -e

# num_workflows=1
num_workflows=20
# sleep_duration=120 # 2 minutes
sleep_duration=300 # 5 minutes
workflow_name="build1.yml"

batch_id=$(date +%s)

echo "Starting batch ID: $batch_id"

for i in $(seq 1 $num_workflows); do
  echo "Starting workflow run$i"
  gh workflow run "$workflow_name" --ref main -f batch_identifier=$batch_id -f workflow_identifier=run$i -f sleep_duration=$sleep_duration
done

sleep 3

gh run list --workflow "$workflow_name" --limit $num_workflows

