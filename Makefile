SHELL=/bin/bash
INVENTORY_FILE=ansible/inventory.ini
ANSIBLE_CFG=ansible/ansible.cfg

tf-init:
	terraform -chdir=terraform init

tf-plan:
	terraform -chdir=terraform plan

tf-apply:
	terraform -chdir=terraform apply

tf-destroy:
	terraform -chdir=terraform destroy

inventory:
	@IP=$$(terraform -chdir=terraform output -raw public_ip 2>/dev/null); \
	if [[ -z "$$IP" ]]; then \
		echo "ERROR: public_ip output is empty."; \
		exit 1; \
	fi; \
	echo "[web]" > $(INVENTORY_FILE); \
	echo "$$IP" >> $(INVENTORY_FILE)

ping:
	ANSIBLE_CONFIG=$(ANSIBLE_CFG) ansible web -m ping

bootstrap:
	ANSIBLE_CONFIG=$(ANSIBLE_CFG) ansible-playbook ansible/playbooks/ws.yml

all: tf-init tf-apply inventory bootstrap

.PHONY: tf-init tf-plan tf-apply tf-destroy inventory ping bootstrap all
