#!/bin/bash
# No set -e, we want to continue even if some deletions fail

echo "Deleting instances..."
gcloud compute instances delete "$BASTION" $MINIO_STANDARD_NODES $MINIO_SSD_NODES --zone="$ZONE" --quiet || true

echo "Deleting NAT and Router..."
gcloud compute routers nats delete "$NETWORK-nat" --router="$NETWORK-router" --region="$REGION" --quiet || true
gcloud compute routers delete "$NETWORK-router" --region="$REGION" --quiet || true

echo "Deleting firewall rules..."
gcloud compute firewall-rules delete "$NETWORK-allow-internal" "$NETWORK-allow-ssh-bastion" --quiet || true

echo "Deleting subnet..."
gcloud compute networks subnets delete "$SUBNET" --region="$REGION" --quiet || true

echo "Deleting VPC..."
gcloud compute networks delete "$NETWORK" --quiet || true
