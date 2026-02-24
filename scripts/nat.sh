#!/bin/bash
set -e

ROUTER_NAME="$NETWORK-router"
NAT_NAME="$NETWORK-nat"

echo "Creating Cloud Router: $ROUTER_NAME..."
gcloud compute routers create "$ROUTER_NAME" \
    --network="$NETWORK" \
    --region="$REGION" || true

echo "Creating Cloud NAT: $NAT_NAME..."
gcloud compute routers nats create "$NAT_NAME" \
    --router="$ROUTER_NAME" \
    --region="$REGION" \
    --auto-allocate-nat-external-ips \
    --nat-all-subnet-ip-ranges
