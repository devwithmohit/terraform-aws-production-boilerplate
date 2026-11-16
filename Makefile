.DEFAULT_GOAL := help

# Directories containing Terraform configurations
ROOT_DIRS := bootstrap environments/dev environments/prod examples/complete-infrastructure
MODULE_DIRS := modules/vpc modules/ec2 modules/s3-bucket modules/cloudfront-s3
ALL_TF_DIRS := $(ROOT_DIRS) $(MODULE_DIRS)

# Shell configuration
SHELL := /bin/bash

.PHONY: help
help: ## Display this help message
	@echo "========================================================================"
	@echo "Terraform AWS Setup - Developer Helper Makefile"
	@echo "========================================================================"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: fmt
fmt: ## Rewrites all Terraform files to canonical format
	@echo "==> Formatting all Terraform configuration files..."
	@terraform fmt -recursive

.PHONY: fmt-check
fmt-check: ## Checks if Terraform files are formatted properly
	@echo "==> Checking Terraform formatting..."
	@terraform fmt -check -diff -recursive

.PHONY: validate
validate: ## Initializes and validates syntax for all root and example configurations
	@echo "==> Initializing and validating root stacks..."
	@for dir in $(ROOT_DIRS); do \
		echo "--> Validating $$dir..."; \
		(cd $$dir && terraform init -backend=false -reconfigure > /dev/null && terraform validate) || exit 1; \
	done
	@echo "==> All configurations successfully validated!"

.PHONY: lint
lint: ## Runs tflint across all reusable modules
	@echo "==> Running tflint across modules..."
	@tflint --init --config=.tflint.hcl
	@for dir in $(MODULE_DIRS); do \
		echo "--> Linting $$dir..."; \
		tflint --chdir=$$dir --config=../../.tflint.hcl || exit 1; \
	done
	@echo "==> All modules passed lint checks!"

.PHONY: security-scan
security-scan: ## Runs checkov security and compliance analysis
	@echo "==> Running Checkov security scanning..."
	@checkov -d . --framework terraform --compact --soft-fail

.PHONY: docs
docs: ## Generates module documentation using terraform-docs
	@echo "==> Generating Terraform documentation..."
	@for dir in $(MODULE_DIRS) $(ROOT_DIRS); do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "--> Generating docs for $$dir..."; \
			terraform-docs markdown table --config .terraform-docs.yml $$dir > $$dir/README.md; \
		fi \
	done
	@echo "==> Documentation generation completed!"

.PHONY: test
test: ## Runs Terratest Go integration testing suite
	@echo "==> Running Terratest suite..."
	@cd tests && go test -v -timeout 30m

.PHONY: pre-commit
pre-commit: ## Runs pre-commit hooks against all files
	@echo "==> Running pre-commit hooks..."
	@pre-commit run --all-files

.PHONY: clean
clean: ## Removes local .terraform directories, state backups, and plan artifacts
	@echo "==> Cleaning local Terraform caches and artifacts..."
	@find . -type d -name ".terraform" -prune -exec rm -rf {} +
	@find . -type f -name ".terraform.lock.hcl" -delete
	@find . -type f -name "*.tfstate" -delete
	@find . -type f -name "*.tfstate.*" -delete
	@find . -type f -name "*.tfplan" -delete
	@find . -type f -name "tfplan" -delete
	@find . -type f -name "crash.log" -delete
	@find . -type f -name "terraform-debug.log" -delete
	@echo "==> Workspace cleaned successfully!"
