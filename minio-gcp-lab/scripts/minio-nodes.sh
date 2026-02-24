#!/bin/bash
set -e

echo "Creating MinIO Standard nodes: $MINIO_STANDARD_NODES..."
for node in $MINIO_STANDARD_NODES; do
    gcloud compute instances create "$node" \
        --network="$NETWORK" \
        --subnet="$SUBNET" \
        --zone="$ZONE" \
        --machine-type=e2-standard-2 \
        --image-family=ubuntu-2204-lts \
        --image-project=ubuntu-os-cloud \
        --no-address \
        --boot-disk-size=100GB \
        --boot-disk-type=pd-standard \
        --metadata=enable-oslogin=TRUE
done

echo "Creating MinIO SSD nodes: $MINIO_SSD_NODES..."
for node in $MINIO_SSD_NODES; do
    gcloud compute instances create "$node" \
        --network="$NETWORK" \
        --subnet="$SUBNET" \
        --zone="$ZONE" \
        --machine-type=e2-standard-2 \
        --image-family=ubuntu-2204-lts \
        --image-project=ubuntu-os-cloud \
        --no-address \
        --boot-disk-size=30GB \
        --boot-disk-type=pd-ssd \
        --metadata=enable-oslogin=TRUE
done
