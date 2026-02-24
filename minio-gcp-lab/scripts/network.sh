#!/bin/bash
set -e

echo "Creating VPC: $NETWORK..."
gcloud compute networks create "$NETWORK" --subnet-mode=custom

echo "Creating Subnet: $SUBNET ($SUBNET_CIDR)..."
gcloud compute networks subnets create "$SUBNET" \
    --network="$NETWORK" \
    --range="$SUBNET_CIDR" \
    --region="$REGION"
