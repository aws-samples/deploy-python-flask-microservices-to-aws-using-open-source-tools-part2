# private-rest-api
---

This solution uses Terraform to deliver a CodePipeline environment for a Python Flask API application on Amazon Elastic Container Service (ECS) using an Amazon Elastic Compute Cloud (EC2) launch type for the ECS service task definition.  The solution loads the codebase to AWS CodeCommit, leverages AWS CodeBuild to create the Docker image for the container, and uses AWS CodeDeploy to launch the ECS service and manage the solution deployment.    

# Motivation
---

Data has become the language of business. Organizations leverage data to better understand and deliver value to their Customers. As a result, there is a growing need in many Organizations for flexible patterns that can be leveraged to develop new applications and functionality to interact with their data. APIs, or Application Program Interfaces, are a utility which can help to enable organizations to continuously deliver customer value. API’s have grown in popularity as organizations have been increasingly designing their applications as microservices. The microservice model configures an application as a suite of small services. Each service runs its own processes and is independently deployable. API’s work in conjunction with microservices as they can be leveraged to connect services together, provide a programmable interface for developers to access data, and provide connectivity to existing legacy systems. 

# AWS Services Used
---

Let’s review the AWS services we are deploying with this project.

*CloudWatch* - [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) (Amazon CloudWatch) is a monitoring and observability service built for DevOps engineers, developers, site reliability engineers (SREs), and IT managers to provide data and actionable insights to monitor your applications, respond to system-wide performance changes, optimize resource utilization, and get a unified view of operational health.

*CodeBuild* - [AWS CodeBuild](https://aws.amazon.com/codebuild/) (AWS CodeBuild) is a fully managed continuous integration service that compiles source code, runs tests, and produces software packages that are ready to deploy.

*CodeCommit* - [AWS CodeCommit](https://aws.amazon.com/codecommit/) (AWS CodeCommit) is a secure, highly scalable, managed source control service that hosts private Git repositories.

*CodeDeploy* - [AWS CodeDeploy](https://aws.amazon.com/codedeploy/) (AWS CodeDeploy) is a fully managed deployment service that automates software deployments to a variety of compute service such as Amazon EC2, AWS Fargate, AWS Lambda, and your on-premises servers.

*CodePipeline* - [AWS CodePipeline](https://aws.amazon.com/codepipeline/) (AWS CodePipeline) is a fully managed continuous delivery service that helps you automate your release pipelines for fast and reliable application and infrastructure updates.

*Elastic Compute Cloud* - [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2/) (Amazon EC2) offers the broadest and deepest compute platform, with over 500 instances and choice of the latest processor, storage, networking, operating system, and purchase model to help you best match the needs of your workload.

*Elastic Container Registry* - [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/) (Amazon ECR) is a fully managed container registry offering high-performance hosting, so you can reliably deploy application images and artifacts anywhere.

*Elastic Container Service* - [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/ecs/) (Amazon ECS) is a fully managed container orchestration service that helps you easily deploy, manage, and scale containerized applications.

*Simple Storage Service* - [Amazon Simple Storage Service (S3)](https://aws.amazon.com/s3/) (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance.

*Virtual Private Cloud* - [Amazon Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/) (Amazon VPC) gives you full control over your virtual networking environment, including resource placement, connectivity, and security.


## Dependencies
---

This solution has dependencies or requirements in order to successfully deliver the desired state.  These dependencies include the following:

- An AWS account is required
- An execution role or IAM key is required for authentication with the AWS account

## Summary
---

This pattern is designed to provide a comprehensive deployment solution for ECS on EC2 using CodePipeline for blue green deployments including the following component configurations:

- Cloudwatch - alert metrics defined
- CodeBuild - the Docker container image is prepared and staged to ECR using CodeBuild
- CodeCommit - the GitHub repository code is copied and pushed to CodeCommit for use by CodePipeline
- CodeDeploy - deploys the containerized application prepared using CodeBuild
- CodePipeline - manages the software lifecycle by pulling from CodeCommit, building with CodeBuild, and deploying with CodeDeploy for a comprehensive CI/CD solution
- Elastic Compute Cloud - provides the resources, launch configuration, autoscaling group configuration for ECS, and the application autoscaling configuration for the ECS service
- Elastic Container Registry - provides a registry for application containers for use by ECS
- Elastic Container Service - provides an ECS cluster for use by CodeDeploy as a blue green deployment target
- Simple Storage Service - provides an object based storage bucket for use by CodePipeline to maintain the state of build artifacts used by the pipeline
- Virtual Private Cloud - provides networking, security, and connectivity for underlying infrastructure resources used to deliver the service


**Please read the rest of this document prior to leveraging this template for delivery.**

## Usage

### To update MakeFile
Run command
```shell
make
```

### Check if Terraform is installed
Run command
```shell
make local
```

### To setup and preview resources with Terraform

Terraform *plan* is used to create an execution plan.  Because Terraform is an orchestration tool used to automate resource delivery in various environments, a Terraform plan action is provided to allow administrators the ability to review the expected changes to an environment.  Terraform plan will show which resources are being added, changed, or destroyed based on the provided variable inputs passed to the modules during execution.  Terraform plan is an ideal instrument for change control processes, audit trails, and general administrative awareness of environment changes.

Run command
```shell
make plan
```

### To deploy the infrastructure

Terraform *apply* is the command used to change a desired target state for an environment.  Apply will prompt for changes made to an environment prior to deployment.  The response for this action may be automated using a switch at the time of execution.  The *deploy-infra* command performs this action.

Run command
```shell
make deploy-infra
```

### To delete all resource with Terraform

Terraform *destroy* is the command used to destroy an environment based on the information in the state file.

Run command
```shell
make destroy
```

### To delete local build artifacts including Terraform files and CodeCommit temporary folders

After running a build and testing the solution, you may want to clean up residual elements deployed as part of the solution.  The *clean* command performs this action by removing the Terraform build files and CodeCommit temporary folders.

Run command
```shell
make clean
```

### Configure a CodeCommit repository for the project
> This command creates the CodeCommit **private** repository. 
Run command
```shell
make configure-repo
```

### Clone the CodeCommit repository for the project
> This command clones the CodeCommit **private** repository. 
Run command
```shell
make clone
```

### Uploads the initial application code to invoke a build in the CodePipeline 
> This command pushes local repo code into the CodeCommit **private** respository. 
Run command
```shell
make upload-codecommit
```

### Uploads the updated application code to invoke a build in the CodePipeline 
> This command pushes local repo code into the CodeCommit **private** respository. 
Run command
```shell
make update-flask-app
```

### Security
---

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

### License
---

This library is licensed under the MIT-0 License. See the [LICENSE](LICENSE) file.