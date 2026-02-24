# MinIO Distributed Cluster on GCP (Reproducible with Makefile + gcloud)

## Goal

Create a fully reproducible MinIO distributed lab environment on Google Cloud Platform using:

- gcloud CLI
- Makefile as orchestrator
- Bash scripts for atomic infra components
- No manual UI clicking
- Single entrypoint: `make up`
- Full teardown: `make down`

---

## Target Architecture

### Network
- VPC: `minio-lab`
- Subnet: `10.10.0.0/24`
- Region: `asia-southeast2`
- Zone: `asia-southeast2-a`

### Instances

| Name      | Machine Type     | External IP | Disk Type      | Disk Size |
|-----------|------------------|------------|---------------|----------|
| bastion   | e2-micro         | Yes        | default       | 30GB     |
| minio-1   | e2-standard-2    | No         | pd-standard   | 100GB    |
| minio-2   | e2-standard-2    | No         | pd-standard   | 100GB    |
| minio-3   | e2-standard-2    | No         | pd-ssd        | 30GB     |
| minio-4   | e2-standard-2    | No         | pd-ssd        | 30GB     |

Notes:
- Only bastion has external IP.
- All MinIO nodes are private.
- Outbound internet via Cloud NAT.

---

## Networking Components

1. Custom VPC
2. Custom Subnet
3. Firewall rules:
   - Allow internal traffic within 10.10.0.0/24
   - Allow SSH (22) to bastion
4. Cloud Router
5. Cloud NAT (auto allocate public IP)
   - Applies to all subnet ranges

---

## Project Structure
minio-gcp-lab/
├── Makefile
├── config.mk
├── scripts/
│ ├── network.sh
│ ├── firewall.sh
│ ├── bastion.sh
│ ├── minio-nodes.sh
│ ├── nat.sh
│ ├── bootstrap.sh # (future extension)
│ └── cleanup.sh
└── README.md

---

## Configuration File (config.mk)

Contains:

- PROJECT_ID
- REGION
- ZONE
- NETWORK
- SUBNET
- BASTION
- MINIO_STANDARD_NODES
- MINIO_SSD_NODES

All scripts read variables from here.

---

## Makefile Responsibilities

Targets:

- `make up` → creates full infrastructure
- `make down` → destroys full infrastructure
- `make network`
- `make firewall`
- `make bastion`
- `make nodes`
- `make nat`
- `make bootstrap` (future extension)

Makefile should:

- Export variables from config.mk
- Call each script in correct order
- Be idempotent-friendly

---

## Scripts Responsibilities

### network.sh
- Create custom VPC
- Create subnet (10.10.0.0/24)

### firewall.sh
- Allow internal TCP/UDP/ICMP within subnet
- Allow SSH to bastion

### bastion.sh
- Create bastion VM
- External IP enabled
- Ubuntu 22.04

### minio-nodes.sh
- Create minio-1 and minio-2:
  - 100GB
  - pd-standard
  - No external IP
- Create minio-3 and minio-4:
  - 30GB
  - pd-ssd
  - No external IP

### nat.sh
- Create Cloud Router
- Create Cloud NAT
  - Auto allocate public IP
  - NAT all subnet ranges

### cleanup.sh
Delete in order:
1. Instances
2. NAT
3. Router
4. Firewall rules
5. Subnet
6. VPC

Must run with `--quiet` to avoid prompts.

---

## Deployment Flow

1. Set project:
gcloud config set project <PROJECT_ID>
gcloud config set compute/region asia-southeast2
gcloud config set compute/zone asia-southeast2-a

2. Deploy:
make up

3. Destroy:
make down

---

## Access Model

- SSH into bastion (external IP)
- From bastion → SSH into minio nodes (private IP)
- MinIO nodes reach internet via Cloud NAT
- No inbound internet exposure to MinIO nodes

---

## Architectural Properties

- Private subnet pattern
- Bastion host pattern
- Cloud NAT outbound model
- Mixed disk performance cluster
- Distributed system capacity constrained by smallest node (30GB)

---

## Future Extensions

1. `bootstrap.sh`
- Install Docker automatically
- Start distributed MinIO cluster

2. Add:
- Nginx load balancer
- TLS
- Health checks
- Benchmark scripts

3. Convert to Terraform module

---

## Learning Outcomes

This project demonstrates:

- VPC networking
- Cloud NAT routing vs firewall distinction
- Bastion architecture
- Disk type trade-offs (pd-standard vs pd-ssd)
- Distributed storage constraints
- Reproducible infra design
- CLI-first cloud engineering workflow

---

## Important Notes

- MinIO distributed usable capacity limited by smallest disk (30GB nodes).
- Disk type cannot be detected inside VM (GCP abstracts backend).
- NAT required for private VMs to access internet.
- Firewall rules do NOT enable internet routing.

---

## Success Criteria

After deployment:

- Bastion has external IP
- MinIO nodes have no external IP
- MinIO nodes can `curl google.com`
- Instances visible in GCP
- Infrastructure reproducible via `make up`
