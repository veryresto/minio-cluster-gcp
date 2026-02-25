#!/bin/bash

echo "Deleting instances..."
gcloud compute instances delete "$BASTION" $MINIO_STANDARD_NODES $MINIO_SSD_NODES --zone="$ZONE" --quiet || true

echo "Deleting NAT..."
gcloud compute routers nats delete "$NETWORK-nat" --router="$NETWORK-router" --region="$REGION" --quiet || true

echo "Deleting Router..."
gcloud compute routers delete "$NETWORK-router" \
  --region="$REGION" --quiet || true

echo "Waiting for router to be fully deleted..."

while gcloud compute routers describe "$NETWORK-router" \
      --region="$REGION" >/dev/null 2>&1
do
  echo "Router still exists... waiting 5s"
  sleep 5
done

echo "Deleting firewall rules..."
gcloud compute firewall-rules delete $NETWORK-allow-internal --quiet || true
gcloud compute firewall-rules delete $NETWORK-allow-ssh-bastion --quiet || true
gcloud compute firewall-rules delete $NETWORK-allow-iap-ssh --quiet || true

echo "Deleting subnet..."
gcloud compute networks subnets delete "$SUBNET" --region="$REGION" --quiet || true

echo "Deleting VPC..."
gcloud compute networks delete "$NETWORK" --quiet || true

echo "Cleanup complete."