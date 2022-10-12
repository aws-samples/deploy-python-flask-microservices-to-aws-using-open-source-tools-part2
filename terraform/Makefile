# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

SHELL := /usr/bin/env bash

# COLORS
RED=$(shell echo -e "\033[0;31m")
GRE=$(shell echo -e "\033[0;32m")
NC=$(shell echo -e "\033[0m")

# TERRAFORM INSTALL
version  ?= "1.0.10"
os       ?= $(shell uname|tr A-Z a-z)
ifeq ($(shell uname -m),x86_64)
  arch   ?= "amd64"
endif
ifeq ($(shell uname -m),i686)
  arch   ?= "386"
endif
ifeq ($(shell uname -m),aarch64)
  arch   ?= "arm"
endif

# CHECK TERRAFORM VERSION
TERRAFORM := $(shell command -v terraform 2> /dev/null)
USER_HOME_DIRECTORY := $(HOME)
DEMO_BUILD_DIRECTORY := deploy-python-flask-microservices-to-aws-using-open-source-tools-part2
CODE_COMMIT_DIRECTORY := FlaskDemoRepo
BRANCH := main
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query "Account" --output text)
REGION := $(shell aws configure get region)
UPLOAD_CODE := demo-code.tar.gz
CHECK_CODECOMMIT_REPO := $(shell aws codecommit list-repositories \
			 		--query 'repositories[*].repositoryName' \
					--region $(REGION) \
					--output text)
CREATE_CODECOMMIT_REPO := $(shell aws codecommit create-repository \
			  		--repository-name FlaskDemoRepo-$(AWS_ACCOUNT_ID) \
					--repository-description "Flask demo application repo." \
					--region $(REGION) \
					--tags Owner=AWS)
CODECOMMIT_CLONE_URL := $(shell aws codecommit get-repository \
					--repository-name FlaskDemoRepo-$(AWS_ACCOUNT_ID) \
					--region $(REGION) \
					--query repositoryMetadata.cloneUrlHttp)
TERRAFORM_VERSION := $(shell terraform --version 2> /dev/null)
CODECOMMIT_REPO := $(shell aws codecommit list-repositories \
					--query repositories[*].repositoryName \
					--output text)
GITHUB_REPO := deploy-python-flask-microservices-to-aws-using-open-source-tools-part2
GITHUB_REPO_TERRAFORM_DIR := deploy-python-flask-microservices-to-aws-using-open-source-tools-part2/terraform


all: local plan configure-repo upload-codecommit deploy-infra update-infra update-flask-app destroy clean
	@echo "$(GRE) INFO: Applying all options"

.PHONY: plan configure-repo upload-codecommit deploy-infra update-infra update-flask-app destroy clean
local:
	@terraform --version
ifdef TERRAFORM
	@echo "$(GRE) INFO: The local Terraform version is $(TERRAFORM_VERSION)"
else
	@echo "$(RED) ERROR: Terraform is not installed"
endif

clean:
	@echo "$(RED) INFO: Removing local build artifacts."
	@rm -rf .terraform* terraform.tfs*
	@rm -rf FlaskDemoRepo-$(AWS_ACCOUNT_ID)
	@echo "$(RED) INFO: Deleting CodeCommit repository."
	@aws codecommit delete-repository --repository-name FlaskDemoRepo-$(AWS_ACCOUNT_ID)

plan:
	@echo "$(GRE) INFO: Initialize the working directory and planning."
	@terraform init -reconfigure && \
	terraform fmt && \
	terraform validate && \
	terraform import aws_codecommit_repository.flask_demo_repo FlaskDemoRepo-$(AWS_ACCOUNT_ID) && \
	terraform plan
	terraform state rm aws_codecommit_repository.flask_demo_repo

deploy-infra:
	@echo "$(GRE) INFO: Deploying Terraform resources."
	@terraform init -reconfigure && \
	terraform validate && \
	terraform import aws_codecommit_repository.flask_demo_repo FlaskDemoRepo-$(AWS_ACCOUNT_ID) && \
	terraform apply -auto-approve

update-infra:
	@echo "$(GRE) INFO: Updating Terraform resources."
	@terraform init -reconfigure && \
        terraform validate && \
        terraform apply -auto-approve

destroy:
	@echo "$(RED) INFO: Removing all Terraform created resources"
	@terraform init -reconfigure && \
	terraform validate && \
	terraform destroy -auto-approve

configure-repo:
ifeq (,$(findstring FlaskDemoRepo-$(AWS_ACCOUNT_ID),$(CHECK_CODECOMMIT_REPO)))
	@echo "$(GRE) INFO: Creating CodeCommit repository." \ 
	@echo "$(NC) $(CREATE_CODECOMMIT_REPO)"
else
	@echo "$(GRE) INFO: CodeCommit repository exists.  Skipping repository creation." 
endif
	@echo "$(GRE) INFO: The CodeCommit HTTP clone URL is $(CODECOMMIT_CLONE_URL)"

clone: 
	@echo "$(GRE) INFO: Cloning the CodeCommit repository for the CodeCommit" && \
	git clone $(CODECOMMIT_CLONE_URL)

upload-codecommit:
	cd $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID) && \
	git checkout -b $(BRANCH) && \
	cd $(USER_HOME_DIRECTORY)/$(DEMO_BUILD_DIRECTORY) && \
	tar czf $(UPLOAD_CODE) app Dockerfile appspec.yaml buildspec.yml && \
	tar -tvf $(UPLOAD_CODE) && \
	mv $(USER_HOME_DIRECTORY)/$(DEMO_BUILD_DIRECTORY)/$(UPLOAD_CODE) $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID) && \
        cd $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID) && \
	tar -xvf $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID)/$(UPLOAD_CODE) && \
        rm $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID)/$(UPLOAD_CODE) && \
	git add . && \
	git commit -m "Configuring repo." && \
	git push -u origin $(BRANCH)

update-flask-app:
	cd $(USER_HOME_DIRECTORY)/$(GITHUB_REPO_TERRAFORM_DIR)/$(CODE_COMMIT_DIRECTORY)-$(AWS_ACCOUNT_ID) && \
	git add . && \
	git commit -m "Updating Flask base path to Hello Updated World." && \
	git push
