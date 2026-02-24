#!/bin/bash
set -e

echo "Creating firewall rule: allow-internal..."
gcloud compute firewall-rules create "$NETWORK-allow-internal" \
    --network="$NETWORK" \
    --allow=tcp,udp,icmp \
    --source-ranges="$SUBNET_CIDR"

echo "Creating firewall rule: allow-ssh-bastion..."
gcloud compute firewall-rules create "$NETWORK-allow-ssh-bastion" \
    --network="$NETWORK" \
    --allow=tcp:22 \
    --target-tags=bastion
