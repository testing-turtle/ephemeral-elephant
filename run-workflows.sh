#!/bin/bash
set -e

num_workflows=20
# sleep_duration=120 # 2 minutes
sleep_duration=300 # 5 minutes
workflow_name="build.yml"

for i in $(seq 1 $num_workflows); do
  echo "Starting workflow build$i"
  gh workflow run "$workflow_name" --ref main -f workflow_identifier=build$i -f sleep_duration=$sleep_duration
done

sleep 3

gh run list --workflow "$workflow_name" --limit $num_workflows

