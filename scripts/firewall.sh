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

# Allow IAP SSH (Source ranges documented here: https://docs.cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule)
echo "Creating firewall rule: allow-iap-ssh..."
gcloud compute firewall-rules create "$NETWORK-allow-iap-ssh" \
  --network="$NETWORK" \
  --allow=tcp:22 \
  --source-ranges=35.235.240.0/20