#!/bin/bash
set -e

echo "Creating bastion VM: $BASTION..."
gcloud compute instances create "$BASTION" \
    --network="$NETWORK" \
    --subnet="$SUBNET" \
    --zone="$ZONE" \
    --machine-type=e2-micro \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --tags=bastion \
    --metadata=enable-oslogin=TRUE
