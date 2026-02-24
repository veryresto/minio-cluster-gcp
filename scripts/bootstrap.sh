#!/bin/bash
set -e

echo "Bootstrapping MinIO nodes..."

NODES=($MINIO_ALL_NODES)

# Install Docker on all nodes
for NODE in "${NODES[@]}"
do
  echo "Installing Docker on $NODE..."

  gcloud compute ssh $NODE \
    --zone=$ZONE \
    --tunnel-through-iap \
    --command="
      sudo apt update -y &&
      sudo apt install -y docker.io &&
      sudo systemctl enable docker &&
      sudo systemctl start docker &&
      sudo mkdir -p /data &&
      sudo chown \$USER:\$USER /data
    "
done

echo "Starting Distributed MinIO..."

# Build distributed URL list
MINIO_URLS=""
for NODE in "${NODES[@]}"
do
  INTERNAL_IP=$(gcloud compute instances describe $NODE \
    --zone=$ZONE \
    --format='get(networkInterfaces[0].networkIP)')

  MINIO_URLS="$MINIO_URLS http://$INTERNAL_IP/data"
done

# Start MinIO on each node
for NODE in "${NODES[@]}"
do
  echo "Starting MinIO on $NODE..."

  gcloud compute ssh $NODE \
    --zone=$ZONE \
    --tunnel-through-iap \
    --command="
      sudo docker rm -f minio || true &&
      sudo docker run -d --name minio \
        -p 9000:9000 \
        -p 9001:9001 \
        -v /data:/data \
        -e MINIO_ROOT_USER=admin \
        -e MINIO_ROOT_PASSWORD=password123 \
        minio/minio server \
        $MINIO_URLS \
        --console-address ':9001'
    "
done

echo "MinIO cluster started."
