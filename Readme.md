# Blockchain API Client

A simple Go-based blockchain API client using the Gin framework. The application queries the block number and block by number from the Polygon-RPC API.

## Features

- RESTful API with two endpoints:
  - `/block/number`: returns the current block number
  - `/block/:number`: returns a block by its number
- [spf13/viper](https://github.com/spf13/viper) used for providing config using yml file
- Dockerized application for easy deployment
- Terraform configurations for deploying to AWS ECS Fargate

## Behaviour

1. Pushing to the "main" branch will trigger the Github Action which will build image and then push it back ghcr-repo.

2. Images pushed with digest as a tag and rewrites the latest one.

3. Current terraform usess "latest" tag by default, but this could be changed by setting variable "appImage" in "terraform.tfvars"-file

## Getting Started

### Prerequisites

- [Go](https://golang.org/dl/) (1.20 or higher)
- [Docker](https://www.docker.com/products/docker-desktop)
- [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli) (1.2.6 or higher)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with configured IAM credentials to avoid using it in terraform config files

### Running the Application

NOTE: since viper-library used for providing config environment variables will be consumed from config.yml file, but might be owwerrided by env variables.

1. Build and run the Go application:

```bash
$ go build
$ ./blockchain-api-client
```


2. Access the API endpoints at `http://localhost:8080/block/number` and `http://localhost:8080/block/:number`.

### Dockerizing the Application

1. Build the Docker image:

```bash
$ docker build -t blockchain-api-client .
```


2. Run a Docker container with the built image:

```bash
$ docker run -p 8080:8080 -e APP_HOST=0.0.0.0 -e APP_PORT=8080 -e POLYGON_URL="https://polygon-rpc.com/" blockchain-api-client
```


### Deploying to AWS ECS Fargate

1. Navigate to the `terraform` folder:


2. Initialize Terraform:


```bash
$ terraform init
```


3. Apply the Terraform configuration:

```bash
$ terraform apply
```

4. Get app dns link from terraform output and try to access it from browser, like this:

```
http://<link-provided-by-output>/block/number
```

## Things that migh be improved:


1. Using terraform workspaces to generate differrent environments for dev/stage/production

2. Providing ecs-cluster by external terraforn for just consumig itsremote state from the current one and deploy only image, service, lb without providing vpc and cluster itself.

3. Using S3 or Terraform Cloud remote state to avoid human mistakes and simplify managing through remote state.

4. Provide SSL-certificate using AWS-issuer with Cloudfront and Route53 dns records and Hosted Zones instead of using defauld http lb.

5. Imporove Action-pipeline for creating a tagged image if git tags used instead of branches.