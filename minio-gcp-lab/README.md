# MinIO Distributed Cluster on GCP (Reproducible)

This project provides a fully automated way to deploy a MinIO distributed cluster on GCP using `gcloud` and `Makefile`.

## Prerequisites

- `gcloud` CLI installed and authenticated.
- `make` installed.

## Getting Started

1.  **Configure:** Edit `config.mk` if you need to change the project ID, region, or node names.
2.  **Deploy:** Run the following command to create the entire infrastructure:
    ```bash
    make up
    ```
3.  **Access:**
    - SSH into the bastion host: `gcloud compute ssh bastion --zone=asia-southeast2-a`
    - From the bastion, you can SSH into any MinIO node using its private IP.
4.  **Teardown:** To destroy all resources, run:
    ```bash
    make down
    ```

## Architecture

- **Network:** Custom VPC with a single private subnet. SSH access is restricted to the bastion host via firewall rules.
- **Bastion Host:** Publicly accessible VM used as a jump box.
- **MinIO Nodes:** 4 private VMs.
    - `minio-1`, `minio-2`: 100GB pd-standard disks.
    - `minio-3`, `minio-4`: 30GB pd-ssd disks.
- **Cloud NAT:** Allows private MinIO nodes to access the internet for updates and installation without being exposed to inbound traffic.
