SHELL := /bin/bash

PROJECT ?= lab-platform
TF_DIR := infra/terraform
HELM_DIR := apps/helm

.PHONY: help
help:
	@echo "Targets:"
	@echo "  fmt-terraform        - terraform fmt across repo"
	@echo "  validate-terraform   - terraform validate for each env"
	@echo "  lint-terraform       - tflint recursive (requires tflint installed)"
	@echo "  plan-dev             - terraform plan dev"
	@echo "  apply-dev            - terraform apply dev"
	@echo "  plan-staging         - terraform plan staging"
	@echo "  apply-staging        - terraform apply staging"
	@echo "  plan-prod            - terraform plan prod"
	@echo "  apply-prod           - terraform apply prod"
	@echo "  helm-lint            - helm lint charts"
	@echo "  helm-template-dev    - render manifests for dev"
	@echo "  helm-template-staging- render manifests for staging"
	@echo "  helm-template-prod   - render manifests for prod"

.PHONY: fmt-terraform
fmt-terraform:
	terraform fmt -recursive $(TF_DIR)

.PHONY: validate-terraform
validate-terraform:
	@for env in dev staging prod; do \
		echo "==> Validating $$env"; \
		cd $(TF_DIR)/envs/$$env && terraform init -backend=false >/dev/null; \
		cd $(TF_DIR)/envs/$$env && terraform validate; \
	done

.PHONY: lint-terraform
lint-terraform:
	tflint --recursive $(TF_DIR)

# The plan/apply targets will work after Step 2 when backends are configured.
.PHONY: plan-dev
plan-dev:
	cd $(TF_DIR)/envs/dev && terraform init && terraform plan

.PHONY: apply-dev
apply-dev:
	cd $(TF_DIR)/envs/dev && terraform init && terraform apply

.PHONY: plan-staging
plan-staging:
	cd $(TF_DIR)/envs/staging && terraform init && terraform plan

.PHONY: apply-staging
apply-staging:
	cd $(TF_DIR)/envs/staging && terraform init && terraform apply

.PHONY: plan-prod
plan-prod:
	cd $(TF_DIR)/envs/prod && terraform init && terraform plan

.PHONY: apply-prod
apply-prod:
	cd $(TF_DIR)/envs/prod && terraform init && terraform apply

.PHONY: helm-lint
helm-lint:
	helm lint $(HELM_DIR)/charts/*

.PHONY: helm-template-dev
helm-template-dev:
	helm template myapp $(HELM_DIR)/charts/myapp -f $(HELM_DIR)/envs/dev/values.yaml --namespace dev

.PHONY: helm-template-staging
helm-template-staging:
	helm template myapp $(HELM_DIR)/charts/myapp -f $(HELM_DIR)/envs/staging/values.yaml --namespace staging

.PHONY: helm-template-prod
helm-template-prod:
	helm template myapp $(HELM_DIR)/charts/myapp -f $(HELM_DIR)/envs/prod/values.yaml --namespace prod

.PHONY: addons-dev addons-staging addons-prod

addons-dev:
	@echo "Installing add-ons for dev (namespaces, ALB, metrics-server, fluent-bit, argo-rollouts)"

addons-staging:
	@echo "Installing add-ons for staging (namespaces, ALB, metrics-server, fluent-bit, argo-rollouts)"

addons-prod:
	@echo "Installing add-ons for prod (namespaces, ALB, metrics-server, fluent-bit, argo-rollouts)"

.PHONY: observability-dev observability-staging observability-prod

observability-dev:
	@echo "Installing Prometheus and Grafana for dev"

observability-staging:
	@echo "Installing Prometheus and Grafana for staging"

observability-prod:
	@echo "Installing Prometheus and Grafana for prod"
