include config.mk

export

.PHONY: up down network firewall bastion nodes nat cleanup

up: network firewall bastion nodes nat
	@echo "Infrastructure is up!"

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

cleanup:
	bash scripts/cleanup.sh
