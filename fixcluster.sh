#!/bin/bash

# Array of resources to check
resources=("service1" "service2" "service3" "service4")

# Function to check the status of a resource
check_resource_status() {
    resource=$1
    # Extract the line corresponding to the resource and check if it contains "Started"
    status=$(pcs status | grep "$resource" | grep -o "Started [a-zA-Z0-9]*")
    echo "$resource status: $status"
    if [[ -z "$status" ]]; then
        return 1
    fi
    return 0
}

# Variable to track if any resource is not started
any_not_started=0

# Check the status of each resource
for resource in "${resources[@]}"; do
    check_resource_status "$resource"
    if [[ $? -ne 0 ]]; then
        any_not_started=1
    fi
done

# If any resource is not started, run the pcs resource refresh command
if [[ $any_not_started -eq 1 ]]; then
    echo "One or more resources are not started. Running 'pcs resource refresh'."
    pcs resource refresh
else
    echo "All resources are started."
fi
