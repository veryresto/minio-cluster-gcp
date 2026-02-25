include config.mk

export

.PHONY: up down network firewall bastion nodes nat bootstrap cleanup tunnel

up: network firewall bastion nodes nat bootstrap
	@echo "Infrastructure is up and bootstrapped!"

down: cleanup
	@echo "Infrastructure is down!"

network:
	bash scripts/network.sh

firewall:
	bash scripts/firewall.sh

bastion:
	bash scripts/bastion.sh

nodes:
	bash scripts/minio-nodes.sh

nat:
	bash scripts/nat.sh

bootstrap:
	bash scripts/bootstrap.sh

cleanup:
	bash scripts/cleanup.sh

tunnel:
	@echo "Creating direct SSH tunnel to minio-1:9001 via IAP..."
	@echo "Access the WebUI at http://localhost:9001"
	gcloud compute ssh minio-1 --zone=$(ZONE) --tunnel-through-iap -- -L 9001:localhost:9001
